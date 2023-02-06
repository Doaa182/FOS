
obj/user/tst_realloc_3:     file format elf32-i386


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
  800031:	e8 29 06 00 00       	call   80065f <libmain>
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
  80003d:	83 ec 40             	sub    $0x40,%esp
	int Mega = 1024*1024;
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[5] = {0};
  80004e:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800051:	b9 05 00 00 00       	mov    $0x5,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 40 37 80 00       	push   $0x803740
  800067:	e8 e3 09 00 00       	call   800a4f <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 100 KB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 93 1d 00 00       	call   801e07 <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 2b 1e 00 00       	call   801ea7 <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(100*kilo - kilo);
  80007f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800082:	89 d0                	mov    %edx,%eax
  800084:	01 c0                	add    %eax,%eax
  800086:	01 d0                	add    %edx,%eax
  800088:	89 c2                	mov    %eax,%edx
  80008a:	c1 e2 05             	shl    $0x5,%edx
  80008d:	01 d0                	add    %edx,%eax
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	e8 30 19 00 00       	call   8019c8 <malloc>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8000a1:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a6:	74 14                	je     8000bc <_main+0x84>
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 64 37 80 00       	push   $0x803764
  8000b0:	6a 11                	push   $0x11
  8000b2:	68 94 37 80 00       	push   $0x803794
  8000b7:	e8 df 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000bf:	e8 43 1d 00 00       	call   801e07 <sys_calculate_free_frames>
  8000c4:	29 c3                	sub    %eax,%ebx
  8000c6:	89 d8                	mov    %ebx,%eax
  8000c8:	83 f8 01             	cmp    $0x1,%eax
  8000cb:	74 14                	je     8000e1 <_main+0xa9>
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 ac 37 80 00       	push   $0x8037ac
  8000d5:	6a 13                	push   $0x13
  8000d7:	68 94 37 80 00       	push   $0x803794
  8000dc:	e8 ba 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are allocated in PageFile");
  8000e1:	e8 c1 1d 00 00       	call   801ea7 <sys_pf_calculate_allocated_pages>
  8000e6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000e9:	83 f8 19             	cmp    $0x19,%eax
  8000ec:	74 14                	je     800102 <_main+0xca>
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 18 38 80 00       	push   $0x803818
  8000f6:	6a 14                	push   $0x14
  8000f8:	68 94 37 80 00       	push   $0x803794
  8000fd:	e8 99 06 00 00       	call   80079b <_panic>

		//Allocate 20 KB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 00 1d 00 00       	call   801e07 <sys_calculate_free_frames>
  800107:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 98 1d 00 00       	call   801ea7 <sys_pf_calculate_allocated_pages>
  80010f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(20*kilo-kilo);
  800112:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800115:	89 d0                	mov    %edx,%eax
  800117:	c1 e0 03             	shl    $0x3,%eax
  80011a:	01 d0                	add    %edx,%eax
  80011c:	01 c0                	add    %eax,%eax
  80011e:	01 d0                	add    %edx,%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 9f 18 00 00       	call   8019c8 <malloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 100 * kilo)) panic("Wrong start address for the allocated space... ");
  80012f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800132:	89 c1                	mov    %eax,%ecx
  800134:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800137:	89 d0                	mov    %edx,%eax
  800139:	c1 e0 02             	shl    $0x2,%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800145:	01 d0                	add    %edx,%eax
  800147:	c1 e0 02             	shl    $0x2,%eax
  80014a:	05 00 00 00 80       	add    $0x80000000,%eax
  80014f:	39 c1                	cmp    %eax,%ecx
  800151:	74 14                	je     800167 <_main+0x12f>
  800153:	83 ec 04             	sub    $0x4,%esp
  800156:	68 64 37 80 00       	push   $0x803764
  80015b:	6a 1a                	push   $0x1a
  80015d:	68 94 37 80 00       	push   $0x803794
  800162:	e8 34 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800167:	e8 9b 1c 00 00       	call   801e07 <sys_calculate_free_frames>
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	39 c2                	cmp    %eax,%edx
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 ac 37 80 00       	push   $0x8037ac
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 94 37 80 00       	push   $0x803794
  800184:	e8 12 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 5) panic("Extra or less pages are allocated in PageFile");
  800189:	e8 19 1d 00 00       	call   801ea7 <sys_pf_calculate_allocated_pages>
  80018e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800191:	83 f8 05             	cmp    $0x5,%eax
  800194:	74 14                	je     8001aa <_main+0x172>
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	68 18 38 80 00       	push   $0x803818
  80019e:	6a 1d                	push   $0x1d
  8001a0:	68 94 37 80 00       	push   $0x803794
  8001a5:	e8 f1 05 00 00       	call   80079b <_panic>

		//Allocate 30 KB
		freeFrames = sys_calculate_free_frames() ;
  8001aa:	e8 58 1c 00 00       	call   801e07 <sys_calculate_free_frames>
  8001af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b2:	e8 f0 1c 00 00       	call   801ea7 <sys_pf_calculate_allocated_pages>
  8001b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(30 * kilo -kilo);
  8001ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001bd:	89 d0                	mov    %edx,%eax
  8001bf:	01 c0                	add    %eax,%eax
  8001c1:	01 d0                	add    %edx,%eax
  8001c3:	01 c0                	add    %eax,%eax
  8001c5:	01 d0                	add    %edx,%eax
  8001c7:	c1 e0 02             	shl    $0x2,%eax
  8001ca:	01 d0                	add    %edx,%eax
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	e8 f3 17 00 00       	call   8019c8 <malloc>
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 120 * kilo)) panic("Wrong start address for the allocated space... ");
  8001db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001de:	89 c1                	mov    %eax,%ecx
  8001e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001e3:	89 d0                	mov    %edx,%eax
  8001e5:	01 c0                	add    %eax,%eax
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f0:	01 d0                	add    %edx,%eax
  8001f2:	c1 e0 03             	shl    $0x3,%eax
  8001f5:	05 00 00 00 80       	add    $0x80000000,%eax
  8001fa:	39 c1                	cmp    %eax,%ecx
  8001fc:	74 14                	je     800212 <_main+0x1da>
  8001fe:	83 ec 04             	sub    $0x4,%esp
  800201:	68 64 37 80 00       	push   $0x803764
  800206:	6a 23                	push   $0x23
  800208:	68 94 37 80 00       	push   $0x803794
  80020d:	e8 89 05 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800212:	e8 f0 1b 00 00       	call   801e07 <sys_calculate_free_frames>
  800217:	89 c2                	mov    %eax,%edx
  800219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 ac 37 80 00       	push   $0x8037ac
  800228:	6a 25                	push   $0x25
  80022a:	68 94 37 80 00       	push   $0x803794
  80022f:	e8 67 05 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8) panic("Extra or less pages are allocated in PageFile");
  800234:	e8 6e 1c 00 00       	call   801ea7 <sys_pf_calculate_allocated_pages>
  800239:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023c:	83 f8 08             	cmp    $0x8,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 18 38 80 00       	push   $0x803818
  800249:	6a 26                	push   $0x26
  80024b:	68 94 37 80 00       	push   $0x803794
  800250:	e8 46 05 00 00       	call   80079b <_panic>

		//Allocate 40 KB
		freeFrames = sys_calculate_free_frames() ;
  800255:	e8 ad 1b 00 00       	call   801e07 <sys_calculate_free_frames>
  80025a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025d:	e8 45 1c 00 00       	call   801ea7 <sys_pf_calculate_allocated_pages>
  800262:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(40 * kilo -kilo);
  800265:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800268:	89 d0                	mov    %edx,%eax
  80026a:	c1 e0 03             	shl    $0x3,%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	01 c0                	add    %eax,%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	01 c0                	add    %eax,%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	50                   	push   %eax
  80027b:	e8 48 17 00 00       	call   8019c8 <malloc>
  800280:	83 c4 10             	add    $0x10,%esp
  800283:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 152 * kilo)) panic("Wrong start address for the allocated space... ");
  800286:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800289:	89 c1                	mov    %eax,%ecx
  80028b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80028e:	89 d0                	mov    %edx,%eax
  800290:	c1 e0 03             	shl    $0x3,%eax
  800293:	01 d0                	add    %edx,%eax
  800295:	01 c0                	add    %eax,%eax
  800297:	01 d0                	add    %edx,%eax
  800299:	c1 e0 03             	shl    $0x3,%eax
  80029c:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a1:	39 c1                	cmp    %eax,%ecx
  8002a3:	74 14                	je     8002b9 <_main+0x281>
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	68 64 37 80 00       	push   $0x803764
  8002ad:	6a 2c                	push   $0x2c
  8002af:	68 94 37 80 00       	push   $0x803794
  8002b4:	e8 e2 04 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002b9:	e8 49 1b 00 00       	call   801e07 <sys_calculate_free_frames>
  8002be:	89 c2                	mov    %eax,%edx
  8002c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c3:	39 c2                	cmp    %eax,%edx
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 ac 37 80 00       	push   $0x8037ac
  8002cf:	6a 2e                	push   $0x2e
  8002d1:	68 94 37 80 00       	push   $0x803794
  8002d6:	e8 c0 04 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 10) panic("Extra or less pages are allocated in PageFile");
  8002db:	e8 c7 1b 00 00       	call   801ea7 <sys_pf_calculate_allocated_pages>
  8002e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002e3:	83 f8 0a             	cmp    $0xa,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 18 38 80 00       	push   $0x803818
  8002f0:	6a 2f                	push   $0x2f
  8002f2:	68 94 37 80 00       	push   $0x803794
  8002f7:	e8 9f 04 00 00       	call   80079b <_panic>


	}


	int cnt = 0;
  8002fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	//[2] Test Re-allocation
	{
		/*Reallocate the first array (100 KB) to the last hole*/

		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
  800303:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800306:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  800309:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80030c:	89 d0                	mov    %edx,%eax
  80030e:	c1 e0 02             	shl    $0x2,%eax
  800311:	01 d0                	add    %edx,%eax
  800313:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031a:	01 d0                	add    %edx,%eax
  80031c:	c1 e0 02             	shl    $0x2,%eax
  80031f:	c1 e8 02             	shr    $0x2,%eax
  800322:	48                   	dec    %eax
  800323:	89 45 d8             	mov    %eax,-0x28(%ebp)

		int i = 0;
  800326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for (i=0; i < lastIndexOfInt1 ; i++)
  80032d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800334:	eb 17                	jmp    80034d <_main+0x315>
		{
			intArr[i] = i ;
  800336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800340:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800343:	01 c2                	add    %eax,%edx
  800345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800348:	89 02                	mov    %eax,(%edx)
		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		int i = 0;
		for (i=0; i < lastIndexOfInt1 ; i++)
  80034a:	ff 45 f4             	incl   -0xc(%ebp)
  80034d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800350:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800353:	7c e1                	jl     800336 <_main+0x2fe>
		{
			intArr[i] = i ;
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  800355:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800358:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  80035b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80035e:	89 d0                	mov    %edx,%eax
  800360:	c1 e0 02             	shl    $0x2,%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	c1 e0 02             	shl    $0x2,%eax
  800368:	c1 e8 02             	shr    $0x2,%eax
  80036b:	48                   	dec    %eax
  80036c:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  80036f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800376:	eb 17                	jmp    80038f <_main+0x357>
		{
			intArr[i] = i ;
  800378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800382:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800385:	01 c2                	add    %eax,%edx
  800387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038a:	89 02                	mov    %eax,(%edx)

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80038c:	ff 45 f4             	incl   -0xc(%ebp)
  80038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800392:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800395:	7c e1                	jl     800378 <_main+0x340>
		{
			intArr[i] = i ;
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800397:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80039a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80039d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003a0:	89 d0                	mov    %edx,%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ad:	01 d0                	add    %edx,%eax
  8003af:	01 c0                	add    %eax,%eax
  8003b1:	c1 e8 02             	shr    $0x2,%eax
  8003b4:	48                   	dec    %eax
  8003b5:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003bf:	eb 17                	jmp    8003d8 <_main+0x3a0>
		{
			intArr[i] = i ;
  8003c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003d5:	ff 45 f4             	incl   -0xc(%ebp)
  8003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003db:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8003de:	7c e1                	jl     8003c1 <_main+0x389>
		{
			intArr[i] = i ;
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8003e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8003e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003e9:	89 d0                	mov    %edx,%eax
  8003eb:	c1 e0 02             	shl    $0x2,%eax
  8003ee:	01 d0                	add    %edx,%eax
  8003f0:	c1 e0 03             	shl    $0x3,%eax
  8003f3:	c1 e8 02             	shr    $0x2,%eax
  8003f6:	48                   	dec    %eax
  8003f7:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800401:	eb 17                	jmp    80041a <_main+0x3e2>
		{
			intArr[i] = i ;
  800403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800406:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800410:	01 c2                	add    %eax,%edx
  800412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800415:	89 02                	mov    %eax,(%edx)

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800417:	ff 45 f4             	incl   -0xc(%ebp)
  80041a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800420:	7c e1                	jl     800403 <_main+0x3cb>
			intArr[i] = i ;
		}


		//Reallocate the first array to 200 KB [should be moved to after the fourth one]
		freeFrames = sys_calculate_free_frames() ;
  800422:	e8 e0 19 00 00       	call   801e07 <sys_calculate_free_frames>
  800427:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042a:	e8 78 1a 00 00       	call   801ea7 <sys_pf_calculate_allocated_pages>
  80042f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 200 * kilo - kilo);
  800432:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800435:	89 d0                	mov    %edx,%eax
  800437:	01 c0                	add    %eax,%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	89 c1                	mov    %eax,%ecx
  80043d:	c1 e1 05             	shl    $0x5,%ecx
  800440:	01 c8                	add    %ecx,%eax
  800442:	01 c0                	add    %eax,%eax
  800444:	01 d0                	add    %edx,%eax
  800446:	89 c2                	mov    %eax,%edx
  800448:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	52                   	push   %edx
  80044f:	50                   	push   %eax
  800450:	e8 30 18 00 00       	call   801c85 <realloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 192 * kilo)) panic("Wrong start address for the re-allocated space... ");
  80045b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	c1 e0 06             	shl    $0x6,%eax
  80046c:	05 00 00 00 80       	add    $0x80000000,%eax
  800471:	39 c1                	cmp    %eax,%ecx
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 48 38 80 00       	push   $0x803848
  80047d:	6a 6b                	push   $0x6b
  80047f:	68 94 37 80 00       	push   $0x803794
  800484:	e8 12 03 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		//if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are re-allocated in PageFile");
  800489:	e8 19 1a 00 00       	call   801ea7 <sys_pf_calculate_allocated_pages>
  80048e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800491:	83 f8 19             	cmp    $0x19,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 7c 38 80 00       	push   $0x80387c
  80049e:	6a 6e                	push   $0x6e
  8004a0:	68 94 37 80 00       	push   $0x803794
  8004a5:	e8 f1 02 00 00       	call   80079b <_panic>


		vcprintf("\b\b\b50%", NULL);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	6a 00                	push   $0x0
  8004af:	68 ad 38 80 00       	push   $0x8038ad
  8004b4:	e8 2b 05 00 00       	call   8009e4 <vcprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
  8004bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  8004c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004c5:	89 d0                	mov    %edx,%eax
  8004c7:	c1 e0 02             	shl    $0x2,%eax
  8004ca:	01 d0                	add    %edx,%eax
  8004cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 02             	shl    $0x2,%eax
  8004d8:	c1 e8 02             	shr    $0x2,%eax
  8004db:	48                   	dec    %eax
  8004dc:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8004df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004e6:	eb 2d                	jmp    800515 <_main+0x4dd>
		{
			if(intArr[i] != i)
  8004e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004f5:	01 d0                	add    %edx,%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004fc:	74 14                	je     800512 <_main+0x4da>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 b4 38 80 00       	push   $0x8038b4
  800506:	6a 7a                	push   $0x7a
  800508:	68 94 37 80 00       	push   $0x803794
  80050d:	e8 89 02 00 00       	call   80079b <_panic>

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800512:	ff 45 f4             	incl   -0xc(%ebp)
  800515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800518:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80051b:	7c cb                	jl     8004e8 <_main+0x4b0>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  80051d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800520:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  800523:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	c1 e0 02             	shl    $0x2,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 02             	shl    $0x2,%eax
  800530:	c1 e8 02             	shr    $0x2,%eax
  800533:	48                   	dec    %eax
  800534:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800537:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80053e:	eb 30                	jmp    800570 <_main+0x538>
		{
			if(intArr[i] != i)
  800540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800543:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054d:	01 d0                	add    %edx,%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800554:	74 17                	je     80056d <_main+0x535>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 b4 38 80 00       	push   $0x8038b4
  80055e:	68 84 00 00 00       	push   $0x84
  800563:	68 94 37 80 00       	push   $0x803794
  800568:	e8 2e 02 00 00       	call   80079b <_panic>

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80056d:	ff 45 f4             	incl   -0xc(%ebp)
  800570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800573:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800576:	7c c8                	jl     800540 <_main+0x508>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800578:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80057b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80057e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800581:	89 d0                	mov    %edx,%eax
  800583:	01 c0                	add    %eax,%eax
  800585:	01 d0                	add    %edx,%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	01 d0                	add    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	c1 e8 02             	shr    $0x2,%eax
  800595:	48                   	dec    %eax
  800596:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005a0:	eb 30                	jmp    8005d2 <_main+0x59a>
		{
			if(intArr[i] != i)
  8005a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005b6:	74 17                	je     8005cf <_main+0x597>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8005b8:	83 ec 04             	sub    $0x4,%esp
  8005bb:	68 b4 38 80 00       	push   $0x8038b4
  8005c0:	68 8e 00 00 00       	push   $0x8e
  8005c5:	68 94 37 80 00       	push   $0x803794
  8005ca:	e8 cc 01 00 00       	call   80079b <_panic>

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005cf:	ff 45 f4             	incl   -0xc(%ebp)
  8005d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8005d8:	7c c8                	jl     8005a2 <_main+0x56a>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8005da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8005e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	c1 e0 03             	shl    $0x3,%eax
  8005ed:	c1 e8 02             	shr    $0x2,%eax
  8005f0:	48                   	dec    %eax
  8005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005fb:	eb 30                	jmp    80062d <_main+0x5f5>
		{
			if(intArr[i] != i)
  8005fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800600:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800611:	74 17                	je     80062a <_main+0x5f2>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	68 b4 38 80 00       	push   $0x8038b4
  80061b:	68 98 00 00 00       	push   $0x98
  800620:	68 94 37 80 00       	push   $0x803794
  800625:	e8 71 01 00 00       	call   80079b <_panic>

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80062a:	ff 45 f4             	incl   -0xc(%ebp)
  80062d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800630:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800633:	7c c8                	jl     8005fd <_main+0x5c5>
				panic("Wrong re-allocation: stored values are wrongly changed!");

		}


		vcprintf("\b\b\b100%\n", NULL);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	6a 00                	push   $0x0
  80063a:	68 ec 38 80 00       	push   $0x8038ec
  80063f:	e8 a0 03 00 00       	call   8009e4 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [3] completed successfully.\n");
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	68 f8 38 80 00       	push   $0x8038f8
  80064f:	e8 fb 03 00 00       	call   800a4f <cprintf>
  800654:	83 c4 10             	add    $0x10,%esp

	return;
  800657:	90                   	nop
}
  800658:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80065b:	5b                   	pop    %ebx
  80065c:	5f                   	pop    %edi
  80065d:	5d                   	pop    %ebp
  80065e:	c3                   	ret    

0080065f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800665:	e8 7d 1a 00 00       	call   8020e7 <sys_getenvindex>
  80066a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80066d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	c1 e0 03             	shl    $0x3,%eax
  800675:	01 d0                	add    %edx,%eax
  800677:	01 c0                	add    %eax,%eax
  800679:	01 d0                	add    %edx,%eax
  80067b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800682:	01 d0                	add    %edx,%eax
  800684:	c1 e0 04             	shl    $0x4,%eax
  800687:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80068c:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800691:	a1 20 50 80 00       	mov    0x805020,%eax
  800696:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80069c:	84 c0                	test   %al,%al
  80069e:	74 0f                	je     8006af <libmain+0x50>
		binaryname = myEnv->prog_name;
  8006a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a5:	05 5c 05 00 00       	add    $0x55c,%eax
  8006aa:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006b3:	7e 0a                	jle    8006bf <libmain+0x60>
		binaryname = argv[0];
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	ff 75 0c             	pushl  0xc(%ebp)
  8006c5:	ff 75 08             	pushl  0x8(%ebp)
  8006c8:	e8 6b f9 ff ff       	call   800038 <_main>
  8006cd:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006d0:	e8 1f 18 00 00       	call   801ef4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	68 4c 39 80 00       	push   $0x80394c
  8006dd:	e8 6d 03 00 00       	call   800a4f <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8006ea:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006fb:	83 ec 04             	sub    $0x4,%esp
  8006fe:	52                   	push   %edx
  8006ff:	50                   	push   %eax
  800700:	68 74 39 80 00       	push   $0x803974
  800705:	e8 45 03 00 00       	call   800a4f <cprintf>
  80070a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80070d:	a1 20 50 80 00       	mov    0x805020,%eax
  800712:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800718:	a1 20 50 80 00       	mov    0x805020,%eax
  80071d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800723:	a1 20 50 80 00       	mov    0x805020,%eax
  800728:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	68 9c 39 80 00       	push   $0x80399c
  800736:	e8 14 03 00 00       	call   800a4f <cprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80073e:	a1 20 50 80 00       	mov    0x805020,%eax
  800743:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	50                   	push   %eax
  80074d:	68 f4 39 80 00       	push   $0x8039f4
  800752:	e8 f8 02 00 00       	call   800a4f <cprintf>
  800757:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80075a:	83 ec 0c             	sub    $0xc,%esp
  80075d:	68 4c 39 80 00       	push   $0x80394c
  800762:	e8 e8 02 00 00       	call   800a4f <cprintf>
  800767:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80076a:	e8 9f 17 00 00       	call   801f0e <sys_enable_interrupt>

	// exit gracefully
	exit();
  80076f:	e8 19 00 00 00       	call   80078d <exit>
}
  800774:	90                   	nop
  800775:	c9                   	leave  
  800776:	c3                   	ret    

00800777 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80077d:	83 ec 0c             	sub    $0xc,%esp
  800780:	6a 00                	push   $0x0
  800782:	e8 2c 19 00 00       	call   8020b3 <sys_destroy_env>
  800787:	83 c4 10             	add    $0x10,%esp
}
  80078a:	90                   	nop
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <exit>:

void
exit(void)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800793:	e8 81 19 00 00       	call   802119 <sys_exit_env>
}
  800798:	90                   	nop
  800799:	c9                   	leave  
  80079a:	c3                   	ret    

0080079b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8007a4:	83 c0 04             	add    $0x4,%eax
  8007a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007aa:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007af:	85 c0                	test   %eax,%eax
  8007b1:	74 16                	je     8007c9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007b3:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	50                   	push   %eax
  8007bc:	68 08 3a 80 00       	push   $0x803a08
  8007c1:	e8 89 02 00 00       	call   800a4f <cprintf>
  8007c6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007c9:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	ff 75 08             	pushl  0x8(%ebp)
  8007d4:	50                   	push   %eax
  8007d5:	68 0d 3a 80 00       	push   $0x803a0d
  8007da:	e8 70 02 00 00       	call   800a4f <cprintf>
  8007df:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007eb:	50                   	push   %eax
  8007ec:	e8 f3 01 00 00       	call   8009e4 <vcprintf>
  8007f1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	6a 00                	push   $0x0
  8007f9:	68 29 3a 80 00       	push   $0x803a29
  8007fe:	e8 e1 01 00 00       	call   8009e4 <vcprintf>
  800803:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800806:	e8 82 ff ff ff       	call   80078d <exit>

	// should not return here
	while (1) ;
  80080b:	eb fe                	jmp    80080b <_panic+0x70>

0080080d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800813:	a1 20 50 80 00       	mov    0x805020,%eax
  800818:	8b 50 74             	mov    0x74(%eax),%edx
  80081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 14                	je     800836 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 2c 3a 80 00       	push   $0x803a2c
  80082a:	6a 26                	push   $0x26
  80082c:	68 78 3a 80 00       	push   $0x803a78
  800831:	e8 65 ff ff ff       	call   80079b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80083d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800844:	e9 c2 00 00 00       	jmp    80090b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	01 d0                	add    %edx,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	85 c0                	test   %eax,%eax
  80085c:	75 08                	jne    800866 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80085e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800861:	e9 a2 00 00 00       	jmp    800908 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800866:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80086d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800874:	eb 69                	jmp    8008df <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800876:	a1 20 50 80 00       	mov    0x805020,%eax
  80087b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800881:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800884:	89 d0                	mov    %edx,%eax
  800886:	01 c0                	add    %eax,%eax
  800888:	01 d0                	add    %edx,%eax
  80088a:	c1 e0 03             	shl    $0x3,%eax
  80088d:	01 c8                	add    %ecx,%eax
  80088f:	8a 40 04             	mov    0x4(%eax),%al
  800892:	84 c0                	test   %al,%al
  800894:	75 46                	jne    8008dc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800896:	a1 20 50 80 00       	mov    0x805020,%eax
  80089b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a4:	89 d0                	mov    %edx,%eax
  8008a6:	01 c0                	add    %eax,%eax
  8008a8:	01 d0                	add    %edx,%eax
  8008aa:	c1 e0 03             	shl    $0x3,%eax
  8008ad:	01 c8                	add    %ecx,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008bc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	01 c8                	add    %ecx,%eax
  8008cd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	75 09                	jne    8008dc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008d3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008da:	eb 12                	jmp    8008ee <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dc:	ff 45 e8             	incl   -0x18(%ebp)
  8008df:	a1 20 50 80 00       	mov    0x805020,%eax
  8008e4:	8b 50 74             	mov    0x74(%eax),%edx
  8008e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008ea:	39 c2                	cmp    %eax,%edx
  8008ec:	77 88                	ja     800876 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008f2:	75 14                	jne    800908 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 84 3a 80 00       	push   $0x803a84
  8008fc:	6a 3a                	push   $0x3a
  8008fe:	68 78 3a 80 00       	push   $0x803a78
  800903:	e8 93 fe ff ff       	call   80079b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800908:	ff 45 f0             	incl   -0x10(%ebp)
  80090b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800911:	0f 8c 32 ff ff ff    	jl     800849 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800917:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80091e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800925:	eb 26                	jmp    80094d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800927:	a1 20 50 80 00       	mov    0x805020,%eax
  80092c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800932:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800935:	89 d0                	mov    %edx,%eax
  800937:	01 c0                	add    %eax,%eax
  800939:	01 d0                	add    %edx,%eax
  80093b:	c1 e0 03             	shl    $0x3,%eax
  80093e:	01 c8                	add    %ecx,%eax
  800940:	8a 40 04             	mov    0x4(%eax),%al
  800943:	3c 01                	cmp    $0x1,%al
  800945:	75 03                	jne    80094a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800947:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80094a:	ff 45 e0             	incl   -0x20(%ebp)
  80094d:	a1 20 50 80 00       	mov    0x805020,%eax
  800952:	8b 50 74             	mov    0x74(%eax),%edx
  800955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800958:	39 c2                	cmp    %eax,%edx
  80095a:	77 cb                	ja     800927 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80095c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800962:	74 14                	je     800978 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800964:	83 ec 04             	sub    $0x4,%esp
  800967:	68 d8 3a 80 00       	push   $0x803ad8
  80096c:	6a 44                	push   $0x44
  80096e:	68 78 3a 80 00       	push   $0x803a78
  800973:	e8 23 fe ff ff       	call   80079b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800978:	90                   	nop
  800979:	c9                   	leave  
  80097a:	c3                   	ret    

0080097b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	8d 48 01             	lea    0x1(%eax),%ecx
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	89 0a                	mov    %ecx,(%edx)
  80098e:	8b 55 08             	mov    0x8(%ebp),%edx
  800991:	88 d1                	mov    %dl,%cl
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80099a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009a4:	75 2c                	jne    8009d2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009a6:	a0 24 50 80 00       	mov    0x805024,%al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b1:	8b 12                	mov    (%edx),%edx
  8009b3:	89 d1                	mov    %edx,%ecx
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	83 c2 08             	add    $0x8,%edx
  8009bb:	83 ec 04             	sub    $0x4,%esp
  8009be:	50                   	push   %eax
  8009bf:	51                   	push   %ecx
  8009c0:	52                   	push   %edx
  8009c1:	e8 80 13 00 00       	call   801d46 <sys_cputs>
  8009c6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d5:	8b 40 04             	mov    0x4(%eax),%eax
  8009d8:	8d 50 01             	lea    0x1(%eax),%edx
  8009db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009de:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009e1:	90                   	nop
  8009e2:	c9                   	leave  
  8009e3:	c3                   	ret    

008009e4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009f4:	00 00 00 
	b.cnt = 0;
  8009f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009fe:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	ff 75 08             	pushl  0x8(%ebp)
  800a07:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a0d:	50                   	push   %eax
  800a0e:	68 7b 09 80 00       	push   $0x80097b
  800a13:	e8 11 02 00 00       	call   800c29 <vprintfmt>
  800a18:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a1b:	a0 24 50 80 00       	mov    0x805024,%al
  800a20:	0f b6 c0             	movzbl %al,%eax
  800a23:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a29:	83 ec 04             	sub    $0x4,%esp
  800a2c:	50                   	push   %eax
  800a2d:	52                   	push   %edx
  800a2e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a34:	83 c0 08             	add    $0x8,%eax
  800a37:	50                   	push   %eax
  800a38:	e8 09 13 00 00       	call   801d46 <sys_cputs>
  800a3d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a40:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a47:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <cprintf>:

int cprintf(const char *fmt, ...) {
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a55:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a5c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6b:	50                   	push   %eax
  800a6c:	e8 73 ff ff ff       	call   8009e4 <vcprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a82:	e8 6d 14 00 00       	call   801ef4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a87:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 f4             	pushl  -0xc(%ebp)
  800a96:	50                   	push   %eax
  800a97:	e8 48 ff ff ff       	call   8009e4 <vcprintf>
  800a9c:	83 c4 10             	add    $0x10,%esp
  800a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800aa2:	e8 67 14 00 00       	call   801f0e <sys_enable_interrupt>
	return cnt;
  800aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aaa:	c9                   	leave  
  800aab:	c3                   	ret    

00800aac <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	53                   	push   %ebx
  800ab0:	83 ec 14             	sub    $0x14,%esp
  800ab3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab9:	8b 45 14             	mov    0x14(%ebp),%eax
  800abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800abf:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aca:	77 55                	ja     800b21 <printnum+0x75>
  800acc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800acf:	72 05                	jb     800ad6 <printnum+0x2a>
  800ad1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ad4:	77 4b                	ja     800b21 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ad6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ad9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800adc:	8b 45 18             	mov    0x18(%ebp),%eax
  800adf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae4:	52                   	push   %edx
  800ae5:	50                   	push   %eax
  800ae6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae9:	ff 75 f0             	pushl  -0x10(%ebp)
  800aec:	e8 cf 29 00 00       	call   8034c0 <__udivdi3>
  800af1:	83 c4 10             	add    $0x10,%esp
  800af4:	83 ec 04             	sub    $0x4,%esp
  800af7:	ff 75 20             	pushl  0x20(%ebp)
  800afa:	53                   	push   %ebx
  800afb:	ff 75 18             	pushl  0x18(%ebp)
  800afe:	52                   	push   %edx
  800aff:	50                   	push   %eax
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	ff 75 08             	pushl  0x8(%ebp)
  800b06:	e8 a1 ff ff ff       	call   800aac <printnum>
  800b0b:	83 c4 20             	add    $0x20,%esp
  800b0e:	eb 1a                	jmp    800b2a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	ff 75 20             	pushl  0x20(%ebp)
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	ff d0                	call   *%eax
  800b1e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b21:	ff 4d 1c             	decl   0x1c(%ebp)
  800b24:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b28:	7f e6                	jg     800b10 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b2a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b38:	53                   	push   %ebx
  800b39:	51                   	push   %ecx
  800b3a:	52                   	push   %edx
  800b3b:	50                   	push   %eax
  800b3c:	e8 8f 2a 00 00       	call   8035d0 <__umoddi3>
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	05 54 3d 80 00       	add    $0x803d54,%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f be c0             	movsbl %al,%eax
  800b4e:	83 ec 08             	sub    $0x8,%esp
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	50                   	push   %eax
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
}
  800b5d:	90                   	nop
  800b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b66:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b6a:	7e 1c                	jle    800b88 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8b 00                	mov    (%eax),%eax
  800b71:	8d 50 08             	lea    0x8(%eax),%edx
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	89 10                	mov    %edx,(%eax)
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8b 00                	mov    (%eax),%eax
  800b7e:	83 e8 08             	sub    $0x8,%eax
  800b81:	8b 50 04             	mov    0x4(%eax),%edx
  800b84:	8b 00                	mov    (%eax),%eax
  800b86:	eb 40                	jmp    800bc8 <getuint+0x65>
	else if (lflag)
  800b88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b8c:	74 1e                	je     800bac <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8b 00                	mov    (%eax),%eax
  800b93:	8d 50 04             	lea    0x4(%eax),%edx
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	89 10                	mov    %edx,(%eax)
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	83 e8 04             	sub    $0x4,%eax
  800ba3:	8b 00                	mov    (%eax),%eax
  800ba5:	ba 00 00 00 00       	mov    $0x0,%edx
  800baa:	eb 1c                	jmp    800bc8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	8d 50 04             	lea    0x4(%eax),%edx
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	89 10                	mov    %edx,(%eax)
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 00                	mov    (%eax),%eax
  800bbe:	83 e8 04             	sub    $0x4,%eax
  800bc1:	8b 00                	mov    (%eax),%eax
  800bc3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bcd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bd1:	7e 1c                	jle    800bef <getint+0x25>
		return va_arg(*ap, long long);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8b 00                	mov    (%eax),%eax
  800bd8:	8d 50 08             	lea    0x8(%eax),%edx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	89 10                	mov    %edx,(%eax)
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	83 e8 08             	sub    $0x8,%eax
  800be8:	8b 50 04             	mov    0x4(%eax),%edx
  800beb:	8b 00                	mov    (%eax),%eax
  800bed:	eb 38                	jmp    800c27 <getint+0x5d>
	else if (lflag)
  800bef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf3:	74 1a                	je     800c0f <getint+0x45>
		return va_arg(*ap, long);
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	8b 00                	mov    (%eax),%eax
  800bfa:	8d 50 04             	lea    0x4(%eax),%edx
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	89 10                	mov    %edx,(%eax)
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	83 e8 04             	sub    $0x4,%eax
  800c0a:	8b 00                	mov    (%eax),%eax
  800c0c:	99                   	cltd   
  800c0d:	eb 18                	jmp    800c27 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	8d 50 04             	lea    0x4(%eax),%edx
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	89 10                	mov    %edx,(%eax)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8b 00                	mov    (%eax),%eax
  800c21:	83 e8 04             	sub    $0x4,%eax
  800c24:	8b 00                	mov    (%eax),%eax
  800c26:	99                   	cltd   
}
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	56                   	push   %esi
  800c2d:	53                   	push   %ebx
  800c2e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c31:	eb 17                	jmp    800c4a <vprintfmt+0x21>
			if (ch == '\0')
  800c33:	85 db                	test   %ebx,%ebx
  800c35:	0f 84 af 03 00 00    	je     800fea <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	53                   	push   %ebx
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 10             	mov    %edx,0x10(%ebp)
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	0f b6 d8             	movzbl %al,%ebx
  800c58:	83 fb 25             	cmp    $0x25,%ebx
  800c5b:	75 d6                	jne    800c33 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c5d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c61:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c68:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c6f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c76:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c80:	8d 50 01             	lea    0x1(%eax),%edx
  800c83:	89 55 10             	mov    %edx,0x10(%ebp)
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	0f b6 d8             	movzbl %al,%ebx
  800c8b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c8e:	83 f8 55             	cmp    $0x55,%eax
  800c91:	0f 87 2b 03 00 00    	ja     800fc2 <vprintfmt+0x399>
  800c97:	8b 04 85 78 3d 80 00 	mov    0x803d78(,%eax,4),%eax
  800c9e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ca0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ca4:	eb d7                	jmp    800c7d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ca6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800caa:	eb d1                	jmp    800c7d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cb6:	89 d0                	mov    %edx,%eax
  800cb8:	c1 e0 02             	shl    $0x2,%eax
  800cbb:	01 d0                	add    %edx,%eax
  800cbd:	01 c0                	add    %eax,%eax
  800cbf:	01 d8                	add    %ebx,%eax
  800cc1:	83 e8 30             	sub    $0x30,%eax
  800cc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ccf:	83 fb 2f             	cmp    $0x2f,%ebx
  800cd2:	7e 3e                	jle    800d12 <vprintfmt+0xe9>
  800cd4:	83 fb 39             	cmp    $0x39,%ebx
  800cd7:	7f 39                	jg     800d12 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cd9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cdc:	eb d5                	jmp    800cb3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cde:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce1:	83 c0 04             	add    $0x4,%eax
  800ce4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 e8 04             	sub    $0x4,%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cf2:	eb 1f                	jmp    800d13 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cf4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf8:	79 83                	jns    800c7d <vprintfmt+0x54>
				width = 0;
  800cfa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d01:	e9 77 ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d06:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d0d:	e9 6b ff ff ff       	jmp    800c7d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d12:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d17:	0f 89 60 ff ff ff    	jns    800c7d <vprintfmt+0x54>
				width = precision, precision = -1;
  800d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d23:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d2a:	e9 4e ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d2f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d32:	e9 46 ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d37:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3a:	83 c0 04             	add    $0x4,%eax
  800d3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 e8 04             	sub    $0x4,%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	50                   	push   %eax
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			break;
  800d57:	e9 89 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5f:	83 c0 04             	add    $0x4,%eax
  800d62:	89 45 14             	mov    %eax,0x14(%ebp)
  800d65:	8b 45 14             	mov    0x14(%ebp),%eax
  800d68:	83 e8 04             	sub    $0x4,%eax
  800d6b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d6d:	85 db                	test   %ebx,%ebx
  800d6f:	79 02                	jns    800d73 <vprintfmt+0x14a>
				err = -err;
  800d71:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d73:	83 fb 64             	cmp    $0x64,%ebx
  800d76:	7f 0b                	jg     800d83 <vprintfmt+0x15a>
  800d78:	8b 34 9d c0 3b 80 00 	mov    0x803bc0(,%ebx,4),%esi
  800d7f:	85 f6                	test   %esi,%esi
  800d81:	75 19                	jne    800d9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d83:	53                   	push   %ebx
  800d84:	68 65 3d 80 00       	push   $0x803d65
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	ff 75 08             	pushl  0x8(%ebp)
  800d8f:	e8 5e 02 00 00       	call   800ff2 <printfmt>
  800d94:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d97:	e9 49 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d9c:	56                   	push   %esi
  800d9d:	68 6e 3d 80 00       	push   $0x803d6e
  800da2:	ff 75 0c             	pushl  0xc(%ebp)
  800da5:	ff 75 08             	pushl  0x8(%ebp)
  800da8:	e8 45 02 00 00       	call   800ff2 <printfmt>
  800dad:	83 c4 10             	add    $0x10,%esp
			break;
  800db0:	e9 30 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800db5:	8b 45 14             	mov    0x14(%ebp),%eax
  800db8:	83 c0 04             	add    $0x4,%eax
  800dbb:	89 45 14             	mov    %eax,0x14(%ebp)
  800dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc1:	83 e8 04             	sub    $0x4,%eax
  800dc4:	8b 30                	mov    (%eax),%esi
  800dc6:	85 f6                	test   %esi,%esi
  800dc8:	75 05                	jne    800dcf <vprintfmt+0x1a6>
				p = "(null)";
  800dca:	be 71 3d 80 00       	mov    $0x803d71,%esi
			if (width > 0 && padc != '-')
  800dcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd3:	7e 6d                	jle    800e42 <vprintfmt+0x219>
  800dd5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dd9:	74 67                	je     800e42 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ddb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dde:	83 ec 08             	sub    $0x8,%esp
  800de1:	50                   	push   %eax
  800de2:	56                   	push   %esi
  800de3:	e8 0c 03 00 00       	call   8010f4 <strnlen>
  800de8:	83 c4 10             	add    $0x10,%esp
  800deb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dee:	eb 16                	jmp    800e06 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800df0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800df4:	83 ec 08             	sub    $0x8,%esp
  800df7:	ff 75 0c             	pushl  0xc(%ebp)
  800dfa:	50                   	push   %eax
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	ff d0                	call   *%eax
  800e00:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e03:	ff 4d e4             	decl   -0x1c(%ebp)
  800e06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e0a:	7f e4                	jg     800df0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e0c:	eb 34                	jmp    800e42 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e12:	74 1c                	je     800e30 <vprintfmt+0x207>
  800e14:	83 fb 1f             	cmp    $0x1f,%ebx
  800e17:	7e 05                	jle    800e1e <vprintfmt+0x1f5>
  800e19:	83 fb 7e             	cmp    $0x7e,%ebx
  800e1c:	7e 12                	jle    800e30 <vprintfmt+0x207>
					putch('?', putdat);
  800e1e:	83 ec 08             	sub    $0x8,%esp
  800e21:	ff 75 0c             	pushl  0xc(%ebp)
  800e24:	6a 3f                	push   $0x3f
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	ff d0                	call   *%eax
  800e2b:	83 c4 10             	add    $0x10,%esp
  800e2e:	eb 0f                	jmp    800e3f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	ff 75 0c             	pushl  0xc(%ebp)
  800e36:	53                   	push   %ebx
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	ff d0                	call   *%eax
  800e3c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e3f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e42:	89 f0                	mov    %esi,%eax
  800e44:	8d 70 01             	lea    0x1(%eax),%esi
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	0f be d8             	movsbl %al,%ebx
  800e4c:	85 db                	test   %ebx,%ebx
  800e4e:	74 24                	je     800e74 <vprintfmt+0x24b>
  800e50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e54:	78 b8                	js     800e0e <vprintfmt+0x1e5>
  800e56:	ff 4d e0             	decl   -0x20(%ebp)
  800e59:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e5d:	79 af                	jns    800e0e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e5f:	eb 13                	jmp    800e74 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e61:	83 ec 08             	sub    $0x8,%esp
  800e64:	ff 75 0c             	pushl  0xc(%ebp)
  800e67:	6a 20                	push   $0x20
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	ff d0                	call   *%eax
  800e6e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e71:	ff 4d e4             	decl   -0x1c(%ebp)
  800e74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e78:	7f e7                	jg     800e61 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e7a:	e9 66 01 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 e8             	pushl  -0x18(%ebp)
  800e85:	8d 45 14             	lea    0x14(%ebp),%eax
  800e88:	50                   	push   %eax
  800e89:	e8 3c fd ff ff       	call   800bca <getint>
  800e8e:	83 c4 10             	add    $0x10,%esp
  800e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9d:	85 d2                	test   %edx,%edx
  800e9f:	79 23                	jns    800ec4 <vprintfmt+0x29b>
				putch('-', putdat);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	6a 2d                	push   $0x2d
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	ff d0                	call   *%eax
  800eae:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb7:	f7 d8                	neg    %eax
  800eb9:	83 d2 00             	adc    $0x0,%edx
  800ebc:	f7 da                	neg    %edx
  800ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ec4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ecb:	e9 bc 00 00 00       	jmp    800f8c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ed6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed9:	50                   	push   %eax
  800eda:	e8 84 fc ff ff       	call   800b63 <getuint>
  800edf:	83 c4 10             	add    $0x10,%esp
  800ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ee8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eef:	e9 98 00 00 00       	jmp    800f8c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ef4:	83 ec 08             	sub    $0x8,%esp
  800ef7:	ff 75 0c             	pushl  0xc(%ebp)
  800efa:	6a 58                	push   $0x58
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	ff d0                	call   *%eax
  800f01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f04:	83 ec 08             	sub    $0x8,%esp
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	6a 58                	push   $0x58
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	ff d0                	call   *%eax
  800f11:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	ff 75 0c             	pushl  0xc(%ebp)
  800f1a:	6a 58                	push   $0x58
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	ff d0                	call   *%eax
  800f21:	83 c4 10             	add    $0x10,%esp
			break;
  800f24:	e9 bc 00 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f29:	83 ec 08             	sub    $0x8,%esp
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	6a 30                	push   $0x30
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	ff d0                	call   *%eax
  800f36:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 0c             	pushl  0xc(%ebp)
  800f3f:	6a 78                	push   $0x78
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	ff d0                	call   *%eax
  800f46:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f49:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4c:	83 c0 04             	add    $0x4,%eax
  800f4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f52:	8b 45 14             	mov    0x14(%ebp),%eax
  800f55:	83 e8 04             	sub    $0x4,%eax
  800f58:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f64:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f6b:	eb 1f                	jmp    800f8c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f6d:	83 ec 08             	sub    $0x8,%esp
  800f70:	ff 75 e8             	pushl  -0x18(%ebp)
  800f73:	8d 45 14             	lea    0x14(%ebp),%eax
  800f76:	50                   	push   %eax
  800f77:	e8 e7 fb ff ff       	call   800b63 <getuint>
  800f7c:	83 c4 10             	add    $0x10,%esp
  800f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f8c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f93:	83 ec 04             	sub    $0x4,%esp
  800f96:	52                   	push   %edx
  800f97:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f9a:	50                   	push   %eax
  800f9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f9e:	ff 75 f0             	pushl  -0x10(%ebp)
  800fa1:	ff 75 0c             	pushl  0xc(%ebp)
  800fa4:	ff 75 08             	pushl  0x8(%ebp)
  800fa7:	e8 00 fb ff ff       	call   800aac <printnum>
  800fac:	83 c4 20             	add    $0x20,%esp
			break;
  800faf:	eb 34                	jmp    800fe5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fb1:	83 ec 08             	sub    $0x8,%esp
  800fb4:	ff 75 0c             	pushl  0xc(%ebp)
  800fb7:	53                   	push   %ebx
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	ff d0                	call   *%eax
  800fbd:	83 c4 10             	add    $0x10,%esp
			break;
  800fc0:	eb 23                	jmp    800fe5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fc2:	83 ec 08             	sub    $0x8,%esp
  800fc5:	ff 75 0c             	pushl  0xc(%ebp)
  800fc8:	6a 25                	push   $0x25
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	ff d0                	call   *%eax
  800fcf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fd2:	ff 4d 10             	decl   0x10(%ebp)
  800fd5:	eb 03                	jmp    800fda <vprintfmt+0x3b1>
  800fd7:	ff 4d 10             	decl   0x10(%ebp)
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	48                   	dec    %eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	3c 25                	cmp    $0x25,%al
  800fe2:	75 f3                	jne    800fd7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fe4:	90                   	nop
		}
	}
  800fe5:	e9 47 fc ff ff       	jmp    800c31 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fea:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800feb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fee:	5b                   	pop    %ebx
  800fef:	5e                   	pop    %esi
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    

00800ff2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ff8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ffb:	83 c0 04             	add    $0x4,%eax
  800ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801001:	8b 45 10             	mov    0x10(%ebp),%eax
  801004:	ff 75 f4             	pushl  -0xc(%ebp)
  801007:	50                   	push   %eax
  801008:	ff 75 0c             	pushl  0xc(%ebp)
  80100b:	ff 75 08             	pushl  0x8(%ebp)
  80100e:	e8 16 fc ff ff       	call   800c29 <vprintfmt>
  801013:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801016:	90                   	nop
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	8b 40 08             	mov    0x8(%eax),%eax
  801022:	8d 50 01             	lea    0x1(%eax),%edx
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80102b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102e:	8b 10                	mov    (%eax),%edx
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8b 40 04             	mov    0x4(%eax),%eax
  801036:	39 c2                	cmp    %eax,%edx
  801038:	73 12                	jae    80104c <sprintputch+0x33>
		*b->buf++ = ch;
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	8b 00                	mov    (%eax),%eax
  80103f:	8d 48 01             	lea    0x1(%eax),%ecx
  801042:	8b 55 0c             	mov    0xc(%ebp),%edx
  801045:	89 0a                	mov    %ecx,(%edx)
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	88 10                	mov    %dl,(%eax)
}
  80104c:	90                   	nop
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	01 d0                	add    %edx,%eax
  801066:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801070:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801074:	74 06                	je     80107c <vsnprintf+0x2d>
  801076:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107a:	7f 07                	jg     801083 <vsnprintf+0x34>
		return -E_INVAL;
  80107c:	b8 03 00 00 00       	mov    $0x3,%eax
  801081:	eb 20                	jmp    8010a3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801083:	ff 75 14             	pushl  0x14(%ebp)
  801086:	ff 75 10             	pushl  0x10(%ebp)
  801089:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80108c:	50                   	push   %eax
  80108d:	68 19 10 80 00       	push   $0x801019
  801092:	e8 92 fb ff ff       	call   800c29 <vprintfmt>
  801097:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80109a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80109d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010ab:	8d 45 10             	lea    0x10(%ebp),%eax
  8010ae:	83 c0 04             	add    $0x4,%eax
  8010b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ba:	50                   	push   %eax
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	ff 75 08             	pushl  0x8(%ebp)
  8010c1:	e8 89 ff ff ff       	call   80104f <vsnprintf>
  8010c6:	83 c4 10             	add    $0x10,%esp
  8010c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010de:	eb 06                	jmp    8010e6 <strlen+0x15>
		n++;
  8010e0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e3:	ff 45 08             	incl   0x8(%ebp)
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	84 c0                	test   %al,%al
  8010ed:	75 f1                	jne    8010e0 <strlen+0xf>
		n++;
	return n;
  8010ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801101:	eb 09                	jmp    80110c <strnlen+0x18>
		n++;
  801103:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801106:	ff 45 08             	incl   0x8(%ebp)
  801109:	ff 4d 0c             	decl   0xc(%ebp)
  80110c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801110:	74 09                	je     80111b <strnlen+0x27>
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	84 c0                	test   %al,%al
  801119:	75 e8                	jne    801103 <strnlen+0xf>
		n++;
	return n;
  80111b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80112c:	90                   	nop
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8d 50 01             	lea    0x1(%eax),%edx
  801133:	89 55 08             	mov    %edx,0x8(%ebp)
  801136:	8b 55 0c             	mov    0xc(%ebp),%edx
  801139:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80113f:	8a 12                	mov    (%edx),%dl
  801141:	88 10                	mov    %dl,(%eax)
  801143:	8a 00                	mov    (%eax),%al
  801145:	84 c0                	test   %al,%al
  801147:	75 e4                	jne    80112d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80115a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801161:	eb 1f                	jmp    801182 <strncpy+0x34>
		*dst++ = *src;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8d 50 01             	lea    0x1(%eax),%edx
  801169:	89 55 08             	mov    %edx,0x8(%ebp)
  80116c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116f:	8a 12                	mov    (%edx),%dl
  801171:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	84 c0                	test   %al,%al
  80117a:	74 03                	je     80117f <strncpy+0x31>
			src++;
  80117c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80117f:	ff 45 fc             	incl   -0x4(%ebp)
  801182:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801185:	3b 45 10             	cmp    0x10(%ebp),%eax
  801188:	72 d9                	jb     801163 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80118a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80119b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119f:	74 30                	je     8011d1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011a1:	eb 16                	jmp    8011b9 <strlcpy+0x2a>
			*dst++ = *src++;
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8d 50 01             	lea    0x1(%eax),%edx
  8011a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011b5:	8a 12                	mov    (%edx),%dl
  8011b7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011b9:	ff 4d 10             	decl   0x10(%ebp)
  8011bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c0:	74 09                	je     8011cb <strlcpy+0x3c>
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	84 c0                	test   %al,%al
  8011c9:	75 d8                	jne    8011a3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d7:	29 c2                	sub    %eax,%edx
  8011d9:	89 d0                	mov    %edx,%eax
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011e0:	eb 06                	jmp    8011e8 <strcmp+0xb>
		p++, q++;
  8011e2:	ff 45 08             	incl   0x8(%ebp)
  8011e5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	84 c0                	test   %al,%al
  8011ef:	74 0e                	je     8011ff <strcmp+0x22>
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 10                	mov    (%eax),%dl
  8011f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	38 c2                	cmp    %al,%dl
  8011fd:	74 e3                	je     8011e2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f b6 d0             	movzbl %al,%edx
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	0f b6 c0             	movzbl %al,%eax
  80120f:	29 c2                	sub    %eax,%edx
  801211:	89 d0                	mov    %edx,%eax
}
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801218:	eb 09                	jmp    801223 <strncmp+0xe>
		n--, p++, q++;
  80121a:	ff 4d 10             	decl   0x10(%ebp)
  80121d:	ff 45 08             	incl   0x8(%ebp)
  801220:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801223:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801227:	74 17                	je     801240 <strncmp+0x2b>
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	84 c0                	test   %al,%al
  801230:	74 0e                	je     801240 <strncmp+0x2b>
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	8a 10                	mov    (%eax),%dl
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	38 c2                	cmp    %al,%dl
  80123e:	74 da                	je     80121a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801240:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801244:	75 07                	jne    80124d <strncmp+0x38>
		return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 14                	jmp    801261 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	0f b6 d0             	movzbl %al,%edx
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	0f b6 c0             	movzbl %al,%eax
  80125d:	29 c2                	sub    %eax,%edx
  80125f:	89 d0                	mov    %edx,%eax
}
  801261:	5d                   	pop    %ebp
  801262:	c3                   	ret    

00801263 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80126f:	eb 12                	jmp    801283 <strchr+0x20>
		if (*s == c)
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801279:	75 05                	jne    801280 <strchr+0x1d>
			return (char *) s;
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	eb 11                	jmp    801291 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801280:	ff 45 08             	incl   0x8(%ebp)
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	75 e5                	jne    801271 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    

00801293 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 04             	sub    $0x4,%esp
  801299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80129f:	eb 0d                	jmp    8012ae <strfind+0x1b>
		if (*s == c)
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012a9:	74 0e                	je     8012b9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012ab:	ff 45 08             	incl   0x8(%ebp)
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	84 c0                	test   %al,%al
  8012b5:	75 ea                	jne    8012a1 <strfind+0xe>
  8012b7:	eb 01                	jmp    8012ba <strfind+0x27>
		if (*s == c)
			break;
  8012b9:	90                   	nop
	return (char *) s;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012d1:	eb 0e                	jmp    8012e1 <memset+0x22>
		*p++ = c;
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	8d 50 01             	lea    0x1(%eax),%edx
  8012d9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012df:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8012e1:	ff 4d f8             	decl   -0x8(%ebp)
  8012e4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012e8:	79 e9                	jns    8012d3 <memset+0x14>
		*p++ = c;

	return v;
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801301:	eb 16                	jmp    801319 <memcpy+0x2a>
		*d++ = *s++;
  801303:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801306:	8d 50 01             	lea    0x1(%eax),%edx
  801309:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801312:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801315:	8a 12                	mov    (%edx),%dl
  801317:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131f:	89 55 10             	mov    %edx,0x10(%ebp)
  801322:	85 c0                	test   %eax,%eax
  801324:	75 dd                	jne    801303 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80133d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801340:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801343:	73 50                	jae    801395 <memmove+0x6a>
  801345:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801350:	76 43                	jbe    801395 <memmove+0x6a>
		s += n;
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80135e:	eb 10                	jmp    801370 <memmove+0x45>
			*--d = *--s;
  801360:	ff 4d f8             	decl   -0x8(%ebp)
  801363:	ff 4d fc             	decl   -0x4(%ebp)
  801366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801369:	8a 10                	mov    (%eax),%dl
  80136b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801370:	8b 45 10             	mov    0x10(%ebp),%eax
  801373:	8d 50 ff             	lea    -0x1(%eax),%edx
  801376:	89 55 10             	mov    %edx,0x10(%ebp)
  801379:	85 c0                	test   %eax,%eax
  80137b:	75 e3                	jne    801360 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80137d:	eb 23                	jmp    8013a2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	8d 50 01             	lea    0x1(%eax),%edx
  801385:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801388:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80138e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801391:	8a 12                	mov    (%edx),%dl
  801393:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801395:	8b 45 10             	mov    0x10(%ebp),%eax
  801398:	8d 50 ff             	lea    -0x1(%eax),%edx
  80139b:	89 55 10             	mov    %edx,0x10(%ebp)
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	75 dd                	jne    80137f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013b9:	eb 2a                	jmp    8013e5 <memcmp+0x3e>
		if (*s1 != *s2)
  8013bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013be:	8a 10                	mov    (%eax),%dl
  8013c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	38 c2                	cmp    %al,%dl
  8013c7:	74 16                	je     8013df <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	0f b6 d0             	movzbl %al,%edx
  8013d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f b6 c0             	movzbl %al,%eax
  8013d9:	29 c2                	sub    %eax,%edx
  8013db:	89 d0                	mov    %edx,%eax
  8013dd:	eb 18                	jmp    8013f7 <memcmp+0x50>
		s1++, s2++;
  8013df:	ff 45 fc             	incl   -0x4(%ebp)
  8013e2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	75 c9                	jne    8013bb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801402:	8b 45 10             	mov    0x10(%ebp),%eax
  801405:	01 d0                	add    %edx,%eax
  801407:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80140a:	eb 15                	jmp    801421 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	0f b6 d0             	movzbl %al,%edx
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	0f b6 c0             	movzbl %al,%eax
  80141a:	39 c2                	cmp    %eax,%edx
  80141c:	74 0d                	je     80142b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80141e:	ff 45 08             	incl   0x8(%ebp)
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801427:	72 e3                	jb     80140c <memfind+0x13>
  801429:	eb 01                	jmp    80142c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80142b:	90                   	nop
	return (void *) s;
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801437:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80143e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801445:	eb 03                	jmp    80144a <strtol+0x19>
		s++;
  801447:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	3c 20                	cmp    $0x20,%al
  801451:	74 f4                	je     801447 <strtol+0x16>
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	3c 09                	cmp    $0x9,%al
  80145a:	74 eb                	je     801447 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3c 2b                	cmp    $0x2b,%al
  801463:	75 05                	jne    80146a <strtol+0x39>
		s++;
  801465:	ff 45 08             	incl   0x8(%ebp)
  801468:	eb 13                	jmp    80147d <strtol+0x4c>
	else if (*s == '-')
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	3c 2d                	cmp    $0x2d,%al
  801471:	75 0a                	jne    80147d <strtol+0x4c>
		s++, neg = 1;
  801473:	ff 45 08             	incl   0x8(%ebp)
  801476:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80147d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801481:	74 06                	je     801489 <strtol+0x58>
  801483:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801487:	75 20                	jne    8014a9 <strtol+0x78>
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	3c 30                	cmp    $0x30,%al
  801490:	75 17                	jne    8014a9 <strtol+0x78>
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	40                   	inc    %eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	3c 78                	cmp    $0x78,%al
  80149a:	75 0d                	jne    8014a9 <strtol+0x78>
		s += 2, base = 16;
  80149c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014a0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014a7:	eb 28                	jmp    8014d1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ad:	75 15                	jne    8014c4 <strtol+0x93>
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	3c 30                	cmp    $0x30,%al
  8014b6:	75 0c                	jne    8014c4 <strtol+0x93>
		s++, base = 8;
  8014b8:	ff 45 08             	incl   0x8(%ebp)
  8014bb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014c2:	eb 0d                	jmp    8014d1 <strtol+0xa0>
	else if (base == 0)
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	75 07                	jne    8014d1 <strtol+0xa0>
		base = 10;
  8014ca:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	3c 2f                	cmp    $0x2f,%al
  8014d8:	7e 19                	jle    8014f3 <strtol+0xc2>
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8a 00                	mov    (%eax),%al
  8014df:	3c 39                	cmp    $0x39,%al
  8014e1:	7f 10                	jg     8014f3 <strtol+0xc2>
			dig = *s - '0';
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	0f be c0             	movsbl %al,%eax
  8014eb:	83 e8 30             	sub    $0x30,%eax
  8014ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014f1:	eb 42                	jmp    801535 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	3c 60                	cmp    $0x60,%al
  8014fa:	7e 19                	jle    801515 <strtol+0xe4>
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	3c 7a                	cmp    $0x7a,%al
  801503:	7f 10                	jg     801515 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	8a 00                	mov    (%eax),%al
  80150a:	0f be c0             	movsbl %al,%eax
  80150d:	83 e8 57             	sub    $0x57,%eax
  801510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801513:	eb 20                	jmp    801535 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8a 00                	mov    (%eax),%al
  80151a:	3c 40                	cmp    $0x40,%al
  80151c:	7e 39                	jle    801557 <strtol+0x126>
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	3c 5a                	cmp    $0x5a,%al
  801525:	7f 30                	jg     801557 <strtol+0x126>
			dig = *s - 'A' + 10;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8a 00                	mov    (%eax),%al
  80152c:	0f be c0             	movsbl %al,%eax
  80152f:	83 e8 37             	sub    $0x37,%eax
  801532:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801538:	3b 45 10             	cmp    0x10(%ebp),%eax
  80153b:	7d 19                	jge    801556 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80153d:	ff 45 08             	incl   0x8(%ebp)
  801540:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801543:	0f af 45 10          	imul   0x10(%ebp),%eax
  801547:	89 c2                	mov    %eax,%edx
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154c:	01 d0                	add    %edx,%eax
  80154e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801551:	e9 7b ff ff ff       	jmp    8014d1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801556:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801557:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80155b:	74 08                	je     801565 <strtol+0x134>
		*endptr = (char *) s;
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	8b 55 08             	mov    0x8(%ebp),%edx
  801563:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801565:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801569:	74 07                	je     801572 <strtol+0x141>
  80156b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156e:	f7 d8                	neg    %eax
  801570:	eb 03                	jmp    801575 <strtol+0x144>
  801572:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <ltostr>:

void
ltostr(long value, char *str)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80157d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801584:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80158b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80158f:	79 13                	jns    8015a4 <ltostr+0x2d>
	{
		neg = 1;
  801591:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80159e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015a1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015ac:	99                   	cltd   
  8015ad:	f7 f9                	idiv   %ecx
  8015af:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b5:	8d 50 01             	lea    0x1(%eax),%edx
  8015b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015bb:	89 c2                	mov    %eax,%edx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	01 d0                	add    %edx,%eax
  8015c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015c5:	83 c2 30             	add    $0x30,%edx
  8015c8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015cd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015d2:	f7 e9                	imul   %ecx
  8015d4:	c1 fa 02             	sar    $0x2,%edx
  8015d7:	89 c8                	mov    %ecx,%eax
  8015d9:	c1 f8 1f             	sar    $0x1f,%eax
  8015dc:	29 c2                	sub    %eax,%edx
  8015de:	89 d0                	mov    %edx,%eax
  8015e0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015eb:	f7 e9                	imul   %ecx
  8015ed:	c1 fa 02             	sar    $0x2,%edx
  8015f0:	89 c8                	mov    %ecx,%eax
  8015f2:	c1 f8 1f             	sar    $0x1f,%eax
  8015f5:	29 c2                	sub    %eax,%edx
  8015f7:	89 d0                	mov    %edx,%eax
  8015f9:	c1 e0 02             	shl    $0x2,%eax
  8015fc:	01 d0                	add    %edx,%eax
  8015fe:	01 c0                	add    %eax,%eax
  801600:	29 c1                	sub    %eax,%ecx
  801602:	89 ca                	mov    %ecx,%edx
  801604:	85 d2                	test   %edx,%edx
  801606:	75 9c                	jne    8015a4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801608:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80160f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801612:	48                   	dec    %eax
  801613:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801616:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80161a:	74 3d                	je     801659 <ltostr+0xe2>
		start = 1 ;
  80161c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801623:	eb 34                	jmp    801659 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	01 d0                	add    %edx,%eax
  80162d:	8a 00                	mov    (%eax),%al
  80162f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801632:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801635:	8b 45 0c             	mov    0xc(%ebp),%eax
  801638:	01 c2                	add    %eax,%edx
  80163a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801640:	01 c8                	add    %ecx,%eax
  801642:	8a 00                	mov    (%eax),%al
  801644:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801646:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 c2                	add    %eax,%edx
  80164e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801651:	88 02                	mov    %al,(%edx)
		start++ ;
  801653:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801656:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165f:	7c c4                	jl     801625 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801661:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801664:	8b 45 0c             	mov    0xc(%ebp),%eax
  801667:	01 d0                	add    %edx,%eax
  801669:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80166c:	90                   	nop
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 54 fa ff ff       	call   8010d1 <strlen>
  80167d:	83 c4 04             	add    $0x4,%esp
  801680:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801683:	ff 75 0c             	pushl  0xc(%ebp)
  801686:	e8 46 fa ff ff       	call   8010d1 <strlen>
  80168b:	83 c4 04             	add    $0x4,%esp
  80168e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801691:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801698:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80169f:	eb 17                	jmp    8016b8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a7:	01 c2                	add    %eax,%edx
  8016a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	01 c8                	add    %ecx,%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016b5:	ff 45 fc             	incl   -0x4(%ebp)
  8016b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016be:	7c e1                	jl     8016a1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ce:	eb 1f                	jmp    8016ef <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d3:	8d 50 01             	lea    0x1(%eax),%edx
  8016d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016d9:	89 c2                	mov    %eax,%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 c2                	add    %eax,%edx
  8016e0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e6:	01 c8                	add    %ecx,%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016ec:	ff 45 f8             	incl   -0x8(%ebp)
  8016ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016f5:	7c d9                	jl     8016d0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fd:	01 d0                	add    %edx,%eax
  8016ff:	c6 00 00             	movb   $0x0,(%eax)
}
  801702:	90                   	nop
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801708:	8b 45 14             	mov    0x14(%ebp),%eax
  80170b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801711:	8b 45 14             	mov    0x14(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171d:	8b 45 10             	mov    0x10(%ebp),%eax
  801720:	01 d0                	add    %edx,%eax
  801722:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801728:	eb 0c                	jmp    801736 <strsplit+0x31>
			*string++ = 0;
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8d 50 01             	lea    0x1(%eax),%edx
  801730:	89 55 08             	mov    %edx,0x8(%ebp)
  801733:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	8a 00                	mov    (%eax),%al
  80173b:	84 c0                	test   %al,%al
  80173d:	74 18                	je     801757 <strsplit+0x52>
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8a 00                	mov    (%eax),%al
  801744:	0f be c0             	movsbl %al,%eax
  801747:	50                   	push   %eax
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	e8 13 fb ff ff       	call   801263 <strchr>
  801750:	83 c4 08             	add    $0x8,%esp
  801753:	85 c0                	test   %eax,%eax
  801755:	75 d3                	jne    80172a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	74 5a                	je     8017ba <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801760:	8b 45 14             	mov    0x14(%ebp),%eax
  801763:	8b 00                	mov    (%eax),%eax
  801765:	83 f8 0f             	cmp    $0xf,%eax
  801768:	75 07                	jne    801771 <strsplit+0x6c>
		{
			return 0;
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
  80176f:	eb 66                	jmp    8017d7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801771:	8b 45 14             	mov    0x14(%ebp),%eax
  801774:	8b 00                	mov    (%eax),%eax
  801776:	8d 48 01             	lea    0x1(%eax),%ecx
  801779:	8b 55 14             	mov    0x14(%ebp),%edx
  80177c:	89 0a                	mov    %ecx,(%edx)
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 c2                	add    %eax,%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80178f:	eb 03                	jmp    801794 <strsplit+0x8f>
			string++;
  801791:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	84 c0                	test   %al,%al
  80179b:	74 8b                	je     801728 <strsplit+0x23>
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	8a 00                	mov    (%eax),%al
  8017a2:	0f be c0             	movsbl %al,%eax
  8017a5:	50                   	push   %eax
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	e8 b5 fa ff ff       	call   801263 <strchr>
  8017ae:	83 c4 08             	add    $0x8,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	74 dc                	je     801791 <strsplit+0x8c>
			string++;
	}
  8017b5:	e9 6e ff ff ff       	jmp    801728 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017ba:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017be:	8b 00                	mov    (%eax),%eax
  8017c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017d2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8017df:	a1 04 50 80 00       	mov    0x805004,%eax
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	74 1f                	je     801807 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8017e8:	e8 1d 00 00 00       	call   80180a <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	68 d0 3e 80 00       	push   $0x803ed0
  8017f5:	e8 55 f2 ff ff       	call   800a4f <cprintf>
  8017fa:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8017fd:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801804:	00 00 00 
	}
}
  801807:	90                   	nop
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801810:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801817:	00 00 00 
  80181a:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801821:	00 00 00 
  801824:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80182b:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  80182e:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801835:	00 00 00 
  801838:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80183f:	00 00 00 
  801842:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801849:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  80184c:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801856:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80185b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801860:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801865:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80186c:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80186f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801879:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  80187e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801881:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801884:	ba 00 00 00 00       	mov    $0x0,%edx
  801889:	f7 75 f0             	divl   -0x10(%ebp)
  80188c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80188f:	29 d0                	sub    %edx,%eax
  801891:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801894:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80189b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80189e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018a3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018a8:	83 ec 04             	sub    $0x4,%esp
  8018ab:	6a 06                	push   $0x6
  8018ad:	ff 75 e8             	pushl  -0x18(%ebp)
  8018b0:	50                   	push   %eax
  8018b1:	e8 d4 05 00 00       	call   801e8a <sys_allocate_chunk>
  8018b6:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018b9:	a1 20 51 80 00       	mov    0x805120,%eax
  8018be:	83 ec 0c             	sub    $0xc,%esp
  8018c1:	50                   	push   %eax
  8018c2:	e8 49 0c 00 00       	call   802510 <initialize_MemBlocksList>
  8018c7:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8018ca:	a1 48 51 80 00       	mov    0x805148,%eax
  8018cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8018d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018d6:	75 14                	jne    8018ec <initialize_dyn_block_system+0xe2>
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	68 f5 3e 80 00       	push   $0x803ef5
  8018e0:	6a 39                	push   $0x39
  8018e2:	68 13 3f 80 00       	push   $0x803f13
  8018e7:	e8 af ee ff ff       	call   80079b <_panic>
  8018ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ef:	8b 00                	mov    (%eax),%eax
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	74 10                	je     801905 <initialize_dyn_block_system+0xfb>
  8018f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f8:	8b 00                	mov    (%eax),%eax
  8018fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018fd:	8b 52 04             	mov    0x4(%edx),%edx
  801900:	89 50 04             	mov    %edx,0x4(%eax)
  801903:	eb 0b                	jmp    801910 <initialize_dyn_block_system+0x106>
  801905:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801908:	8b 40 04             	mov    0x4(%eax),%eax
  80190b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801910:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801913:	8b 40 04             	mov    0x4(%eax),%eax
  801916:	85 c0                	test   %eax,%eax
  801918:	74 0f                	je     801929 <initialize_dyn_block_system+0x11f>
  80191a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191d:	8b 40 04             	mov    0x4(%eax),%eax
  801920:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801923:	8b 12                	mov    (%edx),%edx
  801925:	89 10                	mov    %edx,(%eax)
  801927:	eb 0a                	jmp    801933 <initialize_dyn_block_system+0x129>
  801929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80192c:	8b 00                	mov    (%eax),%eax
  80192e:	a3 48 51 80 00       	mov    %eax,0x805148
  801933:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801936:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80193c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80193f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801946:	a1 54 51 80 00       	mov    0x805154,%eax
  80194b:	48                   	dec    %eax
  80194c:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801954:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80195b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80195e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801965:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801969:	75 14                	jne    80197f <initialize_dyn_block_system+0x175>
  80196b:	83 ec 04             	sub    $0x4,%esp
  80196e:	68 20 3f 80 00       	push   $0x803f20
  801973:	6a 3f                	push   $0x3f
  801975:	68 13 3f 80 00       	push   $0x803f13
  80197a:	e8 1c ee ff ff       	call   80079b <_panic>
  80197f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801985:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801988:	89 10                	mov    %edx,(%eax)
  80198a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80198d:	8b 00                	mov    (%eax),%eax
  80198f:	85 c0                	test   %eax,%eax
  801991:	74 0d                	je     8019a0 <initialize_dyn_block_system+0x196>
  801993:	a1 38 51 80 00       	mov    0x805138,%eax
  801998:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80199b:	89 50 04             	mov    %edx,0x4(%eax)
  80199e:	eb 08                	jmp    8019a8 <initialize_dyn_block_system+0x19e>
  8019a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8019a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ab:	a3 38 51 80 00       	mov    %eax,0x805138
  8019b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8019ba:	a1 44 51 80 00       	mov    0x805144,%eax
  8019bf:	40                   	inc    %eax
  8019c0:	a3 44 51 80 00       	mov    %eax,0x805144

}
  8019c5:	90                   	nop
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019ce:	e8 06 fe ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  8019d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019d7:	75 07                	jne    8019e0 <malloc+0x18>
  8019d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019de:	eb 7d                	jmp    801a5d <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8019e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8019e7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f4:	01 d0                	add    %edx,%eax
  8019f6:	48                   	dec    %eax
  8019f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801a02:	f7 75 f0             	divl   -0x10(%ebp)
  801a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a08:	29 d0                	sub    %edx,%eax
  801a0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801a0d:	e8 46 08 00 00       	call   802258 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a12:	83 f8 01             	cmp    $0x1,%eax
  801a15:	75 07                	jne    801a1e <malloc+0x56>
  801a17:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801a1e:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801a22:	75 34                	jne    801a58 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801a24:	83 ec 0c             	sub    $0xc,%esp
  801a27:	ff 75 e8             	pushl  -0x18(%ebp)
  801a2a:	e8 73 0e 00 00       	call   8028a2 <alloc_block_FF>
  801a2f:	83 c4 10             	add    $0x10,%esp
  801a32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801a35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a39:	74 16                	je     801a51 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801a3b:	83 ec 0c             	sub    $0xc,%esp
  801a3e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a41:	e8 ff 0b 00 00       	call   802645 <insert_sorted_allocList>
  801a46:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801a49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a4c:	8b 40 08             	mov    0x8(%eax),%eax
  801a4f:	eb 0c                	jmp    801a5d <malloc+0x95>
	             }
	             else
	             	return NULL;
  801a51:	b8 00 00 00 00       	mov    $0x0,%eax
  801a56:	eb 05                	jmp    801a5d <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801a58:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a74:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a79:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801a7c:	83 ec 08             	sub    $0x8,%esp
  801a7f:	ff 75 f4             	pushl  -0xc(%ebp)
  801a82:	68 40 50 80 00       	push   $0x805040
  801a87:	e8 61 0b 00 00       	call   8025ed <find_block>
  801a8c:	83 c4 10             	add    $0x10,%esp
  801a8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801a92:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a96:	0f 84 a5 00 00 00    	je     801b41 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801a9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa2:	83 ec 08             	sub    $0x8,%esp
  801aa5:	50                   	push   %eax
  801aa6:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa9:	e8 a4 03 00 00       	call   801e52 <sys_free_user_mem>
  801aae:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801ab1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ab5:	75 17                	jne    801ace <free+0x6f>
  801ab7:	83 ec 04             	sub    $0x4,%esp
  801aba:	68 f5 3e 80 00       	push   $0x803ef5
  801abf:	68 87 00 00 00       	push   $0x87
  801ac4:	68 13 3f 80 00       	push   $0x803f13
  801ac9:	e8 cd ec ff ff       	call   80079b <_panic>
  801ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ad1:	8b 00                	mov    (%eax),%eax
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	74 10                	je     801ae7 <free+0x88>
  801ad7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ada:	8b 00                	mov    (%eax),%eax
  801adc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801adf:	8b 52 04             	mov    0x4(%edx),%edx
  801ae2:	89 50 04             	mov    %edx,0x4(%eax)
  801ae5:	eb 0b                	jmp    801af2 <free+0x93>
  801ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aea:	8b 40 04             	mov    0x4(%eax),%eax
  801aed:	a3 44 50 80 00       	mov    %eax,0x805044
  801af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af5:	8b 40 04             	mov    0x4(%eax),%eax
  801af8:	85 c0                	test   %eax,%eax
  801afa:	74 0f                	je     801b0b <free+0xac>
  801afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aff:	8b 40 04             	mov    0x4(%eax),%eax
  801b02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b05:	8b 12                	mov    (%edx),%edx
  801b07:	89 10                	mov    %edx,(%eax)
  801b09:	eb 0a                	jmp    801b15 <free+0xb6>
  801b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b0e:	8b 00                	mov    (%eax),%eax
  801b10:	a3 40 50 80 00       	mov    %eax,0x805040
  801b15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b28:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801b2d:	48                   	dec    %eax
  801b2e:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801b33:	83 ec 0c             	sub    $0xc,%esp
  801b36:	ff 75 ec             	pushl  -0x14(%ebp)
  801b39:	e8 37 12 00 00       	call   802d75 <insert_sorted_with_merge_freeList>
  801b3e:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801b41:	90                   	nop
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	83 ec 38             	sub    $0x38,%esp
  801b4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b50:	e8 84 fc ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b59:	75 07                	jne    801b62 <smalloc+0x1e>
  801b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b60:	eb 7e                	jmp    801be0 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801b62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801b69:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b76:	01 d0                	add    %edx,%eax
  801b78:	48                   	dec    %eax
  801b79:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b84:	f7 75 f0             	divl   -0x10(%ebp)
  801b87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b8a:	29 d0                	sub    %edx,%eax
  801b8c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801b8f:	e8 c4 06 00 00       	call   802258 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b94:	83 f8 01             	cmp    $0x1,%eax
  801b97:	75 42                	jne    801bdb <smalloc+0x97>

		  va = malloc(newsize) ;
  801b99:	83 ec 0c             	sub    $0xc,%esp
  801b9c:	ff 75 e8             	pushl  -0x18(%ebp)
  801b9f:	e8 24 fe ff ff       	call   8019c8 <malloc>
  801ba4:	83 c4 10             	add    $0x10,%esp
  801ba7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801baa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bae:	74 24                	je     801bd4 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801bb0:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801bb4:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bb7:	50                   	push   %eax
  801bb8:	ff 75 e8             	pushl  -0x18(%ebp)
  801bbb:	ff 75 08             	pushl  0x8(%ebp)
  801bbe:	e8 1a 04 00 00       	call   801fdd <sys_createSharedObject>
  801bc3:	83 c4 10             	add    $0x10,%esp
  801bc6:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801bc9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801bcd:	78 0c                	js     801bdb <smalloc+0x97>
					  return va ;
  801bcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bd2:	eb 0c                	jmp    801be0 <smalloc+0x9c>
				 }
				 else
					return NULL;
  801bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd9:	eb 05                	jmp    801be0 <smalloc+0x9c>
	  }
		  return NULL ;
  801bdb:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801be8:	e8 ec fb ff ff       	call   8017d9 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801bed:	83 ec 08             	sub    $0x8,%esp
  801bf0:	ff 75 0c             	pushl  0xc(%ebp)
  801bf3:	ff 75 08             	pushl  0x8(%ebp)
  801bf6:	e8 0c 04 00 00       	call   802007 <sys_getSizeOfSharedObject>
  801bfb:	83 c4 10             	add    $0x10,%esp
  801bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801c01:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801c05:	75 07                	jne    801c0e <sget+0x2c>
  801c07:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0c:	eb 75                	jmp    801c83 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801c0e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1b:	01 d0                	add    %edx,%eax
  801c1d:	48                   	dec    %eax
  801c1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c24:	ba 00 00 00 00       	mov    $0x0,%edx
  801c29:	f7 75 f0             	divl   -0x10(%ebp)
  801c2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c2f:	29 d0                	sub    %edx,%eax
  801c31:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801c34:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801c3b:	e8 18 06 00 00       	call   802258 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c40:	83 f8 01             	cmp    $0x1,%eax
  801c43:	75 39                	jne    801c7e <sget+0x9c>

		  va = malloc(newsize) ;
  801c45:	83 ec 0c             	sub    $0xc,%esp
  801c48:	ff 75 e8             	pushl  -0x18(%ebp)
  801c4b:	e8 78 fd ff ff       	call   8019c8 <malloc>
  801c50:	83 c4 10             	add    $0x10,%esp
  801c53:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801c56:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c5a:	74 22                	je     801c7e <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	ff 75 e0             	pushl  -0x20(%ebp)
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	ff 75 08             	pushl  0x8(%ebp)
  801c68:	e8 b7 03 00 00       	call   802024 <sys_getSharedObject>
  801c6d:	83 c4 10             	add    $0x10,%esp
  801c70:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801c73:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c77:	78 05                	js     801c7e <sget+0x9c>
					  return va;
  801c79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c7c:	eb 05                	jmp    801c83 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801c7e:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c8b:	e8 49 fb ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c90:	83 ec 04             	sub    $0x4,%esp
  801c93:	68 44 3f 80 00       	push   $0x803f44
  801c98:	68 1e 01 00 00       	push   $0x11e
  801c9d:	68 13 3f 80 00       	push   $0x803f13
  801ca2:	e8 f4 ea ff ff       	call   80079b <_panic>

00801ca7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801cad:	83 ec 04             	sub    $0x4,%esp
  801cb0:	68 6c 3f 80 00       	push   $0x803f6c
  801cb5:	68 32 01 00 00       	push   $0x132
  801cba:	68 13 3f 80 00       	push   $0x803f13
  801cbf:	e8 d7 ea ff ff       	call   80079b <_panic>

00801cc4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cca:	83 ec 04             	sub    $0x4,%esp
  801ccd:	68 90 3f 80 00       	push   $0x803f90
  801cd2:	68 3d 01 00 00       	push   $0x13d
  801cd7:	68 13 3f 80 00       	push   $0x803f13
  801cdc:	e8 ba ea ff ff       	call   80079b <_panic>

00801ce1 <shrink>:

}
void shrink(uint32 newSize)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ce7:	83 ec 04             	sub    $0x4,%esp
  801cea:	68 90 3f 80 00       	push   $0x803f90
  801cef:	68 42 01 00 00       	push   $0x142
  801cf4:	68 13 3f 80 00       	push   $0x803f13
  801cf9:	e8 9d ea ff ff       	call   80079b <_panic>

00801cfe <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d04:	83 ec 04             	sub    $0x4,%esp
  801d07:	68 90 3f 80 00       	push   $0x803f90
  801d0c:	68 47 01 00 00       	push   $0x147
  801d11:	68 13 3f 80 00       	push   $0x803f13
  801d16:	e8 80 ea ff ff       	call   80079b <_panic>

00801d1b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	57                   	push   %edi
  801d1f:	56                   	push   %esi
  801d20:	53                   	push   %ebx
  801d21:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d24:	8b 45 08             	mov    0x8(%ebp),%eax
  801d27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d2d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d30:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d33:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d36:	cd 30                	int    $0x30
  801d38:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d3e:	83 c4 10             	add    $0x10,%esp
  801d41:	5b                   	pop    %ebx
  801d42:	5e                   	pop    %esi
  801d43:	5f                   	pop    %edi
  801d44:	5d                   	pop    %ebp
  801d45:	c3                   	ret    

00801d46 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 04             	sub    $0x4,%esp
  801d4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d52:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	52                   	push   %edx
  801d5e:	ff 75 0c             	pushl  0xc(%ebp)
  801d61:	50                   	push   %eax
  801d62:	6a 00                	push   $0x0
  801d64:	e8 b2 ff ff ff       	call   801d1b <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
}
  801d6c:	90                   	nop
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sys_cgetc>:

int
sys_cgetc(void)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 01                	push   $0x1
  801d7e:	e8 98 ff ff ff       	call   801d1b <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	52                   	push   %edx
  801d98:	50                   	push   %eax
  801d99:	6a 05                	push   $0x5
  801d9b:	e8 7b ff ff ff       	call   801d1b <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	56                   	push   %esi
  801da9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801daa:	8b 75 18             	mov    0x18(%ebp),%esi
  801dad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801db0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	56                   	push   %esi
  801dba:	53                   	push   %ebx
  801dbb:	51                   	push   %ecx
  801dbc:	52                   	push   %edx
  801dbd:	50                   	push   %eax
  801dbe:	6a 06                	push   $0x6
  801dc0:	e8 56 ff ff ff       	call   801d1b <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
}
  801dc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dcb:	5b                   	pop    %ebx
  801dcc:	5e                   	pop    %esi
  801dcd:	5d                   	pop    %ebp
  801dce:	c3                   	ret    

00801dcf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	52                   	push   %edx
  801ddf:	50                   	push   %eax
  801de0:	6a 07                	push   $0x7
  801de2:	e8 34 ff ff ff       	call   801d1b <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	ff 75 0c             	pushl  0xc(%ebp)
  801df8:	ff 75 08             	pushl  0x8(%ebp)
  801dfb:	6a 08                	push   $0x8
  801dfd:	e8 19 ff ff ff       	call   801d1b <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 09                	push   $0x9
  801e16:	e8 00 ff ff ff       	call   801d1b <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 0a                	push   $0xa
  801e2f:	e8 e7 fe ff ff       	call   801d1b <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 0b                	push   $0xb
  801e48:	e8 ce fe ff ff       	call   801d1b <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	ff 75 0c             	pushl  0xc(%ebp)
  801e5e:	ff 75 08             	pushl  0x8(%ebp)
  801e61:	6a 0f                	push   $0xf
  801e63:	e8 b3 fe ff ff       	call   801d1b <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
	return;
  801e6b:	90                   	nop
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	ff 75 0c             	pushl  0xc(%ebp)
  801e7a:	ff 75 08             	pushl  0x8(%ebp)
  801e7d:	6a 10                	push   $0x10
  801e7f:	e8 97 fe ff ff       	call   801d1b <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
	return ;
  801e87:	90                   	nop
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	ff 75 10             	pushl  0x10(%ebp)
  801e94:	ff 75 0c             	pushl  0xc(%ebp)
  801e97:	ff 75 08             	pushl  0x8(%ebp)
  801e9a:	6a 11                	push   $0x11
  801e9c:	e8 7a fe ff ff       	call   801d1b <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea4:	90                   	nop
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 0c                	push   $0xc
  801eb6:	e8 60 fe ff ff       	call   801d1b <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	ff 75 08             	pushl  0x8(%ebp)
  801ece:	6a 0d                	push   $0xd
  801ed0:	e8 46 fe ff ff       	call   801d1b <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <sys_scarce_memory>:

void sys_scarce_memory()
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 0e                	push   $0xe
  801ee9:	e8 2d fe ff ff       	call   801d1b <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
}
  801ef1:	90                   	nop
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 13                	push   $0x13
  801f03:	e8 13 fe ff ff       	call   801d1b <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
}
  801f0b:	90                   	nop
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 14                	push   $0x14
  801f1d:	e8 f9 fd ff ff       	call   801d1b <syscall>
  801f22:	83 c4 18             	add    $0x18,%esp
}
  801f25:	90                   	nop
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	83 ec 04             	sub    $0x4,%esp
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f34:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	50                   	push   %eax
  801f41:	6a 15                	push   $0x15
  801f43:	e8 d3 fd ff ff       	call   801d1b <syscall>
  801f48:	83 c4 18             	add    $0x18,%esp
}
  801f4b:	90                   	nop
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 16                	push   $0x16
  801f5d:	e8 b9 fd ff ff       	call   801d1b <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
}
  801f65:	90                   	nop
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	ff 75 0c             	pushl  0xc(%ebp)
  801f77:	50                   	push   %eax
  801f78:	6a 17                	push   $0x17
  801f7a:	e8 9c fd ff ff       	call   801d1b <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	52                   	push   %edx
  801f94:	50                   	push   %eax
  801f95:	6a 1a                	push   $0x1a
  801f97:	e8 7f fd ff ff       	call   801d1b <syscall>
  801f9c:	83 c4 18             	add    $0x18,%esp
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	52                   	push   %edx
  801fb1:	50                   	push   %eax
  801fb2:	6a 18                	push   $0x18
  801fb4:	e8 62 fd ff ff       	call   801d1b <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
}
  801fbc:	90                   	nop
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	52                   	push   %edx
  801fcf:	50                   	push   %eax
  801fd0:	6a 19                	push   $0x19
  801fd2:	e8 44 fd ff ff       	call   801d1b <syscall>
  801fd7:	83 c4 18             	add    $0x18,%esp
}
  801fda:	90                   	nop
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 04             	sub    $0x4,%esp
  801fe3:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fe9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fec:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff3:	6a 00                	push   $0x0
  801ff5:	51                   	push   %ecx
  801ff6:	52                   	push   %edx
  801ff7:	ff 75 0c             	pushl  0xc(%ebp)
  801ffa:	50                   	push   %eax
  801ffb:	6a 1b                	push   $0x1b
  801ffd:	e8 19 fd ff ff       	call   801d1b <syscall>
  802002:	83 c4 18             	add    $0x18,%esp
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80200a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	52                   	push   %edx
  802017:	50                   	push   %eax
  802018:	6a 1c                	push   $0x1c
  80201a:	e8 fc fc ff ff       	call   801d1b <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802027:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	51                   	push   %ecx
  802035:	52                   	push   %edx
  802036:	50                   	push   %eax
  802037:	6a 1d                	push   $0x1d
  802039:	e8 dd fc ff ff       	call   801d1b <syscall>
  80203e:	83 c4 18             	add    $0x18,%esp
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802046:	8b 55 0c             	mov    0xc(%ebp),%edx
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	52                   	push   %edx
  802053:	50                   	push   %eax
  802054:	6a 1e                	push   $0x1e
  802056:	e8 c0 fc ff ff       	call   801d1b <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 1f                	push   $0x1f
  80206f:	e8 a7 fc ff ff       	call   801d1b <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	6a 00                	push   $0x0
  802081:	ff 75 14             	pushl  0x14(%ebp)
  802084:	ff 75 10             	pushl  0x10(%ebp)
  802087:	ff 75 0c             	pushl  0xc(%ebp)
  80208a:	50                   	push   %eax
  80208b:	6a 20                	push   $0x20
  80208d:	e8 89 fc ff ff       	call   801d1b <syscall>
  802092:	83 c4 18             	add    $0x18,%esp
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	6a 00                	push   $0x0
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	50                   	push   %eax
  8020a6:	6a 21                	push   $0x21
  8020a8:	e8 6e fc ff ff       	call   801d1b <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
}
  8020b0:	90                   	nop
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	50                   	push   %eax
  8020c2:	6a 22                	push   $0x22
  8020c4:	e8 52 fc ff ff       	call   801d1b <syscall>
  8020c9:	83 c4 18             	add    $0x18,%esp
}
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 02                	push   $0x2
  8020dd:	e8 39 fc ff ff       	call   801d1b <syscall>
  8020e2:	83 c4 18             	add    $0x18,%esp
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 03                	push   $0x3
  8020f6:	e8 20 fc ff ff       	call   801d1b <syscall>
  8020fb:	83 c4 18             	add    $0x18,%esp
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    

00802100 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 04                	push   $0x4
  80210f:	e8 07 fc ff ff       	call   801d1b <syscall>
  802114:	83 c4 18             	add    $0x18,%esp
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <sys_exit_env>:


void sys_exit_env(void)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 23                	push   $0x23
  802128:	e8 ee fb ff ff       	call   801d1b <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
}
  802130:	90                   	nop
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802139:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80213c:	8d 50 04             	lea    0x4(%eax),%edx
  80213f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	52                   	push   %edx
  802149:	50                   	push   %eax
  80214a:	6a 24                	push   $0x24
  80214c:	e8 ca fb ff ff       	call   801d1b <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
	return result;
  802154:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802157:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80215a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80215d:	89 01                	mov    %eax,(%ecx)
  80215f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	c9                   	leave  
  802166:	c2 04 00             	ret    $0x4

00802169 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	ff 75 10             	pushl  0x10(%ebp)
  802173:	ff 75 0c             	pushl  0xc(%ebp)
  802176:	ff 75 08             	pushl  0x8(%ebp)
  802179:	6a 12                	push   $0x12
  80217b:	e8 9b fb ff ff       	call   801d1b <syscall>
  802180:	83 c4 18             	add    $0x18,%esp
	return ;
  802183:	90                   	nop
}
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <sys_rcr2>:
uint32 sys_rcr2()
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 25                	push   $0x25
  802195:	e8 81 fb ff ff       	call   801d1b <syscall>
  80219a:	83 c4 18             	add    $0x18,%esp
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
  8021a2:	83 ec 04             	sub    $0x4,%esp
  8021a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021ab:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	50                   	push   %eax
  8021b8:	6a 26                	push   $0x26
  8021ba:	e8 5c fb ff ff       	call   801d1b <syscall>
  8021bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c2:	90                   	nop
}
  8021c3:	c9                   	leave  
  8021c4:	c3                   	ret    

008021c5 <rsttst>:
void rsttst()
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 28                	push   $0x28
  8021d4:	e8 42 fb ff ff       	call   801d1b <syscall>
  8021d9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021dc:	90                   	nop
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	83 ec 04             	sub    $0x4,%esp
  8021e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021eb:	8b 55 18             	mov    0x18(%ebp),%edx
  8021ee:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021f2:	52                   	push   %edx
  8021f3:	50                   	push   %eax
  8021f4:	ff 75 10             	pushl  0x10(%ebp)
  8021f7:	ff 75 0c             	pushl  0xc(%ebp)
  8021fa:	ff 75 08             	pushl  0x8(%ebp)
  8021fd:	6a 27                	push   $0x27
  8021ff:	e8 17 fb ff ff       	call   801d1b <syscall>
  802204:	83 c4 18             	add    $0x18,%esp
	return ;
  802207:	90                   	nop
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <chktst>:
void chktst(uint32 n)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	ff 75 08             	pushl  0x8(%ebp)
  802218:	6a 29                	push   $0x29
  80221a:	e8 fc fa ff ff       	call   801d1b <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
	return ;
  802222:	90                   	nop
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <inctst>:

void inctst()
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 2a                	push   $0x2a
  802234:	e8 e2 fa ff ff       	call   801d1b <syscall>
  802239:	83 c4 18             	add    $0x18,%esp
	return ;
  80223c:	90                   	nop
}
  80223d:	c9                   	leave  
  80223e:	c3                   	ret    

0080223f <gettst>:
uint32 gettst()
{
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 2b                	push   $0x2b
  80224e:	e8 c8 fa ff ff       	call   801d1b <syscall>
  802253:	83 c4 18             	add    $0x18,%esp
}
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 2c                	push   $0x2c
  80226a:	e8 ac fa ff ff       	call   801d1b <syscall>
  80226f:	83 c4 18             	add    $0x18,%esp
  802272:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802275:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802279:	75 07                	jne    802282 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80227b:	b8 01 00 00 00       	mov    $0x1,%eax
  802280:	eb 05                	jmp    802287 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802282:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802287:	c9                   	leave  
  802288:	c3                   	ret    

00802289 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 2c                	push   $0x2c
  80229b:	e8 7b fa ff ff       	call   801d1b <syscall>
  8022a0:	83 c4 18             	add    $0x18,%esp
  8022a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022a6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022aa:	75 07                	jne    8022b3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b1:	eb 05                	jmp    8022b8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b8:	c9                   	leave  
  8022b9:	c3                   	ret    

008022ba <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 2c                	push   $0x2c
  8022cc:	e8 4a fa ff ff       	call   801d1b <syscall>
  8022d1:	83 c4 18             	add    $0x18,%esp
  8022d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022d7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022db:	75 07                	jne    8022e4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e2:	eb 05                	jmp    8022e9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022e9:	c9                   	leave  
  8022ea:	c3                   	ret    

008022eb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 2c                	push   $0x2c
  8022fd:	e8 19 fa ff ff       	call   801d1b <syscall>
  802302:	83 c4 18             	add    $0x18,%esp
  802305:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802308:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80230c:	75 07                	jne    802315 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80230e:	b8 01 00 00 00       	mov    $0x1,%eax
  802313:	eb 05                	jmp    80231a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802315:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	ff 75 08             	pushl  0x8(%ebp)
  80232a:	6a 2d                	push   $0x2d
  80232c:	e8 ea f9 ff ff       	call   801d1b <syscall>
  802331:	83 c4 18             	add    $0x18,%esp
	return ;
  802334:	90                   	nop
}
  802335:	c9                   	leave  
  802336:	c3                   	ret    

00802337 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
  80233a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80233b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80233e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802341:	8b 55 0c             	mov    0xc(%ebp),%edx
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	6a 00                	push   $0x0
  802349:	53                   	push   %ebx
  80234a:	51                   	push   %ecx
  80234b:	52                   	push   %edx
  80234c:	50                   	push   %eax
  80234d:	6a 2e                	push   $0x2e
  80234f:	e8 c7 f9 ff ff       	call   801d1b <syscall>
  802354:	83 c4 18             	add    $0x18,%esp
}
  802357:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80235a:	c9                   	leave  
  80235b:	c3                   	ret    

0080235c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80235f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	52                   	push   %edx
  80236c:	50                   	push   %eax
  80236d:	6a 2f                	push   $0x2f
  80236f:	e8 a7 f9 ff ff       	call   801d1b <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
}
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80237f:	83 ec 0c             	sub    $0xc,%esp
  802382:	68 a0 3f 80 00       	push   $0x803fa0
  802387:	e8 c3 e6 ff ff       	call   800a4f <cprintf>
  80238c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80238f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802396:	83 ec 0c             	sub    $0xc,%esp
  802399:	68 cc 3f 80 00       	push   $0x803fcc
  80239e:	e8 ac e6 ff ff       	call   800a4f <cprintf>
  8023a3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8023a6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023aa:	a1 38 51 80 00       	mov    0x805138,%eax
  8023af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b2:	eb 56                	jmp    80240a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023b8:	74 1c                	je     8023d6 <print_mem_block_lists+0x5d>
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	8b 50 08             	mov    0x8(%eax),%edx
  8023c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c3:	8b 48 08             	mov    0x8(%eax),%ecx
  8023c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cc:	01 c8                	add    %ecx,%eax
  8023ce:	39 c2                	cmp    %eax,%edx
  8023d0:	73 04                	jae    8023d6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023d2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d9:	8b 50 08             	mov    0x8(%eax),%edx
  8023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023df:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e2:	01 c2                	add    %eax,%edx
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 40 08             	mov    0x8(%eax),%eax
  8023ea:	83 ec 04             	sub    $0x4,%esp
  8023ed:	52                   	push   %edx
  8023ee:	50                   	push   %eax
  8023ef:	68 e1 3f 80 00       	push   $0x803fe1
  8023f4:	e8 56 e6 ff ff       	call   800a4f <cprintf>
  8023f9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802402:	a1 40 51 80 00       	mov    0x805140,%eax
  802407:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240e:	74 07                	je     802417 <print_mem_block_lists+0x9e>
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 00                	mov    (%eax),%eax
  802415:	eb 05                	jmp    80241c <print_mem_block_lists+0xa3>
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
  80241c:	a3 40 51 80 00       	mov    %eax,0x805140
  802421:	a1 40 51 80 00       	mov    0x805140,%eax
  802426:	85 c0                	test   %eax,%eax
  802428:	75 8a                	jne    8023b4 <print_mem_block_lists+0x3b>
  80242a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242e:	75 84                	jne    8023b4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802430:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802434:	75 10                	jne    802446 <print_mem_block_lists+0xcd>
  802436:	83 ec 0c             	sub    $0xc,%esp
  802439:	68 f0 3f 80 00       	push   $0x803ff0
  80243e:	e8 0c e6 ff ff       	call   800a4f <cprintf>
  802443:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802446:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80244d:	83 ec 0c             	sub    $0xc,%esp
  802450:	68 14 40 80 00       	push   $0x804014
  802455:	e8 f5 e5 ff ff       	call   800a4f <cprintf>
  80245a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80245d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802461:	a1 40 50 80 00       	mov    0x805040,%eax
  802466:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802469:	eb 56                	jmp    8024c1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80246b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80246f:	74 1c                	je     80248d <print_mem_block_lists+0x114>
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	8b 50 08             	mov    0x8(%eax),%edx
  802477:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247a:	8b 48 08             	mov    0x8(%eax),%ecx
  80247d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802480:	8b 40 0c             	mov    0xc(%eax),%eax
  802483:	01 c8                	add    %ecx,%eax
  802485:	39 c2                	cmp    %eax,%edx
  802487:	73 04                	jae    80248d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802489:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	8b 50 08             	mov    0x8(%eax),%edx
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	8b 40 0c             	mov    0xc(%eax),%eax
  802499:	01 c2                	add    %eax,%edx
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249e:	8b 40 08             	mov    0x8(%eax),%eax
  8024a1:	83 ec 04             	sub    $0x4,%esp
  8024a4:	52                   	push   %edx
  8024a5:	50                   	push   %eax
  8024a6:	68 e1 3f 80 00       	push   $0x803fe1
  8024ab:	e8 9f e5 ff ff       	call   800a4f <cprintf>
  8024b0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024b9:	a1 48 50 80 00       	mov    0x805048,%eax
  8024be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c5:	74 07                	je     8024ce <print_mem_block_lists+0x155>
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 00                	mov    (%eax),%eax
  8024cc:	eb 05                	jmp    8024d3 <print_mem_block_lists+0x15a>
  8024ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d3:	a3 48 50 80 00       	mov    %eax,0x805048
  8024d8:	a1 48 50 80 00       	mov    0x805048,%eax
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	75 8a                	jne    80246b <print_mem_block_lists+0xf2>
  8024e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e5:	75 84                	jne    80246b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024e7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024eb:	75 10                	jne    8024fd <print_mem_block_lists+0x184>
  8024ed:	83 ec 0c             	sub    $0xc,%esp
  8024f0:	68 2c 40 80 00       	push   $0x80402c
  8024f5:	e8 55 e5 ff ff       	call   800a4f <cprintf>
  8024fa:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024fd:	83 ec 0c             	sub    $0xc,%esp
  802500:	68 a0 3f 80 00       	push   $0x803fa0
  802505:	e8 45 e5 ff ff       	call   800a4f <cprintf>
  80250a:	83 c4 10             	add    $0x10,%esp

}
  80250d:	90                   	nop
  80250e:	c9                   	leave  
  80250f:	c3                   	ret    

00802510 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802516:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80251d:	00 00 00 
  802520:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802527:	00 00 00 
  80252a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802531:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802534:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80253b:	e9 9e 00 00 00       	jmp    8025de <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802540:	a1 50 50 80 00       	mov    0x805050,%eax
  802545:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802548:	c1 e2 04             	shl    $0x4,%edx
  80254b:	01 d0                	add    %edx,%eax
  80254d:	85 c0                	test   %eax,%eax
  80254f:	75 14                	jne    802565 <initialize_MemBlocksList+0x55>
  802551:	83 ec 04             	sub    $0x4,%esp
  802554:	68 54 40 80 00       	push   $0x804054
  802559:	6a 47                	push   $0x47
  80255b:	68 77 40 80 00       	push   $0x804077
  802560:	e8 36 e2 ff ff       	call   80079b <_panic>
  802565:	a1 50 50 80 00       	mov    0x805050,%eax
  80256a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256d:	c1 e2 04             	shl    $0x4,%edx
  802570:	01 d0                	add    %edx,%eax
  802572:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802578:	89 10                	mov    %edx,(%eax)
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	85 c0                	test   %eax,%eax
  80257e:	74 18                	je     802598 <initialize_MemBlocksList+0x88>
  802580:	a1 48 51 80 00       	mov    0x805148,%eax
  802585:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80258b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80258e:	c1 e1 04             	shl    $0x4,%ecx
  802591:	01 ca                	add    %ecx,%edx
  802593:	89 50 04             	mov    %edx,0x4(%eax)
  802596:	eb 12                	jmp    8025aa <initialize_MemBlocksList+0x9a>
  802598:	a1 50 50 80 00       	mov    0x805050,%eax
  80259d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a0:	c1 e2 04             	shl    $0x4,%edx
  8025a3:	01 d0                	add    %edx,%eax
  8025a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025aa:	a1 50 50 80 00       	mov    0x805050,%eax
  8025af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b2:	c1 e2 04             	shl    $0x4,%edx
  8025b5:	01 d0                	add    %edx,%eax
  8025b7:	a3 48 51 80 00       	mov    %eax,0x805148
  8025bc:	a1 50 50 80 00       	mov    0x805050,%eax
  8025c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c4:	c1 e2 04             	shl    $0x4,%edx
  8025c7:	01 d0                	add    %edx,%eax
  8025c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8025d5:	40                   	inc    %eax
  8025d6:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8025db:	ff 45 f4             	incl   -0xc(%ebp)
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e4:	0f 82 56 ff ff ff    	jb     802540 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8025ea:	90                   	nop
  8025eb:	c9                   	leave  
  8025ec:	c3                   	ret    

008025ed <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025ed:	55                   	push   %ebp
  8025ee:	89 e5                	mov    %esp,%ebp
  8025f0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8025f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f6:	8b 00                	mov    (%eax),%eax
  8025f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025fb:	eb 19                	jmp    802616 <find_block+0x29>
	{
		if(element->sva == va){
  8025fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802600:	8b 40 08             	mov    0x8(%eax),%eax
  802603:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802606:	75 05                	jne    80260d <find_block+0x20>
			 		return element;
  802608:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80260b:	eb 36                	jmp    802643 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	8b 40 08             	mov    0x8(%eax),%eax
  802613:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802616:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80261a:	74 07                	je     802623 <find_block+0x36>
  80261c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80261f:	8b 00                	mov    (%eax),%eax
  802621:	eb 05                	jmp    802628 <find_block+0x3b>
  802623:	b8 00 00 00 00       	mov    $0x0,%eax
  802628:	8b 55 08             	mov    0x8(%ebp),%edx
  80262b:	89 42 08             	mov    %eax,0x8(%edx)
  80262e:	8b 45 08             	mov    0x8(%ebp),%eax
  802631:	8b 40 08             	mov    0x8(%eax),%eax
  802634:	85 c0                	test   %eax,%eax
  802636:	75 c5                	jne    8025fd <find_block+0x10>
  802638:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80263c:	75 bf                	jne    8025fd <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  80263e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80264b:	a1 44 50 80 00       	mov    0x805044,%eax
  802650:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802653:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802658:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80265b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80265f:	74 0a                	je     80266b <insert_sorted_allocList+0x26>
  802661:	8b 45 08             	mov    0x8(%ebp),%eax
  802664:	8b 40 08             	mov    0x8(%eax),%eax
  802667:	85 c0                	test   %eax,%eax
  802669:	75 65                	jne    8026d0 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80266b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80266f:	75 14                	jne    802685 <insert_sorted_allocList+0x40>
  802671:	83 ec 04             	sub    $0x4,%esp
  802674:	68 54 40 80 00       	push   $0x804054
  802679:	6a 6e                	push   $0x6e
  80267b:	68 77 40 80 00       	push   $0x804077
  802680:	e8 16 e1 ff ff       	call   80079b <_panic>
  802685:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80268b:	8b 45 08             	mov    0x8(%ebp),%eax
  80268e:	89 10                	mov    %edx,(%eax)
  802690:	8b 45 08             	mov    0x8(%ebp),%eax
  802693:	8b 00                	mov    (%eax),%eax
  802695:	85 c0                	test   %eax,%eax
  802697:	74 0d                	je     8026a6 <insert_sorted_allocList+0x61>
  802699:	a1 40 50 80 00       	mov    0x805040,%eax
  80269e:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a1:	89 50 04             	mov    %edx,0x4(%eax)
  8026a4:	eb 08                	jmp    8026ae <insert_sorted_allocList+0x69>
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	a3 44 50 80 00       	mov    %eax,0x805044
  8026ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b1:	a3 40 50 80 00       	mov    %eax,0x805040
  8026b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026c5:	40                   	inc    %eax
  8026c6:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8026cb:	e9 cf 01 00 00       	jmp    80289f <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8026d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d3:	8b 50 08             	mov    0x8(%eax),%edx
  8026d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d9:	8b 40 08             	mov    0x8(%eax),%eax
  8026dc:	39 c2                	cmp    %eax,%edx
  8026de:	73 65                	jae    802745 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8026e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026e4:	75 14                	jne    8026fa <insert_sorted_allocList+0xb5>
  8026e6:	83 ec 04             	sub    $0x4,%esp
  8026e9:	68 90 40 80 00       	push   $0x804090
  8026ee:	6a 72                	push   $0x72
  8026f0:	68 77 40 80 00       	push   $0x804077
  8026f5:	e8 a1 e0 ff ff       	call   80079b <_panic>
  8026fa:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802700:	8b 45 08             	mov    0x8(%ebp),%eax
  802703:	89 50 04             	mov    %edx,0x4(%eax)
  802706:	8b 45 08             	mov    0x8(%ebp),%eax
  802709:	8b 40 04             	mov    0x4(%eax),%eax
  80270c:	85 c0                	test   %eax,%eax
  80270e:	74 0c                	je     80271c <insert_sorted_allocList+0xd7>
  802710:	a1 44 50 80 00       	mov    0x805044,%eax
  802715:	8b 55 08             	mov    0x8(%ebp),%edx
  802718:	89 10                	mov    %edx,(%eax)
  80271a:	eb 08                	jmp    802724 <insert_sorted_allocList+0xdf>
  80271c:	8b 45 08             	mov    0x8(%ebp),%eax
  80271f:	a3 40 50 80 00       	mov    %eax,0x805040
  802724:	8b 45 08             	mov    0x8(%ebp),%eax
  802727:	a3 44 50 80 00       	mov    %eax,0x805044
  80272c:	8b 45 08             	mov    0x8(%ebp),%eax
  80272f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802735:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80273a:	40                   	inc    %eax
  80273b:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802740:	e9 5a 01 00 00       	jmp    80289f <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802748:	8b 50 08             	mov    0x8(%eax),%edx
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	8b 40 08             	mov    0x8(%eax),%eax
  802751:	39 c2                	cmp    %eax,%edx
  802753:	75 70                	jne    8027c5 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802755:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802759:	74 06                	je     802761 <insert_sorted_allocList+0x11c>
  80275b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80275f:	75 14                	jne    802775 <insert_sorted_allocList+0x130>
  802761:	83 ec 04             	sub    $0x4,%esp
  802764:	68 b4 40 80 00       	push   $0x8040b4
  802769:	6a 75                	push   $0x75
  80276b:	68 77 40 80 00       	push   $0x804077
  802770:	e8 26 e0 ff ff       	call   80079b <_panic>
  802775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802778:	8b 10                	mov    (%eax),%edx
  80277a:	8b 45 08             	mov    0x8(%ebp),%eax
  80277d:	89 10                	mov    %edx,(%eax)
  80277f:	8b 45 08             	mov    0x8(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	85 c0                	test   %eax,%eax
  802786:	74 0b                	je     802793 <insert_sorted_allocList+0x14e>
  802788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	8b 55 08             	mov    0x8(%ebp),%edx
  802790:	89 50 04             	mov    %edx,0x4(%eax)
  802793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802796:	8b 55 08             	mov    0x8(%ebp),%edx
  802799:	89 10                	mov    %edx,(%eax)
  80279b:	8b 45 08             	mov    0x8(%ebp),%eax
  80279e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a1:	89 50 04             	mov    %edx,0x4(%eax)
  8027a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a7:	8b 00                	mov    (%eax),%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	75 08                	jne    8027b5 <insert_sorted_allocList+0x170>
  8027ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b0:	a3 44 50 80 00       	mov    %eax,0x805044
  8027b5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027ba:	40                   	inc    %eax
  8027bb:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8027c0:	e9 da 00 00 00       	jmp    80289f <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8027c5:	a1 40 50 80 00       	mov    0x805040,%eax
  8027ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027cd:	e9 9d 00 00 00       	jmp    80286f <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8027da:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dd:	8b 50 08             	mov    0x8(%eax),%edx
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	8b 40 08             	mov    0x8(%eax),%eax
  8027e6:	39 c2                	cmp    %eax,%edx
  8027e8:	76 7d                	jbe    802867 <insert_sorted_allocList+0x222>
  8027ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ed:	8b 50 08             	mov    0x8(%eax),%edx
  8027f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f3:	8b 40 08             	mov    0x8(%eax),%eax
  8027f6:	39 c2                	cmp    %eax,%edx
  8027f8:	73 6d                	jae    802867 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8027fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fe:	74 06                	je     802806 <insert_sorted_allocList+0x1c1>
  802800:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802804:	75 14                	jne    80281a <insert_sorted_allocList+0x1d5>
  802806:	83 ec 04             	sub    $0x4,%esp
  802809:	68 b4 40 80 00       	push   $0x8040b4
  80280e:	6a 7c                	push   $0x7c
  802810:	68 77 40 80 00       	push   $0x804077
  802815:	e8 81 df ff ff       	call   80079b <_panic>
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 10                	mov    (%eax),%edx
  80281f:	8b 45 08             	mov    0x8(%ebp),%eax
  802822:	89 10                	mov    %edx,(%eax)
  802824:	8b 45 08             	mov    0x8(%ebp),%eax
  802827:	8b 00                	mov    (%eax),%eax
  802829:	85 c0                	test   %eax,%eax
  80282b:	74 0b                	je     802838 <insert_sorted_allocList+0x1f3>
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	8b 00                	mov    (%eax),%eax
  802832:	8b 55 08             	mov    0x8(%ebp),%edx
  802835:	89 50 04             	mov    %edx,0x4(%eax)
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 55 08             	mov    0x8(%ebp),%edx
  80283e:	89 10                	mov    %edx,(%eax)
  802840:	8b 45 08             	mov    0x8(%ebp),%eax
  802843:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802846:	89 50 04             	mov    %edx,0x4(%eax)
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	8b 00                	mov    (%eax),%eax
  80284e:	85 c0                	test   %eax,%eax
  802850:	75 08                	jne    80285a <insert_sorted_allocList+0x215>
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	a3 44 50 80 00       	mov    %eax,0x805044
  80285a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80285f:	40                   	inc    %eax
  802860:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802865:	eb 38                	jmp    80289f <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802867:	a1 48 50 80 00       	mov    0x805048,%eax
  80286c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80286f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802873:	74 07                	je     80287c <insert_sorted_allocList+0x237>
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	eb 05                	jmp    802881 <insert_sorted_allocList+0x23c>
  80287c:	b8 00 00 00 00       	mov    $0x0,%eax
  802881:	a3 48 50 80 00       	mov    %eax,0x805048
  802886:	a1 48 50 80 00       	mov    0x805048,%eax
  80288b:	85 c0                	test   %eax,%eax
  80288d:	0f 85 3f ff ff ff    	jne    8027d2 <insert_sorted_allocList+0x18d>
  802893:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802897:	0f 85 35 ff ff ff    	jne    8027d2 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  80289d:	eb 00                	jmp    80289f <insert_sorted_allocList+0x25a>
  80289f:	90                   	nop
  8028a0:	c9                   	leave  
  8028a1:	c3                   	ret    

008028a2 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8028a2:	55                   	push   %ebp
  8028a3:	89 e5                	mov    %esp,%ebp
  8028a5:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8028a8:	a1 38 51 80 00       	mov    0x805138,%eax
  8028ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b0:	e9 6b 02 00 00       	jmp    802b20 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028be:	0f 85 90 00 00 00    	jne    802954 <alloc_block_FF+0xb2>
			  temp=element;
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8028ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ce:	75 17                	jne    8028e7 <alloc_block_FF+0x45>
  8028d0:	83 ec 04             	sub    $0x4,%esp
  8028d3:	68 e8 40 80 00       	push   $0x8040e8
  8028d8:	68 92 00 00 00       	push   $0x92
  8028dd:	68 77 40 80 00       	push   $0x804077
  8028e2:	e8 b4 de ff ff       	call   80079b <_panic>
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 00                	mov    (%eax),%eax
  8028ec:	85 c0                	test   %eax,%eax
  8028ee:	74 10                	je     802900 <alloc_block_FF+0x5e>
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 00                	mov    (%eax),%eax
  8028f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f8:	8b 52 04             	mov    0x4(%edx),%edx
  8028fb:	89 50 04             	mov    %edx,0x4(%eax)
  8028fe:	eb 0b                	jmp    80290b <alloc_block_FF+0x69>
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 40 04             	mov    0x4(%eax),%eax
  802906:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	8b 40 04             	mov    0x4(%eax),%eax
  802911:	85 c0                	test   %eax,%eax
  802913:	74 0f                	je     802924 <alloc_block_FF+0x82>
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	8b 40 04             	mov    0x4(%eax),%eax
  80291b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291e:	8b 12                	mov    (%edx),%edx
  802920:	89 10                	mov    %edx,(%eax)
  802922:	eb 0a                	jmp    80292e <alloc_block_FF+0x8c>
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	8b 00                	mov    (%eax),%eax
  802929:	a3 38 51 80 00       	mov    %eax,0x805138
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802941:	a1 44 51 80 00       	mov    0x805144,%eax
  802946:	48                   	dec    %eax
  802947:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  80294c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294f:	e9 ff 01 00 00       	jmp    802b53 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	8b 40 0c             	mov    0xc(%eax),%eax
  80295a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80295d:	0f 86 b5 01 00 00    	jbe    802b18 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	8b 40 0c             	mov    0xc(%eax),%eax
  802969:	2b 45 08             	sub    0x8(%ebp),%eax
  80296c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80296f:	a1 48 51 80 00       	mov    0x805148,%eax
  802974:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802977:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80297b:	75 17                	jne    802994 <alloc_block_FF+0xf2>
  80297d:	83 ec 04             	sub    $0x4,%esp
  802980:	68 e8 40 80 00       	push   $0x8040e8
  802985:	68 99 00 00 00       	push   $0x99
  80298a:	68 77 40 80 00       	push   $0x804077
  80298f:	e8 07 de ff ff       	call   80079b <_panic>
  802994:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802997:	8b 00                	mov    (%eax),%eax
  802999:	85 c0                	test   %eax,%eax
  80299b:	74 10                	je     8029ad <alloc_block_FF+0x10b>
  80299d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a0:	8b 00                	mov    (%eax),%eax
  8029a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029a5:	8b 52 04             	mov    0x4(%edx),%edx
  8029a8:	89 50 04             	mov    %edx,0x4(%eax)
  8029ab:	eb 0b                	jmp    8029b8 <alloc_block_FF+0x116>
  8029ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b0:	8b 40 04             	mov    0x4(%eax),%eax
  8029b3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bb:	8b 40 04             	mov    0x4(%eax),%eax
  8029be:	85 c0                	test   %eax,%eax
  8029c0:	74 0f                	je     8029d1 <alloc_block_FF+0x12f>
  8029c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c5:	8b 40 04             	mov    0x4(%eax),%eax
  8029c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029cb:	8b 12                	mov    (%edx),%edx
  8029cd:	89 10                	mov    %edx,(%eax)
  8029cf:	eb 0a                	jmp    8029db <alloc_block_FF+0x139>
  8029d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d4:	8b 00                	mov    (%eax),%eax
  8029d6:	a3 48 51 80 00       	mov    %eax,0x805148
  8029db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ee:	a1 54 51 80 00       	mov    0x805154,%eax
  8029f3:	48                   	dec    %eax
  8029f4:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8029f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029fd:	75 17                	jne    802a16 <alloc_block_FF+0x174>
  8029ff:	83 ec 04             	sub    $0x4,%esp
  802a02:	68 90 40 80 00       	push   $0x804090
  802a07:	68 9a 00 00 00       	push   $0x9a
  802a0c:	68 77 40 80 00       	push   $0x804077
  802a11:	e8 85 dd ff ff       	call   80079b <_panic>
  802a16:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802a1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1f:	89 50 04             	mov    %edx,0x4(%eax)
  802a22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a25:	8b 40 04             	mov    0x4(%eax),%eax
  802a28:	85 c0                	test   %eax,%eax
  802a2a:	74 0c                	je     802a38 <alloc_block_FF+0x196>
  802a2c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802a31:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a34:	89 10                	mov    %edx,(%eax)
  802a36:	eb 08                	jmp    802a40 <alloc_block_FF+0x19e>
  802a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3b:	a3 38 51 80 00       	mov    %eax,0x805138
  802a40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a43:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a51:	a1 44 51 80 00       	mov    0x805144,%eax
  802a56:	40                   	inc    %eax
  802a57:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802a5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a62:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 50 08             	mov    0x8(%eax),%edx
  802a6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6e:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a77:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 50 08             	mov    0x8(%eax),%edx
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	01 c2                	add    %eax,%edx
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802a8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802a91:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a95:	75 17                	jne    802aae <alloc_block_FF+0x20c>
  802a97:	83 ec 04             	sub    $0x4,%esp
  802a9a:	68 e8 40 80 00       	push   $0x8040e8
  802a9f:	68 a2 00 00 00       	push   $0xa2
  802aa4:	68 77 40 80 00       	push   $0x804077
  802aa9:	e8 ed dc ff ff       	call   80079b <_panic>
  802aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab1:	8b 00                	mov    (%eax),%eax
  802ab3:	85 c0                	test   %eax,%eax
  802ab5:	74 10                	je     802ac7 <alloc_block_FF+0x225>
  802ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aba:	8b 00                	mov    (%eax),%eax
  802abc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802abf:	8b 52 04             	mov    0x4(%edx),%edx
  802ac2:	89 50 04             	mov    %edx,0x4(%eax)
  802ac5:	eb 0b                	jmp    802ad2 <alloc_block_FF+0x230>
  802ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aca:	8b 40 04             	mov    0x4(%eax),%eax
  802acd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ad2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad5:	8b 40 04             	mov    0x4(%eax),%eax
  802ad8:	85 c0                	test   %eax,%eax
  802ada:	74 0f                	je     802aeb <alloc_block_FF+0x249>
  802adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adf:	8b 40 04             	mov    0x4(%eax),%eax
  802ae2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae5:	8b 12                	mov    (%edx),%edx
  802ae7:	89 10                	mov    %edx,(%eax)
  802ae9:	eb 0a                	jmp    802af5 <alloc_block_FF+0x253>
  802aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aee:	8b 00                	mov    (%eax),%eax
  802af0:	a3 38 51 80 00       	mov    %eax,0x805138
  802af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b08:	a1 44 51 80 00       	mov    0x805144,%eax
  802b0d:	48                   	dec    %eax
  802b0e:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802b13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b16:	eb 3b                	jmp    802b53 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802b18:	a1 40 51 80 00       	mov    0x805140,%eax
  802b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b24:	74 07                	je     802b2d <alloc_block_FF+0x28b>
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 00                	mov    (%eax),%eax
  802b2b:	eb 05                	jmp    802b32 <alloc_block_FF+0x290>
  802b2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b32:	a3 40 51 80 00       	mov    %eax,0x805140
  802b37:	a1 40 51 80 00       	mov    0x805140,%eax
  802b3c:	85 c0                	test   %eax,%eax
  802b3e:	0f 85 71 fd ff ff    	jne    8028b5 <alloc_block_FF+0x13>
  802b44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b48:	0f 85 67 fd ff ff    	jne    8028b5 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802b4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b53:	c9                   	leave  
  802b54:	c3                   	ret    

00802b55 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b55:	55                   	push   %ebp
  802b56:	89 e5                	mov    %esp,%ebp
  802b58:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802b5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802b62:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802b69:	a1 38 51 80 00       	mov    0x805138,%eax
  802b6e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802b71:	e9 d3 00 00 00       	jmp    802c49 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802b76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b79:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b7f:	0f 85 90 00 00 00    	jne    802c15 <alloc_block_BF+0xc0>
	   temp = element;
  802b85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b88:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802b8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b8f:	75 17                	jne    802ba8 <alloc_block_BF+0x53>
  802b91:	83 ec 04             	sub    $0x4,%esp
  802b94:	68 e8 40 80 00       	push   $0x8040e8
  802b99:	68 bd 00 00 00       	push   $0xbd
  802b9e:	68 77 40 80 00       	push   $0x804077
  802ba3:	e8 f3 db ff ff       	call   80079b <_panic>
  802ba8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bab:	8b 00                	mov    (%eax),%eax
  802bad:	85 c0                	test   %eax,%eax
  802baf:	74 10                	je     802bc1 <alloc_block_BF+0x6c>
  802bb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb4:	8b 00                	mov    (%eax),%eax
  802bb6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bb9:	8b 52 04             	mov    0x4(%edx),%edx
  802bbc:	89 50 04             	mov    %edx,0x4(%eax)
  802bbf:	eb 0b                	jmp    802bcc <alloc_block_BF+0x77>
  802bc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc4:	8b 40 04             	mov    0x4(%eax),%eax
  802bc7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bcf:	8b 40 04             	mov    0x4(%eax),%eax
  802bd2:	85 c0                	test   %eax,%eax
  802bd4:	74 0f                	je     802be5 <alloc_block_BF+0x90>
  802bd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd9:	8b 40 04             	mov    0x4(%eax),%eax
  802bdc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bdf:	8b 12                	mov    (%edx),%edx
  802be1:	89 10                	mov    %edx,(%eax)
  802be3:	eb 0a                	jmp    802bef <alloc_block_BF+0x9a>
  802be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be8:	8b 00                	mov    (%eax),%eax
  802bea:	a3 38 51 80 00       	mov    %eax,0x805138
  802bef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c02:	a1 44 51 80 00       	mov    0x805144,%eax
  802c07:	48                   	dec    %eax
  802c08:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802c0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c10:	e9 41 01 00 00       	jmp    802d56 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802c15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c18:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c1e:	76 21                	jbe    802c41 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802c20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c23:	8b 40 0c             	mov    0xc(%eax),%eax
  802c26:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c29:	73 16                	jae    802c41 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802c2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c31:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802c34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c37:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802c3a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802c41:	a1 40 51 80 00       	mov    0x805140,%eax
  802c46:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802c49:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c4d:	74 07                	je     802c56 <alloc_block_BF+0x101>
  802c4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c52:	8b 00                	mov    (%eax),%eax
  802c54:	eb 05                	jmp    802c5b <alloc_block_BF+0x106>
  802c56:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5b:	a3 40 51 80 00       	mov    %eax,0x805140
  802c60:	a1 40 51 80 00       	mov    0x805140,%eax
  802c65:	85 c0                	test   %eax,%eax
  802c67:	0f 85 09 ff ff ff    	jne    802b76 <alloc_block_BF+0x21>
  802c6d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c71:	0f 85 ff fe ff ff    	jne    802b76 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802c77:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802c7b:	0f 85 d0 00 00 00    	jne    802d51 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802c81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c84:	8b 40 0c             	mov    0xc(%eax),%eax
  802c87:	2b 45 08             	sub    0x8(%ebp),%eax
  802c8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802c8d:	a1 48 51 80 00       	mov    0x805148,%eax
  802c92:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802c95:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c99:	75 17                	jne    802cb2 <alloc_block_BF+0x15d>
  802c9b:	83 ec 04             	sub    $0x4,%esp
  802c9e:	68 e8 40 80 00       	push   $0x8040e8
  802ca3:	68 d1 00 00 00       	push   $0xd1
  802ca8:	68 77 40 80 00       	push   $0x804077
  802cad:	e8 e9 da ff ff       	call   80079b <_panic>
  802cb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb5:	8b 00                	mov    (%eax),%eax
  802cb7:	85 c0                	test   %eax,%eax
  802cb9:	74 10                	je     802ccb <alloc_block_BF+0x176>
  802cbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cc3:	8b 52 04             	mov    0x4(%edx),%edx
  802cc6:	89 50 04             	mov    %edx,0x4(%eax)
  802cc9:	eb 0b                	jmp    802cd6 <alloc_block_BF+0x181>
  802ccb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cce:	8b 40 04             	mov    0x4(%eax),%eax
  802cd1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cd6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd9:	8b 40 04             	mov    0x4(%eax),%eax
  802cdc:	85 c0                	test   %eax,%eax
  802cde:	74 0f                	je     802cef <alloc_block_BF+0x19a>
  802ce0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ce3:	8b 40 04             	mov    0x4(%eax),%eax
  802ce6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ce9:	8b 12                	mov    (%edx),%edx
  802ceb:	89 10                	mov    %edx,(%eax)
  802ced:	eb 0a                	jmp    802cf9 <alloc_block_BF+0x1a4>
  802cef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cf2:	8b 00                	mov    (%eax),%eax
  802cf4:	a3 48 51 80 00       	mov    %eax,0x805148
  802cf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cfc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0c:	a1 54 51 80 00       	mov    0x805154,%eax
  802d11:	48                   	dec    %eax
  802d12:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  802d17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d1d:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d23:	8b 50 08             	mov    0x8(%eax),%edx
  802d26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d29:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802d2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d32:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802d35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d38:	8b 50 08             	mov    0x8(%eax),%edx
  802d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3e:	01 c2                	add    %eax,%edx
  802d40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d43:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802d46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d49:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802d4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d4f:	eb 05                	jmp    802d56 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802d51:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802d56:	c9                   	leave  
  802d57:	c3                   	ret    

00802d58 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802d58:	55                   	push   %ebp
  802d59:	89 e5                	mov    %esp,%ebp
  802d5b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802d5e:	83 ec 04             	sub    $0x4,%esp
  802d61:	68 08 41 80 00       	push   $0x804108
  802d66:	68 e8 00 00 00       	push   $0xe8
  802d6b:	68 77 40 80 00       	push   $0x804077
  802d70:	e8 26 da ff ff       	call   80079b <_panic>

00802d75 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d75:	55                   	push   %ebp
  802d76:	89 e5                	mov    %esp,%ebp
  802d78:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802d7b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802d83:	a1 38 51 80 00       	mov    0x805138,%eax
  802d88:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802d8b:	a1 44 51 80 00       	mov    0x805144,%eax
  802d90:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802d93:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d97:	75 68                	jne    802e01 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d9d:	75 17                	jne    802db6 <insert_sorted_with_merge_freeList+0x41>
  802d9f:	83 ec 04             	sub    $0x4,%esp
  802da2:	68 54 40 80 00       	push   $0x804054
  802da7:	68 36 01 00 00       	push   $0x136
  802dac:	68 77 40 80 00       	push   $0x804077
  802db1:	e8 e5 d9 ff ff       	call   80079b <_panic>
  802db6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	89 10                	mov    %edx,(%eax)
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	8b 00                	mov    (%eax),%eax
  802dc6:	85 c0                	test   %eax,%eax
  802dc8:	74 0d                	je     802dd7 <insert_sorted_with_merge_freeList+0x62>
  802dca:	a1 38 51 80 00       	mov    0x805138,%eax
  802dcf:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd2:	89 50 04             	mov    %edx,0x4(%eax)
  802dd5:	eb 08                	jmp    802ddf <insert_sorted_with_merge_freeList+0x6a>
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	a3 38 51 80 00       	mov    %eax,0x805138
  802de7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df1:	a1 44 51 80 00       	mov    0x805144,%eax
  802df6:	40                   	inc    %eax
  802df7:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802dfc:	e9 ba 06 00 00       	jmp    8034bb <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e04:	8b 50 08             	mov    0x8(%eax),%edx
  802e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0d:	01 c2                	add    %eax,%edx
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	8b 40 08             	mov    0x8(%eax),%eax
  802e15:	39 c2                	cmp    %eax,%edx
  802e17:	73 68                	jae    802e81 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e1d:	75 17                	jne    802e36 <insert_sorted_with_merge_freeList+0xc1>
  802e1f:	83 ec 04             	sub    $0x4,%esp
  802e22:	68 90 40 80 00       	push   $0x804090
  802e27:	68 3a 01 00 00       	push   $0x13a
  802e2c:	68 77 40 80 00       	push   $0x804077
  802e31:	e8 65 d9 ff ff       	call   80079b <_panic>
  802e36:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3f:	89 50 04             	mov    %edx,0x4(%eax)
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	8b 40 04             	mov    0x4(%eax),%eax
  802e48:	85 c0                	test   %eax,%eax
  802e4a:	74 0c                	je     802e58 <insert_sorted_with_merge_freeList+0xe3>
  802e4c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e51:	8b 55 08             	mov    0x8(%ebp),%edx
  802e54:	89 10                	mov    %edx,(%eax)
  802e56:	eb 08                	jmp    802e60 <insert_sorted_with_merge_freeList+0xeb>
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	a3 38 51 80 00       	mov    %eax,0x805138
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e71:	a1 44 51 80 00       	mov    0x805144,%eax
  802e76:	40                   	inc    %eax
  802e77:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802e7c:	e9 3a 06 00 00       	jmp    8034bb <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e84:	8b 50 08             	mov    0x8(%eax),%edx
  802e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8d:	01 c2                	add    %eax,%edx
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	8b 40 08             	mov    0x8(%eax),%eax
  802e95:	39 c2                	cmp    %eax,%edx
  802e97:	0f 85 90 00 00 00    	jne    802f2d <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea9:	01 c2                	add    %eax,%edx
  802eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eae:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ec5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec9:	75 17                	jne    802ee2 <insert_sorted_with_merge_freeList+0x16d>
  802ecb:	83 ec 04             	sub    $0x4,%esp
  802ece:	68 54 40 80 00       	push   $0x804054
  802ed3:	68 41 01 00 00       	push   $0x141
  802ed8:	68 77 40 80 00       	push   $0x804077
  802edd:	e8 b9 d8 ff ff       	call   80079b <_panic>
  802ee2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	89 10                	mov    %edx,(%eax)
  802eed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	74 0d                	je     802f03 <insert_sorted_with_merge_freeList+0x18e>
  802ef6:	a1 48 51 80 00       	mov    0x805148,%eax
  802efb:	8b 55 08             	mov    0x8(%ebp),%edx
  802efe:	89 50 04             	mov    %edx,0x4(%eax)
  802f01:	eb 08                	jmp    802f0b <insert_sorted_with_merge_freeList+0x196>
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	a3 48 51 80 00       	mov    %eax,0x805148
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1d:	a1 54 51 80 00       	mov    0x805154,%eax
  802f22:	40                   	inc    %eax
  802f23:	a3 54 51 80 00       	mov    %eax,0x805154





}
  802f28:	e9 8e 05 00 00       	jmp    8034bb <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	8b 50 08             	mov    0x8(%eax),%edx
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	8b 40 0c             	mov    0xc(%eax),%eax
  802f39:	01 c2                	add    %eax,%edx
  802f3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3e:	8b 40 08             	mov    0x8(%eax),%eax
  802f41:	39 c2                	cmp    %eax,%edx
  802f43:	73 68                	jae    802fad <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802f45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f49:	75 17                	jne    802f62 <insert_sorted_with_merge_freeList+0x1ed>
  802f4b:	83 ec 04             	sub    $0x4,%esp
  802f4e:	68 54 40 80 00       	push   $0x804054
  802f53:	68 45 01 00 00       	push   $0x145
  802f58:	68 77 40 80 00       	push   $0x804077
  802f5d:	e8 39 d8 ff ff       	call   80079b <_panic>
  802f62:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	89 10                	mov    %edx,(%eax)
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	85 c0                	test   %eax,%eax
  802f74:	74 0d                	je     802f83 <insert_sorted_with_merge_freeList+0x20e>
  802f76:	a1 38 51 80 00       	mov    0x805138,%eax
  802f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f7e:	89 50 04             	mov    %edx,0x4(%eax)
  802f81:	eb 08                	jmp    802f8b <insert_sorted_with_merge_freeList+0x216>
  802f83:	8b 45 08             	mov    0x8(%ebp),%eax
  802f86:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	a3 38 51 80 00       	mov    %eax,0x805138
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9d:	a1 44 51 80 00       	mov    0x805144,%eax
  802fa2:	40                   	inc    %eax
  802fa3:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802fa8:	e9 0e 05 00 00       	jmp    8034bb <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802fad:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb0:	8b 50 08             	mov    0x8(%eax),%edx
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb9:	01 c2                	add    %eax,%edx
  802fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbe:	8b 40 08             	mov    0x8(%eax),%eax
  802fc1:	39 c2                	cmp    %eax,%edx
  802fc3:	0f 85 9c 00 00 00    	jne    803065 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcc:	8b 50 0c             	mov    0xc(%eax),%edx
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd5:	01 c2                	add    %eax,%edx
  802fd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fda:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	8b 50 08             	mov    0x8(%eax),%edx
  802fe3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe6:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ffd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803001:	75 17                	jne    80301a <insert_sorted_with_merge_freeList+0x2a5>
  803003:	83 ec 04             	sub    $0x4,%esp
  803006:	68 54 40 80 00       	push   $0x804054
  80300b:	68 4d 01 00 00       	push   $0x14d
  803010:	68 77 40 80 00       	push   $0x804077
  803015:	e8 81 d7 ff ff       	call   80079b <_panic>
  80301a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803020:	8b 45 08             	mov    0x8(%ebp),%eax
  803023:	89 10                	mov    %edx,(%eax)
  803025:	8b 45 08             	mov    0x8(%ebp),%eax
  803028:	8b 00                	mov    (%eax),%eax
  80302a:	85 c0                	test   %eax,%eax
  80302c:	74 0d                	je     80303b <insert_sorted_with_merge_freeList+0x2c6>
  80302e:	a1 48 51 80 00       	mov    0x805148,%eax
  803033:	8b 55 08             	mov    0x8(%ebp),%edx
  803036:	89 50 04             	mov    %edx,0x4(%eax)
  803039:	eb 08                	jmp    803043 <insert_sorted_with_merge_freeList+0x2ce>
  80303b:	8b 45 08             	mov    0x8(%ebp),%eax
  80303e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	a3 48 51 80 00       	mov    %eax,0x805148
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803055:	a1 54 51 80 00       	mov    0x805154,%eax
  80305a:	40                   	inc    %eax
  80305b:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803060:	e9 56 04 00 00       	jmp    8034bb <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803065:	a1 38 51 80 00       	mov    0x805138,%eax
  80306a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80306d:	e9 19 04 00 00       	jmp    80348b <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  803072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803075:	8b 00                	mov    (%eax),%eax
  803077:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  80307a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307d:	8b 50 08             	mov    0x8(%eax),%edx
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	8b 40 0c             	mov    0xc(%eax),%eax
  803086:	01 c2                	add    %eax,%edx
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	8b 40 08             	mov    0x8(%eax),%eax
  80308e:	39 c2                	cmp    %eax,%edx
  803090:	0f 85 ad 01 00 00    	jne    803243 <insert_sorted_with_merge_freeList+0x4ce>
  803096:	8b 45 08             	mov    0x8(%ebp),%eax
  803099:	8b 50 08             	mov    0x8(%eax),%edx
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a2:	01 c2                	add    %eax,%edx
  8030a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a7:	8b 40 08             	mov    0x8(%eax),%eax
  8030aa:	39 c2                	cmp    %eax,%edx
  8030ac:	0f 85 91 01 00 00    	jne    803243 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  8030b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b5:	8b 50 0c             	mov    0xc(%eax),%edx
  8030b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bb:	8b 48 0c             	mov    0xc(%eax),%ecx
  8030be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c4:	01 c8                	add    %ecx,%eax
  8030c6:	01 c2                	add    %eax,%edx
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  8030e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  8030ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  8030f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030fa:	75 17                	jne    803113 <insert_sorted_with_merge_freeList+0x39e>
  8030fc:	83 ec 04             	sub    $0x4,%esp
  8030ff:	68 e8 40 80 00       	push   $0x8040e8
  803104:	68 5b 01 00 00       	push   $0x15b
  803109:	68 77 40 80 00       	push   $0x804077
  80310e:	e8 88 d6 ff ff       	call   80079b <_panic>
  803113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803116:	8b 00                	mov    (%eax),%eax
  803118:	85 c0                	test   %eax,%eax
  80311a:	74 10                	je     80312c <insert_sorted_with_merge_freeList+0x3b7>
  80311c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80311f:	8b 00                	mov    (%eax),%eax
  803121:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803124:	8b 52 04             	mov    0x4(%edx),%edx
  803127:	89 50 04             	mov    %edx,0x4(%eax)
  80312a:	eb 0b                	jmp    803137 <insert_sorted_with_merge_freeList+0x3c2>
  80312c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312f:	8b 40 04             	mov    0x4(%eax),%eax
  803132:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803137:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313a:	8b 40 04             	mov    0x4(%eax),%eax
  80313d:	85 c0                	test   %eax,%eax
  80313f:	74 0f                	je     803150 <insert_sorted_with_merge_freeList+0x3db>
  803141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803144:	8b 40 04             	mov    0x4(%eax),%eax
  803147:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80314a:	8b 12                	mov    (%edx),%edx
  80314c:	89 10                	mov    %edx,(%eax)
  80314e:	eb 0a                	jmp    80315a <insert_sorted_with_merge_freeList+0x3e5>
  803150:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803153:	8b 00                	mov    (%eax),%eax
  803155:	a3 38 51 80 00       	mov    %eax,0x805138
  80315a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803163:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803166:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316d:	a1 44 51 80 00       	mov    0x805144,%eax
  803172:	48                   	dec    %eax
  803173:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803178:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317c:	75 17                	jne    803195 <insert_sorted_with_merge_freeList+0x420>
  80317e:	83 ec 04             	sub    $0x4,%esp
  803181:	68 54 40 80 00       	push   $0x804054
  803186:	68 5c 01 00 00       	push   $0x15c
  80318b:	68 77 40 80 00       	push   $0x804077
  803190:	e8 06 d6 ff ff       	call   80079b <_panic>
  803195:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	89 10                	mov    %edx,(%eax)
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	8b 00                	mov    (%eax),%eax
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	74 0d                	je     8031b6 <insert_sorted_with_merge_freeList+0x441>
  8031a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b1:	89 50 04             	mov    %edx,0x4(%eax)
  8031b4:	eb 08                	jmp    8031be <insert_sorted_with_merge_freeList+0x449>
  8031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031be:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8031d5:	40                   	inc    %eax
  8031d6:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  8031db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031df:	75 17                	jne    8031f8 <insert_sorted_with_merge_freeList+0x483>
  8031e1:	83 ec 04             	sub    $0x4,%esp
  8031e4:	68 54 40 80 00       	push   $0x804054
  8031e9:	68 5d 01 00 00       	push   $0x15d
  8031ee:	68 77 40 80 00       	push   $0x804077
  8031f3:	e8 a3 d5 ff ff       	call   80079b <_panic>
  8031f8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803201:	89 10                	mov    %edx,(%eax)
  803203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	85 c0                	test   %eax,%eax
  80320a:	74 0d                	je     803219 <insert_sorted_with_merge_freeList+0x4a4>
  80320c:	a1 48 51 80 00       	mov    0x805148,%eax
  803211:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803214:	89 50 04             	mov    %edx,0x4(%eax)
  803217:	eb 08                	jmp    803221 <insert_sorted_with_merge_freeList+0x4ac>
  803219:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80321c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803221:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803224:	a3 48 51 80 00       	mov    %eax,0x805148
  803229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80322c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803233:	a1 54 51 80 00       	mov    0x805154,%eax
  803238:	40                   	inc    %eax
  803239:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80323e:	e9 78 02 00 00       	jmp    8034bb <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803246:	8b 50 08             	mov    0x8(%eax),%edx
  803249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324c:	8b 40 0c             	mov    0xc(%eax),%eax
  80324f:	01 c2                	add    %eax,%edx
  803251:	8b 45 08             	mov    0x8(%ebp),%eax
  803254:	8b 40 08             	mov    0x8(%eax),%eax
  803257:	39 c2                	cmp    %eax,%edx
  803259:	0f 83 b8 00 00 00    	jae    803317 <insert_sorted_with_merge_freeList+0x5a2>
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	8b 50 08             	mov    0x8(%eax),%edx
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	8b 40 0c             	mov    0xc(%eax),%eax
  80326b:	01 c2                	add    %eax,%edx
  80326d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803270:	8b 40 08             	mov    0x8(%eax),%eax
  803273:	39 c2                	cmp    %eax,%edx
  803275:	0f 85 9c 00 00 00    	jne    803317 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  80327b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327e:	8b 50 0c             	mov    0xc(%eax),%edx
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	8b 40 0c             	mov    0xc(%eax),%eax
  803287:	01 c2                	add    %eax,%edx
  803289:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80328c:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  80328f:	8b 45 08             	mov    0x8(%ebp),%eax
  803292:	8b 50 08             	mov    0x8(%eax),%edx
  803295:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803298:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b3:	75 17                	jne    8032cc <insert_sorted_with_merge_freeList+0x557>
  8032b5:	83 ec 04             	sub    $0x4,%esp
  8032b8:	68 54 40 80 00       	push   $0x804054
  8032bd:	68 67 01 00 00       	push   $0x167
  8032c2:	68 77 40 80 00       	push   $0x804077
  8032c7:	e8 cf d4 ff ff       	call   80079b <_panic>
  8032cc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d5:	89 10                	mov    %edx,(%eax)
  8032d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032da:	8b 00                	mov    (%eax),%eax
  8032dc:	85 c0                	test   %eax,%eax
  8032de:	74 0d                	je     8032ed <insert_sorted_with_merge_freeList+0x578>
  8032e0:	a1 48 51 80 00       	mov    0x805148,%eax
  8032e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e8:	89 50 04             	mov    %edx,0x4(%eax)
  8032eb:	eb 08                	jmp    8032f5 <insert_sorted_with_merge_freeList+0x580>
  8032ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	a3 48 51 80 00       	mov    %eax,0x805148
  8032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803300:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803307:	a1 54 51 80 00       	mov    0x805154,%eax
  80330c:	40                   	inc    %eax
  80330d:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803312:	e9 a4 01 00 00       	jmp    8034bb <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331a:	8b 50 08             	mov    0x8(%eax),%edx
  80331d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803320:	8b 40 0c             	mov    0xc(%eax),%eax
  803323:	01 c2                	add    %eax,%edx
  803325:	8b 45 08             	mov    0x8(%ebp),%eax
  803328:	8b 40 08             	mov    0x8(%eax),%eax
  80332b:	39 c2                	cmp    %eax,%edx
  80332d:	0f 85 ac 00 00 00    	jne    8033df <insert_sorted_with_merge_freeList+0x66a>
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	8b 50 08             	mov    0x8(%eax),%edx
  803339:	8b 45 08             	mov    0x8(%ebp),%eax
  80333c:	8b 40 0c             	mov    0xc(%eax),%eax
  80333f:	01 c2                	add    %eax,%edx
  803341:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803344:	8b 40 08             	mov    0x8(%eax),%eax
  803347:	39 c2                	cmp    %eax,%edx
  803349:	0f 83 90 00 00 00    	jae    8033df <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  80334f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803352:	8b 50 0c             	mov    0xc(%eax),%edx
  803355:	8b 45 08             	mov    0x8(%ebp),%eax
  803358:	8b 40 0c             	mov    0xc(%eax),%eax
  80335b:	01 c2                	add    %eax,%edx
  80335d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803360:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  80336d:	8b 45 08             	mov    0x8(%ebp),%eax
  803370:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803377:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80337b:	75 17                	jne    803394 <insert_sorted_with_merge_freeList+0x61f>
  80337d:	83 ec 04             	sub    $0x4,%esp
  803380:	68 54 40 80 00       	push   $0x804054
  803385:	68 70 01 00 00       	push   $0x170
  80338a:	68 77 40 80 00       	push   $0x804077
  80338f:	e8 07 d4 ff ff       	call   80079b <_panic>
  803394:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	89 10                	mov    %edx,(%eax)
  80339f:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a2:	8b 00                	mov    (%eax),%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	74 0d                	je     8033b5 <insert_sorted_with_merge_freeList+0x640>
  8033a8:	a1 48 51 80 00       	mov    0x805148,%eax
  8033ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b0:	89 50 04             	mov    %edx,0x4(%eax)
  8033b3:	eb 08                	jmp    8033bd <insert_sorted_with_merge_freeList+0x648>
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c0:	a3 48 51 80 00       	mov    %eax,0x805148
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033cf:	a1 54 51 80 00       	mov    0x805154,%eax
  8033d4:	40                   	inc    %eax
  8033d5:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  8033da:	e9 dc 00 00 00       	jmp    8034bb <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8033df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e2:	8b 50 08             	mov    0x8(%eax),%edx
  8033e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8033eb:	01 c2                	add    %eax,%edx
  8033ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f0:	8b 40 08             	mov    0x8(%eax),%eax
  8033f3:	39 c2                	cmp    %eax,%edx
  8033f5:	0f 83 88 00 00 00    	jae    803483 <insert_sorted_with_merge_freeList+0x70e>
  8033fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fe:	8b 50 08             	mov    0x8(%eax),%edx
  803401:	8b 45 08             	mov    0x8(%ebp),%eax
  803404:	8b 40 0c             	mov    0xc(%eax),%eax
  803407:	01 c2                	add    %eax,%edx
  803409:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340c:	8b 40 08             	mov    0x8(%eax),%eax
  80340f:	39 c2                	cmp    %eax,%edx
  803411:	73 70                	jae    803483 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803413:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803417:	74 06                	je     80341f <insert_sorted_with_merge_freeList+0x6aa>
  803419:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80341d:	75 17                	jne    803436 <insert_sorted_with_merge_freeList+0x6c1>
  80341f:	83 ec 04             	sub    $0x4,%esp
  803422:	68 b4 40 80 00       	push   $0x8040b4
  803427:	68 75 01 00 00       	push   $0x175
  80342c:	68 77 40 80 00       	push   $0x804077
  803431:	e8 65 d3 ff ff       	call   80079b <_panic>
  803436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803439:	8b 10                	mov    (%eax),%edx
  80343b:	8b 45 08             	mov    0x8(%ebp),%eax
  80343e:	89 10                	mov    %edx,(%eax)
  803440:	8b 45 08             	mov    0x8(%ebp),%eax
  803443:	8b 00                	mov    (%eax),%eax
  803445:	85 c0                	test   %eax,%eax
  803447:	74 0b                	je     803454 <insert_sorted_with_merge_freeList+0x6df>
  803449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344c:	8b 00                	mov    (%eax),%eax
  80344e:	8b 55 08             	mov    0x8(%ebp),%edx
  803451:	89 50 04             	mov    %edx,0x4(%eax)
  803454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803457:	8b 55 08             	mov    0x8(%ebp),%edx
  80345a:	89 10                	mov    %edx,(%eax)
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803462:	89 50 04             	mov    %edx,0x4(%eax)
  803465:	8b 45 08             	mov    0x8(%ebp),%eax
  803468:	8b 00                	mov    (%eax),%eax
  80346a:	85 c0                	test   %eax,%eax
  80346c:	75 08                	jne    803476 <insert_sorted_with_merge_freeList+0x701>
  80346e:	8b 45 08             	mov    0x8(%ebp),%eax
  803471:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803476:	a1 44 51 80 00       	mov    0x805144,%eax
  80347b:	40                   	inc    %eax
  80347c:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  803481:	eb 38                	jmp    8034bb <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803483:	a1 40 51 80 00       	mov    0x805140,%eax
  803488:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80348b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80348f:	74 07                	je     803498 <insert_sorted_with_merge_freeList+0x723>
  803491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803494:	8b 00                	mov    (%eax),%eax
  803496:	eb 05                	jmp    80349d <insert_sorted_with_merge_freeList+0x728>
  803498:	b8 00 00 00 00       	mov    $0x0,%eax
  80349d:	a3 40 51 80 00       	mov    %eax,0x805140
  8034a2:	a1 40 51 80 00       	mov    0x805140,%eax
  8034a7:	85 c0                	test   %eax,%eax
  8034a9:	0f 85 c3 fb ff ff    	jne    803072 <insert_sorted_with_merge_freeList+0x2fd>
  8034af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b3:	0f 85 b9 fb ff ff    	jne    803072 <insert_sorted_with_merge_freeList+0x2fd>





}
  8034b9:	eb 00                	jmp    8034bb <insert_sorted_with_merge_freeList+0x746>
  8034bb:	90                   	nop
  8034bc:	c9                   	leave  
  8034bd:	c3                   	ret    
  8034be:	66 90                	xchg   %ax,%ax

008034c0 <__udivdi3>:
  8034c0:	55                   	push   %ebp
  8034c1:	57                   	push   %edi
  8034c2:	56                   	push   %esi
  8034c3:	53                   	push   %ebx
  8034c4:	83 ec 1c             	sub    $0x1c,%esp
  8034c7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034cb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034d7:	89 ca                	mov    %ecx,%edx
  8034d9:	89 f8                	mov    %edi,%eax
  8034db:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034df:	85 f6                	test   %esi,%esi
  8034e1:	75 2d                	jne    803510 <__udivdi3+0x50>
  8034e3:	39 cf                	cmp    %ecx,%edi
  8034e5:	77 65                	ja     80354c <__udivdi3+0x8c>
  8034e7:	89 fd                	mov    %edi,%ebp
  8034e9:	85 ff                	test   %edi,%edi
  8034eb:	75 0b                	jne    8034f8 <__udivdi3+0x38>
  8034ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8034f2:	31 d2                	xor    %edx,%edx
  8034f4:	f7 f7                	div    %edi
  8034f6:	89 c5                	mov    %eax,%ebp
  8034f8:	31 d2                	xor    %edx,%edx
  8034fa:	89 c8                	mov    %ecx,%eax
  8034fc:	f7 f5                	div    %ebp
  8034fe:	89 c1                	mov    %eax,%ecx
  803500:	89 d8                	mov    %ebx,%eax
  803502:	f7 f5                	div    %ebp
  803504:	89 cf                	mov    %ecx,%edi
  803506:	89 fa                	mov    %edi,%edx
  803508:	83 c4 1c             	add    $0x1c,%esp
  80350b:	5b                   	pop    %ebx
  80350c:	5e                   	pop    %esi
  80350d:	5f                   	pop    %edi
  80350e:	5d                   	pop    %ebp
  80350f:	c3                   	ret    
  803510:	39 ce                	cmp    %ecx,%esi
  803512:	77 28                	ja     80353c <__udivdi3+0x7c>
  803514:	0f bd fe             	bsr    %esi,%edi
  803517:	83 f7 1f             	xor    $0x1f,%edi
  80351a:	75 40                	jne    80355c <__udivdi3+0x9c>
  80351c:	39 ce                	cmp    %ecx,%esi
  80351e:	72 0a                	jb     80352a <__udivdi3+0x6a>
  803520:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803524:	0f 87 9e 00 00 00    	ja     8035c8 <__udivdi3+0x108>
  80352a:	b8 01 00 00 00       	mov    $0x1,%eax
  80352f:	89 fa                	mov    %edi,%edx
  803531:	83 c4 1c             	add    $0x1c,%esp
  803534:	5b                   	pop    %ebx
  803535:	5e                   	pop    %esi
  803536:	5f                   	pop    %edi
  803537:	5d                   	pop    %ebp
  803538:	c3                   	ret    
  803539:	8d 76 00             	lea    0x0(%esi),%esi
  80353c:	31 ff                	xor    %edi,%edi
  80353e:	31 c0                	xor    %eax,%eax
  803540:	89 fa                	mov    %edi,%edx
  803542:	83 c4 1c             	add    $0x1c,%esp
  803545:	5b                   	pop    %ebx
  803546:	5e                   	pop    %esi
  803547:	5f                   	pop    %edi
  803548:	5d                   	pop    %ebp
  803549:	c3                   	ret    
  80354a:	66 90                	xchg   %ax,%ax
  80354c:	89 d8                	mov    %ebx,%eax
  80354e:	f7 f7                	div    %edi
  803550:	31 ff                	xor    %edi,%edi
  803552:	89 fa                	mov    %edi,%edx
  803554:	83 c4 1c             	add    $0x1c,%esp
  803557:	5b                   	pop    %ebx
  803558:	5e                   	pop    %esi
  803559:	5f                   	pop    %edi
  80355a:	5d                   	pop    %ebp
  80355b:	c3                   	ret    
  80355c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803561:	89 eb                	mov    %ebp,%ebx
  803563:	29 fb                	sub    %edi,%ebx
  803565:	89 f9                	mov    %edi,%ecx
  803567:	d3 e6                	shl    %cl,%esi
  803569:	89 c5                	mov    %eax,%ebp
  80356b:	88 d9                	mov    %bl,%cl
  80356d:	d3 ed                	shr    %cl,%ebp
  80356f:	89 e9                	mov    %ebp,%ecx
  803571:	09 f1                	or     %esi,%ecx
  803573:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803577:	89 f9                	mov    %edi,%ecx
  803579:	d3 e0                	shl    %cl,%eax
  80357b:	89 c5                	mov    %eax,%ebp
  80357d:	89 d6                	mov    %edx,%esi
  80357f:	88 d9                	mov    %bl,%cl
  803581:	d3 ee                	shr    %cl,%esi
  803583:	89 f9                	mov    %edi,%ecx
  803585:	d3 e2                	shl    %cl,%edx
  803587:	8b 44 24 08          	mov    0x8(%esp),%eax
  80358b:	88 d9                	mov    %bl,%cl
  80358d:	d3 e8                	shr    %cl,%eax
  80358f:	09 c2                	or     %eax,%edx
  803591:	89 d0                	mov    %edx,%eax
  803593:	89 f2                	mov    %esi,%edx
  803595:	f7 74 24 0c          	divl   0xc(%esp)
  803599:	89 d6                	mov    %edx,%esi
  80359b:	89 c3                	mov    %eax,%ebx
  80359d:	f7 e5                	mul    %ebp
  80359f:	39 d6                	cmp    %edx,%esi
  8035a1:	72 19                	jb     8035bc <__udivdi3+0xfc>
  8035a3:	74 0b                	je     8035b0 <__udivdi3+0xf0>
  8035a5:	89 d8                	mov    %ebx,%eax
  8035a7:	31 ff                	xor    %edi,%edi
  8035a9:	e9 58 ff ff ff       	jmp    803506 <__udivdi3+0x46>
  8035ae:	66 90                	xchg   %ax,%ax
  8035b0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035b4:	89 f9                	mov    %edi,%ecx
  8035b6:	d3 e2                	shl    %cl,%edx
  8035b8:	39 c2                	cmp    %eax,%edx
  8035ba:	73 e9                	jae    8035a5 <__udivdi3+0xe5>
  8035bc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035bf:	31 ff                	xor    %edi,%edi
  8035c1:	e9 40 ff ff ff       	jmp    803506 <__udivdi3+0x46>
  8035c6:	66 90                	xchg   %ax,%ax
  8035c8:	31 c0                	xor    %eax,%eax
  8035ca:	e9 37 ff ff ff       	jmp    803506 <__udivdi3+0x46>
  8035cf:	90                   	nop

008035d0 <__umoddi3>:
  8035d0:	55                   	push   %ebp
  8035d1:	57                   	push   %edi
  8035d2:	56                   	push   %esi
  8035d3:	53                   	push   %ebx
  8035d4:	83 ec 1c             	sub    $0x1c,%esp
  8035d7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035db:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035e3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035ef:	89 f3                	mov    %esi,%ebx
  8035f1:	89 fa                	mov    %edi,%edx
  8035f3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035f7:	89 34 24             	mov    %esi,(%esp)
  8035fa:	85 c0                	test   %eax,%eax
  8035fc:	75 1a                	jne    803618 <__umoddi3+0x48>
  8035fe:	39 f7                	cmp    %esi,%edi
  803600:	0f 86 a2 00 00 00    	jbe    8036a8 <__umoddi3+0xd8>
  803606:	89 c8                	mov    %ecx,%eax
  803608:	89 f2                	mov    %esi,%edx
  80360a:	f7 f7                	div    %edi
  80360c:	89 d0                	mov    %edx,%eax
  80360e:	31 d2                	xor    %edx,%edx
  803610:	83 c4 1c             	add    $0x1c,%esp
  803613:	5b                   	pop    %ebx
  803614:	5e                   	pop    %esi
  803615:	5f                   	pop    %edi
  803616:	5d                   	pop    %ebp
  803617:	c3                   	ret    
  803618:	39 f0                	cmp    %esi,%eax
  80361a:	0f 87 ac 00 00 00    	ja     8036cc <__umoddi3+0xfc>
  803620:	0f bd e8             	bsr    %eax,%ebp
  803623:	83 f5 1f             	xor    $0x1f,%ebp
  803626:	0f 84 ac 00 00 00    	je     8036d8 <__umoddi3+0x108>
  80362c:	bf 20 00 00 00       	mov    $0x20,%edi
  803631:	29 ef                	sub    %ebp,%edi
  803633:	89 fe                	mov    %edi,%esi
  803635:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803639:	89 e9                	mov    %ebp,%ecx
  80363b:	d3 e0                	shl    %cl,%eax
  80363d:	89 d7                	mov    %edx,%edi
  80363f:	89 f1                	mov    %esi,%ecx
  803641:	d3 ef                	shr    %cl,%edi
  803643:	09 c7                	or     %eax,%edi
  803645:	89 e9                	mov    %ebp,%ecx
  803647:	d3 e2                	shl    %cl,%edx
  803649:	89 14 24             	mov    %edx,(%esp)
  80364c:	89 d8                	mov    %ebx,%eax
  80364e:	d3 e0                	shl    %cl,%eax
  803650:	89 c2                	mov    %eax,%edx
  803652:	8b 44 24 08          	mov    0x8(%esp),%eax
  803656:	d3 e0                	shl    %cl,%eax
  803658:	89 44 24 04          	mov    %eax,0x4(%esp)
  80365c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803660:	89 f1                	mov    %esi,%ecx
  803662:	d3 e8                	shr    %cl,%eax
  803664:	09 d0                	or     %edx,%eax
  803666:	d3 eb                	shr    %cl,%ebx
  803668:	89 da                	mov    %ebx,%edx
  80366a:	f7 f7                	div    %edi
  80366c:	89 d3                	mov    %edx,%ebx
  80366e:	f7 24 24             	mull   (%esp)
  803671:	89 c6                	mov    %eax,%esi
  803673:	89 d1                	mov    %edx,%ecx
  803675:	39 d3                	cmp    %edx,%ebx
  803677:	0f 82 87 00 00 00    	jb     803704 <__umoddi3+0x134>
  80367d:	0f 84 91 00 00 00    	je     803714 <__umoddi3+0x144>
  803683:	8b 54 24 04          	mov    0x4(%esp),%edx
  803687:	29 f2                	sub    %esi,%edx
  803689:	19 cb                	sbb    %ecx,%ebx
  80368b:	89 d8                	mov    %ebx,%eax
  80368d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803691:	d3 e0                	shl    %cl,%eax
  803693:	89 e9                	mov    %ebp,%ecx
  803695:	d3 ea                	shr    %cl,%edx
  803697:	09 d0                	or     %edx,%eax
  803699:	89 e9                	mov    %ebp,%ecx
  80369b:	d3 eb                	shr    %cl,%ebx
  80369d:	89 da                	mov    %ebx,%edx
  80369f:	83 c4 1c             	add    $0x1c,%esp
  8036a2:	5b                   	pop    %ebx
  8036a3:	5e                   	pop    %esi
  8036a4:	5f                   	pop    %edi
  8036a5:	5d                   	pop    %ebp
  8036a6:	c3                   	ret    
  8036a7:	90                   	nop
  8036a8:	89 fd                	mov    %edi,%ebp
  8036aa:	85 ff                	test   %edi,%edi
  8036ac:	75 0b                	jne    8036b9 <__umoddi3+0xe9>
  8036ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8036b3:	31 d2                	xor    %edx,%edx
  8036b5:	f7 f7                	div    %edi
  8036b7:	89 c5                	mov    %eax,%ebp
  8036b9:	89 f0                	mov    %esi,%eax
  8036bb:	31 d2                	xor    %edx,%edx
  8036bd:	f7 f5                	div    %ebp
  8036bf:	89 c8                	mov    %ecx,%eax
  8036c1:	f7 f5                	div    %ebp
  8036c3:	89 d0                	mov    %edx,%eax
  8036c5:	e9 44 ff ff ff       	jmp    80360e <__umoddi3+0x3e>
  8036ca:	66 90                	xchg   %ax,%ax
  8036cc:	89 c8                	mov    %ecx,%eax
  8036ce:	89 f2                	mov    %esi,%edx
  8036d0:	83 c4 1c             	add    $0x1c,%esp
  8036d3:	5b                   	pop    %ebx
  8036d4:	5e                   	pop    %esi
  8036d5:	5f                   	pop    %edi
  8036d6:	5d                   	pop    %ebp
  8036d7:	c3                   	ret    
  8036d8:	3b 04 24             	cmp    (%esp),%eax
  8036db:	72 06                	jb     8036e3 <__umoddi3+0x113>
  8036dd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036e1:	77 0f                	ja     8036f2 <__umoddi3+0x122>
  8036e3:	89 f2                	mov    %esi,%edx
  8036e5:	29 f9                	sub    %edi,%ecx
  8036e7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036eb:	89 14 24             	mov    %edx,(%esp)
  8036ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036f2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036f6:	8b 14 24             	mov    (%esp),%edx
  8036f9:	83 c4 1c             	add    $0x1c,%esp
  8036fc:	5b                   	pop    %ebx
  8036fd:	5e                   	pop    %esi
  8036fe:	5f                   	pop    %edi
  8036ff:	5d                   	pop    %ebp
  803700:	c3                   	ret    
  803701:	8d 76 00             	lea    0x0(%esi),%esi
  803704:	2b 04 24             	sub    (%esp),%eax
  803707:	19 fa                	sbb    %edi,%edx
  803709:	89 d1                	mov    %edx,%ecx
  80370b:	89 c6                	mov    %eax,%esi
  80370d:	e9 71 ff ff ff       	jmp    803683 <__umoddi3+0xb3>
  803712:	66 90                	xchg   %ax,%ax
  803714:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803718:	72 ea                	jb     803704 <__umoddi3+0x134>
  80371a:	89 d9                	mov    %ebx,%ecx
  80371c:	e9 62 ff ff ff       	jmp    803683 <__umoddi3+0xb3>
