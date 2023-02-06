
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 6f 05 00 00       	call   8005a5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	83 ec 74             	sub    $0x74,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 80 36 80 00       	push   $0x803680
  800092:	6a 14                	push   $0x14
  800094:	68 9c 36 80 00       	push   $0x80369c
  800099:	e8 43 06 00 00       	call   8006e1 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 66 18 00 00       	call   80190e <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ab:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	//int sizeOfMemBlocksArray = ROUNDUP(((USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE) * sizeof(struct MemBlock), PAGE_SIZE) ;
	void* ptr_allocations[20] = {0};
  8000b9:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000bc:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c6:	89 d7                	mov    %edx,%edi
  8000c8:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 7e 1c 00 00       	call   801d4d <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000d2:	e8 16 1d 00 00       	call   801ded <sys_pf_calculate_allocated_pages>
  8000d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000dd:	01 c0                	add    %eax,%eax
  8000df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	50                   	push   %eax
  8000e6:	e8 23 18 00 00       	call   80190e <malloc>
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8000f1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	79 0a                	jns    800102 <_main+0xca>
  8000f8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000fb:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800100:	76 14                	jbe    800116 <_main+0xde>
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	68 b0 36 80 00       	push   $0x8036b0
  80010a:	6a 23                	push   $0x23
  80010c:	68 9c 36 80 00       	push   $0x80369c
  800111:	e8 cb 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		//cprintf("freeFrames - sys_calculate_free_frames() = %d\n", freeFrames - sys_calculate_free_frames()) ;
		//cprintf("Expected = %d\n", (1 + sizeOfMemBlocksArray/PAGE_SIZE));
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800116:	e8 32 1c 00 00       	call   801d4d <sys_calculate_free_frames>
  80011b:	89 c2                	mov    %eax,%edx
  80011d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800120:	39 c2                	cmp    %eax,%edx
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 e0 36 80 00       	push   $0x8036e0
  80012c:	6a 27                	push   $0x27
  80012e:	68 9c 36 80 00       	push   $0x80369c
  800133:	e8 a9 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 b0 1c 00 00       	call   801ded <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 4c 37 80 00       	push   $0x80374c
  80014a:	6a 28                	push   $0x28
  80014c:	68 9c 36 80 00       	push   $0x80369c
  800151:	e8 8b 05 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800156:	e8 f2 1b 00 00       	call   801d4d <sys_calculate_free_frames>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80015e:	e8 8a 1c 00 00       	call   801ded <sys_pf_calculate_allocated_pages>
  800163:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800169:	01 c0                	add    %eax,%eax
  80016b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	50                   	push   %eax
  800172:	e8 97 17 00 00       	call   80190e <malloc>
  800177:	83 c4 10             	add    $0x10,%esp
  80017a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START + 2*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80017d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800180:	89 c2                	mov    %eax,%edx
  800182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800185:	01 c0                	add    %eax,%eax
  800187:	05 00 00 00 80       	add    $0x80000000,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	72 13                	jb     8001a3 <_main+0x16b>
  800190:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800193:	89 c2                	mov    %eax,%edx
  800195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80019f:	39 c2                	cmp    %eax,%edx
  8001a1:	76 14                	jbe    8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 b0 36 80 00       	push   $0x8036b0
  8001ab:	6a 2d                	push   $0x2d
  8001ad:	68 9c 36 80 00       	push   $0x80369c
  8001b2:	e8 2a 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001b7:	e8 91 1b 00 00       	call   801d4d <sys_calculate_free_frames>
  8001bc:	89 c2                	mov    %eax,%edx
  8001be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c1:	39 c2                	cmp    %eax,%edx
  8001c3:	74 14                	je     8001d9 <_main+0x1a1>
  8001c5:	83 ec 04             	sub    $0x4,%esp
  8001c8:	68 e0 36 80 00       	push   $0x8036e0
  8001cd:	6a 2f                	push   $0x2f
  8001cf:	68 9c 36 80 00       	push   $0x80369c
  8001d4:	e8 08 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001d9:	e8 0f 1c 00 00       	call   801ded <sys_pf_calculate_allocated_pages>
  8001de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 4c 37 80 00       	push   $0x80374c
  8001eb:	6a 30                	push   $0x30
  8001ed:	68 9c 36 80 00       	push   $0x80369c
  8001f2:	e8 ea 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001f7:	e8 51 1b 00 00       	call   801d4d <sys_calculate_free_frames>
  8001fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 e9 1b 00 00       	call   801ded <sys_pf_calculate_allocated_pages>
  800204:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800207:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80020a:	89 c2                	mov    %eax,%edx
  80020c:	01 d2                	add    %edx,%edx
  80020e:	01 d0                	add    %edx,%eax
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	50                   	push   %eax
  800214:	e8 f5 16 00 00       	call   80190e <malloc>
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80021f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800222:	89 c2                	mov    %eax,%edx
  800224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800227:	c1 e0 02             	shl    $0x2,%eax
  80022a:	05 00 00 00 80       	add    $0x80000000,%eax
  80022f:	39 c2                	cmp    %eax,%edx
  800231:	72 14                	jb     800247 <_main+0x20f>
  800233:	8b 45 98             	mov    -0x68(%ebp),%eax
  800236:	89 c2                	mov    %eax,%edx
  800238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023b:	c1 e0 02             	shl    $0x2,%eax
  80023e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800243:	39 c2                	cmp    %eax,%edx
  800245:	76 14                	jbe    80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 b0 36 80 00       	push   $0x8036b0
  80024f:	6a 35                	push   $0x35
  800251:	68 9c 36 80 00       	push   $0x80369c
  800256:	e8 86 04 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80025b:	e8 ed 1a 00 00       	call   801d4d <sys_calculate_free_frames>
  800260:	89 c2                	mov    %eax,%edx
  800262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800265:	39 c2                	cmp    %eax,%edx
  800267:	74 14                	je     80027d <_main+0x245>
  800269:	83 ec 04             	sub    $0x4,%esp
  80026c:	68 e0 36 80 00       	push   $0x8036e0
  800271:	6a 37                	push   $0x37
  800273:	68 9c 36 80 00       	push   $0x80369c
  800278:	e8 64 04 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80027d:	e8 6b 1b 00 00       	call   801ded <sys_pf_calculate_allocated_pages>
  800282:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 4c 37 80 00       	push   $0x80374c
  80028f:	6a 38                	push   $0x38
  800291:	68 9c 36 80 00       	push   $0x80369c
  800296:	e8 46 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80029b:	e8 ad 1a 00 00       	call   801d4d <sys_calculate_free_frames>
  8002a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002a3:	e8 45 1b 00 00       	call   801ded <sys_pf_calculate_allocated_pages>
  8002a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8002ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ae:	89 c2                	mov    %eax,%edx
  8002b0:	01 d2                	add    %edx,%edx
  8002b2:	01 d0                	add    %edx,%eax
  8002b4:	83 ec 0c             	sub    $0xc,%esp
  8002b7:	50                   	push   %eax
  8002b8:	e8 51 16 00 00       	call   80190e <malloc>
  8002bd:	83 c4 10             	add    $0x10,%esp
  8002c0:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8002c3:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002c6:	89 c2                	mov    %eax,%edx
  8002c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cb:	c1 e0 02             	shl    $0x2,%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d3:	c1 e0 02             	shl    $0x2,%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 00 00 00 80       	add    $0x80000000,%eax
  8002dd:	39 c2                	cmp    %eax,%edx
  8002df:	72 1e                	jb     8002ff <_main+0x2c7>
  8002e1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002e4:	89 c2                	mov    %eax,%edx
  8002e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e9:	c1 e0 02             	shl    $0x2,%eax
  8002ec:	89 c1                	mov    %eax,%ecx
  8002ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f1:	c1 e0 02             	shl    $0x2,%eax
  8002f4:	01 c8                	add    %ecx,%eax
  8002f6:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002fb:	39 c2                	cmp    %eax,%edx
  8002fd:	76 14                	jbe    800313 <_main+0x2db>
  8002ff:	83 ec 04             	sub    $0x4,%esp
  800302:	68 b0 36 80 00       	push   $0x8036b0
  800307:	6a 3d                	push   $0x3d
  800309:	68 9c 36 80 00       	push   $0x80369c
  80030e:	e8 ce 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800313:	e8 35 1a 00 00       	call   801d4d <sys_calculate_free_frames>
  800318:	89 c2                	mov    %eax,%edx
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	39 c2                	cmp    %eax,%edx
  80031f:	74 14                	je     800335 <_main+0x2fd>
  800321:	83 ec 04             	sub    $0x4,%esp
  800324:	68 e0 36 80 00       	push   $0x8036e0
  800329:	6a 3f                	push   $0x3f
  80032b:	68 9c 36 80 00       	push   $0x80369c
  800330:	e8 ac 03 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800335:	e8 b3 1a 00 00       	call   801ded <sys_pf_calculate_allocated_pages>
  80033a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 4c 37 80 00       	push   $0x80374c
  800347:	6a 40                	push   $0x40
  800349:	68 9c 36 80 00       	push   $0x80369c
  80034e:	e8 8e 03 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800353:	e8 f5 19 00 00       	call   801d4d <sys_calculate_free_frames>
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035b:	e8 8d 1a 00 00       	call   801ded <sys_pf_calculate_allocated_pages>
  800360:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800363:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800366:	89 d0                	mov    %edx,%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	01 d0                	add    %edx,%eax
  80036c:	01 c0                	add    %eax,%eax
  80036e:	01 d0                	add    %edx,%eax
  800370:	83 ec 0c             	sub    $0xc,%esp
  800373:	50                   	push   %eax
  800374:	e8 95 15 00 00       	call   80190e <malloc>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80037f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800382:	89 c2                	mov    %eax,%edx
  800384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800387:	c1 e0 02             	shl    $0x2,%eax
  80038a:	89 c1                	mov    %eax,%ecx
  80038c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80038f:	c1 e0 03             	shl    $0x3,%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	05 00 00 00 80       	add    $0x80000000,%eax
  800399:	39 c2                	cmp    %eax,%edx
  80039b:	72 1e                	jb     8003bb <_main+0x383>
  80039d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003a0:	89 c2                	mov    %eax,%edx
  8003a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a5:	c1 e0 02             	shl    $0x2,%eax
  8003a8:	89 c1                	mov    %eax,%ecx
  8003aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 c8                	add    %ecx,%eax
  8003b2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	76 14                	jbe    8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 b0 36 80 00       	push   $0x8036b0
  8003c3:	6a 45                	push   $0x45
  8003c5:	68 9c 36 80 00       	push   $0x80369c
  8003ca:	e8 12 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003cf:	e8 79 19 00 00       	call   801d4d <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	74 14                	je     8003f1 <_main+0x3b9>
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	68 e0 36 80 00       	push   $0x8036e0
  8003e5:	6a 47                	push   $0x47
  8003e7:	68 9c 36 80 00       	push   $0x80369c
  8003ec:	e8 f0 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003f1:	e8 f7 19 00 00       	call   801ded <sys_pf_calculate_allocated_pages>
  8003f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003f9:	74 14                	je     80040f <_main+0x3d7>
  8003fb:	83 ec 04             	sub    $0x4,%esp
  8003fe:	68 4c 37 80 00       	push   $0x80374c
  800403:	6a 48                	push   $0x48
  800405:	68 9c 36 80 00       	push   $0x80369c
  80040a:	e8 d2 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80040f:	e8 39 19 00 00       	call   801d4d <sys_calculate_free_frames>
  800414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800417:	e8 d1 19 00 00       	call   801ded <sys_pf_calculate_allocated_pages>
  80041c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  80041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800422:	89 c2                	mov    %eax,%edx
  800424:	01 d2                	add    %edx,%edx
  800426:	01 d0                	add    %edx,%eax
  800428:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80042b:	83 ec 0c             	sub    $0xc,%esp
  80042e:	50                   	push   %eax
  80042f:	e8 da 14 00 00       	call   80190e <malloc>
  800434:	83 c4 10             	add    $0x10,%esp
  800437:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80043a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80043d:	89 c2                	mov    %eax,%edx
  80043f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800442:	c1 e0 02             	shl    $0x2,%eax
  800445:	89 c1                	mov    %eax,%ecx
  800447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044a:	c1 e0 04             	shl    $0x4,%eax
  80044d:	01 c8                	add    %ecx,%eax
  80044f:	05 00 00 00 80       	add    $0x80000000,%eax
  800454:	39 c2                	cmp    %eax,%edx
  800456:	72 1e                	jb     800476 <_main+0x43e>
  800458:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80045b:	89 c2                	mov    %eax,%edx
  80045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800460:	c1 e0 02             	shl    $0x2,%eax
  800463:	89 c1                	mov    %eax,%ecx
  800465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800468:	c1 e0 04             	shl    $0x4,%eax
  80046b:	01 c8                	add    %ecx,%eax
  80046d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	76 14                	jbe    80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 b0 36 80 00       	push   $0x8036b0
  80047e:	6a 4d                	push   $0x4d
  800480:	68 9c 36 80 00       	push   $0x80369c
  800485:	e8 57 02 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80048a:	e8 be 18 00 00       	call   801d4d <sys_calculate_free_frames>
  80048f:	89 c2                	mov    %eax,%edx
  800491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800494:	39 c2                	cmp    %eax,%edx
  800496:	74 14                	je     8004ac <_main+0x474>
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	68 7a 37 80 00       	push   $0x80377a
  8004a0:	6a 4e                	push   $0x4e
  8004a2:	68 9c 36 80 00       	push   $0x80369c
  8004a7:	e8 35 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004ac:	e8 3c 19 00 00       	call   801ded <sys_pf_calculate_allocated_pages>
  8004b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004b4:	74 14                	je     8004ca <_main+0x492>
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 4c 37 80 00       	push   $0x80374c
  8004be:	6a 4f                	push   $0x4f
  8004c0:	68 9c 36 80 00       	push   $0x80369c
  8004c5:	e8 17 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004ca:	e8 7e 18 00 00       	call   801d4d <sys_calculate_free_frames>
  8004cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004d2:	e8 16 19 00 00       	call   801ded <sys_pf_calculate_allocated_pages>
  8004d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  8004da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004dd:	01 c0                	add    %eax,%eax
  8004df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004e2:	83 ec 0c             	sub    $0xc,%esp
  8004e5:	50                   	push   %eax
  8004e6:	e8 23 14 00 00       	call   80190e <malloc>
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8004f1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004f4:	89 c1                	mov    %eax,%ecx
  8004f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004f9:	89 d0                	mov    %edx,%eax
  8004fb:	01 c0                	add    %eax,%eax
  8004fd:	01 d0                	add    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	89 c2                	mov    %eax,%edx
  800505:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800508:	c1 e0 04             	shl    $0x4,%eax
  80050b:	01 d0                	add    %edx,%eax
  80050d:	05 00 00 00 80       	add    $0x80000000,%eax
  800512:	39 c1                	cmp    %eax,%ecx
  800514:	72 25                	jb     80053b <_main+0x503>
  800516:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800519:	89 c1                	mov    %eax,%ecx
  80051b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051e:	89 d0                	mov    %edx,%eax
  800520:	01 c0                	add    %eax,%eax
  800522:	01 d0                	add    %edx,%eax
  800524:	01 c0                	add    %eax,%eax
  800526:	01 d0                	add    %edx,%eax
  800528:	89 c2                	mov    %eax,%edx
  80052a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80052d:	c1 e0 04             	shl    $0x4,%eax
  800530:	01 d0                	add    %edx,%eax
  800532:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800537:	39 c1                	cmp    %eax,%ecx
  800539:	76 14                	jbe    80054f <_main+0x517>
  80053b:	83 ec 04             	sub    $0x4,%esp
  80053e:	68 b0 36 80 00       	push   $0x8036b0
  800543:	6a 54                	push   $0x54
  800545:	68 9c 36 80 00       	push   $0x80369c
  80054a:	e8 92 01 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80054f:	e8 f9 17 00 00       	call   801d4d <sys_calculate_free_frames>
  800554:	89 c2                	mov    %eax,%edx
  800556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 7a 37 80 00       	push   $0x80377a
  800565:	6a 55                	push   $0x55
  800567:	68 9c 36 80 00       	push   $0x80369c
  80056c:	e8 70 01 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800571:	e8 77 18 00 00       	call   801ded <sys_pf_calculate_allocated_pages>
  800576:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800579:	74 14                	je     80058f <_main+0x557>
  80057b:	83 ec 04             	sub    $0x4,%esp
  80057e:	68 4c 37 80 00       	push   $0x80374c
  800583:	6a 56                	push   $0x56
  800585:	68 9c 36 80 00       	push   $0x80369c
  80058a:	e8 52 01 00 00       	call   8006e1 <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  80058f:	83 ec 0c             	sub    $0xc,%esp
  800592:	68 90 37 80 00       	push   $0x803790
  800597:	e8 f9 03 00 00       	call   800995 <cprintf>
  80059c:	83 c4 10             	add    $0x10,%esp

	return;
  80059f:	90                   	nop
}
  8005a0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8005a3:	c9                   	leave  
  8005a4:	c3                   	ret    

008005a5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005a5:	55                   	push   %ebp
  8005a6:	89 e5                	mov    %esp,%ebp
  8005a8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005ab:	e8 7d 1a 00 00       	call   80202d <sys_getenvindex>
  8005b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005b6:	89 d0                	mov    %edx,%eax
  8005b8:	c1 e0 03             	shl    $0x3,%eax
  8005bb:	01 d0                	add    %edx,%eax
  8005bd:	01 c0                	add    %eax,%eax
  8005bf:	01 d0                	add    %edx,%eax
  8005c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005c8:	01 d0                	add    %edx,%eax
  8005ca:	c1 e0 04             	shl    $0x4,%eax
  8005cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005d2:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8005dc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005e2:	84 c0                	test   %al,%al
  8005e4:	74 0f                	je     8005f5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005eb:	05 5c 05 00 00       	add    $0x55c,%eax
  8005f0:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005f9:	7e 0a                	jle    800605 <libmain+0x60>
		binaryname = argv[0];
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 08             	pushl  0x8(%ebp)
  80060e:	e8 25 fa ff ff       	call   800038 <_main>
  800613:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800616:	e8 1f 18 00 00       	call   801e3a <sys_disable_interrupt>
	cprintf("**************************************\n");
  80061b:	83 ec 0c             	sub    $0xc,%esp
  80061e:	68 e4 37 80 00       	push   $0x8037e4
  800623:	e8 6d 03 00 00       	call   800995 <cprintf>
  800628:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80062b:	a1 20 40 80 00       	mov    0x804020,%eax
  800630:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800636:	a1 20 40 80 00       	mov    0x804020,%eax
  80063b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	52                   	push   %edx
  800645:	50                   	push   %eax
  800646:	68 0c 38 80 00       	push   $0x80380c
  80064b:	e8 45 03 00 00       	call   800995 <cprintf>
  800650:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800653:	a1 20 40 80 00       	mov    0x804020,%eax
  800658:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80065e:	a1 20 40 80 00       	mov    0x804020,%eax
  800663:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800669:	a1 20 40 80 00       	mov    0x804020,%eax
  80066e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800674:	51                   	push   %ecx
  800675:	52                   	push   %edx
  800676:	50                   	push   %eax
  800677:	68 34 38 80 00       	push   $0x803834
  80067c:	e8 14 03 00 00       	call   800995 <cprintf>
  800681:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800684:	a1 20 40 80 00       	mov    0x804020,%eax
  800689:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	50                   	push   %eax
  800693:	68 8c 38 80 00       	push   $0x80388c
  800698:	e8 f8 02 00 00       	call   800995 <cprintf>
  80069d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	68 e4 37 80 00       	push   $0x8037e4
  8006a8:	e8 e8 02 00 00       	call   800995 <cprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006b0:	e8 9f 17 00 00       	call   801e54 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006b5:	e8 19 00 00 00       	call   8006d3 <exit>
}
  8006ba:	90                   	nop
  8006bb:	c9                   	leave  
  8006bc:	c3                   	ret    

008006bd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006c3:	83 ec 0c             	sub    $0xc,%esp
  8006c6:	6a 00                	push   $0x0
  8006c8:	e8 2c 19 00 00       	call   801ff9 <sys_destroy_env>
  8006cd:	83 c4 10             	add    $0x10,%esp
}
  8006d0:	90                   	nop
  8006d1:	c9                   	leave  
  8006d2:	c3                   	ret    

008006d3 <exit>:

void
exit(void)
{
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006d9:	e8 81 19 00 00       	call   80205f <sys_exit_env>
}
  8006de:	90                   	nop
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8006ea:	83 c0 04             	add    $0x4,%eax
  8006ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006f0:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	74 16                	je     80070f <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006f9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	50                   	push   %eax
  800702:	68 a0 38 80 00       	push   $0x8038a0
  800707:	e8 89 02 00 00       	call   800995 <cprintf>
  80070c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80070f:	a1 00 40 80 00       	mov    0x804000,%eax
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	ff 75 08             	pushl  0x8(%ebp)
  80071a:	50                   	push   %eax
  80071b:	68 a5 38 80 00       	push   $0x8038a5
  800720:	e8 70 02 00 00       	call   800995 <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800728:	8b 45 10             	mov    0x10(%ebp),%eax
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	ff 75 f4             	pushl  -0xc(%ebp)
  800731:	50                   	push   %eax
  800732:	e8 f3 01 00 00       	call   80092a <vcprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	6a 00                	push   $0x0
  80073f:	68 c1 38 80 00       	push   $0x8038c1
  800744:	e8 e1 01 00 00       	call   80092a <vcprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80074c:	e8 82 ff ff ff       	call   8006d3 <exit>

	// should not return here
	while (1) ;
  800751:	eb fe                	jmp    800751 <_panic+0x70>

00800753 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800759:	a1 20 40 80 00       	mov    0x804020,%eax
  80075e:	8b 50 74             	mov    0x74(%eax),%edx
  800761:	8b 45 0c             	mov    0xc(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 14                	je     80077c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 c4 38 80 00       	push   $0x8038c4
  800770:	6a 26                	push   $0x26
  800772:	68 10 39 80 00       	push   $0x803910
  800777:	e8 65 ff ff ff       	call   8006e1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80077c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800783:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80078a:	e9 c2 00 00 00       	jmp    800851 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80078f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800792:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	01 d0                	add    %edx,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	85 c0                	test   %eax,%eax
  8007a2:	75 08                	jne    8007ac <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007a4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007a7:	e9 a2 00 00 00       	jmp    80084e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ba:	eb 69                	jmp    800825 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007bc:	a1 20 40 80 00       	mov    0x804020,%eax
  8007c1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ca:	89 d0                	mov    %edx,%eax
  8007cc:	01 c0                	add    %eax,%eax
  8007ce:	01 d0                	add    %edx,%eax
  8007d0:	c1 e0 03             	shl    $0x3,%eax
  8007d3:	01 c8                	add    %ecx,%eax
  8007d5:	8a 40 04             	mov    0x4(%eax),%al
  8007d8:	84 c0                	test   %al,%al
  8007da:	75 46                	jne    800822 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8007e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ea:	89 d0                	mov    %edx,%eax
  8007ec:	01 c0                	add    %eax,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	c1 e0 03             	shl    $0x3,%eax
  8007f3:	01 c8                	add    %ecx,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800802:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800807:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	01 c8                	add    %ecx,%eax
  800813:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800815:	39 c2                	cmp    %eax,%edx
  800817:	75 09                	jne    800822 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800819:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800820:	eb 12                	jmp    800834 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800822:	ff 45 e8             	incl   -0x18(%ebp)
  800825:	a1 20 40 80 00       	mov    0x804020,%eax
  80082a:	8b 50 74             	mov    0x74(%eax),%edx
  80082d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800830:	39 c2                	cmp    %eax,%edx
  800832:	77 88                	ja     8007bc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800834:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800838:	75 14                	jne    80084e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80083a:	83 ec 04             	sub    $0x4,%esp
  80083d:	68 1c 39 80 00       	push   $0x80391c
  800842:	6a 3a                	push   $0x3a
  800844:	68 10 39 80 00       	push   $0x803910
  800849:	e8 93 fe ff ff       	call   8006e1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80084e:	ff 45 f0             	incl   -0x10(%ebp)
  800851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800854:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800857:	0f 8c 32 ff ff ff    	jl     80078f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80085d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800864:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80086b:	eb 26                	jmp    800893 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80086d:	a1 20 40 80 00       	mov    0x804020,%eax
  800872:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800878:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80087b:	89 d0                	mov    %edx,%eax
  80087d:	01 c0                	add    %eax,%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	c1 e0 03             	shl    $0x3,%eax
  800884:	01 c8                	add    %ecx,%eax
  800886:	8a 40 04             	mov    0x4(%eax),%al
  800889:	3c 01                	cmp    $0x1,%al
  80088b:	75 03                	jne    800890 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80088d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800890:	ff 45 e0             	incl   -0x20(%ebp)
  800893:	a1 20 40 80 00       	mov    0x804020,%eax
  800898:	8b 50 74             	mov    0x74(%eax),%edx
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	39 c2                	cmp    %eax,%edx
  8008a0:	77 cb                	ja     80086d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008a8:	74 14                	je     8008be <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008aa:	83 ec 04             	sub    $0x4,%esp
  8008ad:	68 70 39 80 00       	push   $0x803970
  8008b2:	6a 44                	push   $0x44
  8008b4:	68 10 39 80 00       	push   $0x803910
  8008b9:	e8 23 fe ff ff       	call   8006e1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008be:	90                   	nop
  8008bf:	c9                   	leave  
  8008c0:	c3                   	ret    

008008c1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8008cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d2:	89 0a                	mov    %ecx,(%edx)
  8008d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d7:	88 d1                	mov    %dl,%cl
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008ea:	75 2c                	jne    800918 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008ec:	a0 24 40 80 00       	mov    0x804024,%al
  8008f1:	0f b6 c0             	movzbl %al,%eax
  8008f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f7:	8b 12                	mov    (%edx),%edx
  8008f9:	89 d1                	mov    %edx,%ecx
  8008fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fe:	83 c2 08             	add    $0x8,%edx
  800901:	83 ec 04             	sub    $0x4,%esp
  800904:	50                   	push   %eax
  800905:	51                   	push   %ecx
  800906:	52                   	push   %edx
  800907:	e8 80 13 00 00       	call   801c8c <sys_cputs>
  80090c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091b:	8b 40 04             	mov    0x4(%eax),%eax
  80091e:	8d 50 01             	lea    0x1(%eax),%edx
  800921:	8b 45 0c             	mov    0xc(%ebp),%eax
  800924:	89 50 04             	mov    %edx,0x4(%eax)
}
  800927:	90                   	nop
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800933:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80093a:	00 00 00 
	b.cnt = 0;
  80093d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800944:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	ff 75 08             	pushl  0x8(%ebp)
  80094d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800953:	50                   	push   %eax
  800954:	68 c1 08 80 00       	push   $0x8008c1
  800959:	e8 11 02 00 00       	call   800b6f <vprintfmt>
  80095e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800961:	a0 24 40 80 00       	mov    0x804024,%al
  800966:	0f b6 c0             	movzbl %al,%eax
  800969:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80096f:	83 ec 04             	sub    $0x4,%esp
  800972:	50                   	push   %eax
  800973:	52                   	push   %edx
  800974:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80097a:	83 c0 08             	add    $0x8,%eax
  80097d:	50                   	push   %eax
  80097e:	e8 09 13 00 00       	call   801c8c <sys_cputs>
  800983:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800986:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80098d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <cprintf>:

int cprintf(const char *fmt, ...) {
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80099b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8009a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b1:	50                   	push   %eax
  8009b2:	e8 73 ff ff ff       	call   80092a <vcprintf>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c0:	c9                   	leave  
  8009c1:	c3                   	ret    

008009c2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009c8:	e8 6d 14 00 00       	call   801e3a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009cd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009dc:	50                   	push   %eax
  8009dd:	e8 48 ff ff ff       	call   80092a <vcprintf>
  8009e2:	83 c4 10             	add    $0x10,%esp
  8009e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009e8:	e8 67 14 00 00       	call   801e54 <sys_enable_interrupt>
	return cnt;
  8009ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	53                   	push   %ebx
  8009f6:	83 ec 14             	sub    $0x14,%esp
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a05:	8b 45 18             	mov    0x18(%ebp),%eax
  800a08:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a10:	77 55                	ja     800a67 <printnum+0x75>
  800a12:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a15:	72 05                	jb     800a1c <printnum+0x2a>
  800a17:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a1a:	77 4b                	ja     800a67 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a1c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a1f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a22:	8b 45 18             	mov    0x18(%ebp),%eax
  800a25:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2a:	52                   	push   %edx
  800a2b:	50                   	push   %eax
  800a2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2f:	ff 75 f0             	pushl  -0x10(%ebp)
  800a32:	e8 cd 29 00 00       	call   803404 <__udivdi3>
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	83 ec 04             	sub    $0x4,%esp
  800a3d:	ff 75 20             	pushl  0x20(%ebp)
  800a40:	53                   	push   %ebx
  800a41:	ff 75 18             	pushl  0x18(%ebp)
  800a44:	52                   	push   %edx
  800a45:	50                   	push   %eax
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	ff 75 08             	pushl  0x8(%ebp)
  800a4c:	e8 a1 ff ff ff       	call   8009f2 <printnum>
  800a51:	83 c4 20             	add    $0x20,%esp
  800a54:	eb 1a                	jmp    800a70 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	ff 75 20             	pushl  0x20(%ebp)
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a67:	ff 4d 1c             	decl   0x1c(%ebp)
  800a6a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a6e:	7f e6                	jg     800a56 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a70:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7e:	53                   	push   %ebx
  800a7f:	51                   	push   %ecx
  800a80:	52                   	push   %edx
  800a81:	50                   	push   %eax
  800a82:	e8 8d 2a 00 00       	call   803514 <__umoddi3>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	05 d4 3b 80 00       	add    $0x803bd4,%eax
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	0f be c0             	movsbl %al,%eax
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	50                   	push   %eax
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
}
  800aa3:	90                   	nop
  800aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    

00800aa9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ab0:	7e 1c                	jle    800ace <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 00                	mov    (%eax),%eax
  800ab7:	8d 50 08             	lea    0x8(%eax),%edx
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	89 10                	mov    %edx,(%eax)
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	83 e8 08             	sub    $0x8,%eax
  800ac7:	8b 50 04             	mov    0x4(%eax),%edx
  800aca:	8b 00                	mov    (%eax),%eax
  800acc:	eb 40                	jmp    800b0e <getuint+0x65>
	else if (lflag)
  800ace:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad2:	74 1e                	je     800af2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	8d 50 04             	lea    0x4(%eax),%edx
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	89 10                	mov    %edx,(%eax)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	83 e8 04             	sub    $0x4,%eax
  800ae9:	8b 00                	mov    (%eax),%eax
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	eb 1c                	jmp    800b0e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	8d 50 04             	lea    0x4(%eax),%edx
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	89 10                	mov    %edx,(%eax)
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 00                	mov    (%eax),%eax
  800b04:	83 e8 04             	sub    $0x4,%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b13:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b17:	7e 1c                	jle    800b35 <getint+0x25>
		return va_arg(*ap, long long);
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 50 08             	lea    0x8(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 10                	mov    %edx,(%eax)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	83 e8 08             	sub    $0x8,%eax
  800b2e:	8b 50 04             	mov    0x4(%eax),%edx
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	eb 38                	jmp    800b6d <getint+0x5d>
	else if (lflag)
  800b35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b39:	74 1a                	je     800b55 <getint+0x45>
		return va_arg(*ap, long);
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	8d 50 04             	lea    0x4(%eax),%edx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	89 10                	mov    %edx,(%eax)
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8b 00                	mov    (%eax),%eax
  800b4d:	83 e8 04             	sub    $0x4,%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	99                   	cltd   
  800b53:	eb 18                	jmp    800b6d <getint+0x5d>
	else
		return va_arg(*ap, int);
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
}
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b77:	eb 17                	jmp    800b90 <vprintfmt+0x21>
			if (ch == '\0')
  800b79:	85 db                	test   %ebx,%ebx
  800b7b:	0f 84 af 03 00 00    	je     800f30 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	53                   	push   %ebx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	8d 50 01             	lea    0x1(%eax),%edx
  800b96:	89 55 10             	mov    %edx,0x10(%ebp)
  800b99:	8a 00                	mov    (%eax),%al
  800b9b:	0f b6 d8             	movzbl %al,%ebx
  800b9e:	83 fb 25             	cmp    $0x25,%ebx
  800ba1:	75 d6                	jne    800b79 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ba3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ba7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bb5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bbc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc6:	8d 50 01             	lea    0x1(%eax),%edx
  800bc9:	89 55 10             	mov    %edx,0x10(%ebp)
  800bcc:	8a 00                	mov    (%eax),%al
  800bce:	0f b6 d8             	movzbl %al,%ebx
  800bd1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bd4:	83 f8 55             	cmp    $0x55,%eax
  800bd7:	0f 87 2b 03 00 00    	ja     800f08 <vprintfmt+0x399>
  800bdd:	8b 04 85 f8 3b 80 00 	mov    0x803bf8(,%eax,4),%eax
  800be4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800be6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bea:	eb d7                	jmp    800bc3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bec:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bf0:	eb d1                	jmp    800bc3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bf9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bfc:	89 d0                	mov    %edx,%eax
  800bfe:	c1 e0 02             	shl    $0x2,%eax
  800c01:	01 d0                	add    %edx,%eax
  800c03:	01 c0                	add    %eax,%eax
  800c05:	01 d8                	add    %ebx,%eax
  800c07:	83 e8 30             	sub    $0x30,%eax
  800c0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c15:	83 fb 2f             	cmp    $0x2f,%ebx
  800c18:	7e 3e                	jle    800c58 <vprintfmt+0xe9>
  800c1a:	83 fb 39             	cmp    $0x39,%ebx
  800c1d:	7f 39                	jg     800c58 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c1f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c22:	eb d5                	jmp    800bf9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c24:	8b 45 14             	mov    0x14(%ebp),%eax
  800c27:	83 c0 04             	add    $0x4,%eax
  800c2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	83 e8 04             	sub    $0x4,%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c38:	eb 1f                	jmp    800c59 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c3e:	79 83                	jns    800bc3 <vprintfmt+0x54>
				width = 0;
  800c40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c47:	e9 77 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c4c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c53:	e9 6b ff ff ff       	jmp    800bc3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c58:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5d:	0f 89 60 ff ff ff    	jns    800bc3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c69:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c70:	e9 4e ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c75:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c78:	e9 46 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 c0 04             	add    $0x4,%eax
  800c83:	89 45 14             	mov    %eax,0x14(%ebp)
  800c86:	8b 45 14             	mov    0x14(%ebp),%eax
  800c89:	83 e8 04             	sub    $0x4,%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	ff d0                	call   *%eax
  800c9a:	83 c4 10             	add    $0x10,%esp
			break;
  800c9d:	e9 89 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ca2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca5:	83 c0 04             	add    $0x4,%eax
  800ca8:	89 45 14             	mov    %eax,0x14(%ebp)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	83 e8 04             	sub    $0x4,%eax
  800cb1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cb3:	85 db                	test   %ebx,%ebx
  800cb5:	79 02                	jns    800cb9 <vprintfmt+0x14a>
				err = -err;
  800cb7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cb9:	83 fb 64             	cmp    $0x64,%ebx
  800cbc:	7f 0b                	jg     800cc9 <vprintfmt+0x15a>
  800cbe:	8b 34 9d 40 3a 80 00 	mov    0x803a40(,%ebx,4),%esi
  800cc5:	85 f6                	test   %esi,%esi
  800cc7:	75 19                	jne    800ce2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cc9:	53                   	push   %ebx
  800cca:	68 e5 3b 80 00       	push   $0x803be5
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	ff 75 08             	pushl  0x8(%ebp)
  800cd5:	e8 5e 02 00 00       	call   800f38 <printfmt>
  800cda:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cdd:	e9 49 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ce2:	56                   	push   %esi
  800ce3:	68 ee 3b 80 00       	push   $0x803bee
  800ce8:	ff 75 0c             	pushl  0xc(%ebp)
  800ceb:	ff 75 08             	pushl  0x8(%ebp)
  800cee:	e8 45 02 00 00       	call   800f38 <printfmt>
  800cf3:	83 c4 10             	add    $0x10,%esp
			break;
  800cf6:	e9 30 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfe:	83 c0 04             	add    $0x4,%eax
  800d01:	89 45 14             	mov    %eax,0x14(%ebp)
  800d04:	8b 45 14             	mov    0x14(%ebp),%eax
  800d07:	83 e8 04             	sub    $0x4,%eax
  800d0a:	8b 30                	mov    (%eax),%esi
  800d0c:	85 f6                	test   %esi,%esi
  800d0e:	75 05                	jne    800d15 <vprintfmt+0x1a6>
				p = "(null)";
  800d10:	be f1 3b 80 00       	mov    $0x803bf1,%esi
			if (width > 0 && padc != '-')
  800d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d19:	7e 6d                	jle    800d88 <vprintfmt+0x219>
  800d1b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d1f:	74 67                	je     800d88 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d24:	83 ec 08             	sub    $0x8,%esp
  800d27:	50                   	push   %eax
  800d28:	56                   	push   %esi
  800d29:	e8 0c 03 00 00       	call   80103a <strnlen>
  800d2e:	83 c4 10             	add    $0x10,%esp
  800d31:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d34:	eb 16                	jmp    800d4c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d36:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d3a:	83 ec 08             	sub    $0x8,%esp
  800d3d:	ff 75 0c             	pushl  0xc(%ebp)
  800d40:	50                   	push   %eax
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	ff d0                	call   *%eax
  800d46:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d49:	ff 4d e4             	decl   -0x1c(%ebp)
  800d4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d50:	7f e4                	jg     800d36 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d52:	eb 34                	jmp    800d88 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d54:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d58:	74 1c                	je     800d76 <vprintfmt+0x207>
  800d5a:	83 fb 1f             	cmp    $0x1f,%ebx
  800d5d:	7e 05                	jle    800d64 <vprintfmt+0x1f5>
  800d5f:	83 fb 7e             	cmp    $0x7e,%ebx
  800d62:	7e 12                	jle    800d76 <vprintfmt+0x207>
					putch('?', putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	6a 3f                	push   $0x3f
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	ff d0                	call   *%eax
  800d71:	83 c4 10             	add    $0x10,%esp
  800d74:	eb 0f                	jmp    800d85 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d76:	83 ec 08             	sub    $0x8,%esp
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	53                   	push   %ebx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	ff d0                	call   *%eax
  800d82:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d85:	ff 4d e4             	decl   -0x1c(%ebp)
  800d88:	89 f0                	mov    %esi,%eax
  800d8a:	8d 70 01             	lea    0x1(%eax),%esi
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f be d8             	movsbl %al,%ebx
  800d92:	85 db                	test   %ebx,%ebx
  800d94:	74 24                	je     800dba <vprintfmt+0x24b>
  800d96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d9a:	78 b8                	js     800d54 <vprintfmt+0x1e5>
  800d9c:	ff 4d e0             	decl   -0x20(%ebp)
  800d9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800da3:	79 af                	jns    800d54 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	eb 13                	jmp    800dba <vprintfmt+0x24b>
				putch(' ', putdat);
  800da7:	83 ec 08             	sub    $0x8,%esp
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	6a 20                	push   $0x20
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	ff d0                	call   *%eax
  800db4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800db7:	ff 4d e4             	decl   -0x1c(%ebp)
  800dba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbe:	7f e7                	jg     800da7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dc0:	e9 66 01 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 e8             	pushl  -0x18(%ebp)
  800dcb:	8d 45 14             	lea    0x14(%ebp),%eax
  800dce:	50                   	push   %eax
  800dcf:	e8 3c fd ff ff       	call   800b10 <getint>
  800dd4:	83 c4 10             	add    $0x10,%esp
  800dd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dda:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de3:	85 d2                	test   %edx,%edx
  800de5:	79 23                	jns    800e0a <vprintfmt+0x29b>
				putch('-', putdat);
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	ff 75 0c             	pushl  0xc(%ebp)
  800ded:	6a 2d                	push   $0x2d
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	ff d0                	call   *%eax
  800df4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfd:	f7 d8                	neg    %eax
  800dff:	83 d2 00             	adc    $0x0,%edx
  800e02:	f7 da                	neg    %edx
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e11:	e9 bc 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	ff 75 e8             	pushl  -0x18(%ebp)
  800e1c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e1f:	50                   	push   %eax
  800e20:	e8 84 fc ff ff       	call   800aa9 <getuint>
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e35:	e9 98 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	ff 75 0c             	pushl  0xc(%ebp)
  800e40:	6a 58                	push   $0x58
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	ff d0                	call   *%eax
  800e47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	6a 58                	push   $0x58
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	ff d0                	call   *%eax
  800e57:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e5a:	83 ec 08             	sub    $0x8,%esp
  800e5d:	ff 75 0c             	pushl  0xc(%ebp)
  800e60:	6a 58                	push   $0x58
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	ff d0                	call   *%eax
  800e67:	83 c4 10             	add    $0x10,%esp
			break;
  800e6a:	e9 bc 00 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e6f:	83 ec 08             	sub    $0x8,%esp
  800e72:	ff 75 0c             	pushl  0xc(%ebp)
  800e75:	6a 30                	push   $0x30
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	ff d0                	call   *%eax
  800e7c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 78                	push   $0x78
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 c0 04             	add    $0x4,%eax
  800e95:	89 45 14             	mov    %eax,0x14(%ebp)
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eaa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eb1:	eb 1f                	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	ff 75 e8             	pushl  -0x18(%ebp)
  800eb9:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebc:	50                   	push   %eax
  800ebd:	e8 e7 fb ff ff       	call   800aa9 <getuint>
  800ec2:	83 c4 10             	add    $0x10,%esp
  800ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ecb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ed2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ed9:	83 ec 04             	sub    $0x4,%esp
  800edc:	52                   	push   %edx
  800edd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ee0:	50                   	push   %eax
  800ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ee7:	ff 75 0c             	pushl  0xc(%ebp)
  800eea:	ff 75 08             	pushl  0x8(%ebp)
  800eed:	e8 00 fb ff ff       	call   8009f2 <printnum>
  800ef2:	83 c4 20             	add    $0x20,%esp
			break;
  800ef5:	eb 34                	jmp    800f2b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	53                   	push   %ebx
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			break;
  800f06:	eb 23                	jmp    800f2b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f08:	83 ec 08             	sub    $0x8,%esp
  800f0b:	ff 75 0c             	pushl  0xc(%ebp)
  800f0e:	6a 25                	push   $0x25
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	ff d0                	call   *%eax
  800f15:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	eb 03                	jmp    800f20 <vprintfmt+0x3b1>
  800f1d:	ff 4d 10             	decl   0x10(%ebp)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	48                   	dec    %eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 25                	cmp    $0x25,%al
  800f28:	75 f3                	jne    800f1d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f2a:	90                   	nop
		}
	}
  800f2b:	e9 47 fc ff ff       	jmp    800b77 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f30:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f34:	5b                   	pop    %ebx
  800f35:	5e                   	pop    %esi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f3e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4d:	50                   	push   %eax
  800f4e:	ff 75 0c             	pushl  0xc(%ebp)
  800f51:	ff 75 08             	pushl  0x8(%ebp)
  800f54:	e8 16 fc ff ff       	call   800b6f <vprintfmt>
  800f59:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f5c:	90                   	nop
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	8b 40 08             	mov    0x8(%eax),%eax
  800f68:	8d 50 01             	lea    0x1(%eax),%edx
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8b 10                	mov    (%eax),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	8b 40 04             	mov    0x4(%eax),%eax
  800f7c:	39 c2                	cmp    %eax,%edx
  800f7e:	73 12                	jae    800f92 <sprintputch+0x33>
		*b->buf++ = ch;
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	8b 00                	mov    (%eax),%eax
  800f85:	8d 48 01             	lea    0x1(%eax),%ecx
  800f88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8b:	89 0a                	mov    %ecx,(%edx)
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	88 10                	mov    %dl,(%eax)
}
  800f92:	90                   	nop
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    

00800f95 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	01 d0                	add    %edx,%eax
  800fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800faf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fba:	74 06                	je     800fc2 <vsnprintf+0x2d>
  800fbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc0:	7f 07                	jg     800fc9 <vsnprintf+0x34>
		return -E_INVAL;
  800fc2:	b8 03 00 00 00       	mov    $0x3,%eax
  800fc7:	eb 20                	jmp    800fe9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fc9:	ff 75 14             	pushl  0x14(%ebp)
  800fcc:	ff 75 10             	pushl  0x10(%ebp)
  800fcf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fd2:	50                   	push   %eax
  800fd3:	68 5f 0f 80 00       	push   $0x800f5f
  800fd8:	e8 92 fb ff ff       	call   800b6f <vprintfmt>
  800fdd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fe3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    

00800feb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ff1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff4:	83 c0 04             	add    $0x4,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	ff 75 f4             	pushl  -0xc(%ebp)
  801000:	50                   	push   %eax
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	ff 75 08             	pushl  0x8(%ebp)
  801007:	e8 89 ff ff ff       	call   800f95 <vsnprintf>
  80100c:	83 c4 10             	add    $0x10,%esp
  80100f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801012:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80101d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801024:	eb 06                	jmp    80102c <strlen+0x15>
		n++;
  801026:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801029:	ff 45 08             	incl   0x8(%ebp)
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	84 c0                	test   %al,%al
  801033:	75 f1                	jne    801026 <strlen+0xf>
		n++;
	return n;
  801035:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801047:	eb 09                	jmp    801052 <strnlen+0x18>
		n++;
  801049:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104c:	ff 45 08             	incl   0x8(%ebp)
  80104f:	ff 4d 0c             	decl   0xc(%ebp)
  801052:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801056:	74 09                	je     801061 <strnlen+0x27>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e8                	jne    801049 <strnlen+0xf>
		n++;
	return n;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801072:	90                   	nop
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8d 50 01             	lea    0x1(%eax),%edx
  801079:	89 55 08             	mov    %edx,0x8(%ebp)
  80107c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801082:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801085:	8a 12                	mov    (%edx),%dl
  801087:	88 10                	mov    %dl,(%eax)
  801089:	8a 00                	mov    (%eax),%al
  80108b:	84 c0                	test   %al,%al
  80108d:	75 e4                	jne    801073 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80108f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a7:	eb 1f                	jmp    8010c8 <strncpy+0x34>
		*dst++ = *src;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8d 50 01             	lea    0x1(%eax),%edx
  8010af:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b5:	8a 12                	mov    (%edx),%dl
  8010b7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	84 c0                	test   %al,%al
  8010c0:	74 03                	je     8010c5 <strncpy+0x31>
			src++;
  8010c2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010c5:	ff 45 fc             	incl   -0x4(%ebp)
  8010c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ce:	72 d9                	jb     8010a9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e5:	74 30                	je     801117 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010e7:	eb 16                	jmp    8010ff <strlcpy+0x2a>
			*dst++ = *src++;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	8d 50 01             	lea    0x1(%eax),%edx
  8010ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fb:	8a 12                	mov    (%edx),%dl
  8010fd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ff:	ff 4d 10             	decl   0x10(%ebp)
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	74 09                	je     801111 <strlcpy+0x3c>
  801108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	84 c0                	test   %al,%al
  80110f:	75 d8                	jne    8010e9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801117:	8b 55 08             	mov    0x8(%ebp),%edx
  80111a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111d:	29 c2                	sub    %eax,%edx
  80111f:	89 d0                	mov    %edx,%eax
}
  801121:	c9                   	leave  
  801122:	c3                   	ret    

00801123 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801126:	eb 06                	jmp    80112e <strcmp+0xb>
		p++, q++;
  801128:	ff 45 08             	incl   0x8(%ebp)
  80112b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	84 c0                	test   %al,%al
  801135:	74 0e                	je     801145 <strcmp+0x22>
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 10                	mov    (%eax),%dl
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	38 c2                	cmp    %al,%dl
  801143:	74 e3                	je     801128 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f b6 d0             	movzbl %al,%edx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	29 c2                	sub    %eax,%edx
  801157:	89 d0                	mov    %edx,%eax
}
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80115e:	eb 09                	jmp    801169 <strncmp+0xe>
		n--, p++, q++;
  801160:	ff 4d 10             	decl   0x10(%ebp)
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801169:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116d:	74 17                	je     801186 <strncmp+0x2b>
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	84 c0                	test   %al,%al
  801176:	74 0e                	je     801186 <strncmp+0x2b>
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 10                	mov    (%eax),%dl
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	38 c2                	cmp    %al,%dl
  801184:	74 da                	je     801160 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801186:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118a:	75 07                	jne    801193 <strncmp+0x38>
		return 0;
  80118c:	b8 00 00 00 00       	mov    $0x0,%eax
  801191:	eb 14                	jmp    8011a7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	0f b6 d0             	movzbl %al,%edx
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	0f b6 c0             	movzbl %al,%eax
  8011a3:	29 c2                	sub    %eax,%edx
  8011a5:	89 d0                	mov    %edx,%eax
}
  8011a7:	5d                   	pop    %ebp
  8011a8:	c3                   	ret    

008011a9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 04             	sub    $0x4,%esp
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b5:	eb 12                	jmp    8011c9 <strchr+0x20>
		if (*s == c)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011bf:	75 05                	jne    8011c6 <strchr+0x1d>
			return (char *) s;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	eb 11                	jmp    8011d7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011c6:	ff 45 08             	incl   0x8(%ebp)
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	84 c0                	test   %al,%al
  8011d0:	75 e5                	jne    8011b7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 04             	sub    $0x4,%esp
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011e5:	eb 0d                	jmp    8011f4 <strfind+0x1b>
		if (*s == c)
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ef:	74 0e                	je     8011ff <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011f1:	ff 45 08             	incl   0x8(%ebp)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	84 c0                	test   %al,%al
  8011fb:	75 ea                	jne    8011e7 <strfind+0xe>
  8011fd:	eb 01                	jmp    801200 <strfind+0x27>
		if (*s == c)
			break;
  8011ff:	90                   	nop
	return (char *) s;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801217:	eb 0e                	jmp    801227 <memset+0x22>
		*p++ = c;
  801219:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121c:	8d 50 01             	lea    0x1(%eax),%edx
  80121f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801222:	8b 55 0c             	mov    0xc(%ebp),%edx
  801225:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801227:	ff 4d f8             	decl   -0x8(%ebp)
  80122a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80122e:	79 e9                	jns    801219 <memset+0x14>
		*p++ = c;

	return v;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801247:	eb 16                	jmp    80125f <memcpy+0x2a>
		*d++ = *s++;
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	8d 50 01             	lea    0x1(%eax),%edx
  80124f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801252:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801255:	8d 4a 01             	lea    0x1(%edx),%ecx
  801258:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80125b:	8a 12                	mov    (%edx),%dl
  80125d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80125f:	8b 45 10             	mov    0x10(%ebp),%eax
  801262:	8d 50 ff             	lea    -0x1(%eax),%edx
  801265:	89 55 10             	mov    %edx,0x10(%ebp)
  801268:	85 c0                	test   %eax,%eax
  80126a:	75 dd                	jne    801249 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801283:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801286:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801289:	73 50                	jae    8012db <memmove+0x6a>
  80128b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128e:	8b 45 10             	mov    0x10(%ebp),%eax
  801291:	01 d0                	add    %edx,%eax
  801293:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801296:	76 43                	jbe    8012db <memmove+0x6a>
		s += n;
  801298:	8b 45 10             	mov    0x10(%ebp),%eax
  80129b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80129e:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012a4:	eb 10                	jmp    8012b6 <memmove+0x45>
			*--d = *--s;
  8012a6:	ff 4d f8             	decl   -0x8(%ebp)
  8012a9:	ff 4d fc             	decl   -0x4(%ebp)
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012af:	8a 10                	mov    (%eax),%dl
  8012b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	75 e3                	jne    8012a6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012c3:	eb 23                	jmp    8012e8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d7:	8a 12                	mov    (%edx),%dl
  8012d9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	75 dd                	jne    8012c5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ff:	eb 2a                	jmp    80132b <memcmp+0x3e>
		if (*s1 != *s2)
  801301:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801304:	8a 10                	mov    (%eax),%dl
  801306:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	38 c2                	cmp    %al,%dl
  80130d:	74 16                	je     801325 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80130f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	0f b6 d0             	movzbl %al,%edx
  801317:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f b6 c0             	movzbl %al,%eax
  80131f:	29 c2                	sub    %eax,%edx
  801321:	89 d0                	mov    %edx,%eax
  801323:	eb 18                	jmp    80133d <memcmp+0x50>
		s1++, s2++;
  801325:	ff 45 fc             	incl   -0x4(%ebp)
  801328:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80132b:	8b 45 10             	mov    0x10(%ebp),%eax
  80132e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801331:	89 55 10             	mov    %edx,0x10(%ebp)
  801334:	85 c0                	test   %eax,%eax
  801336:	75 c9                	jne    801301 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801345:	8b 55 08             	mov    0x8(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801350:	eb 15                	jmp    801367 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	0f b6 d0             	movzbl %al,%edx
  80135a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135d:	0f b6 c0             	movzbl %al,%eax
  801360:	39 c2                	cmp    %eax,%edx
  801362:	74 0d                	je     801371 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801364:	ff 45 08             	incl   0x8(%ebp)
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80136d:	72 e3                	jb     801352 <memfind+0x13>
  80136f:	eb 01                	jmp    801372 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801371:	90                   	nop
	return (void *) s;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80137d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801384:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138b:	eb 03                	jmp    801390 <strtol+0x19>
		s++;
  80138d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 20                	cmp    $0x20,%al
  801397:	74 f4                	je     80138d <strtol+0x16>
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	3c 09                	cmp    $0x9,%al
  8013a0:	74 eb                	je     80138d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	3c 2b                	cmp    $0x2b,%al
  8013a9:	75 05                	jne    8013b0 <strtol+0x39>
		s++;
  8013ab:	ff 45 08             	incl   0x8(%ebp)
  8013ae:	eb 13                	jmp    8013c3 <strtol+0x4c>
	else if (*s == '-')
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	3c 2d                	cmp    $0x2d,%al
  8013b7:	75 0a                	jne    8013c3 <strtol+0x4c>
		s++, neg = 1;
  8013b9:	ff 45 08             	incl   0x8(%ebp)
  8013bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c7:	74 06                	je     8013cf <strtol+0x58>
  8013c9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013cd:	75 20                	jne    8013ef <strtol+0x78>
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	3c 30                	cmp    $0x30,%al
  8013d6:	75 17                	jne    8013ef <strtol+0x78>
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	40                   	inc    %eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	3c 78                	cmp    $0x78,%al
  8013e0:	75 0d                	jne    8013ef <strtol+0x78>
		s += 2, base = 16;
  8013e2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013e6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013ed:	eb 28                	jmp    801417 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f3:	75 15                	jne    80140a <strtol+0x93>
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	3c 30                	cmp    $0x30,%al
  8013fc:	75 0c                	jne    80140a <strtol+0x93>
		s++, base = 8;
  8013fe:	ff 45 08             	incl   0x8(%ebp)
  801401:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801408:	eb 0d                	jmp    801417 <strtol+0xa0>
	else if (base == 0)
  80140a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140e:	75 07                	jne    801417 <strtol+0xa0>
		base = 10;
  801410:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	3c 2f                	cmp    $0x2f,%al
  80141e:	7e 19                	jle    801439 <strtol+0xc2>
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	3c 39                	cmp    $0x39,%al
  801427:	7f 10                	jg     801439 <strtol+0xc2>
			dig = *s - '0';
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	0f be c0             	movsbl %al,%eax
  801431:	83 e8 30             	sub    $0x30,%eax
  801434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801437:	eb 42                	jmp    80147b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	3c 60                	cmp    $0x60,%al
  801440:	7e 19                	jle    80145b <strtol+0xe4>
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	3c 7a                	cmp    $0x7a,%al
  801449:	7f 10                	jg     80145b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	83 e8 57             	sub    $0x57,%eax
  801456:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801459:	eb 20                	jmp    80147b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	3c 40                	cmp    $0x40,%al
  801462:	7e 39                	jle    80149d <strtol+0x126>
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	3c 5a                	cmp    $0x5a,%al
  80146b:	7f 30                	jg     80149d <strtol+0x126>
			dig = *s - 'A' + 10;
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	0f be c0             	movsbl %al,%eax
  801475:	83 e8 37             	sub    $0x37,%eax
  801478:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801481:	7d 19                	jge    80149c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801483:	ff 45 08             	incl   0x8(%ebp)
  801486:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801489:	0f af 45 10          	imul   0x10(%ebp),%eax
  80148d:	89 c2                	mov    %eax,%edx
  80148f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801492:	01 d0                	add    %edx,%eax
  801494:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801497:	e9 7b ff ff ff       	jmp    801417 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80149c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80149d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a1:	74 08                	je     8014ab <strtol+0x134>
		*endptr = (char *) s;
  8014a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014af:	74 07                	je     8014b8 <strtol+0x141>
  8014b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b4:	f7 d8                	neg    %eax
  8014b6:	eb 03                	jmp    8014bb <strtol+0x144>
  8014b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <ltostr>:

void
ltostr(long value, char *str)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d5:	79 13                	jns    8014ea <ltostr+0x2d>
	{
		neg = 1;
  8014d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014e4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014e7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014f2:	99                   	cltd   
  8014f3:	f7 f9                	idiv   %ecx
  8014f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fb:	8d 50 01             	lea    0x1(%eax),%edx
  8014fe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801501:	89 c2                	mov    %eax,%edx
  801503:	8b 45 0c             	mov    0xc(%ebp),%eax
  801506:	01 d0                	add    %edx,%eax
  801508:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80150b:	83 c2 30             	add    $0x30,%edx
  80150e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801510:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801513:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801518:	f7 e9                	imul   %ecx
  80151a:	c1 fa 02             	sar    $0x2,%edx
  80151d:	89 c8                	mov    %ecx,%eax
  80151f:	c1 f8 1f             	sar    $0x1f,%eax
  801522:	29 c2                	sub    %eax,%edx
  801524:	89 d0                	mov    %edx,%eax
  801526:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801529:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801531:	f7 e9                	imul   %ecx
  801533:	c1 fa 02             	sar    $0x2,%edx
  801536:	89 c8                	mov    %ecx,%eax
  801538:	c1 f8 1f             	sar    $0x1f,%eax
  80153b:	29 c2                	sub    %eax,%edx
  80153d:	89 d0                	mov    %edx,%eax
  80153f:	c1 e0 02             	shl    $0x2,%eax
  801542:	01 d0                	add    %edx,%eax
  801544:	01 c0                	add    %eax,%eax
  801546:	29 c1                	sub    %eax,%ecx
  801548:	89 ca                	mov    %ecx,%edx
  80154a:	85 d2                	test   %edx,%edx
  80154c:	75 9c                	jne    8014ea <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80154e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801555:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801558:	48                   	dec    %eax
  801559:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80155c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801560:	74 3d                	je     80159f <ltostr+0xe2>
		start = 1 ;
  801562:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801569:	eb 34                	jmp    80159f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80156b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801571:	01 d0                	add    %edx,%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	01 c2                	add    %eax,%edx
  801580:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	01 c8                	add    %ecx,%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80158c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80158f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801592:	01 c2                	add    %eax,%edx
  801594:	8a 45 eb             	mov    -0x15(%ebp),%al
  801597:	88 02                	mov    %al,(%edx)
		start++ ;
  801599:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80159c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015a5:	7c c4                	jl     80156b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ad:	01 d0                	add    %edx,%eax
  8015af:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015b2:	90                   	nop
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	e8 54 fa ff ff       	call   801017 <strlen>
  8015c3:	83 c4 04             	add    $0x4,%esp
  8015c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	e8 46 fa ff ff       	call   801017 <strlen>
  8015d1:	83 c4 04             	add    $0x4,%esp
  8015d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e5:	eb 17                	jmp    8015fe <strcconcat+0x49>
		final[s] = str1[s] ;
  8015e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ed:	01 c2                	add    %eax,%edx
  8015ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	01 c8                	add    %ecx,%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015fb:	ff 45 fc             	incl   -0x4(%ebp)
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801601:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801604:	7c e1                	jl     8015e7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801606:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80160d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801614:	eb 1f                	jmp    801635 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801616:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801619:	8d 50 01             	lea    0x1(%eax),%edx
  80161c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161f:	89 c2                	mov    %eax,%edx
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	01 c2                	add    %eax,%edx
  801626:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162c:	01 c8                	add    %ecx,%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801632:	ff 45 f8             	incl   -0x8(%ebp)
  801635:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801638:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80163b:	7c d9                	jl     801616 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80163d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	01 d0                	add    %edx,%eax
  801645:	c6 00 00             	movb   $0x0,(%eax)
}
  801648:	90                   	nop
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80164e:	8b 45 14             	mov    0x14(%ebp),%eax
  801651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801657:	8b 45 14             	mov    0x14(%ebp),%eax
  80165a:	8b 00                	mov    (%eax),%eax
  80165c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801663:	8b 45 10             	mov    0x10(%ebp),%eax
  801666:	01 d0                	add    %edx,%eax
  801668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166e:	eb 0c                	jmp    80167c <strsplit+0x31>
			*string++ = 0;
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	8d 50 01             	lea    0x1(%eax),%edx
  801676:	89 55 08             	mov    %edx,0x8(%ebp)
  801679:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	84 c0                	test   %al,%al
  801683:	74 18                	je     80169d <strsplit+0x52>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	0f be c0             	movsbl %al,%eax
  80168d:	50                   	push   %eax
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	e8 13 fb ff ff       	call   8011a9 <strchr>
  801696:	83 c4 08             	add    $0x8,%esp
  801699:	85 c0                	test   %eax,%eax
  80169b:	75 d3                	jne    801670 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8a 00                	mov    (%eax),%al
  8016a2:	84 c0                	test   %al,%al
  8016a4:	74 5a                	je     801700 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a9:	8b 00                	mov    (%eax),%eax
  8016ab:	83 f8 0f             	cmp    $0xf,%eax
  8016ae:	75 07                	jne    8016b7 <strsplit+0x6c>
		{
			return 0;
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	eb 66                	jmp    80171d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ba:	8b 00                	mov    (%eax),%eax
  8016bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8016bf:	8b 55 14             	mov    0x14(%ebp),%edx
  8016c2:	89 0a                	mov    %ecx,(%edx)
  8016c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ce:	01 c2                	add    %eax,%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016d5:	eb 03                	jmp    8016da <strsplit+0x8f>
			string++;
  8016d7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 8b                	je     80166e <strsplit+0x23>
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f be c0             	movsbl %al,%eax
  8016eb:	50                   	push   %eax
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	e8 b5 fa ff ff       	call   8011a9 <strchr>
  8016f4:	83 c4 08             	add    $0x8,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	74 dc                	je     8016d7 <strsplit+0x8c>
			string++;
	}
  8016fb:	e9 6e ff ff ff       	jmp    80166e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801700:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801701:	8b 45 14             	mov    0x14(%ebp),%eax
  801704:	8b 00                	mov    (%eax),%eax
  801706:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80170d:	8b 45 10             	mov    0x10(%ebp),%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801718:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801725:	a1 04 40 80 00       	mov    0x804004,%eax
  80172a:	85 c0                	test   %eax,%eax
  80172c:	74 1f                	je     80174d <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80172e:	e8 1d 00 00 00       	call   801750 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	68 50 3d 80 00       	push   $0x803d50
  80173b:	e8 55 f2 ff ff       	call   800995 <cprintf>
  801740:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801743:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80174a:	00 00 00 
	}
}
  80174d:	90                   	nop
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801756:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80175d:	00 00 00 
  801760:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801767:	00 00 00 
  80176a:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801771:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801774:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80177b:	00 00 00 
  80177e:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801785:	00 00 00 
  801788:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80178f:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801792:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017a1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017a6:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8017ab:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8017b2:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8017b5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bf:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8017c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cf:	f7 75 f0             	divl   -0x10(%ebp)
  8017d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d5:	29 d0                	sub    %edx,%eax
  8017d7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8017da:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8017e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017e9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017ee:	83 ec 04             	sub    $0x4,%esp
  8017f1:	6a 06                	push   $0x6
  8017f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8017f6:	50                   	push   %eax
  8017f7:	e8 d4 05 00 00       	call   801dd0 <sys_allocate_chunk>
  8017fc:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017ff:	a1 20 41 80 00       	mov    0x804120,%eax
  801804:	83 ec 0c             	sub    $0xc,%esp
  801807:	50                   	push   %eax
  801808:	e8 49 0c 00 00       	call   802456 <initialize_MemBlocksList>
  80180d:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801810:	a1 48 41 80 00       	mov    0x804148,%eax
  801815:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801818:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80181c:	75 14                	jne    801832 <initialize_dyn_block_system+0xe2>
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	68 75 3d 80 00       	push   $0x803d75
  801826:	6a 39                	push   $0x39
  801828:	68 93 3d 80 00       	push   $0x803d93
  80182d:	e8 af ee ff ff       	call   8006e1 <_panic>
  801832:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801835:	8b 00                	mov    (%eax),%eax
  801837:	85 c0                	test   %eax,%eax
  801839:	74 10                	je     80184b <initialize_dyn_block_system+0xfb>
  80183b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80183e:	8b 00                	mov    (%eax),%eax
  801840:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801843:	8b 52 04             	mov    0x4(%edx),%edx
  801846:	89 50 04             	mov    %edx,0x4(%eax)
  801849:	eb 0b                	jmp    801856 <initialize_dyn_block_system+0x106>
  80184b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80184e:	8b 40 04             	mov    0x4(%eax),%eax
  801851:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801856:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801859:	8b 40 04             	mov    0x4(%eax),%eax
  80185c:	85 c0                	test   %eax,%eax
  80185e:	74 0f                	je     80186f <initialize_dyn_block_system+0x11f>
  801860:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801863:	8b 40 04             	mov    0x4(%eax),%eax
  801866:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801869:	8b 12                	mov    (%edx),%edx
  80186b:	89 10                	mov    %edx,(%eax)
  80186d:	eb 0a                	jmp    801879 <initialize_dyn_block_system+0x129>
  80186f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801872:	8b 00                	mov    (%eax),%eax
  801874:	a3 48 41 80 00       	mov    %eax,0x804148
  801879:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80187c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801882:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801885:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80188c:	a1 54 41 80 00       	mov    0x804154,%eax
  801891:	48                   	dec    %eax
  801892:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801897:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  8018a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a4:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  8018ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018af:	75 14                	jne    8018c5 <initialize_dyn_block_system+0x175>
  8018b1:	83 ec 04             	sub    $0x4,%esp
  8018b4:	68 a0 3d 80 00       	push   $0x803da0
  8018b9:	6a 3f                	push   $0x3f
  8018bb:	68 93 3d 80 00       	push   $0x803d93
  8018c0:	e8 1c ee ff ff       	call   8006e1 <_panic>
  8018c5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8018cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ce:	89 10                	mov    %edx,(%eax)
  8018d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d3:	8b 00                	mov    (%eax),%eax
  8018d5:	85 c0                	test   %eax,%eax
  8018d7:	74 0d                	je     8018e6 <initialize_dyn_block_system+0x196>
  8018d9:	a1 38 41 80 00       	mov    0x804138,%eax
  8018de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018e1:	89 50 04             	mov    %edx,0x4(%eax)
  8018e4:	eb 08                	jmp    8018ee <initialize_dyn_block_system+0x19e>
  8018e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8018ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f1:	a3 38 41 80 00       	mov    %eax,0x804138
  8018f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801900:	a1 44 41 80 00       	mov    0x804144,%eax
  801905:	40                   	inc    %eax
  801906:	a3 44 41 80 00       	mov    %eax,0x804144

}
  80190b:	90                   	nop
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801914:	e8 06 fe ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  801919:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80191d:	75 07                	jne    801926 <malloc+0x18>
  80191f:	b8 00 00 00 00       	mov    $0x0,%eax
  801924:	eb 7d                	jmp    8019a3 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801926:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80192d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801934:	8b 55 08             	mov    0x8(%ebp),%edx
  801937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193a:	01 d0                	add    %edx,%eax
  80193c:	48                   	dec    %eax
  80193d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801940:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801943:	ba 00 00 00 00       	mov    $0x0,%edx
  801948:	f7 75 f0             	divl   -0x10(%ebp)
  80194b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80194e:	29 d0                	sub    %edx,%eax
  801950:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801953:	e8 46 08 00 00       	call   80219e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801958:	83 f8 01             	cmp    $0x1,%eax
  80195b:	75 07                	jne    801964 <malloc+0x56>
  80195d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801964:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801968:	75 34                	jne    80199e <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  80196a:	83 ec 0c             	sub    $0xc,%esp
  80196d:	ff 75 e8             	pushl  -0x18(%ebp)
  801970:	e8 73 0e 00 00       	call   8027e8 <alloc_block_FF>
  801975:	83 c4 10             	add    $0x10,%esp
  801978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  80197b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80197f:	74 16                	je     801997 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801981:	83 ec 0c             	sub    $0xc,%esp
  801984:	ff 75 e4             	pushl  -0x1c(%ebp)
  801987:	e8 ff 0b 00 00       	call   80258b <insert_sorted_allocList>
  80198c:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  80198f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801992:	8b 40 08             	mov    0x8(%eax),%eax
  801995:	eb 0c                	jmp    8019a3 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801997:	b8 00 00 00 00       	mov    $0x0,%eax
  80199c:	eb 05                	jmp    8019a3 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80199e:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  8019b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019bf:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  8019c2:	83 ec 08             	sub    $0x8,%esp
  8019c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8019c8:	68 40 40 80 00       	push   $0x804040
  8019cd:	e8 61 0b 00 00       	call   802533 <find_block>
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8019d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019dc:	0f 84 a5 00 00 00    	je     801a87 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8019e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e8:	83 ec 08             	sub    $0x8,%esp
  8019eb:	50                   	push   %eax
  8019ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8019ef:	e8 a4 03 00 00       	call   801d98 <sys_free_user_mem>
  8019f4:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8019f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019fb:	75 17                	jne    801a14 <free+0x6f>
  8019fd:	83 ec 04             	sub    $0x4,%esp
  801a00:	68 75 3d 80 00       	push   $0x803d75
  801a05:	68 87 00 00 00       	push   $0x87
  801a0a:	68 93 3d 80 00       	push   $0x803d93
  801a0f:	e8 cd ec ff ff       	call   8006e1 <_panic>
  801a14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a17:	8b 00                	mov    (%eax),%eax
  801a19:	85 c0                	test   %eax,%eax
  801a1b:	74 10                	je     801a2d <free+0x88>
  801a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a20:	8b 00                	mov    (%eax),%eax
  801a22:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a25:	8b 52 04             	mov    0x4(%edx),%edx
  801a28:	89 50 04             	mov    %edx,0x4(%eax)
  801a2b:	eb 0b                	jmp    801a38 <free+0x93>
  801a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a30:	8b 40 04             	mov    0x4(%eax),%eax
  801a33:	a3 44 40 80 00       	mov    %eax,0x804044
  801a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a3b:	8b 40 04             	mov    0x4(%eax),%eax
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	74 0f                	je     801a51 <free+0xac>
  801a42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a45:	8b 40 04             	mov    0x4(%eax),%eax
  801a48:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a4b:	8b 12                	mov    (%edx),%edx
  801a4d:	89 10                	mov    %edx,(%eax)
  801a4f:	eb 0a                	jmp    801a5b <free+0xb6>
  801a51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a54:	8b 00                	mov    (%eax),%eax
  801a56:	a3 40 40 80 00       	mov    %eax,0x804040
  801a5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a6e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801a73:	48                   	dec    %eax
  801a74:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801a79:	83 ec 0c             	sub    $0xc,%esp
  801a7c:	ff 75 ec             	pushl  -0x14(%ebp)
  801a7f:	e8 37 12 00 00       	call   802cbb <insert_sorted_with_merge_freeList>
  801a84:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801a87:	90                   	nop
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 38             	sub    $0x38,%esp
  801a90:	8b 45 10             	mov    0x10(%ebp),%eax
  801a93:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a96:	e8 84 fc ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  801a9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a9f:	75 07                	jne    801aa8 <smalloc+0x1e>
  801aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa6:	eb 7e                	jmp    801b26 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801aa8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801aaf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abc:	01 d0                	add    %edx,%eax
  801abe:	48                   	dec    %eax
  801abf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ac5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aca:	f7 75 f0             	divl   -0x10(%ebp)
  801acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ad0:	29 d0                	sub    %edx,%eax
  801ad2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801ad5:	e8 c4 06 00 00       	call   80219e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ada:	83 f8 01             	cmp    $0x1,%eax
  801add:	75 42                	jne    801b21 <smalloc+0x97>

		  va = malloc(newsize) ;
  801adf:	83 ec 0c             	sub    $0xc,%esp
  801ae2:	ff 75 e8             	pushl  -0x18(%ebp)
  801ae5:	e8 24 fe ff ff       	call   80190e <malloc>
  801aea:	83 c4 10             	add    $0x10,%esp
  801aed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801af0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801af4:	74 24                	je     801b1a <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801af6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801afa:	ff 75 e4             	pushl  -0x1c(%ebp)
  801afd:	50                   	push   %eax
  801afe:	ff 75 e8             	pushl  -0x18(%ebp)
  801b01:	ff 75 08             	pushl  0x8(%ebp)
  801b04:	e8 1a 04 00 00       	call   801f23 <sys_createSharedObject>
  801b09:	83 c4 10             	add    $0x10,%esp
  801b0c:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801b0f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b13:	78 0c                	js     801b21 <smalloc+0x97>
					  return va ;
  801b15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b18:	eb 0c                	jmp    801b26 <smalloc+0x9c>
				 }
				 else
					return NULL;
  801b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1f:	eb 05                	jmp    801b26 <smalloc+0x9c>
	  }
		  return NULL ;
  801b21:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b2e:	e8 ec fb ff ff       	call   80171f <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801b33:	83 ec 08             	sub    $0x8,%esp
  801b36:	ff 75 0c             	pushl  0xc(%ebp)
  801b39:	ff 75 08             	pushl  0x8(%ebp)
  801b3c:	e8 0c 04 00 00       	call   801f4d <sys_getSizeOfSharedObject>
  801b41:	83 c4 10             	add    $0x10,%esp
  801b44:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801b47:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801b4b:	75 07                	jne    801b54 <sget+0x2c>
  801b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b52:	eb 75                	jmp    801bc9 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801b54:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b61:	01 d0                	add    %edx,%eax
  801b63:	48                   	dec    %eax
  801b64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6f:	f7 75 f0             	divl   -0x10(%ebp)
  801b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b75:	29 d0                	sub    %edx,%eax
  801b77:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801b7a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801b81:	e8 18 06 00 00       	call   80219e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b86:	83 f8 01             	cmp    $0x1,%eax
  801b89:	75 39                	jne    801bc4 <sget+0x9c>

		  va = malloc(newsize) ;
  801b8b:	83 ec 0c             	sub    $0xc,%esp
  801b8e:	ff 75 e8             	pushl  -0x18(%ebp)
  801b91:	e8 78 fd ff ff       	call   80190e <malloc>
  801b96:	83 c4 10             	add    $0x10,%esp
  801b99:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801b9c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ba0:	74 22                	je     801bc4 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801ba2:	83 ec 04             	sub    $0x4,%esp
  801ba5:	ff 75 e0             	pushl  -0x20(%ebp)
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	ff 75 08             	pushl  0x8(%ebp)
  801bae:	e8 b7 03 00 00       	call   801f6a <sys_getSharedObject>
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801bb9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801bbd:	78 05                	js     801bc4 <sget+0x9c>
					  return va;
  801bbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bc2:	eb 05                	jmp    801bc9 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801bc4:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bd1:	e8 49 fb ff ff       	call   80171f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bd6:	83 ec 04             	sub    $0x4,%esp
  801bd9:	68 c4 3d 80 00       	push   $0x803dc4
  801bde:	68 1e 01 00 00       	push   $0x11e
  801be3:	68 93 3d 80 00       	push   $0x803d93
  801be8:	e8 f4 ea ff ff       	call   8006e1 <_panic>

00801bed <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bf3:	83 ec 04             	sub    $0x4,%esp
  801bf6:	68 ec 3d 80 00       	push   $0x803dec
  801bfb:	68 32 01 00 00       	push   $0x132
  801c00:	68 93 3d 80 00       	push   $0x803d93
  801c05:	e8 d7 ea ff ff       	call   8006e1 <_panic>

00801c0a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c10:	83 ec 04             	sub    $0x4,%esp
  801c13:	68 10 3e 80 00       	push   $0x803e10
  801c18:	68 3d 01 00 00       	push   $0x13d
  801c1d:	68 93 3d 80 00       	push   $0x803d93
  801c22:	e8 ba ea ff ff       	call   8006e1 <_panic>

00801c27 <shrink>:

}
void shrink(uint32 newSize)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c2d:	83 ec 04             	sub    $0x4,%esp
  801c30:	68 10 3e 80 00       	push   $0x803e10
  801c35:	68 42 01 00 00       	push   $0x142
  801c3a:	68 93 3d 80 00       	push   $0x803d93
  801c3f:	e8 9d ea ff ff       	call   8006e1 <_panic>

00801c44 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c4a:	83 ec 04             	sub    $0x4,%esp
  801c4d:	68 10 3e 80 00       	push   $0x803e10
  801c52:	68 47 01 00 00       	push   $0x147
  801c57:	68 93 3d 80 00       	push   $0x803d93
  801c5c:	e8 80 ea ff ff       	call   8006e1 <_panic>

00801c61 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	57                   	push   %edi
  801c65:	56                   	push   %esi
  801c66:	53                   	push   %ebx
  801c67:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c70:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c73:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c76:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c79:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c7c:	cd 30                	int    $0x30
  801c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c84:	83 c4 10             	add    $0x10,%esp
  801c87:	5b                   	pop    %ebx
  801c88:	5e                   	pop    %esi
  801c89:	5f                   	pop    %edi
  801c8a:	5d                   	pop    %ebp
  801c8b:	c3                   	ret    

00801c8c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	83 ec 04             	sub    $0x4,%esp
  801c92:	8b 45 10             	mov    0x10(%ebp),%eax
  801c95:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c98:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	52                   	push   %edx
  801ca4:	ff 75 0c             	pushl  0xc(%ebp)
  801ca7:	50                   	push   %eax
  801ca8:	6a 00                	push   $0x0
  801caa:	e8 b2 ff ff ff       	call   801c61 <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
}
  801cb2:	90                   	nop
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_cgetc>:

int
sys_cgetc(void)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 01                	push   $0x1
  801cc4:	e8 98 ff ff ff       	call   801c61 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	52                   	push   %edx
  801cde:	50                   	push   %eax
  801cdf:	6a 05                	push   $0x5
  801ce1:	e8 7b ff ff ff       	call   801c61 <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	56                   	push   %esi
  801cef:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cf0:	8b 75 18             	mov    0x18(%ebp),%esi
  801cf3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	56                   	push   %esi
  801d00:	53                   	push   %ebx
  801d01:	51                   	push   %ecx
  801d02:	52                   	push   %edx
  801d03:	50                   	push   %eax
  801d04:	6a 06                	push   $0x6
  801d06:	e8 56 ff ff ff       	call   801c61 <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d11:	5b                   	pop    %ebx
  801d12:	5e                   	pop    %esi
  801d13:	5d                   	pop    %ebp
  801d14:	c3                   	ret    

00801d15 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	52                   	push   %edx
  801d25:	50                   	push   %eax
  801d26:	6a 07                	push   $0x7
  801d28:	e8 34 ff ff ff       	call   801c61 <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	ff 75 0c             	pushl  0xc(%ebp)
  801d3e:	ff 75 08             	pushl  0x8(%ebp)
  801d41:	6a 08                	push   $0x8
  801d43:	e8 19 ff ff ff       	call   801c61 <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 09                	push   $0x9
  801d5c:	e8 00 ff ff ff       	call   801c61 <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 0a                	push   $0xa
  801d75:	e8 e7 fe ff ff       	call   801c61 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 0b                	push   $0xb
  801d8e:	e8 ce fe ff ff       	call   801c61 <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	ff 75 0c             	pushl  0xc(%ebp)
  801da4:	ff 75 08             	pushl  0x8(%ebp)
  801da7:	6a 0f                	push   $0xf
  801da9:	e8 b3 fe ff ff       	call   801c61 <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
	return;
  801db1:	90                   	nop
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	ff 75 0c             	pushl  0xc(%ebp)
  801dc0:	ff 75 08             	pushl  0x8(%ebp)
  801dc3:	6a 10                	push   $0x10
  801dc5:	e8 97 fe ff ff       	call   801c61 <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
	return ;
  801dcd:	90                   	nop
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	ff 75 10             	pushl  0x10(%ebp)
  801dda:	ff 75 0c             	pushl  0xc(%ebp)
  801ddd:	ff 75 08             	pushl  0x8(%ebp)
  801de0:	6a 11                	push   $0x11
  801de2:	e8 7a fe ff ff       	call   801c61 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dea:	90                   	nop
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 0c                	push   $0xc
  801dfc:	e8 60 fe ff ff       	call   801c61 <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	ff 75 08             	pushl  0x8(%ebp)
  801e14:	6a 0d                	push   $0xd
  801e16:	e8 46 fe ff ff       	call   801c61 <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 0e                	push   $0xe
  801e2f:	e8 2d fe ff ff       	call   801c61 <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
}
  801e37:	90                   	nop
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 13                	push   $0x13
  801e49:	e8 13 fe ff ff       	call   801c61 <syscall>
  801e4e:	83 c4 18             	add    $0x18,%esp
}
  801e51:	90                   	nop
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 14                	push   $0x14
  801e63:	e8 f9 fd ff ff       	call   801c61 <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
}
  801e6b:	90                   	nop
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_cputc>:


void
sys_cputc(const char c)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 04             	sub    $0x4,%esp
  801e74:	8b 45 08             	mov    0x8(%ebp),%eax
  801e77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e7a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	50                   	push   %eax
  801e87:	6a 15                	push   $0x15
  801e89:	e8 d3 fd ff ff       	call   801c61 <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
}
  801e91:	90                   	nop
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 16                	push   $0x16
  801ea3:	e8 b9 fd ff ff       	call   801c61 <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
}
  801eab:	90                   	nop
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	ff 75 0c             	pushl  0xc(%ebp)
  801ebd:	50                   	push   %eax
  801ebe:	6a 17                	push   $0x17
  801ec0:	e8 9c fd ff ff       	call   801c61 <syscall>
  801ec5:	83 c4 18             	add    $0x18,%esp
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ecd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	52                   	push   %edx
  801eda:	50                   	push   %eax
  801edb:	6a 1a                	push   $0x1a
  801edd:	e8 7f fd ff ff       	call   801c61 <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	52                   	push   %edx
  801ef7:	50                   	push   %eax
  801ef8:	6a 18                	push   $0x18
  801efa:	e8 62 fd ff ff       	call   801c61 <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
}
  801f02:	90                   	nop
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	52                   	push   %edx
  801f15:	50                   	push   %eax
  801f16:	6a 19                	push   $0x19
  801f18:	e8 44 fd ff ff       	call   801c61 <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
}
  801f20:	90                   	nop
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 04             	sub    $0x4,%esp
  801f29:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f2f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f32:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	6a 00                	push   $0x0
  801f3b:	51                   	push   %ecx
  801f3c:	52                   	push   %edx
  801f3d:	ff 75 0c             	pushl  0xc(%ebp)
  801f40:	50                   	push   %eax
  801f41:	6a 1b                	push   $0x1b
  801f43:	e8 19 fd ff ff       	call   801c61 <syscall>
  801f48:	83 c4 18             	add    $0x18,%esp
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	52                   	push   %edx
  801f5d:	50                   	push   %eax
  801f5e:	6a 1c                	push   $0x1c
  801f60:	e8 fc fc ff ff       	call   801c61 <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	51                   	push   %ecx
  801f7b:	52                   	push   %edx
  801f7c:	50                   	push   %eax
  801f7d:	6a 1d                	push   $0x1d
  801f7f:	e8 dd fc ff ff       	call   801c61 <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	52                   	push   %edx
  801f99:	50                   	push   %eax
  801f9a:	6a 1e                	push   $0x1e
  801f9c:	e8 c0 fc ff ff       	call   801c61 <syscall>
  801fa1:	83 c4 18             	add    $0x18,%esp
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 1f                	push   $0x1f
  801fb5:	e8 a7 fc ff ff       	call   801c61 <syscall>
  801fba:	83 c4 18             	add    $0x18,%esp
}
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	6a 00                	push   $0x0
  801fc7:	ff 75 14             	pushl  0x14(%ebp)
  801fca:	ff 75 10             	pushl  0x10(%ebp)
  801fcd:	ff 75 0c             	pushl  0xc(%ebp)
  801fd0:	50                   	push   %eax
  801fd1:	6a 20                	push   $0x20
  801fd3:	e8 89 fc ff ff       	call   801c61 <syscall>
  801fd8:	83 c4 18             	add    $0x18,%esp
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	50                   	push   %eax
  801fec:	6a 21                	push   $0x21
  801fee:	e8 6e fc ff ff       	call   801c61 <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
}
  801ff6:	90                   	nop
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	50                   	push   %eax
  802008:	6a 22                	push   $0x22
  80200a:	e8 52 fc ff ff       	call   801c61 <syscall>
  80200f:	83 c4 18             	add    $0x18,%esp
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 02                	push   $0x2
  802023:	e8 39 fc ff ff       	call   801c61 <syscall>
  802028:	83 c4 18             	add    $0x18,%esp
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 03                	push   $0x3
  80203c:	e8 20 fc ff ff       	call   801c61 <syscall>
  802041:	83 c4 18             	add    $0x18,%esp
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 04                	push   $0x4
  802055:	e8 07 fc ff ff       	call   801c61 <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <sys_exit_env>:


void sys_exit_env(void)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 23                	push   $0x23
  80206e:	e8 ee fb ff ff       	call   801c61 <syscall>
  802073:	83 c4 18             	add    $0x18,%esp
}
  802076:	90                   	nop
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80207f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802082:	8d 50 04             	lea    0x4(%eax),%edx
  802085:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	52                   	push   %edx
  80208f:	50                   	push   %eax
  802090:	6a 24                	push   $0x24
  802092:	e8 ca fb ff ff       	call   801c61 <syscall>
  802097:	83 c4 18             	add    $0x18,%esp
	return result;
  80209a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80209d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020a3:	89 01                	mov    %eax,(%ecx)
  8020a5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	c9                   	leave  
  8020ac:	c2 04 00             	ret    $0x4

008020af <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	ff 75 10             	pushl  0x10(%ebp)
  8020b9:	ff 75 0c             	pushl  0xc(%ebp)
  8020bc:	ff 75 08             	pushl  0x8(%ebp)
  8020bf:	6a 12                	push   $0x12
  8020c1:	e8 9b fb ff ff       	call   801c61 <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8020c9:	90                   	nop
}
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <sys_rcr2>:
uint32 sys_rcr2()
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 25                	push   $0x25
  8020db:	e8 81 fb ff ff       	call   801c61 <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	83 ec 04             	sub    $0x4,%esp
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020f1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	50                   	push   %eax
  8020fe:	6a 26                	push   $0x26
  802100:	e8 5c fb ff ff       	call   801c61 <syscall>
  802105:	83 c4 18             	add    $0x18,%esp
	return ;
  802108:	90                   	nop
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <rsttst>:
void rsttst()
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 28                	push   $0x28
  80211a:	e8 42 fb ff ff       	call   801c61 <syscall>
  80211f:	83 c4 18             	add    $0x18,%esp
	return ;
  802122:	90                   	nop
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 04             	sub    $0x4,%esp
  80212b:	8b 45 14             	mov    0x14(%ebp),%eax
  80212e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802131:	8b 55 18             	mov    0x18(%ebp),%edx
  802134:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802138:	52                   	push   %edx
  802139:	50                   	push   %eax
  80213a:	ff 75 10             	pushl  0x10(%ebp)
  80213d:	ff 75 0c             	pushl  0xc(%ebp)
  802140:	ff 75 08             	pushl  0x8(%ebp)
  802143:	6a 27                	push   $0x27
  802145:	e8 17 fb ff ff       	call   801c61 <syscall>
  80214a:	83 c4 18             	add    $0x18,%esp
	return ;
  80214d:	90                   	nop
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <chktst>:
void chktst(uint32 n)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	ff 75 08             	pushl  0x8(%ebp)
  80215e:	6a 29                	push   $0x29
  802160:	e8 fc fa ff ff       	call   801c61 <syscall>
  802165:	83 c4 18             	add    $0x18,%esp
	return ;
  802168:	90                   	nop
}
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <inctst>:

void inctst()
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 2a                	push   $0x2a
  80217a:	e8 e2 fa ff ff       	call   801c61 <syscall>
  80217f:	83 c4 18             	add    $0x18,%esp
	return ;
  802182:	90                   	nop
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <gettst>:
uint32 gettst()
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 2b                	push   $0x2b
  802194:	e8 c8 fa ff ff       	call   801c61 <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 2c                	push   $0x2c
  8021b0:	e8 ac fa ff ff       	call   801c61 <syscall>
  8021b5:	83 c4 18             	add    $0x18,%esp
  8021b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021bb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021bf:	75 07                	jne    8021c8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c6:	eb 05                	jmp    8021cd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 2c                	push   $0x2c
  8021e1:	e8 7b fa ff ff       	call   801c61 <syscall>
  8021e6:	83 c4 18             	add    $0x18,%esp
  8021e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021ec:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021f0:	75 07                	jne    8021f9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f7:	eb 05                	jmp    8021fe <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 2c                	push   $0x2c
  802212:	e8 4a fa ff ff       	call   801c61 <syscall>
  802217:	83 c4 18             	add    $0x18,%esp
  80221a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80221d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802221:	75 07                	jne    80222a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802223:	b8 01 00 00 00       	mov    $0x1,%eax
  802228:	eb 05                	jmp    80222f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80222a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
  802234:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 2c                	push   $0x2c
  802243:	e8 19 fa ff ff       	call   801c61 <syscall>
  802248:	83 c4 18             	add    $0x18,%esp
  80224b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80224e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802252:	75 07                	jne    80225b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802254:	b8 01 00 00 00       	mov    $0x1,%eax
  802259:	eb 05                	jmp    802260 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80225b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802260:	c9                   	leave  
  802261:	c3                   	ret    

00802262 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802262:	55                   	push   %ebp
  802263:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	ff 75 08             	pushl  0x8(%ebp)
  802270:	6a 2d                	push   $0x2d
  802272:	e8 ea f9 ff ff       	call   801c61 <syscall>
  802277:	83 c4 18             	add    $0x18,%esp
	return ;
  80227a:	90                   	nop
}
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802281:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802284:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802287:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	6a 00                	push   $0x0
  80228f:	53                   	push   %ebx
  802290:	51                   	push   %ecx
  802291:	52                   	push   %edx
  802292:	50                   	push   %eax
  802293:	6a 2e                	push   $0x2e
  802295:	e8 c7 f9 ff ff       	call   801c61 <syscall>
  80229a:	83 c4 18             	add    $0x18,%esp
}
  80229d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022a0:	c9                   	leave  
  8022a1:	c3                   	ret    

008022a2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	52                   	push   %edx
  8022b2:	50                   	push   %eax
  8022b3:	6a 2f                	push   $0x2f
  8022b5:	e8 a7 f9 ff ff       	call   801c61 <syscall>
  8022ba:	83 c4 18             	add    $0x18,%esp
}
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
  8022c2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022c5:	83 ec 0c             	sub    $0xc,%esp
  8022c8:	68 20 3e 80 00       	push   $0x803e20
  8022cd:	e8 c3 e6 ff ff       	call   800995 <cprintf>
  8022d2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022dc:	83 ec 0c             	sub    $0xc,%esp
  8022df:	68 4c 3e 80 00       	push   $0x803e4c
  8022e4:	e8 ac e6 ff ff       	call   800995 <cprintf>
  8022e9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022ec:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022f0:	a1 38 41 80 00       	mov    0x804138,%eax
  8022f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f8:	eb 56                	jmp    802350 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022fe:	74 1c                	je     80231c <print_mem_block_lists+0x5d>
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	8b 50 08             	mov    0x8(%eax),%edx
  802306:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802309:	8b 48 08             	mov    0x8(%eax),%ecx
  80230c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230f:	8b 40 0c             	mov    0xc(%eax),%eax
  802312:	01 c8                	add    %ecx,%eax
  802314:	39 c2                	cmp    %eax,%edx
  802316:	73 04                	jae    80231c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802318:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 50 08             	mov    0x8(%eax),%edx
  802322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802325:	8b 40 0c             	mov    0xc(%eax),%eax
  802328:	01 c2                	add    %eax,%edx
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	8b 40 08             	mov    0x8(%eax),%eax
  802330:	83 ec 04             	sub    $0x4,%esp
  802333:	52                   	push   %edx
  802334:	50                   	push   %eax
  802335:	68 61 3e 80 00       	push   $0x803e61
  80233a:	e8 56 e6 ff ff       	call   800995 <cprintf>
  80233f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802348:	a1 40 41 80 00       	mov    0x804140,%eax
  80234d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802350:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802354:	74 07                	je     80235d <print_mem_block_lists+0x9e>
  802356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802359:	8b 00                	mov    (%eax),%eax
  80235b:	eb 05                	jmp    802362 <print_mem_block_lists+0xa3>
  80235d:	b8 00 00 00 00       	mov    $0x0,%eax
  802362:	a3 40 41 80 00       	mov    %eax,0x804140
  802367:	a1 40 41 80 00       	mov    0x804140,%eax
  80236c:	85 c0                	test   %eax,%eax
  80236e:	75 8a                	jne    8022fa <print_mem_block_lists+0x3b>
  802370:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802374:	75 84                	jne    8022fa <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802376:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80237a:	75 10                	jne    80238c <print_mem_block_lists+0xcd>
  80237c:	83 ec 0c             	sub    $0xc,%esp
  80237f:	68 70 3e 80 00       	push   $0x803e70
  802384:	e8 0c e6 ff ff       	call   800995 <cprintf>
  802389:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80238c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802393:	83 ec 0c             	sub    $0xc,%esp
  802396:	68 94 3e 80 00       	push   $0x803e94
  80239b:	e8 f5 e5 ff ff       	call   800995 <cprintf>
  8023a0:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8023a3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023a7:	a1 40 40 80 00       	mov    0x804040,%eax
  8023ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023af:	eb 56                	jmp    802407 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023b5:	74 1c                	je     8023d3 <print_mem_block_lists+0x114>
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	8b 50 08             	mov    0x8(%eax),%edx
  8023bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c0:	8b 48 08             	mov    0x8(%eax),%ecx
  8023c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c9:	01 c8                	add    %ecx,%eax
  8023cb:	39 c2                	cmp    %eax,%edx
  8023cd:	73 04                	jae    8023d3 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023cf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	8b 50 08             	mov    0x8(%eax),%edx
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023df:	01 c2                	add    %eax,%edx
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 40 08             	mov    0x8(%eax),%eax
  8023e7:	83 ec 04             	sub    $0x4,%esp
  8023ea:	52                   	push   %edx
  8023eb:	50                   	push   %eax
  8023ec:	68 61 3e 80 00       	push   $0x803e61
  8023f1:	e8 9f e5 ff ff       	call   800995 <cprintf>
  8023f6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023ff:	a1 48 40 80 00       	mov    0x804048,%eax
  802404:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802407:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240b:	74 07                	je     802414 <print_mem_block_lists+0x155>
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	8b 00                	mov    (%eax),%eax
  802412:	eb 05                	jmp    802419 <print_mem_block_lists+0x15a>
  802414:	b8 00 00 00 00       	mov    $0x0,%eax
  802419:	a3 48 40 80 00       	mov    %eax,0x804048
  80241e:	a1 48 40 80 00       	mov    0x804048,%eax
  802423:	85 c0                	test   %eax,%eax
  802425:	75 8a                	jne    8023b1 <print_mem_block_lists+0xf2>
  802427:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242b:	75 84                	jne    8023b1 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80242d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802431:	75 10                	jne    802443 <print_mem_block_lists+0x184>
  802433:	83 ec 0c             	sub    $0xc,%esp
  802436:	68 ac 3e 80 00       	push   $0x803eac
  80243b:	e8 55 e5 ff ff       	call   800995 <cprintf>
  802440:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802443:	83 ec 0c             	sub    $0xc,%esp
  802446:	68 20 3e 80 00       	push   $0x803e20
  80244b:	e8 45 e5 ff ff       	call   800995 <cprintf>
  802450:	83 c4 10             	add    $0x10,%esp

}
  802453:	90                   	nop
  802454:	c9                   	leave  
  802455:	c3                   	ret    

00802456 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
  802459:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  80245c:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802463:	00 00 00 
  802466:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80246d:	00 00 00 
  802470:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802477:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80247a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802481:	e9 9e 00 00 00       	jmp    802524 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802486:	a1 50 40 80 00       	mov    0x804050,%eax
  80248b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248e:	c1 e2 04             	shl    $0x4,%edx
  802491:	01 d0                	add    %edx,%eax
  802493:	85 c0                	test   %eax,%eax
  802495:	75 14                	jne    8024ab <initialize_MemBlocksList+0x55>
  802497:	83 ec 04             	sub    $0x4,%esp
  80249a:	68 d4 3e 80 00       	push   $0x803ed4
  80249f:	6a 47                	push   $0x47
  8024a1:	68 f7 3e 80 00       	push   $0x803ef7
  8024a6:	e8 36 e2 ff ff       	call   8006e1 <_panic>
  8024ab:	a1 50 40 80 00       	mov    0x804050,%eax
  8024b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b3:	c1 e2 04             	shl    $0x4,%edx
  8024b6:	01 d0                	add    %edx,%eax
  8024b8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8024be:	89 10                	mov    %edx,(%eax)
  8024c0:	8b 00                	mov    (%eax),%eax
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	74 18                	je     8024de <initialize_MemBlocksList+0x88>
  8024c6:	a1 48 41 80 00       	mov    0x804148,%eax
  8024cb:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8024d1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024d4:	c1 e1 04             	shl    $0x4,%ecx
  8024d7:	01 ca                	add    %ecx,%edx
  8024d9:	89 50 04             	mov    %edx,0x4(%eax)
  8024dc:	eb 12                	jmp    8024f0 <initialize_MemBlocksList+0x9a>
  8024de:	a1 50 40 80 00       	mov    0x804050,%eax
  8024e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e6:	c1 e2 04             	shl    $0x4,%edx
  8024e9:	01 d0                	add    %edx,%eax
  8024eb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024f0:	a1 50 40 80 00       	mov    0x804050,%eax
  8024f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f8:	c1 e2 04             	shl    $0x4,%edx
  8024fb:	01 d0                	add    %edx,%eax
  8024fd:	a3 48 41 80 00       	mov    %eax,0x804148
  802502:	a1 50 40 80 00       	mov    0x804050,%eax
  802507:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250a:	c1 e2 04             	shl    $0x4,%edx
  80250d:	01 d0                	add    %edx,%eax
  80250f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802516:	a1 54 41 80 00       	mov    0x804154,%eax
  80251b:	40                   	inc    %eax
  80251c:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802521:	ff 45 f4             	incl   -0xc(%ebp)
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	3b 45 08             	cmp    0x8(%ebp),%eax
  80252a:	0f 82 56 ff ff ff    	jb     802486 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802530:	90                   	nop
  802531:	c9                   	leave  
  802532:	c3                   	ret    

00802533 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp
  802536:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802539:	8b 45 08             	mov    0x8(%ebp),%eax
  80253c:	8b 00                	mov    (%eax),%eax
  80253e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802541:	eb 19                	jmp    80255c <find_block+0x29>
	{
		if(element->sva == va){
  802543:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802546:	8b 40 08             	mov    0x8(%eax),%eax
  802549:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80254c:	75 05                	jne    802553 <find_block+0x20>
			 		return element;
  80254e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802551:	eb 36                	jmp    802589 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802553:	8b 45 08             	mov    0x8(%ebp),%eax
  802556:	8b 40 08             	mov    0x8(%eax),%eax
  802559:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80255c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802560:	74 07                	je     802569 <find_block+0x36>
  802562:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802565:	8b 00                	mov    (%eax),%eax
  802567:	eb 05                	jmp    80256e <find_block+0x3b>
  802569:	b8 00 00 00 00       	mov    $0x0,%eax
  80256e:	8b 55 08             	mov    0x8(%ebp),%edx
  802571:	89 42 08             	mov    %eax,0x8(%edx)
  802574:	8b 45 08             	mov    0x8(%ebp),%eax
  802577:	8b 40 08             	mov    0x8(%eax),%eax
  80257a:	85 c0                	test   %eax,%eax
  80257c:	75 c5                	jne    802543 <find_block+0x10>
  80257e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802582:	75 bf                	jne    802543 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802584:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802589:	c9                   	leave  
  80258a:	c3                   	ret    

0080258b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80258b:	55                   	push   %ebp
  80258c:	89 e5                	mov    %esp,%ebp
  80258e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802591:	a1 44 40 80 00       	mov    0x804044,%eax
  802596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802599:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80259e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  8025a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025a5:	74 0a                	je     8025b1 <insert_sorted_allocList+0x26>
  8025a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025aa:	8b 40 08             	mov    0x8(%eax),%eax
  8025ad:	85 c0                	test   %eax,%eax
  8025af:	75 65                	jne    802616 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8025b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025b5:	75 14                	jne    8025cb <insert_sorted_allocList+0x40>
  8025b7:	83 ec 04             	sub    $0x4,%esp
  8025ba:	68 d4 3e 80 00       	push   $0x803ed4
  8025bf:	6a 6e                	push   $0x6e
  8025c1:	68 f7 3e 80 00       	push   $0x803ef7
  8025c6:	e8 16 e1 ff ff       	call   8006e1 <_panic>
  8025cb:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8025d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d4:	89 10                	mov    %edx,(%eax)
  8025d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d9:	8b 00                	mov    (%eax),%eax
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	74 0d                	je     8025ec <insert_sorted_allocList+0x61>
  8025df:	a1 40 40 80 00       	mov    0x804040,%eax
  8025e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e7:	89 50 04             	mov    %edx,0x4(%eax)
  8025ea:	eb 08                	jmp    8025f4 <insert_sorted_allocList+0x69>
  8025ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ef:	a3 44 40 80 00       	mov    %eax,0x804044
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	a3 40 40 80 00       	mov    %eax,0x804040
  8025fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802606:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80260b:	40                   	inc    %eax
  80260c:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802611:	e9 cf 01 00 00       	jmp    8027e5 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802619:	8b 50 08             	mov    0x8(%eax),%edx
  80261c:	8b 45 08             	mov    0x8(%ebp),%eax
  80261f:	8b 40 08             	mov    0x8(%eax),%eax
  802622:	39 c2                	cmp    %eax,%edx
  802624:	73 65                	jae    80268b <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802626:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80262a:	75 14                	jne    802640 <insert_sorted_allocList+0xb5>
  80262c:	83 ec 04             	sub    $0x4,%esp
  80262f:	68 10 3f 80 00       	push   $0x803f10
  802634:	6a 72                	push   $0x72
  802636:	68 f7 3e 80 00       	push   $0x803ef7
  80263b:	e8 a1 e0 ff ff       	call   8006e1 <_panic>
  802640:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
  802649:	89 50 04             	mov    %edx,0x4(%eax)
  80264c:	8b 45 08             	mov    0x8(%ebp),%eax
  80264f:	8b 40 04             	mov    0x4(%eax),%eax
  802652:	85 c0                	test   %eax,%eax
  802654:	74 0c                	je     802662 <insert_sorted_allocList+0xd7>
  802656:	a1 44 40 80 00       	mov    0x804044,%eax
  80265b:	8b 55 08             	mov    0x8(%ebp),%edx
  80265e:	89 10                	mov    %edx,(%eax)
  802660:	eb 08                	jmp    80266a <insert_sorted_allocList+0xdf>
  802662:	8b 45 08             	mov    0x8(%ebp),%eax
  802665:	a3 40 40 80 00       	mov    %eax,0x804040
  80266a:	8b 45 08             	mov    0x8(%ebp),%eax
  80266d:	a3 44 40 80 00       	mov    %eax,0x804044
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802680:	40                   	inc    %eax
  802681:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802686:	e9 5a 01 00 00       	jmp    8027e5 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  80268b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268e:	8b 50 08             	mov    0x8(%eax),%edx
  802691:	8b 45 08             	mov    0x8(%ebp),%eax
  802694:	8b 40 08             	mov    0x8(%eax),%eax
  802697:	39 c2                	cmp    %eax,%edx
  802699:	75 70                	jne    80270b <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  80269b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80269f:	74 06                	je     8026a7 <insert_sorted_allocList+0x11c>
  8026a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026a5:	75 14                	jne    8026bb <insert_sorted_allocList+0x130>
  8026a7:	83 ec 04             	sub    $0x4,%esp
  8026aa:	68 34 3f 80 00       	push   $0x803f34
  8026af:	6a 75                	push   $0x75
  8026b1:	68 f7 3e 80 00       	push   $0x803ef7
  8026b6:	e8 26 e0 ff ff       	call   8006e1 <_panic>
  8026bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026be:	8b 10                	mov    (%eax),%edx
  8026c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c3:	89 10                	mov    %edx,(%eax)
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	8b 00                	mov    (%eax),%eax
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	74 0b                	je     8026d9 <insert_sorted_allocList+0x14e>
  8026ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d1:	8b 00                	mov    (%eax),%eax
  8026d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d6:	89 50 04             	mov    %edx,0x4(%eax)
  8026d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8026df:	89 10                	mov    %edx,(%eax)
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026e7:	89 50 04             	mov    %edx,0x4(%eax)
  8026ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ed:	8b 00                	mov    (%eax),%eax
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	75 08                	jne    8026fb <insert_sorted_allocList+0x170>
  8026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f6:	a3 44 40 80 00       	mov    %eax,0x804044
  8026fb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802700:	40                   	inc    %eax
  802701:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802706:	e9 da 00 00 00       	jmp    8027e5 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80270b:	a1 40 40 80 00       	mov    0x804040,%eax
  802710:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802713:	e9 9d 00 00 00       	jmp    8027b5 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 00                	mov    (%eax),%eax
  80271d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802720:	8b 45 08             	mov    0x8(%ebp),%eax
  802723:	8b 50 08             	mov    0x8(%eax),%edx
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 40 08             	mov    0x8(%eax),%eax
  80272c:	39 c2                	cmp    %eax,%edx
  80272e:	76 7d                	jbe    8027ad <insert_sorted_allocList+0x222>
  802730:	8b 45 08             	mov    0x8(%ebp),%eax
  802733:	8b 50 08             	mov    0x8(%eax),%edx
  802736:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802739:	8b 40 08             	mov    0x8(%eax),%eax
  80273c:	39 c2                	cmp    %eax,%edx
  80273e:	73 6d                	jae    8027ad <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802740:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802744:	74 06                	je     80274c <insert_sorted_allocList+0x1c1>
  802746:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80274a:	75 14                	jne    802760 <insert_sorted_allocList+0x1d5>
  80274c:	83 ec 04             	sub    $0x4,%esp
  80274f:	68 34 3f 80 00       	push   $0x803f34
  802754:	6a 7c                	push   $0x7c
  802756:	68 f7 3e 80 00       	push   $0x803ef7
  80275b:	e8 81 df ff ff       	call   8006e1 <_panic>
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 10                	mov    (%eax),%edx
  802765:	8b 45 08             	mov    0x8(%ebp),%eax
  802768:	89 10                	mov    %edx,(%eax)
  80276a:	8b 45 08             	mov    0x8(%ebp),%eax
  80276d:	8b 00                	mov    (%eax),%eax
  80276f:	85 c0                	test   %eax,%eax
  802771:	74 0b                	je     80277e <insert_sorted_allocList+0x1f3>
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	8b 00                	mov    (%eax),%eax
  802778:	8b 55 08             	mov    0x8(%ebp),%edx
  80277b:	89 50 04             	mov    %edx,0x4(%eax)
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	8b 55 08             	mov    0x8(%ebp),%edx
  802784:	89 10                	mov    %edx,(%eax)
  802786:	8b 45 08             	mov    0x8(%ebp),%eax
  802789:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278c:	89 50 04             	mov    %edx,0x4(%eax)
  80278f:	8b 45 08             	mov    0x8(%ebp),%eax
  802792:	8b 00                	mov    (%eax),%eax
  802794:	85 c0                	test   %eax,%eax
  802796:	75 08                	jne    8027a0 <insert_sorted_allocList+0x215>
  802798:	8b 45 08             	mov    0x8(%ebp),%eax
  80279b:	a3 44 40 80 00       	mov    %eax,0x804044
  8027a0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8027a5:	40                   	inc    %eax
  8027a6:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8027ab:	eb 38                	jmp    8027e5 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8027ad:	a1 48 40 80 00       	mov    0x804048,%eax
  8027b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b9:	74 07                	je     8027c2 <insert_sorted_allocList+0x237>
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 00                	mov    (%eax),%eax
  8027c0:	eb 05                	jmp    8027c7 <insert_sorted_allocList+0x23c>
  8027c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c7:	a3 48 40 80 00       	mov    %eax,0x804048
  8027cc:	a1 48 40 80 00       	mov    0x804048,%eax
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	0f 85 3f ff ff ff    	jne    802718 <insert_sorted_allocList+0x18d>
  8027d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027dd:	0f 85 35 ff ff ff    	jne    802718 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8027e3:	eb 00                	jmp    8027e5 <insert_sorted_allocList+0x25a>
  8027e5:	90                   	nop
  8027e6:	c9                   	leave  
  8027e7:	c3                   	ret    

008027e8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8027e8:	55                   	push   %ebp
  8027e9:	89 e5                	mov    %esp,%ebp
  8027eb:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8027ee:	a1 38 41 80 00       	mov    0x804138,%eax
  8027f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f6:	e9 6b 02 00 00       	jmp    802a66 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802801:	3b 45 08             	cmp    0x8(%ebp),%eax
  802804:	0f 85 90 00 00 00    	jne    80289a <alloc_block_FF+0xb2>
			  temp=element;
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802810:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802814:	75 17                	jne    80282d <alloc_block_FF+0x45>
  802816:	83 ec 04             	sub    $0x4,%esp
  802819:	68 68 3f 80 00       	push   $0x803f68
  80281e:	68 92 00 00 00       	push   $0x92
  802823:	68 f7 3e 80 00       	push   $0x803ef7
  802828:	e8 b4 de ff ff       	call   8006e1 <_panic>
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	8b 00                	mov    (%eax),%eax
  802832:	85 c0                	test   %eax,%eax
  802834:	74 10                	je     802846 <alloc_block_FF+0x5e>
  802836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802839:	8b 00                	mov    (%eax),%eax
  80283b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283e:	8b 52 04             	mov    0x4(%edx),%edx
  802841:	89 50 04             	mov    %edx,0x4(%eax)
  802844:	eb 0b                	jmp    802851 <alloc_block_FF+0x69>
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 40 04             	mov    0x4(%eax),%eax
  80284c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 40 04             	mov    0x4(%eax),%eax
  802857:	85 c0                	test   %eax,%eax
  802859:	74 0f                	je     80286a <alloc_block_FF+0x82>
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 40 04             	mov    0x4(%eax),%eax
  802861:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802864:	8b 12                	mov    (%edx),%edx
  802866:	89 10                	mov    %edx,(%eax)
  802868:	eb 0a                	jmp    802874 <alloc_block_FF+0x8c>
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	a3 38 41 80 00       	mov    %eax,0x804138
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802887:	a1 44 41 80 00       	mov    0x804144,%eax
  80288c:	48                   	dec    %eax
  80288d:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802892:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802895:	e9 ff 01 00 00       	jmp    802a99 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a3:	0f 86 b5 01 00 00    	jbe    802a5e <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8028af:	2b 45 08             	sub    0x8(%ebp),%eax
  8028b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  8028b5:	a1 48 41 80 00       	mov    0x804148,%eax
  8028ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  8028bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028c1:	75 17                	jne    8028da <alloc_block_FF+0xf2>
  8028c3:	83 ec 04             	sub    $0x4,%esp
  8028c6:	68 68 3f 80 00       	push   $0x803f68
  8028cb:	68 99 00 00 00       	push   $0x99
  8028d0:	68 f7 3e 80 00       	push   $0x803ef7
  8028d5:	e8 07 de ff ff       	call   8006e1 <_panic>
  8028da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dd:	8b 00                	mov    (%eax),%eax
  8028df:	85 c0                	test   %eax,%eax
  8028e1:	74 10                	je     8028f3 <alloc_block_FF+0x10b>
  8028e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028eb:	8b 52 04             	mov    0x4(%edx),%edx
  8028ee:	89 50 04             	mov    %edx,0x4(%eax)
  8028f1:	eb 0b                	jmp    8028fe <alloc_block_FF+0x116>
  8028f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f6:	8b 40 04             	mov    0x4(%eax),%eax
  8028f9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802901:	8b 40 04             	mov    0x4(%eax),%eax
  802904:	85 c0                	test   %eax,%eax
  802906:	74 0f                	je     802917 <alloc_block_FF+0x12f>
  802908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290b:	8b 40 04             	mov    0x4(%eax),%eax
  80290e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802911:	8b 12                	mov    (%edx),%edx
  802913:	89 10                	mov    %edx,(%eax)
  802915:	eb 0a                	jmp    802921 <alloc_block_FF+0x139>
  802917:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291a:	8b 00                	mov    (%eax),%eax
  80291c:	a3 48 41 80 00       	mov    %eax,0x804148
  802921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802924:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802934:	a1 54 41 80 00       	mov    0x804154,%eax
  802939:	48                   	dec    %eax
  80293a:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  80293f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802943:	75 17                	jne    80295c <alloc_block_FF+0x174>
  802945:	83 ec 04             	sub    $0x4,%esp
  802948:	68 10 3f 80 00       	push   $0x803f10
  80294d:	68 9a 00 00 00       	push   $0x9a
  802952:	68 f7 3e 80 00       	push   $0x803ef7
  802957:	e8 85 dd ff ff       	call   8006e1 <_panic>
  80295c:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802965:	89 50 04             	mov    %edx,0x4(%eax)
  802968:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296b:	8b 40 04             	mov    0x4(%eax),%eax
  80296e:	85 c0                	test   %eax,%eax
  802970:	74 0c                	je     80297e <alloc_block_FF+0x196>
  802972:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802977:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80297a:	89 10                	mov    %edx,(%eax)
  80297c:	eb 08                	jmp    802986 <alloc_block_FF+0x19e>
  80297e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802981:	a3 38 41 80 00       	mov    %eax,0x804138
  802986:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802989:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80298e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802991:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802997:	a1 44 41 80 00       	mov    0x804144,%eax
  80299c:	40                   	inc    %eax
  80299d:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  8029a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a8:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	8b 50 08             	mov    0x8(%eax),%edx
  8029b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b4:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  8029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029bd:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 50 08             	mov    0x8(%eax),%edx
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	01 c2                	add    %eax,%edx
  8029cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ce:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8029d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8029d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029db:	75 17                	jne    8029f4 <alloc_block_FF+0x20c>
  8029dd:	83 ec 04             	sub    $0x4,%esp
  8029e0:	68 68 3f 80 00       	push   $0x803f68
  8029e5:	68 a2 00 00 00       	push   $0xa2
  8029ea:	68 f7 3e 80 00       	push   $0x803ef7
  8029ef:	e8 ed dc ff ff       	call   8006e1 <_panic>
  8029f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f7:	8b 00                	mov    (%eax),%eax
  8029f9:	85 c0                	test   %eax,%eax
  8029fb:	74 10                	je     802a0d <alloc_block_FF+0x225>
  8029fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a05:	8b 52 04             	mov    0x4(%edx),%edx
  802a08:	89 50 04             	mov    %edx,0x4(%eax)
  802a0b:	eb 0b                	jmp    802a18 <alloc_block_FF+0x230>
  802a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a10:	8b 40 04             	mov    0x4(%eax),%eax
  802a13:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1b:	8b 40 04             	mov    0x4(%eax),%eax
  802a1e:	85 c0                	test   %eax,%eax
  802a20:	74 0f                	je     802a31 <alloc_block_FF+0x249>
  802a22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a25:	8b 40 04             	mov    0x4(%eax),%eax
  802a28:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a2b:	8b 12                	mov    (%edx),%edx
  802a2d:	89 10                	mov    %edx,(%eax)
  802a2f:	eb 0a                	jmp    802a3b <alloc_block_FF+0x253>
  802a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a34:	8b 00                	mov    (%eax),%eax
  802a36:	a3 38 41 80 00       	mov    %eax,0x804138
  802a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4e:	a1 44 41 80 00       	mov    0x804144,%eax
  802a53:	48                   	dec    %eax
  802a54:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  802a59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5c:	eb 3b                	jmp    802a99 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802a5e:	a1 40 41 80 00       	mov    0x804140,%eax
  802a63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6a:	74 07                	je     802a73 <alloc_block_FF+0x28b>
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 00                	mov    (%eax),%eax
  802a71:	eb 05                	jmp    802a78 <alloc_block_FF+0x290>
  802a73:	b8 00 00 00 00       	mov    $0x0,%eax
  802a78:	a3 40 41 80 00       	mov    %eax,0x804140
  802a7d:	a1 40 41 80 00       	mov    0x804140,%eax
  802a82:	85 c0                	test   %eax,%eax
  802a84:	0f 85 71 fd ff ff    	jne    8027fb <alloc_block_FF+0x13>
  802a8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8e:	0f 85 67 fd ff ff    	jne    8027fb <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802a94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a99:	c9                   	leave  
  802a9a:	c3                   	ret    

00802a9b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802a9b:	55                   	push   %ebp
  802a9c:	89 e5                	mov    %esp,%ebp
  802a9e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802aa1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802aa8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802aaf:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ab7:	e9 d3 00 00 00       	jmp    802b8f <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802abc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac5:	0f 85 90 00 00 00    	jne    802b5b <alloc_block_BF+0xc0>
	   temp = element;
  802acb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ace:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802ad1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ad5:	75 17                	jne    802aee <alloc_block_BF+0x53>
  802ad7:	83 ec 04             	sub    $0x4,%esp
  802ada:	68 68 3f 80 00       	push   $0x803f68
  802adf:	68 bd 00 00 00       	push   $0xbd
  802ae4:	68 f7 3e 80 00       	push   $0x803ef7
  802ae9:	e8 f3 db ff ff       	call   8006e1 <_panic>
  802aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af1:	8b 00                	mov    (%eax),%eax
  802af3:	85 c0                	test   %eax,%eax
  802af5:	74 10                	je     802b07 <alloc_block_BF+0x6c>
  802af7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afa:	8b 00                	mov    (%eax),%eax
  802afc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aff:	8b 52 04             	mov    0x4(%edx),%edx
  802b02:	89 50 04             	mov    %edx,0x4(%eax)
  802b05:	eb 0b                	jmp    802b12 <alloc_block_BF+0x77>
  802b07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0a:	8b 40 04             	mov    0x4(%eax),%eax
  802b0d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b15:	8b 40 04             	mov    0x4(%eax),%eax
  802b18:	85 c0                	test   %eax,%eax
  802b1a:	74 0f                	je     802b2b <alloc_block_BF+0x90>
  802b1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1f:	8b 40 04             	mov    0x4(%eax),%eax
  802b22:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b25:	8b 12                	mov    (%edx),%edx
  802b27:	89 10                	mov    %edx,(%eax)
  802b29:	eb 0a                	jmp    802b35 <alloc_block_BF+0x9a>
  802b2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2e:	8b 00                	mov    (%eax),%eax
  802b30:	a3 38 41 80 00       	mov    %eax,0x804138
  802b35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b48:	a1 44 41 80 00       	mov    0x804144,%eax
  802b4d:	48                   	dec    %eax
  802b4e:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802b53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b56:	e9 41 01 00 00       	jmp    802c9c <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802b5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b61:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b64:	76 21                	jbe    802b87 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802b66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b69:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b6f:	73 16                	jae    802b87 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802b71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b74:	8b 40 0c             	mov    0xc(%eax),%eax
  802b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802b7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802b80:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802b87:	a1 40 41 80 00       	mov    0x804140,%eax
  802b8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802b8f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b93:	74 07                	je     802b9c <alloc_block_BF+0x101>
  802b95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b98:	8b 00                	mov    (%eax),%eax
  802b9a:	eb 05                	jmp    802ba1 <alloc_block_BF+0x106>
  802b9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba1:	a3 40 41 80 00       	mov    %eax,0x804140
  802ba6:	a1 40 41 80 00       	mov    0x804140,%eax
  802bab:	85 c0                	test   %eax,%eax
  802bad:	0f 85 09 ff ff ff    	jne    802abc <alloc_block_BF+0x21>
  802bb3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bb7:	0f 85 ff fe ff ff    	jne    802abc <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802bbd:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802bc1:	0f 85 d0 00 00 00    	jne    802c97 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802bc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bca:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcd:	2b 45 08             	sub    0x8(%ebp),%eax
  802bd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802bd3:	a1 48 41 80 00       	mov    0x804148,%eax
  802bd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802bdb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bdf:	75 17                	jne    802bf8 <alloc_block_BF+0x15d>
  802be1:	83 ec 04             	sub    $0x4,%esp
  802be4:	68 68 3f 80 00       	push   $0x803f68
  802be9:	68 d1 00 00 00       	push   $0xd1
  802bee:	68 f7 3e 80 00       	push   $0x803ef7
  802bf3:	e8 e9 da ff ff       	call   8006e1 <_panic>
  802bf8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bfb:	8b 00                	mov    (%eax),%eax
  802bfd:	85 c0                	test   %eax,%eax
  802bff:	74 10                	je     802c11 <alloc_block_BF+0x176>
  802c01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c04:	8b 00                	mov    (%eax),%eax
  802c06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c09:	8b 52 04             	mov    0x4(%edx),%edx
  802c0c:	89 50 04             	mov    %edx,0x4(%eax)
  802c0f:	eb 0b                	jmp    802c1c <alloc_block_BF+0x181>
  802c11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c14:	8b 40 04             	mov    0x4(%eax),%eax
  802c17:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c1f:	8b 40 04             	mov    0x4(%eax),%eax
  802c22:	85 c0                	test   %eax,%eax
  802c24:	74 0f                	je     802c35 <alloc_block_BF+0x19a>
  802c26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c29:	8b 40 04             	mov    0x4(%eax),%eax
  802c2c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c2f:	8b 12                	mov    (%edx),%edx
  802c31:	89 10                	mov    %edx,(%eax)
  802c33:	eb 0a                	jmp    802c3f <alloc_block_BF+0x1a4>
  802c35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c38:	8b 00                	mov    (%eax),%eax
  802c3a:	a3 48 41 80 00       	mov    %eax,0x804148
  802c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c52:	a1 54 41 80 00       	mov    0x804154,%eax
  802c57:	48                   	dec    %eax
  802c58:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802c5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c60:	8b 55 08             	mov    0x8(%ebp),%edx
  802c63:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802c66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c69:	8b 50 08             	mov    0x8(%eax),%edx
  802c6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c6f:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802c72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c78:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802c7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7e:	8b 50 08             	mov    0x8(%eax),%edx
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	01 c2                	add    %eax,%edx
  802c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c89:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802c8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c8f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802c92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c95:	eb 05                	jmp    802c9c <alloc_block_BF+0x201>
	 }
	 return NULL;
  802c97:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802c9c:	c9                   	leave  
  802c9d:	c3                   	ret    

00802c9e <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c9e:	55                   	push   %ebp
  802c9f:	89 e5                	mov    %esp,%ebp
  802ca1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802ca4:	83 ec 04             	sub    $0x4,%esp
  802ca7:	68 88 3f 80 00       	push   $0x803f88
  802cac:	68 e8 00 00 00       	push   $0xe8
  802cb1:	68 f7 3e 80 00       	push   $0x803ef7
  802cb6:	e8 26 da ff ff       	call   8006e1 <_panic>

00802cbb <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cbb:	55                   	push   %ebp
  802cbc:	89 e5                	mov    %esp,%ebp
  802cbe:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802cc1:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802cc9:	a1 38 41 80 00       	mov    0x804138,%eax
  802cce:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802cd1:	a1 44 41 80 00       	mov    0x804144,%eax
  802cd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802cd9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cdd:	75 68                	jne    802d47 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802cdf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce3:	75 17                	jne    802cfc <insert_sorted_with_merge_freeList+0x41>
  802ce5:	83 ec 04             	sub    $0x4,%esp
  802ce8:	68 d4 3e 80 00       	push   $0x803ed4
  802ced:	68 36 01 00 00       	push   $0x136
  802cf2:	68 f7 3e 80 00       	push   $0x803ef7
  802cf7:	e8 e5 d9 ff ff       	call   8006e1 <_panic>
  802cfc:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	89 10                	mov    %edx,(%eax)
  802d07:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0a:	8b 00                	mov    (%eax),%eax
  802d0c:	85 c0                	test   %eax,%eax
  802d0e:	74 0d                	je     802d1d <insert_sorted_with_merge_freeList+0x62>
  802d10:	a1 38 41 80 00       	mov    0x804138,%eax
  802d15:	8b 55 08             	mov    0x8(%ebp),%edx
  802d18:	89 50 04             	mov    %edx,0x4(%eax)
  802d1b:	eb 08                	jmp    802d25 <insert_sorted_with_merge_freeList+0x6a>
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d25:	8b 45 08             	mov    0x8(%ebp),%eax
  802d28:	a3 38 41 80 00       	mov    %eax,0x804138
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d37:	a1 44 41 80 00       	mov    0x804144,%eax
  802d3c:	40                   	inc    %eax
  802d3d:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802d42:	e9 ba 06 00 00       	jmp    803401 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4a:	8b 50 08             	mov    0x8(%eax),%edx
  802d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d50:	8b 40 0c             	mov    0xc(%eax),%eax
  802d53:	01 c2                	add    %eax,%edx
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	8b 40 08             	mov    0x8(%eax),%eax
  802d5b:	39 c2                	cmp    %eax,%edx
  802d5d:	73 68                	jae    802dc7 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802d5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d63:	75 17                	jne    802d7c <insert_sorted_with_merge_freeList+0xc1>
  802d65:	83 ec 04             	sub    $0x4,%esp
  802d68:	68 10 3f 80 00       	push   $0x803f10
  802d6d:	68 3a 01 00 00       	push   $0x13a
  802d72:	68 f7 3e 80 00       	push   $0x803ef7
  802d77:	e8 65 d9 ff ff       	call   8006e1 <_panic>
  802d7c:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	89 50 04             	mov    %edx,0x4(%eax)
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	8b 40 04             	mov    0x4(%eax),%eax
  802d8e:	85 c0                	test   %eax,%eax
  802d90:	74 0c                	je     802d9e <insert_sorted_with_merge_freeList+0xe3>
  802d92:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d97:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9a:	89 10                	mov    %edx,(%eax)
  802d9c:	eb 08                	jmp    802da6 <insert_sorted_with_merge_freeList+0xeb>
  802d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802da1:	a3 38 41 80 00       	mov    %eax,0x804138
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db7:	a1 44 41 80 00       	mov    0x804144,%eax
  802dbc:	40                   	inc    %eax
  802dbd:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802dc2:	e9 3a 06 00 00       	jmp    803401 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dca:	8b 50 08             	mov    0x8(%eax),%edx
  802dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd3:	01 c2                	add    %eax,%edx
  802dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd8:	8b 40 08             	mov    0x8(%eax),%eax
  802ddb:	39 c2                	cmp    %eax,%edx
  802ddd:	0f 85 90 00 00 00    	jne    802e73 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de6:	8b 50 0c             	mov    0xc(%eax),%edx
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	8b 40 0c             	mov    0xc(%eax),%eax
  802def:	01 c2                	add    %eax,%edx
  802df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df4:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802df7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e0f:	75 17                	jne    802e28 <insert_sorted_with_merge_freeList+0x16d>
  802e11:	83 ec 04             	sub    $0x4,%esp
  802e14:	68 d4 3e 80 00       	push   $0x803ed4
  802e19:	68 41 01 00 00       	push   $0x141
  802e1e:	68 f7 3e 80 00       	push   $0x803ef7
  802e23:	e8 b9 d8 ff ff       	call   8006e1 <_panic>
  802e28:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	89 10                	mov    %edx,(%eax)
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	85 c0                	test   %eax,%eax
  802e3a:	74 0d                	je     802e49 <insert_sorted_with_merge_freeList+0x18e>
  802e3c:	a1 48 41 80 00       	mov    0x804148,%eax
  802e41:	8b 55 08             	mov    0x8(%ebp),%edx
  802e44:	89 50 04             	mov    %edx,0x4(%eax)
  802e47:	eb 08                	jmp    802e51 <insert_sorted_with_merge_freeList+0x196>
  802e49:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e51:	8b 45 08             	mov    0x8(%ebp),%eax
  802e54:	a3 48 41 80 00       	mov    %eax,0x804148
  802e59:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e63:	a1 54 41 80 00       	mov    0x804154,%eax
  802e68:	40                   	inc    %eax
  802e69:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802e6e:	e9 8e 05 00 00       	jmp    803401 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	8b 50 08             	mov    0x8(%eax),%edx
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7f:	01 c2                	add    %eax,%edx
  802e81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e84:	8b 40 08             	mov    0x8(%eax),%eax
  802e87:	39 c2                	cmp    %eax,%edx
  802e89:	73 68                	jae    802ef3 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802e8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e8f:	75 17                	jne    802ea8 <insert_sorted_with_merge_freeList+0x1ed>
  802e91:	83 ec 04             	sub    $0x4,%esp
  802e94:	68 d4 3e 80 00       	push   $0x803ed4
  802e99:	68 45 01 00 00       	push   $0x145
  802e9e:	68 f7 3e 80 00       	push   $0x803ef7
  802ea3:	e8 39 d8 ff ff       	call   8006e1 <_panic>
  802ea8:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	89 10                	mov    %edx,(%eax)
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	8b 00                	mov    (%eax),%eax
  802eb8:	85 c0                	test   %eax,%eax
  802eba:	74 0d                	je     802ec9 <insert_sorted_with_merge_freeList+0x20e>
  802ebc:	a1 38 41 80 00       	mov    0x804138,%eax
  802ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec4:	89 50 04             	mov    %edx,0x4(%eax)
  802ec7:	eb 08                	jmp    802ed1 <insert_sorted_with_merge_freeList+0x216>
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	a3 38 41 80 00       	mov    %eax,0x804138
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee3:	a1 44 41 80 00       	mov    0x804144,%eax
  802ee8:	40                   	inc    %eax
  802ee9:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802eee:	e9 0e 05 00 00       	jmp    803401 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef6:	8b 50 08             	mov    0x8(%eax),%edx
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	8b 40 0c             	mov    0xc(%eax),%eax
  802eff:	01 c2                	add    %eax,%edx
  802f01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f04:	8b 40 08             	mov    0x8(%eax),%eax
  802f07:	39 c2                	cmp    %eax,%edx
  802f09:	0f 85 9c 00 00 00    	jne    802fab <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802f0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f12:	8b 50 0c             	mov    0xc(%eax),%edx
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1b:	01 c2                	add    %eax,%edx
  802f1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f20:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	8b 50 08             	mov    0x8(%eax),%edx
  802f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2c:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802f39:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f47:	75 17                	jne    802f60 <insert_sorted_with_merge_freeList+0x2a5>
  802f49:	83 ec 04             	sub    $0x4,%esp
  802f4c:	68 d4 3e 80 00       	push   $0x803ed4
  802f51:	68 4d 01 00 00       	push   $0x14d
  802f56:	68 f7 3e 80 00       	push   $0x803ef7
  802f5b:	e8 81 d7 ff ff       	call   8006e1 <_panic>
  802f60:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	89 10                	mov    %edx,(%eax)
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	8b 00                	mov    (%eax),%eax
  802f70:	85 c0                	test   %eax,%eax
  802f72:	74 0d                	je     802f81 <insert_sorted_with_merge_freeList+0x2c6>
  802f74:	a1 48 41 80 00       	mov    0x804148,%eax
  802f79:	8b 55 08             	mov    0x8(%ebp),%edx
  802f7c:	89 50 04             	mov    %edx,0x4(%eax)
  802f7f:	eb 08                	jmp    802f89 <insert_sorted_with_merge_freeList+0x2ce>
  802f81:	8b 45 08             	mov    0x8(%ebp),%eax
  802f84:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	a3 48 41 80 00       	mov    %eax,0x804148
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9b:	a1 54 41 80 00       	mov    0x804154,%eax
  802fa0:	40                   	inc    %eax
  802fa1:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802fa6:	e9 56 04 00 00       	jmp    803401 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802fab:	a1 38 41 80 00       	mov    0x804138,%eax
  802fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb3:	e9 19 04 00 00       	jmp    8033d1 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbb:	8b 00                	mov    (%eax),%eax
  802fbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc3:	8b 50 08             	mov    0x8(%eax),%edx
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcc:	01 c2                	add    %eax,%edx
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	8b 40 08             	mov    0x8(%eax),%eax
  802fd4:	39 c2                	cmp    %eax,%edx
  802fd6:	0f 85 ad 01 00 00    	jne    803189 <insert_sorted_with_merge_freeList+0x4ce>
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	8b 50 08             	mov    0x8(%eax),%edx
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe8:	01 c2                	add    %eax,%edx
  802fea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fed:	8b 40 08             	mov    0x8(%eax),%eax
  802ff0:	39 c2                	cmp    %eax,%edx
  802ff2:	0f 85 91 01 00 00    	jne    803189 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffb:	8b 50 0c             	mov    0xc(%eax),%edx
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	8b 48 0c             	mov    0xc(%eax),%ecx
  803004:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803007:	8b 40 0c             	mov    0xc(%eax),%eax
  80300a:	01 c8                	add    %ecx,%eax
  80300c:	01 c2                	add    %eax,%edx
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  803028:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  803032:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803035:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  80303c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803040:	75 17                	jne    803059 <insert_sorted_with_merge_freeList+0x39e>
  803042:	83 ec 04             	sub    $0x4,%esp
  803045:	68 68 3f 80 00       	push   $0x803f68
  80304a:	68 5b 01 00 00       	push   $0x15b
  80304f:	68 f7 3e 80 00       	push   $0x803ef7
  803054:	e8 88 d6 ff ff       	call   8006e1 <_panic>
  803059:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	85 c0                	test   %eax,%eax
  803060:	74 10                	je     803072 <insert_sorted_with_merge_freeList+0x3b7>
  803062:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803065:	8b 00                	mov    (%eax),%eax
  803067:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80306a:	8b 52 04             	mov    0x4(%edx),%edx
  80306d:	89 50 04             	mov    %edx,0x4(%eax)
  803070:	eb 0b                	jmp    80307d <insert_sorted_with_merge_freeList+0x3c2>
  803072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803075:	8b 40 04             	mov    0x4(%eax),%eax
  803078:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80307d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803080:	8b 40 04             	mov    0x4(%eax),%eax
  803083:	85 c0                	test   %eax,%eax
  803085:	74 0f                	je     803096 <insert_sorted_with_merge_freeList+0x3db>
  803087:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80308a:	8b 40 04             	mov    0x4(%eax),%eax
  80308d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803090:	8b 12                	mov    (%edx),%edx
  803092:	89 10                	mov    %edx,(%eax)
  803094:	eb 0a                	jmp    8030a0 <insert_sorted_with_merge_freeList+0x3e5>
  803096:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803099:	8b 00                	mov    (%eax),%eax
  80309b:	a3 38 41 80 00       	mov    %eax,0x804138
  8030a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b3:	a1 44 41 80 00       	mov    0x804144,%eax
  8030b8:	48                   	dec    %eax
  8030b9:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c2:	75 17                	jne    8030db <insert_sorted_with_merge_freeList+0x420>
  8030c4:	83 ec 04             	sub    $0x4,%esp
  8030c7:	68 d4 3e 80 00       	push   $0x803ed4
  8030cc:	68 5c 01 00 00       	push   $0x15c
  8030d1:	68 f7 3e 80 00       	push   $0x803ef7
  8030d6:	e8 06 d6 ff ff       	call   8006e1 <_panic>
  8030db:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e4:	89 10                	mov    %edx,(%eax)
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	85 c0                	test   %eax,%eax
  8030ed:	74 0d                	je     8030fc <insert_sorted_with_merge_freeList+0x441>
  8030ef:	a1 48 41 80 00       	mov    0x804148,%eax
  8030f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f7:	89 50 04             	mov    %edx,0x4(%eax)
  8030fa:	eb 08                	jmp    803104 <insert_sorted_with_merge_freeList+0x449>
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	a3 48 41 80 00       	mov    %eax,0x804148
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803116:	a1 54 41 80 00       	mov    0x804154,%eax
  80311b:	40                   	inc    %eax
  80311c:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  803121:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803125:	75 17                	jne    80313e <insert_sorted_with_merge_freeList+0x483>
  803127:	83 ec 04             	sub    $0x4,%esp
  80312a:	68 d4 3e 80 00       	push   $0x803ed4
  80312f:	68 5d 01 00 00       	push   $0x15d
  803134:	68 f7 3e 80 00       	push   $0x803ef7
  803139:	e8 a3 d5 ff ff       	call   8006e1 <_panic>
  80313e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803147:	89 10                	mov    %edx,(%eax)
  803149:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314c:	8b 00                	mov    (%eax),%eax
  80314e:	85 c0                	test   %eax,%eax
  803150:	74 0d                	je     80315f <insert_sorted_with_merge_freeList+0x4a4>
  803152:	a1 48 41 80 00       	mov    0x804148,%eax
  803157:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80315a:	89 50 04             	mov    %edx,0x4(%eax)
  80315d:	eb 08                	jmp    803167 <insert_sorted_with_merge_freeList+0x4ac>
  80315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803162:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803167:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80316a:	a3 48 41 80 00       	mov    %eax,0x804148
  80316f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803172:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803179:	a1 54 41 80 00       	mov    0x804154,%eax
  80317e:	40                   	inc    %eax
  80317f:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  803184:	e9 78 02 00 00       	jmp    803401 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318c:	8b 50 08             	mov    0x8(%eax),%edx
  80318f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803192:	8b 40 0c             	mov    0xc(%eax),%eax
  803195:	01 c2                	add    %eax,%edx
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	8b 40 08             	mov    0x8(%eax),%eax
  80319d:	39 c2                	cmp    %eax,%edx
  80319f:	0f 83 b8 00 00 00    	jae    80325d <insert_sorted_with_merge_freeList+0x5a2>
  8031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a8:	8b 50 08             	mov    0x8(%eax),%edx
  8031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b1:	01 c2                	add    %eax,%edx
  8031b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b6:	8b 40 08             	mov    0x8(%eax),%eax
  8031b9:	39 c2                	cmp    %eax,%edx
  8031bb:	0f 85 9c 00 00 00    	jne    80325d <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  8031c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8031cd:	01 c2                	add    %eax,%edx
  8031cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d2:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  8031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d8:	8b 50 08             	mov    0x8(%eax),%edx
  8031db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031de:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  8031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f9:	75 17                	jne    803212 <insert_sorted_with_merge_freeList+0x557>
  8031fb:	83 ec 04             	sub    $0x4,%esp
  8031fe:	68 d4 3e 80 00       	push   $0x803ed4
  803203:	68 67 01 00 00       	push   $0x167
  803208:	68 f7 3e 80 00       	push   $0x803ef7
  80320d:	e8 cf d4 ff ff       	call   8006e1 <_panic>
  803212:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803218:	8b 45 08             	mov    0x8(%ebp),%eax
  80321b:	89 10                	mov    %edx,(%eax)
  80321d:	8b 45 08             	mov    0x8(%ebp),%eax
  803220:	8b 00                	mov    (%eax),%eax
  803222:	85 c0                	test   %eax,%eax
  803224:	74 0d                	je     803233 <insert_sorted_with_merge_freeList+0x578>
  803226:	a1 48 41 80 00       	mov    0x804148,%eax
  80322b:	8b 55 08             	mov    0x8(%ebp),%edx
  80322e:	89 50 04             	mov    %edx,0x4(%eax)
  803231:	eb 08                	jmp    80323b <insert_sorted_with_merge_freeList+0x580>
  803233:	8b 45 08             	mov    0x8(%ebp),%eax
  803236:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	a3 48 41 80 00       	mov    %eax,0x804148
  803243:	8b 45 08             	mov    0x8(%ebp),%eax
  803246:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324d:	a1 54 41 80 00       	mov    0x804154,%eax
  803252:	40                   	inc    %eax
  803253:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  803258:	e9 a4 01 00 00       	jmp    803401 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80325d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803260:	8b 50 08             	mov    0x8(%eax),%edx
  803263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803266:	8b 40 0c             	mov    0xc(%eax),%eax
  803269:	01 c2                	add    %eax,%edx
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	8b 40 08             	mov    0x8(%eax),%eax
  803271:	39 c2                	cmp    %eax,%edx
  803273:	0f 85 ac 00 00 00    	jne    803325 <insert_sorted_with_merge_freeList+0x66a>
  803279:	8b 45 08             	mov    0x8(%ebp),%eax
  80327c:	8b 50 08             	mov    0x8(%eax),%edx
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	8b 40 0c             	mov    0xc(%eax),%eax
  803285:	01 c2                	add    %eax,%edx
  803287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80328a:	8b 40 08             	mov    0x8(%eax),%eax
  80328d:	39 c2                	cmp    %eax,%edx
  80328f:	0f 83 90 00 00 00    	jae    803325 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  803295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803298:	8b 50 0c             	mov    0xc(%eax),%edx
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a1:	01 c2                	add    %eax,%edx
  8032a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a6:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  8032b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c1:	75 17                	jne    8032da <insert_sorted_with_merge_freeList+0x61f>
  8032c3:	83 ec 04             	sub    $0x4,%esp
  8032c6:	68 d4 3e 80 00       	push   $0x803ed4
  8032cb:	68 70 01 00 00       	push   $0x170
  8032d0:	68 f7 3e 80 00       	push   $0x803ef7
  8032d5:	e8 07 d4 ff ff       	call   8006e1 <_panic>
  8032da:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e3:	89 10                	mov    %edx,(%eax)
  8032e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e8:	8b 00                	mov    (%eax),%eax
  8032ea:	85 c0                	test   %eax,%eax
  8032ec:	74 0d                	je     8032fb <insert_sorted_with_merge_freeList+0x640>
  8032ee:	a1 48 41 80 00       	mov    0x804148,%eax
  8032f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f6:	89 50 04             	mov    %edx,0x4(%eax)
  8032f9:	eb 08                	jmp    803303 <insert_sorted_with_merge_freeList+0x648>
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	a3 48 41 80 00       	mov    %eax,0x804148
  80330b:	8b 45 08             	mov    0x8(%ebp),%eax
  80330e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803315:	a1 54 41 80 00       	mov    0x804154,%eax
  80331a:	40                   	inc    %eax
  80331b:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  803320:	e9 dc 00 00 00       	jmp    803401 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803328:	8b 50 08             	mov    0x8(%eax),%edx
  80332b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332e:	8b 40 0c             	mov    0xc(%eax),%eax
  803331:	01 c2                	add    %eax,%edx
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	8b 40 08             	mov    0x8(%eax),%eax
  803339:	39 c2                	cmp    %eax,%edx
  80333b:	0f 83 88 00 00 00    	jae    8033c9 <insert_sorted_with_merge_freeList+0x70e>
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	8b 50 08             	mov    0x8(%eax),%edx
  803347:	8b 45 08             	mov    0x8(%ebp),%eax
  80334a:	8b 40 0c             	mov    0xc(%eax),%eax
  80334d:	01 c2                	add    %eax,%edx
  80334f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803352:	8b 40 08             	mov    0x8(%eax),%eax
  803355:	39 c2                	cmp    %eax,%edx
  803357:	73 70                	jae    8033c9 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803359:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80335d:	74 06                	je     803365 <insert_sorted_with_merge_freeList+0x6aa>
  80335f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803363:	75 17                	jne    80337c <insert_sorted_with_merge_freeList+0x6c1>
  803365:	83 ec 04             	sub    $0x4,%esp
  803368:	68 34 3f 80 00       	push   $0x803f34
  80336d:	68 75 01 00 00       	push   $0x175
  803372:	68 f7 3e 80 00       	push   $0x803ef7
  803377:	e8 65 d3 ff ff       	call   8006e1 <_panic>
  80337c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337f:	8b 10                	mov    (%eax),%edx
  803381:	8b 45 08             	mov    0x8(%ebp),%eax
  803384:	89 10                	mov    %edx,(%eax)
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	8b 00                	mov    (%eax),%eax
  80338b:	85 c0                	test   %eax,%eax
  80338d:	74 0b                	je     80339a <insert_sorted_with_merge_freeList+0x6df>
  80338f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803392:	8b 00                	mov    (%eax),%eax
  803394:	8b 55 08             	mov    0x8(%ebp),%edx
  803397:	89 50 04             	mov    %edx,0x4(%eax)
  80339a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339d:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a0:	89 10                	mov    %edx,(%eax)
  8033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033a8:	89 50 04             	mov    %edx,0x4(%eax)
  8033ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ae:	8b 00                	mov    (%eax),%eax
  8033b0:	85 c0                	test   %eax,%eax
  8033b2:	75 08                	jne    8033bc <insert_sorted_with_merge_freeList+0x701>
  8033b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8033bc:	a1 44 41 80 00       	mov    0x804144,%eax
  8033c1:	40                   	inc    %eax
  8033c2:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  8033c7:	eb 38                	jmp    803401 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8033c9:	a1 40 41 80 00       	mov    0x804140,%eax
  8033ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d5:	74 07                	je     8033de <insert_sorted_with_merge_freeList+0x723>
  8033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033da:	8b 00                	mov    (%eax),%eax
  8033dc:	eb 05                	jmp    8033e3 <insert_sorted_with_merge_freeList+0x728>
  8033de:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e3:	a3 40 41 80 00       	mov    %eax,0x804140
  8033e8:	a1 40 41 80 00       	mov    0x804140,%eax
  8033ed:	85 c0                	test   %eax,%eax
  8033ef:	0f 85 c3 fb ff ff    	jne    802fb8 <insert_sorted_with_merge_freeList+0x2fd>
  8033f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f9:	0f 85 b9 fb ff ff    	jne    802fb8 <insert_sorted_with_merge_freeList+0x2fd>





}
  8033ff:	eb 00                	jmp    803401 <insert_sorted_with_merge_freeList+0x746>
  803401:	90                   	nop
  803402:	c9                   	leave  
  803403:	c3                   	ret    

00803404 <__udivdi3>:
  803404:	55                   	push   %ebp
  803405:	57                   	push   %edi
  803406:	56                   	push   %esi
  803407:	53                   	push   %ebx
  803408:	83 ec 1c             	sub    $0x1c,%esp
  80340b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80340f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803413:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803417:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80341b:	89 ca                	mov    %ecx,%edx
  80341d:	89 f8                	mov    %edi,%eax
  80341f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803423:	85 f6                	test   %esi,%esi
  803425:	75 2d                	jne    803454 <__udivdi3+0x50>
  803427:	39 cf                	cmp    %ecx,%edi
  803429:	77 65                	ja     803490 <__udivdi3+0x8c>
  80342b:	89 fd                	mov    %edi,%ebp
  80342d:	85 ff                	test   %edi,%edi
  80342f:	75 0b                	jne    80343c <__udivdi3+0x38>
  803431:	b8 01 00 00 00       	mov    $0x1,%eax
  803436:	31 d2                	xor    %edx,%edx
  803438:	f7 f7                	div    %edi
  80343a:	89 c5                	mov    %eax,%ebp
  80343c:	31 d2                	xor    %edx,%edx
  80343e:	89 c8                	mov    %ecx,%eax
  803440:	f7 f5                	div    %ebp
  803442:	89 c1                	mov    %eax,%ecx
  803444:	89 d8                	mov    %ebx,%eax
  803446:	f7 f5                	div    %ebp
  803448:	89 cf                	mov    %ecx,%edi
  80344a:	89 fa                	mov    %edi,%edx
  80344c:	83 c4 1c             	add    $0x1c,%esp
  80344f:	5b                   	pop    %ebx
  803450:	5e                   	pop    %esi
  803451:	5f                   	pop    %edi
  803452:	5d                   	pop    %ebp
  803453:	c3                   	ret    
  803454:	39 ce                	cmp    %ecx,%esi
  803456:	77 28                	ja     803480 <__udivdi3+0x7c>
  803458:	0f bd fe             	bsr    %esi,%edi
  80345b:	83 f7 1f             	xor    $0x1f,%edi
  80345e:	75 40                	jne    8034a0 <__udivdi3+0x9c>
  803460:	39 ce                	cmp    %ecx,%esi
  803462:	72 0a                	jb     80346e <__udivdi3+0x6a>
  803464:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803468:	0f 87 9e 00 00 00    	ja     80350c <__udivdi3+0x108>
  80346e:	b8 01 00 00 00       	mov    $0x1,%eax
  803473:	89 fa                	mov    %edi,%edx
  803475:	83 c4 1c             	add    $0x1c,%esp
  803478:	5b                   	pop    %ebx
  803479:	5e                   	pop    %esi
  80347a:	5f                   	pop    %edi
  80347b:	5d                   	pop    %ebp
  80347c:	c3                   	ret    
  80347d:	8d 76 00             	lea    0x0(%esi),%esi
  803480:	31 ff                	xor    %edi,%edi
  803482:	31 c0                	xor    %eax,%eax
  803484:	89 fa                	mov    %edi,%edx
  803486:	83 c4 1c             	add    $0x1c,%esp
  803489:	5b                   	pop    %ebx
  80348a:	5e                   	pop    %esi
  80348b:	5f                   	pop    %edi
  80348c:	5d                   	pop    %ebp
  80348d:	c3                   	ret    
  80348e:	66 90                	xchg   %ax,%ax
  803490:	89 d8                	mov    %ebx,%eax
  803492:	f7 f7                	div    %edi
  803494:	31 ff                	xor    %edi,%edi
  803496:	89 fa                	mov    %edi,%edx
  803498:	83 c4 1c             	add    $0x1c,%esp
  80349b:	5b                   	pop    %ebx
  80349c:	5e                   	pop    %esi
  80349d:	5f                   	pop    %edi
  80349e:	5d                   	pop    %ebp
  80349f:	c3                   	ret    
  8034a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034a5:	89 eb                	mov    %ebp,%ebx
  8034a7:	29 fb                	sub    %edi,%ebx
  8034a9:	89 f9                	mov    %edi,%ecx
  8034ab:	d3 e6                	shl    %cl,%esi
  8034ad:	89 c5                	mov    %eax,%ebp
  8034af:	88 d9                	mov    %bl,%cl
  8034b1:	d3 ed                	shr    %cl,%ebp
  8034b3:	89 e9                	mov    %ebp,%ecx
  8034b5:	09 f1                	or     %esi,%ecx
  8034b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034bb:	89 f9                	mov    %edi,%ecx
  8034bd:	d3 e0                	shl    %cl,%eax
  8034bf:	89 c5                	mov    %eax,%ebp
  8034c1:	89 d6                	mov    %edx,%esi
  8034c3:	88 d9                	mov    %bl,%cl
  8034c5:	d3 ee                	shr    %cl,%esi
  8034c7:	89 f9                	mov    %edi,%ecx
  8034c9:	d3 e2                	shl    %cl,%edx
  8034cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034cf:	88 d9                	mov    %bl,%cl
  8034d1:	d3 e8                	shr    %cl,%eax
  8034d3:	09 c2                	or     %eax,%edx
  8034d5:	89 d0                	mov    %edx,%eax
  8034d7:	89 f2                	mov    %esi,%edx
  8034d9:	f7 74 24 0c          	divl   0xc(%esp)
  8034dd:	89 d6                	mov    %edx,%esi
  8034df:	89 c3                	mov    %eax,%ebx
  8034e1:	f7 e5                	mul    %ebp
  8034e3:	39 d6                	cmp    %edx,%esi
  8034e5:	72 19                	jb     803500 <__udivdi3+0xfc>
  8034e7:	74 0b                	je     8034f4 <__udivdi3+0xf0>
  8034e9:	89 d8                	mov    %ebx,%eax
  8034eb:	31 ff                	xor    %edi,%edi
  8034ed:	e9 58 ff ff ff       	jmp    80344a <__udivdi3+0x46>
  8034f2:	66 90                	xchg   %ax,%ax
  8034f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034f8:	89 f9                	mov    %edi,%ecx
  8034fa:	d3 e2                	shl    %cl,%edx
  8034fc:	39 c2                	cmp    %eax,%edx
  8034fe:	73 e9                	jae    8034e9 <__udivdi3+0xe5>
  803500:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803503:	31 ff                	xor    %edi,%edi
  803505:	e9 40 ff ff ff       	jmp    80344a <__udivdi3+0x46>
  80350a:	66 90                	xchg   %ax,%ax
  80350c:	31 c0                	xor    %eax,%eax
  80350e:	e9 37 ff ff ff       	jmp    80344a <__udivdi3+0x46>
  803513:	90                   	nop

00803514 <__umoddi3>:
  803514:	55                   	push   %ebp
  803515:	57                   	push   %edi
  803516:	56                   	push   %esi
  803517:	53                   	push   %ebx
  803518:	83 ec 1c             	sub    $0x1c,%esp
  80351b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80351f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803523:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803527:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80352b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80352f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803533:	89 f3                	mov    %esi,%ebx
  803535:	89 fa                	mov    %edi,%edx
  803537:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80353b:	89 34 24             	mov    %esi,(%esp)
  80353e:	85 c0                	test   %eax,%eax
  803540:	75 1a                	jne    80355c <__umoddi3+0x48>
  803542:	39 f7                	cmp    %esi,%edi
  803544:	0f 86 a2 00 00 00    	jbe    8035ec <__umoddi3+0xd8>
  80354a:	89 c8                	mov    %ecx,%eax
  80354c:	89 f2                	mov    %esi,%edx
  80354e:	f7 f7                	div    %edi
  803550:	89 d0                	mov    %edx,%eax
  803552:	31 d2                	xor    %edx,%edx
  803554:	83 c4 1c             	add    $0x1c,%esp
  803557:	5b                   	pop    %ebx
  803558:	5e                   	pop    %esi
  803559:	5f                   	pop    %edi
  80355a:	5d                   	pop    %ebp
  80355b:	c3                   	ret    
  80355c:	39 f0                	cmp    %esi,%eax
  80355e:	0f 87 ac 00 00 00    	ja     803610 <__umoddi3+0xfc>
  803564:	0f bd e8             	bsr    %eax,%ebp
  803567:	83 f5 1f             	xor    $0x1f,%ebp
  80356a:	0f 84 ac 00 00 00    	je     80361c <__umoddi3+0x108>
  803570:	bf 20 00 00 00       	mov    $0x20,%edi
  803575:	29 ef                	sub    %ebp,%edi
  803577:	89 fe                	mov    %edi,%esi
  803579:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80357d:	89 e9                	mov    %ebp,%ecx
  80357f:	d3 e0                	shl    %cl,%eax
  803581:	89 d7                	mov    %edx,%edi
  803583:	89 f1                	mov    %esi,%ecx
  803585:	d3 ef                	shr    %cl,%edi
  803587:	09 c7                	or     %eax,%edi
  803589:	89 e9                	mov    %ebp,%ecx
  80358b:	d3 e2                	shl    %cl,%edx
  80358d:	89 14 24             	mov    %edx,(%esp)
  803590:	89 d8                	mov    %ebx,%eax
  803592:	d3 e0                	shl    %cl,%eax
  803594:	89 c2                	mov    %eax,%edx
  803596:	8b 44 24 08          	mov    0x8(%esp),%eax
  80359a:	d3 e0                	shl    %cl,%eax
  80359c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035a4:	89 f1                	mov    %esi,%ecx
  8035a6:	d3 e8                	shr    %cl,%eax
  8035a8:	09 d0                	or     %edx,%eax
  8035aa:	d3 eb                	shr    %cl,%ebx
  8035ac:	89 da                	mov    %ebx,%edx
  8035ae:	f7 f7                	div    %edi
  8035b0:	89 d3                	mov    %edx,%ebx
  8035b2:	f7 24 24             	mull   (%esp)
  8035b5:	89 c6                	mov    %eax,%esi
  8035b7:	89 d1                	mov    %edx,%ecx
  8035b9:	39 d3                	cmp    %edx,%ebx
  8035bb:	0f 82 87 00 00 00    	jb     803648 <__umoddi3+0x134>
  8035c1:	0f 84 91 00 00 00    	je     803658 <__umoddi3+0x144>
  8035c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035cb:	29 f2                	sub    %esi,%edx
  8035cd:	19 cb                	sbb    %ecx,%ebx
  8035cf:	89 d8                	mov    %ebx,%eax
  8035d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035d5:	d3 e0                	shl    %cl,%eax
  8035d7:	89 e9                	mov    %ebp,%ecx
  8035d9:	d3 ea                	shr    %cl,%edx
  8035db:	09 d0                	or     %edx,%eax
  8035dd:	89 e9                	mov    %ebp,%ecx
  8035df:	d3 eb                	shr    %cl,%ebx
  8035e1:	89 da                	mov    %ebx,%edx
  8035e3:	83 c4 1c             	add    $0x1c,%esp
  8035e6:	5b                   	pop    %ebx
  8035e7:	5e                   	pop    %esi
  8035e8:	5f                   	pop    %edi
  8035e9:	5d                   	pop    %ebp
  8035ea:	c3                   	ret    
  8035eb:	90                   	nop
  8035ec:	89 fd                	mov    %edi,%ebp
  8035ee:	85 ff                	test   %edi,%edi
  8035f0:	75 0b                	jne    8035fd <__umoddi3+0xe9>
  8035f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035f7:	31 d2                	xor    %edx,%edx
  8035f9:	f7 f7                	div    %edi
  8035fb:	89 c5                	mov    %eax,%ebp
  8035fd:	89 f0                	mov    %esi,%eax
  8035ff:	31 d2                	xor    %edx,%edx
  803601:	f7 f5                	div    %ebp
  803603:	89 c8                	mov    %ecx,%eax
  803605:	f7 f5                	div    %ebp
  803607:	89 d0                	mov    %edx,%eax
  803609:	e9 44 ff ff ff       	jmp    803552 <__umoddi3+0x3e>
  80360e:	66 90                	xchg   %ax,%ax
  803610:	89 c8                	mov    %ecx,%eax
  803612:	89 f2                	mov    %esi,%edx
  803614:	83 c4 1c             	add    $0x1c,%esp
  803617:	5b                   	pop    %ebx
  803618:	5e                   	pop    %esi
  803619:	5f                   	pop    %edi
  80361a:	5d                   	pop    %ebp
  80361b:	c3                   	ret    
  80361c:	3b 04 24             	cmp    (%esp),%eax
  80361f:	72 06                	jb     803627 <__umoddi3+0x113>
  803621:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803625:	77 0f                	ja     803636 <__umoddi3+0x122>
  803627:	89 f2                	mov    %esi,%edx
  803629:	29 f9                	sub    %edi,%ecx
  80362b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80362f:	89 14 24             	mov    %edx,(%esp)
  803632:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803636:	8b 44 24 04          	mov    0x4(%esp),%eax
  80363a:	8b 14 24             	mov    (%esp),%edx
  80363d:	83 c4 1c             	add    $0x1c,%esp
  803640:	5b                   	pop    %ebx
  803641:	5e                   	pop    %esi
  803642:	5f                   	pop    %edi
  803643:	5d                   	pop    %ebp
  803644:	c3                   	ret    
  803645:	8d 76 00             	lea    0x0(%esi),%esi
  803648:	2b 04 24             	sub    (%esp),%eax
  80364b:	19 fa                	sbb    %edi,%edx
  80364d:	89 d1                	mov    %edx,%ecx
  80364f:	89 c6                	mov    %eax,%esi
  803651:	e9 71 ff ff ff       	jmp    8035c7 <__umoddi3+0xb3>
  803656:	66 90                	xchg   %ax,%ax
  803658:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80365c:	72 ea                	jb     803648 <__umoddi3+0x134>
  80365e:	89 d9                	mov    %ebx,%ecx
  803660:	e9 62 ff ff ff       	jmp    8035c7 <__umoddi3+0xb3>
