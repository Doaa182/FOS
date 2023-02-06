
obj/user/tst_free_3:     file format elf32-i386


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
  800031:	e8 1d 14 00 00       	call   801453 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

#define numOfAccessesFor3MB 7
#define numOfAccessesFor8MB 4
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 7c 01 00 00    	sub    $0x17c,%esp



	int Mega = 1024*1024;
  800044:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)
	int kilo = 1024;
  80004b:	c7 45 d0 00 04 00 00 	movl   $0x400,-0x30(%ebp)
	char minByte = 1<<7;
  800052:	c6 45 cf 80          	movb   $0x80,-0x31(%ebp)
	char maxByte = 0x7F;
  800056:	c6 45 ce 7f          	movb   $0x7f,-0x32(%ebp)
	short minShort = 1<<15 ;
  80005a:	66 c7 45 cc 00 80    	movw   $0x8000,-0x34(%ebp)
	short maxShort = 0x7FFF;
  800060:	66 c7 45 ca ff 7f    	movw   $0x7fff,-0x36(%ebp)
	int minInt = 1<<31 ;
  800066:	c7 45 c4 00 00 00 80 	movl   $0x80000000,-0x3c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006d:	c7 45 c0 ff ff ff 7f 	movl   $0x7fffffff,-0x40(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	6a 00                	push   $0x0
  800079:	e8 3e 27 00 00       	call   8027bc <malloc>
  80007e:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80008c:	8b 00                	mov    (%eax),%eax
  80008e:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800091:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800099:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80009e:	74 14                	je     8000b4 <_main+0x7c>
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 20 45 80 00       	push   $0x804520
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 61 45 80 00       	push   $0x804561
  8000af:	e8 db 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000b9:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000bf:	83 c0 18             	add    $0x18,%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8000c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8000ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000cf:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 20 45 80 00       	push   $0x804520
  8000de:	6a 21                	push   $0x21
  8000e0:	68 61 45 80 00       	push   $0x804561
  8000e5:	e8 a5 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ef:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000f5:	83 c0 30             	add    $0x30,%eax
  8000f8:	8b 00                	mov    (%eax),%eax
  8000fa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8000fd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800100:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800105:	3d 00 20 20 00       	cmp    $0x202000,%eax
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 20 45 80 00       	push   $0x804520
  800114:	6a 22                	push   $0x22
  800116:	68 61 45 80 00       	push   $0x804561
  80011b:	e8 6f 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800120:	a1 20 50 80 00       	mov    0x805020,%eax
  800125:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80012b:	83 c0 48             	add    $0x48,%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800133:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800136:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80013b:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 20 45 80 00       	push   $0x804520
  80014a:	6a 23                	push   $0x23
  80014c:	68 61 45 80 00       	push   $0x804561
  800151:	e8 39 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800156:	a1 20 50 80 00       	mov    0x805020,%eax
  80015b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800161:	83 c0 60             	add    $0x60,%eax
  800164:	8b 00                	mov    (%eax),%eax
  800166:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800169:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80016c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800171:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800176:	74 14                	je     80018c <_main+0x154>
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	68 20 45 80 00       	push   $0x804520
  800180:	6a 24                	push   $0x24
  800182:	68 61 45 80 00       	push   $0x804561
  800187:	e8 03 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80018c:	a1 20 50 80 00       	mov    0x805020,%eax
  800191:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800197:	83 c0 78             	add    $0x78,%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80019f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a7:	3d 00 50 20 00       	cmp    $0x205000,%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 20 45 80 00       	push   $0x804520
  8001b6:	6a 25                	push   $0x25
  8001b8:	68 61 45 80 00       	push   $0x804561
  8001bd:	e8 cd 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c7:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001cd:	05 90 00 00 00       	add    $0x90,%eax
  8001d2:	8b 00                	mov    (%eax),%eax
  8001d4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8001d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8001da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001df:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001e4:	74 14                	je     8001fa <_main+0x1c2>
  8001e6:	83 ec 04             	sub    $0x4,%esp
  8001e9:	68 20 45 80 00       	push   $0x804520
  8001ee:	6a 26                	push   $0x26
  8001f0:	68 61 45 80 00       	push   $0x804561
  8001f5:	e8 95 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001fa:	a1 20 50 80 00       	mov    0x805020,%eax
  8001ff:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800205:	05 a8 00 00 00       	add    $0xa8,%eax
  80020a:	8b 00                	mov    (%eax),%eax
  80020c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80020f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800212:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800217:	3d 00 10 80 00       	cmp    $0x801000,%eax
  80021c:	74 14                	je     800232 <_main+0x1fa>
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 20 45 80 00       	push   $0x804520
  800226:	6a 27                	push   $0x27
  800228:	68 61 45 80 00       	push   $0x804561
  80022d:	e8 5d 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800232:	a1 20 50 80 00       	mov    0x805020,%eax
  800237:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80023d:	05 c0 00 00 00       	add    $0xc0,%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800247:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80024a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024f:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 20 45 80 00       	push   $0x804520
  80025e:	6a 28                	push   $0x28
  800260:	68 61 45 80 00       	push   $0x804561
  800265:	e8 25 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80026a:	a1 20 50 80 00       	mov    0x805020,%eax
  80026f:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800275:	05 d8 00 00 00       	add    $0xd8,%eax
  80027a:	8b 00                	mov    (%eax),%eax
  80027c:	89 45 98             	mov    %eax,-0x68(%ebp)
  80027f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800282:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800287:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 20 45 80 00       	push   $0x804520
  800296:	6a 29                	push   $0x29
  800298:	68 61 45 80 00       	push   $0x804561
  80029d:	e8 ed 12 00 00       	call   80158f <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a7:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 74 45 80 00       	push   $0x804574
  8002b9:	6a 2a                	push   $0x2a
  8002bb:	68 61 45 80 00       	push   $0x804561
  8002c0:	e8 ca 12 00 00       	call   80158f <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 31 29 00 00       	call   802bfb <sys_calculate_free_frames>
  8002ca:	89 45 94             	mov    %eax,-0x6c(%ebp)

	int indicesOf3MB[numOfAccessesFor3MB];
	int indicesOf8MB[numOfAccessesFor8MB];
	int var, i, j;

	void* ptr_allocations[20] = {0};
  8002cd:	8d 95 80 fe ff ff    	lea    -0x180(%ebp),%edx
  8002d3:	b9 14 00 00 00       	mov    $0x14,%ecx
  8002d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dd:	89 d7                	mov    %edx,%edi
  8002df:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		/*ALLOCATE 2 MB*/
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002e1:	e8 b5 29 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  8002e6:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8002e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ec:	01 c0                	add    %eax,%eax
  8002ee:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002f1:	83 ec 0c             	sub    $0xc,%esp
  8002f4:	50                   	push   %eax
  8002f5:	e8 c2 24 00 00       	call   8027bc <malloc>
  8002fa:	83 c4 10             	add    $0x10,%esp
  8002fd:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800303:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800309:	85 c0                	test   %eax,%eax
  80030b:	79 0d                	jns    80031a <_main+0x2e2>
  80030d:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800313:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800318:	76 14                	jbe    80032e <_main+0x2f6>
  80031a:	83 ec 04             	sub    $0x4,%esp
  80031d:	68 bc 45 80 00       	push   $0x8045bc
  800322:	6a 39                	push   $0x39
  800324:	68 61 45 80 00       	push   $0x804561
  800329:	e8 61 12 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032e:	e8 68 29 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  800333:	2b 45 90             	sub    -0x70(%ebp),%eax
  800336:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 24 46 80 00       	push   $0x804624
  800345:	6a 3a                	push   $0x3a
  800347:	68 61 45 80 00       	push   $0x804561
  80034c:	e8 3e 12 00 00       	call   80158f <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 45 29 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  800356:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800359:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035c:	89 c2                	mov    %eax,%edx
  80035e:	01 d2                	add    %edx,%edx
  800360:	01 d0                	add    %edx,%eax
  800362:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800365:	83 ec 0c             	sub    $0xc,%esp
  800368:	50                   	push   %eax
  800369:	e8 4e 24 00 00       	call   8027bc <malloc>
  80036e:	83 c4 10             	add    $0x10,%esp
  800371:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800377:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80037d:	89 c2                	mov    %eax,%edx
  80037f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	05 00 00 00 80       	add    $0x80000000,%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	72 16                	jb     8003a3 <_main+0x36b>
  80038d:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800393:	89 c2                	mov    %eax,%edx
  800395:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800398:	01 c0                	add    %eax,%eax
  80039a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80039f:	39 c2                	cmp    %eax,%edx
  8003a1:	76 14                	jbe    8003b7 <_main+0x37f>
  8003a3:	83 ec 04             	sub    $0x4,%esp
  8003a6:	68 bc 45 80 00       	push   $0x8045bc
  8003ab:	6a 40                	push   $0x40
  8003ad:	68 61 45 80 00       	push   $0x804561
  8003b2:	e8 d8 11 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b7:	e8 df 28 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  8003bc:	2b 45 90             	sub    -0x70(%ebp),%eax
  8003bf:	89 c2                	mov    %eax,%edx
  8003c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c4:	89 c1                	mov    %eax,%ecx
  8003c6:	01 c9                	add    %ecx,%ecx
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	79 05                	jns    8003d3 <_main+0x39b>
  8003ce:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003d3:	c1 f8 0c             	sar    $0xc,%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 24 46 80 00       	push   $0x804624
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 61 45 80 00       	push   $0x804561
  8003e9:	e8 a1 11 00 00       	call   80158f <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ee:	e8 a8 28 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  8003f3:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(8*Mega-kilo);
  8003f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003f9:	c1 e0 03             	shl    $0x3,%eax
  8003fc:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8003ff:	83 ec 0c             	sub    $0xc,%esp
  800402:	50                   	push   %eax
  800403:	e8 b4 23 00 00       	call   8027bc <malloc>
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 5*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 5*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800411:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800417:	89 c1                	mov    %eax,%ecx
  800419:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	c1 e0 02             	shl    $0x2,%eax
  800421:	01 d0                	add    %edx,%eax
  800423:	05 00 00 00 80       	add    $0x80000000,%eax
  800428:	39 c1                	cmp    %eax,%ecx
  80042a:	72 1b                	jb     800447 <_main+0x40f>
  80042c:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800432:	89 c1                	mov    %eax,%ecx
  800434:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800437:	89 d0                	mov    %edx,%eax
  800439:	c1 e0 02             	shl    $0x2,%eax
  80043c:	01 d0                	add    %edx,%eax
  80043e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800443:	39 c1                	cmp    %eax,%ecx
  800445:	76 14                	jbe    80045b <_main+0x423>
  800447:	83 ec 04             	sub    $0x4,%esp
  80044a:	68 bc 45 80 00       	push   $0x8045bc
  80044f:	6a 47                	push   $0x47
  800451:	68 61 45 80 00       	push   $0x804561
  800456:	e8 34 11 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045b:	e8 3b 28 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  800460:	2b 45 90             	sub    -0x70(%ebp),%eax
  800463:	89 c2                	mov    %eax,%edx
  800465:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800468:	c1 e0 03             	shl    $0x3,%eax
  80046b:	85 c0                	test   %eax,%eax
  80046d:	79 05                	jns    800474 <_main+0x43c>
  80046f:	05 ff 0f 00 00       	add    $0xfff,%eax
  800474:	c1 f8 0c             	sar    $0xc,%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <_main+0x457>
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 24 46 80 00       	push   $0x804624
  800483:	6a 48                	push   $0x48
  800485:	68 61 45 80 00       	push   $0x804561
  80048a:	e8 00 11 00 00       	call   80158f <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 07 28 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  800494:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(7*Mega-kilo);
  800497:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80049a:	89 d0                	mov    %edx,%eax
  80049c:	01 c0                	add    %eax,%eax
  80049e:	01 d0                	add    %edx,%eax
  8004a0:	01 c0                	add    %eax,%eax
  8004a2:	01 d0                	add    %edx,%eax
  8004a4:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8004a7:	83 ec 0c             	sub    $0xc,%esp
  8004aa:	50                   	push   %eax
  8004ab:	e8 0c 23 00 00       	call   8027bc <malloc>
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 13*Mega) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 13*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8004b9:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8004bf:	89 c1                	mov    %eax,%ecx
  8004c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004c4:	89 d0                	mov    %edx,%eax
  8004c6:	01 c0                	add    %eax,%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	c1 e0 02             	shl    $0x2,%eax
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	05 00 00 00 80       	add    $0x80000000,%eax
  8004d4:	39 c1                	cmp    %eax,%ecx
  8004d6:	72 1f                	jb     8004f7 <_main+0x4bf>
  8004d8:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8004de:	89 c1                	mov    %eax,%ecx
  8004e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004e3:	89 d0                	mov    %edx,%eax
  8004e5:	01 c0                	add    %eax,%eax
  8004e7:	01 d0                	add    %edx,%eax
  8004e9:	c1 e0 02             	shl    $0x2,%eax
  8004ec:	01 d0                	add    %edx,%eax
  8004ee:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8004f3:	39 c1                	cmp    %eax,%ecx
  8004f5:	76 14                	jbe    80050b <_main+0x4d3>
  8004f7:	83 ec 04             	sub    $0x4,%esp
  8004fa:	68 bc 45 80 00       	push   $0x8045bc
  8004ff:	6a 4e                	push   $0x4e
  800501:	68 61 45 80 00       	push   $0x804561
  800506:	e8 84 10 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050b:	e8 8b 27 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  800510:	2b 45 90             	sub    -0x70(%ebp),%eax
  800513:	89 c1                	mov    %eax,%ecx
  800515:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	01 c0                	add    %eax,%eax
  800520:	01 d0                	add    %edx,%eax
  800522:	85 c0                	test   %eax,%eax
  800524:	79 05                	jns    80052b <_main+0x4f3>
  800526:	05 ff 0f 00 00       	add    $0xfff,%eax
  80052b:	c1 f8 0c             	sar    $0xc,%eax
  80052e:	39 c1                	cmp    %eax,%ecx
  800530:	74 14                	je     800546 <_main+0x50e>
  800532:	83 ec 04             	sub    $0x4,%esp
  800535:	68 24 46 80 00       	push   $0x804624
  80053a:	6a 4f                	push   $0x4f
  80053c:	68 61 45 80 00       	push   $0x804561
  800541:	e8 49 10 00 00       	call   80158f <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800546:	e8 b0 26 00 00       	call   802bfb <sys_calculate_free_frames>
  80054b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054e:	e8 c1 26 00 00       	call   802c14 <sys_calculate_modified_frames>
  800553:	89 45 88             	mov    %eax,-0x78(%ebp)
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
  800556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800559:	89 c2                	mov    %eax,%edx
  80055b:	01 d2                	add    %edx,%edx
  80055d:	01 d0                	add    %edx,%eax
  80055f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800562:	48                   	dec    %eax
  800563:	89 45 84             	mov    %eax,-0x7c(%ebp)
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
  800566:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800569:	bf 07 00 00 00       	mov    $0x7,%edi
  80056e:	99                   	cltd   
  80056f:	f7 ff                	idiv   %edi
  800571:	89 45 80             	mov    %eax,-0x80(%ebp)
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  800574:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80057b:	eb 16                	jmp    800593 <_main+0x55b>
		{
			indicesOf3MB[var] = var * inc ;
  80057d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800580:	0f af 45 80          	imul   -0x80(%ebp),%eax
  800584:	89 c2                	mov    %eax,%edx
  800586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800589:	89 94 85 e0 fe ff ff 	mov    %edx,-0x120(%ebp,%eax,4)
		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
		int modFrames = sys_calculate_modified_frames();
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  800590:	ff 45 e4             	incl   -0x1c(%ebp)
  800593:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800597:	7e e4                	jle    80057d <_main+0x545>
		{
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
  800599:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80059f:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		//3 reads
		int sum = 0;
  8005a5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005ac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005b3:	eb 1f                	jmp    8005d4 <_main+0x59c>
		{
			sum += byteArr[indicesOf3MB[var]] ;
  8005b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005b8:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8005bf:	89 c2                	mov    %eax,%edx
  8005c1:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005c7:	01 d0                	add    %edx,%eax
  8005c9:	8a 00                	mov    (%eax),%al
  8005cb:	0f be c0             	movsbl %al,%eax
  8005ce:	01 45 dc             	add    %eax,-0x24(%ebp)
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
		//3 reads
		int sum = 0;
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005d1:	ff 45 e4             	incl   -0x1c(%ebp)
  8005d4:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  8005d8:	7e db                	jle    8005b5 <_main+0x57d>
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  8005da:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  8005e1:	eb 1c                	jmp    8005ff <_main+0x5c7>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
  8005e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005e6:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8005ed:	89 c2                	mov    %eax,%edx
  8005ef:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f5:	01 c2                	add    %eax,%edx
  8005f7:	8a 45 ce             	mov    -0x32(%ebp),%al
  8005fa:	88 02                	mov    %al,(%edx)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  8005fc:	ff 45 e4             	incl   -0x1c(%ebp)
  8005ff:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800603:	7e de                	jle    8005e3 <_main+0x5ab>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800605:	8b 55 8c             	mov    -0x74(%ebp),%edx
  800608:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	89 c6                	mov    %eax,%esi
  80060f:	e8 e7 25 00 00       	call   802bfb <sys_calculate_free_frames>
  800614:	89 c3                	mov    %eax,%ebx
  800616:	e8 f9 25 00 00       	call   802c14 <sys_calculate_modified_frames>
  80061b:	01 d8                	add    %ebx,%eax
  80061d:	29 c6                	sub    %eax,%esi
  80061f:	89 f0                	mov    %esi,%eax
  800621:	83 f8 02             	cmp    $0x2,%eax
  800624:	74 14                	je     80063a <_main+0x602>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 54 46 80 00       	push   $0x804654
  80062e:	6a 67                	push   $0x67
  800630:	68 61 45 80 00       	push   $0x804561
  800635:	e8 55 0f 00 00       	call   80158f <_panic>
		int found = 0;
  80063a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  800641:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800648:	eb 78                	jmp    8006c2 <_main+0x68a>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80064a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800651:	eb 5d                	jmp    8006b0 <_main+0x678>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  800653:	a1 20 50 80 00       	mov    0x805020,%eax
  800658:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80065e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800661:	89 d0                	mov    %edx,%eax
  800663:	01 c0                	add    %eax,%eax
  800665:	01 d0                	add    %edx,%eax
  800667:	c1 e0 03             	shl    $0x3,%eax
  80066a:	01 c8                	add    %ecx,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800674:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80067a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80067f:	89 c2                	mov    %eax,%edx
  800681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800684:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  80068b:	89 c1                	mov    %eax,%ecx
  80068d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800693:	01 c8                	add    %ecx,%eax
  800695:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  80069b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	75 03                	jne    8006ad <_main+0x675>
				{
					found++;
  8006aa:	ff 45 d8             	incl   -0x28(%ebp)
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8006ad:	ff 45 e0             	incl   -0x20(%ebp)
  8006b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b5:	8b 50 74             	mov    0x74(%eax),%edx
  8006b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006bb:	39 c2                	cmp    %eax,%edx
  8006bd:	77 94                	ja     800653 <_main+0x61b>
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  8006bf:	ff 45 e4             	incl   -0x1c(%ebp)
  8006c2:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8006c6:	7e 82                	jle    80064a <_main+0x612>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor3MB) panic("malloc: page is not added to WS");
  8006c8:	83 7d d8 07          	cmpl   $0x7,-0x28(%ebp)
  8006cc:	74 14                	je     8006e2 <_main+0x6aa>
  8006ce:	83 ec 04             	sub    $0x4,%esp
  8006d1:	68 98 46 80 00       	push   $0x804698
  8006d6:	6a 73                	push   $0x73
  8006d8:	68 61 45 80 00       	push   $0x804561
  8006dd:	e8 ad 0e 00 00       	call   80158f <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e2:	e8 14 25 00 00       	call   802bfb <sys_calculate_free_frames>
  8006e7:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006ea:	e8 25 25 00 00       	call   802c14 <sys_calculate_modified_frames>
  8006ef:	89 45 88             	mov    %eax,-0x78(%ebp)
		lastIndexOfShort = (8*Mega-kilo)/sizeof(short) - 1;
  8006f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f5:	c1 e0 03             	shl    $0x3,%eax
  8006f8:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8006fb:	d1 e8                	shr    %eax
  8006fd:	48                   	dec    %eax
  8006fe:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		indicesOf8MB[0] = lastIndexOfShort * 1 / 2;
  800704:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80070a:	89 c2                	mov    %eax,%edx
  80070c:	c1 ea 1f             	shr    $0x1f,%edx
  80070f:	01 d0                	add    %edx,%eax
  800711:	d1 f8                	sar    %eax
  800713:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
		indicesOf8MB[1] = lastIndexOfShort * 2 / 3;
  800719:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80071f:	01 c0                	add    %eax,%eax
  800721:	89 c1                	mov    %eax,%ecx
  800723:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800728:	f7 e9                	imul   %ecx
  80072a:	c1 f9 1f             	sar    $0x1f,%ecx
  80072d:	89 d0                	mov    %edx,%eax
  80072f:	29 c8                	sub    %ecx,%eax
  800731:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
		indicesOf8MB[2] = lastIndexOfShort * 3 / 4;
  800737:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80073d:	89 c2                	mov    %eax,%edx
  80073f:	01 d2                	add    %edx,%edx
  800741:	01 d0                	add    %edx,%eax
  800743:	85 c0                	test   %eax,%eax
  800745:	79 03                	jns    80074a <_main+0x712>
  800747:	83 c0 03             	add    $0x3,%eax
  80074a:	c1 f8 02             	sar    $0x2,%eax
  80074d:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
		indicesOf8MB[3] = lastIndexOfShort ;
  800753:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800759:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)

		//use one of the read pages from 3 MB to avoid victimizing it
		sum += byteArr[indicesOf3MB[0]] ;
  80075f:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800765:	89 c2                	mov    %eax,%edx
  800767:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80076d:	01 d0                	add    %edx,%eax
  80076f:	8a 00                	mov    (%eax),%al
  800771:	0f be c0             	movsbl %al,%eax
  800774:	01 45 dc             	add    %eax,-0x24(%ebp)

		shortArr = (short *) ptr_allocations[2];
  800777:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  80077d:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		//2 reads
		sum = 0;
  800783:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  80078a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800791:	eb 20                	jmp    8007b3 <_main+0x77b>
		{
			sum += shortArr[indicesOf8MB[var]] ;
  800793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800796:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  80079d:	01 c0                	add    %eax,%eax
  80079f:	89 c2                	mov    %eax,%edx
  8007a1:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007a7:	01 d0                	add    %edx,%eax
  8007a9:	66 8b 00             	mov    (%eax),%ax
  8007ac:	98                   	cwtl   
  8007ad:	01 45 dc             	add    %eax,-0x24(%ebp)
		sum += byteArr[indicesOf3MB[0]] ;

		shortArr = (short *) ptr_allocations[2];
		//2 reads
		sum = 0;
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  8007b0:	ff 45 e4             	incl   -0x1c(%ebp)
  8007b3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8007b7:	7e da                	jle    800793 <_main+0x75b>
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007b9:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  8007c0:	eb 20                	jmp    8007e2 <_main+0x7aa>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
  8007c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007c5:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  8007cc:	01 c0                	add    %eax,%eax
  8007ce:	89 c2                	mov    %eax,%edx
  8007d0:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007d6:	01 c2                	add    %eax,%edx
  8007d8:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  8007dc:	66 89 02             	mov    %ax,(%edx)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007df:	ff 45 e4             	incl   -0x1c(%ebp)
  8007e2:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8007e6:	7e da                	jle    8007c2 <_main+0x78a>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007e8:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8007eb:	e8 0b 24 00 00       	call   802bfb <sys_calculate_free_frames>
  8007f0:	29 c3                	sub    %eax,%ebx
  8007f2:	89 d8                	mov    %ebx,%eax
  8007f4:	83 f8 04             	cmp    $0x4,%eax
  8007f7:	74 17                	je     800810 <_main+0x7d8>
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 54 46 80 00       	push   $0x804654
  800801:	68 8e 00 00 00       	push   $0x8e
  800806:	68 61 45 80 00       	push   $0x804561
  80080b:	e8 7f 0d 00 00       	call   80158f <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800810:	8b 5d 88             	mov    -0x78(%ebp),%ebx
  800813:	e8 fc 23 00 00       	call   802c14 <sys_calculate_modified_frames>
  800818:	29 c3                	sub    %eax,%ebx
  80081a:	89 d8                	mov    %ebx,%eax
  80081c:	83 f8 fe             	cmp    $0xfffffffe,%eax
  80081f:	74 17                	je     800838 <_main+0x800>
  800821:	83 ec 04             	sub    $0x4,%esp
  800824:	68 54 46 80 00       	push   $0x804654
  800829:	68 8f 00 00 00       	push   $0x8f
  80082e:	68 61 45 80 00       	push   $0x804561
  800833:	e8 57 0d 00 00       	call   80158f <_panic>
		found = 0;
  800838:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  80083f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800846:	eb 7a                	jmp    8008c2 <_main+0x88a>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  800848:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80084f:	eb 5f                	jmp    8008b0 <_main+0x878>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[indicesOf8MB[var]])), PAGE_SIZE))
  800851:	a1 20 50 80 00       	mov    0x805020,%eax
  800856:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80085c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80085f:	89 d0                	mov    %edx,%eax
  800861:	01 c0                	add    %eax,%eax
  800863:	01 d0                	add    %edx,%eax
  800865:	c1 e0 03             	shl    $0x3,%eax
  800868:	01 c8                	add    %ecx,%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800872:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800878:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087d:	89 c2                	mov    %eax,%edx
  80087f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800882:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  800889:	01 c0                	add    %eax,%eax
  80088b:	89 c1                	mov    %eax,%ecx
  80088d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800893:	01 c8                	add    %ecx,%eax
  800895:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80089b:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8008a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	75 03                	jne    8008ad <_main+0x875>
				{
					found++;
  8008aa:	ff 45 d8             	incl   -0x28(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8008ad:	ff 45 e0             	incl   -0x20(%ebp)
  8008b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8008b5:	8b 50 74             	mov    0x74(%eax),%edx
  8008b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008bb:	39 c2                	cmp    %eax,%edx
  8008bd:	77 92                	ja     800851 <_main+0x819>
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  8008bf:	ff 45 e4             	incl   -0x1c(%ebp)
  8008c2:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8008c6:	7e 80                	jle    800848 <_main+0x810>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor8MB) panic("malloc: page is not added to WS");
  8008c8:	83 7d d8 04          	cmpl   $0x4,-0x28(%ebp)
  8008cc:	74 17                	je     8008e5 <_main+0x8ad>
  8008ce:	83 ec 04             	sub    $0x4,%esp
  8008d1:	68 98 46 80 00       	push   $0x804698
  8008d6:	68 9b 00 00 00       	push   $0x9b
  8008db:	68 61 45 80 00       	push   $0x804561
  8008e0:	e8 aa 0c 00 00       	call   80158f <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008e5:	e8 11 23 00 00       	call   802bfb <sys_calculate_free_frames>
  8008ea:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008ed:	e8 22 23 00 00       	call   802c14 <sys_calculate_modified_frames>
  8008f2:	89 45 88             	mov    %eax,-0x78(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008f5:	e8 a1 23 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  8008fa:	89 45 90             	mov    %eax,-0x70(%ebp)

		free(ptr_allocations[1]);
  8008fd:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800903:	83 ec 0c             	sub    $0xc,%esp
  800906:	50                   	push   %eax
  800907:	e8 47 1f 00 00       	call   802853 <free>
  80090c:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80090f:	e8 87 23 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  800914:	8b 55 90             	mov    -0x70(%ebp),%edx
  800917:	89 d1                	mov    %edx,%ecx
  800919:	29 c1                	sub    %eax,%ecx
  80091b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80091e:	89 c2                	mov    %eax,%edx
  800920:	01 d2                	add    %edx,%edx
  800922:	01 d0                	add    %edx,%eax
  800924:	85 c0                	test   %eax,%eax
  800926:	79 05                	jns    80092d <_main+0x8f5>
  800928:	05 ff 0f 00 00       	add    $0xfff,%eax
  80092d:	c1 f8 0c             	sar    $0xc,%eax
  800930:	39 c1                	cmp    %eax,%ecx
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 b8 46 80 00       	push   $0x8046b8
  80093c:	68 a5 00 00 00       	push   $0xa5
  800941:	68 61 45 80 00       	push   $0x804561
  800946:	e8 44 0c 00 00       	call   80158f <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  80094b:	e8 ab 22 00 00       	call   802bfb <sys_calculate_free_frames>
  800950:	89 c2                	mov    %eax,%edx
  800952:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800955:	29 c2                	sub    %eax,%edx
  800957:	89 d0                	mov    %edx,%eax
  800959:	83 f8 07             	cmp    $0x7,%eax
  80095c:	74 17                	je     800975 <_main+0x93d>
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	68 f4 46 80 00       	push   $0x8046f4
  800966:	68 a7 00 00 00       	push   $0xa7
  80096b:	68 61 45 80 00       	push   $0x804561
  800970:	e8 1a 0c 00 00       	call   80158f <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800975:	e8 9a 22 00 00       	call   802c14 <sys_calculate_modified_frames>
  80097a:	89 c2                	mov    %eax,%edx
  80097c:	8b 45 88             	mov    -0x78(%ebp),%eax
  80097f:	29 c2                	sub    %eax,%edx
  800981:	89 d0                	mov    %edx,%eax
  800983:	83 f8 02             	cmp    $0x2,%eax
  800986:	74 17                	je     80099f <_main+0x967>
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 48 47 80 00       	push   $0x804748
  800990:	68 a8 00 00 00       	push   $0xa8
  800995:	68 61 45 80 00       	push   $0x804561
  80099a:	e8 f0 0b 00 00       	call   80158f <_panic>
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  80099f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8009a6:	e9 8c 00 00 00       	jmp    800a37 <_main+0x9ff>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8009ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009b2:	eb 71                	jmp    800a25 <_main+0x9ed>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  8009b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8009b9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c2:	89 d0                	mov    %edx,%eax
  8009c4:	01 c0                	add    %eax,%eax
  8009c6:	01 d0                	add    %edx,%eax
  8009c8:	c1 e0 03             	shl    $0x3,%eax
  8009cb:	01 c8                	add    %ecx,%eax
  8009cd:	8b 00                	mov    (%eax),%eax
  8009cf:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  8009d5:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8009db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009e0:	89 c2                	mov    %eax,%edx
  8009e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009e5:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8009ec:	89 c1                	mov    %eax,%ecx
  8009ee:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8009f4:	01 c8                	add    %ecx,%eax
  8009f6:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  8009fc:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a07:	39 c2                	cmp    %eax,%edx
  800a09:	75 17                	jne    800a22 <_main+0x9ea>
				{
					panic("free: page is not removed from WS");
  800a0b:	83 ec 04             	sub    $0x4,%esp
  800a0e:	68 80 47 80 00       	push   $0x804780
  800a13:	68 b0 00 00 00       	push   $0xb0
  800a18:	68 61 45 80 00       	push   $0x804561
  800a1d:	e8 6d 0b 00 00       	call   80158f <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  800a22:	ff 45 e0             	incl   -0x20(%ebp)
  800a25:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2a:	8b 50 74             	mov    0x74(%eax),%edx
  800a2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a30:	39 c2                	cmp    %eax,%edx
  800a32:	77 80                	ja     8009b4 <_main+0x97c>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  800a34:	ff 45 e4             	incl   -0x1c(%ebp)
  800a37:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800a3b:	0f 8e 6a ff ff ff    	jle    8009ab <_main+0x973>
			}
		}



		freeFrames = sys_calculate_free_frames() ;
  800a41:	e8 b5 21 00 00       	call   802bfb <sys_calculate_free_frames>
  800a46:	89 45 8c             	mov    %eax,-0x74(%ebp)
		shortArr = (short *) ptr_allocations[2];
  800a49:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800a4f:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800a55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a58:	01 c0                	add    %eax,%eax
  800a5a:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800a5d:	d1 e8                	shr    %eax
  800a5f:	48                   	dec    %eax
  800a60:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		shortArr[0] = minShort;
  800a66:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  800a6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a6f:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800a72:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800a78:	01 c0                	add    %eax,%eax
  800a7a:	89 c2                	mov    %eax,%edx
  800a7c:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a82:	01 c2                	add    %eax,%edx
  800a84:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  800a88:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a8b:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  800a8e:	e8 68 21 00 00       	call   802bfb <sys_calculate_free_frames>
  800a93:	29 c3                	sub    %eax,%ebx
  800a95:	89 d8                	mov    %ebx,%eax
  800a97:	83 f8 02             	cmp    $0x2,%eax
  800a9a:	74 17                	je     800ab3 <_main+0xa7b>
  800a9c:	83 ec 04             	sub    $0x4,%esp
  800a9f:	68 54 46 80 00       	push   $0x804654
  800aa4:	68 bc 00 00 00       	push   $0xbc
  800aa9:	68 61 45 80 00       	push   $0x804561
  800aae:	e8 dc 0a 00 00       	call   80158f <_panic>
		found = 0;
  800ab3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800aba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ac1:	e9 a7 00 00 00       	jmp    800b6d <_main+0xb35>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800ac6:	a1 20 50 80 00       	mov    0x805020,%eax
  800acb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ad4:	89 d0                	mov    %edx,%eax
  800ad6:	01 c0                	add    %eax,%eax
  800ad8:	01 d0                	add    %edx,%eax
  800ada:	c1 e0 03             	shl    $0x3,%eax
  800add:	01 c8                	add    %ecx,%eax
  800adf:	8b 00                	mov    (%eax),%eax
  800ae1:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800ae7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800aed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af2:	89 c2                	mov    %eax,%edx
  800af4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800afa:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b00:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	75 03                	jne    800b12 <_main+0xada>
				found++;
  800b0f:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  800b12:	a1 20 50 80 00       	mov    0x805020,%eax
  800b17:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b20:	89 d0                	mov    %edx,%eax
  800b22:	01 c0                	add    %eax,%eax
  800b24:	01 d0                	add    %edx,%eax
  800b26:	c1 e0 03             	shl    $0x3,%eax
  800b29:	01 c8                	add    %ecx,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b33:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b3e:	89 c2                	mov    %eax,%edx
  800b40:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800b46:	01 c0                	add    %eax,%eax
  800b48:	89 c1                	mov    %eax,%ecx
  800b4a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b50:	01 c8                	add    %ecx,%eax
  800b52:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b58:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b63:	39 c2                	cmp    %eax,%edx
  800b65:	75 03                	jne    800b6a <_main+0xb32>
				found++;
  800b67:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800b6a:	ff 45 e4             	incl   -0x1c(%ebp)
  800b6d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b72:	8b 50 74             	mov    0x74(%eax),%edx
  800b75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b78:	39 c2                	cmp    %eax,%edx
  800b7a:	0f 87 46 ff ff ff    	ja     800ac6 <_main+0xa8e>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800b80:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800b84:	74 17                	je     800b9d <_main+0xb65>
  800b86:	83 ec 04             	sub    $0x4,%esp
  800b89:	68 98 46 80 00       	push   $0x804698
  800b8e:	68 c5 00 00 00       	push   $0xc5
  800b93:	68 61 45 80 00       	push   $0x804561
  800b98:	e8 f2 09 00 00       	call   80158f <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b9d:	e8 f9 20 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  800ba2:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800ba5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ba8:	01 c0                	add    %eax,%eax
  800baa:	83 ec 0c             	sub    $0xc,%esp
  800bad:	50                   	push   %eax
  800bae:	e8 09 1c 00 00       	call   8027bc <malloc>
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800bbc:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800bc2:	89 c2                	mov    %eax,%edx
  800bc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bc7:	c1 e0 02             	shl    $0x2,%eax
  800bca:	05 00 00 00 80       	add    $0x80000000,%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	72 17                	jb     800bea <_main+0xbb2>
  800bd3:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800bd9:	89 c2                	mov    %eax,%edx
  800bdb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bde:	c1 e0 02             	shl    $0x2,%eax
  800be1:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800be6:	39 c2                	cmp    %eax,%edx
  800be8:	76 17                	jbe    800c01 <_main+0xbc9>
  800bea:	83 ec 04             	sub    $0x4,%esp
  800bed:	68 bc 45 80 00       	push   $0x8045bc
  800bf2:	68 ca 00 00 00       	push   $0xca
  800bf7:	68 61 45 80 00       	push   $0x804561
  800bfc:	e8 8e 09 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800c01:	e8 95 20 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  800c06:	2b 45 90             	sub    -0x70(%ebp),%eax
  800c09:	83 f8 01             	cmp    $0x1,%eax
  800c0c:	74 17                	je     800c25 <_main+0xbed>
  800c0e:	83 ec 04             	sub    $0x4,%esp
  800c11:	68 24 46 80 00       	push   $0x804624
  800c16:	68 cb 00 00 00       	push   $0xcb
  800c1b:	68 61 45 80 00       	push   $0x804561
  800c20:	e8 6a 09 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c25:	e8 d1 1f 00 00       	call   802bfb <sys_calculate_free_frames>
  800c2a:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr = (int *) ptr_allocations[2];
  800c2d:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800c33:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  800c39:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c3c:	01 c0                	add    %eax,%eax
  800c3e:	c1 e8 02             	shr    $0x2,%eax
  800c41:	48                   	dec    %eax
  800c42:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
		intArr[0] = minInt;
  800c48:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c4e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800c51:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  800c53:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800c59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c60:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c66:	01 c2                	add    %eax,%edx
  800c68:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6b:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800c6d:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  800c70:	e8 86 1f 00 00       	call   802bfb <sys_calculate_free_frames>
  800c75:	29 c3                	sub    %eax,%ebx
  800c77:	89 d8                	mov    %ebx,%eax
  800c79:	83 f8 02             	cmp    $0x2,%eax
  800c7c:	74 17                	je     800c95 <_main+0xc5d>
  800c7e:	83 ec 04             	sub    $0x4,%esp
  800c81:	68 54 46 80 00       	push   $0x804654
  800c86:	68 d2 00 00 00       	push   $0xd2
  800c8b:	68 61 45 80 00       	push   $0x804561
  800c90:	e8 fa 08 00 00       	call   80158f <_panic>
		found = 0;
  800c95:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800c9c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ca3:	e9 aa 00 00 00       	jmp    800d52 <_main+0xd1a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800ca8:	a1 20 50 80 00       	mov    0x805020,%eax
  800cad:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800cb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800cb6:	89 d0                	mov    %edx,%eax
  800cb8:	01 c0                	add    %eax,%eax
  800cba:	01 d0                	add    %edx,%eax
  800cbc:	c1 e0 03             	shl    $0x3,%eax
  800cbf:	01 c8                	add    %ecx,%eax
  800cc1:	8b 00                	mov    (%eax),%eax
  800cc3:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800cc9:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800ccf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800cd4:	89 c2                	mov    %eax,%edx
  800cd6:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800cdc:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800ce2:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800ce8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ced:	39 c2                	cmp    %eax,%edx
  800cef:	75 03                	jne    800cf4 <_main+0xcbc>
				found++;
  800cf1:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800cf4:	a1 20 50 80 00       	mov    0x805020,%eax
  800cf9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800cff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d02:	89 d0                	mov    %edx,%eax
  800d04:	01 c0                	add    %eax,%eax
  800d06:	01 d0                	add    %edx,%eax
  800d08:	c1 e0 03             	shl    $0x3,%eax
  800d0b:	01 c8                	add    %ecx,%eax
  800d0d:	8b 00                	mov    (%eax),%eax
  800d0f:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d15:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d20:	89 c2                	mov    %eax,%edx
  800d22:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800d28:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d2f:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800d35:	01 c8                	add    %ecx,%eax
  800d37:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d3d:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d48:	39 c2                	cmp    %eax,%edx
  800d4a:	75 03                	jne    800d4f <_main+0xd17>
				found++;
  800d4c:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d4f:	ff 45 e4             	incl   -0x1c(%ebp)
  800d52:	a1 20 50 80 00       	mov    0x805020,%eax
  800d57:	8b 50 74             	mov    0x74(%eax),%edx
  800d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d5d:	39 c2                	cmp    %eax,%edx
  800d5f:	0f 87 43 ff ff ff    	ja     800ca8 <_main+0xc70>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800d65:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800d69:	74 17                	je     800d82 <_main+0xd4a>
  800d6b:	83 ec 04             	sub    $0x4,%esp
  800d6e:	68 98 46 80 00       	push   $0x804698
  800d73:	68 db 00 00 00       	push   $0xdb
  800d78:	68 61 45 80 00       	push   $0x804561
  800d7d:	e8 0d 08 00 00       	call   80158f <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d82:	e8 74 1e 00 00       	call   802bfb <sys_calculate_free_frames>
  800d87:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d8a:	e8 0c 1f 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  800d8f:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800d92:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d95:	01 c0                	add    %eax,%eax
  800d97:	83 ec 0c             	sub    $0xc,%esp
  800d9a:	50                   	push   %eax
  800d9b:	e8 1c 1a 00 00       	call   8027bc <malloc>
  800da0:	83 c4 10             	add    $0x10,%esp
  800da3:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800da9:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800daf:	89 c2                	mov    %eax,%edx
  800db1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800db4:	c1 e0 02             	shl    $0x2,%eax
  800db7:	89 c1                	mov    %eax,%ecx
  800db9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800dbc:	c1 e0 02             	shl    $0x2,%eax
  800dbf:	01 c8                	add    %ecx,%eax
  800dc1:	05 00 00 00 80       	add    $0x80000000,%eax
  800dc6:	39 c2                	cmp    %eax,%edx
  800dc8:	72 21                	jb     800deb <_main+0xdb3>
  800dca:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800dd0:	89 c2                	mov    %eax,%edx
  800dd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dd5:	c1 e0 02             	shl    $0x2,%eax
  800dd8:	89 c1                	mov    %eax,%ecx
  800dda:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ddd:	c1 e0 02             	shl    $0x2,%eax
  800de0:	01 c8                	add    %ecx,%eax
  800de2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800de7:	39 c2                	cmp    %eax,%edx
  800de9:	76 17                	jbe    800e02 <_main+0xdca>
  800deb:	83 ec 04             	sub    $0x4,%esp
  800dee:	68 bc 45 80 00       	push   $0x8045bc
  800df3:	68 e1 00 00 00       	push   $0xe1
  800df8:	68 61 45 80 00       	push   $0x804561
  800dfd:	e8 8d 07 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800e02:	e8 94 1e 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  800e07:	2b 45 90             	sub    -0x70(%ebp),%eax
  800e0a:	83 f8 01             	cmp    $0x1,%eax
  800e0d:	74 17                	je     800e26 <_main+0xdee>
  800e0f:	83 ec 04             	sub    $0x4,%esp
  800e12:	68 24 46 80 00       	push   $0x804624
  800e17:	68 e2 00 00 00       	push   $0xe2
  800e1c:	68 61 45 80 00       	push   $0x804561
  800e21:	e8 69 07 00 00       	call   80158f <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e26:	e8 70 1e 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  800e2b:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800e2e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	01 c0                	add    %eax,%eax
  800e35:	01 d0                	add    %edx,%eax
  800e37:	01 c0                	add    %eax,%eax
  800e39:	01 d0                	add    %edx,%eax
  800e3b:	83 ec 0c             	sub    $0xc,%esp
  800e3e:	50                   	push   %eax
  800e3f:	e8 78 19 00 00       	call   8027bc <malloc>
  800e44:	83 c4 10             	add    $0x10,%esp
  800e47:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800e4d:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800e53:	89 c2                	mov    %eax,%edx
  800e55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e58:	c1 e0 02             	shl    $0x2,%eax
  800e5b:	89 c1                	mov    %eax,%ecx
  800e5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e60:	c1 e0 03             	shl    $0x3,%eax
  800e63:	01 c8                	add    %ecx,%eax
  800e65:	05 00 00 00 80       	add    $0x80000000,%eax
  800e6a:	39 c2                	cmp    %eax,%edx
  800e6c:	72 21                	jb     800e8f <_main+0xe57>
  800e6e:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800e74:	89 c2                	mov    %eax,%edx
  800e76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e79:	c1 e0 02             	shl    $0x2,%eax
  800e7c:	89 c1                	mov    %eax,%ecx
  800e7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e81:	c1 e0 03             	shl    $0x3,%eax
  800e84:	01 c8                	add    %ecx,%eax
  800e86:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800e8b:	39 c2                	cmp    %eax,%edx
  800e8d:	76 17                	jbe    800ea6 <_main+0xe6e>
  800e8f:	83 ec 04             	sub    $0x4,%esp
  800e92:	68 bc 45 80 00       	push   $0x8045bc
  800e97:	68 e8 00 00 00       	push   $0xe8
  800e9c:	68 61 45 80 00       	push   $0x804561
  800ea1:	e8 e9 06 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800ea6:	e8 f0 1d 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  800eab:	2b 45 90             	sub    -0x70(%ebp),%eax
  800eae:	83 f8 02             	cmp    $0x2,%eax
  800eb1:	74 17                	je     800eca <_main+0xe92>
  800eb3:	83 ec 04             	sub    $0x4,%esp
  800eb6:	68 24 46 80 00       	push   $0x804624
  800ebb:	68 e9 00 00 00       	push   $0xe9
  800ec0:	68 61 45 80 00       	push   $0x804561
  800ec5:	e8 c5 06 00 00       	call   80158f <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800eca:	e8 2c 1d 00 00       	call   802bfb <sys_calculate_free_frames>
  800ecf:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800ed2:	e8 c4 1d 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  800ed7:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800eda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800edd:	89 c2                	mov    %eax,%edx
  800edf:	01 d2                	add    %edx,%edx
  800ee1:	01 d0                	add    %edx,%eax
  800ee3:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800ee6:	83 ec 0c             	sub    $0xc,%esp
  800ee9:	50                   	push   %eax
  800eea:	e8 cd 18 00 00       	call   8027bc <malloc>
  800eef:	83 c4 10             	add    $0x10,%esp
  800ef2:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800ef8:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  800efe:	89 c2                	mov    %eax,%edx
  800f00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f03:	c1 e0 02             	shl    $0x2,%eax
  800f06:	89 c1                	mov    %eax,%ecx
  800f08:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f0b:	c1 e0 04             	shl    $0x4,%eax
  800f0e:	01 c8                	add    %ecx,%eax
  800f10:	05 00 00 00 80       	add    $0x80000000,%eax
  800f15:	39 c2                	cmp    %eax,%edx
  800f17:	72 21                	jb     800f3a <_main+0xf02>
  800f19:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  800f1f:	89 c2                	mov    %eax,%edx
  800f21:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f24:	c1 e0 02             	shl    $0x2,%eax
  800f27:	89 c1                	mov    %eax,%ecx
  800f29:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f2c:	c1 e0 04             	shl    $0x4,%eax
  800f2f:	01 c8                	add    %ecx,%eax
  800f31:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800f36:	39 c2                	cmp    %eax,%edx
  800f38:	76 17                	jbe    800f51 <_main+0xf19>
  800f3a:	83 ec 04             	sub    $0x4,%esp
  800f3d:	68 bc 45 80 00       	push   $0x8045bc
  800f42:	68 f0 00 00 00       	push   $0xf0
  800f47:	68 61 45 80 00       	push   $0x804561
  800f4c:	e8 3e 06 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f51:	e8 45 1d 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  800f56:	2b 45 90             	sub    -0x70(%ebp),%eax
  800f59:	89 c2                	mov    %eax,%edx
  800f5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f5e:	89 c1                	mov    %eax,%ecx
  800f60:	01 c9                	add    %ecx,%ecx
  800f62:	01 c8                	add    %ecx,%eax
  800f64:	85 c0                	test   %eax,%eax
  800f66:	79 05                	jns    800f6d <_main+0xf35>
  800f68:	05 ff 0f 00 00       	add    $0xfff,%eax
  800f6d:	c1 f8 0c             	sar    $0xc,%eax
  800f70:	39 c2                	cmp    %eax,%edx
  800f72:	74 17                	je     800f8b <_main+0xf53>
  800f74:	83 ec 04             	sub    $0x4,%esp
  800f77:	68 24 46 80 00       	push   $0x804624
  800f7c:	68 f1 00 00 00       	push   $0xf1
  800f81:	68 61 45 80 00       	push   $0x804561
  800f86:	e8 04 06 00 00       	call   80158f <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8b:	e8 0b 1d 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  800f90:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  800f93:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f96:	89 d0                	mov    %edx,%eax
  800f98:	01 c0                	add    %eax,%eax
  800f9a:	01 d0                	add    %edx,%eax
  800f9c:	01 c0                	add    %eax,%eax
  800f9e:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800fa1:	83 ec 0c             	sub    $0xc,%esp
  800fa4:	50                   	push   %eax
  800fa5:	e8 12 18 00 00       	call   8027bc <malloc>
  800faa:	83 c4 10             	add    $0x10,%esp
  800fad:	89 85 98 fe ff ff    	mov    %eax,-0x168(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800fb3:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  800fb9:	89 c1                	mov    %eax,%ecx
  800fbb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fbe:	89 d0                	mov    %edx,%eax
  800fc0:	01 c0                	add    %eax,%eax
  800fc2:	01 d0                	add    %edx,%eax
  800fc4:	01 c0                	add    %eax,%eax
  800fc6:	01 d0                	add    %edx,%eax
  800fc8:	89 c2                	mov    %eax,%edx
  800fca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fcd:	c1 e0 04             	shl    $0x4,%eax
  800fd0:	01 d0                	add    %edx,%eax
  800fd2:	05 00 00 00 80       	add    $0x80000000,%eax
  800fd7:	39 c1                	cmp    %eax,%ecx
  800fd9:	72 28                	jb     801003 <_main+0xfcb>
  800fdb:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  800fe1:	89 c1                	mov    %eax,%ecx
  800fe3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fe6:	89 d0                	mov    %edx,%eax
  800fe8:	01 c0                	add    %eax,%eax
  800fea:	01 d0                	add    %edx,%eax
  800fec:	01 c0                	add    %eax,%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	89 c2                	mov    %eax,%edx
  800ff2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ff5:	c1 e0 04             	shl    $0x4,%eax
  800ff8:	01 d0                	add    %edx,%eax
  800ffa:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800fff:	39 c1                	cmp    %eax,%ecx
  801001:	76 17                	jbe    80101a <_main+0xfe2>
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	68 bc 45 80 00       	push   $0x8045bc
  80100b:	68 f7 00 00 00       	push   $0xf7
  801010:	68 61 45 80 00       	push   $0x804561
  801015:	e8 75 05 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  80101a:	e8 7c 1c 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  80101f:	2b 45 90             	sub    -0x70(%ebp),%eax
  801022:	89 c1                	mov    %eax,%ecx
  801024:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801027:	89 d0                	mov    %edx,%eax
  801029:	01 c0                	add    %eax,%eax
  80102b:	01 d0                	add    %edx,%eax
  80102d:	01 c0                	add    %eax,%eax
  80102f:	85 c0                	test   %eax,%eax
  801031:	79 05                	jns    801038 <_main+0x1000>
  801033:	05 ff 0f 00 00       	add    $0xfff,%eax
  801038:	c1 f8 0c             	sar    $0xc,%eax
  80103b:	39 c1                	cmp    %eax,%ecx
  80103d:	74 17                	je     801056 <_main+0x101e>
  80103f:	83 ec 04             	sub    $0x4,%esp
  801042:	68 24 46 80 00       	push   $0x804624
  801047:	68 f8 00 00 00       	push   $0xf8
  80104c:	68 61 45 80 00       	push   $0x804561
  801051:	e8 39 05 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801056:	e8 a0 1b 00 00       	call   802bfb <sys_calculate_free_frames>
  80105b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  80105e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801061:	89 d0                	mov    %edx,%eax
  801063:	01 c0                	add    %eax,%eax
  801065:	01 d0                	add    %edx,%eax
  801067:	01 c0                	add    %eax,%eax
  801069:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80106c:	48                   	dec    %eax
  80106d:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  801073:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  801079:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
		byteArr2[0] = minByte ;
  80107f:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  801085:	8a 55 cf             	mov    -0x31(%ebp),%dl
  801088:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  80108a:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  801090:	89 c2                	mov    %eax,%edx
  801092:	c1 ea 1f             	shr    $0x1f,%edx
  801095:	01 d0                	add    %edx,%eax
  801097:	d1 f8                	sar    %eax
  801099:	89 c2                	mov    %eax,%edx
  80109b:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010a1:	01 c2                	add    %eax,%edx
  8010a3:	8a 45 ce             	mov    -0x32(%ebp),%al
  8010a6:	88 c1                	mov    %al,%cl
  8010a8:	c0 e9 07             	shr    $0x7,%cl
  8010ab:	01 c8                	add    %ecx,%eax
  8010ad:	d0 f8                	sar    %al
  8010af:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  8010b1:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  8010b7:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010bd:	01 c2                	add    %eax,%edx
  8010bf:	8a 45 ce             	mov    -0x32(%ebp),%al
  8010c2:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8010c4:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8010c7:	e8 2f 1b 00 00       	call   802bfb <sys_calculate_free_frames>
  8010cc:	29 c3                	sub    %eax,%ebx
  8010ce:	89 d8                	mov    %ebx,%eax
  8010d0:	83 f8 05             	cmp    $0x5,%eax
  8010d3:	74 17                	je     8010ec <_main+0x10b4>
  8010d5:	83 ec 04             	sub    $0x4,%esp
  8010d8:	68 54 46 80 00       	push   $0x804654
  8010dd:	68 00 01 00 00       	push   $0x100
  8010e2:	68 61 45 80 00       	push   $0x804561
  8010e7:	e8 a3 04 00 00       	call   80158f <_panic>
		found = 0;
  8010ec:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8010f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8010fa:	e9 02 01 00 00       	jmp    801201 <_main+0x11c9>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  8010ff:	a1 20 50 80 00       	mov    0x805020,%eax
  801104:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80110a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80110d:	89 d0                	mov    %edx,%eax
  80110f:	01 c0                	add    %eax,%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	c1 e0 03             	shl    $0x3,%eax
  801116:	01 c8                	add    %ecx,%eax
  801118:	8b 00                	mov    (%eax),%eax
  80111a:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  801120:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  801126:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80112b:	89 c2                	mov    %eax,%edx
  80112d:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  801133:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  801139:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80113f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801144:	39 c2                	cmp    %eax,%edx
  801146:	75 03                	jne    80114b <_main+0x1113>
				found++;
  801148:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  80114b:	a1 20 50 80 00       	mov    0x805020,%eax
  801150:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801156:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801159:	89 d0                	mov    %edx,%eax
  80115b:	01 c0                	add    %eax,%eax
  80115d:	01 d0                	add    %edx,%eax
  80115f:	c1 e0 03             	shl    $0x3,%eax
  801162:	01 c8                	add    %ecx,%eax
  801164:	8b 00                	mov    (%eax),%eax
  801166:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  80116c:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  801172:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801177:	89 c2                	mov    %eax,%edx
  801179:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  80117f:	89 c1                	mov    %eax,%ecx
  801181:	c1 e9 1f             	shr    $0x1f,%ecx
  801184:	01 c8                	add    %ecx,%eax
  801186:	d1 f8                	sar    %eax
  801188:	89 c1                	mov    %eax,%ecx
  80118a:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  801190:	01 c8                	add    %ecx,%eax
  801192:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  801198:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  80119e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011a3:	39 c2                	cmp    %eax,%edx
  8011a5:	75 03                	jne    8011aa <_main+0x1172>
				found++;
  8011a7:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  8011aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8011af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8011b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011b8:	89 d0                	mov    %edx,%eax
  8011ba:	01 c0                	add    %eax,%eax
  8011bc:	01 d0                	add    %edx,%eax
  8011be:	c1 e0 03             	shl    $0x3,%eax
  8011c1:	01 c8                	add    %ecx,%eax
  8011c3:	8b 00                	mov    (%eax),%eax
  8011c5:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  8011cb:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  8011d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011d6:	89 c1                	mov    %eax,%ecx
  8011d8:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  8011de:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  8011ec:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8011f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011f7:	39 c1                	cmp    %eax,%ecx
  8011f9:	75 03                	jne    8011fe <_main+0x11c6>
				found++;
  8011fb:	ff 45 d8             	incl   -0x28(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8011fe:	ff 45 e4             	incl   -0x1c(%ebp)
  801201:	a1 20 50 80 00       	mov    0x805020,%eax
  801206:	8b 50 74             	mov    0x74(%eax),%edx
  801209:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80120c:	39 c2                	cmp    %eax,%edx
  80120e:	0f 87 eb fe ff ff    	ja     8010ff <_main+0x10c7>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  801214:	83 7d d8 03          	cmpl   $0x3,-0x28(%ebp)
  801218:	74 17                	je     801231 <_main+0x11f9>
  80121a:	83 ec 04             	sub    $0x4,%esp
  80121d:	68 98 46 80 00       	push   $0x804698
  801222:	68 0b 01 00 00       	push   $0x10b
  801227:	68 61 45 80 00       	push   $0x804561
  80122c:	e8 5e 03 00 00       	call   80158f <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801231:	e8 65 1a 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  801236:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  801239:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80123c:	89 d0                	mov    %edx,%eax
  80123e:	01 c0                	add    %eax,%eax
  801240:	01 d0                	add    %edx,%eax
  801242:	01 c0                	add    %eax,%eax
  801244:	01 d0                	add    %edx,%eax
  801246:	01 c0                	add    %eax,%eax
  801248:	83 ec 0c             	sub    $0xc,%esp
  80124b:	50                   	push   %eax
  80124c:	e8 6b 15 00 00       	call   8027bc <malloc>
  801251:	83 c4 10             	add    $0x10,%esp
  801254:	89 85 9c fe ff ff    	mov    %eax,-0x164(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80125a:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  801260:	89 c1                	mov    %eax,%ecx
  801262:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801265:	89 d0                	mov    %edx,%eax
  801267:	01 c0                	add    %eax,%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	c1 e0 02             	shl    $0x2,%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	89 c2                	mov    %eax,%edx
  801272:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801275:	c1 e0 04             	shl    $0x4,%eax
  801278:	01 d0                	add    %edx,%eax
  80127a:	05 00 00 00 80       	add    $0x80000000,%eax
  80127f:	39 c1                	cmp    %eax,%ecx
  801281:	72 29                	jb     8012ac <_main+0x1274>
  801283:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  801289:	89 c1                	mov    %eax,%ecx
  80128b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80128e:	89 d0                	mov    %edx,%eax
  801290:	01 c0                	add    %eax,%eax
  801292:	01 d0                	add    %edx,%eax
  801294:	c1 e0 02             	shl    $0x2,%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	89 c2                	mov    %eax,%edx
  80129b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80129e:	c1 e0 04             	shl    $0x4,%eax
  8012a1:	01 d0                	add    %edx,%eax
  8012a3:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8012a8:	39 c1                	cmp    %eax,%ecx
  8012aa:	76 17                	jbe    8012c3 <_main+0x128b>
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 bc 45 80 00       	push   $0x8045bc
  8012b4:	68 10 01 00 00       	push   $0x110
  8012b9:	68 61 45 80 00       	push   $0x804561
  8012be:	e8 cc 02 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012c3:	e8 d3 19 00 00       	call   802c9b <sys_pf_calculate_allocated_pages>
  8012c8:	2b 45 90             	sub    -0x70(%ebp),%eax
  8012cb:	83 f8 04             	cmp    $0x4,%eax
  8012ce:	74 17                	je     8012e7 <_main+0x12af>
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	68 24 46 80 00       	push   $0x804624
  8012d8:	68 11 01 00 00       	push   $0x111
  8012dd:	68 61 45 80 00       	push   $0x804561
  8012e2:	e8 a8 02 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8012e7:	e8 0f 19 00 00       	call   802bfb <sys_calculate_free_frames>
  8012ec:	89 45 8c             	mov    %eax,-0x74(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  8012ef:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  8012f5:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  8012fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	01 c0                	add    %eax,%eax
  801302:	01 d0                	add    %edx,%eax
  801304:	01 c0                	add    %eax,%eax
  801306:	01 d0                	add    %edx,%eax
  801308:	01 c0                	add    %eax,%eax
  80130a:	d1 e8                	shr    %eax
  80130c:	48                   	dec    %eax
  80130d:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		shortArr2[0] = minShort;
  801313:	8b 95 10 ff ff ff    	mov    -0xf0(%ebp),%edx
  801319:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80131c:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  80131f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801325:	01 c0                	add    %eax,%eax
  801327:	89 c2                	mov    %eax,%edx
  801329:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  80132f:	01 c2                	add    %eax,%edx
  801331:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  801335:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  801338:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  80133b:	e8 bb 18 00 00       	call   802bfb <sys_calculate_free_frames>
  801340:	29 c3                	sub    %eax,%ebx
  801342:	89 d8                	mov    %ebx,%eax
  801344:	83 f8 02             	cmp    $0x2,%eax
  801347:	74 17                	je     801360 <_main+0x1328>
  801349:	83 ec 04             	sub    $0x4,%esp
  80134c:	68 54 46 80 00       	push   $0x804654
  801351:	68 18 01 00 00       	push   $0x118
  801356:	68 61 45 80 00       	push   $0x804561
  80135b:	e8 2f 02 00 00       	call   80158f <_panic>
		found = 0;
  801360:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801367:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80136e:	e9 a7 00 00 00       	jmp    80141a <_main+0x13e2>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  801373:	a1 20 50 80 00       	mov    0x805020,%eax
  801378:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80137e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801381:	89 d0                	mov    %edx,%eax
  801383:	01 c0                	add    %eax,%eax
  801385:	01 d0                	add    %edx,%eax
  801387:	c1 e0 03             	shl    $0x3,%eax
  80138a:	01 c8                	add    %ecx,%eax
  80138c:	8b 00                	mov    (%eax),%eax
  80138e:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  801394:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80139a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80139f:	89 c2                	mov    %eax,%edx
  8013a1:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8013a7:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  8013ad:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  8013b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b8:	39 c2                	cmp    %eax,%edx
  8013ba:	75 03                	jne    8013bf <_main+0x1387>
				found++;
  8013bc:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  8013bf:	a1 20 50 80 00       	mov    0x805020,%eax
  8013c4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8013ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013cd:	89 d0                	mov    %edx,%eax
  8013cf:	01 c0                	add    %eax,%eax
  8013d1:	01 d0                	add    %edx,%eax
  8013d3:	c1 e0 03             	shl    $0x3,%eax
  8013d6:	01 c8                	add    %ecx,%eax
  8013d8:	8b 00                	mov    (%eax),%eax
  8013da:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  8013e0:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  8013e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013eb:	89 c2                	mov    %eax,%edx
  8013ed:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  8013f3:	01 c0                	add    %eax,%eax
  8013f5:	89 c1                	mov    %eax,%ecx
  8013f7:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8013fd:	01 c8                	add    %ecx,%eax
  8013ff:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  801405:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  80140b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801410:	39 c2                	cmp    %eax,%edx
  801412:	75 03                	jne    801417 <_main+0x13df>
				found++;
  801414:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801417:	ff 45 e4             	incl   -0x1c(%ebp)
  80141a:	a1 20 50 80 00       	mov    0x805020,%eax
  80141f:	8b 50 74             	mov    0x74(%eax),%edx
  801422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801425:	39 c2                	cmp    %eax,%edx
  801427:	0f 87 46 ff ff ff    	ja     801373 <_main+0x133b>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80142d:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  801431:	74 17                	je     80144a <_main+0x1412>
  801433:	83 ec 04             	sub    $0x4,%esp
  801436:	68 98 46 80 00       	push   $0x804698
  80143b:	68 21 01 00 00       	push   $0x121
  801440:	68 61 45 80 00       	push   $0x804561
  801445:	e8 45 01 00 00       	call   80158f <_panic>
		if(start_freeFrames != (sys_calculate_free_frames() + 4)) {panic("Wrong free: not all pages removed correctly at end");}
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
	 */
	return;
  80144a:	90                   	nop
}
  80144b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144e:	5b                   	pop    %ebx
  80144f:	5e                   	pop    %esi
  801450:	5f                   	pop    %edi
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    

00801453 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801459:	e8 7d 1a 00 00       	call   802edb <sys_getenvindex>
  80145e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  801461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801464:	89 d0                	mov    %edx,%eax
  801466:	c1 e0 03             	shl    $0x3,%eax
  801469:	01 d0                	add    %edx,%eax
  80146b:	01 c0                	add    %eax,%eax
  80146d:	01 d0                	add    %edx,%eax
  80146f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801476:	01 d0                	add    %edx,%eax
  801478:	c1 e0 04             	shl    $0x4,%eax
  80147b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801480:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801485:	a1 20 50 80 00       	mov    0x805020,%eax
  80148a:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  801490:	84 c0                	test   %al,%al
  801492:	74 0f                	je     8014a3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  801494:	a1 20 50 80 00       	mov    0x805020,%eax
  801499:	05 5c 05 00 00       	add    $0x55c,%eax
  80149e:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8014a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a7:	7e 0a                	jle    8014b3 <libmain+0x60>
		binaryname = argv[0];
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8014b3:	83 ec 08             	sub    $0x8,%esp
  8014b6:	ff 75 0c             	pushl  0xc(%ebp)
  8014b9:	ff 75 08             	pushl  0x8(%ebp)
  8014bc:	e8 77 eb ff ff       	call   800038 <_main>
  8014c1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8014c4:	e8 1f 18 00 00       	call   802ce8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8014c9:	83 ec 0c             	sub    $0xc,%esp
  8014cc:	68 bc 47 80 00       	push   $0x8047bc
  8014d1:	e8 6d 03 00 00       	call   801843 <cprintf>
  8014d6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8014d9:	a1 20 50 80 00       	mov    0x805020,%eax
  8014de:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8014e4:	a1 20 50 80 00       	mov    0x805020,%eax
  8014e9:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	52                   	push   %edx
  8014f3:	50                   	push   %eax
  8014f4:	68 e4 47 80 00       	push   $0x8047e4
  8014f9:	e8 45 03 00 00       	call   801843 <cprintf>
  8014fe:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801501:	a1 20 50 80 00       	mov    0x805020,%eax
  801506:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80150c:	a1 20 50 80 00       	mov    0x805020,%eax
  801511:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  801517:	a1 20 50 80 00       	mov    0x805020,%eax
  80151c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  801522:	51                   	push   %ecx
  801523:	52                   	push   %edx
  801524:	50                   	push   %eax
  801525:	68 0c 48 80 00       	push   $0x80480c
  80152a:	e8 14 03 00 00       	call   801843 <cprintf>
  80152f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801532:	a1 20 50 80 00       	mov    0x805020,%eax
  801537:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80153d:	83 ec 08             	sub    $0x8,%esp
  801540:	50                   	push   %eax
  801541:	68 64 48 80 00       	push   $0x804864
  801546:	e8 f8 02 00 00       	call   801843 <cprintf>
  80154b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80154e:	83 ec 0c             	sub    $0xc,%esp
  801551:	68 bc 47 80 00       	push   $0x8047bc
  801556:	e8 e8 02 00 00       	call   801843 <cprintf>
  80155b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80155e:	e8 9f 17 00 00       	call   802d02 <sys_enable_interrupt>

	// exit gracefully
	exit();
  801563:	e8 19 00 00 00       	call   801581 <exit>
}
  801568:	90                   	nop
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801571:	83 ec 0c             	sub    $0xc,%esp
  801574:	6a 00                	push   $0x0
  801576:	e8 2c 19 00 00       	call   802ea7 <sys_destroy_env>
  80157b:	83 c4 10             	add    $0x10,%esp
}
  80157e:	90                   	nop
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <exit>:

void
exit(void)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801587:	e8 81 19 00 00       	call   802f0d <sys_exit_env>
}
  80158c:	90                   	nop
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801595:	8d 45 10             	lea    0x10(%ebp),%eax
  801598:	83 c0 04             	add    $0x4,%eax
  80159b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80159e:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	74 16                	je     8015bd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8015a7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8015ac:	83 ec 08             	sub    $0x8,%esp
  8015af:	50                   	push   %eax
  8015b0:	68 78 48 80 00       	push   $0x804878
  8015b5:	e8 89 02 00 00       	call   801843 <cprintf>
  8015ba:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8015bd:	a1 00 50 80 00       	mov    0x805000,%eax
  8015c2:	ff 75 0c             	pushl  0xc(%ebp)
  8015c5:	ff 75 08             	pushl  0x8(%ebp)
  8015c8:	50                   	push   %eax
  8015c9:	68 7d 48 80 00       	push   $0x80487d
  8015ce:	e8 70 02 00 00       	call   801843 <cprintf>
  8015d3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8015d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d9:	83 ec 08             	sub    $0x8,%esp
  8015dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8015df:	50                   	push   %eax
  8015e0:	e8 f3 01 00 00       	call   8017d8 <vcprintf>
  8015e5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8015e8:	83 ec 08             	sub    $0x8,%esp
  8015eb:	6a 00                	push   $0x0
  8015ed:	68 99 48 80 00       	push   $0x804899
  8015f2:	e8 e1 01 00 00       	call   8017d8 <vcprintf>
  8015f7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8015fa:	e8 82 ff ff ff       	call   801581 <exit>

	// should not return here
	while (1) ;
  8015ff:	eb fe                	jmp    8015ff <_panic+0x70>

00801601 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801607:	a1 20 50 80 00       	mov    0x805020,%eax
  80160c:	8b 50 74             	mov    0x74(%eax),%edx
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	39 c2                	cmp    %eax,%edx
  801614:	74 14                	je     80162a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801616:	83 ec 04             	sub    $0x4,%esp
  801619:	68 9c 48 80 00       	push   $0x80489c
  80161e:	6a 26                	push   $0x26
  801620:	68 e8 48 80 00       	push   $0x8048e8
  801625:	e8 65 ff ff ff       	call   80158f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80162a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801631:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801638:	e9 c2 00 00 00       	jmp    8016ff <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80163d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801640:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	01 d0                	add    %edx,%eax
  80164c:	8b 00                	mov    (%eax),%eax
  80164e:	85 c0                	test   %eax,%eax
  801650:	75 08                	jne    80165a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801652:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801655:	e9 a2 00 00 00       	jmp    8016fc <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80165a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801661:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801668:	eb 69                	jmp    8016d3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80166a:	a1 20 50 80 00       	mov    0x805020,%eax
  80166f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801675:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801678:	89 d0                	mov    %edx,%eax
  80167a:	01 c0                	add    %eax,%eax
  80167c:	01 d0                	add    %edx,%eax
  80167e:	c1 e0 03             	shl    $0x3,%eax
  801681:	01 c8                	add    %ecx,%eax
  801683:	8a 40 04             	mov    0x4(%eax),%al
  801686:	84 c0                	test   %al,%al
  801688:	75 46                	jne    8016d0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80168a:	a1 20 50 80 00       	mov    0x805020,%eax
  80168f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801695:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801698:	89 d0                	mov    %edx,%eax
  80169a:	01 c0                	add    %eax,%eax
  80169c:	01 d0                	add    %edx,%eax
  80169e:	c1 e0 03             	shl    $0x3,%eax
  8016a1:	01 c8                	add    %ecx,%eax
  8016a3:	8b 00                	mov    (%eax),%eax
  8016a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8016b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	01 c8                	add    %ecx,%eax
  8016c1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016c3:	39 c2                	cmp    %eax,%edx
  8016c5:	75 09                	jne    8016d0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8016c7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8016ce:	eb 12                	jmp    8016e2 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016d0:	ff 45 e8             	incl   -0x18(%ebp)
  8016d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8016d8:	8b 50 74             	mov    0x74(%eax),%edx
  8016db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016de:	39 c2                	cmp    %eax,%edx
  8016e0:	77 88                	ja     80166a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8016e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016e6:	75 14                	jne    8016fc <CheckWSWithoutLastIndex+0xfb>
			panic(
  8016e8:	83 ec 04             	sub    $0x4,%esp
  8016eb:	68 f4 48 80 00       	push   $0x8048f4
  8016f0:	6a 3a                	push   $0x3a
  8016f2:	68 e8 48 80 00       	push   $0x8048e8
  8016f7:	e8 93 fe ff ff       	call   80158f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8016fc:	ff 45 f0             	incl   -0x10(%ebp)
  8016ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801702:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801705:	0f 8c 32 ff ff ff    	jl     80163d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80170b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801712:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801719:	eb 26                	jmp    801741 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80171b:	a1 20 50 80 00       	mov    0x805020,%eax
  801720:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801726:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801729:	89 d0                	mov    %edx,%eax
  80172b:	01 c0                	add    %eax,%eax
  80172d:	01 d0                	add    %edx,%eax
  80172f:	c1 e0 03             	shl    $0x3,%eax
  801732:	01 c8                	add    %ecx,%eax
  801734:	8a 40 04             	mov    0x4(%eax),%al
  801737:	3c 01                	cmp    $0x1,%al
  801739:	75 03                	jne    80173e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80173b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80173e:	ff 45 e0             	incl   -0x20(%ebp)
  801741:	a1 20 50 80 00       	mov    0x805020,%eax
  801746:	8b 50 74             	mov    0x74(%eax),%edx
  801749:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80174c:	39 c2                	cmp    %eax,%edx
  80174e:	77 cb                	ja     80171b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801753:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801756:	74 14                	je     80176c <CheckWSWithoutLastIndex+0x16b>
		panic(
  801758:	83 ec 04             	sub    $0x4,%esp
  80175b:	68 48 49 80 00       	push   $0x804948
  801760:	6a 44                	push   $0x44
  801762:	68 e8 48 80 00       	push   $0x8048e8
  801767:	e8 23 fe ff ff       	call   80158f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80176c:	90                   	nop
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801775:	8b 45 0c             	mov    0xc(%ebp),%eax
  801778:	8b 00                	mov    (%eax),%eax
  80177a:	8d 48 01             	lea    0x1(%eax),%ecx
  80177d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801780:	89 0a                	mov    %ecx,(%edx)
  801782:	8b 55 08             	mov    0x8(%ebp),%edx
  801785:	88 d1                	mov    %dl,%cl
  801787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80178e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801791:	8b 00                	mov    (%eax),%eax
  801793:	3d ff 00 00 00       	cmp    $0xff,%eax
  801798:	75 2c                	jne    8017c6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80179a:	a0 24 50 80 00       	mov    0x805024,%al
  80179f:	0f b6 c0             	movzbl %al,%eax
  8017a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a5:	8b 12                	mov    (%edx),%edx
  8017a7:	89 d1                	mov    %edx,%ecx
  8017a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ac:	83 c2 08             	add    $0x8,%edx
  8017af:	83 ec 04             	sub    $0x4,%esp
  8017b2:	50                   	push   %eax
  8017b3:	51                   	push   %ecx
  8017b4:	52                   	push   %edx
  8017b5:	e8 80 13 00 00       	call   802b3a <sys_cputs>
  8017ba:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8017bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	8b 40 04             	mov    0x4(%eax),%eax
  8017cc:	8d 50 01             	lea    0x1(%eax),%edx
  8017cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8017d5:	90                   	nop
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8017e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8017e8:	00 00 00 
	b.cnt = 0;
  8017eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8017f2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8017f5:	ff 75 0c             	pushl  0xc(%ebp)
  8017f8:	ff 75 08             	pushl  0x8(%ebp)
  8017fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801801:	50                   	push   %eax
  801802:	68 6f 17 80 00       	push   $0x80176f
  801807:	e8 11 02 00 00       	call   801a1d <vprintfmt>
  80180c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80180f:	a0 24 50 80 00       	mov    0x805024,%al
  801814:	0f b6 c0             	movzbl %al,%eax
  801817:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	50                   	push   %eax
  801821:	52                   	push   %edx
  801822:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801828:	83 c0 08             	add    $0x8,%eax
  80182b:	50                   	push   %eax
  80182c:	e8 09 13 00 00       	call   802b3a <sys_cputs>
  801831:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801834:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80183b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <cprintf>:

int cprintf(const char *fmt, ...) {
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801849:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801850:	8d 45 0c             	lea    0xc(%ebp),%eax
  801853:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	83 ec 08             	sub    $0x8,%esp
  80185c:	ff 75 f4             	pushl  -0xc(%ebp)
  80185f:	50                   	push   %eax
  801860:	e8 73 ff ff ff       	call   8017d8 <vcprintf>
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80186b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801876:	e8 6d 14 00 00       	call   802ce8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80187b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80187e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	83 ec 08             	sub    $0x8,%esp
  801887:	ff 75 f4             	pushl  -0xc(%ebp)
  80188a:	50                   	push   %eax
  80188b:	e8 48 ff ff ff       	call   8017d8 <vcprintf>
  801890:	83 c4 10             	add    $0x10,%esp
  801893:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801896:	e8 67 14 00 00       	call   802d02 <sys_enable_interrupt>
	return cnt;
  80189b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 14             	sub    $0x14,%esp
  8018a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8018b3:	8b 45 18             	mov    0x18(%ebp),%eax
  8018b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018be:	77 55                	ja     801915 <printnum+0x75>
  8018c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018c3:	72 05                	jb     8018ca <printnum+0x2a>
  8018c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018c8:	77 4b                	ja     801915 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8018ca:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8018cd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8018d0:	8b 45 18             	mov    0x18(%ebp),%eax
  8018d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d8:	52                   	push   %edx
  8018d9:	50                   	push   %eax
  8018da:	ff 75 f4             	pushl  -0xc(%ebp)
  8018dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e0:	e8 cf 29 00 00       	call   8042b4 <__udivdi3>
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	83 ec 04             	sub    $0x4,%esp
  8018eb:	ff 75 20             	pushl  0x20(%ebp)
  8018ee:	53                   	push   %ebx
  8018ef:	ff 75 18             	pushl  0x18(%ebp)
  8018f2:	52                   	push   %edx
  8018f3:	50                   	push   %eax
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	ff 75 08             	pushl  0x8(%ebp)
  8018fa:	e8 a1 ff ff ff       	call   8018a0 <printnum>
  8018ff:	83 c4 20             	add    $0x20,%esp
  801902:	eb 1a                	jmp    80191e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801904:	83 ec 08             	sub    $0x8,%esp
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	ff 75 20             	pushl  0x20(%ebp)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	ff d0                	call   *%eax
  801912:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801915:	ff 4d 1c             	decl   0x1c(%ebp)
  801918:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80191c:	7f e6                	jg     801904 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80191e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801921:	bb 00 00 00 00       	mov    $0x0,%ebx
  801926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80192c:	53                   	push   %ebx
  80192d:	51                   	push   %ecx
  80192e:	52                   	push   %edx
  80192f:	50                   	push   %eax
  801930:	e8 8f 2a 00 00       	call   8043c4 <__umoddi3>
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	05 b4 4b 80 00       	add    $0x804bb4,%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	0f be c0             	movsbl %al,%eax
  801942:	83 ec 08             	sub    $0x8,%esp
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	50                   	push   %eax
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	ff d0                	call   *%eax
  80194e:	83 c4 10             	add    $0x10,%esp
}
  801951:	90                   	nop
  801952:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80195a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80195e:	7e 1c                	jle    80197c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	8b 00                	mov    (%eax),%eax
  801965:	8d 50 08             	lea    0x8(%eax),%edx
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	89 10                	mov    %edx,(%eax)
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	83 e8 08             	sub    $0x8,%eax
  801975:	8b 50 04             	mov    0x4(%eax),%edx
  801978:	8b 00                	mov    (%eax),%eax
  80197a:	eb 40                	jmp    8019bc <getuint+0x65>
	else if (lflag)
  80197c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801980:	74 1e                	je     8019a0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	8b 00                	mov    (%eax),%eax
  801987:	8d 50 04             	lea    0x4(%eax),%edx
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	89 10                	mov    %edx,(%eax)
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	8b 00                	mov    (%eax),%eax
  801994:	83 e8 04             	sub    $0x4,%eax
  801997:	8b 00                	mov    (%eax),%eax
  801999:	ba 00 00 00 00       	mov    $0x0,%edx
  80199e:	eb 1c                	jmp    8019bc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	8b 00                	mov    (%eax),%eax
  8019a5:	8d 50 04             	lea    0x4(%eax),%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	89 10                	mov    %edx,(%eax)
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	8b 00                	mov    (%eax),%eax
  8019b2:	83 e8 04             	sub    $0x4,%eax
  8019b5:	8b 00                	mov    (%eax),%eax
  8019b7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019bc:	5d                   	pop    %ebp
  8019bd:	c3                   	ret    

008019be <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019c1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019c5:	7e 1c                	jle    8019e3 <getint+0x25>
		return va_arg(*ap, long long);
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8b 00                	mov    (%eax),%eax
  8019cc:	8d 50 08             	lea    0x8(%eax),%edx
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	89 10                	mov    %edx,(%eax)
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	8b 00                	mov    (%eax),%eax
  8019d9:	83 e8 08             	sub    $0x8,%eax
  8019dc:	8b 50 04             	mov    0x4(%eax),%edx
  8019df:	8b 00                	mov    (%eax),%eax
  8019e1:	eb 38                	jmp    801a1b <getint+0x5d>
	else if (lflag)
  8019e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019e7:	74 1a                	je     801a03 <getint+0x45>
		return va_arg(*ap, long);
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8b 00                	mov    (%eax),%eax
  8019ee:	8d 50 04             	lea    0x4(%eax),%edx
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	89 10                	mov    %edx,(%eax)
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8b 00                	mov    (%eax),%eax
  8019fb:	83 e8 04             	sub    $0x4,%eax
  8019fe:	8b 00                	mov    (%eax),%eax
  801a00:	99                   	cltd   
  801a01:	eb 18                	jmp    801a1b <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	8b 00                	mov    (%eax),%eax
  801a08:	8d 50 04             	lea    0x4(%eax),%edx
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	89 10                	mov    %edx,(%eax)
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	8b 00                	mov    (%eax),%eax
  801a15:	83 e8 04             	sub    $0x4,%eax
  801a18:	8b 00                	mov    (%eax),%eax
  801a1a:	99                   	cltd   
}
  801a1b:	5d                   	pop    %ebp
  801a1c:	c3                   	ret    

00801a1d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	56                   	push   %esi
  801a21:	53                   	push   %ebx
  801a22:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a25:	eb 17                	jmp    801a3e <vprintfmt+0x21>
			if (ch == '\0')
  801a27:	85 db                	test   %ebx,%ebx
  801a29:	0f 84 af 03 00 00    	je     801dde <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801a2f:	83 ec 08             	sub    $0x8,%esp
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	53                   	push   %ebx
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	ff d0                	call   *%eax
  801a3b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a41:	8d 50 01             	lea    0x1(%eax),%edx
  801a44:	89 55 10             	mov    %edx,0x10(%ebp)
  801a47:	8a 00                	mov    (%eax),%al
  801a49:	0f b6 d8             	movzbl %al,%ebx
  801a4c:	83 fb 25             	cmp    $0x25,%ebx
  801a4f:	75 d6                	jne    801a27 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801a51:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801a55:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801a5c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801a63:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801a6a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a71:	8b 45 10             	mov    0x10(%ebp),%eax
  801a74:	8d 50 01             	lea    0x1(%eax),%edx
  801a77:	89 55 10             	mov    %edx,0x10(%ebp)
  801a7a:	8a 00                	mov    (%eax),%al
  801a7c:	0f b6 d8             	movzbl %al,%ebx
  801a7f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801a82:	83 f8 55             	cmp    $0x55,%eax
  801a85:	0f 87 2b 03 00 00    	ja     801db6 <vprintfmt+0x399>
  801a8b:	8b 04 85 d8 4b 80 00 	mov    0x804bd8(,%eax,4),%eax
  801a92:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801a94:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801a98:	eb d7                	jmp    801a71 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801a9a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801a9e:	eb d1                	jmp    801a71 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801aa0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801aa7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801aaa:	89 d0                	mov    %edx,%eax
  801aac:	c1 e0 02             	shl    $0x2,%eax
  801aaf:	01 d0                	add    %edx,%eax
  801ab1:	01 c0                	add    %eax,%eax
  801ab3:	01 d8                	add    %ebx,%eax
  801ab5:	83 e8 30             	sub    $0x30,%eax
  801ab8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801abb:	8b 45 10             	mov    0x10(%ebp),%eax
  801abe:	8a 00                	mov    (%eax),%al
  801ac0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801ac3:	83 fb 2f             	cmp    $0x2f,%ebx
  801ac6:	7e 3e                	jle    801b06 <vprintfmt+0xe9>
  801ac8:	83 fb 39             	cmp    $0x39,%ebx
  801acb:	7f 39                	jg     801b06 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801acd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801ad0:	eb d5                	jmp    801aa7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801ad2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad5:	83 c0 04             	add    $0x4,%eax
  801ad8:	89 45 14             	mov    %eax,0x14(%ebp)
  801adb:	8b 45 14             	mov    0x14(%ebp),%eax
  801ade:	83 e8 04             	sub    $0x4,%eax
  801ae1:	8b 00                	mov    (%eax),%eax
  801ae3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801ae6:	eb 1f                	jmp    801b07 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801ae8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801aec:	79 83                	jns    801a71 <vprintfmt+0x54>
				width = 0;
  801aee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801af5:	e9 77 ff ff ff       	jmp    801a71 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801afa:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b01:	e9 6b ff ff ff       	jmp    801a71 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b06:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b0b:	0f 89 60 ff ff ff    	jns    801a71 <vprintfmt+0x54>
				width = precision, precision = -1;
  801b11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b17:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b1e:	e9 4e ff ff ff       	jmp    801a71 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b23:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b26:	e9 46 ff ff ff       	jmp    801a71 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2e:	83 c0 04             	add    $0x4,%eax
  801b31:	89 45 14             	mov    %eax,0x14(%ebp)
  801b34:	8b 45 14             	mov    0x14(%ebp),%eax
  801b37:	83 e8 04             	sub    $0x4,%eax
  801b3a:	8b 00                	mov    (%eax),%eax
  801b3c:	83 ec 08             	sub    $0x8,%esp
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	50                   	push   %eax
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	ff d0                	call   *%eax
  801b48:	83 c4 10             	add    $0x10,%esp
			break;
  801b4b:	e9 89 02 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b50:	8b 45 14             	mov    0x14(%ebp),%eax
  801b53:	83 c0 04             	add    $0x4,%eax
  801b56:	89 45 14             	mov    %eax,0x14(%ebp)
  801b59:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5c:	83 e8 04             	sub    $0x4,%eax
  801b5f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801b61:	85 db                	test   %ebx,%ebx
  801b63:	79 02                	jns    801b67 <vprintfmt+0x14a>
				err = -err;
  801b65:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801b67:	83 fb 64             	cmp    $0x64,%ebx
  801b6a:	7f 0b                	jg     801b77 <vprintfmt+0x15a>
  801b6c:	8b 34 9d 20 4a 80 00 	mov    0x804a20(,%ebx,4),%esi
  801b73:	85 f6                	test   %esi,%esi
  801b75:	75 19                	jne    801b90 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801b77:	53                   	push   %ebx
  801b78:	68 c5 4b 80 00       	push   $0x804bc5
  801b7d:	ff 75 0c             	pushl  0xc(%ebp)
  801b80:	ff 75 08             	pushl  0x8(%ebp)
  801b83:	e8 5e 02 00 00       	call   801de6 <printfmt>
  801b88:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801b8b:	e9 49 02 00 00       	jmp    801dd9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801b90:	56                   	push   %esi
  801b91:	68 ce 4b 80 00       	push   $0x804bce
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	ff 75 08             	pushl  0x8(%ebp)
  801b9c:	e8 45 02 00 00       	call   801de6 <printfmt>
  801ba1:	83 c4 10             	add    $0x10,%esp
			break;
  801ba4:	e9 30 02 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801ba9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bac:	83 c0 04             	add    $0x4,%eax
  801baf:	89 45 14             	mov    %eax,0x14(%ebp)
  801bb2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb5:	83 e8 04             	sub    $0x4,%eax
  801bb8:	8b 30                	mov    (%eax),%esi
  801bba:	85 f6                	test   %esi,%esi
  801bbc:	75 05                	jne    801bc3 <vprintfmt+0x1a6>
				p = "(null)";
  801bbe:	be d1 4b 80 00       	mov    $0x804bd1,%esi
			if (width > 0 && padc != '-')
  801bc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bc7:	7e 6d                	jle    801c36 <vprintfmt+0x219>
  801bc9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801bcd:	74 67                	je     801c36 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801bcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bd2:	83 ec 08             	sub    $0x8,%esp
  801bd5:	50                   	push   %eax
  801bd6:	56                   	push   %esi
  801bd7:	e8 0c 03 00 00       	call   801ee8 <strnlen>
  801bdc:	83 c4 10             	add    $0x10,%esp
  801bdf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801be2:	eb 16                	jmp    801bfa <vprintfmt+0x1dd>
					putch(padc, putdat);
  801be4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801be8:	83 ec 08             	sub    $0x8,%esp
  801beb:	ff 75 0c             	pushl  0xc(%ebp)
  801bee:	50                   	push   %eax
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	ff d0                	call   *%eax
  801bf4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801bf7:	ff 4d e4             	decl   -0x1c(%ebp)
  801bfa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bfe:	7f e4                	jg     801be4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c00:	eb 34                	jmp    801c36 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c02:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c06:	74 1c                	je     801c24 <vprintfmt+0x207>
  801c08:	83 fb 1f             	cmp    $0x1f,%ebx
  801c0b:	7e 05                	jle    801c12 <vprintfmt+0x1f5>
  801c0d:	83 fb 7e             	cmp    $0x7e,%ebx
  801c10:	7e 12                	jle    801c24 <vprintfmt+0x207>
					putch('?', putdat);
  801c12:	83 ec 08             	sub    $0x8,%esp
  801c15:	ff 75 0c             	pushl  0xc(%ebp)
  801c18:	6a 3f                	push   $0x3f
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	ff d0                	call   *%eax
  801c1f:	83 c4 10             	add    $0x10,%esp
  801c22:	eb 0f                	jmp    801c33 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c24:	83 ec 08             	sub    $0x8,%esp
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	53                   	push   %ebx
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	ff d0                	call   *%eax
  801c30:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c33:	ff 4d e4             	decl   -0x1c(%ebp)
  801c36:	89 f0                	mov    %esi,%eax
  801c38:	8d 70 01             	lea    0x1(%eax),%esi
  801c3b:	8a 00                	mov    (%eax),%al
  801c3d:	0f be d8             	movsbl %al,%ebx
  801c40:	85 db                	test   %ebx,%ebx
  801c42:	74 24                	je     801c68 <vprintfmt+0x24b>
  801c44:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c48:	78 b8                	js     801c02 <vprintfmt+0x1e5>
  801c4a:	ff 4d e0             	decl   -0x20(%ebp)
  801c4d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c51:	79 af                	jns    801c02 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c53:	eb 13                	jmp    801c68 <vprintfmt+0x24b>
				putch(' ', putdat);
  801c55:	83 ec 08             	sub    $0x8,%esp
  801c58:	ff 75 0c             	pushl  0xc(%ebp)
  801c5b:	6a 20                	push   $0x20
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	ff d0                	call   *%eax
  801c62:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c65:	ff 4d e4             	decl   -0x1c(%ebp)
  801c68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c6c:	7f e7                	jg     801c55 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801c6e:	e9 66 01 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801c73:	83 ec 08             	sub    $0x8,%esp
  801c76:	ff 75 e8             	pushl  -0x18(%ebp)
  801c79:	8d 45 14             	lea    0x14(%ebp),%eax
  801c7c:	50                   	push   %eax
  801c7d:	e8 3c fd ff ff       	call   8019be <getint>
  801c82:	83 c4 10             	add    $0x10,%esp
  801c85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c91:	85 d2                	test   %edx,%edx
  801c93:	79 23                	jns    801cb8 <vprintfmt+0x29b>
				putch('-', putdat);
  801c95:	83 ec 08             	sub    $0x8,%esp
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	6a 2d                	push   $0x2d
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	ff d0                	call   *%eax
  801ca2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cab:	f7 d8                	neg    %eax
  801cad:	83 d2 00             	adc    $0x0,%edx
  801cb0:	f7 da                	neg    %edx
  801cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801cb8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801cbf:	e9 bc 00 00 00       	jmp    801d80 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801cc4:	83 ec 08             	sub    $0x8,%esp
  801cc7:	ff 75 e8             	pushl  -0x18(%ebp)
  801cca:	8d 45 14             	lea    0x14(%ebp),%eax
  801ccd:	50                   	push   %eax
  801cce:	e8 84 fc ff ff       	call   801957 <getuint>
  801cd3:	83 c4 10             	add    $0x10,%esp
  801cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801cdc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801ce3:	e9 98 00 00 00       	jmp    801d80 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801ce8:	83 ec 08             	sub    $0x8,%esp
  801ceb:	ff 75 0c             	pushl  0xc(%ebp)
  801cee:	6a 58                	push   $0x58
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	ff d0                	call   *%eax
  801cf5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801cf8:	83 ec 08             	sub    $0x8,%esp
  801cfb:	ff 75 0c             	pushl  0xc(%ebp)
  801cfe:	6a 58                	push   $0x58
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	ff d0                	call   *%eax
  801d05:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d08:	83 ec 08             	sub    $0x8,%esp
  801d0b:	ff 75 0c             	pushl  0xc(%ebp)
  801d0e:	6a 58                	push   $0x58
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	ff d0                	call   *%eax
  801d15:	83 c4 10             	add    $0x10,%esp
			break;
  801d18:	e9 bc 00 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801d1d:	83 ec 08             	sub    $0x8,%esp
  801d20:	ff 75 0c             	pushl  0xc(%ebp)
  801d23:	6a 30                	push   $0x30
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	ff d0                	call   *%eax
  801d2a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801d2d:	83 ec 08             	sub    $0x8,%esp
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	6a 78                	push   $0x78
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	ff d0                	call   *%eax
  801d3a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801d3d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d40:	83 c0 04             	add    $0x4,%eax
  801d43:	89 45 14             	mov    %eax,0x14(%ebp)
  801d46:	8b 45 14             	mov    0x14(%ebp),%eax
  801d49:	83 e8 04             	sub    $0x4,%eax
  801d4c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801d58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801d5f:	eb 1f                	jmp    801d80 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d61:	83 ec 08             	sub    $0x8,%esp
  801d64:	ff 75 e8             	pushl  -0x18(%ebp)
  801d67:	8d 45 14             	lea    0x14(%ebp),%eax
  801d6a:	50                   	push   %eax
  801d6b:	e8 e7 fb ff ff       	call   801957 <getuint>
  801d70:	83 c4 10             	add    $0x10,%esp
  801d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d76:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801d79:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801d80:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801d84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d87:	83 ec 04             	sub    $0x4,%esp
  801d8a:	52                   	push   %edx
  801d8b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d8e:	50                   	push   %eax
  801d8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d92:	ff 75 f0             	pushl  -0x10(%ebp)
  801d95:	ff 75 0c             	pushl  0xc(%ebp)
  801d98:	ff 75 08             	pushl  0x8(%ebp)
  801d9b:	e8 00 fb ff ff       	call   8018a0 <printnum>
  801da0:	83 c4 20             	add    $0x20,%esp
			break;
  801da3:	eb 34                	jmp    801dd9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801da5:	83 ec 08             	sub    $0x8,%esp
  801da8:	ff 75 0c             	pushl  0xc(%ebp)
  801dab:	53                   	push   %ebx
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	ff d0                	call   *%eax
  801db1:	83 c4 10             	add    $0x10,%esp
			break;
  801db4:	eb 23                	jmp    801dd9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801db6:	83 ec 08             	sub    $0x8,%esp
  801db9:	ff 75 0c             	pushl  0xc(%ebp)
  801dbc:	6a 25                	push   $0x25
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	ff d0                	call   *%eax
  801dc3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801dc6:	ff 4d 10             	decl   0x10(%ebp)
  801dc9:	eb 03                	jmp    801dce <vprintfmt+0x3b1>
  801dcb:	ff 4d 10             	decl   0x10(%ebp)
  801dce:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd1:	48                   	dec    %eax
  801dd2:	8a 00                	mov    (%eax),%al
  801dd4:	3c 25                	cmp    $0x25,%al
  801dd6:	75 f3                	jne    801dcb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801dd8:	90                   	nop
		}
	}
  801dd9:	e9 47 fc ff ff       	jmp    801a25 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801dde:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801ddf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5e                   	pop    %esi
  801de4:	5d                   	pop    %ebp
  801de5:	c3                   	ret    

00801de6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801dec:	8d 45 10             	lea    0x10(%ebp),%eax
  801def:	83 c0 04             	add    $0x4,%eax
  801df2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801df5:	8b 45 10             	mov    0x10(%ebp),%eax
  801df8:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfb:	50                   	push   %eax
  801dfc:	ff 75 0c             	pushl  0xc(%ebp)
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	e8 16 fc ff ff       	call   801a1d <vprintfmt>
  801e07:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e0a:	90                   	nop
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e13:	8b 40 08             	mov    0x8(%eax),%eax
  801e16:	8d 50 01             	lea    0x1(%eax),%edx
  801e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e22:	8b 10                	mov    (%eax),%edx
  801e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e27:	8b 40 04             	mov    0x4(%eax),%eax
  801e2a:	39 c2                	cmp    %eax,%edx
  801e2c:	73 12                	jae    801e40 <sprintputch+0x33>
		*b->buf++ = ch;
  801e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e31:	8b 00                	mov    (%eax),%eax
  801e33:	8d 48 01             	lea    0x1(%eax),%ecx
  801e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e39:	89 0a                	mov    %ecx,(%edx)
  801e3b:	8b 55 08             	mov    0x8(%ebp),%edx
  801e3e:	88 10                	mov    %dl,(%eax)
}
  801e40:	90                   	nop
  801e41:	5d                   	pop    %ebp
  801e42:	c3                   	ret    

00801e43 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e52:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	01 d0                	add    %edx,%eax
  801e5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801e64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e68:	74 06                	je     801e70 <vsnprintf+0x2d>
  801e6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e6e:	7f 07                	jg     801e77 <vsnprintf+0x34>
		return -E_INVAL;
  801e70:	b8 03 00 00 00       	mov    $0x3,%eax
  801e75:	eb 20                	jmp    801e97 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801e77:	ff 75 14             	pushl  0x14(%ebp)
  801e7a:	ff 75 10             	pushl  0x10(%ebp)
  801e7d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e80:	50                   	push   %eax
  801e81:	68 0d 1e 80 00       	push   $0x801e0d
  801e86:	e8 92 fb ff ff       	call   801a1d <vprintfmt>
  801e8b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801e8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e91:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801e9f:	8d 45 10             	lea    0x10(%ebp),%eax
  801ea2:	83 c0 04             	add    $0x4,%eax
  801ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eab:	ff 75 f4             	pushl  -0xc(%ebp)
  801eae:	50                   	push   %eax
  801eaf:	ff 75 0c             	pushl  0xc(%ebp)
  801eb2:	ff 75 08             	pushl  0x8(%ebp)
  801eb5:	e8 89 ff ff ff       	call   801e43 <vsnprintf>
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801ecb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ed2:	eb 06                	jmp    801eda <strlen+0x15>
		n++;
  801ed4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ed7:	ff 45 08             	incl   0x8(%ebp)
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	8a 00                	mov    (%eax),%al
  801edf:	84 c0                	test   %al,%al
  801ee1:	75 f1                	jne    801ed4 <strlen+0xf>
		n++;
	return n;
  801ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801eee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ef5:	eb 09                	jmp    801f00 <strnlen+0x18>
		n++;
  801ef7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801efa:	ff 45 08             	incl   0x8(%ebp)
  801efd:	ff 4d 0c             	decl   0xc(%ebp)
  801f00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f04:	74 09                	je     801f0f <strnlen+0x27>
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	8a 00                	mov    (%eax),%al
  801f0b:	84 c0                	test   %al,%al
  801f0d:	75 e8                	jne    801ef7 <strnlen+0xf>
		n++;
	return n;
  801f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f20:	90                   	nop
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	8d 50 01             	lea    0x1(%eax),%edx
  801f27:	89 55 08             	mov    %edx,0x8(%ebp)
  801f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f30:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f33:	8a 12                	mov    (%edx),%dl
  801f35:	88 10                	mov    %dl,(%eax)
  801f37:	8a 00                	mov    (%eax),%al
  801f39:	84 c0                	test   %al,%al
  801f3b:	75 e4                	jne    801f21 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801f4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f55:	eb 1f                	jmp    801f76 <strncpy+0x34>
		*dst++ = *src;
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	8d 50 01             	lea    0x1(%eax),%edx
  801f5d:	89 55 08             	mov    %edx,0x8(%ebp)
  801f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f63:	8a 12                	mov    (%edx),%dl
  801f65:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6a:	8a 00                	mov    (%eax),%al
  801f6c:	84 c0                	test   %al,%al
  801f6e:	74 03                	je     801f73 <strncpy+0x31>
			src++;
  801f70:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f73:	ff 45 fc             	incl   -0x4(%ebp)
  801f76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f79:	3b 45 10             	cmp    0x10(%ebp),%eax
  801f7c:	72 d9                	jb     801f57 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801f8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f93:	74 30                	je     801fc5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801f95:	eb 16                	jmp    801fad <strlcpy+0x2a>
			*dst++ = *src++;
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	8d 50 01             	lea    0x1(%eax),%edx
  801f9d:	89 55 08             	mov    %edx,0x8(%ebp)
  801fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa3:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fa6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801fa9:	8a 12                	mov    (%edx),%dl
  801fab:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801fad:	ff 4d 10             	decl   0x10(%ebp)
  801fb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fb4:	74 09                	je     801fbf <strlcpy+0x3c>
  801fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb9:	8a 00                	mov    (%eax),%al
  801fbb:	84 c0                	test   %al,%al
  801fbd:	75 d8                	jne    801f97 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801fc5:	8b 55 08             	mov    0x8(%ebp),%edx
  801fc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fcb:	29 c2                	sub    %eax,%edx
  801fcd:	89 d0                	mov    %edx,%eax
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801fd4:	eb 06                	jmp    801fdc <strcmp+0xb>
		p++, q++;
  801fd6:	ff 45 08             	incl   0x8(%ebp)
  801fd9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	8a 00                	mov    (%eax),%al
  801fe1:	84 c0                	test   %al,%al
  801fe3:	74 0e                	je     801ff3 <strcmp+0x22>
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	8a 10                	mov    (%eax),%dl
  801fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fed:	8a 00                	mov    (%eax),%al
  801fef:	38 c2                	cmp    %al,%dl
  801ff1:	74 e3                	je     801fd6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	8a 00                	mov    (%eax),%al
  801ff8:	0f b6 d0             	movzbl %al,%edx
  801ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffe:	8a 00                	mov    (%eax),%al
  802000:	0f b6 c0             	movzbl %al,%eax
  802003:	29 c2                	sub    %eax,%edx
  802005:	89 d0                	mov    %edx,%eax
}
  802007:	5d                   	pop    %ebp
  802008:	c3                   	ret    

00802009 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80200c:	eb 09                	jmp    802017 <strncmp+0xe>
		n--, p++, q++;
  80200e:	ff 4d 10             	decl   0x10(%ebp)
  802011:	ff 45 08             	incl   0x8(%ebp)
  802014:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  802017:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80201b:	74 17                	je     802034 <strncmp+0x2b>
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	8a 00                	mov    (%eax),%al
  802022:	84 c0                	test   %al,%al
  802024:	74 0e                	je     802034 <strncmp+0x2b>
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	8a 10                	mov    (%eax),%dl
  80202b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202e:	8a 00                	mov    (%eax),%al
  802030:	38 c2                	cmp    %al,%dl
  802032:	74 da                	je     80200e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802034:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802038:	75 07                	jne    802041 <strncmp+0x38>
		return 0;
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	eb 14                	jmp    802055 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	8a 00                	mov    (%eax),%al
  802046:	0f b6 d0             	movzbl %al,%edx
  802049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204c:	8a 00                	mov    (%eax),%al
  80204e:	0f b6 c0             	movzbl %al,%eax
  802051:	29 c2                	sub    %eax,%edx
  802053:	89 d0                	mov    %edx,%eax
}
  802055:	5d                   	pop    %ebp
  802056:	c3                   	ret    

00802057 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 04             	sub    $0x4,%esp
  80205d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802060:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802063:	eb 12                	jmp    802077 <strchr+0x20>
		if (*s == c)
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	8a 00                	mov    (%eax),%al
  80206a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80206d:	75 05                	jne    802074 <strchr+0x1d>
			return (char *) s;
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	eb 11                	jmp    802085 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802074:	ff 45 08             	incl   0x8(%ebp)
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	8a 00                	mov    (%eax),%al
  80207c:	84 c0                	test   %al,%al
  80207e:	75 e5                	jne    802065 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802090:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802093:	eb 0d                	jmp    8020a2 <strfind+0x1b>
		if (*s == c)
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	8a 00                	mov    (%eax),%al
  80209a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80209d:	74 0e                	je     8020ad <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80209f:	ff 45 08             	incl   0x8(%ebp)
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	8a 00                	mov    (%eax),%al
  8020a7:	84 c0                	test   %al,%al
  8020a9:	75 ea                	jne    802095 <strfind+0xe>
  8020ab:	eb 01                	jmp    8020ae <strfind+0x27>
		if (*s == c)
			break;
  8020ad:	90                   	nop
	return (char *) s;
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8020bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8020c5:	eb 0e                	jmp    8020d5 <memset+0x22>
		*p++ = c;
  8020c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ca:	8d 50 01             	lea    0x1(%eax),%edx
  8020cd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8020d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8020d5:	ff 4d f8             	decl   -0x8(%ebp)
  8020d8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8020dc:	79 e9                	jns    8020c7 <memset+0x14>
		*p++ = c;

	return v;
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8020e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8020f5:	eb 16                	jmp    80210d <memcpy+0x2a>
		*d++ = *s++;
  8020f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020fa:	8d 50 01             	lea    0x1(%eax),%edx
  8020fd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802100:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802103:	8d 4a 01             	lea    0x1(%edx),%ecx
  802106:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802109:	8a 12                	mov    (%edx),%dl
  80210b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80210d:	8b 45 10             	mov    0x10(%ebp),%eax
  802110:	8d 50 ff             	lea    -0x1(%eax),%edx
  802113:	89 55 10             	mov    %edx,0x10(%ebp)
  802116:	85 c0                	test   %eax,%eax
  802118:	75 dd                	jne    8020f7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802125:	8b 45 0c             	mov    0xc(%ebp),%eax
  802128:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802131:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802134:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802137:	73 50                	jae    802189 <memmove+0x6a>
  802139:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80213c:	8b 45 10             	mov    0x10(%ebp),%eax
  80213f:	01 d0                	add    %edx,%eax
  802141:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802144:	76 43                	jbe    802189 <memmove+0x6a>
		s += n;
  802146:	8b 45 10             	mov    0x10(%ebp),%eax
  802149:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80214c:	8b 45 10             	mov    0x10(%ebp),%eax
  80214f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802152:	eb 10                	jmp    802164 <memmove+0x45>
			*--d = *--s;
  802154:	ff 4d f8             	decl   -0x8(%ebp)
  802157:	ff 4d fc             	decl   -0x4(%ebp)
  80215a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80215d:	8a 10                	mov    (%eax),%dl
  80215f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802162:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802164:	8b 45 10             	mov    0x10(%ebp),%eax
  802167:	8d 50 ff             	lea    -0x1(%eax),%edx
  80216a:	89 55 10             	mov    %edx,0x10(%ebp)
  80216d:	85 c0                	test   %eax,%eax
  80216f:	75 e3                	jne    802154 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802171:	eb 23                	jmp    802196 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802173:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802176:	8d 50 01             	lea    0x1(%eax),%edx
  802179:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80217c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80217f:	8d 4a 01             	lea    0x1(%edx),%ecx
  802182:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802185:	8a 12                	mov    (%edx),%dl
  802187:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802189:	8b 45 10             	mov    0x10(%ebp),%eax
  80218c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80218f:	89 55 10             	mov    %edx,0x10(%ebp)
  802192:	85 c0                	test   %eax,%eax
  802194:	75 dd                	jne    802173 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8021a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021aa:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8021ad:	eb 2a                	jmp    8021d9 <memcmp+0x3e>
		if (*s1 != *s2)
  8021af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b2:	8a 10                	mov    (%eax),%dl
  8021b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021b7:	8a 00                	mov    (%eax),%al
  8021b9:	38 c2                	cmp    %al,%dl
  8021bb:	74 16                	je     8021d3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8021bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c0:	8a 00                	mov    (%eax),%al
  8021c2:	0f b6 d0             	movzbl %al,%edx
  8021c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021c8:	8a 00                	mov    (%eax),%al
  8021ca:	0f b6 c0             	movzbl %al,%eax
  8021cd:	29 c2                	sub    %eax,%edx
  8021cf:	89 d0                	mov    %edx,%eax
  8021d1:	eb 18                	jmp    8021eb <memcmp+0x50>
		s1++, s2++;
  8021d3:	ff 45 fc             	incl   -0x4(%ebp)
  8021d6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8021d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8021dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021df:	89 55 10             	mov    %edx,0x10(%ebp)
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	75 c9                	jne    8021af <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8021e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8021f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f9:	01 d0                	add    %edx,%eax
  8021fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8021fe:	eb 15                	jmp    802215 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	8a 00                	mov    (%eax),%al
  802205:	0f b6 d0             	movzbl %al,%edx
  802208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220b:	0f b6 c0             	movzbl %al,%eax
  80220e:	39 c2                	cmp    %eax,%edx
  802210:	74 0d                	je     80221f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802212:	ff 45 08             	incl   0x8(%ebp)
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80221b:	72 e3                	jb     802200 <memfind+0x13>
  80221d:	eb 01                	jmp    802220 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80221f:	90                   	nop
	return (void *) s;
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80222b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802232:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802239:	eb 03                	jmp    80223e <strtol+0x19>
		s++;
  80223b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	8a 00                	mov    (%eax),%al
  802243:	3c 20                	cmp    $0x20,%al
  802245:	74 f4                	je     80223b <strtol+0x16>
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	8a 00                	mov    (%eax),%al
  80224c:	3c 09                	cmp    $0x9,%al
  80224e:	74 eb                	je     80223b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	8a 00                	mov    (%eax),%al
  802255:	3c 2b                	cmp    $0x2b,%al
  802257:	75 05                	jne    80225e <strtol+0x39>
		s++;
  802259:	ff 45 08             	incl   0x8(%ebp)
  80225c:	eb 13                	jmp    802271 <strtol+0x4c>
	else if (*s == '-')
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	8a 00                	mov    (%eax),%al
  802263:	3c 2d                	cmp    $0x2d,%al
  802265:	75 0a                	jne    802271 <strtol+0x4c>
		s++, neg = 1;
  802267:	ff 45 08             	incl   0x8(%ebp)
  80226a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802271:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802275:	74 06                	je     80227d <strtol+0x58>
  802277:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80227b:	75 20                	jne    80229d <strtol+0x78>
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	8a 00                	mov    (%eax),%al
  802282:	3c 30                	cmp    $0x30,%al
  802284:	75 17                	jne    80229d <strtol+0x78>
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	40                   	inc    %eax
  80228a:	8a 00                	mov    (%eax),%al
  80228c:	3c 78                	cmp    $0x78,%al
  80228e:	75 0d                	jne    80229d <strtol+0x78>
		s += 2, base = 16;
  802290:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802294:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80229b:	eb 28                	jmp    8022c5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80229d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022a1:	75 15                	jne    8022b8 <strtol+0x93>
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8a 00                	mov    (%eax),%al
  8022a8:	3c 30                	cmp    $0x30,%al
  8022aa:	75 0c                	jne    8022b8 <strtol+0x93>
		s++, base = 8;
  8022ac:	ff 45 08             	incl   0x8(%ebp)
  8022af:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8022b6:	eb 0d                	jmp    8022c5 <strtol+0xa0>
	else if (base == 0)
  8022b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022bc:	75 07                	jne    8022c5 <strtol+0xa0>
		base = 10;
  8022be:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	8a 00                	mov    (%eax),%al
  8022ca:	3c 2f                	cmp    $0x2f,%al
  8022cc:	7e 19                	jle    8022e7 <strtol+0xc2>
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	8a 00                	mov    (%eax),%al
  8022d3:	3c 39                	cmp    $0x39,%al
  8022d5:	7f 10                	jg     8022e7 <strtol+0xc2>
			dig = *s - '0';
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	8a 00                	mov    (%eax),%al
  8022dc:	0f be c0             	movsbl %al,%eax
  8022df:	83 e8 30             	sub    $0x30,%eax
  8022e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e5:	eb 42                	jmp    802329 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	8a 00                	mov    (%eax),%al
  8022ec:	3c 60                	cmp    $0x60,%al
  8022ee:	7e 19                	jle    802309 <strtol+0xe4>
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	8a 00                	mov    (%eax),%al
  8022f5:	3c 7a                	cmp    $0x7a,%al
  8022f7:	7f 10                	jg     802309 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	8a 00                	mov    (%eax),%al
  8022fe:	0f be c0             	movsbl %al,%eax
  802301:	83 e8 57             	sub    $0x57,%eax
  802304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802307:	eb 20                	jmp    802329 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	8a 00                	mov    (%eax),%al
  80230e:	3c 40                	cmp    $0x40,%al
  802310:	7e 39                	jle    80234b <strtol+0x126>
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	8a 00                	mov    (%eax),%al
  802317:	3c 5a                	cmp    $0x5a,%al
  802319:	7f 30                	jg     80234b <strtol+0x126>
			dig = *s - 'A' + 10;
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	8a 00                	mov    (%eax),%al
  802320:	0f be c0             	movsbl %al,%eax
  802323:	83 e8 37             	sub    $0x37,%eax
  802326:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80232f:	7d 19                	jge    80234a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802331:	ff 45 08             	incl   0x8(%ebp)
  802334:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802337:	0f af 45 10          	imul   0x10(%ebp),%eax
  80233b:	89 c2                	mov    %eax,%edx
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	01 d0                	add    %edx,%eax
  802342:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802345:	e9 7b ff ff ff       	jmp    8022c5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80234a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80234b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80234f:	74 08                	je     802359 <strtol+0x134>
		*endptr = (char *) s;
  802351:	8b 45 0c             	mov    0xc(%ebp),%eax
  802354:	8b 55 08             	mov    0x8(%ebp),%edx
  802357:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802359:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80235d:	74 07                	je     802366 <strtol+0x141>
  80235f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802362:	f7 d8                	neg    %eax
  802364:	eb 03                	jmp    802369 <strtol+0x144>
  802366:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <ltostr>:

void
ltostr(long value, char *str)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802371:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802378:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80237f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802383:	79 13                	jns    802398 <ltostr+0x2d>
	{
		neg = 1;
  802385:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80238c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802392:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802395:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8023a0:	99                   	cltd   
  8023a1:	f7 f9                	idiv   %ecx
  8023a3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8023a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023a9:	8d 50 01             	lea    0x1(%eax),%edx
  8023ac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8023af:	89 c2                	mov    %eax,%edx
  8023b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b4:	01 d0                	add    %edx,%eax
  8023b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023b9:	83 c2 30             	add    $0x30,%edx
  8023bc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8023be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023c1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8023c6:	f7 e9                	imul   %ecx
  8023c8:	c1 fa 02             	sar    $0x2,%edx
  8023cb:	89 c8                	mov    %ecx,%eax
  8023cd:	c1 f8 1f             	sar    $0x1f,%eax
  8023d0:	29 c2                	sub    %eax,%edx
  8023d2:	89 d0                	mov    %edx,%eax
  8023d4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8023d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023da:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8023df:	f7 e9                	imul   %ecx
  8023e1:	c1 fa 02             	sar    $0x2,%edx
  8023e4:	89 c8                	mov    %ecx,%eax
  8023e6:	c1 f8 1f             	sar    $0x1f,%eax
  8023e9:	29 c2                	sub    %eax,%edx
  8023eb:	89 d0                	mov    %edx,%eax
  8023ed:	c1 e0 02             	shl    $0x2,%eax
  8023f0:	01 d0                	add    %edx,%eax
  8023f2:	01 c0                	add    %eax,%eax
  8023f4:	29 c1                	sub    %eax,%ecx
  8023f6:	89 ca                	mov    %ecx,%edx
  8023f8:	85 d2                	test   %edx,%edx
  8023fa:	75 9c                	jne    802398 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8023fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802403:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802406:	48                   	dec    %eax
  802407:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80240a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80240e:	74 3d                	je     80244d <ltostr+0xe2>
		start = 1 ;
  802410:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802417:	eb 34                	jmp    80244d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802419:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241f:	01 d0                	add    %edx,%eax
  802421:	8a 00                	mov    (%eax),%al
  802423:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802426:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802429:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242c:	01 c2                	add    %eax,%edx
  80242e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802431:	8b 45 0c             	mov    0xc(%ebp),%eax
  802434:	01 c8                	add    %ecx,%eax
  802436:	8a 00                	mov    (%eax),%al
  802438:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80243a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80243d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802440:	01 c2                	add    %eax,%edx
  802442:	8a 45 eb             	mov    -0x15(%ebp),%al
  802445:	88 02                	mov    %al,(%edx)
		start++ ;
  802447:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80244a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802453:	7c c4                	jl     802419 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802455:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802458:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245b:	01 d0                	add    %edx,%eax
  80245d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802460:	90                   	nop
  802461:	c9                   	leave  
  802462:	c3                   	ret    

00802463 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
  802466:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802469:	ff 75 08             	pushl  0x8(%ebp)
  80246c:	e8 54 fa ff ff       	call   801ec5 <strlen>
  802471:	83 c4 04             	add    $0x4,%esp
  802474:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802477:	ff 75 0c             	pushl  0xc(%ebp)
  80247a:	e8 46 fa ff ff       	call   801ec5 <strlen>
  80247f:	83 c4 04             	add    $0x4,%esp
  802482:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802485:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80248c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802493:	eb 17                	jmp    8024ac <strcconcat+0x49>
		final[s] = str1[s] ;
  802495:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802498:	8b 45 10             	mov    0x10(%ebp),%eax
  80249b:	01 c2                	add    %eax,%edx
  80249d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	01 c8                	add    %ecx,%eax
  8024a5:	8a 00                	mov    (%eax),%al
  8024a7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8024a9:	ff 45 fc             	incl   -0x4(%ebp)
  8024ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024b2:	7c e1                	jl     802495 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8024b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8024bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8024c2:	eb 1f                	jmp    8024e3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8024c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c7:	8d 50 01             	lea    0x1(%eax),%edx
  8024ca:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8024cd:	89 c2                	mov    %eax,%edx
  8024cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d2:	01 c2                	add    %eax,%edx
  8024d4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8024d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024da:	01 c8                	add    %ecx,%eax
  8024dc:	8a 00                	mov    (%eax),%al
  8024de:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8024e0:	ff 45 f8             	incl   -0x8(%ebp)
  8024e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024e9:	7c d9                	jl     8024c4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8024eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f1:	01 d0                	add    %edx,%eax
  8024f3:	c6 00 00             	movb   $0x0,(%eax)
}
  8024f6:	90                   	nop
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8024fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802505:	8b 45 14             	mov    0x14(%ebp),%eax
  802508:	8b 00                	mov    (%eax),%eax
  80250a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802511:	8b 45 10             	mov    0x10(%ebp),%eax
  802514:	01 d0                	add    %edx,%eax
  802516:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80251c:	eb 0c                	jmp    80252a <strsplit+0x31>
			*string++ = 0;
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	8d 50 01             	lea    0x1(%eax),%edx
  802524:	89 55 08             	mov    %edx,0x8(%ebp)
  802527:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	8a 00                	mov    (%eax),%al
  80252f:	84 c0                	test   %al,%al
  802531:	74 18                	je     80254b <strsplit+0x52>
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	8a 00                	mov    (%eax),%al
  802538:	0f be c0             	movsbl %al,%eax
  80253b:	50                   	push   %eax
  80253c:	ff 75 0c             	pushl  0xc(%ebp)
  80253f:	e8 13 fb ff ff       	call   802057 <strchr>
  802544:	83 c4 08             	add    $0x8,%esp
  802547:	85 c0                	test   %eax,%eax
  802549:	75 d3                	jne    80251e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	8a 00                	mov    (%eax),%al
  802550:	84 c0                	test   %al,%al
  802552:	74 5a                	je     8025ae <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802554:	8b 45 14             	mov    0x14(%ebp),%eax
  802557:	8b 00                	mov    (%eax),%eax
  802559:	83 f8 0f             	cmp    $0xf,%eax
  80255c:	75 07                	jne    802565 <strsplit+0x6c>
		{
			return 0;
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
  802563:	eb 66                	jmp    8025cb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802565:	8b 45 14             	mov    0x14(%ebp),%eax
  802568:	8b 00                	mov    (%eax),%eax
  80256a:	8d 48 01             	lea    0x1(%eax),%ecx
  80256d:	8b 55 14             	mov    0x14(%ebp),%edx
  802570:	89 0a                	mov    %ecx,(%edx)
  802572:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802579:	8b 45 10             	mov    0x10(%ebp),%eax
  80257c:	01 c2                	add    %eax,%edx
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802583:	eb 03                	jmp    802588 <strsplit+0x8f>
			string++;
  802585:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	8a 00                	mov    (%eax),%al
  80258d:	84 c0                	test   %al,%al
  80258f:	74 8b                	je     80251c <strsplit+0x23>
  802591:	8b 45 08             	mov    0x8(%ebp),%eax
  802594:	8a 00                	mov    (%eax),%al
  802596:	0f be c0             	movsbl %al,%eax
  802599:	50                   	push   %eax
  80259a:	ff 75 0c             	pushl  0xc(%ebp)
  80259d:	e8 b5 fa ff ff       	call   802057 <strchr>
  8025a2:	83 c4 08             	add    $0x8,%esp
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	74 dc                	je     802585 <strsplit+0x8c>
			string++;
	}
  8025a9:	e9 6e ff ff ff       	jmp    80251c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8025ae:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8025af:	8b 45 14             	mov    0x14(%ebp),%eax
  8025b2:	8b 00                	mov    (%eax),%eax
  8025b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8025be:	01 d0                	add    %edx,%eax
  8025c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8025c6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    

008025cd <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8025cd:	55                   	push   %ebp
  8025ce:	89 e5                	mov    %esp,%ebp
  8025d0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8025d3:	a1 04 50 80 00       	mov    0x805004,%eax
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	74 1f                	je     8025fb <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8025dc:	e8 1d 00 00 00       	call   8025fe <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8025e1:	83 ec 0c             	sub    $0xc,%esp
  8025e4:	68 30 4d 80 00       	push   $0x804d30
  8025e9:	e8 55 f2 ff ff       	call   801843 <cprintf>
  8025ee:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8025f1:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8025f8:	00 00 00 
	}
}
  8025fb:	90                   	nop
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
  802601:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  802604:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80260b:	00 00 00 
  80260e:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802615:	00 00 00 
  802618:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80261f:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  802622:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802629:	00 00 00 
  80262c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  802633:	00 00 00 
  802636:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80263d:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  802640:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80264f:	2d 00 10 00 00       	sub    $0x1000,%eax
  802654:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  802659:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  802660:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  802663:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80266a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266d:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  802672:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802675:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802678:	ba 00 00 00 00       	mov    $0x0,%edx
  80267d:	f7 75 f0             	divl   -0x10(%ebp)
  802680:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802683:	29 d0                	sub    %edx,%eax
  802685:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  802688:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80268f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802692:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802697:	2d 00 10 00 00       	sub    $0x1000,%eax
  80269c:	83 ec 04             	sub    $0x4,%esp
  80269f:	6a 06                	push   $0x6
  8026a1:	ff 75 e8             	pushl  -0x18(%ebp)
  8026a4:	50                   	push   %eax
  8026a5:	e8 d4 05 00 00       	call   802c7e <sys_allocate_chunk>
  8026aa:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8026ad:	a1 20 51 80 00       	mov    0x805120,%eax
  8026b2:	83 ec 0c             	sub    $0xc,%esp
  8026b5:	50                   	push   %eax
  8026b6:	e8 49 0c 00 00       	call   803304 <initialize_MemBlocksList>
  8026bb:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8026be:	a1 48 51 80 00       	mov    0x805148,%eax
  8026c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8026c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8026ca:	75 14                	jne    8026e0 <initialize_dyn_block_system+0xe2>
  8026cc:	83 ec 04             	sub    $0x4,%esp
  8026cf:	68 55 4d 80 00       	push   $0x804d55
  8026d4:	6a 39                	push   $0x39
  8026d6:	68 73 4d 80 00       	push   $0x804d73
  8026db:	e8 af ee ff ff       	call   80158f <_panic>
  8026e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e3:	8b 00                	mov    (%eax),%eax
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	74 10                	je     8026f9 <initialize_dyn_block_system+0xfb>
  8026e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ec:	8b 00                	mov    (%eax),%eax
  8026ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026f1:	8b 52 04             	mov    0x4(%edx),%edx
  8026f4:	89 50 04             	mov    %edx,0x4(%eax)
  8026f7:	eb 0b                	jmp    802704 <initialize_dyn_block_system+0x106>
  8026f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fc:	8b 40 04             	mov    0x4(%eax),%eax
  8026ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802704:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802707:	8b 40 04             	mov    0x4(%eax),%eax
  80270a:	85 c0                	test   %eax,%eax
  80270c:	74 0f                	je     80271d <initialize_dyn_block_system+0x11f>
  80270e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802711:	8b 40 04             	mov    0x4(%eax),%eax
  802714:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802717:	8b 12                	mov    (%edx),%edx
  802719:	89 10                	mov    %edx,(%eax)
  80271b:	eb 0a                	jmp    802727 <initialize_dyn_block_system+0x129>
  80271d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802720:	8b 00                	mov    (%eax),%eax
  802722:	a3 48 51 80 00       	mov    %eax,0x805148
  802727:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80272a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802730:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802733:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273a:	a1 54 51 80 00       	mov    0x805154,%eax
  80273f:	48                   	dec    %eax
  802740:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  802745:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802748:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80274f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802752:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  802759:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80275d:	75 14                	jne    802773 <initialize_dyn_block_system+0x175>
  80275f:	83 ec 04             	sub    $0x4,%esp
  802762:	68 80 4d 80 00       	push   $0x804d80
  802767:	6a 3f                	push   $0x3f
  802769:	68 73 4d 80 00       	push   $0x804d73
  80276e:	e8 1c ee ff ff       	call   80158f <_panic>
  802773:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802779:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277c:	89 10                	mov    %edx,(%eax)
  80277e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802781:	8b 00                	mov    (%eax),%eax
  802783:	85 c0                	test   %eax,%eax
  802785:	74 0d                	je     802794 <initialize_dyn_block_system+0x196>
  802787:	a1 38 51 80 00       	mov    0x805138,%eax
  80278c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80278f:	89 50 04             	mov    %edx,0x4(%eax)
  802792:	eb 08                	jmp    80279c <initialize_dyn_block_system+0x19e>
  802794:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802797:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80279c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279f:	a3 38 51 80 00       	mov    %eax,0x805138
  8027a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ae:	a1 44 51 80 00       	mov    0x805144,%eax
  8027b3:	40                   	inc    %eax
  8027b4:	a3 44 51 80 00       	mov    %eax,0x805144

}
  8027b9:	90                   	nop
  8027ba:	c9                   	leave  
  8027bb:	c3                   	ret    

008027bc <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8027bc:	55                   	push   %ebp
  8027bd:	89 e5                	mov    %esp,%ebp
  8027bf:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8027c2:	e8 06 fe ff ff       	call   8025cd <InitializeUHeap>
	if (size == 0) return NULL ;
  8027c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027cb:	75 07                	jne    8027d4 <malloc+0x18>
  8027cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d2:	eb 7d                	jmp    802851 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8027d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8027db:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8027e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e8:	01 d0                	add    %edx,%eax
  8027ea:	48                   	dec    %eax
  8027eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8027f6:	f7 75 f0             	divl   -0x10(%ebp)
  8027f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fc:	29 d0                	sub    %edx,%eax
  8027fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  802801:	e8 46 08 00 00       	call   80304c <sys_isUHeapPlacementStrategyFIRSTFIT>
  802806:	83 f8 01             	cmp    $0x1,%eax
  802809:	75 07                	jne    802812 <malloc+0x56>
  80280b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  802812:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802816:	75 34                	jne    80284c <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  802818:	83 ec 0c             	sub    $0xc,%esp
  80281b:	ff 75 e8             	pushl  -0x18(%ebp)
  80281e:	e8 73 0e 00 00       	call   803696 <alloc_block_FF>
  802823:	83 c4 10             	add    $0x10,%esp
  802826:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  802829:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80282d:	74 16                	je     802845 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  80282f:	83 ec 0c             	sub    $0xc,%esp
  802832:	ff 75 e4             	pushl  -0x1c(%ebp)
  802835:	e8 ff 0b 00 00       	call   803439 <insert_sorted_allocList>
  80283a:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  80283d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802840:	8b 40 08             	mov    0x8(%eax),%eax
  802843:	eb 0c                	jmp    802851 <malloc+0x95>
	             }
	             else
	             	return NULL;
  802845:	b8 00 00 00 00       	mov    $0x0,%eax
  80284a:	eb 05                	jmp    802851 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80284c:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  802851:	c9                   	leave  
  802852:	c3                   	ret    

00802853 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802853:	55                   	push   %ebp
  802854:	89 e5                	mov    %esp,%ebp
  802856:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  802859:	8b 45 08             	mov    0x8(%ebp),%eax
  80285c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802868:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80286d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  802870:	83 ec 08             	sub    $0x8,%esp
  802873:	ff 75 f4             	pushl  -0xc(%ebp)
  802876:	68 40 50 80 00       	push   $0x805040
  80287b:	e8 61 0b 00 00       	call   8033e1 <find_block>
  802880:	83 c4 10             	add    $0x10,%esp
  802883:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  802886:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80288a:	0f 84 a5 00 00 00    	je     802935 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  802890:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802893:	8b 40 0c             	mov    0xc(%eax),%eax
  802896:	83 ec 08             	sub    $0x8,%esp
  802899:	50                   	push   %eax
  80289a:	ff 75 f4             	pushl  -0xc(%ebp)
  80289d:	e8 a4 03 00 00       	call   802c46 <sys_free_user_mem>
  8028a2:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8028a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028a9:	75 17                	jne    8028c2 <free+0x6f>
  8028ab:	83 ec 04             	sub    $0x4,%esp
  8028ae:	68 55 4d 80 00       	push   $0x804d55
  8028b3:	68 87 00 00 00       	push   $0x87
  8028b8:	68 73 4d 80 00       	push   $0x804d73
  8028bd:	e8 cd ec ff ff       	call   80158f <_panic>
  8028c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	85 c0                	test   %eax,%eax
  8028c9:	74 10                	je     8028db <free+0x88>
  8028cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ce:	8b 00                	mov    (%eax),%eax
  8028d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028d3:	8b 52 04             	mov    0x4(%edx),%edx
  8028d6:	89 50 04             	mov    %edx,0x4(%eax)
  8028d9:	eb 0b                	jmp    8028e6 <free+0x93>
  8028db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028de:	8b 40 04             	mov    0x4(%eax),%eax
  8028e1:	a3 44 50 80 00       	mov    %eax,0x805044
  8028e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e9:	8b 40 04             	mov    0x4(%eax),%eax
  8028ec:	85 c0                	test   %eax,%eax
  8028ee:	74 0f                	je     8028ff <free+0xac>
  8028f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f3:	8b 40 04             	mov    0x4(%eax),%eax
  8028f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028f9:	8b 12                	mov    (%edx),%edx
  8028fb:	89 10                	mov    %edx,(%eax)
  8028fd:	eb 0a                	jmp    802909 <free+0xb6>
  8028ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802902:	8b 00                	mov    (%eax),%eax
  802904:	a3 40 50 80 00       	mov    %eax,0x805040
  802909:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802912:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802915:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802921:	48                   	dec    %eax
  802922:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  802927:	83 ec 0c             	sub    $0xc,%esp
  80292a:	ff 75 ec             	pushl  -0x14(%ebp)
  80292d:	e8 37 12 00 00       	call   803b69 <insert_sorted_with_merge_freeList>
  802932:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  802935:	90                   	nop
  802936:	c9                   	leave  
  802937:	c3                   	ret    

00802938 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802938:	55                   	push   %ebp
  802939:	89 e5                	mov    %esp,%ebp
  80293b:	83 ec 38             	sub    $0x38,%esp
  80293e:	8b 45 10             	mov    0x10(%ebp),%eax
  802941:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802944:	e8 84 fc ff ff       	call   8025cd <InitializeUHeap>
	if (size == 0) return NULL ;
  802949:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80294d:	75 07                	jne    802956 <smalloc+0x1e>
  80294f:	b8 00 00 00 00       	mov    $0x0,%eax
  802954:	eb 7e                	jmp    8029d4 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  802956:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80295d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802964:	8b 55 0c             	mov    0xc(%ebp),%edx
  802967:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296a:	01 d0                	add    %edx,%eax
  80296c:	48                   	dec    %eax
  80296d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802970:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802973:	ba 00 00 00 00       	mov    $0x0,%edx
  802978:	f7 75 f0             	divl   -0x10(%ebp)
  80297b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297e:	29 d0                	sub    %edx,%eax
  802980:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  802983:	e8 c4 06 00 00       	call   80304c <sys_isUHeapPlacementStrategyFIRSTFIT>
  802988:	83 f8 01             	cmp    $0x1,%eax
  80298b:	75 42                	jne    8029cf <smalloc+0x97>

		  va = malloc(newsize) ;
  80298d:	83 ec 0c             	sub    $0xc,%esp
  802990:	ff 75 e8             	pushl  -0x18(%ebp)
  802993:	e8 24 fe ff ff       	call   8027bc <malloc>
  802998:	83 c4 10             	add    $0x10,%esp
  80299b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  80299e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029a2:	74 24                	je     8029c8 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8029a4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8029a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029ab:	50                   	push   %eax
  8029ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8029af:	ff 75 08             	pushl  0x8(%ebp)
  8029b2:	e8 1a 04 00 00       	call   802dd1 <sys_createSharedObject>
  8029b7:	83 c4 10             	add    $0x10,%esp
  8029ba:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8029bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8029c1:	78 0c                	js     8029cf <smalloc+0x97>
					  return va ;
  8029c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c6:	eb 0c                	jmp    8029d4 <smalloc+0x9c>
				 }
				 else
					return NULL;
  8029c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029cd:	eb 05                	jmp    8029d4 <smalloc+0x9c>
	  }
		  return NULL ;
  8029cf:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8029d4:	c9                   	leave  
  8029d5:	c3                   	ret    

008029d6 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8029d6:	55                   	push   %ebp
  8029d7:	89 e5                	mov    %esp,%ebp
  8029d9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8029dc:	e8 ec fb ff ff       	call   8025cd <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8029e1:	83 ec 08             	sub    $0x8,%esp
  8029e4:	ff 75 0c             	pushl  0xc(%ebp)
  8029e7:	ff 75 08             	pushl  0x8(%ebp)
  8029ea:	e8 0c 04 00 00       	call   802dfb <sys_getSizeOfSharedObject>
  8029ef:	83 c4 10             	add    $0x10,%esp
  8029f2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8029f5:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8029f9:	75 07                	jne    802a02 <sget+0x2c>
  8029fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802a00:	eb 75                	jmp    802a77 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  802a02:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802a09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0f:	01 d0                	add    %edx,%eax
  802a11:	48                   	dec    %eax
  802a12:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802a15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a18:	ba 00 00 00 00       	mov    $0x0,%edx
  802a1d:	f7 75 f0             	divl   -0x10(%ebp)
  802a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a23:	29 d0                	sub    %edx,%eax
  802a25:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  802a28:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  802a2f:	e8 18 06 00 00       	call   80304c <sys_isUHeapPlacementStrategyFIRSTFIT>
  802a34:	83 f8 01             	cmp    $0x1,%eax
  802a37:	75 39                	jne    802a72 <sget+0x9c>

		  va = malloc(newsize) ;
  802a39:	83 ec 0c             	sub    $0xc,%esp
  802a3c:	ff 75 e8             	pushl  -0x18(%ebp)
  802a3f:	e8 78 fd ff ff       	call   8027bc <malloc>
  802a44:	83 c4 10             	add    $0x10,%esp
  802a47:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  802a4a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a4e:	74 22                	je     802a72 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  802a50:	83 ec 04             	sub    $0x4,%esp
  802a53:	ff 75 e0             	pushl  -0x20(%ebp)
  802a56:	ff 75 0c             	pushl  0xc(%ebp)
  802a59:	ff 75 08             	pushl  0x8(%ebp)
  802a5c:	e8 b7 03 00 00       	call   802e18 <sys_getSharedObject>
  802a61:	83 c4 10             	add    $0x10,%esp
  802a64:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  802a67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802a6b:	78 05                	js     802a72 <sget+0x9c>
					  return va;
  802a6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a70:	eb 05                	jmp    802a77 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  802a72:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  802a77:	c9                   	leave  
  802a78:	c3                   	ret    

00802a79 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802a79:	55                   	push   %ebp
  802a7a:	89 e5                	mov    %esp,%ebp
  802a7c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802a7f:	e8 49 fb ff ff       	call   8025cd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802a84:	83 ec 04             	sub    $0x4,%esp
  802a87:	68 a4 4d 80 00       	push   $0x804da4
  802a8c:	68 1e 01 00 00       	push   $0x11e
  802a91:	68 73 4d 80 00       	push   $0x804d73
  802a96:	e8 f4 ea ff ff       	call   80158f <_panic>

00802a9b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802a9b:	55                   	push   %ebp
  802a9c:	89 e5                	mov    %esp,%ebp
  802a9e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802aa1:	83 ec 04             	sub    $0x4,%esp
  802aa4:	68 cc 4d 80 00       	push   $0x804dcc
  802aa9:	68 32 01 00 00       	push   $0x132
  802aae:	68 73 4d 80 00       	push   $0x804d73
  802ab3:	e8 d7 ea ff ff       	call   80158f <_panic>

00802ab8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802ab8:	55                   	push   %ebp
  802ab9:	89 e5                	mov    %esp,%ebp
  802abb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802abe:	83 ec 04             	sub    $0x4,%esp
  802ac1:	68 f0 4d 80 00       	push   $0x804df0
  802ac6:	68 3d 01 00 00       	push   $0x13d
  802acb:	68 73 4d 80 00       	push   $0x804d73
  802ad0:	e8 ba ea ff ff       	call   80158f <_panic>

00802ad5 <shrink>:

}
void shrink(uint32 newSize)
{
  802ad5:	55                   	push   %ebp
  802ad6:	89 e5                	mov    %esp,%ebp
  802ad8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802adb:	83 ec 04             	sub    $0x4,%esp
  802ade:	68 f0 4d 80 00       	push   $0x804df0
  802ae3:	68 42 01 00 00       	push   $0x142
  802ae8:	68 73 4d 80 00       	push   $0x804d73
  802aed:	e8 9d ea ff ff       	call   80158f <_panic>

00802af2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802af2:	55                   	push   %ebp
  802af3:	89 e5                	mov    %esp,%ebp
  802af5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802af8:	83 ec 04             	sub    $0x4,%esp
  802afb:	68 f0 4d 80 00       	push   $0x804df0
  802b00:	68 47 01 00 00       	push   $0x147
  802b05:	68 73 4d 80 00       	push   $0x804d73
  802b0a:	e8 80 ea ff ff       	call   80158f <_panic>

00802b0f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802b0f:	55                   	push   %ebp
  802b10:	89 e5                	mov    %esp,%ebp
  802b12:	57                   	push   %edi
  802b13:	56                   	push   %esi
  802b14:	53                   	push   %ebx
  802b15:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b21:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802b24:	8b 7d 18             	mov    0x18(%ebp),%edi
  802b27:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802b2a:	cd 30                	int    $0x30
  802b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802b32:	83 c4 10             	add    $0x10,%esp
  802b35:	5b                   	pop    %ebx
  802b36:	5e                   	pop    %esi
  802b37:	5f                   	pop    %edi
  802b38:	5d                   	pop    %ebp
  802b39:	c3                   	ret    

00802b3a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802b3a:	55                   	push   %ebp
  802b3b:	89 e5                	mov    %esp,%ebp
  802b3d:	83 ec 04             	sub    $0x4,%esp
  802b40:	8b 45 10             	mov    0x10(%ebp),%eax
  802b43:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802b46:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	6a 00                	push   $0x0
  802b4f:	6a 00                	push   $0x0
  802b51:	52                   	push   %edx
  802b52:	ff 75 0c             	pushl  0xc(%ebp)
  802b55:	50                   	push   %eax
  802b56:	6a 00                	push   $0x0
  802b58:	e8 b2 ff ff ff       	call   802b0f <syscall>
  802b5d:	83 c4 18             	add    $0x18,%esp
}
  802b60:	90                   	nop
  802b61:	c9                   	leave  
  802b62:	c3                   	ret    

00802b63 <sys_cgetc>:

int
sys_cgetc(void)
{
  802b63:	55                   	push   %ebp
  802b64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802b66:	6a 00                	push   $0x0
  802b68:	6a 00                	push   $0x0
  802b6a:	6a 00                	push   $0x0
  802b6c:	6a 00                	push   $0x0
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 01                	push   $0x1
  802b72:	e8 98 ff ff ff       	call   802b0f <syscall>
  802b77:	83 c4 18             	add    $0x18,%esp
}
  802b7a:	c9                   	leave  
  802b7b:	c3                   	ret    

00802b7c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802b7c:	55                   	push   %ebp
  802b7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	6a 00                	push   $0x0
  802b87:	6a 00                	push   $0x0
  802b89:	6a 00                	push   $0x0
  802b8b:	52                   	push   %edx
  802b8c:	50                   	push   %eax
  802b8d:	6a 05                	push   $0x5
  802b8f:	e8 7b ff ff ff       	call   802b0f <syscall>
  802b94:	83 c4 18             	add    $0x18,%esp
}
  802b97:	c9                   	leave  
  802b98:	c3                   	ret    

00802b99 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802b99:	55                   	push   %ebp
  802b9a:	89 e5                	mov    %esp,%ebp
  802b9c:	56                   	push   %esi
  802b9d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802b9e:	8b 75 18             	mov    0x18(%ebp),%esi
  802ba1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ba4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	56                   	push   %esi
  802bae:	53                   	push   %ebx
  802baf:	51                   	push   %ecx
  802bb0:	52                   	push   %edx
  802bb1:	50                   	push   %eax
  802bb2:	6a 06                	push   $0x6
  802bb4:	e8 56 ff ff ff       	call   802b0f <syscall>
  802bb9:	83 c4 18             	add    $0x18,%esp
}
  802bbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802bbf:	5b                   	pop    %ebx
  802bc0:	5e                   	pop    %esi
  802bc1:	5d                   	pop    %ebp
  802bc2:	c3                   	ret    

00802bc3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802bc3:	55                   	push   %ebp
  802bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	6a 00                	push   $0x0
  802bce:	6a 00                	push   $0x0
  802bd0:	6a 00                	push   $0x0
  802bd2:	52                   	push   %edx
  802bd3:	50                   	push   %eax
  802bd4:	6a 07                	push   $0x7
  802bd6:	e8 34 ff ff ff       	call   802b0f <syscall>
  802bdb:	83 c4 18             	add    $0x18,%esp
}
  802bde:	c9                   	leave  
  802bdf:	c3                   	ret    

00802be0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802be0:	55                   	push   %ebp
  802be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802be3:	6a 00                	push   $0x0
  802be5:	6a 00                	push   $0x0
  802be7:	6a 00                	push   $0x0
  802be9:	ff 75 0c             	pushl  0xc(%ebp)
  802bec:	ff 75 08             	pushl  0x8(%ebp)
  802bef:	6a 08                	push   $0x8
  802bf1:	e8 19 ff ff ff       	call   802b0f <syscall>
  802bf6:	83 c4 18             	add    $0x18,%esp
}
  802bf9:	c9                   	leave  
  802bfa:	c3                   	ret    

00802bfb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802bfb:	55                   	push   %ebp
  802bfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802bfe:	6a 00                	push   $0x0
  802c00:	6a 00                	push   $0x0
  802c02:	6a 00                	push   $0x0
  802c04:	6a 00                	push   $0x0
  802c06:	6a 00                	push   $0x0
  802c08:	6a 09                	push   $0x9
  802c0a:	e8 00 ff ff ff       	call   802b0f <syscall>
  802c0f:	83 c4 18             	add    $0x18,%esp
}
  802c12:	c9                   	leave  
  802c13:	c3                   	ret    

00802c14 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802c14:	55                   	push   %ebp
  802c15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802c17:	6a 00                	push   $0x0
  802c19:	6a 00                	push   $0x0
  802c1b:	6a 00                	push   $0x0
  802c1d:	6a 00                	push   $0x0
  802c1f:	6a 00                	push   $0x0
  802c21:	6a 0a                	push   $0xa
  802c23:	e8 e7 fe ff ff       	call   802b0f <syscall>
  802c28:	83 c4 18             	add    $0x18,%esp
}
  802c2b:	c9                   	leave  
  802c2c:	c3                   	ret    

00802c2d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802c2d:	55                   	push   %ebp
  802c2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802c30:	6a 00                	push   $0x0
  802c32:	6a 00                	push   $0x0
  802c34:	6a 00                	push   $0x0
  802c36:	6a 00                	push   $0x0
  802c38:	6a 00                	push   $0x0
  802c3a:	6a 0b                	push   $0xb
  802c3c:	e8 ce fe ff ff       	call   802b0f <syscall>
  802c41:	83 c4 18             	add    $0x18,%esp
}
  802c44:	c9                   	leave  
  802c45:	c3                   	ret    

00802c46 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802c46:	55                   	push   %ebp
  802c47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802c49:	6a 00                	push   $0x0
  802c4b:	6a 00                	push   $0x0
  802c4d:	6a 00                	push   $0x0
  802c4f:	ff 75 0c             	pushl  0xc(%ebp)
  802c52:	ff 75 08             	pushl  0x8(%ebp)
  802c55:	6a 0f                	push   $0xf
  802c57:	e8 b3 fe ff ff       	call   802b0f <syscall>
  802c5c:	83 c4 18             	add    $0x18,%esp
	return;
  802c5f:	90                   	nop
}
  802c60:	c9                   	leave  
  802c61:	c3                   	ret    

00802c62 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802c62:	55                   	push   %ebp
  802c63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802c65:	6a 00                	push   $0x0
  802c67:	6a 00                	push   $0x0
  802c69:	6a 00                	push   $0x0
  802c6b:	ff 75 0c             	pushl  0xc(%ebp)
  802c6e:	ff 75 08             	pushl  0x8(%ebp)
  802c71:	6a 10                	push   $0x10
  802c73:	e8 97 fe ff ff       	call   802b0f <syscall>
  802c78:	83 c4 18             	add    $0x18,%esp
	return ;
  802c7b:	90                   	nop
}
  802c7c:	c9                   	leave  
  802c7d:	c3                   	ret    

00802c7e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802c7e:	55                   	push   %ebp
  802c7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802c81:	6a 00                	push   $0x0
  802c83:	6a 00                	push   $0x0
  802c85:	ff 75 10             	pushl  0x10(%ebp)
  802c88:	ff 75 0c             	pushl  0xc(%ebp)
  802c8b:	ff 75 08             	pushl  0x8(%ebp)
  802c8e:	6a 11                	push   $0x11
  802c90:	e8 7a fe ff ff       	call   802b0f <syscall>
  802c95:	83 c4 18             	add    $0x18,%esp
	return ;
  802c98:	90                   	nop
}
  802c99:	c9                   	leave  
  802c9a:	c3                   	ret    

00802c9b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802c9b:	55                   	push   %ebp
  802c9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802c9e:	6a 00                	push   $0x0
  802ca0:	6a 00                	push   $0x0
  802ca2:	6a 00                	push   $0x0
  802ca4:	6a 00                	push   $0x0
  802ca6:	6a 00                	push   $0x0
  802ca8:	6a 0c                	push   $0xc
  802caa:	e8 60 fe ff ff       	call   802b0f <syscall>
  802caf:	83 c4 18             	add    $0x18,%esp
}
  802cb2:	c9                   	leave  
  802cb3:	c3                   	ret    

00802cb4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802cb4:	55                   	push   %ebp
  802cb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802cb7:	6a 00                	push   $0x0
  802cb9:	6a 00                	push   $0x0
  802cbb:	6a 00                	push   $0x0
  802cbd:	6a 00                	push   $0x0
  802cbf:	ff 75 08             	pushl  0x8(%ebp)
  802cc2:	6a 0d                	push   $0xd
  802cc4:	e8 46 fe ff ff       	call   802b0f <syscall>
  802cc9:	83 c4 18             	add    $0x18,%esp
}
  802ccc:	c9                   	leave  
  802ccd:	c3                   	ret    

00802cce <sys_scarce_memory>:

void sys_scarce_memory()
{
  802cce:	55                   	push   %ebp
  802ccf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802cd1:	6a 00                	push   $0x0
  802cd3:	6a 00                	push   $0x0
  802cd5:	6a 00                	push   $0x0
  802cd7:	6a 00                	push   $0x0
  802cd9:	6a 00                	push   $0x0
  802cdb:	6a 0e                	push   $0xe
  802cdd:	e8 2d fe ff ff       	call   802b0f <syscall>
  802ce2:	83 c4 18             	add    $0x18,%esp
}
  802ce5:	90                   	nop
  802ce6:	c9                   	leave  
  802ce7:	c3                   	ret    

00802ce8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802ce8:	55                   	push   %ebp
  802ce9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802ceb:	6a 00                	push   $0x0
  802ced:	6a 00                	push   $0x0
  802cef:	6a 00                	push   $0x0
  802cf1:	6a 00                	push   $0x0
  802cf3:	6a 00                	push   $0x0
  802cf5:	6a 13                	push   $0x13
  802cf7:	e8 13 fe ff ff       	call   802b0f <syscall>
  802cfc:	83 c4 18             	add    $0x18,%esp
}
  802cff:	90                   	nop
  802d00:	c9                   	leave  
  802d01:	c3                   	ret    

00802d02 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802d02:	55                   	push   %ebp
  802d03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802d05:	6a 00                	push   $0x0
  802d07:	6a 00                	push   $0x0
  802d09:	6a 00                	push   $0x0
  802d0b:	6a 00                	push   $0x0
  802d0d:	6a 00                	push   $0x0
  802d0f:	6a 14                	push   $0x14
  802d11:	e8 f9 fd ff ff       	call   802b0f <syscall>
  802d16:	83 c4 18             	add    $0x18,%esp
}
  802d19:	90                   	nop
  802d1a:	c9                   	leave  
  802d1b:	c3                   	ret    

00802d1c <sys_cputc>:


void
sys_cputc(const char c)
{
  802d1c:	55                   	push   %ebp
  802d1d:	89 e5                	mov    %esp,%ebp
  802d1f:	83 ec 04             	sub    $0x4,%esp
  802d22:	8b 45 08             	mov    0x8(%ebp),%eax
  802d25:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802d28:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802d2c:	6a 00                	push   $0x0
  802d2e:	6a 00                	push   $0x0
  802d30:	6a 00                	push   $0x0
  802d32:	6a 00                	push   $0x0
  802d34:	50                   	push   %eax
  802d35:	6a 15                	push   $0x15
  802d37:	e8 d3 fd ff ff       	call   802b0f <syscall>
  802d3c:	83 c4 18             	add    $0x18,%esp
}
  802d3f:	90                   	nop
  802d40:	c9                   	leave  
  802d41:	c3                   	ret    

00802d42 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802d42:	55                   	push   %ebp
  802d43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802d45:	6a 00                	push   $0x0
  802d47:	6a 00                	push   $0x0
  802d49:	6a 00                	push   $0x0
  802d4b:	6a 00                	push   $0x0
  802d4d:	6a 00                	push   $0x0
  802d4f:	6a 16                	push   $0x16
  802d51:	e8 b9 fd ff ff       	call   802b0f <syscall>
  802d56:	83 c4 18             	add    $0x18,%esp
}
  802d59:	90                   	nop
  802d5a:	c9                   	leave  
  802d5b:	c3                   	ret    

00802d5c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802d5c:	55                   	push   %ebp
  802d5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	6a 00                	push   $0x0
  802d64:	6a 00                	push   $0x0
  802d66:	6a 00                	push   $0x0
  802d68:	ff 75 0c             	pushl  0xc(%ebp)
  802d6b:	50                   	push   %eax
  802d6c:	6a 17                	push   $0x17
  802d6e:	e8 9c fd ff ff       	call   802b0f <syscall>
  802d73:	83 c4 18             	add    $0x18,%esp
}
  802d76:	c9                   	leave  
  802d77:	c3                   	ret    

00802d78 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802d78:	55                   	push   %ebp
  802d79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	6a 00                	push   $0x0
  802d83:	6a 00                	push   $0x0
  802d85:	6a 00                	push   $0x0
  802d87:	52                   	push   %edx
  802d88:	50                   	push   %eax
  802d89:	6a 1a                	push   $0x1a
  802d8b:	e8 7f fd ff ff       	call   802b0f <syscall>
  802d90:	83 c4 18             	add    $0x18,%esp
}
  802d93:	c9                   	leave  
  802d94:	c3                   	ret    

00802d95 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802d95:	55                   	push   %ebp
  802d96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802d98:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	6a 00                	push   $0x0
  802da0:	6a 00                	push   $0x0
  802da2:	6a 00                	push   $0x0
  802da4:	52                   	push   %edx
  802da5:	50                   	push   %eax
  802da6:	6a 18                	push   $0x18
  802da8:	e8 62 fd ff ff       	call   802b0f <syscall>
  802dad:	83 c4 18             	add    $0x18,%esp
}
  802db0:	90                   	nop
  802db1:	c9                   	leave  
  802db2:	c3                   	ret    

00802db3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802db3:	55                   	push   %ebp
  802db4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802db6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	6a 00                	push   $0x0
  802dbe:	6a 00                	push   $0x0
  802dc0:	6a 00                	push   $0x0
  802dc2:	52                   	push   %edx
  802dc3:	50                   	push   %eax
  802dc4:	6a 19                	push   $0x19
  802dc6:	e8 44 fd ff ff       	call   802b0f <syscall>
  802dcb:	83 c4 18             	add    $0x18,%esp
}
  802dce:	90                   	nop
  802dcf:	c9                   	leave  
  802dd0:	c3                   	ret    

00802dd1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802dd1:	55                   	push   %ebp
  802dd2:	89 e5                	mov    %esp,%ebp
  802dd4:	83 ec 04             	sub    $0x4,%esp
  802dd7:	8b 45 10             	mov    0x10(%ebp),%eax
  802dda:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802ddd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802de0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	6a 00                	push   $0x0
  802de9:	51                   	push   %ecx
  802dea:	52                   	push   %edx
  802deb:	ff 75 0c             	pushl  0xc(%ebp)
  802dee:	50                   	push   %eax
  802def:	6a 1b                	push   $0x1b
  802df1:	e8 19 fd ff ff       	call   802b0f <syscall>
  802df6:	83 c4 18             	add    $0x18,%esp
}
  802df9:	c9                   	leave  
  802dfa:	c3                   	ret    

00802dfb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802dfb:	55                   	push   %ebp
  802dfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	6a 00                	push   $0x0
  802e06:	6a 00                	push   $0x0
  802e08:	6a 00                	push   $0x0
  802e0a:	52                   	push   %edx
  802e0b:	50                   	push   %eax
  802e0c:	6a 1c                	push   $0x1c
  802e0e:	e8 fc fc ff ff       	call   802b0f <syscall>
  802e13:	83 c4 18             	add    $0x18,%esp
}
  802e16:	c9                   	leave  
  802e17:	c3                   	ret    

00802e18 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802e18:	55                   	push   %ebp
  802e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802e1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	6a 00                	push   $0x0
  802e26:	6a 00                	push   $0x0
  802e28:	51                   	push   %ecx
  802e29:	52                   	push   %edx
  802e2a:	50                   	push   %eax
  802e2b:	6a 1d                	push   $0x1d
  802e2d:	e8 dd fc ff ff       	call   802b0f <syscall>
  802e32:	83 c4 18             	add    $0x18,%esp
}
  802e35:	c9                   	leave  
  802e36:	c3                   	ret    

00802e37 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802e37:	55                   	push   %ebp
  802e38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	6a 00                	push   $0x0
  802e42:	6a 00                	push   $0x0
  802e44:	6a 00                	push   $0x0
  802e46:	52                   	push   %edx
  802e47:	50                   	push   %eax
  802e48:	6a 1e                	push   $0x1e
  802e4a:	e8 c0 fc ff ff       	call   802b0f <syscall>
  802e4f:	83 c4 18             	add    $0x18,%esp
}
  802e52:	c9                   	leave  
  802e53:	c3                   	ret    

00802e54 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802e54:	55                   	push   %ebp
  802e55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802e57:	6a 00                	push   $0x0
  802e59:	6a 00                	push   $0x0
  802e5b:	6a 00                	push   $0x0
  802e5d:	6a 00                	push   $0x0
  802e5f:	6a 00                	push   $0x0
  802e61:	6a 1f                	push   $0x1f
  802e63:	e8 a7 fc ff ff       	call   802b0f <syscall>
  802e68:	83 c4 18             	add    $0x18,%esp
}
  802e6b:	c9                   	leave  
  802e6c:	c3                   	ret    

00802e6d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802e6d:	55                   	push   %ebp
  802e6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	6a 00                	push   $0x0
  802e75:	ff 75 14             	pushl  0x14(%ebp)
  802e78:	ff 75 10             	pushl  0x10(%ebp)
  802e7b:	ff 75 0c             	pushl  0xc(%ebp)
  802e7e:	50                   	push   %eax
  802e7f:	6a 20                	push   $0x20
  802e81:	e8 89 fc ff ff       	call   802b0f <syscall>
  802e86:	83 c4 18             	add    $0x18,%esp
}
  802e89:	c9                   	leave  
  802e8a:	c3                   	ret    

00802e8b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802e8b:	55                   	push   %ebp
  802e8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	6a 00                	push   $0x0
  802e93:	6a 00                	push   $0x0
  802e95:	6a 00                	push   $0x0
  802e97:	6a 00                	push   $0x0
  802e99:	50                   	push   %eax
  802e9a:	6a 21                	push   $0x21
  802e9c:	e8 6e fc ff ff       	call   802b0f <syscall>
  802ea1:	83 c4 18             	add    $0x18,%esp
}
  802ea4:	90                   	nop
  802ea5:	c9                   	leave  
  802ea6:	c3                   	ret    

00802ea7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802ea7:	55                   	push   %ebp
  802ea8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	6a 00                	push   $0x0
  802eaf:	6a 00                	push   $0x0
  802eb1:	6a 00                	push   $0x0
  802eb3:	6a 00                	push   $0x0
  802eb5:	50                   	push   %eax
  802eb6:	6a 22                	push   $0x22
  802eb8:	e8 52 fc ff ff       	call   802b0f <syscall>
  802ebd:	83 c4 18             	add    $0x18,%esp
}
  802ec0:	c9                   	leave  
  802ec1:	c3                   	ret    

00802ec2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802ec2:	55                   	push   %ebp
  802ec3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802ec5:	6a 00                	push   $0x0
  802ec7:	6a 00                	push   $0x0
  802ec9:	6a 00                	push   $0x0
  802ecb:	6a 00                	push   $0x0
  802ecd:	6a 00                	push   $0x0
  802ecf:	6a 02                	push   $0x2
  802ed1:	e8 39 fc ff ff       	call   802b0f <syscall>
  802ed6:	83 c4 18             	add    $0x18,%esp
}
  802ed9:	c9                   	leave  
  802eda:	c3                   	ret    

00802edb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802edb:	55                   	push   %ebp
  802edc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802ede:	6a 00                	push   $0x0
  802ee0:	6a 00                	push   $0x0
  802ee2:	6a 00                	push   $0x0
  802ee4:	6a 00                	push   $0x0
  802ee6:	6a 00                	push   $0x0
  802ee8:	6a 03                	push   $0x3
  802eea:	e8 20 fc ff ff       	call   802b0f <syscall>
  802eef:	83 c4 18             	add    $0x18,%esp
}
  802ef2:	c9                   	leave  
  802ef3:	c3                   	ret    

00802ef4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802ef4:	55                   	push   %ebp
  802ef5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802ef7:	6a 00                	push   $0x0
  802ef9:	6a 00                	push   $0x0
  802efb:	6a 00                	push   $0x0
  802efd:	6a 00                	push   $0x0
  802eff:	6a 00                	push   $0x0
  802f01:	6a 04                	push   $0x4
  802f03:	e8 07 fc ff ff       	call   802b0f <syscall>
  802f08:	83 c4 18             	add    $0x18,%esp
}
  802f0b:	c9                   	leave  
  802f0c:	c3                   	ret    

00802f0d <sys_exit_env>:


void sys_exit_env(void)
{
  802f0d:	55                   	push   %ebp
  802f0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802f10:	6a 00                	push   $0x0
  802f12:	6a 00                	push   $0x0
  802f14:	6a 00                	push   $0x0
  802f16:	6a 00                	push   $0x0
  802f18:	6a 00                	push   $0x0
  802f1a:	6a 23                	push   $0x23
  802f1c:	e8 ee fb ff ff       	call   802b0f <syscall>
  802f21:	83 c4 18             	add    $0x18,%esp
}
  802f24:	90                   	nop
  802f25:	c9                   	leave  
  802f26:	c3                   	ret    

00802f27 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802f27:	55                   	push   %ebp
  802f28:	89 e5                	mov    %esp,%ebp
  802f2a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802f2d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802f30:	8d 50 04             	lea    0x4(%eax),%edx
  802f33:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802f36:	6a 00                	push   $0x0
  802f38:	6a 00                	push   $0x0
  802f3a:	6a 00                	push   $0x0
  802f3c:	52                   	push   %edx
  802f3d:	50                   	push   %eax
  802f3e:	6a 24                	push   $0x24
  802f40:	e8 ca fb ff ff       	call   802b0f <syscall>
  802f45:	83 c4 18             	add    $0x18,%esp
	return result;
  802f48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802f4e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802f51:	89 01                	mov    %eax,(%ecx)
  802f53:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	c9                   	leave  
  802f5a:	c2 04 00             	ret    $0x4

00802f5d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802f5d:	55                   	push   %ebp
  802f5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802f60:	6a 00                	push   $0x0
  802f62:	6a 00                	push   $0x0
  802f64:	ff 75 10             	pushl  0x10(%ebp)
  802f67:	ff 75 0c             	pushl  0xc(%ebp)
  802f6a:	ff 75 08             	pushl  0x8(%ebp)
  802f6d:	6a 12                	push   $0x12
  802f6f:	e8 9b fb ff ff       	call   802b0f <syscall>
  802f74:	83 c4 18             	add    $0x18,%esp
	return ;
  802f77:	90                   	nop
}
  802f78:	c9                   	leave  
  802f79:	c3                   	ret    

00802f7a <sys_rcr2>:
uint32 sys_rcr2()
{
  802f7a:	55                   	push   %ebp
  802f7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802f7d:	6a 00                	push   $0x0
  802f7f:	6a 00                	push   $0x0
  802f81:	6a 00                	push   $0x0
  802f83:	6a 00                	push   $0x0
  802f85:	6a 00                	push   $0x0
  802f87:	6a 25                	push   $0x25
  802f89:	e8 81 fb ff ff       	call   802b0f <syscall>
  802f8e:	83 c4 18             	add    $0x18,%esp
}
  802f91:	c9                   	leave  
  802f92:	c3                   	ret    

00802f93 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802f93:	55                   	push   %ebp
  802f94:	89 e5                	mov    %esp,%ebp
  802f96:	83 ec 04             	sub    $0x4,%esp
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802f9f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802fa3:	6a 00                	push   $0x0
  802fa5:	6a 00                	push   $0x0
  802fa7:	6a 00                	push   $0x0
  802fa9:	6a 00                	push   $0x0
  802fab:	50                   	push   %eax
  802fac:	6a 26                	push   $0x26
  802fae:	e8 5c fb ff ff       	call   802b0f <syscall>
  802fb3:	83 c4 18             	add    $0x18,%esp
	return ;
  802fb6:	90                   	nop
}
  802fb7:	c9                   	leave  
  802fb8:	c3                   	ret    

00802fb9 <rsttst>:
void rsttst()
{
  802fb9:	55                   	push   %ebp
  802fba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802fbc:	6a 00                	push   $0x0
  802fbe:	6a 00                	push   $0x0
  802fc0:	6a 00                	push   $0x0
  802fc2:	6a 00                	push   $0x0
  802fc4:	6a 00                	push   $0x0
  802fc6:	6a 28                	push   $0x28
  802fc8:	e8 42 fb ff ff       	call   802b0f <syscall>
  802fcd:	83 c4 18             	add    $0x18,%esp
	return ;
  802fd0:	90                   	nop
}
  802fd1:	c9                   	leave  
  802fd2:	c3                   	ret    

00802fd3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802fd3:	55                   	push   %ebp
  802fd4:	89 e5                	mov    %esp,%ebp
  802fd6:	83 ec 04             	sub    $0x4,%esp
  802fd9:	8b 45 14             	mov    0x14(%ebp),%eax
  802fdc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802fdf:	8b 55 18             	mov    0x18(%ebp),%edx
  802fe2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802fe6:	52                   	push   %edx
  802fe7:	50                   	push   %eax
  802fe8:	ff 75 10             	pushl  0x10(%ebp)
  802feb:	ff 75 0c             	pushl  0xc(%ebp)
  802fee:	ff 75 08             	pushl  0x8(%ebp)
  802ff1:	6a 27                	push   $0x27
  802ff3:	e8 17 fb ff ff       	call   802b0f <syscall>
  802ff8:	83 c4 18             	add    $0x18,%esp
	return ;
  802ffb:	90                   	nop
}
  802ffc:	c9                   	leave  
  802ffd:	c3                   	ret    

00802ffe <chktst>:
void chktst(uint32 n)
{
  802ffe:	55                   	push   %ebp
  802fff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803001:	6a 00                	push   $0x0
  803003:	6a 00                	push   $0x0
  803005:	6a 00                	push   $0x0
  803007:	6a 00                	push   $0x0
  803009:	ff 75 08             	pushl  0x8(%ebp)
  80300c:	6a 29                	push   $0x29
  80300e:	e8 fc fa ff ff       	call   802b0f <syscall>
  803013:	83 c4 18             	add    $0x18,%esp
	return ;
  803016:	90                   	nop
}
  803017:	c9                   	leave  
  803018:	c3                   	ret    

00803019 <inctst>:

void inctst()
{
  803019:	55                   	push   %ebp
  80301a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80301c:	6a 00                	push   $0x0
  80301e:	6a 00                	push   $0x0
  803020:	6a 00                	push   $0x0
  803022:	6a 00                	push   $0x0
  803024:	6a 00                	push   $0x0
  803026:	6a 2a                	push   $0x2a
  803028:	e8 e2 fa ff ff       	call   802b0f <syscall>
  80302d:	83 c4 18             	add    $0x18,%esp
	return ;
  803030:	90                   	nop
}
  803031:	c9                   	leave  
  803032:	c3                   	ret    

00803033 <gettst>:
uint32 gettst()
{
  803033:	55                   	push   %ebp
  803034:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  803036:	6a 00                	push   $0x0
  803038:	6a 00                	push   $0x0
  80303a:	6a 00                	push   $0x0
  80303c:	6a 00                	push   $0x0
  80303e:	6a 00                	push   $0x0
  803040:	6a 2b                	push   $0x2b
  803042:	e8 c8 fa ff ff       	call   802b0f <syscall>
  803047:	83 c4 18             	add    $0x18,%esp
}
  80304a:	c9                   	leave  
  80304b:	c3                   	ret    

0080304c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80304c:	55                   	push   %ebp
  80304d:	89 e5                	mov    %esp,%ebp
  80304f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803052:	6a 00                	push   $0x0
  803054:	6a 00                	push   $0x0
  803056:	6a 00                	push   $0x0
  803058:	6a 00                	push   $0x0
  80305a:	6a 00                	push   $0x0
  80305c:	6a 2c                	push   $0x2c
  80305e:	e8 ac fa ff ff       	call   802b0f <syscall>
  803063:	83 c4 18             	add    $0x18,%esp
  803066:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  803069:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80306d:	75 07                	jne    803076 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80306f:	b8 01 00 00 00       	mov    $0x1,%eax
  803074:	eb 05                	jmp    80307b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  803076:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80307b:	c9                   	leave  
  80307c:	c3                   	ret    

0080307d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80307d:	55                   	push   %ebp
  80307e:	89 e5                	mov    %esp,%ebp
  803080:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803083:	6a 00                	push   $0x0
  803085:	6a 00                	push   $0x0
  803087:	6a 00                	push   $0x0
  803089:	6a 00                	push   $0x0
  80308b:	6a 00                	push   $0x0
  80308d:	6a 2c                	push   $0x2c
  80308f:	e8 7b fa ff ff       	call   802b0f <syscall>
  803094:	83 c4 18             	add    $0x18,%esp
  803097:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80309a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80309e:	75 07                	jne    8030a7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8030a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8030a5:	eb 05                	jmp    8030ac <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8030a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030ac:	c9                   	leave  
  8030ad:	c3                   	ret    

008030ae <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8030ae:	55                   	push   %ebp
  8030af:	89 e5                	mov    %esp,%ebp
  8030b1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8030b4:	6a 00                	push   $0x0
  8030b6:	6a 00                	push   $0x0
  8030b8:	6a 00                	push   $0x0
  8030ba:	6a 00                	push   $0x0
  8030bc:	6a 00                	push   $0x0
  8030be:	6a 2c                	push   $0x2c
  8030c0:	e8 4a fa ff ff       	call   802b0f <syscall>
  8030c5:	83 c4 18             	add    $0x18,%esp
  8030c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8030cb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8030cf:	75 07                	jne    8030d8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8030d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8030d6:	eb 05                	jmp    8030dd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8030d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030dd:	c9                   	leave  
  8030de:	c3                   	ret    

008030df <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8030df:	55                   	push   %ebp
  8030e0:	89 e5                	mov    %esp,%ebp
  8030e2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8030e5:	6a 00                	push   $0x0
  8030e7:	6a 00                	push   $0x0
  8030e9:	6a 00                	push   $0x0
  8030eb:	6a 00                	push   $0x0
  8030ed:	6a 00                	push   $0x0
  8030ef:	6a 2c                	push   $0x2c
  8030f1:	e8 19 fa ff ff       	call   802b0f <syscall>
  8030f6:	83 c4 18             	add    $0x18,%esp
  8030f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8030fc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  803100:	75 07                	jne    803109 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  803102:	b8 01 00 00 00       	mov    $0x1,%eax
  803107:	eb 05                	jmp    80310e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803109:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80310e:	c9                   	leave  
  80310f:	c3                   	ret    

00803110 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803110:	55                   	push   %ebp
  803111:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803113:	6a 00                	push   $0x0
  803115:	6a 00                	push   $0x0
  803117:	6a 00                	push   $0x0
  803119:	6a 00                	push   $0x0
  80311b:	ff 75 08             	pushl  0x8(%ebp)
  80311e:	6a 2d                	push   $0x2d
  803120:	e8 ea f9 ff ff       	call   802b0f <syscall>
  803125:	83 c4 18             	add    $0x18,%esp
	return ;
  803128:	90                   	nop
}
  803129:	c9                   	leave  
  80312a:	c3                   	ret    

0080312b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80312b:	55                   	push   %ebp
  80312c:	89 e5                	mov    %esp,%ebp
  80312e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80312f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803132:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803135:	8b 55 0c             	mov    0xc(%ebp),%edx
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	6a 00                	push   $0x0
  80313d:	53                   	push   %ebx
  80313e:	51                   	push   %ecx
  80313f:	52                   	push   %edx
  803140:	50                   	push   %eax
  803141:	6a 2e                	push   $0x2e
  803143:	e8 c7 f9 ff ff       	call   802b0f <syscall>
  803148:	83 c4 18             	add    $0x18,%esp
}
  80314b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80314e:	c9                   	leave  
  80314f:	c3                   	ret    

00803150 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803150:	55                   	push   %ebp
  803151:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803153:	8b 55 0c             	mov    0xc(%ebp),%edx
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	6a 00                	push   $0x0
  80315b:	6a 00                	push   $0x0
  80315d:	6a 00                	push   $0x0
  80315f:	52                   	push   %edx
  803160:	50                   	push   %eax
  803161:	6a 2f                	push   $0x2f
  803163:	e8 a7 f9 ff ff       	call   802b0f <syscall>
  803168:	83 c4 18             	add    $0x18,%esp
}
  80316b:	c9                   	leave  
  80316c:	c3                   	ret    

0080316d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80316d:	55                   	push   %ebp
  80316e:	89 e5                	mov    %esp,%ebp
  803170:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  803173:	83 ec 0c             	sub    $0xc,%esp
  803176:	68 00 4e 80 00       	push   $0x804e00
  80317b:	e8 c3 e6 ff ff       	call   801843 <cprintf>
  803180:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  803183:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80318a:	83 ec 0c             	sub    $0xc,%esp
  80318d:	68 2c 4e 80 00       	push   $0x804e2c
  803192:	e8 ac e6 ff ff       	call   801843 <cprintf>
  803197:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80319a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80319e:	a1 38 51 80 00       	mov    0x805138,%eax
  8031a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a6:	eb 56                	jmp    8031fe <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8031a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031ac:	74 1c                	je     8031ca <print_mem_block_lists+0x5d>
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	8b 50 08             	mov    0x8(%eax),%edx
  8031b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b7:	8b 48 08             	mov    0x8(%eax),%ecx
  8031ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c0:	01 c8                	add    %ecx,%eax
  8031c2:	39 c2                	cmp    %eax,%edx
  8031c4:	73 04                	jae    8031ca <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8031c6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8031ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cd:	8b 50 08             	mov    0x8(%eax),%edx
  8031d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d6:	01 c2                	add    %eax,%edx
  8031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031db:	8b 40 08             	mov    0x8(%eax),%eax
  8031de:	83 ec 04             	sub    $0x4,%esp
  8031e1:	52                   	push   %edx
  8031e2:	50                   	push   %eax
  8031e3:	68 41 4e 80 00       	push   $0x804e41
  8031e8:	e8 56 e6 ff ff       	call   801843 <cprintf>
  8031ed:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8031f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8031f6:	a1 40 51 80 00       	mov    0x805140,%eax
  8031fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803202:	74 07                	je     80320b <print_mem_block_lists+0x9e>
  803204:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803207:	8b 00                	mov    (%eax),%eax
  803209:	eb 05                	jmp    803210 <print_mem_block_lists+0xa3>
  80320b:	b8 00 00 00 00       	mov    $0x0,%eax
  803210:	a3 40 51 80 00       	mov    %eax,0x805140
  803215:	a1 40 51 80 00       	mov    0x805140,%eax
  80321a:	85 c0                	test   %eax,%eax
  80321c:	75 8a                	jne    8031a8 <print_mem_block_lists+0x3b>
  80321e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803222:	75 84                	jne    8031a8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  803224:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803228:	75 10                	jne    80323a <print_mem_block_lists+0xcd>
  80322a:	83 ec 0c             	sub    $0xc,%esp
  80322d:	68 50 4e 80 00       	push   $0x804e50
  803232:	e8 0c e6 ff ff       	call   801843 <cprintf>
  803237:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80323a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  803241:	83 ec 0c             	sub    $0xc,%esp
  803244:	68 74 4e 80 00       	push   $0x804e74
  803249:	e8 f5 e5 ff ff       	call   801843 <cprintf>
  80324e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  803251:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803255:	a1 40 50 80 00       	mov    0x805040,%eax
  80325a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80325d:	eb 56                	jmp    8032b5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80325f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803263:	74 1c                	je     803281 <print_mem_block_lists+0x114>
  803265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803268:	8b 50 08             	mov    0x8(%eax),%edx
  80326b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326e:	8b 48 08             	mov    0x8(%eax),%ecx
  803271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803274:	8b 40 0c             	mov    0xc(%eax),%eax
  803277:	01 c8                	add    %ecx,%eax
  803279:	39 c2                	cmp    %eax,%edx
  80327b:	73 04                	jae    803281 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80327d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803284:	8b 50 08             	mov    0x8(%eax),%edx
  803287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328a:	8b 40 0c             	mov    0xc(%eax),%eax
  80328d:	01 c2                	add    %eax,%edx
  80328f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803292:	8b 40 08             	mov    0x8(%eax),%eax
  803295:	83 ec 04             	sub    $0x4,%esp
  803298:	52                   	push   %edx
  803299:	50                   	push   %eax
  80329a:	68 41 4e 80 00       	push   $0x804e41
  80329f:	e8 9f e5 ff ff       	call   801843 <cprintf>
  8032a4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8032a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8032ad:	a1 48 50 80 00       	mov    0x805048,%eax
  8032b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b9:	74 07                	je     8032c2 <print_mem_block_lists+0x155>
  8032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032be:	8b 00                	mov    (%eax),%eax
  8032c0:	eb 05                	jmp    8032c7 <print_mem_block_lists+0x15a>
  8032c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c7:	a3 48 50 80 00       	mov    %eax,0x805048
  8032cc:	a1 48 50 80 00       	mov    0x805048,%eax
  8032d1:	85 c0                	test   %eax,%eax
  8032d3:	75 8a                	jne    80325f <print_mem_block_lists+0xf2>
  8032d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d9:	75 84                	jne    80325f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8032db:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8032df:	75 10                	jne    8032f1 <print_mem_block_lists+0x184>
  8032e1:	83 ec 0c             	sub    $0xc,%esp
  8032e4:	68 8c 4e 80 00       	push   $0x804e8c
  8032e9:	e8 55 e5 ff ff       	call   801843 <cprintf>
  8032ee:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8032f1:	83 ec 0c             	sub    $0xc,%esp
  8032f4:	68 00 4e 80 00       	push   $0x804e00
  8032f9:	e8 45 e5 ff ff       	call   801843 <cprintf>
  8032fe:	83 c4 10             	add    $0x10,%esp

}
  803301:	90                   	nop
  803302:	c9                   	leave  
  803303:	c3                   	ret    

00803304 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  803304:	55                   	push   %ebp
  803305:	89 e5                	mov    %esp,%ebp
  803307:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  80330a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  803311:	00 00 00 
  803314:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80331b:	00 00 00 
  80331e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  803325:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  803328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80332f:	e9 9e 00 00 00       	jmp    8033d2 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  803334:	a1 50 50 80 00       	mov    0x805050,%eax
  803339:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80333c:	c1 e2 04             	shl    $0x4,%edx
  80333f:	01 d0                	add    %edx,%eax
  803341:	85 c0                	test   %eax,%eax
  803343:	75 14                	jne    803359 <initialize_MemBlocksList+0x55>
  803345:	83 ec 04             	sub    $0x4,%esp
  803348:	68 b4 4e 80 00       	push   $0x804eb4
  80334d:	6a 47                	push   $0x47
  80334f:	68 d7 4e 80 00       	push   $0x804ed7
  803354:	e8 36 e2 ff ff       	call   80158f <_panic>
  803359:	a1 50 50 80 00       	mov    0x805050,%eax
  80335e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803361:	c1 e2 04             	shl    $0x4,%edx
  803364:	01 d0                	add    %edx,%eax
  803366:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80336c:	89 10                	mov    %edx,(%eax)
  80336e:	8b 00                	mov    (%eax),%eax
  803370:	85 c0                	test   %eax,%eax
  803372:	74 18                	je     80338c <initialize_MemBlocksList+0x88>
  803374:	a1 48 51 80 00       	mov    0x805148,%eax
  803379:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80337f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803382:	c1 e1 04             	shl    $0x4,%ecx
  803385:	01 ca                	add    %ecx,%edx
  803387:	89 50 04             	mov    %edx,0x4(%eax)
  80338a:	eb 12                	jmp    80339e <initialize_MemBlocksList+0x9a>
  80338c:	a1 50 50 80 00       	mov    0x805050,%eax
  803391:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803394:	c1 e2 04             	shl    $0x4,%edx
  803397:	01 d0                	add    %edx,%eax
  803399:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80339e:	a1 50 50 80 00       	mov    0x805050,%eax
  8033a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033a6:	c1 e2 04             	shl    $0x4,%edx
  8033a9:	01 d0                	add    %edx,%eax
  8033ab:	a3 48 51 80 00       	mov    %eax,0x805148
  8033b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8033b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033b8:	c1 e2 04             	shl    $0x4,%edx
  8033bb:	01 d0                	add    %edx,%eax
  8033bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c4:	a1 54 51 80 00       	mov    0x805154,%eax
  8033c9:	40                   	inc    %eax
  8033ca:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8033cf:	ff 45 f4             	incl   -0xc(%ebp)
  8033d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033d8:	0f 82 56 ff ff ff    	jb     803334 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8033de:	90                   	nop
  8033df:	c9                   	leave  
  8033e0:	c3                   	ret    

008033e1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8033e1:	55                   	push   %ebp
  8033e2:	89 e5                	mov    %esp,%ebp
  8033e4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8033e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ea:	8b 00                	mov    (%eax),%eax
  8033ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8033ef:	eb 19                	jmp    80340a <find_block+0x29>
	{
		if(element->sva == va){
  8033f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033f4:	8b 40 08             	mov    0x8(%eax),%eax
  8033f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033fa:	75 05                	jne    803401 <find_block+0x20>
			 		return element;
  8033fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033ff:	eb 36                	jmp    803437 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  803401:	8b 45 08             	mov    0x8(%ebp),%eax
  803404:	8b 40 08             	mov    0x8(%eax),%eax
  803407:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80340a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80340e:	74 07                	je     803417 <find_block+0x36>
  803410:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803413:	8b 00                	mov    (%eax),%eax
  803415:	eb 05                	jmp    80341c <find_block+0x3b>
  803417:	b8 00 00 00 00       	mov    $0x0,%eax
  80341c:	8b 55 08             	mov    0x8(%ebp),%edx
  80341f:	89 42 08             	mov    %eax,0x8(%edx)
  803422:	8b 45 08             	mov    0x8(%ebp),%eax
  803425:	8b 40 08             	mov    0x8(%eax),%eax
  803428:	85 c0                	test   %eax,%eax
  80342a:	75 c5                	jne    8033f1 <find_block+0x10>
  80342c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803430:	75 bf                	jne    8033f1 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  803432:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803437:	c9                   	leave  
  803438:	c3                   	ret    

00803439 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  803439:	55                   	push   %ebp
  80343a:	89 e5                	mov    %esp,%ebp
  80343c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80343f:	a1 44 50 80 00       	mov    0x805044,%eax
  803444:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  803447:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80344c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80344f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803453:	74 0a                	je     80345f <insert_sorted_allocList+0x26>
  803455:	8b 45 08             	mov    0x8(%ebp),%eax
  803458:	8b 40 08             	mov    0x8(%eax),%eax
  80345b:	85 c0                	test   %eax,%eax
  80345d:	75 65                	jne    8034c4 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80345f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803463:	75 14                	jne    803479 <insert_sorted_allocList+0x40>
  803465:	83 ec 04             	sub    $0x4,%esp
  803468:	68 b4 4e 80 00       	push   $0x804eb4
  80346d:	6a 6e                	push   $0x6e
  80346f:	68 d7 4e 80 00       	push   $0x804ed7
  803474:	e8 16 e1 ff ff       	call   80158f <_panic>
  803479:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80347f:	8b 45 08             	mov    0x8(%ebp),%eax
  803482:	89 10                	mov    %edx,(%eax)
  803484:	8b 45 08             	mov    0x8(%ebp),%eax
  803487:	8b 00                	mov    (%eax),%eax
  803489:	85 c0                	test   %eax,%eax
  80348b:	74 0d                	je     80349a <insert_sorted_allocList+0x61>
  80348d:	a1 40 50 80 00       	mov    0x805040,%eax
  803492:	8b 55 08             	mov    0x8(%ebp),%edx
  803495:	89 50 04             	mov    %edx,0x4(%eax)
  803498:	eb 08                	jmp    8034a2 <insert_sorted_allocList+0x69>
  80349a:	8b 45 08             	mov    0x8(%ebp),%eax
  80349d:	a3 44 50 80 00       	mov    %eax,0x805044
  8034a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a5:	a3 40 50 80 00       	mov    %eax,0x805040
  8034aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8034b9:	40                   	inc    %eax
  8034ba:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8034bf:	e9 cf 01 00 00       	jmp    803693 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8034c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c7:	8b 50 08             	mov    0x8(%eax),%edx
  8034ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cd:	8b 40 08             	mov    0x8(%eax),%eax
  8034d0:	39 c2                	cmp    %eax,%edx
  8034d2:	73 65                	jae    803539 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8034d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034d8:	75 14                	jne    8034ee <insert_sorted_allocList+0xb5>
  8034da:	83 ec 04             	sub    $0x4,%esp
  8034dd:	68 f0 4e 80 00       	push   $0x804ef0
  8034e2:	6a 72                	push   $0x72
  8034e4:	68 d7 4e 80 00       	push   $0x804ed7
  8034e9:	e8 a1 e0 ff ff       	call   80158f <_panic>
  8034ee:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	89 50 04             	mov    %edx,0x4(%eax)
  8034fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fd:	8b 40 04             	mov    0x4(%eax),%eax
  803500:	85 c0                	test   %eax,%eax
  803502:	74 0c                	je     803510 <insert_sorted_allocList+0xd7>
  803504:	a1 44 50 80 00       	mov    0x805044,%eax
  803509:	8b 55 08             	mov    0x8(%ebp),%edx
  80350c:	89 10                	mov    %edx,(%eax)
  80350e:	eb 08                	jmp    803518 <insert_sorted_allocList+0xdf>
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	a3 40 50 80 00       	mov    %eax,0x805040
  803518:	8b 45 08             	mov    0x8(%ebp),%eax
  80351b:	a3 44 50 80 00       	mov    %eax,0x805044
  803520:	8b 45 08             	mov    0x8(%ebp),%eax
  803523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803529:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80352e:	40                   	inc    %eax
  80352f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  803534:	e9 5a 01 00 00       	jmp    803693 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  803539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353c:	8b 50 08             	mov    0x8(%eax),%edx
  80353f:	8b 45 08             	mov    0x8(%ebp),%eax
  803542:	8b 40 08             	mov    0x8(%eax),%eax
  803545:	39 c2                	cmp    %eax,%edx
  803547:	75 70                	jne    8035b9 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  803549:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80354d:	74 06                	je     803555 <insert_sorted_allocList+0x11c>
  80354f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803553:	75 14                	jne    803569 <insert_sorted_allocList+0x130>
  803555:	83 ec 04             	sub    $0x4,%esp
  803558:	68 14 4f 80 00       	push   $0x804f14
  80355d:	6a 75                	push   $0x75
  80355f:	68 d7 4e 80 00       	push   $0x804ed7
  803564:	e8 26 e0 ff ff       	call   80158f <_panic>
  803569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356c:	8b 10                	mov    (%eax),%edx
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	89 10                	mov    %edx,(%eax)
  803573:	8b 45 08             	mov    0x8(%ebp),%eax
  803576:	8b 00                	mov    (%eax),%eax
  803578:	85 c0                	test   %eax,%eax
  80357a:	74 0b                	je     803587 <insert_sorted_allocList+0x14e>
  80357c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357f:	8b 00                	mov    (%eax),%eax
  803581:	8b 55 08             	mov    0x8(%ebp),%edx
  803584:	89 50 04             	mov    %edx,0x4(%eax)
  803587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80358a:	8b 55 08             	mov    0x8(%ebp),%edx
  80358d:	89 10                	mov    %edx,(%eax)
  80358f:	8b 45 08             	mov    0x8(%ebp),%eax
  803592:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803595:	89 50 04             	mov    %edx,0x4(%eax)
  803598:	8b 45 08             	mov    0x8(%ebp),%eax
  80359b:	8b 00                	mov    (%eax),%eax
  80359d:	85 c0                	test   %eax,%eax
  80359f:	75 08                	jne    8035a9 <insert_sorted_allocList+0x170>
  8035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a4:	a3 44 50 80 00       	mov    %eax,0x805044
  8035a9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8035ae:	40                   	inc    %eax
  8035af:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8035b4:	e9 da 00 00 00       	jmp    803693 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8035b9:	a1 40 50 80 00       	mov    0x805040,%eax
  8035be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035c1:	e9 9d 00 00 00       	jmp    803663 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8035c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c9:	8b 00                	mov    (%eax),%eax
  8035cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d1:	8b 50 08             	mov    0x8(%eax),%edx
  8035d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d7:	8b 40 08             	mov    0x8(%eax),%eax
  8035da:	39 c2                	cmp    %eax,%edx
  8035dc:	76 7d                	jbe    80365b <insert_sorted_allocList+0x222>
  8035de:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e1:	8b 50 08             	mov    0x8(%eax),%edx
  8035e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e7:	8b 40 08             	mov    0x8(%eax),%eax
  8035ea:	39 c2                	cmp    %eax,%edx
  8035ec:	73 6d                	jae    80365b <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8035ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f2:	74 06                	je     8035fa <insert_sorted_allocList+0x1c1>
  8035f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f8:	75 14                	jne    80360e <insert_sorted_allocList+0x1d5>
  8035fa:	83 ec 04             	sub    $0x4,%esp
  8035fd:	68 14 4f 80 00       	push   $0x804f14
  803602:	6a 7c                	push   $0x7c
  803604:	68 d7 4e 80 00       	push   $0x804ed7
  803609:	e8 81 df ff ff       	call   80158f <_panic>
  80360e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803611:	8b 10                	mov    (%eax),%edx
  803613:	8b 45 08             	mov    0x8(%ebp),%eax
  803616:	89 10                	mov    %edx,(%eax)
  803618:	8b 45 08             	mov    0x8(%ebp),%eax
  80361b:	8b 00                	mov    (%eax),%eax
  80361d:	85 c0                	test   %eax,%eax
  80361f:	74 0b                	je     80362c <insert_sorted_allocList+0x1f3>
  803621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803624:	8b 00                	mov    (%eax),%eax
  803626:	8b 55 08             	mov    0x8(%ebp),%edx
  803629:	89 50 04             	mov    %edx,0x4(%eax)
  80362c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362f:	8b 55 08             	mov    0x8(%ebp),%edx
  803632:	89 10                	mov    %edx,(%eax)
  803634:	8b 45 08             	mov    0x8(%ebp),%eax
  803637:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80363a:	89 50 04             	mov    %edx,0x4(%eax)
  80363d:	8b 45 08             	mov    0x8(%ebp),%eax
  803640:	8b 00                	mov    (%eax),%eax
  803642:	85 c0                	test   %eax,%eax
  803644:	75 08                	jne    80364e <insert_sorted_allocList+0x215>
  803646:	8b 45 08             	mov    0x8(%ebp),%eax
  803649:	a3 44 50 80 00       	mov    %eax,0x805044
  80364e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803653:	40                   	inc    %eax
  803654:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  803659:	eb 38                	jmp    803693 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80365b:	a1 48 50 80 00       	mov    0x805048,%eax
  803660:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803663:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803667:	74 07                	je     803670 <insert_sorted_allocList+0x237>
  803669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366c:	8b 00                	mov    (%eax),%eax
  80366e:	eb 05                	jmp    803675 <insert_sorted_allocList+0x23c>
  803670:	b8 00 00 00 00       	mov    $0x0,%eax
  803675:	a3 48 50 80 00       	mov    %eax,0x805048
  80367a:	a1 48 50 80 00       	mov    0x805048,%eax
  80367f:	85 c0                	test   %eax,%eax
  803681:	0f 85 3f ff ff ff    	jne    8035c6 <insert_sorted_allocList+0x18d>
  803687:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80368b:	0f 85 35 ff ff ff    	jne    8035c6 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  803691:	eb 00                	jmp    803693 <insert_sorted_allocList+0x25a>
  803693:	90                   	nop
  803694:	c9                   	leave  
  803695:	c3                   	ret    

00803696 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  803696:	55                   	push   %ebp
  803697:	89 e5                	mov    %esp,%ebp
  803699:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80369c:	a1 38 51 80 00       	mov    0x805138,%eax
  8036a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036a4:	e9 6b 02 00 00       	jmp    803914 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8036a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8036af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036b2:	0f 85 90 00 00 00    	jne    803748 <alloc_block_FF+0xb2>
			  temp=element;
  8036b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8036be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036c2:	75 17                	jne    8036db <alloc_block_FF+0x45>
  8036c4:	83 ec 04             	sub    $0x4,%esp
  8036c7:	68 48 4f 80 00       	push   $0x804f48
  8036cc:	68 92 00 00 00       	push   $0x92
  8036d1:	68 d7 4e 80 00       	push   $0x804ed7
  8036d6:	e8 b4 de ff ff       	call   80158f <_panic>
  8036db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036de:	8b 00                	mov    (%eax),%eax
  8036e0:	85 c0                	test   %eax,%eax
  8036e2:	74 10                	je     8036f4 <alloc_block_FF+0x5e>
  8036e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e7:	8b 00                	mov    (%eax),%eax
  8036e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ec:	8b 52 04             	mov    0x4(%edx),%edx
  8036ef:	89 50 04             	mov    %edx,0x4(%eax)
  8036f2:	eb 0b                	jmp    8036ff <alloc_block_FF+0x69>
  8036f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f7:	8b 40 04             	mov    0x4(%eax),%eax
  8036fa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803702:	8b 40 04             	mov    0x4(%eax),%eax
  803705:	85 c0                	test   %eax,%eax
  803707:	74 0f                	je     803718 <alloc_block_FF+0x82>
  803709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370c:	8b 40 04             	mov    0x4(%eax),%eax
  80370f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803712:	8b 12                	mov    (%edx),%edx
  803714:	89 10                	mov    %edx,(%eax)
  803716:	eb 0a                	jmp    803722 <alloc_block_FF+0x8c>
  803718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371b:	8b 00                	mov    (%eax),%eax
  80371d:	a3 38 51 80 00       	mov    %eax,0x805138
  803722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803725:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80372b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803735:	a1 44 51 80 00       	mov    0x805144,%eax
  80373a:	48                   	dec    %eax
  80373b:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  803740:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803743:	e9 ff 01 00 00       	jmp    803947 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  803748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374b:	8b 40 0c             	mov    0xc(%eax),%eax
  80374e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803751:	0f 86 b5 01 00 00    	jbe    80390c <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  803757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375a:	8b 40 0c             	mov    0xc(%eax),%eax
  80375d:	2b 45 08             	sub    0x8(%ebp),%eax
  803760:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  803763:	a1 48 51 80 00       	mov    0x805148,%eax
  803768:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  80376b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80376f:	75 17                	jne    803788 <alloc_block_FF+0xf2>
  803771:	83 ec 04             	sub    $0x4,%esp
  803774:	68 48 4f 80 00       	push   $0x804f48
  803779:	68 99 00 00 00       	push   $0x99
  80377e:	68 d7 4e 80 00       	push   $0x804ed7
  803783:	e8 07 de ff ff       	call   80158f <_panic>
  803788:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80378b:	8b 00                	mov    (%eax),%eax
  80378d:	85 c0                	test   %eax,%eax
  80378f:	74 10                	je     8037a1 <alloc_block_FF+0x10b>
  803791:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803794:	8b 00                	mov    (%eax),%eax
  803796:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803799:	8b 52 04             	mov    0x4(%edx),%edx
  80379c:	89 50 04             	mov    %edx,0x4(%eax)
  80379f:	eb 0b                	jmp    8037ac <alloc_block_FF+0x116>
  8037a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a4:	8b 40 04             	mov    0x4(%eax),%eax
  8037a7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037af:	8b 40 04             	mov    0x4(%eax),%eax
  8037b2:	85 c0                	test   %eax,%eax
  8037b4:	74 0f                	je     8037c5 <alloc_block_FF+0x12f>
  8037b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b9:	8b 40 04             	mov    0x4(%eax),%eax
  8037bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037bf:	8b 12                	mov    (%edx),%edx
  8037c1:	89 10                	mov    %edx,(%eax)
  8037c3:	eb 0a                	jmp    8037cf <alloc_block_FF+0x139>
  8037c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c8:	8b 00                	mov    (%eax),%eax
  8037ca:	a3 48 51 80 00       	mov    %eax,0x805148
  8037cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037e2:	a1 54 51 80 00       	mov    0x805154,%eax
  8037e7:	48                   	dec    %eax
  8037e8:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8037ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037f1:	75 17                	jne    80380a <alloc_block_FF+0x174>
  8037f3:	83 ec 04             	sub    $0x4,%esp
  8037f6:	68 f0 4e 80 00       	push   $0x804ef0
  8037fb:	68 9a 00 00 00       	push   $0x9a
  803800:	68 d7 4e 80 00       	push   $0x804ed7
  803805:	e8 85 dd ff ff       	call   80158f <_panic>
  80380a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803813:	89 50 04             	mov    %edx,0x4(%eax)
  803816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803819:	8b 40 04             	mov    0x4(%eax),%eax
  80381c:	85 c0                	test   %eax,%eax
  80381e:	74 0c                	je     80382c <alloc_block_FF+0x196>
  803820:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803825:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803828:	89 10                	mov    %edx,(%eax)
  80382a:	eb 08                	jmp    803834 <alloc_block_FF+0x19e>
  80382c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80382f:	a3 38 51 80 00       	mov    %eax,0x805138
  803834:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803837:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80383c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80383f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803845:	a1 44 51 80 00       	mov    0x805144,%eax
  80384a:	40                   	inc    %eax
  80384b:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  803850:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803853:	8b 55 08             	mov    0x8(%ebp),%edx
  803856:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  803859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80385c:	8b 50 08             	mov    0x8(%eax),%edx
  80385f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803862:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  803865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803868:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80386b:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  80386e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803871:	8b 50 08             	mov    0x8(%eax),%edx
  803874:	8b 45 08             	mov    0x8(%ebp),%eax
  803877:	01 c2                	add    %eax,%edx
  803879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387c:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  80387f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803882:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  803885:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803889:	75 17                	jne    8038a2 <alloc_block_FF+0x20c>
  80388b:	83 ec 04             	sub    $0x4,%esp
  80388e:	68 48 4f 80 00       	push   $0x804f48
  803893:	68 a2 00 00 00       	push   $0xa2
  803898:	68 d7 4e 80 00       	push   $0x804ed7
  80389d:	e8 ed dc ff ff       	call   80158f <_panic>
  8038a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038a5:	8b 00                	mov    (%eax),%eax
  8038a7:	85 c0                	test   %eax,%eax
  8038a9:	74 10                	je     8038bb <alloc_block_FF+0x225>
  8038ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ae:	8b 00                	mov    (%eax),%eax
  8038b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038b3:	8b 52 04             	mov    0x4(%edx),%edx
  8038b6:	89 50 04             	mov    %edx,0x4(%eax)
  8038b9:	eb 0b                	jmp    8038c6 <alloc_block_FF+0x230>
  8038bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038be:	8b 40 04             	mov    0x4(%eax),%eax
  8038c1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038c9:	8b 40 04             	mov    0x4(%eax),%eax
  8038cc:	85 c0                	test   %eax,%eax
  8038ce:	74 0f                	je     8038df <alloc_block_FF+0x249>
  8038d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038d3:	8b 40 04             	mov    0x4(%eax),%eax
  8038d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038d9:	8b 12                	mov    (%edx),%edx
  8038db:	89 10                	mov    %edx,(%eax)
  8038dd:	eb 0a                	jmp    8038e9 <alloc_block_FF+0x253>
  8038df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038e2:	8b 00                	mov    (%eax),%eax
  8038e4:	a3 38 51 80 00       	mov    %eax,0x805138
  8038e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038fc:	a1 44 51 80 00       	mov    0x805144,%eax
  803901:	48                   	dec    %eax
  803902:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  803907:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390a:	eb 3b                	jmp    803947 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80390c:	a1 40 51 80 00       	mov    0x805140,%eax
  803911:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803914:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803918:	74 07                	je     803921 <alloc_block_FF+0x28b>
  80391a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391d:	8b 00                	mov    (%eax),%eax
  80391f:	eb 05                	jmp    803926 <alloc_block_FF+0x290>
  803921:	b8 00 00 00 00       	mov    $0x0,%eax
  803926:	a3 40 51 80 00       	mov    %eax,0x805140
  80392b:	a1 40 51 80 00       	mov    0x805140,%eax
  803930:	85 c0                	test   %eax,%eax
  803932:	0f 85 71 fd ff ff    	jne    8036a9 <alloc_block_FF+0x13>
  803938:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80393c:	0f 85 67 fd ff ff    	jne    8036a9 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  803942:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803947:	c9                   	leave  
  803948:	c3                   	ret    

00803949 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803949:	55                   	push   %ebp
  80394a:	89 e5                	mov    %esp,%ebp
  80394c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  80394f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  803956:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80395d:	a1 38 51 80 00       	mov    0x805138,%eax
  803962:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803965:	e9 d3 00 00 00       	jmp    803a3d <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  80396a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396d:	8b 40 0c             	mov    0xc(%eax),%eax
  803970:	3b 45 08             	cmp    0x8(%ebp),%eax
  803973:	0f 85 90 00 00 00    	jne    803a09 <alloc_block_BF+0xc0>
	   temp = element;
  803979:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  80397f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803983:	75 17                	jne    80399c <alloc_block_BF+0x53>
  803985:	83 ec 04             	sub    $0x4,%esp
  803988:	68 48 4f 80 00       	push   $0x804f48
  80398d:	68 bd 00 00 00       	push   $0xbd
  803992:	68 d7 4e 80 00       	push   $0x804ed7
  803997:	e8 f3 db ff ff       	call   80158f <_panic>
  80399c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399f:	8b 00                	mov    (%eax),%eax
  8039a1:	85 c0                	test   %eax,%eax
  8039a3:	74 10                	je     8039b5 <alloc_block_BF+0x6c>
  8039a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a8:	8b 00                	mov    (%eax),%eax
  8039aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039ad:	8b 52 04             	mov    0x4(%edx),%edx
  8039b0:	89 50 04             	mov    %edx,0x4(%eax)
  8039b3:	eb 0b                	jmp    8039c0 <alloc_block_BF+0x77>
  8039b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b8:	8b 40 04             	mov    0x4(%eax),%eax
  8039bb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c3:	8b 40 04             	mov    0x4(%eax),%eax
  8039c6:	85 c0                	test   %eax,%eax
  8039c8:	74 0f                	je     8039d9 <alloc_block_BF+0x90>
  8039ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039cd:	8b 40 04             	mov    0x4(%eax),%eax
  8039d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039d3:	8b 12                	mov    (%edx),%edx
  8039d5:	89 10                	mov    %edx,(%eax)
  8039d7:	eb 0a                	jmp    8039e3 <alloc_block_BF+0x9a>
  8039d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039dc:	8b 00                	mov    (%eax),%eax
  8039de:	a3 38 51 80 00       	mov    %eax,0x805138
  8039e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8039fb:	48                   	dec    %eax
  8039fc:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  803a01:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a04:	e9 41 01 00 00       	jmp    803b4a <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  803a09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  803a0f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a12:	76 21                	jbe    803a35 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  803a14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a17:	8b 40 0c             	mov    0xc(%eax),%eax
  803a1a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803a1d:	73 16                	jae    803a35 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  803a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a22:	8b 40 0c             	mov    0xc(%eax),%eax
  803a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  803a28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  803a2e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  803a35:	a1 40 51 80 00       	mov    0x805140,%eax
  803a3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803a3d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a41:	74 07                	je     803a4a <alloc_block_BF+0x101>
  803a43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a46:	8b 00                	mov    (%eax),%eax
  803a48:	eb 05                	jmp    803a4f <alloc_block_BF+0x106>
  803a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  803a4f:	a3 40 51 80 00       	mov    %eax,0x805140
  803a54:	a1 40 51 80 00       	mov    0x805140,%eax
  803a59:	85 c0                	test   %eax,%eax
  803a5b:	0f 85 09 ff ff ff    	jne    80396a <alloc_block_BF+0x21>
  803a61:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a65:	0f 85 ff fe ff ff    	jne    80396a <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  803a6b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  803a6f:	0f 85 d0 00 00 00    	jne    803b45 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  803a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a78:	8b 40 0c             	mov    0xc(%eax),%eax
  803a7b:	2b 45 08             	sub    0x8(%ebp),%eax
  803a7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  803a81:	a1 48 51 80 00       	mov    0x805148,%eax
  803a86:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  803a89:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803a8d:	75 17                	jne    803aa6 <alloc_block_BF+0x15d>
  803a8f:	83 ec 04             	sub    $0x4,%esp
  803a92:	68 48 4f 80 00       	push   $0x804f48
  803a97:	68 d1 00 00 00       	push   $0xd1
  803a9c:	68 d7 4e 80 00       	push   $0x804ed7
  803aa1:	e8 e9 da ff ff       	call   80158f <_panic>
  803aa6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aa9:	8b 00                	mov    (%eax),%eax
  803aab:	85 c0                	test   %eax,%eax
  803aad:	74 10                	je     803abf <alloc_block_BF+0x176>
  803aaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ab2:	8b 00                	mov    (%eax),%eax
  803ab4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ab7:	8b 52 04             	mov    0x4(%edx),%edx
  803aba:	89 50 04             	mov    %edx,0x4(%eax)
  803abd:	eb 0b                	jmp    803aca <alloc_block_BF+0x181>
  803abf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ac2:	8b 40 04             	mov    0x4(%eax),%eax
  803ac5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803acd:	8b 40 04             	mov    0x4(%eax),%eax
  803ad0:	85 c0                	test   %eax,%eax
  803ad2:	74 0f                	je     803ae3 <alloc_block_BF+0x19a>
  803ad4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ad7:	8b 40 04             	mov    0x4(%eax),%eax
  803ada:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803add:	8b 12                	mov    (%edx),%edx
  803adf:	89 10                	mov    %edx,(%eax)
  803ae1:	eb 0a                	jmp    803aed <alloc_block_BF+0x1a4>
  803ae3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ae6:	8b 00                	mov    (%eax),%eax
  803ae8:	a3 48 51 80 00       	mov    %eax,0x805148
  803aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803af0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803af6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803af9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b00:	a1 54 51 80 00       	mov    0x805154,%eax
  803b05:	48                   	dec    %eax
  803b06:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  803b0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b0e:	8b 55 08             	mov    0x8(%ebp),%edx
  803b11:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  803b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b17:	8b 50 08             	mov    0x8(%eax),%edx
  803b1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b1d:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  803b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b26:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  803b29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b2c:	8b 50 08             	mov    0x8(%eax),%edx
  803b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b32:	01 c2                	add    %eax,%edx
  803b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b37:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  803b3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  803b40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b43:	eb 05                	jmp    803b4a <alloc_block_BF+0x201>
	 }
	 return NULL;
  803b45:	b8 00 00 00 00       	mov    $0x0,%eax


}
  803b4a:	c9                   	leave  
  803b4b:	c3                   	ret    

00803b4c <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803b4c:	55                   	push   %ebp
  803b4d:	89 e5                	mov    %esp,%ebp
  803b4f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  803b52:	83 ec 04             	sub    $0x4,%esp
  803b55:	68 68 4f 80 00       	push   $0x804f68
  803b5a:	68 e8 00 00 00       	push   $0xe8
  803b5f:	68 d7 4e 80 00       	push   $0x804ed7
  803b64:	e8 26 da ff ff       	call   80158f <_panic>

00803b69 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803b69:	55                   	push   %ebp
  803b6a:	89 e5                	mov    %esp,%ebp
  803b6c:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  803b6f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  803b77:	a1 38 51 80 00       	mov    0x805138,%eax
  803b7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  803b7f:	a1 44 51 80 00       	mov    0x805144,%eax
  803b84:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  803b87:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b8b:	75 68                	jne    803bf5 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803b8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b91:	75 17                	jne    803baa <insert_sorted_with_merge_freeList+0x41>
  803b93:	83 ec 04             	sub    $0x4,%esp
  803b96:	68 b4 4e 80 00       	push   $0x804eb4
  803b9b:	68 36 01 00 00       	push   $0x136
  803ba0:	68 d7 4e 80 00       	push   $0x804ed7
  803ba5:	e8 e5 d9 ff ff       	call   80158f <_panic>
  803baa:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb3:	89 10                	mov    %edx,(%eax)
  803bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb8:	8b 00                	mov    (%eax),%eax
  803bba:	85 c0                	test   %eax,%eax
  803bbc:	74 0d                	je     803bcb <insert_sorted_with_merge_freeList+0x62>
  803bbe:	a1 38 51 80 00       	mov    0x805138,%eax
  803bc3:	8b 55 08             	mov    0x8(%ebp),%edx
  803bc6:	89 50 04             	mov    %edx,0x4(%eax)
  803bc9:	eb 08                	jmp    803bd3 <insert_sorted_with_merge_freeList+0x6a>
  803bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  803bce:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd6:	a3 38 51 80 00       	mov    %eax,0x805138
  803bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  803bde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803be5:	a1 44 51 80 00       	mov    0x805144,%eax
  803bea:	40                   	inc    %eax
  803beb:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803bf0:	e9 ba 06 00 00       	jmp    8042af <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  803bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bf8:	8b 50 08             	mov    0x8(%eax),%edx
  803bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bfe:	8b 40 0c             	mov    0xc(%eax),%eax
  803c01:	01 c2                	add    %eax,%edx
  803c03:	8b 45 08             	mov    0x8(%ebp),%eax
  803c06:	8b 40 08             	mov    0x8(%eax),%eax
  803c09:	39 c2                	cmp    %eax,%edx
  803c0b:	73 68                	jae    803c75 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803c0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c11:	75 17                	jne    803c2a <insert_sorted_with_merge_freeList+0xc1>
  803c13:	83 ec 04             	sub    $0x4,%esp
  803c16:	68 f0 4e 80 00       	push   $0x804ef0
  803c1b:	68 3a 01 00 00       	push   $0x13a
  803c20:	68 d7 4e 80 00       	push   $0x804ed7
  803c25:	e8 65 d9 ff ff       	call   80158f <_panic>
  803c2a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803c30:	8b 45 08             	mov    0x8(%ebp),%eax
  803c33:	89 50 04             	mov    %edx,0x4(%eax)
  803c36:	8b 45 08             	mov    0x8(%ebp),%eax
  803c39:	8b 40 04             	mov    0x4(%eax),%eax
  803c3c:	85 c0                	test   %eax,%eax
  803c3e:	74 0c                	je     803c4c <insert_sorted_with_merge_freeList+0xe3>
  803c40:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803c45:	8b 55 08             	mov    0x8(%ebp),%edx
  803c48:	89 10                	mov    %edx,(%eax)
  803c4a:	eb 08                	jmp    803c54 <insert_sorted_with_merge_freeList+0xeb>
  803c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4f:	a3 38 51 80 00       	mov    %eax,0x805138
  803c54:	8b 45 08             	mov    0x8(%ebp),%eax
  803c57:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c65:	a1 44 51 80 00       	mov    0x805144,%eax
  803c6a:	40                   	inc    %eax
  803c6b:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803c70:	e9 3a 06 00 00       	jmp    8042af <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  803c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c78:	8b 50 08             	mov    0x8(%eax),%edx
  803c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c7e:	8b 40 0c             	mov    0xc(%eax),%eax
  803c81:	01 c2                	add    %eax,%edx
  803c83:	8b 45 08             	mov    0x8(%ebp),%eax
  803c86:	8b 40 08             	mov    0x8(%eax),%eax
  803c89:	39 c2                	cmp    %eax,%edx
  803c8b:	0f 85 90 00 00 00    	jne    803d21 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  803c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c94:	8b 50 0c             	mov    0xc(%eax),%edx
  803c97:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9a:	8b 40 0c             	mov    0xc(%eax),%eax
  803c9d:	01 c2                	add    %eax,%edx
  803c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ca2:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  803ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  803caf:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803cb9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cbd:	75 17                	jne    803cd6 <insert_sorted_with_merge_freeList+0x16d>
  803cbf:	83 ec 04             	sub    $0x4,%esp
  803cc2:	68 b4 4e 80 00       	push   $0x804eb4
  803cc7:	68 41 01 00 00       	push   $0x141
  803ccc:	68 d7 4e 80 00       	push   $0x804ed7
  803cd1:	e8 b9 d8 ff ff       	call   80158f <_panic>
  803cd6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  803cdf:	89 10                	mov    %edx,(%eax)
  803ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce4:	8b 00                	mov    (%eax),%eax
  803ce6:	85 c0                	test   %eax,%eax
  803ce8:	74 0d                	je     803cf7 <insert_sorted_with_merge_freeList+0x18e>
  803cea:	a1 48 51 80 00       	mov    0x805148,%eax
  803cef:	8b 55 08             	mov    0x8(%ebp),%edx
  803cf2:	89 50 04             	mov    %edx,0x4(%eax)
  803cf5:	eb 08                	jmp    803cff <insert_sorted_with_merge_freeList+0x196>
  803cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803cff:	8b 45 08             	mov    0x8(%ebp),%eax
  803d02:	a3 48 51 80 00       	mov    %eax,0x805148
  803d07:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d11:	a1 54 51 80 00       	mov    0x805154,%eax
  803d16:	40                   	inc    %eax
  803d17:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803d1c:	e9 8e 05 00 00       	jmp    8042af <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  803d21:	8b 45 08             	mov    0x8(%ebp),%eax
  803d24:	8b 50 08             	mov    0x8(%eax),%edx
  803d27:	8b 45 08             	mov    0x8(%ebp),%eax
  803d2a:	8b 40 0c             	mov    0xc(%eax),%eax
  803d2d:	01 c2                	add    %eax,%edx
  803d2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d32:	8b 40 08             	mov    0x8(%eax),%eax
  803d35:	39 c2                	cmp    %eax,%edx
  803d37:	73 68                	jae    803da1 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803d39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d3d:	75 17                	jne    803d56 <insert_sorted_with_merge_freeList+0x1ed>
  803d3f:	83 ec 04             	sub    $0x4,%esp
  803d42:	68 b4 4e 80 00       	push   $0x804eb4
  803d47:	68 45 01 00 00       	push   $0x145
  803d4c:	68 d7 4e 80 00       	push   $0x804ed7
  803d51:	e8 39 d8 ff ff       	call   80158f <_panic>
  803d56:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5f:	89 10                	mov    %edx,(%eax)
  803d61:	8b 45 08             	mov    0x8(%ebp),%eax
  803d64:	8b 00                	mov    (%eax),%eax
  803d66:	85 c0                	test   %eax,%eax
  803d68:	74 0d                	je     803d77 <insert_sorted_with_merge_freeList+0x20e>
  803d6a:	a1 38 51 80 00       	mov    0x805138,%eax
  803d6f:	8b 55 08             	mov    0x8(%ebp),%edx
  803d72:	89 50 04             	mov    %edx,0x4(%eax)
  803d75:	eb 08                	jmp    803d7f <insert_sorted_with_merge_freeList+0x216>
  803d77:	8b 45 08             	mov    0x8(%ebp),%eax
  803d7a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d82:	a3 38 51 80 00       	mov    %eax,0x805138
  803d87:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d91:	a1 44 51 80 00       	mov    0x805144,%eax
  803d96:	40                   	inc    %eax
  803d97:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803d9c:	e9 0e 05 00 00       	jmp    8042af <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  803da1:	8b 45 08             	mov    0x8(%ebp),%eax
  803da4:	8b 50 08             	mov    0x8(%eax),%edx
  803da7:	8b 45 08             	mov    0x8(%ebp),%eax
  803daa:	8b 40 0c             	mov    0xc(%eax),%eax
  803dad:	01 c2                	add    %eax,%edx
  803daf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803db2:	8b 40 08             	mov    0x8(%eax),%eax
  803db5:	39 c2                	cmp    %eax,%edx
  803db7:	0f 85 9c 00 00 00    	jne    803e59 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  803dbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dc0:	8b 50 0c             	mov    0xc(%eax),%edx
  803dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc6:	8b 40 0c             	mov    0xc(%eax),%eax
  803dc9:	01 c2                	add    %eax,%edx
  803dcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dce:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  803dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd4:	8b 50 08             	mov    0x8(%eax),%edx
  803dd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803dda:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  803ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  803de0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  803de7:	8b 45 08             	mov    0x8(%ebp),%eax
  803dea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803df1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803df5:	75 17                	jne    803e0e <insert_sorted_with_merge_freeList+0x2a5>
  803df7:	83 ec 04             	sub    $0x4,%esp
  803dfa:	68 b4 4e 80 00       	push   $0x804eb4
  803dff:	68 4d 01 00 00       	push   $0x14d
  803e04:	68 d7 4e 80 00       	push   $0x804ed7
  803e09:	e8 81 d7 ff ff       	call   80158f <_panic>
  803e0e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803e14:	8b 45 08             	mov    0x8(%ebp),%eax
  803e17:	89 10                	mov    %edx,(%eax)
  803e19:	8b 45 08             	mov    0x8(%ebp),%eax
  803e1c:	8b 00                	mov    (%eax),%eax
  803e1e:	85 c0                	test   %eax,%eax
  803e20:	74 0d                	je     803e2f <insert_sorted_with_merge_freeList+0x2c6>
  803e22:	a1 48 51 80 00       	mov    0x805148,%eax
  803e27:	8b 55 08             	mov    0x8(%ebp),%edx
  803e2a:	89 50 04             	mov    %edx,0x4(%eax)
  803e2d:	eb 08                	jmp    803e37 <insert_sorted_with_merge_freeList+0x2ce>
  803e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e32:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803e37:	8b 45 08             	mov    0x8(%ebp),%eax
  803e3a:	a3 48 51 80 00       	mov    %eax,0x805148
  803e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e49:	a1 54 51 80 00       	mov    0x805154,%eax
  803e4e:	40                   	inc    %eax
  803e4f:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803e54:	e9 56 04 00 00       	jmp    8042af <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803e59:	a1 38 51 80 00       	mov    0x805138,%eax
  803e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e61:	e9 19 04 00 00       	jmp    80427f <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  803e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e69:	8b 00                	mov    (%eax),%eax
  803e6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e71:	8b 50 08             	mov    0x8(%eax),%edx
  803e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e77:	8b 40 0c             	mov    0xc(%eax),%eax
  803e7a:	01 c2                	add    %eax,%edx
  803e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e7f:	8b 40 08             	mov    0x8(%eax),%eax
  803e82:	39 c2                	cmp    %eax,%edx
  803e84:	0f 85 ad 01 00 00    	jne    804037 <insert_sorted_with_merge_freeList+0x4ce>
  803e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e8d:	8b 50 08             	mov    0x8(%eax),%edx
  803e90:	8b 45 08             	mov    0x8(%ebp),%eax
  803e93:	8b 40 0c             	mov    0xc(%eax),%eax
  803e96:	01 c2                	add    %eax,%edx
  803e98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e9b:	8b 40 08             	mov    0x8(%eax),%eax
  803e9e:	39 c2                	cmp    %eax,%edx
  803ea0:	0f 85 91 01 00 00    	jne    804037 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  803ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ea9:	8b 50 0c             	mov    0xc(%eax),%edx
  803eac:	8b 45 08             	mov    0x8(%ebp),%eax
  803eaf:	8b 48 0c             	mov    0xc(%eax),%ecx
  803eb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb5:	8b 40 0c             	mov    0xc(%eax),%eax
  803eb8:	01 c8                	add    %ecx,%eax
  803eba:	01 c2                	add    %eax,%edx
  803ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ebf:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  803ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  803ecf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  803ed6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ed9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  803ee0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ee3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  803eea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803eee:	75 17                	jne    803f07 <insert_sorted_with_merge_freeList+0x39e>
  803ef0:	83 ec 04             	sub    $0x4,%esp
  803ef3:	68 48 4f 80 00       	push   $0x804f48
  803ef8:	68 5b 01 00 00       	push   $0x15b
  803efd:	68 d7 4e 80 00       	push   $0x804ed7
  803f02:	e8 88 d6 ff ff       	call   80158f <_panic>
  803f07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f0a:	8b 00                	mov    (%eax),%eax
  803f0c:	85 c0                	test   %eax,%eax
  803f0e:	74 10                	je     803f20 <insert_sorted_with_merge_freeList+0x3b7>
  803f10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f13:	8b 00                	mov    (%eax),%eax
  803f15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f18:	8b 52 04             	mov    0x4(%edx),%edx
  803f1b:	89 50 04             	mov    %edx,0x4(%eax)
  803f1e:	eb 0b                	jmp    803f2b <insert_sorted_with_merge_freeList+0x3c2>
  803f20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f23:	8b 40 04             	mov    0x4(%eax),%eax
  803f26:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803f2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f2e:	8b 40 04             	mov    0x4(%eax),%eax
  803f31:	85 c0                	test   %eax,%eax
  803f33:	74 0f                	je     803f44 <insert_sorted_with_merge_freeList+0x3db>
  803f35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f38:	8b 40 04             	mov    0x4(%eax),%eax
  803f3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803f3e:	8b 12                	mov    (%edx),%edx
  803f40:	89 10                	mov    %edx,(%eax)
  803f42:	eb 0a                	jmp    803f4e <insert_sorted_with_merge_freeList+0x3e5>
  803f44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f47:	8b 00                	mov    (%eax),%eax
  803f49:	a3 38 51 80 00       	mov    %eax,0x805138
  803f4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f61:	a1 44 51 80 00       	mov    0x805144,%eax
  803f66:	48                   	dec    %eax
  803f67:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803f6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f70:	75 17                	jne    803f89 <insert_sorted_with_merge_freeList+0x420>
  803f72:	83 ec 04             	sub    $0x4,%esp
  803f75:	68 b4 4e 80 00       	push   $0x804eb4
  803f7a:	68 5c 01 00 00       	push   $0x15c
  803f7f:	68 d7 4e 80 00       	push   $0x804ed7
  803f84:	e8 06 d6 ff ff       	call   80158f <_panic>
  803f89:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f92:	89 10                	mov    %edx,(%eax)
  803f94:	8b 45 08             	mov    0x8(%ebp),%eax
  803f97:	8b 00                	mov    (%eax),%eax
  803f99:	85 c0                	test   %eax,%eax
  803f9b:	74 0d                	je     803faa <insert_sorted_with_merge_freeList+0x441>
  803f9d:	a1 48 51 80 00       	mov    0x805148,%eax
  803fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  803fa5:	89 50 04             	mov    %edx,0x4(%eax)
  803fa8:	eb 08                	jmp    803fb2 <insert_sorted_with_merge_freeList+0x449>
  803faa:	8b 45 08             	mov    0x8(%ebp),%eax
  803fad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  803fb5:	a3 48 51 80 00       	mov    %eax,0x805148
  803fba:	8b 45 08             	mov    0x8(%ebp),%eax
  803fbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fc4:	a1 54 51 80 00       	mov    0x805154,%eax
  803fc9:	40                   	inc    %eax
  803fca:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  803fcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803fd3:	75 17                	jne    803fec <insert_sorted_with_merge_freeList+0x483>
  803fd5:	83 ec 04             	sub    $0x4,%esp
  803fd8:	68 b4 4e 80 00       	push   $0x804eb4
  803fdd:	68 5d 01 00 00       	push   $0x15d
  803fe2:	68 d7 4e 80 00       	push   $0x804ed7
  803fe7:	e8 a3 d5 ff ff       	call   80158f <_panic>
  803fec:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ff5:	89 10                	mov    %edx,(%eax)
  803ff7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ffa:	8b 00                	mov    (%eax),%eax
  803ffc:	85 c0                	test   %eax,%eax
  803ffe:	74 0d                	je     80400d <insert_sorted_with_merge_freeList+0x4a4>
  804000:	a1 48 51 80 00       	mov    0x805148,%eax
  804005:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804008:	89 50 04             	mov    %edx,0x4(%eax)
  80400b:	eb 08                	jmp    804015 <insert_sorted_with_merge_freeList+0x4ac>
  80400d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804010:	a3 4c 51 80 00       	mov    %eax,0x80514c
  804015:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804018:	a3 48 51 80 00       	mov    %eax,0x805148
  80401d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804020:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804027:	a1 54 51 80 00       	mov    0x805154,%eax
  80402c:	40                   	inc    %eax
  80402d:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  804032:	e9 78 02 00 00       	jmp    8042af <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  804037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80403a:	8b 50 08             	mov    0x8(%eax),%edx
  80403d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804040:	8b 40 0c             	mov    0xc(%eax),%eax
  804043:	01 c2                	add    %eax,%edx
  804045:	8b 45 08             	mov    0x8(%ebp),%eax
  804048:	8b 40 08             	mov    0x8(%eax),%eax
  80404b:	39 c2                	cmp    %eax,%edx
  80404d:	0f 83 b8 00 00 00    	jae    80410b <insert_sorted_with_merge_freeList+0x5a2>
  804053:	8b 45 08             	mov    0x8(%ebp),%eax
  804056:	8b 50 08             	mov    0x8(%eax),%edx
  804059:	8b 45 08             	mov    0x8(%ebp),%eax
  80405c:	8b 40 0c             	mov    0xc(%eax),%eax
  80405f:	01 c2                	add    %eax,%edx
  804061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804064:	8b 40 08             	mov    0x8(%eax),%eax
  804067:	39 c2                	cmp    %eax,%edx
  804069:	0f 85 9c 00 00 00    	jne    80410b <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  80406f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804072:	8b 50 0c             	mov    0xc(%eax),%edx
  804075:	8b 45 08             	mov    0x8(%ebp),%eax
  804078:	8b 40 0c             	mov    0xc(%eax),%eax
  80407b:	01 c2                	add    %eax,%edx
  80407d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804080:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  804083:	8b 45 08             	mov    0x8(%ebp),%eax
  804086:	8b 50 08             	mov    0x8(%eax),%edx
  804089:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80408c:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  80408f:	8b 45 08             	mov    0x8(%ebp),%eax
  804092:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  804099:	8b 45 08             	mov    0x8(%ebp),%eax
  80409c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8040a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8040a7:	75 17                	jne    8040c0 <insert_sorted_with_merge_freeList+0x557>
  8040a9:	83 ec 04             	sub    $0x4,%esp
  8040ac:	68 b4 4e 80 00       	push   $0x804eb4
  8040b1:	68 67 01 00 00       	push   $0x167
  8040b6:	68 d7 4e 80 00       	push   $0x804ed7
  8040bb:	e8 cf d4 ff ff       	call   80158f <_panic>
  8040c0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8040c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8040c9:	89 10                	mov    %edx,(%eax)
  8040cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ce:	8b 00                	mov    (%eax),%eax
  8040d0:	85 c0                	test   %eax,%eax
  8040d2:	74 0d                	je     8040e1 <insert_sorted_with_merge_freeList+0x578>
  8040d4:	a1 48 51 80 00       	mov    0x805148,%eax
  8040d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8040dc:	89 50 04             	mov    %edx,0x4(%eax)
  8040df:	eb 08                	jmp    8040e9 <insert_sorted_with_merge_freeList+0x580>
  8040e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8040e4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8040e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8040f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8040f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040fb:	a1 54 51 80 00       	mov    0x805154,%eax
  804100:	40                   	inc    %eax
  804101:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  804106:	e9 a4 01 00 00       	jmp    8042af <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80410b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80410e:	8b 50 08             	mov    0x8(%eax),%edx
  804111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804114:	8b 40 0c             	mov    0xc(%eax),%eax
  804117:	01 c2                	add    %eax,%edx
  804119:	8b 45 08             	mov    0x8(%ebp),%eax
  80411c:	8b 40 08             	mov    0x8(%eax),%eax
  80411f:	39 c2                	cmp    %eax,%edx
  804121:	0f 85 ac 00 00 00    	jne    8041d3 <insert_sorted_with_merge_freeList+0x66a>
  804127:	8b 45 08             	mov    0x8(%ebp),%eax
  80412a:	8b 50 08             	mov    0x8(%eax),%edx
  80412d:	8b 45 08             	mov    0x8(%ebp),%eax
  804130:	8b 40 0c             	mov    0xc(%eax),%eax
  804133:	01 c2                	add    %eax,%edx
  804135:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804138:	8b 40 08             	mov    0x8(%eax),%eax
  80413b:	39 c2                	cmp    %eax,%edx
  80413d:	0f 83 90 00 00 00    	jae    8041d3 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  804143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804146:	8b 50 0c             	mov    0xc(%eax),%edx
  804149:	8b 45 08             	mov    0x8(%ebp),%eax
  80414c:	8b 40 0c             	mov    0xc(%eax),%eax
  80414f:	01 c2                	add    %eax,%edx
  804151:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804154:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  804157:	8b 45 08             	mov    0x8(%ebp),%eax
  80415a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  804161:	8b 45 08             	mov    0x8(%ebp),%eax
  804164:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80416b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80416f:	75 17                	jne    804188 <insert_sorted_with_merge_freeList+0x61f>
  804171:	83 ec 04             	sub    $0x4,%esp
  804174:	68 b4 4e 80 00       	push   $0x804eb4
  804179:	68 70 01 00 00       	push   $0x170
  80417e:	68 d7 4e 80 00       	push   $0x804ed7
  804183:	e8 07 d4 ff ff       	call   80158f <_panic>
  804188:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80418e:	8b 45 08             	mov    0x8(%ebp),%eax
  804191:	89 10                	mov    %edx,(%eax)
  804193:	8b 45 08             	mov    0x8(%ebp),%eax
  804196:	8b 00                	mov    (%eax),%eax
  804198:	85 c0                	test   %eax,%eax
  80419a:	74 0d                	je     8041a9 <insert_sorted_with_merge_freeList+0x640>
  80419c:	a1 48 51 80 00       	mov    0x805148,%eax
  8041a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8041a4:	89 50 04             	mov    %edx,0x4(%eax)
  8041a7:	eb 08                	jmp    8041b1 <insert_sorted_with_merge_freeList+0x648>
  8041a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8041ac:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8041b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8041b4:	a3 48 51 80 00       	mov    %eax,0x805148
  8041b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8041bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041c3:	a1 54 51 80 00       	mov    0x805154,%eax
  8041c8:	40                   	inc    %eax
  8041c9:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  8041ce:	e9 dc 00 00 00       	jmp    8042af <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8041d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041d6:	8b 50 08             	mov    0x8(%eax),%edx
  8041d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8041df:	01 c2                	add    %eax,%edx
  8041e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8041e4:	8b 40 08             	mov    0x8(%eax),%eax
  8041e7:	39 c2                	cmp    %eax,%edx
  8041e9:	0f 83 88 00 00 00    	jae    804277 <insert_sorted_with_merge_freeList+0x70e>
  8041ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f2:	8b 50 08             	mov    0x8(%eax),%edx
  8041f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8041fb:	01 c2                	add    %eax,%edx
  8041fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804200:	8b 40 08             	mov    0x8(%eax),%eax
  804203:	39 c2                	cmp    %eax,%edx
  804205:	73 70                	jae    804277 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  804207:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80420b:	74 06                	je     804213 <insert_sorted_with_merge_freeList+0x6aa>
  80420d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804211:	75 17                	jne    80422a <insert_sorted_with_merge_freeList+0x6c1>
  804213:	83 ec 04             	sub    $0x4,%esp
  804216:	68 14 4f 80 00       	push   $0x804f14
  80421b:	68 75 01 00 00       	push   $0x175
  804220:	68 d7 4e 80 00       	push   $0x804ed7
  804225:	e8 65 d3 ff ff       	call   80158f <_panic>
  80422a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80422d:	8b 10                	mov    (%eax),%edx
  80422f:	8b 45 08             	mov    0x8(%ebp),%eax
  804232:	89 10                	mov    %edx,(%eax)
  804234:	8b 45 08             	mov    0x8(%ebp),%eax
  804237:	8b 00                	mov    (%eax),%eax
  804239:	85 c0                	test   %eax,%eax
  80423b:	74 0b                	je     804248 <insert_sorted_with_merge_freeList+0x6df>
  80423d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804240:	8b 00                	mov    (%eax),%eax
  804242:	8b 55 08             	mov    0x8(%ebp),%edx
  804245:	89 50 04             	mov    %edx,0x4(%eax)
  804248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80424b:	8b 55 08             	mov    0x8(%ebp),%edx
  80424e:	89 10                	mov    %edx,(%eax)
  804250:	8b 45 08             	mov    0x8(%ebp),%eax
  804253:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804256:	89 50 04             	mov    %edx,0x4(%eax)
  804259:	8b 45 08             	mov    0x8(%ebp),%eax
  80425c:	8b 00                	mov    (%eax),%eax
  80425e:	85 c0                	test   %eax,%eax
  804260:	75 08                	jne    80426a <insert_sorted_with_merge_freeList+0x701>
  804262:	8b 45 08             	mov    0x8(%ebp),%eax
  804265:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80426a:	a1 44 51 80 00       	mov    0x805144,%eax
  80426f:	40                   	inc    %eax
  804270:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  804275:	eb 38                	jmp    8042af <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  804277:	a1 40 51 80 00       	mov    0x805140,%eax
  80427c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80427f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804283:	74 07                	je     80428c <insert_sorted_with_merge_freeList+0x723>
  804285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804288:	8b 00                	mov    (%eax),%eax
  80428a:	eb 05                	jmp    804291 <insert_sorted_with_merge_freeList+0x728>
  80428c:	b8 00 00 00 00       	mov    $0x0,%eax
  804291:	a3 40 51 80 00       	mov    %eax,0x805140
  804296:	a1 40 51 80 00       	mov    0x805140,%eax
  80429b:	85 c0                	test   %eax,%eax
  80429d:	0f 85 c3 fb ff ff    	jne    803e66 <insert_sorted_with_merge_freeList+0x2fd>
  8042a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042a7:	0f 85 b9 fb ff ff    	jne    803e66 <insert_sorted_with_merge_freeList+0x2fd>





}
  8042ad:	eb 00                	jmp    8042af <insert_sorted_with_merge_freeList+0x746>
  8042af:	90                   	nop
  8042b0:	c9                   	leave  
  8042b1:	c3                   	ret    
  8042b2:	66 90                	xchg   %ax,%ax

008042b4 <__udivdi3>:
  8042b4:	55                   	push   %ebp
  8042b5:	57                   	push   %edi
  8042b6:	56                   	push   %esi
  8042b7:	53                   	push   %ebx
  8042b8:	83 ec 1c             	sub    $0x1c,%esp
  8042bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8042bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8042c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8042cb:	89 ca                	mov    %ecx,%edx
  8042cd:	89 f8                	mov    %edi,%eax
  8042cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8042d3:	85 f6                	test   %esi,%esi
  8042d5:	75 2d                	jne    804304 <__udivdi3+0x50>
  8042d7:	39 cf                	cmp    %ecx,%edi
  8042d9:	77 65                	ja     804340 <__udivdi3+0x8c>
  8042db:	89 fd                	mov    %edi,%ebp
  8042dd:	85 ff                	test   %edi,%edi
  8042df:	75 0b                	jne    8042ec <__udivdi3+0x38>
  8042e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8042e6:	31 d2                	xor    %edx,%edx
  8042e8:	f7 f7                	div    %edi
  8042ea:	89 c5                	mov    %eax,%ebp
  8042ec:	31 d2                	xor    %edx,%edx
  8042ee:	89 c8                	mov    %ecx,%eax
  8042f0:	f7 f5                	div    %ebp
  8042f2:	89 c1                	mov    %eax,%ecx
  8042f4:	89 d8                	mov    %ebx,%eax
  8042f6:	f7 f5                	div    %ebp
  8042f8:	89 cf                	mov    %ecx,%edi
  8042fa:	89 fa                	mov    %edi,%edx
  8042fc:	83 c4 1c             	add    $0x1c,%esp
  8042ff:	5b                   	pop    %ebx
  804300:	5e                   	pop    %esi
  804301:	5f                   	pop    %edi
  804302:	5d                   	pop    %ebp
  804303:	c3                   	ret    
  804304:	39 ce                	cmp    %ecx,%esi
  804306:	77 28                	ja     804330 <__udivdi3+0x7c>
  804308:	0f bd fe             	bsr    %esi,%edi
  80430b:	83 f7 1f             	xor    $0x1f,%edi
  80430e:	75 40                	jne    804350 <__udivdi3+0x9c>
  804310:	39 ce                	cmp    %ecx,%esi
  804312:	72 0a                	jb     80431e <__udivdi3+0x6a>
  804314:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804318:	0f 87 9e 00 00 00    	ja     8043bc <__udivdi3+0x108>
  80431e:	b8 01 00 00 00       	mov    $0x1,%eax
  804323:	89 fa                	mov    %edi,%edx
  804325:	83 c4 1c             	add    $0x1c,%esp
  804328:	5b                   	pop    %ebx
  804329:	5e                   	pop    %esi
  80432a:	5f                   	pop    %edi
  80432b:	5d                   	pop    %ebp
  80432c:	c3                   	ret    
  80432d:	8d 76 00             	lea    0x0(%esi),%esi
  804330:	31 ff                	xor    %edi,%edi
  804332:	31 c0                	xor    %eax,%eax
  804334:	89 fa                	mov    %edi,%edx
  804336:	83 c4 1c             	add    $0x1c,%esp
  804339:	5b                   	pop    %ebx
  80433a:	5e                   	pop    %esi
  80433b:	5f                   	pop    %edi
  80433c:	5d                   	pop    %ebp
  80433d:	c3                   	ret    
  80433e:	66 90                	xchg   %ax,%ax
  804340:	89 d8                	mov    %ebx,%eax
  804342:	f7 f7                	div    %edi
  804344:	31 ff                	xor    %edi,%edi
  804346:	89 fa                	mov    %edi,%edx
  804348:	83 c4 1c             	add    $0x1c,%esp
  80434b:	5b                   	pop    %ebx
  80434c:	5e                   	pop    %esi
  80434d:	5f                   	pop    %edi
  80434e:	5d                   	pop    %ebp
  80434f:	c3                   	ret    
  804350:	bd 20 00 00 00       	mov    $0x20,%ebp
  804355:	89 eb                	mov    %ebp,%ebx
  804357:	29 fb                	sub    %edi,%ebx
  804359:	89 f9                	mov    %edi,%ecx
  80435b:	d3 e6                	shl    %cl,%esi
  80435d:	89 c5                	mov    %eax,%ebp
  80435f:	88 d9                	mov    %bl,%cl
  804361:	d3 ed                	shr    %cl,%ebp
  804363:	89 e9                	mov    %ebp,%ecx
  804365:	09 f1                	or     %esi,%ecx
  804367:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80436b:	89 f9                	mov    %edi,%ecx
  80436d:	d3 e0                	shl    %cl,%eax
  80436f:	89 c5                	mov    %eax,%ebp
  804371:	89 d6                	mov    %edx,%esi
  804373:	88 d9                	mov    %bl,%cl
  804375:	d3 ee                	shr    %cl,%esi
  804377:	89 f9                	mov    %edi,%ecx
  804379:	d3 e2                	shl    %cl,%edx
  80437b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80437f:	88 d9                	mov    %bl,%cl
  804381:	d3 e8                	shr    %cl,%eax
  804383:	09 c2                	or     %eax,%edx
  804385:	89 d0                	mov    %edx,%eax
  804387:	89 f2                	mov    %esi,%edx
  804389:	f7 74 24 0c          	divl   0xc(%esp)
  80438d:	89 d6                	mov    %edx,%esi
  80438f:	89 c3                	mov    %eax,%ebx
  804391:	f7 e5                	mul    %ebp
  804393:	39 d6                	cmp    %edx,%esi
  804395:	72 19                	jb     8043b0 <__udivdi3+0xfc>
  804397:	74 0b                	je     8043a4 <__udivdi3+0xf0>
  804399:	89 d8                	mov    %ebx,%eax
  80439b:	31 ff                	xor    %edi,%edi
  80439d:	e9 58 ff ff ff       	jmp    8042fa <__udivdi3+0x46>
  8043a2:	66 90                	xchg   %ax,%ax
  8043a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8043a8:	89 f9                	mov    %edi,%ecx
  8043aa:	d3 e2                	shl    %cl,%edx
  8043ac:	39 c2                	cmp    %eax,%edx
  8043ae:	73 e9                	jae    804399 <__udivdi3+0xe5>
  8043b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8043b3:	31 ff                	xor    %edi,%edi
  8043b5:	e9 40 ff ff ff       	jmp    8042fa <__udivdi3+0x46>
  8043ba:	66 90                	xchg   %ax,%ax
  8043bc:	31 c0                	xor    %eax,%eax
  8043be:	e9 37 ff ff ff       	jmp    8042fa <__udivdi3+0x46>
  8043c3:	90                   	nop

008043c4 <__umoddi3>:
  8043c4:	55                   	push   %ebp
  8043c5:	57                   	push   %edi
  8043c6:	56                   	push   %esi
  8043c7:	53                   	push   %ebx
  8043c8:	83 ec 1c             	sub    $0x1c,%esp
  8043cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8043cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8043d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8043d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8043db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8043df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8043e3:	89 f3                	mov    %esi,%ebx
  8043e5:	89 fa                	mov    %edi,%edx
  8043e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8043eb:	89 34 24             	mov    %esi,(%esp)
  8043ee:	85 c0                	test   %eax,%eax
  8043f0:	75 1a                	jne    80440c <__umoddi3+0x48>
  8043f2:	39 f7                	cmp    %esi,%edi
  8043f4:	0f 86 a2 00 00 00    	jbe    80449c <__umoddi3+0xd8>
  8043fa:	89 c8                	mov    %ecx,%eax
  8043fc:	89 f2                	mov    %esi,%edx
  8043fe:	f7 f7                	div    %edi
  804400:	89 d0                	mov    %edx,%eax
  804402:	31 d2                	xor    %edx,%edx
  804404:	83 c4 1c             	add    $0x1c,%esp
  804407:	5b                   	pop    %ebx
  804408:	5e                   	pop    %esi
  804409:	5f                   	pop    %edi
  80440a:	5d                   	pop    %ebp
  80440b:	c3                   	ret    
  80440c:	39 f0                	cmp    %esi,%eax
  80440e:	0f 87 ac 00 00 00    	ja     8044c0 <__umoddi3+0xfc>
  804414:	0f bd e8             	bsr    %eax,%ebp
  804417:	83 f5 1f             	xor    $0x1f,%ebp
  80441a:	0f 84 ac 00 00 00    	je     8044cc <__umoddi3+0x108>
  804420:	bf 20 00 00 00       	mov    $0x20,%edi
  804425:	29 ef                	sub    %ebp,%edi
  804427:	89 fe                	mov    %edi,%esi
  804429:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80442d:	89 e9                	mov    %ebp,%ecx
  80442f:	d3 e0                	shl    %cl,%eax
  804431:	89 d7                	mov    %edx,%edi
  804433:	89 f1                	mov    %esi,%ecx
  804435:	d3 ef                	shr    %cl,%edi
  804437:	09 c7                	or     %eax,%edi
  804439:	89 e9                	mov    %ebp,%ecx
  80443b:	d3 e2                	shl    %cl,%edx
  80443d:	89 14 24             	mov    %edx,(%esp)
  804440:	89 d8                	mov    %ebx,%eax
  804442:	d3 e0                	shl    %cl,%eax
  804444:	89 c2                	mov    %eax,%edx
  804446:	8b 44 24 08          	mov    0x8(%esp),%eax
  80444a:	d3 e0                	shl    %cl,%eax
  80444c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804450:	8b 44 24 08          	mov    0x8(%esp),%eax
  804454:	89 f1                	mov    %esi,%ecx
  804456:	d3 e8                	shr    %cl,%eax
  804458:	09 d0                	or     %edx,%eax
  80445a:	d3 eb                	shr    %cl,%ebx
  80445c:	89 da                	mov    %ebx,%edx
  80445e:	f7 f7                	div    %edi
  804460:	89 d3                	mov    %edx,%ebx
  804462:	f7 24 24             	mull   (%esp)
  804465:	89 c6                	mov    %eax,%esi
  804467:	89 d1                	mov    %edx,%ecx
  804469:	39 d3                	cmp    %edx,%ebx
  80446b:	0f 82 87 00 00 00    	jb     8044f8 <__umoddi3+0x134>
  804471:	0f 84 91 00 00 00    	je     804508 <__umoddi3+0x144>
  804477:	8b 54 24 04          	mov    0x4(%esp),%edx
  80447b:	29 f2                	sub    %esi,%edx
  80447d:	19 cb                	sbb    %ecx,%ebx
  80447f:	89 d8                	mov    %ebx,%eax
  804481:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804485:	d3 e0                	shl    %cl,%eax
  804487:	89 e9                	mov    %ebp,%ecx
  804489:	d3 ea                	shr    %cl,%edx
  80448b:	09 d0                	or     %edx,%eax
  80448d:	89 e9                	mov    %ebp,%ecx
  80448f:	d3 eb                	shr    %cl,%ebx
  804491:	89 da                	mov    %ebx,%edx
  804493:	83 c4 1c             	add    $0x1c,%esp
  804496:	5b                   	pop    %ebx
  804497:	5e                   	pop    %esi
  804498:	5f                   	pop    %edi
  804499:	5d                   	pop    %ebp
  80449a:	c3                   	ret    
  80449b:	90                   	nop
  80449c:	89 fd                	mov    %edi,%ebp
  80449e:	85 ff                	test   %edi,%edi
  8044a0:	75 0b                	jne    8044ad <__umoddi3+0xe9>
  8044a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8044a7:	31 d2                	xor    %edx,%edx
  8044a9:	f7 f7                	div    %edi
  8044ab:	89 c5                	mov    %eax,%ebp
  8044ad:	89 f0                	mov    %esi,%eax
  8044af:	31 d2                	xor    %edx,%edx
  8044b1:	f7 f5                	div    %ebp
  8044b3:	89 c8                	mov    %ecx,%eax
  8044b5:	f7 f5                	div    %ebp
  8044b7:	89 d0                	mov    %edx,%eax
  8044b9:	e9 44 ff ff ff       	jmp    804402 <__umoddi3+0x3e>
  8044be:	66 90                	xchg   %ax,%ax
  8044c0:	89 c8                	mov    %ecx,%eax
  8044c2:	89 f2                	mov    %esi,%edx
  8044c4:	83 c4 1c             	add    $0x1c,%esp
  8044c7:	5b                   	pop    %ebx
  8044c8:	5e                   	pop    %esi
  8044c9:	5f                   	pop    %edi
  8044ca:	5d                   	pop    %ebp
  8044cb:	c3                   	ret    
  8044cc:	3b 04 24             	cmp    (%esp),%eax
  8044cf:	72 06                	jb     8044d7 <__umoddi3+0x113>
  8044d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8044d5:	77 0f                	ja     8044e6 <__umoddi3+0x122>
  8044d7:	89 f2                	mov    %esi,%edx
  8044d9:	29 f9                	sub    %edi,%ecx
  8044db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8044df:	89 14 24             	mov    %edx,(%esp)
  8044e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8044ea:	8b 14 24             	mov    (%esp),%edx
  8044ed:	83 c4 1c             	add    $0x1c,%esp
  8044f0:	5b                   	pop    %ebx
  8044f1:	5e                   	pop    %esi
  8044f2:	5f                   	pop    %edi
  8044f3:	5d                   	pop    %ebp
  8044f4:	c3                   	ret    
  8044f5:	8d 76 00             	lea    0x0(%esi),%esi
  8044f8:	2b 04 24             	sub    (%esp),%eax
  8044fb:	19 fa                	sbb    %edi,%edx
  8044fd:	89 d1                	mov    %edx,%ecx
  8044ff:	89 c6                	mov    %eax,%esi
  804501:	e9 71 ff ff ff       	jmp    804477 <__umoddi3+0xb3>
  804506:	66 90                	xchg   %ax,%ax
  804508:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80450c:	72 ea                	jb     8044f8 <__umoddi3+0x134>
  80450e:	89 d9                	mov    %ebx,%ecx
  804510:	e9 62 ff ff ff       	jmp    804477 <__umoddi3+0xb3>
