
obj/user/tst_best_fit_1:     file format elf32-i386


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
  800031:	e8 d2 0a 00 00       	call   800b08 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 7b 27 00 00       	call   8027c5 <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 29                	jmp    800083 <_main+0x4b>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 50 80 00       	mov    0x805020,%eax
  80005f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	01 c0                	add    %eax,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	c1 e0 03             	shl    $0x3,%eax
  800071:	01 c8                	add    %ecx,%eax
  800073:	8a 40 04             	mov    0x4(%eax),%al
  800076:	84 c0                	test   %al,%al
  800078:	74 06                	je     800080 <_main+0x48>
			{
				fullWS = 0;
  80007a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007e:	eb 12                	jmp    800092 <_main+0x5a>
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800080:	ff 45 f0             	incl   -0x10(%ebp)
  800083:	a1 20 50 80 00       	mov    0x805020,%eax
  800088:	8b 50 74             	mov    0x74(%eax),%edx
  80008b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008e:	39 c2                	cmp    %eax,%edx
  800090:	77 c8                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800092:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800096:	74 14                	je     8000ac <_main+0x74>
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 e0 3b 80 00       	push   $0x803be0
  8000a0:	6a 15                	push   $0x15
  8000a2:	68 fc 3b 80 00       	push   $0x803bfc
  8000a7:	e8 98 0b 00 00       	call   800c44 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 bb 1d 00 00       	call   801e71 <malloc>
  8000b6:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000b9:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000c7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000ca:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 d3 21 00 00       	call   8022b0 <sys_calculate_free_frames>
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e0:	e8 6b 22 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(3*Mega-kilo);
  8000e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000eb:	89 c2                	mov    %eax,%edx
  8000ed:	01 d2                	add    %edx,%edx
  8000ef:	01 d0                	add    %edx,%eax
  8000f1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 74 1d 00 00       	call   801e71 <malloc>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800103:	8b 45 90             	mov    -0x70(%ebp),%eax
  800106:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80010b:	74 14                	je     800121 <_main+0xe9>
  80010d:	83 ec 04             	sub    $0x4,%esp
  800110:	68 14 3c 80 00       	push   $0x803c14
  800115:	6a 26                	push   $0x26
  800117:	68 fc 3b 80 00       	push   $0x803bfc
  80011c:	e8 23 0b 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  800121:	e8 2a 22 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800126:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800129:	3d 00 03 00 00       	cmp    $0x300,%eax
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 44 3c 80 00       	push   $0x803c44
  800138:	6a 28                	push   $0x28
  80013a:	68 fc 3b 80 00       	push   $0x803bfc
  80013f:	e8 00 0b 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800144:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800147:	e8 64 21 00 00       	call   8022b0 <sys_calculate_free_frames>
  80014c:	29 c3                	sub    %eax,%ebx
  80014e:	89 d8                	mov    %ebx,%eax
  800150:	83 f8 01             	cmp    $0x1,%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 61 3c 80 00       	push   $0x803c61
  80015d:	6a 29                	push   $0x29
  80015f:	68 fc 3b 80 00       	push   $0x803bfc
  800164:	e8 db 0a 00 00       	call   800c44 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 42 21 00 00       	call   8022b0 <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 da 21 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	89 c2                	mov    %eax,%edx
  80017e:	01 d2                	add    %edx,%edx
  800180:	01 d0                	add    %edx,%eax
  800182:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	50                   	push   %eax
  800189:	e8 e3 1c 00 00       	call   801e71 <malloc>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  800194:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800197:	89 c1                	mov    %eax,%ecx
  800199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019c:	89 c2                	mov    %eax,%edx
  80019e:	01 d2                	add    %edx,%edx
  8001a0:	01 d0                	add    %edx,%eax
  8001a2:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a7:	39 c1                	cmp    %eax,%ecx
  8001a9:	74 14                	je     8001bf <_main+0x187>
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	68 14 3c 80 00       	push   $0x803c14
  8001b3:	6a 2f                	push   $0x2f
  8001b5:	68 fc 3b 80 00       	push   $0x803bfc
  8001ba:	e8 85 0a 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  8001bf:	e8 8c 21 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  8001c4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c7:	3d 00 03 00 00       	cmp    $0x300,%eax
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 44 3c 80 00       	push   $0x803c44
  8001d6:	6a 31                	push   $0x31
  8001d8:	68 fc 3b 80 00       	push   $0x803bfc
  8001dd:	e8 62 0a 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001e2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001e5:	e8 c6 20 00 00       	call   8022b0 <sys_calculate_free_frames>
  8001ea:	29 c3                	sub    %eax,%ebx
  8001ec:	89 d8                	mov    %ebx,%eax
  8001ee:	83 f8 01             	cmp    $0x1,%eax
  8001f1:	74 14                	je     800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 61 3c 80 00       	push   $0x803c61
  8001fb:	6a 32                	push   $0x32
  8001fd:	68 fc 3b 80 00       	push   $0x803bfc
  800202:	e8 3d 0a 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800207:	e8 a4 20 00 00       	call   8022b0 <sys_calculate_free_frames>
  80020c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020f:	e8 3c 21 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800214:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*Mega-kilo);
  800217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	50                   	push   %eax
  800223:	e8 49 1c 00 00       	call   801e71 <malloc>
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80022e:	8b 45 98             	mov    -0x68(%ebp),%eax
  800231:	89 c1                	mov    %eax,%ecx
  800233:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800236:	89 d0                	mov    %edx,%eax
  800238:	01 c0                	add    %eax,%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	01 c0                	add    %eax,%eax
  80023e:	05 00 00 00 80       	add    $0x80000000,%eax
  800243:	39 c1                	cmp    %eax,%ecx
  800245:	74 14                	je     80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 14 3c 80 00       	push   $0x803c14
  80024f:	6a 38                	push   $0x38
  800251:	68 fc 3b 80 00       	push   $0x803bfc
  800256:	e8 e9 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  80025b:	e8 f0 20 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800260:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800263:	3d 00 02 00 00       	cmp    $0x200,%eax
  800268:	74 14                	je     80027e <_main+0x246>
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	68 44 3c 80 00       	push   $0x803c44
  800272:	6a 3a                	push   $0x3a
  800274:	68 fc 3b 80 00       	push   $0x803bfc
  800279:	e8 c6 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80027e:	e8 2d 20 00 00       	call   8022b0 <sys_calculate_free_frames>
  800283:	89 c2                	mov    %eax,%edx
  800285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800288:	39 c2                	cmp    %eax,%edx
  80028a:	74 14                	je     8002a0 <_main+0x268>
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	68 61 3c 80 00       	push   $0x803c61
  800294:	6a 3b                	push   $0x3b
  800296:	68 fc 3b 80 00       	push   $0x803bfc
  80029b:	e8 a4 09 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002a0:	e8 0b 20 00 00       	call   8022b0 <sys_calculate_free_frames>
  8002a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002a8:	e8 a3 20 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  8002ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*Mega-kilo);
  8002b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b3:	01 c0                	add    %eax,%eax
  8002b5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	50                   	push   %eax
  8002bc:	e8 b0 1b 00 00       	call   801e71 <malloc>
  8002c1:	83 c4 10             	add    $0x10,%esp
  8002c4:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8002c7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002ca:	89 c2                	mov    %eax,%edx
  8002cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cf:	c1 e0 03             	shl    $0x3,%eax
  8002d2:	05 00 00 00 80       	add    $0x80000000,%eax
  8002d7:	39 c2                	cmp    %eax,%edx
  8002d9:	74 14                	je     8002ef <_main+0x2b7>
  8002db:	83 ec 04             	sub    $0x4,%esp
  8002de:	68 14 3c 80 00       	push   $0x803c14
  8002e3:	6a 41                	push   $0x41
  8002e5:	68 fc 3b 80 00       	push   $0x803bfc
  8002ea:	e8 55 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  8002ef:	e8 5c 20 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  8002f4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002f7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 44 3c 80 00       	push   $0x803c44
  800306:	6a 43                	push   $0x43
  800308:	68 fc 3b 80 00       	push   $0x803bfc
  80030d:	e8 32 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800312:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800315:	e8 96 1f 00 00       	call   8022b0 <sys_calculate_free_frames>
  80031a:	29 c3                	sub    %eax,%ebx
  80031c:	89 d8                	mov    %ebx,%eax
  80031e:	83 f8 01             	cmp    $0x1,%eax
  800321:	74 14                	je     800337 <_main+0x2ff>
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	68 61 3c 80 00       	push   $0x803c61
  80032b:	6a 44                	push   $0x44
  80032d:	68 fc 3b 80 00       	push   $0x803bfc
  800332:	e8 0d 09 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800337:	e8 74 1f 00 00       	call   8022b0 <sys_calculate_free_frames>
  80033c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80033f:	e8 0c 20 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800344:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(1*Mega-kilo);
  800347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80034a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	50                   	push   %eax
  800351:	e8 1b 1b 00 00       	call   801e71 <malloc>
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 10*Mega) ) panic("Wrong start address for the allocated space... ");
  80035c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80035f:	89 c1                	mov    %eax,%ecx
  800361:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	c1 e0 02             	shl    $0x2,%eax
  800369:	01 d0                	add    %edx,%eax
  80036b:	01 c0                	add    %eax,%eax
  80036d:	05 00 00 00 80       	add    $0x80000000,%eax
  800372:	39 c1                	cmp    %eax,%ecx
  800374:	74 14                	je     80038a <_main+0x352>
  800376:	83 ec 04             	sub    $0x4,%esp
  800379:	68 14 3c 80 00       	push   $0x803c14
  80037e:	6a 4a                	push   $0x4a
  800380:	68 fc 3b 80 00       	push   $0x803bfc
  800385:	e8 ba 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80038a:	e8 c1 1f 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  80038f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800392:	3d 00 01 00 00       	cmp    $0x100,%eax
  800397:	74 14                	je     8003ad <_main+0x375>
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	68 44 3c 80 00       	push   $0x803c44
  8003a1:	6a 4c                	push   $0x4c
  8003a3:	68 fc 3b 80 00       	push   $0x803bfc
  8003a8:	e8 97 08 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8003ad:	e8 fe 1e 00 00       	call   8022b0 <sys_calculate_free_frames>
  8003b2:	89 c2                	mov    %eax,%edx
  8003b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	74 14                	je     8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 61 3c 80 00       	push   $0x803c61
  8003c3:	6a 4d                	push   $0x4d
  8003c5:	68 fc 3b 80 00       	push   $0x803bfc
  8003ca:	e8 75 08 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cf:	e8 dc 1e 00 00       	call   8022b0 <sys_calculate_free_frames>
  8003d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d7:	e8 74 1f 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  8003dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(1*Mega-kilo);
  8003df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e5:	83 ec 0c             	sub    $0xc,%esp
  8003e8:	50                   	push   %eax
  8003e9:	e8 83 1a 00 00       	call   801e71 <malloc>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 11*Mega) ) panic("Wrong start address for the allocated space... ");
  8003f4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003f7:	89 c1                	mov    %eax,%ecx
  8003f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003fc:	89 d0                	mov    %edx,%eax
  8003fe:	c1 e0 02             	shl    $0x2,%eax
  800401:	01 d0                	add    %edx,%eax
  800403:	01 c0                	add    %eax,%eax
  800405:	01 d0                	add    %edx,%eax
  800407:	05 00 00 00 80       	add    $0x80000000,%eax
  80040c:	39 c1                	cmp    %eax,%ecx
  80040e:	74 14                	je     800424 <_main+0x3ec>
  800410:	83 ec 04             	sub    $0x4,%esp
  800413:	68 14 3c 80 00       	push   $0x803c14
  800418:	6a 53                	push   $0x53
  80041a:	68 fc 3b 80 00       	push   $0x803bfc
  80041f:	e8 20 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800424:	e8 27 1f 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800429:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80042c:	3d 00 01 00 00       	cmp    $0x100,%eax
  800431:	74 14                	je     800447 <_main+0x40f>
  800433:	83 ec 04             	sub    $0x4,%esp
  800436:	68 44 3c 80 00       	push   $0x803c44
  80043b:	6a 55                	push   $0x55
  80043d:	68 fc 3b 80 00       	push   $0x803bfc
  800442:	e8 fd 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800447:	e8 64 1e 00 00       	call   8022b0 <sys_calculate_free_frames>
  80044c:	89 c2                	mov    %eax,%edx
  80044e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800451:	39 c2                	cmp    %eax,%edx
  800453:	74 14                	je     800469 <_main+0x431>
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 61 3c 80 00       	push   $0x803c61
  80045d:	6a 56                	push   $0x56
  80045f:	68 fc 3b 80 00       	push   $0x803bfc
  800464:	e8 db 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800469:	e8 42 1e 00 00       	call   8022b0 <sys_calculate_free_frames>
  80046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800471:	e8 da 1e 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800476:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(1*Mega-kilo);
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	50                   	push   %eax
  800483:	e8 e9 19 00 00       	call   801e71 <malloc>
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 12*Mega) ) panic("Wrong start address for the allocated space... ");
  80048e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800491:	89 c1                	mov    %eax,%ecx
  800493:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800496:	89 d0                	mov    %edx,%eax
  800498:	01 c0                	add    %eax,%eax
  80049a:	01 d0                	add    %edx,%eax
  80049c:	c1 e0 02             	shl    $0x2,%eax
  80049f:	05 00 00 00 80       	add    $0x80000000,%eax
  8004a4:	39 c1                	cmp    %eax,%ecx
  8004a6:	74 14                	je     8004bc <_main+0x484>
  8004a8:	83 ec 04             	sub    $0x4,%esp
  8004ab:	68 14 3c 80 00       	push   $0x803c14
  8004b0:	6a 5c                	push   $0x5c
  8004b2:	68 fc 3b 80 00       	push   $0x803bfc
  8004b7:	e8 88 07 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8004bc:	e8 8f 1e 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  8004c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004c4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 44 3c 80 00       	push   $0x803c44
  8004d3:	6a 5e                	push   $0x5e
  8004d5:	68 fc 3b 80 00       	push   $0x803bfc
  8004da:	e8 65 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004e2:	e8 c9 1d 00 00       	call   8022b0 <sys_calculate_free_frames>
  8004e7:	29 c3                	sub    %eax,%ebx
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	83 f8 01             	cmp    $0x1,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 61 3c 80 00       	push   $0x803c61
  8004f8:	6a 5f                	push   $0x5f
  8004fa:	68 fc 3b 80 00       	push   $0x803bfc
  8004ff:	e8 40 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800504:	e8 a7 1d 00 00       	call   8022b0 <sys_calculate_free_frames>
  800509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80050c:	e8 3f 1e 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800511:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(1*Mega-kilo);
  800514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800517:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	e8 4e 19 00 00       	call   801e71 <malloc>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 13*Mega)) panic("Wrong start address for the allocated space... ");
  800529:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80052c:	89 c1                	mov    %eax,%ecx
  80052e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800531:	89 d0                	mov    %edx,%eax
  800533:	01 c0                	add    %eax,%eax
  800535:	01 d0                	add    %edx,%eax
  800537:	c1 e0 02             	shl    $0x2,%eax
  80053a:	01 d0                	add    %edx,%eax
  80053c:	05 00 00 00 80       	add    $0x80000000,%eax
  800541:	39 c1                	cmp    %eax,%ecx
  800543:	74 14                	je     800559 <_main+0x521>
  800545:	83 ec 04             	sub    $0x4,%esp
  800548:	68 14 3c 80 00       	push   $0x803c14
  80054d:	6a 65                	push   $0x65
  80054f:	68 fc 3b 80 00       	push   $0x803bfc
  800554:	e8 eb 06 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800559:	e8 f2 1d 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  80055e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800561:	3d 00 01 00 00       	cmp    $0x100,%eax
  800566:	74 14                	je     80057c <_main+0x544>
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	68 44 3c 80 00       	push   $0x803c44
  800570:	6a 67                	push   $0x67
  800572:	68 fc 3b 80 00       	push   $0x803bfc
  800577:	e8 c8 06 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80057c:	e8 2f 1d 00 00       	call   8022b0 <sys_calculate_free_frames>
  800581:	89 c2                	mov    %eax,%edx
  800583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800586:	39 c2                	cmp    %eax,%edx
  800588:	74 14                	je     80059e <_main+0x566>
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	68 61 3c 80 00       	push   $0x803c61
  800592:	6a 68                	push   $0x68
  800594:	68 fc 3b 80 00       	push   $0x803bfc
  800599:	e8 a6 06 00 00       	call   800c44 <_panic>
	}

	//[2] Free some to create holes
	{
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80059e:	e8 0d 1d 00 00       	call   8022b0 <sys_calculate_free_frames>
  8005a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005a6:	e8 a5 1d 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  8005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	50                   	push   %eax
  8005b5:	e8 4e 19 00 00       	call   801f08 <free>
  8005ba:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  3*256) panic("Wrong page file free: ");
  8005bd:	e8 8e 1d 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  8005c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c5:	29 c2                	sub    %eax,%edx
  8005c7:	89 d0                	mov    %edx,%eax
  8005c9:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005ce:	74 14                	je     8005e4 <_main+0x5ac>
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	68 74 3c 80 00       	push   $0x803c74
  8005d8:	6a 72                	push   $0x72
  8005da:	68 fc 3b 80 00       	push   $0x803bfc
  8005df:	e8 60 06 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005e4:	e8 c7 1c 00 00       	call   8022b0 <sys_calculate_free_frames>
  8005e9:	89 c2                	mov    %eax,%edx
  8005eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ee:	39 c2                	cmp    %eax,%edx
  8005f0:	74 14                	je     800606 <_main+0x5ce>
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 8b 3c 80 00       	push   $0x803c8b
  8005fa:	6a 73                	push   $0x73
  8005fc:	68 fc 3b 80 00       	push   $0x803bfc
  800601:	e8 3e 06 00 00       	call   800c44 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800606:	e8 a5 1c 00 00       	call   8022b0 <sys_calculate_free_frames>
  80060b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80060e:	e8 3d 1d 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800613:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800616:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	50                   	push   %eax
  80061d:	e8 e6 18 00 00       	call   801f08 <free>
  800622:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  2*256) panic("Wrong page file free: ");
  800625:	e8 26 1d 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  80062a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062d:	29 c2                	sub    %eax,%edx
  80062f:	89 d0                	mov    %edx,%eax
  800631:	3d 00 02 00 00       	cmp    $0x200,%eax
  800636:	74 14                	je     80064c <_main+0x614>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 74 3c 80 00       	push   $0x803c74
  800640:	6a 7a                	push   $0x7a
  800642:	68 fc 3b 80 00       	push   $0x803bfc
  800647:	e8 f8 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064c:	e8 5f 1c 00 00       	call   8022b0 <sys_calculate_free_frames>
  800651:	89 c2                	mov    %eax,%edx
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	74 14                	je     80066e <_main+0x636>
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	68 8b 3c 80 00       	push   $0x803c8b
  800662:	6a 7b                	push   $0x7b
  800664:	68 fc 3b 80 00       	push   $0x803bfc
  800669:	e8 d6 05 00 00       	call   800c44 <_panic>

		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80066e:	e8 3d 1c 00 00       	call   8022b0 <sys_calculate_free_frames>
  800673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800676:	e8 d5 1c 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  80067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80067e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800681:	83 ec 0c             	sub    $0xc,%esp
  800684:	50                   	push   %eax
  800685:	e8 7e 18 00 00       	call   801f08 <free>
  80068a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  80068d:	e8 be 1c 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800695:	29 c2                	sub    %eax,%edx
  800697:	89 d0                	mov    %edx,%eax
  800699:	3d 00 01 00 00       	cmp    $0x100,%eax
  80069e:	74 17                	je     8006b7 <_main+0x67f>
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	68 74 3c 80 00       	push   $0x803c74
  8006a8:	68 82 00 00 00       	push   $0x82
  8006ad:	68 fc 3b 80 00       	push   $0x803bfc
  8006b2:	e8 8d 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006b7:	e8 f4 1b 00 00       	call   8022b0 <sys_calculate_free_frames>
  8006bc:	89 c2                	mov    %eax,%edx
  8006be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c1:	39 c2                	cmp    %eax,%edx
  8006c3:	74 17                	je     8006dc <_main+0x6a4>
  8006c5:	83 ec 04             	sub    $0x4,%esp
  8006c8:	68 8b 3c 80 00       	push   $0x803c8b
  8006cd:	68 83 00 00 00       	push   $0x83
  8006d2:	68 fc 3b 80 00       	push   $0x803bfc
  8006d7:	e8 68 05 00 00       	call   800c44 <_panic>
	}

	//[3] Allocate again [test best fit]
	{
		//Allocate 512 KB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8006dc:	e8 cf 1b 00 00       	call   8022b0 <sys_calculate_free_frames>
  8006e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006e4:	e8 67 1c 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  8006e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo);
  8006ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006ef:	c1 e0 09             	shl    $0x9,%eax
  8006f2:	83 ec 0c             	sub    $0xc,%esp
  8006f5:	50                   	push   %eax
  8006f6:	e8 76 17 00 00       	call   801e71 <malloc>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  800701:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800704:	89 c1                	mov    %eax,%ecx
  800706:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800709:	89 d0                	mov    %edx,%eax
  80070b:	c1 e0 02             	shl    $0x2,%eax
  80070e:	01 d0                	add    %edx,%eax
  800710:	01 c0                	add    %eax,%eax
  800712:	01 d0                	add    %edx,%eax
  800714:	05 00 00 00 80       	add    $0x80000000,%eax
  800719:	39 c1                	cmp    %eax,%ecx
  80071b:	74 17                	je     800734 <_main+0x6fc>
  80071d:	83 ec 04             	sub    $0x4,%esp
  800720:	68 14 3c 80 00       	push   $0x803c14
  800725:	68 8c 00 00 00       	push   $0x8c
  80072a:	68 fc 3b 80 00       	push   $0x803bfc
  80072f:	e8 10 05 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800734:	e8 17 1c 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800739:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80073c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800741:	74 17                	je     80075a <_main+0x722>
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	68 44 3c 80 00       	push   $0x803c44
  80074b:	68 8e 00 00 00       	push   $0x8e
  800750:	68 fc 3b 80 00       	push   $0x803bfc
  800755:	e8 ea 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80075a:	e8 51 1b 00 00       	call   8022b0 <sys_calculate_free_frames>
  80075f:	89 c2                	mov    %eax,%edx
  800761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 17                	je     80077f <_main+0x747>
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 61 3c 80 00       	push   $0x803c61
  800770:	68 8f 00 00 00       	push   $0x8f
  800775:	68 fc 3b 80 00       	push   $0x803bfc
  80077a:	e8 c5 04 00 00       	call   800c44 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80077f:	e8 2c 1b 00 00       	call   8022b0 <sys_calculate_free_frames>
  800784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800787:	e8 c4 1b 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  80078c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80078f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800792:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	50                   	push   %eax
  800799:	e8 d3 16 00 00       	call   801e71 <malloc>
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8007a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007a7:	89 c2                	mov    %eax,%edx
  8007a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ac:	c1 e0 03             	shl    $0x3,%eax
  8007af:	05 00 00 00 80       	add    $0x80000000,%eax
  8007b4:	39 c2                	cmp    %eax,%edx
  8007b6:	74 17                	je     8007cf <_main+0x797>
  8007b8:	83 ec 04             	sub    $0x4,%esp
  8007bb:	68 14 3c 80 00       	push   $0x803c14
  8007c0:	68 95 00 00 00       	push   $0x95
  8007c5:	68 fc 3b 80 00       	push   $0x803bfc
  8007ca:	e8 75 04 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007cf:	e8 7c 1b 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  8007d4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007d7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007dc:	74 17                	je     8007f5 <_main+0x7bd>
  8007de:	83 ec 04             	sub    $0x4,%esp
  8007e1:	68 44 3c 80 00       	push   $0x803c44
  8007e6:	68 97 00 00 00       	push   $0x97
  8007eb:	68 fc 3b 80 00       	push   $0x803bfc
  8007f0:	e8 4f 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007f5:	e8 b6 1a 00 00       	call   8022b0 <sys_calculate_free_frames>
  8007fa:	89 c2                	mov    %eax,%edx
  8007fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ff:	39 c2                	cmp    %eax,%edx
  800801:	74 17                	je     80081a <_main+0x7e2>
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	68 61 3c 80 00       	push   $0x803c61
  80080b:	68 98 00 00 00       	push   $0x98
  800810:	68 fc 3b 80 00       	push   $0x803bfc
  800815:	e8 2a 04 00 00       	call   800c44 <_panic>

		//Allocate 256 KB - should be placed in remaining of 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80081a:	e8 91 1a 00 00       	call   8022b0 <sys_calculate_free_frames>
  80081f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800822:	e8 29 1b 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800827:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  80082a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082d:	89 d0                	mov    %edx,%eax
  80082f:	c1 e0 08             	shl    $0x8,%eax
  800832:	29 d0                	sub    %edx,%eax
  800834:	83 ec 0c             	sub    $0xc,%esp
  800837:	50                   	push   %eax
  800838:	e8 34 16 00 00       	call   801e71 <malloc>
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 11*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  800843:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800846:	89 c1                	mov    %eax,%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	c1 e0 02             	shl    $0x2,%eax
  800850:	01 d0                	add    %edx,%eax
  800852:	01 c0                	add    %eax,%eax
  800854:	01 d0                	add    %edx,%eax
  800856:	89 c2                	mov    %eax,%edx
  800858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80085b:	c1 e0 09             	shl    $0x9,%eax
  80085e:	01 d0                	add    %edx,%eax
  800860:	05 00 00 00 80       	add    $0x80000000,%eax
  800865:	39 c1                	cmp    %eax,%ecx
  800867:	74 17                	je     800880 <_main+0x848>
  800869:	83 ec 04             	sub    $0x4,%esp
  80086c:	68 14 3c 80 00       	push   $0x803c14
  800871:	68 9e 00 00 00       	push   $0x9e
  800876:	68 fc 3b 80 00       	push   $0x803bfc
  80087b:	e8 c4 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800880:	e8 cb 1a 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800885:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800888:	83 f8 40             	cmp    $0x40,%eax
  80088b:	74 17                	je     8008a4 <_main+0x86c>
  80088d:	83 ec 04             	sub    $0x4,%esp
  800890:	68 44 3c 80 00       	push   $0x803c44
  800895:	68 a0 00 00 00       	push   $0xa0
  80089a:	68 fc 3b 80 00       	push   $0x803bfc
  80089f:	e8 a0 03 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008a4:	e8 07 1a 00 00       	call   8022b0 <sys_calculate_free_frames>
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ae:	39 c2                	cmp    %eax,%edx
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 61 3c 80 00       	push   $0x803c61
  8008ba:	68 a1 00 00 00       	push   $0xa1
  8008bf:	68 fc 3b 80 00       	push   $0x803bfc
  8008c4:	e8 7b 03 00 00       	call   800c44 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 e2 19 00 00       	call   8022b0 <sys_calculate_free_frames>
  8008ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008d1:	e8 7a 1a 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  8008d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega - kilo);
  8008d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008dc:	c1 e0 02             	shl    $0x2,%eax
  8008df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008e2:	83 ec 0c             	sub    $0xc,%esp
  8008e5:	50                   	push   %eax
  8008e6:	e8 86 15 00 00       	call   801e71 <malloc>
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  8008f1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8008f4:	89 c1                	mov    %eax,%ecx
  8008f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	01 c0                	add    %eax,%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	01 c0                	add    %eax,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	05 00 00 00 80       	add    $0x80000000,%eax
  80090a:	39 c1                	cmp    %eax,%ecx
  80090c:	74 17                	je     800925 <_main+0x8ed>
  80090e:	83 ec 04             	sub    $0x4,%esp
  800911:	68 14 3c 80 00       	push   $0x803c14
  800916:	68 a7 00 00 00       	push   $0xa7
  80091b:	68 fc 3b 80 00       	push   $0x803bfc
  800920:	e8 1f 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  800925:	e8 26 1a 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  80092a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80092d:	3d 00 04 00 00       	cmp    $0x400,%eax
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 44 3c 80 00       	push   $0x803c44
  80093c:	68 a9 00 00 00       	push   $0xa9
  800941:	68 fc 3b 80 00       	push   $0x803bfc
  800946:	e8 f9 02 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  80094b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80094e:	e8 5d 19 00 00       	call   8022b0 <sys_calculate_free_frames>
  800953:	29 c3                	sub    %eax,%ebx
  800955:	89 d8                	mov    %ebx,%eax
  800957:	83 f8 01             	cmp    $0x1,%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 61 3c 80 00       	push   $0x803c61
  800964:	68 aa 00 00 00       	push   $0xaa
  800969:	68 fc 3b 80 00       	push   $0x803bfc
  80096e:	e8 d1 02 00 00       	call   800c44 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1M Hole appended to already existing 1M hole in the middle
		freeFrames = sys_calculate_free_frames() ;
  800973:	e8 38 19 00 00       	call   8022b0 <sys_calculate_free_frames>
  800978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80097b:	e8 d0 19 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800980:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  800983:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800986:	83 ec 0c             	sub    $0xc,%esp
  800989:	50                   	push   %eax
  80098a:	e8 79 15 00 00       	call   801f08 <free>
  80098f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800992:	e8 b9 19 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800997:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099a:	29 c2                	sub    %eax,%edx
  80099c:	89 d0                	mov    %edx,%eax
  80099e:	3d 00 01 00 00       	cmp    $0x100,%eax
  8009a3:	74 17                	je     8009bc <_main+0x984>
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	68 74 3c 80 00       	push   $0x803c74
  8009ad:	68 b4 00 00 00       	push   $0xb4
  8009b2:	68 fc 3b 80 00       	push   $0x803bfc
  8009b7:	e8 88 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009bc:	e8 ef 18 00 00       	call   8022b0 <sys_calculate_free_frames>
  8009c1:	89 c2                	mov    %eax,%edx
  8009c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c6:	39 c2                	cmp    %eax,%edx
  8009c8:	74 17                	je     8009e1 <_main+0x9a9>
  8009ca:	83 ec 04             	sub    $0x4,%esp
  8009cd:	68 8b 3c 80 00       	push   $0x803c8b
  8009d2:	68 b5 00 00 00       	push   $0xb5
  8009d7:	68 fc 3b 80 00       	push   $0x803bfc
  8009dc:	e8 63 02 00 00       	call   800c44 <_panic>

		//another 512 KB Hole appended to the hole
		freeFrames = sys_calculate_free_frames() ;
  8009e1:	e8 ca 18 00 00       	call   8022b0 <sys_calculate_free_frames>
  8009e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e9:	e8 62 19 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  8009ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[8]);
  8009f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8009f4:	83 ec 0c             	sub    $0xc,%esp
  8009f7:	50                   	push   %eax
  8009f8:	e8 0b 15 00 00       	call   801f08 <free>
  8009fd:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  128) panic("Wrong page file free: ");
  800a00:	e8 4b 19 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800a05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a08:	29 c2                	sub    %eax,%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800a11:	74 17                	je     800a2a <_main+0x9f2>
  800a13:	83 ec 04             	sub    $0x4,%esp
  800a16:	68 74 3c 80 00       	push   $0x803c74
  800a1b:	68 bc 00 00 00       	push   $0xbc
  800a20:	68 fc 3b 80 00       	push   $0x803bfc
  800a25:	e8 1a 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a2a:	e8 81 18 00 00       	call   8022b0 <sys_calculate_free_frames>
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a34:	39 c2                	cmp    %eax,%edx
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 8b 3c 80 00       	push   $0x803c8b
  800a40:	68 bd 00 00 00       	push   $0xbd
  800a45:	68 fc 3b 80 00       	push   $0x803bfc
  800a4a:	e8 f5 01 00 00       	call   800c44 <_panic>
	}

	//[5] Allocate again [test best fit]
	{
		//Allocate 2 MB - should be placed in the contiguous hole (2 MB + 512 KB)
		freeFrames = sys_calculate_free_frames();
  800a4f:	e8 5c 18 00 00       	call   8022b0 <sys_calculate_free_frames>
  800a54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a57:	e8 f4 18 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800a5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(2*Mega - kilo);
  800a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a62:	01 c0                	add    %eax,%eax
  800a64:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800a67:	83 ec 0c             	sub    $0xc,%esp
  800a6a:	50                   	push   %eax
  800a6b:	e8 01 14 00 00       	call   801e71 <malloc>
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 9*Mega)) panic("Wrong start address for the allocated space... ");
  800a76:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a79:	89 c1                	mov    %eax,%ecx
  800a7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a7e:	89 d0                	mov    %edx,%eax
  800a80:	c1 e0 03             	shl    $0x3,%eax
  800a83:	01 d0                	add    %edx,%eax
  800a85:	05 00 00 00 80       	add    $0x80000000,%eax
  800a8a:	39 c1                	cmp    %eax,%ecx
  800a8c:	74 17                	je     800aa5 <_main+0xa6d>
  800a8e:	83 ec 04             	sub    $0x4,%esp
  800a91:	68 14 3c 80 00       	push   $0x803c14
  800a96:	68 c6 00 00 00       	push   $0xc6
  800a9b:	68 fc 3b 80 00       	push   $0x803bfc
  800aa0:	e8 9f 01 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800aa5:	e8 a6 18 00 00       	call   802350 <sys_pf_calculate_allocated_pages>
  800aaa:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800aad:	3d 00 02 00 00       	cmp    $0x200,%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 44 3c 80 00       	push   $0x803c44
  800abc:	68 c8 00 00 00       	push   $0xc8
  800ac1:	68 fc 3b 80 00       	push   $0x803bfc
  800ac6:	e8 79 01 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800acb:	e8 e0 17 00 00       	call   8022b0 <sys_calculate_free_frames>
  800ad0:	89 c2                	mov    %eax,%edx
  800ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad5:	39 c2                	cmp    %eax,%edx
  800ad7:	74 17                	je     800af0 <_main+0xab8>
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	68 61 3c 80 00       	push   $0x803c61
  800ae1:	68 c9 00 00 00       	push   $0xc9
  800ae6:	68 fc 3b 80 00       	push   $0x803bfc
  800aeb:	e8 54 01 00 00       	call   800c44 <_panic>
	}
	cprintf("Congratulations!! test BEST FIT allocation (1) completed successfully.\n");
  800af0:	83 ec 0c             	sub    $0xc,%esp
  800af3:	68 98 3c 80 00       	push   $0x803c98
  800af8:	e8 fb 03 00 00       	call   800ef8 <cprintf>
  800afd:	83 c4 10             	add    $0x10,%esp

	return;
  800b00:	90                   	nop
}
  800b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b04:	5b                   	pop    %ebx
  800b05:	5f                   	pop    %edi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b0e:	e8 7d 1a 00 00       	call   802590 <sys_getenvindex>
  800b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b19:	89 d0                	mov    %edx,%eax
  800b1b:	c1 e0 03             	shl    $0x3,%eax
  800b1e:	01 d0                	add    %edx,%eax
  800b20:	01 c0                	add    %eax,%eax
  800b22:	01 d0                	add    %edx,%eax
  800b24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b2b:	01 d0                	add    %edx,%eax
  800b2d:	c1 e0 04             	shl    $0x4,%eax
  800b30:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b35:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800b3f:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800b45:	84 c0                	test   %al,%al
  800b47:	74 0f                	je     800b58 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800b49:	a1 20 50 80 00       	mov    0x805020,%eax
  800b4e:	05 5c 05 00 00       	add    $0x55c,%eax
  800b53:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5c:	7e 0a                	jle    800b68 <libmain+0x60>
		binaryname = argv[0];
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	ff 75 08             	pushl  0x8(%ebp)
  800b71:	e8 c2 f4 ff ff       	call   800038 <_main>
  800b76:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800b79:	e8 1f 18 00 00       	call   80239d <sys_disable_interrupt>
	cprintf("**************************************\n");
  800b7e:	83 ec 0c             	sub    $0xc,%esp
  800b81:	68 f8 3c 80 00       	push   $0x803cf8
  800b86:	e8 6d 03 00 00       	call   800ef8 <cprintf>
  800b8b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b8e:	a1 20 50 80 00       	mov    0x805020,%eax
  800b93:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800b99:	a1 20 50 80 00       	mov    0x805020,%eax
  800b9e:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800ba4:	83 ec 04             	sub    $0x4,%esp
  800ba7:	52                   	push   %edx
  800ba8:	50                   	push   %eax
  800ba9:	68 20 3d 80 00       	push   $0x803d20
  800bae:	e8 45 03 00 00       	call   800ef8 <cprintf>
  800bb3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bb6:	a1 20 50 80 00       	mov    0x805020,%eax
  800bbb:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800bc1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bc6:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800bcc:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd1:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800bd7:	51                   	push   %ecx
  800bd8:	52                   	push   %edx
  800bd9:	50                   	push   %eax
  800bda:	68 48 3d 80 00       	push   $0x803d48
  800bdf:	e8 14 03 00 00       	call   800ef8 <cprintf>
  800be4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800be7:	a1 20 50 80 00       	mov    0x805020,%eax
  800bec:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	68 a0 3d 80 00       	push   $0x803da0
  800bfb:	e8 f8 02 00 00       	call   800ef8 <cprintf>
  800c00:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	68 f8 3c 80 00       	push   $0x803cf8
  800c0b:	e8 e8 02 00 00       	call   800ef8 <cprintf>
  800c10:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c13:	e8 9f 17 00 00       	call   8023b7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c18:	e8 19 00 00 00       	call   800c36 <exit>
}
  800c1d:	90                   	nop
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	6a 00                	push   $0x0
  800c2b:	e8 2c 19 00 00       	call   80255c <sys_destroy_env>
  800c30:	83 c4 10             	add    $0x10,%esp
}
  800c33:	90                   	nop
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

00800c36 <exit>:

void
exit(void)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c3c:	e8 81 19 00 00       	call   8025c2 <sys_exit_env>
}
  800c41:	90                   	nop
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c4a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c4d:	83 c0 04             	add    $0x4,%eax
  800c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c53:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	74 16                	je     800c72 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c5c:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	50                   	push   %eax
  800c65:	68 b4 3d 80 00       	push   $0x803db4
  800c6a:	e8 89 02 00 00       	call   800ef8 <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c72:	a1 00 50 80 00       	mov    0x805000,%eax
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	ff 75 08             	pushl  0x8(%ebp)
  800c7d:	50                   	push   %eax
  800c7e:	68 b9 3d 80 00       	push   $0x803db9
  800c83:	e8 70 02 00 00       	call   800ef8 <cprintf>
  800c88:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800c8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 f4             	pushl  -0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	e8 f3 01 00 00       	call   800e8d <vcprintf>
  800c9a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	6a 00                	push   $0x0
  800ca2:	68 d5 3d 80 00       	push   $0x803dd5
  800ca7:	e8 e1 01 00 00       	call   800e8d <vcprintf>
  800cac:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800caf:	e8 82 ff ff ff       	call   800c36 <exit>

	// should not return here
	while (1) ;
  800cb4:	eb fe                	jmp    800cb4 <_panic+0x70>

00800cb6 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cbc:	a1 20 50 80 00       	mov    0x805020,%eax
  800cc1:	8b 50 74             	mov    0x74(%eax),%edx
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	39 c2                	cmp    %eax,%edx
  800cc9:	74 14                	je     800cdf <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800ccb:	83 ec 04             	sub    $0x4,%esp
  800cce:	68 d8 3d 80 00       	push   $0x803dd8
  800cd3:	6a 26                	push   $0x26
  800cd5:	68 24 3e 80 00       	push   $0x803e24
  800cda:	e8 65 ff ff ff       	call   800c44 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800cdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ce6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ced:	e9 c2 00 00 00       	jmp    800db4 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cf5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	01 d0                	add    %edx,%eax
  800d01:	8b 00                	mov    (%eax),%eax
  800d03:	85 c0                	test   %eax,%eax
  800d05:	75 08                	jne    800d0f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d07:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d0a:	e9 a2 00 00 00       	jmp    800db1 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d16:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d1d:	eb 69                	jmp    800d88 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d1f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d24:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d2d:	89 d0                	mov    %edx,%eax
  800d2f:	01 c0                	add    %eax,%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	c1 e0 03             	shl    $0x3,%eax
  800d36:	01 c8                	add    %ecx,%eax
  800d38:	8a 40 04             	mov    0x4(%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	75 46                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d3f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d44:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d4d:	89 d0                	mov    %edx,%eax
  800d4f:	01 c0                	add    %eax,%eax
  800d51:	01 d0                	add    %edx,%eax
  800d53:	c1 e0 03             	shl    $0x3,%eax
  800d56:	01 c8                	add    %ecx,%eax
  800d58:	8b 00                	mov    (%eax),%eax
  800d5a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d65:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d6a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	01 c8                	add    %ecx,%eax
  800d76:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d78:	39 c2                	cmp    %eax,%edx
  800d7a:	75 09                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800d7c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800d83:	eb 12                	jmp    800d97 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d85:	ff 45 e8             	incl   -0x18(%ebp)
  800d88:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8d:	8b 50 74             	mov    0x74(%eax),%edx
  800d90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d93:	39 c2                	cmp    %eax,%edx
  800d95:	77 88                	ja     800d1f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800d97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800d9b:	75 14                	jne    800db1 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800d9d:	83 ec 04             	sub    $0x4,%esp
  800da0:	68 30 3e 80 00       	push   $0x803e30
  800da5:	6a 3a                	push   $0x3a
  800da7:	68 24 3e 80 00       	push   $0x803e24
  800dac:	e8 93 fe ff ff       	call   800c44 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800db1:	ff 45 f0             	incl   -0x10(%ebp)
  800db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dba:	0f 8c 32 ff ff ff    	jl     800cf2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800dc0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800dce:	eb 26                	jmp    800df6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800dd0:	a1 20 50 80 00       	mov    0x805020,%eax
  800dd5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ddb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dde:	89 d0                	mov    %edx,%eax
  800de0:	01 c0                	add    %eax,%eax
  800de2:	01 d0                	add    %edx,%eax
  800de4:	c1 e0 03             	shl    $0x3,%eax
  800de7:	01 c8                	add    %ecx,%eax
  800de9:	8a 40 04             	mov    0x4(%eax),%al
  800dec:	3c 01                	cmp    $0x1,%al
  800dee:	75 03                	jne    800df3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800df0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800df3:	ff 45 e0             	incl   -0x20(%ebp)
  800df6:	a1 20 50 80 00       	mov    0x805020,%eax
  800dfb:	8b 50 74             	mov    0x74(%eax),%edx
  800dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e01:	39 c2                	cmp    %eax,%edx
  800e03:	77 cb                	ja     800dd0 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e0b:	74 14                	je     800e21 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e0d:	83 ec 04             	sub    $0x4,%esp
  800e10:	68 84 3e 80 00       	push   $0x803e84
  800e15:	6a 44                	push   $0x44
  800e17:	68 24 3e 80 00       	push   $0x803e24
  800e1c:	e8 23 fe ff ff       	call   800c44 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e21:	90                   	nop
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8b 00                	mov    (%eax),%eax
  800e2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e35:	89 0a                	mov    %ecx,(%edx)
  800e37:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3a:	88 d1                	mov    %dl,%cl
  800e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	8b 00                	mov    (%eax),%eax
  800e48:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e4d:	75 2c                	jne    800e7b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e4f:	a0 24 50 80 00       	mov    0x805024,%al
  800e54:	0f b6 c0             	movzbl %al,%eax
  800e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5a:	8b 12                	mov    (%edx),%edx
  800e5c:	89 d1                	mov    %edx,%ecx
  800e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e61:	83 c2 08             	add    $0x8,%edx
  800e64:	83 ec 04             	sub    $0x4,%esp
  800e67:	50                   	push   %eax
  800e68:	51                   	push   %ecx
  800e69:	52                   	push   %edx
  800e6a:	e8 80 13 00 00       	call   8021ef <sys_cputs>
  800e6f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	8b 40 04             	mov    0x4(%eax),%eax
  800e81:	8d 50 01             	lea    0x1(%eax),%edx
  800e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e87:	89 50 04             	mov    %edx,0x4(%eax)
}
  800e8a:	90                   	nop
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800e96:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800e9d:	00 00 00 
	b.cnt = 0;
  800ea0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ea7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	ff 75 08             	pushl  0x8(%ebp)
  800eb0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800eb6:	50                   	push   %eax
  800eb7:	68 24 0e 80 00       	push   $0x800e24
  800ebc:	e8 11 02 00 00       	call   8010d2 <vprintfmt>
  800ec1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ec4:	a0 24 50 80 00       	mov    0x805024,%al
  800ec9:	0f b6 c0             	movzbl %al,%eax
  800ecc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ed2:	83 ec 04             	sub    $0x4,%esp
  800ed5:	50                   	push   %eax
  800ed6:	52                   	push   %edx
  800ed7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800edd:	83 c0 08             	add    $0x8,%eax
  800ee0:	50                   	push   %eax
  800ee1:	e8 09 13 00 00       	call   8021ef <sys_cputs>
  800ee6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ee9:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800ef0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800efe:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f05:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 f4             	pushl  -0xc(%ebp)
  800f14:	50                   	push   %eax
  800f15:	e8 73 ff ff ff       	call   800e8d <vcprintf>
  800f1a:	83 c4 10             	add    $0x10,%esp
  800f1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f2b:	e8 6d 14 00 00       	call   80239d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f30:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3f:	50                   	push   %eax
  800f40:	e8 48 ff ff ff       	call   800e8d <vcprintf>
  800f45:	83 c4 10             	add    $0x10,%esp
  800f48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f4b:	e8 67 14 00 00       	call   8023b7 <sys_enable_interrupt>
	return cnt;
  800f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	53                   	push   %ebx
  800f59:	83 ec 14             	sub    $0x14,%esp
  800f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f62:	8b 45 14             	mov    0x14(%ebp),%eax
  800f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f68:	8b 45 18             	mov    0x18(%ebp),%eax
  800f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f70:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f73:	77 55                	ja     800fca <printnum+0x75>
  800f75:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f78:	72 05                	jb     800f7f <printnum+0x2a>
  800f7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f7d:	77 4b                	ja     800fca <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f7f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800f82:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800f85:	8b 45 18             	mov    0x18(%ebp),%eax
  800f88:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8d:	52                   	push   %edx
  800f8e:	50                   	push   %eax
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	ff 75 f0             	pushl  -0x10(%ebp)
  800f95:	e8 ce 29 00 00       	call   803968 <__udivdi3>
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	83 ec 04             	sub    $0x4,%esp
  800fa0:	ff 75 20             	pushl  0x20(%ebp)
  800fa3:	53                   	push   %ebx
  800fa4:	ff 75 18             	pushl  0x18(%ebp)
  800fa7:	52                   	push   %edx
  800fa8:	50                   	push   %eax
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 a1 ff ff ff       	call   800f55 <printnum>
  800fb4:	83 c4 20             	add    $0x20,%esp
  800fb7:	eb 1a                	jmp    800fd3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	ff 75 20             	pushl  0x20(%ebp)
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	ff d0                	call   *%eax
  800fc7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800fca:	ff 4d 1c             	decl   0x1c(%ebp)
  800fcd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800fd1:	7f e6                	jg     800fb9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800fd3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe1:	53                   	push   %ebx
  800fe2:	51                   	push   %ecx
  800fe3:	52                   	push   %edx
  800fe4:	50                   	push   %eax
  800fe5:	e8 8e 2a 00 00       	call   803a78 <__umoddi3>
  800fea:	83 c4 10             	add    $0x10,%esp
  800fed:	05 f4 40 80 00       	add    $0x8040f4,%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f be c0             	movsbl %al,%eax
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	ff 75 0c             	pushl  0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
}
  801006:	90                   	nop
  801007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80100f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801013:	7e 1c                	jle    801031 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8b 00                	mov    (%eax),%eax
  80101a:	8d 50 08             	lea    0x8(%eax),%edx
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	89 10                	mov    %edx,(%eax)
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	83 e8 08             	sub    $0x8,%eax
  80102a:	8b 50 04             	mov    0x4(%eax),%edx
  80102d:	8b 00                	mov    (%eax),%eax
  80102f:	eb 40                	jmp    801071 <getuint+0x65>
	else if (lflag)
  801031:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801035:	74 1e                	je     801055 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8b 00                	mov    (%eax),%eax
  80103c:	8d 50 04             	lea    0x4(%eax),%edx
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	89 10                	mov    %edx,(%eax)
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8b 00                	mov    (%eax),%eax
  801049:	83 e8 04             	sub    $0x4,%eax
  80104c:	8b 00                	mov    (%eax),%eax
  80104e:	ba 00 00 00 00       	mov    $0x0,%edx
  801053:	eb 1c                	jmp    801071 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8b 00                	mov    (%eax),%eax
  80105a:	8d 50 04             	lea    0x4(%eax),%edx
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	89 10                	mov    %edx,(%eax)
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8b 00                	mov    (%eax),%eax
  801067:	83 e8 04             	sub    $0x4,%eax
  80106a:	8b 00                	mov    (%eax),%eax
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801076:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80107a:	7e 1c                	jle    801098 <getint+0x25>
		return va_arg(*ap, long long);
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8b 00                	mov    (%eax),%eax
  801081:	8d 50 08             	lea    0x8(%eax),%edx
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	89 10                	mov    %edx,(%eax)
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	83 e8 08             	sub    $0x8,%eax
  801091:	8b 50 04             	mov    0x4(%eax),%edx
  801094:	8b 00                	mov    (%eax),%eax
  801096:	eb 38                	jmp    8010d0 <getint+0x5d>
	else if (lflag)
  801098:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109c:	74 1a                	je     8010b8 <getint+0x45>
		return va_arg(*ap, long);
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 50 04             	lea    0x4(%eax),%edx
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	89 10                	mov    %edx,(%eax)
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8b 00                	mov    (%eax),%eax
  8010b0:	83 e8 04             	sub    $0x4,%eax
  8010b3:	8b 00                	mov    (%eax),%eax
  8010b5:	99                   	cltd   
  8010b6:	eb 18                	jmp    8010d0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8b 00                	mov    (%eax),%eax
  8010bd:	8d 50 04             	lea    0x4(%eax),%edx
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	89 10                	mov    %edx,(%eax)
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8b 00                	mov    (%eax),%eax
  8010ca:	83 e8 04             	sub    $0x4,%eax
  8010cd:	8b 00                	mov    (%eax),%eax
  8010cf:	99                   	cltd   
}
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	56                   	push   %esi
  8010d6:	53                   	push   %ebx
  8010d7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010da:	eb 17                	jmp    8010f3 <vprintfmt+0x21>
			if (ch == '\0')
  8010dc:	85 db                	test   %ebx,%ebx
  8010de:	0f 84 af 03 00 00    	je     801493 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8010e4:	83 ec 08             	sub    $0x8,%esp
  8010e7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ea:	53                   	push   %ebx
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	ff d0                	call   *%eax
  8010f0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	8d 50 01             	lea    0x1(%eax),%edx
  8010f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	0f b6 d8             	movzbl %al,%ebx
  801101:	83 fb 25             	cmp    $0x25,%ebx
  801104:	75 d6                	jne    8010dc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801106:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80110a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801111:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801118:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80111f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801126:	8b 45 10             	mov    0x10(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 10             	mov    %edx,0x10(%ebp)
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 d8             	movzbl %al,%ebx
  801134:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801137:	83 f8 55             	cmp    $0x55,%eax
  80113a:	0f 87 2b 03 00 00    	ja     80146b <vprintfmt+0x399>
  801140:	8b 04 85 18 41 80 00 	mov    0x804118(,%eax,4),%eax
  801147:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801149:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80114d:	eb d7                	jmp    801126 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80114f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801153:	eb d1                	jmp    801126 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801155:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80115c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80115f:	89 d0                	mov    %edx,%eax
  801161:	c1 e0 02             	shl    $0x2,%eax
  801164:	01 d0                	add    %edx,%eax
  801166:	01 c0                	add    %eax,%eax
  801168:	01 d8                	add    %ebx,%eax
  80116a:	83 e8 30             	sub    $0x30,%eax
  80116d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801170:	8b 45 10             	mov    0x10(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801178:	83 fb 2f             	cmp    $0x2f,%ebx
  80117b:	7e 3e                	jle    8011bb <vprintfmt+0xe9>
  80117d:	83 fb 39             	cmp    $0x39,%ebx
  801180:	7f 39                	jg     8011bb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801182:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801185:	eb d5                	jmp    80115c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801187:	8b 45 14             	mov    0x14(%ebp),%eax
  80118a:	83 c0 04             	add    $0x4,%eax
  80118d:	89 45 14             	mov    %eax,0x14(%ebp)
  801190:	8b 45 14             	mov    0x14(%ebp),%eax
  801193:	83 e8 04             	sub    $0x4,%eax
  801196:	8b 00                	mov    (%eax),%eax
  801198:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80119b:	eb 1f                	jmp    8011bc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80119d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a1:	79 83                	jns    801126 <vprintfmt+0x54>
				width = 0;
  8011a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011aa:	e9 77 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011af:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011b6:	e9 6b ff ff ff       	jmp    801126 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011bb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011c0:	0f 89 60 ff ff ff    	jns    801126 <vprintfmt+0x54>
				width = precision, precision = -1;
  8011c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8011d3:	e9 4e ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8011d8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8011db:	e9 46 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	83 c0 04             	add    $0x4,%eax
  8011e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8011e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ec:	83 e8 04             	sub    $0x4,%eax
  8011ef:	8b 00                	mov    (%eax),%eax
  8011f1:	83 ec 08             	sub    $0x8,%esp
  8011f4:	ff 75 0c             	pushl  0xc(%ebp)
  8011f7:	50                   	push   %eax
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	ff d0                	call   *%eax
  8011fd:	83 c4 10             	add    $0x10,%esp
			break;
  801200:	e9 89 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801205:	8b 45 14             	mov    0x14(%ebp),%eax
  801208:	83 c0 04             	add    $0x4,%eax
  80120b:	89 45 14             	mov    %eax,0x14(%ebp)
  80120e:	8b 45 14             	mov    0x14(%ebp),%eax
  801211:	83 e8 04             	sub    $0x4,%eax
  801214:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801216:	85 db                	test   %ebx,%ebx
  801218:	79 02                	jns    80121c <vprintfmt+0x14a>
				err = -err;
  80121a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80121c:	83 fb 64             	cmp    $0x64,%ebx
  80121f:	7f 0b                	jg     80122c <vprintfmt+0x15a>
  801221:	8b 34 9d 60 3f 80 00 	mov    0x803f60(,%ebx,4),%esi
  801228:	85 f6                	test   %esi,%esi
  80122a:	75 19                	jne    801245 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80122c:	53                   	push   %ebx
  80122d:	68 05 41 80 00       	push   $0x804105
  801232:	ff 75 0c             	pushl  0xc(%ebp)
  801235:	ff 75 08             	pushl  0x8(%ebp)
  801238:	e8 5e 02 00 00       	call   80149b <printfmt>
  80123d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801240:	e9 49 02 00 00       	jmp    80148e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801245:	56                   	push   %esi
  801246:	68 0e 41 80 00       	push   $0x80410e
  80124b:	ff 75 0c             	pushl  0xc(%ebp)
  80124e:	ff 75 08             	pushl  0x8(%ebp)
  801251:	e8 45 02 00 00       	call   80149b <printfmt>
  801256:	83 c4 10             	add    $0x10,%esp
			break;
  801259:	e9 30 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80125e:	8b 45 14             	mov    0x14(%ebp),%eax
  801261:	83 c0 04             	add    $0x4,%eax
  801264:	89 45 14             	mov    %eax,0x14(%ebp)
  801267:	8b 45 14             	mov    0x14(%ebp),%eax
  80126a:	83 e8 04             	sub    $0x4,%eax
  80126d:	8b 30                	mov    (%eax),%esi
  80126f:	85 f6                	test   %esi,%esi
  801271:	75 05                	jne    801278 <vprintfmt+0x1a6>
				p = "(null)";
  801273:	be 11 41 80 00       	mov    $0x804111,%esi
			if (width > 0 && padc != '-')
  801278:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80127c:	7e 6d                	jle    8012eb <vprintfmt+0x219>
  80127e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801282:	74 67                	je     8012eb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801284:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	50                   	push   %eax
  80128b:	56                   	push   %esi
  80128c:	e8 0c 03 00 00       	call   80159d <strnlen>
  801291:	83 c4 10             	add    $0x10,%esp
  801294:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801297:	eb 16                	jmp    8012af <vprintfmt+0x1dd>
					putch(padc, putdat);
  801299:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80129d:	83 ec 08             	sub    $0x8,%esp
  8012a0:	ff 75 0c             	pushl  0xc(%ebp)
  8012a3:	50                   	push   %eax
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	ff d0                	call   *%eax
  8012a9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8012af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012b3:	7f e4                	jg     801299 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012b5:	eb 34                	jmp    8012eb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012bb:	74 1c                	je     8012d9 <vprintfmt+0x207>
  8012bd:	83 fb 1f             	cmp    $0x1f,%ebx
  8012c0:	7e 05                	jle    8012c7 <vprintfmt+0x1f5>
  8012c2:	83 fb 7e             	cmp    $0x7e,%ebx
  8012c5:	7e 12                	jle    8012d9 <vprintfmt+0x207>
					putch('?', putdat);
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	6a 3f                	push   $0x3f
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	ff d0                	call   *%eax
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	eb 0f                	jmp    8012e8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8012d9:	83 ec 08             	sub    $0x8,%esp
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	53                   	push   %ebx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	ff d0                	call   *%eax
  8012e5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012e8:	ff 4d e4             	decl   -0x1c(%ebp)
  8012eb:	89 f0                	mov    %esi,%eax
  8012ed:	8d 70 01             	lea    0x1(%eax),%esi
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	0f be d8             	movsbl %al,%ebx
  8012f5:	85 db                	test   %ebx,%ebx
  8012f7:	74 24                	je     80131d <vprintfmt+0x24b>
  8012f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012fd:	78 b8                	js     8012b7 <vprintfmt+0x1e5>
  8012ff:	ff 4d e0             	decl   -0x20(%ebp)
  801302:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801306:	79 af                	jns    8012b7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801308:	eb 13                	jmp    80131d <vprintfmt+0x24b>
				putch(' ', putdat);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	6a 20                	push   $0x20
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80131a:	ff 4d e4             	decl   -0x1c(%ebp)
  80131d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801321:	7f e7                	jg     80130a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801323:	e9 66 01 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801328:	83 ec 08             	sub    $0x8,%esp
  80132b:	ff 75 e8             	pushl  -0x18(%ebp)
  80132e:	8d 45 14             	lea    0x14(%ebp),%eax
  801331:	50                   	push   %eax
  801332:	e8 3c fd ff ff       	call   801073 <getint>
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80133d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801343:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801346:	85 d2                	test   %edx,%edx
  801348:	79 23                	jns    80136d <vprintfmt+0x29b>
				putch('-', putdat);
  80134a:	83 ec 08             	sub    $0x8,%esp
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	6a 2d                	push   $0x2d
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	ff d0                	call   *%eax
  801357:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801360:	f7 d8                	neg    %eax
  801362:	83 d2 00             	adc    $0x0,%edx
  801365:	f7 da                	neg    %edx
  801367:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80136a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80136d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801374:	e9 bc 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801379:	83 ec 08             	sub    $0x8,%esp
  80137c:	ff 75 e8             	pushl  -0x18(%ebp)
  80137f:	8d 45 14             	lea    0x14(%ebp),%eax
  801382:	50                   	push   %eax
  801383:	e8 84 fc ff ff       	call   80100c <getuint>
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80138e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801391:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801398:	e9 98 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80139d:	83 ec 08             	sub    $0x8,%esp
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	6a 58                	push   $0x58
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	ff d0                	call   *%eax
  8013aa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	ff 75 0c             	pushl  0xc(%ebp)
  8013b3:	6a 58                	push   $0x58
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	ff d0                	call   *%eax
  8013ba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	6a 58                	push   $0x58
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	ff d0                	call   *%eax
  8013ca:	83 c4 10             	add    $0x10,%esp
			break;
  8013cd:	e9 bc 00 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8013d2:	83 ec 08             	sub    $0x8,%esp
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	6a 30                	push   $0x30
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	ff d0                	call   *%eax
  8013df:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	ff 75 0c             	pushl  0xc(%ebp)
  8013e8:	6a 78                	push   $0x78
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	ff d0                	call   *%eax
  8013ef:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8013f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f5:	83 c0 04             	add    $0x4,%eax
  8013f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8013fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fe:	83 e8 04             	sub    $0x4,%eax
  801401:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801403:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80140d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801414:	eb 1f                	jmp    801435 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	ff 75 e8             	pushl  -0x18(%ebp)
  80141c:	8d 45 14             	lea    0x14(%ebp),%eax
  80141f:	50                   	push   %eax
  801420:	e8 e7 fb ff ff       	call   80100c <getuint>
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80142b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80142e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801435:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	52                   	push   %edx
  801440:	ff 75 e4             	pushl  -0x1c(%ebp)
  801443:	50                   	push   %eax
  801444:	ff 75 f4             	pushl  -0xc(%ebp)
  801447:	ff 75 f0             	pushl  -0x10(%ebp)
  80144a:	ff 75 0c             	pushl  0xc(%ebp)
  80144d:	ff 75 08             	pushl  0x8(%ebp)
  801450:	e8 00 fb ff ff       	call   800f55 <printnum>
  801455:	83 c4 20             	add    $0x20,%esp
			break;
  801458:	eb 34                	jmp    80148e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80145a:	83 ec 08             	sub    $0x8,%esp
  80145d:	ff 75 0c             	pushl  0xc(%ebp)
  801460:	53                   	push   %ebx
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	ff d0                	call   *%eax
  801466:	83 c4 10             	add    $0x10,%esp
			break;
  801469:	eb 23                	jmp    80148e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	6a 25                	push   $0x25
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	ff d0                	call   *%eax
  801478:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80147b:	ff 4d 10             	decl   0x10(%ebp)
  80147e:	eb 03                	jmp    801483 <vprintfmt+0x3b1>
  801480:	ff 4d 10             	decl   0x10(%ebp)
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	48                   	dec    %eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	3c 25                	cmp    $0x25,%al
  80148b:	75 f3                	jne    801480 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80148d:	90                   	nop
		}
	}
  80148e:	e9 47 fc ff ff       	jmp    8010da <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801493:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801494:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801497:	5b                   	pop    %ebx
  801498:	5e                   	pop    %esi
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    

0080149b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8014a4:	83 c0 04             	add    $0x4,%eax
  8014a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b0:	50                   	push   %eax
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	ff 75 08             	pushl  0x8(%ebp)
  8014b7:	e8 16 fc ff ff       	call   8010d2 <vprintfmt>
  8014bc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014bf:	90                   	nop
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	8b 40 08             	mov    0x8(%eax),%eax
  8014cb:	8d 50 01             	lea    0x1(%eax),%edx
  8014ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8014d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d7:	8b 10                	mov    (%eax),%edx
  8014d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dc:	8b 40 04             	mov    0x4(%eax),%eax
  8014df:	39 c2                	cmp    %eax,%edx
  8014e1:	73 12                	jae    8014f5 <sprintputch+0x33>
		*b->buf++ = ch;
  8014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	8d 48 01             	lea    0x1(%eax),%ecx
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	89 0a                	mov    %ecx,(%edx)
  8014f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f3:	88 10                	mov    %dl,(%eax)
}
  8014f5:	90                   	nop
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    

008014f8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	01 d0                	add    %edx,%eax
  80150f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801512:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801519:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80151d:	74 06                	je     801525 <vsnprintf+0x2d>
  80151f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801523:	7f 07                	jg     80152c <vsnprintf+0x34>
		return -E_INVAL;
  801525:	b8 03 00 00 00       	mov    $0x3,%eax
  80152a:	eb 20                	jmp    80154c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80152c:	ff 75 14             	pushl  0x14(%ebp)
  80152f:	ff 75 10             	pushl  0x10(%ebp)
  801532:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801535:	50                   	push   %eax
  801536:	68 c2 14 80 00       	push   $0x8014c2
  80153b:	e8 92 fb ff ff       	call   8010d2 <vprintfmt>
  801540:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801546:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801554:	8d 45 10             	lea    0x10(%ebp),%eax
  801557:	83 c0 04             	add    $0x4,%eax
  80155a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80155d:	8b 45 10             	mov    0x10(%ebp),%eax
  801560:	ff 75 f4             	pushl  -0xc(%ebp)
  801563:	50                   	push   %eax
  801564:	ff 75 0c             	pushl  0xc(%ebp)
  801567:	ff 75 08             	pushl  0x8(%ebp)
  80156a:	e8 89 ff ff ff       	call   8014f8 <vsnprintf>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801575:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801580:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801587:	eb 06                	jmp    80158f <strlen+0x15>
		n++;
  801589:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80158c:	ff 45 08             	incl   0x8(%ebp)
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	84 c0                	test   %al,%al
  801596:	75 f1                	jne    801589 <strlen+0xf>
		n++;
	return n;
  801598:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015aa:	eb 09                	jmp    8015b5 <strnlen+0x18>
		n++;
  8015ac:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	ff 4d 0c             	decl   0xc(%ebp)
  8015b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b9:	74 09                	je     8015c4 <strnlen+0x27>
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	84 c0                	test   %al,%al
  8015c2:	75 e8                	jne    8015ac <strnlen+0xf>
		n++;
	return n;
  8015c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015d5:	90                   	nop
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	8d 50 01             	lea    0x1(%eax),%edx
  8015dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8015df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015e5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015e8:	8a 12                	mov    (%edx),%dl
  8015ea:	88 10                	mov    %dl,(%eax)
  8015ec:	8a 00                	mov    (%eax),%al
  8015ee:	84 c0                	test   %al,%al
  8015f0:	75 e4                	jne    8015d6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80160a:	eb 1f                	jmp    80162b <strncpy+0x34>
		*dst++ = *src;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8d 50 01             	lea    0x1(%eax),%edx
  801612:	89 55 08             	mov    %edx,0x8(%ebp)
  801615:	8b 55 0c             	mov    0xc(%ebp),%edx
  801618:	8a 12                	mov    (%edx),%dl
  80161a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	8a 00                	mov    (%eax),%al
  801621:	84 c0                	test   %al,%al
  801623:	74 03                	je     801628 <strncpy+0x31>
			src++;
  801625:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801628:	ff 45 fc             	incl   -0x4(%ebp)
  80162b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801631:	72 d9                	jb     80160c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801633:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801644:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801648:	74 30                	je     80167a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80164a:	eb 16                	jmp    801662 <strlcpy+0x2a>
			*dst++ = *src++;
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8d 50 01             	lea    0x1(%eax),%edx
  801652:	89 55 08             	mov    %edx,0x8(%ebp)
  801655:	8b 55 0c             	mov    0xc(%ebp),%edx
  801658:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80165e:	8a 12                	mov    (%edx),%dl
  801660:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801662:	ff 4d 10             	decl   0x10(%ebp)
  801665:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801669:	74 09                	je     801674 <strlcpy+0x3c>
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	84 c0                	test   %al,%al
  801672:	75 d8                	jne    80164c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80167a:	8b 55 08             	mov    0x8(%ebp),%edx
  80167d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801680:	29 c2                	sub    %eax,%edx
  801682:	89 d0                	mov    %edx,%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801689:	eb 06                	jmp    801691 <strcmp+0xb>
		p++, q++;
  80168b:	ff 45 08             	incl   0x8(%ebp)
  80168e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8a 00                	mov    (%eax),%al
  801696:	84 c0                	test   %al,%al
  801698:	74 0e                	je     8016a8 <strcmp+0x22>
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 10                	mov    (%eax),%dl
  80169f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	38 c2                	cmp    %al,%dl
  8016a6:	74 e3                	je     80168b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	0f b6 d0             	movzbl %al,%edx
  8016b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b3:	8a 00                	mov    (%eax),%al
  8016b5:	0f b6 c0             	movzbl %al,%eax
  8016b8:	29 c2                	sub    %eax,%edx
  8016ba:	89 d0                	mov    %edx,%eax
}
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016c1:	eb 09                	jmp    8016cc <strncmp+0xe>
		n--, p++, q++;
  8016c3:	ff 4d 10             	decl   0x10(%ebp)
  8016c6:	ff 45 08             	incl   0x8(%ebp)
  8016c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d0:	74 17                	je     8016e9 <strncmp+0x2b>
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8a 00                	mov    (%eax),%al
  8016d7:	84 c0                	test   %al,%al
  8016d9:	74 0e                	je     8016e9 <strncmp+0x2b>
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8a 10                	mov    (%eax),%dl
  8016e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	38 c2                	cmp    %al,%dl
  8016e7:	74 da                	je     8016c3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ed:	75 07                	jne    8016f6 <strncmp+0x38>
		return 0;
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f4:	eb 14                	jmp    80170a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	0f b6 d0             	movzbl %al,%edx
  8016fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801701:	8a 00                	mov    (%eax),%al
  801703:	0f b6 c0             	movzbl %al,%eax
  801706:	29 c2                	sub    %eax,%edx
  801708:	89 d0                	mov    %edx,%eax
}
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    

0080170c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	8b 45 0c             	mov    0xc(%ebp),%eax
  801715:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801718:	eb 12                	jmp    80172c <strchr+0x20>
		if (*s == c)
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801722:	75 05                	jne    801729 <strchr+0x1d>
			return (char *) s;
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	eb 11                	jmp    80173a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801729:	ff 45 08             	incl   0x8(%ebp)
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	84 c0                	test   %al,%al
  801733:	75 e5                	jne    80171a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	8b 45 0c             	mov    0xc(%ebp),%eax
  801745:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801748:	eb 0d                	jmp    801757 <strfind+0x1b>
		if (*s == c)
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8a 00                	mov    (%eax),%al
  80174f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801752:	74 0e                	je     801762 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801754:	ff 45 08             	incl   0x8(%ebp)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	75 ea                	jne    80174a <strfind+0xe>
  801760:	eb 01                	jmp    801763 <strfind+0x27>
		if (*s == c)
			break;
  801762:	90                   	nop
	return (char *) s;
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801774:	8b 45 10             	mov    0x10(%ebp),%eax
  801777:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80177a:	eb 0e                	jmp    80178a <memset+0x22>
		*p++ = c;
  80177c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177f:	8d 50 01             	lea    0x1(%eax),%edx
  801782:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801785:	8b 55 0c             	mov    0xc(%ebp),%edx
  801788:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80178a:	ff 4d f8             	decl   -0x8(%ebp)
  80178d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801791:	79 e9                	jns    80177c <memset+0x14>
		*p++ = c;

	return v;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80179e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017aa:	eb 16                	jmp    8017c2 <memcpy+0x2a>
		*d++ = *s++;
  8017ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017af:	8d 50 01             	lea    0x1(%eax),%edx
  8017b2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017bb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017be:	8a 12                	mov    (%edx),%dl
  8017c0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	75 dd                	jne    8017ac <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017ec:	73 50                	jae    80183e <memmove+0x6a>
  8017ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f4:	01 d0                	add    %edx,%eax
  8017f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017f9:	76 43                	jbe    80183e <memmove+0x6a>
		s += n;
  8017fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fe:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801801:	8b 45 10             	mov    0x10(%ebp),%eax
  801804:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801807:	eb 10                	jmp    801819 <memmove+0x45>
			*--d = *--s;
  801809:	ff 4d f8             	decl   -0x8(%ebp)
  80180c:	ff 4d fc             	decl   -0x4(%ebp)
  80180f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801812:	8a 10                	mov    (%eax),%dl
  801814:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801817:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801819:	8b 45 10             	mov    0x10(%ebp),%eax
  80181c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80181f:	89 55 10             	mov    %edx,0x10(%ebp)
  801822:	85 c0                	test   %eax,%eax
  801824:	75 e3                	jne    801809 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801826:	eb 23                	jmp    80184b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801828:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8d 4a 01             	lea    0x1(%edx),%ecx
  801837:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80183a:	8a 12                	mov    (%edx),%dl
  80183c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	8d 50 ff             	lea    -0x1(%eax),%edx
  801844:	89 55 10             	mov    %edx,0x10(%ebp)
  801847:	85 c0                	test   %eax,%eax
  801849:	75 dd                	jne    801828 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801862:	eb 2a                	jmp    80188e <memcmp+0x3e>
		if (*s1 != *s2)
  801864:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801867:	8a 10                	mov    (%eax),%dl
  801869:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	38 c2                	cmp    %al,%dl
  801870:	74 16                	je     801888 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801872:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801875:	8a 00                	mov    (%eax),%al
  801877:	0f b6 d0             	movzbl %al,%edx
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	8a 00                	mov    (%eax),%al
  80187f:	0f b6 c0             	movzbl %al,%eax
  801882:	29 c2                	sub    %eax,%edx
  801884:	89 d0                	mov    %edx,%eax
  801886:	eb 18                	jmp    8018a0 <memcmp+0x50>
		s1++, s2++;
  801888:	ff 45 fc             	incl   -0x4(%ebp)
  80188b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	8d 50 ff             	lea    -0x1(%eax),%edx
  801894:	89 55 10             	mov    %edx,0x10(%ebp)
  801897:	85 c0                	test   %eax,%eax
  801899:	75 c9                	jne    801864 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018b3:	eb 15                	jmp    8018ca <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c0:	0f b6 c0             	movzbl %al,%eax
  8018c3:	39 c2                	cmp    %eax,%edx
  8018c5:	74 0d                	je     8018d4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018c7:	ff 45 08             	incl   0x8(%ebp)
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018d0:	72 e3                	jb     8018b5 <memfind+0x13>
  8018d2:	eb 01                	jmp    8018d5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018d4:	90                   	nop
	return (void *) s;
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018ee:	eb 03                	jmp    8018f3 <strtol+0x19>
		s++;
  8018f0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8a 00                	mov    (%eax),%al
  8018f8:	3c 20                	cmp    $0x20,%al
  8018fa:	74 f4                	je     8018f0 <strtol+0x16>
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	8a 00                	mov    (%eax),%al
  801901:	3c 09                	cmp    $0x9,%al
  801903:	74 eb                	je     8018f0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	3c 2b                	cmp    $0x2b,%al
  80190c:	75 05                	jne    801913 <strtol+0x39>
		s++;
  80190e:	ff 45 08             	incl   0x8(%ebp)
  801911:	eb 13                	jmp    801926 <strtol+0x4c>
	else if (*s == '-')
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8a 00                	mov    (%eax),%al
  801918:	3c 2d                	cmp    $0x2d,%al
  80191a:	75 0a                	jne    801926 <strtol+0x4c>
		s++, neg = 1;
  80191c:	ff 45 08             	incl   0x8(%ebp)
  80191f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801926:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80192a:	74 06                	je     801932 <strtol+0x58>
  80192c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801930:	75 20                	jne    801952 <strtol+0x78>
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	3c 30                	cmp    $0x30,%al
  801939:	75 17                	jne    801952 <strtol+0x78>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	40                   	inc    %eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	3c 78                	cmp    $0x78,%al
  801943:	75 0d                	jne    801952 <strtol+0x78>
		s += 2, base = 16;
  801945:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801949:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801950:	eb 28                	jmp    80197a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801952:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801956:	75 15                	jne    80196d <strtol+0x93>
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	8a 00                	mov    (%eax),%al
  80195d:	3c 30                	cmp    $0x30,%al
  80195f:	75 0c                	jne    80196d <strtol+0x93>
		s++, base = 8;
  801961:	ff 45 08             	incl   0x8(%ebp)
  801964:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80196b:	eb 0d                	jmp    80197a <strtol+0xa0>
	else if (base == 0)
  80196d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801971:	75 07                	jne    80197a <strtol+0xa0>
		base = 10;
  801973:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	8a 00                	mov    (%eax),%al
  80197f:	3c 2f                	cmp    $0x2f,%al
  801981:	7e 19                	jle    80199c <strtol+0xc2>
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8a 00                	mov    (%eax),%al
  801988:	3c 39                	cmp    $0x39,%al
  80198a:	7f 10                	jg     80199c <strtol+0xc2>
			dig = *s - '0';
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8a 00                	mov    (%eax),%al
  801991:	0f be c0             	movsbl %al,%eax
  801994:	83 e8 30             	sub    $0x30,%eax
  801997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80199a:	eb 42                	jmp    8019de <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	8a 00                	mov    (%eax),%al
  8019a1:	3c 60                	cmp    $0x60,%al
  8019a3:	7e 19                	jle    8019be <strtol+0xe4>
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	8a 00                	mov    (%eax),%al
  8019aa:	3c 7a                	cmp    $0x7a,%al
  8019ac:	7f 10                	jg     8019be <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8a 00                	mov    (%eax),%al
  8019b3:	0f be c0             	movsbl %al,%eax
  8019b6:	83 e8 57             	sub    $0x57,%eax
  8019b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019bc:	eb 20                	jmp    8019de <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 40                	cmp    $0x40,%al
  8019c5:	7e 39                	jle    801a00 <strtol+0x126>
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8a 00                	mov    (%eax),%al
  8019cc:	3c 5a                	cmp    $0x5a,%al
  8019ce:	7f 30                	jg     801a00 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	8a 00                	mov    (%eax),%al
  8019d5:	0f be c0             	movsbl %al,%eax
  8019d8:	83 e8 37             	sub    $0x37,%eax
  8019db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019e4:	7d 19                	jge    8019ff <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019e6:	ff 45 08             	incl   0x8(%ebp)
  8019e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ec:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019f0:	89 c2                	mov    %eax,%edx
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	01 d0                	add    %edx,%eax
  8019f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019fa:	e9 7b ff ff ff       	jmp    80197a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019ff:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a04:	74 08                	je     801a0e <strtol+0x134>
		*endptr = (char *) s;
  801a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a09:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a12:	74 07                	je     801a1b <strtol+0x141>
  801a14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a17:	f7 d8                	neg    %eax
  801a19:	eb 03                	jmp    801a1e <strtol+0x144>
  801a1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <ltostr>:

void
ltostr(long value, char *str)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a2d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a38:	79 13                	jns    801a4d <ltostr+0x2d>
	{
		neg = 1;
  801a3a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a44:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a47:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a4a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a55:	99                   	cltd   
  801a56:	f7 f9                	idiv   %ecx
  801a58:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	8d 50 01             	lea    0x1(%eax),%edx
  801a61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a64:	89 c2                	mov    %eax,%edx
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a6e:	83 c2 30             	add    $0x30,%edx
  801a71:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a76:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a7b:	f7 e9                	imul   %ecx
  801a7d:	c1 fa 02             	sar    $0x2,%edx
  801a80:	89 c8                	mov    %ecx,%eax
  801a82:	c1 f8 1f             	sar    $0x1f,%eax
  801a85:	29 c2                	sub    %eax,%edx
  801a87:	89 d0                	mov    %edx,%eax
  801a89:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801a8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a8f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a94:	f7 e9                	imul   %ecx
  801a96:	c1 fa 02             	sar    $0x2,%edx
  801a99:	89 c8                	mov    %ecx,%eax
  801a9b:	c1 f8 1f             	sar    $0x1f,%eax
  801a9e:	29 c2                	sub    %eax,%edx
  801aa0:	89 d0                	mov    %edx,%eax
  801aa2:	c1 e0 02             	shl    $0x2,%eax
  801aa5:	01 d0                	add    %edx,%eax
  801aa7:	01 c0                	add    %eax,%eax
  801aa9:	29 c1                	sub    %eax,%ecx
  801aab:	89 ca                	mov    %ecx,%edx
  801aad:	85 d2                	test   %edx,%edx
  801aaf:	75 9c                	jne    801a4d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801ab1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ab8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abb:	48                   	dec    %eax
  801abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801abf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ac3:	74 3d                	je     801b02 <ltostr+0xe2>
		start = 1 ;
  801ac5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801acc:	eb 34                	jmp    801b02 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad4:	01 d0                	add    %edx,%eax
  801ad6:	8a 00                	mov    (%eax),%al
  801ad8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae1:	01 c2                	add    %eax,%edx
  801ae3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae9:	01 c8                	add    %ecx,%eax
  801aeb:	8a 00                	mov    (%eax),%al
  801aed:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801aef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af5:	01 c2                	add    %eax,%edx
  801af7:	8a 45 eb             	mov    -0x15(%ebp),%al
  801afa:	88 02                	mov    %al,(%edx)
		start++ ;
  801afc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801aff:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b08:	7c c4                	jl     801ace <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b0a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b10:	01 d0                	add    %edx,%eax
  801b12:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b15:	90                   	nop
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b1e:	ff 75 08             	pushl  0x8(%ebp)
  801b21:	e8 54 fa ff ff       	call   80157a <strlen>
  801b26:	83 c4 04             	add    $0x4,%esp
  801b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	e8 46 fa ff ff       	call   80157a <strlen>
  801b34:	83 c4 04             	add    $0x4,%esp
  801b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b48:	eb 17                	jmp    801b61 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b50:	01 c2                	add    %eax,%edx
  801b52:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	01 c8                	add    %ecx,%eax
  801b5a:	8a 00                	mov    (%eax),%al
  801b5c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b5e:	ff 45 fc             	incl   -0x4(%ebp)
  801b61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b64:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b67:	7c e1                	jl     801b4a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b69:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b77:	eb 1f                	jmp    801b98 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b7c:	8d 50 01             	lea    0x1(%eax),%edx
  801b7f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b82:	89 c2                	mov    %eax,%edx
  801b84:	8b 45 10             	mov    0x10(%ebp),%eax
  801b87:	01 c2                	add    %eax,%edx
  801b89:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8f:	01 c8                	add    %ecx,%eax
  801b91:	8a 00                	mov    (%eax),%al
  801b93:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b95:	ff 45 f8             	incl   -0x8(%ebp)
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b9e:	7c d9                	jl     801b79 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ba0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba6:	01 d0                	add    %edx,%eax
  801ba8:	c6 00 00             	movb   $0x0,(%eax)
}
  801bab:	90                   	nop
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bba:	8b 45 14             	mov    0x14(%ebp),%eax
  801bbd:	8b 00                	mov    (%eax),%eax
  801bbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc9:	01 d0                	add    %edx,%eax
  801bcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bd1:	eb 0c                	jmp    801bdf <strsplit+0x31>
			*string++ = 0;
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	8d 50 01             	lea    0x1(%eax),%edx
  801bd9:	89 55 08             	mov    %edx,0x8(%ebp)
  801bdc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	8a 00                	mov    (%eax),%al
  801be4:	84 c0                	test   %al,%al
  801be6:	74 18                	je     801c00 <strsplit+0x52>
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	8a 00                	mov    (%eax),%al
  801bed:	0f be c0             	movsbl %al,%eax
  801bf0:	50                   	push   %eax
  801bf1:	ff 75 0c             	pushl  0xc(%ebp)
  801bf4:	e8 13 fb ff ff       	call   80170c <strchr>
  801bf9:	83 c4 08             	add    $0x8,%esp
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	75 d3                	jne    801bd3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	8a 00                	mov    (%eax),%al
  801c05:	84 c0                	test   %al,%al
  801c07:	74 5a                	je     801c63 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c09:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0c:	8b 00                	mov    (%eax),%eax
  801c0e:	83 f8 0f             	cmp    $0xf,%eax
  801c11:	75 07                	jne    801c1a <strsplit+0x6c>
		{
			return 0;
  801c13:	b8 00 00 00 00       	mov    $0x0,%eax
  801c18:	eb 66                	jmp    801c80 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1d:	8b 00                	mov    (%eax),%eax
  801c1f:	8d 48 01             	lea    0x1(%eax),%ecx
  801c22:	8b 55 14             	mov    0x14(%ebp),%edx
  801c25:	89 0a                	mov    %ecx,(%edx)
  801c27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c31:	01 c2                	add    %eax,%edx
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c38:	eb 03                	jmp    801c3d <strsplit+0x8f>
			string++;
  801c3a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	8a 00                	mov    (%eax),%al
  801c42:	84 c0                	test   %al,%al
  801c44:	74 8b                	je     801bd1 <strsplit+0x23>
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	8a 00                	mov    (%eax),%al
  801c4b:	0f be c0             	movsbl %al,%eax
  801c4e:	50                   	push   %eax
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	e8 b5 fa ff ff       	call   80170c <strchr>
  801c57:	83 c4 08             	add    $0x8,%esp
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	74 dc                	je     801c3a <strsplit+0x8c>
			string++;
	}
  801c5e:	e9 6e ff ff ff       	jmp    801bd1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c63:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	8b 00                	mov    (%eax),%eax
  801c69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c70:	8b 45 10             	mov    0x10(%ebp),%eax
  801c73:	01 d0                	add    %edx,%eax
  801c75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c7b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801c88:	a1 04 50 80 00       	mov    0x805004,%eax
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	74 1f                	je     801cb0 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801c91:	e8 1d 00 00 00       	call   801cb3 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801c96:	83 ec 0c             	sub    $0xc,%esp
  801c99:	68 70 42 80 00       	push   $0x804270
  801c9e:	e8 55 f2 ff ff       	call   800ef8 <cprintf>
  801ca3:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801ca6:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801cad:	00 00 00 
	}
}
  801cb0:	90                   	nop
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801cb9:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801cc0:	00 00 00 
  801cc3:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801cca:	00 00 00 
  801ccd:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801cd4:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801cd7:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801cde:	00 00 00 
  801ce1:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801ce8:	00 00 00 
  801ceb:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801cf2:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801cf5:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d04:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d09:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801d0e:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801d15:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801d18:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d22:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801d27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d32:	f7 75 f0             	divl   -0x10(%ebp)
  801d35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d38:	29 d0                	sub    %edx,%eax
  801d3a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801d3d:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801d44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d4c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d51:	83 ec 04             	sub    $0x4,%esp
  801d54:	6a 06                	push   $0x6
  801d56:	ff 75 e8             	pushl  -0x18(%ebp)
  801d59:	50                   	push   %eax
  801d5a:	e8 d4 05 00 00       	call   802333 <sys_allocate_chunk>
  801d5f:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801d62:	a1 20 51 80 00       	mov    0x805120,%eax
  801d67:	83 ec 0c             	sub    $0xc,%esp
  801d6a:	50                   	push   %eax
  801d6b:	e8 49 0c 00 00       	call   8029b9 <initialize_MemBlocksList>
  801d70:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801d73:	a1 48 51 80 00       	mov    0x805148,%eax
  801d78:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801d7b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d7f:	75 14                	jne    801d95 <initialize_dyn_block_system+0xe2>
  801d81:	83 ec 04             	sub    $0x4,%esp
  801d84:	68 95 42 80 00       	push   $0x804295
  801d89:	6a 39                	push   $0x39
  801d8b:	68 b3 42 80 00       	push   $0x8042b3
  801d90:	e8 af ee ff ff       	call   800c44 <_panic>
  801d95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d98:	8b 00                	mov    (%eax),%eax
  801d9a:	85 c0                	test   %eax,%eax
  801d9c:	74 10                	je     801dae <initialize_dyn_block_system+0xfb>
  801d9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801da1:	8b 00                	mov    (%eax),%eax
  801da3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801da6:	8b 52 04             	mov    0x4(%edx),%edx
  801da9:	89 50 04             	mov    %edx,0x4(%eax)
  801dac:	eb 0b                	jmp    801db9 <initialize_dyn_block_system+0x106>
  801dae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801db1:	8b 40 04             	mov    0x4(%eax),%eax
  801db4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801db9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dbc:	8b 40 04             	mov    0x4(%eax),%eax
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	74 0f                	je     801dd2 <initialize_dyn_block_system+0x11f>
  801dc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dc6:	8b 40 04             	mov    0x4(%eax),%eax
  801dc9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dcc:	8b 12                	mov    (%edx),%edx
  801dce:	89 10                	mov    %edx,(%eax)
  801dd0:	eb 0a                	jmp    801ddc <initialize_dyn_block_system+0x129>
  801dd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dd5:	8b 00                	mov    (%eax),%eax
  801dd7:	a3 48 51 80 00       	mov    %eax,0x805148
  801ddc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ddf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801de5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801def:	a1 54 51 80 00       	mov    0x805154,%eax
  801df4:	48                   	dec    %eax
  801df5:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801dfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dfd:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801e04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e07:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801e0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e12:	75 14                	jne    801e28 <initialize_dyn_block_system+0x175>
  801e14:	83 ec 04             	sub    $0x4,%esp
  801e17:	68 c0 42 80 00       	push   $0x8042c0
  801e1c:	6a 3f                	push   $0x3f
  801e1e:	68 b3 42 80 00       	push   $0x8042b3
  801e23:	e8 1c ee ff ff       	call   800c44 <_panic>
  801e28:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801e2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e31:	89 10                	mov    %edx,(%eax)
  801e33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e36:	8b 00                	mov    (%eax),%eax
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	74 0d                	je     801e49 <initialize_dyn_block_system+0x196>
  801e3c:	a1 38 51 80 00       	mov    0x805138,%eax
  801e41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e44:	89 50 04             	mov    %edx,0x4(%eax)
  801e47:	eb 08                	jmp    801e51 <initialize_dyn_block_system+0x19e>
  801e49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e4c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801e51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e54:	a3 38 51 80 00       	mov    %eax,0x805138
  801e59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e63:	a1 44 51 80 00       	mov    0x805144,%eax
  801e68:	40                   	inc    %eax
  801e69:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801e6e:	90                   	nop
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e77:	e8 06 fe ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e80:	75 07                	jne    801e89 <malloc+0x18>
  801e82:	b8 00 00 00 00       	mov    $0x0,%eax
  801e87:	eb 7d                	jmp    801f06 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801e89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801e90:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e97:	8b 55 08             	mov    0x8(%ebp),%edx
  801e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9d:	01 d0                	add    %edx,%eax
  801e9f:	48                   	dec    %eax
  801ea0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ea3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea6:	ba 00 00 00 00       	mov    $0x0,%edx
  801eab:	f7 75 f0             	divl   -0x10(%ebp)
  801eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eb1:	29 d0                	sub    %edx,%eax
  801eb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801eb6:	e8 46 08 00 00       	call   802701 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ebb:	83 f8 01             	cmp    $0x1,%eax
  801ebe:	75 07                	jne    801ec7 <malloc+0x56>
  801ec0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801ec7:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801ecb:	75 34                	jne    801f01 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801ecd:	83 ec 0c             	sub    $0xc,%esp
  801ed0:	ff 75 e8             	pushl  -0x18(%ebp)
  801ed3:	e8 73 0e 00 00       	call   802d4b <alloc_block_FF>
  801ed8:	83 c4 10             	add    $0x10,%esp
  801edb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801ede:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ee2:	74 16                	je     801efa <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801ee4:	83 ec 0c             	sub    $0xc,%esp
  801ee7:	ff 75 e4             	pushl  -0x1c(%ebp)
  801eea:	e8 ff 0b 00 00       	call   802aee <insert_sorted_allocList>
  801eef:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801ef2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ef5:	8b 40 08             	mov    0x8(%eax),%eax
  801ef8:	eb 0c                	jmp    801f06 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801efa:	b8 00 00 00 00       	mov    $0x0,%eax
  801eff:	eb 05                	jmp    801f06 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801f01:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f22:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801f25:	83 ec 08             	sub    $0x8,%esp
  801f28:	ff 75 f4             	pushl  -0xc(%ebp)
  801f2b:	68 40 50 80 00       	push   $0x805040
  801f30:	e8 61 0b 00 00       	call   802a96 <find_block>
  801f35:	83 c4 10             	add    $0x10,%esp
  801f38:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801f3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f3f:	0f 84 a5 00 00 00    	je     801fea <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801f45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f48:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4b:	83 ec 08             	sub    $0x8,%esp
  801f4e:	50                   	push   %eax
  801f4f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f52:	e8 a4 03 00 00       	call   8022fb <sys_free_user_mem>
  801f57:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801f5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f5e:	75 17                	jne    801f77 <free+0x6f>
  801f60:	83 ec 04             	sub    $0x4,%esp
  801f63:	68 95 42 80 00       	push   $0x804295
  801f68:	68 87 00 00 00       	push   $0x87
  801f6d:	68 b3 42 80 00       	push   $0x8042b3
  801f72:	e8 cd ec ff ff       	call   800c44 <_panic>
  801f77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f7a:	8b 00                	mov    (%eax),%eax
  801f7c:	85 c0                	test   %eax,%eax
  801f7e:	74 10                	je     801f90 <free+0x88>
  801f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f83:	8b 00                	mov    (%eax),%eax
  801f85:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f88:	8b 52 04             	mov    0x4(%edx),%edx
  801f8b:	89 50 04             	mov    %edx,0x4(%eax)
  801f8e:	eb 0b                	jmp    801f9b <free+0x93>
  801f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f93:	8b 40 04             	mov    0x4(%eax),%eax
  801f96:	a3 44 50 80 00       	mov    %eax,0x805044
  801f9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f9e:	8b 40 04             	mov    0x4(%eax),%eax
  801fa1:	85 c0                	test   %eax,%eax
  801fa3:	74 0f                	je     801fb4 <free+0xac>
  801fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa8:	8b 40 04             	mov    0x4(%eax),%eax
  801fab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fae:	8b 12                	mov    (%edx),%edx
  801fb0:	89 10                	mov    %edx,(%eax)
  801fb2:	eb 0a                	jmp    801fbe <free+0xb6>
  801fb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb7:	8b 00                	mov    (%eax),%eax
  801fb9:	a3 40 50 80 00       	mov    %eax,0x805040
  801fbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fd1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801fd6:	48                   	dec    %eax
  801fd7:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801fdc:	83 ec 0c             	sub    $0xc,%esp
  801fdf:	ff 75 ec             	pushl  -0x14(%ebp)
  801fe2:	e8 37 12 00 00       	call   80321e <insert_sorted_with_merge_freeList>
  801fe7:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801fea:	90                   	nop
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
  801ff0:	83 ec 38             	sub    $0x38,%esp
  801ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff6:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ff9:	e8 84 fc ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ffe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802002:	75 07                	jne    80200b <smalloc+0x1e>
  802004:	b8 00 00 00 00       	mov    $0x0,%eax
  802009:	eb 7e                	jmp    802089 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  80200b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  802012:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802019:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201f:	01 d0                	add    %edx,%eax
  802021:	48                   	dec    %eax
  802022:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802028:	ba 00 00 00 00       	mov    $0x0,%edx
  80202d:	f7 75 f0             	divl   -0x10(%ebp)
  802030:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802033:	29 d0                	sub    %edx,%eax
  802035:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  802038:	e8 c4 06 00 00       	call   802701 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80203d:	83 f8 01             	cmp    $0x1,%eax
  802040:	75 42                	jne    802084 <smalloc+0x97>

		  va = malloc(newsize) ;
  802042:	83 ec 0c             	sub    $0xc,%esp
  802045:	ff 75 e8             	pushl  -0x18(%ebp)
  802048:	e8 24 fe ff ff       	call   801e71 <malloc>
  80204d:	83 c4 10             	add    $0x10,%esp
  802050:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  802053:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802057:	74 24                	je     80207d <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  802059:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80205d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802060:	50                   	push   %eax
  802061:	ff 75 e8             	pushl  -0x18(%ebp)
  802064:	ff 75 08             	pushl  0x8(%ebp)
  802067:	e8 1a 04 00 00       	call   802486 <sys_createSharedObject>
  80206c:	83 c4 10             	add    $0x10,%esp
  80206f:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  802072:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802076:	78 0c                	js     802084 <smalloc+0x97>
					  return va ;
  802078:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80207b:	eb 0c                	jmp    802089 <smalloc+0x9c>
				 }
				 else
					return NULL;
  80207d:	b8 00 00 00 00       	mov    $0x0,%eax
  802082:	eb 05                	jmp    802089 <smalloc+0x9c>
	  }
		  return NULL ;
  802084:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802091:	e8 ec fb ff ff       	call   801c82 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  802096:	83 ec 08             	sub    $0x8,%esp
  802099:	ff 75 0c             	pushl  0xc(%ebp)
  80209c:	ff 75 08             	pushl  0x8(%ebp)
  80209f:	e8 0c 04 00 00       	call   8024b0 <sys_getSizeOfSharedObject>
  8020a4:	83 c4 10             	add    $0x10,%esp
  8020a7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8020aa:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8020ae:	75 07                	jne    8020b7 <sget+0x2c>
  8020b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b5:	eb 75                	jmp    80212c <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8020b7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8020be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c4:	01 d0                	add    %edx,%eax
  8020c6:	48                   	dec    %eax
  8020c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8020d2:	f7 75 f0             	divl   -0x10(%ebp)
  8020d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d8:	29 d0                	sub    %edx,%eax
  8020da:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  8020dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8020e4:	e8 18 06 00 00       	call   802701 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020e9:	83 f8 01             	cmp    $0x1,%eax
  8020ec:	75 39                	jne    802127 <sget+0x9c>

		  va = malloc(newsize) ;
  8020ee:	83 ec 0c             	sub    $0xc,%esp
  8020f1:	ff 75 e8             	pushl  -0x18(%ebp)
  8020f4:	e8 78 fd ff ff       	call   801e71 <malloc>
  8020f9:	83 c4 10             	add    $0x10,%esp
  8020fc:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  8020ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802103:	74 22                	je     802127 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  802105:	83 ec 04             	sub    $0x4,%esp
  802108:	ff 75 e0             	pushl  -0x20(%ebp)
  80210b:	ff 75 0c             	pushl  0xc(%ebp)
  80210e:	ff 75 08             	pushl  0x8(%ebp)
  802111:	e8 b7 03 00 00       	call   8024cd <sys_getSharedObject>
  802116:	83 c4 10             	add    $0x10,%esp
  802119:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  80211c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802120:	78 05                	js     802127 <sget+0x9c>
					  return va;
  802122:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802125:	eb 05                	jmp    80212c <sget+0xa1>
				  }
			  }
     }
         return NULL;
  802127:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802134:	e8 49 fb ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802139:	83 ec 04             	sub    $0x4,%esp
  80213c:	68 e4 42 80 00       	push   $0x8042e4
  802141:	68 1e 01 00 00       	push   $0x11e
  802146:	68 b3 42 80 00       	push   $0x8042b3
  80214b:	e8 f4 ea ff ff       	call   800c44 <_panic>

00802150 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802156:	83 ec 04             	sub    $0x4,%esp
  802159:	68 0c 43 80 00       	push   $0x80430c
  80215e:	68 32 01 00 00       	push   $0x132
  802163:	68 b3 42 80 00       	push   $0x8042b3
  802168:	e8 d7 ea ff ff       	call   800c44 <_panic>

0080216d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802173:	83 ec 04             	sub    $0x4,%esp
  802176:	68 30 43 80 00       	push   $0x804330
  80217b:	68 3d 01 00 00       	push   $0x13d
  802180:	68 b3 42 80 00       	push   $0x8042b3
  802185:	e8 ba ea ff ff       	call   800c44 <_panic>

0080218a <shrink>:

}
void shrink(uint32 newSize)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802190:	83 ec 04             	sub    $0x4,%esp
  802193:	68 30 43 80 00       	push   $0x804330
  802198:	68 42 01 00 00       	push   $0x142
  80219d:	68 b3 42 80 00       	push   $0x8042b3
  8021a2:	e8 9d ea ff ff       	call   800c44 <_panic>

008021a7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021ad:	83 ec 04             	sub    $0x4,%esp
  8021b0:	68 30 43 80 00       	push   $0x804330
  8021b5:	68 47 01 00 00       	push   $0x147
  8021ba:	68 b3 42 80 00       	push   $0x8042b3
  8021bf:	e8 80 ea ff ff       	call   800c44 <_panic>

008021c4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
  8021c7:	57                   	push   %edi
  8021c8:	56                   	push   %esi
  8021c9:	53                   	push   %ebx
  8021ca:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021d6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021d9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021dc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021df:	cd 30                	int    $0x30
  8021e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021e7:	83 c4 10             	add    $0x10,%esp
  8021ea:	5b                   	pop    %ebx
  8021eb:	5e                   	pop    %esi
  8021ec:	5f                   	pop    %edi
  8021ed:	5d                   	pop    %ebp
  8021ee:	c3                   	ret    

008021ef <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
  8021f2:	83 ec 04             	sub    $0x4,%esp
  8021f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8021fb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	52                   	push   %edx
  802207:	ff 75 0c             	pushl  0xc(%ebp)
  80220a:	50                   	push   %eax
  80220b:	6a 00                	push   $0x0
  80220d:	e8 b2 ff ff ff       	call   8021c4 <syscall>
  802212:	83 c4 18             	add    $0x18,%esp
}
  802215:	90                   	nop
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <sys_cgetc>:

int
sys_cgetc(void)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 01                	push   $0x1
  802227:	e8 98 ff ff ff       	call   8021c4 <syscall>
  80222c:	83 c4 18             	add    $0x18,%esp
}
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802234:	8b 55 0c             	mov    0xc(%ebp),%edx
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	52                   	push   %edx
  802241:	50                   	push   %eax
  802242:	6a 05                	push   $0x5
  802244:	e8 7b ff ff ff       	call   8021c4 <syscall>
  802249:	83 c4 18             	add    $0x18,%esp
}
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	56                   	push   %esi
  802252:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802253:	8b 75 18             	mov    0x18(%ebp),%esi
  802256:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802259:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80225c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	56                   	push   %esi
  802263:	53                   	push   %ebx
  802264:	51                   	push   %ecx
  802265:	52                   	push   %edx
  802266:	50                   	push   %eax
  802267:	6a 06                	push   $0x6
  802269:	e8 56 ff ff ff       	call   8021c4 <syscall>
  80226e:	83 c4 18             	add    $0x18,%esp
}
  802271:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802274:	5b                   	pop    %ebx
  802275:	5e                   	pop    %esi
  802276:	5d                   	pop    %ebp
  802277:	c3                   	ret    

00802278 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80227b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	52                   	push   %edx
  802288:	50                   	push   %eax
  802289:	6a 07                	push   $0x7
  80228b:	e8 34 ff ff ff       	call   8021c4 <syscall>
  802290:	83 c4 18             	add    $0x18,%esp
}
  802293:	c9                   	leave  
  802294:	c3                   	ret    

00802295 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802295:	55                   	push   %ebp
  802296:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	ff 75 0c             	pushl  0xc(%ebp)
  8022a1:	ff 75 08             	pushl  0x8(%ebp)
  8022a4:	6a 08                	push   $0x8
  8022a6:	e8 19 ff ff ff       	call   8021c4 <syscall>
  8022ab:	83 c4 18             	add    $0x18,%esp
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 09                	push   $0x9
  8022bf:	e8 00 ff ff ff       	call   8021c4 <syscall>
  8022c4:	83 c4 18             	add    $0x18,%esp
}
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 0a                	push   $0xa
  8022d8:	e8 e7 fe ff ff       	call   8021c4 <syscall>
  8022dd:	83 c4 18             	add    $0x18,%esp
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 0b                	push   $0xb
  8022f1:	e8 ce fe ff ff       	call   8021c4 <syscall>
  8022f6:	83 c4 18             	add    $0x18,%esp
}
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	ff 75 0c             	pushl  0xc(%ebp)
  802307:	ff 75 08             	pushl  0x8(%ebp)
  80230a:	6a 0f                	push   $0xf
  80230c:	e8 b3 fe ff ff       	call   8021c4 <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
	return;
  802314:	90                   	nop
}
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	ff 75 0c             	pushl  0xc(%ebp)
  802323:	ff 75 08             	pushl  0x8(%ebp)
  802326:	6a 10                	push   $0x10
  802328:	e8 97 fe ff ff       	call   8021c4 <syscall>
  80232d:	83 c4 18             	add    $0x18,%esp
	return ;
  802330:	90                   	nop
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	ff 75 10             	pushl  0x10(%ebp)
  80233d:	ff 75 0c             	pushl  0xc(%ebp)
  802340:	ff 75 08             	pushl  0x8(%ebp)
  802343:	6a 11                	push   $0x11
  802345:	e8 7a fe ff ff       	call   8021c4 <syscall>
  80234a:	83 c4 18             	add    $0x18,%esp
	return ;
  80234d:	90                   	nop
}
  80234e:	c9                   	leave  
  80234f:	c3                   	ret    

00802350 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 0c                	push   $0xc
  80235f:	e8 60 fe ff ff       	call   8021c4 <syscall>
  802364:	83 c4 18             	add    $0x18,%esp
}
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	ff 75 08             	pushl  0x8(%ebp)
  802377:	6a 0d                	push   $0xd
  802379:	e8 46 fe ff ff       	call   8021c4 <syscall>
  80237e:	83 c4 18             	add    $0x18,%esp
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	6a 0e                	push   $0xe
  802392:	e8 2d fe ff ff       	call   8021c4 <syscall>
  802397:	83 c4 18             	add    $0x18,%esp
}
  80239a:	90                   	nop
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    

0080239d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 13                	push   $0x13
  8023ac:	e8 13 fe ff ff       	call   8021c4 <syscall>
  8023b1:	83 c4 18             	add    $0x18,%esp
}
  8023b4:	90                   	nop
  8023b5:	c9                   	leave  
  8023b6:	c3                   	ret    

008023b7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023b7:	55                   	push   %ebp
  8023b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 14                	push   $0x14
  8023c6:	e8 f9 fd ff ff       	call   8021c4 <syscall>
  8023cb:	83 c4 18             	add    $0x18,%esp
}
  8023ce:	90                   	nop
  8023cf:	c9                   	leave  
  8023d0:	c3                   	ret    

008023d1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8023d1:	55                   	push   %ebp
  8023d2:	89 e5                	mov    %esp,%ebp
  8023d4:	83 ec 04             	sub    $0x4,%esp
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023dd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	50                   	push   %eax
  8023ea:	6a 15                	push   $0x15
  8023ec:	e8 d3 fd ff ff       	call   8021c4 <syscall>
  8023f1:	83 c4 18             	add    $0x18,%esp
}
  8023f4:	90                   	nop
  8023f5:	c9                   	leave  
  8023f6:	c3                   	ret    

008023f7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023f7:	55                   	push   %ebp
  8023f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 16                	push   $0x16
  802406:	e8 b9 fd ff ff       	call   8021c4 <syscall>
  80240b:	83 c4 18             	add    $0x18,%esp
}
  80240e:	90                   	nop
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	ff 75 0c             	pushl  0xc(%ebp)
  802420:	50                   	push   %eax
  802421:	6a 17                	push   $0x17
  802423:	e8 9c fd ff ff       	call   8021c4 <syscall>
  802428:	83 c4 18             	add    $0x18,%esp
}
  80242b:	c9                   	leave  
  80242c:	c3                   	ret    

0080242d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802430:	8b 55 0c             	mov    0xc(%ebp),%edx
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	52                   	push   %edx
  80243d:	50                   	push   %eax
  80243e:	6a 1a                	push   $0x1a
  802440:	e8 7f fd ff ff       	call   8021c4 <syscall>
  802445:	83 c4 18             	add    $0x18,%esp
}
  802448:	c9                   	leave  
  802449:	c3                   	ret    

0080244a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80244d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802450:	8b 45 08             	mov    0x8(%ebp),%eax
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	52                   	push   %edx
  80245a:	50                   	push   %eax
  80245b:	6a 18                	push   $0x18
  80245d:	e8 62 fd ff ff       	call   8021c4 <syscall>
  802462:	83 c4 18             	add    $0x18,%esp
}
  802465:	90                   	nop
  802466:	c9                   	leave  
  802467:	c3                   	ret    

00802468 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80246b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	52                   	push   %edx
  802478:	50                   	push   %eax
  802479:	6a 19                	push   $0x19
  80247b:	e8 44 fd ff ff       	call   8021c4 <syscall>
  802480:	83 c4 18             	add    $0x18,%esp
}
  802483:	90                   	nop
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	83 ec 04             	sub    $0x4,%esp
  80248c:	8b 45 10             	mov    0x10(%ebp),%eax
  80248f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802492:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802495:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	6a 00                	push   $0x0
  80249e:	51                   	push   %ecx
  80249f:	52                   	push   %edx
  8024a0:	ff 75 0c             	pushl  0xc(%ebp)
  8024a3:	50                   	push   %eax
  8024a4:	6a 1b                	push   $0x1b
  8024a6:	e8 19 fd ff ff       	call   8021c4 <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
}
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8024b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	52                   	push   %edx
  8024c0:	50                   	push   %eax
  8024c1:	6a 1c                	push   $0x1c
  8024c3:	e8 fc fc ff ff       	call   8021c4 <syscall>
  8024c8:	83 c4 18             	add    $0x18,%esp
}
  8024cb:	c9                   	leave  
  8024cc:	c3                   	ret    

008024cd <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8024cd:	55                   	push   %ebp
  8024ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8024d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	51                   	push   %ecx
  8024de:	52                   	push   %edx
  8024df:	50                   	push   %eax
  8024e0:	6a 1d                	push   $0x1d
  8024e2:	e8 dd fc ff ff       	call   8021c4 <syscall>
  8024e7:	83 c4 18             	add    $0x18,%esp
}
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8024ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	52                   	push   %edx
  8024fc:	50                   	push   %eax
  8024fd:	6a 1e                	push   $0x1e
  8024ff:	e8 c0 fc ff ff       	call   8021c4 <syscall>
  802504:	83 c4 18             	add    $0x18,%esp
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 1f                	push   $0x1f
  802518:	e8 a7 fc ff ff       	call   8021c4 <syscall>
  80251d:	83 c4 18             	add    $0x18,%esp
}
  802520:	c9                   	leave  
  802521:	c3                   	ret    

00802522 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802525:	8b 45 08             	mov    0x8(%ebp),%eax
  802528:	6a 00                	push   $0x0
  80252a:	ff 75 14             	pushl  0x14(%ebp)
  80252d:	ff 75 10             	pushl  0x10(%ebp)
  802530:	ff 75 0c             	pushl  0xc(%ebp)
  802533:	50                   	push   %eax
  802534:	6a 20                	push   $0x20
  802536:	e8 89 fc ff ff       	call   8021c4 <syscall>
  80253b:	83 c4 18             	add    $0x18,%esp
}
  80253e:	c9                   	leave  
  80253f:	c3                   	ret    

00802540 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802543:	8b 45 08             	mov    0x8(%ebp),%eax
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	50                   	push   %eax
  80254f:	6a 21                	push   $0x21
  802551:	e8 6e fc ff ff       	call   8021c4 <syscall>
  802556:	83 c4 18             	add    $0x18,%esp
}
  802559:	90                   	nop
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80255f:	8b 45 08             	mov    0x8(%ebp),%eax
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	50                   	push   %eax
  80256b:	6a 22                	push   $0x22
  80256d:	e8 52 fc ff ff       	call   8021c4 <syscall>
  802572:	83 c4 18             	add    $0x18,%esp
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 02                	push   $0x2
  802586:	e8 39 fc ff ff       	call   8021c4 <syscall>
  80258b:	83 c4 18             	add    $0x18,%esp
}
  80258e:	c9                   	leave  
  80258f:	c3                   	ret    

00802590 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 03                	push   $0x3
  80259f:	e8 20 fc ff ff       	call   8021c4 <syscall>
  8025a4:	83 c4 18             	add    $0x18,%esp
}
  8025a7:	c9                   	leave  
  8025a8:	c3                   	ret    

008025a9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 04                	push   $0x4
  8025b8:	e8 07 fc ff ff       	call   8021c4 <syscall>
  8025bd:	83 c4 18             	add    $0x18,%esp
}
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <sys_exit_env>:


void sys_exit_env(void)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 23                	push   $0x23
  8025d1:	e8 ee fb ff ff       	call   8021c4 <syscall>
  8025d6:	83 c4 18             	add    $0x18,%esp
}
  8025d9:	90                   	nop
  8025da:	c9                   	leave  
  8025db:	c3                   	ret    

008025dc <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8025e2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025e5:	8d 50 04             	lea    0x4(%eax),%edx
  8025e8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	52                   	push   %edx
  8025f2:	50                   	push   %eax
  8025f3:	6a 24                	push   $0x24
  8025f5:	e8 ca fb ff ff       	call   8021c4 <syscall>
  8025fa:	83 c4 18             	add    $0x18,%esp
	return result;
  8025fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802600:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802603:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802606:	89 01                	mov    %eax,(%ecx)
  802608:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	c9                   	leave  
  80260f:	c2 04 00             	ret    $0x4

00802612 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802612:	55                   	push   %ebp
  802613:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802615:	6a 00                	push   $0x0
  802617:	6a 00                	push   $0x0
  802619:	ff 75 10             	pushl  0x10(%ebp)
  80261c:	ff 75 0c             	pushl  0xc(%ebp)
  80261f:	ff 75 08             	pushl  0x8(%ebp)
  802622:	6a 12                	push   $0x12
  802624:	e8 9b fb ff ff       	call   8021c4 <syscall>
  802629:	83 c4 18             	add    $0x18,%esp
	return ;
  80262c:	90                   	nop
}
  80262d:	c9                   	leave  
  80262e:	c3                   	ret    

0080262f <sys_rcr2>:
uint32 sys_rcr2()
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 25                	push   $0x25
  80263e:	e8 81 fb ff ff       	call   8021c4 <syscall>
  802643:	83 c4 18             	add    $0x18,%esp
}
  802646:	c9                   	leave  
  802647:	c3                   	ret    

00802648 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
  80264b:	83 ec 04             	sub    $0x4,%esp
  80264e:	8b 45 08             	mov    0x8(%ebp),%eax
  802651:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802654:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	50                   	push   %eax
  802661:	6a 26                	push   $0x26
  802663:	e8 5c fb ff ff       	call   8021c4 <syscall>
  802668:	83 c4 18             	add    $0x18,%esp
	return ;
  80266b:	90                   	nop
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <rsttst>:
void rsttst()
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 28                	push   $0x28
  80267d:	e8 42 fb ff ff       	call   8021c4 <syscall>
  802682:	83 c4 18             	add    $0x18,%esp
	return ;
  802685:	90                   	nop
}
  802686:	c9                   	leave  
  802687:	c3                   	ret    

00802688 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
  80268b:	83 ec 04             	sub    $0x4,%esp
  80268e:	8b 45 14             	mov    0x14(%ebp),%eax
  802691:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802694:	8b 55 18             	mov    0x18(%ebp),%edx
  802697:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80269b:	52                   	push   %edx
  80269c:	50                   	push   %eax
  80269d:	ff 75 10             	pushl  0x10(%ebp)
  8026a0:	ff 75 0c             	pushl  0xc(%ebp)
  8026a3:	ff 75 08             	pushl  0x8(%ebp)
  8026a6:	6a 27                	push   $0x27
  8026a8:	e8 17 fb ff ff       	call   8021c4 <syscall>
  8026ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b0:	90                   	nop
}
  8026b1:	c9                   	leave  
  8026b2:	c3                   	ret    

008026b3 <chktst>:
void chktst(uint32 n)
{
  8026b3:	55                   	push   %ebp
  8026b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	ff 75 08             	pushl  0x8(%ebp)
  8026c1:	6a 29                	push   $0x29
  8026c3:	e8 fc fa ff ff       	call   8021c4 <syscall>
  8026c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8026cb:	90                   	nop
}
  8026cc:	c9                   	leave  
  8026cd:	c3                   	ret    

008026ce <inctst>:

void inctst()
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 2a                	push   $0x2a
  8026dd:	e8 e2 fa ff ff       	call   8021c4 <syscall>
  8026e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8026e5:	90                   	nop
}
  8026e6:	c9                   	leave  
  8026e7:	c3                   	ret    

008026e8 <gettst>:
uint32 gettst()
{
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8026eb:	6a 00                	push   $0x0
  8026ed:	6a 00                	push   $0x0
  8026ef:	6a 00                	push   $0x0
  8026f1:	6a 00                	push   $0x0
  8026f3:	6a 00                	push   $0x0
  8026f5:	6a 2b                	push   $0x2b
  8026f7:	e8 c8 fa ff ff       	call   8021c4 <syscall>
  8026fc:	83 c4 18             	add    $0x18,%esp
}
  8026ff:	c9                   	leave  
  802700:	c3                   	ret    

00802701 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802701:	55                   	push   %ebp
  802702:	89 e5                	mov    %esp,%ebp
  802704:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802707:	6a 00                	push   $0x0
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	6a 00                	push   $0x0
  80270f:	6a 00                	push   $0x0
  802711:	6a 2c                	push   $0x2c
  802713:	e8 ac fa ff ff       	call   8021c4 <syscall>
  802718:	83 c4 18             	add    $0x18,%esp
  80271b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80271e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802722:	75 07                	jne    80272b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802724:	b8 01 00 00 00       	mov    $0x1,%eax
  802729:	eb 05                	jmp    802730 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80272b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802730:	c9                   	leave  
  802731:	c3                   	ret    

00802732 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802732:	55                   	push   %ebp
  802733:	89 e5                	mov    %esp,%ebp
  802735:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802738:	6a 00                	push   $0x0
  80273a:	6a 00                	push   $0x0
  80273c:	6a 00                	push   $0x0
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	6a 2c                	push   $0x2c
  802744:	e8 7b fa ff ff       	call   8021c4 <syscall>
  802749:	83 c4 18             	add    $0x18,%esp
  80274c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80274f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802753:	75 07                	jne    80275c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802755:	b8 01 00 00 00       	mov    $0x1,%eax
  80275a:	eb 05                	jmp    802761 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802761:	c9                   	leave  
  802762:	c3                   	ret    

00802763 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802763:	55                   	push   %ebp
  802764:	89 e5                	mov    %esp,%ebp
  802766:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	6a 2c                	push   $0x2c
  802775:	e8 4a fa ff ff       	call   8021c4 <syscall>
  80277a:	83 c4 18             	add    $0x18,%esp
  80277d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802780:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802784:	75 07                	jne    80278d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802786:	b8 01 00 00 00       	mov    $0x1,%eax
  80278b:	eb 05                	jmp    802792 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80278d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802792:	c9                   	leave  
  802793:	c3                   	ret    

00802794 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802794:	55                   	push   %ebp
  802795:	89 e5                	mov    %esp,%ebp
  802797:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	6a 2c                	push   $0x2c
  8027a6:	e8 19 fa ff ff       	call   8021c4 <syscall>
  8027ab:	83 c4 18             	add    $0x18,%esp
  8027ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027b1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027b5:	75 07                	jne    8027be <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8027bc:	eb 05                	jmp    8027c3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027c3:	c9                   	leave  
  8027c4:	c3                   	ret    

008027c5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027c8:	6a 00                	push   $0x0
  8027ca:	6a 00                	push   $0x0
  8027cc:	6a 00                	push   $0x0
  8027ce:	6a 00                	push   $0x0
  8027d0:	ff 75 08             	pushl  0x8(%ebp)
  8027d3:	6a 2d                	push   $0x2d
  8027d5:	e8 ea f9 ff ff       	call   8021c4 <syscall>
  8027da:	83 c4 18             	add    $0x18,%esp
	return ;
  8027dd:	90                   	nop
}
  8027de:	c9                   	leave  
  8027df:	c3                   	ret    

008027e0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
  8027e3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8027e4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f0:	6a 00                	push   $0x0
  8027f2:	53                   	push   %ebx
  8027f3:	51                   	push   %ecx
  8027f4:	52                   	push   %edx
  8027f5:	50                   	push   %eax
  8027f6:	6a 2e                	push   $0x2e
  8027f8:	e8 c7 f9 ff ff       	call   8021c4 <syscall>
  8027fd:	83 c4 18             	add    $0x18,%esp
}
  802800:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802803:	c9                   	leave  
  802804:	c3                   	ret    

00802805 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802805:	55                   	push   %ebp
  802806:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80280b:	8b 45 08             	mov    0x8(%ebp),%eax
  80280e:	6a 00                	push   $0x0
  802810:	6a 00                	push   $0x0
  802812:	6a 00                	push   $0x0
  802814:	52                   	push   %edx
  802815:	50                   	push   %eax
  802816:	6a 2f                	push   $0x2f
  802818:	e8 a7 f9 ff ff       	call   8021c4 <syscall>
  80281d:	83 c4 18             	add    $0x18,%esp
}
  802820:	c9                   	leave  
  802821:	c3                   	ret    

00802822 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802822:	55                   	push   %ebp
  802823:	89 e5                	mov    %esp,%ebp
  802825:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802828:	83 ec 0c             	sub    $0xc,%esp
  80282b:	68 40 43 80 00       	push   $0x804340
  802830:	e8 c3 e6 ff ff       	call   800ef8 <cprintf>
  802835:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802838:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80283f:	83 ec 0c             	sub    $0xc,%esp
  802842:	68 6c 43 80 00       	push   $0x80436c
  802847:	e8 ac e6 ff ff       	call   800ef8 <cprintf>
  80284c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80284f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802853:	a1 38 51 80 00       	mov    0x805138,%eax
  802858:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285b:	eb 56                	jmp    8028b3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80285d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802861:	74 1c                	je     80287f <print_mem_block_lists+0x5d>
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 50 08             	mov    0x8(%eax),%edx
  802869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286c:	8b 48 08             	mov    0x8(%eax),%ecx
  80286f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802872:	8b 40 0c             	mov    0xc(%eax),%eax
  802875:	01 c8                	add    %ecx,%eax
  802877:	39 c2                	cmp    %eax,%edx
  802879:	73 04                	jae    80287f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80287b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 50 08             	mov    0x8(%eax),%edx
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 40 0c             	mov    0xc(%eax),%eax
  80288b:	01 c2                	add    %eax,%edx
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 40 08             	mov    0x8(%eax),%eax
  802893:	83 ec 04             	sub    $0x4,%esp
  802896:	52                   	push   %edx
  802897:	50                   	push   %eax
  802898:	68 81 43 80 00       	push   $0x804381
  80289d:	e8 56 e6 ff ff       	call   800ef8 <cprintf>
  8028a2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028ab:	a1 40 51 80 00       	mov    0x805140,%eax
  8028b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b7:	74 07                	je     8028c0 <print_mem_block_lists+0x9e>
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 00                	mov    (%eax),%eax
  8028be:	eb 05                	jmp    8028c5 <print_mem_block_lists+0xa3>
  8028c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c5:	a3 40 51 80 00       	mov    %eax,0x805140
  8028ca:	a1 40 51 80 00       	mov    0x805140,%eax
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	75 8a                	jne    80285d <print_mem_block_lists+0x3b>
  8028d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d7:	75 84                	jne    80285d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8028d9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028dd:	75 10                	jne    8028ef <print_mem_block_lists+0xcd>
  8028df:	83 ec 0c             	sub    $0xc,%esp
  8028e2:	68 90 43 80 00       	push   $0x804390
  8028e7:	e8 0c e6 ff ff       	call   800ef8 <cprintf>
  8028ec:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8028ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8028f6:	83 ec 0c             	sub    $0xc,%esp
  8028f9:	68 b4 43 80 00       	push   $0x8043b4
  8028fe:	e8 f5 e5 ff ff       	call   800ef8 <cprintf>
  802903:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802906:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80290a:	a1 40 50 80 00       	mov    0x805040,%eax
  80290f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802912:	eb 56                	jmp    80296a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802914:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802918:	74 1c                	je     802936 <print_mem_block_lists+0x114>
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 50 08             	mov    0x8(%eax),%edx
  802920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802923:	8b 48 08             	mov    0x8(%eax),%ecx
  802926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802929:	8b 40 0c             	mov    0xc(%eax),%eax
  80292c:	01 c8                	add    %ecx,%eax
  80292e:	39 c2                	cmp    %eax,%edx
  802930:	73 04                	jae    802936 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802932:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 50 08             	mov    0x8(%eax),%edx
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 40 0c             	mov    0xc(%eax),%eax
  802942:	01 c2                	add    %eax,%edx
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	8b 40 08             	mov    0x8(%eax),%eax
  80294a:	83 ec 04             	sub    $0x4,%esp
  80294d:	52                   	push   %edx
  80294e:	50                   	push   %eax
  80294f:	68 81 43 80 00       	push   $0x804381
  802954:	e8 9f e5 ff ff       	call   800ef8 <cprintf>
  802959:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802962:	a1 48 50 80 00       	mov    0x805048,%eax
  802967:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296e:	74 07                	je     802977 <print_mem_block_lists+0x155>
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 00                	mov    (%eax),%eax
  802975:	eb 05                	jmp    80297c <print_mem_block_lists+0x15a>
  802977:	b8 00 00 00 00       	mov    $0x0,%eax
  80297c:	a3 48 50 80 00       	mov    %eax,0x805048
  802981:	a1 48 50 80 00       	mov    0x805048,%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	75 8a                	jne    802914 <print_mem_block_lists+0xf2>
  80298a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298e:	75 84                	jne    802914 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802990:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802994:	75 10                	jne    8029a6 <print_mem_block_lists+0x184>
  802996:	83 ec 0c             	sub    $0xc,%esp
  802999:	68 cc 43 80 00       	push   $0x8043cc
  80299e:	e8 55 e5 ff ff       	call   800ef8 <cprintf>
  8029a3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8029a6:	83 ec 0c             	sub    $0xc,%esp
  8029a9:	68 40 43 80 00       	push   $0x804340
  8029ae:	e8 45 e5 ff ff       	call   800ef8 <cprintf>
  8029b3:	83 c4 10             	add    $0x10,%esp

}
  8029b6:	90                   	nop
  8029b7:	c9                   	leave  
  8029b8:	c3                   	ret    

008029b9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8029b9:	55                   	push   %ebp
  8029ba:	89 e5                	mov    %esp,%ebp
  8029bc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  8029bf:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8029c6:	00 00 00 
  8029c9:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8029d0:	00 00 00 
  8029d3:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8029da:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8029dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029e4:	e9 9e 00 00 00       	jmp    802a87 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8029e9:	a1 50 50 80 00       	mov    0x805050,%eax
  8029ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f1:	c1 e2 04             	shl    $0x4,%edx
  8029f4:	01 d0                	add    %edx,%eax
  8029f6:	85 c0                	test   %eax,%eax
  8029f8:	75 14                	jne    802a0e <initialize_MemBlocksList+0x55>
  8029fa:	83 ec 04             	sub    $0x4,%esp
  8029fd:	68 f4 43 80 00       	push   $0x8043f4
  802a02:	6a 47                	push   $0x47
  802a04:	68 17 44 80 00       	push   $0x804417
  802a09:	e8 36 e2 ff ff       	call   800c44 <_panic>
  802a0e:	a1 50 50 80 00       	mov    0x805050,%eax
  802a13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a16:	c1 e2 04             	shl    $0x4,%edx
  802a19:	01 d0                	add    %edx,%eax
  802a1b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a21:	89 10                	mov    %edx,(%eax)
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	74 18                	je     802a41 <initialize_MemBlocksList+0x88>
  802a29:	a1 48 51 80 00       	mov    0x805148,%eax
  802a2e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a34:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a37:	c1 e1 04             	shl    $0x4,%ecx
  802a3a:	01 ca                	add    %ecx,%edx
  802a3c:	89 50 04             	mov    %edx,0x4(%eax)
  802a3f:	eb 12                	jmp    802a53 <initialize_MemBlocksList+0x9a>
  802a41:	a1 50 50 80 00       	mov    0x805050,%eax
  802a46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a49:	c1 e2 04             	shl    $0x4,%edx
  802a4c:	01 d0                	add    %edx,%eax
  802a4e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a53:	a1 50 50 80 00       	mov    0x805050,%eax
  802a58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5b:	c1 e2 04             	shl    $0x4,%edx
  802a5e:	01 d0                	add    %edx,%eax
  802a60:	a3 48 51 80 00       	mov    %eax,0x805148
  802a65:	a1 50 50 80 00       	mov    0x805050,%eax
  802a6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6d:	c1 e2 04             	shl    $0x4,%edx
  802a70:	01 d0                	add    %edx,%eax
  802a72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a79:	a1 54 51 80 00       	mov    0x805154,%eax
  802a7e:	40                   	inc    %eax
  802a7f:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802a84:	ff 45 f4             	incl   -0xc(%ebp)
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a8d:	0f 82 56 ff ff ff    	jb     8029e9 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802a93:	90                   	nop
  802a94:	c9                   	leave  
  802a95:	c3                   	ret    

00802a96 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802a96:	55                   	push   %ebp
  802a97:	89 e5                	mov    %esp,%ebp
  802a99:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	8b 00                	mov    (%eax),%eax
  802aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802aa4:	eb 19                	jmp    802abf <find_block+0x29>
	{
		if(element->sva == va){
  802aa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802aa9:	8b 40 08             	mov    0x8(%eax),%eax
  802aac:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802aaf:	75 05                	jne    802ab6 <find_block+0x20>
			 		return element;
  802ab1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ab4:	eb 36                	jmp    802aec <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	8b 40 08             	mov    0x8(%eax),%eax
  802abc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802abf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ac3:	74 07                	je     802acc <find_block+0x36>
  802ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ac8:	8b 00                	mov    (%eax),%eax
  802aca:	eb 05                	jmp    802ad1 <find_block+0x3b>
  802acc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad4:	89 42 08             	mov    %eax,0x8(%edx)
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	8b 40 08             	mov    0x8(%eax),%eax
  802add:	85 c0                	test   %eax,%eax
  802adf:	75 c5                	jne    802aa6 <find_block+0x10>
  802ae1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ae5:	75 bf                	jne    802aa6 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802ae7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aec:	c9                   	leave  
  802aed:	c3                   	ret    

00802aee <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802aee:	55                   	push   %ebp
  802aef:	89 e5                	mov    %esp,%ebp
  802af1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802af4:	a1 44 50 80 00       	mov    0x805044,%eax
  802af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802afc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b01:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802b04:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b08:	74 0a                	je     802b14 <insert_sorted_allocList+0x26>
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	8b 40 08             	mov    0x8(%eax),%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	75 65                	jne    802b79 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802b14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b18:	75 14                	jne    802b2e <insert_sorted_allocList+0x40>
  802b1a:	83 ec 04             	sub    $0x4,%esp
  802b1d:	68 f4 43 80 00       	push   $0x8043f4
  802b22:	6a 6e                	push   $0x6e
  802b24:	68 17 44 80 00       	push   $0x804417
  802b29:	e8 16 e1 ff ff       	call   800c44 <_panic>
  802b2e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	89 10                	mov    %edx,(%eax)
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	8b 00                	mov    (%eax),%eax
  802b3e:	85 c0                	test   %eax,%eax
  802b40:	74 0d                	je     802b4f <insert_sorted_allocList+0x61>
  802b42:	a1 40 50 80 00       	mov    0x805040,%eax
  802b47:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4a:	89 50 04             	mov    %edx,0x4(%eax)
  802b4d:	eb 08                	jmp    802b57 <insert_sorted_allocList+0x69>
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	a3 44 50 80 00       	mov    %eax,0x805044
  802b57:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5a:	a3 40 50 80 00       	mov    %eax,0x805040
  802b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b69:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b6e:	40                   	inc    %eax
  802b6f:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802b74:	e9 cf 01 00 00       	jmp    802d48 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7c:	8b 50 08             	mov    0x8(%eax),%edx
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	8b 40 08             	mov    0x8(%eax),%eax
  802b85:	39 c2                	cmp    %eax,%edx
  802b87:	73 65                	jae    802bee <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802b89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b8d:	75 14                	jne    802ba3 <insert_sorted_allocList+0xb5>
  802b8f:	83 ec 04             	sub    $0x4,%esp
  802b92:	68 30 44 80 00       	push   $0x804430
  802b97:	6a 72                	push   $0x72
  802b99:	68 17 44 80 00       	push   $0x804417
  802b9e:	e8 a1 e0 ff ff       	call   800c44 <_panic>
  802ba3:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	89 50 04             	mov    %edx,0x4(%eax)
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	8b 40 04             	mov    0x4(%eax),%eax
  802bb5:	85 c0                	test   %eax,%eax
  802bb7:	74 0c                	je     802bc5 <insert_sorted_allocList+0xd7>
  802bb9:	a1 44 50 80 00       	mov    0x805044,%eax
  802bbe:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc1:	89 10                	mov    %edx,(%eax)
  802bc3:	eb 08                	jmp    802bcd <insert_sorted_allocList+0xdf>
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	a3 40 50 80 00       	mov    %eax,0x805040
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	a3 44 50 80 00       	mov    %eax,0x805044
  802bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bde:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802be3:	40                   	inc    %eax
  802be4:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802be9:	e9 5a 01 00 00       	jmp    802d48 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf1:	8b 50 08             	mov    0x8(%eax),%edx
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	8b 40 08             	mov    0x8(%eax),%eax
  802bfa:	39 c2                	cmp    %eax,%edx
  802bfc:	75 70                	jne    802c6e <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802bfe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c02:	74 06                	je     802c0a <insert_sorted_allocList+0x11c>
  802c04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c08:	75 14                	jne    802c1e <insert_sorted_allocList+0x130>
  802c0a:	83 ec 04             	sub    $0x4,%esp
  802c0d:	68 54 44 80 00       	push   $0x804454
  802c12:	6a 75                	push   $0x75
  802c14:	68 17 44 80 00       	push   $0x804417
  802c19:	e8 26 e0 ff ff       	call   800c44 <_panic>
  802c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c21:	8b 10                	mov    (%eax),%edx
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	89 10                	mov    %edx,(%eax)
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	8b 00                	mov    (%eax),%eax
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	74 0b                	je     802c3c <insert_sorted_allocList+0x14e>
  802c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	8b 55 08             	mov    0x8(%ebp),%edx
  802c39:	89 50 04             	mov    %edx,0x4(%eax)
  802c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c42:	89 10                	mov    %edx,(%eax)
  802c44:	8b 45 08             	mov    0x8(%ebp),%eax
  802c47:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c4a:	89 50 04             	mov    %edx,0x4(%eax)
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	8b 00                	mov    (%eax),%eax
  802c52:	85 c0                	test   %eax,%eax
  802c54:	75 08                	jne    802c5e <insert_sorted_allocList+0x170>
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	a3 44 50 80 00       	mov    %eax,0x805044
  802c5e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c63:	40                   	inc    %eax
  802c64:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802c69:	e9 da 00 00 00       	jmp    802d48 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802c6e:	a1 40 50 80 00       	mov    0x805040,%eax
  802c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c76:	e9 9d 00 00 00       	jmp    802d18 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 00                	mov    (%eax),%eax
  802c80:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802c83:	8b 45 08             	mov    0x8(%ebp),%eax
  802c86:	8b 50 08             	mov    0x8(%eax),%edx
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 40 08             	mov    0x8(%eax),%eax
  802c8f:	39 c2                	cmp    %eax,%edx
  802c91:	76 7d                	jbe    802d10 <insert_sorted_allocList+0x222>
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	8b 50 08             	mov    0x8(%eax),%edx
  802c99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c9c:	8b 40 08             	mov    0x8(%eax),%eax
  802c9f:	39 c2                	cmp    %eax,%edx
  802ca1:	73 6d                	jae    802d10 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802ca3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca7:	74 06                	je     802caf <insert_sorted_allocList+0x1c1>
  802ca9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cad:	75 14                	jne    802cc3 <insert_sorted_allocList+0x1d5>
  802caf:	83 ec 04             	sub    $0x4,%esp
  802cb2:	68 54 44 80 00       	push   $0x804454
  802cb7:	6a 7c                	push   $0x7c
  802cb9:	68 17 44 80 00       	push   $0x804417
  802cbe:	e8 81 df ff ff       	call   800c44 <_panic>
  802cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc6:	8b 10                	mov    (%eax),%edx
  802cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccb:	89 10                	mov    %edx,(%eax)
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	8b 00                	mov    (%eax),%eax
  802cd2:	85 c0                	test   %eax,%eax
  802cd4:	74 0b                	je     802ce1 <insert_sorted_allocList+0x1f3>
  802cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd9:	8b 00                	mov    (%eax),%eax
  802cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cde:	89 50 04             	mov    %edx,0x4(%eax)
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce7:	89 10                	mov    %edx,(%eax)
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cef:	89 50 04             	mov    %edx,0x4(%eax)
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	8b 00                	mov    (%eax),%eax
  802cf7:	85 c0                	test   %eax,%eax
  802cf9:	75 08                	jne    802d03 <insert_sorted_allocList+0x215>
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	a3 44 50 80 00       	mov    %eax,0x805044
  802d03:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d08:	40                   	inc    %eax
  802d09:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802d0e:	eb 38                	jmp    802d48 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802d10:	a1 48 50 80 00       	mov    0x805048,%eax
  802d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1c:	74 07                	je     802d25 <insert_sorted_allocList+0x237>
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 00                	mov    (%eax),%eax
  802d23:	eb 05                	jmp    802d2a <insert_sorted_allocList+0x23c>
  802d25:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2a:	a3 48 50 80 00       	mov    %eax,0x805048
  802d2f:	a1 48 50 80 00       	mov    0x805048,%eax
  802d34:	85 c0                	test   %eax,%eax
  802d36:	0f 85 3f ff ff ff    	jne    802c7b <insert_sorted_allocList+0x18d>
  802d3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d40:	0f 85 35 ff ff ff    	jne    802c7b <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802d46:	eb 00                	jmp    802d48 <insert_sorted_allocList+0x25a>
  802d48:	90                   	nop
  802d49:	c9                   	leave  
  802d4a:	c3                   	ret    

00802d4b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802d4b:	55                   	push   %ebp
  802d4c:	89 e5                	mov    %esp,%ebp
  802d4e:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802d51:	a1 38 51 80 00       	mov    0x805138,%eax
  802d56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d59:	e9 6b 02 00 00       	jmp    802fc9 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 40 0c             	mov    0xc(%eax),%eax
  802d64:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d67:	0f 85 90 00 00 00    	jne    802dfd <alloc_block_FF+0xb2>
			  temp=element;
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802d73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d77:	75 17                	jne    802d90 <alloc_block_FF+0x45>
  802d79:	83 ec 04             	sub    $0x4,%esp
  802d7c:	68 88 44 80 00       	push   $0x804488
  802d81:	68 92 00 00 00       	push   $0x92
  802d86:	68 17 44 80 00       	push   $0x804417
  802d8b:	e8 b4 de ff ff       	call   800c44 <_panic>
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	8b 00                	mov    (%eax),%eax
  802d95:	85 c0                	test   %eax,%eax
  802d97:	74 10                	je     802da9 <alloc_block_FF+0x5e>
  802d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9c:	8b 00                	mov    (%eax),%eax
  802d9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802da1:	8b 52 04             	mov    0x4(%edx),%edx
  802da4:	89 50 04             	mov    %edx,0x4(%eax)
  802da7:	eb 0b                	jmp    802db4 <alloc_block_FF+0x69>
  802da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dac:	8b 40 04             	mov    0x4(%eax),%eax
  802daf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 40 04             	mov    0x4(%eax),%eax
  802dba:	85 c0                	test   %eax,%eax
  802dbc:	74 0f                	je     802dcd <alloc_block_FF+0x82>
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 40 04             	mov    0x4(%eax),%eax
  802dc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dc7:	8b 12                	mov    (%edx),%edx
  802dc9:	89 10                	mov    %edx,(%eax)
  802dcb:	eb 0a                	jmp    802dd7 <alloc_block_FF+0x8c>
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	8b 00                	mov    (%eax),%eax
  802dd2:	a3 38 51 80 00       	mov    %eax,0x805138
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dea:	a1 44 51 80 00       	mov    0x805144,%eax
  802def:	48                   	dec    %eax
  802df0:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802df5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df8:	e9 ff 01 00 00       	jmp    802ffc <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	8b 40 0c             	mov    0xc(%eax),%eax
  802e03:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e06:	0f 86 b5 01 00 00    	jbe    802fc1 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e12:	2b 45 08             	sub    0x8(%ebp),%eax
  802e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802e18:	a1 48 51 80 00       	mov    0x805148,%eax
  802e1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802e20:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e24:	75 17                	jne    802e3d <alloc_block_FF+0xf2>
  802e26:	83 ec 04             	sub    $0x4,%esp
  802e29:	68 88 44 80 00       	push   $0x804488
  802e2e:	68 99 00 00 00       	push   $0x99
  802e33:	68 17 44 80 00       	push   $0x804417
  802e38:	e8 07 de ff ff       	call   800c44 <_panic>
  802e3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e40:	8b 00                	mov    (%eax),%eax
  802e42:	85 c0                	test   %eax,%eax
  802e44:	74 10                	je     802e56 <alloc_block_FF+0x10b>
  802e46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e49:	8b 00                	mov    (%eax),%eax
  802e4b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e4e:	8b 52 04             	mov    0x4(%edx),%edx
  802e51:	89 50 04             	mov    %edx,0x4(%eax)
  802e54:	eb 0b                	jmp    802e61 <alloc_block_FF+0x116>
  802e56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e59:	8b 40 04             	mov    0x4(%eax),%eax
  802e5c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e64:	8b 40 04             	mov    0x4(%eax),%eax
  802e67:	85 c0                	test   %eax,%eax
  802e69:	74 0f                	je     802e7a <alloc_block_FF+0x12f>
  802e6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6e:	8b 40 04             	mov    0x4(%eax),%eax
  802e71:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e74:	8b 12                	mov    (%edx),%edx
  802e76:	89 10                	mov    %edx,(%eax)
  802e78:	eb 0a                	jmp    802e84 <alloc_block_FF+0x139>
  802e7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7d:	8b 00                	mov    (%eax),%eax
  802e7f:	a3 48 51 80 00       	mov    %eax,0x805148
  802e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e97:	a1 54 51 80 00       	mov    0x805154,%eax
  802e9c:	48                   	dec    %eax
  802e9d:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802ea2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ea6:	75 17                	jne    802ebf <alloc_block_FF+0x174>
  802ea8:	83 ec 04             	sub    $0x4,%esp
  802eab:	68 30 44 80 00       	push   $0x804430
  802eb0:	68 9a 00 00 00       	push   $0x9a
  802eb5:	68 17 44 80 00       	push   $0x804417
  802eba:	e8 85 dd ff ff       	call   800c44 <_panic>
  802ebf:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec8:	89 50 04             	mov    %edx,0x4(%eax)
  802ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ece:	8b 40 04             	mov    0x4(%eax),%eax
  802ed1:	85 c0                	test   %eax,%eax
  802ed3:	74 0c                	je     802ee1 <alloc_block_FF+0x196>
  802ed5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802eda:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802edd:	89 10                	mov    %edx,(%eax)
  802edf:	eb 08                	jmp    802ee9 <alloc_block_FF+0x19e>
  802ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee4:	a3 38 51 80 00       	mov    %eax,0x805138
  802ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ef1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802efa:	a1 44 51 80 00       	mov    0x805144,%eax
  802eff:	40                   	inc    %eax
  802f00:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f08:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0b:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	8b 50 08             	mov    0x8(%eax),%edx
  802f14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f17:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f20:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	8b 50 08             	mov    0x8(%eax),%edx
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	01 c2                	add    %eax,%edx
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f37:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802f3a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f3e:	75 17                	jne    802f57 <alloc_block_FF+0x20c>
  802f40:	83 ec 04             	sub    $0x4,%esp
  802f43:	68 88 44 80 00       	push   $0x804488
  802f48:	68 a2 00 00 00       	push   $0xa2
  802f4d:	68 17 44 80 00       	push   $0x804417
  802f52:	e8 ed dc ff ff       	call   800c44 <_panic>
  802f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5a:	8b 00                	mov    (%eax),%eax
  802f5c:	85 c0                	test   %eax,%eax
  802f5e:	74 10                	je     802f70 <alloc_block_FF+0x225>
  802f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f63:	8b 00                	mov    (%eax),%eax
  802f65:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f68:	8b 52 04             	mov    0x4(%edx),%edx
  802f6b:	89 50 04             	mov    %edx,0x4(%eax)
  802f6e:	eb 0b                	jmp    802f7b <alloc_block_FF+0x230>
  802f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f73:	8b 40 04             	mov    0x4(%eax),%eax
  802f76:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7e:	8b 40 04             	mov    0x4(%eax),%eax
  802f81:	85 c0                	test   %eax,%eax
  802f83:	74 0f                	je     802f94 <alloc_block_FF+0x249>
  802f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f88:	8b 40 04             	mov    0x4(%eax),%eax
  802f8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f8e:	8b 12                	mov    (%edx),%edx
  802f90:	89 10                	mov    %edx,(%eax)
  802f92:	eb 0a                	jmp    802f9e <alloc_block_FF+0x253>
  802f94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	a3 38 51 80 00       	mov    %eax,0x805138
  802f9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802faa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb1:	a1 44 51 80 00       	mov    0x805144,%eax
  802fb6:	48                   	dec    %eax
  802fb7:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802fbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbf:	eb 3b                	jmp    802ffc <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802fc1:	a1 40 51 80 00       	mov    0x805140,%eax
  802fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fcd:	74 07                	je     802fd6 <alloc_block_FF+0x28b>
  802fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd2:	8b 00                	mov    (%eax),%eax
  802fd4:	eb 05                	jmp    802fdb <alloc_block_FF+0x290>
  802fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdb:	a3 40 51 80 00       	mov    %eax,0x805140
  802fe0:	a1 40 51 80 00       	mov    0x805140,%eax
  802fe5:	85 c0                	test   %eax,%eax
  802fe7:	0f 85 71 fd ff ff    	jne    802d5e <alloc_block_FF+0x13>
  802fed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff1:	0f 85 67 fd ff ff    	jne    802d5e <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802ff7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ffc:	c9                   	leave  
  802ffd:	c3                   	ret    

00802ffe <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ffe:	55                   	push   %ebp
  802fff:	89 e5                	mov    %esp,%ebp
  803001:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  803004:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  80300b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  803012:	a1 38 51 80 00       	mov    0x805138,%eax
  803017:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80301a:	e9 d3 00 00 00       	jmp    8030f2 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  80301f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803022:	8b 40 0c             	mov    0xc(%eax),%eax
  803025:	3b 45 08             	cmp    0x8(%ebp),%eax
  803028:	0f 85 90 00 00 00    	jne    8030be <alloc_block_BF+0xc0>
	   temp = element;
  80302e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803031:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  803034:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803038:	75 17                	jne    803051 <alloc_block_BF+0x53>
  80303a:	83 ec 04             	sub    $0x4,%esp
  80303d:	68 88 44 80 00       	push   $0x804488
  803042:	68 bd 00 00 00       	push   $0xbd
  803047:	68 17 44 80 00       	push   $0x804417
  80304c:	e8 f3 db ff ff       	call   800c44 <_panic>
  803051:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803054:	8b 00                	mov    (%eax),%eax
  803056:	85 c0                	test   %eax,%eax
  803058:	74 10                	je     80306a <alloc_block_BF+0x6c>
  80305a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305d:	8b 00                	mov    (%eax),%eax
  80305f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803062:	8b 52 04             	mov    0x4(%edx),%edx
  803065:	89 50 04             	mov    %edx,0x4(%eax)
  803068:	eb 0b                	jmp    803075 <alloc_block_BF+0x77>
  80306a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306d:	8b 40 04             	mov    0x4(%eax),%eax
  803070:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803075:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803078:	8b 40 04             	mov    0x4(%eax),%eax
  80307b:	85 c0                	test   %eax,%eax
  80307d:	74 0f                	je     80308e <alloc_block_BF+0x90>
  80307f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803082:	8b 40 04             	mov    0x4(%eax),%eax
  803085:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803088:	8b 12                	mov    (%edx),%edx
  80308a:	89 10                	mov    %edx,(%eax)
  80308c:	eb 0a                	jmp    803098 <alloc_block_BF+0x9a>
  80308e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803091:	8b 00                	mov    (%eax),%eax
  803093:	a3 38 51 80 00       	mov    %eax,0x805138
  803098:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ab:	a1 44 51 80 00       	mov    0x805144,%eax
  8030b0:	48                   	dec    %eax
  8030b1:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  8030b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030b9:	e9 41 01 00 00       	jmp    8031ff <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8030be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030c7:	76 21                	jbe    8030ea <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  8030c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030d2:	73 16                	jae    8030ea <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  8030d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  8030dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  8030e3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8030ea:	a1 40 51 80 00       	mov    0x805140,%eax
  8030ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8030f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030f6:	74 07                	je     8030ff <alloc_block_BF+0x101>
  8030f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	eb 05                	jmp    803104 <alloc_block_BF+0x106>
  8030ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803104:	a3 40 51 80 00       	mov    %eax,0x805140
  803109:	a1 40 51 80 00       	mov    0x805140,%eax
  80310e:	85 c0                	test   %eax,%eax
  803110:	0f 85 09 ff ff ff    	jne    80301f <alloc_block_BF+0x21>
  803116:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80311a:	0f 85 ff fe ff ff    	jne    80301f <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  803120:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  803124:	0f 85 d0 00 00 00    	jne    8031fa <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80312a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312d:	8b 40 0c             	mov    0xc(%eax),%eax
  803130:	2b 45 08             	sub    0x8(%ebp),%eax
  803133:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  803136:	a1 48 51 80 00       	mov    0x805148,%eax
  80313b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  80313e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803142:	75 17                	jne    80315b <alloc_block_BF+0x15d>
  803144:	83 ec 04             	sub    $0x4,%esp
  803147:	68 88 44 80 00       	push   $0x804488
  80314c:	68 d1 00 00 00       	push   $0xd1
  803151:	68 17 44 80 00       	push   $0x804417
  803156:	e8 e9 da ff ff       	call   800c44 <_panic>
  80315b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80315e:	8b 00                	mov    (%eax),%eax
  803160:	85 c0                	test   %eax,%eax
  803162:	74 10                	je     803174 <alloc_block_BF+0x176>
  803164:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80316c:	8b 52 04             	mov    0x4(%edx),%edx
  80316f:	89 50 04             	mov    %edx,0x4(%eax)
  803172:	eb 0b                	jmp    80317f <alloc_block_BF+0x181>
  803174:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803177:	8b 40 04             	mov    0x4(%eax),%eax
  80317a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80317f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803182:	8b 40 04             	mov    0x4(%eax),%eax
  803185:	85 c0                	test   %eax,%eax
  803187:	74 0f                	je     803198 <alloc_block_BF+0x19a>
  803189:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80318c:	8b 40 04             	mov    0x4(%eax),%eax
  80318f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803192:	8b 12                	mov    (%edx),%edx
  803194:	89 10                	mov    %edx,(%eax)
  803196:	eb 0a                	jmp    8031a2 <alloc_block_BF+0x1a4>
  803198:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80319b:	8b 00                	mov    (%eax),%eax
  80319d:	a3 48 51 80 00       	mov    %eax,0x805148
  8031a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b5:	a1 54 51 80 00       	mov    0x805154,%eax
  8031ba:	48                   	dec    %eax
  8031bb:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  8031c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c6:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  8031c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031cc:	8b 50 08             	mov    0x8(%eax),%edx
  8031cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031d2:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  8031d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031db:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  8031de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e1:	8b 50 08             	mov    0x8(%eax),%edx
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	01 c2                	add    %eax,%edx
  8031e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ec:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  8031ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  8031f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f8:	eb 05                	jmp    8031ff <alloc_block_BF+0x201>
	 }
	 return NULL;
  8031fa:	b8 00 00 00 00       	mov    $0x0,%eax


}
  8031ff:	c9                   	leave  
  803200:	c3                   	ret    

00803201 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803201:	55                   	push   %ebp
  803202:	89 e5                	mov    %esp,%ebp
  803204:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  803207:	83 ec 04             	sub    $0x4,%esp
  80320a:	68 a8 44 80 00       	push   $0x8044a8
  80320f:	68 e8 00 00 00       	push   $0xe8
  803214:	68 17 44 80 00       	push   $0x804417
  803219:	e8 26 da ff ff       	call   800c44 <_panic>

0080321e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80321e:	55                   	push   %ebp
  80321f:	89 e5                	mov    %esp,%ebp
  803221:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  803224:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803229:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  80322c:	a1 38 51 80 00       	mov    0x805138,%eax
  803231:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  803234:	a1 44 51 80 00       	mov    0x805144,%eax
  803239:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  80323c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803240:	75 68                	jne    8032aa <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803242:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803246:	75 17                	jne    80325f <insert_sorted_with_merge_freeList+0x41>
  803248:	83 ec 04             	sub    $0x4,%esp
  80324b:	68 f4 43 80 00       	push   $0x8043f4
  803250:	68 36 01 00 00       	push   $0x136
  803255:	68 17 44 80 00       	push   $0x804417
  80325a:	e8 e5 d9 ff ff       	call   800c44 <_panic>
  80325f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	89 10                	mov    %edx,(%eax)
  80326a:	8b 45 08             	mov    0x8(%ebp),%eax
  80326d:	8b 00                	mov    (%eax),%eax
  80326f:	85 c0                	test   %eax,%eax
  803271:	74 0d                	je     803280 <insert_sorted_with_merge_freeList+0x62>
  803273:	a1 38 51 80 00       	mov    0x805138,%eax
  803278:	8b 55 08             	mov    0x8(%ebp),%edx
  80327b:	89 50 04             	mov    %edx,0x4(%eax)
  80327e:	eb 08                	jmp    803288 <insert_sorted_with_merge_freeList+0x6a>
  803280:	8b 45 08             	mov    0x8(%ebp),%eax
  803283:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803288:	8b 45 08             	mov    0x8(%ebp),%eax
  80328b:	a3 38 51 80 00       	mov    %eax,0x805138
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329a:	a1 44 51 80 00       	mov    0x805144,%eax
  80329f:	40                   	inc    %eax
  8032a0:	a3 44 51 80 00       	mov    %eax,0x805144





}
  8032a5:	e9 ba 06 00 00       	jmp    803964 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  8032aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ad:	8b 50 08             	mov    0x8(%eax),%edx
  8032b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b6:	01 c2                	add    %eax,%edx
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	8b 40 08             	mov    0x8(%eax),%eax
  8032be:	39 c2                	cmp    %eax,%edx
  8032c0:	73 68                	jae    80332a <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8032c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c6:	75 17                	jne    8032df <insert_sorted_with_merge_freeList+0xc1>
  8032c8:	83 ec 04             	sub    $0x4,%esp
  8032cb:	68 30 44 80 00       	push   $0x804430
  8032d0:	68 3a 01 00 00       	push   $0x13a
  8032d5:	68 17 44 80 00       	push   $0x804417
  8032da:	e8 65 d9 ff ff       	call   800c44 <_panic>
  8032df:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e8:	89 50 04             	mov    %edx,0x4(%eax)
  8032eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ee:	8b 40 04             	mov    0x4(%eax),%eax
  8032f1:	85 c0                	test   %eax,%eax
  8032f3:	74 0c                	je     803301 <insert_sorted_with_merge_freeList+0xe3>
  8032f5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8032fd:	89 10                	mov    %edx,(%eax)
  8032ff:	eb 08                	jmp    803309 <insert_sorted_with_merge_freeList+0xeb>
  803301:	8b 45 08             	mov    0x8(%ebp),%eax
  803304:	a3 38 51 80 00       	mov    %eax,0x805138
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80331a:	a1 44 51 80 00       	mov    0x805144,%eax
  80331f:	40                   	inc    %eax
  803320:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803325:	e9 3a 06 00 00       	jmp    803964 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  80332a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332d:	8b 50 08             	mov    0x8(%eax),%edx
  803330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803333:	8b 40 0c             	mov    0xc(%eax),%eax
  803336:	01 c2                	add    %eax,%edx
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	8b 40 08             	mov    0x8(%eax),%eax
  80333e:	39 c2                	cmp    %eax,%edx
  803340:	0f 85 90 00 00 00    	jne    8033d6 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  803346:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803349:	8b 50 0c             	mov    0xc(%eax),%edx
  80334c:	8b 45 08             	mov    0x8(%ebp),%eax
  80334f:	8b 40 0c             	mov    0xc(%eax),%eax
  803352:	01 c2                	add    %eax,%edx
  803354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803357:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  803364:	8b 45 08             	mov    0x8(%ebp),%eax
  803367:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80336e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803372:	75 17                	jne    80338b <insert_sorted_with_merge_freeList+0x16d>
  803374:	83 ec 04             	sub    $0x4,%esp
  803377:	68 f4 43 80 00       	push   $0x8043f4
  80337c:	68 41 01 00 00       	push   $0x141
  803381:	68 17 44 80 00       	push   $0x804417
  803386:	e8 b9 d8 ff ff       	call   800c44 <_panic>
  80338b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803391:	8b 45 08             	mov    0x8(%ebp),%eax
  803394:	89 10                	mov    %edx,(%eax)
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	8b 00                	mov    (%eax),%eax
  80339b:	85 c0                	test   %eax,%eax
  80339d:	74 0d                	je     8033ac <insert_sorted_with_merge_freeList+0x18e>
  80339f:	a1 48 51 80 00       	mov    0x805148,%eax
  8033a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a7:	89 50 04             	mov    %edx,0x4(%eax)
  8033aa:	eb 08                	jmp    8033b4 <insert_sorted_with_merge_freeList+0x196>
  8033ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8033af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b7:	a3 48 51 80 00       	mov    %eax,0x805148
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c6:	a1 54 51 80 00       	mov    0x805154,%eax
  8033cb:	40                   	inc    %eax
  8033cc:	a3 54 51 80 00       	mov    %eax,0x805154





}
  8033d1:	e9 8e 05 00 00       	jmp    803964 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	8b 50 08             	mov    0x8(%eax),%edx
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e2:	01 c2                	add    %eax,%edx
  8033e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e7:	8b 40 08             	mov    0x8(%eax),%eax
  8033ea:	39 c2                	cmp    %eax,%edx
  8033ec:	73 68                	jae    803456 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8033ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033f2:	75 17                	jne    80340b <insert_sorted_with_merge_freeList+0x1ed>
  8033f4:	83 ec 04             	sub    $0x4,%esp
  8033f7:	68 f4 43 80 00       	push   $0x8043f4
  8033fc:	68 45 01 00 00       	push   $0x145
  803401:	68 17 44 80 00       	push   $0x804417
  803406:	e8 39 d8 ff ff       	call   800c44 <_panic>
  80340b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803411:	8b 45 08             	mov    0x8(%ebp),%eax
  803414:	89 10                	mov    %edx,(%eax)
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	85 c0                	test   %eax,%eax
  80341d:	74 0d                	je     80342c <insert_sorted_with_merge_freeList+0x20e>
  80341f:	a1 38 51 80 00       	mov    0x805138,%eax
  803424:	8b 55 08             	mov    0x8(%ebp),%edx
  803427:	89 50 04             	mov    %edx,0x4(%eax)
  80342a:	eb 08                	jmp    803434 <insert_sorted_with_merge_freeList+0x216>
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803434:	8b 45 08             	mov    0x8(%ebp),%eax
  803437:	a3 38 51 80 00       	mov    %eax,0x805138
  80343c:	8b 45 08             	mov    0x8(%ebp),%eax
  80343f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803446:	a1 44 51 80 00       	mov    0x805144,%eax
  80344b:	40                   	inc    %eax
  80344c:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803451:	e9 0e 05 00 00       	jmp    803964 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	8b 50 08             	mov    0x8(%eax),%edx
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	8b 40 0c             	mov    0xc(%eax),%eax
  803462:	01 c2                	add    %eax,%edx
  803464:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803467:	8b 40 08             	mov    0x8(%eax),%eax
  80346a:	39 c2                	cmp    %eax,%edx
  80346c:	0f 85 9c 00 00 00    	jne    80350e <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  803472:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803475:	8b 50 0c             	mov    0xc(%eax),%edx
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	8b 40 0c             	mov    0xc(%eax),%eax
  80347e:	01 c2                	add    %eax,%edx
  803480:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803483:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	8b 50 08             	mov    0x8(%eax),%edx
  80348c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80348f:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  80349c:	8b 45 08             	mov    0x8(%ebp),%eax
  80349f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034aa:	75 17                	jne    8034c3 <insert_sorted_with_merge_freeList+0x2a5>
  8034ac:	83 ec 04             	sub    $0x4,%esp
  8034af:	68 f4 43 80 00       	push   $0x8043f4
  8034b4:	68 4d 01 00 00       	push   $0x14d
  8034b9:	68 17 44 80 00       	push   $0x804417
  8034be:	e8 81 d7 ff ff       	call   800c44 <_panic>
  8034c3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cc:	89 10                	mov    %edx,(%eax)
  8034ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d1:	8b 00                	mov    (%eax),%eax
  8034d3:	85 c0                	test   %eax,%eax
  8034d5:	74 0d                	je     8034e4 <insert_sorted_with_merge_freeList+0x2c6>
  8034d7:	a1 48 51 80 00       	mov    0x805148,%eax
  8034dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8034df:	89 50 04             	mov    %edx,0x4(%eax)
  8034e2:	eb 08                	jmp    8034ec <insert_sorted_with_merge_freeList+0x2ce>
  8034e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ef:	a3 48 51 80 00       	mov    %eax,0x805148
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034fe:	a1 54 51 80 00       	mov    0x805154,%eax
  803503:	40                   	inc    %eax
  803504:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803509:	e9 56 04 00 00       	jmp    803964 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  80350e:	a1 38 51 80 00       	mov    0x805138,%eax
  803513:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803516:	e9 19 04 00 00       	jmp    803934 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  80351b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351e:	8b 00                	mov    (%eax),%eax
  803520:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803526:	8b 50 08             	mov    0x8(%eax),%edx
  803529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352c:	8b 40 0c             	mov    0xc(%eax),%eax
  80352f:	01 c2                	add    %eax,%edx
  803531:	8b 45 08             	mov    0x8(%ebp),%eax
  803534:	8b 40 08             	mov    0x8(%eax),%eax
  803537:	39 c2                	cmp    %eax,%edx
  803539:	0f 85 ad 01 00 00    	jne    8036ec <insert_sorted_with_merge_freeList+0x4ce>
  80353f:	8b 45 08             	mov    0x8(%ebp),%eax
  803542:	8b 50 08             	mov    0x8(%eax),%edx
  803545:	8b 45 08             	mov    0x8(%ebp),%eax
  803548:	8b 40 0c             	mov    0xc(%eax),%eax
  80354b:	01 c2                	add    %eax,%edx
  80354d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803550:	8b 40 08             	mov    0x8(%eax),%eax
  803553:	39 c2                	cmp    %eax,%edx
  803555:	0f 85 91 01 00 00    	jne    8036ec <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  80355b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355e:	8b 50 0c             	mov    0xc(%eax),%edx
  803561:	8b 45 08             	mov    0x8(%ebp),%eax
  803564:	8b 48 0c             	mov    0xc(%eax),%ecx
  803567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356a:	8b 40 0c             	mov    0xc(%eax),%eax
  80356d:	01 c8                	add    %ecx,%eax
  80356f:	01 c2                	add    %eax,%edx
  803571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803574:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  803577:	8b 45 08             	mov    0x8(%ebp),%eax
  80357a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803581:	8b 45 08             	mov    0x8(%ebp),%eax
  803584:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  80358b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80358e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  803595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803598:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  80359f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035a3:	75 17                	jne    8035bc <insert_sorted_with_merge_freeList+0x39e>
  8035a5:	83 ec 04             	sub    $0x4,%esp
  8035a8:	68 88 44 80 00       	push   $0x804488
  8035ad:	68 5b 01 00 00       	push   $0x15b
  8035b2:	68 17 44 80 00       	push   $0x804417
  8035b7:	e8 88 d6 ff ff       	call   800c44 <_panic>
  8035bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035bf:	8b 00                	mov    (%eax),%eax
  8035c1:	85 c0                	test   %eax,%eax
  8035c3:	74 10                	je     8035d5 <insert_sorted_with_merge_freeList+0x3b7>
  8035c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c8:	8b 00                	mov    (%eax),%eax
  8035ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035cd:	8b 52 04             	mov    0x4(%edx),%edx
  8035d0:	89 50 04             	mov    %edx,0x4(%eax)
  8035d3:	eb 0b                	jmp    8035e0 <insert_sorted_with_merge_freeList+0x3c2>
  8035d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d8:	8b 40 04             	mov    0x4(%eax),%eax
  8035db:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e3:	8b 40 04             	mov    0x4(%eax),%eax
  8035e6:	85 c0                	test   %eax,%eax
  8035e8:	74 0f                	je     8035f9 <insert_sorted_with_merge_freeList+0x3db>
  8035ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ed:	8b 40 04             	mov    0x4(%eax),%eax
  8035f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035f3:	8b 12                	mov    (%edx),%edx
  8035f5:	89 10                	mov    %edx,(%eax)
  8035f7:	eb 0a                	jmp    803603 <insert_sorted_with_merge_freeList+0x3e5>
  8035f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fc:	8b 00                	mov    (%eax),%eax
  8035fe:	a3 38 51 80 00       	mov    %eax,0x805138
  803603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803606:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80360c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803616:	a1 44 51 80 00       	mov    0x805144,%eax
  80361b:	48                   	dec    %eax
  80361c:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803621:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803625:	75 17                	jne    80363e <insert_sorted_with_merge_freeList+0x420>
  803627:	83 ec 04             	sub    $0x4,%esp
  80362a:	68 f4 43 80 00       	push   $0x8043f4
  80362f:	68 5c 01 00 00       	push   $0x15c
  803634:	68 17 44 80 00       	push   $0x804417
  803639:	e8 06 d6 ff ff       	call   800c44 <_panic>
  80363e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803644:	8b 45 08             	mov    0x8(%ebp),%eax
  803647:	89 10                	mov    %edx,(%eax)
  803649:	8b 45 08             	mov    0x8(%ebp),%eax
  80364c:	8b 00                	mov    (%eax),%eax
  80364e:	85 c0                	test   %eax,%eax
  803650:	74 0d                	je     80365f <insert_sorted_with_merge_freeList+0x441>
  803652:	a1 48 51 80 00       	mov    0x805148,%eax
  803657:	8b 55 08             	mov    0x8(%ebp),%edx
  80365a:	89 50 04             	mov    %edx,0x4(%eax)
  80365d:	eb 08                	jmp    803667 <insert_sorted_with_merge_freeList+0x449>
  80365f:	8b 45 08             	mov    0x8(%ebp),%eax
  803662:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803667:	8b 45 08             	mov    0x8(%ebp),%eax
  80366a:	a3 48 51 80 00       	mov    %eax,0x805148
  80366f:	8b 45 08             	mov    0x8(%ebp),%eax
  803672:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803679:	a1 54 51 80 00       	mov    0x805154,%eax
  80367e:	40                   	inc    %eax
  80367f:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  803684:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803688:	75 17                	jne    8036a1 <insert_sorted_with_merge_freeList+0x483>
  80368a:	83 ec 04             	sub    $0x4,%esp
  80368d:	68 f4 43 80 00       	push   $0x8043f4
  803692:	68 5d 01 00 00       	push   $0x15d
  803697:	68 17 44 80 00       	push   $0x804417
  80369c:	e8 a3 d5 ff ff       	call   800c44 <_panic>
  8036a1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036aa:	89 10                	mov    %edx,(%eax)
  8036ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036af:	8b 00                	mov    (%eax),%eax
  8036b1:	85 c0                	test   %eax,%eax
  8036b3:	74 0d                	je     8036c2 <insert_sorted_with_merge_freeList+0x4a4>
  8036b5:	a1 48 51 80 00       	mov    0x805148,%eax
  8036ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036bd:	89 50 04             	mov    %edx,0x4(%eax)
  8036c0:	eb 08                	jmp    8036ca <insert_sorted_with_merge_freeList+0x4ac>
  8036c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036cd:	a3 48 51 80 00       	mov    %eax,0x805148
  8036d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036dc:	a1 54 51 80 00       	mov    0x805154,%eax
  8036e1:	40                   	inc    %eax
  8036e2:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  8036e7:	e9 78 02 00 00       	jmp    803964 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  8036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ef:	8b 50 08             	mov    0x8(%eax),%edx
  8036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f8:	01 c2                	add    %eax,%edx
  8036fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fd:	8b 40 08             	mov    0x8(%eax),%eax
  803700:	39 c2                	cmp    %eax,%edx
  803702:	0f 83 b8 00 00 00    	jae    8037c0 <insert_sorted_with_merge_freeList+0x5a2>
  803708:	8b 45 08             	mov    0x8(%ebp),%eax
  80370b:	8b 50 08             	mov    0x8(%eax),%edx
  80370e:	8b 45 08             	mov    0x8(%ebp),%eax
  803711:	8b 40 0c             	mov    0xc(%eax),%eax
  803714:	01 c2                	add    %eax,%edx
  803716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803719:	8b 40 08             	mov    0x8(%eax),%eax
  80371c:	39 c2                	cmp    %eax,%edx
  80371e:	0f 85 9c 00 00 00    	jne    8037c0 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  803724:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803727:	8b 50 0c             	mov    0xc(%eax),%edx
  80372a:	8b 45 08             	mov    0x8(%ebp),%eax
  80372d:	8b 40 0c             	mov    0xc(%eax),%eax
  803730:	01 c2                	add    %eax,%edx
  803732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803735:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  803738:	8b 45 08             	mov    0x8(%ebp),%eax
  80373b:	8b 50 08             	mov    0x8(%eax),%edx
  80373e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803741:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  803744:	8b 45 08             	mov    0x8(%ebp),%eax
  803747:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  80374e:	8b 45 08             	mov    0x8(%ebp),%eax
  803751:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803758:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80375c:	75 17                	jne    803775 <insert_sorted_with_merge_freeList+0x557>
  80375e:	83 ec 04             	sub    $0x4,%esp
  803761:	68 f4 43 80 00       	push   $0x8043f4
  803766:	68 67 01 00 00       	push   $0x167
  80376b:	68 17 44 80 00       	push   $0x804417
  803770:	e8 cf d4 ff ff       	call   800c44 <_panic>
  803775:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80377b:	8b 45 08             	mov    0x8(%ebp),%eax
  80377e:	89 10                	mov    %edx,(%eax)
  803780:	8b 45 08             	mov    0x8(%ebp),%eax
  803783:	8b 00                	mov    (%eax),%eax
  803785:	85 c0                	test   %eax,%eax
  803787:	74 0d                	je     803796 <insert_sorted_with_merge_freeList+0x578>
  803789:	a1 48 51 80 00       	mov    0x805148,%eax
  80378e:	8b 55 08             	mov    0x8(%ebp),%edx
  803791:	89 50 04             	mov    %edx,0x4(%eax)
  803794:	eb 08                	jmp    80379e <insert_sorted_with_merge_freeList+0x580>
  803796:	8b 45 08             	mov    0x8(%ebp),%eax
  803799:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80379e:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a1:	a3 48 51 80 00       	mov    %eax,0x805148
  8037a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037b0:	a1 54 51 80 00       	mov    0x805154,%eax
  8037b5:	40                   	inc    %eax
  8037b6:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  8037bb:	e9 a4 01 00 00       	jmp    803964 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8037c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c3:	8b 50 08             	mov    0x8(%eax),%edx
  8037c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8037cc:	01 c2                	add    %eax,%edx
  8037ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d1:	8b 40 08             	mov    0x8(%eax),%eax
  8037d4:	39 c2                	cmp    %eax,%edx
  8037d6:	0f 85 ac 00 00 00    	jne    803888 <insert_sorted_with_merge_freeList+0x66a>
  8037dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037df:	8b 50 08             	mov    0x8(%eax),%edx
  8037e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8037e8:	01 c2                	add    %eax,%edx
  8037ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ed:	8b 40 08             	mov    0x8(%eax),%eax
  8037f0:	39 c2                	cmp    %eax,%edx
  8037f2:	0f 83 90 00 00 00    	jae    803888 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  8037f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fb:	8b 50 0c             	mov    0xc(%eax),%edx
  8037fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803801:	8b 40 0c             	mov    0xc(%eax),%eax
  803804:	01 c2                	add    %eax,%edx
  803806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803809:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  80380c:	8b 45 08             	mov    0x8(%ebp),%eax
  80380f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  803816:	8b 45 08             	mov    0x8(%ebp),%eax
  803819:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803820:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803824:	75 17                	jne    80383d <insert_sorted_with_merge_freeList+0x61f>
  803826:	83 ec 04             	sub    $0x4,%esp
  803829:	68 f4 43 80 00       	push   $0x8043f4
  80382e:	68 70 01 00 00       	push   $0x170
  803833:	68 17 44 80 00       	push   $0x804417
  803838:	e8 07 d4 ff ff       	call   800c44 <_panic>
  80383d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803843:	8b 45 08             	mov    0x8(%ebp),%eax
  803846:	89 10                	mov    %edx,(%eax)
  803848:	8b 45 08             	mov    0x8(%ebp),%eax
  80384b:	8b 00                	mov    (%eax),%eax
  80384d:	85 c0                	test   %eax,%eax
  80384f:	74 0d                	je     80385e <insert_sorted_with_merge_freeList+0x640>
  803851:	a1 48 51 80 00       	mov    0x805148,%eax
  803856:	8b 55 08             	mov    0x8(%ebp),%edx
  803859:	89 50 04             	mov    %edx,0x4(%eax)
  80385c:	eb 08                	jmp    803866 <insert_sorted_with_merge_freeList+0x648>
  80385e:	8b 45 08             	mov    0x8(%ebp),%eax
  803861:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803866:	8b 45 08             	mov    0x8(%ebp),%eax
  803869:	a3 48 51 80 00       	mov    %eax,0x805148
  80386e:	8b 45 08             	mov    0x8(%ebp),%eax
  803871:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803878:	a1 54 51 80 00       	mov    0x805154,%eax
  80387d:	40                   	inc    %eax
  80387e:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  803883:	e9 dc 00 00 00       	jmp    803964 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388b:	8b 50 08             	mov    0x8(%eax),%edx
  80388e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803891:	8b 40 0c             	mov    0xc(%eax),%eax
  803894:	01 c2                	add    %eax,%edx
  803896:	8b 45 08             	mov    0x8(%ebp),%eax
  803899:	8b 40 08             	mov    0x8(%eax),%eax
  80389c:	39 c2                	cmp    %eax,%edx
  80389e:	0f 83 88 00 00 00    	jae    80392c <insert_sorted_with_merge_freeList+0x70e>
  8038a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a7:	8b 50 08             	mov    0x8(%eax),%edx
  8038aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8038b0:	01 c2                	add    %eax,%edx
  8038b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038b5:	8b 40 08             	mov    0x8(%eax),%eax
  8038b8:	39 c2                	cmp    %eax,%edx
  8038ba:	73 70                	jae    80392c <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  8038bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038c0:	74 06                	je     8038c8 <insert_sorted_with_merge_freeList+0x6aa>
  8038c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038c6:	75 17                	jne    8038df <insert_sorted_with_merge_freeList+0x6c1>
  8038c8:	83 ec 04             	sub    $0x4,%esp
  8038cb:	68 54 44 80 00       	push   $0x804454
  8038d0:	68 75 01 00 00       	push   $0x175
  8038d5:	68 17 44 80 00       	push   $0x804417
  8038da:	e8 65 d3 ff ff       	call   800c44 <_panic>
  8038df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e2:	8b 10                	mov    (%eax),%edx
  8038e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e7:	89 10                	mov    %edx,(%eax)
  8038e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ec:	8b 00                	mov    (%eax),%eax
  8038ee:	85 c0                	test   %eax,%eax
  8038f0:	74 0b                	je     8038fd <insert_sorted_with_merge_freeList+0x6df>
  8038f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038f5:	8b 00                	mov    (%eax),%eax
  8038f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8038fa:	89 50 04             	mov    %edx,0x4(%eax)
  8038fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803900:	8b 55 08             	mov    0x8(%ebp),%edx
  803903:	89 10                	mov    %edx,(%eax)
  803905:	8b 45 08             	mov    0x8(%ebp),%eax
  803908:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80390b:	89 50 04             	mov    %edx,0x4(%eax)
  80390e:	8b 45 08             	mov    0x8(%ebp),%eax
  803911:	8b 00                	mov    (%eax),%eax
  803913:	85 c0                	test   %eax,%eax
  803915:	75 08                	jne    80391f <insert_sorted_with_merge_freeList+0x701>
  803917:	8b 45 08             	mov    0x8(%ebp),%eax
  80391a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80391f:	a1 44 51 80 00       	mov    0x805144,%eax
  803924:	40                   	inc    %eax
  803925:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  80392a:	eb 38                	jmp    803964 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  80392c:	a1 40 51 80 00       	mov    0x805140,%eax
  803931:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803934:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803938:	74 07                	je     803941 <insert_sorted_with_merge_freeList+0x723>
  80393a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393d:	8b 00                	mov    (%eax),%eax
  80393f:	eb 05                	jmp    803946 <insert_sorted_with_merge_freeList+0x728>
  803941:	b8 00 00 00 00       	mov    $0x0,%eax
  803946:	a3 40 51 80 00       	mov    %eax,0x805140
  80394b:	a1 40 51 80 00       	mov    0x805140,%eax
  803950:	85 c0                	test   %eax,%eax
  803952:	0f 85 c3 fb ff ff    	jne    80351b <insert_sorted_with_merge_freeList+0x2fd>
  803958:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80395c:	0f 85 b9 fb ff ff    	jne    80351b <insert_sorted_with_merge_freeList+0x2fd>





}
  803962:	eb 00                	jmp    803964 <insert_sorted_with_merge_freeList+0x746>
  803964:	90                   	nop
  803965:	c9                   	leave  
  803966:	c3                   	ret    
  803967:	90                   	nop

00803968 <__udivdi3>:
  803968:	55                   	push   %ebp
  803969:	57                   	push   %edi
  80396a:	56                   	push   %esi
  80396b:	53                   	push   %ebx
  80396c:	83 ec 1c             	sub    $0x1c,%esp
  80396f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803973:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803977:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80397b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80397f:	89 ca                	mov    %ecx,%edx
  803981:	89 f8                	mov    %edi,%eax
  803983:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803987:	85 f6                	test   %esi,%esi
  803989:	75 2d                	jne    8039b8 <__udivdi3+0x50>
  80398b:	39 cf                	cmp    %ecx,%edi
  80398d:	77 65                	ja     8039f4 <__udivdi3+0x8c>
  80398f:	89 fd                	mov    %edi,%ebp
  803991:	85 ff                	test   %edi,%edi
  803993:	75 0b                	jne    8039a0 <__udivdi3+0x38>
  803995:	b8 01 00 00 00       	mov    $0x1,%eax
  80399a:	31 d2                	xor    %edx,%edx
  80399c:	f7 f7                	div    %edi
  80399e:	89 c5                	mov    %eax,%ebp
  8039a0:	31 d2                	xor    %edx,%edx
  8039a2:	89 c8                	mov    %ecx,%eax
  8039a4:	f7 f5                	div    %ebp
  8039a6:	89 c1                	mov    %eax,%ecx
  8039a8:	89 d8                	mov    %ebx,%eax
  8039aa:	f7 f5                	div    %ebp
  8039ac:	89 cf                	mov    %ecx,%edi
  8039ae:	89 fa                	mov    %edi,%edx
  8039b0:	83 c4 1c             	add    $0x1c,%esp
  8039b3:	5b                   	pop    %ebx
  8039b4:	5e                   	pop    %esi
  8039b5:	5f                   	pop    %edi
  8039b6:	5d                   	pop    %ebp
  8039b7:	c3                   	ret    
  8039b8:	39 ce                	cmp    %ecx,%esi
  8039ba:	77 28                	ja     8039e4 <__udivdi3+0x7c>
  8039bc:	0f bd fe             	bsr    %esi,%edi
  8039bf:	83 f7 1f             	xor    $0x1f,%edi
  8039c2:	75 40                	jne    803a04 <__udivdi3+0x9c>
  8039c4:	39 ce                	cmp    %ecx,%esi
  8039c6:	72 0a                	jb     8039d2 <__udivdi3+0x6a>
  8039c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039cc:	0f 87 9e 00 00 00    	ja     803a70 <__udivdi3+0x108>
  8039d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8039d7:	89 fa                	mov    %edi,%edx
  8039d9:	83 c4 1c             	add    $0x1c,%esp
  8039dc:	5b                   	pop    %ebx
  8039dd:	5e                   	pop    %esi
  8039de:	5f                   	pop    %edi
  8039df:	5d                   	pop    %ebp
  8039e0:	c3                   	ret    
  8039e1:	8d 76 00             	lea    0x0(%esi),%esi
  8039e4:	31 ff                	xor    %edi,%edi
  8039e6:	31 c0                	xor    %eax,%eax
  8039e8:	89 fa                	mov    %edi,%edx
  8039ea:	83 c4 1c             	add    $0x1c,%esp
  8039ed:	5b                   	pop    %ebx
  8039ee:	5e                   	pop    %esi
  8039ef:	5f                   	pop    %edi
  8039f0:	5d                   	pop    %ebp
  8039f1:	c3                   	ret    
  8039f2:	66 90                	xchg   %ax,%ax
  8039f4:	89 d8                	mov    %ebx,%eax
  8039f6:	f7 f7                	div    %edi
  8039f8:	31 ff                	xor    %edi,%edi
  8039fa:	89 fa                	mov    %edi,%edx
  8039fc:	83 c4 1c             	add    $0x1c,%esp
  8039ff:	5b                   	pop    %ebx
  803a00:	5e                   	pop    %esi
  803a01:	5f                   	pop    %edi
  803a02:	5d                   	pop    %ebp
  803a03:	c3                   	ret    
  803a04:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a09:	89 eb                	mov    %ebp,%ebx
  803a0b:	29 fb                	sub    %edi,%ebx
  803a0d:	89 f9                	mov    %edi,%ecx
  803a0f:	d3 e6                	shl    %cl,%esi
  803a11:	89 c5                	mov    %eax,%ebp
  803a13:	88 d9                	mov    %bl,%cl
  803a15:	d3 ed                	shr    %cl,%ebp
  803a17:	89 e9                	mov    %ebp,%ecx
  803a19:	09 f1                	or     %esi,%ecx
  803a1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a1f:	89 f9                	mov    %edi,%ecx
  803a21:	d3 e0                	shl    %cl,%eax
  803a23:	89 c5                	mov    %eax,%ebp
  803a25:	89 d6                	mov    %edx,%esi
  803a27:	88 d9                	mov    %bl,%cl
  803a29:	d3 ee                	shr    %cl,%esi
  803a2b:	89 f9                	mov    %edi,%ecx
  803a2d:	d3 e2                	shl    %cl,%edx
  803a2f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a33:	88 d9                	mov    %bl,%cl
  803a35:	d3 e8                	shr    %cl,%eax
  803a37:	09 c2                	or     %eax,%edx
  803a39:	89 d0                	mov    %edx,%eax
  803a3b:	89 f2                	mov    %esi,%edx
  803a3d:	f7 74 24 0c          	divl   0xc(%esp)
  803a41:	89 d6                	mov    %edx,%esi
  803a43:	89 c3                	mov    %eax,%ebx
  803a45:	f7 e5                	mul    %ebp
  803a47:	39 d6                	cmp    %edx,%esi
  803a49:	72 19                	jb     803a64 <__udivdi3+0xfc>
  803a4b:	74 0b                	je     803a58 <__udivdi3+0xf0>
  803a4d:	89 d8                	mov    %ebx,%eax
  803a4f:	31 ff                	xor    %edi,%edi
  803a51:	e9 58 ff ff ff       	jmp    8039ae <__udivdi3+0x46>
  803a56:	66 90                	xchg   %ax,%ax
  803a58:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a5c:	89 f9                	mov    %edi,%ecx
  803a5e:	d3 e2                	shl    %cl,%edx
  803a60:	39 c2                	cmp    %eax,%edx
  803a62:	73 e9                	jae    803a4d <__udivdi3+0xe5>
  803a64:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a67:	31 ff                	xor    %edi,%edi
  803a69:	e9 40 ff ff ff       	jmp    8039ae <__udivdi3+0x46>
  803a6e:	66 90                	xchg   %ax,%ax
  803a70:	31 c0                	xor    %eax,%eax
  803a72:	e9 37 ff ff ff       	jmp    8039ae <__udivdi3+0x46>
  803a77:	90                   	nop

00803a78 <__umoddi3>:
  803a78:	55                   	push   %ebp
  803a79:	57                   	push   %edi
  803a7a:	56                   	push   %esi
  803a7b:	53                   	push   %ebx
  803a7c:	83 ec 1c             	sub    $0x1c,%esp
  803a7f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a83:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a87:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a8b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a97:	89 f3                	mov    %esi,%ebx
  803a99:	89 fa                	mov    %edi,%edx
  803a9b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a9f:	89 34 24             	mov    %esi,(%esp)
  803aa2:	85 c0                	test   %eax,%eax
  803aa4:	75 1a                	jne    803ac0 <__umoddi3+0x48>
  803aa6:	39 f7                	cmp    %esi,%edi
  803aa8:	0f 86 a2 00 00 00    	jbe    803b50 <__umoddi3+0xd8>
  803aae:	89 c8                	mov    %ecx,%eax
  803ab0:	89 f2                	mov    %esi,%edx
  803ab2:	f7 f7                	div    %edi
  803ab4:	89 d0                	mov    %edx,%eax
  803ab6:	31 d2                	xor    %edx,%edx
  803ab8:	83 c4 1c             	add    $0x1c,%esp
  803abb:	5b                   	pop    %ebx
  803abc:	5e                   	pop    %esi
  803abd:	5f                   	pop    %edi
  803abe:	5d                   	pop    %ebp
  803abf:	c3                   	ret    
  803ac0:	39 f0                	cmp    %esi,%eax
  803ac2:	0f 87 ac 00 00 00    	ja     803b74 <__umoddi3+0xfc>
  803ac8:	0f bd e8             	bsr    %eax,%ebp
  803acb:	83 f5 1f             	xor    $0x1f,%ebp
  803ace:	0f 84 ac 00 00 00    	je     803b80 <__umoddi3+0x108>
  803ad4:	bf 20 00 00 00       	mov    $0x20,%edi
  803ad9:	29 ef                	sub    %ebp,%edi
  803adb:	89 fe                	mov    %edi,%esi
  803add:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ae1:	89 e9                	mov    %ebp,%ecx
  803ae3:	d3 e0                	shl    %cl,%eax
  803ae5:	89 d7                	mov    %edx,%edi
  803ae7:	89 f1                	mov    %esi,%ecx
  803ae9:	d3 ef                	shr    %cl,%edi
  803aeb:	09 c7                	or     %eax,%edi
  803aed:	89 e9                	mov    %ebp,%ecx
  803aef:	d3 e2                	shl    %cl,%edx
  803af1:	89 14 24             	mov    %edx,(%esp)
  803af4:	89 d8                	mov    %ebx,%eax
  803af6:	d3 e0                	shl    %cl,%eax
  803af8:	89 c2                	mov    %eax,%edx
  803afa:	8b 44 24 08          	mov    0x8(%esp),%eax
  803afe:	d3 e0                	shl    %cl,%eax
  803b00:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b04:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b08:	89 f1                	mov    %esi,%ecx
  803b0a:	d3 e8                	shr    %cl,%eax
  803b0c:	09 d0                	or     %edx,%eax
  803b0e:	d3 eb                	shr    %cl,%ebx
  803b10:	89 da                	mov    %ebx,%edx
  803b12:	f7 f7                	div    %edi
  803b14:	89 d3                	mov    %edx,%ebx
  803b16:	f7 24 24             	mull   (%esp)
  803b19:	89 c6                	mov    %eax,%esi
  803b1b:	89 d1                	mov    %edx,%ecx
  803b1d:	39 d3                	cmp    %edx,%ebx
  803b1f:	0f 82 87 00 00 00    	jb     803bac <__umoddi3+0x134>
  803b25:	0f 84 91 00 00 00    	je     803bbc <__umoddi3+0x144>
  803b2b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b2f:	29 f2                	sub    %esi,%edx
  803b31:	19 cb                	sbb    %ecx,%ebx
  803b33:	89 d8                	mov    %ebx,%eax
  803b35:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b39:	d3 e0                	shl    %cl,%eax
  803b3b:	89 e9                	mov    %ebp,%ecx
  803b3d:	d3 ea                	shr    %cl,%edx
  803b3f:	09 d0                	or     %edx,%eax
  803b41:	89 e9                	mov    %ebp,%ecx
  803b43:	d3 eb                	shr    %cl,%ebx
  803b45:	89 da                	mov    %ebx,%edx
  803b47:	83 c4 1c             	add    $0x1c,%esp
  803b4a:	5b                   	pop    %ebx
  803b4b:	5e                   	pop    %esi
  803b4c:	5f                   	pop    %edi
  803b4d:	5d                   	pop    %ebp
  803b4e:	c3                   	ret    
  803b4f:	90                   	nop
  803b50:	89 fd                	mov    %edi,%ebp
  803b52:	85 ff                	test   %edi,%edi
  803b54:	75 0b                	jne    803b61 <__umoddi3+0xe9>
  803b56:	b8 01 00 00 00       	mov    $0x1,%eax
  803b5b:	31 d2                	xor    %edx,%edx
  803b5d:	f7 f7                	div    %edi
  803b5f:	89 c5                	mov    %eax,%ebp
  803b61:	89 f0                	mov    %esi,%eax
  803b63:	31 d2                	xor    %edx,%edx
  803b65:	f7 f5                	div    %ebp
  803b67:	89 c8                	mov    %ecx,%eax
  803b69:	f7 f5                	div    %ebp
  803b6b:	89 d0                	mov    %edx,%eax
  803b6d:	e9 44 ff ff ff       	jmp    803ab6 <__umoddi3+0x3e>
  803b72:	66 90                	xchg   %ax,%ax
  803b74:	89 c8                	mov    %ecx,%eax
  803b76:	89 f2                	mov    %esi,%edx
  803b78:	83 c4 1c             	add    $0x1c,%esp
  803b7b:	5b                   	pop    %ebx
  803b7c:	5e                   	pop    %esi
  803b7d:	5f                   	pop    %edi
  803b7e:	5d                   	pop    %ebp
  803b7f:	c3                   	ret    
  803b80:	3b 04 24             	cmp    (%esp),%eax
  803b83:	72 06                	jb     803b8b <__umoddi3+0x113>
  803b85:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b89:	77 0f                	ja     803b9a <__umoddi3+0x122>
  803b8b:	89 f2                	mov    %esi,%edx
  803b8d:	29 f9                	sub    %edi,%ecx
  803b8f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b93:	89 14 24             	mov    %edx,(%esp)
  803b96:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b9a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b9e:	8b 14 24             	mov    (%esp),%edx
  803ba1:	83 c4 1c             	add    $0x1c,%esp
  803ba4:	5b                   	pop    %ebx
  803ba5:	5e                   	pop    %esi
  803ba6:	5f                   	pop    %edi
  803ba7:	5d                   	pop    %ebp
  803ba8:	c3                   	ret    
  803ba9:	8d 76 00             	lea    0x0(%esi),%esi
  803bac:	2b 04 24             	sub    (%esp),%eax
  803baf:	19 fa                	sbb    %edi,%edx
  803bb1:	89 d1                	mov    %edx,%ecx
  803bb3:	89 c6                	mov    %eax,%esi
  803bb5:	e9 71 ff ff ff       	jmp    803b2b <__umoddi3+0xb3>
  803bba:	66 90                	xchg   %ax,%ax
  803bbc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bc0:	72 ea                	jb     803bac <__umoddi3+0x134>
  803bc2:	89 d9                	mov    %ebx,%ecx
  803bc4:	e9 62 ff ff ff       	jmp    803b2b <__umoddi3+0xb3>
