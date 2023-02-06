
obj/user/tst_realloc_1:     file format elf32-i386


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
  800031:	e8 38 11 00 00       	call   80116e <libmain>
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
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 55 80             	lea    -0x80(%ebp),%edx
  800051:	b9 14 00 00 00       	mov    $0x14,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 40 42 80 00       	push   $0x804240
  800067:	e8 f2 14 00 00       	call   80155e <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 a2 28 00 00       	call   802916 <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 3a 29 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  80007f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800082:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800085:	83 ec 0c             	sub    $0xc,%esp
  800088:	50                   	push   %eax
  800089:	e8 49 24 00 00       	call   8024d7 <malloc>
  80008e:	83 c4 10             	add    $0x10,%esp
  800091:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800094:	8b 45 80             	mov    -0x80(%ebp),%eax
  800097:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80009c:	74 14                	je     8000b2 <_main+0x7a>
  80009e:	83 ec 04             	sub    $0x4,%esp
  8000a1:	68 64 42 80 00       	push   $0x804264
  8000a6:	6a 11                	push   $0x11
  8000a8:	68 94 42 80 00       	push   $0x804294
  8000ad:	e8 f8 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000b2:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000b5:	e8 5c 28 00 00       	call   802916 <sys_calculate_free_frames>
  8000ba:	29 c3                	sub    %eax,%ebx
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	83 f8 01             	cmp    $0x1,%eax
  8000c1:	74 14                	je     8000d7 <_main+0x9f>
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	68 ac 42 80 00       	push   $0x8042ac
  8000cb:	6a 13                	push   $0x13
  8000cd:	68 94 42 80 00       	push   $0x804294
  8000d2:	e8 d3 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256)panic("Extra or less pages are allocated in PageFile");
  8000d7:	e8 da 28 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  8000dc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000df:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 18 43 80 00       	push   $0x804318
  8000ee:	6a 14                	push   $0x14
  8000f0:	68 94 42 80 00       	push   $0x804294
  8000f5:	e8 b0 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000fa:	e8 17 28 00 00       	call   802916 <sys_calculate_free_frames>
  8000ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800102:	e8 af 28 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80010a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80010d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 be 23 00 00       	call   8024d7 <malloc>
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80011f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800122:	89 c2                	mov    %eax,%edx
  800124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800127:	05 00 00 00 80       	add    $0x80000000,%eax
  80012c:	39 c2                	cmp    %eax,%edx
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 64 42 80 00       	push   $0x804264
  800138:	6a 19                	push   $0x19
  80013a:	68 94 42 80 00       	push   $0x804294
  80013f:	e8 66 11 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800144:	e8 cd 27 00 00       	call   802916 <sys_calculate_free_frames>
  800149:	89 c2                	mov    %eax,%edx
  80014b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014e:	39 c2                	cmp    %eax,%edx
  800150:	74 14                	je     800166 <_main+0x12e>
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	68 ac 42 80 00       	push   $0x8042ac
  80015a:	6a 1b                	push   $0x1b
  80015c:	68 94 42 80 00       	push   $0x804294
  800161:	e8 44 11 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800166:	e8 4b 28 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  80016b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80016e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 18 43 80 00       	push   $0x804318
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 94 42 80 00       	push   $0x804294
  800184:	e8 21 11 00 00       	call   8012aa <_panic>
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800189:	e8 88 27 00 00       	call   802916 <sys_calculate_free_frames>
  80018e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800191:	e8 20 28 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800196:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80019c:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	50                   	push   %eax
  8001a3:	e8 2f 23 00 00       	call   8024d7 <malloc>
  8001a8:	83 c4 10             	add    $0x10,%esp
  8001ab:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001ae:	8b 45 88             	mov    -0x78(%ebp),%eax
  8001b1:	89 c2                	mov    %eax,%edx
  8001b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b6:	01 c0                	add    %eax,%eax
  8001b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 64 42 80 00       	push   $0x804264
  8001c9:	6a 21                	push   $0x21
  8001cb:	68 94 42 80 00       	push   $0x804294
  8001d0:	e8 d5 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001d5:	e8 3c 27 00 00       	call   802916 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 ac 42 80 00       	push   $0x8042ac
  8001eb:	6a 23                	push   $0x23
  8001ed:	68 94 42 80 00       	push   $0x804294
  8001f2:	e8 b3 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8001f7:	e8 ba 27 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  8001fc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ff:	3d 00 01 00 00       	cmp    $0x100,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 18 43 80 00       	push   $0x804318
  80020e:	6a 24                	push   $0x24
  800210:	68 94 42 80 00       	push   $0x804294
  800215:	e8 90 10 00 00       	call   8012aa <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80021a:	e8 f7 26 00 00       	call   802916 <sys_calculate_free_frames>
  80021f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800222:	e8 8f 27 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  80022a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80022d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	50                   	push   %eax
  800234:	e8 9e 22 00 00       	call   8024d7 <malloc>
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80023f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800242:	89 c1                	mov    %eax,%ecx
  800244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800247:	89 c2                	mov    %eax,%edx
  800249:	01 d2                	add    %edx,%edx
  80024b:	01 d0                	add    %edx,%eax
  80024d:	05 00 00 00 80       	add    $0x80000000,%eax
  800252:	39 c1                	cmp    %eax,%ecx
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 64 42 80 00       	push   $0x804264
  80025e:	6a 2a                	push   $0x2a
  800260:	68 94 42 80 00       	push   $0x804294
  800265:	e8 40 10 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80026a:	e8 a7 26 00 00       	call   802916 <sys_calculate_free_frames>
  80026f:	89 c2                	mov    %eax,%edx
  800271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800274:	39 c2                	cmp    %eax,%edx
  800276:	74 14                	je     80028c <_main+0x254>
  800278:	83 ec 04             	sub    $0x4,%esp
  80027b:	68 ac 42 80 00       	push   $0x8042ac
  800280:	6a 2c                	push   $0x2c
  800282:	68 94 42 80 00       	push   $0x804294
  800287:	e8 1e 10 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80028c:	e8 25 27 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800291:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800294:	3d 00 01 00 00       	cmp    $0x100,%eax
  800299:	74 14                	je     8002af <_main+0x277>
  80029b:	83 ec 04             	sub    $0x4,%esp
  80029e:	68 18 43 80 00       	push   $0x804318
  8002a3:	6a 2d                	push   $0x2d
  8002a5:	68 94 42 80 00       	push   $0x804294
  8002aa:	e8 fb 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002af:	e8 62 26 00 00       	call   802916 <sys_calculate_free_frames>
  8002b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002b7:	e8 fa 26 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  8002bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c2:	01 c0                	add    %eax,%eax
  8002c4:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8002c7:	83 ec 0c             	sub    $0xc,%esp
  8002ca:	50                   	push   %eax
  8002cb:	e8 07 22 00 00       	call   8024d7 <malloc>
  8002d0:	83 c4 10             	add    $0x10,%esp
  8002d3:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002d6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002d9:	89 c2                	mov    %eax,%edx
  8002db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002de:	c1 e0 02             	shl    $0x2,%eax
  8002e1:	05 00 00 00 80       	add    $0x80000000,%eax
  8002e6:	39 c2                	cmp    %eax,%edx
  8002e8:	74 14                	je     8002fe <_main+0x2c6>
  8002ea:	83 ec 04             	sub    $0x4,%esp
  8002ed:	68 64 42 80 00       	push   $0x804264
  8002f2:	6a 33                	push   $0x33
  8002f4:	68 94 42 80 00       	push   $0x804294
  8002f9:	e8 ac 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800301:	e8 10 26 00 00       	call   802916 <sys_calculate_free_frames>
  800306:	29 c3                	sub    %eax,%ebx
  800308:	89 d8                	mov    %ebx,%eax
  80030a:	83 f8 01             	cmp    $0x1,%eax
  80030d:	74 14                	je     800323 <_main+0x2eb>
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	68 ac 42 80 00       	push   $0x8042ac
  800317:	6a 35                	push   $0x35
  800319:	68 94 42 80 00       	push   $0x804294
  80031e:	e8 87 0f 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800323:	e8 8e 26 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800328:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800330:	74 14                	je     800346 <_main+0x30e>
  800332:	83 ec 04             	sub    $0x4,%esp
  800335:	68 18 43 80 00       	push   $0x804318
  80033a:	6a 36                	push   $0x36
  80033c:	68 94 42 80 00       	push   $0x804294
  800341:	e8 64 0f 00 00       	call   8012aa <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800346:	e8 cb 25 00 00       	call   802916 <sys_calculate_free_frames>
  80034b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80034e:	e8 63 26 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800359:	01 c0                	add    %eax,%eax
  80035b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  80035e:	83 ec 0c             	sub    $0xc,%esp
  800361:	50                   	push   %eax
  800362:	e8 70 21 00 00       	call   8024d7 <malloc>
  800367:	83 c4 10             	add    $0x10,%esp
  80036a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80036d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800370:	89 c1                	mov    %eax,%ecx
  800372:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800375:	89 d0                	mov    %edx,%eax
  800377:	01 c0                	add    %eax,%eax
  800379:	01 d0                	add    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	05 00 00 00 80       	add    $0x80000000,%eax
  800382:	39 c1                	cmp    %eax,%ecx
  800384:	74 14                	je     80039a <_main+0x362>
  800386:	83 ec 04             	sub    $0x4,%esp
  800389:	68 64 42 80 00       	push   $0x804264
  80038e:	6a 3c                	push   $0x3c
  800390:	68 94 42 80 00       	push   $0x804294
  800395:	e8 10 0f 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80039a:	e8 77 25 00 00       	call   802916 <sys_calculate_free_frames>
  80039f:	89 c2                	mov    %eax,%edx
  8003a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003a4:	39 c2                	cmp    %eax,%edx
  8003a6:	74 14                	je     8003bc <_main+0x384>
  8003a8:	83 ec 04             	sub    $0x4,%esp
  8003ab:	68 ac 42 80 00       	push   $0x8042ac
  8003b0:	6a 3e                	push   $0x3e
  8003b2:	68 94 42 80 00       	push   $0x804294
  8003b7:	e8 ee 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003bc:	e8 f5 25 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  8003c1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8003c4:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003c9:	74 14                	je     8003df <_main+0x3a7>
  8003cb:	83 ec 04             	sub    $0x4,%esp
  8003ce:	68 18 43 80 00       	push   $0x804318
  8003d3:	6a 3f                	push   $0x3f
  8003d5:	68 94 42 80 00       	push   $0x804294
  8003da:	e8 cb 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003df:	e8 32 25 00 00       	call   802916 <sys_calculate_free_frames>
  8003e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003e7:	e8 ca 25 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  8003ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	89 c2                	mov    %eax,%edx
  8003f4:	01 d2                	add    %edx,%edx
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8003fb:	83 ec 0c             	sub    $0xc,%esp
  8003fe:	50                   	push   %eax
  8003ff:	e8 d3 20 00 00       	call   8024d7 <malloc>
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80040a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80040d:	89 c2                	mov    %eax,%edx
  80040f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800412:	c1 e0 03             	shl    $0x3,%eax
  800415:	05 00 00 00 80       	add    $0x80000000,%eax
  80041a:	39 c2                	cmp    %eax,%edx
  80041c:	74 14                	je     800432 <_main+0x3fa>
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	68 64 42 80 00       	push   $0x804264
  800426:	6a 45                	push   $0x45
  800428:	68 94 42 80 00       	push   $0x804294
  80042d:	e8 78 0e 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800432:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800435:	e8 dc 24 00 00       	call   802916 <sys_calculate_free_frames>
  80043a:	29 c3                	sub    %eax,%ebx
  80043c:	89 d8                	mov    %ebx,%eax
  80043e:	83 f8 01             	cmp    $0x1,%eax
  800441:	74 14                	je     800457 <_main+0x41f>
  800443:	83 ec 04             	sub    $0x4,%esp
  800446:	68 ac 42 80 00       	push   $0x8042ac
  80044b:	6a 47                	push   $0x47
  80044d:	68 94 42 80 00       	push   $0x804294
  800452:	e8 53 0e 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800457:	e8 5a 25 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  80045c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80045f:	3d 00 03 00 00       	cmp    $0x300,%eax
  800464:	74 14                	je     80047a <_main+0x442>
  800466:	83 ec 04             	sub    $0x4,%esp
  800469:	68 18 43 80 00       	push   $0x804318
  80046e:	6a 48                	push   $0x48
  800470:	68 94 42 80 00       	push   $0x804294
  800475:	e8 30 0e 00 00       	call   8012aa <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80047a:	e8 97 24 00 00       	call   802916 <sys_calculate_free_frames>
  80047f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800482:	e8 2f 25 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  80048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048d:	89 c2                	mov    %eax,%edx
  80048f:	01 d2                	add    %edx,%edx
  800491:	01 d0                	add    %edx,%eax
  800493:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	50                   	push   %eax
  80049a:	e8 38 20 00 00       	call   8024d7 <malloc>
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004a5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004a8:	89 c1                	mov    %eax,%ecx
  8004aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8004ad:	89 d0                	mov    %edx,%eax
  8004af:	c1 e0 02             	shl    $0x2,%eax
  8004b2:	01 d0                	add    %edx,%eax
  8004b4:	01 c0                	add    %eax,%eax
  8004b6:	01 d0                	add    %edx,%eax
  8004b8:	05 00 00 00 80       	add    $0x80000000,%eax
  8004bd:	39 c1                	cmp    %eax,%ecx
  8004bf:	74 14                	je     8004d5 <_main+0x49d>
  8004c1:	83 ec 04             	sub    $0x4,%esp
  8004c4:	68 64 42 80 00       	push   $0x804264
  8004c9:	6a 4e                	push   $0x4e
  8004cb:	68 94 42 80 00       	push   $0x804294
  8004d0:	e8 d5 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8004d8:	e8 39 24 00 00       	call   802916 <sys_calculate_free_frames>
  8004dd:	29 c3                	sub    %eax,%ebx
  8004df:	89 d8                	mov    %ebx,%eax
  8004e1:	83 f8 01             	cmp    $0x1,%eax
  8004e4:	74 14                	je     8004fa <_main+0x4c2>
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	68 ac 42 80 00       	push   $0x8042ac
  8004ee:	6a 50                	push   $0x50
  8004f0:	68 94 42 80 00       	push   $0x804294
  8004f5:	e8 b0 0d 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  8004fa:	e8 b7 24 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  8004ff:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800502:	3d 00 03 00 00       	cmp    $0x300,%eax
  800507:	74 14                	je     80051d <_main+0x4e5>
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	68 18 43 80 00       	push   $0x804318
  800511:	6a 51                	push   $0x51
  800513:	68 94 42 80 00       	push   $0x804294
  800518:	e8 8d 0d 00 00       	call   8012aa <_panic>


		//NEW
		//Filling the remaining size of user heap
		freeFrames = sys_calculate_free_frames() ;
  80051d:	e8 f4 23 00 00       	call   802916 <sys_calculate_free_frames>
  800522:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800525:	e8 8c 24 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  80052a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		uint32 remainingSpaceInUHeap = (USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega;
  80052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800530:	89 d0                	mov    %edx,%eax
  800532:	01 c0                	add    %eax,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	01 c0                	add    %eax,%eax
  800538:	01 d0                	add    %edx,%eax
  80053a:	01 c0                	add    %eax,%eax
  80053c:	f7 d8                	neg    %eax
  80053e:	05 00 00 00 20       	add    $0x20000000,%eax
  800543:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(remainingSpaceInUHeap - kilo);
  800546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800549:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054c:	29 c2                	sub    %eax,%edx
  80054e:	89 d0                	mov    %edx,%eax
  800550:	83 ec 0c             	sub    $0xc,%esp
  800553:	50                   	push   %eax
  800554:	e8 7e 1f 00 00       	call   8024d7 <malloc>
  800559:	83 c4 10             	add    $0x10,%esp
  80055c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80055f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800562:	89 c1                	mov    %eax,%ecx
  800564:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800567:	89 d0                	mov    %edx,%eax
  800569:	01 c0                	add    %eax,%eax
  80056b:	01 d0                	add    %edx,%eax
  80056d:	01 c0                	add    %eax,%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	01 c0                	add    %eax,%eax
  800573:	05 00 00 00 80       	add    $0x80000000,%eax
  800578:	39 c1                	cmp    %eax,%ecx
  80057a:	74 14                	je     800590 <_main+0x558>
  80057c:	83 ec 04             	sub    $0x4,%esp
  80057f:	68 64 42 80 00       	push   $0x804264
  800584:	6a 5a                	push   $0x5a
  800586:	68 94 42 80 00       	push   $0x804294
  80058b:	e8 1a 0d 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800590:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800593:	e8 7e 23 00 00       	call   802916 <sys_calculate_free_frames>
  800598:	29 c3                	sub    %eax,%ebx
  80059a:	89 d8                	mov    %ebx,%eax
  80059c:	83 f8 7c             	cmp    $0x7c,%eax
  80059f:	74 14                	je     8005b5 <_main+0x57d>
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	68 ac 42 80 00       	push   $0x8042ac
  8005a9:	6a 5c                	push   $0x5c
  8005ab:	68 94 42 80 00       	push   $0x804294
  8005b0:	e8 f5 0c 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005b5:	e8 fc 23 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  8005ba:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8005bd:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005c2:	74 14                	je     8005d8 <_main+0x5a0>
  8005c4:	83 ec 04             	sub    $0x4,%esp
  8005c7:	68 18 43 80 00       	push   $0x804318
  8005cc:	6a 5d                	push   $0x5d
  8005ce:	68 94 42 80 00       	push   $0x804294
  8005d3:	e8 d2 0c 00 00       	call   8012aa <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d8:	e8 39 23 00 00       	call   802916 <sys_calculate_free_frames>
  8005dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005e0:	e8 d1 23 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  8005e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[1]);
  8005e8:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005eb:	83 ec 0c             	sub    $0xc,%esp
  8005ee:	50                   	push   %eax
  8005ef:	e8 7a 1f 00 00       	call   80256e <free>
  8005f4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  8005f7:	e8 ba 23 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  8005fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005ff:	29 c2                	sub    %eax,%edx
  800601:	89 d0                	mov    %edx,%eax
  800603:	3d 00 01 00 00       	cmp    $0x100,%eax
  800608:	74 14                	je     80061e <_main+0x5e6>
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	68 48 43 80 00       	push   $0x804348
  800612:	6a 68                	push   $0x68
  800614:	68 94 42 80 00       	push   $0x804294
  800619:	e8 8c 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80061e:	e8 f3 22 00 00       	call   802916 <sys_calculate_free_frames>
  800623:	89 c2                	mov    %eax,%edx
  800625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800628:	39 c2                	cmp    %eax,%edx
  80062a:	74 14                	je     800640 <_main+0x608>
  80062c:	83 ec 04             	sub    $0x4,%esp
  80062f:	68 84 43 80 00       	push   $0x804384
  800634:	6a 69                	push   $0x69
  800636:	68 94 42 80 00       	push   $0x804294
  80063b:	e8 6a 0c 00 00       	call   8012aa <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800640:	e8 d1 22 00 00       	call   802916 <sys_calculate_free_frames>
  800645:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800648:	e8 69 23 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[4]);
  800650:	8b 45 90             	mov    -0x70(%ebp),%eax
  800653:	83 ec 0c             	sub    $0xc,%esp
  800656:	50                   	push   %eax
  800657:	e8 12 1f 00 00       	call   80256e <free>
  80065c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80065f:	e8 52 23 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800664:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800667:	29 c2                	sub    %eax,%edx
  800669:	89 d0                	mov    %edx,%eax
  80066b:	3d 00 02 00 00       	cmp    $0x200,%eax
  800670:	74 14                	je     800686 <_main+0x64e>
  800672:	83 ec 04             	sub    $0x4,%esp
  800675:	68 48 43 80 00       	push   $0x804348
  80067a:	6a 70                	push   $0x70
  80067c:	68 94 42 80 00       	push   $0x804294
  800681:	e8 24 0c 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800686:	e8 8b 22 00 00       	call   802916 <sys_calculate_free_frames>
  80068b:	89 c2                	mov    %eax,%edx
  80068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800690:	39 c2                	cmp    %eax,%edx
  800692:	74 14                	je     8006a8 <_main+0x670>
  800694:	83 ec 04             	sub    $0x4,%esp
  800697:	68 84 43 80 00       	push   $0x804384
  80069c:	6a 71                	push   $0x71
  80069e:	68 94 42 80 00       	push   $0x804294
  8006a3:	e8 02 0c 00 00       	call   8012aa <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006a8:	e8 69 22 00 00       	call   802916 <sys_calculate_free_frames>
  8006ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006b0:	e8 01 23 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  8006b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[6]);
  8006b8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8006bb:	83 ec 0c             	sub    $0xc,%esp
  8006be:	50                   	push   %eax
  8006bf:	e8 aa 1e 00 00       	call   80256e <free>
  8006c4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006c7:	e8 ea 22 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  8006cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006cf:	29 c2                	sub    %eax,%edx
  8006d1:	89 d0                	mov    %edx,%eax
  8006d3:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006d8:	74 14                	je     8006ee <_main+0x6b6>
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	68 48 43 80 00       	push   $0x804348
  8006e2:	6a 78                	push   $0x78
  8006e4:	68 94 42 80 00       	push   $0x804294
  8006e9:	e8 bc 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006ee:	e8 23 22 00 00       	call   802916 <sys_calculate_free_frames>
  8006f3:	89 c2                	mov    %eax,%edx
  8006f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006f8:	39 c2                	cmp    %eax,%edx
  8006fa:	74 14                	je     800710 <_main+0x6d8>
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	68 84 43 80 00       	push   $0x804384
  800704:	6a 79                	push   $0x79
  800706:	68 94 42 80 00       	push   $0x804294
  80070b:	e8 9a 0b 00 00       	call   8012aa <_panic>

		//NEW
		//free the latest Hole (the big one)
		freeFrames = sys_calculate_free_frames() ;
  800710:	e8 01 22 00 00       	call   802916 <sys_calculate_free_frames>
  800715:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800718:	e8 99 22 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  80071d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[8]);
  800720:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800723:	83 ec 0c             	sub    $0xc,%esp
  800726:	50                   	push   %eax
  800727:	e8 42 1e 00 00       	call   80256e <free>
  80072c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
  80072f:	e8 82 22 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800734:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800737:	29 c2                	sub    %eax,%edx
  800739:	89 d0                	mov    %edx,%eax
  80073b:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  800740:	74 17                	je     800759 <_main+0x721>
  800742:	83 ec 04             	sub    $0x4,%esp
  800745:	68 48 43 80 00       	push   $0x804348
  80074a:	68 81 00 00 00       	push   $0x81
  80074f:	68 94 42 80 00       	push   $0x804294
  800754:	e8 51 0b 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800759:	e8 b8 21 00 00       	call   802916 <sys_calculate_free_frames>
  80075e:	89 c2                	mov    %eax,%edx
  800760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800763:	39 c2                	cmp    %eax,%edx
  800765:	74 17                	je     80077e <_main+0x746>
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	68 84 43 80 00       	push   $0x804384
  80076f:	68 82 00 00 00       	push   $0x82
  800774:	68 94 42 80 00       	push   $0x804294
  800779:	e8 2c 0b 00 00       	call   8012aa <_panic>
	}
	int cnt = 0;
  80077e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate that's fit in the same location*/

		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800785:	e8 8c 21 00 00       	call   802916 <sys_calculate_free_frames>
  80078a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80078d:	e8 24 22 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(512*kilo - kilo);
  800795:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800798:	89 d0                	mov    %edx,%eax
  80079a:	c1 e0 09             	shl    $0x9,%eax
  80079d:	29 d0                	sub    %edx,%eax
  80079f:	83 ec 0c             	sub    $0xc,%esp
  8007a2:	50                   	push   %eax
  8007a3:	e8 2f 1d 00 00       	call   8024d7 <malloc>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8007ae:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8007b1:	89 c2                	mov    %eax,%edx
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b6:	05 00 00 00 80       	add    $0x80000000,%eax
  8007bb:	39 c2                	cmp    %eax,%edx
  8007bd:	74 17                	je     8007d6 <_main+0x79e>
  8007bf:	83 ec 04             	sub    $0x4,%esp
  8007c2:	68 64 42 80 00       	push   $0x804264
  8007c7:	68 8e 00 00 00       	push   $0x8e
  8007cc:	68 94 42 80 00       	push   $0x804294
  8007d1:	e8 d4 0a 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8007d6:	e8 3b 21 00 00       	call   802916 <sys_calculate_free_frames>
  8007db:	89 c2                	mov    %eax,%edx
  8007dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007e0:	39 c2                	cmp    %eax,%edx
  8007e2:	74 17                	je     8007fb <_main+0x7c3>
  8007e4:	83 ec 04             	sub    $0x4,%esp
  8007e7:	68 ac 42 80 00       	push   $0x8042ac
  8007ec:	68 90 00 00 00       	push   $0x90
  8007f1:	68 94 42 80 00       	push   $0x804294
  8007f6:	e8 af 0a 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 128) panic("Extra or less pages are allocated in PageFile");
  8007fb:	e8 b6 21 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800800:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800803:	3d 80 00 00 00       	cmp    $0x80,%eax
  800808:	74 17                	je     800821 <_main+0x7e9>
  80080a:	83 ec 04             	sub    $0x4,%esp
  80080d:	68 18 43 80 00       	push   $0x804318
  800812:	68 91 00 00 00       	push   $0x91
  800817:	68 94 42 80 00       	push   $0x804294
  80081c:	e8 89 0a 00 00       	call   8012aa <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[9];
  800821:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800824:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int lastIndexOfInt1 = ((512)*kilo)/sizeof(int) - 1;
  800827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082a:	c1 e0 09             	shl    $0x9,%eax
  80082d:	c1 e8 02             	shr    $0x2,%eax
  800830:	48                   	dec    %eax
  800831:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		int i = 0;
  800834:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800842:	eb 17                	jmp    80085b <_main+0x823>
		{
			intArr[i] = i ;
  800844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800847:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80084e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800851:	01 c2                	add    %eax,%edx
  800853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800856:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800858:	ff 45 f4             	incl   -0xc(%ebp)
  80085b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80085f:	7e e3                	jle    800844 <_main+0x80c>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800861:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800864:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800867:	eb 17                	jmp    800880 <_main+0x848>
		{
			intArr[i] = i ;
  800869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80086c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800873:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800876:	01 c2                	add    %eax,%edx
  800878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80087b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  80087d:	ff 4d f4             	decl   -0xc(%ebp)
  800880:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800883:	83 e8 64             	sub    $0x64,%eax
  800886:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800889:	7c de                	jl     800869 <_main+0x831>
		{
			intArr[i] = i ;
		}

		//Reallocate it [expanded in the same place]
		freeFrames = sys_calculate_free_frames() ;
  80088b:	e8 86 20 00 00       	call   802916 <sys_calculate_free_frames>
  800890:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800893:	e8 1e 21 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800898:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 512*kilo + 256*kilo - kilo);
  80089b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80089e:	89 d0                	mov    %edx,%eax
  8008a0:	01 c0                	add    %eax,%eax
  8008a2:	01 d0                	add    %edx,%eax
  8008a4:	c1 e0 08             	shl    $0x8,%eax
  8008a7:	29 d0                	sub    %edx,%eax
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008ae:	83 ec 08             	sub    $0x8,%esp
  8008b1:	52                   	push   %edx
  8008b2:	50                   	push   %eax
  8008b3:	e8 dc 1e 00 00       	call   802794 <realloc>
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the re-allocated space... ");
  8008be:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8008c1:	89 c2                	mov    %eax,%edx
  8008c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c6:	05 00 00 00 80       	add    $0x80000000,%eax
  8008cb:	39 c2                	cmp    %eax,%edx
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 d0 43 80 00       	push   $0x8043d0
  8008d7:	68 ae 00 00 00       	push   $0xae
  8008dc:	68 94 42 80 00       	push   $0x804294
  8008e1:	e8 c4 09 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008e6:	e8 2b 20 00 00       	call   802916 <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 04 44 80 00       	push   $0x804404
  8008fc:	68 b0 00 00 00       	push   $0xb0
  800901:	68 94 42 80 00       	push   $0x804294
  800906:	e8 9f 09 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 64) panic("Extra or less pages are re-allocated in PageFile");
  80090b:	e8 a6 20 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800910:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800913:	83 f8 40             	cmp    $0x40,%eax
  800916:	74 17                	je     80092f <_main+0x8f7>
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	68 74 44 80 00       	push   $0x804474
  800920:	68 b1 00 00 00       	push   $0xb1
  800925:	68 94 42 80 00       	push   $0x804294
  80092a:	e8 7b 09 00 00       	call   8012aa <_panic>


		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;
  80092f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800932:	89 d0                	mov    %edx,%eax
  800934:	01 c0                	add    %eax,%eax
  800936:	01 d0                	add    %edx,%eax
  800938:	c1 e0 08             	shl    $0x8,%eax
  80093b:	c1 e8 02             	shr    $0x2,%eax
  80093e:	48                   	dec    %eax
  80093f:	89 45 d0             	mov    %eax,-0x30(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800942:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800945:	40                   	inc    %eax
  800946:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800949:	eb 17                	jmp    800962 <_main+0x92a>
		{
			intArr[i] = i;
  80094b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800958:	01 c2                	add    %eax,%edx
  80095a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095d:	89 02                	mov    %eax,(%edx)
		//[2] test memory access
		int lastIndexOfInt2 = ((512+256)*kilo)/sizeof(int) - 1;

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  80095f:	ff 45 f4             	incl   -0xc(%ebp)
  800962:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800965:	83 c0 65             	add    $0x65,%eax
  800968:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80096b:	7f de                	jg     80094b <_main+0x913>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80096d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800970:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800973:	eb 17                	jmp    80098c <_main+0x954>
		{
			intArr[i] = i;
  800975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800978:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80097f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800982:	01 c2                	add    %eax,%edx
  800984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800987:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800989:	ff 4d f4             	decl   -0xc(%ebp)
  80098c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80098f:	83 e8 64             	sub    $0x64,%eax
  800992:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800995:	7c de                	jl     800975 <_main+0x93d>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800997:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80099e:	eb 30                	jmp    8009d0 <_main+0x998>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ad:	01 d0                	add    %edx,%eax
  8009af:	8b 00                	mov    (%eax),%eax
  8009b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009b4:	74 17                	je     8009cd <_main+0x995>
  8009b6:	83 ec 04             	sub    $0x4,%esp
  8009b9:	68 a8 44 80 00       	push   $0x8044a8
  8009be:	68 c6 00 00 00       	push   $0xc6
  8009c3:	68 94 42 80 00       	push   $0x804294
  8009c8:	e8 dd 08 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  8009cd:	ff 45 f4             	incl   -0xc(%ebp)
  8009d0:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  8009d4:	7e ca                	jle    8009a0 <_main+0x968>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  8009d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8009dc:	eb 30                	jmp    800a0e <_main+0x9d6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009eb:	01 d0                	add    %edx,%eax
  8009ed:	8b 00                	mov    (%eax),%eax
  8009ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8009f2:	74 17                	je     800a0b <_main+0x9d3>
  8009f4:	83 ec 04             	sub    $0x4,%esp
  8009f7:	68 a8 44 80 00       	push   $0x8044a8
  8009fc:	68 cc 00 00 00       	push   $0xcc
  800a01:	68 94 42 80 00       	push   $0x804294
  800a06:	e8 9f 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800a0b:	ff 4d f4             	decl   -0xc(%ebp)
  800a0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a11:	83 e8 64             	sub    $0x64,%eax
  800a14:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a17:	7c c5                	jl     8009de <_main+0x9a6>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1c:	40                   	inc    %eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a20:	eb 30                	jmp    800a52 <_main+0xa1a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a2f:	01 d0                	add    %edx,%eax
  800a31:	8b 00                	mov    (%eax),%eax
  800a33:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 a8 44 80 00       	push   $0x8044a8
  800a40:	68 d2 00 00 00       	push   $0xd2
  800a45:	68 94 42 80 00       	push   $0x804294
  800a4a:	e8 5b 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800a4f:	ff 45 f4             	incl   -0xc(%ebp)
  800a52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a55:	83 c0 65             	add    $0x65,%eax
  800a58:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a5b:	7f c5                	jg     800a22 <_main+0x9ea>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a63:	eb 30                	jmp    800a95 <_main+0xa5d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a72:	01 d0                	add    %edx,%eax
  800a74:	8b 00                	mov    (%eax),%eax
  800a76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a79:	74 17                	je     800a92 <_main+0xa5a>
  800a7b:	83 ec 04             	sub    $0x4,%esp
  800a7e:	68 a8 44 80 00       	push   $0x8044a8
  800a83:	68 d8 00 00 00       	push   $0xd8
  800a88:	68 94 42 80 00       	push   $0x804294
  800a8d:	e8 18 08 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800a92:	ff 4d f4             	decl   -0xc(%ebp)
  800a95:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a98:	83 e8 64             	sub    $0x64,%eax
  800a9b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800a9e:	7c c5                	jl     800a65 <_main+0xa2d>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800aa0:	e8 71 1e 00 00       	call   802916 <sys_calculate_free_frames>
  800aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800aa8:	e8 09 1f 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800aad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800ab0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ab3:	83 ec 0c             	sub    $0xc,%esp
  800ab6:	50                   	push   %eax
  800ab7:	e8 b2 1a 00 00       	call   80256e <free>
  800abc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 192) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 192) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800abf:	e8 f2 1e 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800ac4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ac7:	29 c2                	sub    %eax,%edx
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	3d c0 00 00 00       	cmp    $0xc0,%eax
  800ad0:	74 17                	je     800ae9 <_main+0xab1>
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	68 e0 44 80 00       	push   $0x8044e0
  800ada:	68 e0 00 00 00       	push   $0xe0
  800adf:	68 94 42 80 00       	push   $0x804294
  800ae4:	e8 c1 07 00 00       	call   8012aa <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800ae9:	e8 28 1e 00 00       	call   802916 <sys_calculate_free_frames>
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af3:	29 c2                	sub    %eax,%edx
  800af5:	89 d0                	mov    %edx,%eax
  800af7:	83 f8 05             	cmp    $0x5,%eax
  800afa:	74 17                	je     800b13 <_main+0xadb>
  800afc:	83 ec 04             	sub    $0x4,%esp
  800aff:	68 84 43 80 00       	push   $0x804384
  800b04:	68 e1 00 00 00       	push   $0xe1
  800b09:	68 94 42 80 00       	push   $0x804294
  800b0e:	e8 97 07 00 00       	call   8012aa <_panic>

		vcprintf("\b\b\b40%", NULL);
  800b13:	83 ec 08             	sub    $0x8,%esp
  800b16:	6a 00                	push   $0x0
  800b18:	68 34 45 80 00       	push   $0x804534
  800b1d:	e8 d1 09 00 00       	call   8014f3 <vcprintf>
  800b22:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate that's not fit in the same location*/

		//Allocate 1.5 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  800b25:	e8 ec 1d 00 00       	call   802916 <sys_calculate_free_frames>
  800b2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b2d:	e8 84 1e 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = malloc(1*Mega + 512*kilo - kilo);
  800b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b38:	c1 e0 09             	shl    $0x9,%eax
  800b3b:	89 c2                	mov    %eax,%edx
  800b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800b45:	83 ec 0c             	sub    $0xc,%esp
  800b48:	50                   	push   %eax
  800b49:	e8 89 19 00 00       	call   8024d7 <malloc>
  800b4e:	83 c4 10             	add    $0x10,%esp
  800b51:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[9] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800b54:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800b57:	89 c2                	mov    %eax,%edx
  800b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b5c:	c1 e0 02             	shl    $0x2,%eax
  800b5f:	05 00 00 00 80       	add    $0x80000000,%eax
  800b64:	39 c2                	cmp    %eax,%edx
  800b66:	74 17                	je     800b7f <_main+0xb47>
  800b68:	83 ec 04             	sub    $0x4,%esp
  800b6b:	68 64 42 80 00       	push   $0x804264
  800b70:	68 eb 00 00 00       	push   $0xeb
  800b75:	68 94 42 80 00       	push   $0x804294
  800b7a:	e8 2b 07 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 384) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800b7f:	e8 92 1d 00 00       	call   802916 <sys_calculate_free_frames>
  800b84:	89 c2                	mov    %eax,%edx
  800b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b89:	39 c2                	cmp    %eax,%edx
  800b8b:	74 17                	je     800ba4 <_main+0xb6c>
  800b8d:	83 ec 04             	sub    $0x4,%esp
  800b90:	68 ac 42 80 00       	push   $0x8042ac
  800b95:	68 ed 00 00 00       	push   $0xed
  800b9a:	68 94 42 80 00       	push   $0x804294
  800b9f:	e8 06 07 00 00       	call   8012aa <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 384) panic("Extra or less pages are allocated in PageFile");
  800ba4:	e8 0d 1e 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800ba9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800bac:	3d 80 01 00 00       	cmp    $0x180,%eax
  800bb1:	74 17                	je     800bca <_main+0xb92>
  800bb3:	83 ec 04             	sub    $0x4,%esp
  800bb6:	68 18 43 80 00       	push   $0x804318
  800bbb:	68 ee 00 00 00       	push   $0xee
  800bc0:	68 94 42 80 00       	push   $0x804294
  800bc5:	e8 e0 06 00 00       	call   8012aa <_panic>

		//Fill it with data
		intArr = (int*) ptr_allocations[9];
  800bca:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800bcd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c1 e0 09             	shl    $0x9,%eax
  800bd6:	89 c2                	mov    %eax,%edx
  800bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bdb:	01 d0                	add    %edx,%eax
  800bdd:	c1 e8 02             	shr    $0x2,%eax
  800be0:	48                   	dec    %eax
  800be1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		i = 0;
  800be4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800bf2:	eb 17                	jmp    800c0b <_main+0xbd3>
		{
			intArr[i] = i ;
  800bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c01:	01 c2                	add    %eax,%edx
  800c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c06:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt1 = (1*Mega + 512*kilo)/sizeof(int) - 1;
		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800c08:	ff 45 f4             	incl   -0xc(%ebp)
  800c0b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800c0f:	7e e3                	jle    800bf4 <_main+0xbbc>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800c17:	eb 17                	jmp    800c30 <_main+0xbf8>
		{
			intArr[i] = i ;
  800c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c26:	01 c2                	add    %eax,%edx
  800c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c2b:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800c2d:	ff 4d f4             	decl   -0xc(%ebp)
  800c30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c33:	83 e8 64             	sub    $0x64,%eax
  800c36:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800c39:	7c de                	jl     800c19 <_main+0xbe1>
		{
			intArr[i] = i ;
		}

		//Reallocate it to 2.5 MB [should be moved to next hole]
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 d6 1c 00 00       	call   802916 <sys_calculate_free_frames>
  800c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c43:	e8 6e 1d 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800c48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[9] = realloc(ptr_allocations[9], 1*Mega + 512*kilo + 1*Mega - kilo);
  800c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c4e:	c1 e0 09             	shl    $0x9,%eax
  800c51:	89 c2                	mov    %eax,%edx
  800c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c56:	01 c2                	add    %eax,%edx
  800c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c5b:	01 d0                	add    %edx,%eax
  800c5d:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800c60:	89 c2                	mov    %eax,%edx
  800c62:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c65:	83 ec 08             	sub    $0x8,%esp
  800c68:	52                   	push   %edx
  800c69:	50                   	push   %eax
  800c6a:	e8 25 1b 00 00       	call   802794 <realloc>
  800c6f:	83 c4 10             	add    $0x10,%esp
  800c72:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800c75:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800c78:	89 c2                	mov    %eax,%edx
  800c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c7d:	c1 e0 03             	shl    $0x3,%eax
  800c80:	05 00 00 00 80       	add    $0x80000000,%eax
  800c85:	39 c2                	cmp    %eax,%edx
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 d0 43 80 00       	push   $0x8043d0
  800c91:	68 07 01 00 00       	push   $0x107
  800c96:	68 94 42 80 00       	push   $0x804294
  800c9b:	e8 0a 06 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong re-allocation");

		//if((sys_calculate_free_frames() - freeFrames) != 3) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  800ca0:	e8 11 1d 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800ca5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ca8:	3d 00 01 00 00       	cmp    $0x100,%eax
  800cad:	74 17                	je     800cc6 <_main+0xc8e>
  800caf:	83 ec 04             	sub    $0x4,%esp
  800cb2:	68 74 44 80 00       	push   $0x804474
  800cb7:	68 0b 01 00 00       	push   $0x10b
  800cbc:	68 94 42 80 00       	push   $0x804294
  800cc1:	e8 e4 05 00 00       	call   8012aa <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (2*Mega + 512*kilo)/sizeof(int) - 1;
  800cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc9:	c1 e0 08             	shl    $0x8,%eax
  800ccc:	89 c2                	mov    %eax,%edx
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	01 c0                	add    %eax,%eax
  800cd5:	c1 e8 02             	shr    $0x2,%eax
  800cd8:	48                   	dec    %eax
  800cd9:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[9];
  800cdc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800cdf:	89 45 d8             	mov    %eax,-0x28(%ebp)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800ce2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ce5:	40                   	inc    %eax
  800ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ce9:	eb 17                	jmp    800d02 <_main+0xcca>
		{
			intArr[i] = i;
  800ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cf5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800cf8:	01 c2                	add    %eax,%edx
  800cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cfd:	89 02                	mov    %eax,(%edx)



		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800cff:	ff 45 f4             	incl   -0xc(%ebp)
  800d02:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d05:	83 c0 65             	add    $0x65,%eax
  800d08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d0b:	7f de                	jg     800ceb <_main+0xcb3>
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d0d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d13:	eb 17                	jmp    800d2c <_main+0xcf4>
		{
			intArr[i] = i;
  800d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d22:	01 c2                	add    %eax,%edx
  800d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d27:	89 02                	mov    %eax,(%edx)
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
		{
			intArr[i] = i;
		}
		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800d29:	ff 4d f4             	decl   -0xc(%ebp)
  800d2c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d2f:	83 e8 64             	sub    $0x64,%eax
  800d32:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d35:	7c de                	jl     800d15 <_main+0xcdd>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800d3e:	eb 30                	jmp    800d70 <_main+0xd38>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d4d:	01 d0                	add    %edx,%eax
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d54:	74 17                	je     800d6d <_main+0xd35>
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	68 a8 44 80 00       	push   $0x8044a8
  800d5e:	68 22 01 00 00       	push   $0x122
  800d63:	68 94 42 80 00       	push   $0x804294
  800d68:	e8 3d 05 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800d6d:	ff 45 f4             	incl   -0xc(%ebp)
  800d70:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800d74:	7e ca                	jle    800d40 <_main+0xd08>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d7c:	eb 30                	jmp    800dae <_main+0xd76>
		{
			if (intArr[i] != i)
  800d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d81:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d88:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d8b:	01 d0                	add    %edx,%eax
  800d8d:	8b 00                	mov    (%eax),%eax
  800d8f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800d92:	74 17                	je     800dab <_main+0xd73>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800d94:	83 ec 04             	sub    $0x4,%esp
  800d97:	68 a8 44 80 00       	push   $0x8044a8
  800d9c:	68 2a 01 00 00       	push   $0x12a
  800da1:	68 94 42 80 00       	push   $0x804294
  800da6:	e8 ff 04 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800dab:	ff 4d f4             	decl   -0xc(%ebp)
  800dae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800db1:	83 e8 64             	sub    $0x64,%eax
  800db4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800db7:	7c c5                	jl     800d7e <_main+0xd46>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800db9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dbc:	40                   	inc    %eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dc0:	eb 30                	jmp    800df2 <_main+0xdba>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dcc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dcf:	01 d0                	add    %edx,%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dd6:	74 17                	je     800def <_main+0xdb7>
  800dd8:	83 ec 04             	sub    $0x4,%esp
  800ddb:	68 a8 44 80 00       	push   $0x8044a8
  800de0:	68 31 01 00 00       	push   $0x131
  800de5:	68 94 42 80 00       	push   $0x804294
  800dea:	e8 bb 04 00 00       	call   8012aa <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800def:	ff 45 f4             	incl   -0xc(%ebp)
  800df2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800df5:	83 c0 65             	add    $0x65,%eax
  800df8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800dfb:	7f c5                	jg     800dc2 <_main+0xd8a>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800dfd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e03:	eb 30                	jmp    800e35 <_main+0xdfd>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e0f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e12:	01 d0                	add    %edx,%eax
  800e14:	8b 00                	mov    (%eax),%eax
  800e16:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e19:	74 17                	je     800e32 <_main+0xdfa>
  800e1b:	83 ec 04             	sub    $0x4,%esp
  800e1e:	68 a8 44 80 00       	push   $0x8044a8
  800e23:	68 37 01 00 00       	push   $0x137
  800e28:	68 94 42 80 00       	push   $0x804294
  800e2d:	e8 78 04 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800e32:	ff 4d f4             	decl   -0xc(%ebp)
  800e35:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e38:	83 e8 64             	sub    $0x64,%eax
  800e3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800e3e:	7c c5                	jl     800e05 <_main+0xdcd>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800e40:	e8 d1 1a 00 00       	call   802916 <sys_calculate_free_frames>
  800e45:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e48:	e8 69 1b 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800e4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[9]);
  800e50:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800e53:	83 ec 0c             	sub    $0xc,%esp
  800e56:	50                   	push   %eax
  800e57:	e8 12 17 00 00       	call   80256e <free>
  800e5c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e5f:	e8 52 1b 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800e64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e67:	29 c2                	sub    %eax,%edx
  800e69:	89 d0                	mov    %edx,%eax
  800e6b:	3d 80 02 00 00       	cmp    $0x280,%eax
  800e70:	74 17                	je     800e89 <_main+0xe51>
  800e72:	83 ec 04             	sub    $0x4,%esp
  800e75:	68 e0 44 80 00       	push   $0x8044e0
  800e7a:	68 40 01 00 00       	push   $0x140
  800e7f:	68 94 42 80 00       	push   $0x804294
  800e84:	e8 21 04 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b70%", NULL);
  800e89:	83 ec 08             	sub    $0x8,%esp
  800e8c:	6a 00                	push   $0x0
  800e8e:	68 3b 45 80 00       	push   $0x80453b
  800e93:	e8 5b 06 00 00       	call   8014f3 <vcprintf>
  800e98:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate that's not fit in the same location*/

		//Fill it with data
		intArr = (int*) ptr_allocations[0];
  800e9b:	8b 45 80             	mov    -0x80(%ebp),%eax
  800e9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	c1 e8 02             	shr    $0x2,%eax
  800ea7:	48                   	dec    %eax
  800ea8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		i = 0;
  800eab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800eb9:	eb 17                	jmp    800ed2 <_main+0xe9a>
		{
			intArr[i] = i ;
  800ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ec5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ec8:	01 c2                	add    %eax,%edx
  800eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ecd:	89 02                	mov    %eax,(%edx)

		i = 0;

		//NEW
		//filling the first 100 elements
		for (i=0; i < 100 ; i++)
  800ecf:	ff 45 f4             	incl   -0xc(%ebp)
  800ed2:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  800ed6:	7e e3                	jle    800ebb <_main+0xe83>
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ed8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ede:	eb 17                	jmp    800ef7 <_main+0xebf>
		{
			intArr[i] = i ;
  800ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800eed:	01 c2                	add    %eax,%edx
  800eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 elements
		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  800ef4:	ff 4d f4             	decl   -0xc(%ebp)
  800ef7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800efa:	83 e8 64             	sub    $0x64,%eax
  800efd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f00:	7c de                	jl     800ee0 <_main+0xea8>
			intArr[i] = i ;
		}


		//Reallocate it to 4 MB [should be moved to last hole]
		freeFrames = sys_calculate_free_frames() ;
  800f02:	e8 0f 1a 00 00       	call   802916 <sys_calculate_free_frames>
  800f07:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f0a:	e8 a7 1a 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800f0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 1*Mega + 3*Mega - kilo);
  800f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f15:	c1 e0 02             	shl    $0x2,%eax
  800f18:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800f1b:	89 c2                	mov    %eax,%edx
  800f1d:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	52                   	push   %edx
  800f24:	50                   	push   %eax
  800f25:	e8 6a 18 00 00       	call   802794 <realloc>
  800f2a:	83 c4 10             	add    $0x10,%esp
  800f2d:	89 45 80             	mov    %eax,-0x80(%ebp)
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the re-allocated space... ");
  800f30:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f33:	89 c1                	mov    %eax,%ecx
  800f35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f38:	89 d0                	mov    %edx,%eax
  800f3a:	01 c0                	add    %eax,%eax
  800f3c:	01 d0                	add    %edx,%eax
  800f3e:	01 c0                	add    %eax,%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	01 c0                	add    %eax,%eax
  800f44:	05 00 00 00 80       	add    $0x80000000,%eax
  800f49:	39 c1                	cmp    %eax,%ecx
  800f4b:	74 17                	je     800f64 <_main+0xf2c>
  800f4d:	83 ec 04             	sub    $0x4,%esp
  800f50:	68 d0 43 80 00       	push   $0x8043d0
  800f55:	68 60 01 00 00       	push   $0x160
  800f5a:	68 94 42 80 00       	push   $0x804294
  800f5f:	e8 46 03 00 00       	call   8012aa <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are re-allocated in PageFile");
  800f64:	e8 4d 1a 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  800f69:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f6c:	3d 00 03 00 00       	cmp    $0x300,%eax
  800f71:	74 17                	je     800f8a <_main+0xf52>
  800f73:	83 ec 04             	sub    $0x4,%esp
  800f76:	68 74 44 80 00       	push   $0x804474
  800f7b:	68 63 01 00 00       	push   $0x163
  800f80:	68 94 42 80 00       	push   $0x804294
  800f85:	e8 20 03 00 00       	call   8012aa <_panic>

		//[2] test memory access
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
  800f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8d:	c1 e0 02             	shl    $0x2,%eax
  800f90:	c1 e8 02             	shr    $0x2,%eax
  800f93:	48                   	dec    %eax
  800f94:	89 45 d0             	mov    %eax,-0x30(%ebp)
		intArr = (int*) ptr_allocations[0];
  800f97:	8b 45 80             	mov    -0x80(%ebp),%eax
  800f9a:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800f9d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fa0:	40                   	inc    %eax
  800fa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa4:	eb 17                	jmp    800fbd <_main+0xf85>
		{
			intArr[i] = i;
  800fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fb0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fb3:	01 c2                	add    %eax,%edx
  800fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb8:	89 02                	mov    %eax,(%edx)
		lastIndexOfInt2 = (4*Mega)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[0];

		//NEW
		//filling the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  800fba:	ff 45 f4             	incl   -0xc(%ebp)
  800fbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fc0:	83 c0 65             	add    $0x65,%eax
  800fc3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fc6:	7f de                	jg     800fa6 <_main+0xf6e>
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fc8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fce:	eb 17                	jmp    800fe7 <_main+0xfaf>
		{
			intArr[i] = i;
  800fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fda:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800fdd:	01 c2                	add    %eax,%edx
  800fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe2:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i;
		}

		//filling the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  800fe4:	ff 4d f4             	decl   -0xc(%ebp)
  800fe7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fea:	83 e8 64             	sub    $0x64,%eax
  800fed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ff0:	7c de                	jl     800fd0 <_main+0xf98>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  800ff2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800ff9:	eb 30                	jmp    80102b <_main+0xff3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801005:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801008:	01 d0                	add    %edx,%eax
  80100a:	8b 00                	mov    (%eax),%eax
  80100c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80100f:	74 17                	je     801028 <_main+0xff0>
  801011:	83 ec 04             	sub    $0x4,%esp
  801014:	68 a8 44 80 00       	push   $0x8044a8
  801019:	68 79 01 00 00       	push   $0x179
  80101e:	68 94 42 80 00       	push   $0x804294
  801023:	e8 82 02 00 00       	call   8012aa <_panic>
		{
			intArr[i] = i;
		}

		//checking the first 100 elements of the old range
		for(i = 0; i < 100; i++)
  801028:	ff 45 f4             	incl   -0xc(%ebp)
  80102b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  80102f:	7e ca                	jle    800ffb <_main+0xfc3>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801031:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801037:	eb 30                	jmp    801069 <_main+0x1031>
		{
			if (intArr[i] != i)
  801039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801043:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801046:	01 d0                	add    %edx,%eax
  801048:	8b 00                	mov    (%eax),%eax
  80104a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80104d:	74 17                	je     801066 <_main+0x102e>
			{
				panic("Wrong re-allocation: stored values are wrongly changed!");
  80104f:	83 ec 04             	sub    $0x4,%esp
  801052:	68 a8 44 80 00       	push   $0x8044a8
  801057:	68 81 01 00 00       	push   $0x181
  80105c:	68 94 42 80 00       	push   $0x804294
  801061:	e8 44 02 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the old range
		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801066:	ff 4d f4             	decl   -0xc(%ebp)
  801069:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80106c:	83 e8 64             	sub    $0x64,%eax
  80106f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801072:	7c c5                	jl     801039 <_main+0x1001>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  801074:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801077:	40                   	inc    %eax
  801078:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107b:	eb 30                	jmp    8010ad <_main+0x1075>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80107d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801080:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801087:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80108a:	01 d0                	add    %edx,%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801091:	74 17                	je     8010aa <_main+0x1072>
  801093:	83 ec 04             	sub    $0x4,%esp
  801096:	68 a8 44 80 00       	push   $0x8044a8
  80109b:	68 88 01 00 00       	push   $0x188
  8010a0:	68 94 42 80 00       	push   $0x804294
  8010a5:	e8 00 02 00 00       	call   8012aa <_panic>
				panic("Wrong re-allocation: stored values are wrongly changed!");
			}
		}

		//checking the first 100 elements of the new range
		for(i = lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101; i++)
  8010aa:	ff 45 f4             	incl   -0xc(%ebp)
  8010ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010b0:	83 c0 65             	add    $0x65,%eax
  8010b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010b6:	7f c5                	jg     80107d <_main+0x1045>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010be:	eb 30                	jmp    8010f0 <_main+0x10b8>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8010cd:	01 d0                	add    %edx,%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010d4:	74 17                	je     8010ed <_main+0x10b5>
  8010d6:	83 ec 04             	sub    $0x4,%esp
  8010d9:	68 a8 44 80 00       	push   $0x8044a8
  8010de:	68 8e 01 00 00       	push   $0x18e
  8010e3:	68 94 42 80 00       	push   $0x804294
  8010e8:	e8 bd 01 00 00       	call   8012aa <_panic>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//checking the last 100 elements of the new range
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  8010ed:	ff 4d f4             	decl   -0xc(%ebp)
  8010f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010f3:	83 e8 64             	sub    $0x64,%eax
  8010f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010f9:	7c c5                	jl     8010c0 <_main+0x1088>
		{
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  8010fb:	e8 16 18 00 00       	call   802916 <sys_calculate_free_frames>
  801100:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801103:	e8 ae 18 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  801108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		free(ptr_allocations[0]);
  80110b:	8b 45 80             	mov    -0x80(%ebp),%eax
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	50                   	push   %eax
  801112:	e8 57 14 00 00       	call   80256e <free>
  801117:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024+1) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  80111a:	e8 97 18 00 00       	call   8029b6 <sys_pf_calculate_allocated_pages>
  80111f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801122:	29 c2                	sub    %eax,%edx
  801124:	89 d0                	mov    %edx,%eax
  801126:	3d 00 04 00 00       	cmp    $0x400,%eax
  80112b:	74 17                	je     801144 <_main+0x110c>
  80112d:	83 ec 04             	sub    $0x4,%esp
  801130:	68 e0 44 80 00       	push   $0x8044e0
  801135:	68 96 01 00 00       	push   $0x196
  80113a:	68 94 42 80 00       	push   $0x804294
  80113f:	e8 66 01 00 00       	call   8012aa <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 2) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  801144:	83 ec 08             	sub    $0x8,%esp
  801147:	6a 00                	push   $0x0
  801149:	68 42 45 80 00       	push   $0x804542
  80114e:	e8 a0 03 00 00       	call   8014f3 <vcprintf>
  801153:	83 c4 10             	add    $0x10,%esp
	}

	cprintf("Congratulations!! test realloc [1] completed successfully.\n");
  801156:	83 ec 0c             	sub    $0xc,%esp
  801159:	68 4c 45 80 00       	push   $0x80454c
  80115e:	e8 fb 03 00 00       	call   80155e <cprintf>
  801163:	83 c4 10             	add    $0x10,%esp

	return;
  801166:	90                   	nop
}
  801167:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80116a:	5b                   	pop    %ebx
  80116b:	5f                   	pop    %edi
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801174:	e8 7d 1a 00 00       	call   802bf6 <sys_getenvindex>
  801179:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80117c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80117f:	89 d0                	mov    %edx,%eax
  801181:	c1 e0 03             	shl    $0x3,%eax
  801184:	01 d0                	add    %edx,%eax
  801186:	01 c0                	add    %eax,%eax
  801188:	01 d0                	add    %edx,%eax
  80118a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801191:	01 d0                	add    %edx,%eax
  801193:	c1 e0 04             	shl    $0x4,%eax
  801196:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80119b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8011a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8011a5:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8011ab:	84 c0                	test   %al,%al
  8011ad:	74 0f                	je     8011be <libmain+0x50>
		binaryname = myEnv->prog_name;
  8011af:	a1 20 50 80 00       	mov    0x805020,%eax
  8011b4:	05 5c 05 00 00       	add    $0x55c,%eax
  8011b9:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8011be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c2:	7e 0a                	jle    8011ce <libmain+0x60>
		binaryname = argv[0];
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8011ce:	83 ec 08             	sub    $0x8,%esp
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	ff 75 08             	pushl  0x8(%ebp)
  8011d7:	e8 5c ee ff ff       	call   800038 <_main>
  8011dc:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8011df:	e8 1f 18 00 00       	call   802a03 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8011e4:	83 ec 0c             	sub    $0xc,%esp
  8011e7:	68 a0 45 80 00       	push   $0x8045a0
  8011ec:	e8 6d 03 00 00       	call   80155e <cprintf>
  8011f1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8011f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8011f9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8011ff:	a1 20 50 80 00       	mov    0x805020,%eax
  801204:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80120a:	83 ec 04             	sub    $0x4,%esp
  80120d:	52                   	push   %edx
  80120e:	50                   	push   %eax
  80120f:	68 c8 45 80 00       	push   $0x8045c8
  801214:	e8 45 03 00 00       	call   80155e <cprintf>
  801219:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80121c:	a1 20 50 80 00       	mov    0x805020,%eax
  801221:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  801227:	a1 20 50 80 00       	mov    0x805020,%eax
  80122c:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  801232:	a1 20 50 80 00       	mov    0x805020,%eax
  801237:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80123d:	51                   	push   %ecx
  80123e:	52                   	push   %edx
  80123f:	50                   	push   %eax
  801240:	68 f0 45 80 00       	push   $0x8045f0
  801245:	e8 14 03 00 00       	call   80155e <cprintf>
  80124a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80124d:	a1 20 50 80 00       	mov    0x805020,%eax
  801252:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  801258:	83 ec 08             	sub    $0x8,%esp
  80125b:	50                   	push   %eax
  80125c:	68 48 46 80 00       	push   $0x804648
  801261:	e8 f8 02 00 00       	call   80155e <cprintf>
  801266:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  801269:	83 ec 0c             	sub    $0xc,%esp
  80126c:	68 a0 45 80 00       	push   $0x8045a0
  801271:	e8 e8 02 00 00       	call   80155e <cprintf>
  801276:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801279:	e8 9f 17 00 00       	call   802a1d <sys_enable_interrupt>

	// exit gracefully
	exit();
  80127e:	e8 19 00 00 00       	call   80129c <exit>
}
  801283:	90                   	nop
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80128c:	83 ec 0c             	sub    $0xc,%esp
  80128f:	6a 00                	push   $0x0
  801291:	e8 2c 19 00 00       	call   802bc2 <sys_destroy_env>
  801296:	83 c4 10             	add    $0x10,%esp
}
  801299:	90                   	nop
  80129a:	c9                   	leave  
  80129b:	c3                   	ret    

0080129c <exit>:

void
exit(void)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8012a2:	e8 81 19 00 00       	call   802c28 <sys_exit_env>
}
  8012a7:	90                   	nop
  8012a8:	c9                   	leave  
  8012a9:	c3                   	ret    

008012aa <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8012b0:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b3:	83 c0 04             	add    $0x4,%eax
  8012b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8012b9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	74 16                	je     8012d8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8012c2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	50                   	push   %eax
  8012cb:	68 5c 46 80 00       	push   $0x80465c
  8012d0:	e8 89 02 00 00       	call   80155e <cprintf>
  8012d5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8012d8:	a1 00 50 80 00       	mov    0x805000,%eax
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	ff 75 08             	pushl  0x8(%ebp)
  8012e3:	50                   	push   %eax
  8012e4:	68 61 46 80 00       	push   $0x804661
  8012e9:	e8 70 02 00 00       	call   80155e <cprintf>
  8012ee:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8012f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8012fa:	50                   	push   %eax
  8012fb:	e8 f3 01 00 00       	call   8014f3 <vcprintf>
  801300:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801303:	83 ec 08             	sub    $0x8,%esp
  801306:	6a 00                	push   $0x0
  801308:	68 7d 46 80 00       	push   $0x80467d
  80130d:	e8 e1 01 00 00       	call   8014f3 <vcprintf>
  801312:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801315:	e8 82 ff ff ff       	call   80129c <exit>

	// should not return here
	while (1) ;
  80131a:	eb fe                	jmp    80131a <_panic+0x70>

0080131c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801322:	a1 20 50 80 00       	mov    0x805020,%eax
  801327:	8b 50 74             	mov    0x74(%eax),%edx
  80132a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132d:	39 c2                	cmp    %eax,%edx
  80132f:	74 14                	je     801345 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801331:	83 ec 04             	sub    $0x4,%esp
  801334:	68 80 46 80 00       	push   $0x804680
  801339:	6a 26                	push   $0x26
  80133b:	68 cc 46 80 00       	push   $0x8046cc
  801340:	e8 65 ff ff ff       	call   8012aa <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801345:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80134c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801353:	e9 c2 00 00 00       	jmp    80141a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  801358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	8b 00                	mov    (%eax),%eax
  801369:	85 c0                	test   %eax,%eax
  80136b:	75 08                	jne    801375 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80136d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801370:	e9 a2 00 00 00       	jmp    801417 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801375:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80137c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801383:	eb 69                	jmp    8013ee <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801385:	a1 20 50 80 00       	mov    0x805020,%eax
  80138a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801390:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801393:	89 d0                	mov    %edx,%eax
  801395:	01 c0                	add    %eax,%eax
  801397:	01 d0                	add    %edx,%eax
  801399:	c1 e0 03             	shl    $0x3,%eax
  80139c:	01 c8                	add    %ecx,%eax
  80139e:	8a 40 04             	mov    0x4(%eax),%al
  8013a1:	84 c0                	test   %al,%al
  8013a3:	75 46                	jne    8013eb <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8013aa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8013b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013b3:	89 d0                	mov    %edx,%eax
  8013b5:	01 c0                	add    %eax,%eax
  8013b7:	01 d0                	add    %edx,%eax
  8013b9:	c1 e0 03             	shl    $0x3,%eax
  8013bc:	01 c8                	add    %ecx,%eax
  8013be:	8b 00                	mov    (%eax),%eax
  8013c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8013c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013cb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8013cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	01 c8                	add    %ecx,%eax
  8013dc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8013de:	39 c2                	cmp    %eax,%edx
  8013e0:	75 09                	jne    8013eb <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8013e2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8013e9:	eb 12                	jmp    8013fd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013eb:	ff 45 e8             	incl   -0x18(%ebp)
  8013ee:	a1 20 50 80 00       	mov    0x805020,%eax
  8013f3:	8b 50 74             	mov    0x74(%eax),%edx
  8013f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013f9:	39 c2                	cmp    %eax,%edx
  8013fb:	77 88                	ja     801385 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8013fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801401:	75 14                	jne    801417 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801403:	83 ec 04             	sub    $0x4,%esp
  801406:	68 d8 46 80 00       	push   $0x8046d8
  80140b:	6a 3a                	push   $0x3a
  80140d:	68 cc 46 80 00       	push   $0x8046cc
  801412:	e8 93 fe ff ff       	call   8012aa <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801417:	ff 45 f0             	incl   -0x10(%ebp)
  80141a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801420:	0f 8c 32 ff ff ff    	jl     801358 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801426:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80142d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801434:	eb 26                	jmp    80145c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801436:	a1 20 50 80 00       	mov    0x805020,%eax
  80143b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801441:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801444:	89 d0                	mov    %edx,%eax
  801446:	01 c0                	add    %eax,%eax
  801448:	01 d0                	add    %edx,%eax
  80144a:	c1 e0 03             	shl    $0x3,%eax
  80144d:	01 c8                	add    %ecx,%eax
  80144f:	8a 40 04             	mov    0x4(%eax),%al
  801452:	3c 01                	cmp    $0x1,%al
  801454:	75 03                	jne    801459 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  801456:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801459:	ff 45 e0             	incl   -0x20(%ebp)
  80145c:	a1 20 50 80 00       	mov    0x805020,%eax
  801461:	8b 50 74             	mov    0x74(%eax),%edx
  801464:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801467:	39 c2                	cmp    %eax,%edx
  801469:	77 cb                	ja     801436 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80146b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801471:	74 14                	je     801487 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801473:	83 ec 04             	sub    $0x4,%esp
  801476:	68 2c 47 80 00       	push   $0x80472c
  80147b:	6a 44                	push   $0x44
  80147d:	68 cc 46 80 00       	push   $0x8046cc
  801482:	e8 23 fe ff ff       	call   8012aa <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801487:	90                   	nop
  801488:	c9                   	leave  
  801489:	c3                   	ret    

0080148a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801490:	8b 45 0c             	mov    0xc(%ebp),%eax
  801493:	8b 00                	mov    (%eax),%eax
  801495:	8d 48 01             	lea    0x1(%eax),%ecx
  801498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149b:	89 0a                	mov    %ecx,(%edx)
  80149d:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a0:	88 d1                	mov    %dl,%cl
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	3d ff 00 00 00       	cmp    $0xff,%eax
  8014b3:	75 2c                	jne    8014e1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8014b5:	a0 24 50 80 00       	mov    0x805024,%al
  8014ba:	0f b6 c0             	movzbl %al,%eax
  8014bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c0:	8b 12                	mov    (%edx),%edx
  8014c2:	89 d1                	mov    %edx,%ecx
  8014c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c7:	83 c2 08             	add    $0x8,%edx
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	50                   	push   %eax
  8014ce:	51                   	push   %ecx
  8014cf:	52                   	push   %edx
  8014d0:	e8 80 13 00 00       	call   802855 <sys_cputs>
  8014d5:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8014d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	8b 40 04             	mov    0x4(%eax),%eax
  8014e7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ed:	89 50 04             	mov    %edx,0x4(%eax)
}
  8014f0:	90                   	nop
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8014fc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801503:	00 00 00 
	b.cnt = 0;
  801506:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80150d:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801510:	ff 75 0c             	pushl  0xc(%ebp)
  801513:	ff 75 08             	pushl  0x8(%ebp)
  801516:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80151c:	50                   	push   %eax
  80151d:	68 8a 14 80 00       	push   $0x80148a
  801522:	e8 11 02 00 00       	call   801738 <vprintfmt>
  801527:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80152a:	a0 24 50 80 00       	mov    0x805024,%al
  80152f:	0f b6 c0             	movzbl %al,%eax
  801532:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801538:	83 ec 04             	sub    $0x4,%esp
  80153b:	50                   	push   %eax
  80153c:	52                   	push   %edx
  80153d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801543:	83 c0 08             	add    $0x8,%eax
  801546:	50                   	push   %eax
  801547:	e8 09 13 00 00       	call   802855 <sys_cputs>
  80154c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80154f:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  801556:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <cprintf>:

int cprintf(const char *fmt, ...) {
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801564:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80156b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80156e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	83 ec 08             	sub    $0x8,%esp
  801577:	ff 75 f4             	pushl  -0xc(%ebp)
  80157a:	50                   	push   %eax
  80157b:	e8 73 ff ff ff       	call   8014f3 <vcprintf>
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801586:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801591:	e8 6d 14 00 00       	call   802a03 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801596:	8d 45 0c             	lea    0xc(%ebp),%eax
  801599:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a5:	50                   	push   %eax
  8015a6:	e8 48 ff ff ff       	call   8014f3 <vcprintf>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8015b1:	e8 67 14 00 00       	call   802a1d <sys_enable_interrupt>
	return cnt;
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	53                   	push   %ebx
  8015bf:	83 ec 14             	sub    $0x14,%esp
  8015c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8015ce:	8b 45 18             	mov    0x18(%ebp),%eax
  8015d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015d9:	77 55                	ja     801630 <printnum+0x75>
  8015db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8015de:	72 05                	jb     8015e5 <printnum+0x2a>
  8015e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e3:	77 4b                	ja     801630 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8015e5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8015e8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8015eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8015ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f3:	52                   	push   %edx
  8015f4:	50                   	push   %eax
  8015f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8015fb:	e8 d0 29 00 00       	call   803fd0 <__udivdi3>
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	83 ec 04             	sub    $0x4,%esp
  801606:	ff 75 20             	pushl  0x20(%ebp)
  801609:	53                   	push   %ebx
  80160a:	ff 75 18             	pushl  0x18(%ebp)
  80160d:	52                   	push   %edx
  80160e:	50                   	push   %eax
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	ff 75 08             	pushl  0x8(%ebp)
  801615:	e8 a1 ff ff ff       	call   8015bb <printnum>
  80161a:	83 c4 20             	add    $0x20,%esp
  80161d:	eb 1a                	jmp    801639 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	ff 75 0c             	pushl  0xc(%ebp)
  801625:	ff 75 20             	pushl  0x20(%ebp)
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
  80162b:	ff d0                	call   *%eax
  80162d:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801630:	ff 4d 1c             	decl   0x1c(%ebp)
  801633:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801637:	7f e6                	jg     80161f <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801639:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80163c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801644:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801647:	53                   	push   %ebx
  801648:	51                   	push   %ecx
  801649:	52                   	push   %edx
  80164a:	50                   	push   %eax
  80164b:	e8 90 2a 00 00       	call   8040e0 <__umoddi3>
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	05 94 49 80 00       	add    $0x804994,%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	0f be c0             	movsbl %al,%eax
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	50                   	push   %eax
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	ff d0                	call   *%eax
  801669:	83 c4 10             	add    $0x10,%esp
}
  80166c:	90                   	nop
  80166d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801675:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801679:	7e 1c                	jle    801697 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	8b 00                	mov    (%eax),%eax
  801680:	8d 50 08             	lea    0x8(%eax),%edx
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	89 10                	mov    %edx,(%eax)
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8b 00                	mov    (%eax),%eax
  80168d:	83 e8 08             	sub    $0x8,%eax
  801690:	8b 50 04             	mov    0x4(%eax),%edx
  801693:	8b 00                	mov    (%eax),%eax
  801695:	eb 40                	jmp    8016d7 <getuint+0x65>
	else if (lflag)
  801697:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169b:	74 1e                	je     8016bb <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8b 00                	mov    (%eax),%eax
  8016a2:	8d 50 04             	lea    0x4(%eax),%edx
  8016a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a8:	89 10                	mov    %edx,(%eax)
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	8b 00                	mov    (%eax),%eax
  8016af:	83 e8 04             	sub    $0x4,%eax
  8016b2:	8b 00                	mov    (%eax),%eax
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	eb 1c                	jmp    8016d7 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8b 00                	mov    (%eax),%eax
  8016c0:	8d 50 04             	lea    0x4(%eax),%edx
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	89 10                	mov    %edx,(%eax)
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8b 00                	mov    (%eax),%eax
  8016cd:	83 e8 04             	sub    $0x4,%eax
  8016d0:	8b 00                	mov    (%eax),%eax
  8016d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8016d7:	5d                   	pop    %ebp
  8016d8:	c3                   	ret    

008016d9 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8016dc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8016e0:	7e 1c                	jle    8016fe <getint+0x25>
		return va_arg(*ap, long long);
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	8b 00                	mov    (%eax),%eax
  8016e7:	8d 50 08             	lea    0x8(%eax),%edx
  8016ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ed:	89 10                	mov    %edx,(%eax)
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	83 e8 08             	sub    $0x8,%eax
  8016f7:	8b 50 04             	mov    0x4(%eax),%edx
  8016fa:	8b 00                	mov    (%eax),%eax
  8016fc:	eb 38                	jmp    801736 <getint+0x5d>
	else if (lflag)
  8016fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801702:	74 1a                	je     80171e <getint+0x45>
		return va_arg(*ap, long);
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8b 00                	mov    (%eax),%eax
  801709:	8d 50 04             	lea    0x4(%eax),%edx
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	89 10                	mov    %edx,(%eax)
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	83 e8 04             	sub    $0x4,%eax
  801719:	8b 00                	mov    (%eax),%eax
  80171b:	99                   	cltd   
  80171c:	eb 18                	jmp    801736 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	8d 50 04             	lea    0x4(%eax),%edx
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	89 10                	mov    %edx,(%eax)
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8b 00                	mov    (%eax),%eax
  801730:	83 e8 04             	sub    $0x4,%eax
  801733:	8b 00                	mov    (%eax),%eax
  801735:	99                   	cltd   
}
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	56                   	push   %esi
  80173c:	53                   	push   %ebx
  80173d:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801740:	eb 17                	jmp    801759 <vprintfmt+0x21>
			if (ch == '\0')
  801742:	85 db                	test   %ebx,%ebx
  801744:	0f 84 af 03 00 00    	je     801af9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	ff 75 0c             	pushl  0xc(%ebp)
  801750:	53                   	push   %ebx
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	ff d0                	call   *%eax
  801756:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801759:	8b 45 10             	mov    0x10(%ebp),%eax
  80175c:	8d 50 01             	lea    0x1(%eax),%edx
  80175f:	89 55 10             	mov    %edx,0x10(%ebp)
  801762:	8a 00                	mov    (%eax),%al
  801764:	0f b6 d8             	movzbl %al,%ebx
  801767:	83 fb 25             	cmp    $0x25,%ebx
  80176a:	75 d6                	jne    801742 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80176c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801770:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801777:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80177e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801785:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80178c:	8b 45 10             	mov    0x10(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 10             	mov    %edx,0x10(%ebp)
  801795:	8a 00                	mov    (%eax),%al
  801797:	0f b6 d8             	movzbl %al,%ebx
  80179a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80179d:	83 f8 55             	cmp    $0x55,%eax
  8017a0:	0f 87 2b 03 00 00    	ja     801ad1 <vprintfmt+0x399>
  8017a6:	8b 04 85 b8 49 80 00 	mov    0x8049b8(,%eax,4),%eax
  8017ad:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8017af:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8017b3:	eb d7                	jmp    80178c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8017b5:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8017b9:	eb d1                	jmp    80178c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8017c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017c5:	89 d0                	mov    %edx,%eax
  8017c7:	c1 e0 02             	shl    $0x2,%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	01 c0                	add    %eax,%eax
  8017ce:	01 d8                	add    %ebx,%eax
  8017d0:	83 e8 30             	sub    $0x30,%eax
  8017d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8017d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8017de:	83 fb 2f             	cmp    $0x2f,%ebx
  8017e1:	7e 3e                	jle    801821 <vprintfmt+0xe9>
  8017e3:	83 fb 39             	cmp    $0x39,%ebx
  8017e6:	7f 39                	jg     801821 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8017e8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8017eb:	eb d5                	jmp    8017c2 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8017ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f0:	83 c0 04             	add    $0x4,%eax
  8017f3:	89 45 14             	mov    %eax,0x14(%ebp)
  8017f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f9:	83 e8 04             	sub    $0x4,%eax
  8017fc:	8b 00                	mov    (%eax),%eax
  8017fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801801:	eb 1f                	jmp    801822 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801807:	79 83                	jns    80178c <vprintfmt+0x54>
				width = 0;
  801809:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801810:	e9 77 ff ff ff       	jmp    80178c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801815:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80181c:	e9 6b ff ff ff       	jmp    80178c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801821:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801822:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801826:	0f 89 60 ff ff ff    	jns    80178c <vprintfmt+0x54>
				width = precision, precision = -1;
  80182c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801832:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801839:	e9 4e ff ff ff       	jmp    80178c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80183e:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801841:	e9 46 ff ff ff       	jmp    80178c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801846:	8b 45 14             	mov    0x14(%ebp),%eax
  801849:	83 c0 04             	add    $0x4,%eax
  80184c:	89 45 14             	mov    %eax,0x14(%ebp)
  80184f:	8b 45 14             	mov    0x14(%ebp),%eax
  801852:	83 e8 04             	sub    $0x4,%eax
  801855:	8b 00                	mov    (%eax),%eax
  801857:	83 ec 08             	sub    $0x8,%esp
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	50                   	push   %eax
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	ff d0                	call   *%eax
  801863:	83 c4 10             	add    $0x10,%esp
			break;
  801866:	e9 89 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80186b:	8b 45 14             	mov    0x14(%ebp),%eax
  80186e:	83 c0 04             	add    $0x4,%eax
  801871:	89 45 14             	mov    %eax,0x14(%ebp)
  801874:	8b 45 14             	mov    0x14(%ebp),%eax
  801877:	83 e8 04             	sub    $0x4,%eax
  80187a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80187c:	85 db                	test   %ebx,%ebx
  80187e:	79 02                	jns    801882 <vprintfmt+0x14a>
				err = -err;
  801880:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801882:	83 fb 64             	cmp    $0x64,%ebx
  801885:	7f 0b                	jg     801892 <vprintfmt+0x15a>
  801887:	8b 34 9d 00 48 80 00 	mov    0x804800(,%ebx,4),%esi
  80188e:	85 f6                	test   %esi,%esi
  801890:	75 19                	jne    8018ab <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801892:	53                   	push   %ebx
  801893:	68 a5 49 80 00       	push   $0x8049a5
  801898:	ff 75 0c             	pushl  0xc(%ebp)
  80189b:	ff 75 08             	pushl  0x8(%ebp)
  80189e:	e8 5e 02 00 00       	call   801b01 <printfmt>
  8018a3:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8018a6:	e9 49 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8018ab:	56                   	push   %esi
  8018ac:	68 ae 49 80 00       	push   $0x8049ae
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	ff 75 08             	pushl  0x8(%ebp)
  8018b7:	e8 45 02 00 00       	call   801b01 <printfmt>
  8018bc:	83 c4 10             	add    $0x10,%esp
			break;
  8018bf:	e9 30 02 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8018c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8018c7:	83 c0 04             	add    $0x4,%eax
  8018ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8018cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d0:	83 e8 04             	sub    $0x4,%eax
  8018d3:	8b 30                	mov    (%eax),%esi
  8018d5:	85 f6                	test   %esi,%esi
  8018d7:	75 05                	jne    8018de <vprintfmt+0x1a6>
				p = "(null)";
  8018d9:	be b1 49 80 00       	mov    $0x8049b1,%esi
			if (width > 0 && padc != '-')
  8018de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018e2:	7e 6d                	jle    801951 <vprintfmt+0x219>
  8018e4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8018e8:	74 67                	je     801951 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8018ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ed:	83 ec 08             	sub    $0x8,%esp
  8018f0:	50                   	push   %eax
  8018f1:	56                   	push   %esi
  8018f2:	e8 0c 03 00 00       	call   801c03 <strnlen>
  8018f7:	83 c4 10             	add    $0x10,%esp
  8018fa:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8018fd:	eb 16                	jmp    801915 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8018ff:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801903:	83 ec 08             	sub    $0x8,%esp
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	50                   	push   %eax
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	ff d0                	call   *%eax
  80190f:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801912:	ff 4d e4             	decl   -0x1c(%ebp)
  801915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801919:	7f e4                	jg     8018ff <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80191b:	eb 34                	jmp    801951 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80191d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801921:	74 1c                	je     80193f <vprintfmt+0x207>
  801923:	83 fb 1f             	cmp    $0x1f,%ebx
  801926:	7e 05                	jle    80192d <vprintfmt+0x1f5>
  801928:	83 fb 7e             	cmp    $0x7e,%ebx
  80192b:	7e 12                	jle    80193f <vprintfmt+0x207>
					putch('?', putdat);
  80192d:	83 ec 08             	sub    $0x8,%esp
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	6a 3f                	push   $0x3f
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	ff d0                	call   *%eax
  80193a:	83 c4 10             	add    $0x10,%esp
  80193d:	eb 0f                	jmp    80194e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80193f:	83 ec 08             	sub    $0x8,%esp
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	53                   	push   %ebx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	ff d0                	call   *%eax
  80194b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80194e:	ff 4d e4             	decl   -0x1c(%ebp)
  801951:	89 f0                	mov    %esi,%eax
  801953:	8d 70 01             	lea    0x1(%eax),%esi
  801956:	8a 00                	mov    (%eax),%al
  801958:	0f be d8             	movsbl %al,%ebx
  80195b:	85 db                	test   %ebx,%ebx
  80195d:	74 24                	je     801983 <vprintfmt+0x24b>
  80195f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801963:	78 b8                	js     80191d <vprintfmt+0x1e5>
  801965:	ff 4d e0             	decl   -0x20(%ebp)
  801968:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80196c:	79 af                	jns    80191d <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80196e:	eb 13                	jmp    801983 <vprintfmt+0x24b>
				putch(' ', putdat);
  801970:	83 ec 08             	sub    $0x8,%esp
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	6a 20                	push   $0x20
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	ff d0                	call   *%eax
  80197d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801980:	ff 4d e4             	decl   -0x1c(%ebp)
  801983:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801987:	7f e7                	jg     801970 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801989:	e9 66 01 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80198e:	83 ec 08             	sub    $0x8,%esp
  801991:	ff 75 e8             	pushl  -0x18(%ebp)
  801994:	8d 45 14             	lea    0x14(%ebp),%eax
  801997:	50                   	push   %eax
  801998:	e8 3c fd ff ff       	call   8016d9 <getint>
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8019a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ac:	85 d2                	test   %edx,%edx
  8019ae:	79 23                	jns    8019d3 <vprintfmt+0x29b>
				putch('-', putdat);
  8019b0:	83 ec 08             	sub    $0x8,%esp
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	6a 2d                	push   $0x2d
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	ff d0                	call   *%eax
  8019bd:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8019c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c6:	f7 d8                	neg    %eax
  8019c8:	83 d2 00             	adc    $0x0,%edx
  8019cb:	f7 da                	neg    %edx
  8019cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8019d3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019da:	e9 bc 00 00 00       	jmp    801a9b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8019df:	83 ec 08             	sub    $0x8,%esp
  8019e2:	ff 75 e8             	pushl  -0x18(%ebp)
  8019e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8019e8:	50                   	push   %eax
  8019e9:	e8 84 fc ff ff       	call   801672 <getuint>
  8019ee:	83 c4 10             	add    $0x10,%esp
  8019f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8019f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019fe:	e9 98 00 00 00       	jmp    801a9b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801a03:	83 ec 08             	sub    $0x8,%esp
  801a06:	ff 75 0c             	pushl  0xc(%ebp)
  801a09:	6a 58                	push   $0x58
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	ff d0                	call   *%eax
  801a10:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a13:	83 ec 08             	sub    $0x8,%esp
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	6a 58                	push   $0x58
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	ff d0                	call   *%eax
  801a20:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801a23:	83 ec 08             	sub    $0x8,%esp
  801a26:	ff 75 0c             	pushl  0xc(%ebp)
  801a29:	6a 58                	push   $0x58
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	ff d0                	call   *%eax
  801a30:	83 c4 10             	add    $0x10,%esp
			break;
  801a33:	e9 bc 00 00 00       	jmp    801af4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801a38:	83 ec 08             	sub    $0x8,%esp
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	6a 30                	push   $0x30
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	ff d0                	call   *%eax
  801a45:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801a48:	83 ec 08             	sub    $0x8,%esp
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	6a 78                	push   $0x78
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	ff d0                	call   *%eax
  801a55:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801a58:	8b 45 14             	mov    0x14(%ebp),%eax
  801a5b:	83 c0 04             	add    $0x4,%eax
  801a5e:	89 45 14             	mov    %eax,0x14(%ebp)
  801a61:	8b 45 14             	mov    0x14(%ebp),%eax
  801a64:	83 e8 04             	sub    $0x4,%eax
  801a67:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801a73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801a7a:	eb 1f                	jmp    801a9b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801a7c:	83 ec 08             	sub    $0x8,%esp
  801a7f:	ff 75 e8             	pushl  -0x18(%ebp)
  801a82:	8d 45 14             	lea    0x14(%ebp),%eax
  801a85:	50                   	push   %eax
  801a86:	e8 e7 fb ff ff       	call   801672 <getuint>
  801a8b:	83 c4 10             	add    $0x10,%esp
  801a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a91:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801a94:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801a9b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	52                   	push   %edx
  801aa6:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aa9:	50                   	push   %eax
  801aaa:	ff 75 f4             	pushl  -0xc(%ebp)
  801aad:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	ff 75 08             	pushl  0x8(%ebp)
  801ab6:	e8 00 fb ff ff       	call   8015bb <printnum>
  801abb:	83 c4 20             	add    $0x20,%esp
			break;
  801abe:	eb 34                	jmp    801af4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801ac0:	83 ec 08             	sub    $0x8,%esp
  801ac3:	ff 75 0c             	pushl  0xc(%ebp)
  801ac6:	53                   	push   %ebx
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	ff d0                	call   *%eax
  801acc:	83 c4 10             	add    $0x10,%esp
			break;
  801acf:	eb 23                	jmp    801af4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801ad1:	83 ec 08             	sub    $0x8,%esp
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	6a 25                	push   $0x25
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	ff d0                	call   *%eax
  801ade:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801ae1:	ff 4d 10             	decl   0x10(%ebp)
  801ae4:	eb 03                	jmp    801ae9 <vprintfmt+0x3b1>
  801ae6:	ff 4d 10             	decl   0x10(%ebp)
  801ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  801aec:	48                   	dec    %eax
  801aed:	8a 00                	mov    (%eax),%al
  801aef:	3c 25                	cmp    $0x25,%al
  801af1:	75 f3                	jne    801ae6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801af3:	90                   	nop
		}
	}
  801af4:	e9 47 fc ff ff       	jmp    801740 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801af9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801afa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801afd:	5b                   	pop    %ebx
  801afe:	5e                   	pop    %esi
  801aff:	5d                   	pop    %ebp
  801b00:	c3                   	ret    

00801b01 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801b07:	8d 45 10             	lea    0x10(%ebp),%eax
  801b0a:	83 c0 04             	add    $0x4,%eax
  801b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801b10:	8b 45 10             	mov    0x10(%ebp),%eax
  801b13:	ff 75 f4             	pushl  -0xc(%ebp)
  801b16:	50                   	push   %eax
  801b17:	ff 75 0c             	pushl  0xc(%ebp)
  801b1a:	ff 75 08             	pushl  0x8(%ebp)
  801b1d:	e8 16 fc ff ff       	call   801738 <vprintfmt>
  801b22:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801b25:	90                   	nop
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801b2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2e:	8b 40 08             	mov    0x8(%eax),%eax
  801b31:	8d 50 01             	lea    0x1(%eax),%edx
  801b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b37:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3d:	8b 10                	mov    (%eax),%edx
  801b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b42:	8b 40 04             	mov    0x4(%eax),%eax
  801b45:	39 c2                	cmp    %eax,%edx
  801b47:	73 12                	jae    801b5b <sprintputch+0x33>
		*b->buf++ = ch;
  801b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4c:	8b 00                	mov    (%eax),%eax
  801b4e:	8d 48 01             	lea    0x1(%eax),%ecx
  801b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b54:	89 0a                	mov    %ecx,(%edx)
  801b56:	8b 55 08             	mov    0x8(%ebp),%edx
  801b59:	88 10                	mov    %dl,(%eax)
}
  801b5b:	90                   	nop
  801b5c:	5d                   	pop    %ebp
  801b5d:	c3                   	ret    

00801b5e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	01 d0                	add    %edx,%eax
  801b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b83:	74 06                	je     801b8b <vsnprintf+0x2d>
  801b85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b89:	7f 07                	jg     801b92 <vsnprintf+0x34>
		return -E_INVAL;
  801b8b:	b8 03 00 00 00       	mov    $0x3,%eax
  801b90:	eb 20                	jmp    801bb2 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b92:	ff 75 14             	pushl  0x14(%ebp)
  801b95:	ff 75 10             	pushl  0x10(%ebp)
  801b98:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b9b:	50                   	push   %eax
  801b9c:	68 28 1b 80 00       	push   $0x801b28
  801ba1:	e8 92 fb ff ff       	call   801738 <vprintfmt>
  801ba6:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bac:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801bba:	8d 45 10             	lea    0x10(%ebp),%eax
  801bbd:	83 c0 04             	add    $0x4,%eax
  801bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc6:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc9:	50                   	push   %eax
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	e8 89 ff ff ff       	call   801b5e <vsnprintf>
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801be6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bed:	eb 06                	jmp    801bf5 <strlen+0x15>
		n++;
  801bef:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801bf2:	ff 45 08             	incl   0x8(%ebp)
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	8a 00                	mov    (%eax),%al
  801bfa:	84 c0                	test   %al,%al
  801bfc:	75 f1                	jne    801bef <strlen+0xf>
		n++;
	return n;
  801bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c10:	eb 09                	jmp    801c1b <strnlen+0x18>
		n++;
  801c12:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801c15:	ff 45 08             	incl   0x8(%ebp)
  801c18:	ff 4d 0c             	decl   0xc(%ebp)
  801c1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c1f:	74 09                	je     801c2a <strnlen+0x27>
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	8a 00                	mov    (%eax),%al
  801c26:	84 c0                	test   %al,%al
  801c28:	75 e8                	jne    801c12 <strnlen+0xf>
		n++;
	return n;
  801c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801c3b:	90                   	nop
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8d 50 01             	lea    0x1(%eax),%edx
  801c42:	89 55 08             	mov    %edx,0x8(%ebp)
  801c45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c48:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c4b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801c4e:	8a 12                	mov    (%edx),%dl
  801c50:	88 10                	mov    %dl,(%eax)
  801c52:	8a 00                	mov    (%eax),%al
  801c54:	84 c0                	test   %al,%al
  801c56:	75 e4                	jne    801c3c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801c63:	8b 45 08             	mov    0x8(%ebp),%eax
  801c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801c69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c70:	eb 1f                	jmp    801c91 <strncpy+0x34>
		*dst++ = *src;
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	8d 50 01             	lea    0x1(%eax),%edx
  801c78:	89 55 08             	mov    %edx,0x8(%ebp)
  801c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7e:	8a 12                	mov    (%edx),%dl
  801c80:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c85:	8a 00                	mov    (%eax),%al
  801c87:	84 c0                	test   %al,%al
  801c89:	74 03                	je     801c8e <strncpy+0x31>
			src++;
  801c8b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c8e:	ff 45 fc             	incl   -0x4(%ebp)
  801c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c94:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c97:	72 d9                	jb     801c72 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801caa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cae:	74 30                	je     801ce0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801cb0:	eb 16                	jmp    801cc8 <strlcpy+0x2a>
			*dst++ = *src++;
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	8d 50 01             	lea    0x1(%eax),%edx
  801cb8:	89 55 08             	mov    %edx,0x8(%ebp)
  801cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801cc1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801cc4:	8a 12                	mov    (%edx),%dl
  801cc6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801cc8:	ff 4d 10             	decl   0x10(%ebp)
  801ccb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ccf:	74 09                	je     801cda <strlcpy+0x3c>
  801cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd4:	8a 00                	mov    (%eax),%al
  801cd6:	84 c0                	test   %al,%al
  801cd8:	75 d8                	jne    801cb2 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ce6:	29 c2                	sub    %eax,%edx
  801ce8:	89 d0                	mov    %edx,%eax
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801cef:	eb 06                	jmp    801cf7 <strcmp+0xb>
		p++, q++;
  801cf1:	ff 45 08             	incl   0x8(%ebp)
  801cf4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	8a 00                	mov    (%eax),%al
  801cfc:	84 c0                	test   %al,%al
  801cfe:	74 0e                	je     801d0e <strcmp+0x22>
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	8a 10                	mov    (%eax),%dl
  801d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d08:	8a 00                	mov    (%eax),%al
  801d0a:	38 c2                	cmp    %al,%dl
  801d0c:	74 e3                	je     801cf1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	8a 00                	mov    (%eax),%al
  801d13:	0f b6 d0             	movzbl %al,%edx
  801d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d19:	8a 00                	mov    (%eax),%al
  801d1b:	0f b6 c0             	movzbl %al,%eax
  801d1e:	29 c2                	sub    %eax,%edx
  801d20:	89 d0                	mov    %edx,%eax
}
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    

00801d24 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801d27:	eb 09                	jmp    801d32 <strncmp+0xe>
		n--, p++, q++;
  801d29:	ff 4d 10             	decl   0x10(%ebp)
  801d2c:	ff 45 08             	incl   0x8(%ebp)
  801d2f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801d32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d36:	74 17                	je     801d4f <strncmp+0x2b>
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	8a 00                	mov    (%eax),%al
  801d3d:	84 c0                	test   %al,%al
  801d3f:	74 0e                	je     801d4f <strncmp+0x2b>
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	8a 10                	mov    (%eax),%dl
  801d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d49:	8a 00                	mov    (%eax),%al
  801d4b:	38 c2                	cmp    %al,%dl
  801d4d:	74 da                	je     801d29 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d53:	75 07                	jne    801d5c <strncmp+0x38>
		return 0;
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5a:	eb 14                	jmp    801d70 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	8a 00                	mov    (%eax),%al
  801d61:	0f b6 d0             	movzbl %al,%edx
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	8a 00                	mov    (%eax),%al
  801d69:	0f b6 c0             	movzbl %al,%eax
  801d6c:	29 c2                	sub    %eax,%edx
  801d6e:	89 d0                	mov    %edx,%eax
}
  801d70:	5d                   	pop    %ebp
  801d71:	c3                   	ret    

00801d72 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801d7e:	eb 12                	jmp    801d92 <strchr+0x20>
		if (*s == c)
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	8a 00                	mov    (%eax),%al
  801d85:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801d88:	75 05                	jne    801d8f <strchr+0x1d>
			return (char *) s;
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	eb 11                	jmp    801da0 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d8f:	ff 45 08             	incl   0x8(%ebp)
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	8a 00                	mov    (%eax),%al
  801d97:	84 c0                	test   %al,%al
  801d99:	75 e5                	jne    801d80 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
  801da5:	83 ec 04             	sub    $0x4,%esp
  801da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dab:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801dae:	eb 0d                	jmp    801dbd <strfind+0x1b>
		if (*s == c)
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	8a 00                	mov    (%eax),%al
  801db5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801db8:	74 0e                	je     801dc8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801dba:	ff 45 08             	incl   0x8(%ebp)
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	8a 00                	mov    (%eax),%al
  801dc2:	84 c0                	test   %al,%al
  801dc4:	75 ea                	jne    801db0 <strfind+0xe>
  801dc6:	eb 01                	jmp    801dc9 <strfind+0x27>
		if (*s == c)
			break;
  801dc8:	90                   	nop
	return (char *) s;
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801dda:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801de0:	eb 0e                	jmp    801df0 <memset+0x22>
		*p++ = c;
  801de2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de5:	8d 50 01             	lea    0x1(%eax),%edx
  801de8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dee:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801df0:	ff 4d f8             	decl   -0x8(%ebp)
  801df3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801df7:	79 e9                	jns    801de2 <memset+0x14>
		*p++ = c;

	return v;
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801e10:	eb 16                	jmp    801e28 <memcpy+0x2a>
		*d++ = *s++;
  801e12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e15:	8d 50 01             	lea    0x1(%eax),%edx
  801e18:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e1e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e21:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801e24:	8a 12                	mov    (%edx),%dl
  801e26:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801e28:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e2e:	89 55 10             	mov    %edx,0x10(%ebp)
  801e31:	85 c0                	test   %eax,%eax
  801e33:	75 dd                	jne    801e12 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e52:	73 50                	jae    801ea4 <memmove+0x6a>
  801e54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e57:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5a:	01 d0                	add    %edx,%eax
  801e5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e5f:	76 43                	jbe    801ea4 <memmove+0x6a>
		s += n;
  801e61:	8b 45 10             	mov    0x10(%ebp),%eax
  801e64:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801e67:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801e6d:	eb 10                	jmp    801e7f <memmove+0x45>
			*--d = *--s;
  801e6f:	ff 4d f8             	decl   -0x8(%ebp)
  801e72:	ff 4d fc             	decl   -0x4(%ebp)
  801e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e78:	8a 10                	mov    (%eax),%dl
  801e7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e7d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e82:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e85:	89 55 10             	mov    %edx,0x10(%ebp)
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	75 e3                	jne    801e6f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e8c:	eb 23                	jmp    801eb1 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e91:	8d 50 01             	lea    0x1(%eax),%edx
  801e94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ea0:	8a 12                	mov    (%edx),%dl
  801ea2:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	75 dd                	jne    801e8e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ec8:	eb 2a                	jmp    801ef4 <memcmp+0x3e>
		if (*s1 != *s2)
  801eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ecd:	8a 10                	mov    (%eax),%dl
  801ecf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ed2:	8a 00                	mov    (%eax),%al
  801ed4:	38 c2                	cmp    %al,%dl
  801ed6:	74 16                	je     801eee <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801ed8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801edb:	8a 00                	mov    (%eax),%al
  801edd:	0f b6 d0             	movzbl %al,%edx
  801ee0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ee3:	8a 00                	mov    (%eax),%al
  801ee5:	0f b6 c0             	movzbl %al,%eax
  801ee8:	29 c2                	sub    %eax,%edx
  801eea:	89 d0                	mov    %edx,%eax
  801eec:	eb 18                	jmp    801f06 <memcmp+0x50>
		s1++, s2++;
  801eee:	ff 45 fc             	incl   -0x4(%ebp)
  801ef1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef7:	8d 50 ff             	lea    -0x1(%eax),%edx
  801efa:	89 55 10             	mov    %edx,0x10(%ebp)
  801efd:	85 c0                	test   %eax,%eax
  801eff:	75 c9                	jne    801eca <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f11:	8b 45 10             	mov    0x10(%ebp),%eax
  801f14:	01 d0                	add    %edx,%eax
  801f16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801f19:	eb 15                	jmp    801f30 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	8a 00                	mov    (%eax),%al
  801f20:	0f b6 d0             	movzbl %al,%edx
  801f23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f26:	0f b6 c0             	movzbl %al,%eax
  801f29:	39 c2                	cmp    %eax,%edx
  801f2b:	74 0d                	je     801f3a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801f2d:	ff 45 08             	incl   0x8(%ebp)
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801f36:	72 e3                	jb     801f1b <memfind+0x13>
  801f38:	eb 01                	jmp    801f3b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801f3a:	90                   	nop
	return (void *) s;
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801f46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801f4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f54:	eb 03                	jmp    801f59 <strtol+0x19>
		s++;
  801f56:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	8a 00                	mov    (%eax),%al
  801f5e:	3c 20                	cmp    $0x20,%al
  801f60:	74 f4                	je     801f56 <strtol+0x16>
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	8a 00                	mov    (%eax),%al
  801f67:	3c 09                	cmp    $0x9,%al
  801f69:	74 eb                	je     801f56 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	8a 00                	mov    (%eax),%al
  801f70:	3c 2b                	cmp    $0x2b,%al
  801f72:	75 05                	jne    801f79 <strtol+0x39>
		s++;
  801f74:	ff 45 08             	incl   0x8(%ebp)
  801f77:	eb 13                	jmp    801f8c <strtol+0x4c>
	else if (*s == '-')
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	8a 00                	mov    (%eax),%al
  801f7e:	3c 2d                	cmp    $0x2d,%al
  801f80:	75 0a                	jne    801f8c <strtol+0x4c>
		s++, neg = 1;
  801f82:	ff 45 08             	incl   0x8(%ebp)
  801f85:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f90:	74 06                	je     801f98 <strtol+0x58>
  801f92:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801f96:	75 20                	jne    801fb8 <strtol+0x78>
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	8a 00                	mov    (%eax),%al
  801f9d:	3c 30                	cmp    $0x30,%al
  801f9f:	75 17                	jne    801fb8 <strtol+0x78>
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	40                   	inc    %eax
  801fa5:	8a 00                	mov    (%eax),%al
  801fa7:	3c 78                	cmp    $0x78,%al
  801fa9:	75 0d                	jne    801fb8 <strtol+0x78>
		s += 2, base = 16;
  801fab:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801faf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801fb6:	eb 28                	jmp    801fe0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801fb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fbc:	75 15                	jne    801fd3 <strtol+0x93>
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	8a 00                	mov    (%eax),%al
  801fc3:	3c 30                	cmp    $0x30,%al
  801fc5:	75 0c                	jne    801fd3 <strtol+0x93>
		s++, base = 8;
  801fc7:	ff 45 08             	incl   0x8(%ebp)
  801fca:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801fd1:	eb 0d                	jmp    801fe0 <strtol+0xa0>
	else if (base == 0)
  801fd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fd7:	75 07                	jne    801fe0 <strtol+0xa0>
		base = 10;
  801fd9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	8a 00                	mov    (%eax),%al
  801fe5:	3c 2f                	cmp    $0x2f,%al
  801fe7:	7e 19                	jle    802002 <strtol+0xc2>
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	8a 00                	mov    (%eax),%al
  801fee:	3c 39                	cmp    $0x39,%al
  801ff0:	7f 10                	jg     802002 <strtol+0xc2>
			dig = *s - '0';
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	8a 00                	mov    (%eax),%al
  801ff7:	0f be c0             	movsbl %al,%eax
  801ffa:	83 e8 30             	sub    $0x30,%eax
  801ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802000:	eb 42                	jmp    802044 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	8a 00                	mov    (%eax),%al
  802007:	3c 60                	cmp    $0x60,%al
  802009:	7e 19                	jle    802024 <strtol+0xe4>
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	8a 00                	mov    (%eax),%al
  802010:	3c 7a                	cmp    $0x7a,%al
  802012:	7f 10                	jg     802024 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	8a 00                	mov    (%eax),%al
  802019:	0f be c0             	movsbl %al,%eax
  80201c:	83 e8 57             	sub    $0x57,%eax
  80201f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802022:	eb 20                	jmp    802044 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	8a 00                	mov    (%eax),%al
  802029:	3c 40                	cmp    $0x40,%al
  80202b:	7e 39                	jle    802066 <strtol+0x126>
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	8a 00                	mov    (%eax),%al
  802032:	3c 5a                	cmp    $0x5a,%al
  802034:	7f 30                	jg     802066 <strtol+0x126>
			dig = *s - 'A' + 10;
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	8a 00                	mov    (%eax),%al
  80203b:	0f be c0             	movsbl %al,%eax
  80203e:	83 e8 37             	sub    $0x37,%eax
  802041:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	3b 45 10             	cmp    0x10(%ebp),%eax
  80204a:	7d 19                	jge    802065 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80204c:	ff 45 08             	incl   0x8(%ebp)
  80204f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802052:	0f af 45 10          	imul   0x10(%ebp),%eax
  802056:	89 c2                	mov    %eax,%edx
  802058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205b:	01 d0                	add    %edx,%eax
  80205d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802060:	e9 7b ff ff ff       	jmp    801fe0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802065:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802066:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80206a:	74 08                	je     802074 <strtol+0x134>
		*endptr = (char *) s;
  80206c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206f:	8b 55 08             	mov    0x8(%ebp),%edx
  802072:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802074:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802078:	74 07                	je     802081 <strtol+0x141>
  80207a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80207d:	f7 d8                	neg    %eax
  80207f:	eb 03                	jmp    802084 <strtol+0x144>
  802081:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <ltostr>:

void
ltostr(long value, char *str)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
  802089:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80208c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802093:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80209a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80209e:	79 13                	jns    8020b3 <ltostr+0x2d>
	{
		neg = 1;
  8020a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8020a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020aa:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8020ad:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8020b0:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8020bb:	99                   	cltd   
  8020bc:	f7 f9                	idiv   %ecx
  8020be:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8020c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020c4:	8d 50 01             	lea    0x1(%eax),%edx
  8020c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8020ca:	89 c2                	mov    %eax,%edx
  8020cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cf:	01 d0                	add    %edx,%eax
  8020d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020d4:	83 c2 30             	add    $0x30,%edx
  8020d7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8020d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020dc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8020e1:	f7 e9                	imul   %ecx
  8020e3:	c1 fa 02             	sar    $0x2,%edx
  8020e6:	89 c8                	mov    %ecx,%eax
  8020e8:	c1 f8 1f             	sar    $0x1f,%eax
  8020eb:	29 c2                	sub    %eax,%edx
  8020ed:	89 d0                	mov    %edx,%eax
  8020ef:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8020f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8020fa:	f7 e9                	imul   %ecx
  8020fc:	c1 fa 02             	sar    $0x2,%edx
  8020ff:	89 c8                	mov    %ecx,%eax
  802101:	c1 f8 1f             	sar    $0x1f,%eax
  802104:	29 c2                	sub    %eax,%edx
  802106:	89 d0                	mov    %edx,%eax
  802108:	c1 e0 02             	shl    $0x2,%eax
  80210b:	01 d0                	add    %edx,%eax
  80210d:	01 c0                	add    %eax,%eax
  80210f:	29 c1                	sub    %eax,%ecx
  802111:	89 ca                	mov    %ecx,%edx
  802113:	85 d2                	test   %edx,%edx
  802115:	75 9c                	jne    8020b3 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802117:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80211e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802121:	48                   	dec    %eax
  802122:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802125:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802129:	74 3d                	je     802168 <ltostr+0xe2>
		start = 1 ;
  80212b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802132:	eb 34                	jmp    802168 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213a:	01 d0                	add    %edx,%eax
  80213c:	8a 00                	mov    (%eax),%al
  80213e:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802141:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802144:	8b 45 0c             	mov    0xc(%ebp),%eax
  802147:	01 c2                	add    %eax,%edx
  802149:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80214c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214f:	01 c8                	add    %ecx,%eax
  802151:	8a 00                	mov    (%eax),%al
  802153:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802155:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215b:	01 c2                	add    %eax,%edx
  80215d:	8a 45 eb             	mov    -0x15(%ebp),%al
  802160:	88 02                	mov    %al,(%edx)
		start++ ;
  802162:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802165:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80216e:	7c c4                	jl     802134 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802170:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802173:	8b 45 0c             	mov    0xc(%ebp),%eax
  802176:	01 d0                	add    %edx,%eax
  802178:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80217b:	90                   	nop
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	e8 54 fa ff ff       	call   801be0 <strlen>
  80218c:	83 c4 04             	add    $0x4,%esp
  80218f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802192:	ff 75 0c             	pushl  0xc(%ebp)
  802195:	e8 46 fa ff ff       	call   801be0 <strlen>
  80219a:	83 c4 04             	add    $0x4,%esp
  80219d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8021a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8021a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8021ae:	eb 17                	jmp    8021c7 <strcconcat+0x49>
		final[s] = str1[s] ;
  8021b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b6:	01 c2                	add    %eax,%edx
  8021b8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	01 c8                	add    %ecx,%eax
  8021c0:	8a 00                	mov    (%eax),%al
  8021c2:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8021c4:	ff 45 fc             	incl   -0x4(%ebp)
  8021c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ca:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8021cd:	7c e1                	jl     8021b0 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8021cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8021d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8021dd:	eb 1f                	jmp    8021fe <strcconcat+0x80>
		final[s++] = str2[i] ;
  8021df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e2:	8d 50 01             	lea    0x1(%eax),%edx
  8021e5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8021e8:	89 c2                	mov    %eax,%edx
  8021ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ed:	01 c2                	add    %eax,%edx
  8021ef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8021f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f5:	01 c8                	add    %ecx,%eax
  8021f7:	8a 00                	mov    (%eax),%al
  8021f9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8021fb:	ff 45 f8             	incl   -0x8(%ebp)
  8021fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802201:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802204:	7c d9                	jl     8021df <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802206:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802209:	8b 45 10             	mov    0x10(%ebp),%eax
  80220c:	01 d0                	add    %edx,%eax
  80220e:	c6 00 00             	movb   $0x0,(%eax)
}
  802211:	90                   	nop
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802217:	8b 45 14             	mov    0x14(%ebp),%eax
  80221a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802220:	8b 45 14             	mov    0x14(%ebp),%eax
  802223:	8b 00                	mov    (%eax),%eax
  802225:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80222c:	8b 45 10             	mov    0x10(%ebp),%eax
  80222f:	01 d0                	add    %edx,%eax
  802231:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802237:	eb 0c                	jmp    802245 <strsplit+0x31>
			*string++ = 0;
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	8d 50 01             	lea    0x1(%eax),%edx
  80223f:	89 55 08             	mov    %edx,0x8(%ebp)
  802242:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8a 00                	mov    (%eax),%al
  80224a:	84 c0                	test   %al,%al
  80224c:	74 18                	je     802266 <strsplit+0x52>
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	8a 00                	mov    (%eax),%al
  802253:	0f be c0             	movsbl %al,%eax
  802256:	50                   	push   %eax
  802257:	ff 75 0c             	pushl  0xc(%ebp)
  80225a:	e8 13 fb ff ff       	call   801d72 <strchr>
  80225f:	83 c4 08             	add    $0x8,%esp
  802262:	85 c0                	test   %eax,%eax
  802264:	75 d3                	jne    802239 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8a 00                	mov    (%eax),%al
  80226b:	84 c0                	test   %al,%al
  80226d:	74 5a                	je     8022c9 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80226f:	8b 45 14             	mov    0x14(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	83 f8 0f             	cmp    $0xf,%eax
  802277:	75 07                	jne    802280 <strsplit+0x6c>
		{
			return 0;
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
  80227e:	eb 66                	jmp    8022e6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802280:	8b 45 14             	mov    0x14(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	8d 48 01             	lea    0x1(%eax),%ecx
  802288:	8b 55 14             	mov    0x14(%ebp),%edx
  80228b:	89 0a                	mov    %ecx,(%edx)
  80228d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802294:	8b 45 10             	mov    0x10(%ebp),%eax
  802297:	01 c2                	add    %eax,%edx
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80229e:	eb 03                	jmp    8022a3 <strsplit+0x8f>
			string++;
  8022a0:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8a 00                	mov    (%eax),%al
  8022a8:	84 c0                	test   %al,%al
  8022aa:	74 8b                	je     802237 <strsplit+0x23>
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8a 00                	mov    (%eax),%al
  8022b1:	0f be c0             	movsbl %al,%eax
  8022b4:	50                   	push   %eax
  8022b5:	ff 75 0c             	pushl  0xc(%ebp)
  8022b8:	e8 b5 fa ff ff       	call   801d72 <strchr>
  8022bd:	83 c4 08             	add    $0x8,%esp
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	74 dc                	je     8022a0 <strsplit+0x8c>
			string++;
	}
  8022c4:	e9 6e ff ff ff       	jmp    802237 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8022c9:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8022ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8022d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d9:	01 d0                	add    %edx,%eax
  8022db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8022e1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8022ee:	a1 04 50 80 00       	mov    0x805004,%eax
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	74 1f                	je     802316 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8022f7:	e8 1d 00 00 00       	call   802319 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8022fc:	83 ec 0c             	sub    $0xc,%esp
  8022ff:	68 10 4b 80 00       	push   $0x804b10
  802304:	e8 55 f2 ff ff       	call   80155e <cprintf>
  802309:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80230c:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  802313:	00 00 00 
	}
}
  802316:	90                   	nop
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  80231f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  802326:	00 00 00 
  802329:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  802330:	00 00 00 
  802333:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80233a:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  80233d:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  802344:	00 00 00 
  802347:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80234e:	00 00 00 
  802351:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  802358:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  80235b:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80236a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80236f:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  802374:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80237b:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80237e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802388:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  80238d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802390:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802393:	ba 00 00 00 00       	mov    $0x0,%edx
  802398:	f7 75 f0             	divl   -0x10(%ebp)
  80239b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239e:	29 d0                	sub    %edx,%eax
  8023a0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8023a3:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8023aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8023b2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8023b7:	83 ec 04             	sub    $0x4,%esp
  8023ba:	6a 06                	push   $0x6
  8023bc:	ff 75 e8             	pushl  -0x18(%ebp)
  8023bf:	50                   	push   %eax
  8023c0:	e8 d4 05 00 00       	call   802999 <sys_allocate_chunk>
  8023c5:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8023c8:	a1 20 51 80 00       	mov    0x805120,%eax
  8023cd:	83 ec 0c             	sub    $0xc,%esp
  8023d0:	50                   	push   %eax
  8023d1:	e8 49 0c 00 00       	call   80301f <initialize_MemBlocksList>
  8023d6:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8023d9:	a1 48 51 80 00       	mov    0x805148,%eax
  8023de:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8023e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8023e5:	75 14                	jne    8023fb <initialize_dyn_block_system+0xe2>
  8023e7:	83 ec 04             	sub    $0x4,%esp
  8023ea:	68 35 4b 80 00       	push   $0x804b35
  8023ef:	6a 39                	push   $0x39
  8023f1:	68 53 4b 80 00       	push   $0x804b53
  8023f6:	e8 af ee ff ff       	call   8012aa <_panic>
  8023fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023fe:	8b 00                	mov    (%eax),%eax
  802400:	85 c0                	test   %eax,%eax
  802402:	74 10                	je     802414 <initialize_dyn_block_system+0xfb>
  802404:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802407:	8b 00                	mov    (%eax),%eax
  802409:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80240c:	8b 52 04             	mov    0x4(%edx),%edx
  80240f:	89 50 04             	mov    %edx,0x4(%eax)
  802412:	eb 0b                	jmp    80241f <initialize_dyn_block_system+0x106>
  802414:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802417:	8b 40 04             	mov    0x4(%eax),%eax
  80241a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80241f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802422:	8b 40 04             	mov    0x4(%eax),%eax
  802425:	85 c0                	test   %eax,%eax
  802427:	74 0f                	je     802438 <initialize_dyn_block_system+0x11f>
  802429:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80242c:	8b 40 04             	mov    0x4(%eax),%eax
  80242f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802432:	8b 12                	mov    (%edx),%edx
  802434:	89 10                	mov    %edx,(%eax)
  802436:	eb 0a                	jmp    802442 <initialize_dyn_block_system+0x129>
  802438:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80243b:	8b 00                	mov    (%eax),%eax
  80243d:	a3 48 51 80 00       	mov    %eax,0x805148
  802442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802445:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80244b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80244e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802455:	a1 54 51 80 00       	mov    0x805154,%eax
  80245a:	48                   	dec    %eax
  80245b:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  802460:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802463:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80246a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80246d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  802474:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802478:	75 14                	jne    80248e <initialize_dyn_block_system+0x175>
  80247a:	83 ec 04             	sub    $0x4,%esp
  80247d:	68 60 4b 80 00       	push   $0x804b60
  802482:	6a 3f                	push   $0x3f
  802484:	68 53 4b 80 00       	push   $0x804b53
  802489:	e8 1c ee ff ff       	call   8012aa <_panic>
  80248e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802494:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802497:	89 10                	mov    %edx,(%eax)
  802499:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80249c:	8b 00                	mov    (%eax),%eax
  80249e:	85 c0                	test   %eax,%eax
  8024a0:	74 0d                	je     8024af <initialize_dyn_block_system+0x196>
  8024a2:	a1 38 51 80 00       	mov    0x805138,%eax
  8024a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024aa:	89 50 04             	mov    %edx,0x4(%eax)
  8024ad:	eb 08                	jmp    8024b7 <initialize_dyn_block_system+0x19e>
  8024af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ba:	a3 38 51 80 00       	mov    %eax,0x805138
  8024bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c9:	a1 44 51 80 00       	mov    0x805144,%eax
  8024ce:	40                   	inc    %eax
  8024cf:	a3 44 51 80 00       	mov    %eax,0x805144

}
  8024d4:	90                   	nop
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
  8024da:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8024dd:	e8 06 fe ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8024e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024e6:	75 07                	jne    8024ef <malloc+0x18>
  8024e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ed:	eb 7d                	jmp    80256c <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8024ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8024f6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8024fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802503:	01 d0                	add    %edx,%eax
  802505:	48                   	dec    %eax
  802506:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802509:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250c:	ba 00 00 00 00       	mov    $0x0,%edx
  802511:	f7 75 f0             	divl   -0x10(%ebp)
  802514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802517:	29 d0                	sub    %edx,%eax
  802519:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  80251c:	e8 46 08 00 00       	call   802d67 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802521:	83 f8 01             	cmp    $0x1,%eax
  802524:	75 07                	jne    80252d <malloc+0x56>
  802526:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  80252d:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802531:	75 34                	jne    802567 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  802533:	83 ec 0c             	sub    $0xc,%esp
  802536:	ff 75 e8             	pushl  -0x18(%ebp)
  802539:	e8 73 0e 00 00       	call   8033b1 <alloc_block_FF>
  80253e:	83 c4 10             	add    $0x10,%esp
  802541:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  802544:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802548:	74 16                	je     802560 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  80254a:	83 ec 0c             	sub    $0xc,%esp
  80254d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802550:	e8 ff 0b 00 00       	call   803154 <insert_sorted_allocList>
  802555:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  802558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80255b:	8b 40 08             	mov    0x8(%eax),%eax
  80255e:	eb 0c                	jmp    80256c <malloc+0x95>
	             }
	             else
	             	return NULL;
  802560:	b8 00 00 00 00       	mov    $0x0,%eax
  802565:	eb 05                	jmp    80256c <malloc+0x95>
	      	  }
	          else
	               return NULL;
  802567:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  80256c:	c9                   	leave  
  80256d:	c3                   	ret    

0080256e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80256e:	55                   	push   %ebp
  80256f:	89 e5                	mov    %esp,%ebp
  802571:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  802574:	8b 45 08             	mov    0x8(%ebp),%eax
  802577:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802583:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802588:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  80258b:	83 ec 08             	sub    $0x8,%esp
  80258e:	ff 75 f4             	pushl  -0xc(%ebp)
  802591:	68 40 50 80 00       	push   $0x805040
  802596:	e8 61 0b 00 00       	call   8030fc <find_block>
  80259b:	83 c4 10             	add    $0x10,%esp
  80259e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8025a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025a5:	0f 84 a5 00 00 00    	je     802650 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8025ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b1:	83 ec 08             	sub    $0x8,%esp
  8025b4:	50                   	push   %eax
  8025b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8025b8:	e8 a4 03 00 00       	call   802961 <sys_free_user_mem>
  8025bd:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8025c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025c4:	75 17                	jne    8025dd <free+0x6f>
  8025c6:	83 ec 04             	sub    $0x4,%esp
  8025c9:	68 35 4b 80 00       	push   $0x804b35
  8025ce:	68 87 00 00 00       	push   $0x87
  8025d3:	68 53 4b 80 00       	push   $0x804b53
  8025d8:	e8 cd ec ff ff       	call   8012aa <_panic>
  8025dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e0:	8b 00                	mov    (%eax),%eax
  8025e2:	85 c0                	test   %eax,%eax
  8025e4:	74 10                	je     8025f6 <free+0x88>
  8025e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e9:	8b 00                	mov    (%eax),%eax
  8025eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025ee:	8b 52 04             	mov    0x4(%edx),%edx
  8025f1:	89 50 04             	mov    %edx,0x4(%eax)
  8025f4:	eb 0b                	jmp    802601 <free+0x93>
  8025f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f9:	8b 40 04             	mov    0x4(%eax),%eax
  8025fc:	a3 44 50 80 00       	mov    %eax,0x805044
  802601:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802604:	8b 40 04             	mov    0x4(%eax),%eax
  802607:	85 c0                	test   %eax,%eax
  802609:	74 0f                	je     80261a <free+0xac>
  80260b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260e:	8b 40 04             	mov    0x4(%eax),%eax
  802611:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802614:	8b 12                	mov    (%edx),%edx
  802616:	89 10                	mov    %edx,(%eax)
  802618:	eb 0a                	jmp    802624 <free+0xb6>
  80261a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261d:	8b 00                	mov    (%eax),%eax
  80261f:	a3 40 50 80 00       	mov    %eax,0x805040
  802624:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802627:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802630:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802637:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80263c:	48                   	dec    %eax
  80263d:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  802642:	83 ec 0c             	sub    $0xc,%esp
  802645:	ff 75 ec             	pushl  -0x14(%ebp)
  802648:	e8 37 12 00 00       	call   803884 <insert_sorted_with_merge_freeList>
  80264d:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  802650:	90                   	nop
  802651:	c9                   	leave  
  802652:	c3                   	ret    

00802653 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
  802656:	83 ec 38             	sub    $0x38,%esp
  802659:	8b 45 10             	mov    0x10(%ebp),%eax
  80265c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80265f:	e8 84 fc ff ff       	call   8022e8 <InitializeUHeap>
	if (size == 0) return NULL ;
  802664:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802668:	75 07                	jne    802671 <smalloc+0x1e>
  80266a:	b8 00 00 00 00       	mov    $0x0,%eax
  80266f:	eb 7e                	jmp    8026ef <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  802671:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  802678:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80267f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802685:	01 d0                	add    %edx,%eax
  802687:	48                   	dec    %eax
  802688:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80268b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268e:	ba 00 00 00 00       	mov    $0x0,%edx
  802693:	f7 75 f0             	divl   -0x10(%ebp)
  802696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802699:	29 d0                	sub    %edx,%eax
  80269b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80269e:	e8 c4 06 00 00       	call   802d67 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8026a3:	83 f8 01             	cmp    $0x1,%eax
  8026a6:	75 42                	jne    8026ea <smalloc+0x97>

		  va = malloc(newsize) ;
  8026a8:	83 ec 0c             	sub    $0xc,%esp
  8026ab:	ff 75 e8             	pushl  -0x18(%ebp)
  8026ae:	e8 24 fe ff ff       	call   8024d7 <malloc>
  8026b3:	83 c4 10             	add    $0x10,%esp
  8026b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8026b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026bd:	74 24                	je     8026e3 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8026bf:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8026c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026c6:	50                   	push   %eax
  8026c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8026ca:	ff 75 08             	pushl  0x8(%ebp)
  8026cd:	e8 1a 04 00 00       	call   802aec <sys_createSharedObject>
  8026d2:	83 c4 10             	add    $0x10,%esp
  8026d5:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8026d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8026dc:	78 0c                	js     8026ea <smalloc+0x97>
					  return va ;
  8026de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e1:	eb 0c                	jmp    8026ef <smalloc+0x9c>
				 }
				 else
					return NULL;
  8026e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e8:	eb 05                	jmp    8026ef <smalloc+0x9c>
	  }
		  return NULL ;
  8026ea:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8026ef:	c9                   	leave  
  8026f0:	c3                   	ret    

008026f1 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
  8026f4:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8026f7:	e8 ec fb ff ff       	call   8022e8 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8026fc:	83 ec 08             	sub    $0x8,%esp
  8026ff:	ff 75 0c             	pushl  0xc(%ebp)
  802702:	ff 75 08             	pushl  0x8(%ebp)
  802705:	e8 0c 04 00 00       	call   802b16 <sys_getSizeOfSharedObject>
  80270a:	83 c4 10             	add    $0x10,%esp
  80270d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  802710:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802714:	75 07                	jne    80271d <sget+0x2c>
  802716:	b8 00 00 00 00       	mov    $0x0,%eax
  80271b:	eb 75                	jmp    802792 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80271d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802724:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272a:	01 d0                	add    %edx,%eax
  80272c:	48                   	dec    %eax
  80272d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802730:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802733:	ba 00 00 00 00       	mov    $0x0,%edx
  802738:	f7 75 f0             	divl   -0x10(%ebp)
  80273b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273e:	29 d0                	sub    %edx,%eax
  802740:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  802743:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80274a:	e8 18 06 00 00       	call   802d67 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80274f:	83 f8 01             	cmp    $0x1,%eax
  802752:	75 39                	jne    80278d <sget+0x9c>

		  va = malloc(newsize) ;
  802754:	83 ec 0c             	sub    $0xc,%esp
  802757:	ff 75 e8             	pushl  -0x18(%ebp)
  80275a:	e8 78 fd ff ff       	call   8024d7 <malloc>
  80275f:	83 c4 10             	add    $0x10,%esp
  802762:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  802765:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802769:	74 22                	je     80278d <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  80276b:	83 ec 04             	sub    $0x4,%esp
  80276e:	ff 75 e0             	pushl  -0x20(%ebp)
  802771:	ff 75 0c             	pushl  0xc(%ebp)
  802774:	ff 75 08             	pushl  0x8(%ebp)
  802777:	e8 b7 03 00 00       	call   802b33 <sys_getSharedObject>
  80277c:	83 c4 10             	add    $0x10,%esp
  80277f:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  802782:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802786:	78 05                	js     80278d <sget+0x9c>
					  return va;
  802788:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278b:	eb 05                	jmp    802792 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  80278d:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  802792:	c9                   	leave  
  802793:	c3                   	ret    

00802794 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802794:	55                   	push   %ebp
  802795:	89 e5                	mov    %esp,%ebp
  802797:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80279a:	e8 49 fb ff ff       	call   8022e8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80279f:	83 ec 04             	sub    $0x4,%esp
  8027a2:	68 84 4b 80 00       	push   $0x804b84
  8027a7:	68 1e 01 00 00       	push   $0x11e
  8027ac:	68 53 4b 80 00       	push   $0x804b53
  8027b1:	e8 f4 ea ff ff       	call   8012aa <_panic>

008027b6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
  8027b9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8027bc:	83 ec 04             	sub    $0x4,%esp
  8027bf:	68 ac 4b 80 00       	push   $0x804bac
  8027c4:	68 32 01 00 00       	push   $0x132
  8027c9:	68 53 4b 80 00       	push   $0x804b53
  8027ce:	e8 d7 ea ff ff       	call   8012aa <_panic>

008027d3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp
  8027d6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027d9:	83 ec 04             	sub    $0x4,%esp
  8027dc:	68 d0 4b 80 00       	push   $0x804bd0
  8027e1:	68 3d 01 00 00       	push   $0x13d
  8027e6:	68 53 4b 80 00       	push   $0x804b53
  8027eb:	e8 ba ea ff ff       	call   8012aa <_panic>

008027f0 <shrink>:

}
void shrink(uint32 newSize)
{
  8027f0:	55                   	push   %ebp
  8027f1:	89 e5                	mov    %esp,%ebp
  8027f3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027f6:	83 ec 04             	sub    $0x4,%esp
  8027f9:	68 d0 4b 80 00       	push   $0x804bd0
  8027fe:	68 42 01 00 00       	push   $0x142
  802803:	68 53 4b 80 00       	push   $0x804b53
  802808:	e8 9d ea ff ff       	call   8012aa <_panic>

0080280d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
  802810:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802813:	83 ec 04             	sub    $0x4,%esp
  802816:	68 d0 4b 80 00       	push   $0x804bd0
  80281b:	68 47 01 00 00       	push   $0x147
  802820:	68 53 4b 80 00       	push   $0x804b53
  802825:	e8 80 ea ff ff       	call   8012aa <_panic>

0080282a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
  80282d:	57                   	push   %edi
  80282e:	56                   	push   %esi
  80282f:	53                   	push   %ebx
  802830:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802833:	8b 45 08             	mov    0x8(%ebp),%eax
  802836:	8b 55 0c             	mov    0xc(%ebp),%edx
  802839:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80283c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80283f:	8b 7d 18             	mov    0x18(%ebp),%edi
  802842:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802845:	cd 30                	int    $0x30
  802847:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80284a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80284d:	83 c4 10             	add    $0x10,%esp
  802850:	5b                   	pop    %ebx
  802851:	5e                   	pop    %esi
  802852:	5f                   	pop    %edi
  802853:	5d                   	pop    %ebp
  802854:	c3                   	ret    

00802855 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802855:	55                   	push   %ebp
  802856:	89 e5                	mov    %esp,%ebp
  802858:	83 ec 04             	sub    $0x4,%esp
  80285b:	8b 45 10             	mov    0x10(%ebp),%eax
  80285e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802861:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802865:	8b 45 08             	mov    0x8(%ebp),%eax
  802868:	6a 00                	push   $0x0
  80286a:	6a 00                	push   $0x0
  80286c:	52                   	push   %edx
  80286d:	ff 75 0c             	pushl  0xc(%ebp)
  802870:	50                   	push   %eax
  802871:	6a 00                	push   $0x0
  802873:	e8 b2 ff ff ff       	call   80282a <syscall>
  802878:	83 c4 18             	add    $0x18,%esp
}
  80287b:	90                   	nop
  80287c:	c9                   	leave  
  80287d:	c3                   	ret    

0080287e <sys_cgetc>:

int
sys_cgetc(void)
{
  80287e:	55                   	push   %ebp
  80287f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802881:	6a 00                	push   $0x0
  802883:	6a 00                	push   $0x0
  802885:	6a 00                	push   $0x0
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 01                	push   $0x1
  80288d:	e8 98 ff ff ff       	call   80282a <syscall>
  802892:	83 c4 18             	add    $0x18,%esp
}
  802895:	c9                   	leave  
  802896:	c3                   	ret    

00802897 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802897:	55                   	push   %ebp
  802898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80289a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80289d:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a0:	6a 00                	push   $0x0
  8028a2:	6a 00                	push   $0x0
  8028a4:	6a 00                	push   $0x0
  8028a6:	52                   	push   %edx
  8028a7:	50                   	push   %eax
  8028a8:	6a 05                	push   $0x5
  8028aa:	e8 7b ff ff ff       	call   80282a <syscall>
  8028af:	83 c4 18             	add    $0x18,%esp
}
  8028b2:	c9                   	leave  
  8028b3:	c3                   	ret    

008028b4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8028b4:	55                   	push   %ebp
  8028b5:	89 e5                	mov    %esp,%ebp
  8028b7:	56                   	push   %esi
  8028b8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8028b9:	8b 75 18             	mov    0x18(%ebp),%esi
  8028bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c8:	56                   	push   %esi
  8028c9:	53                   	push   %ebx
  8028ca:	51                   	push   %ecx
  8028cb:	52                   	push   %edx
  8028cc:	50                   	push   %eax
  8028cd:	6a 06                	push   $0x6
  8028cf:	e8 56 ff ff ff       	call   80282a <syscall>
  8028d4:	83 c4 18             	add    $0x18,%esp
}
  8028d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8028da:	5b                   	pop    %ebx
  8028db:	5e                   	pop    %esi
  8028dc:	5d                   	pop    %ebp
  8028dd:	c3                   	ret    

008028de <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8028de:	55                   	push   %ebp
  8028df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8028e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e7:	6a 00                	push   $0x0
  8028e9:	6a 00                	push   $0x0
  8028eb:	6a 00                	push   $0x0
  8028ed:	52                   	push   %edx
  8028ee:	50                   	push   %eax
  8028ef:	6a 07                	push   $0x7
  8028f1:	e8 34 ff ff ff       	call   80282a <syscall>
  8028f6:	83 c4 18             	add    $0x18,%esp
}
  8028f9:	c9                   	leave  
  8028fa:	c3                   	ret    

008028fb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8028fb:	55                   	push   %ebp
  8028fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8028fe:	6a 00                	push   $0x0
  802900:	6a 00                	push   $0x0
  802902:	6a 00                	push   $0x0
  802904:	ff 75 0c             	pushl  0xc(%ebp)
  802907:	ff 75 08             	pushl  0x8(%ebp)
  80290a:	6a 08                	push   $0x8
  80290c:	e8 19 ff ff ff       	call   80282a <syscall>
  802911:	83 c4 18             	add    $0x18,%esp
}
  802914:	c9                   	leave  
  802915:	c3                   	ret    

00802916 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802919:	6a 00                	push   $0x0
  80291b:	6a 00                	push   $0x0
  80291d:	6a 00                	push   $0x0
  80291f:	6a 00                	push   $0x0
  802921:	6a 00                	push   $0x0
  802923:	6a 09                	push   $0x9
  802925:	e8 00 ff ff ff       	call   80282a <syscall>
  80292a:	83 c4 18             	add    $0x18,%esp
}
  80292d:	c9                   	leave  
  80292e:	c3                   	ret    

0080292f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80292f:	55                   	push   %ebp
  802930:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802932:	6a 00                	push   $0x0
  802934:	6a 00                	push   $0x0
  802936:	6a 00                	push   $0x0
  802938:	6a 00                	push   $0x0
  80293a:	6a 00                	push   $0x0
  80293c:	6a 0a                	push   $0xa
  80293e:	e8 e7 fe ff ff       	call   80282a <syscall>
  802943:	83 c4 18             	add    $0x18,%esp
}
  802946:	c9                   	leave  
  802947:	c3                   	ret    

00802948 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802948:	55                   	push   %ebp
  802949:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80294b:	6a 00                	push   $0x0
  80294d:	6a 00                	push   $0x0
  80294f:	6a 00                	push   $0x0
  802951:	6a 00                	push   $0x0
  802953:	6a 00                	push   $0x0
  802955:	6a 0b                	push   $0xb
  802957:	e8 ce fe ff ff       	call   80282a <syscall>
  80295c:	83 c4 18             	add    $0x18,%esp
}
  80295f:	c9                   	leave  
  802960:	c3                   	ret    

00802961 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802961:	55                   	push   %ebp
  802962:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802964:	6a 00                	push   $0x0
  802966:	6a 00                	push   $0x0
  802968:	6a 00                	push   $0x0
  80296a:	ff 75 0c             	pushl  0xc(%ebp)
  80296d:	ff 75 08             	pushl  0x8(%ebp)
  802970:	6a 0f                	push   $0xf
  802972:	e8 b3 fe ff ff       	call   80282a <syscall>
  802977:	83 c4 18             	add    $0x18,%esp
	return;
  80297a:	90                   	nop
}
  80297b:	c9                   	leave  
  80297c:	c3                   	ret    

0080297d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80297d:	55                   	push   %ebp
  80297e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802980:	6a 00                	push   $0x0
  802982:	6a 00                	push   $0x0
  802984:	6a 00                	push   $0x0
  802986:	ff 75 0c             	pushl  0xc(%ebp)
  802989:	ff 75 08             	pushl  0x8(%ebp)
  80298c:	6a 10                	push   $0x10
  80298e:	e8 97 fe ff ff       	call   80282a <syscall>
  802993:	83 c4 18             	add    $0x18,%esp
	return ;
  802996:	90                   	nop
}
  802997:	c9                   	leave  
  802998:	c3                   	ret    

00802999 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802999:	55                   	push   %ebp
  80299a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80299c:	6a 00                	push   $0x0
  80299e:	6a 00                	push   $0x0
  8029a0:	ff 75 10             	pushl  0x10(%ebp)
  8029a3:	ff 75 0c             	pushl  0xc(%ebp)
  8029a6:	ff 75 08             	pushl  0x8(%ebp)
  8029a9:	6a 11                	push   $0x11
  8029ab:	e8 7a fe ff ff       	call   80282a <syscall>
  8029b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8029b3:	90                   	nop
}
  8029b4:	c9                   	leave  
  8029b5:	c3                   	ret    

008029b6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8029b6:	55                   	push   %ebp
  8029b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 00                	push   $0x0
  8029bd:	6a 00                	push   $0x0
  8029bf:	6a 00                	push   $0x0
  8029c1:	6a 00                	push   $0x0
  8029c3:	6a 0c                	push   $0xc
  8029c5:	e8 60 fe ff ff       	call   80282a <syscall>
  8029ca:	83 c4 18             	add    $0x18,%esp
}
  8029cd:	c9                   	leave  
  8029ce:	c3                   	ret    

008029cf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8029cf:	55                   	push   %ebp
  8029d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8029d2:	6a 00                	push   $0x0
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	ff 75 08             	pushl  0x8(%ebp)
  8029dd:	6a 0d                	push   $0xd
  8029df:	e8 46 fe ff ff       	call   80282a <syscall>
  8029e4:	83 c4 18             	add    $0x18,%esp
}
  8029e7:	c9                   	leave  
  8029e8:	c3                   	ret    

008029e9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8029e9:	55                   	push   %ebp
  8029ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8029ec:	6a 00                	push   $0x0
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 00                	push   $0x0
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 00                	push   $0x0
  8029f6:	6a 0e                	push   $0xe
  8029f8:	e8 2d fe ff ff       	call   80282a <syscall>
  8029fd:	83 c4 18             	add    $0x18,%esp
}
  802a00:	90                   	nop
  802a01:	c9                   	leave  
  802a02:	c3                   	ret    

00802a03 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802a03:	55                   	push   %ebp
  802a04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802a06:	6a 00                	push   $0x0
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 00                	push   $0x0
  802a0e:	6a 00                	push   $0x0
  802a10:	6a 13                	push   $0x13
  802a12:	e8 13 fe ff ff       	call   80282a <syscall>
  802a17:	83 c4 18             	add    $0x18,%esp
}
  802a1a:	90                   	nop
  802a1b:	c9                   	leave  
  802a1c:	c3                   	ret    

00802a1d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802a1d:	55                   	push   %ebp
  802a1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802a20:	6a 00                	push   $0x0
  802a22:	6a 00                	push   $0x0
  802a24:	6a 00                	push   $0x0
  802a26:	6a 00                	push   $0x0
  802a28:	6a 00                	push   $0x0
  802a2a:	6a 14                	push   $0x14
  802a2c:	e8 f9 fd ff ff       	call   80282a <syscall>
  802a31:	83 c4 18             	add    $0x18,%esp
}
  802a34:	90                   	nop
  802a35:	c9                   	leave  
  802a36:	c3                   	ret    

00802a37 <sys_cputc>:


void
sys_cputc(const char c)
{
  802a37:	55                   	push   %ebp
  802a38:	89 e5                	mov    %esp,%ebp
  802a3a:	83 ec 04             	sub    $0x4,%esp
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802a43:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a47:	6a 00                	push   $0x0
  802a49:	6a 00                	push   $0x0
  802a4b:	6a 00                	push   $0x0
  802a4d:	6a 00                	push   $0x0
  802a4f:	50                   	push   %eax
  802a50:	6a 15                	push   $0x15
  802a52:	e8 d3 fd ff ff       	call   80282a <syscall>
  802a57:	83 c4 18             	add    $0x18,%esp
}
  802a5a:	90                   	nop
  802a5b:	c9                   	leave  
  802a5c:	c3                   	ret    

00802a5d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802a5d:	55                   	push   %ebp
  802a5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802a60:	6a 00                	push   $0x0
  802a62:	6a 00                	push   $0x0
  802a64:	6a 00                	push   $0x0
  802a66:	6a 00                	push   $0x0
  802a68:	6a 00                	push   $0x0
  802a6a:	6a 16                	push   $0x16
  802a6c:	e8 b9 fd ff ff       	call   80282a <syscall>
  802a71:	83 c4 18             	add    $0x18,%esp
}
  802a74:	90                   	nop
  802a75:	c9                   	leave  
  802a76:	c3                   	ret    

00802a77 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802a77:	55                   	push   %ebp
  802a78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7d:	6a 00                	push   $0x0
  802a7f:	6a 00                	push   $0x0
  802a81:	6a 00                	push   $0x0
  802a83:	ff 75 0c             	pushl  0xc(%ebp)
  802a86:	50                   	push   %eax
  802a87:	6a 17                	push   $0x17
  802a89:	e8 9c fd ff ff       	call   80282a <syscall>
  802a8e:	83 c4 18             	add    $0x18,%esp
}
  802a91:	c9                   	leave  
  802a92:	c3                   	ret    

00802a93 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802a93:	55                   	push   %ebp
  802a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802a96:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a99:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9c:	6a 00                	push   $0x0
  802a9e:	6a 00                	push   $0x0
  802aa0:	6a 00                	push   $0x0
  802aa2:	52                   	push   %edx
  802aa3:	50                   	push   %eax
  802aa4:	6a 1a                	push   $0x1a
  802aa6:	e8 7f fd ff ff       	call   80282a <syscall>
  802aab:	83 c4 18             	add    $0x18,%esp
}
  802aae:	c9                   	leave  
  802aaf:	c3                   	ret    

00802ab0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802ab0:	55                   	push   %ebp
  802ab1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	6a 00                	push   $0x0
  802abb:	6a 00                	push   $0x0
  802abd:	6a 00                	push   $0x0
  802abf:	52                   	push   %edx
  802ac0:	50                   	push   %eax
  802ac1:	6a 18                	push   $0x18
  802ac3:	e8 62 fd ff ff       	call   80282a <syscall>
  802ac8:	83 c4 18             	add    $0x18,%esp
}
  802acb:	90                   	nop
  802acc:	c9                   	leave  
  802acd:	c3                   	ret    

00802ace <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802ace:	55                   	push   %ebp
  802acf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	6a 00                	push   $0x0
  802ad9:	6a 00                	push   $0x0
  802adb:	6a 00                	push   $0x0
  802add:	52                   	push   %edx
  802ade:	50                   	push   %eax
  802adf:	6a 19                	push   $0x19
  802ae1:	e8 44 fd ff ff       	call   80282a <syscall>
  802ae6:	83 c4 18             	add    $0x18,%esp
}
  802ae9:	90                   	nop
  802aea:	c9                   	leave  
  802aeb:	c3                   	ret    

00802aec <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802aec:	55                   	push   %ebp
  802aed:	89 e5                	mov    %esp,%ebp
  802aef:	83 ec 04             	sub    $0x4,%esp
  802af2:	8b 45 10             	mov    0x10(%ebp),%eax
  802af5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802af8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802afb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802aff:	8b 45 08             	mov    0x8(%ebp),%eax
  802b02:	6a 00                	push   $0x0
  802b04:	51                   	push   %ecx
  802b05:	52                   	push   %edx
  802b06:	ff 75 0c             	pushl  0xc(%ebp)
  802b09:	50                   	push   %eax
  802b0a:	6a 1b                	push   $0x1b
  802b0c:	e8 19 fd ff ff       	call   80282a <syscall>
  802b11:	83 c4 18             	add    $0x18,%esp
}
  802b14:	c9                   	leave  
  802b15:	c3                   	ret    

00802b16 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802b16:	55                   	push   %ebp
  802b17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	6a 00                	push   $0x0
  802b21:	6a 00                	push   $0x0
  802b23:	6a 00                	push   $0x0
  802b25:	52                   	push   %edx
  802b26:	50                   	push   %eax
  802b27:	6a 1c                	push   $0x1c
  802b29:	e8 fc fc ff ff       	call   80282a <syscall>
  802b2e:	83 c4 18             	add    $0x18,%esp
}
  802b31:	c9                   	leave  
  802b32:	c3                   	ret    

00802b33 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802b33:	55                   	push   %ebp
  802b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802b36:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802b39:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	6a 00                	push   $0x0
  802b41:	6a 00                	push   $0x0
  802b43:	51                   	push   %ecx
  802b44:	52                   	push   %edx
  802b45:	50                   	push   %eax
  802b46:	6a 1d                	push   $0x1d
  802b48:	e8 dd fc ff ff       	call   80282a <syscall>
  802b4d:	83 c4 18             	add    $0x18,%esp
}
  802b50:	c9                   	leave  
  802b51:	c3                   	ret    

00802b52 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802b52:	55                   	push   %ebp
  802b53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b58:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5b:	6a 00                	push   $0x0
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 00                	push   $0x0
  802b61:	52                   	push   %edx
  802b62:	50                   	push   %eax
  802b63:	6a 1e                	push   $0x1e
  802b65:	e8 c0 fc ff ff       	call   80282a <syscall>
  802b6a:	83 c4 18             	add    $0x18,%esp
}
  802b6d:	c9                   	leave  
  802b6e:	c3                   	ret    

00802b6f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802b6f:	55                   	push   %ebp
  802b70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802b72:	6a 00                	push   $0x0
  802b74:	6a 00                	push   $0x0
  802b76:	6a 00                	push   $0x0
  802b78:	6a 00                	push   $0x0
  802b7a:	6a 00                	push   $0x0
  802b7c:	6a 1f                	push   $0x1f
  802b7e:	e8 a7 fc ff ff       	call   80282a <syscall>
  802b83:	83 c4 18             	add    $0x18,%esp
}
  802b86:	c9                   	leave  
  802b87:	c3                   	ret    

00802b88 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802b88:	55                   	push   %ebp
  802b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	6a 00                	push   $0x0
  802b90:	ff 75 14             	pushl  0x14(%ebp)
  802b93:	ff 75 10             	pushl  0x10(%ebp)
  802b96:	ff 75 0c             	pushl  0xc(%ebp)
  802b99:	50                   	push   %eax
  802b9a:	6a 20                	push   $0x20
  802b9c:	e8 89 fc ff ff       	call   80282a <syscall>
  802ba1:	83 c4 18             	add    $0x18,%esp
}
  802ba4:	c9                   	leave  
  802ba5:	c3                   	ret    

00802ba6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802ba6:	55                   	push   %ebp
  802ba7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	6a 00                	push   $0x0
  802bae:	6a 00                	push   $0x0
  802bb0:	6a 00                	push   $0x0
  802bb2:	6a 00                	push   $0x0
  802bb4:	50                   	push   %eax
  802bb5:	6a 21                	push   $0x21
  802bb7:	e8 6e fc ff ff       	call   80282a <syscall>
  802bbc:	83 c4 18             	add    $0x18,%esp
}
  802bbf:	90                   	nop
  802bc0:	c9                   	leave  
  802bc1:	c3                   	ret    

00802bc2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802bc2:	55                   	push   %ebp
  802bc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	6a 00                	push   $0x0
  802bca:	6a 00                	push   $0x0
  802bcc:	6a 00                	push   $0x0
  802bce:	6a 00                	push   $0x0
  802bd0:	50                   	push   %eax
  802bd1:	6a 22                	push   $0x22
  802bd3:	e8 52 fc ff ff       	call   80282a <syscall>
  802bd8:	83 c4 18             	add    $0x18,%esp
}
  802bdb:	c9                   	leave  
  802bdc:	c3                   	ret    

00802bdd <sys_getenvid>:

int32 sys_getenvid(void)
{
  802bdd:	55                   	push   %ebp
  802bde:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802be0:	6a 00                	push   $0x0
  802be2:	6a 00                	push   $0x0
  802be4:	6a 00                	push   $0x0
  802be6:	6a 00                	push   $0x0
  802be8:	6a 00                	push   $0x0
  802bea:	6a 02                	push   $0x2
  802bec:	e8 39 fc ff ff       	call   80282a <syscall>
  802bf1:	83 c4 18             	add    $0x18,%esp
}
  802bf4:	c9                   	leave  
  802bf5:	c3                   	ret    

00802bf6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802bf6:	55                   	push   %ebp
  802bf7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802bf9:	6a 00                	push   $0x0
  802bfb:	6a 00                	push   $0x0
  802bfd:	6a 00                	push   $0x0
  802bff:	6a 00                	push   $0x0
  802c01:	6a 00                	push   $0x0
  802c03:	6a 03                	push   $0x3
  802c05:	e8 20 fc ff ff       	call   80282a <syscall>
  802c0a:	83 c4 18             	add    $0x18,%esp
}
  802c0d:	c9                   	leave  
  802c0e:	c3                   	ret    

00802c0f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802c0f:	55                   	push   %ebp
  802c10:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802c12:	6a 00                	push   $0x0
  802c14:	6a 00                	push   $0x0
  802c16:	6a 00                	push   $0x0
  802c18:	6a 00                	push   $0x0
  802c1a:	6a 00                	push   $0x0
  802c1c:	6a 04                	push   $0x4
  802c1e:	e8 07 fc ff ff       	call   80282a <syscall>
  802c23:	83 c4 18             	add    $0x18,%esp
}
  802c26:	c9                   	leave  
  802c27:	c3                   	ret    

00802c28 <sys_exit_env>:


void sys_exit_env(void)
{
  802c28:	55                   	push   %ebp
  802c29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802c2b:	6a 00                	push   $0x0
  802c2d:	6a 00                	push   $0x0
  802c2f:	6a 00                	push   $0x0
  802c31:	6a 00                	push   $0x0
  802c33:	6a 00                	push   $0x0
  802c35:	6a 23                	push   $0x23
  802c37:	e8 ee fb ff ff       	call   80282a <syscall>
  802c3c:	83 c4 18             	add    $0x18,%esp
}
  802c3f:	90                   	nop
  802c40:	c9                   	leave  
  802c41:	c3                   	ret    

00802c42 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802c42:	55                   	push   %ebp
  802c43:	89 e5                	mov    %esp,%ebp
  802c45:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802c48:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c4b:	8d 50 04             	lea    0x4(%eax),%edx
  802c4e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802c51:	6a 00                	push   $0x0
  802c53:	6a 00                	push   $0x0
  802c55:	6a 00                	push   $0x0
  802c57:	52                   	push   %edx
  802c58:	50                   	push   %eax
  802c59:	6a 24                	push   $0x24
  802c5b:	e8 ca fb ff ff       	call   80282a <syscall>
  802c60:	83 c4 18             	add    $0x18,%esp
	return result;
  802c63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802c69:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802c6c:	89 01                	mov    %eax,(%ecx)
  802c6e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	c9                   	leave  
  802c75:	c2 04 00             	ret    $0x4

00802c78 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802c78:	55                   	push   %ebp
  802c79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802c7b:	6a 00                	push   $0x0
  802c7d:	6a 00                	push   $0x0
  802c7f:	ff 75 10             	pushl  0x10(%ebp)
  802c82:	ff 75 0c             	pushl  0xc(%ebp)
  802c85:	ff 75 08             	pushl  0x8(%ebp)
  802c88:	6a 12                	push   $0x12
  802c8a:	e8 9b fb ff ff       	call   80282a <syscall>
  802c8f:	83 c4 18             	add    $0x18,%esp
	return ;
  802c92:	90                   	nop
}
  802c93:	c9                   	leave  
  802c94:	c3                   	ret    

00802c95 <sys_rcr2>:
uint32 sys_rcr2()
{
  802c95:	55                   	push   %ebp
  802c96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802c98:	6a 00                	push   $0x0
  802c9a:	6a 00                	push   $0x0
  802c9c:	6a 00                	push   $0x0
  802c9e:	6a 00                	push   $0x0
  802ca0:	6a 00                	push   $0x0
  802ca2:	6a 25                	push   $0x25
  802ca4:	e8 81 fb ff ff       	call   80282a <syscall>
  802ca9:	83 c4 18             	add    $0x18,%esp
}
  802cac:	c9                   	leave  
  802cad:	c3                   	ret    

00802cae <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802cae:	55                   	push   %ebp
  802caf:	89 e5                	mov    %esp,%ebp
  802cb1:	83 ec 04             	sub    $0x4,%esp
  802cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802cba:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802cbe:	6a 00                	push   $0x0
  802cc0:	6a 00                	push   $0x0
  802cc2:	6a 00                	push   $0x0
  802cc4:	6a 00                	push   $0x0
  802cc6:	50                   	push   %eax
  802cc7:	6a 26                	push   $0x26
  802cc9:	e8 5c fb ff ff       	call   80282a <syscall>
  802cce:	83 c4 18             	add    $0x18,%esp
	return ;
  802cd1:	90                   	nop
}
  802cd2:	c9                   	leave  
  802cd3:	c3                   	ret    

00802cd4 <rsttst>:
void rsttst()
{
  802cd4:	55                   	push   %ebp
  802cd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802cd7:	6a 00                	push   $0x0
  802cd9:	6a 00                	push   $0x0
  802cdb:	6a 00                	push   $0x0
  802cdd:	6a 00                	push   $0x0
  802cdf:	6a 00                	push   $0x0
  802ce1:	6a 28                	push   $0x28
  802ce3:	e8 42 fb ff ff       	call   80282a <syscall>
  802ce8:	83 c4 18             	add    $0x18,%esp
	return ;
  802ceb:	90                   	nop
}
  802cec:	c9                   	leave  
  802ced:	c3                   	ret    

00802cee <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802cee:	55                   	push   %ebp
  802cef:	89 e5                	mov    %esp,%ebp
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	8b 45 14             	mov    0x14(%ebp),%eax
  802cf7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802cfa:	8b 55 18             	mov    0x18(%ebp),%edx
  802cfd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802d01:	52                   	push   %edx
  802d02:	50                   	push   %eax
  802d03:	ff 75 10             	pushl  0x10(%ebp)
  802d06:	ff 75 0c             	pushl  0xc(%ebp)
  802d09:	ff 75 08             	pushl  0x8(%ebp)
  802d0c:	6a 27                	push   $0x27
  802d0e:	e8 17 fb ff ff       	call   80282a <syscall>
  802d13:	83 c4 18             	add    $0x18,%esp
	return ;
  802d16:	90                   	nop
}
  802d17:	c9                   	leave  
  802d18:	c3                   	ret    

00802d19 <chktst>:
void chktst(uint32 n)
{
  802d19:	55                   	push   %ebp
  802d1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802d1c:	6a 00                	push   $0x0
  802d1e:	6a 00                	push   $0x0
  802d20:	6a 00                	push   $0x0
  802d22:	6a 00                	push   $0x0
  802d24:	ff 75 08             	pushl  0x8(%ebp)
  802d27:	6a 29                	push   $0x29
  802d29:	e8 fc fa ff ff       	call   80282a <syscall>
  802d2e:	83 c4 18             	add    $0x18,%esp
	return ;
  802d31:	90                   	nop
}
  802d32:	c9                   	leave  
  802d33:	c3                   	ret    

00802d34 <inctst>:

void inctst()
{
  802d34:	55                   	push   %ebp
  802d35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802d37:	6a 00                	push   $0x0
  802d39:	6a 00                	push   $0x0
  802d3b:	6a 00                	push   $0x0
  802d3d:	6a 00                	push   $0x0
  802d3f:	6a 00                	push   $0x0
  802d41:	6a 2a                	push   $0x2a
  802d43:	e8 e2 fa ff ff       	call   80282a <syscall>
  802d48:	83 c4 18             	add    $0x18,%esp
	return ;
  802d4b:	90                   	nop
}
  802d4c:	c9                   	leave  
  802d4d:	c3                   	ret    

00802d4e <gettst>:
uint32 gettst()
{
  802d4e:	55                   	push   %ebp
  802d4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802d51:	6a 00                	push   $0x0
  802d53:	6a 00                	push   $0x0
  802d55:	6a 00                	push   $0x0
  802d57:	6a 00                	push   $0x0
  802d59:	6a 00                	push   $0x0
  802d5b:	6a 2b                	push   $0x2b
  802d5d:	e8 c8 fa ff ff       	call   80282a <syscall>
  802d62:	83 c4 18             	add    $0x18,%esp
}
  802d65:	c9                   	leave  
  802d66:	c3                   	ret    

00802d67 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802d67:	55                   	push   %ebp
  802d68:	89 e5                	mov    %esp,%ebp
  802d6a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d6d:	6a 00                	push   $0x0
  802d6f:	6a 00                	push   $0x0
  802d71:	6a 00                	push   $0x0
  802d73:	6a 00                	push   $0x0
  802d75:	6a 00                	push   $0x0
  802d77:	6a 2c                	push   $0x2c
  802d79:	e8 ac fa ff ff       	call   80282a <syscall>
  802d7e:	83 c4 18             	add    $0x18,%esp
  802d81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802d84:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802d88:	75 07                	jne    802d91 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802d8a:	b8 01 00 00 00       	mov    $0x1,%eax
  802d8f:	eb 05                	jmp    802d96 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802d91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d96:	c9                   	leave  
  802d97:	c3                   	ret    

00802d98 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802d98:	55                   	push   %ebp
  802d99:	89 e5                	mov    %esp,%ebp
  802d9b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802d9e:	6a 00                	push   $0x0
  802da0:	6a 00                	push   $0x0
  802da2:	6a 00                	push   $0x0
  802da4:	6a 00                	push   $0x0
  802da6:	6a 00                	push   $0x0
  802da8:	6a 2c                	push   $0x2c
  802daa:	e8 7b fa ff ff       	call   80282a <syscall>
  802daf:	83 c4 18             	add    $0x18,%esp
  802db2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802db5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802db9:	75 07                	jne    802dc2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802dbb:	b8 01 00 00 00       	mov    $0x1,%eax
  802dc0:	eb 05                	jmp    802dc7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc7:	c9                   	leave  
  802dc8:	c3                   	ret    

00802dc9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802dc9:	55                   	push   %ebp
  802dca:	89 e5                	mov    %esp,%ebp
  802dcc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802dcf:	6a 00                	push   $0x0
  802dd1:	6a 00                	push   $0x0
  802dd3:	6a 00                	push   $0x0
  802dd5:	6a 00                	push   $0x0
  802dd7:	6a 00                	push   $0x0
  802dd9:	6a 2c                	push   $0x2c
  802ddb:	e8 4a fa ff ff       	call   80282a <syscall>
  802de0:	83 c4 18             	add    $0x18,%esp
  802de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802de6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802dea:	75 07                	jne    802df3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802dec:	b8 01 00 00 00       	mov    $0x1,%eax
  802df1:	eb 05                	jmp    802df8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df8:	c9                   	leave  
  802df9:	c3                   	ret    

00802dfa <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802dfa:	55                   	push   %ebp
  802dfb:	89 e5                	mov    %esp,%ebp
  802dfd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e00:	6a 00                	push   $0x0
  802e02:	6a 00                	push   $0x0
  802e04:	6a 00                	push   $0x0
  802e06:	6a 00                	push   $0x0
  802e08:	6a 00                	push   $0x0
  802e0a:	6a 2c                	push   $0x2c
  802e0c:	e8 19 fa ff ff       	call   80282a <syscall>
  802e11:	83 c4 18             	add    $0x18,%esp
  802e14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802e17:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802e1b:	75 07                	jne    802e24 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802e1d:	b8 01 00 00 00       	mov    $0x1,%eax
  802e22:	eb 05                	jmp    802e29 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802e24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e29:	c9                   	leave  
  802e2a:	c3                   	ret    

00802e2b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802e2b:	55                   	push   %ebp
  802e2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802e2e:	6a 00                	push   $0x0
  802e30:	6a 00                	push   $0x0
  802e32:	6a 00                	push   $0x0
  802e34:	6a 00                	push   $0x0
  802e36:	ff 75 08             	pushl  0x8(%ebp)
  802e39:	6a 2d                	push   $0x2d
  802e3b:	e8 ea f9 ff ff       	call   80282a <syscall>
  802e40:	83 c4 18             	add    $0x18,%esp
	return ;
  802e43:	90                   	nop
}
  802e44:	c9                   	leave  
  802e45:	c3                   	ret    

00802e46 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802e46:	55                   	push   %ebp
  802e47:	89 e5                	mov    %esp,%ebp
  802e49:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802e4a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802e4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802e50:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e53:	8b 45 08             	mov    0x8(%ebp),%eax
  802e56:	6a 00                	push   $0x0
  802e58:	53                   	push   %ebx
  802e59:	51                   	push   %ecx
  802e5a:	52                   	push   %edx
  802e5b:	50                   	push   %eax
  802e5c:	6a 2e                	push   $0x2e
  802e5e:	e8 c7 f9 ff ff       	call   80282a <syscall>
  802e63:	83 c4 18             	add    $0x18,%esp
}
  802e66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e69:	c9                   	leave  
  802e6a:	c3                   	ret    

00802e6b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802e6b:	55                   	push   %ebp
  802e6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802e6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	6a 00                	push   $0x0
  802e76:	6a 00                	push   $0x0
  802e78:	6a 00                	push   $0x0
  802e7a:	52                   	push   %edx
  802e7b:	50                   	push   %eax
  802e7c:	6a 2f                	push   $0x2f
  802e7e:	e8 a7 f9 ff ff       	call   80282a <syscall>
  802e83:	83 c4 18             	add    $0x18,%esp
}
  802e86:	c9                   	leave  
  802e87:	c3                   	ret    

00802e88 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802e88:	55                   	push   %ebp
  802e89:	89 e5                	mov    %esp,%ebp
  802e8b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802e8e:	83 ec 0c             	sub    $0xc,%esp
  802e91:	68 e0 4b 80 00       	push   $0x804be0
  802e96:	e8 c3 e6 ff ff       	call   80155e <cprintf>
  802e9b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802e9e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802ea5:	83 ec 0c             	sub    $0xc,%esp
  802ea8:	68 0c 4c 80 00       	push   $0x804c0c
  802ead:	e8 ac e6 ff ff       	call   80155e <cprintf>
  802eb2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802eb5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802eb9:	a1 38 51 80 00       	mov    0x805138,%eax
  802ebe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ec1:	eb 56                	jmp    802f19 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802ec3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec7:	74 1c                	je     802ee5 <print_mem_block_lists+0x5d>
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 50 08             	mov    0x8(%eax),%edx
  802ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed2:	8b 48 08             	mov    0x8(%eax),%ecx
  802ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed8:	8b 40 0c             	mov    0xc(%eax),%eax
  802edb:	01 c8                	add    %ecx,%eax
  802edd:	39 c2                	cmp    %eax,%edx
  802edf:	73 04                	jae    802ee5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802ee1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee8:	8b 50 08             	mov    0x8(%eax),%edx
  802eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eee:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef1:	01 c2                	add    %eax,%edx
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8b 40 08             	mov    0x8(%eax),%eax
  802ef9:	83 ec 04             	sub    $0x4,%esp
  802efc:	52                   	push   %edx
  802efd:	50                   	push   %eax
  802efe:	68 21 4c 80 00       	push   $0x804c21
  802f03:	e8 56 e6 ff ff       	call   80155e <cprintf>
  802f08:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802f11:	a1 40 51 80 00       	mov    0x805140,%eax
  802f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f1d:	74 07                	je     802f26 <print_mem_block_lists+0x9e>
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	8b 00                	mov    (%eax),%eax
  802f24:	eb 05                	jmp    802f2b <print_mem_block_lists+0xa3>
  802f26:	b8 00 00 00 00       	mov    $0x0,%eax
  802f2b:	a3 40 51 80 00       	mov    %eax,0x805140
  802f30:	a1 40 51 80 00       	mov    0x805140,%eax
  802f35:	85 c0                	test   %eax,%eax
  802f37:	75 8a                	jne    802ec3 <print_mem_block_lists+0x3b>
  802f39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3d:	75 84                	jne    802ec3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802f3f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802f43:	75 10                	jne    802f55 <print_mem_block_lists+0xcd>
  802f45:	83 ec 0c             	sub    $0xc,%esp
  802f48:	68 30 4c 80 00       	push   $0x804c30
  802f4d:	e8 0c e6 ff ff       	call   80155e <cprintf>
  802f52:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802f55:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802f5c:	83 ec 0c             	sub    $0xc,%esp
  802f5f:	68 54 4c 80 00       	push   $0x804c54
  802f64:	e8 f5 e5 ff ff       	call   80155e <cprintf>
  802f69:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802f6c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802f70:	a1 40 50 80 00       	mov    0x805040,%eax
  802f75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f78:	eb 56                	jmp    802fd0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802f7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f7e:	74 1c                	je     802f9c <print_mem_block_lists+0x114>
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	8b 50 08             	mov    0x8(%eax),%edx
  802f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f89:	8b 48 08             	mov    0x8(%eax),%ecx
  802f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f92:	01 c8                	add    %ecx,%eax
  802f94:	39 c2                	cmp    %eax,%edx
  802f96:	73 04                	jae    802f9c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802f98:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9f:	8b 50 08             	mov    0x8(%eax),%edx
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa8:	01 c2                	add    %eax,%edx
  802faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fad:	8b 40 08             	mov    0x8(%eax),%eax
  802fb0:	83 ec 04             	sub    $0x4,%esp
  802fb3:	52                   	push   %edx
  802fb4:	50                   	push   %eax
  802fb5:	68 21 4c 80 00       	push   $0x804c21
  802fba:	e8 9f e5 ff ff       	call   80155e <cprintf>
  802fbf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802fc8:	a1 48 50 80 00       	mov    0x805048,%eax
  802fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd4:	74 07                	je     802fdd <print_mem_block_lists+0x155>
  802fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd9:	8b 00                	mov    (%eax),%eax
  802fdb:	eb 05                	jmp    802fe2 <print_mem_block_lists+0x15a>
  802fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  802fe2:	a3 48 50 80 00       	mov    %eax,0x805048
  802fe7:	a1 48 50 80 00       	mov    0x805048,%eax
  802fec:	85 c0                	test   %eax,%eax
  802fee:	75 8a                	jne    802f7a <print_mem_block_lists+0xf2>
  802ff0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff4:	75 84                	jne    802f7a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802ff6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802ffa:	75 10                	jne    80300c <print_mem_block_lists+0x184>
  802ffc:	83 ec 0c             	sub    $0xc,%esp
  802fff:	68 6c 4c 80 00       	push   $0x804c6c
  803004:	e8 55 e5 ff ff       	call   80155e <cprintf>
  803009:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80300c:	83 ec 0c             	sub    $0xc,%esp
  80300f:	68 e0 4b 80 00       	push   $0x804be0
  803014:	e8 45 e5 ff ff       	call   80155e <cprintf>
  803019:	83 c4 10             	add    $0x10,%esp

}
  80301c:	90                   	nop
  80301d:	c9                   	leave  
  80301e:	c3                   	ret    

0080301f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80301f:	55                   	push   %ebp
  803020:	89 e5                	mov    %esp,%ebp
  803022:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  803025:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80302c:	00 00 00 
  80302f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  803036:	00 00 00 
  803039:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  803040:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  803043:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80304a:	e9 9e 00 00 00       	jmp    8030ed <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80304f:	a1 50 50 80 00       	mov    0x805050,%eax
  803054:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803057:	c1 e2 04             	shl    $0x4,%edx
  80305a:	01 d0                	add    %edx,%eax
  80305c:	85 c0                	test   %eax,%eax
  80305e:	75 14                	jne    803074 <initialize_MemBlocksList+0x55>
  803060:	83 ec 04             	sub    $0x4,%esp
  803063:	68 94 4c 80 00       	push   $0x804c94
  803068:	6a 47                	push   $0x47
  80306a:	68 b7 4c 80 00       	push   $0x804cb7
  80306f:	e8 36 e2 ff ff       	call   8012aa <_panic>
  803074:	a1 50 50 80 00       	mov    0x805050,%eax
  803079:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80307c:	c1 e2 04             	shl    $0x4,%edx
  80307f:	01 d0                	add    %edx,%eax
  803081:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803087:	89 10                	mov    %edx,(%eax)
  803089:	8b 00                	mov    (%eax),%eax
  80308b:	85 c0                	test   %eax,%eax
  80308d:	74 18                	je     8030a7 <initialize_MemBlocksList+0x88>
  80308f:	a1 48 51 80 00       	mov    0x805148,%eax
  803094:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80309a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80309d:	c1 e1 04             	shl    $0x4,%ecx
  8030a0:	01 ca                	add    %ecx,%edx
  8030a2:	89 50 04             	mov    %edx,0x4(%eax)
  8030a5:	eb 12                	jmp    8030b9 <initialize_MemBlocksList+0x9a>
  8030a7:	a1 50 50 80 00       	mov    0x805050,%eax
  8030ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030af:	c1 e2 04             	shl    $0x4,%edx
  8030b2:	01 d0                	add    %edx,%eax
  8030b4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030b9:	a1 50 50 80 00       	mov    0x805050,%eax
  8030be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030c1:	c1 e2 04             	shl    $0x4,%edx
  8030c4:	01 d0                	add    %edx,%eax
  8030c6:	a3 48 51 80 00       	mov    %eax,0x805148
  8030cb:	a1 50 50 80 00       	mov    0x805050,%eax
  8030d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030d3:	c1 e2 04             	shl    $0x4,%edx
  8030d6:	01 d0                	add    %edx,%eax
  8030d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030df:	a1 54 51 80 00       	mov    0x805154,%eax
  8030e4:	40                   	inc    %eax
  8030e5:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8030ea:	ff 45 f4             	incl   -0xc(%ebp)
  8030ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f3:	0f 82 56 ff ff ff    	jb     80304f <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8030f9:	90                   	nop
  8030fa:	c9                   	leave  
  8030fb:	c3                   	ret    

008030fc <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8030fc:	55                   	push   %ebp
  8030fd:	89 e5                	mov    %esp,%ebp
  8030ff:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  803102:	8b 45 08             	mov    0x8(%ebp),%eax
  803105:	8b 00                	mov    (%eax),%eax
  803107:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80310a:	eb 19                	jmp    803125 <find_block+0x29>
	{
		if(element->sva == va){
  80310c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80310f:	8b 40 08             	mov    0x8(%eax),%eax
  803112:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803115:	75 05                	jne    80311c <find_block+0x20>
			 		return element;
  803117:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80311a:	eb 36                	jmp    803152 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80311c:	8b 45 08             	mov    0x8(%ebp),%eax
  80311f:	8b 40 08             	mov    0x8(%eax),%eax
  803122:	89 45 fc             	mov    %eax,-0x4(%ebp)
  803125:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803129:	74 07                	je     803132 <find_block+0x36>
  80312b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80312e:	8b 00                	mov    (%eax),%eax
  803130:	eb 05                	jmp    803137 <find_block+0x3b>
  803132:	b8 00 00 00 00       	mov    $0x0,%eax
  803137:	8b 55 08             	mov    0x8(%ebp),%edx
  80313a:	89 42 08             	mov    %eax,0x8(%edx)
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	8b 40 08             	mov    0x8(%eax),%eax
  803143:	85 c0                	test   %eax,%eax
  803145:	75 c5                	jne    80310c <find_block+0x10>
  803147:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80314b:	75 bf                	jne    80310c <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  80314d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803152:	c9                   	leave  
  803153:	c3                   	ret    

00803154 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  803154:	55                   	push   %ebp
  803155:	89 e5                	mov    %esp,%ebp
  803157:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80315a:	a1 44 50 80 00       	mov    0x805044,%eax
  80315f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  803162:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803167:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80316a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80316e:	74 0a                	je     80317a <insert_sorted_allocList+0x26>
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	8b 40 08             	mov    0x8(%eax),%eax
  803176:	85 c0                	test   %eax,%eax
  803178:	75 65                	jne    8031df <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80317a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317e:	75 14                	jne    803194 <insert_sorted_allocList+0x40>
  803180:	83 ec 04             	sub    $0x4,%esp
  803183:	68 94 4c 80 00       	push   $0x804c94
  803188:	6a 6e                	push   $0x6e
  80318a:	68 b7 4c 80 00       	push   $0x804cb7
  80318f:	e8 16 e1 ff ff       	call   8012aa <_panic>
  803194:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80319a:	8b 45 08             	mov    0x8(%ebp),%eax
  80319d:	89 10                	mov    %edx,(%eax)
  80319f:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a2:	8b 00                	mov    (%eax),%eax
  8031a4:	85 c0                	test   %eax,%eax
  8031a6:	74 0d                	je     8031b5 <insert_sorted_allocList+0x61>
  8031a8:	a1 40 50 80 00       	mov    0x805040,%eax
  8031ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b0:	89 50 04             	mov    %edx,0x4(%eax)
  8031b3:	eb 08                	jmp    8031bd <insert_sorted_allocList+0x69>
  8031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b8:	a3 44 50 80 00       	mov    %eax,0x805044
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	a3 40 50 80 00       	mov    %eax,0x805040
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031cf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8031d4:	40                   	inc    %eax
  8031d5:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8031da:	e9 cf 01 00 00       	jmp    8033ae <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8031df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e2:	8b 50 08             	mov    0x8(%eax),%edx
  8031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e8:	8b 40 08             	mov    0x8(%eax),%eax
  8031eb:	39 c2                	cmp    %eax,%edx
  8031ed:	73 65                	jae    803254 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8031ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f3:	75 14                	jne    803209 <insert_sorted_allocList+0xb5>
  8031f5:	83 ec 04             	sub    $0x4,%esp
  8031f8:	68 d0 4c 80 00       	push   $0x804cd0
  8031fd:	6a 72                	push   $0x72
  8031ff:	68 b7 4c 80 00       	push   $0x804cb7
  803204:	e8 a1 e0 ff ff       	call   8012aa <_panic>
  803209:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	89 50 04             	mov    %edx,0x4(%eax)
  803215:	8b 45 08             	mov    0x8(%ebp),%eax
  803218:	8b 40 04             	mov    0x4(%eax),%eax
  80321b:	85 c0                	test   %eax,%eax
  80321d:	74 0c                	je     80322b <insert_sorted_allocList+0xd7>
  80321f:	a1 44 50 80 00       	mov    0x805044,%eax
  803224:	8b 55 08             	mov    0x8(%ebp),%edx
  803227:	89 10                	mov    %edx,(%eax)
  803229:	eb 08                	jmp    803233 <insert_sorted_allocList+0xdf>
  80322b:	8b 45 08             	mov    0x8(%ebp),%eax
  80322e:	a3 40 50 80 00       	mov    %eax,0x805040
  803233:	8b 45 08             	mov    0x8(%ebp),%eax
  803236:	a3 44 50 80 00       	mov    %eax,0x805044
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803244:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803249:	40                   	inc    %eax
  80324a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  80324f:	e9 5a 01 00 00       	jmp    8033ae <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  803254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803257:	8b 50 08             	mov    0x8(%eax),%edx
  80325a:	8b 45 08             	mov    0x8(%ebp),%eax
  80325d:	8b 40 08             	mov    0x8(%eax),%eax
  803260:	39 c2                	cmp    %eax,%edx
  803262:	75 70                	jne    8032d4 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  803264:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803268:	74 06                	je     803270 <insert_sorted_allocList+0x11c>
  80326a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80326e:	75 14                	jne    803284 <insert_sorted_allocList+0x130>
  803270:	83 ec 04             	sub    $0x4,%esp
  803273:	68 f4 4c 80 00       	push   $0x804cf4
  803278:	6a 75                	push   $0x75
  80327a:	68 b7 4c 80 00       	push   $0x804cb7
  80327f:	e8 26 e0 ff ff       	call   8012aa <_panic>
  803284:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803287:	8b 10                	mov    (%eax),%edx
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	89 10                	mov    %edx,(%eax)
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	8b 00                	mov    (%eax),%eax
  803293:	85 c0                	test   %eax,%eax
  803295:	74 0b                	je     8032a2 <insert_sorted_allocList+0x14e>
  803297:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329a:	8b 00                	mov    (%eax),%eax
  80329c:	8b 55 08             	mov    0x8(%ebp),%edx
  80329f:	89 50 04             	mov    %edx,0x4(%eax)
  8032a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a8:	89 10                	mov    %edx,(%eax)
  8032aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032b0:	89 50 04             	mov    %edx,0x4(%eax)
  8032b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b6:	8b 00                	mov    (%eax),%eax
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	75 08                	jne    8032c4 <insert_sorted_allocList+0x170>
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	a3 44 50 80 00       	mov    %eax,0x805044
  8032c4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8032c9:	40                   	inc    %eax
  8032ca:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8032cf:	e9 da 00 00 00       	jmp    8033ae <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8032d4:	a1 40 50 80 00       	mov    0x805040,%eax
  8032d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032dc:	e9 9d 00 00 00       	jmp    80337e <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8032e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e4:	8b 00                	mov    (%eax),%eax
  8032e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	8b 50 08             	mov    0x8(%eax),%edx
  8032ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f2:	8b 40 08             	mov    0x8(%eax),%eax
  8032f5:	39 c2                	cmp    %eax,%edx
  8032f7:	76 7d                	jbe    803376 <insert_sorted_allocList+0x222>
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	8b 50 08             	mov    0x8(%eax),%edx
  8032ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803302:	8b 40 08             	mov    0x8(%eax),%eax
  803305:	39 c2                	cmp    %eax,%edx
  803307:	73 6d                	jae    803376 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  803309:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80330d:	74 06                	je     803315 <insert_sorted_allocList+0x1c1>
  80330f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803313:	75 14                	jne    803329 <insert_sorted_allocList+0x1d5>
  803315:	83 ec 04             	sub    $0x4,%esp
  803318:	68 f4 4c 80 00       	push   $0x804cf4
  80331d:	6a 7c                	push   $0x7c
  80331f:	68 b7 4c 80 00       	push   $0x804cb7
  803324:	e8 81 df ff ff       	call   8012aa <_panic>
  803329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332c:	8b 10                	mov    (%eax),%edx
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	89 10                	mov    %edx,(%eax)
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	8b 00                	mov    (%eax),%eax
  803338:	85 c0                	test   %eax,%eax
  80333a:	74 0b                	je     803347 <insert_sorted_allocList+0x1f3>
  80333c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333f:	8b 00                	mov    (%eax),%eax
  803341:	8b 55 08             	mov    0x8(%ebp),%edx
  803344:	89 50 04             	mov    %edx,0x4(%eax)
  803347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334a:	8b 55 08             	mov    0x8(%ebp),%edx
  80334d:	89 10                	mov    %edx,(%eax)
  80334f:	8b 45 08             	mov    0x8(%ebp),%eax
  803352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803355:	89 50 04             	mov    %edx,0x4(%eax)
  803358:	8b 45 08             	mov    0x8(%ebp),%eax
  80335b:	8b 00                	mov    (%eax),%eax
  80335d:	85 c0                	test   %eax,%eax
  80335f:	75 08                	jne    803369 <insert_sorted_allocList+0x215>
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	a3 44 50 80 00       	mov    %eax,0x805044
  803369:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80336e:	40                   	inc    %eax
  80336f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  803374:	eb 38                	jmp    8033ae <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  803376:	a1 48 50 80 00       	mov    0x805048,%eax
  80337b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80337e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803382:	74 07                	je     80338b <insert_sorted_allocList+0x237>
  803384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803387:	8b 00                	mov    (%eax),%eax
  803389:	eb 05                	jmp    803390 <insert_sorted_allocList+0x23c>
  80338b:	b8 00 00 00 00       	mov    $0x0,%eax
  803390:	a3 48 50 80 00       	mov    %eax,0x805048
  803395:	a1 48 50 80 00       	mov    0x805048,%eax
  80339a:	85 c0                	test   %eax,%eax
  80339c:	0f 85 3f ff ff ff    	jne    8032e1 <insert_sorted_allocList+0x18d>
  8033a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a6:	0f 85 35 ff ff ff    	jne    8032e1 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8033ac:	eb 00                	jmp    8033ae <insert_sorted_allocList+0x25a>
  8033ae:	90                   	nop
  8033af:	c9                   	leave  
  8033b0:	c3                   	ret    

008033b1 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8033b1:	55                   	push   %ebp
  8033b2:	89 e5                	mov    %esp,%ebp
  8033b4:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8033b7:	a1 38 51 80 00       	mov    0x805138,%eax
  8033bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033bf:	e9 6b 02 00 00       	jmp    80362f <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8033c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033cd:	0f 85 90 00 00 00    	jne    803463 <alloc_block_FF+0xb2>
			  temp=element;
  8033d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8033d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033dd:	75 17                	jne    8033f6 <alloc_block_FF+0x45>
  8033df:	83 ec 04             	sub    $0x4,%esp
  8033e2:	68 28 4d 80 00       	push   $0x804d28
  8033e7:	68 92 00 00 00       	push   $0x92
  8033ec:	68 b7 4c 80 00       	push   $0x804cb7
  8033f1:	e8 b4 de ff ff       	call   8012aa <_panic>
  8033f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f9:	8b 00                	mov    (%eax),%eax
  8033fb:	85 c0                	test   %eax,%eax
  8033fd:	74 10                	je     80340f <alloc_block_FF+0x5e>
  8033ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803402:	8b 00                	mov    (%eax),%eax
  803404:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803407:	8b 52 04             	mov    0x4(%edx),%edx
  80340a:	89 50 04             	mov    %edx,0x4(%eax)
  80340d:	eb 0b                	jmp    80341a <alloc_block_FF+0x69>
  80340f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803412:	8b 40 04             	mov    0x4(%eax),%eax
  803415:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80341a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341d:	8b 40 04             	mov    0x4(%eax),%eax
  803420:	85 c0                	test   %eax,%eax
  803422:	74 0f                	je     803433 <alloc_block_FF+0x82>
  803424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803427:	8b 40 04             	mov    0x4(%eax),%eax
  80342a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80342d:	8b 12                	mov    (%edx),%edx
  80342f:	89 10                	mov    %edx,(%eax)
  803431:	eb 0a                	jmp    80343d <alloc_block_FF+0x8c>
  803433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803436:	8b 00                	mov    (%eax),%eax
  803438:	a3 38 51 80 00       	mov    %eax,0x805138
  80343d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803449:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803450:	a1 44 51 80 00       	mov    0x805144,%eax
  803455:	48                   	dec    %eax
  803456:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  80345b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345e:	e9 ff 01 00 00       	jmp    803662 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  803463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803466:	8b 40 0c             	mov    0xc(%eax),%eax
  803469:	3b 45 08             	cmp    0x8(%ebp),%eax
  80346c:	0f 86 b5 01 00 00    	jbe    803627 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  803472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803475:	8b 40 0c             	mov    0xc(%eax),%eax
  803478:	2b 45 08             	sub    0x8(%ebp),%eax
  80347b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80347e:	a1 48 51 80 00       	mov    0x805148,%eax
  803483:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  803486:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80348a:	75 17                	jne    8034a3 <alloc_block_FF+0xf2>
  80348c:	83 ec 04             	sub    $0x4,%esp
  80348f:	68 28 4d 80 00       	push   $0x804d28
  803494:	68 99 00 00 00       	push   $0x99
  803499:	68 b7 4c 80 00       	push   $0x804cb7
  80349e:	e8 07 de ff ff       	call   8012aa <_panic>
  8034a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a6:	8b 00                	mov    (%eax),%eax
  8034a8:	85 c0                	test   %eax,%eax
  8034aa:	74 10                	je     8034bc <alloc_block_FF+0x10b>
  8034ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034af:	8b 00                	mov    (%eax),%eax
  8034b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034b4:	8b 52 04             	mov    0x4(%edx),%edx
  8034b7:	89 50 04             	mov    %edx,0x4(%eax)
  8034ba:	eb 0b                	jmp    8034c7 <alloc_block_FF+0x116>
  8034bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034bf:	8b 40 04             	mov    0x4(%eax),%eax
  8034c2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ca:	8b 40 04             	mov    0x4(%eax),%eax
  8034cd:	85 c0                	test   %eax,%eax
  8034cf:	74 0f                	je     8034e0 <alloc_block_FF+0x12f>
  8034d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d4:	8b 40 04             	mov    0x4(%eax),%eax
  8034d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8034da:	8b 12                	mov    (%edx),%edx
  8034dc:	89 10                	mov    %edx,(%eax)
  8034de:	eb 0a                	jmp    8034ea <alloc_block_FF+0x139>
  8034e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e3:	8b 00                	mov    (%eax),%eax
  8034e5:	a3 48 51 80 00       	mov    %eax,0x805148
  8034ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034fd:	a1 54 51 80 00       	mov    0x805154,%eax
  803502:	48                   	dec    %eax
  803503:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  803508:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80350c:	75 17                	jne    803525 <alloc_block_FF+0x174>
  80350e:	83 ec 04             	sub    $0x4,%esp
  803511:	68 d0 4c 80 00       	push   $0x804cd0
  803516:	68 9a 00 00 00       	push   $0x9a
  80351b:	68 b7 4c 80 00       	push   $0x804cb7
  803520:	e8 85 dd ff ff       	call   8012aa <_panic>
  803525:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80352b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352e:	89 50 04             	mov    %edx,0x4(%eax)
  803531:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803534:	8b 40 04             	mov    0x4(%eax),%eax
  803537:	85 c0                	test   %eax,%eax
  803539:	74 0c                	je     803547 <alloc_block_FF+0x196>
  80353b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803540:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803543:	89 10                	mov    %edx,(%eax)
  803545:	eb 08                	jmp    80354f <alloc_block_FF+0x19e>
  803547:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80354a:	a3 38 51 80 00       	mov    %eax,0x805138
  80354f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803552:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803557:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803560:	a1 44 51 80 00       	mov    0x805144,%eax
  803565:	40                   	inc    %eax
  803566:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  80356b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356e:	8b 55 08             	mov    0x8(%ebp),%edx
  803571:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  803574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803577:	8b 50 08             	mov    0x8(%eax),%edx
  80357a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80357d:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  803580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803583:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803586:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  803589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358c:	8b 50 08             	mov    0x8(%eax),%edx
  80358f:	8b 45 08             	mov    0x8(%ebp),%eax
  803592:	01 c2                	add    %eax,%edx
  803594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803597:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  80359a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80359d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8035a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035a4:	75 17                	jne    8035bd <alloc_block_FF+0x20c>
  8035a6:	83 ec 04             	sub    $0x4,%esp
  8035a9:	68 28 4d 80 00       	push   $0x804d28
  8035ae:	68 a2 00 00 00       	push   $0xa2
  8035b3:	68 b7 4c 80 00       	push   $0x804cb7
  8035b8:	e8 ed dc ff ff       	call   8012aa <_panic>
  8035bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c0:	8b 00                	mov    (%eax),%eax
  8035c2:	85 c0                	test   %eax,%eax
  8035c4:	74 10                	je     8035d6 <alloc_block_FF+0x225>
  8035c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c9:	8b 00                	mov    (%eax),%eax
  8035cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035ce:	8b 52 04             	mov    0x4(%edx),%edx
  8035d1:	89 50 04             	mov    %edx,0x4(%eax)
  8035d4:	eb 0b                	jmp    8035e1 <alloc_block_FF+0x230>
  8035d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d9:	8b 40 04             	mov    0x4(%eax),%eax
  8035dc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e4:	8b 40 04             	mov    0x4(%eax),%eax
  8035e7:	85 c0                	test   %eax,%eax
  8035e9:	74 0f                	je     8035fa <alloc_block_FF+0x249>
  8035eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ee:	8b 40 04             	mov    0x4(%eax),%eax
  8035f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035f4:	8b 12                	mov    (%edx),%edx
  8035f6:	89 10                	mov    %edx,(%eax)
  8035f8:	eb 0a                	jmp    803604 <alloc_block_FF+0x253>
  8035fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fd:	8b 00                	mov    (%eax),%eax
  8035ff:	a3 38 51 80 00       	mov    %eax,0x805138
  803604:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803607:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80360d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803610:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803617:	a1 44 51 80 00       	mov    0x805144,%eax
  80361c:	48                   	dec    %eax
  80361d:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  803622:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803625:	eb 3b                	jmp    803662 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  803627:	a1 40 51 80 00       	mov    0x805140,%eax
  80362c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80362f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803633:	74 07                	je     80363c <alloc_block_FF+0x28b>
  803635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803638:	8b 00                	mov    (%eax),%eax
  80363a:	eb 05                	jmp    803641 <alloc_block_FF+0x290>
  80363c:	b8 00 00 00 00       	mov    $0x0,%eax
  803641:	a3 40 51 80 00       	mov    %eax,0x805140
  803646:	a1 40 51 80 00       	mov    0x805140,%eax
  80364b:	85 c0                	test   %eax,%eax
  80364d:	0f 85 71 fd ff ff    	jne    8033c4 <alloc_block_FF+0x13>
  803653:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803657:	0f 85 67 fd ff ff    	jne    8033c4 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  80365d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803662:	c9                   	leave  
  803663:	c3                   	ret    

00803664 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803664:	55                   	push   %ebp
  803665:	89 e5                	mov    %esp,%ebp
  803667:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  80366a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  803671:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  803678:	a1 38 51 80 00       	mov    0x805138,%eax
  80367d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803680:	e9 d3 00 00 00       	jmp    803758 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  803685:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803688:	8b 40 0c             	mov    0xc(%eax),%eax
  80368b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80368e:	0f 85 90 00 00 00    	jne    803724 <alloc_block_BF+0xc0>
	   temp = element;
  803694:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803697:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  80369a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80369e:	75 17                	jne    8036b7 <alloc_block_BF+0x53>
  8036a0:	83 ec 04             	sub    $0x4,%esp
  8036a3:	68 28 4d 80 00       	push   $0x804d28
  8036a8:	68 bd 00 00 00       	push   $0xbd
  8036ad:	68 b7 4c 80 00       	push   $0x804cb7
  8036b2:	e8 f3 db ff ff       	call   8012aa <_panic>
  8036b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ba:	8b 00                	mov    (%eax),%eax
  8036bc:	85 c0                	test   %eax,%eax
  8036be:	74 10                	je     8036d0 <alloc_block_BF+0x6c>
  8036c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c3:	8b 00                	mov    (%eax),%eax
  8036c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036c8:	8b 52 04             	mov    0x4(%edx),%edx
  8036cb:	89 50 04             	mov    %edx,0x4(%eax)
  8036ce:	eb 0b                	jmp    8036db <alloc_block_BF+0x77>
  8036d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d3:	8b 40 04             	mov    0x4(%eax),%eax
  8036d6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036de:	8b 40 04             	mov    0x4(%eax),%eax
  8036e1:	85 c0                	test   %eax,%eax
  8036e3:	74 0f                	je     8036f4 <alloc_block_BF+0x90>
  8036e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e8:	8b 40 04             	mov    0x4(%eax),%eax
  8036eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036ee:	8b 12                	mov    (%edx),%edx
  8036f0:	89 10                	mov    %edx,(%eax)
  8036f2:	eb 0a                	jmp    8036fe <alloc_block_BF+0x9a>
  8036f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f7:	8b 00                	mov    (%eax),%eax
  8036f9:	a3 38 51 80 00       	mov    %eax,0x805138
  8036fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803701:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803707:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803711:	a1 44 51 80 00       	mov    0x805144,%eax
  803716:	48                   	dec    %eax
  803717:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  80371c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80371f:	e9 41 01 00 00       	jmp    803865 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  803724:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803727:	8b 40 0c             	mov    0xc(%eax),%eax
  80372a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80372d:	76 21                	jbe    803750 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  80372f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803732:	8b 40 0c             	mov    0xc(%eax),%eax
  803735:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803738:	73 16                	jae    803750 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  80373a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373d:	8b 40 0c             	mov    0xc(%eax),%eax
  803740:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  803743:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803746:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  803749:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  803750:	a1 40 51 80 00       	mov    0x805140,%eax
  803755:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803758:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80375c:	74 07                	je     803765 <alloc_block_BF+0x101>
  80375e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803761:	8b 00                	mov    (%eax),%eax
  803763:	eb 05                	jmp    80376a <alloc_block_BF+0x106>
  803765:	b8 00 00 00 00       	mov    $0x0,%eax
  80376a:	a3 40 51 80 00       	mov    %eax,0x805140
  80376f:	a1 40 51 80 00       	mov    0x805140,%eax
  803774:	85 c0                	test   %eax,%eax
  803776:	0f 85 09 ff ff ff    	jne    803685 <alloc_block_BF+0x21>
  80377c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803780:	0f 85 ff fe ff ff    	jne    803685 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  803786:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80378a:	0f 85 d0 00 00 00    	jne    803860 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  803790:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803793:	8b 40 0c             	mov    0xc(%eax),%eax
  803796:	2b 45 08             	sub    0x8(%ebp),%eax
  803799:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  80379c:	a1 48 51 80 00       	mov    0x805148,%eax
  8037a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8037a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8037a8:	75 17                	jne    8037c1 <alloc_block_BF+0x15d>
  8037aa:	83 ec 04             	sub    $0x4,%esp
  8037ad:	68 28 4d 80 00       	push   $0x804d28
  8037b2:	68 d1 00 00 00       	push   $0xd1
  8037b7:	68 b7 4c 80 00       	push   $0x804cb7
  8037bc:	e8 e9 da ff ff       	call   8012aa <_panic>
  8037c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037c4:	8b 00                	mov    (%eax),%eax
  8037c6:	85 c0                	test   %eax,%eax
  8037c8:	74 10                	je     8037da <alloc_block_BF+0x176>
  8037ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037cd:	8b 00                	mov    (%eax),%eax
  8037cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037d2:	8b 52 04             	mov    0x4(%edx),%edx
  8037d5:	89 50 04             	mov    %edx,0x4(%eax)
  8037d8:	eb 0b                	jmp    8037e5 <alloc_block_BF+0x181>
  8037da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037dd:	8b 40 04             	mov    0x4(%eax),%eax
  8037e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037e8:	8b 40 04             	mov    0x4(%eax),%eax
  8037eb:	85 c0                	test   %eax,%eax
  8037ed:	74 0f                	je     8037fe <alloc_block_BF+0x19a>
  8037ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037f2:	8b 40 04             	mov    0x4(%eax),%eax
  8037f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8037f8:	8b 12                	mov    (%edx),%edx
  8037fa:	89 10                	mov    %edx,(%eax)
  8037fc:	eb 0a                	jmp    803808 <alloc_block_BF+0x1a4>
  8037fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803801:	8b 00                	mov    (%eax),%eax
  803803:	a3 48 51 80 00       	mov    %eax,0x805148
  803808:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80380b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803811:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803814:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80381b:	a1 54 51 80 00       	mov    0x805154,%eax
  803820:	48                   	dec    %eax
  803821:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  803826:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803829:	8b 55 08             	mov    0x8(%ebp),%edx
  80382c:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  80382f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803832:	8b 50 08             	mov    0x8(%eax),%edx
  803835:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803838:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  80383b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80383e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803841:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  803844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803847:	8b 50 08             	mov    0x8(%eax),%edx
  80384a:	8b 45 08             	mov    0x8(%ebp),%eax
  80384d:	01 c2                	add    %eax,%edx
  80384f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803852:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  803855:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803858:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  80385b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80385e:	eb 05                	jmp    803865 <alloc_block_BF+0x201>
	 }
	 return NULL;
  803860:	b8 00 00 00 00       	mov    $0x0,%eax


}
  803865:	c9                   	leave  
  803866:	c3                   	ret    

00803867 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803867:	55                   	push   %ebp
  803868:	89 e5                	mov    %esp,%ebp
  80386a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80386d:	83 ec 04             	sub    $0x4,%esp
  803870:	68 48 4d 80 00       	push   $0x804d48
  803875:	68 e8 00 00 00       	push   $0xe8
  80387a:	68 b7 4c 80 00       	push   $0x804cb7
  80387f:	e8 26 da ff ff       	call   8012aa <_panic>

00803884 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803884:	55                   	push   %ebp
  803885:	89 e5                	mov    %esp,%ebp
  803887:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  80388a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80388f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  803892:	a1 38 51 80 00       	mov    0x805138,%eax
  803897:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  80389a:	a1 44 51 80 00       	mov    0x805144,%eax
  80389f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8038a2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8038a6:	75 68                	jne    803910 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8038a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038ac:	75 17                	jne    8038c5 <insert_sorted_with_merge_freeList+0x41>
  8038ae:	83 ec 04             	sub    $0x4,%esp
  8038b1:	68 94 4c 80 00       	push   $0x804c94
  8038b6:	68 36 01 00 00       	push   $0x136
  8038bb:	68 b7 4c 80 00       	push   $0x804cb7
  8038c0:	e8 e5 d9 ff ff       	call   8012aa <_panic>
  8038c5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8038cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ce:	89 10                	mov    %edx,(%eax)
  8038d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d3:	8b 00                	mov    (%eax),%eax
  8038d5:	85 c0                	test   %eax,%eax
  8038d7:	74 0d                	je     8038e6 <insert_sorted_with_merge_freeList+0x62>
  8038d9:	a1 38 51 80 00       	mov    0x805138,%eax
  8038de:	8b 55 08             	mov    0x8(%ebp),%edx
  8038e1:	89 50 04             	mov    %edx,0x4(%eax)
  8038e4:	eb 08                	jmp    8038ee <insert_sorted_with_merge_freeList+0x6a>
  8038e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f1:	a3 38 51 80 00       	mov    %eax,0x805138
  8038f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803900:	a1 44 51 80 00       	mov    0x805144,%eax
  803905:	40                   	inc    %eax
  803906:	a3 44 51 80 00       	mov    %eax,0x805144





}
  80390b:	e9 ba 06 00 00       	jmp    803fca <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  803910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803913:	8b 50 08             	mov    0x8(%eax),%edx
  803916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803919:	8b 40 0c             	mov    0xc(%eax),%eax
  80391c:	01 c2                	add    %eax,%edx
  80391e:	8b 45 08             	mov    0x8(%ebp),%eax
  803921:	8b 40 08             	mov    0x8(%eax),%eax
  803924:	39 c2                	cmp    %eax,%edx
  803926:	73 68                	jae    803990 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803928:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80392c:	75 17                	jne    803945 <insert_sorted_with_merge_freeList+0xc1>
  80392e:	83 ec 04             	sub    $0x4,%esp
  803931:	68 d0 4c 80 00       	push   $0x804cd0
  803936:	68 3a 01 00 00       	push   $0x13a
  80393b:	68 b7 4c 80 00       	push   $0x804cb7
  803940:	e8 65 d9 ff ff       	call   8012aa <_panic>
  803945:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80394b:	8b 45 08             	mov    0x8(%ebp),%eax
  80394e:	89 50 04             	mov    %edx,0x4(%eax)
  803951:	8b 45 08             	mov    0x8(%ebp),%eax
  803954:	8b 40 04             	mov    0x4(%eax),%eax
  803957:	85 c0                	test   %eax,%eax
  803959:	74 0c                	je     803967 <insert_sorted_with_merge_freeList+0xe3>
  80395b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803960:	8b 55 08             	mov    0x8(%ebp),%edx
  803963:	89 10                	mov    %edx,(%eax)
  803965:	eb 08                	jmp    80396f <insert_sorted_with_merge_freeList+0xeb>
  803967:	8b 45 08             	mov    0x8(%ebp),%eax
  80396a:	a3 38 51 80 00       	mov    %eax,0x805138
  80396f:	8b 45 08             	mov    0x8(%ebp),%eax
  803972:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803977:	8b 45 08             	mov    0x8(%ebp),%eax
  80397a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803980:	a1 44 51 80 00       	mov    0x805144,%eax
  803985:	40                   	inc    %eax
  803986:	a3 44 51 80 00       	mov    %eax,0x805144





}
  80398b:	e9 3a 06 00 00       	jmp    803fca <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  803990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803993:	8b 50 08             	mov    0x8(%eax),%edx
  803996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803999:	8b 40 0c             	mov    0xc(%eax),%eax
  80399c:	01 c2                	add    %eax,%edx
  80399e:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a1:	8b 40 08             	mov    0x8(%eax),%eax
  8039a4:	39 c2                	cmp    %eax,%edx
  8039a6:	0f 85 90 00 00 00    	jne    803a3c <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8039ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039af:	8b 50 0c             	mov    0xc(%eax),%edx
  8039b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8039b8:	01 c2                	add    %eax,%edx
  8039ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039bd:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8039c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8039ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8039d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039d8:	75 17                	jne    8039f1 <insert_sorted_with_merge_freeList+0x16d>
  8039da:	83 ec 04             	sub    $0x4,%esp
  8039dd:	68 94 4c 80 00       	push   $0x804c94
  8039e2:	68 41 01 00 00       	push   $0x141
  8039e7:	68 b7 4c 80 00       	push   $0x804cb7
  8039ec:	e8 b9 d8 ff ff       	call   8012aa <_panic>
  8039f1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fa:	89 10                	mov    %edx,(%eax)
  8039fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ff:	8b 00                	mov    (%eax),%eax
  803a01:	85 c0                	test   %eax,%eax
  803a03:	74 0d                	je     803a12 <insert_sorted_with_merge_freeList+0x18e>
  803a05:	a1 48 51 80 00       	mov    0x805148,%eax
  803a0a:	8b 55 08             	mov    0x8(%ebp),%edx
  803a0d:	89 50 04             	mov    %edx,0x4(%eax)
  803a10:	eb 08                	jmp    803a1a <insert_sorted_with_merge_freeList+0x196>
  803a12:	8b 45 08             	mov    0x8(%ebp),%eax
  803a15:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1d:	a3 48 51 80 00       	mov    %eax,0x805148
  803a22:	8b 45 08             	mov    0x8(%ebp),%eax
  803a25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a2c:	a1 54 51 80 00       	mov    0x805154,%eax
  803a31:	40                   	inc    %eax
  803a32:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803a37:	e9 8e 05 00 00       	jmp    803fca <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  803a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3f:	8b 50 08             	mov    0x8(%eax),%edx
  803a42:	8b 45 08             	mov    0x8(%ebp),%eax
  803a45:	8b 40 0c             	mov    0xc(%eax),%eax
  803a48:	01 c2                	add    %eax,%edx
  803a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a4d:	8b 40 08             	mov    0x8(%eax),%eax
  803a50:	39 c2                	cmp    %eax,%edx
  803a52:	73 68                	jae    803abc <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803a54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a58:	75 17                	jne    803a71 <insert_sorted_with_merge_freeList+0x1ed>
  803a5a:	83 ec 04             	sub    $0x4,%esp
  803a5d:	68 94 4c 80 00       	push   $0x804c94
  803a62:	68 45 01 00 00       	push   $0x145
  803a67:	68 b7 4c 80 00       	push   $0x804cb7
  803a6c:	e8 39 d8 ff ff       	call   8012aa <_panic>
  803a71:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803a77:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7a:	89 10                	mov    %edx,(%eax)
  803a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7f:	8b 00                	mov    (%eax),%eax
  803a81:	85 c0                	test   %eax,%eax
  803a83:	74 0d                	je     803a92 <insert_sorted_with_merge_freeList+0x20e>
  803a85:	a1 38 51 80 00       	mov    0x805138,%eax
  803a8a:	8b 55 08             	mov    0x8(%ebp),%edx
  803a8d:	89 50 04             	mov    %edx,0x4(%eax)
  803a90:	eb 08                	jmp    803a9a <insert_sorted_with_merge_freeList+0x216>
  803a92:	8b 45 08             	mov    0x8(%ebp),%eax
  803a95:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9d:	a3 38 51 80 00       	mov    %eax,0x805138
  803aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aac:	a1 44 51 80 00       	mov    0x805144,%eax
  803ab1:	40                   	inc    %eax
  803ab2:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803ab7:	e9 0e 05 00 00       	jmp    803fca <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  803abc:	8b 45 08             	mov    0x8(%ebp),%eax
  803abf:	8b 50 08             	mov    0x8(%eax),%edx
  803ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac5:	8b 40 0c             	mov    0xc(%eax),%eax
  803ac8:	01 c2                	add    %eax,%edx
  803aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803acd:	8b 40 08             	mov    0x8(%eax),%eax
  803ad0:	39 c2                	cmp    %eax,%edx
  803ad2:	0f 85 9c 00 00 00    	jne    803b74 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  803ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803adb:	8b 50 0c             	mov    0xc(%eax),%edx
  803ade:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae1:	8b 40 0c             	mov    0xc(%eax),%eax
  803ae4:	01 c2                	add    %eax,%edx
  803ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ae9:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  803aec:	8b 45 08             	mov    0x8(%ebp),%eax
  803aef:	8b 50 08             	mov    0x8(%eax),%edx
  803af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803af5:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  803af8:	8b 45 08             	mov    0x8(%ebp),%eax
  803afb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  803b02:	8b 45 08             	mov    0x8(%ebp),%eax
  803b05:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803b0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b10:	75 17                	jne    803b29 <insert_sorted_with_merge_freeList+0x2a5>
  803b12:	83 ec 04             	sub    $0x4,%esp
  803b15:	68 94 4c 80 00       	push   $0x804c94
  803b1a:	68 4d 01 00 00       	push   $0x14d
  803b1f:	68 b7 4c 80 00       	push   $0x804cb7
  803b24:	e8 81 d7 ff ff       	call   8012aa <_panic>
  803b29:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b32:	89 10                	mov    %edx,(%eax)
  803b34:	8b 45 08             	mov    0x8(%ebp),%eax
  803b37:	8b 00                	mov    (%eax),%eax
  803b39:	85 c0                	test   %eax,%eax
  803b3b:	74 0d                	je     803b4a <insert_sorted_with_merge_freeList+0x2c6>
  803b3d:	a1 48 51 80 00       	mov    0x805148,%eax
  803b42:	8b 55 08             	mov    0x8(%ebp),%edx
  803b45:	89 50 04             	mov    %edx,0x4(%eax)
  803b48:	eb 08                	jmp    803b52 <insert_sorted_with_merge_freeList+0x2ce>
  803b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b52:	8b 45 08             	mov    0x8(%ebp),%eax
  803b55:	a3 48 51 80 00       	mov    %eax,0x805148
  803b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b64:	a1 54 51 80 00       	mov    0x805154,%eax
  803b69:	40                   	inc    %eax
  803b6a:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803b6f:	e9 56 04 00 00       	jmp    803fca <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803b74:	a1 38 51 80 00       	mov    0x805138,%eax
  803b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b7c:	e9 19 04 00 00       	jmp    803f9a <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  803b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b84:	8b 00                	mov    (%eax),%eax
  803b86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b8c:	8b 50 08             	mov    0x8(%eax),%edx
  803b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b92:	8b 40 0c             	mov    0xc(%eax),%eax
  803b95:	01 c2                	add    %eax,%edx
  803b97:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9a:	8b 40 08             	mov    0x8(%eax),%eax
  803b9d:	39 c2                	cmp    %eax,%edx
  803b9f:	0f 85 ad 01 00 00    	jne    803d52 <insert_sorted_with_merge_freeList+0x4ce>
  803ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba8:	8b 50 08             	mov    0x8(%eax),%edx
  803bab:	8b 45 08             	mov    0x8(%ebp),%eax
  803bae:	8b 40 0c             	mov    0xc(%eax),%eax
  803bb1:	01 c2                	add    %eax,%edx
  803bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb6:	8b 40 08             	mov    0x8(%eax),%eax
  803bb9:	39 c2                	cmp    %eax,%edx
  803bbb:	0f 85 91 01 00 00    	jne    803d52 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  803bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc4:	8b 50 0c             	mov    0xc(%eax),%edx
  803bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  803bca:	8b 48 0c             	mov    0xc(%eax),%ecx
  803bcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bd0:	8b 40 0c             	mov    0xc(%eax),%eax
  803bd3:	01 c8                	add    %ecx,%eax
  803bd5:	01 c2                	add    %eax,%edx
  803bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bda:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  803bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  803be0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803be7:	8b 45 08             	mov    0x8(%ebp),%eax
  803bea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  803bf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bf4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  803bfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bfe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  803c05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803c09:	75 17                	jne    803c22 <insert_sorted_with_merge_freeList+0x39e>
  803c0b:	83 ec 04             	sub    $0x4,%esp
  803c0e:	68 28 4d 80 00       	push   $0x804d28
  803c13:	68 5b 01 00 00       	push   $0x15b
  803c18:	68 b7 4c 80 00       	push   $0x804cb7
  803c1d:	e8 88 d6 ff ff       	call   8012aa <_panic>
  803c22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c25:	8b 00                	mov    (%eax),%eax
  803c27:	85 c0                	test   %eax,%eax
  803c29:	74 10                	je     803c3b <insert_sorted_with_merge_freeList+0x3b7>
  803c2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2e:	8b 00                	mov    (%eax),%eax
  803c30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c33:	8b 52 04             	mov    0x4(%edx),%edx
  803c36:	89 50 04             	mov    %edx,0x4(%eax)
  803c39:	eb 0b                	jmp    803c46 <insert_sorted_with_merge_freeList+0x3c2>
  803c3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c3e:	8b 40 04             	mov    0x4(%eax),%eax
  803c41:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c49:	8b 40 04             	mov    0x4(%eax),%eax
  803c4c:	85 c0                	test   %eax,%eax
  803c4e:	74 0f                	je     803c5f <insert_sorted_with_merge_freeList+0x3db>
  803c50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c53:	8b 40 04             	mov    0x4(%eax),%eax
  803c56:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c59:	8b 12                	mov    (%edx),%edx
  803c5b:	89 10                	mov    %edx,(%eax)
  803c5d:	eb 0a                	jmp    803c69 <insert_sorted_with_merge_freeList+0x3e5>
  803c5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c62:	8b 00                	mov    (%eax),%eax
  803c64:	a3 38 51 80 00       	mov    %eax,0x805138
  803c69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c7c:	a1 44 51 80 00       	mov    0x805144,%eax
  803c81:	48                   	dec    %eax
  803c82:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803c87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c8b:	75 17                	jne    803ca4 <insert_sorted_with_merge_freeList+0x420>
  803c8d:	83 ec 04             	sub    $0x4,%esp
  803c90:	68 94 4c 80 00       	push   $0x804c94
  803c95:	68 5c 01 00 00       	push   $0x15c
  803c9a:	68 b7 4c 80 00       	push   $0x804cb7
  803c9f:	e8 06 d6 ff ff       	call   8012aa <_panic>
  803ca4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803caa:	8b 45 08             	mov    0x8(%ebp),%eax
  803cad:	89 10                	mov    %edx,(%eax)
  803caf:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb2:	8b 00                	mov    (%eax),%eax
  803cb4:	85 c0                	test   %eax,%eax
  803cb6:	74 0d                	je     803cc5 <insert_sorted_with_merge_freeList+0x441>
  803cb8:	a1 48 51 80 00       	mov    0x805148,%eax
  803cbd:	8b 55 08             	mov    0x8(%ebp),%edx
  803cc0:	89 50 04             	mov    %edx,0x4(%eax)
  803cc3:	eb 08                	jmp    803ccd <insert_sorted_with_merge_freeList+0x449>
  803cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd0:	a3 48 51 80 00       	mov    %eax,0x805148
  803cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cdf:	a1 54 51 80 00       	mov    0x805154,%eax
  803ce4:	40                   	inc    %eax
  803ce5:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  803cea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cee:	75 17                	jne    803d07 <insert_sorted_with_merge_freeList+0x483>
  803cf0:	83 ec 04             	sub    $0x4,%esp
  803cf3:	68 94 4c 80 00       	push   $0x804c94
  803cf8:	68 5d 01 00 00       	push   $0x15d
  803cfd:	68 b7 4c 80 00       	push   $0x804cb7
  803d02:	e8 a3 d5 ff ff       	call   8012aa <_panic>
  803d07:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803d0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d10:	89 10                	mov    %edx,(%eax)
  803d12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d15:	8b 00                	mov    (%eax),%eax
  803d17:	85 c0                	test   %eax,%eax
  803d19:	74 0d                	je     803d28 <insert_sorted_with_merge_freeList+0x4a4>
  803d1b:	a1 48 51 80 00       	mov    0x805148,%eax
  803d20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d23:	89 50 04             	mov    %edx,0x4(%eax)
  803d26:	eb 08                	jmp    803d30 <insert_sorted_with_merge_freeList+0x4ac>
  803d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d2b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d33:	a3 48 51 80 00       	mov    %eax,0x805148
  803d38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d42:	a1 54 51 80 00       	mov    0x805154,%eax
  803d47:	40                   	inc    %eax
  803d48:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803d4d:	e9 78 02 00 00       	jmp    803fca <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d55:	8b 50 08             	mov    0x8(%eax),%edx
  803d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d5b:	8b 40 0c             	mov    0xc(%eax),%eax
  803d5e:	01 c2                	add    %eax,%edx
  803d60:	8b 45 08             	mov    0x8(%ebp),%eax
  803d63:	8b 40 08             	mov    0x8(%eax),%eax
  803d66:	39 c2                	cmp    %eax,%edx
  803d68:	0f 83 b8 00 00 00    	jae    803e26 <insert_sorted_with_merge_freeList+0x5a2>
  803d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d71:	8b 50 08             	mov    0x8(%eax),%edx
  803d74:	8b 45 08             	mov    0x8(%ebp),%eax
  803d77:	8b 40 0c             	mov    0xc(%eax),%eax
  803d7a:	01 c2                	add    %eax,%edx
  803d7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d7f:	8b 40 08             	mov    0x8(%eax),%eax
  803d82:	39 c2                	cmp    %eax,%edx
  803d84:	0f 85 9c 00 00 00    	jne    803e26 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  803d8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d8d:	8b 50 0c             	mov    0xc(%eax),%edx
  803d90:	8b 45 08             	mov    0x8(%ebp),%eax
  803d93:	8b 40 0c             	mov    0xc(%eax),%eax
  803d96:	01 c2                	add    %eax,%edx
  803d98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d9b:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  803d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  803da1:	8b 50 08             	mov    0x8(%eax),%edx
  803da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803da7:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  803daa:	8b 45 08             	mov    0x8(%ebp),%eax
  803dad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803db4:	8b 45 08             	mov    0x8(%ebp),%eax
  803db7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803dbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803dc2:	75 17                	jne    803ddb <insert_sorted_with_merge_freeList+0x557>
  803dc4:	83 ec 04             	sub    $0x4,%esp
  803dc7:	68 94 4c 80 00       	push   $0x804c94
  803dcc:	68 67 01 00 00       	push   $0x167
  803dd1:	68 b7 4c 80 00       	push   $0x804cb7
  803dd6:	e8 cf d4 ff ff       	call   8012aa <_panic>
  803ddb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803de1:	8b 45 08             	mov    0x8(%ebp),%eax
  803de4:	89 10                	mov    %edx,(%eax)
  803de6:	8b 45 08             	mov    0x8(%ebp),%eax
  803de9:	8b 00                	mov    (%eax),%eax
  803deb:	85 c0                	test   %eax,%eax
  803ded:	74 0d                	je     803dfc <insert_sorted_with_merge_freeList+0x578>
  803def:	a1 48 51 80 00       	mov    0x805148,%eax
  803df4:	8b 55 08             	mov    0x8(%ebp),%edx
  803df7:	89 50 04             	mov    %edx,0x4(%eax)
  803dfa:	eb 08                	jmp    803e04 <insert_sorted_with_merge_freeList+0x580>
  803dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  803dff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803e04:	8b 45 08             	mov    0x8(%ebp),%eax
  803e07:	a3 48 51 80 00       	mov    %eax,0x805148
  803e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e16:	a1 54 51 80 00       	mov    0x805154,%eax
  803e1b:	40                   	inc    %eax
  803e1c:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803e21:	e9 a4 01 00 00       	jmp    803fca <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e29:	8b 50 08             	mov    0x8(%eax),%edx
  803e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2f:	8b 40 0c             	mov    0xc(%eax),%eax
  803e32:	01 c2                	add    %eax,%edx
  803e34:	8b 45 08             	mov    0x8(%ebp),%eax
  803e37:	8b 40 08             	mov    0x8(%eax),%eax
  803e3a:	39 c2                	cmp    %eax,%edx
  803e3c:	0f 85 ac 00 00 00    	jne    803eee <insert_sorted_with_merge_freeList+0x66a>
  803e42:	8b 45 08             	mov    0x8(%ebp),%eax
  803e45:	8b 50 08             	mov    0x8(%eax),%edx
  803e48:	8b 45 08             	mov    0x8(%ebp),%eax
  803e4b:	8b 40 0c             	mov    0xc(%eax),%eax
  803e4e:	01 c2                	add    %eax,%edx
  803e50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e53:	8b 40 08             	mov    0x8(%eax),%eax
  803e56:	39 c2                	cmp    %eax,%edx
  803e58:	0f 83 90 00 00 00    	jae    803eee <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  803e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e61:	8b 50 0c             	mov    0xc(%eax),%edx
  803e64:	8b 45 08             	mov    0x8(%ebp),%eax
  803e67:	8b 40 0c             	mov    0xc(%eax),%eax
  803e6a:	01 c2                	add    %eax,%edx
  803e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e6f:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  803e72:	8b 45 08             	mov    0x8(%ebp),%eax
  803e75:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  803e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e7f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803e86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e8a:	75 17                	jne    803ea3 <insert_sorted_with_merge_freeList+0x61f>
  803e8c:	83 ec 04             	sub    $0x4,%esp
  803e8f:	68 94 4c 80 00       	push   $0x804c94
  803e94:	68 70 01 00 00       	push   $0x170
  803e99:	68 b7 4c 80 00       	push   $0x804cb7
  803e9e:	e8 07 d4 ff ff       	call   8012aa <_panic>
  803ea3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  803eac:	89 10                	mov    %edx,(%eax)
  803eae:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb1:	8b 00                	mov    (%eax),%eax
  803eb3:	85 c0                	test   %eax,%eax
  803eb5:	74 0d                	je     803ec4 <insert_sorted_with_merge_freeList+0x640>
  803eb7:	a1 48 51 80 00       	mov    0x805148,%eax
  803ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  803ebf:	89 50 04             	mov    %edx,0x4(%eax)
  803ec2:	eb 08                	jmp    803ecc <insert_sorted_with_merge_freeList+0x648>
  803ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  803ecf:	a3 48 51 80 00       	mov    %eax,0x805148
  803ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ede:	a1 54 51 80 00       	mov    0x805154,%eax
  803ee3:	40                   	inc    %eax
  803ee4:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  803ee9:	e9 dc 00 00 00       	jmp    803fca <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef1:	8b 50 08             	mov    0x8(%eax),%edx
  803ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef7:	8b 40 0c             	mov    0xc(%eax),%eax
  803efa:	01 c2                	add    %eax,%edx
  803efc:	8b 45 08             	mov    0x8(%ebp),%eax
  803eff:	8b 40 08             	mov    0x8(%eax),%eax
  803f02:	39 c2                	cmp    %eax,%edx
  803f04:	0f 83 88 00 00 00    	jae    803f92 <insert_sorted_with_merge_freeList+0x70e>
  803f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0d:	8b 50 08             	mov    0x8(%eax),%edx
  803f10:	8b 45 08             	mov    0x8(%ebp),%eax
  803f13:	8b 40 0c             	mov    0xc(%eax),%eax
  803f16:	01 c2                	add    %eax,%edx
  803f18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f1b:	8b 40 08             	mov    0x8(%eax),%eax
  803f1e:	39 c2                	cmp    %eax,%edx
  803f20:	73 70                	jae    803f92 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803f22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f26:	74 06                	je     803f2e <insert_sorted_with_merge_freeList+0x6aa>
  803f28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f2c:	75 17                	jne    803f45 <insert_sorted_with_merge_freeList+0x6c1>
  803f2e:	83 ec 04             	sub    $0x4,%esp
  803f31:	68 f4 4c 80 00       	push   $0x804cf4
  803f36:	68 75 01 00 00       	push   $0x175
  803f3b:	68 b7 4c 80 00       	push   $0x804cb7
  803f40:	e8 65 d3 ff ff       	call   8012aa <_panic>
  803f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f48:	8b 10                	mov    (%eax),%edx
  803f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4d:	89 10                	mov    %edx,(%eax)
  803f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f52:	8b 00                	mov    (%eax),%eax
  803f54:	85 c0                	test   %eax,%eax
  803f56:	74 0b                	je     803f63 <insert_sorted_with_merge_freeList+0x6df>
  803f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f5b:	8b 00                	mov    (%eax),%eax
  803f5d:	8b 55 08             	mov    0x8(%ebp),%edx
  803f60:	89 50 04             	mov    %edx,0x4(%eax)
  803f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f66:	8b 55 08             	mov    0x8(%ebp),%edx
  803f69:	89 10                	mov    %edx,(%eax)
  803f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f71:	89 50 04             	mov    %edx,0x4(%eax)
  803f74:	8b 45 08             	mov    0x8(%ebp),%eax
  803f77:	8b 00                	mov    (%eax),%eax
  803f79:	85 c0                	test   %eax,%eax
  803f7b:	75 08                	jne    803f85 <insert_sorted_with_merge_freeList+0x701>
  803f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  803f80:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803f85:	a1 44 51 80 00       	mov    0x805144,%eax
  803f8a:	40                   	inc    %eax
  803f8b:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  803f90:	eb 38                	jmp    803fca <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803f92:	a1 40 51 80 00       	mov    0x805140,%eax
  803f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f9e:	74 07                	je     803fa7 <insert_sorted_with_merge_freeList+0x723>
  803fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa3:	8b 00                	mov    (%eax),%eax
  803fa5:	eb 05                	jmp    803fac <insert_sorted_with_merge_freeList+0x728>
  803fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  803fac:	a3 40 51 80 00       	mov    %eax,0x805140
  803fb1:	a1 40 51 80 00       	mov    0x805140,%eax
  803fb6:	85 c0                	test   %eax,%eax
  803fb8:	0f 85 c3 fb ff ff    	jne    803b81 <insert_sorted_with_merge_freeList+0x2fd>
  803fbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fc2:	0f 85 b9 fb ff ff    	jne    803b81 <insert_sorted_with_merge_freeList+0x2fd>





}
  803fc8:	eb 00                	jmp    803fca <insert_sorted_with_merge_freeList+0x746>
  803fca:	90                   	nop
  803fcb:	c9                   	leave  
  803fcc:	c3                   	ret    
  803fcd:	66 90                	xchg   %ax,%ax
  803fcf:	90                   	nop

00803fd0 <__udivdi3>:
  803fd0:	55                   	push   %ebp
  803fd1:	57                   	push   %edi
  803fd2:	56                   	push   %esi
  803fd3:	53                   	push   %ebx
  803fd4:	83 ec 1c             	sub    $0x1c,%esp
  803fd7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803fdb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803fdf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fe3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803fe7:	89 ca                	mov    %ecx,%edx
  803fe9:	89 f8                	mov    %edi,%eax
  803feb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803fef:	85 f6                	test   %esi,%esi
  803ff1:	75 2d                	jne    804020 <__udivdi3+0x50>
  803ff3:	39 cf                	cmp    %ecx,%edi
  803ff5:	77 65                	ja     80405c <__udivdi3+0x8c>
  803ff7:	89 fd                	mov    %edi,%ebp
  803ff9:	85 ff                	test   %edi,%edi
  803ffb:	75 0b                	jne    804008 <__udivdi3+0x38>
  803ffd:	b8 01 00 00 00       	mov    $0x1,%eax
  804002:	31 d2                	xor    %edx,%edx
  804004:	f7 f7                	div    %edi
  804006:	89 c5                	mov    %eax,%ebp
  804008:	31 d2                	xor    %edx,%edx
  80400a:	89 c8                	mov    %ecx,%eax
  80400c:	f7 f5                	div    %ebp
  80400e:	89 c1                	mov    %eax,%ecx
  804010:	89 d8                	mov    %ebx,%eax
  804012:	f7 f5                	div    %ebp
  804014:	89 cf                	mov    %ecx,%edi
  804016:	89 fa                	mov    %edi,%edx
  804018:	83 c4 1c             	add    $0x1c,%esp
  80401b:	5b                   	pop    %ebx
  80401c:	5e                   	pop    %esi
  80401d:	5f                   	pop    %edi
  80401e:	5d                   	pop    %ebp
  80401f:	c3                   	ret    
  804020:	39 ce                	cmp    %ecx,%esi
  804022:	77 28                	ja     80404c <__udivdi3+0x7c>
  804024:	0f bd fe             	bsr    %esi,%edi
  804027:	83 f7 1f             	xor    $0x1f,%edi
  80402a:	75 40                	jne    80406c <__udivdi3+0x9c>
  80402c:	39 ce                	cmp    %ecx,%esi
  80402e:	72 0a                	jb     80403a <__udivdi3+0x6a>
  804030:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804034:	0f 87 9e 00 00 00    	ja     8040d8 <__udivdi3+0x108>
  80403a:	b8 01 00 00 00       	mov    $0x1,%eax
  80403f:	89 fa                	mov    %edi,%edx
  804041:	83 c4 1c             	add    $0x1c,%esp
  804044:	5b                   	pop    %ebx
  804045:	5e                   	pop    %esi
  804046:	5f                   	pop    %edi
  804047:	5d                   	pop    %ebp
  804048:	c3                   	ret    
  804049:	8d 76 00             	lea    0x0(%esi),%esi
  80404c:	31 ff                	xor    %edi,%edi
  80404e:	31 c0                	xor    %eax,%eax
  804050:	89 fa                	mov    %edi,%edx
  804052:	83 c4 1c             	add    $0x1c,%esp
  804055:	5b                   	pop    %ebx
  804056:	5e                   	pop    %esi
  804057:	5f                   	pop    %edi
  804058:	5d                   	pop    %ebp
  804059:	c3                   	ret    
  80405a:	66 90                	xchg   %ax,%ax
  80405c:	89 d8                	mov    %ebx,%eax
  80405e:	f7 f7                	div    %edi
  804060:	31 ff                	xor    %edi,%edi
  804062:	89 fa                	mov    %edi,%edx
  804064:	83 c4 1c             	add    $0x1c,%esp
  804067:	5b                   	pop    %ebx
  804068:	5e                   	pop    %esi
  804069:	5f                   	pop    %edi
  80406a:	5d                   	pop    %ebp
  80406b:	c3                   	ret    
  80406c:	bd 20 00 00 00       	mov    $0x20,%ebp
  804071:	89 eb                	mov    %ebp,%ebx
  804073:	29 fb                	sub    %edi,%ebx
  804075:	89 f9                	mov    %edi,%ecx
  804077:	d3 e6                	shl    %cl,%esi
  804079:	89 c5                	mov    %eax,%ebp
  80407b:	88 d9                	mov    %bl,%cl
  80407d:	d3 ed                	shr    %cl,%ebp
  80407f:	89 e9                	mov    %ebp,%ecx
  804081:	09 f1                	or     %esi,%ecx
  804083:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804087:	89 f9                	mov    %edi,%ecx
  804089:	d3 e0                	shl    %cl,%eax
  80408b:	89 c5                	mov    %eax,%ebp
  80408d:	89 d6                	mov    %edx,%esi
  80408f:	88 d9                	mov    %bl,%cl
  804091:	d3 ee                	shr    %cl,%esi
  804093:	89 f9                	mov    %edi,%ecx
  804095:	d3 e2                	shl    %cl,%edx
  804097:	8b 44 24 08          	mov    0x8(%esp),%eax
  80409b:	88 d9                	mov    %bl,%cl
  80409d:	d3 e8                	shr    %cl,%eax
  80409f:	09 c2                	or     %eax,%edx
  8040a1:	89 d0                	mov    %edx,%eax
  8040a3:	89 f2                	mov    %esi,%edx
  8040a5:	f7 74 24 0c          	divl   0xc(%esp)
  8040a9:	89 d6                	mov    %edx,%esi
  8040ab:	89 c3                	mov    %eax,%ebx
  8040ad:	f7 e5                	mul    %ebp
  8040af:	39 d6                	cmp    %edx,%esi
  8040b1:	72 19                	jb     8040cc <__udivdi3+0xfc>
  8040b3:	74 0b                	je     8040c0 <__udivdi3+0xf0>
  8040b5:	89 d8                	mov    %ebx,%eax
  8040b7:	31 ff                	xor    %edi,%edi
  8040b9:	e9 58 ff ff ff       	jmp    804016 <__udivdi3+0x46>
  8040be:	66 90                	xchg   %ax,%ax
  8040c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8040c4:	89 f9                	mov    %edi,%ecx
  8040c6:	d3 e2                	shl    %cl,%edx
  8040c8:	39 c2                	cmp    %eax,%edx
  8040ca:	73 e9                	jae    8040b5 <__udivdi3+0xe5>
  8040cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8040cf:	31 ff                	xor    %edi,%edi
  8040d1:	e9 40 ff ff ff       	jmp    804016 <__udivdi3+0x46>
  8040d6:	66 90                	xchg   %ax,%ax
  8040d8:	31 c0                	xor    %eax,%eax
  8040da:	e9 37 ff ff ff       	jmp    804016 <__udivdi3+0x46>
  8040df:	90                   	nop

008040e0 <__umoddi3>:
  8040e0:	55                   	push   %ebp
  8040e1:	57                   	push   %edi
  8040e2:	56                   	push   %esi
  8040e3:	53                   	push   %ebx
  8040e4:	83 ec 1c             	sub    $0x1c,%esp
  8040e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8040eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8040ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8040f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8040fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8040ff:	89 f3                	mov    %esi,%ebx
  804101:	89 fa                	mov    %edi,%edx
  804103:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804107:	89 34 24             	mov    %esi,(%esp)
  80410a:	85 c0                	test   %eax,%eax
  80410c:	75 1a                	jne    804128 <__umoddi3+0x48>
  80410e:	39 f7                	cmp    %esi,%edi
  804110:	0f 86 a2 00 00 00    	jbe    8041b8 <__umoddi3+0xd8>
  804116:	89 c8                	mov    %ecx,%eax
  804118:	89 f2                	mov    %esi,%edx
  80411a:	f7 f7                	div    %edi
  80411c:	89 d0                	mov    %edx,%eax
  80411e:	31 d2                	xor    %edx,%edx
  804120:	83 c4 1c             	add    $0x1c,%esp
  804123:	5b                   	pop    %ebx
  804124:	5e                   	pop    %esi
  804125:	5f                   	pop    %edi
  804126:	5d                   	pop    %ebp
  804127:	c3                   	ret    
  804128:	39 f0                	cmp    %esi,%eax
  80412a:	0f 87 ac 00 00 00    	ja     8041dc <__umoddi3+0xfc>
  804130:	0f bd e8             	bsr    %eax,%ebp
  804133:	83 f5 1f             	xor    $0x1f,%ebp
  804136:	0f 84 ac 00 00 00    	je     8041e8 <__umoddi3+0x108>
  80413c:	bf 20 00 00 00       	mov    $0x20,%edi
  804141:	29 ef                	sub    %ebp,%edi
  804143:	89 fe                	mov    %edi,%esi
  804145:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804149:	89 e9                	mov    %ebp,%ecx
  80414b:	d3 e0                	shl    %cl,%eax
  80414d:	89 d7                	mov    %edx,%edi
  80414f:	89 f1                	mov    %esi,%ecx
  804151:	d3 ef                	shr    %cl,%edi
  804153:	09 c7                	or     %eax,%edi
  804155:	89 e9                	mov    %ebp,%ecx
  804157:	d3 e2                	shl    %cl,%edx
  804159:	89 14 24             	mov    %edx,(%esp)
  80415c:	89 d8                	mov    %ebx,%eax
  80415e:	d3 e0                	shl    %cl,%eax
  804160:	89 c2                	mov    %eax,%edx
  804162:	8b 44 24 08          	mov    0x8(%esp),%eax
  804166:	d3 e0                	shl    %cl,%eax
  804168:	89 44 24 04          	mov    %eax,0x4(%esp)
  80416c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804170:	89 f1                	mov    %esi,%ecx
  804172:	d3 e8                	shr    %cl,%eax
  804174:	09 d0                	or     %edx,%eax
  804176:	d3 eb                	shr    %cl,%ebx
  804178:	89 da                	mov    %ebx,%edx
  80417a:	f7 f7                	div    %edi
  80417c:	89 d3                	mov    %edx,%ebx
  80417e:	f7 24 24             	mull   (%esp)
  804181:	89 c6                	mov    %eax,%esi
  804183:	89 d1                	mov    %edx,%ecx
  804185:	39 d3                	cmp    %edx,%ebx
  804187:	0f 82 87 00 00 00    	jb     804214 <__umoddi3+0x134>
  80418d:	0f 84 91 00 00 00    	je     804224 <__umoddi3+0x144>
  804193:	8b 54 24 04          	mov    0x4(%esp),%edx
  804197:	29 f2                	sub    %esi,%edx
  804199:	19 cb                	sbb    %ecx,%ebx
  80419b:	89 d8                	mov    %ebx,%eax
  80419d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041a1:	d3 e0                	shl    %cl,%eax
  8041a3:	89 e9                	mov    %ebp,%ecx
  8041a5:	d3 ea                	shr    %cl,%edx
  8041a7:	09 d0                	or     %edx,%eax
  8041a9:	89 e9                	mov    %ebp,%ecx
  8041ab:	d3 eb                	shr    %cl,%ebx
  8041ad:	89 da                	mov    %ebx,%edx
  8041af:	83 c4 1c             	add    $0x1c,%esp
  8041b2:	5b                   	pop    %ebx
  8041b3:	5e                   	pop    %esi
  8041b4:	5f                   	pop    %edi
  8041b5:	5d                   	pop    %ebp
  8041b6:	c3                   	ret    
  8041b7:	90                   	nop
  8041b8:	89 fd                	mov    %edi,%ebp
  8041ba:	85 ff                	test   %edi,%edi
  8041bc:	75 0b                	jne    8041c9 <__umoddi3+0xe9>
  8041be:	b8 01 00 00 00       	mov    $0x1,%eax
  8041c3:	31 d2                	xor    %edx,%edx
  8041c5:	f7 f7                	div    %edi
  8041c7:	89 c5                	mov    %eax,%ebp
  8041c9:	89 f0                	mov    %esi,%eax
  8041cb:	31 d2                	xor    %edx,%edx
  8041cd:	f7 f5                	div    %ebp
  8041cf:	89 c8                	mov    %ecx,%eax
  8041d1:	f7 f5                	div    %ebp
  8041d3:	89 d0                	mov    %edx,%eax
  8041d5:	e9 44 ff ff ff       	jmp    80411e <__umoddi3+0x3e>
  8041da:	66 90                	xchg   %ax,%ax
  8041dc:	89 c8                	mov    %ecx,%eax
  8041de:	89 f2                	mov    %esi,%edx
  8041e0:	83 c4 1c             	add    $0x1c,%esp
  8041e3:	5b                   	pop    %ebx
  8041e4:	5e                   	pop    %esi
  8041e5:	5f                   	pop    %edi
  8041e6:	5d                   	pop    %ebp
  8041e7:	c3                   	ret    
  8041e8:	3b 04 24             	cmp    (%esp),%eax
  8041eb:	72 06                	jb     8041f3 <__umoddi3+0x113>
  8041ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8041f1:	77 0f                	ja     804202 <__umoddi3+0x122>
  8041f3:	89 f2                	mov    %esi,%edx
  8041f5:	29 f9                	sub    %edi,%ecx
  8041f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8041fb:	89 14 24             	mov    %edx,(%esp)
  8041fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804202:	8b 44 24 04          	mov    0x4(%esp),%eax
  804206:	8b 14 24             	mov    (%esp),%edx
  804209:	83 c4 1c             	add    $0x1c,%esp
  80420c:	5b                   	pop    %ebx
  80420d:	5e                   	pop    %esi
  80420e:	5f                   	pop    %edi
  80420f:	5d                   	pop    %ebp
  804210:	c3                   	ret    
  804211:	8d 76 00             	lea    0x0(%esi),%esi
  804214:	2b 04 24             	sub    (%esp),%eax
  804217:	19 fa                	sbb    %edi,%edx
  804219:	89 d1                	mov    %edx,%ecx
  80421b:	89 c6                	mov    %eax,%esi
  80421d:	e9 71 ff ff ff       	jmp    804193 <__umoddi3+0xb3>
  804222:	66 90                	xchg   %ax,%ax
  804224:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804228:	72 ea                	jb     804214 <__umoddi3+0x134>
  80422a:	89 d9                	mov    %ebx,%ecx
  80422c:	e9 62 ff ff ff       	jmp    804193 <__umoddi3+0xb3>
