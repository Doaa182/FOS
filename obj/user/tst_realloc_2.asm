
obj/user/tst_realloc_2:     file format elf32-i386


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
  800031:	e8 b7 12 00 00       	call   8012ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 c4 80             	add    $0xffffff80,%esp
	int Mega = 1024*1024;
  800040:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  800047:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 95 78 ff ff ff    	lea    -0x88(%ebp),%edx
  800054:	b9 14 00 00 00       	mov    $0x14,%ecx
  800059:	b8 00 00 00 00       	mov    $0x0,%eax
  80005e:	89 d7                	mov    %edx,%edi
  800060:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  800062:	83 ec 0c             	sub    $0xc,%esp
  800065:	68 c0 43 80 00       	push   $0x8043c0
  80006a:	e8 6e 16 00 00       	call   8016dd <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800072:	e8 1e 2a 00 00       	call   802a95 <sys_calculate_free_frames>
  800077:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80007a:	e8 b6 2a 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  800082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800085:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800088:	83 ec 0c             	sub    $0xc,%esp
  80008b:	50                   	push   %eax
  80008c:	e8 c5 25 00 00       	call   802656 <malloc>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8000a0:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a5:	74 14                	je     8000bb <_main+0x83>
  8000a7:	83 ec 04             	sub    $0x4,%esp
  8000aa:	68 e4 43 80 00       	push   $0x8043e4
  8000af:	6a 11                	push   $0x11
  8000b1:	68 14 44 80 00       	push   $0x804414
  8000b6:	e8 6e 13 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000be:	e8 d2 29 00 00       	call   802a95 <sys_calculate_free_frames>
  8000c3:	29 c3                	sub    %eax,%ebx
  8000c5:	89 d8                	mov    %ebx,%eax
  8000c7:	83 f8 01             	cmp    $0x1,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 2c 44 80 00       	push   $0x80442c
  8000d4:	6a 13                	push   $0x13
  8000d6:	68 14 44 80 00       	push   $0x804414
  8000db:	e8 49 13 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8000e0:	e8 50 2a 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  8000e5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8000e8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000ed:	74 14                	je     800103 <_main+0xcb>
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	68 98 44 80 00       	push   $0x804498
  8000f7:	6a 14                	push   $0x14
  8000f9:	68 14 44 80 00       	push   $0x804414
  8000fe:	e8 26 13 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800103:	e8 8d 29 00 00       	call   802a95 <sys_calculate_free_frames>
  800108:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 25 2a 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800110:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	50                   	push   %eax
  80011d:	e8 34 25 00 00       	call   802656 <malloc>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80012b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800131:	89 c2                	mov    %eax,%edx
  800133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800136:	05 00 00 00 80       	add    $0x80000000,%eax
  80013b:	39 c2                	cmp    %eax,%edx
  80013d:	74 14                	je     800153 <_main+0x11b>
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	68 e4 43 80 00       	push   $0x8043e4
  800147:	6a 1a                	push   $0x1a
  800149:	68 14 44 80 00       	push   $0x804414
  80014e:	e8 d6 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800153:	e8 3d 29 00 00       	call   802a95 <sys_calculate_free_frames>
  800158:	89 c2                	mov    %eax,%edx
  80015a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80015d:	39 c2                	cmp    %eax,%edx
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 2c 44 80 00       	push   $0x80442c
  800169:	6a 1c                	push   $0x1c
  80016b:	68 14 44 80 00       	push   $0x804414
  800170:	e8 b4 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800175:	e8 bb 29 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  80017a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017d:	3d 00 01 00 00       	cmp    $0x100,%eax
  800182:	74 14                	je     800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 98 44 80 00       	push   $0x804498
  80018c:	6a 1d                	push   $0x1d
  80018e:	68 14 44 80 00       	push   $0x804414
  800193:	e8 91 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800198:	e8 f8 28 00 00       	call   802a95 <sys_calculate_free_frames>
  80019d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001a0:	e8 90 29 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  8001a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ab:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	50                   	push   %eax
  8001b2:	e8 9f 24 00 00       	call   802656 <malloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001bd:	8b 45 80             	mov    -0x80(%ebp),%eax
  8001c0:	89 c2                	mov    %eax,%edx
  8001c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 e4 43 80 00       	push   $0x8043e4
  8001d8:	6a 23                	push   $0x23
  8001da:	68 14 44 80 00       	push   $0x804414
  8001df:	e8 45 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001e4:	e8 ac 28 00 00       	call   802a95 <sys_calculate_free_frames>
  8001e9:	89 c2                	mov    %eax,%edx
  8001eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ee:	39 c2                	cmp    %eax,%edx
  8001f0:	74 14                	je     800206 <_main+0x1ce>
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	68 2c 44 80 00       	push   $0x80442c
  8001fa:	6a 25                	push   $0x25
  8001fc:	68 14 44 80 00       	push   $0x804414
  800201:	e8 23 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800206:	e8 2a 29 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  80020b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80020e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800213:	74 14                	je     800229 <_main+0x1f1>
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	68 98 44 80 00       	push   $0x804498
  80021d:	6a 26                	push   $0x26
  80021f:	68 14 44 80 00       	push   $0x804414
  800224:	e8 00 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800229:	e8 67 28 00 00       	call   802a95 <sys_calculate_free_frames>
  80022e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800231:	e8 ff 28 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800236:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80023c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	50                   	push   %eax
  800243:	e8 0e 24 00 00       	call   802656 <malloc>
  800248:	83 c4 10             	add    $0x10,%esp
  80024b:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80024e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800251:	89 c1                	mov    %eax,%ecx
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	05 00 00 00 80       	add    $0x80000000,%eax
  800261:	39 c1                	cmp    %eax,%ecx
  800263:	74 14                	je     800279 <_main+0x241>
  800265:	83 ec 04             	sub    $0x4,%esp
  800268:	68 e4 43 80 00       	push   $0x8043e4
  80026d:	6a 2c                	push   $0x2c
  80026f:	68 14 44 80 00       	push   $0x804414
  800274:	e8 b0 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800279:	e8 17 28 00 00       	call   802a95 <sys_calculate_free_frames>
  80027e:	89 c2                	mov    %eax,%edx
  800280:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800283:	39 c2                	cmp    %eax,%edx
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 2c 44 80 00       	push   $0x80442c
  80028f:	6a 2e                	push   $0x2e
  800291:	68 14 44 80 00       	push   $0x804414
  800296:	e8 8e 11 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80029b:	e8 95 28 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  8002a0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002a3:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002a8:	74 14                	je     8002be <_main+0x286>
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	68 98 44 80 00       	push   $0x804498
  8002b2:	6a 2f                	push   $0x2f
  8002b4:	68 14 44 80 00       	push   $0x804414
  8002b9:	e8 6b 11 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002be:	e8 d2 27 00 00       	call   802a95 <sys_calculate_free_frames>
  8002c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002c6:	e8 6a 28 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  8002cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d1:	01 c0                	add    %eax,%eax
  8002d3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 77 23 00 00       	call   802656 <malloc>
  8002df:	83 c4 10             	add    $0x10,%esp
  8002e2:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002e5:	8b 45 88             	mov    -0x78(%ebp),%eax
  8002e8:	89 c2                	mov    %eax,%edx
  8002ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ed:	c1 e0 02             	shl    $0x2,%eax
  8002f0:	05 00 00 00 80       	add    $0x80000000,%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	74 14                	je     80030d <_main+0x2d5>
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	68 e4 43 80 00       	push   $0x8043e4
  800301:	6a 35                	push   $0x35
  800303:	68 14 44 80 00       	push   $0x804414
  800308:	e8 1c 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80030d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800310:	e8 80 27 00 00       	call   802a95 <sys_calculate_free_frames>
  800315:	29 c3                	sub    %eax,%ebx
  800317:	89 d8                	mov    %ebx,%eax
  800319:	83 f8 01             	cmp    $0x1,%eax
  80031c:	74 14                	je     800332 <_main+0x2fa>
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	68 2c 44 80 00       	push   $0x80442c
  800326:	6a 37                	push   $0x37
  800328:	68 14 44 80 00       	push   $0x804414
  80032d:	e8 f7 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800332:	e8 fe 27 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800337:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80033a:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033f:	74 14                	je     800355 <_main+0x31d>
  800341:	83 ec 04             	sub    $0x4,%esp
  800344:	68 98 44 80 00       	push   $0x804498
  800349:	6a 38                	push   $0x38
  80034b:	68 14 44 80 00       	push   $0x804414
  800350:	e8 d4 10 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800355:	e8 3b 27 00 00       	call   802a95 <sys_calculate_free_frames>
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035d:	e8 d3 27 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800362:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	50                   	push   %eax
  800371:	e8 e0 22 00 00       	call   802656 <malloc>
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80037c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80037f:	89 c1                	mov    %eax,%ecx
  800381:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800384:	89 d0                	mov    %edx,%eax
  800386:	01 c0                	add    %eax,%eax
  800388:	01 d0                	add    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	05 00 00 00 80       	add    $0x80000000,%eax
  800391:	39 c1                	cmp    %eax,%ecx
  800393:	74 14                	je     8003a9 <_main+0x371>
  800395:	83 ec 04             	sub    $0x4,%esp
  800398:	68 e4 43 80 00       	push   $0x8043e4
  80039d:	6a 3e                	push   $0x3e
  80039f:	68 14 44 80 00       	push   $0x804414
  8003a4:	e8 80 10 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003a9:	e8 e7 26 00 00       	call   802a95 <sys_calculate_free_frames>
  8003ae:	89 c2                	mov    %eax,%edx
  8003b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	74 14                	je     8003cb <_main+0x393>
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	68 2c 44 80 00       	push   $0x80442c
  8003bf:	6a 40                	push   $0x40
  8003c1:	68 14 44 80 00       	push   $0x804414
  8003c6:	e8 5e 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003cb:	e8 65 27 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  8003d0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8003d3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 98 44 80 00       	push   $0x804498
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 14 44 80 00       	push   $0x804414
  8003e9:	e8 3b 10 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003ee:	e8 a2 26 00 00       	call   802a95 <sys_calculate_free_frames>
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003f6:	e8 3a 27 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  8003fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800401:	89 c2                	mov    %eax,%edx
  800403:	01 d2                	add    %edx,%edx
  800405:	01 d0                	add    %edx,%eax
  800407:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80040a:	83 ec 0c             	sub    $0xc,%esp
  80040d:	50                   	push   %eax
  80040e:	e8 43 22 00 00       	call   802656 <malloc>
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800419:	8b 45 90             	mov    -0x70(%ebp),%eax
  80041c:	89 c2                	mov    %eax,%edx
  80041e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	05 00 00 00 80       	add    $0x80000000,%eax
  800429:	39 c2                	cmp    %eax,%edx
  80042b:	74 14                	je     800441 <_main+0x409>
  80042d:	83 ec 04             	sub    $0x4,%esp
  800430:	68 e4 43 80 00       	push   $0x8043e4
  800435:	6a 47                	push   $0x47
  800437:	68 14 44 80 00       	push   $0x804414
  80043c:	e8 e8 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800441:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800444:	e8 4c 26 00 00       	call   802a95 <sys_calculate_free_frames>
  800449:	29 c3                	sub    %eax,%ebx
  80044b:	89 d8                	mov    %ebx,%eax
  80044d:	83 f8 01             	cmp    $0x1,%eax
  800450:	74 14                	je     800466 <_main+0x42e>
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	68 2c 44 80 00       	push   $0x80442c
  80045a:	6a 49                	push   $0x49
  80045c:	68 14 44 80 00       	push   $0x804414
  800461:	e8 c3 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800466:	e8 ca 26 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  80046b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80046e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 98 44 80 00       	push   $0x804498
  80047d:	6a 4a                	push   $0x4a
  80047f:	68 14 44 80 00       	push   $0x804414
  800484:	e8 a0 0f 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800489:	e8 07 26 00 00       	call   802a95 <sys_calculate_free_frames>
  80048e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800491:	e8 9f 26 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800496:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  800499:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80049c:	89 c2                	mov    %eax,%edx
  80049e:	01 d2                	add    %edx,%edx
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8004a5:	83 ec 0c             	sub    $0xc,%esp
  8004a8:	50                   	push   %eax
  8004a9:	e8 a8 21 00 00       	call   802656 <malloc>
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004b4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8004b7:	89 c1                	mov    %eax,%ecx
  8004b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004bc:	89 d0                	mov    %edx,%eax
  8004be:	c1 e0 02             	shl    $0x2,%eax
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	01 c0                	add    %eax,%eax
  8004c5:	01 d0                	add    %edx,%eax
  8004c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8004cc:	39 c1                	cmp    %eax,%ecx
  8004ce:	74 14                	je     8004e4 <_main+0x4ac>
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	68 e4 43 80 00       	push   $0x8043e4
  8004d8:	6a 50                	push   $0x50
  8004da:	68 14 44 80 00       	push   $0x804414
  8004df:	e8 45 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004e4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e7:	e8 a9 25 00 00       	call   802a95 <sys_calculate_free_frames>
  8004ec:	29 c3                	sub    %eax,%ebx
  8004ee:	89 d8                	mov    %ebx,%eax
  8004f0:	83 f8 01             	cmp    $0x1,%eax
  8004f3:	74 14                	je     800509 <_main+0x4d1>
  8004f5:	83 ec 04             	sub    $0x4,%esp
  8004f8:	68 2c 44 80 00       	push   $0x80442c
  8004fd:	6a 52                	push   $0x52
  8004ff:	68 14 44 80 00       	push   $0x804414
  800504:	e8 20 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800509:	e8 27 26 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  80050e:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800511:	3d 00 03 00 00       	cmp    $0x300,%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 98 44 80 00       	push   $0x804498
  800520:	6a 53                	push   $0x53
  800522:	68 14 44 80 00       	push   $0x804414
  800527:	e8 fd 0e 00 00       	call   801429 <_panic>

		//Allocate the remaining space in user heap
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 64 25 00 00       	call   802a95 <sys_calculate_free_frames>
  800531:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800534:	e8 fc 25 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800539:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc((USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega - kilo);
  80053c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	01 c0                	add    %eax,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	01 c0                	add    %eax,%eax
  80054b:	f7 d8                	neg    %eax
  80054d:	89 c2                	mov    %eax,%edx
  80054f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800552:	29 c2                	sub    %eax,%edx
  800554:	89 d0                	mov    %edx,%eax
  800556:	05 00 00 00 20       	add    $0x20000000,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 f2 20 00 00       	call   802656 <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80056a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80056d:	89 c1                	mov    %eax,%ecx
  80056f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800572:	89 d0                	mov    %edx,%eax
  800574:	01 c0                	add    %eax,%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	01 c0                	add    %eax,%eax
  80057a:	01 d0                	add    %edx,%eax
  80057c:	01 c0                	add    %eax,%eax
  80057e:	05 00 00 00 80       	add    $0x80000000,%eax
  800583:	39 c1                	cmp    %eax,%ecx
  800585:	74 14                	je     80059b <_main+0x563>
  800587:	83 ec 04             	sub    $0x4,%esp
  80058a:	68 e4 43 80 00       	push   $0x8043e4
  80058f:	6a 59                	push   $0x59
  800591:	68 14 44 80 00       	push   $0x804414
  800596:	e8 8e 0e 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80059b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80059e:	e8 f2 24 00 00       	call   802a95 <sys_calculate_free_frames>
  8005a3:	29 c3                	sub    %eax,%ebx
  8005a5:	89 d8                	mov    %ebx,%eax
  8005a7:	83 f8 7c             	cmp    $0x7c,%eax
  8005aa:	74 14                	je     8005c0 <_main+0x588>
  8005ac:	83 ec 04             	sub    $0x4,%esp
  8005af:	68 2c 44 80 00       	push   $0x80442c
  8005b4:	6a 5b                	push   $0x5b
  8005b6:	68 14 44 80 00       	push   $0x804414
  8005bb:	e8 69 0e 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005c0:	e8 70 25 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  8005c5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8005c8:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005cd:	74 14                	je     8005e3 <_main+0x5ab>
  8005cf:	83 ec 04             	sub    $0x4,%esp
  8005d2:	68 98 44 80 00       	push   $0x804498
  8005d7:	6a 5c                	push   $0x5c
  8005d9:	68 14 44 80 00       	push   $0x804414
  8005de:	e8 46 0e 00 00       	call   801429 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005e3:	e8 ad 24 00 00       	call   802a95 <sys_calculate_free_frames>
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005eb:	e8 45 25 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  8005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  8005f3:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f9:	83 ec 0c             	sub    $0xc,%esp
  8005fc:	50                   	push   %eax
  8005fd:	e8 eb 20 00 00       	call   8026ed <free>
  800602:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800605:	e8 2b 25 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  80060a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80060d:	29 c2                	sub    %eax,%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	3d 00 01 00 00       	cmp    $0x100,%eax
  800616:	74 14                	je     80062c <_main+0x5f4>
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	68 c8 44 80 00       	push   $0x8044c8
  800620:	6a 67                	push   $0x67
  800622:	68 14 44 80 00       	push   $0x804414
  800627:	e8 fd 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80062c:	e8 64 24 00 00       	call   802a95 <sys_calculate_free_frames>
  800631:	89 c2                	mov    %eax,%edx
  800633:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800636:	39 c2                	cmp    %eax,%edx
  800638:	74 14                	je     80064e <_main+0x616>
  80063a:	83 ec 04             	sub    $0x4,%esp
  80063d:	68 04 45 80 00       	push   $0x804504
  800642:	6a 68                	push   $0x68
  800644:	68 14 44 80 00       	push   $0x804414
  800649:	e8 db 0d 00 00       	call   801429 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80064e:	e8 42 24 00 00       	call   802a95 <sys_calculate_free_frames>
  800653:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800656:	e8 da 24 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  80065b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  80065e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800661:	83 ec 0c             	sub    $0xc,%esp
  800664:	50                   	push   %eax
  800665:	e8 83 20 00 00       	call   8026ed <free>
  80066a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80066d:	e8 c3 24 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800672:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800675:	29 c2                	sub    %eax,%edx
  800677:	89 d0                	mov    %edx,%eax
  800679:	3d 00 02 00 00       	cmp    $0x200,%eax
  80067e:	74 14                	je     800694 <_main+0x65c>
  800680:	83 ec 04             	sub    $0x4,%esp
  800683:	68 c8 44 80 00       	push   $0x8044c8
  800688:	6a 6f                	push   $0x6f
  80068a:	68 14 44 80 00       	push   $0x804414
  80068f:	e8 95 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800694:	e8 fc 23 00 00       	call   802a95 <sys_calculate_free_frames>
  800699:	89 c2                	mov    %eax,%edx
  80069b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069e:	39 c2                	cmp    %eax,%edx
  8006a0:	74 14                	je     8006b6 <_main+0x67e>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 04 45 80 00       	push   $0x804504
  8006aa:	6a 70                	push   $0x70
  8006ac:	68 14 44 80 00       	push   $0x804414
  8006b1:	e8 73 0d 00 00       	call   801429 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006b6:	e8 da 23 00 00       	call   802a95 <sys_calculate_free_frames>
  8006bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006be:	e8 72 24 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  8006c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  8006c6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006c9:	83 ec 0c             	sub    $0xc,%esp
  8006cc:	50                   	push   %eax
  8006cd:	e8 1b 20 00 00       	call   8026ed <free>
  8006d2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006d5:	e8 5b 24 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  8006da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006dd:	29 c2                	sub    %eax,%edx
  8006df:	89 d0                	mov    %edx,%eax
  8006e1:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006e6:	74 14                	je     8006fc <_main+0x6c4>
  8006e8:	83 ec 04             	sub    $0x4,%esp
  8006eb:	68 c8 44 80 00       	push   $0x8044c8
  8006f0:	6a 77                	push   $0x77
  8006f2:	68 14 44 80 00       	push   $0x804414
  8006f7:	e8 2d 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006fc:	e8 94 23 00 00       	call   802a95 <sys_calculate_free_frames>
  800701:	89 c2                	mov    %eax,%edx
  800703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800706:	39 c2                	cmp    %eax,%edx
  800708:	74 14                	je     80071e <_main+0x6e6>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 04 45 80 00       	push   $0x804504
  800712:	6a 78                	push   $0x78
  800714:	68 14 44 80 00       	push   $0x804414
  800719:	e8 0b 0d 00 00       	call   801429 <_panic>
//		free(ptr_allocations[8]);
//		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
//		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
//		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
	}
	int cnt = 0;
  80071e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	6a 03                	push   $0x3
  80072a:	e8 fe 26 00 00       	call   802e2d <sys_bypassPageFault>
  80072f:	83 c4 10             	add    $0x10,%esp

	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate with size = 0*/

		char *byteArr = (char *) ptr_allocations[0];
  800732:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//Reallocate with size = 0 [delete it]
		freeFrames = sys_calculate_free_frames() ;
  80073b:	e8 55 23 00 00       	call   802a95 <sys_calculate_free_frames>
  800740:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800743:	e8 ed 23 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800748:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 0);
  80074b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	6a 00                	push   $0x0
  800756:	50                   	push   %eax
  800757:	e8 b7 21 00 00       	call   802913 <realloc>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != 0) panic("Wrong start address for the re-allocated space...it should return NULL!");
  800765:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80076b:	85 c0                	test   %eax,%eax
  80076d:	74 17                	je     800786 <_main+0x74e>
  80076f:	83 ec 04             	sub    $0x4,%esp
  800772:	68 50 45 80 00       	push   $0x804550
  800777:	68 94 00 00 00       	push   $0x94
  80077c:	68 14 44 80 00       	push   $0x804414
  800781:	e8 a3 0c 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800786:	e8 0a 23 00 00       	call   802a95 <sys_calculate_free_frames>
  80078b:	89 c2                	mov    %eax,%edx
  80078d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800790:	39 c2                	cmp    %eax,%edx
  800792:	74 17                	je     8007ab <_main+0x773>
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	68 98 45 80 00       	push   $0x804598
  80079c:	68 96 00 00 00       	push   $0x96
  8007a1:	68 14 44 80 00       	push   $0x804414
  8007a6:	e8 7e 0c 00 00       	call   801429 <_panic>
		if((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8007ab:	e8 85 23 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  8007b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007b3:	29 c2                	sub    %eax,%edx
  8007b5:	89 d0                	mov    %edx,%eax
  8007b7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 08 46 80 00       	push   $0x804608
  8007c6:	68 97 00 00 00       	push   $0x97
  8007cb:	68 14 44 80 00       	push   $0x804414
  8007d0:	e8 54 0c 00 00       	call   801429 <_panic>

		//[2] test memory access
		byteArr[0] = 10;
  8007d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d8:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("successful access to re-allocated space with size 0!! it should not be succeeded");
  8007db:	e8 34 26 00 00       	call   802e14 <sys_rcr2>
  8007e0:	89 c2                	mov    %eax,%edx
  8007e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e5:	39 c2                	cmp    %eax,%edx
  8007e7:	74 17                	je     800800 <_main+0x7c8>
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	68 3c 46 80 00       	push   $0x80463c
  8007f1:	68 9b 00 00 00       	push   $0x9b
  8007f6:	68 14 44 80 00       	push   $0x804414
  8007fb:	e8 29 0c 00 00       	call   801429 <_panic>
		byteArr[(1*Mega-kilo)/sizeof(char) - 1] = 10;
  800800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800803:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800806:	8d 50 ff             	lea    -0x1(%eax),%edx
  800809:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[(1*Mega-kilo)/sizeof(char) - 1])) panic("successful access to reallocated space of size 0!! it should not be succeeded");
  800811:	e8 fe 25 00 00       	call   802e14 <sys_rcr2>
  800816:	89 c2                	mov    %eax,%edx
  800818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80081e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  800821:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800824:	01 c8                	add    %ecx,%eax
  800826:	39 c2                	cmp    %eax,%edx
  800828:	74 17                	je     800841 <_main+0x809>
  80082a:	83 ec 04             	sub    $0x4,%esp
  80082d:	68 90 46 80 00       	push   $0x804690
  800832:	68 9d 00 00 00       	push   $0x9d
  800837:	68 14 44 80 00       	push   $0x804414
  80083c:	e8 e8 0b 00 00       	call   801429 <_panic>

		//set it to 0 again to cancel the bypassing option
		sys_bypassPageFault(0);
  800841:	83 ec 0c             	sub    $0xc,%esp
  800844:	6a 00                	push   $0x0
  800846:	e8 e2 25 00 00       	call   802e2d <sys_bypassPageFault>
  80084b:	83 c4 10             	add    $0x10,%esp

		vcprintf("\b\b\b20%", NULL);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	6a 00                	push   $0x0
  800853:	68 de 46 80 00       	push   $0x8046de
  800858:	e8 15 0e 00 00       	call   801672 <vcprintf>
  80085d:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate with address = NULL*/

		//new allocation with size = 2.5 MB, should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800860:	e8 30 22 00 00       	call   802a95 <sys_calculate_free_frames>
  800865:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800868:	e8 c8 22 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  80086d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(NULL, 2*Mega + 510*kilo);
  800870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800873:	89 d0                	mov    %edx,%eax
  800875:	c1 e0 08             	shl    $0x8,%eax
  800878:	29 d0                	sub    %edx,%eax
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	01 c0                	add    %eax,%eax
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	50                   	push   %eax
  800887:	6a 00                	push   $0x0
  800889:	e8 85 20 00 00       	call   802913 <realloc>
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800894:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800897:	89 c2                	mov    %eax,%edx
  800899:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80089c:	c1 e0 03             	shl    $0x3,%eax
  80089f:	05 00 00 00 80       	add    $0x80000000,%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	83 ec 04             	sub    $0x4,%esp
  8008ab:	68 e4 43 80 00       	push   $0x8043e4
  8008b0:	68 aa 00 00 00       	push   $0xaa
  8008b5:	68 14 44 80 00       	push   $0x804414
  8008ba:	e8 6a 0b 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 640) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008bf:	e8 d1 21 00 00       	call   802a95 <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	83 ec 04             	sub    $0x4,%esp
  8008d0:	68 98 45 80 00       	push   $0x804598
  8008d5:	68 ac 00 00 00       	push   $0xac
  8008da:	68 14 44 80 00       	push   $0x804414
  8008df:	e8 45 0b 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 640) panic("Extra or less pages are re-allocated in PageFile");
  8008e4:	e8 4c 22 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  8008e9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008ec:	3d 80 02 00 00       	cmp    $0x280,%eax
  8008f1:	74 17                	je     80090a <_main+0x8d2>
  8008f3:	83 ec 04             	sub    $0x4,%esp
  8008f6:	68 08 46 80 00       	push   $0x804608
  8008fb:	68 ad 00 00 00       	push   $0xad
  800900:	68 14 44 80 00       	push   $0x804414
  800905:	e8 1f 0b 00 00       	call   801429 <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[10];
  80090a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80090d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfInt1 = (2*Mega + 510*kilo)/sizeof(int) - 1;
  800910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800913:	89 d0                	mov    %edx,%eax
  800915:	c1 e0 08             	shl    $0x8,%eax
  800918:	29 d0                	sub    %edx,%eax
  80091a:	89 c2                	mov    %eax,%edx
  80091c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	01 c0                	add    %eax,%eax
  800923:	c1 e8 02             	shr    $0x2,%eax
  800926:	48                   	dec    %eax
  800927:	89 45 d0             	mov    %eax,-0x30(%ebp)

		int i = 0;
  80092a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  800931:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800938:	eb 17                	jmp    800951 <_main+0x919>
		{
			intArr[i] = i;
  80093a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800944:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800947:	01 c2                	add    %eax,%edx
  800949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094c:	89 02                	mov    %eax,(%edx)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  80094e:	ff 45 f0             	incl   -0x10(%ebp)
  800951:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800955:	7e e3                	jle    80093a <_main+0x902>
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800957:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80095a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095d:	eb 17                	jmp    800976 <_main+0x93e>
		{
			intArr[i] = i;
  80095f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800962:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800969:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80096c:	01 c2                	add    %eax,%edx
  80096e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800971:	89 02                	mov    %eax,(%edx)
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800973:	ff 4d f0             	decl   -0x10(%ebp)
  800976:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800979:	83 e8 63             	sub    $0x63,%eax
  80097c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80097f:	7e de                	jle    80095f <_main+0x927>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800981:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800988:	eb 33                	jmp    8009bd <_main+0x985>
		{
			cnt++;
  80098a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800997:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80099a:	01 d0                	add    %edx,%eax
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009a1:	74 17                	je     8009ba <_main+0x982>
  8009a3:	83 ec 04             	sub    $0x4,%esp
  8009a6:	68 e8 46 80 00       	push   $0x8046e8
  8009ab:	68 ca 00 00 00       	push   $0xca
  8009b0:	68 14 44 80 00       	push   $0x804414
  8009b5:	e8 6f 0a 00 00       	call   801429 <_panic>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  8009ba:	ff 45 f0             	incl   -0x10(%ebp)
  8009bd:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8009c1:	7e c7                	jle    80098a <_main+0x952>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	eb 33                	jmp    8009fe <_main+0x9c6>
		{
			cnt++;
  8009cb:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009e2:	74 17                	je     8009fb <_main+0x9c3>
  8009e4:	83 ec 04             	sub    $0x4,%esp
  8009e7:	68 e8 46 80 00       	push   $0x8046e8
  8009ec:	68 d0 00 00 00       	push   $0xd0
  8009f1:	68 14 44 80 00       	push   $0x804414
  8009f6:	e8 2e 0a 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009fb:	ff 4d f0             	decl   -0x10(%ebp)
  8009fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a01:	83 e8 63             	sub    $0x63,%eax
  800a04:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a07:	7e c2                	jle    8009cb <_main+0x993>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		vcprintf("\b\b\b40%", NULL);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	68 20 47 80 00       	push   $0x804720
  800a13:	e8 5a 0c 00 00       	call   801672 <vcprintf>
  800a18:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate in the existing internal fragment (no additional pages are required)*/

		//Reallocate last allocation with 1 extra KB [should be placed in the existing 2 KB internal fragment]
		freeFrames = sys_calculate_free_frames() ;
  800a1b:	e8 75 20 00 00       	call   802a95 <sys_calculate_free_frames>
  800a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800a23:	e8 0d 21 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800a28:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(ptr_allocations[10], 2*Mega + 510*kilo + kilo);
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	c1 e0 08             	shl    $0x8,%eax
  800a33:	29 d0                	sub    %edx,%eax
  800a35:	89 c2                	mov    %eax,%edx
  800a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a3a:	01 d0                	add    %edx,%eax
  800a3c:	01 c0                	add    %eax,%eax
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a43:	01 d0                	add    %edx,%eax
  800a45:	89 c2                	mov    %eax,%edx
  800a47:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	52                   	push   %edx
  800a4e:	50                   	push   %eax
  800a4f:	e8 bf 1e 00 00       	call   802913 <realloc>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	89 45 a0             	mov    %eax,-0x60(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800a5a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a62:	c1 e0 03             	shl    $0x3,%eax
  800a65:	05 00 00 00 80       	add    $0x80000000,%eax
  800a6a:	39 c2                	cmp    %eax,%edx
  800a6c:	74 17                	je     800a85 <_main+0xa4d>
  800a6e:	83 ec 04             	sub    $0x4,%esp
  800a71:	68 28 47 80 00       	push   $0x804728
  800a76:	68 dc 00 00 00       	push   $0xdc
  800a7b:	68 14 44 80 00       	push   $0x804414
  800a80:	e8 a4 09 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");

		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800a85:	e8 0b 20 00 00       	call   802a95 <sys_calculate_free_frames>
  800a8a:	89 c2                	mov    %eax,%edx
  800a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8f:	39 c2                	cmp    %eax,%edx
  800a91:	74 17                	je     800aaa <_main+0xa72>
  800a93:	83 ec 04             	sub    $0x4,%esp
  800a96:	68 98 45 80 00       	push   $0x804598
  800a9b:	68 df 00 00 00       	push   $0xdf
  800aa0:	68 14 44 80 00       	push   $0x804414
  800aa5:	e8 7f 09 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800aaa:	e8 86 20 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800aaf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 08 46 80 00       	push   $0x804608
  800abc:	68 e0 00 00 00       	push   $0xe0
  800ac1:	68 14 44 80 00       	push   $0x804414
  800ac6:	e8 5e 09 00 00       	call   801429 <_panic>

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;
  800acb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ace:	89 d0                	mov    %edx,%eax
  800ad0:	c1 e0 08             	shl    $0x8,%eax
  800ad3:	29 d0                	sub    %edx,%eax
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ada:	01 d0                	add    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	89 c2                	mov    %eax,%edx
  800ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ae3:	01 d0                	add    %edx,%eax
  800ae5:	c1 e8 02             	shr    $0x2,%eax
  800ae8:	48                   	dec    %eax
  800ae9:	89 45 cc             	mov    %eax,-0x34(%ebp)

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800aec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800aef:	40                   	inc    %eax
  800af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af3:	eb 17                	jmp    800b0c <_main+0xad4>
		{
			intArr[i] = i ;
  800af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800aff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b02:	01 c2                	add    %eax,%edx
  800b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b07:	89 02                	mov    %eax,(%edx)
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800b09:	ff 45 f0             	incl   -0x10(%ebp)
  800b0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b0f:	83 c0 65             	add    $0x65,%eax
  800b12:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b15:	7f de                	jg     800af5 <_main+0xabd>
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1d:	eb 17                	jmp    800b36 <_main+0xafe>
		{
			intArr[i] = i ;
  800b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b2c:	01 c2                	add    %eax,%edx
  800b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b31:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b33:	ff 4d f0             	decl   -0x10(%ebp)
  800b36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b39:	83 e8 63             	sub    $0x63,%eax
  800b3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b3f:	7e de                	jle    800b1f <_main+0xae7>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b48:	eb 33                	jmp    800b7d <_main+0xb45>
		{
			cnt++;
  800b4a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b5a:	01 d0                	add    %edx,%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b61:	74 17                	je     800b7a <_main+0xb42>
  800b63:	83 ec 04             	sub    $0x4,%esp
  800b66:	68 e8 46 80 00       	push   $0x8046e8
  800b6b:	68 f4 00 00 00       	push   $0xf4
  800b70:	68 14 44 80 00       	push   $0x804414
  800b75:	e8 af 08 00 00       	call   801429 <_panic>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b7a:	ff 45 f0             	incl   -0x10(%ebp)
  800b7d:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800b81:	7e c7                	jle    800b4a <_main+0xb12>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800b83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b86:	48                   	dec    %eax
  800b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8a:	eb 33                	jmp    800bbf <_main+0xb87>
		{
			cnt++;
  800b8c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b9c:	01 d0                	add    %edx,%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ba3:	74 17                	je     800bbc <_main+0xb84>
  800ba5:	83 ec 04             	sub    $0x4,%esp
  800ba8:	68 e8 46 80 00       	push   $0x8046e8
  800bad:	68 f9 00 00 00       	push   $0xf9
  800bb2:	68 14 44 80 00       	push   $0x804414
  800bb7:	e8 6d 08 00 00       	call   801429 <_panic>
		for (i=0; i < 100 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800bbc:	ff 4d f0             	decl   -0x10(%ebp)
  800bbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bc2:	83 e8 63             	sub    $0x63,%eax
  800bc5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bc8:	7e c2                	jle    800b8c <_main+0xb54>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800bca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bcd:	40                   	inc    %eax
  800bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd1:	eb 33                	jmp    800c06 <_main+0xbce>
		{
			cnt++;
  800bd3:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800be0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800be3:	01 d0                	add    %edx,%eax
  800be5:	8b 00                	mov    (%eax),%eax
  800be7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bea:	74 17                	je     800c03 <_main+0xbcb>
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	68 e8 46 80 00       	push   $0x8046e8
  800bf4:	68 fe 00 00 00       	push   $0xfe
  800bf9:	68 14 44 80 00       	push   $0x804414
  800bfe:	e8 26 08 00 00       	call   801429 <_panic>
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800c03:	ff 45 f0             	incl   -0x10(%ebp)
  800c06:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c09:	83 c0 65             	add    $0x65,%eax
  800c0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c0f:	7f c2                	jg     800bd3 <_main+0xb9b>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c17:	eb 33                	jmp    800c4c <_main+0xc14>
		{
			cnt++;
  800c19:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c29:	01 d0                	add    %edx,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c30:	74 17                	je     800c49 <_main+0xc11>
  800c32:	83 ec 04             	sub    $0x4,%esp
  800c35:	68 e8 46 80 00       	push   $0x8046e8
  800c3a:	68 03 01 00 00       	push   $0x103
  800c3f:	68 14 44 80 00       	push   $0x804414
  800c44:	e8 e0 07 00 00       	call   801429 <_panic>
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c49:	ff 4d f0             	decl   -0x10(%ebp)
  800c4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c4f:	83 e8 63             	sub    $0x63,%eax
  800c52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c55:	7e c2                	jle    800c19 <_main+0xbe1>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800c57:	e8 39 1e 00 00       	call   802a95 <sys_calculate_free_frames>
  800c5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c5f:	e8 d1 1e 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800c64:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[10]);
  800c67:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	50                   	push   %eax
  800c6e:	e8 7a 1a 00 00       	call   8026ed <free>
  800c73:	83 c4 10             	add    $0x10,%esp

		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800c76:	e8 ba 1e 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800c7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c7e:	29 c2                	sub    %eax,%edx
  800c80:	89 d0                	mov    %edx,%eax
  800c82:	3d 80 02 00 00       	cmp    $0x280,%eax
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 5c 47 80 00       	push   $0x80475c
  800c91:	68 0d 01 00 00       	push   $0x10d
  800c96:	68 14 44 80 00       	push   $0x804414
  800c9b:	e8 89 07 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800ca0:	e8 f0 1d 00 00       	call   802a95 <sys_calculate_free_frames>
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800caa:	29 c2                	sub    %eax,%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	83 f8 03             	cmp    $0x3,%eax
  800cb1:	74 17                	je     800cca <_main+0xc92>
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	68 b0 47 80 00       	push   $0x8047b0
  800cbb:	68 0e 01 00 00       	push   $0x10e
  800cc0:	68 14 44 80 00       	push   $0x804414
  800cc5:	e8 5f 07 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b60%", NULL);
  800cca:	83 ec 08             	sub    $0x8,%esp
  800ccd:	6a 00                	push   $0x0
  800ccf:	68 14 48 80 00       	push   $0x804814
  800cd4:	e8 99 09 00 00       	call   801672 <vcprintf>
  800cd9:	83 c4 10             	add    $0x10,%esp

		/*CASE4: Re-allocate that can NOT fit in any free fragment*/

		//Fill 3rd allocation with data
		intArr = (int*) ptr_allocations[2];
  800cdc:	8b 45 80             	mov    -0x80(%ebp),%eax
  800cdf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ce2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ce5:	c1 e8 02             	shr    $0x2,%eax
  800ce8:	48                   	dec    %eax
  800ce9:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  800cec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800cf3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cfa:	eb 17                	jmp    800d13 <_main+0xcdb>
		{
			intArr[i] = i ;
  800cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d09:	01 c2                	add    %eax,%edx
  800d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d0e:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800d10:	ff 45 f0             	incl   -0x10(%ebp)
  800d13:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800d17:	7e e3                	jle    800cfc <_main+0xcc4>
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d1f:	eb 17                	jmp    800d38 <_main+0xd00>
		{
			intArr[i] = i;
  800d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d2e:	01 c2                	add    %eax,%edx
  800d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d33:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d35:	ff 4d ec             	decl   -0x14(%ebp)
  800d38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d3b:	83 e8 64             	sub    $0x64,%eax
  800d3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d41:	7c de                	jl     800d21 <_main+0xce9>
		{
			intArr[i] = i;
		}

		//Reallocate it to large size that can't be fit in any free segment
		freeFrames = sys_calculate_free_frames() ;
  800d43:	e8 4d 1d 00 00       	call   802a95 <sys_calculate_free_frames>
  800d48:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d4b:	e8 e5 1d 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800d50:	89 45 dc             	mov    %eax,-0x24(%ebp)
		void* origAddress = ptr_allocations[2];
  800d53:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d56:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = realloc(ptr_allocations[2], (USER_HEAP_MAX - USER_HEAP_START - 13*Mega));
  800d59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d5c:	89 d0                	mov    %edx,%eax
  800d5e:	01 c0                	add    %eax,%eax
  800d60:	01 d0                	add    %edx,%eax
  800d62:	c1 e0 02             	shl    $0x2,%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	f7 d8                	neg    %eax
  800d69:	8d 90 00 00 00 20    	lea    0x20000000(%eax),%edx
  800d6f:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	52                   	push   %edx
  800d76:	50                   	push   %eax
  800d77:	e8 97 1b 00 00       	call   802913 <realloc>
  800d7c:	83 c4 10             	add    $0x10,%esp
  800d7f:	89 45 80             	mov    %eax,-0x80(%ebp)

		//cprintf("%x\n", ptr_allocations[2]);
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[2] != 0) panic("Wrong start address for the re-allocated space... ");
  800d82:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d85:	85 c0                	test   %eax,%eax
  800d87:	74 17                	je     800da0 <_main+0xd68>
  800d89:	83 ec 04             	sub    $0x4,%esp
  800d8c:	68 28 47 80 00       	push   $0x804728
  800d91:	68 2d 01 00 00       	push   $0x12d
  800d96:	68 14 44 80 00       	push   $0x804414
  800d9b:	e8 89 06 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800da0:	e8 f0 1c 00 00       	call   802a95 <sys_calculate_free_frames>
  800da5:	89 c2                	mov    %eax,%edx
  800da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800daa:	39 c2                	cmp    %eax,%edx
  800dac:	74 17                	je     800dc5 <_main+0xd8d>
  800dae:	83 ec 04             	sub    $0x4,%esp
  800db1:	68 98 45 80 00       	push   $0x804598
  800db6:	68 2f 01 00 00       	push   $0x12f
  800dbb:	68 14 44 80 00       	push   $0x804414
  800dc0:	e8 64 06 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800dc5:	e8 6b 1d 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800dca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800dcd:	74 17                	je     800de6 <_main+0xdae>
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	68 08 46 80 00       	push   $0x804608
  800dd7:	68 30 01 00 00       	push   $0x130
  800ddc:	68 14 44 80 00       	push   $0x804414
  800de1:	e8 43 06 00 00       	call   801429 <_panic>

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800de6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ded:	eb 33                	jmp    800e22 <_main+0xdea>
		{
			cnt++;
  800def:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dff:	01 d0                	add    %edx,%eax
  800e01:	8b 00                	mov    (%eax),%eax
  800e03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e06:	74 17                	je     800e1f <_main+0xde7>
  800e08:	83 ec 04             	sub    $0x4,%esp
  800e0b:	68 e8 46 80 00       	push   $0x8046e8
  800e10:	68 36 01 00 00       	push   $0x136
  800e15:	68 14 44 80 00       	push   $0x804414
  800e1a:	e8 0a 06 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800e1f:	ff 45 f0             	incl   -0x10(%ebp)
  800e22:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800e26:	7e c7                	jle    800def <_main+0xdb7>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2e:	eb 33                	jmp    800e63 <_main+0xe2b>
		{
			cnt++;
  800e30:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	8b 00                	mov    (%eax),%eax
  800e44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e47:	74 17                	je     800e60 <_main+0xe28>
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	68 e8 46 80 00       	push   $0x8046e8
  800e51:	68 3c 01 00 00       	push   $0x13c
  800e56:	68 14 44 80 00       	push   $0x804414
  800e5b:	e8 c9 05 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e60:	ff 4d f0             	decl   -0x10(%ebp)
  800e63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e66:	83 e8 64             	sub    $0x64,%eax
  800e69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6c:	7c c2                	jl     800e30 <_main+0xdf8>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after FAILURE expansion
		freeFrames = sys_calculate_free_frames() ;
  800e6e:	e8 22 1c 00 00       	call   802a95 <sys_calculate_free_frames>
  800e73:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e76:	e8 ba 1c 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800e7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(origAddress);
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	ff 75 c8             	pushl  -0x38(%ebp)
  800e84:	e8 64 18 00 00       	call   8026ed <free>
  800e89:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e8c:	e8 a4 1c 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800e91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800e94:	29 c2                	sub    %eax,%edx
  800e96:	89 d0                	mov    %edx,%eax
  800e98:	3d 00 01 00 00       	cmp    $0x100,%eax
  800e9d:	74 17                	je     800eb6 <_main+0xe7e>
  800e9f:	83 ec 04             	sub    $0x4,%esp
  800ea2:	68 5c 47 80 00       	push   $0x80475c
  800ea7:	68 44 01 00 00       	push   $0x144
  800eac:	68 14 44 80 00       	push   $0x804414
  800eb1:	e8 73 05 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800eb6:	e8 da 1b 00 00       	call   802a95 <sys_calculate_free_frames>
  800ebb:	89 c2                	mov    %eax,%edx
  800ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	83 f8 03             	cmp    $0x3,%eax
  800ec7:	74 17                	je     800ee0 <_main+0xea8>
  800ec9:	83 ec 04             	sub    $0x4,%esp
  800ecc:	68 b0 47 80 00       	push   $0x8047b0
  800ed1:	68 45 01 00 00       	push   $0x145
  800ed6:	68 14 44 80 00       	push   $0x804414
  800edb:	e8 49 05 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b80%", NULL);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	6a 00                	push   $0x0
  800ee5:	68 1b 48 80 00       	push   $0x80481b
  800eea:	e8 83 07 00 00       	call   801672 <vcprintf>
  800eef:	83 c4 10             	add    $0x10,%esp
		/*CASE5: Re-allocate that test FIRST FIT strategy*/

		//[1] create 4 MB hole at beginning of the heap

		//Take 2 MB from currently 3 MB hole at beginning of the heap
		freeFrames = sys_calculate_free_frames() ;
  800ef2:	e8 9e 1b 00 00       	call   802a95 <sys_calculate_free_frames>
  800ef7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800efa:	e8 36 1c 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800eff:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = malloc(2*Mega-kilo);
  800f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f05:	01 c0                	add    %eax,%eax
  800f07:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	50                   	push   %eax
  800f0e:	e8 43 17 00 00       	call   802656 <malloc>
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800f19:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800f1c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800f21:	74 17                	je     800f3a <_main+0xf02>
  800f23:	83 ec 04             	sub    $0x4,%esp
  800f26:	68 e4 43 80 00       	push   $0x8043e4
  800f2b:	68 51 01 00 00       	push   $0x151
  800f30:	68 14 44 80 00       	push   $0x804414
  800f35:	e8 ef 04 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800f3a:	e8 56 1b 00 00       	call   802a95 <sys_calculate_free_frames>
  800f3f:	89 c2                	mov    %eax,%edx
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	39 c2                	cmp    %eax,%edx
  800f46:	74 17                	je     800f5f <_main+0xf27>
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	68 2c 44 80 00       	push   $0x80442c
  800f50:	68 53 01 00 00       	push   $0x153
  800f55:	68 14 44 80 00       	push   $0x804414
  800f5a:	e8 ca 04 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800f5f:	e8 d1 1b 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800f64:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800f67:	3d 00 02 00 00       	cmp    $0x200,%eax
  800f6c:	74 17                	je     800f85 <_main+0xf4d>
  800f6e:	83 ec 04             	sub    $0x4,%esp
  800f71:	68 98 44 80 00       	push   $0x804498
  800f76:	68 54 01 00 00       	push   $0x154
  800f7b:	68 14 44 80 00       	push   $0x804414
  800f80:	e8 a4 04 00 00       	call   801429 <_panic>

		//remove 1 MB allocation between 1 MB hole and 2 MB hole to create 4 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f85:	e8 0b 1b 00 00       	call   802a95 <sys_calculate_free_frames>
  800f8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8d:	e8 a3 1b 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800f92:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800f95:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	50                   	push   %eax
  800f9c:	e8 4c 17 00 00       	call   8026ed <free>
  800fa1:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800fa4:	e8 8c 1b 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  800fa9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	3d 00 01 00 00       	cmp    $0x100,%eax
  800fb5:	74 17                	je     800fce <_main+0xf96>
  800fb7:	83 ec 04             	sub    $0x4,%esp
  800fba:	68 c8 44 80 00       	push   $0x8044c8
  800fbf:	68 5b 01 00 00       	push   $0x15b
  800fc4:	68 14 44 80 00       	push   $0x804414
  800fc9:	e8 5b 04 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fce:	e8 c2 1a 00 00       	call   802a95 <sys_calculate_free_frames>
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd8:	39 c2                	cmp    %eax,%edx
  800fda:	74 17                	je     800ff3 <_main+0xfbb>
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	68 04 45 80 00       	push   $0x804504
  800fe4:	68 5c 01 00 00       	push   $0x15c
  800fe9:	68 14 44 80 00       	push   $0x804414
  800fee:	e8 36 04 00 00       	call   801429 <_panic>
		{
			//allocate 1 page after each 3 MB
			sys_allocateMem(i, PAGE_SIZE) ;
		}*/

		malloc(5*Mega-kilo);
  800ff3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ff6:	89 d0                	mov    %edx,%eax
  800ff8:	c1 e0 02             	shl    $0x2,%eax
  800ffb:	01 d0                	add    %edx,%eax
  800ffd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801000:	83 ec 0c             	sub    $0xc,%esp
  801003:	50                   	push   %eax
  801004:	e8 4d 16 00 00       	call   802656 <malloc>
  801009:	83 c4 10             	add    $0x10,%esp

		//Fill last 3MB allocation with data
		intArr = (int*) ptr_allocations[7];
  80100c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80100f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;
  801012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801015:	89 c2                	mov    %eax,%edx
  801017:	01 d2                	add    %edx,%edx
  801019:	01 d0                	add    %edx,%eax
  80101b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80101e:	c1 e8 02             	shr    $0x2,%eax
  801021:	48                   	dec    %eax
  801022:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  801025:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  80102c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801033:	eb 17                	jmp    80104c <_main+0x1014>
		{
			intArr[i] = i ;
  801035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801038:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80103f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801042:	01 c2                	add    %eax,%edx
  801044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801047:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[7];
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  801049:	ff 45 f0             	incl   -0x10(%ebp)
  80104c:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  801050:	7e e3                	jle    801035 <_main+0xffd>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801052:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801055:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801058:	eb 17                	jmp    801071 <_main+0x1039>
		{
			intArr[i] = i;
  80105a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801064:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801067:	01 c2                	add    %eax,%edx
  801069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106c:	89 02                	mov    %eax,(%edx)
		for (i=0; i < 100 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  80106e:	ff 4d f0             	decl   -0x10(%ebp)
  801071:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801074:	83 e8 64             	sub    $0x64,%eax
  801077:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80107a:	7c de                	jl     80105a <_main+0x1022>
		{
			intArr[i] = i;
		}

		//Reallocate it to 4 MB, so that it can only fit at the 1st fragment
		freeFrames = sys_calculate_free_frames() ;
  80107c:	e8 14 1a 00 00       	call   802a95 <sys_calculate_free_frames>
  801081:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801084:	e8 ac 1a 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  801089:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = realloc(ptr_allocations[7], 4*Mega-kilo);
  80108c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80108f:	c1 e0 02             	shl    $0x2,%eax
  801092:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	52                   	push   %edx
  80109e:	50                   	push   %eax
  80109f:	e8 6f 18 00 00       	call   802913 <realloc>
  8010a4:	83 c4 10             	add    $0x10,%esp
  8010a7:	89 45 94             	mov    %eax,-0x6c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the re-allocated space... ");
  8010aa:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8010ad:	89 c2                	mov    %eax,%edx
  8010af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b2:	01 c0                	add    %eax,%eax
  8010b4:	05 00 00 00 80       	add    $0x80000000,%eax
  8010b9:	39 c2                	cmp    %eax,%edx
  8010bb:	74 17                	je     8010d4 <_main+0x109c>
  8010bd:	83 ec 04             	sub    $0x4,%esp
  8010c0:	68 28 47 80 00       	push   $0x804728
  8010c5:	68 7d 01 00 00       	push   $0x17d
  8010ca:	68 14 44 80 00       	push   $0x804414
  8010cf:	e8 55 03 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 - 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 2) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8010d4:	e8 5c 1a 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  8010d9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8010dc:	3d 00 01 00 00       	cmp    $0x100,%eax
  8010e1:	74 17                	je     8010fa <_main+0x10c2>
  8010e3:	83 ec 04             	sub    $0x4,%esp
  8010e6:	68 08 46 80 00       	push   $0x804608
  8010eb:	68 80 01 00 00       	push   $0x180
  8010f0:	68 14 44 80 00       	push   $0x804414
  8010f5:	e8 2f 03 00 00       	call   801429 <_panic>


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
  8010fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010fd:	c1 e0 02             	shl    $0x2,%eax
  801100:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801103:	c1 e8 02             	shr    $0x2,%eax
  801106:	48                   	dec    %eax
  801107:	89 45 cc             	mov    %eax,-0x34(%ebp)
		intArr = (int*) ptr_allocations[7];
  80110a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80110d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801110:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801113:	40                   	inc    %eax
  801114:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801117:	eb 17                	jmp    801130 <_main+0x10f8>
		{
			intArr[i] = i ;
  801119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801123:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801126:	01 c2                	add    %eax,%edx
  801128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112b:	89 02                	mov    %eax,(%edx)


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[7];
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  80112d:	ff 45 f0             	incl   -0x10(%ebp)
  801130:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801133:	83 c0 65             	add    $0x65,%eax
  801136:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801139:	7f de                	jg     801119 <_main+0x10e1>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80113b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80113e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801141:	eb 17                	jmp    80115a <_main+0x1122>
		{
			intArr[i] = i;
  801143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801150:	01 c2                	add    %eax,%edx
  801152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801155:	89 02                	mov    %eax,(%edx)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801157:	ff 4d f0             	decl   -0x10(%ebp)
  80115a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80115d:	83 e8 64             	sub    $0x64,%eax
  801160:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801163:	7c de                	jl     801143 <_main+0x110b>
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  801165:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80116c:	eb 33                	jmp    8011a1 <_main+0x1169>
		{
			cnt++;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  801171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801174:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	8b 00                	mov    (%eax),%eax
  801182:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801185:	74 17                	je     80119e <_main+0x1166>
  801187:	83 ec 04             	sub    $0x4,%esp
  80118a:	68 e8 46 80 00       	push   $0x8046e8
  80118f:	68 93 01 00 00       	push   $0x193
  801194:	68 14 44 80 00       	push   $0x804414
  801199:	e8 8b 02 00 00       	call   801429 <_panic>
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  80119e:	ff 45 f0             	incl   -0x10(%ebp)
  8011a1:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8011a5:	7e c7                	jle    80116e <_main+0x1136>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ad:	eb 33                	jmp    8011e2 <_main+0x11aa>
		{
			cnt++;
  8011af:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011bf:	01 d0                	add    %edx,%eax
  8011c1:	8b 00                	mov    (%eax),%eax
  8011c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c6:	74 17                	je     8011df <_main+0x11a7>
  8011c8:	83 ec 04             	sub    $0x4,%esp
  8011cb:	68 e8 46 80 00       	push   $0x8046e8
  8011d0:	68 99 01 00 00       	push   $0x199
  8011d5:	68 14 44 80 00       	push   $0x804414
  8011da:	e8 4a 02 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011df:	ff 4d f0             	decl   -0x10(%ebp)
  8011e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011e5:	83 e8 64             	sub    $0x64,%eax
  8011e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011eb:	7c c2                	jl     8011af <_main+0x1177>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  8011ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011f0:	40                   	inc    %eax
  8011f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f4:	eb 33                	jmp    801229 <_main+0x11f1>
		{
			cnt++;
  8011f6:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801203:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801206:	01 d0                	add    %edx,%eax
  801208:	8b 00                	mov    (%eax),%eax
  80120a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120d:	74 17                	je     801226 <_main+0x11ee>
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	68 e8 46 80 00       	push   $0x8046e8
  801217:	68 9f 01 00 00       	push   $0x19f
  80121c:	68 14 44 80 00       	push   $0x804414
  801221:	e8 03 02 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801226:	ff 45 f0             	incl   -0x10(%ebp)
  801229:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80122c:	83 c0 65             	add    $0x65,%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7f c2                	jg     8011f6 <_main+0x11be>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801234:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801237:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80123a:	eb 33                	jmp    80126f <_main+0x1237>
		{
			cnt++;
  80123c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80123f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801242:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801249:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80124c:	01 d0                	add    %edx,%eax
  80124e:	8b 00                	mov    (%eax),%eax
  801250:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801253:	74 17                	je     80126c <_main+0x1234>
  801255:	83 ec 04             	sub    $0x4,%esp
  801258:	68 e8 46 80 00       	push   $0x8046e8
  80125d:	68 a5 01 00 00       	push   $0x1a5
  801262:	68 14 44 80 00       	push   $0x804414
  801267:	e8 bd 01 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80126c:	ff 4d f0             	decl   -0x10(%ebp)
  80126f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801272:	83 e8 64             	sub    $0x64,%eax
  801275:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801278:	7c c2                	jl     80123c <_main+0x1204>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  80127a:	e8 16 18 00 00       	call   802a95 <sys_calculate_free_frames>
  80127f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801282:	e8 ae 18 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  801287:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[7]);
  80128a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 57 14 00 00       	call   8026ed <free>
  801296:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  801299:	e8 97 18 00 00       	call   802b35 <sys_pf_calculate_allocated_pages>
  80129e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012a1:	29 c2                	sub    %eax,%edx
  8012a3:	89 d0                	mov    %edx,%eax
  8012a5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012aa:	74 17                	je     8012c3 <_main+0x128b>
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 5c 47 80 00       	push   $0x80475c
  8012b4:	68 ad 01 00 00       	push   $0x1ad
  8012b9:	68 14 44 80 00       	push   $0x804414
  8012be:	e8 66 01 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	6a 00                	push   $0x0
  8012c8:	68 22 48 80 00       	push   $0x804822
  8012cd:	e8 a0 03 00 00       	call   801672 <vcprintf>
  8012d2:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [2] completed successfully.\n");
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	68 2c 48 80 00       	push   $0x80482c
  8012dd:	e8 fb 03 00 00       	call   8016dd <cprintf>
  8012e2:	83 c4 10             	add    $0x10,%esp

	return;
  8012e5:	90                   	nop
}
  8012e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e9:	5b                   	pop    %ebx
  8012ea:	5f                   	pop    %edi
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8012f3:	e8 7d 1a 00 00       	call   802d75 <sys_getenvindex>
  8012f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8012fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	c1 e0 03             	shl    $0x3,%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	01 c0                	add    %eax,%eax
  801307:	01 d0                	add    %edx,%eax
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	01 d0                	add    %edx,%eax
  801312:	c1 e0 04             	shl    $0x4,%eax
  801315:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80131a:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80131f:	a1 20 60 80 00       	mov    0x806020,%eax
  801324:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80132a:	84 c0                	test   %al,%al
  80132c:	74 0f                	je     80133d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80132e:	a1 20 60 80 00       	mov    0x806020,%eax
  801333:	05 5c 05 00 00       	add    $0x55c,%eax
  801338:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80133d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801341:	7e 0a                	jle    80134d <libmain+0x60>
		binaryname = argv[0];
  801343:	8b 45 0c             	mov    0xc(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	ff 75 08             	pushl  0x8(%ebp)
  801356:	e8 dd ec ff ff       	call   800038 <_main>
  80135b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80135e:	e8 1f 18 00 00       	call   802b82 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	68 80 48 80 00       	push   $0x804880
  80136b:	e8 6d 03 00 00       	call   8016dd <cprintf>
  801370:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801373:	a1 20 60 80 00       	mov    0x806020,%eax
  801378:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80137e:	a1 20 60 80 00       	mov    0x806020,%eax
  801383:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  801389:	83 ec 04             	sub    $0x4,%esp
  80138c:	52                   	push   %edx
  80138d:	50                   	push   %eax
  80138e:	68 a8 48 80 00       	push   $0x8048a8
  801393:	e8 45 03 00 00       	call   8016dd <cprintf>
  801398:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80139b:	a1 20 60 80 00       	mov    0x806020,%eax
  8013a0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8013a6:	a1 20 60 80 00       	mov    0x806020,%eax
  8013ab:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8013b1:	a1 20 60 80 00       	mov    0x806020,%eax
  8013b6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8013bc:	51                   	push   %ecx
  8013bd:	52                   	push   %edx
  8013be:	50                   	push   %eax
  8013bf:	68 d0 48 80 00       	push   $0x8048d0
  8013c4:	e8 14 03 00 00       	call   8016dd <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8013cc:	a1 20 60 80 00       	mov    0x806020,%eax
  8013d1:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	50                   	push   %eax
  8013db:	68 28 49 80 00       	push   $0x804928
  8013e0:	e8 f8 02 00 00       	call   8016dd <cprintf>
  8013e5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	68 80 48 80 00       	push   $0x804880
  8013f0:	e8 e8 02 00 00       	call   8016dd <cprintf>
  8013f5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8013f8:	e8 9f 17 00 00       	call   802b9c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8013fd:	e8 19 00 00 00       	call   80141b <exit>
}
  801402:	90                   	nop
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	6a 00                	push   $0x0
  801410:	e8 2c 19 00 00       	call   802d41 <sys_destroy_env>
  801415:	83 c4 10             	add    $0x10,%esp
}
  801418:	90                   	nop
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <exit>:

void
exit(void)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801421:	e8 81 19 00 00       	call   802da7 <sys_exit_env>
}
  801426:	90                   	nop
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80142f:	8d 45 10             	lea    0x10(%ebp),%eax
  801432:	83 c0 04             	add    $0x4,%eax
  801435:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801438:	a1 5c 61 80 00       	mov    0x80615c,%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 16                	je     801457 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801441:	a1 5c 61 80 00       	mov    0x80615c,%eax
  801446:	83 ec 08             	sub    $0x8,%esp
  801449:	50                   	push   %eax
  80144a:	68 3c 49 80 00       	push   $0x80493c
  80144f:	e8 89 02 00 00       	call   8016dd <cprintf>
  801454:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801457:	a1 00 60 80 00       	mov    0x806000,%eax
  80145c:	ff 75 0c             	pushl  0xc(%ebp)
  80145f:	ff 75 08             	pushl  0x8(%ebp)
  801462:	50                   	push   %eax
  801463:	68 41 49 80 00       	push   $0x804941
  801468:	e8 70 02 00 00       	call   8016dd <cprintf>
  80146d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801470:	8b 45 10             	mov    0x10(%ebp),%eax
  801473:	83 ec 08             	sub    $0x8,%esp
  801476:	ff 75 f4             	pushl  -0xc(%ebp)
  801479:	50                   	push   %eax
  80147a:	e8 f3 01 00 00       	call   801672 <vcprintf>
  80147f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801482:	83 ec 08             	sub    $0x8,%esp
  801485:	6a 00                	push   $0x0
  801487:	68 5d 49 80 00       	push   $0x80495d
  80148c:	e8 e1 01 00 00       	call   801672 <vcprintf>
  801491:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801494:	e8 82 ff ff ff       	call   80141b <exit>

	// should not return here
	while (1) ;
  801499:	eb fe                	jmp    801499 <_panic+0x70>

0080149b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8014a1:	a1 20 60 80 00       	mov    0x806020,%eax
  8014a6:	8b 50 74             	mov    0x74(%eax),%edx
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	39 c2                	cmp    %eax,%edx
  8014ae:	74 14                	je     8014c4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8014b0:	83 ec 04             	sub    $0x4,%esp
  8014b3:	68 60 49 80 00       	push   $0x804960
  8014b8:	6a 26                	push   $0x26
  8014ba:	68 ac 49 80 00       	push   $0x8049ac
  8014bf:	e8 65 ff ff ff       	call   801429 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8014c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8014cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014d2:	e9 c2 00 00 00       	jmp    801599 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8014d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	01 d0                	add    %edx,%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	75 08                	jne    8014f4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8014ec:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8014ef:	e9 a2 00 00 00       	jmp    801596 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8014f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8014fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801502:	eb 69                	jmp    80156d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801504:	a1 20 60 80 00       	mov    0x806020,%eax
  801509:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80150f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801512:	89 d0                	mov    %edx,%eax
  801514:	01 c0                	add    %eax,%eax
  801516:	01 d0                	add    %edx,%eax
  801518:	c1 e0 03             	shl    $0x3,%eax
  80151b:	01 c8                	add    %ecx,%eax
  80151d:	8a 40 04             	mov    0x4(%eax),%al
  801520:	84 c0                	test   %al,%al
  801522:	75 46                	jne    80156a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801524:	a1 20 60 80 00       	mov    0x806020,%eax
  801529:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80152f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801532:	89 d0                	mov    %edx,%eax
  801534:	01 c0                	add    %eax,%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	c1 e0 03             	shl    $0x3,%eax
  80153b:	01 c8                	add    %ecx,%eax
  80153d:	8b 00                	mov    (%eax),%eax
  80153f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801542:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801545:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80154a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80154c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	01 c8                	add    %ecx,%eax
  80155b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80155d:	39 c2                	cmp    %eax,%edx
  80155f:	75 09                	jne    80156a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801561:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801568:	eb 12                	jmp    80157c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80156a:	ff 45 e8             	incl   -0x18(%ebp)
  80156d:	a1 20 60 80 00       	mov    0x806020,%eax
  801572:	8b 50 74             	mov    0x74(%eax),%edx
  801575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801578:	39 c2                	cmp    %eax,%edx
  80157a:	77 88                	ja     801504 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80157c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801580:	75 14                	jne    801596 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	68 b8 49 80 00       	push   $0x8049b8
  80158a:	6a 3a                	push   $0x3a
  80158c:	68 ac 49 80 00       	push   $0x8049ac
  801591:	e8 93 fe ff ff       	call   801429 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801596:	ff 45 f0             	incl   -0x10(%ebp)
  801599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80159f:	0f 8c 32 ff ff ff    	jl     8014d7 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8015a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015ac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8015b3:	eb 26                	jmp    8015db <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8015b5:	a1 20 60 80 00       	mov    0x806020,%eax
  8015ba:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8015c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015c3:	89 d0                	mov    %edx,%eax
  8015c5:	01 c0                	add    %eax,%eax
  8015c7:	01 d0                	add    %edx,%eax
  8015c9:	c1 e0 03             	shl    $0x3,%eax
  8015cc:	01 c8                	add    %ecx,%eax
  8015ce:	8a 40 04             	mov    0x4(%eax),%al
  8015d1:	3c 01                	cmp    $0x1,%al
  8015d3:	75 03                	jne    8015d8 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8015d5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015d8:	ff 45 e0             	incl   -0x20(%ebp)
  8015db:	a1 20 60 80 00       	mov    0x806020,%eax
  8015e0:	8b 50 74             	mov    0x74(%eax),%edx
  8015e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e6:	39 c2                	cmp    %eax,%edx
  8015e8:	77 cb                	ja     8015b5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8015ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ed:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8015f0:	74 14                	je     801606 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	68 0c 4a 80 00       	push   $0x804a0c
  8015fa:	6a 44                	push   $0x44
  8015fc:	68 ac 49 80 00       	push   $0x8049ac
  801601:	e8 23 fe ff ff       	call   801429 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801606:	90                   	nop
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	8b 00                	mov    (%eax),%eax
  801614:	8d 48 01             	lea    0x1(%eax),%ecx
  801617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161a:	89 0a                	mov    %ecx,(%edx)
  80161c:	8b 55 08             	mov    0x8(%ebp),%edx
  80161f:	88 d1                	mov    %dl,%cl
  801621:	8b 55 0c             	mov    0xc(%ebp),%edx
  801624:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	8b 00                	mov    (%eax),%eax
  80162d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801632:	75 2c                	jne    801660 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801634:	a0 24 60 80 00       	mov    0x806024,%al
  801639:	0f b6 c0             	movzbl %al,%eax
  80163c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163f:	8b 12                	mov    (%edx),%edx
  801641:	89 d1                	mov    %edx,%ecx
  801643:	8b 55 0c             	mov    0xc(%ebp),%edx
  801646:	83 c2 08             	add    $0x8,%edx
  801649:	83 ec 04             	sub    $0x4,%esp
  80164c:	50                   	push   %eax
  80164d:	51                   	push   %ecx
  80164e:	52                   	push   %edx
  80164f:	e8 80 13 00 00       	call   8029d4 <sys_cputs>
  801654:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801660:	8b 45 0c             	mov    0xc(%ebp),%eax
  801663:	8b 40 04             	mov    0x4(%eax),%eax
  801666:	8d 50 01             	lea    0x1(%eax),%edx
  801669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80166f:	90                   	nop
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80167b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801682:	00 00 00 
	b.cnt = 0;
  801685:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80168c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80169b:	50                   	push   %eax
  80169c:	68 09 16 80 00       	push   $0x801609
  8016a1:	e8 11 02 00 00       	call   8018b7 <vprintfmt>
  8016a6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8016a9:	a0 24 60 80 00       	mov    0x806024,%al
  8016ae:	0f b6 c0             	movzbl %al,%eax
  8016b1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	50                   	push   %eax
  8016bb:	52                   	push   %edx
  8016bc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8016c2:	83 c0 08             	add    $0x8,%eax
  8016c5:	50                   	push   %eax
  8016c6:	e8 09 13 00 00       	call   8029d4 <sys_cputs>
  8016cb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8016ce:	c6 05 24 60 80 00 00 	movb   $0x0,0x806024
	return b.cnt;
  8016d5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <cprintf>:

int cprintf(const char *fmt, ...) {
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8016e3:	c6 05 24 60 80 00 01 	movb   $0x1,0x806024
	va_start(ap, fmt);
  8016ea:	8d 45 0c             	lea    0xc(%ebp),%eax
  8016ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	83 ec 08             	sub    $0x8,%esp
  8016f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f9:	50                   	push   %eax
  8016fa:	e8 73 ff ff ff       	call   801672 <vcprintf>
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801710:	e8 6d 14 00 00       	call   802b82 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801715:	8d 45 0c             	lea    0xc(%ebp),%eax
  801718:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	83 ec 08             	sub    $0x8,%esp
  801721:	ff 75 f4             	pushl  -0xc(%ebp)
  801724:	50                   	push   %eax
  801725:	e8 48 ff ff ff       	call   801672 <vcprintf>
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801730:	e8 67 14 00 00       	call   802b9c <sys_enable_interrupt>
	return cnt;
  801735:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	53                   	push   %ebx
  80173e:	83 ec 14             	sub    $0x14,%esp
  801741:	8b 45 10             	mov    0x10(%ebp),%eax
  801744:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801747:	8b 45 14             	mov    0x14(%ebp),%eax
  80174a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80174d:	8b 45 18             	mov    0x18(%ebp),%eax
  801750:	ba 00 00 00 00       	mov    $0x0,%edx
  801755:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801758:	77 55                	ja     8017af <printnum+0x75>
  80175a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80175d:	72 05                	jb     801764 <printnum+0x2a>
  80175f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801762:	77 4b                	ja     8017af <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801764:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801767:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80176a:	8b 45 18             	mov    0x18(%ebp),%eax
  80176d:	ba 00 00 00 00       	mov    $0x0,%edx
  801772:	52                   	push   %edx
  801773:	50                   	push   %eax
  801774:	ff 75 f4             	pushl  -0xc(%ebp)
  801777:	ff 75 f0             	pushl  -0x10(%ebp)
  80177a:	e8 cd 29 00 00       	call   80414c <__udivdi3>
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	ff 75 20             	pushl  0x20(%ebp)
  801788:	53                   	push   %ebx
  801789:	ff 75 18             	pushl  0x18(%ebp)
  80178c:	52                   	push   %edx
  80178d:	50                   	push   %eax
  80178e:	ff 75 0c             	pushl  0xc(%ebp)
  801791:	ff 75 08             	pushl  0x8(%ebp)
  801794:	e8 a1 ff ff ff       	call   80173a <printnum>
  801799:	83 c4 20             	add    $0x20,%esp
  80179c:	eb 1a                	jmp    8017b8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80179e:	83 ec 08             	sub    $0x8,%esp
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	ff 75 20             	pushl  0x20(%ebp)
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	ff d0                	call   *%eax
  8017ac:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8017af:	ff 4d 1c             	decl   0x1c(%ebp)
  8017b2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8017b6:	7f e6                	jg     80179e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017b8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8017bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c6:	53                   	push   %ebx
  8017c7:	51                   	push   %ecx
  8017c8:	52                   	push   %edx
  8017c9:	50                   	push   %eax
  8017ca:	e8 8d 2a 00 00       	call   80425c <__umoddi3>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	05 74 4c 80 00       	add    $0x804c74,%eax
  8017d7:	8a 00                	mov    (%eax),%al
  8017d9:	0f be c0             	movsbl %al,%eax
  8017dc:	83 ec 08             	sub    $0x8,%esp
  8017df:	ff 75 0c             	pushl  0xc(%ebp)
  8017e2:	50                   	push   %eax
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	ff d0                	call   *%eax
  8017e8:	83 c4 10             	add    $0x10,%esp
}
  8017eb:	90                   	nop
  8017ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8017f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8017f8:	7e 1c                	jle    801816 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8b 00                	mov    (%eax),%eax
  8017ff:	8d 50 08             	lea    0x8(%eax),%edx
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	89 10                	mov    %edx,(%eax)
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	83 e8 08             	sub    $0x8,%eax
  80180f:	8b 50 04             	mov    0x4(%eax),%edx
  801812:	8b 00                	mov    (%eax),%eax
  801814:	eb 40                	jmp    801856 <getuint+0x65>
	else if (lflag)
  801816:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80181a:	74 1e                	je     80183a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8b 00                	mov    (%eax),%eax
  801821:	8d 50 04             	lea    0x4(%eax),%edx
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	89 10                	mov    %edx,(%eax)
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8b 00                	mov    (%eax),%eax
  80182e:	83 e8 04             	sub    $0x4,%eax
  801831:	8b 00                	mov    (%eax),%eax
  801833:	ba 00 00 00 00       	mov    $0x0,%edx
  801838:	eb 1c                	jmp    801856 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	8b 00                	mov    (%eax),%eax
  80183f:	8d 50 04             	lea    0x4(%eax),%edx
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	89 10                	mov    %edx,(%eax)
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8b 00                	mov    (%eax),%eax
  80184c:	83 e8 04             	sub    $0x4,%eax
  80184f:	8b 00                	mov    (%eax),%eax
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801856:	5d                   	pop    %ebp
  801857:	c3                   	ret    

00801858 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80185b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80185f:	7e 1c                	jle    80187d <getint+0x25>
		return va_arg(*ap, long long);
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	8b 00                	mov    (%eax),%eax
  801866:	8d 50 08             	lea    0x8(%eax),%edx
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	89 10                	mov    %edx,(%eax)
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	8b 00                	mov    (%eax),%eax
  801873:	83 e8 08             	sub    $0x8,%eax
  801876:	8b 50 04             	mov    0x4(%eax),%edx
  801879:	8b 00                	mov    (%eax),%eax
  80187b:	eb 38                	jmp    8018b5 <getint+0x5d>
	else if (lflag)
  80187d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801881:	74 1a                	je     80189d <getint+0x45>
		return va_arg(*ap, long);
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	8b 00                	mov    (%eax),%eax
  801888:	8d 50 04             	lea    0x4(%eax),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	89 10                	mov    %edx,(%eax)
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	8b 00                	mov    (%eax),%eax
  801895:	83 e8 04             	sub    $0x4,%eax
  801898:	8b 00                	mov    (%eax),%eax
  80189a:	99                   	cltd   
  80189b:	eb 18                	jmp    8018b5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8b 00                	mov    (%eax),%eax
  8018a2:	8d 50 04             	lea    0x4(%eax),%edx
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	89 10                	mov    %edx,(%eax)
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	8b 00                	mov    (%eax),%eax
  8018af:	83 e8 04             	sub    $0x4,%eax
  8018b2:	8b 00                	mov    (%eax),%eax
  8018b4:	99                   	cltd   
}
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	56                   	push   %esi
  8018bb:	53                   	push   %ebx
  8018bc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018bf:	eb 17                	jmp    8018d8 <vprintfmt+0x21>
			if (ch == '\0')
  8018c1:	85 db                	test   %ebx,%ebx
  8018c3:	0f 84 af 03 00 00    	je     801c78 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	53                   	push   %ebx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	ff d0                	call   *%eax
  8018d5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018db:	8d 50 01             	lea    0x1(%eax),%edx
  8018de:	89 55 10             	mov    %edx,0x10(%ebp)
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	0f b6 d8             	movzbl %al,%ebx
  8018e6:	83 fb 25             	cmp    $0x25,%ebx
  8018e9:	75 d6                	jne    8018c1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8018eb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8018ef:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8018f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8018fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801904:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80190b:	8b 45 10             	mov    0x10(%ebp),%eax
  80190e:	8d 50 01             	lea    0x1(%eax),%edx
  801911:	89 55 10             	mov    %edx,0x10(%ebp)
  801914:	8a 00                	mov    (%eax),%al
  801916:	0f b6 d8             	movzbl %al,%ebx
  801919:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80191c:	83 f8 55             	cmp    $0x55,%eax
  80191f:	0f 87 2b 03 00 00    	ja     801c50 <vprintfmt+0x399>
  801925:	8b 04 85 98 4c 80 00 	mov    0x804c98(,%eax,4),%eax
  80192c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80192e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801932:	eb d7                	jmp    80190b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801934:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801938:	eb d1                	jmp    80190b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80193a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801941:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801944:	89 d0                	mov    %edx,%eax
  801946:	c1 e0 02             	shl    $0x2,%eax
  801949:	01 d0                	add    %edx,%eax
  80194b:	01 c0                	add    %eax,%eax
  80194d:	01 d8                	add    %ebx,%eax
  80194f:	83 e8 30             	sub    $0x30,%eax
  801952:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801955:	8b 45 10             	mov    0x10(%ebp),%eax
  801958:	8a 00                	mov    (%eax),%al
  80195a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80195d:	83 fb 2f             	cmp    $0x2f,%ebx
  801960:	7e 3e                	jle    8019a0 <vprintfmt+0xe9>
  801962:	83 fb 39             	cmp    $0x39,%ebx
  801965:	7f 39                	jg     8019a0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801967:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80196a:	eb d5                	jmp    801941 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80196c:	8b 45 14             	mov    0x14(%ebp),%eax
  80196f:	83 c0 04             	add    $0x4,%eax
  801972:	89 45 14             	mov    %eax,0x14(%ebp)
  801975:	8b 45 14             	mov    0x14(%ebp),%eax
  801978:	83 e8 04             	sub    $0x4,%eax
  80197b:	8b 00                	mov    (%eax),%eax
  80197d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801980:	eb 1f                	jmp    8019a1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801982:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801986:	79 83                	jns    80190b <vprintfmt+0x54>
				width = 0;
  801988:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80198f:	e9 77 ff ff ff       	jmp    80190b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801994:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80199b:	e9 6b ff ff ff       	jmp    80190b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8019a0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8019a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019a5:	0f 89 60 ff ff ff    	jns    80190b <vprintfmt+0x54>
				width = precision, precision = -1;
  8019ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8019b8:	e9 4e ff ff ff       	jmp    80190b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8019bd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8019c0:	e9 46 ff ff ff       	jmp    80190b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8019c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c8:	83 c0 04             	add    $0x4,%eax
  8019cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8019ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d1:	83 e8 04             	sub    $0x4,%eax
  8019d4:	8b 00                	mov    (%eax),%eax
  8019d6:	83 ec 08             	sub    $0x8,%esp
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	50                   	push   %eax
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	ff d0                	call   *%eax
  8019e2:	83 c4 10             	add    $0x10,%esp
			break;
  8019e5:	e9 89 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8019ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ed:	83 c0 04             	add    $0x4,%eax
  8019f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8019f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f6:	83 e8 04             	sub    $0x4,%eax
  8019f9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8019fb:	85 db                	test   %ebx,%ebx
  8019fd:	79 02                	jns    801a01 <vprintfmt+0x14a>
				err = -err;
  8019ff:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801a01:	83 fb 64             	cmp    $0x64,%ebx
  801a04:	7f 0b                	jg     801a11 <vprintfmt+0x15a>
  801a06:	8b 34 9d e0 4a 80 00 	mov    0x804ae0(,%ebx,4),%esi
  801a0d:	85 f6                	test   %esi,%esi
  801a0f:	75 19                	jne    801a2a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801a11:	53                   	push   %ebx
  801a12:	68 85 4c 80 00       	push   $0x804c85
  801a17:	ff 75 0c             	pushl  0xc(%ebp)
  801a1a:	ff 75 08             	pushl  0x8(%ebp)
  801a1d:	e8 5e 02 00 00       	call   801c80 <printfmt>
  801a22:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a25:	e9 49 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a2a:	56                   	push   %esi
  801a2b:	68 8e 4c 80 00       	push   $0x804c8e
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	e8 45 02 00 00       	call   801c80 <printfmt>
  801a3b:	83 c4 10             	add    $0x10,%esp
			break;
  801a3e:	e9 30 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801a43:	8b 45 14             	mov    0x14(%ebp),%eax
  801a46:	83 c0 04             	add    $0x4,%eax
  801a49:	89 45 14             	mov    %eax,0x14(%ebp)
  801a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4f:	83 e8 04             	sub    $0x4,%eax
  801a52:	8b 30                	mov    (%eax),%esi
  801a54:	85 f6                	test   %esi,%esi
  801a56:	75 05                	jne    801a5d <vprintfmt+0x1a6>
				p = "(null)";
  801a58:	be 91 4c 80 00       	mov    $0x804c91,%esi
			if (width > 0 && padc != '-')
  801a5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a61:	7e 6d                	jle    801ad0 <vprintfmt+0x219>
  801a63:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801a67:	74 67                	je     801ad0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801a69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a6c:	83 ec 08             	sub    $0x8,%esp
  801a6f:	50                   	push   %eax
  801a70:	56                   	push   %esi
  801a71:	e8 0c 03 00 00       	call   801d82 <strnlen>
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801a7c:	eb 16                	jmp    801a94 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801a7e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	50                   	push   %eax
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	ff d0                	call   *%eax
  801a8e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801a91:	ff 4d e4             	decl   -0x1c(%ebp)
  801a94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a98:	7f e4                	jg     801a7e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a9a:	eb 34                	jmp    801ad0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801a9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801aa0:	74 1c                	je     801abe <vprintfmt+0x207>
  801aa2:	83 fb 1f             	cmp    $0x1f,%ebx
  801aa5:	7e 05                	jle    801aac <vprintfmt+0x1f5>
  801aa7:	83 fb 7e             	cmp    $0x7e,%ebx
  801aaa:	7e 12                	jle    801abe <vprintfmt+0x207>
					putch('?', putdat);
  801aac:	83 ec 08             	sub    $0x8,%esp
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	6a 3f                	push   $0x3f
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	ff d0                	call   *%eax
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	eb 0f                	jmp    801acd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801abe:	83 ec 08             	sub    $0x8,%esp
  801ac1:	ff 75 0c             	pushl  0xc(%ebp)
  801ac4:	53                   	push   %ebx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	ff d0                	call   *%eax
  801aca:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801acd:	ff 4d e4             	decl   -0x1c(%ebp)
  801ad0:	89 f0                	mov    %esi,%eax
  801ad2:	8d 70 01             	lea    0x1(%eax),%esi
  801ad5:	8a 00                	mov    (%eax),%al
  801ad7:	0f be d8             	movsbl %al,%ebx
  801ada:	85 db                	test   %ebx,%ebx
  801adc:	74 24                	je     801b02 <vprintfmt+0x24b>
  801ade:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ae2:	78 b8                	js     801a9c <vprintfmt+0x1e5>
  801ae4:	ff 4d e0             	decl   -0x20(%ebp)
  801ae7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801aeb:	79 af                	jns    801a9c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801aed:	eb 13                	jmp    801b02 <vprintfmt+0x24b>
				putch(' ', putdat);
  801aef:	83 ec 08             	sub    $0x8,%esp
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	6a 20                	push   $0x20
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	ff d0                	call   *%eax
  801afc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801aff:	ff 4d e4             	decl   -0x1c(%ebp)
  801b02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b06:	7f e7                	jg     801aef <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801b08:	e9 66 01 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801b0d:	83 ec 08             	sub    $0x8,%esp
  801b10:	ff 75 e8             	pushl  -0x18(%ebp)
  801b13:	8d 45 14             	lea    0x14(%ebp),%eax
  801b16:	50                   	push   %eax
  801b17:	e8 3c fd ff ff       	call   801858 <getint>
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2b:	85 d2                	test   %edx,%edx
  801b2d:	79 23                	jns    801b52 <vprintfmt+0x29b>
				putch('-', putdat);
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	6a 2d                	push   $0x2d
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	ff d0                	call   *%eax
  801b3c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b45:	f7 d8                	neg    %eax
  801b47:	83 d2 00             	adc    $0x0,%edx
  801b4a:	f7 da                	neg    %edx
  801b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801b52:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b59:	e9 bc 00 00 00       	jmp    801c1a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801b5e:	83 ec 08             	sub    $0x8,%esp
  801b61:	ff 75 e8             	pushl  -0x18(%ebp)
  801b64:	8d 45 14             	lea    0x14(%ebp),%eax
  801b67:	50                   	push   %eax
  801b68:	e8 84 fc ff ff       	call   8017f1 <getuint>
  801b6d:	83 c4 10             	add    $0x10,%esp
  801b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b73:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801b76:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b7d:	e9 98 00 00 00       	jmp    801c1a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801b82:	83 ec 08             	sub    $0x8,%esp
  801b85:	ff 75 0c             	pushl  0xc(%ebp)
  801b88:	6a 58                	push   $0x58
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	ff d0                	call   *%eax
  801b8f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801b92:	83 ec 08             	sub    $0x8,%esp
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	6a 58                	push   $0x58
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	ff d0                	call   *%eax
  801b9f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801ba2:	83 ec 08             	sub    $0x8,%esp
  801ba5:	ff 75 0c             	pushl  0xc(%ebp)
  801ba8:	6a 58                	push   $0x58
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	ff d0                	call   *%eax
  801baf:	83 c4 10             	add    $0x10,%esp
			break;
  801bb2:	e9 bc 00 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801bb7:	83 ec 08             	sub    $0x8,%esp
  801bba:	ff 75 0c             	pushl  0xc(%ebp)
  801bbd:	6a 30                	push   $0x30
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	ff d0                	call   *%eax
  801bc4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	6a 78                	push   $0x78
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	ff d0                	call   *%eax
  801bd4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bda:	83 c0 04             	add    $0x4,%eax
  801bdd:	89 45 14             	mov    %eax,0x14(%ebp)
  801be0:	8b 45 14             	mov    0x14(%ebp),%eax
  801be3:	83 e8 04             	sub    $0x4,%eax
  801be6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801bf2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801bf9:	eb 1f                	jmp    801c1a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801bfb:	83 ec 08             	sub    $0x8,%esp
  801bfe:	ff 75 e8             	pushl  -0x18(%ebp)
  801c01:	8d 45 14             	lea    0x14(%ebp),%eax
  801c04:	50                   	push   %eax
  801c05:	e8 e7 fb ff ff       	call   8017f1 <getuint>
  801c0a:	83 c4 10             	add    $0x10,%esp
  801c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c10:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801c13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801c1a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	52                   	push   %edx
  801c25:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c28:	50                   	push   %eax
  801c29:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2c:	ff 75 f0             	pushl  -0x10(%ebp)
  801c2f:	ff 75 0c             	pushl  0xc(%ebp)
  801c32:	ff 75 08             	pushl  0x8(%ebp)
  801c35:	e8 00 fb ff ff       	call   80173a <printnum>
  801c3a:	83 c4 20             	add    $0x20,%esp
			break;
  801c3d:	eb 34                	jmp    801c73 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801c3f:	83 ec 08             	sub    $0x8,%esp
  801c42:	ff 75 0c             	pushl  0xc(%ebp)
  801c45:	53                   	push   %ebx
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	ff d0                	call   *%eax
  801c4b:	83 c4 10             	add    $0x10,%esp
			break;
  801c4e:	eb 23                	jmp    801c73 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801c50:	83 ec 08             	sub    $0x8,%esp
  801c53:	ff 75 0c             	pushl  0xc(%ebp)
  801c56:	6a 25                	push   $0x25
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	ff d0                	call   *%eax
  801c5d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c60:	ff 4d 10             	decl   0x10(%ebp)
  801c63:	eb 03                	jmp    801c68 <vprintfmt+0x3b1>
  801c65:	ff 4d 10             	decl   0x10(%ebp)
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	48                   	dec    %eax
  801c6c:	8a 00                	mov    (%eax),%al
  801c6e:	3c 25                	cmp    $0x25,%al
  801c70:	75 f3                	jne    801c65 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801c72:	90                   	nop
		}
	}
  801c73:	e9 47 fc ff ff       	jmp    8018bf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801c78:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801c79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5e                   	pop    %esi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    

00801c80 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801c86:	8d 45 10             	lea    0x10(%ebp),%eax
  801c89:	83 c0 04             	add    $0x4,%eax
  801c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801c8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c92:	ff 75 f4             	pushl  -0xc(%ebp)
  801c95:	50                   	push   %eax
  801c96:	ff 75 0c             	pushl  0xc(%ebp)
  801c99:	ff 75 08             	pushl  0x8(%ebp)
  801c9c:	e8 16 fc ff ff       	call   8018b7 <vprintfmt>
  801ca1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801ca4:	90                   	nop
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cad:	8b 40 08             	mov    0x8(%eax),%eax
  801cb0:	8d 50 01             	lea    0x1(%eax),%edx
  801cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbc:	8b 10                	mov    (%eax),%edx
  801cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc1:	8b 40 04             	mov    0x4(%eax),%eax
  801cc4:	39 c2                	cmp    %eax,%edx
  801cc6:	73 12                	jae    801cda <sprintputch+0x33>
		*b->buf++ = ch;
  801cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccb:	8b 00                	mov    (%eax),%eax
  801ccd:	8d 48 01             	lea    0x1(%eax),%ecx
  801cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd3:	89 0a                	mov    %ecx,(%edx)
  801cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  801cd8:	88 10                	mov    %dl,(%eax)
}
  801cda:	90                   	nop
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    

00801cdd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cec:	8d 50 ff             	lea    -0x1(%eax),%edx
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	01 d0                	add    %edx,%eax
  801cf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801cfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d02:	74 06                	je     801d0a <vsnprintf+0x2d>
  801d04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d08:	7f 07                	jg     801d11 <vsnprintf+0x34>
		return -E_INVAL;
  801d0a:	b8 03 00 00 00       	mov    $0x3,%eax
  801d0f:	eb 20                	jmp    801d31 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801d11:	ff 75 14             	pushl  0x14(%ebp)
  801d14:	ff 75 10             	pushl  0x10(%ebp)
  801d17:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d1a:	50                   	push   %eax
  801d1b:	68 a7 1c 80 00       	push   $0x801ca7
  801d20:	e8 92 fb ff ff       	call   8018b7 <vprintfmt>
  801d25:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801d39:	8d 45 10             	lea    0x10(%ebp),%eax
  801d3c:	83 c0 04             	add    $0x4,%eax
  801d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801d42:	8b 45 10             	mov    0x10(%ebp),%eax
  801d45:	ff 75 f4             	pushl  -0xc(%ebp)
  801d48:	50                   	push   %eax
  801d49:	ff 75 0c             	pushl  0xc(%ebp)
  801d4c:	ff 75 08             	pushl  0x8(%ebp)
  801d4f:	e8 89 ff ff ff       	call   801cdd <vsnprintf>
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d6c:	eb 06                	jmp    801d74 <strlen+0x15>
		n++;
  801d6e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d71:	ff 45 08             	incl   0x8(%ebp)
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	8a 00                	mov    (%eax),%al
  801d79:	84 c0                	test   %al,%al
  801d7b:	75 f1                	jne    801d6e <strlen+0xf>
		n++;
	return n;
  801d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d8f:	eb 09                	jmp    801d9a <strnlen+0x18>
		n++;
  801d91:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d94:	ff 45 08             	incl   0x8(%ebp)
  801d97:	ff 4d 0c             	decl   0xc(%ebp)
  801d9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d9e:	74 09                	je     801da9 <strnlen+0x27>
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	8a 00                	mov    (%eax),%al
  801da5:	84 c0                	test   %al,%al
  801da7:	75 e8                	jne    801d91 <strnlen+0xf>
		n++;
	return n;
  801da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801dba:	90                   	nop
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	8d 50 01             	lea    0x1(%eax),%edx
  801dc1:	89 55 08             	mov    %edx,0x8(%ebp)
  801dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  801dca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801dcd:	8a 12                	mov    (%edx),%dl
  801dcf:	88 10                	mov    %dl,(%eax)
  801dd1:	8a 00                	mov    (%eax),%al
  801dd3:	84 c0                	test   %al,%al
  801dd5:	75 e4                	jne    801dbb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801def:	eb 1f                	jmp    801e10 <strncpy+0x34>
		*dst++ = *src;
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	8d 50 01             	lea    0x1(%eax),%edx
  801df7:	89 55 08             	mov    %edx,0x8(%ebp)
  801dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfd:	8a 12                	mov    (%edx),%dl
  801dff:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e04:	8a 00                	mov    (%eax),%al
  801e06:	84 c0                	test   %al,%al
  801e08:	74 03                	je     801e0d <strncpy+0x31>
			src++;
  801e0a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801e0d:	ff 45 fc             	incl   -0x4(%ebp)
  801e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e13:	3b 45 10             	cmp    0x10(%ebp),%eax
  801e16:	72 d9                	jb     801df1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801e18:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801e29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e2d:	74 30                	je     801e5f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801e2f:	eb 16                	jmp    801e47 <strlcpy+0x2a>
			*dst++ = *src++;
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	8d 50 01             	lea    0x1(%eax),%edx
  801e37:	89 55 08             	mov    %edx,0x8(%ebp)
  801e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e40:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e43:	8a 12                	mov    (%edx),%dl
  801e45:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e47:	ff 4d 10             	decl   0x10(%ebp)
  801e4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e4e:	74 09                	je     801e59 <strlcpy+0x3c>
  801e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e53:	8a 00                	mov    (%eax),%al
  801e55:	84 c0                	test   %al,%al
  801e57:	75 d8                	jne    801e31 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  801e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e65:	29 c2                	sub    %eax,%edx
  801e67:	89 d0                	mov    %edx,%eax
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e6e:	eb 06                	jmp    801e76 <strcmp+0xb>
		p++, q++;
  801e70:	ff 45 08             	incl   0x8(%ebp)
  801e73:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	8a 00                	mov    (%eax),%al
  801e7b:	84 c0                	test   %al,%al
  801e7d:	74 0e                	je     801e8d <strcmp+0x22>
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	8a 10                	mov    (%eax),%dl
  801e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e87:	8a 00                	mov    (%eax),%al
  801e89:	38 c2                	cmp    %al,%dl
  801e8b:	74 e3                	je     801e70 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	8a 00                	mov    (%eax),%al
  801e92:	0f b6 d0             	movzbl %al,%edx
  801e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e98:	8a 00                	mov    (%eax),%al
  801e9a:	0f b6 c0             	movzbl %al,%eax
  801e9d:	29 c2                	sub    %eax,%edx
  801e9f:	89 d0                	mov    %edx,%eax
}
  801ea1:	5d                   	pop    %ebp
  801ea2:	c3                   	ret    

00801ea3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801ea6:	eb 09                	jmp    801eb1 <strncmp+0xe>
		n--, p++, q++;
  801ea8:	ff 4d 10             	decl   0x10(%ebp)
  801eab:	ff 45 08             	incl   0x8(%ebp)
  801eae:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801eb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eb5:	74 17                	je     801ece <strncmp+0x2b>
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	8a 00                	mov    (%eax),%al
  801ebc:	84 c0                	test   %al,%al
  801ebe:	74 0e                	je     801ece <strncmp+0x2b>
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	8a 10                	mov    (%eax),%dl
  801ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec8:	8a 00                	mov    (%eax),%al
  801eca:	38 c2                	cmp    %al,%dl
  801ecc:	74 da                	je     801ea8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801ece:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ed2:	75 07                	jne    801edb <strncmp+0x38>
		return 0;
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	eb 14                	jmp    801eef <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	8a 00                	mov    (%eax),%al
  801ee0:	0f b6 d0             	movzbl %al,%edx
  801ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee6:	8a 00                	mov    (%eax),%al
  801ee8:	0f b6 c0             	movzbl %al,%eax
  801eeb:	29 c2                	sub    %eax,%edx
  801eed:	89 d0                	mov    %edx,%eax
}
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    

00801ef1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 04             	sub    $0x4,%esp
  801ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801efd:	eb 12                	jmp    801f11 <strchr+0x20>
		if (*s == c)
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	8a 00                	mov    (%eax),%al
  801f04:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f07:	75 05                	jne    801f0e <strchr+0x1d>
			return (char *) s;
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	eb 11                	jmp    801f1f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801f0e:	ff 45 08             	incl   0x8(%ebp)
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	8a 00                	mov    (%eax),%al
  801f16:	84 c0                	test   %al,%al
  801f18:	75 e5                	jne    801eff <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 04             	sub    $0x4,%esp
  801f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801f2d:	eb 0d                	jmp    801f3c <strfind+0x1b>
		if (*s == c)
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	8a 00                	mov    (%eax),%al
  801f34:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f37:	74 0e                	je     801f47 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f39:	ff 45 08             	incl   0x8(%ebp)
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	8a 00                	mov    (%eax),%al
  801f41:	84 c0                	test   %al,%al
  801f43:	75 ea                	jne    801f2f <strfind+0xe>
  801f45:	eb 01                	jmp    801f48 <strfind+0x27>
		if (*s == c)
			break;
  801f47:	90                   	nop
	return (char *) s;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801f59:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801f5f:	eb 0e                	jmp    801f6f <memset+0x22>
		*p++ = c;
  801f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f64:	8d 50 01             	lea    0x1(%eax),%edx
  801f67:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801f6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801f6f:	ff 4d f8             	decl   -0x8(%ebp)
  801f72:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801f76:	79 e9                	jns    801f61 <memset+0x14>
		*p++ = c;

	return v;
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801f8f:	eb 16                	jmp    801fa7 <memcpy+0x2a>
		*d++ = *s++;
  801f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f94:	8d 50 01             	lea    0x1(%eax),%edx
  801f97:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fa0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801fa3:	8a 12                	mov    (%edx),%dl
  801fa5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  801faa:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fad:	89 55 10             	mov    %edx,0x10(%ebp)
  801fb0:	85 c0                	test   %eax,%eax
  801fb2:	75 dd                	jne    801f91 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fd1:	73 50                	jae    802023 <memmove+0x6a>
  801fd3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd9:	01 d0                	add    %edx,%eax
  801fdb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fde:	76 43                	jbe    802023 <memmove+0x6a>
		s += n;
  801fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801fec:	eb 10                	jmp    801ffe <memmove+0x45>
			*--d = *--s;
  801fee:	ff 4d f8             	decl   -0x8(%ebp)
  801ff1:	ff 4d fc             	decl   -0x4(%ebp)
  801ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff7:	8a 10                	mov    (%eax),%dl
  801ff9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ffc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801ffe:	8b 45 10             	mov    0x10(%ebp),%eax
  802001:	8d 50 ff             	lea    -0x1(%eax),%edx
  802004:	89 55 10             	mov    %edx,0x10(%ebp)
  802007:	85 c0                	test   %eax,%eax
  802009:	75 e3                	jne    801fee <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80200b:	eb 23                	jmp    802030 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80200d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802010:	8d 50 01             	lea    0x1(%eax),%edx
  802013:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802016:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802019:	8d 4a 01             	lea    0x1(%edx),%ecx
  80201c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80201f:	8a 12                	mov    (%edx),%dl
  802021:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802023:	8b 45 10             	mov    0x10(%ebp),%eax
  802026:	8d 50 ff             	lea    -0x1(%eax),%edx
  802029:	89 55 10             	mov    %edx,0x10(%ebp)
  80202c:	85 c0                	test   %eax,%eax
  80202e:	75 dd                	jne    80200d <memmove+0x54>
			*d++ = *s++;

	return dst;
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802041:	8b 45 0c             	mov    0xc(%ebp),%eax
  802044:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802047:	eb 2a                	jmp    802073 <memcmp+0x3e>
		if (*s1 != *s2)
  802049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204c:	8a 10                	mov    (%eax),%dl
  80204e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802051:	8a 00                	mov    (%eax),%al
  802053:	38 c2                	cmp    %al,%dl
  802055:	74 16                	je     80206d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80205a:	8a 00                	mov    (%eax),%al
  80205c:	0f b6 d0             	movzbl %al,%edx
  80205f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802062:	8a 00                	mov    (%eax),%al
  802064:	0f b6 c0             	movzbl %al,%eax
  802067:	29 c2                	sub    %eax,%edx
  802069:	89 d0                	mov    %edx,%eax
  80206b:	eb 18                	jmp    802085 <memcmp+0x50>
		s1++, s2++;
  80206d:	ff 45 fc             	incl   -0x4(%ebp)
  802070:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802073:	8b 45 10             	mov    0x10(%ebp),%eax
  802076:	8d 50 ff             	lea    -0x1(%eax),%edx
  802079:	89 55 10             	mov    %edx,0x10(%ebp)
  80207c:	85 c0                	test   %eax,%eax
  80207e:	75 c9                	jne    802049 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80208d:	8b 55 08             	mov    0x8(%ebp),%edx
  802090:	8b 45 10             	mov    0x10(%ebp),%eax
  802093:	01 d0                	add    %edx,%eax
  802095:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802098:	eb 15                	jmp    8020af <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	8a 00                	mov    (%eax),%al
  80209f:	0f b6 d0             	movzbl %al,%edx
  8020a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a5:	0f b6 c0             	movzbl %al,%eax
  8020a8:	39 c2                	cmp    %eax,%edx
  8020aa:	74 0d                	je     8020b9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8020ac:	ff 45 08             	incl   0x8(%ebp)
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8020b5:	72 e3                	jb     80209a <memfind+0x13>
  8020b7:	eb 01                	jmp    8020ba <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8020b9:	90                   	nop
	return (void *) s;
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8020c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8020cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020d3:	eb 03                	jmp    8020d8 <strtol+0x19>
		s++;
  8020d5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	8a 00                	mov    (%eax),%al
  8020dd:	3c 20                	cmp    $0x20,%al
  8020df:	74 f4                	je     8020d5 <strtol+0x16>
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	8a 00                	mov    (%eax),%al
  8020e6:	3c 09                	cmp    $0x9,%al
  8020e8:	74 eb                	je     8020d5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	8a 00                	mov    (%eax),%al
  8020ef:	3c 2b                	cmp    $0x2b,%al
  8020f1:	75 05                	jne    8020f8 <strtol+0x39>
		s++;
  8020f3:	ff 45 08             	incl   0x8(%ebp)
  8020f6:	eb 13                	jmp    80210b <strtol+0x4c>
	else if (*s == '-')
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	8a 00                	mov    (%eax),%al
  8020fd:	3c 2d                	cmp    $0x2d,%al
  8020ff:	75 0a                	jne    80210b <strtol+0x4c>
		s++, neg = 1;
  802101:	ff 45 08             	incl   0x8(%ebp)
  802104:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80210b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80210f:	74 06                	je     802117 <strtol+0x58>
  802111:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802115:	75 20                	jne    802137 <strtol+0x78>
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	8a 00                	mov    (%eax),%al
  80211c:	3c 30                	cmp    $0x30,%al
  80211e:	75 17                	jne    802137 <strtol+0x78>
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	40                   	inc    %eax
  802124:	8a 00                	mov    (%eax),%al
  802126:	3c 78                	cmp    $0x78,%al
  802128:	75 0d                	jne    802137 <strtol+0x78>
		s += 2, base = 16;
  80212a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80212e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802135:	eb 28                	jmp    80215f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802137:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80213b:	75 15                	jne    802152 <strtol+0x93>
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	8a 00                	mov    (%eax),%al
  802142:	3c 30                	cmp    $0x30,%al
  802144:	75 0c                	jne    802152 <strtol+0x93>
		s++, base = 8;
  802146:	ff 45 08             	incl   0x8(%ebp)
  802149:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802150:	eb 0d                	jmp    80215f <strtol+0xa0>
	else if (base == 0)
  802152:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802156:	75 07                	jne    80215f <strtol+0xa0>
		base = 10;
  802158:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	8a 00                	mov    (%eax),%al
  802164:	3c 2f                	cmp    $0x2f,%al
  802166:	7e 19                	jle    802181 <strtol+0xc2>
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	8a 00                	mov    (%eax),%al
  80216d:	3c 39                	cmp    $0x39,%al
  80216f:	7f 10                	jg     802181 <strtol+0xc2>
			dig = *s - '0';
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	8a 00                	mov    (%eax),%al
  802176:	0f be c0             	movsbl %al,%eax
  802179:	83 e8 30             	sub    $0x30,%eax
  80217c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217f:	eb 42                	jmp    8021c3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	8a 00                	mov    (%eax),%al
  802186:	3c 60                	cmp    $0x60,%al
  802188:	7e 19                	jle    8021a3 <strtol+0xe4>
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8a 00                	mov    (%eax),%al
  80218f:	3c 7a                	cmp    $0x7a,%al
  802191:	7f 10                	jg     8021a3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	8a 00                	mov    (%eax),%al
  802198:	0f be c0             	movsbl %al,%eax
  80219b:	83 e8 57             	sub    $0x57,%eax
  80219e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a1:	eb 20                	jmp    8021c3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	8a 00                	mov    (%eax),%al
  8021a8:	3c 40                	cmp    $0x40,%al
  8021aa:	7e 39                	jle    8021e5 <strtol+0x126>
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	8a 00                	mov    (%eax),%al
  8021b1:	3c 5a                	cmp    $0x5a,%al
  8021b3:	7f 30                	jg     8021e5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	8a 00                	mov    (%eax),%al
  8021ba:	0f be c0             	movsbl %al,%eax
  8021bd:	83 e8 37             	sub    $0x37,%eax
  8021c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021c9:	7d 19                	jge    8021e4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8021cb:	ff 45 08             	incl   0x8(%ebp)
  8021ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021d1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8021d5:	89 c2                	mov    %eax,%edx
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	01 d0                	add    %edx,%eax
  8021dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8021df:	e9 7b ff ff ff       	jmp    80215f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8021e4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8021e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021e9:	74 08                	je     8021f3 <strtol+0x134>
		*endptr = (char *) s;
  8021eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8021f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f7:	74 07                	je     802200 <strtol+0x141>
  8021f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021fc:	f7 d8                	neg    %eax
  8021fe:	eb 03                	jmp    802203 <strtol+0x144>
  802200:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <ltostr>:

void
ltostr(long value, char *str)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80220b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802212:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221d:	79 13                	jns    802232 <ltostr+0x2d>
	{
		neg = 1;
  80221f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802226:	8b 45 0c             	mov    0xc(%ebp),%eax
  802229:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80222c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80222f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80223a:	99                   	cltd   
  80223b:	f7 f9                	idiv   %ecx
  80223d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802240:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802243:	8d 50 01             	lea    0x1(%eax),%edx
  802246:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802249:	89 c2                	mov    %eax,%edx
  80224b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224e:	01 d0                	add    %edx,%eax
  802250:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802253:	83 c2 30             	add    $0x30,%edx
  802256:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802258:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80225b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802260:	f7 e9                	imul   %ecx
  802262:	c1 fa 02             	sar    $0x2,%edx
  802265:	89 c8                	mov    %ecx,%eax
  802267:	c1 f8 1f             	sar    $0x1f,%eax
  80226a:	29 c2                	sub    %eax,%edx
  80226c:	89 d0                	mov    %edx,%eax
  80226e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802271:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802274:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802279:	f7 e9                	imul   %ecx
  80227b:	c1 fa 02             	sar    $0x2,%edx
  80227e:	89 c8                	mov    %ecx,%eax
  802280:	c1 f8 1f             	sar    $0x1f,%eax
  802283:	29 c2                	sub    %eax,%edx
  802285:	89 d0                	mov    %edx,%eax
  802287:	c1 e0 02             	shl    $0x2,%eax
  80228a:	01 d0                	add    %edx,%eax
  80228c:	01 c0                	add    %eax,%eax
  80228e:	29 c1                	sub    %eax,%ecx
  802290:	89 ca                	mov    %ecx,%edx
  802292:	85 d2                	test   %edx,%edx
  802294:	75 9c                	jne    802232 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802296:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80229d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022a0:	48                   	dec    %eax
  8022a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8022a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022a8:	74 3d                	je     8022e7 <ltostr+0xe2>
		start = 1 ;
  8022aa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8022b1:	eb 34                	jmp    8022e7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8022b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	8a 00                	mov    (%eax),%al
  8022bd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8022c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c6:	01 c2                	add    %eax,%edx
  8022c8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8022cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ce:	01 c8                	add    %ecx,%eax
  8022d0:	8a 00                	mov    (%eax),%al
  8022d2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8022d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022da:	01 c2                	add    %eax,%edx
  8022dc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8022df:	88 02                	mov    %al,(%edx)
		start++ ;
  8022e1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8022e4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022ed:	7c c4                	jl     8022b3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8022ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8022f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f5:	01 d0                	add    %edx,%eax
  8022f7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8022fa:	90                   	nop
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802303:	ff 75 08             	pushl  0x8(%ebp)
  802306:	e8 54 fa ff ff       	call   801d5f <strlen>
  80230b:	83 c4 04             	add    $0x4,%esp
  80230e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802311:	ff 75 0c             	pushl  0xc(%ebp)
  802314:	e8 46 fa ff ff       	call   801d5f <strlen>
  802319:	83 c4 04             	add    $0x4,%esp
  80231c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80231f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802326:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80232d:	eb 17                	jmp    802346 <strcconcat+0x49>
		final[s] = str1[s] ;
  80232f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802332:	8b 45 10             	mov    0x10(%ebp),%eax
  802335:	01 c2                	add    %eax,%edx
  802337:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	01 c8                	add    %ecx,%eax
  80233f:	8a 00                	mov    (%eax),%al
  802341:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802343:	ff 45 fc             	incl   -0x4(%ebp)
  802346:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802349:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80234c:	7c e1                	jl     80232f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80234e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802355:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80235c:	eb 1f                	jmp    80237d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80235e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802361:	8d 50 01             	lea    0x1(%eax),%edx
  802364:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802367:	89 c2                	mov    %eax,%edx
  802369:	8b 45 10             	mov    0x10(%ebp),%eax
  80236c:	01 c2                	add    %eax,%edx
  80236e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802371:	8b 45 0c             	mov    0xc(%ebp),%eax
  802374:	01 c8                	add    %ecx,%eax
  802376:	8a 00                	mov    (%eax),%al
  802378:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80237a:	ff 45 f8             	incl   -0x8(%ebp)
  80237d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802380:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802383:	7c d9                	jl     80235e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802385:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802388:	8b 45 10             	mov    0x10(%ebp),%eax
  80238b:	01 d0                	add    %edx,%eax
  80238d:	c6 00 00             	movb   $0x0,(%eax)
}
  802390:	90                   	nop
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802396:	8b 45 14             	mov    0x14(%ebp),%eax
  802399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80239f:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ae:	01 d0                	add    %edx,%eax
  8023b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023b6:	eb 0c                	jmp    8023c4 <strsplit+0x31>
			*string++ = 0;
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8d 50 01             	lea    0x1(%eax),%edx
  8023be:	89 55 08             	mov    %edx,0x8(%ebp)
  8023c1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	8a 00                	mov    (%eax),%al
  8023c9:	84 c0                	test   %al,%al
  8023cb:	74 18                	je     8023e5 <strsplit+0x52>
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	8a 00                	mov    (%eax),%al
  8023d2:	0f be c0             	movsbl %al,%eax
  8023d5:	50                   	push   %eax
  8023d6:	ff 75 0c             	pushl  0xc(%ebp)
  8023d9:	e8 13 fb ff ff       	call   801ef1 <strchr>
  8023de:	83 c4 08             	add    $0x8,%esp
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	75 d3                	jne    8023b8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	8a 00                	mov    (%eax),%al
  8023ea:	84 c0                	test   %al,%al
  8023ec:	74 5a                	je     802448 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8023ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	83 f8 0f             	cmp    $0xf,%eax
  8023f6:	75 07                	jne    8023ff <strsplit+0x6c>
		{
			return 0;
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fd:	eb 66                	jmp    802465 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8023ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802402:	8b 00                	mov    (%eax),%eax
  802404:	8d 48 01             	lea    0x1(%eax),%ecx
  802407:	8b 55 14             	mov    0x14(%ebp),%edx
  80240a:	89 0a                	mov    %ecx,(%edx)
  80240c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802413:	8b 45 10             	mov    0x10(%ebp),%eax
  802416:	01 c2                	add    %eax,%edx
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80241d:	eb 03                	jmp    802422 <strsplit+0x8f>
			string++;
  80241f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	8a 00                	mov    (%eax),%al
  802427:	84 c0                	test   %al,%al
  802429:	74 8b                	je     8023b6 <strsplit+0x23>
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	8a 00                	mov    (%eax),%al
  802430:	0f be c0             	movsbl %al,%eax
  802433:	50                   	push   %eax
  802434:	ff 75 0c             	pushl  0xc(%ebp)
  802437:	e8 b5 fa ff ff       	call   801ef1 <strchr>
  80243c:	83 c4 08             	add    $0x8,%esp
  80243f:	85 c0                	test   %eax,%eax
  802441:	74 dc                	je     80241f <strsplit+0x8c>
			string++;
	}
  802443:	e9 6e ff ff ff       	jmp    8023b6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802448:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802449:	8b 45 14             	mov    0x14(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802455:	8b 45 10             	mov    0x10(%ebp),%eax
  802458:	01 d0                	add    %edx,%eax
  80245a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802460:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80246d:	a1 04 60 80 00       	mov    0x806004,%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	74 1f                	je     802495 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  802476:	e8 1d 00 00 00       	call   802498 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80247b:	83 ec 0c             	sub    $0xc,%esp
  80247e:	68 f0 4d 80 00       	push   $0x804df0
  802483:	e8 55 f2 ff ff       	call   8016dd <cprintf>
  802488:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80248b:	c7 05 04 60 80 00 00 	movl   $0x0,0x806004
  802492:	00 00 00 
	}
}
  802495:	90                   	nop
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  80249e:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  8024a5:	00 00 00 
  8024a8:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  8024af:	00 00 00 
  8024b2:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  8024b9:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  8024bc:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  8024c3:	00 00 00 
  8024c6:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  8024cd:	00 00 00 
  8024d0:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8024d7:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  8024da:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8024e9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8024ee:	a3 50 60 80 00       	mov    %eax,0x806050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8024f3:	c7 05 20 61 80 00 00 	movl   $0x20000,0x806120
  8024fa:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8024fd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802507:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  80250c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80250f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802512:	ba 00 00 00 00       	mov    $0x0,%edx
  802517:	f7 75 f0             	divl   -0x10(%ebp)
  80251a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251d:	29 d0                	sub    %edx,%eax
  80251f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  802522:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  802529:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802531:	2d 00 10 00 00       	sub    $0x1000,%eax
  802536:	83 ec 04             	sub    $0x4,%esp
  802539:	6a 06                	push   $0x6
  80253b:	ff 75 e8             	pushl  -0x18(%ebp)
  80253e:	50                   	push   %eax
  80253f:	e8 d4 05 00 00       	call   802b18 <sys_allocate_chunk>
  802544:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802547:	a1 20 61 80 00       	mov    0x806120,%eax
  80254c:	83 ec 0c             	sub    $0xc,%esp
  80254f:	50                   	push   %eax
  802550:	e8 49 0c 00 00       	call   80319e <initialize_MemBlocksList>
  802555:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  802558:	a1 48 61 80 00       	mov    0x806148,%eax
  80255d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  802560:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802564:	75 14                	jne    80257a <initialize_dyn_block_system+0xe2>
  802566:	83 ec 04             	sub    $0x4,%esp
  802569:	68 15 4e 80 00       	push   $0x804e15
  80256e:	6a 39                	push   $0x39
  802570:	68 33 4e 80 00       	push   $0x804e33
  802575:	e8 af ee ff ff       	call   801429 <_panic>
  80257a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	85 c0                	test   %eax,%eax
  802581:	74 10                	je     802593 <initialize_dyn_block_system+0xfb>
  802583:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802586:	8b 00                	mov    (%eax),%eax
  802588:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80258b:	8b 52 04             	mov    0x4(%edx),%edx
  80258e:	89 50 04             	mov    %edx,0x4(%eax)
  802591:	eb 0b                	jmp    80259e <initialize_dyn_block_system+0x106>
  802593:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802596:	8b 40 04             	mov    0x4(%eax),%eax
  802599:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80259e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a1:	8b 40 04             	mov    0x4(%eax),%eax
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	74 0f                	je     8025b7 <initialize_dyn_block_system+0x11f>
  8025a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ab:	8b 40 04             	mov    0x4(%eax),%eax
  8025ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025b1:	8b 12                	mov    (%edx),%edx
  8025b3:	89 10                	mov    %edx,(%eax)
  8025b5:	eb 0a                	jmp    8025c1 <initialize_dyn_block_system+0x129>
  8025b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	a3 48 61 80 00       	mov    %eax,0x806148
  8025c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d4:	a1 54 61 80 00       	mov    0x806154,%eax
  8025d9:	48                   	dec    %eax
  8025da:	a3 54 61 80 00       	mov    %eax,0x806154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  8025df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e2:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  8025e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ec:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  8025f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8025f7:	75 14                	jne    80260d <initialize_dyn_block_system+0x175>
  8025f9:	83 ec 04             	sub    $0x4,%esp
  8025fc:	68 40 4e 80 00       	push   $0x804e40
  802601:	6a 3f                	push   $0x3f
  802603:	68 33 4e 80 00       	push   $0x804e33
  802608:	e8 1c ee ff ff       	call   801429 <_panic>
  80260d:	8b 15 38 61 80 00    	mov    0x806138,%edx
  802613:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802616:	89 10                	mov    %edx,(%eax)
  802618:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80261b:	8b 00                	mov    (%eax),%eax
  80261d:	85 c0                	test   %eax,%eax
  80261f:	74 0d                	je     80262e <initialize_dyn_block_system+0x196>
  802621:	a1 38 61 80 00       	mov    0x806138,%eax
  802626:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802629:	89 50 04             	mov    %edx,0x4(%eax)
  80262c:	eb 08                	jmp    802636 <initialize_dyn_block_system+0x19e>
  80262e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802631:	a3 3c 61 80 00       	mov    %eax,0x80613c
  802636:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802639:	a3 38 61 80 00       	mov    %eax,0x806138
  80263e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802641:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802648:	a1 44 61 80 00       	mov    0x806144,%eax
  80264d:	40                   	inc    %eax
  80264e:	a3 44 61 80 00       	mov    %eax,0x806144

}
  802653:	90                   	nop
  802654:	c9                   	leave  
  802655:	c3                   	ret    

00802656 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
  802659:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80265c:	e8 06 fe ff ff       	call   802467 <InitializeUHeap>
	if (size == 0) return NULL ;
  802661:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802665:	75 07                	jne    80266e <malloc+0x18>
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
  80266c:	eb 7d                	jmp    8026eb <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  80266e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  802675:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80267c:	8b 55 08             	mov    0x8(%ebp),%edx
  80267f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802682:	01 d0                	add    %edx,%eax
  802684:	48                   	dec    %eax
  802685:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802688:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268b:	ba 00 00 00 00       	mov    $0x0,%edx
  802690:	f7 75 f0             	divl   -0x10(%ebp)
  802693:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802696:	29 d0                	sub    %edx,%eax
  802698:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  80269b:	e8 46 08 00 00       	call   802ee6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8026a0:	83 f8 01             	cmp    $0x1,%eax
  8026a3:	75 07                	jne    8026ac <malloc+0x56>
  8026a5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  8026ac:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8026b0:	75 34                	jne    8026e6 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  8026b2:	83 ec 0c             	sub    $0xc,%esp
  8026b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8026b8:	e8 73 0e 00 00       	call   803530 <alloc_block_FF>
  8026bd:	83 c4 10             	add    $0x10,%esp
  8026c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  8026c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026c7:	74 16                	je     8026df <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  8026c9:	83 ec 0c             	sub    $0xc,%esp
  8026cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026cf:	e8 ff 0b 00 00       	call   8032d3 <insert_sorted_allocList>
  8026d4:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  8026d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026da:	8b 40 08             	mov    0x8(%eax),%eax
  8026dd:	eb 0c                	jmp    8026eb <malloc+0x95>
	             }
	             else
	             	return NULL;
  8026df:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e4:	eb 05                	jmp    8026eb <malloc+0x95>
	      	  }
	          else
	               return NULL;
  8026e6:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  8026eb:	c9                   	leave  
  8026ec:	c3                   	ret    

008026ed <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp
  8026f0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  8026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f6:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802702:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802707:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  80270a:	83 ec 08             	sub    $0x8,%esp
  80270d:	ff 75 f4             	pushl  -0xc(%ebp)
  802710:	68 40 60 80 00       	push   $0x806040
  802715:	e8 61 0b 00 00       	call   80327b <find_block>
  80271a:	83 c4 10             	add    $0x10,%esp
  80271d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  802720:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802724:	0f 84 a5 00 00 00    	je     8027cf <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  80272a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272d:	8b 40 0c             	mov    0xc(%eax),%eax
  802730:	83 ec 08             	sub    $0x8,%esp
  802733:	50                   	push   %eax
  802734:	ff 75 f4             	pushl  -0xc(%ebp)
  802737:	e8 a4 03 00 00       	call   802ae0 <sys_free_user_mem>
  80273c:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  80273f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802743:	75 17                	jne    80275c <free+0x6f>
  802745:	83 ec 04             	sub    $0x4,%esp
  802748:	68 15 4e 80 00       	push   $0x804e15
  80274d:	68 87 00 00 00       	push   $0x87
  802752:	68 33 4e 80 00       	push   $0x804e33
  802757:	e8 cd ec ff ff       	call   801429 <_panic>
  80275c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275f:	8b 00                	mov    (%eax),%eax
  802761:	85 c0                	test   %eax,%eax
  802763:	74 10                	je     802775 <free+0x88>
  802765:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802768:	8b 00                	mov    (%eax),%eax
  80276a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80276d:	8b 52 04             	mov    0x4(%edx),%edx
  802770:	89 50 04             	mov    %edx,0x4(%eax)
  802773:	eb 0b                	jmp    802780 <free+0x93>
  802775:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802778:	8b 40 04             	mov    0x4(%eax),%eax
  80277b:	a3 44 60 80 00       	mov    %eax,0x806044
  802780:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802783:	8b 40 04             	mov    0x4(%eax),%eax
  802786:	85 c0                	test   %eax,%eax
  802788:	74 0f                	je     802799 <free+0xac>
  80278a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278d:	8b 40 04             	mov    0x4(%eax),%eax
  802790:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802793:	8b 12                	mov    (%edx),%edx
  802795:	89 10                	mov    %edx,(%eax)
  802797:	eb 0a                	jmp    8027a3 <free+0xb6>
  802799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279c:	8b 00                	mov    (%eax),%eax
  80279e:	a3 40 60 80 00       	mov    %eax,0x806040
  8027a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b6:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8027bb:	48                   	dec    %eax
  8027bc:	a3 4c 60 80 00       	mov    %eax,0x80604c
			insert_sorted_with_merge_freeList(theBlock);
  8027c1:	83 ec 0c             	sub    $0xc,%esp
  8027c4:	ff 75 ec             	pushl  -0x14(%ebp)
  8027c7:	e8 37 12 00 00       	call   803a03 <insert_sorted_with_merge_freeList>
  8027cc:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  8027cf:	90                   	nop
  8027d0:	c9                   	leave  
  8027d1:	c3                   	ret    

008027d2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8027d2:	55                   	push   %ebp
  8027d3:	89 e5                	mov    %esp,%ebp
  8027d5:	83 ec 38             	sub    $0x38,%esp
  8027d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8027db:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8027de:	e8 84 fc ff ff       	call   802467 <InitializeUHeap>
	if (size == 0) return NULL ;
  8027e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8027e7:	75 07                	jne    8027f0 <smalloc+0x1e>
  8027e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ee:	eb 7e                	jmp    80286e <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  8027f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8027f7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8027fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802804:	01 d0                	add    %edx,%eax
  802806:	48                   	dec    %eax
  802807:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80280a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280d:	ba 00 00 00 00       	mov    $0x0,%edx
  802812:	f7 75 f0             	divl   -0x10(%ebp)
  802815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802818:	29 d0                	sub    %edx,%eax
  80281a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80281d:	e8 c4 06 00 00       	call   802ee6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802822:	83 f8 01             	cmp    $0x1,%eax
  802825:	75 42                	jne    802869 <smalloc+0x97>

		  va = malloc(newsize) ;
  802827:	83 ec 0c             	sub    $0xc,%esp
  80282a:	ff 75 e8             	pushl  -0x18(%ebp)
  80282d:	e8 24 fe ff ff       	call   802656 <malloc>
  802832:	83 c4 10             	add    $0x10,%esp
  802835:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  802838:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80283c:	74 24                	je     802862 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  80283e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802842:	ff 75 e4             	pushl  -0x1c(%ebp)
  802845:	50                   	push   %eax
  802846:	ff 75 e8             	pushl  -0x18(%ebp)
  802849:	ff 75 08             	pushl  0x8(%ebp)
  80284c:	e8 1a 04 00 00       	call   802c6b <sys_createSharedObject>
  802851:	83 c4 10             	add    $0x10,%esp
  802854:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  802857:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80285b:	78 0c                	js     802869 <smalloc+0x97>
					  return va ;
  80285d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802860:	eb 0c                	jmp    80286e <smalloc+0x9c>
				 }
				 else
					return NULL;
  802862:	b8 00 00 00 00       	mov    $0x0,%eax
  802867:	eb 05                	jmp    80286e <smalloc+0x9c>
	  }
		  return NULL ;
  802869:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80286e:	c9                   	leave  
  80286f:	c3                   	ret    

00802870 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802870:	55                   	push   %ebp
  802871:	89 e5                	mov    %esp,%ebp
  802873:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802876:	e8 ec fb ff ff       	call   802467 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  80287b:	83 ec 08             	sub    $0x8,%esp
  80287e:	ff 75 0c             	pushl  0xc(%ebp)
  802881:	ff 75 08             	pushl  0x8(%ebp)
  802884:	e8 0c 04 00 00       	call   802c95 <sys_getSizeOfSharedObject>
  802889:	83 c4 10             	add    $0x10,%esp
  80288c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  80288f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802893:	75 07                	jne    80289c <sget+0x2c>
  802895:	b8 00 00 00 00       	mov    $0x0,%eax
  80289a:	eb 75                	jmp    802911 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80289c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8028a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a9:	01 d0                	add    %edx,%eax
  8028ab:	48                   	dec    %eax
  8028ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8028b7:	f7 75 f0             	divl   -0x10(%ebp)
  8028ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bd:	29 d0                	sub    %edx,%eax
  8028bf:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  8028c2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8028c9:	e8 18 06 00 00       	call   802ee6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8028ce:	83 f8 01             	cmp    $0x1,%eax
  8028d1:	75 39                	jne    80290c <sget+0x9c>

		  va = malloc(newsize) ;
  8028d3:	83 ec 0c             	sub    $0xc,%esp
  8028d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8028d9:	e8 78 fd ff ff       	call   802656 <malloc>
  8028de:	83 c4 10             	add    $0x10,%esp
  8028e1:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  8028e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028e8:	74 22                	je     80290c <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  8028ea:	83 ec 04             	sub    $0x4,%esp
  8028ed:	ff 75 e0             	pushl  -0x20(%ebp)
  8028f0:	ff 75 0c             	pushl  0xc(%ebp)
  8028f3:	ff 75 08             	pushl  0x8(%ebp)
  8028f6:	e8 b7 03 00 00       	call   802cb2 <sys_getSharedObject>
  8028fb:	83 c4 10             	add    $0x10,%esp
  8028fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  802901:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802905:	78 05                	js     80290c <sget+0x9c>
					  return va;
  802907:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290a:	eb 05                	jmp    802911 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  80290c:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  802911:	c9                   	leave  
  802912:	c3                   	ret    

00802913 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802913:	55                   	push   %ebp
  802914:	89 e5                	mov    %esp,%ebp
  802916:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802919:	e8 49 fb ff ff       	call   802467 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80291e:	83 ec 04             	sub    $0x4,%esp
  802921:	68 64 4e 80 00       	push   $0x804e64
  802926:	68 1e 01 00 00       	push   $0x11e
  80292b:	68 33 4e 80 00       	push   $0x804e33
  802930:	e8 f4 ea ff ff       	call   801429 <_panic>

00802935 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
  802938:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80293b:	83 ec 04             	sub    $0x4,%esp
  80293e:	68 8c 4e 80 00       	push   $0x804e8c
  802943:	68 32 01 00 00       	push   $0x132
  802948:	68 33 4e 80 00       	push   $0x804e33
  80294d:	e8 d7 ea ff ff       	call   801429 <_panic>

00802952 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802952:	55                   	push   %ebp
  802953:	89 e5                	mov    %esp,%ebp
  802955:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802958:	83 ec 04             	sub    $0x4,%esp
  80295b:	68 b0 4e 80 00       	push   $0x804eb0
  802960:	68 3d 01 00 00       	push   $0x13d
  802965:	68 33 4e 80 00       	push   $0x804e33
  80296a:	e8 ba ea ff ff       	call   801429 <_panic>

0080296f <shrink>:

}
void shrink(uint32 newSize)
{
  80296f:	55                   	push   %ebp
  802970:	89 e5                	mov    %esp,%ebp
  802972:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802975:	83 ec 04             	sub    $0x4,%esp
  802978:	68 b0 4e 80 00       	push   $0x804eb0
  80297d:	68 42 01 00 00       	push   $0x142
  802982:	68 33 4e 80 00       	push   $0x804e33
  802987:	e8 9d ea ff ff       	call   801429 <_panic>

0080298c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80298c:	55                   	push   %ebp
  80298d:	89 e5                	mov    %esp,%ebp
  80298f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802992:	83 ec 04             	sub    $0x4,%esp
  802995:	68 b0 4e 80 00       	push   $0x804eb0
  80299a:	68 47 01 00 00       	push   $0x147
  80299f:	68 33 4e 80 00       	push   $0x804e33
  8029a4:	e8 80 ea ff ff       	call   801429 <_panic>

008029a9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8029a9:	55                   	push   %ebp
  8029aa:	89 e5                	mov    %esp,%ebp
  8029ac:	57                   	push   %edi
  8029ad:	56                   	push   %esi
  8029ae:	53                   	push   %ebx
  8029af:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8029be:	8b 7d 18             	mov    0x18(%ebp),%edi
  8029c1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8029c4:	cd 30                	int    $0x30
  8029c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8029c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8029cc:	83 c4 10             	add    $0x10,%esp
  8029cf:	5b                   	pop    %ebx
  8029d0:	5e                   	pop    %esi
  8029d1:	5f                   	pop    %edi
  8029d2:	5d                   	pop    %ebp
  8029d3:	c3                   	ret    

008029d4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8029d4:	55                   	push   %ebp
  8029d5:	89 e5                	mov    %esp,%ebp
  8029d7:	83 ec 04             	sub    $0x4,%esp
  8029da:	8b 45 10             	mov    0x10(%ebp),%eax
  8029dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8029e0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	6a 00                	push   $0x0
  8029e9:	6a 00                	push   $0x0
  8029eb:	52                   	push   %edx
  8029ec:	ff 75 0c             	pushl  0xc(%ebp)
  8029ef:	50                   	push   %eax
  8029f0:	6a 00                	push   $0x0
  8029f2:	e8 b2 ff ff ff       	call   8029a9 <syscall>
  8029f7:	83 c4 18             	add    $0x18,%esp
}
  8029fa:	90                   	nop
  8029fb:	c9                   	leave  
  8029fc:	c3                   	ret    

008029fd <sys_cgetc>:

int
sys_cgetc(void)
{
  8029fd:	55                   	push   %ebp
  8029fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802a00:	6a 00                	push   $0x0
  802a02:	6a 00                	push   $0x0
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 01                	push   $0x1
  802a0c:	e8 98 ff ff ff       	call   8029a9 <syscall>
  802a11:	83 c4 18             	add    $0x18,%esp
}
  802a14:	c9                   	leave  
  802a15:	c3                   	ret    

00802a16 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802a16:	55                   	push   %ebp
  802a17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1f:	6a 00                	push   $0x0
  802a21:	6a 00                	push   $0x0
  802a23:	6a 00                	push   $0x0
  802a25:	52                   	push   %edx
  802a26:	50                   	push   %eax
  802a27:	6a 05                	push   $0x5
  802a29:	e8 7b ff ff ff       	call   8029a9 <syscall>
  802a2e:	83 c4 18             	add    $0x18,%esp
}
  802a31:	c9                   	leave  
  802a32:	c3                   	ret    

00802a33 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802a33:	55                   	push   %ebp
  802a34:	89 e5                	mov    %esp,%ebp
  802a36:	56                   	push   %esi
  802a37:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802a38:	8b 75 18             	mov    0x18(%ebp),%esi
  802a3b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a44:	8b 45 08             	mov    0x8(%ebp),%eax
  802a47:	56                   	push   %esi
  802a48:	53                   	push   %ebx
  802a49:	51                   	push   %ecx
  802a4a:	52                   	push   %edx
  802a4b:	50                   	push   %eax
  802a4c:	6a 06                	push   $0x6
  802a4e:	e8 56 ff ff ff       	call   8029a9 <syscall>
  802a53:	83 c4 18             	add    $0x18,%esp
}
  802a56:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a59:	5b                   	pop    %ebx
  802a5a:	5e                   	pop    %esi
  802a5b:	5d                   	pop    %ebp
  802a5c:	c3                   	ret    

00802a5d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802a5d:	55                   	push   %ebp
  802a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a63:	8b 45 08             	mov    0x8(%ebp),%eax
  802a66:	6a 00                	push   $0x0
  802a68:	6a 00                	push   $0x0
  802a6a:	6a 00                	push   $0x0
  802a6c:	52                   	push   %edx
  802a6d:	50                   	push   %eax
  802a6e:	6a 07                	push   $0x7
  802a70:	e8 34 ff ff ff       	call   8029a9 <syscall>
  802a75:	83 c4 18             	add    $0x18,%esp
}
  802a78:	c9                   	leave  
  802a79:	c3                   	ret    

00802a7a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802a7a:	55                   	push   %ebp
  802a7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802a7d:	6a 00                	push   $0x0
  802a7f:	6a 00                	push   $0x0
  802a81:	6a 00                	push   $0x0
  802a83:	ff 75 0c             	pushl  0xc(%ebp)
  802a86:	ff 75 08             	pushl  0x8(%ebp)
  802a89:	6a 08                	push   $0x8
  802a8b:	e8 19 ff ff ff       	call   8029a9 <syscall>
  802a90:	83 c4 18             	add    $0x18,%esp
}
  802a93:	c9                   	leave  
  802a94:	c3                   	ret    

00802a95 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802a95:	55                   	push   %ebp
  802a96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802a98:	6a 00                	push   $0x0
  802a9a:	6a 00                	push   $0x0
  802a9c:	6a 00                	push   $0x0
  802a9e:	6a 00                	push   $0x0
  802aa0:	6a 00                	push   $0x0
  802aa2:	6a 09                	push   $0x9
  802aa4:	e8 00 ff ff ff       	call   8029a9 <syscall>
  802aa9:	83 c4 18             	add    $0x18,%esp
}
  802aac:	c9                   	leave  
  802aad:	c3                   	ret    

00802aae <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802aae:	55                   	push   %ebp
  802aaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802ab1:	6a 00                	push   $0x0
  802ab3:	6a 00                	push   $0x0
  802ab5:	6a 00                	push   $0x0
  802ab7:	6a 00                	push   $0x0
  802ab9:	6a 00                	push   $0x0
  802abb:	6a 0a                	push   $0xa
  802abd:	e8 e7 fe ff ff       	call   8029a9 <syscall>
  802ac2:	83 c4 18             	add    $0x18,%esp
}
  802ac5:	c9                   	leave  
  802ac6:	c3                   	ret    

00802ac7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802ac7:	55                   	push   %ebp
  802ac8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802aca:	6a 00                	push   $0x0
  802acc:	6a 00                	push   $0x0
  802ace:	6a 00                	push   $0x0
  802ad0:	6a 00                	push   $0x0
  802ad2:	6a 00                	push   $0x0
  802ad4:	6a 0b                	push   $0xb
  802ad6:	e8 ce fe ff ff       	call   8029a9 <syscall>
  802adb:	83 c4 18             	add    $0x18,%esp
}
  802ade:	c9                   	leave  
  802adf:	c3                   	ret    

00802ae0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802ae0:	55                   	push   %ebp
  802ae1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802ae3:	6a 00                	push   $0x0
  802ae5:	6a 00                	push   $0x0
  802ae7:	6a 00                	push   $0x0
  802ae9:	ff 75 0c             	pushl  0xc(%ebp)
  802aec:	ff 75 08             	pushl  0x8(%ebp)
  802aef:	6a 0f                	push   $0xf
  802af1:	e8 b3 fe ff ff       	call   8029a9 <syscall>
  802af6:	83 c4 18             	add    $0x18,%esp
	return;
  802af9:	90                   	nop
}
  802afa:	c9                   	leave  
  802afb:	c3                   	ret    

00802afc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802afc:	55                   	push   %ebp
  802afd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802aff:	6a 00                	push   $0x0
  802b01:	6a 00                	push   $0x0
  802b03:	6a 00                	push   $0x0
  802b05:	ff 75 0c             	pushl  0xc(%ebp)
  802b08:	ff 75 08             	pushl  0x8(%ebp)
  802b0b:	6a 10                	push   $0x10
  802b0d:	e8 97 fe ff ff       	call   8029a9 <syscall>
  802b12:	83 c4 18             	add    $0x18,%esp
	return ;
  802b15:	90                   	nop
}
  802b16:	c9                   	leave  
  802b17:	c3                   	ret    

00802b18 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b18:	55                   	push   %ebp
  802b19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802b1b:	6a 00                	push   $0x0
  802b1d:	6a 00                	push   $0x0
  802b1f:	ff 75 10             	pushl  0x10(%ebp)
  802b22:	ff 75 0c             	pushl  0xc(%ebp)
  802b25:	ff 75 08             	pushl  0x8(%ebp)
  802b28:	6a 11                	push   $0x11
  802b2a:	e8 7a fe ff ff       	call   8029a9 <syscall>
  802b2f:	83 c4 18             	add    $0x18,%esp
	return ;
  802b32:	90                   	nop
}
  802b33:	c9                   	leave  
  802b34:	c3                   	ret    

00802b35 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802b35:	55                   	push   %ebp
  802b36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802b38:	6a 00                	push   $0x0
  802b3a:	6a 00                	push   $0x0
  802b3c:	6a 00                	push   $0x0
  802b3e:	6a 00                	push   $0x0
  802b40:	6a 00                	push   $0x0
  802b42:	6a 0c                	push   $0xc
  802b44:	e8 60 fe ff ff       	call   8029a9 <syscall>
  802b49:	83 c4 18             	add    $0x18,%esp
}
  802b4c:	c9                   	leave  
  802b4d:	c3                   	ret    

00802b4e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802b4e:	55                   	push   %ebp
  802b4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802b51:	6a 00                	push   $0x0
  802b53:	6a 00                	push   $0x0
  802b55:	6a 00                	push   $0x0
  802b57:	6a 00                	push   $0x0
  802b59:	ff 75 08             	pushl  0x8(%ebp)
  802b5c:	6a 0d                	push   $0xd
  802b5e:	e8 46 fe ff ff       	call   8029a9 <syscall>
  802b63:	83 c4 18             	add    $0x18,%esp
}
  802b66:	c9                   	leave  
  802b67:	c3                   	ret    

00802b68 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802b68:	55                   	push   %ebp
  802b69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802b6b:	6a 00                	push   $0x0
  802b6d:	6a 00                	push   $0x0
  802b6f:	6a 00                	push   $0x0
  802b71:	6a 00                	push   $0x0
  802b73:	6a 00                	push   $0x0
  802b75:	6a 0e                	push   $0xe
  802b77:	e8 2d fe ff ff       	call   8029a9 <syscall>
  802b7c:	83 c4 18             	add    $0x18,%esp
}
  802b7f:	90                   	nop
  802b80:	c9                   	leave  
  802b81:	c3                   	ret    

00802b82 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802b82:	55                   	push   %ebp
  802b83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802b85:	6a 00                	push   $0x0
  802b87:	6a 00                	push   $0x0
  802b89:	6a 00                	push   $0x0
  802b8b:	6a 00                	push   $0x0
  802b8d:	6a 00                	push   $0x0
  802b8f:	6a 13                	push   $0x13
  802b91:	e8 13 fe ff ff       	call   8029a9 <syscall>
  802b96:	83 c4 18             	add    $0x18,%esp
}
  802b99:	90                   	nop
  802b9a:	c9                   	leave  
  802b9b:	c3                   	ret    

00802b9c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802b9c:	55                   	push   %ebp
  802b9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802b9f:	6a 00                	push   $0x0
  802ba1:	6a 00                	push   $0x0
  802ba3:	6a 00                	push   $0x0
  802ba5:	6a 00                	push   $0x0
  802ba7:	6a 00                	push   $0x0
  802ba9:	6a 14                	push   $0x14
  802bab:	e8 f9 fd ff ff       	call   8029a9 <syscall>
  802bb0:	83 c4 18             	add    $0x18,%esp
}
  802bb3:	90                   	nop
  802bb4:	c9                   	leave  
  802bb5:	c3                   	ret    

00802bb6 <sys_cputc>:


void
sys_cputc(const char c)
{
  802bb6:	55                   	push   %ebp
  802bb7:	89 e5                	mov    %esp,%ebp
  802bb9:	83 ec 04             	sub    $0x4,%esp
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802bc2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802bc6:	6a 00                	push   $0x0
  802bc8:	6a 00                	push   $0x0
  802bca:	6a 00                	push   $0x0
  802bcc:	6a 00                	push   $0x0
  802bce:	50                   	push   %eax
  802bcf:	6a 15                	push   $0x15
  802bd1:	e8 d3 fd ff ff       	call   8029a9 <syscall>
  802bd6:	83 c4 18             	add    $0x18,%esp
}
  802bd9:	90                   	nop
  802bda:	c9                   	leave  
  802bdb:	c3                   	ret    

00802bdc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802bdc:	55                   	push   %ebp
  802bdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802bdf:	6a 00                	push   $0x0
  802be1:	6a 00                	push   $0x0
  802be3:	6a 00                	push   $0x0
  802be5:	6a 00                	push   $0x0
  802be7:	6a 00                	push   $0x0
  802be9:	6a 16                	push   $0x16
  802beb:	e8 b9 fd ff ff       	call   8029a9 <syscall>
  802bf0:	83 c4 18             	add    $0x18,%esp
}
  802bf3:	90                   	nop
  802bf4:	c9                   	leave  
  802bf5:	c3                   	ret    

00802bf6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802bf6:	55                   	push   %ebp
  802bf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfc:	6a 00                	push   $0x0
  802bfe:	6a 00                	push   $0x0
  802c00:	6a 00                	push   $0x0
  802c02:	ff 75 0c             	pushl  0xc(%ebp)
  802c05:	50                   	push   %eax
  802c06:	6a 17                	push   $0x17
  802c08:	e8 9c fd ff ff       	call   8029a9 <syscall>
  802c0d:	83 c4 18             	add    $0x18,%esp
}
  802c10:	c9                   	leave  
  802c11:	c3                   	ret    

00802c12 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802c12:	55                   	push   %ebp
  802c13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	6a 00                	push   $0x0
  802c1d:	6a 00                	push   $0x0
  802c1f:	6a 00                	push   $0x0
  802c21:	52                   	push   %edx
  802c22:	50                   	push   %eax
  802c23:	6a 1a                	push   $0x1a
  802c25:	e8 7f fd ff ff       	call   8029a9 <syscall>
  802c2a:	83 c4 18             	add    $0x18,%esp
}
  802c2d:	c9                   	leave  
  802c2e:	c3                   	ret    

00802c2f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802c2f:	55                   	push   %ebp
  802c30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c32:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	6a 00                	push   $0x0
  802c3a:	6a 00                	push   $0x0
  802c3c:	6a 00                	push   $0x0
  802c3e:	52                   	push   %edx
  802c3f:	50                   	push   %eax
  802c40:	6a 18                	push   $0x18
  802c42:	e8 62 fd ff ff       	call   8029a9 <syscall>
  802c47:	83 c4 18             	add    $0x18,%esp
}
  802c4a:	90                   	nop
  802c4b:	c9                   	leave  
  802c4c:	c3                   	ret    

00802c4d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802c4d:	55                   	push   %ebp
  802c4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c50:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	6a 00                	push   $0x0
  802c58:	6a 00                	push   $0x0
  802c5a:	6a 00                	push   $0x0
  802c5c:	52                   	push   %edx
  802c5d:	50                   	push   %eax
  802c5e:	6a 19                	push   $0x19
  802c60:	e8 44 fd ff ff       	call   8029a9 <syscall>
  802c65:	83 c4 18             	add    $0x18,%esp
}
  802c68:	90                   	nop
  802c69:	c9                   	leave  
  802c6a:	c3                   	ret    

00802c6b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802c6b:	55                   	push   %ebp
  802c6c:	89 e5                	mov    %esp,%ebp
  802c6e:	83 ec 04             	sub    $0x4,%esp
  802c71:	8b 45 10             	mov    0x10(%ebp),%eax
  802c74:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802c77:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802c7a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c81:	6a 00                	push   $0x0
  802c83:	51                   	push   %ecx
  802c84:	52                   	push   %edx
  802c85:	ff 75 0c             	pushl  0xc(%ebp)
  802c88:	50                   	push   %eax
  802c89:	6a 1b                	push   $0x1b
  802c8b:	e8 19 fd ff ff       	call   8029a9 <syscall>
  802c90:	83 c4 18             	add    $0x18,%esp
}
  802c93:	c9                   	leave  
  802c94:	c3                   	ret    

00802c95 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802c95:	55                   	push   %ebp
  802c96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802c98:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	6a 00                	push   $0x0
  802ca0:	6a 00                	push   $0x0
  802ca2:	6a 00                	push   $0x0
  802ca4:	52                   	push   %edx
  802ca5:	50                   	push   %eax
  802ca6:	6a 1c                	push   $0x1c
  802ca8:	e8 fc fc ff ff       	call   8029a9 <syscall>
  802cad:	83 c4 18             	add    $0x18,%esp
}
  802cb0:	c9                   	leave  
  802cb1:	c3                   	ret    

00802cb2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802cb2:	55                   	push   %ebp
  802cb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802cb5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802cb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	6a 00                	push   $0x0
  802cc0:	6a 00                	push   $0x0
  802cc2:	51                   	push   %ecx
  802cc3:	52                   	push   %edx
  802cc4:	50                   	push   %eax
  802cc5:	6a 1d                	push   $0x1d
  802cc7:	e8 dd fc ff ff       	call   8029a9 <syscall>
  802ccc:	83 c4 18             	add    $0x18,%esp
}
  802ccf:	c9                   	leave  
  802cd0:	c3                   	ret    

00802cd1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802cd1:	55                   	push   %ebp
  802cd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	6a 00                	push   $0x0
  802cdc:	6a 00                	push   $0x0
  802cde:	6a 00                	push   $0x0
  802ce0:	52                   	push   %edx
  802ce1:	50                   	push   %eax
  802ce2:	6a 1e                	push   $0x1e
  802ce4:	e8 c0 fc ff ff       	call   8029a9 <syscall>
  802ce9:	83 c4 18             	add    $0x18,%esp
}
  802cec:	c9                   	leave  
  802ced:	c3                   	ret    

00802cee <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802cee:	55                   	push   %ebp
  802cef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802cf1:	6a 00                	push   $0x0
  802cf3:	6a 00                	push   $0x0
  802cf5:	6a 00                	push   $0x0
  802cf7:	6a 00                	push   $0x0
  802cf9:	6a 00                	push   $0x0
  802cfb:	6a 1f                	push   $0x1f
  802cfd:	e8 a7 fc ff ff       	call   8029a9 <syscall>
  802d02:	83 c4 18             	add    $0x18,%esp
}
  802d05:	c9                   	leave  
  802d06:	c3                   	ret    

00802d07 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802d07:	55                   	push   %ebp
  802d08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0d:	6a 00                	push   $0x0
  802d0f:	ff 75 14             	pushl  0x14(%ebp)
  802d12:	ff 75 10             	pushl  0x10(%ebp)
  802d15:	ff 75 0c             	pushl  0xc(%ebp)
  802d18:	50                   	push   %eax
  802d19:	6a 20                	push   $0x20
  802d1b:	e8 89 fc ff ff       	call   8029a9 <syscall>
  802d20:	83 c4 18             	add    $0x18,%esp
}
  802d23:	c9                   	leave  
  802d24:	c3                   	ret    

00802d25 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802d25:	55                   	push   %ebp
  802d26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	6a 00                	push   $0x0
  802d2d:	6a 00                	push   $0x0
  802d2f:	6a 00                	push   $0x0
  802d31:	6a 00                	push   $0x0
  802d33:	50                   	push   %eax
  802d34:	6a 21                	push   $0x21
  802d36:	e8 6e fc ff ff       	call   8029a9 <syscall>
  802d3b:	83 c4 18             	add    $0x18,%esp
}
  802d3e:	90                   	nop
  802d3f:	c9                   	leave  
  802d40:	c3                   	ret    

00802d41 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802d41:	55                   	push   %ebp
  802d42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	6a 00                	push   $0x0
  802d49:	6a 00                	push   $0x0
  802d4b:	6a 00                	push   $0x0
  802d4d:	6a 00                	push   $0x0
  802d4f:	50                   	push   %eax
  802d50:	6a 22                	push   $0x22
  802d52:	e8 52 fc ff ff       	call   8029a9 <syscall>
  802d57:	83 c4 18             	add    $0x18,%esp
}
  802d5a:	c9                   	leave  
  802d5b:	c3                   	ret    

00802d5c <sys_getenvid>:

int32 sys_getenvid(void)
{
  802d5c:	55                   	push   %ebp
  802d5d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802d5f:	6a 00                	push   $0x0
  802d61:	6a 00                	push   $0x0
  802d63:	6a 00                	push   $0x0
  802d65:	6a 00                	push   $0x0
  802d67:	6a 00                	push   $0x0
  802d69:	6a 02                	push   $0x2
  802d6b:	e8 39 fc ff ff       	call   8029a9 <syscall>
  802d70:	83 c4 18             	add    $0x18,%esp
}
  802d73:	c9                   	leave  
  802d74:	c3                   	ret    

00802d75 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802d75:	55                   	push   %ebp
  802d76:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802d78:	6a 00                	push   $0x0
  802d7a:	6a 00                	push   $0x0
  802d7c:	6a 00                	push   $0x0
  802d7e:	6a 00                	push   $0x0
  802d80:	6a 00                	push   $0x0
  802d82:	6a 03                	push   $0x3
  802d84:	e8 20 fc ff ff       	call   8029a9 <syscall>
  802d89:	83 c4 18             	add    $0x18,%esp
}
  802d8c:	c9                   	leave  
  802d8d:	c3                   	ret    

00802d8e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802d8e:	55                   	push   %ebp
  802d8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802d91:	6a 00                	push   $0x0
  802d93:	6a 00                	push   $0x0
  802d95:	6a 00                	push   $0x0
  802d97:	6a 00                	push   $0x0
  802d99:	6a 00                	push   $0x0
  802d9b:	6a 04                	push   $0x4
  802d9d:	e8 07 fc ff ff       	call   8029a9 <syscall>
  802da2:	83 c4 18             	add    $0x18,%esp
}
  802da5:	c9                   	leave  
  802da6:	c3                   	ret    

00802da7 <sys_exit_env>:


void sys_exit_env(void)
{
  802da7:	55                   	push   %ebp
  802da8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802daa:	6a 00                	push   $0x0
  802dac:	6a 00                	push   $0x0
  802dae:	6a 00                	push   $0x0
  802db0:	6a 00                	push   $0x0
  802db2:	6a 00                	push   $0x0
  802db4:	6a 23                	push   $0x23
  802db6:	e8 ee fb ff ff       	call   8029a9 <syscall>
  802dbb:	83 c4 18             	add    $0x18,%esp
}
  802dbe:	90                   	nop
  802dbf:	c9                   	leave  
  802dc0:	c3                   	ret    

00802dc1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802dc1:	55                   	push   %ebp
  802dc2:	89 e5                	mov    %esp,%ebp
  802dc4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802dc7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802dca:	8d 50 04             	lea    0x4(%eax),%edx
  802dcd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802dd0:	6a 00                	push   $0x0
  802dd2:	6a 00                	push   $0x0
  802dd4:	6a 00                	push   $0x0
  802dd6:	52                   	push   %edx
  802dd7:	50                   	push   %eax
  802dd8:	6a 24                	push   $0x24
  802dda:	e8 ca fb ff ff       	call   8029a9 <syscall>
  802ddf:	83 c4 18             	add    $0x18,%esp
	return result;
  802de2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802de5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802de8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802deb:	89 01                	mov    %eax,(%ecx)
  802ded:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802df0:	8b 45 08             	mov    0x8(%ebp),%eax
  802df3:	c9                   	leave  
  802df4:	c2 04 00             	ret    $0x4

00802df7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802df7:	55                   	push   %ebp
  802df8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802dfa:	6a 00                	push   $0x0
  802dfc:	6a 00                	push   $0x0
  802dfe:	ff 75 10             	pushl  0x10(%ebp)
  802e01:	ff 75 0c             	pushl  0xc(%ebp)
  802e04:	ff 75 08             	pushl  0x8(%ebp)
  802e07:	6a 12                	push   $0x12
  802e09:	e8 9b fb ff ff       	call   8029a9 <syscall>
  802e0e:	83 c4 18             	add    $0x18,%esp
	return ;
  802e11:	90                   	nop
}
  802e12:	c9                   	leave  
  802e13:	c3                   	ret    

00802e14 <sys_rcr2>:
uint32 sys_rcr2()
{
  802e14:	55                   	push   %ebp
  802e15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802e17:	6a 00                	push   $0x0
  802e19:	6a 00                	push   $0x0
  802e1b:	6a 00                	push   $0x0
  802e1d:	6a 00                	push   $0x0
  802e1f:	6a 00                	push   $0x0
  802e21:	6a 25                	push   $0x25
  802e23:	e8 81 fb ff ff       	call   8029a9 <syscall>
  802e28:	83 c4 18             	add    $0x18,%esp
}
  802e2b:	c9                   	leave  
  802e2c:	c3                   	ret    

00802e2d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802e2d:	55                   	push   %ebp
  802e2e:	89 e5                	mov    %esp,%ebp
  802e30:	83 ec 04             	sub    $0x4,%esp
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802e39:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802e3d:	6a 00                	push   $0x0
  802e3f:	6a 00                	push   $0x0
  802e41:	6a 00                	push   $0x0
  802e43:	6a 00                	push   $0x0
  802e45:	50                   	push   %eax
  802e46:	6a 26                	push   $0x26
  802e48:	e8 5c fb ff ff       	call   8029a9 <syscall>
  802e4d:	83 c4 18             	add    $0x18,%esp
	return ;
  802e50:	90                   	nop
}
  802e51:	c9                   	leave  
  802e52:	c3                   	ret    

00802e53 <rsttst>:
void rsttst()
{
  802e53:	55                   	push   %ebp
  802e54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802e56:	6a 00                	push   $0x0
  802e58:	6a 00                	push   $0x0
  802e5a:	6a 00                	push   $0x0
  802e5c:	6a 00                	push   $0x0
  802e5e:	6a 00                	push   $0x0
  802e60:	6a 28                	push   $0x28
  802e62:	e8 42 fb ff ff       	call   8029a9 <syscall>
  802e67:	83 c4 18             	add    $0x18,%esp
	return ;
  802e6a:	90                   	nop
}
  802e6b:	c9                   	leave  
  802e6c:	c3                   	ret    

00802e6d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802e6d:	55                   	push   %ebp
  802e6e:	89 e5                	mov    %esp,%ebp
  802e70:	83 ec 04             	sub    $0x4,%esp
  802e73:	8b 45 14             	mov    0x14(%ebp),%eax
  802e76:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802e79:	8b 55 18             	mov    0x18(%ebp),%edx
  802e7c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802e80:	52                   	push   %edx
  802e81:	50                   	push   %eax
  802e82:	ff 75 10             	pushl  0x10(%ebp)
  802e85:	ff 75 0c             	pushl  0xc(%ebp)
  802e88:	ff 75 08             	pushl  0x8(%ebp)
  802e8b:	6a 27                	push   $0x27
  802e8d:	e8 17 fb ff ff       	call   8029a9 <syscall>
  802e92:	83 c4 18             	add    $0x18,%esp
	return ;
  802e95:	90                   	nop
}
  802e96:	c9                   	leave  
  802e97:	c3                   	ret    

00802e98 <chktst>:
void chktst(uint32 n)
{
  802e98:	55                   	push   %ebp
  802e99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802e9b:	6a 00                	push   $0x0
  802e9d:	6a 00                	push   $0x0
  802e9f:	6a 00                	push   $0x0
  802ea1:	6a 00                	push   $0x0
  802ea3:	ff 75 08             	pushl  0x8(%ebp)
  802ea6:	6a 29                	push   $0x29
  802ea8:	e8 fc fa ff ff       	call   8029a9 <syscall>
  802ead:	83 c4 18             	add    $0x18,%esp
	return ;
  802eb0:	90                   	nop
}
  802eb1:	c9                   	leave  
  802eb2:	c3                   	ret    

00802eb3 <inctst>:

void inctst()
{
  802eb3:	55                   	push   %ebp
  802eb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802eb6:	6a 00                	push   $0x0
  802eb8:	6a 00                	push   $0x0
  802eba:	6a 00                	push   $0x0
  802ebc:	6a 00                	push   $0x0
  802ebe:	6a 00                	push   $0x0
  802ec0:	6a 2a                	push   $0x2a
  802ec2:	e8 e2 fa ff ff       	call   8029a9 <syscall>
  802ec7:	83 c4 18             	add    $0x18,%esp
	return ;
  802eca:	90                   	nop
}
  802ecb:	c9                   	leave  
  802ecc:	c3                   	ret    

00802ecd <gettst>:
uint32 gettst()
{
  802ecd:	55                   	push   %ebp
  802ece:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802ed0:	6a 00                	push   $0x0
  802ed2:	6a 00                	push   $0x0
  802ed4:	6a 00                	push   $0x0
  802ed6:	6a 00                	push   $0x0
  802ed8:	6a 00                	push   $0x0
  802eda:	6a 2b                	push   $0x2b
  802edc:	e8 c8 fa ff ff       	call   8029a9 <syscall>
  802ee1:	83 c4 18             	add    $0x18,%esp
}
  802ee4:	c9                   	leave  
  802ee5:	c3                   	ret    

00802ee6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802ee6:	55                   	push   %ebp
  802ee7:	89 e5                	mov    %esp,%ebp
  802ee9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802eec:	6a 00                	push   $0x0
  802eee:	6a 00                	push   $0x0
  802ef0:	6a 00                	push   $0x0
  802ef2:	6a 00                	push   $0x0
  802ef4:	6a 00                	push   $0x0
  802ef6:	6a 2c                	push   $0x2c
  802ef8:	e8 ac fa ff ff       	call   8029a9 <syscall>
  802efd:	83 c4 18             	add    $0x18,%esp
  802f00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802f03:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802f07:	75 07                	jne    802f10 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802f09:	b8 01 00 00 00       	mov    $0x1,%eax
  802f0e:	eb 05                	jmp    802f15 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802f10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f15:	c9                   	leave  
  802f16:	c3                   	ret    

00802f17 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802f17:	55                   	push   %ebp
  802f18:	89 e5                	mov    %esp,%ebp
  802f1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f1d:	6a 00                	push   $0x0
  802f1f:	6a 00                	push   $0x0
  802f21:	6a 00                	push   $0x0
  802f23:	6a 00                	push   $0x0
  802f25:	6a 00                	push   $0x0
  802f27:	6a 2c                	push   $0x2c
  802f29:	e8 7b fa ff ff       	call   8029a9 <syscall>
  802f2e:	83 c4 18             	add    $0x18,%esp
  802f31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802f34:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802f38:	75 07                	jne    802f41 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802f3a:	b8 01 00 00 00       	mov    $0x1,%eax
  802f3f:	eb 05                	jmp    802f46 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802f41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f46:	c9                   	leave  
  802f47:	c3                   	ret    

00802f48 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802f48:	55                   	push   %ebp
  802f49:	89 e5                	mov    %esp,%ebp
  802f4b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f4e:	6a 00                	push   $0x0
  802f50:	6a 00                	push   $0x0
  802f52:	6a 00                	push   $0x0
  802f54:	6a 00                	push   $0x0
  802f56:	6a 00                	push   $0x0
  802f58:	6a 2c                	push   $0x2c
  802f5a:	e8 4a fa ff ff       	call   8029a9 <syscall>
  802f5f:	83 c4 18             	add    $0x18,%esp
  802f62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802f65:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802f69:	75 07                	jne    802f72 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802f6b:	b8 01 00 00 00       	mov    $0x1,%eax
  802f70:	eb 05                	jmp    802f77 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802f72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f77:	c9                   	leave  
  802f78:	c3                   	ret    

00802f79 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802f79:	55                   	push   %ebp
  802f7a:	89 e5                	mov    %esp,%ebp
  802f7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f7f:	6a 00                	push   $0x0
  802f81:	6a 00                	push   $0x0
  802f83:	6a 00                	push   $0x0
  802f85:	6a 00                	push   $0x0
  802f87:	6a 00                	push   $0x0
  802f89:	6a 2c                	push   $0x2c
  802f8b:	e8 19 fa ff ff       	call   8029a9 <syscall>
  802f90:	83 c4 18             	add    $0x18,%esp
  802f93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802f96:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802f9a:	75 07                	jne    802fa3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802f9c:	b8 01 00 00 00       	mov    $0x1,%eax
  802fa1:	eb 05                	jmp    802fa8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802fa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fa8:	c9                   	leave  
  802fa9:	c3                   	ret    

00802faa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802faa:	55                   	push   %ebp
  802fab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802fad:	6a 00                	push   $0x0
  802faf:	6a 00                	push   $0x0
  802fb1:	6a 00                	push   $0x0
  802fb3:	6a 00                	push   $0x0
  802fb5:	ff 75 08             	pushl  0x8(%ebp)
  802fb8:	6a 2d                	push   $0x2d
  802fba:	e8 ea f9 ff ff       	call   8029a9 <syscall>
  802fbf:	83 c4 18             	add    $0x18,%esp
	return ;
  802fc2:	90                   	nop
}
  802fc3:	c9                   	leave  
  802fc4:	c3                   	ret    

00802fc5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802fc5:	55                   	push   %ebp
  802fc6:	89 e5                	mov    %esp,%ebp
  802fc8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802fc9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fcc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	6a 00                	push   $0x0
  802fd7:	53                   	push   %ebx
  802fd8:	51                   	push   %ecx
  802fd9:	52                   	push   %edx
  802fda:	50                   	push   %eax
  802fdb:	6a 2e                	push   $0x2e
  802fdd:	e8 c7 f9 ff ff       	call   8029a9 <syscall>
  802fe2:	83 c4 18             	add    $0x18,%esp
}
  802fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fe8:	c9                   	leave  
  802fe9:	c3                   	ret    

00802fea <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802fea:	55                   	push   %ebp
  802feb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802fed:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff3:	6a 00                	push   $0x0
  802ff5:	6a 00                	push   $0x0
  802ff7:	6a 00                	push   $0x0
  802ff9:	52                   	push   %edx
  802ffa:	50                   	push   %eax
  802ffb:	6a 2f                	push   $0x2f
  802ffd:	e8 a7 f9 ff ff       	call   8029a9 <syscall>
  803002:	83 c4 18             	add    $0x18,%esp
}
  803005:	c9                   	leave  
  803006:	c3                   	ret    

00803007 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  803007:	55                   	push   %ebp
  803008:	89 e5                	mov    %esp,%ebp
  80300a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80300d:	83 ec 0c             	sub    $0xc,%esp
  803010:	68 c0 4e 80 00       	push   $0x804ec0
  803015:	e8 c3 e6 ff ff       	call   8016dd <cprintf>
  80301a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80301d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  803024:	83 ec 0c             	sub    $0xc,%esp
  803027:	68 ec 4e 80 00       	push   $0x804eec
  80302c:	e8 ac e6 ff ff       	call   8016dd <cprintf>
  803031:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  803034:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803038:	a1 38 61 80 00       	mov    0x806138,%eax
  80303d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803040:	eb 56                	jmp    803098 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  803042:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803046:	74 1c                	je     803064 <print_mem_block_lists+0x5d>
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	8b 50 08             	mov    0x8(%eax),%edx
  80304e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803051:	8b 48 08             	mov    0x8(%eax),%ecx
  803054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803057:	8b 40 0c             	mov    0xc(%eax),%eax
  80305a:	01 c8                	add    %ecx,%eax
  80305c:	39 c2                	cmp    %eax,%edx
  80305e:	73 04                	jae    803064 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  803060:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803067:	8b 50 08             	mov    0x8(%eax),%edx
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 40 0c             	mov    0xc(%eax),%eax
  803070:	01 c2                	add    %eax,%edx
  803072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803075:	8b 40 08             	mov    0x8(%eax),%eax
  803078:	83 ec 04             	sub    $0x4,%esp
  80307b:	52                   	push   %edx
  80307c:	50                   	push   %eax
  80307d:	68 01 4f 80 00       	push   $0x804f01
  803082:	e8 56 e6 ff ff       	call   8016dd <cprintf>
  803087:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803090:	a1 40 61 80 00       	mov    0x806140,%eax
  803095:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803098:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80309c:	74 07                	je     8030a5 <print_mem_block_lists+0x9e>
  80309e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a1:	8b 00                	mov    (%eax),%eax
  8030a3:	eb 05                	jmp    8030aa <print_mem_block_lists+0xa3>
  8030a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8030aa:	a3 40 61 80 00       	mov    %eax,0x806140
  8030af:	a1 40 61 80 00       	mov    0x806140,%eax
  8030b4:	85 c0                	test   %eax,%eax
  8030b6:	75 8a                	jne    803042 <print_mem_block_lists+0x3b>
  8030b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bc:	75 84                	jne    803042 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8030be:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8030c2:	75 10                	jne    8030d4 <print_mem_block_lists+0xcd>
  8030c4:	83 ec 0c             	sub    $0xc,%esp
  8030c7:	68 10 4f 80 00       	push   $0x804f10
  8030cc:	e8 0c e6 ff ff       	call   8016dd <cprintf>
  8030d1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8030d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8030db:	83 ec 0c             	sub    $0xc,%esp
  8030de:	68 34 4f 80 00       	push   $0x804f34
  8030e3:	e8 f5 e5 ff ff       	call   8016dd <cprintf>
  8030e8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8030eb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8030ef:	a1 40 60 80 00       	mov    0x806040,%eax
  8030f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030f7:	eb 56                	jmp    80314f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8030f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030fd:	74 1c                	je     80311b <print_mem_block_lists+0x114>
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	8b 50 08             	mov    0x8(%eax),%edx
  803105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803108:	8b 48 08             	mov    0x8(%eax),%ecx
  80310b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310e:	8b 40 0c             	mov    0xc(%eax),%eax
  803111:	01 c8                	add    %ecx,%eax
  803113:	39 c2                	cmp    %eax,%edx
  803115:	73 04                	jae    80311b <print_mem_block_lists+0x114>
			sorted = 0 ;
  803117:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80311b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311e:	8b 50 08             	mov    0x8(%eax),%edx
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	8b 40 0c             	mov    0xc(%eax),%eax
  803127:	01 c2                	add    %eax,%edx
  803129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312c:	8b 40 08             	mov    0x8(%eax),%eax
  80312f:	83 ec 04             	sub    $0x4,%esp
  803132:	52                   	push   %edx
  803133:	50                   	push   %eax
  803134:	68 01 4f 80 00       	push   $0x804f01
  803139:	e8 9f e5 ff ff       	call   8016dd <cprintf>
  80313e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803144:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803147:	a1 48 60 80 00       	mov    0x806048,%eax
  80314c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80314f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803153:	74 07                	je     80315c <print_mem_block_lists+0x155>
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	eb 05                	jmp    803161 <print_mem_block_lists+0x15a>
  80315c:	b8 00 00 00 00       	mov    $0x0,%eax
  803161:	a3 48 60 80 00       	mov    %eax,0x806048
  803166:	a1 48 60 80 00       	mov    0x806048,%eax
  80316b:	85 c0                	test   %eax,%eax
  80316d:	75 8a                	jne    8030f9 <print_mem_block_lists+0xf2>
  80316f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803173:	75 84                	jne    8030f9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  803175:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803179:	75 10                	jne    80318b <print_mem_block_lists+0x184>
  80317b:	83 ec 0c             	sub    $0xc,%esp
  80317e:	68 4c 4f 80 00       	push   $0x804f4c
  803183:	e8 55 e5 ff ff       	call   8016dd <cprintf>
  803188:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80318b:	83 ec 0c             	sub    $0xc,%esp
  80318e:	68 c0 4e 80 00       	push   $0x804ec0
  803193:	e8 45 e5 ff ff       	call   8016dd <cprintf>
  803198:	83 c4 10             	add    $0x10,%esp

}
  80319b:	90                   	nop
  80319c:	c9                   	leave  
  80319d:	c3                   	ret    

0080319e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80319e:	55                   	push   %ebp
  80319f:	89 e5                	mov    %esp,%ebp
  8031a1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  8031a4:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  8031ab:	00 00 00 
  8031ae:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  8031b5:	00 00 00 
  8031b8:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  8031bf:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8031c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8031c9:	e9 9e 00 00 00       	jmp    80326c <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8031ce:	a1 50 60 80 00       	mov    0x806050,%eax
  8031d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031d6:	c1 e2 04             	shl    $0x4,%edx
  8031d9:	01 d0                	add    %edx,%eax
  8031db:	85 c0                	test   %eax,%eax
  8031dd:	75 14                	jne    8031f3 <initialize_MemBlocksList+0x55>
  8031df:	83 ec 04             	sub    $0x4,%esp
  8031e2:	68 74 4f 80 00       	push   $0x804f74
  8031e7:	6a 47                	push   $0x47
  8031e9:	68 97 4f 80 00       	push   $0x804f97
  8031ee:	e8 36 e2 ff ff       	call   801429 <_panic>
  8031f3:	a1 50 60 80 00       	mov    0x806050,%eax
  8031f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031fb:	c1 e2 04             	shl    $0x4,%edx
  8031fe:	01 d0                	add    %edx,%eax
  803200:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803206:	89 10                	mov    %edx,(%eax)
  803208:	8b 00                	mov    (%eax),%eax
  80320a:	85 c0                	test   %eax,%eax
  80320c:	74 18                	je     803226 <initialize_MemBlocksList+0x88>
  80320e:	a1 48 61 80 00       	mov    0x806148,%eax
  803213:	8b 15 50 60 80 00    	mov    0x806050,%edx
  803219:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80321c:	c1 e1 04             	shl    $0x4,%ecx
  80321f:	01 ca                	add    %ecx,%edx
  803221:	89 50 04             	mov    %edx,0x4(%eax)
  803224:	eb 12                	jmp    803238 <initialize_MemBlocksList+0x9a>
  803226:	a1 50 60 80 00       	mov    0x806050,%eax
  80322b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80322e:	c1 e2 04             	shl    $0x4,%edx
  803231:	01 d0                	add    %edx,%eax
  803233:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803238:	a1 50 60 80 00       	mov    0x806050,%eax
  80323d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803240:	c1 e2 04             	shl    $0x4,%edx
  803243:	01 d0                	add    %edx,%eax
  803245:	a3 48 61 80 00       	mov    %eax,0x806148
  80324a:	a1 50 60 80 00       	mov    0x806050,%eax
  80324f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803252:	c1 e2 04             	shl    $0x4,%edx
  803255:	01 d0                	add    %edx,%eax
  803257:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325e:	a1 54 61 80 00       	mov    0x806154,%eax
  803263:	40                   	inc    %eax
  803264:	a3 54 61 80 00       	mov    %eax,0x806154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  803269:	ff 45 f4             	incl   -0xc(%ebp)
  80326c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803272:	0f 82 56 ff ff ff    	jb     8031ce <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  803278:	90                   	nop
  803279:	c9                   	leave  
  80327a:	c3                   	ret    

0080327b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80327b:	55                   	push   %ebp
  80327c:	89 e5                	mov    %esp,%ebp
  80327e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	8b 00                	mov    (%eax),%eax
  803286:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803289:	eb 19                	jmp    8032a4 <find_block+0x29>
	{
		if(element->sva == va){
  80328b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80328e:	8b 40 08             	mov    0x8(%eax),%eax
  803291:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803294:	75 05                	jne    80329b <find_block+0x20>
			 		return element;
  803296:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803299:	eb 36                	jmp    8032d1 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	8b 40 08             	mov    0x8(%eax),%eax
  8032a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8032a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8032a8:	74 07                	je     8032b1 <find_block+0x36>
  8032aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032ad:	8b 00                	mov    (%eax),%eax
  8032af:	eb 05                	jmp    8032b6 <find_block+0x3b>
  8032b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b9:	89 42 08             	mov    %eax,0x8(%edx)
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	8b 40 08             	mov    0x8(%eax),%eax
  8032c2:	85 c0                	test   %eax,%eax
  8032c4:	75 c5                	jne    80328b <find_block+0x10>
  8032c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8032ca:	75 bf                	jne    80328b <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  8032cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032d1:	c9                   	leave  
  8032d2:	c3                   	ret    

008032d3 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8032d3:	55                   	push   %ebp
  8032d4:	89 e5                	mov    %esp,%ebp
  8032d6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  8032d9:	a1 44 60 80 00       	mov    0x806044,%eax
  8032de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  8032e1:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8032e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  8032e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032ed:	74 0a                	je     8032f9 <insert_sorted_allocList+0x26>
  8032ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f2:	8b 40 08             	mov    0x8(%eax),%eax
  8032f5:	85 c0                	test   %eax,%eax
  8032f7:	75 65                	jne    80335e <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8032f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032fd:	75 14                	jne    803313 <insert_sorted_allocList+0x40>
  8032ff:	83 ec 04             	sub    $0x4,%esp
  803302:	68 74 4f 80 00       	push   $0x804f74
  803307:	6a 6e                	push   $0x6e
  803309:	68 97 4f 80 00       	push   $0x804f97
  80330e:	e8 16 e1 ff ff       	call   801429 <_panic>
  803313:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803319:	8b 45 08             	mov    0x8(%ebp),%eax
  80331c:	89 10                	mov    %edx,(%eax)
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	8b 00                	mov    (%eax),%eax
  803323:	85 c0                	test   %eax,%eax
  803325:	74 0d                	je     803334 <insert_sorted_allocList+0x61>
  803327:	a1 40 60 80 00       	mov    0x806040,%eax
  80332c:	8b 55 08             	mov    0x8(%ebp),%edx
  80332f:	89 50 04             	mov    %edx,0x4(%eax)
  803332:	eb 08                	jmp    80333c <insert_sorted_allocList+0x69>
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	a3 44 60 80 00       	mov    %eax,0x806044
  80333c:	8b 45 08             	mov    0x8(%ebp),%eax
  80333f:	a3 40 60 80 00       	mov    %eax,0x806040
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80334e:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803353:	40                   	inc    %eax
  803354:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803359:	e9 cf 01 00 00       	jmp    80352d <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  80335e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803361:	8b 50 08             	mov    0x8(%eax),%edx
  803364:	8b 45 08             	mov    0x8(%ebp),%eax
  803367:	8b 40 08             	mov    0x8(%eax),%eax
  80336a:	39 c2                	cmp    %eax,%edx
  80336c:	73 65                	jae    8033d3 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80336e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803372:	75 14                	jne    803388 <insert_sorted_allocList+0xb5>
  803374:	83 ec 04             	sub    $0x4,%esp
  803377:	68 b0 4f 80 00       	push   $0x804fb0
  80337c:	6a 72                	push   $0x72
  80337e:	68 97 4f 80 00       	push   $0x804f97
  803383:	e8 a1 e0 ff ff       	call   801429 <_panic>
  803388:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	89 50 04             	mov    %edx,0x4(%eax)
  803394:	8b 45 08             	mov    0x8(%ebp),%eax
  803397:	8b 40 04             	mov    0x4(%eax),%eax
  80339a:	85 c0                	test   %eax,%eax
  80339c:	74 0c                	je     8033aa <insert_sorted_allocList+0xd7>
  80339e:	a1 44 60 80 00       	mov    0x806044,%eax
  8033a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a6:	89 10                	mov    %edx,(%eax)
  8033a8:	eb 08                	jmp    8033b2 <insert_sorted_allocList+0xdf>
  8033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ad:	a3 40 60 80 00       	mov    %eax,0x806040
  8033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b5:	a3 44 60 80 00       	mov    %eax,0x806044
  8033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c3:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8033c8:	40                   	inc    %eax
  8033c9:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
			  }
	    }
	  }

}
  8033ce:	e9 5a 01 00 00       	jmp    80352d <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  8033d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d6:	8b 50 08             	mov    0x8(%eax),%edx
  8033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dc:	8b 40 08             	mov    0x8(%eax),%eax
  8033df:	39 c2                	cmp    %eax,%edx
  8033e1:	75 70                	jne    803453 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  8033e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033e7:	74 06                	je     8033ef <insert_sorted_allocList+0x11c>
  8033e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ed:	75 14                	jne    803403 <insert_sorted_allocList+0x130>
  8033ef:	83 ec 04             	sub    $0x4,%esp
  8033f2:	68 d4 4f 80 00       	push   $0x804fd4
  8033f7:	6a 75                	push   $0x75
  8033f9:	68 97 4f 80 00       	push   $0x804f97
  8033fe:	e8 26 e0 ff ff       	call   801429 <_panic>
  803403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803406:	8b 10                	mov    (%eax),%edx
  803408:	8b 45 08             	mov    0x8(%ebp),%eax
  80340b:	89 10                	mov    %edx,(%eax)
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	8b 00                	mov    (%eax),%eax
  803412:	85 c0                	test   %eax,%eax
  803414:	74 0b                	je     803421 <insert_sorted_allocList+0x14e>
  803416:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	8b 55 08             	mov    0x8(%ebp),%edx
  80341e:	89 50 04             	mov    %edx,0x4(%eax)
  803421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803424:	8b 55 08             	mov    0x8(%ebp),%edx
  803427:	89 10                	mov    %edx,(%eax)
  803429:	8b 45 08             	mov    0x8(%ebp),%eax
  80342c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80342f:	89 50 04             	mov    %edx,0x4(%eax)
  803432:	8b 45 08             	mov    0x8(%ebp),%eax
  803435:	8b 00                	mov    (%eax),%eax
  803437:	85 c0                	test   %eax,%eax
  803439:	75 08                	jne    803443 <insert_sorted_allocList+0x170>
  80343b:	8b 45 08             	mov    0x8(%ebp),%eax
  80343e:	a3 44 60 80 00       	mov    %eax,0x806044
  803443:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803448:	40                   	inc    %eax
  803449:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
			  }
	    }
	  }

}
  80344e:	e9 da 00 00 00       	jmp    80352d <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  803453:	a1 40 60 80 00       	mov    0x806040,%eax
  803458:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80345b:	e9 9d 00 00 00       	jmp    8034fd <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  803460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803463:	8b 00                	mov    (%eax),%eax
  803465:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  803468:	8b 45 08             	mov    0x8(%ebp),%eax
  80346b:	8b 50 08             	mov    0x8(%eax),%edx
  80346e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803471:	8b 40 08             	mov    0x8(%eax),%eax
  803474:	39 c2                	cmp    %eax,%edx
  803476:	76 7d                	jbe    8034f5 <insert_sorted_allocList+0x222>
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	8b 50 08             	mov    0x8(%eax),%edx
  80347e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803481:	8b 40 08             	mov    0x8(%eax),%eax
  803484:	39 c2                	cmp    %eax,%edx
  803486:	73 6d                	jae    8034f5 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  803488:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80348c:	74 06                	je     803494 <insert_sorted_allocList+0x1c1>
  80348e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803492:	75 14                	jne    8034a8 <insert_sorted_allocList+0x1d5>
  803494:	83 ec 04             	sub    $0x4,%esp
  803497:	68 d4 4f 80 00       	push   $0x804fd4
  80349c:	6a 7c                	push   $0x7c
  80349e:	68 97 4f 80 00       	push   $0x804f97
  8034a3:	e8 81 df ff ff       	call   801429 <_panic>
  8034a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ab:	8b 10                	mov    (%eax),%edx
  8034ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b0:	89 10                	mov    %edx,(%eax)
  8034b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b5:	8b 00                	mov    (%eax),%eax
  8034b7:	85 c0                	test   %eax,%eax
  8034b9:	74 0b                	je     8034c6 <insert_sorted_allocList+0x1f3>
  8034bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034be:	8b 00                	mov    (%eax),%eax
  8034c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c3:	89 50 04             	mov    %edx,0x4(%eax)
  8034c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8034cc:	89 10                	mov    %edx,(%eax)
  8034ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d4:	89 50 04             	mov    %edx,0x4(%eax)
  8034d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034da:	8b 00                	mov    (%eax),%eax
  8034dc:	85 c0                	test   %eax,%eax
  8034de:	75 08                	jne    8034e8 <insert_sorted_allocList+0x215>
  8034e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e3:	a3 44 60 80 00       	mov    %eax,0x806044
  8034e8:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8034ed:	40                   	inc    %eax
  8034ee:	a3 4c 60 80 00       	mov    %eax,0x80604c
				break;
  8034f3:	eb 38                	jmp    80352d <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8034f5:	a1 48 60 80 00       	mov    0x806048,%eax
  8034fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803501:	74 07                	je     80350a <insert_sorted_allocList+0x237>
  803503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803506:	8b 00                	mov    (%eax),%eax
  803508:	eb 05                	jmp    80350f <insert_sorted_allocList+0x23c>
  80350a:	b8 00 00 00 00       	mov    $0x0,%eax
  80350f:	a3 48 60 80 00       	mov    %eax,0x806048
  803514:	a1 48 60 80 00       	mov    0x806048,%eax
  803519:	85 c0                	test   %eax,%eax
  80351b:	0f 85 3f ff ff ff    	jne    803460 <insert_sorted_allocList+0x18d>
  803521:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803525:	0f 85 35 ff ff ff    	jne    803460 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  80352b:	eb 00                	jmp    80352d <insert_sorted_allocList+0x25a>
  80352d:	90                   	nop
  80352e:	c9                   	leave  
  80352f:	c3                   	ret    

00803530 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  803530:	55                   	push   %ebp
  803531:	89 e5                	mov    %esp,%ebp
  803533:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  803536:	a1 38 61 80 00       	mov    0x806138,%eax
  80353b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80353e:	e9 6b 02 00 00       	jmp    8037ae <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  803543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803546:	8b 40 0c             	mov    0xc(%eax),%eax
  803549:	3b 45 08             	cmp    0x8(%ebp),%eax
  80354c:	0f 85 90 00 00 00    	jne    8035e2 <alloc_block_FF+0xb2>
			  temp=element;
  803552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803555:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  803558:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80355c:	75 17                	jne    803575 <alloc_block_FF+0x45>
  80355e:	83 ec 04             	sub    $0x4,%esp
  803561:	68 08 50 80 00       	push   $0x805008
  803566:	68 92 00 00 00       	push   $0x92
  80356b:	68 97 4f 80 00       	push   $0x804f97
  803570:	e8 b4 de ff ff       	call   801429 <_panic>
  803575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803578:	8b 00                	mov    (%eax),%eax
  80357a:	85 c0                	test   %eax,%eax
  80357c:	74 10                	je     80358e <alloc_block_FF+0x5e>
  80357e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803581:	8b 00                	mov    (%eax),%eax
  803583:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803586:	8b 52 04             	mov    0x4(%edx),%edx
  803589:	89 50 04             	mov    %edx,0x4(%eax)
  80358c:	eb 0b                	jmp    803599 <alloc_block_FF+0x69>
  80358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803591:	8b 40 04             	mov    0x4(%eax),%eax
  803594:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359c:	8b 40 04             	mov    0x4(%eax),%eax
  80359f:	85 c0                	test   %eax,%eax
  8035a1:	74 0f                	je     8035b2 <alloc_block_FF+0x82>
  8035a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a6:	8b 40 04             	mov    0x4(%eax),%eax
  8035a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ac:	8b 12                	mov    (%edx),%edx
  8035ae:	89 10                	mov    %edx,(%eax)
  8035b0:	eb 0a                	jmp    8035bc <alloc_block_FF+0x8c>
  8035b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b5:	8b 00                	mov    (%eax),%eax
  8035b7:	a3 38 61 80 00       	mov    %eax,0x806138
  8035bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035cf:	a1 44 61 80 00       	mov    0x806144,%eax
  8035d4:	48                   	dec    %eax
  8035d5:	a3 44 61 80 00       	mov    %eax,0x806144
			  return temp;
  8035da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035dd:	e9 ff 01 00 00       	jmp    8037e1 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  8035e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035eb:	0f 86 b5 01 00 00    	jbe    8037a6 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  8035f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f7:	2b 45 08             	sub    0x8(%ebp),%eax
  8035fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  8035fd:	a1 48 61 80 00       	mov    0x806148,%eax
  803602:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  803605:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803609:	75 17                	jne    803622 <alloc_block_FF+0xf2>
  80360b:	83 ec 04             	sub    $0x4,%esp
  80360e:	68 08 50 80 00       	push   $0x805008
  803613:	68 99 00 00 00       	push   $0x99
  803618:	68 97 4f 80 00       	push   $0x804f97
  80361d:	e8 07 de ff ff       	call   801429 <_panic>
  803622:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803625:	8b 00                	mov    (%eax),%eax
  803627:	85 c0                	test   %eax,%eax
  803629:	74 10                	je     80363b <alloc_block_FF+0x10b>
  80362b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80362e:	8b 00                	mov    (%eax),%eax
  803630:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803633:	8b 52 04             	mov    0x4(%edx),%edx
  803636:	89 50 04             	mov    %edx,0x4(%eax)
  803639:	eb 0b                	jmp    803646 <alloc_block_FF+0x116>
  80363b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80363e:	8b 40 04             	mov    0x4(%eax),%eax
  803641:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803646:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803649:	8b 40 04             	mov    0x4(%eax),%eax
  80364c:	85 c0                	test   %eax,%eax
  80364e:	74 0f                	je     80365f <alloc_block_FF+0x12f>
  803650:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803653:	8b 40 04             	mov    0x4(%eax),%eax
  803656:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803659:	8b 12                	mov    (%edx),%edx
  80365b:	89 10                	mov    %edx,(%eax)
  80365d:	eb 0a                	jmp    803669 <alloc_block_FF+0x139>
  80365f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803662:	8b 00                	mov    (%eax),%eax
  803664:	a3 48 61 80 00       	mov    %eax,0x806148
  803669:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80366c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803672:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803675:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80367c:	a1 54 61 80 00       	mov    0x806154,%eax
  803681:	48                   	dec    %eax
  803682:	a3 54 61 80 00       	mov    %eax,0x806154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  803687:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80368b:	75 17                	jne    8036a4 <alloc_block_FF+0x174>
  80368d:	83 ec 04             	sub    $0x4,%esp
  803690:	68 b0 4f 80 00       	push   $0x804fb0
  803695:	68 9a 00 00 00       	push   $0x9a
  80369a:	68 97 4f 80 00       	push   $0x804f97
  80369f:	e8 85 dd ff ff       	call   801429 <_panic>
  8036a4:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  8036aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ad:	89 50 04             	mov    %edx,0x4(%eax)
  8036b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b3:	8b 40 04             	mov    0x4(%eax),%eax
  8036b6:	85 c0                	test   %eax,%eax
  8036b8:	74 0c                	je     8036c6 <alloc_block_FF+0x196>
  8036ba:	a1 3c 61 80 00       	mov    0x80613c,%eax
  8036bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036c2:	89 10                	mov    %edx,(%eax)
  8036c4:	eb 08                	jmp    8036ce <alloc_block_FF+0x19e>
  8036c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c9:	a3 38 61 80 00       	mov    %eax,0x806138
  8036ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036d1:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8036d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036df:	a1 44 61 80 00       	mov    0x806144,%eax
  8036e4:	40                   	inc    %eax
  8036e5:	a3 44 61 80 00       	mov    %eax,0x806144
		  // setting the size & sva
		  new_block->size=size;
  8036ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f0:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  8036f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f6:	8b 50 08             	mov    0x8(%eax),%edx
  8036f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036fc:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  8036ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803702:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803705:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  803708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370b:	8b 50 08             	mov    0x8(%eax),%edx
  80370e:	8b 45 08             	mov    0x8(%ebp),%eax
  803711:	01 c2                	add    %eax,%edx
  803713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803716:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  803719:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80371c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  80371f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803723:	75 17                	jne    80373c <alloc_block_FF+0x20c>
  803725:	83 ec 04             	sub    $0x4,%esp
  803728:	68 08 50 80 00       	push   $0x805008
  80372d:	68 a2 00 00 00       	push   $0xa2
  803732:	68 97 4f 80 00       	push   $0x804f97
  803737:	e8 ed dc ff ff       	call   801429 <_panic>
  80373c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80373f:	8b 00                	mov    (%eax),%eax
  803741:	85 c0                	test   %eax,%eax
  803743:	74 10                	je     803755 <alloc_block_FF+0x225>
  803745:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803748:	8b 00                	mov    (%eax),%eax
  80374a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80374d:	8b 52 04             	mov    0x4(%edx),%edx
  803750:	89 50 04             	mov    %edx,0x4(%eax)
  803753:	eb 0b                	jmp    803760 <alloc_block_FF+0x230>
  803755:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803758:	8b 40 04             	mov    0x4(%eax),%eax
  80375b:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803760:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803763:	8b 40 04             	mov    0x4(%eax),%eax
  803766:	85 c0                	test   %eax,%eax
  803768:	74 0f                	je     803779 <alloc_block_FF+0x249>
  80376a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80376d:	8b 40 04             	mov    0x4(%eax),%eax
  803770:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803773:	8b 12                	mov    (%edx),%edx
  803775:	89 10                	mov    %edx,(%eax)
  803777:	eb 0a                	jmp    803783 <alloc_block_FF+0x253>
  803779:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80377c:	8b 00                	mov    (%eax),%eax
  80377e:	a3 38 61 80 00       	mov    %eax,0x806138
  803783:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803786:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80378c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80378f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803796:	a1 44 61 80 00       	mov    0x806144,%eax
  80379b:	48                   	dec    %eax
  80379c:	a3 44 61 80 00       	mov    %eax,0x806144
		  return temp;
  8037a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a4:	eb 3b                	jmp    8037e1 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8037a6:	a1 40 61 80 00       	mov    0x806140,%eax
  8037ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b2:	74 07                	je     8037bb <alloc_block_FF+0x28b>
  8037b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b7:	8b 00                	mov    (%eax),%eax
  8037b9:	eb 05                	jmp    8037c0 <alloc_block_FF+0x290>
  8037bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c0:	a3 40 61 80 00       	mov    %eax,0x806140
  8037c5:	a1 40 61 80 00       	mov    0x806140,%eax
  8037ca:	85 c0                	test   %eax,%eax
  8037cc:	0f 85 71 fd ff ff    	jne    803543 <alloc_block_FF+0x13>
  8037d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037d6:	0f 85 67 fd ff ff    	jne    803543 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  8037dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037e1:	c9                   	leave  
  8037e2:	c3                   	ret    

008037e3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8037e3:	55                   	push   %ebp
  8037e4:	89 e5                	mov    %esp,%ebp
  8037e6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  8037e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  8037f0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8037f7:	a1 38 61 80 00       	mov    0x806138,%eax
  8037fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8037ff:	e9 d3 00 00 00       	jmp    8038d7 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  803804:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803807:	8b 40 0c             	mov    0xc(%eax),%eax
  80380a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80380d:	0f 85 90 00 00 00    	jne    8038a3 <alloc_block_BF+0xc0>
	   temp = element;
  803813:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803816:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  803819:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80381d:	75 17                	jne    803836 <alloc_block_BF+0x53>
  80381f:	83 ec 04             	sub    $0x4,%esp
  803822:	68 08 50 80 00       	push   $0x805008
  803827:	68 bd 00 00 00       	push   $0xbd
  80382c:	68 97 4f 80 00       	push   $0x804f97
  803831:	e8 f3 db ff ff       	call   801429 <_panic>
  803836:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803839:	8b 00                	mov    (%eax),%eax
  80383b:	85 c0                	test   %eax,%eax
  80383d:	74 10                	je     80384f <alloc_block_BF+0x6c>
  80383f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803842:	8b 00                	mov    (%eax),%eax
  803844:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803847:	8b 52 04             	mov    0x4(%edx),%edx
  80384a:	89 50 04             	mov    %edx,0x4(%eax)
  80384d:	eb 0b                	jmp    80385a <alloc_block_BF+0x77>
  80384f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803852:	8b 40 04             	mov    0x4(%eax),%eax
  803855:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80385a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80385d:	8b 40 04             	mov    0x4(%eax),%eax
  803860:	85 c0                	test   %eax,%eax
  803862:	74 0f                	je     803873 <alloc_block_BF+0x90>
  803864:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803867:	8b 40 04             	mov    0x4(%eax),%eax
  80386a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80386d:	8b 12                	mov    (%edx),%edx
  80386f:	89 10                	mov    %edx,(%eax)
  803871:	eb 0a                	jmp    80387d <alloc_block_BF+0x9a>
  803873:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803876:	8b 00                	mov    (%eax),%eax
  803878:	a3 38 61 80 00       	mov    %eax,0x806138
  80387d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803880:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803886:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803889:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803890:	a1 44 61 80 00       	mov    0x806144,%eax
  803895:	48                   	dec    %eax
  803896:	a3 44 61 80 00       	mov    %eax,0x806144
	   return temp;
  80389b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80389e:	e9 41 01 00 00       	jmp    8039e4 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8038a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8038a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8038ac:	76 21                	jbe    8038cf <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  8038ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8038b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8038b7:	73 16                	jae    8038cf <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  8038b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8038bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  8038c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  8038c8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8038cf:	a1 40 61 80 00       	mov    0x806140,%eax
  8038d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8038d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038db:	74 07                	je     8038e4 <alloc_block_BF+0x101>
  8038dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038e0:	8b 00                	mov    (%eax),%eax
  8038e2:	eb 05                	jmp    8038e9 <alloc_block_BF+0x106>
  8038e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8038e9:	a3 40 61 80 00       	mov    %eax,0x806140
  8038ee:	a1 40 61 80 00       	mov    0x806140,%eax
  8038f3:	85 c0                	test   %eax,%eax
  8038f5:	0f 85 09 ff ff ff    	jne    803804 <alloc_block_BF+0x21>
  8038fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038ff:	0f 85 ff fe ff ff    	jne    803804 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  803905:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  803909:	0f 85 d0 00 00 00    	jne    8039df <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80390f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803912:	8b 40 0c             	mov    0xc(%eax),%eax
  803915:	2b 45 08             	sub    0x8(%ebp),%eax
  803918:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  80391b:	a1 48 61 80 00       	mov    0x806148,%eax
  803920:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  803923:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803927:	75 17                	jne    803940 <alloc_block_BF+0x15d>
  803929:	83 ec 04             	sub    $0x4,%esp
  80392c:	68 08 50 80 00       	push   $0x805008
  803931:	68 d1 00 00 00       	push   $0xd1
  803936:	68 97 4f 80 00       	push   $0x804f97
  80393b:	e8 e9 da ff ff       	call   801429 <_panic>
  803940:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803943:	8b 00                	mov    (%eax),%eax
  803945:	85 c0                	test   %eax,%eax
  803947:	74 10                	je     803959 <alloc_block_BF+0x176>
  803949:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80394c:	8b 00                	mov    (%eax),%eax
  80394e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803951:	8b 52 04             	mov    0x4(%edx),%edx
  803954:	89 50 04             	mov    %edx,0x4(%eax)
  803957:	eb 0b                	jmp    803964 <alloc_block_BF+0x181>
  803959:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80395c:	8b 40 04             	mov    0x4(%eax),%eax
  80395f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803964:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803967:	8b 40 04             	mov    0x4(%eax),%eax
  80396a:	85 c0                	test   %eax,%eax
  80396c:	74 0f                	je     80397d <alloc_block_BF+0x19a>
  80396e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803971:	8b 40 04             	mov    0x4(%eax),%eax
  803974:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803977:	8b 12                	mov    (%edx),%edx
  803979:	89 10                	mov    %edx,(%eax)
  80397b:	eb 0a                	jmp    803987 <alloc_block_BF+0x1a4>
  80397d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803980:	8b 00                	mov    (%eax),%eax
  803982:	a3 48 61 80 00       	mov    %eax,0x806148
  803987:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80398a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803990:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803993:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80399a:	a1 54 61 80 00       	mov    0x806154,%eax
  80399f:	48                   	dec    %eax
  8039a0:	a3 54 61 80 00       	mov    %eax,0x806154
	  // setting the size & sva
	  new_block->size = size;
  8039a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8039ab:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  8039ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039b1:	8b 50 08             	mov    0x8(%eax),%edx
  8039b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039b7:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  8039ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039c0:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  8039c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039c6:	8b 50 08             	mov    0x8(%eax),%edx
  8039c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cc:	01 c2                	add    %eax,%edx
  8039ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039d1:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  8039d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  8039da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8039dd:	eb 05                	jmp    8039e4 <alloc_block_BF+0x201>
	 }
	 return NULL;
  8039df:	b8 00 00 00 00       	mov    $0x0,%eax


}
  8039e4:	c9                   	leave  
  8039e5:	c3                   	ret    

008039e6 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8039e6:	55                   	push   %ebp
  8039e7:	89 e5                	mov    %esp,%ebp
  8039e9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8039ec:	83 ec 04             	sub    $0x4,%esp
  8039ef:	68 28 50 80 00       	push   $0x805028
  8039f4:	68 e8 00 00 00       	push   $0xe8
  8039f9:	68 97 4f 80 00       	push   $0x804f97
  8039fe:	e8 26 da ff ff       	call   801429 <_panic>

00803a03 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803a03:	55                   	push   %ebp
  803a04:	89 e5                	mov    %esp,%ebp
  803a06:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  803a09:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  803a11:	a1 38 61 80 00       	mov    0x806138,%eax
  803a16:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  803a19:	a1 44 61 80 00       	mov    0x806144,%eax
  803a1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  803a21:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a25:	75 68                	jne    803a8f <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803a27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a2b:	75 17                	jne    803a44 <insert_sorted_with_merge_freeList+0x41>
  803a2d:	83 ec 04             	sub    $0x4,%esp
  803a30:	68 74 4f 80 00       	push   $0x804f74
  803a35:	68 36 01 00 00       	push   $0x136
  803a3a:	68 97 4f 80 00       	push   $0x804f97
  803a3f:	e8 e5 d9 ff ff       	call   801429 <_panic>
  803a44:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4d:	89 10                	mov    %edx,(%eax)
  803a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a52:	8b 00                	mov    (%eax),%eax
  803a54:	85 c0                	test   %eax,%eax
  803a56:	74 0d                	je     803a65 <insert_sorted_with_merge_freeList+0x62>
  803a58:	a1 38 61 80 00       	mov    0x806138,%eax
  803a5d:	8b 55 08             	mov    0x8(%ebp),%edx
  803a60:	89 50 04             	mov    %edx,0x4(%eax)
  803a63:	eb 08                	jmp    803a6d <insert_sorted_with_merge_freeList+0x6a>
  803a65:	8b 45 08             	mov    0x8(%ebp),%eax
  803a68:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a70:	a3 38 61 80 00       	mov    %eax,0x806138
  803a75:	8b 45 08             	mov    0x8(%ebp),%eax
  803a78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a7f:	a1 44 61 80 00       	mov    0x806144,%eax
  803a84:	40                   	inc    %eax
  803a85:	a3 44 61 80 00       	mov    %eax,0x806144





}
  803a8a:	e9 ba 06 00 00       	jmp    804149 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  803a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a92:	8b 50 08             	mov    0x8(%eax),%edx
  803a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a98:	8b 40 0c             	mov    0xc(%eax),%eax
  803a9b:	01 c2                	add    %eax,%edx
  803a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa0:	8b 40 08             	mov    0x8(%eax),%eax
  803aa3:	39 c2                	cmp    %eax,%edx
  803aa5:	73 68                	jae    803b0f <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803aa7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803aab:	75 17                	jne    803ac4 <insert_sorted_with_merge_freeList+0xc1>
  803aad:	83 ec 04             	sub    $0x4,%esp
  803ab0:	68 b0 4f 80 00       	push   $0x804fb0
  803ab5:	68 3a 01 00 00       	push   $0x13a
  803aba:	68 97 4f 80 00       	push   $0x804f97
  803abf:	e8 65 d9 ff ff       	call   801429 <_panic>
  803ac4:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  803aca:	8b 45 08             	mov    0x8(%ebp),%eax
  803acd:	89 50 04             	mov    %edx,0x4(%eax)
  803ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad3:	8b 40 04             	mov    0x4(%eax),%eax
  803ad6:	85 c0                	test   %eax,%eax
  803ad8:	74 0c                	je     803ae6 <insert_sorted_with_merge_freeList+0xe3>
  803ada:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803adf:	8b 55 08             	mov    0x8(%ebp),%edx
  803ae2:	89 10                	mov    %edx,(%eax)
  803ae4:	eb 08                	jmp    803aee <insert_sorted_with_merge_freeList+0xeb>
  803ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae9:	a3 38 61 80 00       	mov    %eax,0x806138
  803aee:	8b 45 08             	mov    0x8(%ebp),%eax
  803af1:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803af6:	8b 45 08             	mov    0x8(%ebp),%eax
  803af9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aff:	a1 44 61 80 00       	mov    0x806144,%eax
  803b04:	40                   	inc    %eax
  803b05:	a3 44 61 80 00       	mov    %eax,0x806144





}
  803b0a:	e9 3a 06 00 00       	jmp    804149 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  803b0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b12:	8b 50 08             	mov    0x8(%eax),%edx
  803b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b18:	8b 40 0c             	mov    0xc(%eax),%eax
  803b1b:	01 c2                	add    %eax,%edx
  803b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b20:	8b 40 08             	mov    0x8(%eax),%eax
  803b23:	39 c2                	cmp    %eax,%edx
  803b25:	0f 85 90 00 00 00    	jne    803bbb <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  803b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b2e:	8b 50 0c             	mov    0xc(%eax),%edx
  803b31:	8b 45 08             	mov    0x8(%ebp),%eax
  803b34:	8b 40 0c             	mov    0xc(%eax),%eax
  803b37:	01 c2                	add    %eax,%edx
  803b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b3c:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  803b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  803b49:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803b53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b57:	75 17                	jne    803b70 <insert_sorted_with_merge_freeList+0x16d>
  803b59:	83 ec 04             	sub    $0x4,%esp
  803b5c:	68 74 4f 80 00       	push   $0x804f74
  803b61:	68 41 01 00 00       	push   $0x141
  803b66:	68 97 4f 80 00       	push   $0x804f97
  803b6b:	e8 b9 d8 ff ff       	call   801429 <_panic>
  803b70:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803b76:	8b 45 08             	mov    0x8(%ebp),%eax
  803b79:	89 10                	mov    %edx,(%eax)
  803b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7e:	8b 00                	mov    (%eax),%eax
  803b80:	85 c0                	test   %eax,%eax
  803b82:	74 0d                	je     803b91 <insert_sorted_with_merge_freeList+0x18e>
  803b84:	a1 48 61 80 00       	mov    0x806148,%eax
  803b89:	8b 55 08             	mov    0x8(%ebp),%edx
  803b8c:	89 50 04             	mov    %edx,0x4(%eax)
  803b8f:	eb 08                	jmp    803b99 <insert_sorted_with_merge_freeList+0x196>
  803b91:	8b 45 08             	mov    0x8(%ebp),%eax
  803b94:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803b99:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9c:	a3 48 61 80 00       	mov    %eax,0x806148
  803ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bab:	a1 54 61 80 00       	mov    0x806154,%eax
  803bb0:	40                   	inc    %eax
  803bb1:	a3 54 61 80 00       	mov    %eax,0x806154





}
  803bb6:	e9 8e 05 00 00       	jmp    804149 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  803bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  803bbe:	8b 50 08             	mov    0x8(%eax),%edx
  803bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc4:	8b 40 0c             	mov    0xc(%eax),%eax
  803bc7:	01 c2                	add    %eax,%edx
  803bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bcc:	8b 40 08             	mov    0x8(%eax),%eax
  803bcf:	39 c2                	cmp    %eax,%edx
  803bd1:	73 68                	jae    803c3b <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803bd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bd7:	75 17                	jne    803bf0 <insert_sorted_with_merge_freeList+0x1ed>
  803bd9:	83 ec 04             	sub    $0x4,%esp
  803bdc:	68 74 4f 80 00       	push   $0x804f74
  803be1:	68 45 01 00 00       	push   $0x145
  803be6:	68 97 4f 80 00       	push   $0x804f97
  803beb:	e8 39 d8 ff ff       	call   801429 <_panic>
  803bf0:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf9:	89 10                	mov    %edx,(%eax)
  803bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfe:	8b 00                	mov    (%eax),%eax
  803c00:	85 c0                	test   %eax,%eax
  803c02:	74 0d                	je     803c11 <insert_sorted_with_merge_freeList+0x20e>
  803c04:	a1 38 61 80 00       	mov    0x806138,%eax
  803c09:	8b 55 08             	mov    0x8(%ebp),%edx
  803c0c:	89 50 04             	mov    %edx,0x4(%eax)
  803c0f:	eb 08                	jmp    803c19 <insert_sorted_with_merge_freeList+0x216>
  803c11:	8b 45 08             	mov    0x8(%ebp),%eax
  803c14:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803c19:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1c:	a3 38 61 80 00       	mov    %eax,0x806138
  803c21:	8b 45 08             	mov    0x8(%ebp),%eax
  803c24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c2b:	a1 44 61 80 00       	mov    0x806144,%eax
  803c30:	40                   	inc    %eax
  803c31:	a3 44 61 80 00       	mov    %eax,0x806144





}
  803c36:	e9 0e 05 00 00       	jmp    804149 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  803c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3e:	8b 50 08             	mov    0x8(%eax),%edx
  803c41:	8b 45 08             	mov    0x8(%ebp),%eax
  803c44:	8b 40 0c             	mov    0xc(%eax),%eax
  803c47:	01 c2                	add    %eax,%edx
  803c49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c4c:	8b 40 08             	mov    0x8(%eax),%eax
  803c4f:	39 c2                	cmp    %eax,%edx
  803c51:	0f 85 9c 00 00 00    	jne    803cf3 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  803c57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c5a:	8b 50 0c             	mov    0xc(%eax),%edx
  803c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c60:	8b 40 0c             	mov    0xc(%eax),%eax
  803c63:	01 c2                	add    %eax,%edx
  803c65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c68:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  803c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c6e:	8b 50 08             	mov    0x8(%eax),%edx
  803c71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c74:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  803c77:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  803c81:	8b 45 08             	mov    0x8(%ebp),%eax
  803c84:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803c8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c8f:	75 17                	jne    803ca8 <insert_sorted_with_merge_freeList+0x2a5>
  803c91:	83 ec 04             	sub    $0x4,%esp
  803c94:	68 74 4f 80 00       	push   $0x804f74
  803c99:	68 4d 01 00 00       	push   $0x14d
  803c9e:	68 97 4f 80 00       	push   $0x804f97
  803ca3:	e8 81 d7 ff ff       	call   801429 <_panic>
  803ca8:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803cae:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb1:	89 10                	mov    %edx,(%eax)
  803cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb6:	8b 00                	mov    (%eax),%eax
  803cb8:	85 c0                	test   %eax,%eax
  803cba:	74 0d                	je     803cc9 <insert_sorted_with_merge_freeList+0x2c6>
  803cbc:	a1 48 61 80 00       	mov    0x806148,%eax
  803cc1:	8b 55 08             	mov    0x8(%ebp),%edx
  803cc4:	89 50 04             	mov    %edx,0x4(%eax)
  803cc7:	eb 08                	jmp    803cd1 <insert_sorted_with_merge_freeList+0x2ce>
  803cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  803ccc:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd4:	a3 48 61 80 00       	mov    %eax,0x806148
  803cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  803cdc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ce3:	a1 54 61 80 00       	mov    0x806154,%eax
  803ce8:	40                   	inc    %eax
  803ce9:	a3 54 61 80 00       	mov    %eax,0x806154





}
  803cee:	e9 56 04 00 00       	jmp    804149 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803cf3:	a1 38 61 80 00       	mov    0x806138,%eax
  803cf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cfb:	e9 19 04 00 00       	jmp    804119 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  803d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d03:	8b 00                	mov    (%eax),%eax
  803d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d0b:	8b 50 08             	mov    0x8(%eax),%edx
  803d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d11:	8b 40 0c             	mov    0xc(%eax),%eax
  803d14:	01 c2                	add    %eax,%edx
  803d16:	8b 45 08             	mov    0x8(%ebp),%eax
  803d19:	8b 40 08             	mov    0x8(%eax),%eax
  803d1c:	39 c2                	cmp    %eax,%edx
  803d1e:	0f 85 ad 01 00 00    	jne    803ed1 <insert_sorted_with_merge_freeList+0x4ce>
  803d24:	8b 45 08             	mov    0x8(%ebp),%eax
  803d27:	8b 50 08             	mov    0x8(%eax),%edx
  803d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d2d:	8b 40 0c             	mov    0xc(%eax),%eax
  803d30:	01 c2                	add    %eax,%edx
  803d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d35:	8b 40 08             	mov    0x8(%eax),%eax
  803d38:	39 c2                	cmp    %eax,%edx
  803d3a:	0f 85 91 01 00 00    	jne    803ed1 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  803d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d43:	8b 50 0c             	mov    0xc(%eax),%edx
  803d46:	8b 45 08             	mov    0x8(%ebp),%eax
  803d49:	8b 48 0c             	mov    0xc(%eax),%ecx
  803d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d4f:	8b 40 0c             	mov    0xc(%eax),%eax
  803d52:	01 c8                	add    %ecx,%eax
  803d54:	01 c2                	add    %eax,%edx
  803d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d59:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  803d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803d66:	8b 45 08             	mov    0x8(%ebp),%eax
  803d69:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  803d70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d73:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  803d7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d7d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  803d84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803d88:	75 17                	jne    803da1 <insert_sorted_with_merge_freeList+0x39e>
  803d8a:	83 ec 04             	sub    $0x4,%esp
  803d8d:	68 08 50 80 00       	push   $0x805008
  803d92:	68 5b 01 00 00       	push   $0x15b
  803d97:	68 97 4f 80 00       	push   $0x804f97
  803d9c:	e8 88 d6 ff ff       	call   801429 <_panic>
  803da1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da4:	8b 00                	mov    (%eax),%eax
  803da6:	85 c0                	test   %eax,%eax
  803da8:	74 10                	je     803dba <insert_sorted_with_merge_freeList+0x3b7>
  803daa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dad:	8b 00                	mov    (%eax),%eax
  803daf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803db2:	8b 52 04             	mov    0x4(%edx),%edx
  803db5:	89 50 04             	mov    %edx,0x4(%eax)
  803db8:	eb 0b                	jmp    803dc5 <insert_sorted_with_merge_freeList+0x3c2>
  803dba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dbd:	8b 40 04             	mov    0x4(%eax),%eax
  803dc0:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803dc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dc8:	8b 40 04             	mov    0x4(%eax),%eax
  803dcb:	85 c0                	test   %eax,%eax
  803dcd:	74 0f                	je     803dde <insert_sorted_with_merge_freeList+0x3db>
  803dcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803dd2:	8b 40 04             	mov    0x4(%eax),%eax
  803dd5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803dd8:	8b 12                	mov    (%edx),%edx
  803dda:	89 10                	mov    %edx,(%eax)
  803ddc:	eb 0a                	jmp    803de8 <insert_sorted_with_merge_freeList+0x3e5>
  803dde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803de1:	8b 00                	mov    (%eax),%eax
  803de3:	a3 38 61 80 00       	mov    %eax,0x806138
  803de8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803deb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803df4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dfb:	a1 44 61 80 00       	mov    0x806144,%eax
  803e00:	48                   	dec    %eax
  803e01:	a3 44 61 80 00       	mov    %eax,0x806144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803e06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e0a:	75 17                	jne    803e23 <insert_sorted_with_merge_freeList+0x420>
  803e0c:	83 ec 04             	sub    $0x4,%esp
  803e0f:	68 74 4f 80 00       	push   $0x804f74
  803e14:	68 5c 01 00 00       	push   $0x15c
  803e19:	68 97 4f 80 00       	push   $0x804f97
  803e1e:	e8 06 d6 ff ff       	call   801429 <_panic>
  803e23:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803e29:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2c:	89 10                	mov    %edx,(%eax)
  803e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e31:	8b 00                	mov    (%eax),%eax
  803e33:	85 c0                	test   %eax,%eax
  803e35:	74 0d                	je     803e44 <insert_sorted_with_merge_freeList+0x441>
  803e37:	a1 48 61 80 00       	mov    0x806148,%eax
  803e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  803e3f:	89 50 04             	mov    %edx,0x4(%eax)
  803e42:	eb 08                	jmp    803e4c <insert_sorted_with_merge_freeList+0x449>
  803e44:	8b 45 08             	mov    0x8(%ebp),%eax
  803e47:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e4f:	a3 48 61 80 00       	mov    %eax,0x806148
  803e54:	8b 45 08             	mov    0x8(%ebp),%eax
  803e57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e5e:	a1 54 61 80 00       	mov    0x806154,%eax
  803e63:	40                   	inc    %eax
  803e64:	a3 54 61 80 00       	mov    %eax,0x806154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  803e69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803e6d:	75 17                	jne    803e86 <insert_sorted_with_merge_freeList+0x483>
  803e6f:	83 ec 04             	sub    $0x4,%esp
  803e72:	68 74 4f 80 00       	push   $0x804f74
  803e77:	68 5d 01 00 00       	push   $0x15d
  803e7c:	68 97 4f 80 00       	push   $0x804f97
  803e81:	e8 a3 d5 ff ff       	call   801429 <_panic>
  803e86:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803e8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e8f:	89 10                	mov    %edx,(%eax)
  803e91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e94:	8b 00                	mov    (%eax),%eax
  803e96:	85 c0                	test   %eax,%eax
  803e98:	74 0d                	je     803ea7 <insert_sorted_with_merge_freeList+0x4a4>
  803e9a:	a1 48 61 80 00       	mov    0x806148,%eax
  803e9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ea2:	89 50 04             	mov    %edx,0x4(%eax)
  803ea5:	eb 08                	jmp    803eaf <insert_sorted_with_merge_freeList+0x4ac>
  803ea7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eaa:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803eaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb2:	a3 48 61 80 00       	mov    %eax,0x806148
  803eb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ec1:	a1 54 61 80 00       	mov    0x806154,%eax
  803ec6:	40                   	inc    %eax
  803ec7:	a3 54 61 80 00       	mov    %eax,0x806154
	        break;
  803ecc:	e9 78 02 00 00       	jmp    804149 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed4:	8b 50 08             	mov    0x8(%eax),%edx
  803ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eda:	8b 40 0c             	mov    0xc(%eax),%eax
  803edd:	01 c2                	add    %eax,%edx
  803edf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee2:	8b 40 08             	mov    0x8(%eax),%eax
  803ee5:	39 c2                	cmp    %eax,%edx
  803ee7:	0f 83 b8 00 00 00    	jae    803fa5 <insert_sorted_with_merge_freeList+0x5a2>
  803eed:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef0:	8b 50 08             	mov    0x8(%eax),%edx
  803ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef6:	8b 40 0c             	mov    0xc(%eax),%eax
  803ef9:	01 c2                	add    %eax,%edx
  803efb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803efe:	8b 40 08             	mov    0x8(%eax),%eax
  803f01:	39 c2                	cmp    %eax,%edx
  803f03:	0f 85 9c 00 00 00    	jne    803fa5 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  803f09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f0c:	8b 50 0c             	mov    0xc(%eax),%edx
  803f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f12:	8b 40 0c             	mov    0xc(%eax),%eax
  803f15:	01 c2                	add    %eax,%edx
  803f17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f1a:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  803f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803f20:	8b 50 08             	mov    0x8(%eax),%edx
  803f23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f26:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  803f29:	8b 45 08             	mov    0x8(%ebp),%eax
  803f2c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803f33:	8b 45 08             	mov    0x8(%ebp),%eax
  803f36:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803f3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f41:	75 17                	jne    803f5a <insert_sorted_with_merge_freeList+0x557>
  803f43:	83 ec 04             	sub    $0x4,%esp
  803f46:	68 74 4f 80 00       	push   $0x804f74
  803f4b:	68 67 01 00 00       	push   $0x167
  803f50:	68 97 4f 80 00       	push   $0x804f97
  803f55:	e8 cf d4 ff ff       	call   801429 <_panic>
  803f5a:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803f60:	8b 45 08             	mov    0x8(%ebp),%eax
  803f63:	89 10                	mov    %edx,(%eax)
  803f65:	8b 45 08             	mov    0x8(%ebp),%eax
  803f68:	8b 00                	mov    (%eax),%eax
  803f6a:	85 c0                	test   %eax,%eax
  803f6c:	74 0d                	je     803f7b <insert_sorted_with_merge_freeList+0x578>
  803f6e:	a1 48 61 80 00       	mov    0x806148,%eax
  803f73:	8b 55 08             	mov    0x8(%ebp),%edx
  803f76:	89 50 04             	mov    %edx,0x4(%eax)
  803f79:	eb 08                	jmp    803f83 <insert_sorted_with_merge_freeList+0x580>
  803f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f7e:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803f83:	8b 45 08             	mov    0x8(%ebp),%eax
  803f86:	a3 48 61 80 00       	mov    %eax,0x806148
  803f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f95:	a1 54 61 80 00       	mov    0x806154,%eax
  803f9a:	40                   	inc    %eax
  803f9b:	a3 54 61 80 00       	mov    %eax,0x806154
	        break;
  803fa0:	e9 a4 01 00 00       	jmp    804149 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa8:	8b 50 08             	mov    0x8(%eax),%edx
  803fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fae:	8b 40 0c             	mov    0xc(%eax),%eax
  803fb1:	01 c2                	add    %eax,%edx
  803fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803fb6:	8b 40 08             	mov    0x8(%eax),%eax
  803fb9:	39 c2                	cmp    %eax,%edx
  803fbb:	0f 85 ac 00 00 00    	jne    80406d <insert_sorted_with_merge_freeList+0x66a>
  803fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc4:	8b 50 08             	mov    0x8(%eax),%edx
  803fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  803fca:	8b 40 0c             	mov    0xc(%eax),%eax
  803fcd:	01 c2                	add    %eax,%edx
  803fcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fd2:	8b 40 08             	mov    0x8(%eax),%eax
  803fd5:	39 c2                	cmp    %eax,%edx
  803fd7:	0f 83 90 00 00 00    	jae    80406d <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  803fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe0:	8b 50 0c             	mov    0xc(%eax),%edx
  803fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe6:	8b 40 0c             	mov    0xc(%eax),%eax
  803fe9:	01 c2                	add    %eax,%edx
  803feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fee:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  803ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ff4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  803ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ffe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  804005:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804009:	75 17                	jne    804022 <insert_sorted_with_merge_freeList+0x61f>
  80400b:	83 ec 04             	sub    $0x4,%esp
  80400e:	68 74 4f 80 00       	push   $0x804f74
  804013:	68 70 01 00 00       	push   $0x170
  804018:	68 97 4f 80 00       	push   $0x804f97
  80401d:	e8 07 d4 ff ff       	call   801429 <_panic>
  804022:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804028:	8b 45 08             	mov    0x8(%ebp),%eax
  80402b:	89 10                	mov    %edx,(%eax)
  80402d:	8b 45 08             	mov    0x8(%ebp),%eax
  804030:	8b 00                	mov    (%eax),%eax
  804032:	85 c0                	test   %eax,%eax
  804034:	74 0d                	je     804043 <insert_sorted_with_merge_freeList+0x640>
  804036:	a1 48 61 80 00       	mov    0x806148,%eax
  80403b:	8b 55 08             	mov    0x8(%ebp),%edx
  80403e:	89 50 04             	mov    %edx,0x4(%eax)
  804041:	eb 08                	jmp    80404b <insert_sorted_with_merge_freeList+0x648>
  804043:	8b 45 08             	mov    0x8(%ebp),%eax
  804046:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80404b:	8b 45 08             	mov    0x8(%ebp),%eax
  80404e:	a3 48 61 80 00       	mov    %eax,0x806148
  804053:	8b 45 08             	mov    0x8(%ebp),%eax
  804056:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80405d:	a1 54 61 80 00       	mov    0x806154,%eax
  804062:	40                   	inc    %eax
  804063:	a3 54 61 80 00       	mov    %eax,0x806154
	      break;
  804068:	e9 dc 00 00 00       	jmp    804149 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80406d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804070:	8b 50 08             	mov    0x8(%eax),%edx
  804073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804076:	8b 40 0c             	mov    0xc(%eax),%eax
  804079:	01 c2                	add    %eax,%edx
  80407b:	8b 45 08             	mov    0x8(%ebp),%eax
  80407e:	8b 40 08             	mov    0x8(%eax),%eax
  804081:	39 c2                	cmp    %eax,%edx
  804083:	0f 83 88 00 00 00    	jae    804111 <insert_sorted_with_merge_freeList+0x70e>
  804089:	8b 45 08             	mov    0x8(%ebp),%eax
  80408c:	8b 50 08             	mov    0x8(%eax),%edx
  80408f:	8b 45 08             	mov    0x8(%ebp),%eax
  804092:	8b 40 0c             	mov    0xc(%eax),%eax
  804095:	01 c2                	add    %eax,%edx
  804097:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80409a:	8b 40 08             	mov    0x8(%eax),%eax
  80409d:	39 c2                	cmp    %eax,%edx
  80409f:	73 70                	jae    804111 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  8040a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8040a5:	74 06                	je     8040ad <insert_sorted_with_merge_freeList+0x6aa>
  8040a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8040ab:	75 17                	jne    8040c4 <insert_sorted_with_merge_freeList+0x6c1>
  8040ad:	83 ec 04             	sub    $0x4,%esp
  8040b0:	68 d4 4f 80 00       	push   $0x804fd4
  8040b5:	68 75 01 00 00       	push   $0x175
  8040ba:	68 97 4f 80 00       	push   $0x804f97
  8040bf:	e8 65 d3 ff ff       	call   801429 <_panic>
  8040c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040c7:	8b 10                	mov    (%eax),%edx
  8040c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8040cc:	89 10                	mov    %edx,(%eax)
  8040ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8040d1:	8b 00                	mov    (%eax),%eax
  8040d3:	85 c0                	test   %eax,%eax
  8040d5:	74 0b                	je     8040e2 <insert_sorted_with_merge_freeList+0x6df>
  8040d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040da:	8b 00                	mov    (%eax),%eax
  8040dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8040df:	89 50 04             	mov    %edx,0x4(%eax)
  8040e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8040e8:	89 10                	mov    %edx,(%eax)
  8040ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040f0:	89 50 04             	mov    %edx,0x4(%eax)
  8040f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8040f6:	8b 00                	mov    (%eax),%eax
  8040f8:	85 c0                	test   %eax,%eax
  8040fa:	75 08                	jne    804104 <insert_sorted_with_merge_freeList+0x701>
  8040fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ff:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804104:	a1 44 61 80 00       	mov    0x806144,%eax
  804109:	40                   	inc    %eax
  80410a:	a3 44 61 80 00       	mov    %eax,0x806144
	      break;
  80410f:	eb 38                	jmp    804149 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  804111:	a1 40 61 80 00       	mov    0x806140,%eax
  804116:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804119:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80411d:	74 07                	je     804126 <insert_sorted_with_merge_freeList+0x723>
  80411f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804122:	8b 00                	mov    (%eax),%eax
  804124:	eb 05                	jmp    80412b <insert_sorted_with_merge_freeList+0x728>
  804126:	b8 00 00 00 00       	mov    $0x0,%eax
  80412b:	a3 40 61 80 00       	mov    %eax,0x806140
  804130:	a1 40 61 80 00       	mov    0x806140,%eax
  804135:	85 c0                	test   %eax,%eax
  804137:	0f 85 c3 fb ff ff    	jne    803d00 <insert_sorted_with_merge_freeList+0x2fd>
  80413d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804141:	0f 85 b9 fb ff ff    	jne    803d00 <insert_sorted_with_merge_freeList+0x2fd>





}
  804147:	eb 00                	jmp    804149 <insert_sorted_with_merge_freeList+0x746>
  804149:	90                   	nop
  80414a:	c9                   	leave  
  80414b:	c3                   	ret    

0080414c <__udivdi3>:
  80414c:	55                   	push   %ebp
  80414d:	57                   	push   %edi
  80414e:	56                   	push   %esi
  80414f:	53                   	push   %ebx
  804150:	83 ec 1c             	sub    $0x1c,%esp
  804153:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804157:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80415b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80415f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804163:	89 ca                	mov    %ecx,%edx
  804165:	89 f8                	mov    %edi,%eax
  804167:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80416b:	85 f6                	test   %esi,%esi
  80416d:	75 2d                	jne    80419c <__udivdi3+0x50>
  80416f:	39 cf                	cmp    %ecx,%edi
  804171:	77 65                	ja     8041d8 <__udivdi3+0x8c>
  804173:	89 fd                	mov    %edi,%ebp
  804175:	85 ff                	test   %edi,%edi
  804177:	75 0b                	jne    804184 <__udivdi3+0x38>
  804179:	b8 01 00 00 00       	mov    $0x1,%eax
  80417e:	31 d2                	xor    %edx,%edx
  804180:	f7 f7                	div    %edi
  804182:	89 c5                	mov    %eax,%ebp
  804184:	31 d2                	xor    %edx,%edx
  804186:	89 c8                	mov    %ecx,%eax
  804188:	f7 f5                	div    %ebp
  80418a:	89 c1                	mov    %eax,%ecx
  80418c:	89 d8                	mov    %ebx,%eax
  80418e:	f7 f5                	div    %ebp
  804190:	89 cf                	mov    %ecx,%edi
  804192:	89 fa                	mov    %edi,%edx
  804194:	83 c4 1c             	add    $0x1c,%esp
  804197:	5b                   	pop    %ebx
  804198:	5e                   	pop    %esi
  804199:	5f                   	pop    %edi
  80419a:	5d                   	pop    %ebp
  80419b:	c3                   	ret    
  80419c:	39 ce                	cmp    %ecx,%esi
  80419e:	77 28                	ja     8041c8 <__udivdi3+0x7c>
  8041a0:	0f bd fe             	bsr    %esi,%edi
  8041a3:	83 f7 1f             	xor    $0x1f,%edi
  8041a6:	75 40                	jne    8041e8 <__udivdi3+0x9c>
  8041a8:	39 ce                	cmp    %ecx,%esi
  8041aa:	72 0a                	jb     8041b6 <__udivdi3+0x6a>
  8041ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8041b0:	0f 87 9e 00 00 00    	ja     804254 <__udivdi3+0x108>
  8041b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8041bb:	89 fa                	mov    %edi,%edx
  8041bd:	83 c4 1c             	add    $0x1c,%esp
  8041c0:	5b                   	pop    %ebx
  8041c1:	5e                   	pop    %esi
  8041c2:	5f                   	pop    %edi
  8041c3:	5d                   	pop    %ebp
  8041c4:	c3                   	ret    
  8041c5:	8d 76 00             	lea    0x0(%esi),%esi
  8041c8:	31 ff                	xor    %edi,%edi
  8041ca:	31 c0                	xor    %eax,%eax
  8041cc:	89 fa                	mov    %edi,%edx
  8041ce:	83 c4 1c             	add    $0x1c,%esp
  8041d1:	5b                   	pop    %ebx
  8041d2:	5e                   	pop    %esi
  8041d3:	5f                   	pop    %edi
  8041d4:	5d                   	pop    %ebp
  8041d5:	c3                   	ret    
  8041d6:	66 90                	xchg   %ax,%ax
  8041d8:	89 d8                	mov    %ebx,%eax
  8041da:	f7 f7                	div    %edi
  8041dc:	31 ff                	xor    %edi,%edi
  8041de:	89 fa                	mov    %edi,%edx
  8041e0:	83 c4 1c             	add    $0x1c,%esp
  8041e3:	5b                   	pop    %ebx
  8041e4:	5e                   	pop    %esi
  8041e5:	5f                   	pop    %edi
  8041e6:	5d                   	pop    %ebp
  8041e7:	c3                   	ret    
  8041e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8041ed:	89 eb                	mov    %ebp,%ebx
  8041ef:	29 fb                	sub    %edi,%ebx
  8041f1:	89 f9                	mov    %edi,%ecx
  8041f3:	d3 e6                	shl    %cl,%esi
  8041f5:	89 c5                	mov    %eax,%ebp
  8041f7:	88 d9                	mov    %bl,%cl
  8041f9:	d3 ed                	shr    %cl,%ebp
  8041fb:	89 e9                	mov    %ebp,%ecx
  8041fd:	09 f1                	or     %esi,%ecx
  8041ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804203:	89 f9                	mov    %edi,%ecx
  804205:	d3 e0                	shl    %cl,%eax
  804207:	89 c5                	mov    %eax,%ebp
  804209:	89 d6                	mov    %edx,%esi
  80420b:	88 d9                	mov    %bl,%cl
  80420d:	d3 ee                	shr    %cl,%esi
  80420f:	89 f9                	mov    %edi,%ecx
  804211:	d3 e2                	shl    %cl,%edx
  804213:	8b 44 24 08          	mov    0x8(%esp),%eax
  804217:	88 d9                	mov    %bl,%cl
  804219:	d3 e8                	shr    %cl,%eax
  80421b:	09 c2                	or     %eax,%edx
  80421d:	89 d0                	mov    %edx,%eax
  80421f:	89 f2                	mov    %esi,%edx
  804221:	f7 74 24 0c          	divl   0xc(%esp)
  804225:	89 d6                	mov    %edx,%esi
  804227:	89 c3                	mov    %eax,%ebx
  804229:	f7 e5                	mul    %ebp
  80422b:	39 d6                	cmp    %edx,%esi
  80422d:	72 19                	jb     804248 <__udivdi3+0xfc>
  80422f:	74 0b                	je     80423c <__udivdi3+0xf0>
  804231:	89 d8                	mov    %ebx,%eax
  804233:	31 ff                	xor    %edi,%edi
  804235:	e9 58 ff ff ff       	jmp    804192 <__udivdi3+0x46>
  80423a:	66 90                	xchg   %ax,%ax
  80423c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804240:	89 f9                	mov    %edi,%ecx
  804242:	d3 e2                	shl    %cl,%edx
  804244:	39 c2                	cmp    %eax,%edx
  804246:	73 e9                	jae    804231 <__udivdi3+0xe5>
  804248:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80424b:	31 ff                	xor    %edi,%edi
  80424d:	e9 40 ff ff ff       	jmp    804192 <__udivdi3+0x46>
  804252:	66 90                	xchg   %ax,%ax
  804254:	31 c0                	xor    %eax,%eax
  804256:	e9 37 ff ff ff       	jmp    804192 <__udivdi3+0x46>
  80425b:	90                   	nop

0080425c <__umoddi3>:
  80425c:	55                   	push   %ebp
  80425d:	57                   	push   %edi
  80425e:	56                   	push   %esi
  80425f:	53                   	push   %ebx
  804260:	83 ec 1c             	sub    $0x1c,%esp
  804263:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804267:	8b 74 24 34          	mov    0x34(%esp),%esi
  80426b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80426f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804273:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804277:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80427b:	89 f3                	mov    %esi,%ebx
  80427d:	89 fa                	mov    %edi,%edx
  80427f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804283:	89 34 24             	mov    %esi,(%esp)
  804286:	85 c0                	test   %eax,%eax
  804288:	75 1a                	jne    8042a4 <__umoddi3+0x48>
  80428a:	39 f7                	cmp    %esi,%edi
  80428c:	0f 86 a2 00 00 00    	jbe    804334 <__umoddi3+0xd8>
  804292:	89 c8                	mov    %ecx,%eax
  804294:	89 f2                	mov    %esi,%edx
  804296:	f7 f7                	div    %edi
  804298:	89 d0                	mov    %edx,%eax
  80429a:	31 d2                	xor    %edx,%edx
  80429c:	83 c4 1c             	add    $0x1c,%esp
  80429f:	5b                   	pop    %ebx
  8042a0:	5e                   	pop    %esi
  8042a1:	5f                   	pop    %edi
  8042a2:	5d                   	pop    %ebp
  8042a3:	c3                   	ret    
  8042a4:	39 f0                	cmp    %esi,%eax
  8042a6:	0f 87 ac 00 00 00    	ja     804358 <__umoddi3+0xfc>
  8042ac:	0f bd e8             	bsr    %eax,%ebp
  8042af:	83 f5 1f             	xor    $0x1f,%ebp
  8042b2:	0f 84 ac 00 00 00    	je     804364 <__umoddi3+0x108>
  8042b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8042bd:	29 ef                	sub    %ebp,%edi
  8042bf:	89 fe                	mov    %edi,%esi
  8042c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8042c5:	89 e9                	mov    %ebp,%ecx
  8042c7:	d3 e0                	shl    %cl,%eax
  8042c9:	89 d7                	mov    %edx,%edi
  8042cb:	89 f1                	mov    %esi,%ecx
  8042cd:	d3 ef                	shr    %cl,%edi
  8042cf:	09 c7                	or     %eax,%edi
  8042d1:	89 e9                	mov    %ebp,%ecx
  8042d3:	d3 e2                	shl    %cl,%edx
  8042d5:	89 14 24             	mov    %edx,(%esp)
  8042d8:	89 d8                	mov    %ebx,%eax
  8042da:	d3 e0                	shl    %cl,%eax
  8042dc:	89 c2                	mov    %eax,%edx
  8042de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042e2:	d3 e0                	shl    %cl,%eax
  8042e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042ec:	89 f1                	mov    %esi,%ecx
  8042ee:	d3 e8                	shr    %cl,%eax
  8042f0:	09 d0                	or     %edx,%eax
  8042f2:	d3 eb                	shr    %cl,%ebx
  8042f4:	89 da                	mov    %ebx,%edx
  8042f6:	f7 f7                	div    %edi
  8042f8:	89 d3                	mov    %edx,%ebx
  8042fa:	f7 24 24             	mull   (%esp)
  8042fd:	89 c6                	mov    %eax,%esi
  8042ff:	89 d1                	mov    %edx,%ecx
  804301:	39 d3                	cmp    %edx,%ebx
  804303:	0f 82 87 00 00 00    	jb     804390 <__umoddi3+0x134>
  804309:	0f 84 91 00 00 00    	je     8043a0 <__umoddi3+0x144>
  80430f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804313:	29 f2                	sub    %esi,%edx
  804315:	19 cb                	sbb    %ecx,%ebx
  804317:	89 d8                	mov    %ebx,%eax
  804319:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80431d:	d3 e0                	shl    %cl,%eax
  80431f:	89 e9                	mov    %ebp,%ecx
  804321:	d3 ea                	shr    %cl,%edx
  804323:	09 d0                	or     %edx,%eax
  804325:	89 e9                	mov    %ebp,%ecx
  804327:	d3 eb                	shr    %cl,%ebx
  804329:	89 da                	mov    %ebx,%edx
  80432b:	83 c4 1c             	add    $0x1c,%esp
  80432e:	5b                   	pop    %ebx
  80432f:	5e                   	pop    %esi
  804330:	5f                   	pop    %edi
  804331:	5d                   	pop    %ebp
  804332:	c3                   	ret    
  804333:	90                   	nop
  804334:	89 fd                	mov    %edi,%ebp
  804336:	85 ff                	test   %edi,%edi
  804338:	75 0b                	jne    804345 <__umoddi3+0xe9>
  80433a:	b8 01 00 00 00       	mov    $0x1,%eax
  80433f:	31 d2                	xor    %edx,%edx
  804341:	f7 f7                	div    %edi
  804343:	89 c5                	mov    %eax,%ebp
  804345:	89 f0                	mov    %esi,%eax
  804347:	31 d2                	xor    %edx,%edx
  804349:	f7 f5                	div    %ebp
  80434b:	89 c8                	mov    %ecx,%eax
  80434d:	f7 f5                	div    %ebp
  80434f:	89 d0                	mov    %edx,%eax
  804351:	e9 44 ff ff ff       	jmp    80429a <__umoddi3+0x3e>
  804356:	66 90                	xchg   %ax,%ax
  804358:	89 c8                	mov    %ecx,%eax
  80435a:	89 f2                	mov    %esi,%edx
  80435c:	83 c4 1c             	add    $0x1c,%esp
  80435f:	5b                   	pop    %ebx
  804360:	5e                   	pop    %esi
  804361:	5f                   	pop    %edi
  804362:	5d                   	pop    %ebp
  804363:	c3                   	ret    
  804364:	3b 04 24             	cmp    (%esp),%eax
  804367:	72 06                	jb     80436f <__umoddi3+0x113>
  804369:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80436d:	77 0f                	ja     80437e <__umoddi3+0x122>
  80436f:	89 f2                	mov    %esi,%edx
  804371:	29 f9                	sub    %edi,%ecx
  804373:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804377:	89 14 24             	mov    %edx,(%esp)
  80437a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80437e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804382:	8b 14 24             	mov    (%esp),%edx
  804385:	83 c4 1c             	add    $0x1c,%esp
  804388:	5b                   	pop    %ebx
  804389:	5e                   	pop    %esi
  80438a:	5f                   	pop    %edi
  80438b:	5d                   	pop    %ebp
  80438c:	c3                   	ret    
  80438d:	8d 76 00             	lea    0x0(%esi),%esi
  804390:	2b 04 24             	sub    (%esp),%eax
  804393:	19 fa                	sbb    %edi,%edx
  804395:	89 d1                	mov    %edx,%ecx
  804397:	89 c6                	mov    %eax,%esi
  804399:	e9 71 ff ff ff       	jmp    80430f <__umoddi3+0xb3>
  80439e:	66 90                	xchg   %ax,%ax
  8043a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8043a4:	72 ea                	jb     804390 <__umoddi3+0x134>
  8043a6:	89 d9                	mov    %ebx,%ecx
  8043a8:	e9 62 ff ff ff       	jmp    80430f <__umoddi3+0xb3>
