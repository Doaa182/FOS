
obj/user/tst_first_fit_3:     file format elf32-i386


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
  800031:	e8 c6 0e 00 00       	call   800efc <libmain>
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

	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 6f 2b 00 00       	call   802bb9 <sys_set_uheap_strategy>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

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
  80009b:	68 c0 3f 80 00       	push   $0x803fc0
  8000a0:	6a 16                	push   $0x16
  8000a2:	68 dc 3f 80 00       	push   $0x803fdc
  8000a7:	e8 8c 0f 00 00       	call   801038 <_panic>
	}

	int envID = sys_getenvid();
  8000ac:	e8 ba 28 00 00       	call   80296b <sys_getenvid>
  8000b1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b4:	83 ec 0c             	sub    $0xc,%esp
  8000b7:	6a 00                	push   $0x0
  8000b9:	e8 a7 21 00 00       	call   802265 <malloc>
  8000be:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000c1:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000c8:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  8000cf:	8d 55 8c             	lea    -0x74(%ebp),%edx
  8000d2:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000dc:	89 d7                	mov    %edx,%edi
  8000de:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000e0:	e8 bf 25 00 00       	call   8026a4 <sys_calculate_free_frames>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e8:	e8 57 26 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  8000ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	6a 01                	push   $0x1
  8000f8:	50                   	push   %eax
  8000f9:	68 f3 3f 80 00       	push   $0x803ff3
  8000fe:	e8 de 22 00 00       	call   8023e1 <smalloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if (ptr_allocations[0] != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800109:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80010c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800111:	74 14                	je     800127 <_main+0xef>
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 f8 3f 80 00       	push   $0x803ff8
  80011b:	6a 2a                	push   $0x2a
  80011d:	68 dc 3f 80 00       	push   $0x803fdc
  800122:	e8 11 0f 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  256+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800127:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80012a:	e8 75 25 00 00       	call   8026a4 <sys_calculate_free_frames>
  80012f:	29 c3                	sub    %eax,%ebx
  800131:	89 d8                	mov    %ebx,%eax
  800133:	3d 03 01 00 00       	cmp    $0x103,%eax
  800138:	74 14                	je     80014e <_main+0x116>
  80013a:	83 ec 04             	sub    $0x4,%esp
  80013d:	68 64 40 80 00       	push   $0x804064
  800142:	6a 2b                	push   $0x2b
  800144:	68 dc 3f 80 00       	push   $0x803fdc
  800149:	e8 ea 0e 00 00       	call   801038 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014e:	e8 f1 25 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800153:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 e2 40 80 00       	push   $0x8040e2
  800160:	6a 2c                	push   $0x2c
  800162:	68 dc 3f 80 00       	push   $0x803fdc
  800167:	e8 cc 0e 00 00       	call   801038 <_panic>

		cprintf("HERE 1\n") ;
  80016c:	83 ec 0c             	sub    $0xc,%esp
  80016f:	68 ff 40 80 00       	push   $0x8040ff
  800174:	e8 73 11 00 00       	call   8012ec <cprintf>
  800179:	83 c4 10             	add    $0x10,%esp
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80017c:	e8 23 25 00 00       	call   8026a4 <sys_calculate_free_frames>
  800181:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800184:	e8 bb 25 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800189:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80018c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80018f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800192:	83 ec 0c             	sub    $0xc,%esp
  800195:	50                   	push   %eax
  800196:	e8 ca 20 00 00       	call   802265 <malloc>
  80019b:	83 c4 10             	add    $0x10,%esp
  80019e:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8001a1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8001a4:	89 c2                	mov    %eax,%edx
  8001a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001a9:	05 00 00 00 80       	add    $0x80000000,%eax
  8001ae:	39 c2                	cmp    %eax,%edx
  8001b0:	74 14                	je     8001c6 <_main+0x18e>
  8001b2:	83 ec 04             	sub    $0x4,%esp
  8001b5:	68 08 41 80 00       	push   $0x804108
  8001ba:	6a 33                	push   $0x33
  8001bc:	68 dc 3f 80 00       	push   $0x803fdc
  8001c1:	e8 72 0e 00 00       	call   801038 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001c6:	e8 79 25 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  8001cb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 e2 40 80 00       	push   $0x8040e2
  8001d8:	6a 35                	push   $0x35
  8001da:	68 dc 3f 80 00       	push   $0x803fdc
  8001df:	e8 54 0e 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001e4:	e8 bb 24 00 00       	call   8026a4 <sys_calculate_free_frames>
  8001e9:	89 c2                	mov    %eax,%edx
  8001eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ee:	39 c2                	cmp    %eax,%edx
  8001f0:	74 14                	je     800206 <_main+0x1ce>
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	68 38 41 80 00       	push   $0x804138
  8001fa:	6a 36                	push   $0x36
  8001fc:	68 dc 3f 80 00       	push   $0x803fdc
  800201:	e8 32 0e 00 00       	call   801038 <_panic>
		cprintf("HERE 2\n") ;
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	68 4b 41 80 00       	push   $0x80414b
  80020e:	e8 d9 10 00 00       	call   8012ec <cprintf>
  800213:	83 c4 10             	add    $0x10,%esp
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800216:	e8 89 24 00 00       	call   8026a4 <sys_calculate_free_frames>
  80021b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80021e:	e8 21 25 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800223:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800226:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800229:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	50                   	push   %eax
  800230:	e8 30 20 00 00       	call   802265 <malloc>
  800235:	83 c4 10             	add    $0x10,%esp
  800238:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  80023b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80023e:	89 c2                	mov    %eax,%edx
  800240:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800243:	01 c0                	add    %eax,%eax
  800245:	05 00 00 00 80       	add    $0x80000000,%eax
  80024a:	39 c2                	cmp    %eax,%edx
  80024c:	74 14                	je     800262 <_main+0x22a>
  80024e:	83 ec 04             	sub    $0x4,%esp
  800251:	68 08 41 80 00       	push   $0x804108
  800256:	6a 3c                	push   $0x3c
  800258:	68 dc 3f 80 00       	push   $0x803fdc
  80025d:	e8 d6 0d 00 00       	call   801038 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800262:	e8 dd 24 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800267:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80026a:	74 14                	je     800280 <_main+0x248>
  80026c:	83 ec 04             	sub    $0x4,%esp
  80026f:	68 e2 40 80 00       	push   $0x8040e2
  800274:	6a 3e                	push   $0x3e
  800276:	68 dc 3f 80 00       	push   $0x803fdc
  80027b:	e8 b8 0d 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800280:	e8 1f 24 00 00       	call   8026a4 <sys_calculate_free_frames>
  800285:	89 c2                	mov    %eax,%edx
  800287:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80028a:	39 c2                	cmp    %eax,%edx
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 38 41 80 00       	push   $0x804138
  800296:	6a 3f                	push   $0x3f
  800298:	68 dc 3f 80 00       	push   $0x803fdc
  80029d:	e8 96 0d 00 00       	call   801038 <_panic>

		cprintf("HERE 3\n") ;
  8002a2:	83 ec 0c             	sub    $0xc,%esp
  8002a5:	68 53 41 80 00       	push   $0x804153
  8002aa:	e8 3d 10 00 00       	call   8012ec <cprintf>
  8002af:	83 c4 10             	add    $0x10,%esp
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8002b2:	e8 ed 23 00 00       	call   8026a4 <sys_calculate_free_frames>
  8002b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002ba:	e8 85 24 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  8002bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  8002c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 94 1f 00 00       	call   802265 <malloc>
  8002d1:	83 c4 10             	add    $0x10,%esp
  8002d4:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  8002d7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002da:	89 c1                	mov    %eax,%ecx
  8002dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002df:	89 c2                	mov    %eax,%edx
  8002e1:	01 d2                	add    %edx,%edx
  8002e3:	01 d0                	add    %edx,%eax
  8002e5:	05 00 00 00 80       	add    $0x80000000,%eax
  8002ea:	39 c1                	cmp    %eax,%ecx
  8002ec:	74 14                	je     800302 <_main+0x2ca>
  8002ee:	83 ec 04             	sub    $0x4,%esp
  8002f1:	68 08 41 80 00       	push   $0x804108
  8002f6:	6a 46                	push   $0x46
  8002f8:	68 dc 3f 80 00       	push   $0x803fdc
  8002fd:	e8 36 0d 00 00       	call   801038 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800302:	e8 3d 24 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800307:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80030a:	74 14                	je     800320 <_main+0x2e8>
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	68 e2 40 80 00       	push   $0x8040e2
  800314:	6a 48                	push   $0x48
  800316:	68 dc 3f 80 00       	push   $0x803fdc
  80031b:	e8 18 0d 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800320:	e8 7f 23 00 00       	call   8026a4 <sys_calculate_free_frames>
  800325:	89 c2                	mov    %eax,%edx
  800327:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032a:	39 c2                	cmp    %eax,%edx
  80032c:	74 14                	je     800342 <_main+0x30a>
  80032e:	83 ec 04             	sub    $0x4,%esp
  800331:	68 38 41 80 00       	push   $0x804138
  800336:	6a 49                	push   $0x49
  800338:	68 dc 3f 80 00       	push   $0x803fdc
  80033d:	e8 f6 0c 00 00       	call   801038 <_panic>

		cprintf("HERE 4\n") ;
  800342:	83 ec 0c             	sub    $0xc,%esp
  800345:	68 5b 41 80 00       	push   $0x80415b
  80034a:	e8 9d 0f 00 00       	call   8012ec <cprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800352:	e8 4d 23 00 00       	call   8026a4 <sys_calculate_free_frames>
  800357:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80035a:	e8 e5 23 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  80035f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800362:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800365:	01 c0                	add    %eax,%eax
  800367:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80036a:	83 ec 0c             	sub    $0xc,%esp
  80036d:	50                   	push   %eax
  80036e:	e8 f2 1e 00 00       	call   802265 <malloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800379:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80037c:	89 c2                	mov    %eax,%edx
  80037e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800381:	c1 e0 02             	shl    $0x2,%eax
  800384:	05 00 00 00 80       	add    $0x80000000,%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	74 14                	je     8003a1 <_main+0x369>
  80038d:	83 ec 04             	sub    $0x4,%esp
  800390:	68 08 41 80 00       	push   $0x804108
  800395:	6a 50                	push   $0x50
  800397:	68 dc 3f 80 00       	push   $0x803fdc
  80039c:	e8 97 0c 00 00       	call   801038 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8003a1:	e8 9e 23 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  8003a6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003a9:	74 14                	je     8003bf <_main+0x387>
  8003ab:	83 ec 04             	sub    $0x4,%esp
  8003ae:	68 e2 40 80 00       	push   $0x8040e2
  8003b3:	6a 52                	push   $0x52
  8003b5:	68 dc 3f 80 00       	push   $0x803fdc
  8003ba:	e8 79 0c 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8003bf:	e8 e0 22 00 00       	call   8026a4 <sys_calculate_free_frames>
  8003c4:	89 c2                	mov    %eax,%edx
  8003c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c9:	39 c2                	cmp    %eax,%edx
  8003cb:	74 14                	je     8003e1 <_main+0x3a9>
  8003cd:	83 ec 04             	sub    $0x4,%esp
  8003d0:	68 38 41 80 00       	push   $0x804138
  8003d5:	6a 53                	push   $0x53
  8003d7:	68 dc 3f 80 00       	push   $0x803fdc
  8003dc:	e8 57 0c 00 00       	call   801038 <_panic>

		cprintf("HERE 5\n") ;
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 63 41 80 00       	push   $0x804163
  8003e9:	e8 fe 0e 00 00       	call   8012ec <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
		//Allocate Shared 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003f1:	e8 ae 22 00 00       	call   8026a4 <sys_calculate_free_frames>
  8003f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003f9:	e8 46 23 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  8003fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  800401:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800404:	01 c0                	add    %eax,%eax
  800406:	83 ec 04             	sub    $0x4,%esp
  800409:	6a 01                	push   $0x1
  80040b:	50                   	push   %eax
  80040c:	68 6b 41 80 00       	push   $0x80416b
  800411:	e8 cb 1f 00 00       	call   8023e1 <smalloc>
  800416:	83 c4 10             	add    $0x10,%esp
  800419:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (ptr_allocations[5] != (uint32*)(USER_HEAP_START + 6*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80041c:	8b 4d a0             	mov    -0x60(%ebp),%ecx
  80041f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800422:	89 d0                	mov    %edx,%eax
  800424:	01 c0                	add    %eax,%eax
  800426:	01 d0                	add    %edx,%eax
  800428:	01 c0                	add    %eax,%eax
  80042a:	05 00 00 00 80       	add    $0x80000000,%eax
  80042f:	39 c1                	cmp    %eax,%ecx
  800431:	74 14                	je     800447 <_main+0x40f>
  800433:	83 ec 04             	sub    $0x4,%esp
  800436:	68 f8 3f 80 00       	push   $0x803ff8
  80043b:	6a 5a                	push   $0x5a
  80043d:	68 dc 3f 80 00       	push   $0x803fdc
  800442:	e8 f1 0b 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  512+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800447:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80044a:	e8 55 22 00 00       	call   8026a4 <sys_calculate_free_frames>
  80044f:	29 c3                	sub    %eax,%ebx
  800451:	89 d8                	mov    %ebx,%eax
  800453:	3d 03 02 00 00       	cmp    $0x203,%eax
  800458:	74 14                	je     80046e <_main+0x436>
  80045a:	83 ec 04             	sub    $0x4,%esp
  80045d:	68 64 40 80 00       	push   $0x804064
  800462:	6a 5b                	push   $0x5b
  800464:	68 dc 3f 80 00       	push   $0x803fdc
  800469:	e8 ca 0b 00 00       	call   801038 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80046e:	e8 d1 22 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800473:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800476:	74 14                	je     80048c <_main+0x454>
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 e2 40 80 00       	push   $0x8040e2
  800480:	6a 5c                	push   $0x5c
  800482:	68 dc 3f 80 00       	push   $0x803fdc
  800487:	e8 ac 0b 00 00       	call   801038 <_panic>
		cprintf("HERE 6\n") ;
  80048c:	83 ec 0c             	sub    $0xc,%esp
  80048f:	68 6d 41 80 00       	push   $0x80416d
  800494:	e8 53 0e 00 00       	call   8012ec <cprintf>
  800499:	83 c4 10             	add    $0x10,%esp
		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80049c:	e8 03 22 00 00       	call   8026a4 <sys_calculate_free_frames>
  8004a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004a4:	e8 9b 22 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  8004a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8004ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004af:	89 c2                	mov    %eax,%edx
  8004b1:	01 d2                	add    %edx,%edx
  8004b3:	01 d0                	add    %edx,%eax
  8004b5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8004b8:	83 ec 0c             	sub    $0xc,%esp
  8004bb:	50                   	push   %eax
  8004bc:	e8 a4 1d 00 00       	call   802265 <malloc>
  8004c1:	83 c4 10             	add    $0x10,%esp
  8004c4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8004c7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004ca:	89 c2                	mov    %eax,%edx
  8004cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004cf:	c1 e0 03             	shl    $0x3,%eax
  8004d2:	05 00 00 00 80       	add    $0x80000000,%eax
  8004d7:	39 c2                	cmp    %eax,%edx
  8004d9:	74 14                	je     8004ef <_main+0x4b7>
  8004db:	83 ec 04             	sub    $0x4,%esp
  8004de:	68 08 41 80 00       	push   $0x804108
  8004e3:	6a 62                	push   $0x62
  8004e5:	68 dc 3f 80 00       	push   $0x803fdc
  8004ea:	e8 49 0b 00 00       	call   801038 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8004ef:	e8 50 22 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  8004f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8004f7:	74 14                	je     80050d <_main+0x4d5>
  8004f9:	83 ec 04             	sub    $0x4,%esp
  8004fc:	68 e2 40 80 00       	push   $0x8040e2
  800501:	6a 64                	push   $0x64
  800503:	68 dc 3f 80 00       	push   $0x803fdc
  800508:	e8 2b 0b 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80050d:	e8 92 21 00 00       	call   8026a4 <sys_calculate_free_frames>
  800512:	89 c2                	mov    %eax,%edx
  800514:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800517:	39 c2                	cmp    %eax,%edx
  800519:	74 14                	je     80052f <_main+0x4f7>
  80051b:	83 ec 04             	sub    $0x4,%esp
  80051e:	68 38 41 80 00       	push   $0x804138
  800523:	6a 65                	push   $0x65
  800525:	68 dc 3f 80 00       	push   $0x803fdc
  80052a:	e8 09 0b 00 00       	call   801038 <_panic>

		cprintf("HERE 7\n") ;
  80052f:	83 ec 0c             	sub    $0xc,%esp
  800532:	68 75 41 80 00       	push   $0x804175
  800537:	e8 b0 0d 00 00       	call   8012ec <cprintf>
  80053c:	83 c4 10             	add    $0x10,%esp
		//Allocate Shared 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80053f:	e8 60 21 00 00       	call   8026a4 <sys_calculate_free_frames>
  800544:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800547:	e8 f8 21 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  80054c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  80054f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800552:	89 c2                	mov    %eax,%edx
  800554:	01 d2                	add    %edx,%edx
  800556:	01 d0                	add    %edx,%eax
  800558:	83 ec 04             	sub    $0x4,%esp
  80055b:	6a 00                	push   $0x0
  80055d:	50                   	push   %eax
  80055e:	68 7d 41 80 00       	push   $0x80417d
  800563:	e8 79 1e 00 00       	call   8023e1 <smalloc>
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if (ptr_allocations[7] != (uint32*)(USER_HEAP_START + 11*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80056e:	8b 4d a8             	mov    -0x58(%ebp),%ecx
  800571:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800574:	89 d0                	mov    %edx,%eax
  800576:	c1 e0 02             	shl    $0x2,%eax
  800579:	01 d0                	add    %edx,%eax
  80057b:	01 c0                	add    %eax,%eax
  80057d:	01 d0                	add    %edx,%eax
  80057f:	05 00 00 00 80       	add    $0x80000000,%eax
  800584:	39 c1                	cmp    %eax,%ecx
  800586:	74 14                	je     80059c <_main+0x564>
  800588:	83 ec 04             	sub    $0x4,%esp
  80058b:	68 f8 3f 80 00       	push   $0x803ff8
  800590:	6a 6c                	push   $0x6c
  800592:	68 dc 3f 80 00       	push   $0x803fdc
  800597:	e8 9c 0a 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80059c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80059f:	e8 00 21 00 00       	call   8026a4 <sys_calculate_free_frames>
  8005a4:	29 c3                	sub    %eax,%ebx
  8005a6:	89 d8                	mov    %ebx,%eax
  8005a8:	3d 04 03 00 00       	cmp    $0x304,%eax
  8005ad:	74 14                	je     8005c3 <_main+0x58b>
  8005af:	83 ec 04             	sub    $0x4,%esp
  8005b2:	68 64 40 80 00       	push   $0x804064
  8005b7:	6a 6d                	push   $0x6d
  8005b9:	68 dc 3f 80 00       	push   $0x803fdc
  8005be:	e8 75 0a 00 00       	call   801038 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8005c3:	e8 7c 21 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  8005c8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005cb:	74 14                	je     8005e1 <_main+0x5a9>
  8005cd:	83 ec 04             	sub    $0x4,%esp
  8005d0:	68 e2 40 80 00       	push   $0x8040e2
  8005d5:	6a 6e                	push   $0x6e
  8005d7:	68 dc 3f 80 00       	push   $0x803fdc
  8005dc:	e8 57 0a 00 00       	call   801038 <_panic>
		cprintf("HERE 8\n") ;
  8005e1:	83 ec 0c             	sub    $0xc,%esp
  8005e4:	68 7f 41 80 00       	push   $0x80417f
  8005e9:	e8 fe 0c 00 00       	call   8012ec <cprintf>
  8005ee:	83 c4 10             	add    $0x10,%esp
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005f1:	e8 ae 20 00 00       	call   8026a4 <sys_calculate_free_frames>
  8005f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005f9:	e8 46 21 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  8005fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800601:	8b 45 90             	mov    -0x70(%ebp),%eax
  800604:	83 ec 0c             	sub    $0xc,%esp
  800607:	50                   	push   %eax
  800608:	e8 ef 1c 00 00       	call   8022fc <free>
  80060d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800610:	e8 2f 21 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800615:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800618:	74 14                	je     80062e <_main+0x5f6>
  80061a:	83 ec 04             	sub    $0x4,%esp
  80061d:	68 87 41 80 00       	push   $0x804187
  800622:	6a 79                	push   $0x79
  800624:	68 dc 3f 80 00       	push   $0x803fdc
  800629:	e8 0a 0a 00 00       	call   801038 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80062e:	e8 71 20 00 00       	call   8026a4 <sys_calculate_free_frames>
  800633:	89 c2                	mov    %eax,%edx
  800635:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800638:	39 c2                	cmp    %eax,%edx
  80063a:	74 14                	je     800650 <_main+0x618>
  80063c:	83 ec 04             	sub    $0x4,%esp
  80063f:	68 9e 41 80 00       	push   $0x80419e
  800644:	6a 7a                	push   $0x7a
  800646:	68 dc 3f 80 00       	push   $0x803fdc
  80064b:	e8 e8 09 00 00       	call   801038 <_panic>

		cprintf("HERE 9\n") ;
  800650:	83 ec 0c             	sub    $0xc,%esp
  800653:	68 ab 41 80 00       	push   $0x8041ab
  800658:	e8 8f 0c 00 00       	call   8012ec <cprintf>
  80065d:	83 c4 10             	add    $0x10,%esp
		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800660:	e8 3f 20 00 00       	call   8026a4 <sys_calculate_free_frames>
  800665:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800668:	e8 d7 20 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  80066d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  800670:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800673:	83 ec 0c             	sub    $0xc,%esp
  800676:	50                   	push   %eax
  800677:	e8 80 1c 00 00       	call   8022fc <free>
  80067c:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80067f:	e8 c0 20 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800684:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800687:	74 17                	je     8006a0 <_main+0x668>
  800689:	83 ec 04             	sub    $0x4,%esp
  80068c:	68 87 41 80 00       	push   $0x804187
  800691:	68 82 00 00 00       	push   $0x82
  800696:	68 dc 3f 80 00       	push   $0x803fdc
  80069b:	e8 98 09 00 00       	call   801038 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006a0:	e8 ff 1f 00 00       	call   8026a4 <sys_calculate_free_frames>
  8006a5:	89 c2                	mov    %eax,%edx
  8006a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006aa:	39 c2                	cmp    %eax,%edx
  8006ac:	74 17                	je     8006c5 <_main+0x68d>
  8006ae:	83 ec 04             	sub    $0x4,%esp
  8006b1:	68 9e 41 80 00       	push   $0x80419e
  8006b6:	68 83 00 00 00       	push   $0x83
  8006bb:	68 dc 3f 80 00       	push   $0x803fdc
  8006c0:	e8 73 09 00 00       	call   801038 <_panic>

		cprintf("HERE 10\n") ;
  8006c5:	83 ec 0c             	sub    $0xc,%esp
  8006c8:	68 b3 41 80 00       	push   $0x8041b3
  8006cd:	e8 1a 0c 00 00       	call   8012ec <cprintf>
  8006d2:	83 c4 10             	add    $0x10,%esp
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006d5:	e8 ca 1f 00 00       	call   8026a4 <sys_calculate_free_frames>
  8006da:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006dd:	e8 62 20 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  8006e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  8006e5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8006e8:	83 ec 0c             	sub    $0xc,%esp
  8006eb:	50                   	push   %eax
  8006ec:	e8 0b 1c 00 00       	call   8022fc <free>
  8006f1:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8006f4:	e8 4b 20 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  8006f9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006fc:	74 17                	je     800715 <_main+0x6dd>
  8006fe:	83 ec 04             	sub    $0x4,%esp
  800701:	68 87 41 80 00       	push   $0x804187
  800706:	68 8b 00 00 00       	push   $0x8b
  80070b:	68 dc 3f 80 00       	push   $0x803fdc
  800710:	e8 23 09 00 00       	call   801038 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800715:	e8 8a 1f 00 00       	call   8026a4 <sys_calculate_free_frames>
  80071a:	89 c2                	mov    %eax,%edx
  80071c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80071f:	39 c2                	cmp    %eax,%edx
  800721:	74 17                	je     80073a <_main+0x702>
  800723:	83 ec 04             	sub    $0x4,%esp
  800726:	68 9e 41 80 00       	push   $0x80419e
  80072b:	68 8c 00 00 00       	push   $0x8c
  800730:	68 dc 3f 80 00       	push   $0x803fdc
  800735:	e8 fe 08 00 00       	call   801038 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  80073a:	e8 65 1f 00 00       	call   8026a4 <sys_calculate_free_frames>
  80073f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800742:	e8 fd 1f 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800747:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  80074a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80074d:	89 d0                	mov    %edx,%eax
  80074f:	c1 e0 09             	shl    $0x9,%eax
  800752:	29 d0                	sub    %edx,%eax
  800754:	83 ec 0c             	sub    $0xc,%esp
  800757:	50                   	push   %eax
  800758:	e8 08 1b 00 00       	call   802265 <malloc>
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  800763:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800766:	89 c2                	mov    %eax,%edx
  800768:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80076b:	05 00 00 00 80       	add    $0x80000000,%eax
  800770:	39 c2                	cmp    %eax,%edx
  800772:	74 17                	je     80078b <_main+0x753>
  800774:	83 ec 04             	sub    $0x4,%esp
  800777:	68 08 41 80 00       	push   $0x804108
  80077c:	68 95 00 00 00       	push   $0x95
  800781:	68 dc 3f 80 00       	push   $0x803fdc
  800786:	e8 ad 08 00 00       	call   801038 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80078b:	e8 b4 1f 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800790:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800793:	74 17                	je     8007ac <_main+0x774>
  800795:	83 ec 04             	sub    $0x4,%esp
  800798:	68 e2 40 80 00       	push   $0x8040e2
  80079d:	68 97 00 00 00       	push   $0x97
  8007a2:	68 dc 3f 80 00       	push   $0x803fdc
  8007a7:	e8 8c 08 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007ac:	e8 f3 1e 00 00       	call   8026a4 <sys_calculate_free_frames>
  8007b1:	89 c2                	mov    %eax,%edx
  8007b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b6:	39 c2                	cmp    %eax,%edx
  8007b8:	74 17                	je     8007d1 <_main+0x799>
  8007ba:	83 ec 04             	sub    $0x4,%esp
  8007bd:	68 38 41 80 00       	push   $0x804138
  8007c2:	68 98 00 00 00       	push   $0x98
  8007c7:	68 dc 3f 80 00       	push   $0x803fdc
  8007cc:	e8 67 08 00 00       	call   801038 <_panic>
		cprintf("HERE 11\n") ;
  8007d1:	83 ec 0c             	sub    $0xc,%esp
  8007d4:	68 bc 41 80 00       	push   $0x8041bc
  8007d9:	e8 0e 0b 00 00       	call   8012ec <cprintf>
  8007de:	83 c4 10             	add    $0x10,%esp
		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  8007e1:	e8 be 1e 00 00       	call   8026a4 <sys_calculate_free_frames>
  8007e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e9:	e8 56 1f 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  8007ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  8007f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8007f4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8007f7:	83 ec 0c             	sub    $0xc,%esp
  8007fa:	50                   	push   %eax
  8007fb:	e8 65 1a 00 00       	call   802265 <malloc>
  800800:	83 c4 10             	add    $0x10,%esp
  800803:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800806:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800809:	89 c2                	mov    %eax,%edx
  80080b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80080e:	c1 e0 02             	shl    $0x2,%eax
  800811:	05 00 00 00 80       	add    $0x80000000,%eax
  800816:	39 c2                	cmp    %eax,%edx
  800818:	74 17                	je     800831 <_main+0x7f9>
  80081a:	83 ec 04             	sub    $0x4,%esp
  80081d:	68 08 41 80 00       	push   $0x804108
  800822:	68 9e 00 00 00       	push   $0x9e
  800827:	68 dc 3f 80 00       	push   $0x803fdc
  80082c:	e8 07 08 00 00       	call   801038 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800831:	e8 0e 1f 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800836:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800839:	74 17                	je     800852 <_main+0x81a>
  80083b:	83 ec 04             	sub    $0x4,%esp
  80083e:	68 e2 40 80 00       	push   $0x8040e2
  800843:	68 a0 00 00 00       	push   $0xa0
  800848:	68 dc 3f 80 00       	push   $0x803fdc
  80084d:	e8 e6 07 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800852:	e8 4d 1e 00 00       	call   8026a4 <sys_calculate_free_frames>
  800857:	89 c2                	mov    %eax,%edx
  800859:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80085c:	39 c2                	cmp    %eax,%edx
  80085e:	74 17                	je     800877 <_main+0x83f>
  800860:	83 ec 04             	sub    $0x4,%esp
  800863:	68 38 41 80 00       	push   $0x804138
  800868:	68 a1 00 00 00       	push   $0xa1
  80086d:	68 dc 3f 80 00       	push   $0x803fdc
  800872:	e8 c1 07 00 00       	call   801038 <_panic>
		cprintf("HERE 12\n") ;
  800877:	83 ec 0c             	sub    $0xc,%esp
  80087a:	68 c5 41 80 00       	push   $0x8041c5
  80087f:	e8 68 0a 00 00       	call   8012ec <cprintf>
  800884:	83 c4 10             	add    $0x10,%esp
		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800887:	e8 18 1e 00 00       	call   8026a4 <sys_calculate_free_frames>
  80088c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80088f:	e8 b0 1e 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800894:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[10] = malloc(256*kilo - kilo);
		ptr_allocations[10] = smalloc("a", 256*kilo - kilo, 0);
  800897:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80089a:	89 d0                	mov    %edx,%eax
  80089c:	c1 e0 08             	shl    $0x8,%eax
  80089f:	29 d0                	sub    %edx,%eax
  8008a1:	83 ec 04             	sub    $0x4,%esp
  8008a4:	6a 00                	push   $0x0
  8008a6:	50                   	push   %eax
  8008a7:	68 ce 41 80 00       	push   $0x8041ce
  8008ac:	e8 30 1b 00 00       	call   8023e1 <smalloc>
  8008b1:	83 c4 10             	add    $0x10,%esp
  8008b4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  8008b7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8008ba:	89 c2                	mov    %eax,%edx
  8008bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008bf:	c1 e0 09             	shl    $0x9,%eax
  8008c2:	89 c1                	mov    %eax,%ecx
  8008c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008c7:	01 c8                	add    %ecx,%eax
  8008c9:	05 00 00 00 80       	add    $0x80000000,%eax
  8008ce:	39 c2                	cmp    %eax,%edx
  8008d0:	74 17                	je     8008e9 <_main+0x8b1>
  8008d2:	83 ec 04             	sub    $0x4,%esp
  8008d5:	68 08 41 80 00       	push   $0x804108
  8008da:	68 a8 00 00 00       	push   $0xa8
  8008df:	68 dc 3f 80 00       	push   $0x803fdc
  8008e4:	e8 4f 07 00 00       	call   801038 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8008e9:	e8 56 1e 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  8008ee:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008f1:	74 17                	je     80090a <_main+0x8d2>
  8008f3:	83 ec 04             	sub    $0x4,%esp
  8008f6:	68 e2 40 80 00       	push   $0x8040e2
  8008fb:	68 a9 00 00 00       	push   $0xa9
  800900:	68 dc 3f 80 00       	push   $0x803fdc
  800905:	e8 2e 07 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 64+0+2) panic("Wrong allocation: %d", (freeFrames - sys_calculate_free_frames()));
  80090a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80090d:	e8 92 1d 00 00       	call   8026a4 <sys_calculate_free_frames>
  800912:	29 c3                	sub    %eax,%ebx
  800914:	89 d8                	mov    %ebx,%eax
  800916:	83 f8 42             	cmp    $0x42,%eax
  800919:	74 21                	je     80093c <_main+0x904>
  80091b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80091e:	e8 81 1d 00 00       	call   8026a4 <sys_calculate_free_frames>
  800923:	29 c3                	sub    %eax,%ebx
  800925:	89 d8                	mov    %ebx,%eax
  800927:	50                   	push   %eax
  800928:	68 d0 41 80 00       	push   $0x8041d0
  80092d:	68 aa 00 00 00       	push   $0xaa
  800932:	68 dc 3f 80 00       	push   $0x803fdc
  800937:	e8 fc 06 00 00       	call   801038 <_panic>
		cprintf("HERE 13\n") ;
  80093c:	83 ec 0c             	sub    $0xc,%esp
  80093f:	68 e5 41 80 00       	push   $0x8041e5
  800944:	e8 a3 09 00 00       	call   8012ec <cprintf>
  800949:	83 c4 10             	add    $0x10,%esp
		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80094c:	e8 53 1d 00 00       	call   8026a4 <sys_calculate_free_frames>
  800951:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800954:	e8 eb 1d 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800959:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  80095c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80095f:	01 c0                	add    %eax,%eax
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	50                   	push   %eax
  800965:	e8 fb 18 00 00       	call   802265 <malloc>
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800970:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800973:	89 c2                	mov    %eax,%edx
  800975:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800978:	c1 e0 03             	shl    $0x3,%eax
  80097b:	05 00 00 00 80       	add    $0x80000000,%eax
  800980:	39 c2                	cmp    %eax,%edx
  800982:	74 17                	je     80099b <_main+0x963>
  800984:	83 ec 04             	sub    $0x4,%esp
  800987:	68 08 41 80 00       	push   $0x804108
  80098c:	68 b0 00 00 00       	push   $0xb0
  800991:	68 dc 3f 80 00       	push   $0x803fdc
  800996:	e8 9d 06 00 00       	call   801038 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80099b:	e8 a4 1d 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  8009a0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009a3:	74 17                	je     8009bc <_main+0x984>
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	68 e2 40 80 00       	push   $0x8040e2
  8009ad:	68 b2 00 00 00       	push   $0xb2
  8009b2:	68 dc 3f 80 00       	push   $0x803fdc
  8009b7:	e8 7c 06 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8009bc:	e8 e3 1c 00 00       	call   8026a4 <sys_calculate_free_frames>
  8009c1:	89 c2                	mov    %eax,%edx
  8009c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c6:	39 c2                	cmp    %eax,%edx
  8009c8:	74 17                	je     8009e1 <_main+0x9a9>
  8009ca:	83 ec 04             	sub    $0x4,%esp
  8009cd:	68 38 41 80 00       	push   $0x804138
  8009d2:	68 b3 00 00 00       	push   $0xb3
  8009d7:	68 dc 3f 80 00       	push   $0x803fdc
  8009dc:	e8 57 06 00 00       	call   801038 <_panic>
		cprintf("HERE 14\n") ;
  8009e1:	83 ec 0c             	sub    $0xc,%esp
  8009e4:	68 ee 41 80 00       	push   $0x8041ee
  8009e9:	e8 fe 08 00 00       	call   8012ec <cprintf>
  8009ee:	83 c4 10             	add    $0x10,%esp
		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8009f1:	e8 ae 1c 00 00       	call   8026a4 <sys_calculate_free_frames>
  8009f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009f9:	e8 46 1d 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  8009fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  800a01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a04:	c1 e0 02             	shl    $0x2,%eax
  800a07:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800a0a:	83 ec 04             	sub    $0x4,%esp
  800a0d:	6a 00                	push   $0x0
  800a0f:	50                   	push   %eax
  800a10:	68 f7 41 80 00       	push   $0x8041f7
  800a15:	e8 c7 19 00 00       	call   8023e1 <smalloc>
  800a1a:	83 c4 10             	add    $0x10,%esp
  800a1d:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  800a20:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800a23:	89 c1                	mov    %eax,%ecx
  800a25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a28:	89 d0                	mov    %edx,%eax
  800a2a:	01 c0                	add    %eax,%eax
  800a2c:	01 d0                	add    %edx,%eax
  800a2e:	01 c0                	add    %eax,%eax
  800a30:	01 d0                	add    %edx,%eax
  800a32:	01 c0                	add    %eax,%eax
  800a34:	05 00 00 00 80       	add    $0x80000000,%eax
  800a39:	39 c1                	cmp    %eax,%ecx
  800a3b:	74 17                	je     800a54 <_main+0xa1c>
  800a3d:	83 ec 04             	sub    $0x4,%esp
  800a40:	68 08 41 80 00       	push   $0x804108
  800a45:	68 ba 00 00 00       	push   $0xba
  800a4a:	68 dc 3f 80 00       	push   $0x803fdc
  800a4f:	e8 e4 05 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1024+1+2) panic("Wrong allocation: ");
  800a54:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a57:	e8 48 1c 00 00       	call   8026a4 <sys_calculate_free_frames>
  800a5c:	29 c3                	sub    %eax,%ebx
  800a5e:	89 d8                	mov    %ebx,%eax
  800a60:	3d 03 04 00 00       	cmp    $0x403,%eax
  800a65:	74 17                	je     800a7e <_main+0xa46>
  800a67:	83 ec 04             	sub    $0x4,%esp
  800a6a:	68 38 41 80 00       	push   $0x804138
  800a6f:	68 bb 00 00 00       	push   $0xbb
  800a74:	68 dc 3f 80 00       	push   $0x803fdc
  800a79:	e8 ba 05 00 00       	call   801038 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800a7e:	e8 c1 1c 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800a83:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a86:	74 17                	je     800a9f <_main+0xa67>
  800a88:	83 ec 04             	sub    $0x4,%esp
  800a8b:	68 e2 40 80 00       	push   $0x8040e2
  800a90:	68 bc 00 00 00       	push   $0xbc
  800a95:	68 dc 3f 80 00       	push   $0x803fdc
  800a9a:	e8 99 05 00 00       	call   801038 <_panic>
//		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: ");
		cprintf("HERE 15\n") ;
  800a9f:	83 ec 0c             	sub    $0xc,%esp
  800aa2:	68 f9 41 80 00       	push   $0x8041f9
  800aa7:	e8 40 08 00 00       	call   8012ec <cprintf>
  800aac:	83 c4 10             	add    $0x10,%esp
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  800aaf:	e8 f0 1b 00 00       	call   8026a4 <sys_calculate_free_frames>
  800ab4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ab7:	e8 88 1c 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800abc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  800abf:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800ac2:	83 ec 0c             	sub    $0xc,%esp
  800ac5:	50                   	push   %eax
  800ac6:	e8 31 18 00 00       	call   8022fc <free>
  800acb:	83 c4 10             	add    $0x10,%esp
		cprintf("AFTER FREE FROM TEST CASE \n") ;
  800ace:	83 ec 0c             	sub    $0xc,%esp
  800ad1:	68 02 42 80 00       	push   $0x804202
  800ad6:	e8 11 08 00 00       	call   8012ec <cprintf>
  800adb:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800ade:	e8 61 1c 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800ae3:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800ae6:	74 17                	je     800aff <_main+0xac7>
  800ae8:	83 ec 04             	sub    $0x4,%esp
  800aeb:	68 87 41 80 00       	push   $0x804187
  800af0:	68 c9 00 00 00       	push   $0xc9
  800af5:	68 dc 3f 80 00       	push   $0x803fdc
  800afa:	e8 39 05 00 00       	call   801038 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800aff:	e8 a0 1b 00 00       	call   8026a4 <sys_calculate_free_frames>
  800b04:	89 c2                	mov    %eax,%edx
  800b06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b09:	39 c2                	cmp    %eax,%edx
  800b0b:	74 17                	je     800b24 <_main+0xaec>
  800b0d:	83 ec 04             	sub    $0x4,%esp
  800b10:	68 9e 41 80 00       	push   $0x80419e
  800b15:	68 ca 00 00 00       	push   $0xca
  800b1a:	68 dc 3f 80 00       	push   $0x803fdc
  800b1f:	e8 14 05 00 00       	call   801038 <_panic>
		cprintf("HERE 16\n") ;
  800b24:	83 ec 0c             	sub    $0xc,%esp
  800b27:	68 1e 42 80 00       	push   $0x80421e
  800b2c:	e8 bb 07 00 00       	call   8012ec <cprintf>
  800b31:	83 c4 10             	add    $0x10,%esp
		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800b34:	e8 6b 1b 00 00       	call   8026a4 <sys_calculate_free_frames>
  800b39:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b3c:	e8 03 1c 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800b41:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  800b44:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800b47:	83 ec 0c             	sub    $0xc,%esp
  800b4a:	50                   	push   %eax
  800b4b:	e8 ac 17 00 00       	call   8022fc <free>
  800b50:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800b53:	e8 ec 1b 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800b58:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800b5b:	74 17                	je     800b74 <_main+0xb3c>
  800b5d:	83 ec 04             	sub    $0x4,%esp
  800b60:	68 87 41 80 00       	push   $0x804187
  800b65:	68 d1 00 00 00       	push   $0xd1
  800b6a:	68 dc 3f 80 00       	push   $0x803fdc
  800b6f:	e8 c4 04 00 00       	call   801038 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800b74:	e8 2b 1b 00 00       	call   8026a4 <sys_calculate_free_frames>
  800b79:	89 c2                	mov    %eax,%edx
  800b7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b7e:	39 c2                	cmp    %eax,%edx
  800b80:	74 17                	je     800b99 <_main+0xb61>
  800b82:	83 ec 04             	sub    $0x4,%esp
  800b85:	68 9e 41 80 00       	push   $0x80419e
  800b8a:	68 d2 00 00 00       	push   $0xd2
  800b8f:	68 dc 3f 80 00       	push   $0x803fdc
  800b94:	e8 9f 04 00 00       	call   801038 <_panic>
		cprintf("HERE 17\n") ;
  800b99:	83 ec 0c             	sub    $0xc,%esp
  800b9c:	68 27 42 80 00       	push   $0x804227
  800ba1:	e8 46 07 00 00       	call   8012ec <cprintf>
  800ba6:	83 c4 10             	add    $0x10,%esp
		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800ba9:	e8 f6 1a 00 00       	call   8026a4 <sys_calculate_free_frames>
  800bae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800bb1:	e8 8e 1b 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800bb6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800bb9:	8b 45 98             	mov    -0x68(%ebp),%eax
  800bbc:	83 ec 0c             	sub    $0xc,%esp
  800bbf:	50                   	push   %eax
  800bc0:	e8 37 17 00 00       	call   8022fc <free>
  800bc5:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800bc8:	e8 77 1b 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800bcd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800bd0:	74 17                	je     800be9 <_main+0xbb1>
  800bd2:	83 ec 04             	sub    $0x4,%esp
  800bd5:	68 87 41 80 00       	push   $0x804187
  800bda:	68 d9 00 00 00       	push   $0xd9
  800bdf:	68 dc 3f 80 00       	push   $0x803fdc
  800be4:	e8 4f 04 00 00       	call   801038 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800be9:	e8 b6 1a 00 00       	call   8026a4 <sys_calculate_free_frames>
  800bee:	89 c2                	mov    %eax,%edx
  800bf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bf3:	39 c2                	cmp    %eax,%edx
  800bf5:	74 17                	je     800c0e <_main+0xbd6>
  800bf7:	83 ec 04             	sub    $0x4,%esp
  800bfa:	68 9e 41 80 00       	push   $0x80419e
  800bff:	68 da 00 00 00       	push   $0xda
  800c04:	68 dc 3f 80 00       	push   $0x803fdc
  800c09:	e8 2a 04 00 00       	call   801038 <_panic>
		cprintf("HERE 18\n") ;
  800c0e:	83 ec 0c             	sub    $0xc,%esp
  800c11:	68 30 42 80 00       	push   $0x804230
  800c16:	e8 d1 06 00 00       	call   8012ec <cprintf>
  800c1b:	83 c4 10             	add    $0x10,%esp

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800c1e:	e8 81 1a 00 00       	call   8026a4 <sys_calculate_free_frames>
  800c23:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c26:	e8 19 1b 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800c2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[13] = malloc(1*Mega + 256*kilo - kilo);
  800c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c31:	c1 e0 08             	shl    $0x8,%eax
  800c34:	89 c2                	mov    %eax,%edx
  800c36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c39:	01 d0                	add    %edx,%eax
  800c3b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800c3e:	83 ec 0c             	sub    $0xc,%esp
  800c41:	50                   	push   %eax
  800c42:	e8 1e 16 00 00       	call   802265 <malloc>
  800c47:	83 c4 10             	add    $0x10,%esp
  800c4a:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800c4d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c50:	89 c1                	mov    %eax,%ecx
  800c52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c55:	89 d0                	mov    %edx,%eax
  800c57:	01 c0                	add    %eax,%eax
  800c59:	01 d0                	add    %edx,%eax
  800c5b:	c1 e0 08             	shl    $0x8,%eax
  800c5e:	89 c2                	mov    %eax,%edx
  800c60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c63:	01 d0                	add    %edx,%eax
  800c65:	05 00 00 00 80       	add    $0x80000000,%eax
  800c6a:	39 c1                	cmp    %eax,%ecx
  800c6c:	74 17                	je     800c85 <_main+0xc4d>
  800c6e:	83 ec 04             	sub    $0x4,%esp
  800c71:	68 08 41 80 00       	push   $0x804108
  800c76:	68 e5 00 00 00       	push   $0xe5
  800c7b:	68 dc 3f 80 00       	push   $0x803fdc
  800c80:	e8 b3 03 00 00       	call   801038 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c85:	e8 ba 1a 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800c8a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800c8d:	74 17                	je     800ca6 <_main+0xc6e>
  800c8f:	83 ec 04             	sub    $0x4,%esp
  800c92:	68 e2 40 80 00       	push   $0x8040e2
  800c97:	68 e7 00 00 00       	push   $0xe7
  800c9c:	68 dc 3f 80 00       	push   $0x803fdc
  800ca1:	e8 92 03 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800ca6:	e8 f9 19 00 00       	call   8026a4 <sys_calculate_free_frames>
  800cab:	89 c2                	mov    %eax,%edx
  800cad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cb0:	39 c2                	cmp    %eax,%edx
  800cb2:	74 17                	je     800ccb <_main+0xc93>
  800cb4:	83 ec 04             	sub    $0x4,%esp
  800cb7:	68 38 41 80 00       	push   $0x804138
  800cbc:	68 e8 00 00 00       	push   $0xe8
  800cc1:	68 dc 3f 80 00       	push   $0x803fdc
  800cc6:	e8 6d 03 00 00       	call   801038 <_panic>
		cprintf("HERE 19\n") ;
  800ccb:	83 ec 0c             	sub    $0xc,%esp
  800cce:	68 39 42 80 00       	push   $0x804239
  800cd3:	e8 14 06 00 00       	call   8012ec <cprintf>
  800cd8:	83 c4 10             	add    $0x10,%esp
		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800cdb:	e8 c4 19 00 00       	call   8026a4 <sys_calculate_free_frames>
  800ce0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800ce3:	e8 5c 1a 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800ce8:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800ceb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800cee:	c1 e0 02             	shl    $0x2,%eax
  800cf1:	83 ec 04             	sub    $0x4,%esp
  800cf4:	6a 00                	push   $0x0
  800cf6:	50                   	push   %eax
  800cf7:	68 42 42 80 00       	push   $0x804242
  800cfc:	e8 e0 16 00 00       	call   8023e1 <smalloc>
  800d01:	83 c4 10             	add    $0x10,%esp
  800d04:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (ptr_allocations[14] != (uint32*)(USER_HEAP_START + 18*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800d07:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800d0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d0d:	89 d0                	mov    %edx,%eax
  800d0f:	c1 e0 03             	shl    $0x3,%eax
  800d12:	01 d0                	add    %edx,%eax
  800d14:	01 c0                	add    %eax,%eax
  800d16:	05 00 00 00 80       	add    $0x80000000,%eax
  800d1b:	39 c1                	cmp    %eax,%ecx
  800d1d:	74 17                	je     800d36 <_main+0xcfe>
  800d1f:	83 ec 04             	sub    $0x4,%esp
  800d22:	68 f8 3f 80 00       	push   $0x803ff8
  800d27:	68 ee 00 00 00       	push   $0xee
  800d2c:	68 dc 3f 80 00       	push   $0x803fdc
  800d31:	e8 02 03 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1024+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800d36:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800d39:	e8 66 19 00 00       	call   8026a4 <sys_calculate_free_frames>
  800d3e:	29 c3                	sub    %eax,%ebx
  800d40:	89 d8                	mov    %ebx,%eax
  800d42:	3d 03 04 00 00       	cmp    $0x403,%eax
  800d47:	74 17                	je     800d60 <_main+0xd28>
  800d49:	83 ec 04             	sub    $0x4,%esp
  800d4c:	68 64 40 80 00       	push   $0x804064
  800d51:	68 ef 00 00 00       	push   $0xef
  800d56:	68 dc 3f 80 00       	push   $0x803fdc
  800d5b:	e8 d8 02 00 00       	call   801038 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800d60:	e8 df 19 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800d65:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800d68:	74 17                	je     800d81 <_main+0xd49>
  800d6a:	83 ec 04             	sub    $0x4,%esp
  800d6d:	68 e2 40 80 00       	push   $0x8040e2
  800d72:	68 f0 00 00 00       	push   $0xf0
  800d77:	68 dc 3f 80 00       	push   $0x803fdc
  800d7c:	e8 b7 02 00 00       	call   801038 <_panic>
		cprintf("HERE 20\n") ;
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	68 44 42 80 00       	push   $0x804244
  800d89:	e8 5e 05 00 00       	call   8012ec <cprintf>
  800d8e:	83 c4 10             	add    $0x10,%esp
		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800d91:	e8 0e 19 00 00       	call   8026a4 <sys_calculate_free_frames>
  800d96:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800d99:	e8 a6 19 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800d9e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	68 7d 41 80 00       	push   $0x80417d
  800da9:	ff 75 ec             	pushl  -0x14(%ebp)
  800dac:	e8 ce 16 00 00       	call   80247f <sget>
  800db1:	83 c4 10             	add    $0x10,%esp
  800db4:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (ptr_allocations[15] != (uint32*)(USER_HEAP_START + 3*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800db7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800dba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dbd:	89 c1                	mov    %eax,%ecx
  800dbf:	01 c9                	add    %ecx,%ecx
  800dc1:	01 c8                	add    %ecx,%eax
  800dc3:	05 00 00 00 80       	add    $0x80000000,%eax
  800dc8:	39 c2                	cmp    %eax,%edx
  800dca:	74 17                	je     800de3 <_main+0xdab>
  800dcc:	83 ec 04             	sub    $0x4,%esp
  800dcf:	68 f8 3f 80 00       	push   $0x803ff8
  800dd4:	68 f6 00 00 00       	push   $0xf6
  800dd9:	68 dc 3f 80 00       	push   $0x803fdc
  800dde:	e8 55 02 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800de3:	e8 bc 18 00 00       	call   8026a4 <sys_calculate_free_frames>
  800de8:	89 c2                	mov    %eax,%edx
  800dea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ded:	39 c2                	cmp    %eax,%edx
  800def:	74 17                	je     800e08 <_main+0xdd0>
  800df1:	83 ec 04             	sub    $0x4,%esp
  800df4:	68 64 40 80 00       	push   $0x804064
  800df9:	68 f7 00 00 00       	push   $0xf7
  800dfe:	68 dc 3f 80 00       	push   $0x803fdc
  800e03:	e8 30 02 00 00       	call   801038 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800e08:	e8 37 19 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800e0d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800e10:	74 17                	je     800e29 <_main+0xdf1>
  800e12:	83 ec 04             	sub    $0x4,%esp
  800e15:	68 e2 40 80 00       	push   $0x8040e2
  800e1a:	68 f8 00 00 00       	push   $0xf8
  800e1f:	68 dc 3f 80 00       	push   $0x803fdc
  800e24:	e8 0f 02 00 00       	call   801038 <_panic>
		cprintf("HERE 21\n") ;
  800e29:	83 ec 0c             	sub    $0xc,%esp
  800e2c:	68 4d 42 80 00       	push   $0x80424d
  800e31:	e8 b6 04 00 00       	call   8012ec <cprintf>
  800e36:	83 c4 10             	add    $0x10,%esp
		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800e39:	e8 66 18 00 00       	call   8026a4 <sys_calculate_free_frames>
  800e3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800e41:	e8 fe 18 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800e46:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800e49:	83 ec 08             	sub    $0x8,%esp
  800e4c:	68 f3 3f 80 00       	push   $0x803ff3
  800e51:	ff 75 ec             	pushl  -0x14(%ebp)
  800e54:	e8 26 16 00 00       	call   80247f <sget>
  800e59:	83 c4 10             	add    $0x10,%esp
  800e5c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (ptr_allocations[16] != (uint32*)(USER_HEAP_START + 10*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800e5f:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800e62:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e65:	89 d0                	mov    %edx,%eax
  800e67:	c1 e0 02             	shl    $0x2,%eax
  800e6a:	01 d0                	add    %edx,%eax
  800e6c:	01 c0                	add    %eax,%eax
  800e6e:	05 00 00 00 80       	add    $0x80000000,%eax
  800e73:	39 c1                	cmp    %eax,%ecx
  800e75:	74 17                	je     800e8e <_main+0xe56>
  800e77:	83 ec 04             	sub    $0x4,%esp
  800e7a:	68 f8 3f 80 00       	push   $0x803ff8
  800e7f:	68 fe 00 00 00       	push   $0xfe
  800e84:	68 dc 3f 80 00       	push   $0x803fdc
  800e89:	e8 aa 01 00 00       	call   801038 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800e8e:	e8 11 18 00 00       	call   8026a4 <sys_calculate_free_frames>
  800e93:	89 c2                	mov    %eax,%edx
  800e95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e98:	39 c2                	cmp    %eax,%edx
  800e9a:	74 17                	je     800eb3 <_main+0xe7b>
  800e9c:	83 ec 04             	sub    $0x4,%esp
  800e9f:	68 64 40 80 00       	push   $0x804064
  800ea4:	68 ff 00 00 00       	push   $0xff
  800ea9:	68 dc 3f 80 00       	push   $0x803fdc
  800eae:	e8 85 01 00 00       	call   801038 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800eb3:	e8 8c 18 00 00       	call   802744 <sys_pf_calculate_allocated_pages>
  800eb8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800ebb:	74 17                	je     800ed4 <_main+0xe9c>
  800ebd:	83 ec 04             	sub    $0x4,%esp
  800ec0:	68 e2 40 80 00       	push   $0x8040e2
  800ec5:	68 00 01 00 00       	push   $0x100
  800eca:	68 dc 3f 80 00       	push   $0x803fdc
  800ecf:	e8 64 01 00 00       	call   801038 <_panic>
		cprintf("HERE 22\n") ;
  800ed4:	83 ec 0c             	sub    $0xc,%esp
  800ed7:	68 56 42 80 00       	push   $0x804256
  800edc:	e8 0b 04 00 00       	call   8012ec <cprintf>
  800ee1:	83 c4 10             	add    $0x10,%esp
	}
	cprintf("Congratulations!! test FIRST FIT allocation (3) completed successfully.\n");
  800ee4:	83 ec 0c             	sub    $0xc,%esp
  800ee7:	68 60 42 80 00       	push   $0x804260
  800eec:	e8 fb 03 00 00       	call   8012ec <cprintf>
  800ef1:	83 c4 10             	add    $0x10,%esp

	return;
  800ef4:	90                   	nop
}
  800ef5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ef8:	5b                   	pop    %ebx
  800ef9:	5f                   	pop    %edi
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    

00800efc <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800f02:	e8 7d 1a 00 00       	call   802984 <sys_getenvindex>
  800f07:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800f0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f0d:	89 d0                	mov    %edx,%eax
  800f0f:	c1 e0 03             	shl    $0x3,%eax
  800f12:	01 d0                	add    %edx,%eax
  800f14:	01 c0                	add    %eax,%eax
  800f16:	01 d0                	add    %edx,%eax
  800f18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f1f:	01 d0                	add    %edx,%eax
  800f21:	c1 e0 04             	shl    $0x4,%eax
  800f24:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f29:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800f2e:	a1 20 50 80 00       	mov    0x805020,%eax
  800f33:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800f39:	84 c0                	test   %al,%al
  800f3b:	74 0f                	je     800f4c <libmain+0x50>
		binaryname = myEnv->prog_name;
  800f3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800f42:	05 5c 05 00 00       	add    $0x55c,%eax
  800f47:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800f4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f50:	7e 0a                	jle    800f5c <libmain+0x60>
		binaryname = argv[0];
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	8b 00                	mov    (%eax),%eax
  800f57:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800f5c:	83 ec 08             	sub    $0x8,%esp
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	ff 75 08             	pushl  0x8(%ebp)
  800f65:	e8 ce f0 ff ff       	call   800038 <_main>
  800f6a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800f6d:	e8 1f 18 00 00       	call   802791 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800f72:	83 ec 0c             	sub    $0xc,%esp
  800f75:	68 c4 42 80 00       	push   $0x8042c4
  800f7a:	e8 6d 03 00 00       	call   8012ec <cprintf>
  800f7f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800f82:	a1 20 50 80 00       	mov    0x805020,%eax
  800f87:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800f8d:	a1 20 50 80 00       	mov    0x805020,%eax
  800f92:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800f98:	83 ec 04             	sub    $0x4,%esp
  800f9b:	52                   	push   %edx
  800f9c:	50                   	push   %eax
  800f9d:	68 ec 42 80 00       	push   $0x8042ec
  800fa2:	e8 45 03 00 00       	call   8012ec <cprintf>
  800fa7:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800faa:	a1 20 50 80 00       	mov    0x805020,%eax
  800faf:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800fb5:	a1 20 50 80 00       	mov    0x805020,%eax
  800fba:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800fc0:	a1 20 50 80 00       	mov    0x805020,%eax
  800fc5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800fcb:	51                   	push   %ecx
  800fcc:	52                   	push   %edx
  800fcd:	50                   	push   %eax
  800fce:	68 14 43 80 00       	push   $0x804314
  800fd3:	e8 14 03 00 00       	call   8012ec <cprintf>
  800fd8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800fdb:	a1 20 50 80 00       	mov    0x805020,%eax
  800fe0:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800fe6:	83 ec 08             	sub    $0x8,%esp
  800fe9:	50                   	push   %eax
  800fea:	68 6c 43 80 00       	push   $0x80436c
  800fef:	e8 f8 02 00 00       	call   8012ec <cprintf>
  800ff4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800ff7:	83 ec 0c             	sub    $0xc,%esp
  800ffa:	68 c4 42 80 00       	push   $0x8042c4
  800fff:	e8 e8 02 00 00       	call   8012ec <cprintf>
  801004:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801007:	e8 9f 17 00 00       	call   8027ab <sys_enable_interrupt>

	// exit gracefully
	exit();
  80100c:	e8 19 00 00 00       	call   80102a <exit>
}
  801011:	90                   	nop
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80101a:	83 ec 0c             	sub    $0xc,%esp
  80101d:	6a 00                	push   $0x0
  80101f:	e8 2c 19 00 00       	call   802950 <sys_destroy_env>
  801024:	83 c4 10             	add    $0x10,%esp
}
  801027:	90                   	nop
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <exit>:

void
exit(void)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801030:	e8 81 19 00 00       	call   8029b6 <sys_exit_env>
}
  801035:	90                   	nop
  801036:	c9                   	leave  
  801037:	c3                   	ret    

00801038 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80103e:	8d 45 10             	lea    0x10(%ebp),%eax
  801041:	83 c0 04             	add    $0x4,%eax
  801044:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801047:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80104c:	85 c0                	test   %eax,%eax
  80104e:	74 16                	je     801066 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801050:	a1 5c 51 80 00       	mov    0x80515c,%eax
  801055:	83 ec 08             	sub    $0x8,%esp
  801058:	50                   	push   %eax
  801059:	68 80 43 80 00       	push   $0x804380
  80105e:	e8 89 02 00 00       	call   8012ec <cprintf>
  801063:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801066:	a1 00 50 80 00       	mov    0x805000,%eax
  80106b:	ff 75 0c             	pushl  0xc(%ebp)
  80106e:	ff 75 08             	pushl  0x8(%ebp)
  801071:	50                   	push   %eax
  801072:	68 85 43 80 00       	push   $0x804385
  801077:	e8 70 02 00 00       	call   8012ec <cprintf>
  80107c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80107f:	8b 45 10             	mov    0x10(%ebp),%eax
  801082:	83 ec 08             	sub    $0x8,%esp
  801085:	ff 75 f4             	pushl  -0xc(%ebp)
  801088:	50                   	push   %eax
  801089:	e8 f3 01 00 00       	call   801281 <vcprintf>
  80108e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	6a 00                	push   $0x0
  801096:	68 a1 43 80 00       	push   $0x8043a1
  80109b:	e8 e1 01 00 00       	call   801281 <vcprintf>
  8010a0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8010a3:	e8 82 ff ff ff       	call   80102a <exit>

	// should not return here
	while (1) ;
  8010a8:	eb fe                	jmp    8010a8 <_panic+0x70>

008010aa <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8010b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8010b5:	8b 50 74             	mov    0x74(%eax),%edx
  8010b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bb:	39 c2                	cmp    %eax,%edx
  8010bd:	74 14                	je     8010d3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8010bf:	83 ec 04             	sub    $0x4,%esp
  8010c2:	68 a4 43 80 00       	push   $0x8043a4
  8010c7:	6a 26                	push   $0x26
  8010c9:	68 f0 43 80 00       	push   $0x8043f0
  8010ce:	e8 65 ff ff ff       	call   801038 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8010d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8010da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010e1:	e9 c2 00 00 00       	jmp    8011a8 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8010e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8b 00                	mov    (%eax),%eax
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	75 08                	jne    801103 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8010fb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8010fe:	e9 a2 00 00 00       	jmp    8011a5 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  801103:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80110a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801111:	eb 69                	jmp    80117c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801113:	a1 20 50 80 00       	mov    0x805020,%eax
  801118:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80111e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801121:	89 d0                	mov    %edx,%eax
  801123:	01 c0                	add    %eax,%eax
  801125:	01 d0                	add    %edx,%eax
  801127:	c1 e0 03             	shl    $0x3,%eax
  80112a:	01 c8                	add    %ecx,%eax
  80112c:	8a 40 04             	mov    0x4(%eax),%al
  80112f:	84 c0                	test   %al,%al
  801131:	75 46                	jne    801179 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801133:	a1 20 50 80 00       	mov    0x805020,%eax
  801138:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80113e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801141:	89 d0                	mov    %edx,%eax
  801143:	01 c0                	add    %eax,%eax
  801145:	01 d0                	add    %edx,%eax
  801147:	c1 e0 03             	shl    $0x3,%eax
  80114a:	01 c8                	add    %ecx,%eax
  80114c:	8b 00                	mov    (%eax),%eax
  80114e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801151:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801154:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801159:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80115b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80115e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	01 c8                	add    %ecx,%eax
  80116a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80116c:	39 c2                	cmp    %eax,%edx
  80116e:	75 09                	jne    801179 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801170:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801177:	eb 12                	jmp    80118b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801179:	ff 45 e8             	incl   -0x18(%ebp)
  80117c:	a1 20 50 80 00       	mov    0x805020,%eax
  801181:	8b 50 74             	mov    0x74(%eax),%edx
  801184:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801187:	39 c2                	cmp    %eax,%edx
  801189:	77 88                	ja     801113 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80118b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80118f:	75 14                	jne    8011a5 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801191:	83 ec 04             	sub    $0x4,%esp
  801194:	68 fc 43 80 00       	push   $0x8043fc
  801199:	6a 3a                	push   $0x3a
  80119b:	68 f0 43 80 00       	push   $0x8043f0
  8011a0:	e8 93 fe ff ff       	call   801038 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8011a5:	ff 45 f0             	incl   -0x10(%ebp)
  8011a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8011ae:	0f 8c 32 ff ff ff    	jl     8010e6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8011b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8011bb:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8011c2:	eb 26                	jmp    8011ea <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8011c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8011c9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8011cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011d2:	89 d0                	mov    %edx,%eax
  8011d4:	01 c0                	add    %eax,%eax
  8011d6:	01 d0                	add    %edx,%eax
  8011d8:	c1 e0 03             	shl    $0x3,%eax
  8011db:	01 c8                	add    %ecx,%eax
  8011dd:	8a 40 04             	mov    0x4(%eax),%al
  8011e0:	3c 01                	cmp    $0x1,%al
  8011e2:	75 03                	jne    8011e7 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8011e4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8011e7:	ff 45 e0             	incl   -0x20(%ebp)
  8011ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8011ef:	8b 50 74             	mov    0x74(%eax),%edx
  8011f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011f5:	39 c2                	cmp    %eax,%edx
  8011f7:	77 cb                	ja     8011c4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8011f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011fc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8011ff:	74 14                	je     801215 <CheckWSWithoutLastIndex+0x16b>
		panic(
  801201:	83 ec 04             	sub    $0x4,%esp
  801204:	68 50 44 80 00       	push   $0x804450
  801209:	6a 44                	push   $0x44
  80120b:	68 f0 43 80 00       	push   $0x8043f0
  801210:	e8 23 fe ff ff       	call   801038 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801215:	90                   	nop
  801216:	c9                   	leave  
  801217:	c3                   	ret    

00801218 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	8b 00                	mov    (%eax),%eax
  801223:	8d 48 01             	lea    0x1(%eax),%ecx
  801226:	8b 55 0c             	mov    0xc(%ebp),%edx
  801229:	89 0a                	mov    %ecx,(%edx)
  80122b:	8b 55 08             	mov    0x8(%ebp),%edx
  80122e:	88 d1                	mov    %dl,%cl
  801230:	8b 55 0c             	mov    0xc(%ebp),%edx
  801233:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8b 00                	mov    (%eax),%eax
  80123c:	3d ff 00 00 00       	cmp    $0xff,%eax
  801241:	75 2c                	jne    80126f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801243:	a0 24 50 80 00       	mov    0x805024,%al
  801248:	0f b6 c0             	movzbl %al,%eax
  80124b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124e:	8b 12                	mov    (%edx),%edx
  801250:	89 d1                	mov    %edx,%ecx
  801252:	8b 55 0c             	mov    0xc(%ebp),%edx
  801255:	83 c2 08             	add    $0x8,%edx
  801258:	83 ec 04             	sub    $0x4,%esp
  80125b:	50                   	push   %eax
  80125c:	51                   	push   %ecx
  80125d:	52                   	push   %edx
  80125e:	e8 80 13 00 00       	call   8025e3 <sys_cputs>
  801263:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801266:	8b 45 0c             	mov    0xc(%ebp),%eax
  801269:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80126f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801272:	8b 40 04             	mov    0x4(%eax),%eax
  801275:	8d 50 01             	lea    0x1(%eax),%edx
  801278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80127e:	90                   	nop
  80127f:	c9                   	leave  
  801280:	c3                   	ret    

00801281 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80128a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801291:	00 00 00 
	b.cnt = 0;
  801294:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80129b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80129e:	ff 75 0c             	pushl  0xc(%ebp)
  8012a1:	ff 75 08             	pushl  0x8(%ebp)
  8012a4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8012aa:	50                   	push   %eax
  8012ab:	68 18 12 80 00       	push   $0x801218
  8012b0:	e8 11 02 00 00       	call   8014c6 <vprintfmt>
  8012b5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8012b8:	a0 24 50 80 00       	mov    0x805024,%al
  8012bd:	0f b6 c0             	movzbl %al,%eax
  8012c0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8012c6:	83 ec 04             	sub    $0x4,%esp
  8012c9:	50                   	push   %eax
  8012ca:	52                   	push   %edx
  8012cb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8012d1:	83 c0 08             	add    $0x8,%eax
  8012d4:	50                   	push   %eax
  8012d5:	e8 09 13 00 00       	call   8025e3 <sys_cputs>
  8012da:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8012dd:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8012e4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8012ea:	c9                   	leave  
  8012eb:	c3                   	ret    

008012ec <cprintf>:

int cprintf(const char *fmt, ...) {
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8012f2:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8012f9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8012fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801302:	83 ec 08             	sub    $0x8,%esp
  801305:	ff 75 f4             	pushl  -0xc(%ebp)
  801308:	50                   	push   %eax
  801309:	e8 73 ff ff ff       	call   801281 <vcprintf>
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801314:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801317:	c9                   	leave  
  801318:	c3                   	ret    

00801319 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80131f:	e8 6d 14 00 00       	call   802791 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801324:	8d 45 0c             	lea    0xc(%ebp),%eax
  801327:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	83 ec 08             	sub    $0x8,%esp
  801330:	ff 75 f4             	pushl  -0xc(%ebp)
  801333:	50                   	push   %eax
  801334:	e8 48 ff ff ff       	call   801281 <vcprintf>
  801339:	83 c4 10             	add    $0x10,%esp
  80133c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80133f:	e8 67 14 00 00       	call   8027ab <sys_enable_interrupt>
	return cnt;
  801344:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	53                   	push   %ebx
  80134d:	83 ec 14             	sub    $0x14,%esp
  801350:	8b 45 10             	mov    0x10(%ebp),%eax
  801353:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801356:	8b 45 14             	mov    0x14(%ebp),%eax
  801359:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80135c:	8b 45 18             	mov    0x18(%ebp),%eax
  80135f:	ba 00 00 00 00       	mov    $0x0,%edx
  801364:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801367:	77 55                	ja     8013be <printnum+0x75>
  801369:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80136c:	72 05                	jb     801373 <printnum+0x2a>
  80136e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801371:	77 4b                	ja     8013be <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801373:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801376:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801379:	8b 45 18             	mov    0x18(%ebp),%eax
  80137c:	ba 00 00 00 00       	mov    $0x0,%edx
  801381:	52                   	push   %edx
  801382:	50                   	push   %eax
  801383:	ff 75 f4             	pushl  -0xc(%ebp)
  801386:	ff 75 f0             	pushl  -0x10(%ebp)
  801389:	e8 ce 29 00 00       	call   803d5c <__udivdi3>
  80138e:	83 c4 10             	add    $0x10,%esp
  801391:	83 ec 04             	sub    $0x4,%esp
  801394:	ff 75 20             	pushl  0x20(%ebp)
  801397:	53                   	push   %ebx
  801398:	ff 75 18             	pushl  0x18(%ebp)
  80139b:	52                   	push   %edx
  80139c:	50                   	push   %eax
  80139d:	ff 75 0c             	pushl  0xc(%ebp)
  8013a0:	ff 75 08             	pushl  0x8(%ebp)
  8013a3:	e8 a1 ff ff ff       	call   801349 <printnum>
  8013a8:	83 c4 20             	add    $0x20,%esp
  8013ab:	eb 1a                	jmp    8013c7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	ff 75 0c             	pushl  0xc(%ebp)
  8013b3:	ff 75 20             	pushl  0x20(%ebp)
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	ff d0                	call   *%eax
  8013bb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8013be:	ff 4d 1c             	decl   0x1c(%ebp)
  8013c1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8013c5:	7f e6                	jg     8013ad <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8013c7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8013ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d5:	53                   	push   %ebx
  8013d6:	51                   	push   %ecx
  8013d7:	52                   	push   %edx
  8013d8:	50                   	push   %eax
  8013d9:	e8 8e 2a 00 00       	call   803e6c <__umoddi3>
  8013de:	83 c4 10             	add    $0x10,%esp
  8013e1:	05 b4 46 80 00       	add    $0x8046b4,%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	0f be c0             	movsbl %al,%eax
  8013eb:	83 ec 08             	sub    $0x8,%esp
  8013ee:	ff 75 0c             	pushl  0xc(%ebp)
  8013f1:	50                   	push   %eax
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	ff d0                	call   *%eax
  8013f7:	83 c4 10             	add    $0x10,%esp
}
  8013fa:	90                   	nop
  8013fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013fe:	c9                   	leave  
  8013ff:	c3                   	ret    

00801400 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801403:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801407:	7e 1c                	jle    801425 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	8b 00                	mov    (%eax),%eax
  80140e:	8d 50 08             	lea    0x8(%eax),%edx
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	89 10                	mov    %edx,(%eax)
  801416:	8b 45 08             	mov    0x8(%ebp),%eax
  801419:	8b 00                	mov    (%eax),%eax
  80141b:	83 e8 08             	sub    $0x8,%eax
  80141e:	8b 50 04             	mov    0x4(%eax),%edx
  801421:	8b 00                	mov    (%eax),%eax
  801423:	eb 40                	jmp    801465 <getuint+0x65>
	else if (lflag)
  801425:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801429:	74 1e                	je     801449 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	8b 00                	mov    (%eax),%eax
  801430:	8d 50 04             	lea    0x4(%eax),%edx
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	89 10                	mov    %edx,(%eax)
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8b 00                	mov    (%eax),%eax
  80143d:	83 e8 04             	sub    $0x4,%eax
  801440:	8b 00                	mov    (%eax),%eax
  801442:	ba 00 00 00 00       	mov    $0x0,%edx
  801447:	eb 1c                	jmp    801465 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8b 00                	mov    (%eax),%eax
  80144e:	8d 50 04             	lea    0x4(%eax),%edx
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	89 10                	mov    %edx,(%eax)
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	8b 00                	mov    (%eax),%eax
  80145b:	83 e8 04             	sub    $0x4,%eax
  80145e:	8b 00                	mov    (%eax),%eax
  801460:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801465:	5d                   	pop    %ebp
  801466:	c3                   	ret    

00801467 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80146a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80146e:	7e 1c                	jle    80148c <getint+0x25>
		return va_arg(*ap, long long);
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	8b 00                	mov    (%eax),%eax
  801475:	8d 50 08             	lea    0x8(%eax),%edx
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	89 10                	mov    %edx,(%eax)
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8b 00                	mov    (%eax),%eax
  801482:	83 e8 08             	sub    $0x8,%eax
  801485:	8b 50 04             	mov    0x4(%eax),%edx
  801488:	8b 00                	mov    (%eax),%eax
  80148a:	eb 38                	jmp    8014c4 <getint+0x5d>
	else if (lflag)
  80148c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801490:	74 1a                	je     8014ac <getint+0x45>
		return va_arg(*ap, long);
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8b 00                	mov    (%eax),%eax
  801497:	8d 50 04             	lea    0x4(%eax),%edx
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	89 10                	mov    %edx,(%eax)
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	8b 00                	mov    (%eax),%eax
  8014a4:	83 e8 04             	sub    $0x4,%eax
  8014a7:	8b 00                	mov    (%eax),%eax
  8014a9:	99                   	cltd   
  8014aa:	eb 18                	jmp    8014c4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	8d 50 04             	lea    0x4(%eax),%edx
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	89 10                	mov    %edx,(%eax)
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	8b 00                	mov    (%eax),%eax
  8014be:	83 e8 04             	sub    $0x4,%eax
  8014c1:	8b 00                	mov    (%eax),%eax
  8014c3:	99                   	cltd   
}
  8014c4:	5d                   	pop    %ebp
  8014c5:	c3                   	ret    

008014c6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	56                   	push   %esi
  8014ca:	53                   	push   %ebx
  8014cb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8014ce:	eb 17                	jmp    8014e7 <vprintfmt+0x21>
			if (ch == '\0')
  8014d0:	85 db                	test   %ebx,%ebx
  8014d2:	0f 84 af 03 00 00    	je     801887 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8014d8:	83 ec 08             	sub    $0x8,%esp
  8014db:	ff 75 0c             	pushl  0xc(%ebp)
  8014de:	53                   	push   %ebx
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	ff d0                	call   *%eax
  8014e4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8014e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ea:	8d 50 01             	lea    0x1(%eax),%edx
  8014ed:	89 55 10             	mov    %edx,0x10(%ebp)
  8014f0:	8a 00                	mov    (%eax),%al
  8014f2:	0f b6 d8             	movzbl %al,%ebx
  8014f5:	83 fb 25             	cmp    $0x25,%ebx
  8014f8:	75 d6                	jne    8014d0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8014fa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8014fe:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801505:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80150c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801513:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80151a:	8b 45 10             	mov    0x10(%ebp),%eax
  80151d:	8d 50 01             	lea    0x1(%eax),%edx
  801520:	89 55 10             	mov    %edx,0x10(%ebp)
  801523:	8a 00                	mov    (%eax),%al
  801525:	0f b6 d8             	movzbl %al,%ebx
  801528:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80152b:	83 f8 55             	cmp    $0x55,%eax
  80152e:	0f 87 2b 03 00 00    	ja     80185f <vprintfmt+0x399>
  801534:	8b 04 85 d8 46 80 00 	mov    0x8046d8(,%eax,4),%eax
  80153b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80153d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801541:	eb d7                	jmp    80151a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801543:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801547:	eb d1                	jmp    80151a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801549:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801550:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801553:	89 d0                	mov    %edx,%eax
  801555:	c1 e0 02             	shl    $0x2,%eax
  801558:	01 d0                	add    %edx,%eax
  80155a:	01 c0                	add    %eax,%eax
  80155c:	01 d8                	add    %ebx,%eax
  80155e:	83 e8 30             	sub    $0x30,%eax
  801561:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801564:	8b 45 10             	mov    0x10(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80156c:	83 fb 2f             	cmp    $0x2f,%ebx
  80156f:	7e 3e                	jle    8015af <vprintfmt+0xe9>
  801571:	83 fb 39             	cmp    $0x39,%ebx
  801574:	7f 39                	jg     8015af <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801576:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801579:	eb d5                	jmp    801550 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80157b:	8b 45 14             	mov    0x14(%ebp),%eax
  80157e:	83 c0 04             	add    $0x4,%eax
  801581:	89 45 14             	mov    %eax,0x14(%ebp)
  801584:	8b 45 14             	mov    0x14(%ebp),%eax
  801587:	83 e8 04             	sub    $0x4,%eax
  80158a:	8b 00                	mov    (%eax),%eax
  80158c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80158f:	eb 1f                	jmp    8015b0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801591:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801595:	79 83                	jns    80151a <vprintfmt+0x54>
				width = 0;
  801597:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80159e:	e9 77 ff ff ff       	jmp    80151a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8015a3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8015aa:	e9 6b ff ff ff       	jmp    80151a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8015af:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8015b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015b4:	0f 89 60 ff ff ff    	jns    80151a <vprintfmt+0x54>
				width = precision, precision = -1;
  8015ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8015c0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8015c7:	e9 4e ff ff ff       	jmp    80151a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8015cc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8015cf:	e9 46 ff ff ff       	jmp    80151a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8015d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d7:	83 c0 04             	add    $0x4,%eax
  8015da:	89 45 14             	mov    %eax,0x14(%ebp)
  8015dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e0:	83 e8 04             	sub    $0x4,%eax
  8015e3:	8b 00                	mov    (%eax),%eax
  8015e5:	83 ec 08             	sub    $0x8,%esp
  8015e8:	ff 75 0c             	pushl  0xc(%ebp)
  8015eb:	50                   	push   %eax
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	ff d0                	call   *%eax
  8015f1:	83 c4 10             	add    $0x10,%esp
			break;
  8015f4:	e9 89 02 00 00       	jmp    801882 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8015f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8015fc:	83 c0 04             	add    $0x4,%eax
  8015ff:	89 45 14             	mov    %eax,0x14(%ebp)
  801602:	8b 45 14             	mov    0x14(%ebp),%eax
  801605:	83 e8 04             	sub    $0x4,%eax
  801608:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80160a:	85 db                	test   %ebx,%ebx
  80160c:	79 02                	jns    801610 <vprintfmt+0x14a>
				err = -err;
  80160e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801610:	83 fb 64             	cmp    $0x64,%ebx
  801613:	7f 0b                	jg     801620 <vprintfmt+0x15a>
  801615:	8b 34 9d 20 45 80 00 	mov    0x804520(,%ebx,4),%esi
  80161c:	85 f6                	test   %esi,%esi
  80161e:	75 19                	jne    801639 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801620:	53                   	push   %ebx
  801621:	68 c5 46 80 00       	push   $0x8046c5
  801626:	ff 75 0c             	pushl  0xc(%ebp)
  801629:	ff 75 08             	pushl  0x8(%ebp)
  80162c:	e8 5e 02 00 00       	call   80188f <printfmt>
  801631:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801634:	e9 49 02 00 00       	jmp    801882 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801639:	56                   	push   %esi
  80163a:	68 ce 46 80 00       	push   $0x8046ce
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	ff 75 08             	pushl  0x8(%ebp)
  801645:	e8 45 02 00 00       	call   80188f <printfmt>
  80164a:	83 c4 10             	add    $0x10,%esp
			break;
  80164d:	e9 30 02 00 00       	jmp    801882 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801652:	8b 45 14             	mov    0x14(%ebp),%eax
  801655:	83 c0 04             	add    $0x4,%eax
  801658:	89 45 14             	mov    %eax,0x14(%ebp)
  80165b:	8b 45 14             	mov    0x14(%ebp),%eax
  80165e:	83 e8 04             	sub    $0x4,%eax
  801661:	8b 30                	mov    (%eax),%esi
  801663:	85 f6                	test   %esi,%esi
  801665:	75 05                	jne    80166c <vprintfmt+0x1a6>
				p = "(null)";
  801667:	be d1 46 80 00       	mov    $0x8046d1,%esi
			if (width > 0 && padc != '-')
  80166c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801670:	7e 6d                	jle    8016df <vprintfmt+0x219>
  801672:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801676:	74 67                	je     8016df <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801678:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	50                   	push   %eax
  80167f:	56                   	push   %esi
  801680:	e8 0c 03 00 00       	call   801991 <strnlen>
  801685:	83 c4 10             	add    $0x10,%esp
  801688:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80168b:	eb 16                	jmp    8016a3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80168d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801691:	83 ec 08             	sub    $0x8,%esp
  801694:	ff 75 0c             	pushl  0xc(%ebp)
  801697:	50                   	push   %eax
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	ff d0                	call   *%eax
  80169d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8016a0:	ff 4d e4             	decl   -0x1c(%ebp)
  8016a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016a7:	7f e4                	jg     80168d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8016a9:	eb 34                	jmp    8016df <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8016ab:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8016af:	74 1c                	je     8016cd <vprintfmt+0x207>
  8016b1:	83 fb 1f             	cmp    $0x1f,%ebx
  8016b4:	7e 05                	jle    8016bb <vprintfmt+0x1f5>
  8016b6:	83 fb 7e             	cmp    $0x7e,%ebx
  8016b9:	7e 12                	jle    8016cd <vprintfmt+0x207>
					putch('?', putdat);
  8016bb:	83 ec 08             	sub    $0x8,%esp
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	6a 3f                	push   $0x3f
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	ff d0                	call   *%eax
  8016c8:	83 c4 10             	add    $0x10,%esp
  8016cb:	eb 0f                	jmp    8016dc <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8016cd:	83 ec 08             	sub    $0x8,%esp
  8016d0:	ff 75 0c             	pushl  0xc(%ebp)
  8016d3:	53                   	push   %ebx
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	ff d0                	call   *%eax
  8016d9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8016dc:	ff 4d e4             	decl   -0x1c(%ebp)
  8016df:	89 f0                	mov    %esi,%eax
  8016e1:	8d 70 01             	lea    0x1(%eax),%esi
  8016e4:	8a 00                	mov    (%eax),%al
  8016e6:	0f be d8             	movsbl %al,%ebx
  8016e9:	85 db                	test   %ebx,%ebx
  8016eb:	74 24                	je     801711 <vprintfmt+0x24b>
  8016ed:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016f1:	78 b8                	js     8016ab <vprintfmt+0x1e5>
  8016f3:	ff 4d e0             	decl   -0x20(%ebp)
  8016f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016fa:	79 af                	jns    8016ab <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8016fc:	eb 13                	jmp    801711 <vprintfmt+0x24b>
				putch(' ', putdat);
  8016fe:	83 ec 08             	sub    $0x8,%esp
  801701:	ff 75 0c             	pushl  0xc(%ebp)
  801704:	6a 20                	push   $0x20
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	ff d0                	call   *%eax
  80170b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80170e:	ff 4d e4             	decl   -0x1c(%ebp)
  801711:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801715:	7f e7                	jg     8016fe <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801717:	e9 66 01 00 00       	jmp    801882 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80171c:	83 ec 08             	sub    $0x8,%esp
  80171f:	ff 75 e8             	pushl  -0x18(%ebp)
  801722:	8d 45 14             	lea    0x14(%ebp),%eax
  801725:	50                   	push   %eax
  801726:	e8 3c fd ff ff       	call   801467 <getint>
  80172b:	83 c4 10             	add    $0x10,%esp
  80172e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801731:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173a:	85 d2                	test   %edx,%edx
  80173c:	79 23                	jns    801761 <vprintfmt+0x29b>
				putch('-', putdat);
  80173e:	83 ec 08             	sub    $0x8,%esp
  801741:	ff 75 0c             	pushl  0xc(%ebp)
  801744:	6a 2d                	push   $0x2d
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	ff d0                	call   *%eax
  80174b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80174e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801751:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801754:	f7 d8                	neg    %eax
  801756:	83 d2 00             	adc    $0x0,%edx
  801759:	f7 da                	neg    %edx
  80175b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80175e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801761:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801768:	e9 bc 00 00 00       	jmp    801829 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80176d:	83 ec 08             	sub    $0x8,%esp
  801770:	ff 75 e8             	pushl  -0x18(%ebp)
  801773:	8d 45 14             	lea    0x14(%ebp),%eax
  801776:	50                   	push   %eax
  801777:	e8 84 fc ff ff       	call   801400 <getuint>
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801782:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801785:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80178c:	e9 98 00 00 00       	jmp    801829 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801791:	83 ec 08             	sub    $0x8,%esp
  801794:	ff 75 0c             	pushl  0xc(%ebp)
  801797:	6a 58                	push   $0x58
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	ff d0                	call   *%eax
  80179e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	ff 75 0c             	pushl  0xc(%ebp)
  8017a7:	6a 58                	push   $0x58
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	ff d0                	call   *%eax
  8017ae:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8017b1:	83 ec 08             	sub    $0x8,%esp
  8017b4:	ff 75 0c             	pushl  0xc(%ebp)
  8017b7:	6a 58                	push   $0x58
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	ff d0                	call   *%eax
  8017be:	83 c4 10             	add    $0x10,%esp
			break;
  8017c1:	e9 bc 00 00 00       	jmp    801882 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8017c6:	83 ec 08             	sub    $0x8,%esp
  8017c9:	ff 75 0c             	pushl  0xc(%ebp)
  8017cc:	6a 30                	push   $0x30
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	ff d0                	call   *%eax
  8017d3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8017d6:	83 ec 08             	sub    $0x8,%esp
  8017d9:	ff 75 0c             	pushl  0xc(%ebp)
  8017dc:	6a 78                	push   $0x78
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	ff d0                	call   *%eax
  8017e3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8017e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8017e9:	83 c0 04             	add    $0x4,%eax
  8017ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8017ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f2:	83 e8 04             	sub    $0x4,%eax
  8017f5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8017f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801801:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801808:	eb 1f                	jmp    801829 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80180a:	83 ec 08             	sub    $0x8,%esp
  80180d:	ff 75 e8             	pushl  -0x18(%ebp)
  801810:	8d 45 14             	lea    0x14(%ebp),%eax
  801813:	50                   	push   %eax
  801814:	e8 e7 fb ff ff       	call   801400 <getuint>
  801819:	83 c4 10             	add    $0x10,%esp
  80181c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80181f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801822:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801829:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80182d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801830:	83 ec 04             	sub    $0x4,%esp
  801833:	52                   	push   %edx
  801834:	ff 75 e4             	pushl  -0x1c(%ebp)
  801837:	50                   	push   %eax
  801838:	ff 75 f4             	pushl  -0xc(%ebp)
  80183b:	ff 75 f0             	pushl  -0x10(%ebp)
  80183e:	ff 75 0c             	pushl  0xc(%ebp)
  801841:	ff 75 08             	pushl  0x8(%ebp)
  801844:	e8 00 fb ff ff       	call   801349 <printnum>
  801849:	83 c4 20             	add    $0x20,%esp
			break;
  80184c:	eb 34                	jmp    801882 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80184e:	83 ec 08             	sub    $0x8,%esp
  801851:	ff 75 0c             	pushl  0xc(%ebp)
  801854:	53                   	push   %ebx
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	ff d0                	call   *%eax
  80185a:	83 c4 10             	add    $0x10,%esp
			break;
  80185d:	eb 23                	jmp    801882 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80185f:	83 ec 08             	sub    $0x8,%esp
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	6a 25                	push   $0x25
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	ff d0                	call   *%eax
  80186c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80186f:	ff 4d 10             	decl   0x10(%ebp)
  801872:	eb 03                	jmp    801877 <vprintfmt+0x3b1>
  801874:	ff 4d 10             	decl   0x10(%ebp)
  801877:	8b 45 10             	mov    0x10(%ebp),%eax
  80187a:	48                   	dec    %eax
  80187b:	8a 00                	mov    (%eax),%al
  80187d:	3c 25                	cmp    $0x25,%al
  80187f:	75 f3                	jne    801874 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801881:	90                   	nop
		}
	}
  801882:	e9 47 fc ff ff       	jmp    8014ce <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801887:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801888:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188b:	5b                   	pop    %ebx
  80188c:	5e                   	pop    %esi
  80188d:	5d                   	pop    %ebp
  80188e:	c3                   	ret    

0080188f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801895:	8d 45 10             	lea    0x10(%ebp),%eax
  801898:	83 c0 04             	add    $0x4,%eax
  80189b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80189e:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a4:	50                   	push   %eax
  8018a5:	ff 75 0c             	pushl  0xc(%ebp)
  8018a8:	ff 75 08             	pushl  0x8(%ebp)
  8018ab:	e8 16 fc ff ff       	call   8014c6 <vprintfmt>
  8018b0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8018b3:	90                   	nop
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8018b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bc:	8b 40 08             	mov    0x8(%eax),%eax
  8018bf:	8d 50 01             	lea    0x1(%eax),%edx
  8018c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8018c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cb:	8b 10                	mov    (%eax),%edx
  8018cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d0:	8b 40 04             	mov    0x4(%eax),%eax
  8018d3:	39 c2                	cmp    %eax,%edx
  8018d5:	73 12                	jae    8018e9 <sprintputch+0x33>
		*b->buf++ = ch;
  8018d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018da:	8b 00                	mov    (%eax),%eax
  8018dc:	8d 48 01             	lea    0x1(%eax),%ecx
  8018df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e2:	89 0a                	mov    %ecx,(%edx)
  8018e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8018e7:	88 10                	mov    %dl,(%eax)
}
  8018e9:	90                   	nop
  8018ea:	5d                   	pop    %ebp
  8018eb:	c3                   	ret    

008018ec <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	01 d0                	add    %edx,%eax
  801903:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801906:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80190d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801911:	74 06                	je     801919 <vsnprintf+0x2d>
  801913:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801917:	7f 07                	jg     801920 <vsnprintf+0x34>
		return -E_INVAL;
  801919:	b8 03 00 00 00       	mov    $0x3,%eax
  80191e:	eb 20                	jmp    801940 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801920:	ff 75 14             	pushl  0x14(%ebp)
  801923:	ff 75 10             	pushl  0x10(%ebp)
  801926:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801929:	50                   	push   %eax
  80192a:	68 b6 18 80 00       	push   $0x8018b6
  80192f:	e8 92 fb ff ff       	call   8014c6 <vprintfmt>
  801934:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801937:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80193a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80193d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801948:	8d 45 10             	lea    0x10(%ebp),%eax
  80194b:	83 c0 04             	add    $0x4,%eax
  80194e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801951:	8b 45 10             	mov    0x10(%ebp),%eax
  801954:	ff 75 f4             	pushl  -0xc(%ebp)
  801957:	50                   	push   %eax
  801958:	ff 75 0c             	pushl  0xc(%ebp)
  80195b:	ff 75 08             	pushl  0x8(%ebp)
  80195e:	e8 89 ff ff ff       	call   8018ec <vsnprintf>
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801969:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801974:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80197b:	eb 06                	jmp    801983 <strlen+0x15>
		n++;
  80197d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801980:	ff 45 08             	incl   0x8(%ebp)
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8a 00                	mov    (%eax),%al
  801988:	84 c0                	test   %al,%al
  80198a:	75 f1                	jne    80197d <strlen+0xf>
		n++;
	return n;
  80198c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801997:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80199e:	eb 09                	jmp    8019a9 <strnlen+0x18>
		n++;
  8019a0:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8019a3:	ff 45 08             	incl   0x8(%ebp)
  8019a6:	ff 4d 0c             	decl   0xc(%ebp)
  8019a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019ad:	74 09                	je     8019b8 <strnlen+0x27>
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	8a 00                	mov    (%eax),%al
  8019b4:	84 c0                	test   %al,%al
  8019b6:	75 e8                	jne    8019a0 <strnlen+0xf>
		n++;
	return n;
  8019b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8019c9:	90                   	nop
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	8d 50 01             	lea    0x1(%eax),%edx
  8019d0:	89 55 08             	mov    %edx,0x8(%ebp)
  8019d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019d9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8019dc:	8a 12                	mov    (%edx),%dl
  8019de:	88 10                	mov    %dl,(%eax)
  8019e0:	8a 00                	mov    (%eax),%al
  8019e2:	84 c0                	test   %al,%al
  8019e4:	75 e4                	jne    8019ca <strcpy+0xd>
		/* do nothing */;
	return ret;
  8019e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8019f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019fe:	eb 1f                	jmp    801a1f <strncpy+0x34>
		*dst++ = *src;
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	8d 50 01             	lea    0x1(%eax),%edx
  801a06:	89 55 08             	mov    %edx,0x8(%ebp)
  801a09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0c:	8a 12                	mov    (%edx),%dl
  801a0e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a13:	8a 00                	mov    (%eax),%al
  801a15:	84 c0                	test   %al,%al
  801a17:	74 03                	je     801a1c <strncpy+0x31>
			src++;
  801a19:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801a1c:	ff 45 fc             	incl   -0x4(%ebp)
  801a1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a22:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a25:	72 d9                	jb     801a00 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801a27:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801a38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a3c:	74 30                	je     801a6e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801a3e:	eb 16                	jmp    801a56 <strlcpy+0x2a>
			*dst++ = *src++;
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	8d 50 01             	lea    0x1(%eax),%edx
  801a46:	89 55 08             	mov    %edx,0x8(%ebp)
  801a49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4c:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a4f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801a52:	8a 12                	mov    (%edx),%dl
  801a54:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a56:	ff 4d 10             	decl   0x10(%ebp)
  801a59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a5d:	74 09                	je     801a68 <strlcpy+0x3c>
  801a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a62:	8a 00                	mov    (%eax),%al
  801a64:	84 c0                	test   %al,%al
  801a66:	75 d8                	jne    801a40 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801a6e:	8b 55 08             	mov    0x8(%ebp),%edx
  801a71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a74:	29 c2                	sub    %eax,%edx
  801a76:	89 d0                	mov    %edx,%eax
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801a7d:	eb 06                	jmp    801a85 <strcmp+0xb>
		p++, q++;
  801a7f:	ff 45 08             	incl   0x8(%ebp)
  801a82:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	8a 00                	mov    (%eax),%al
  801a8a:	84 c0                	test   %al,%al
  801a8c:	74 0e                	je     801a9c <strcmp+0x22>
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	8a 10                	mov    (%eax),%dl
  801a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a96:	8a 00                	mov    (%eax),%al
  801a98:	38 c2                	cmp    %al,%dl
  801a9a:	74 e3                	je     801a7f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8a 00                	mov    (%eax),%al
  801aa1:	0f b6 d0             	movzbl %al,%edx
  801aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa7:	8a 00                	mov    (%eax),%al
  801aa9:	0f b6 c0             	movzbl %al,%eax
  801aac:	29 c2                	sub    %eax,%edx
  801aae:	89 d0                	mov    %edx,%eax
}
  801ab0:	5d                   	pop    %ebp
  801ab1:	c3                   	ret    

00801ab2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801ab5:	eb 09                	jmp    801ac0 <strncmp+0xe>
		n--, p++, q++;
  801ab7:	ff 4d 10             	decl   0x10(%ebp)
  801aba:	ff 45 08             	incl   0x8(%ebp)
  801abd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801ac0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ac4:	74 17                	je     801add <strncmp+0x2b>
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	8a 00                	mov    (%eax),%al
  801acb:	84 c0                	test   %al,%al
  801acd:	74 0e                	je     801add <strncmp+0x2b>
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	8a 10                	mov    (%eax),%dl
  801ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad7:	8a 00                	mov    (%eax),%al
  801ad9:	38 c2                	cmp    %al,%dl
  801adb:	74 da                	je     801ab7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801add:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ae1:	75 07                	jne    801aea <strncmp+0x38>
		return 0;
  801ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae8:	eb 14                	jmp    801afe <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	8a 00                	mov    (%eax),%al
  801aef:	0f b6 d0             	movzbl %al,%edx
  801af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af5:	8a 00                	mov    (%eax),%al
  801af7:	0f b6 c0             	movzbl %al,%eax
  801afa:	29 c2                	sub    %eax,%edx
  801afc:	89 d0                	mov    %edx,%eax
}
  801afe:	5d                   	pop    %ebp
  801aff:	c3                   	ret    

00801b00 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 04             	sub    $0x4,%esp
  801b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b09:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801b0c:	eb 12                	jmp    801b20 <strchr+0x20>
		if (*s == c)
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	8a 00                	mov    (%eax),%al
  801b13:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801b16:	75 05                	jne    801b1d <strchr+0x1d>
			return (char *) s;
  801b18:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1b:	eb 11                	jmp    801b2e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b1d:	ff 45 08             	incl   0x8(%ebp)
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	8a 00                	mov    (%eax),%al
  801b25:	84 c0                	test   %al,%al
  801b27:	75 e5                	jne    801b0e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801b29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 04             	sub    $0x4,%esp
  801b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b39:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801b3c:	eb 0d                	jmp    801b4b <strfind+0x1b>
		if (*s == c)
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	8a 00                	mov    (%eax),%al
  801b43:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801b46:	74 0e                	je     801b56 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b48:	ff 45 08             	incl   0x8(%ebp)
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	8a 00                	mov    (%eax),%al
  801b50:	84 c0                	test   %al,%al
  801b52:	75 ea                	jne    801b3e <strfind+0xe>
  801b54:	eb 01                	jmp    801b57 <strfind+0x27>
		if (*s == c)
			break;
  801b56:	90                   	nop
	return (char *) s;
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801b68:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801b6e:	eb 0e                	jmp    801b7e <memset+0x22>
		*p++ = c;
  801b70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b73:	8d 50 01             	lea    0x1(%eax),%edx
  801b76:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801b7e:	ff 4d f8             	decl   -0x8(%ebp)
  801b81:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801b85:	79 e9                	jns    801b70 <memset+0x14>
		*p++ = c;

	return v;
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801b9e:	eb 16                	jmp    801bb6 <memcpy+0x2a>
		*d++ = *s++;
  801ba0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba3:	8d 50 01             	lea    0x1(%eax),%edx
  801ba6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ba9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bac:	8d 4a 01             	lea    0x1(%edx),%ecx
  801baf:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801bb2:	8a 12                	mov    (%edx),%dl
  801bb4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801bb6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb9:	8d 50 ff             	lea    -0x1(%eax),%edx
  801bbc:	89 55 10             	mov    %edx,0x10(%ebp)
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	75 dd                	jne    801ba0 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801bda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bdd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801be0:	73 50                	jae    801c32 <memmove+0x6a>
  801be2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be5:	8b 45 10             	mov    0x10(%ebp),%eax
  801be8:	01 d0                	add    %edx,%eax
  801bea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801bed:	76 43                	jbe    801c32 <memmove+0x6a>
		s += n;
  801bef:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801bf5:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801bfb:	eb 10                	jmp    801c0d <memmove+0x45>
			*--d = *--s;
  801bfd:	ff 4d f8             	decl   -0x8(%ebp)
  801c00:	ff 4d fc             	decl   -0x4(%ebp)
  801c03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c06:	8a 10                	mov    (%eax),%dl
  801c08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c0b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c10:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c13:	89 55 10             	mov    %edx,0x10(%ebp)
  801c16:	85 c0                	test   %eax,%eax
  801c18:	75 e3                	jne    801bfd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801c1a:	eb 23                	jmp    801c3f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801c1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c1f:	8d 50 01             	lea    0x1(%eax),%edx
  801c22:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c28:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c2b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801c2e:	8a 12                	mov    (%edx),%dl
  801c30:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801c32:	8b 45 10             	mov    0x10(%ebp),%eax
  801c35:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c38:	89 55 10             	mov    %edx,0x10(%ebp)
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	75 dd                	jne    801c1c <memmove+0x54>
			*d++ = *s++;

	return dst;
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c53:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801c56:	eb 2a                	jmp    801c82 <memcmp+0x3e>
		if (*s1 != *s2)
  801c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c5b:	8a 10                	mov    (%eax),%dl
  801c5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c60:	8a 00                	mov    (%eax),%al
  801c62:	38 c2                	cmp    %al,%dl
  801c64:	74 16                	je     801c7c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c69:	8a 00                	mov    (%eax),%al
  801c6b:	0f b6 d0             	movzbl %al,%edx
  801c6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c71:	8a 00                	mov    (%eax),%al
  801c73:	0f b6 c0             	movzbl %al,%eax
  801c76:	29 c2                	sub    %eax,%edx
  801c78:	89 d0                	mov    %edx,%eax
  801c7a:	eb 18                	jmp    801c94 <memcmp+0x50>
		s1++, s2++;
  801c7c:	ff 45 fc             	incl   -0x4(%ebp)
  801c7f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801c82:	8b 45 10             	mov    0x10(%ebp),%eax
  801c85:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c88:	89 55 10             	mov    %edx,0x10(%ebp)
  801c8b:	85 c0                	test   %eax,%eax
  801c8d:	75 c9                	jne    801c58 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  801c9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca2:	01 d0                	add    %edx,%eax
  801ca4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801ca7:	eb 15                	jmp    801cbe <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	8a 00                	mov    (%eax),%al
  801cae:	0f b6 d0             	movzbl %al,%edx
  801cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb4:	0f b6 c0             	movzbl %al,%eax
  801cb7:	39 c2                	cmp    %eax,%edx
  801cb9:	74 0d                	je     801cc8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801cbb:	ff 45 08             	incl   0x8(%ebp)
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801cc4:	72 e3                	jb     801ca9 <memfind+0x13>
  801cc6:	eb 01                	jmp    801cc9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801cc8:	90                   	nop
	return (void *) s;
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801cd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801cdb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ce2:	eb 03                	jmp    801ce7 <strtol+0x19>
		s++;
  801ce4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	8a 00                	mov    (%eax),%al
  801cec:	3c 20                	cmp    $0x20,%al
  801cee:	74 f4                	je     801ce4 <strtol+0x16>
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	8a 00                	mov    (%eax),%al
  801cf5:	3c 09                	cmp    $0x9,%al
  801cf7:	74 eb                	je     801ce4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	8a 00                	mov    (%eax),%al
  801cfe:	3c 2b                	cmp    $0x2b,%al
  801d00:	75 05                	jne    801d07 <strtol+0x39>
		s++;
  801d02:	ff 45 08             	incl   0x8(%ebp)
  801d05:	eb 13                	jmp    801d1a <strtol+0x4c>
	else if (*s == '-')
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	8a 00                	mov    (%eax),%al
  801d0c:	3c 2d                	cmp    $0x2d,%al
  801d0e:	75 0a                	jne    801d1a <strtol+0x4c>
		s++, neg = 1;
  801d10:	ff 45 08             	incl   0x8(%ebp)
  801d13:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801d1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d1e:	74 06                	je     801d26 <strtol+0x58>
  801d20:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801d24:	75 20                	jne    801d46 <strtol+0x78>
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	8a 00                	mov    (%eax),%al
  801d2b:	3c 30                	cmp    $0x30,%al
  801d2d:	75 17                	jne    801d46 <strtol+0x78>
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	40                   	inc    %eax
  801d33:	8a 00                	mov    (%eax),%al
  801d35:	3c 78                	cmp    $0x78,%al
  801d37:	75 0d                	jne    801d46 <strtol+0x78>
		s += 2, base = 16;
  801d39:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801d3d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801d44:	eb 28                	jmp    801d6e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801d46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d4a:	75 15                	jne    801d61 <strtol+0x93>
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	8a 00                	mov    (%eax),%al
  801d51:	3c 30                	cmp    $0x30,%al
  801d53:	75 0c                	jne    801d61 <strtol+0x93>
		s++, base = 8;
  801d55:	ff 45 08             	incl   0x8(%ebp)
  801d58:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801d5f:	eb 0d                	jmp    801d6e <strtol+0xa0>
	else if (base == 0)
  801d61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d65:	75 07                	jne    801d6e <strtol+0xa0>
		base = 10;
  801d67:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d71:	8a 00                	mov    (%eax),%al
  801d73:	3c 2f                	cmp    $0x2f,%al
  801d75:	7e 19                	jle    801d90 <strtol+0xc2>
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	8a 00                	mov    (%eax),%al
  801d7c:	3c 39                	cmp    $0x39,%al
  801d7e:	7f 10                	jg     801d90 <strtol+0xc2>
			dig = *s - '0';
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	8a 00                	mov    (%eax),%al
  801d85:	0f be c0             	movsbl %al,%eax
  801d88:	83 e8 30             	sub    $0x30,%eax
  801d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d8e:	eb 42                	jmp    801dd2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	8a 00                	mov    (%eax),%al
  801d95:	3c 60                	cmp    $0x60,%al
  801d97:	7e 19                	jle    801db2 <strtol+0xe4>
  801d99:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9c:	8a 00                	mov    (%eax),%al
  801d9e:	3c 7a                	cmp    $0x7a,%al
  801da0:	7f 10                	jg     801db2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	8a 00                	mov    (%eax),%al
  801da7:	0f be c0             	movsbl %al,%eax
  801daa:	83 e8 57             	sub    $0x57,%eax
  801dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801db0:	eb 20                	jmp    801dd2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	8a 00                	mov    (%eax),%al
  801db7:	3c 40                	cmp    $0x40,%al
  801db9:	7e 39                	jle    801df4 <strtol+0x126>
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	8a 00                	mov    (%eax),%al
  801dc0:	3c 5a                	cmp    $0x5a,%al
  801dc2:	7f 30                	jg     801df4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	8a 00                	mov    (%eax),%al
  801dc9:	0f be c0             	movsbl %al,%eax
  801dcc:	83 e8 37             	sub    $0x37,%eax
  801dcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd5:	3b 45 10             	cmp    0x10(%ebp),%eax
  801dd8:	7d 19                	jge    801df3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801dda:	ff 45 08             	incl   0x8(%ebp)
  801ddd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801de0:	0f af 45 10          	imul   0x10(%ebp),%eax
  801de4:	89 c2                	mov    %eax,%edx
  801de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de9:	01 d0                	add    %edx,%eax
  801deb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801dee:	e9 7b ff ff ff       	jmp    801d6e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801df3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801df4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801df8:	74 08                	je     801e02 <strtol+0x134>
		*endptr = (char *) s;
  801dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  801e00:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801e02:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e06:	74 07                	je     801e0f <strtol+0x141>
  801e08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e0b:	f7 d8                	neg    %eax
  801e0d:	eb 03                	jmp    801e12 <strtol+0x144>
  801e0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <ltostr>:

void
ltostr(long value, char *str)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801e1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801e21:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801e28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e2c:	79 13                	jns    801e41 <ltostr+0x2d>
	{
		neg = 1;
  801e2e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e38:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801e3b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801e3e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801e41:	8b 45 08             	mov    0x8(%ebp),%eax
  801e44:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801e49:	99                   	cltd   
  801e4a:	f7 f9                	idiv   %ecx
  801e4c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e52:	8d 50 01             	lea    0x1(%eax),%edx
  801e55:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e58:	89 c2                	mov    %eax,%edx
  801e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5d:	01 d0                	add    %edx,%eax
  801e5f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e62:	83 c2 30             	add    $0x30,%edx
  801e65:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801e67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e6a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801e6f:	f7 e9                	imul   %ecx
  801e71:	c1 fa 02             	sar    $0x2,%edx
  801e74:	89 c8                	mov    %ecx,%eax
  801e76:	c1 f8 1f             	sar    $0x1f,%eax
  801e79:	29 c2                	sub    %eax,%edx
  801e7b:	89 d0                	mov    %edx,%eax
  801e7d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801e80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e83:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801e88:	f7 e9                	imul   %ecx
  801e8a:	c1 fa 02             	sar    $0x2,%edx
  801e8d:	89 c8                	mov    %ecx,%eax
  801e8f:	c1 f8 1f             	sar    $0x1f,%eax
  801e92:	29 c2                	sub    %eax,%edx
  801e94:	89 d0                	mov    %edx,%eax
  801e96:	c1 e0 02             	shl    $0x2,%eax
  801e99:	01 d0                	add    %edx,%eax
  801e9b:	01 c0                	add    %eax,%eax
  801e9d:	29 c1                	sub    %eax,%ecx
  801e9f:	89 ca                	mov    %ecx,%edx
  801ea1:	85 d2                	test   %edx,%edx
  801ea3:	75 9c                	jne    801e41 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801ea5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801eac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eaf:	48                   	dec    %eax
  801eb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801eb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801eb7:	74 3d                	je     801ef6 <ltostr+0xe2>
		start = 1 ;
  801eb9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801ec0:	eb 34                	jmp    801ef6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801ec2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec8:	01 d0                	add    %edx,%eax
  801eca:	8a 00                	mov    (%eax),%al
  801ecc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801ecf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed5:	01 c2                	add    %eax,%edx
  801ed7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edd:	01 c8                	add    %ecx,%eax
  801edf:	8a 00                	mov    (%eax),%al
  801ee1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801ee3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee9:	01 c2                	add    %eax,%edx
  801eeb:	8a 45 eb             	mov    -0x15(%ebp),%al
  801eee:	88 02                	mov    %al,(%edx)
		start++ ;
  801ef0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801ef3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801efc:	7c c4                	jl     801ec2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801efe:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f04:	01 d0                	add    %edx,%eax
  801f06:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801f09:	90                   	nop
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
  801f0f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801f12:	ff 75 08             	pushl  0x8(%ebp)
  801f15:	e8 54 fa ff ff       	call   80196e <strlen>
  801f1a:	83 c4 04             	add    $0x4,%esp
  801f1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	e8 46 fa ff ff       	call   80196e <strlen>
  801f28:	83 c4 04             	add    $0x4,%esp
  801f2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801f2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801f35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f3c:	eb 17                	jmp    801f55 <strcconcat+0x49>
		final[s] = str1[s] ;
  801f3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f41:	8b 45 10             	mov    0x10(%ebp),%eax
  801f44:	01 c2                	add    %eax,%edx
  801f46:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	01 c8                	add    %ecx,%eax
  801f4e:	8a 00                	mov    (%eax),%al
  801f50:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801f52:	ff 45 fc             	incl   -0x4(%ebp)
  801f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f58:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801f5b:	7c e1                	jl     801f3e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801f5d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801f64:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801f6b:	eb 1f                	jmp    801f8c <strcconcat+0x80>
		final[s++] = str2[i] ;
  801f6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f70:	8d 50 01             	lea    0x1(%eax),%edx
  801f73:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801f76:	89 c2                	mov    %eax,%edx
  801f78:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7b:	01 c2                	add    %eax,%edx
  801f7d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f83:	01 c8                	add    %ecx,%eax
  801f85:	8a 00                	mov    (%eax),%al
  801f87:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801f89:	ff 45 f8             	incl   -0x8(%ebp)
  801f8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f8f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f92:	7c d9                	jl     801f6d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801f94:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f97:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9a:	01 d0                	add    %edx,%eax
  801f9c:	c6 00 00             	movb   $0x0,(%eax)
}
  801f9f:	90                   	nop
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801fa5:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801fae:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb1:	8b 00                	mov    (%eax),%eax
  801fb3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801fba:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbd:	01 d0                	add    %edx,%eax
  801fbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801fc5:	eb 0c                	jmp    801fd3 <strsplit+0x31>
			*string++ = 0;
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	8d 50 01             	lea    0x1(%eax),%edx
  801fcd:	89 55 08             	mov    %edx,0x8(%ebp)
  801fd0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	8a 00                	mov    (%eax),%al
  801fd8:	84 c0                	test   %al,%al
  801fda:	74 18                	je     801ff4 <strsplit+0x52>
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	8a 00                	mov    (%eax),%al
  801fe1:	0f be c0             	movsbl %al,%eax
  801fe4:	50                   	push   %eax
  801fe5:	ff 75 0c             	pushl  0xc(%ebp)
  801fe8:	e8 13 fb ff ff       	call   801b00 <strchr>
  801fed:	83 c4 08             	add    $0x8,%esp
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	75 d3                	jne    801fc7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	8a 00                	mov    (%eax),%al
  801ff9:	84 c0                	test   %al,%al
  801ffb:	74 5a                	je     802057 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ffd:	8b 45 14             	mov    0x14(%ebp),%eax
  802000:	8b 00                	mov    (%eax),%eax
  802002:	83 f8 0f             	cmp    $0xf,%eax
  802005:	75 07                	jne    80200e <strsplit+0x6c>
		{
			return 0;
  802007:	b8 00 00 00 00       	mov    $0x0,%eax
  80200c:	eb 66                	jmp    802074 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80200e:	8b 45 14             	mov    0x14(%ebp),%eax
  802011:	8b 00                	mov    (%eax),%eax
  802013:	8d 48 01             	lea    0x1(%eax),%ecx
  802016:	8b 55 14             	mov    0x14(%ebp),%edx
  802019:	89 0a                	mov    %ecx,(%edx)
  80201b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802022:	8b 45 10             	mov    0x10(%ebp),%eax
  802025:	01 c2                	add    %eax,%edx
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80202c:	eb 03                	jmp    802031 <strsplit+0x8f>
			string++;
  80202e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	8a 00                	mov    (%eax),%al
  802036:	84 c0                	test   %al,%al
  802038:	74 8b                	je     801fc5 <strsplit+0x23>
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	8a 00                	mov    (%eax),%al
  80203f:	0f be c0             	movsbl %al,%eax
  802042:	50                   	push   %eax
  802043:	ff 75 0c             	pushl  0xc(%ebp)
  802046:	e8 b5 fa ff ff       	call   801b00 <strchr>
  80204b:	83 c4 08             	add    $0x8,%esp
  80204e:	85 c0                	test   %eax,%eax
  802050:	74 dc                	je     80202e <strsplit+0x8c>
			string++;
	}
  802052:	e9 6e ff ff ff       	jmp    801fc5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802057:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802058:	8b 45 14             	mov    0x14(%ebp),%eax
  80205b:	8b 00                	mov    (%eax),%eax
  80205d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802064:	8b 45 10             	mov    0x10(%ebp),%eax
  802067:	01 d0                	add    %edx,%eax
  802069:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80206f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80207c:	a1 04 50 80 00       	mov    0x805004,%eax
  802081:	85 c0                	test   %eax,%eax
  802083:	74 1f                	je     8020a4 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  802085:	e8 1d 00 00 00       	call   8020a7 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80208a:	83 ec 0c             	sub    $0xc,%esp
  80208d:	68 30 48 80 00       	push   $0x804830
  802092:	e8 55 f2 ff ff       	call   8012ec <cprintf>
  802097:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80209a:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8020a1:	00 00 00 
	}
}
  8020a4:	90                   	nop
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  8020ad:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8020b4:	00 00 00 
  8020b7:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8020be:	00 00 00 
  8020c1:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8020c8:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  8020cb:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8020d2:	00 00 00 
  8020d5:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8020dc:	00 00 00 
  8020df:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8020e6:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  8020e9:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8020f8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8020fd:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  802102:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  802109:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80210c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802116:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  80211b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80211e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802121:	ba 00 00 00 00       	mov    $0x0,%edx
  802126:	f7 75 f0             	divl   -0x10(%ebp)
  802129:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212c:	29 d0                	sub    %edx,%eax
  80212e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  802131:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  802138:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80213b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802140:	2d 00 10 00 00       	sub    $0x1000,%eax
  802145:	83 ec 04             	sub    $0x4,%esp
  802148:	6a 06                	push   $0x6
  80214a:	ff 75 e8             	pushl  -0x18(%ebp)
  80214d:	50                   	push   %eax
  80214e:	e8 d4 05 00 00       	call   802727 <sys_allocate_chunk>
  802153:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802156:	a1 20 51 80 00       	mov    0x805120,%eax
  80215b:	83 ec 0c             	sub    $0xc,%esp
  80215e:	50                   	push   %eax
  80215f:	e8 49 0c 00 00       	call   802dad <initialize_MemBlocksList>
  802164:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  802167:	a1 48 51 80 00       	mov    0x805148,%eax
  80216c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  80216f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802173:	75 14                	jne    802189 <initialize_dyn_block_system+0xe2>
  802175:	83 ec 04             	sub    $0x4,%esp
  802178:	68 55 48 80 00       	push   $0x804855
  80217d:	6a 39                	push   $0x39
  80217f:	68 73 48 80 00       	push   $0x804873
  802184:	e8 af ee ff ff       	call   801038 <_panic>
  802189:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80218c:	8b 00                	mov    (%eax),%eax
  80218e:	85 c0                	test   %eax,%eax
  802190:	74 10                	je     8021a2 <initialize_dyn_block_system+0xfb>
  802192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802195:	8b 00                	mov    (%eax),%eax
  802197:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80219a:	8b 52 04             	mov    0x4(%edx),%edx
  80219d:	89 50 04             	mov    %edx,0x4(%eax)
  8021a0:	eb 0b                	jmp    8021ad <initialize_dyn_block_system+0x106>
  8021a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021a5:	8b 40 04             	mov    0x4(%eax),%eax
  8021a8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8021ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021b0:	8b 40 04             	mov    0x4(%eax),%eax
  8021b3:	85 c0                	test   %eax,%eax
  8021b5:	74 0f                	je     8021c6 <initialize_dyn_block_system+0x11f>
  8021b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021ba:	8b 40 04             	mov    0x4(%eax),%eax
  8021bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021c0:	8b 12                	mov    (%edx),%edx
  8021c2:	89 10                	mov    %edx,(%eax)
  8021c4:	eb 0a                	jmp    8021d0 <initialize_dyn_block_system+0x129>
  8021c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021c9:	8b 00                	mov    (%eax),%eax
  8021cb:	a3 48 51 80 00       	mov    %eax,0x805148
  8021d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e3:	a1 54 51 80 00       	mov    0x805154,%eax
  8021e8:	48                   	dec    %eax
  8021e9:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  8021ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021f1:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  8021f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021fb:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  802202:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802206:	75 14                	jne    80221c <initialize_dyn_block_system+0x175>
  802208:	83 ec 04             	sub    $0x4,%esp
  80220b:	68 80 48 80 00       	push   $0x804880
  802210:	6a 3f                	push   $0x3f
  802212:	68 73 48 80 00       	push   $0x804873
  802217:	e8 1c ee ff ff       	call   801038 <_panic>
  80221c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802225:	89 10                	mov    %edx,(%eax)
  802227:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80222a:	8b 00                	mov    (%eax),%eax
  80222c:	85 c0                	test   %eax,%eax
  80222e:	74 0d                	je     80223d <initialize_dyn_block_system+0x196>
  802230:	a1 38 51 80 00       	mov    0x805138,%eax
  802235:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802238:	89 50 04             	mov    %edx,0x4(%eax)
  80223b:	eb 08                	jmp    802245 <initialize_dyn_block_system+0x19e>
  80223d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802240:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802245:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802248:	a3 38 51 80 00       	mov    %eax,0x805138
  80224d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802250:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802257:	a1 44 51 80 00       	mov    0x805144,%eax
  80225c:	40                   	inc    %eax
  80225d:	a3 44 51 80 00       	mov    %eax,0x805144

}
  802262:	90                   	nop
  802263:	c9                   	leave  
  802264:	c3                   	ret    

00802265 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802265:	55                   	push   %ebp
  802266:	89 e5                	mov    %esp,%ebp
  802268:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80226b:	e8 06 fe ff ff       	call   802076 <InitializeUHeap>
	if (size == 0) return NULL ;
  802270:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802274:	75 07                	jne    80227d <malloc+0x18>
  802276:	b8 00 00 00 00       	mov    $0x0,%eax
  80227b:	eb 7d                	jmp    8022fa <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  80227d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  802284:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80228b:	8b 55 08             	mov    0x8(%ebp),%edx
  80228e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802291:	01 d0                	add    %edx,%eax
  802293:	48                   	dec    %eax
  802294:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802297:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229a:	ba 00 00 00 00       	mov    $0x0,%edx
  80229f:	f7 75 f0             	divl   -0x10(%ebp)
  8022a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a5:	29 d0                	sub    %edx,%eax
  8022a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  8022aa:	e8 46 08 00 00       	call   802af5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8022af:	83 f8 01             	cmp    $0x1,%eax
  8022b2:	75 07                	jne    8022bb <malloc+0x56>
  8022b4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  8022bb:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8022bf:	75 34                	jne    8022f5 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  8022c1:	83 ec 0c             	sub    $0xc,%esp
  8022c4:	ff 75 e8             	pushl  -0x18(%ebp)
  8022c7:	e8 73 0e 00 00       	call   80313f <alloc_block_FF>
  8022cc:	83 c4 10             	add    $0x10,%esp
  8022cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  8022d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022d6:	74 16                	je     8022ee <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  8022d8:	83 ec 0c             	sub    $0xc,%esp
  8022db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8022de:	e8 ff 0b 00 00       	call   802ee2 <insert_sorted_allocList>
  8022e3:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  8022e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022e9:	8b 40 08             	mov    0x8(%eax),%eax
  8022ec:	eb 0c                	jmp    8022fa <malloc+0x95>
	             }
	             else
	             	return NULL;
  8022ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f3:	eb 05                	jmp    8022fa <malloc+0x95>
	      	  }
	          else
	               return NULL;
  8022f5:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  8022fa:	c9                   	leave  
  8022fb:	c3                   	ret    

008022fc <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
  8022ff:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  802302:	8b 45 08             	mov    0x8(%ebp),%eax
  802305:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80230e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802311:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802316:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  802319:	83 ec 08             	sub    $0x8,%esp
  80231c:	ff 75 f4             	pushl  -0xc(%ebp)
  80231f:	68 40 50 80 00       	push   $0x805040
  802324:	e8 61 0b 00 00       	call   802e8a <find_block>
  802329:	83 c4 10             	add    $0x10,%esp
  80232c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  80232f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802333:	0f 84 a5 00 00 00    	je     8023de <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  802339:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233c:	8b 40 0c             	mov    0xc(%eax),%eax
  80233f:	83 ec 08             	sub    $0x8,%esp
  802342:	50                   	push   %eax
  802343:	ff 75 f4             	pushl  -0xc(%ebp)
  802346:	e8 a4 03 00 00       	call   8026ef <sys_free_user_mem>
  80234b:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  80234e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802352:	75 17                	jne    80236b <free+0x6f>
  802354:	83 ec 04             	sub    $0x4,%esp
  802357:	68 55 48 80 00       	push   $0x804855
  80235c:	68 87 00 00 00       	push   $0x87
  802361:	68 73 48 80 00       	push   $0x804873
  802366:	e8 cd ec ff ff       	call   801038 <_panic>
  80236b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236e:	8b 00                	mov    (%eax),%eax
  802370:	85 c0                	test   %eax,%eax
  802372:	74 10                	je     802384 <free+0x88>
  802374:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802377:	8b 00                	mov    (%eax),%eax
  802379:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80237c:	8b 52 04             	mov    0x4(%edx),%edx
  80237f:	89 50 04             	mov    %edx,0x4(%eax)
  802382:	eb 0b                	jmp    80238f <free+0x93>
  802384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802387:	8b 40 04             	mov    0x4(%eax),%eax
  80238a:	a3 44 50 80 00       	mov    %eax,0x805044
  80238f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802392:	8b 40 04             	mov    0x4(%eax),%eax
  802395:	85 c0                	test   %eax,%eax
  802397:	74 0f                	je     8023a8 <free+0xac>
  802399:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239c:	8b 40 04             	mov    0x4(%eax),%eax
  80239f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023a2:	8b 12                	mov    (%edx),%edx
  8023a4:	89 10                	mov    %edx,(%eax)
  8023a6:	eb 0a                	jmp    8023b2 <free+0xb6>
  8023a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ab:	8b 00                	mov    (%eax),%eax
  8023ad:	a3 40 50 80 00       	mov    %eax,0x805040
  8023b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023ca:	48                   	dec    %eax
  8023cb:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  8023d0:	83 ec 0c             	sub    $0xc,%esp
  8023d3:	ff 75 ec             	pushl  -0x14(%ebp)
  8023d6:	e8 37 12 00 00       	call   803612 <insert_sorted_with_merge_freeList>
  8023db:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  8023de:	90                   	nop
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
  8023e4:	83 ec 38             	sub    $0x38,%esp
  8023e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ea:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8023ed:	e8 84 fc ff ff       	call   802076 <InitializeUHeap>
	if (size == 0) return NULL ;
  8023f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023f6:	75 07                	jne    8023ff <smalloc+0x1e>
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fd:	eb 7e                	jmp    80247d <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  8023ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  802406:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80240d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802413:	01 d0                	add    %edx,%eax
  802415:	48                   	dec    %eax
  802416:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802419:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241c:	ba 00 00 00 00       	mov    $0x0,%edx
  802421:	f7 75 f0             	divl   -0x10(%ebp)
  802424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802427:	29 d0                	sub    %edx,%eax
  802429:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80242c:	e8 c4 06 00 00       	call   802af5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802431:	83 f8 01             	cmp    $0x1,%eax
  802434:	75 42                	jne    802478 <smalloc+0x97>

		  va = malloc(newsize) ;
  802436:	83 ec 0c             	sub    $0xc,%esp
  802439:	ff 75 e8             	pushl  -0x18(%ebp)
  80243c:	e8 24 fe ff ff       	call   802265 <malloc>
  802441:	83 c4 10             	add    $0x10,%esp
  802444:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  802447:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80244b:	74 24                	je     802471 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  80244d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802451:	ff 75 e4             	pushl  -0x1c(%ebp)
  802454:	50                   	push   %eax
  802455:	ff 75 e8             	pushl  -0x18(%ebp)
  802458:	ff 75 08             	pushl  0x8(%ebp)
  80245b:	e8 1a 04 00 00       	call   80287a <sys_createSharedObject>
  802460:	83 c4 10             	add    $0x10,%esp
  802463:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  802466:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80246a:	78 0c                	js     802478 <smalloc+0x97>
					  return va ;
  80246c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246f:	eb 0c                	jmp    80247d <smalloc+0x9c>
				 }
				 else
					return NULL;
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
  802476:	eb 05                	jmp    80247d <smalloc+0x9c>
	  }
		  return NULL ;
  802478:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80247d:	c9                   	leave  
  80247e:	c3                   	ret    

0080247f <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80247f:	55                   	push   %ebp
  802480:	89 e5                	mov    %esp,%ebp
  802482:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802485:	e8 ec fb ff ff       	call   802076 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  80248a:	83 ec 08             	sub    $0x8,%esp
  80248d:	ff 75 0c             	pushl  0xc(%ebp)
  802490:	ff 75 08             	pushl  0x8(%ebp)
  802493:	e8 0c 04 00 00       	call   8028a4 <sys_getSizeOfSharedObject>
  802498:	83 c4 10             	add    $0x10,%esp
  80249b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  80249e:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8024a2:	75 07                	jne    8024ab <sget+0x2c>
  8024a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a9:	eb 75                	jmp    802520 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8024ab:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8024b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b8:	01 d0                	add    %edx,%eax
  8024ba:	48                   	dec    %eax
  8024bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8024be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8024c6:	f7 75 f0             	divl   -0x10(%ebp)
  8024c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cc:	29 d0                	sub    %edx,%eax
  8024ce:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  8024d1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8024d8:	e8 18 06 00 00       	call   802af5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8024dd:	83 f8 01             	cmp    $0x1,%eax
  8024e0:	75 39                	jne    80251b <sget+0x9c>

		  va = malloc(newsize) ;
  8024e2:	83 ec 0c             	sub    $0xc,%esp
  8024e5:	ff 75 e8             	pushl  -0x18(%ebp)
  8024e8:	e8 78 fd ff ff       	call   802265 <malloc>
  8024ed:	83 c4 10             	add    $0x10,%esp
  8024f0:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  8024f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8024f7:	74 22                	je     80251b <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  8024f9:	83 ec 04             	sub    $0x4,%esp
  8024fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8024ff:	ff 75 0c             	pushl  0xc(%ebp)
  802502:	ff 75 08             	pushl  0x8(%ebp)
  802505:	e8 b7 03 00 00       	call   8028c1 <sys_getSharedObject>
  80250a:	83 c4 10             	add    $0x10,%esp
  80250d:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  802510:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802514:	78 05                	js     80251b <sget+0x9c>
					  return va;
  802516:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802519:	eb 05                	jmp    802520 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  80251b:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  802520:	c9                   	leave  
  802521:	c3                   	ret    

00802522 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
  802525:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802528:	e8 49 fb ff ff       	call   802076 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80252d:	83 ec 04             	sub    $0x4,%esp
  802530:	68 a4 48 80 00       	push   $0x8048a4
  802535:	68 1e 01 00 00       	push   $0x11e
  80253a:	68 73 48 80 00       	push   $0x804873
  80253f:	e8 f4 ea ff ff       	call   801038 <_panic>

00802544 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80254a:	83 ec 04             	sub    $0x4,%esp
  80254d:	68 cc 48 80 00       	push   $0x8048cc
  802552:	68 32 01 00 00       	push   $0x132
  802557:	68 73 48 80 00       	push   $0x804873
  80255c:	e8 d7 ea ff ff       	call   801038 <_panic>

00802561 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
  802564:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802567:	83 ec 04             	sub    $0x4,%esp
  80256a:	68 f0 48 80 00       	push   $0x8048f0
  80256f:	68 3d 01 00 00       	push   $0x13d
  802574:	68 73 48 80 00       	push   $0x804873
  802579:	e8 ba ea ff ff       	call   801038 <_panic>

0080257e <shrink>:

}
void shrink(uint32 newSize)
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
  802581:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802584:	83 ec 04             	sub    $0x4,%esp
  802587:	68 f0 48 80 00       	push   $0x8048f0
  80258c:	68 42 01 00 00       	push   $0x142
  802591:	68 73 48 80 00       	push   $0x804873
  802596:	e8 9d ea ff ff       	call   801038 <_panic>

0080259b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
  80259e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8025a1:	83 ec 04             	sub    $0x4,%esp
  8025a4:	68 f0 48 80 00       	push   $0x8048f0
  8025a9:	68 47 01 00 00       	push   $0x147
  8025ae:	68 73 48 80 00       	push   $0x804873
  8025b3:	e8 80 ea ff ff       	call   801038 <_panic>

008025b8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
  8025bb:	57                   	push   %edi
  8025bc:	56                   	push   %esi
  8025bd:	53                   	push   %ebx
  8025be:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025cd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8025d0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8025d3:	cd 30                	int    $0x30
  8025d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8025d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8025db:	83 c4 10             	add    $0x10,%esp
  8025de:	5b                   	pop    %ebx
  8025df:	5e                   	pop    %esi
  8025e0:	5f                   	pop    %edi
  8025e1:	5d                   	pop    %ebp
  8025e2:	c3                   	ret    

008025e3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
  8025e6:	83 ec 04             	sub    $0x4,%esp
  8025e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8025ec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8025ef:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8025f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	52                   	push   %edx
  8025fb:	ff 75 0c             	pushl  0xc(%ebp)
  8025fe:	50                   	push   %eax
  8025ff:	6a 00                	push   $0x0
  802601:	e8 b2 ff ff ff       	call   8025b8 <syscall>
  802606:	83 c4 18             	add    $0x18,%esp
}
  802609:	90                   	nop
  80260a:	c9                   	leave  
  80260b:	c3                   	ret    

0080260c <sys_cgetc>:

int
sys_cgetc(void)
{
  80260c:	55                   	push   %ebp
  80260d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	6a 00                	push   $0x0
  802617:	6a 00                	push   $0x0
  802619:	6a 01                	push   $0x1
  80261b:	e8 98 ff ff ff       	call   8025b8 <syscall>
  802620:	83 c4 18             	add    $0x18,%esp
}
  802623:	c9                   	leave  
  802624:	c3                   	ret    

00802625 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802625:	55                   	push   %ebp
  802626:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80262b:	8b 45 08             	mov    0x8(%ebp),%eax
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	52                   	push   %edx
  802635:	50                   	push   %eax
  802636:	6a 05                	push   $0x5
  802638:	e8 7b ff ff ff       	call   8025b8 <syscall>
  80263d:	83 c4 18             	add    $0x18,%esp
}
  802640:	c9                   	leave  
  802641:	c3                   	ret    

00802642 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
  802645:	56                   	push   %esi
  802646:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802647:	8b 75 18             	mov    0x18(%ebp),%esi
  80264a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80264d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802650:	8b 55 0c             	mov    0xc(%ebp),%edx
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	56                   	push   %esi
  802657:	53                   	push   %ebx
  802658:	51                   	push   %ecx
  802659:	52                   	push   %edx
  80265a:	50                   	push   %eax
  80265b:	6a 06                	push   $0x6
  80265d:	e8 56 ff ff ff       	call   8025b8 <syscall>
  802662:	83 c4 18             	add    $0x18,%esp
}
  802665:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802668:	5b                   	pop    %ebx
  802669:	5e                   	pop    %esi
  80266a:	5d                   	pop    %ebp
  80266b:	c3                   	ret    

0080266c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80266f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	52                   	push   %edx
  80267c:	50                   	push   %eax
  80267d:	6a 07                	push   $0x7
  80267f:	e8 34 ff ff ff       	call   8025b8 <syscall>
  802684:	83 c4 18             	add    $0x18,%esp
}
  802687:	c9                   	leave  
  802688:	c3                   	ret    

00802689 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	ff 75 0c             	pushl  0xc(%ebp)
  802695:	ff 75 08             	pushl  0x8(%ebp)
  802698:	6a 08                	push   $0x8
  80269a:	e8 19 ff ff ff       	call   8025b8 <syscall>
  80269f:	83 c4 18             	add    $0x18,%esp
}
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 09                	push   $0x9
  8026b3:	e8 00 ff ff ff       	call   8025b8 <syscall>
  8026b8:	83 c4 18             	add    $0x18,%esp
}
  8026bb:	c9                   	leave  
  8026bc:	c3                   	ret    

008026bd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8026bd:	55                   	push   %ebp
  8026be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 00                	push   $0x0
  8026c6:	6a 00                	push   $0x0
  8026c8:	6a 00                	push   $0x0
  8026ca:	6a 0a                	push   $0xa
  8026cc:	e8 e7 fe ff ff       	call   8025b8 <syscall>
  8026d1:	83 c4 18             	add    $0x18,%esp
}
  8026d4:	c9                   	leave  
  8026d5:	c3                   	ret    

008026d6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8026d6:	55                   	push   %ebp
  8026d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	6a 0b                	push   $0xb
  8026e5:	e8 ce fe ff ff       	call   8025b8 <syscall>
  8026ea:	83 c4 18             	add    $0x18,%esp
}
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    

008026ef <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	ff 75 0c             	pushl  0xc(%ebp)
  8026fb:	ff 75 08             	pushl  0x8(%ebp)
  8026fe:	6a 0f                	push   $0xf
  802700:	e8 b3 fe ff ff       	call   8025b8 <syscall>
  802705:	83 c4 18             	add    $0x18,%esp
	return;
  802708:	90                   	nop
}
  802709:	c9                   	leave  
  80270a:	c3                   	ret    

0080270b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80270b:	55                   	push   %ebp
  80270c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	ff 75 0c             	pushl  0xc(%ebp)
  802717:	ff 75 08             	pushl  0x8(%ebp)
  80271a:	6a 10                	push   $0x10
  80271c:	e8 97 fe ff ff       	call   8025b8 <syscall>
  802721:	83 c4 18             	add    $0x18,%esp
	return ;
  802724:	90                   	nop
}
  802725:	c9                   	leave  
  802726:	c3                   	ret    

00802727 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802727:	55                   	push   %ebp
  802728:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	ff 75 10             	pushl  0x10(%ebp)
  802731:	ff 75 0c             	pushl  0xc(%ebp)
  802734:	ff 75 08             	pushl  0x8(%ebp)
  802737:	6a 11                	push   $0x11
  802739:	e8 7a fe ff ff       	call   8025b8 <syscall>
  80273e:	83 c4 18             	add    $0x18,%esp
	return ;
  802741:	90                   	nop
}
  802742:	c9                   	leave  
  802743:	c3                   	ret    

00802744 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802744:	55                   	push   %ebp
  802745:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802747:	6a 00                	push   $0x0
  802749:	6a 00                	push   $0x0
  80274b:	6a 00                	push   $0x0
  80274d:	6a 00                	push   $0x0
  80274f:	6a 00                	push   $0x0
  802751:	6a 0c                	push   $0xc
  802753:	e8 60 fe ff ff       	call   8025b8 <syscall>
  802758:	83 c4 18             	add    $0x18,%esp
}
  80275b:	c9                   	leave  
  80275c:	c3                   	ret    

0080275d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80275d:	55                   	push   %ebp
  80275e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802760:	6a 00                	push   $0x0
  802762:	6a 00                	push   $0x0
  802764:	6a 00                	push   $0x0
  802766:	6a 00                	push   $0x0
  802768:	ff 75 08             	pushl  0x8(%ebp)
  80276b:	6a 0d                	push   $0xd
  80276d:	e8 46 fe ff ff       	call   8025b8 <syscall>
  802772:	83 c4 18             	add    $0x18,%esp
}
  802775:	c9                   	leave  
  802776:	c3                   	ret    

00802777 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802777:	55                   	push   %ebp
  802778:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80277a:	6a 00                	push   $0x0
  80277c:	6a 00                	push   $0x0
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 0e                	push   $0xe
  802786:	e8 2d fe ff ff       	call   8025b8 <syscall>
  80278b:	83 c4 18             	add    $0x18,%esp
}
  80278e:	90                   	nop
  80278f:	c9                   	leave  
  802790:	c3                   	ret    

00802791 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802791:	55                   	push   %ebp
  802792:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802794:	6a 00                	push   $0x0
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	6a 00                	push   $0x0
  80279c:	6a 00                	push   $0x0
  80279e:	6a 13                	push   $0x13
  8027a0:	e8 13 fe ff ff       	call   8025b8 <syscall>
  8027a5:	83 c4 18             	add    $0x18,%esp
}
  8027a8:	90                   	nop
  8027a9:	c9                   	leave  
  8027aa:	c3                   	ret    

008027ab <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8027ab:	55                   	push   %ebp
  8027ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8027ae:	6a 00                	push   $0x0
  8027b0:	6a 00                	push   $0x0
  8027b2:	6a 00                	push   $0x0
  8027b4:	6a 00                	push   $0x0
  8027b6:	6a 00                	push   $0x0
  8027b8:	6a 14                	push   $0x14
  8027ba:	e8 f9 fd ff ff       	call   8025b8 <syscall>
  8027bf:	83 c4 18             	add    $0x18,%esp
}
  8027c2:	90                   	nop
  8027c3:	c9                   	leave  
  8027c4:	c3                   	ret    

008027c5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
  8027c8:	83 ec 04             	sub    $0x4,%esp
  8027cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8027d1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 00                	push   $0x0
  8027dd:	50                   	push   %eax
  8027de:	6a 15                	push   $0x15
  8027e0:	e8 d3 fd ff ff       	call   8025b8 <syscall>
  8027e5:	83 c4 18             	add    $0x18,%esp
}
  8027e8:	90                   	nop
  8027e9:	c9                   	leave  
  8027ea:	c3                   	ret    

008027eb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8027eb:	55                   	push   %ebp
  8027ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8027ee:	6a 00                	push   $0x0
  8027f0:	6a 00                	push   $0x0
  8027f2:	6a 00                	push   $0x0
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	6a 16                	push   $0x16
  8027fa:	e8 b9 fd ff ff       	call   8025b8 <syscall>
  8027ff:	83 c4 18             	add    $0x18,%esp
}
  802802:	90                   	nop
  802803:	c9                   	leave  
  802804:	c3                   	ret    

00802805 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802805:	55                   	push   %ebp
  802806:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	6a 00                	push   $0x0
  802811:	ff 75 0c             	pushl  0xc(%ebp)
  802814:	50                   	push   %eax
  802815:	6a 17                	push   $0x17
  802817:	e8 9c fd ff ff       	call   8025b8 <syscall>
  80281c:	83 c4 18             	add    $0x18,%esp
}
  80281f:	c9                   	leave  
  802820:	c3                   	ret    

00802821 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802821:	55                   	push   %ebp
  802822:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802824:	8b 55 0c             	mov    0xc(%ebp),%edx
  802827:	8b 45 08             	mov    0x8(%ebp),%eax
  80282a:	6a 00                	push   $0x0
  80282c:	6a 00                	push   $0x0
  80282e:	6a 00                	push   $0x0
  802830:	52                   	push   %edx
  802831:	50                   	push   %eax
  802832:	6a 1a                	push   $0x1a
  802834:	e8 7f fd ff ff       	call   8025b8 <syscall>
  802839:	83 c4 18             	add    $0x18,%esp
}
  80283c:	c9                   	leave  
  80283d:	c3                   	ret    

0080283e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80283e:	55                   	push   %ebp
  80283f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802841:	8b 55 0c             	mov    0xc(%ebp),%edx
  802844:	8b 45 08             	mov    0x8(%ebp),%eax
  802847:	6a 00                	push   $0x0
  802849:	6a 00                	push   $0x0
  80284b:	6a 00                	push   $0x0
  80284d:	52                   	push   %edx
  80284e:	50                   	push   %eax
  80284f:	6a 18                	push   $0x18
  802851:	e8 62 fd ff ff       	call   8025b8 <syscall>
  802856:	83 c4 18             	add    $0x18,%esp
}
  802859:	90                   	nop
  80285a:	c9                   	leave  
  80285b:	c3                   	ret    

0080285c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80285c:	55                   	push   %ebp
  80285d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80285f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	6a 00                	push   $0x0
  802867:	6a 00                	push   $0x0
  802869:	6a 00                	push   $0x0
  80286b:	52                   	push   %edx
  80286c:	50                   	push   %eax
  80286d:	6a 19                	push   $0x19
  80286f:	e8 44 fd ff ff       	call   8025b8 <syscall>
  802874:	83 c4 18             	add    $0x18,%esp
}
  802877:	90                   	nop
  802878:	c9                   	leave  
  802879:	c3                   	ret    

0080287a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80287a:	55                   	push   %ebp
  80287b:	89 e5                	mov    %esp,%ebp
  80287d:	83 ec 04             	sub    $0x4,%esp
  802880:	8b 45 10             	mov    0x10(%ebp),%eax
  802883:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802886:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802889:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80288d:	8b 45 08             	mov    0x8(%ebp),%eax
  802890:	6a 00                	push   $0x0
  802892:	51                   	push   %ecx
  802893:	52                   	push   %edx
  802894:	ff 75 0c             	pushl  0xc(%ebp)
  802897:	50                   	push   %eax
  802898:	6a 1b                	push   $0x1b
  80289a:	e8 19 fd ff ff       	call   8025b8 <syscall>
  80289f:	83 c4 18             	add    $0x18,%esp
}
  8028a2:	c9                   	leave  
  8028a3:	c3                   	ret    

008028a4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8028a4:	55                   	push   %ebp
  8028a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8028a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ad:	6a 00                	push   $0x0
  8028af:	6a 00                	push   $0x0
  8028b1:	6a 00                	push   $0x0
  8028b3:	52                   	push   %edx
  8028b4:	50                   	push   %eax
  8028b5:	6a 1c                	push   $0x1c
  8028b7:	e8 fc fc ff ff       	call   8025b8 <syscall>
  8028bc:	83 c4 18             	add    $0x18,%esp
}
  8028bf:	c9                   	leave  
  8028c0:	c3                   	ret    

008028c1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8028c1:	55                   	push   %ebp
  8028c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8028c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	6a 00                	push   $0x0
  8028cf:	6a 00                	push   $0x0
  8028d1:	51                   	push   %ecx
  8028d2:	52                   	push   %edx
  8028d3:	50                   	push   %eax
  8028d4:	6a 1d                	push   $0x1d
  8028d6:	e8 dd fc ff ff       	call   8025b8 <syscall>
  8028db:	83 c4 18             	add    $0x18,%esp
}
  8028de:	c9                   	leave  
  8028df:	c3                   	ret    

008028e0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8028e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e9:	6a 00                	push   $0x0
  8028eb:	6a 00                	push   $0x0
  8028ed:	6a 00                	push   $0x0
  8028ef:	52                   	push   %edx
  8028f0:	50                   	push   %eax
  8028f1:	6a 1e                	push   $0x1e
  8028f3:	e8 c0 fc ff ff       	call   8025b8 <syscall>
  8028f8:	83 c4 18             	add    $0x18,%esp
}
  8028fb:	c9                   	leave  
  8028fc:	c3                   	ret    

008028fd <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8028fd:	55                   	push   %ebp
  8028fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802900:	6a 00                	push   $0x0
  802902:	6a 00                	push   $0x0
  802904:	6a 00                	push   $0x0
  802906:	6a 00                	push   $0x0
  802908:	6a 00                	push   $0x0
  80290a:	6a 1f                	push   $0x1f
  80290c:	e8 a7 fc ff ff       	call   8025b8 <syscall>
  802911:	83 c4 18             	add    $0x18,%esp
}
  802914:	c9                   	leave  
  802915:	c3                   	ret    

00802916 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	6a 00                	push   $0x0
  80291e:	ff 75 14             	pushl  0x14(%ebp)
  802921:	ff 75 10             	pushl  0x10(%ebp)
  802924:	ff 75 0c             	pushl  0xc(%ebp)
  802927:	50                   	push   %eax
  802928:	6a 20                	push   $0x20
  80292a:	e8 89 fc ff ff       	call   8025b8 <syscall>
  80292f:	83 c4 18             	add    $0x18,%esp
}
  802932:	c9                   	leave  
  802933:	c3                   	ret    

00802934 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802934:	55                   	push   %ebp
  802935:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	6a 00                	push   $0x0
  80293c:	6a 00                	push   $0x0
  80293e:	6a 00                	push   $0x0
  802940:	6a 00                	push   $0x0
  802942:	50                   	push   %eax
  802943:	6a 21                	push   $0x21
  802945:	e8 6e fc ff ff       	call   8025b8 <syscall>
  80294a:	83 c4 18             	add    $0x18,%esp
}
  80294d:	90                   	nop
  80294e:	c9                   	leave  
  80294f:	c3                   	ret    

00802950 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802950:	55                   	push   %ebp
  802951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802953:	8b 45 08             	mov    0x8(%ebp),%eax
  802956:	6a 00                	push   $0x0
  802958:	6a 00                	push   $0x0
  80295a:	6a 00                	push   $0x0
  80295c:	6a 00                	push   $0x0
  80295e:	50                   	push   %eax
  80295f:	6a 22                	push   $0x22
  802961:	e8 52 fc ff ff       	call   8025b8 <syscall>
  802966:	83 c4 18             	add    $0x18,%esp
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    

0080296b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80296b:	55                   	push   %ebp
  80296c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80296e:	6a 00                	push   $0x0
  802970:	6a 00                	push   $0x0
  802972:	6a 00                	push   $0x0
  802974:	6a 00                	push   $0x0
  802976:	6a 00                	push   $0x0
  802978:	6a 02                	push   $0x2
  80297a:	e8 39 fc ff ff       	call   8025b8 <syscall>
  80297f:	83 c4 18             	add    $0x18,%esp
}
  802982:	c9                   	leave  
  802983:	c3                   	ret    

00802984 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802984:	55                   	push   %ebp
  802985:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802987:	6a 00                	push   $0x0
  802989:	6a 00                	push   $0x0
  80298b:	6a 00                	push   $0x0
  80298d:	6a 00                	push   $0x0
  80298f:	6a 00                	push   $0x0
  802991:	6a 03                	push   $0x3
  802993:	e8 20 fc ff ff       	call   8025b8 <syscall>
  802998:	83 c4 18             	add    $0x18,%esp
}
  80299b:	c9                   	leave  
  80299c:	c3                   	ret    

0080299d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80299d:	55                   	push   %ebp
  80299e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8029a0:	6a 00                	push   $0x0
  8029a2:	6a 00                	push   $0x0
  8029a4:	6a 00                	push   $0x0
  8029a6:	6a 00                	push   $0x0
  8029a8:	6a 00                	push   $0x0
  8029aa:	6a 04                	push   $0x4
  8029ac:	e8 07 fc ff ff       	call   8025b8 <syscall>
  8029b1:	83 c4 18             	add    $0x18,%esp
}
  8029b4:	c9                   	leave  
  8029b5:	c3                   	ret    

008029b6 <sys_exit_env>:


void sys_exit_env(void)
{
  8029b6:	55                   	push   %ebp
  8029b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 00                	push   $0x0
  8029bd:	6a 00                	push   $0x0
  8029bf:	6a 00                	push   $0x0
  8029c1:	6a 00                	push   $0x0
  8029c3:	6a 23                	push   $0x23
  8029c5:	e8 ee fb ff ff       	call   8025b8 <syscall>
  8029ca:	83 c4 18             	add    $0x18,%esp
}
  8029cd:	90                   	nop
  8029ce:	c9                   	leave  
  8029cf:	c3                   	ret    

008029d0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8029d0:	55                   	push   %ebp
  8029d1:	89 e5                	mov    %esp,%ebp
  8029d3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8029d6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8029d9:	8d 50 04             	lea    0x4(%eax),%edx
  8029dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8029df:	6a 00                	push   $0x0
  8029e1:	6a 00                	push   $0x0
  8029e3:	6a 00                	push   $0x0
  8029e5:	52                   	push   %edx
  8029e6:	50                   	push   %eax
  8029e7:	6a 24                	push   $0x24
  8029e9:	e8 ca fb ff ff       	call   8025b8 <syscall>
  8029ee:	83 c4 18             	add    $0x18,%esp
	return result;
  8029f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8029f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8029fa:	89 01                	mov    %eax,(%ecx)
  8029fc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8029ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802a02:	c9                   	leave  
  802a03:	c2 04 00             	ret    $0x4

00802a06 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802a06:	55                   	push   %ebp
  802a07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802a09:	6a 00                	push   $0x0
  802a0b:	6a 00                	push   $0x0
  802a0d:	ff 75 10             	pushl  0x10(%ebp)
  802a10:	ff 75 0c             	pushl  0xc(%ebp)
  802a13:	ff 75 08             	pushl  0x8(%ebp)
  802a16:	6a 12                	push   $0x12
  802a18:	e8 9b fb ff ff       	call   8025b8 <syscall>
  802a1d:	83 c4 18             	add    $0x18,%esp
	return ;
  802a20:	90                   	nop
}
  802a21:	c9                   	leave  
  802a22:	c3                   	ret    

00802a23 <sys_rcr2>:
uint32 sys_rcr2()
{
  802a23:	55                   	push   %ebp
  802a24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802a26:	6a 00                	push   $0x0
  802a28:	6a 00                	push   $0x0
  802a2a:	6a 00                	push   $0x0
  802a2c:	6a 00                	push   $0x0
  802a2e:	6a 00                	push   $0x0
  802a30:	6a 25                	push   $0x25
  802a32:	e8 81 fb ff ff       	call   8025b8 <syscall>
  802a37:	83 c4 18             	add    $0x18,%esp
}
  802a3a:	c9                   	leave  
  802a3b:	c3                   	ret    

00802a3c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802a3c:	55                   	push   %ebp
  802a3d:	89 e5                	mov    %esp,%ebp
  802a3f:	83 ec 04             	sub    $0x4,%esp
  802a42:	8b 45 08             	mov    0x8(%ebp),%eax
  802a45:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802a48:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802a4c:	6a 00                	push   $0x0
  802a4e:	6a 00                	push   $0x0
  802a50:	6a 00                	push   $0x0
  802a52:	6a 00                	push   $0x0
  802a54:	50                   	push   %eax
  802a55:	6a 26                	push   $0x26
  802a57:	e8 5c fb ff ff       	call   8025b8 <syscall>
  802a5c:	83 c4 18             	add    $0x18,%esp
	return ;
  802a5f:	90                   	nop
}
  802a60:	c9                   	leave  
  802a61:	c3                   	ret    

00802a62 <rsttst>:
void rsttst()
{
  802a62:	55                   	push   %ebp
  802a63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802a65:	6a 00                	push   $0x0
  802a67:	6a 00                	push   $0x0
  802a69:	6a 00                	push   $0x0
  802a6b:	6a 00                	push   $0x0
  802a6d:	6a 00                	push   $0x0
  802a6f:	6a 28                	push   $0x28
  802a71:	e8 42 fb ff ff       	call   8025b8 <syscall>
  802a76:	83 c4 18             	add    $0x18,%esp
	return ;
  802a79:	90                   	nop
}
  802a7a:	c9                   	leave  
  802a7b:	c3                   	ret    

00802a7c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802a7c:	55                   	push   %ebp
  802a7d:	89 e5                	mov    %esp,%ebp
  802a7f:	83 ec 04             	sub    $0x4,%esp
  802a82:	8b 45 14             	mov    0x14(%ebp),%eax
  802a85:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802a88:	8b 55 18             	mov    0x18(%ebp),%edx
  802a8b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802a8f:	52                   	push   %edx
  802a90:	50                   	push   %eax
  802a91:	ff 75 10             	pushl  0x10(%ebp)
  802a94:	ff 75 0c             	pushl  0xc(%ebp)
  802a97:	ff 75 08             	pushl  0x8(%ebp)
  802a9a:	6a 27                	push   $0x27
  802a9c:	e8 17 fb ff ff       	call   8025b8 <syscall>
  802aa1:	83 c4 18             	add    $0x18,%esp
	return ;
  802aa4:	90                   	nop
}
  802aa5:	c9                   	leave  
  802aa6:	c3                   	ret    

00802aa7 <chktst>:
void chktst(uint32 n)
{
  802aa7:	55                   	push   %ebp
  802aa8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802aaa:	6a 00                	push   $0x0
  802aac:	6a 00                	push   $0x0
  802aae:	6a 00                	push   $0x0
  802ab0:	6a 00                	push   $0x0
  802ab2:	ff 75 08             	pushl  0x8(%ebp)
  802ab5:	6a 29                	push   $0x29
  802ab7:	e8 fc fa ff ff       	call   8025b8 <syscall>
  802abc:	83 c4 18             	add    $0x18,%esp
	return ;
  802abf:	90                   	nop
}
  802ac0:	c9                   	leave  
  802ac1:	c3                   	ret    

00802ac2 <inctst>:

void inctst()
{
  802ac2:	55                   	push   %ebp
  802ac3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802ac5:	6a 00                	push   $0x0
  802ac7:	6a 00                	push   $0x0
  802ac9:	6a 00                	push   $0x0
  802acb:	6a 00                	push   $0x0
  802acd:	6a 00                	push   $0x0
  802acf:	6a 2a                	push   $0x2a
  802ad1:	e8 e2 fa ff ff       	call   8025b8 <syscall>
  802ad6:	83 c4 18             	add    $0x18,%esp
	return ;
  802ad9:	90                   	nop
}
  802ada:	c9                   	leave  
  802adb:	c3                   	ret    

00802adc <gettst>:
uint32 gettst()
{
  802adc:	55                   	push   %ebp
  802add:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802adf:	6a 00                	push   $0x0
  802ae1:	6a 00                	push   $0x0
  802ae3:	6a 00                	push   $0x0
  802ae5:	6a 00                	push   $0x0
  802ae7:	6a 00                	push   $0x0
  802ae9:	6a 2b                	push   $0x2b
  802aeb:	e8 c8 fa ff ff       	call   8025b8 <syscall>
  802af0:	83 c4 18             	add    $0x18,%esp
}
  802af3:	c9                   	leave  
  802af4:	c3                   	ret    

00802af5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802af5:	55                   	push   %ebp
  802af6:	89 e5                	mov    %esp,%ebp
  802af8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802afb:	6a 00                	push   $0x0
  802afd:	6a 00                	push   $0x0
  802aff:	6a 00                	push   $0x0
  802b01:	6a 00                	push   $0x0
  802b03:	6a 00                	push   $0x0
  802b05:	6a 2c                	push   $0x2c
  802b07:	e8 ac fa ff ff       	call   8025b8 <syscall>
  802b0c:	83 c4 18             	add    $0x18,%esp
  802b0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802b12:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802b16:	75 07                	jne    802b1f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802b18:	b8 01 00 00 00       	mov    $0x1,%eax
  802b1d:	eb 05                	jmp    802b24 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802b1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b24:	c9                   	leave  
  802b25:	c3                   	ret    

00802b26 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802b26:	55                   	push   %ebp
  802b27:	89 e5                	mov    %esp,%ebp
  802b29:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b2c:	6a 00                	push   $0x0
  802b2e:	6a 00                	push   $0x0
  802b30:	6a 00                	push   $0x0
  802b32:	6a 00                	push   $0x0
  802b34:	6a 00                	push   $0x0
  802b36:	6a 2c                	push   $0x2c
  802b38:	e8 7b fa ff ff       	call   8025b8 <syscall>
  802b3d:	83 c4 18             	add    $0x18,%esp
  802b40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802b43:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802b47:	75 07                	jne    802b50 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802b49:	b8 01 00 00 00       	mov    $0x1,%eax
  802b4e:	eb 05                	jmp    802b55 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802b50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b55:	c9                   	leave  
  802b56:	c3                   	ret    

00802b57 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802b57:	55                   	push   %ebp
  802b58:	89 e5                	mov    %esp,%ebp
  802b5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b5d:	6a 00                	push   $0x0
  802b5f:	6a 00                	push   $0x0
  802b61:	6a 00                	push   $0x0
  802b63:	6a 00                	push   $0x0
  802b65:	6a 00                	push   $0x0
  802b67:	6a 2c                	push   $0x2c
  802b69:	e8 4a fa ff ff       	call   8025b8 <syscall>
  802b6e:	83 c4 18             	add    $0x18,%esp
  802b71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802b74:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802b78:	75 07                	jne    802b81 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802b7a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b7f:	eb 05                	jmp    802b86 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802b81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b86:	c9                   	leave  
  802b87:	c3                   	ret    

00802b88 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802b88:	55                   	push   %ebp
  802b89:	89 e5                	mov    %esp,%ebp
  802b8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b8e:	6a 00                	push   $0x0
  802b90:	6a 00                	push   $0x0
  802b92:	6a 00                	push   $0x0
  802b94:	6a 00                	push   $0x0
  802b96:	6a 00                	push   $0x0
  802b98:	6a 2c                	push   $0x2c
  802b9a:	e8 19 fa ff ff       	call   8025b8 <syscall>
  802b9f:	83 c4 18             	add    $0x18,%esp
  802ba2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802ba5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802ba9:	75 07                	jne    802bb2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802bab:	b8 01 00 00 00       	mov    $0x1,%eax
  802bb0:	eb 05                	jmp    802bb7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802bb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb7:	c9                   	leave  
  802bb8:	c3                   	ret    

00802bb9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802bb9:	55                   	push   %ebp
  802bba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802bbc:	6a 00                	push   $0x0
  802bbe:	6a 00                	push   $0x0
  802bc0:	6a 00                	push   $0x0
  802bc2:	6a 00                	push   $0x0
  802bc4:	ff 75 08             	pushl  0x8(%ebp)
  802bc7:	6a 2d                	push   $0x2d
  802bc9:	e8 ea f9 ff ff       	call   8025b8 <syscall>
  802bce:	83 c4 18             	add    $0x18,%esp
	return ;
  802bd1:	90                   	nop
}
  802bd2:	c9                   	leave  
  802bd3:	c3                   	ret    

00802bd4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802bd4:	55                   	push   %ebp
  802bd5:	89 e5                	mov    %esp,%ebp
  802bd7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802bd8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802bdb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802bde:	8b 55 0c             	mov    0xc(%ebp),%edx
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	6a 00                	push   $0x0
  802be6:	53                   	push   %ebx
  802be7:	51                   	push   %ecx
  802be8:	52                   	push   %edx
  802be9:	50                   	push   %eax
  802bea:	6a 2e                	push   $0x2e
  802bec:	e8 c7 f9 ff ff       	call   8025b8 <syscall>
  802bf1:	83 c4 18             	add    $0x18,%esp
}
  802bf4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802bf7:	c9                   	leave  
  802bf8:	c3                   	ret    

00802bf9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802bf9:	55                   	push   %ebp
  802bfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802bfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	6a 00                	push   $0x0
  802c04:	6a 00                	push   $0x0
  802c06:	6a 00                	push   $0x0
  802c08:	52                   	push   %edx
  802c09:	50                   	push   %eax
  802c0a:	6a 2f                	push   $0x2f
  802c0c:	e8 a7 f9 ff ff       	call   8025b8 <syscall>
  802c11:	83 c4 18             	add    $0x18,%esp
}
  802c14:	c9                   	leave  
  802c15:	c3                   	ret    

00802c16 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802c16:	55                   	push   %ebp
  802c17:	89 e5                	mov    %esp,%ebp
  802c19:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802c1c:	83 ec 0c             	sub    $0xc,%esp
  802c1f:	68 00 49 80 00       	push   $0x804900
  802c24:	e8 c3 e6 ff ff       	call   8012ec <cprintf>
  802c29:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802c2c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802c33:	83 ec 0c             	sub    $0xc,%esp
  802c36:	68 2c 49 80 00       	push   $0x80492c
  802c3b:	e8 ac e6 ff ff       	call   8012ec <cprintf>
  802c40:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802c43:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802c47:	a1 38 51 80 00       	mov    0x805138,%eax
  802c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c4f:	eb 56                	jmp    802ca7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802c51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c55:	74 1c                	je     802c73 <print_mem_block_lists+0x5d>
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 50 08             	mov    0x8(%eax),%edx
  802c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c60:	8b 48 08             	mov    0x8(%eax),%ecx
  802c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c66:	8b 40 0c             	mov    0xc(%eax),%eax
  802c69:	01 c8                	add    %ecx,%eax
  802c6b:	39 c2                	cmp    %eax,%edx
  802c6d:	73 04                	jae    802c73 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802c6f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 50 08             	mov    0x8(%eax),%edx
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7f:	01 c2                	add    %eax,%edx
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 08             	mov    0x8(%eax),%eax
  802c87:	83 ec 04             	sub    $0x4,%esp
  802c8a:	52                   	push   %edx
  802c8b:	50                   	push   %eax
  802c8c:	68 41 49 80 00       	push   $0x804941
  802c91:	e8 56 e6 ff ff       	call   8012ec <cprintf>
  802c96:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802c9f:	a1 40 51 80 00       	mov    0x805140,%eax
  802ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cab:	74 07                	je     802cb4 <print_mem_block_lists+0x9e>
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 00                	mov    (%eax),%eax
  802cb2:	eb 05                	jmp    802cb9 <print_mem_block_lists+0xa3>
  802cb4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb9:	a3 40 51 80 00       	mov    %eax,0x805140
  802cbe:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc3:	85 c0                	test   %eax,%eax
  802cc5:	75 8a                	jne    802c51 <print_mem_block_lists+0x3b>
  802cc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccb:	75 84                	jne    802c51 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802ccd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802cd1:	75 10                	jne    802ce3 <print_mem_block_lists+0xcd>
  802cd3:	83 ec 0c             	sub    $0xc,%esp
  802cd6:	68 50 49 80 00       	push   $0x804950
  802cdb:	e8 0c e6 ff ff       	call   8012ec <cprintf>
  802ce0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802ce3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802cea:	83 ec 0c             	sub    $0xc,%esp
  802ced:	68 74 49 80 00       	push   $0x804974
  802cf2:	e8 f5 e5 ff ff       	call   8012ec <cprintf>
  802cf7:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802cfa:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802cfe:	a1 40 50 80 00       	mov    0x805040,%eax
  802d03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d06:	eb 56                	jmp    802d5e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802d08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0c:	74 1c                	je     802d2a <print_mem_block_lists+0x114>
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	8b 50 08             	mov    0x8(%eax),%edx
  802d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d17:	8b 48 08             	mov    0x8(%eax),%ecx
  802d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d20:	01 c8                	add    %ecx,%eax
  802d22:	39 c2                	cmp    %eax,%edx
  802d24:	73 04                	jae    802d2a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802d26:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 50 08             	mov    0x8(%eax),%edx
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	8b 40 0c             	mov    0xc(%eax),%eax
  802d36:	01 c2                	add    %eax,%edx
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 40 08             	mov    0x8(%eax),%eax
  802d3e:	83 ec 04             	sub    $0x4,%esp
  802d41:	52                   	push   %edx
  802d42:	50                   	push   %eax
  802d43:	68 41 49 80 00       	push   $0x804941
  802d48:	e8 9f e5 ff ff       	call   8012ec <cprintf>
  802d4d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802d56:	a1 48 50 80 00       	mov    0x805048,%eax
  802d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d62:	74 07                	je     802d6b <print_mem_block_lists+0x155>
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	8b 00                	mov    (%eax),%eax
  802d69:	eb 05                	jmp    802d70 <print_mem_block_lists+0x15a>
  802d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d70:	a3 48 50 80 00       	mov    %eax,0x805048
  802d75:	a1 48 50 80 00       	mov    0x805048,%eax
  802d7a:	85 c0                	test   %eax,%eax
  802d7c:	75 8a                	jne    802d08 <print_mem_block_lists+0xf2>
  802d7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d82:	75 84                	jne    802d08 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802d84:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802d88:	75 10                	jne    802d9a <print_mem_block_lists+0x184>
  802d8a:	83 ec 0c             	sub    $0xc,%esp
  802d8d:	68 8c 49 80 00       	push   $0x80498c
  802d92:	e8 55 e5 ff ff       	call   8012ec <cprintf>
  802d97:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802d9a:	83 ec 0c             	sub    $0xc,%esp
  802d9d:	68 00 49 80 00       	push   $0x804900
  802da2:	e8 45 e5 ff ff       	call   8012ec <cprintf>
  802da7:	83 c4 10             	add    $0x10,%esp

}
  802daa:	90                   	nop
  802dab:	c9                   	leave  
  802dac:	c3                   	ret    

00802dad <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802dad:	55                   	push   %ebp
  802dae:	89 e5                	mov    %esp,%ebp
  802db0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802db3:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802dba:	00 00 00 
  802dbd:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802dc4:	00 00 00 
  802dc7:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802dce:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802dd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802dd8:	e9 9e 00 00 00       	jmp    802e7b <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802ddd:	a1 50 50 80 00       	mov    0x805050,%eax
  802de2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de5:	c1 e2 04             	shl    $0x4,%edx
  802de8:	01 d0                	add    %edx,%eax
  802dea:	85 c0                	test   %eax,%eax
  802dec:	75 14                	jne    802e02 <initialize_MemBlocksList+0x55>
  802dee:	83 ec 04             	sub    $0x4,%esp
  802df1:	68 b4 49 80 00       	push   $0x8049b4
  802df6:	6a 47                	push   $0x47
  802df8:	68 d7 49 80 00       	push   $0x8049d7
  802dfd:	e8 36 e2 ff ff       	call   801038 <_panic>
  802e02:	a1 50 50 80 00       	mov    0x805050,%eax
  802e07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e0a:	c1 e2 04             	shl    $0x4,%edx
  802e0d:	01 d0                	add    %edx,%eax
  802e0f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e15:	89 10                	mov    %edx,(%eax)
  802e17:	8b 00                	mov    (%eax),%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	74 18                	je     802e35 <initialize_MemBlocksList+0x88>
  802e1d:	a1 48 51 80 00       	mov    0x805148,%eax
  802e22:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802e28:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802e2b:	c1 e1 04             	shl    $0x4,%ecx
  802e2e:	01 ca                	add    %ecx,%edx
  802e30:	89 50 04             	mov    %edx,0x4(%eax)
  802e33:	eb 12                	jmp    802e47 <initialize_MemBlocksList+0x9a>
  802e35:	a1 50 50 80 00       	mov    0x805050,%eax
  802e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e3d:	c1 e2 04             	shl    $0x4,%edx
  802e40:	01 d0                	add    %edx,%eax
  802e42:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e47:	a1 50 50 80 00       	mov    0x805050,%eax
  802e4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4f:	c1 e2 04             	shl    $0x4,%edx
  802e52:	01 d0                	add    %edx,%eax
  802e54:	a3 48 51 80 00       	mov    %eax,0x805148
  802e59:	a1 50 50 80 00       	mov    0x805050,%eax
  802e5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e61:	c1 e2 04             	shl    $0x4,%edx
  802e64:	01 d0                	add    %edx,%eax
  802e66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6d:	a1 54 51 80 00       	mov    0x805154,%eax
  802e72:	40                   	inc    %eax
  802e73:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802e78:	ff 45 f4             	incl   -0xc(%ebp)
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e81:	0f 82 56 ff ff ff    	jb     802ddd <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802e87:	90                   	nop
  802e88:	c9                   	leave  
  802e89:	c3                   	ret    

00802e8a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802e8a:	55                   	push   %ebp
  802e8b:	89 e5                	mov    %esp,%ebp
  802e8d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	8b 00                	mov    (%eax),%eax
  802e95:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802e98:	eb 19                	jmp    802eb3 <find_block+0x29>
	{
		if(element->sva == va){
  802e9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ea0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ea3:	75 05                	jne    802eaa <find_block+0x20>
			 		return element;
  802ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ea8:	eb 36                	jmp    802ee0 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	8b 40 08             	mov    0x8(%eax),%eax
  802eb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802eb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802eb7:	74 07                	je     802ec0 <find_block+0x36>
  802eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ebc:	8b 00                	mov    (%eax),%eax
  802ebe:	eb 05                	jmp    802ec5 <find_block+0x3b>
  802ec0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec8:	89 42 08             	mov    %eax,0x8(%edx)
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	8b 40 08             	mov    0x8(%eax),%eax
  802ed1:	85 c0                	test   %eax,%eax
  802ed3:	75 c5                	jne    802e9a <find_block+0x10>
  802ed5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ed9:	75 bf                	jne    802e9a <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802edb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ee0:	c9                   	leave  
  802ee1:	c3                   	ret    

00802ee2 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802ee2:	55                   	push   %ebp
  802ee3:	89 e5                	mov    %esp,%ebp
  802ee5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802ee8:	a1 44 50 80 00       	mov    0x805044,%eax
  802eed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802ef0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ef5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802ef8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802efc:	74 0a                	je     802f08 <insert_sorted_allocList+0x26>
  802efe:	8b 45 08             	mov    0x8(%ebp),%eax
  802f01:	8b 40 08             	mov    0x8(%eax),%eax
  802f04:	85 c0                	test   %eax,%eax
  802f06:	75 65                	jne    802f6d <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802f08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f0c:	75 14                	jne    802f22 <insert_sorted_allocList+0x40>
  802f0e:	83 ec 04             	sub    $0x4,%esp
  802f11:	68 b4 49 80 00       	push   $0x8049b4
  802f16:	6a 6e                	push   $0x6e
  802f18:	68 d7 49 80 00       	push   $0x8049d7
  802f1d:	e8 16 e1 ff ff       	call   801038 <_panic>
  802f22:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	89 10                	mov    %edx,(%eax)
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	8b 00                	mov    (%eax),%eax
  802f32:	85 c0                	test   %eax,%eax
  802f34:	74 0d                	je     802f43 <insert_sorted_allocList+0x61>
  802f36:	a1 40 50 80 00       	mov    0x805040,%eax
  802f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3e:	89 50 04             	mov    %edx,0x4(%eax)
  802f41:	eb 08                	jmp    802f4b <insert_sorted_allocList+0x69>
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	a3 44 50 80 00       	mov    %eax,0x805044
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	a3 40 50 80 00       	mov    %eax,0x805040
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802f62:	40                   	inc    %eax
  802f63:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802f68:	e9 cf 01 00 00       	jmp    80313c <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f70:	8b 50 08             	mov    0x8(%eax),%edx
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	8b 40 08             	mov    0x8(%eax),%eax
  802f79:	39 c2                	cmp    %eax,%edx
  802f7b:	73 65                	jae    802fe2 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802f7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f81:	75 14                	jne    802f97 <insert_sorted_allocList+0xb5>
  802f83:	83 ec 04             	sub    $0x4,%esp
  802f86:	68 f0 49 80 00       	push   $0x8049f0
  802f8b:	6a 72                	push   $0x72
  802f8d:	68 d7 49 80 00       	push   $0x8049d7
  802f92:	e8 a1 e0 ff ff       	call   801038 <_panic>
  802f97:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa0:	89 50 04             	mov    %edx,0x4(%eax)
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	8b 40 04             	mov    0x4(%eax),%eax
  802fa9:	85 c0                	test   %eax,%eax
  802fab:	74 0c                	je     802fb9 <insert_sorted_allocList+0xd7>
  802fad:	a1 44 50 80 00       	mov    0x805044,%eax
  802fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb5:	89 10                	mov    %edx,(%eax)
  802fb7:	eb 08                	jmp    802fc1 <insert_sorted_allocList+0xdf>
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	a3 40 50 80 00       	mov    %eax,0x805040
  802fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc4:	a3 44 50 80 00       	mov    %eax,0x805044
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802fd7:	40                   	inc    %eax
  802fd8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802fdd:	e9 5a 01 00 00       	jmp    80313c <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe5:	8b 50 08             	mov    0x8(%eax),%edx
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	8b 40 08             	mov    0x8(%eax),%eax
  802fee:	39 c2                	cmp    %eax,%edx
  802ff0:	75 70                	jne    803062 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802ff2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ff6:	74 06                	je     802ffe <insert_sorted_allocList+0x11c>
  802ff8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ffc:	75 14                	jne    803012 <insert_sorted_allocList+0x130>
  802ffe:	83 ec 04             	sub    $0x4,%esp
  803001:	68 14 4a 80 00       	push   $0x804a14
  803006:	6a 75                	push   $0x75
  803008:	68 d7 49 80 00       	push   $0x8049d7
  80300d:	e8 26 e0 ff ff       	call   801038 <_panic>
  803012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803015:	8b 10                	mov    (%eax),%edx
  803017:	8b 45 08             	mov    0x8(%ebp),%eax
  80301a:	89 10                	mov    %edx,(%eax)
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	8b 00                	mov    (%eax),%eax
  803021:	85 c0                	test   %eax,%eax
  803023:	74 0b                	je     803030 <insert_sorted_allocList+0x14e>
  803025:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803028:	8b 00                	mov    (%eax),%eax
  80302a:	8b 55 08             	mov    0x8(%ebp),%edx
  80302d:	89 50 04             	mov    %edx,0x4(%eax)
  803030:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803033:	8b 55 08             	mov    0x8(%ebp),%edx
  803036:	89 10                	mov    %edx,(%eax)
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80303e:	89 50 04             	mov    %edx,0x4(%eax)
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	8b 00                	mov    (%eax),%eax
  803046:	85 c0                	test   %eax,%eax
  803048:	75 08                	jne    803052 <insert_sorted_allocList+0x170>
  80304a:	8b 45 08             	mov    0x8(%ebp),%eax
  80304d:	a3 44 50 80 00       	mov    %eax,0x805044
  803052:	a1 4c 50 80 00       	mov    0x80504c,%eax
  803057:	40                   	inc    %eax
  803058:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  80305d:	e9 da 00 00 00       	jmp    80313c <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  803062:	a1 40 50 80 00       	mov    0x805040,%eax
  803067:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80306a:	e9 9d 00 00 00       	jmp    80310c <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	8b 00                	mov    (%eax),%eax
  803074:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	8b 50 08             	mov    0x8(%eax),%edx
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	8b 40 08             	mov    0x8(%eax),%eax
  803083:	39 c2                	cmp    %eax,%edx
  803085:	76 7d                	jbe    803104 <insert_sorted_allocList+0x222>
  803087:	8b 45 08             	mov    0x8(%ebp),%eax
  80308a:	8b 50 08             	mov    0x8(%eax),%edx
  80308d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803090:	8b 40 08             	mov    0x8(%eax),%eax
  803093:	39 c2                	cmp    %eax,%edx
  803095:	73 6d                	jae    803104 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  803097:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80309b:	74 06                	je     8030a3 <insert_sorted_allocList+0x1c1>
  80309d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a1:	75 14                	jne    8030b7 <insert_sorted_allocList+0x1d5>
  8030a3:	83 ec 04             	sub    $0x4,%esp
  8030a6:	68 14 4a 80 00       	push   $0x804a14
  8030ab:	6a 7c                	push   $0x7c
  8030ad:	68 d7 49 80 00       	push   $0x8049d7
  8030b2:	e8 81 df ff ff       	call   801038 <_panic>
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	8b 10                	mov    (%eax),%edx
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	89 10                	mov    %edx,(%eax)
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	8b 00                	mov    (%eax),%eax
  8030c6:	85 c0                	test   %eax,%eax
  8030c8:	74 0b                	je     8030d5 <insert_sorted_allocList+0x1f3>
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	8b 00                	mov    (%eax),%eax
  8030cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d2:	89 50 04             	mov    %edx,0x4(%eax)
  8030d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030db:	89 10                	mov    %edx,(%eax)
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e3:	89 50 04             	mov    %edx,0x4(%eax)
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	85 c0                	test   %eax,%eax
  8030ed:	75 08                	jne    8030f7 <insert_sorted_allocList+0x215>
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	a3 44 50 80 00       	mov    %eax,0x805044
  8030f7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8030fc:	40                   	inc    %eax
  8030fd:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  803102:	eb 38                	jmp    80313c <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  803104:	a1 48 50 80 00       	mov    0x805048,%eax
  803109:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80310c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803110:	74 07                	je     803119 <insert_sorted_allocList+0x237>
  803112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803115:	8b 00                	mov    (%eax),%eax
  803117:	eb 05                	jmp    80311e <insert_sorted_allocList+0x23c>
  803119:	b8 00 00 00 00       	mov    $0x0,%eax
  80311e:	a3 48 50 80 00       	mov    %eax,0x805048
  803123:	a1 48 50 80 00       	mov    0x805048,%eax
  803128:	85 c0                	test   %eax,%eax
  80312a:	0f 85 3f ff ff ff    	jne    80306f <insert_sorted_allocList+0x18d>
  803130:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803134:	0f 85 35 ff ff ff    	jne    80306f <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  80313a:	eb 00                	jmp    80313c <insert_sorted_allocList+0x25a>
  80313c:	90                   	nop
  80313d:	c9                   	leave  
  80313e:	c3                   	ret    

0080313f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80313f:	55                   	push   %ebp
  803140:	89 e5                	mov    %esp,%ebp
  803142:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  803145:	a1 38 51 80 00       	mov    0x805138,%eax
  80314a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80314d:	e9 6b 02 00 00       	jmp    8033bd <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	8b 40 0c             	mov    0xc(%eax),%eax
  803158:	3b 45 08             	cmp    0x8(%ebp),%eax
  80315b:	0f 85 90 00 00 00    	jne    8031f1 <alloc_block_FF+0xb2>
			  temp=element;
  803161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803164:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  803167:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80316b:	75 17                	jne    803184 <alloc_block_FF+0x45>
  80316d:	83 ec 04             	sub    $0x4,%esp
  803170:	68 48 4a 80 00       	push   $0x804a48
  803175:	68 92 00 00 00       	push   $0x92
  80317a:	68 d7 49 80 00       	push   $0x8049d7
  80317f:	e8 b4 de ff ff       	call   801038 <_panic>
  803184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803187:	8b 00                	mov    (%eax),%eax
  803189:	85 c0                	test   %eax,%eax
  80318b:	74 10                	je     80319d <alloc_block_FF+0x5e>
  80318d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803190:	8b 00                	mov    (%eax),%eax
  803192:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803195:	8b 52 04             	mov    0x4(%edx),%edx
  803198:	89 50 04             	mov    %edx,0x4(%eax)
  80319b:	eb 0b                	jmp    8031a8 <alloc_block_FF+0x69>
  80319d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a0:	8b 40 04             	mov    0x4(%eax),%eax
  8031a3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ab:	8b 40 04             	mov    0x4(%eax),%eax
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	74 0f                	je     8031c1 <alloc_block_FF+0x82>
  8031b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b5:	8b 40 04             	mov    0x4(%eax),%eax
  8031b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031bb:	8b 12                	mov    (%edx),%edx
  8031bd:	89 10                	mov    %edx,(%eax)
  8031bf:	eb 0a                	jmp    8031cb <alloc_block_FF+0x8c>
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	8b 00                	mov    (%eax),%eax
  8031c6:	a3 38 51 80 00       	mov    %eax,0x805138
  8031cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031de:	a1 44 51 80 00       	mov    0x805144,%eax
  8031e3:	48                   	dec    %eax
  8031e4:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  8031e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ec:	e9 ff 01 00 00       	jmp    8033f0 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  8031f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031fa:	0f 86 b5 01 00 00    	jbe    8033b5 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  803200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803203:	8b 40 0c             	mov    0xc(%eax),%eax
  803206:	2b 45 08             	sub    0x8(%ebp),%eax
  803209:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80320c:	a1 48 51 80 00       	mov    0x805148,%eax
  803211:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  803214:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803218:	75 17                	jne    803231 <alloc_block_FF+0xf2>
  80321a:	83 ec 04             	sub    $0x4,%esp
  80321d:	68 48 4a 80 00       	push   $0x804a48
  803222:	68 99 00 00 00       	push   $0x99
  803227:	68 d7 49 80 00       	push   $0x8049d7
  80322c:	e8 07 de ff ff       	call   801038 <_panic>
  803231:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803234:	8b 00                	mov    (%eax),%eax
  803236:	85 c0                	test   %eax,%eax
  803238:	74 10                	je     80324a <alloc_block_FF+0x10b>
  80323a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323d:	8b 00                	mov    (%eax),%eax
  80323f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803242:	8b 52 04             	mov    0x4(%edx),%edx
  803245:	89 50 04             	mov    %edx,0x4(%eax)
  803248:	eb 0b                	jmp    803255 <alloc_block_FF+0x116>
  80324a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324d:	8b 40 04             	mov    0x4(%eax),%eax
  803250:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803255:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803258:	8b 40 04             	mov    0x4(%eax),%eax
  80325b:	85 c0                	test   %eax,%eax
  80325d:	74 0f                	je     80326e <alloc_block_FF+0x12f>
  80325f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803262:	8b 40 04             	mov    0x4(%eax),%eax
  803265:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803268:	8b 12                	mov    (%edx),%edx
  80326a:	89 10                	mov    %edx,(%eax)
  80326c:	eb 0a                	jmp    803278 <alloc_block_FF+0x139>
  80326e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803271:	8b 00                	mov    (%eax),%eax
  803273:	a3 48 51 80 00       	mov    %eax,0x805148
  803278:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80327b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803281:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803284:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328b:	a1 54 51 80 00       	mov    0x805154,%eax
  803290:	48                   	dec    %eax
  803291:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  803296:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80329a:	75 17                	jne    8032b3 <alloc_block_FF+0x174>
  80329c:	83 ec 04             	sub    $0x4,%esp
  80329f:	68 f0 49 80 00       	push   $0x8049f0
  8032a4:	68 9a 00 00 00       	push   $0x9a
  8032a9:	68 d7 49 80 00       	push   $0x8049d7
  8032ae:	e8 85 dd ff ff       	call   801038 <_panic>
  8032b3:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032bc:	89 50 04             	mov    %edx,0x4(%eax)
  8032bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c2:	8b 40 04             	mov    0x4(%eax),%eax
  8032c5:	85 c0                	test   %eax,%eax
  8032c7:	74 0c                	je     8032d5 <alloc_block_FF+0x196>
  8032c9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8032d1:	89 10                	mov    %edx,(%eax)
  8032d3:	eb 08                	jmp    8032dd <alloc_block_FF+0x19e>
  8032d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d8:	a3 38 51 80 00       	mov    %eax,0x805138
  8032dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ee:	a1 44 51 80 00       	mov    0x805144,%eax
  8032f3:	40                   	inc    %eax
  8032f4:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  8032f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ff:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  803302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803305:	8b 50 08             	mov    0x8(%eax),%edx
  803308:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330b:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  80330e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803311:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803314:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  803317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331a:	8b 50 08             	mov    0x8(%eax),%edx
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	01 c2                	add    %eax,%edx
  803322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803325:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  803328:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  80332e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803332:	75 17                	jne    80334b <alloc_block_FF+0x20c>
  803334:	83 ec 04             	sub    $0x4,%esp
  803337:	68 48 4a 80 00       	push   $0x804a48
  80333c:	68 a2 00 00 00       	push   $0xa2
  803341:	68 d7 49 80 00       	push   $0x8049d7
  803346:	e8 ed dc ff ff       	call   801038 <_panic>
  80334b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	74 10                	je     803364 <alloc_block_FF+0x225>
  803354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803357:	8b 00                	mov    (%eax),%eax
  803359:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80335c:	8b 52 04             	mov    0x4(%edx),%edx
  80335f:	89 50 04             	mov    %edx,0x4(%eax)
  803362:	eb 0b                	jmp    80336f <alloc_block_FF+0x230>
  803364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803367:	8b 40 04             	mov    0x4(%eax),%eax
  80336a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80336f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803372:	8b 40 04             	mov    0x4(%eax),%eax
  803375:	85 c0                	test   %eax,%eax
  803377:	74 0f                	je     803388 <alloc_block_FF+0x249>
  803379:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80337c:	8b 40 04             	mov    0x4(%eax),%eax
  80337f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803382:	8b 12                	mov    (%edx),%edx
  803384:	89 10                	mov    %edx,(%eax)
  803386:	eb 0a                	jmp    803392 <alloc_block_FF+0x253>
  803388:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80338b:	8b 00                	mov    (%eax),%eax
  80338d:	a3 38 51 80 00       	mov    %eax,0x805138
  803392:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803395:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80339b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80339e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a5:	a1 44 51 80 00       	mov    0x805144,%eax
  8033aa:	48                   	dec    %eax
  8033ab:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  8033b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b3:	eb 3b                	jmp    8033f0 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8033b5:	a1 40 51 80 00       	mov    0x805140,%eax
  8033ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c1:	74 07                	je     8033ca <alloc_block_FF+0x28b>
  8033c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c6:	8b 00                	mov    (%eax),%eax
  8033c8:	eb 05                	jmp    8033cf <alloc_block_FF+0x290>
  8033ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8033cf:	a3 40 51 80 00       	mov    %eax,0x805140
  8033d4:	a1 40 51 80 00       	mov    0x805140,%eax
  8033d9:	85 c0                	test   %eax,%eax
  8033db:	0f 85 71 fd ff ff    	jne    803152 <alloc_block_FF+0x13>
  8033e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e5:	0f 85 67 fd ff ff    	jne    803152 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  8033eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033f0:	c9                   	leave  
  8033f1:	c3                   	ret    

008033f2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8033f2:	55                   	push   %ebp
  8033f3:	89 e5                	mov    %esp,%ebp
  8033f5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  8033f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  8033ff:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  803406:	a1 38 51 80 00       	mov    0x805138,%eax
  80340b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80340e:	e9 d3 00 00 00       	jmp    8034e6 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  803413:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803416:	8b 40 0c             	mov    0xc(%eax),%eax
  803419:	3b 45 08             	cmp    0x8(%ebp),%eax
  80341c:	0f 85 90 00 00 00    	jne    8034b2 <alloc_block_BF+0xc0>
	   temp = element;
  803422:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803425:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  803428:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80342c:	75 17                	jne    803445 <alloc_block_BF+0x53>
  80342e:	83 ec 04             	sub    $0x4,%esp
  803431:	68 48 4a 80 00       	push   $0x804a48
  803436:	68 bd 00 00 00       	push   $0xbd
  80343b:	68 d7 49 80 00       	push   $0x8049d7
  803440:	e8 f3 db ff ff       	call   801038 <_panic>
  803445:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803448:	8b 00                	mov    (%eax),%eax
  80344a:	85 c0                	test   %eax,%eax
  80344c:	74 10                	je     80345e <alloc_block_BF+0x6c>
  80344e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803451:	8b 00                	mov    (%eax),%eax
  803453:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803456:	8b 52 04             	mov    0x4(%edx),%edx
  803459:	89 50 04             	mov    %edx,0x4(%eax)
  80345c:	eb 0b                	jmp    803469 <alloc_block_BF+0x77>
  80345e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803461:	8b 40 04             	mov    0x4(%eax),%eax
  803464:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803469:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346c:	8b 40 04             	mov    0x4(%eax),%eax
  80346f:	85 c0                	test   %eax,%eax
  803471:	74 0f                	je     803482 <alloc_block_BF+0x90>
  803473:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803476:	8b 40 04             	mov    0x4(%eax),%eax
  803479:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80347c:	8b 12                	mov    (%edx),%edx
  80347e:	89 10                	mov    %edx,(%eax)
  803480:	eb 0a                	jmp    80348c <alloc_block_BF+0x9a>
  803482:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803485:	8b 00                	mov    (%eax),%eax
  803487:	a3 38 51 80 00       	mov    %eax,0x805138
  80348c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803495:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803498:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349f:	a1 44 51 80 00       	mov    0x805144,%eax
  8034a4:	48                   	dec    %eax
  8034a5:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  8034aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034ad:	e9 41 01 00 00       	jmp    8035f3 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8034b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034bb:	76 21                	jbe    8034de <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  8034bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8034c6:	73 16                	jae    8034de <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  8034c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  8034d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  8034d7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8034de:	a1 40 51 80 00       	mov    0x805140,%eax
  8034e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8034e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034ea:	74 07                	je     8034f3 <alloc_block_BF+0x101>
  8034ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ef:	8b 00                	mov    (%eax),%eax
  8034f1:	eb 05                	jmp    8034f8 <alloc_block_BF+0x106>
  8034f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f8:	a3 40 51 80 00       	mov    %eax,0x805140
  8034fd:	a1 40 51 80 00       	mov    0x805140,%eax
  803502:	85 c0                	test   %eax,%eax
  803504:	0f 85 09 ff ff ff    	jne    803413 <alloc_block_BF+0x21>
  80350a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80350e:	0f 85 ff fe ff ff    	jne    803413 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  803514:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  803518:	0f 85 d0 00 00 00    	jne    8035ee <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80351e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803521:	8b 40 0c             	mov    0xc(%eax),%eax
  803524:	2b 45 08             	sub    0x8(%ebp),%eax
  803527:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  80352a:	a1 48 51 80 00       	mov    0x805148,%eax
  80352f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  803532:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803536:	75 17                	jne    80354f <alloc_block_BF+0x15d>
  803538:	83 ec 04             	sub    $0x4,%esp
  80353b:	68 48 4a 80 00       	push   $0x804a48
  803540:	68 d1 00 00 00       	push   $0xd1
  803545:	68 d7 49 80 00       	push   $0x8049d7
  80354a:	e8 e9 da ff ff       	call   801038 <_panic>
  80354f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803552:	8b 00                	mov    (%eax),%eax
  803554:	85 c0                	test   %eax,%eax
  803556:	74 10                	je     803568 <alloc_block_BF+0x176>
  803558:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80355b:	8b 00                	mov    (%eax),%eax
  80355d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803560:	8b 52 04             	mov    0x4(%edx),%edx
  803563:	89 50 04             	mov    %edx,0x4(%eax)
  803566:	eb 0b                	jmp    803573 <alloc_block_BF+0x181>
  803568:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80356b:	8b 40 04             	mov    0x4(%eax),%eax
  80356e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803573:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803576:	8b 40 04             	mov    0x4(%eax),%eax
  803579:	85 c0                	test   %eax,%eax
  80357b:	74 0f                	je     80358c <alloc_block_BF+0x19a>
  80357d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803580:	8b 40 04             	mov    0x4(%eax),%eax
  803583:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803586:	8b 12                	mov    (%edx),%edx
  803588:	89 10                	mov    %edx,(%eax)
  80358a:	eb 0a                	jmp    803596 <alloc_block_BF+0x1a4>
  80358c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80358f:	8b 00                	mov    (%eax),%eax
  803591:	a3 48 51 80 00       	mov    %eax,0x805148
  803596:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803599:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80359f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a9:	a1 54 51 80 00       	mov    0x805154,%eax
  8035ae:	48                   	dec    %eax
  8035af:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  8035b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ba:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  8035bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c0:	8b 50 08             	mov    0x8(%eax),%edx
  8035c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035c6:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  8035c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035cf:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  8035d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d5:	8b 50 08             	mov    0x8(%eax),%edx
  8035d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035db:	01 c2                	add    %eax,%edx
  8035dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e0:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  8035e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035e6:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  8035e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8035ec:	eb 05                	jmp    8035f3 <alloc_block_BF+0x201>
	 }
	 return NULL;
  8035ee:	b8 00 00 00 00       	mov    $0x0,%eax


}
  8035f3:	c9                   	leave  
  8035f4:	c3                   	ret    

008035f5 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8035f5:	55                   	push   %ebp
  8035f6:	89 e5                	mov    %esp,%ebp
  8035f8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8035fb:	83 ec 04             	sub    $0x4,%esp
  8035fe:	68 68 4a 80 00       	push   $0x804a68
  803603:	68 e8 00 00 00       	push   $0xe8
  803608:	68 d7 49 80 00       	push   $0x8049d7
  80360d:	e8 26 da ff ff       	call   801038 <_panic>

00803612 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803612:	55                   	push   %ebp
  803613:	89 e5                	mov    %esp,%ebp
  803615:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  803618:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80361d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  803620:	a1 38 51 80 00       	mov    0x805138,%eax
  803625:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  803628:	a1 44 51 80 00       	mov    0x805144,%eax
  80362d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  803630:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803634:	75 68                	jne    80369e <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803636:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80363a:	75 17                	jne    803653 <insert_sorted_with_merge_freeList+0x41>
  80363c:	83 ec 04             	sub    $0x4,%esp
  80363f:	68 b4 49 80 00       	push   $0x8049b4
  803644:	68 36 01 00 00       	push   $0x136
  803649:	68 d7 49 80 00       	push   $0x8049d7
  80364e:	e8 e5 d9 ff ff       	call   801038 <_panic>
  803653:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803659:	8b 45 08             	mov    0x8(%ebp),%eax
  80365c:	89 10                	mov    %edx,(%eax)
  80365e:	8b 45 08             	mov    0x8(%ebp),%eax
  803661:	8b 00                	mov    (%eax),%eax
  803663:	85 c0                	test   %eax,%eax
  803665:	74 0d                	je     803674 <insert_sorted_with_merge_freeList+0x62>
  803667:	a1 38 51 80 00       	mov    0x805138,%eax
  80366c:	8b 55 08             	mov    0x8(%ebp),%edx
  80366f:	89 50 04             	mov    %edx,0x4(%eax)
  803672:	eb 08                	jmp    80367c <insert_sorted_with_merge_freeList+0x6a>
  803674:	8b 45 08             	mov    0x8(%ebp),%eax
  803677:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80367c:	8b 45 08             	mov    0x8(%ebp),%eax
  80367f:	a3 38 51 80 00       	mov    %eax,0x805138
  803684:	8b 45 08             	mov    0x8(%ebp),%eax
  803687:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80368e:	a1 44 51 80 00       	mov    0x805144,%eax
  803693:	40                   	inc    %eax
  803694:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803699:	e9 ba 06 00 00       	jmp    803d58 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  80369e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a1:	8b 50 08             	mov    0x8(%eax),%edx
  8036a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8036aa:	01 c2                	add    %eax,%edx
  8036ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8036af:	8b 40 08             	mov    0x8(%eax),%eax
  8036b2:	39 c2                	cmp    %eax,%edx
  8036b4:	73 68                	jae    80371e <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8036b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036ba:	75 17                	jne    8036d3 <insert_sorted_with_merge_freeList+0xc1>
  8036bc:	83 ec 04             	sub    $0x4,%esp
  8036bf:	68 f0 49 80 00       	push   $0x8049f0
  8036c4:	68 3a 01 00 00       	push   $0x13a
  8036c9:	68 d7 49 80 00       	push   $0x8049d7
  8036ce:	e8 65 d9 ff ff       	call   801038 <_panic>
  8036d3:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8036d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dc:	89 50 04             	mov    %edx,0x4(%eax)
  8036df:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e2:	8b 40 04             	mov    0x4(%eax),%eax
  8036e5:	85 c0                	test   %eax,%eax
  8036e7:	74 0c                	je     8036f5 <insert_sorted_with_merge_freeList+0xe3>
  8036e9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8036ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f1:	89 10                	mov    %edx,(%eax)
  8036f3:	eb 08                	jmp    8036fd <insert_sorted_with_merge_freeList+0xeb>
  8036f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f8:	a3 38 51 80 00       	mov    %eax,0x805138
  8036fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803700:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803705:	8b 45 08             	mov    0x8(%ebp),%eax
  803708:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80370e:	a1 44 51 80 00       	mov    0x805144,%eax
  803713:	40                   	inc    %eax
  803714:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803719:	e9 3a 06 00 00       	jmp    803d58 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  80371e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803721:	8b 50 08             	mov    0x8(%eax),%edx
  803724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803727:	8b 40 0c             	mov    0xc(%eax),%eax
  80372a:	01 c2                	add    %eax,%edx
  80372c:	8b 45 08             	mov    0x8(%ebp),%eax
  80372f:	8b 40 08             	mov    0x8(%eax),%eax
  803732:	39 c2                	cmp    %eax,%edx
  803734:	0f 85 90 00 00 00    	jne    8037ca <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  80373a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373d:	8b 50 0c             	mov    0xc(%eax),%edx
  803740:	8b 45 08             	mov    0x8(%ebp),%eax
  803743:	8b 40 0c             	mov    0xc(%eax),%eax
  803746:	01 c2                	add    %eax,%edx
  803748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374b:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  80374e:	8b 45 08             	mov    0x8(%ebp),%eax
  803751:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  803758:	8b 45 08             	mov    0x8(%ebp),%eax
  80375b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803762:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803766:	75 17                	jne    80377f <insert_sorted_with_merge_freeList+0x16d>
  803768:	83 ec 04             	sub    $0x4,%esp
  80376b:	68 b4 49 80 00       	push   $0x8049b4
  803770:	68 41 01 00 00       	push   $0x141
  803775:	68 d7 49 80 00       	push   $0x8049d7
  80377a:	e8 b9 d8 ff ff       	call   801038 <_panic>
  80377f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803785:	8b 45 08             	mov    0x8(%ebp),%eax
  803788:	89 10                	mov    %edx,(%eax)
  80378a:	8b 45 08             	mov    0x8(%ebp),%eax
  80378d:	8b 00                	mov    (%eax),%eax
  80378f:	85 c0                	test   %eax,%eax
  803791:	74 0d                	je     8037a0 <insert_sorted_with_merge_freeList+0x18e>
  803793:	a1 48 51 80 00       	mov    0x805148,%eax
  803798:	8b 55 08             	mov    0x8(%ebp),%edx
  80379b:	89 50 04             	mov    %edx,0x4(%eax)
  80379e:	eb 08                	jmp    8037a8 <insert_sorted_with_merge_freeList+0x196>
  8037a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ab:	a3 48 51 80 00       	mov    %eax,0x805148
  8037b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8037bf:	40                   	inc    %eax
  8037c0:	a3 54 51 80 00       	mov    %eax,0x805154





}
  8037c5:	e9 8e 05 00 00       	jmp    803d58 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  8037ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cd:	8b 50 08             	mov    0x8(%eax),%edx
  8037d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8037d6:	01 c2                	add    %eax,%edx
  8037d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037db:	8b 40 08             	mov    0x8(%eax),%eax
  8037de:	39 c2                	cmp    %eax,%edx
  8037e0:	73 68                	jae    80384a <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8037e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037e6:	75 17                	jne    8037ff <insert_sorted_with_merge_freeList+0x1ed>
  8037e8:	83 ec 04             	sub    $0x4,%esp
  8037eb:	68 b4 49 80 00       	push   $0x8049b4
  8037f0:	68 45 01 00 00       	push   $0x145
  8037f5:	68 d7 49 80 00       	push   $0x8049d7
  8037fa:	e8 39 d8 ff ff       	call   801038 <_panic>
  8037ff:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803805:	8b 45 08             	mov    0x8(%ebp),%eax
  803808:	89 10                	mov    %edx,(%eax)
  80380a:	8b 45 08             	mov    0x8(%ebp),%eax
  80380d:	8b 00                	mov    (%eax),%eax
  80380f:	85 c0                	test   %eax,%eax
  803811:	74 0d                	je     803820 <insert_sorted_with_merge_freeList+0x20e>
  803813:	a1 38 51 80 00       	mov    0x805138,%eax
  803818:	8b 55 08             	mov    0x8(%ebp),%edx
  80381b:	89 50 04             	mov    %edx,0x4(%eax)
  80381e:	eb 08                	jmp    803828 <insert_sorted_with_merge_freeList+0x216>
  803820:	8b 45 08             	mov    0x8(%ebp),%eax
  803823:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803828:	8b 45 08             	mov    0x8(%ebp),%eax
  80382b:	a3 38 51 80 00       	mov    %eax,0x805138
  803830:	8b 45 08             	mov    0x8(%ebp),%eax
  803833:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80383a:	a1 44 51 80 00       	mov    0x805144,%eax
  80383f:	40                   	inc    %eax
  803840:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803845:	e9 0e 05 00 00       	jmp    803d58 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  80384a:	8b 45 08             	mov    0x8(%ebp),%eax
  80384d:	8b 50 08             	mov    0x8(%eax),%edx
  803850:	8b 45 08             	mov    0x8(%ebp),%eax
  803853:	8b 40 0c             	mov    0xc(%eax),%eax
  803856:	01 c2                	add    %eax,%edx
  803858:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385b:	8b 40 08             	mov    0x8(%eax),%eax
  80385e:	39 c2                	cmp    %eax,%edx
  803860:	0f 85 9c 00 00 00    	jne    803902 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  803866:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803869:	8b 50 0c             	mov    0xc(%eax),%edx
  80386c:	8b 45 08             	mov    0x8(%ebp),%eax
  80386f:	8b 40 0c             	mov    0xc(%eax),%eax
  803872:	01 c2                	add    %eax,%edx
  803874:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803877:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  80387a:	8b 45 08             	mov    0x8(%ebp),%eax
  80387d:	8b 50 08             	mov    0x8(%eax),%edx
  803880:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803883:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  803886:	8b 45 08             	mov    0x8(%ebp),%eax
  803889:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  803890:	8b 45 08             	mov    0x8(%ebp),%eax
  803893:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80389a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80389e:	75 17                	jne    8038b7 <insert_sorted_with_merge_freeList+0x2a5>
  8038a0:	83 ec 04             	sub    $0x4,%esp
  8038a3:	68 b4 49 80 00       	push   $0x8049b4
  8038a8:	68 4d 01 00 00       	push   $0x14d
  8038ad:	68 d7 49 80 00       	push   $0x8049d7
  8038b2:	e8 81 d7 ff ff       	call   801038 <_panic>
  8038b7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c0:	89 10                	mov    %edx,(%eax)
  8038c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c5:	8b 00                	mov    (%eax),%eax
  8038c7:	85 c0                	test   %eax,%eax
  8038c9:	74 0d                	je     8038d8 <insert_sorted_with_merge_freeList+0x2c6>
  8038cb:	a1 48 51 80 00       	mov    0x805148,%eax
  8038d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8038d3:	89 50 04             	mov    %edx,0x4(%eax)
  8038d6:	eb 08                	jmp    8038e0 <insert_sorted_with_merge_freeList+0x2ce>
  8038d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038db:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8038e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038f2:	a1 54 51 80 00       	mov    0x805154,%eax
  8038f7:	40                   	inc    %eax
  8038f8:	a3 54 51 80 00       	mov    %eax,0x805154





}
  8038fd:	e9 56 04 00 00       	jmp    803d58 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803902:	a1 38 51 80 00       	mov    0x805138,%eax
  803907:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80390a:	e9 19 04 00 00       	jmp    803d28 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  80390f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803912:	8b 00                	mov    (%eax),%eax
  803914:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391a:	8b 50 08             	mov    0x8(%eax),%edx
  80391d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803920:	8b 40 0c             	mov    0xc(%eax),%eax
  803923:	01 c2                	add    %eax,%edx
  803925:	8b 45 08             	mov    0x8(%ebp),%eax
  803928:	8b 40 08             	mov    0x8(%eax),%eax
  80392b:	39 c2                	cmp    %eax,%edx
  80392d:	0f 85 ad 01 00 00    	jne    803ae0 <insert_sorted_with_merge_freeList+0x4ce>
  803933:	8b 45 08             	mov    0x8(%ebp),%eax
  803936:	8b 50 08             	mov    0x8(%eax),%edx
  803939:	8b 45 08             	mov    0x8(%ebp),%eax
  80393c:	8b 40 0c             	mov    0xc(%eax),%eax
  80393f:	01 c2                	add    %eax,%edx
  803941:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803944:	8b 40 08             	mov    0x8(%eax),%eax
  803947:	39 c2                	cmp    %eax,%edx
  803949:	0f 85 91 01 00 00    	jne    803ae0 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  80394f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803952:	8b 50 0c             	mov    0xc(%eax),%edx
  803955:	8b 45 08             	mov    0x8(%ebp),%eax
  803958:	8b 48 0c             	mov    0xc(%eax),%ecx
  80395b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80395e:	8b 40 0c             	mov    0xc(%eax),%eax
  803961:	01 c8                	add    %ecx,%eax
  803963:	01 c2                	add    %eax,%edx
  803965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803968:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  80396b:	8b 45 08             	mov    0x8(%ebp),%eax
  80396e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803975:	8b 45 08             	mov    0x8(%ebp),%eax
  803978:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  80397f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803982:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  803989:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  803993:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803997:	75 17                	jne    8039b0 <insert_sorted_with_merge_freeList+0x39e>
  803999:	83 ec 04             	sub    $0x4,%esp
  80399c:	68 48 4a 80 00       	push   $0x804a48
  8039a1:	68 5b 01 00 00       	push   $0x15b
  8039a6:	68 d7 49 80 00       	push   $0x8049d7
  8039ab:	e8 88 d6 ff ff       	call   801038 <_panic>
  8039b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039b3:	8b 00                	mov    (%eax),%eax
  8039b5:	85 c0                	test   %eax,%eax
  8039b7:	74 10                	je     8039c9 <insert_sorted_with_merge_freeList+0x3b7>
  8039b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039bc:	8b 00                	mov    (%eax),%eax
  8039be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039c1:	8b 52 04             	mov    0x4(%edx),%edx
  8039c4:	89 50 04             	mov    %edx,0x4(%eax)
  8039c7:	eb 0b                	jmp    8039d4 <insert_sorted_with_merge_freeList+0x3c2>
  8039c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039cc:	8b 40 04             	mov    0x4(%eax),%eax
  8039cf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039d7:	8b 40 04             	mov    0x4(%eax),%eax
  8039da:	85 c0                	test   %eax,%eax
  8039dc:	74 0f                	je     8039ed <insert_sorted_with_merge_freeList+0x3db>
  8039de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e1:	8b 40 04             	mov    0x4(%eax),%eax
  8039e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039e7:	8b 12                	mov    (%edx),%edx
  8039e9:	89 10                	mov    %edx,(%eax)
  8039eb:	eb 0a                	jmp    8039f7 <insert_sorted_with_merge_freeList+0x3e5>
  8039ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f0:	8b 00                	mov    (%eax),%eax
  8039f2:	a3 38 51 80 00       	mov    %eax,0x805138
  8039f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a0a:	a1 44 51 80 00       	mov    0x805144,%eax
  803a0f:	48                   	dec    %eax
  803a10:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a19:	75 17                	jne    803a32 <insert_sorted_with_merge_freeList+0x420>
  803a1b:	83 ec 04             	sub    $0x4,%esp
  803a1e:	68 b4 49 80 00       	push   $0x8049b4
  803a23:	68 5c 01 00 00       	push   $0x15c
  803a28:	68 d7 49 80 00       	push   $0x8049d7
  803a2d:	e8 06 d6 ff ff       	call   801038 <_panic>
  803a32:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a38:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3b:	89 10                	mov    %edx,(%eax)
  803a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a40:	8b 00                	mov    (%eax),%eax
  803a42:	85 c0                	test   %eax,%eax
  803a44:	74 0d                	je     803a53 <insert_sorted_with_merge_freeList+0x441>
  803a46:	a1 48 51 80 00       	mov    0x805148,%eax
  803a4b:	8b 55 08             	mov    0x8(%ebp),%edx
  803a4e:	89 50 04             	mov    %edx,0x4(%eax)
  803a51:	eb 08                	jmp    803a5b <insert_sorted_with_merge_freeList+0x449>
  803a53:	8b 45 08             	mov    0x8(%ebp),%eax
  803a56:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5e:	a3 48 51 80 00       	mov    %eax,0x805148
  803a63:	8b 45 08             	mov    0x8(%ebp),%eax
  803a66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a6d:	a1 54 51 80 00       	mov    0x805154,%eax
  803a72:	40                   	inc    %eax
  803a73:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  803a78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a7c:	75 17                	jne    803a95 <insert_sorted_with_merge_freeList+0x483>
  803a7e:	83 ec 04             	sub    $0x4,%esp
  803a81:	68 b4 49 80 00       	push   $0x8049b4
  803a86:	68 5d 01 00 00       	push   $0x15d
  803a8b:	68 d7 49 80 00       	push   $0x8049d7
  803a90:	e8 a3 d5 ff ff       	call   801038 <_panic>
  803a95:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803a9e:	89 10                	mov    %edx,(%eax)
  803aa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803aa3:	8b 00                	mov    (%eax),%eax
  803aa5:	85 c0                	test   %eax,%eax
  803aa7:	74 0d                	je     803ab6 <insert_sorted_with_merge_freeList+0x4a4>
  803aa9:	a1 48 51 80 00       	mov    0x805148,%eax
  803aae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803ab1:	89 50 04             	mov    %edx,0x4(%eax)
  803ab4:	eb 08                	jmp    803abe <insert_sorted_with_merge_freeList+0x4ac>
  803ab6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ab9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803abe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac1:	a3 48 51 80 00       	mov    %eax,0x805148
  803ac6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ac9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ad0:	a1 54 51 80 00       	mov    0x805154,%eax
  803ad5:	40                   	inc    %eax
  803ad6:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803adb:	e9 78 02 00 00       	jmp    803d58 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae3:	8b 50 08             	mov    0x8(%eax),%edx
  803ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae9:	8b 40 0c             	mov    0xc(%eax),%eax
  803aec:	01 c2                	add    %eax,%edx
  803aee:	8b 45 08             	mov    0x8(%ebp),%eax
  803af1:	8b 40 08             	mov    0x8(%eax),%eax
  803af4:	39 c2                	cmp    %eax,%edx
  803af6:	0f 83 b8 00 00 00    	jae    803bb4 <insert_sorted_with_merge_freeList+0x5a2>
  803afc:	8b 45 08             	mov    0x8(%ebp),%eax
  803aff:	8b 50 08             	mov    0x8(%eax),%edx
  803b02:	8b 45 08             	mov    0x8(%ebp),%eax
  803b05:	8b 40 0c             	mov    0xc(%eax),%eax
  803b08:	01 c2                	add    %eax,%edx
  803b0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b0d:	8b 40 08             	mov    0x8(%eax),%eax
  803b10:	39 c2                	cmp    %eax,%edx
  803b12:	0f 85 9c 00 00 00    	jne    803bb4 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  803b18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b1b:	8b 50 0c             	mov    0xc(%eax),%edx
  803b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b21:	8b 40 0c             	mov    0xc(%eax),%eax
  803b24:	01 c2                	add    %eax,%edx
  803b26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b29:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  803b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2f:	8b 50 08             	mov    0x8(%eax),%edx
  803b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b35:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  803b38:	8b 45 08             	mov    0x8(%ebp),%eax
  803b3b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803b42:	8b 45 08             	mov    0x8(%ebp),%eax
  803b45:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803b4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b50:	75 17                	jne    803b69 <insert_sorted_with_merge_freeList+0x557>
  803b52:	83 ec 04             	sub    $0x4,%esp
  803b55:	68 b4 49 80 00       	push   $0x8049b4
  803b5a:	68 67 01 00 00       	push   $0x167
  803b5f:	68 d7 49 80 00       	push   $0x8049d7
  803b64:	e8 cf d4 ff ff       	call   801038 <_panic>
  803b69:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b72:	89 10                	mov    %edx,(%eax)
  803b74:	8b 45 08             	mov    0x8(%ebp),%eax
  803b77:	8b 00                	mov    (%eax),%eax
  803b79:	85 c0                	test   %eax,%eax
  803b7b:	74 0d                	je     803b8a <insert_sorted_with_merge_freeList+0x578>
  803b7d:	a1 48 51 80 00       	mov    0x805148,%eax
  803b82:	8b 55 08             	mov    0x8(%ebp),%edx
  803b85:	89 50 04             	mov    %edx,0x4(%eax)
  803b88:	eb 08                	jmp    803b92 <insert_sorted_with_merge_freeList+0x580>
  803b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b92:	8b 45 08             	mov    0x8(%ebp),%eax
  803b95:	a3 48 51 80 00       	mov    %eax,0x805148
  803b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ba4:	a1 54 51 80 00       	mov    0x805154,%eax
  803ba9:	40                   	inc    %eax
  803baa:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803baf:	e9 a4 01 00 00       	jmp    803d58 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb7:	8b 50 08             	mov    0x8(%eax),%edx
  803bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bbd:	8b 40 0c             	mov    0xc(%eax),%eax
  803bc0:	01 c2                	add    %eax,%edx
  803bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc5:	8b 40 08             	mov    0x8(%eax),%eax
  803bc8:	39 c2                	cmp    %eax,%edx
  803bca:	0f 85 ac 00 00 00    	jne    803c7c <insert_sorted_with_merge_freeList+0x66a>
  803bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd3:	8b 50 08             	mov    0x8(%eax),%edx
  803bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd9:	8b 40 0c             	mov    0xc(%eax),%eax
  803bdc:	01 c2                	add    %eax,%edx
  803bde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803be1:	8b 40 08             	mov    0x8(%eax),%eax
  803be4:	39 c2                	cmp    %eax,%edx
  803be6:	0f 83 90 00 00 00    	jae    803c7c <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  803bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bef:	8b 50 0c             	mov    0xc(%eax),%edx
  803bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf5:	8b 40 0c             	mov    0xc(%eax),%eax
  803bf8:	01 c2                	add    %eax,%edx
  803bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfd:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  803c00:	8b 45 08             	mov    0x8(%ebp),%eax
  803c03:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  803c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803c14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c18:	75 17                	jne    803c31 <insert_sorted_with_merge_freeList+0x61f>
  803c1a:	83 ec 04             	sub    $0x4,%esp
  803c1d:	68 b4 49 80 00       	push   $0x8049b4
  803c22:	68 70 01 00 00       	push   $0x170
  803c27:	68 d7 49 80 00       	push   $0x8049d7
  803c2c:	e8 07 d4 ff ff       	call   801038 <_panic>
  803c31:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c37:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3a:	89 10                	mov    %edx,(%eax)
  803c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3f:	8b 00                	mov    (%eax),%eax
  803c41:	85 c0                	test   %eax,%eax
  803c43:	74 0d                	je     803c52 <insert_sorted_with_merge_freeList+0x640>
  803c45:	a1 48 51 80 00       	mov    0x805148,%eax
  803c4a:	8b 55 08             	mov    0x8(%ebp),%edx
  803c4d:	89 50 04             	mov    %edx,0x4(%eax)
  803c50:	eb 08                	jmp    803c5a <insert_sorted_with_merge_freeList+0x648>
  803c52:	8b 45 08             	mov    0x8(%ebp),%eax
  803c55:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c5d:	a3 48 51 80 00       	mov    %eax,0x805148
  803c62:	8b 45 08             	mov    0x8(%ebp),%eax
  803c65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c6c:	a1 54 51 80 00       	mov    0x805154,%eax
  803c71:	40                   	inc    %eax
  803c72:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  803c77:	e9 dc 00 00 00       	jmp    803d58 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7f:	8b 50 08             	mov    0x8(%eax),%edx
  803c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c85:	8b 40 0c             	mov    0xc(%eax),%eax
  803c88:	01 c2                	add    %eax,%edx
  803c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8d:	8b 40 08             	mov    0x8(%eax),%eax
  803c90:	39 c2                	cmp    %eax,%edx
  803c92:	0f 83 88 00 00 00    	jae    803d20 <insert_sorted_with_merge_freeList+0x70e>
  803c98:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9b:	8b 50 08             	mov    0x8(%eax),%edx
  803c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca1:	8b 40 0c             	mov    0xc(%eax),%eax
  803ca4:	01 c2                	add    %eax,%edx
  803ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ca9:	8b 40 08             	mov    0x8(%eax),%eax
  803cac:	39 c2                	cmp    %eax,%edx
  803cae:	73 70                	jae    803d20 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803cb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cb4:	74 06                	je     803cbc <insert_sorted_with_merge_freeList+0x6aa>
  803cb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cba:	75 17                	jne    803cd3 <insert_sorted_with_merge_freeList+0x6c1>
  803cbc:	83 ec 04             	sub    $0x4,%esp
  803cbf:	68 14 4a 80 00       	push   $0x804a14
  803cc4:	68 75 01 00 00       	push   $0x175
  803cc9:	68 d7 49 80 00       	push   $0x8049d7
  803cce:	e8 65 d3 ff ff       	call   801038 <_panic>
  803cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd6:	8b 10                	mov    (%eax),%edx
  803cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  803cdb:	89 10                	mov    %edx,(%eax)
  803cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce0:	8b 00                	mov    (%eax),%eax
  803ce2:	85 c0                	test   %eax,%eax
  803ce4:	74 0b                	je     803cf1 <insert_sorted_with_merge_freeList+0x6df>
  803ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce9:	8b 00                	mov    (%eax),%eax
  803ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  803cee:	89 50 04             	mov    %edx,0x4(%eax)
  803cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf4:	8b 55 08             	mov    0x8(%ebp),%edx
  803cf7:	89 10                	mov    %edx,(%eax)
  803cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803cff:	89 50 04             	mov    %edx,0x4(%eax)
  803d02:	8b 45 08             	mov    0x8(%ebp),%eax
  803d05:	8b 00                	mov    (%eax),%eax
  803d07:	85 c0                	test   %eax,%eax
  803d09:	75 08                	jne    803d13 <insert_sorted_with_merge_freeList+0x701>
  803d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803d13:	a1 44 51 80 00       	mov    0x805144,%eax
  803d18:	40                   	inc    %eax
  803d19:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  803d1e:	eb 38                	jmp    803d58 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803d20:	a1 40 51 80 00       	mov    0x805140,%eax
  803d25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d2c:	74 07                	je     803d35 <insert_sorted_with_merge_freeList+0x723>
  803d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d31:	8b 00                	mov    (%eax),%eax
  803d33:	eb 05                	jmp    803d3a <insert_sorted_with_merge_freeList+0x728>
  803d35:	b8 00 00 00 00       	mov    $0x0,%eax
  803d3a:	a3 40 51 80 00       	mov    %eax,0x805140
  803d3f:	a1 40 51 80 00       	mov    0x805140,%eax
  803d44:	85 c0                	test   %eax,%eax
  803d46:	0f 85 c3 fb ff ff    	jne    80390f <insert_sorted_with_merge_freeList+0x2fd>
  803d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d50:	0f 85 b9 fb ff ff    	jne    80390f <insert_sorted_with_merge_freeList+0x2fd>





}
  803d56:	eb 00                	jmp    803d58 <insert_sorted_with_merge_freeList+0x746>
  803d58:	90                   	nop
  803d59:	c9                   	leave  
  803d5a:	c3                   	ret    
  803d5b:	90                   	nop

00803d5c <__udivdi3>:
  803d5c:	55                   	push   %ebp
  803d5d:	57                   	push   %edi
  803d5e:	56                   	push   %esi
  803d5f:	53                   	push   %ebx
  803d60:	83 ec 1c             	sub    $0x1c,%esp
  803d63:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d67:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d6f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d73:	89 ca                	mov    %ecx,%edx
  803d75:	89 f8                	mov    %edi,%eax
  803d77:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d7b:	85 f6                	test   %esi,%esi
  803d7d:	75 2d                	jne    803dac <__udivdi3+0x50>
  803d7f:	39 cf                	cmp    %ecx,%edi
  803d81:	77 65                	ja     803de8 <__udivdi3+0x8c>
  803d83:	89 fd                	mov    %edi,%ebp
  803d85:	85 ff                	test   %edi,%edi
  803d87:	75 0b                	jne    803d94 <__udivdi3+0x38>
  803d89:	b8 01 00 00 00       	mov    $0x1,%eax
  803d8e:	31 d2                	xor    %edx,%edx
  803d90:	f7 f7                	div    %edi
  803d92:	89 c5                	mov    %eax,%ebp
  803d94:	31 d2                	xor    %edx,%edx
  803d96:	89 c8                	mov    %ecx,%eax
  803d98:	f7 f5                	div    %ebp
  803d9a:	89 c1                	mov    %eax,%ecx
  803d9c:	89 d8                	mov    %ebx,%eax
  803d9e:	f7 f5                	div    %ebp
  803da0:	89 cf                	mov    %ecx,%edi
  803da2:	89 fa                	mov    %edi,%edx
  803da4:	83 c4 1c             	add    $0x1c,%esp
  803da7:	5b                   	pop    %ebx
  803da8:	5e                   	pop    %esi
  803da9:	5f                   	pop    %edi
  803daa:	5d                   	pop    %ebp
  803dab:	c3                   	ret    
  803dac:	39 ce                	cmp    %ecx,%esi
  803dae:	77 28                	ja     803dd8 <__udivdi3+0x7c>
  803db0:	0f bd fe             	bsr    %esi,%edi
  803db3:	83 f7 1f             	xor    $0x1f,%edi
  803db6:	75 40                	jne    803df8 <__udivdi3+0x9c>
  803db8:	39 ce                	cmp    %ecx,%esi
  803dba:	72 0a                	jb     803dc6 <__udivdi3+0x6a>
  803dbc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803dc0:	0f 87 9e 00 00 00    	ja     803e64 <__udivdi3+0x108>
  803dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  803dcb:	89 fa                	mov    %edi,%edx
  803dcd:	83 c4 1c             	add    $0x1c,%esp
  803dd0:	5b                   	pop    %ebx
  803dd1:	5e                   	pop    %esi
  803dd2:	5f                   	pop    %edi
  803dd3:	5d                   	pop    %ebp
  803dd4:	c3                   	ret    
  803dd5:	8d 76 00             	lea    0x0(%esi),%esi
  803dd8:	31 ff                	xor    %edi,%edi
  803dda:	31 c0                	xor    %eax,%eax
  803ddc:	89 fa                	mov    %edi,%edx
  803dde:	83 c4 1c             	add    $0x1c,%esp
  803de1:	5b                   	pop    %ebx
  803de2:	5e                   	pop    %esi
  803de3:	5f                   	pop    %edi
  803de4:	5d                   	pop    %ebp
  803de5:	c3                   	ret    
  803de6:	66 90                	xchg   %ax,%ax
  803de8:	89 d8                	mov    %ebx,%eax
  803dea:	f7 f7                	div    %edi
  803dec:	31 ff                	xor    %edi,%edi
  803dee:	89 fa                	mov    %edi,%edx
  803df0:	83 c4 1c             	add    $0x1c,%esp
  803df3:	5b                   	pop    %ebx
  803df4:	5e                   	pop    %esi
  803df5:	5f                   	pop    %edi
  803df6:	5d                   	pop    %ebp
  803df7:	c3                   	ret    
  803df8:	bd 20 00 00 00       	mov    $0x20,%ebp
  803dfd:	89 eb                	mov    %ebp,%ebx
  803dff:	29 fb                	sub    %edi,%ebx
  803e01:	89 f9                	mov    %edi,%ecx
  803e03:	d3 e6                	shl    %cl,%esi
  803e05:	89 c5                	mov    %eax,%ebp
  803e07:	88 d9                	mov    %bl,%cl
  803e09:	d3 ed                	shr    %cl,%ebp
  803e0b:	89 e9                	mov    %ebp,%ecx
  803e0d:	09 f1                	or     %esi,%ecx
  803e0f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e13:	89 f9                	mov    %edi,%ecx
  803e15:	d3 e0                	shl    %cl,%eax
  803e17:	89 c5                	mov    %eax,%ebp
  803e19:	89 d6                	mov    %edx,%esi
  803e1b:	88 d9                	mov    %bl,%cl
  803e1d:	d3 ee                	shr    %cl,%esi
  803e1f:	89 f9                	mov    %edi,%ecx
  803e21:	d3 e2                	shl    %cl,%edx
  803e23:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e27:	88 d9                	mov    %bl,%cl
  803e29:	d3 e8                	shr    %cl,%eax
  803e2b:	09 c2                	or     %eax,%edx
  803e2d:	89 d0                	mov    %edx,%eax
  803e2f:	89 f2                	mov    %esi,%edx
  803e31:	f7 74 24 0c          	divl   0xc(%esp)
  803e35:	89 d6                	mov    %edx,%esi
  803e37:	89 c3                	mov    %eax,%ebx
  803e39:	f7 e5                	mul    %ebp
  803e3b:	39 d6                	cmp    %edx,%esi
  803e3d:	72 19                	jb     803e58 <__udivdi3+0xfc>
  803e3f:	74 0b                	je     803e4c <__udivdi3+0xf0>
  803e41:	89 d8                	mov    %ebx,%eax
  803e43:	31 ff                	xor    %edi,%edi
  803e45:	e9 58 ff ff ff       	jmp    803da2 <__udivdi3+0x46>
  803e4a:	66 90                	xchg   %ax,%ax
  803e4c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e50:	89 f9                	mov    %edi,%ecx
  803e52:	d3 e2                	shl    %cl,%edx
  803e54:	39 c2                	cmp    %eax,%edx
  803e56:	73 e9                	jae    803e41 <__udivdi3+0xe5>
  803e58:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e5b:	31 ff                	xor    %edi,%edi
  803e5d:	e9 40 ff ff ff       	jmp    803da2 <__udivdi3+0x46>
  803e62:	66 90                	xchg   %ax,%ax
  803e64:	31 c0                	xor    %eax,%eax
  803e66:	e9 37 ff ff ff       	jmp    803da2 <__udivdi3+0x46>
  803e6b:	90                   	nop

00803e6c <__umoddi3>:
  803e6c:	55                   	push   %ebp
  803e6d:	57                   	push   %edi
  803e6e:	56                   	push   %esi
  803e6f:	53                   	push   %ebx
  803e70:	83 ec 1c             	sub    $0x1c,%esp
  803e73:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e77:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e7f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e8b:	89 f3                	mov    %esi,%ebx
  803e8d:	89 fa                	mov    %edi,%edx
  803e8f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e93:	89 34 24             	mov    %esi,(%esp)
  803e96:	85 c0                	test   %eax,%eax
  803e98:	75 1a                	jne    803eb4 <__umoddi3+0x48>
  803e9a:	39 f7                	cmp    %esi,%edi
  803e9c:	0f 86 a2 00 00 00    	jbe    803f44 <__umoddi3+0xd8>
  803ea2:	89 c8                	mov    %ecx,%eax
  803ea4:	89 f2                	mov    %esi,%edx
  803ea6:	f7 f7                	div    %edi
  803ea8:	89 d0                	mov    %edx,%eax
  803eaa:	31 d2                	xor    %edx,%edx
  803eac:	83 c4 1c             	add    $0x1c,%esp
  803eaf:	5b                   	pop    %ebx
  803eb0:	5e                   	pop    %esi
  803eb1:	5f                   	pop    %edi
  803eb2:	5d                   	pop    %ebp
  803eb3:	c3                   	ret    
  803eb4:	39 f0                	cmp    %esi,%eax
  803eb6:	0f 87 ac 00 00 00    	ja     803f68 <__umoddi3+0xfc>
  803ebc:	0f bd e8             	bsr    %eax,%ebp
  803ebf:	83 f5 1f             	xor    $0x1f,%ebp
  803ec2:	0f 84 ac 00 00 00    	je     803f74 <__umoddi3+0x108>
  803ec8:	bf 20 00 00 00       	mov    $0x20,%edi
  803ecd:	29 ef                	sub    %ebp,%edi
  803ecf:	89 fe                	mov    %edi,%esi
  803ed1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ed5:	89 e9                	mov    %ebp,%ecx
  803ed7:	d3 e0                	shl    %cl,%eax
  803ed9:	89 d7                	mov    %edx,%edi
  803edb:	89 f1                	mov    %esi,%ecx
  803edd:	d3 ef                	shr    %cl,%edi
  803edf:	09 c7                	or     %eax,%edi
  803ee1:	89 e9                	mov    %ebp,%ecx
  803ee3:	d3 e2                	shl    %cl,%edx
  803ee5:	89 14 24             	mov    %edx,(%esp)
  803ee8:	89 d8                	mov    %ebx,%eax
  803eea:	d3 e0                	shl    %cl,%eax
  803eec:	89 c2                	mov    %eax,%edx
  803eee:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ef2:	d3 e0                	shl    %cl,%eax
  803ef4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ef8:	8b 44 24 08          	mov    0x8(%esp),%eax
  803efc:	89 f1                	mov    %esi,%ecx
  803efe:	d3 e8                	shr    %cl,%eax
  803f00:	09 d0                	or     %edx,%eax
  803f02:	d3 eb                	shr    %cl,%ebx
  803f04:	89 da                	mov    %ebx,%edx
  803f06:	f7 f7                	div    %edi
  803f08:	89 d3                	mov    %edx,%ebx
  803f0a:	f7 24 24             	mull   (%esp)
  803f0d:	89 c6                	mov    %eax,%esi
  803f0f:	89 d1                	mov    %edx,%ecx
  803f11:	39 d3                	cmp    %edx,%ebx
  803f13:	0f 82 87 00 00 00    	jb     803fa0 <__umoddi3+0x134>
  803f19:	0f 84 91 00 00 00    	je     803fb0 <__umoddi3+0x144>
  803f1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f23:	29 f2                	sub    %esi,%edx
  803f25:	19 cb                	sbb    %ecx,%ebx
  803f27:	89 d8                	mov    %ebx,%eax
  803f29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f2d:	d3 e0                	shl    %cl,%eax
  803f2f:	89 e9                	mov    %ebp,%ecx
  803f31:	d3 ea                	shr    %cl,%edx
  803f33:	09 d0                	or     %edx,%eax
  803f35:	89 e9                	mov    %ebp,%ecx
  803f37:	d3 eb                	shr    %cl,%ebx
  803f39:	89 da                	mov    %ebx,%edx
  803f3b:	83 c4 1c             	add    $0x1c,%esp
  803f3e:	5b                   	pop    %ebx
  803f3f:	5e                   	pop    %esi
  803f40:	5f                   	pop    %edi
  803f41:	5d                   	pop    %ebp
  803f42:	c3                   	ret    
  803f43:	90                   	nop
  803f44:	89 fd                	mov    %edi,%ebp
  803f46:	85 ff                	test   %edi,%edi
  803f48:	75 0b                	jne    803f55 <__umoddi3+0xe9>
  803f4a:	b8 01 00 00 00       	mov    $0x1,%eax
  803f4f:	31 d2                	xor    %edx,%edx
  803f51:	f7 f7                	div    %edi
  803f53:	89 c5                	mov    %eax,%ebp
  803f55:	89 f0                	mov    %esi,%eax
  803f57:	31 d2                	xor    %edx,%edx
  803f59:	f7 f5                	div    %ebp
  803f5b:	89 c8                	mov    %ecx,%eax
  803f5d:	f7 f5                	div    %ebp
  803f5f:	89 d0                	mov    %edx,%eax
  803f61:	e9 44 ff ff ff       	jmp    803eaa <__umoddi3+0x3e>
  803f66:	66 90                	xchg   %ax,%ax
  803f68:	89 c8                	mov    %ecx,%eax
  803f6a:	89 f2                	mov    %esi,%edx
  803f6c:	83 c4 1c             	add    $0x1c,%esp
  803f6f:	5b                   	pop    %ebx
  803f70:	5e                   	pop    %esi
  803f71:	5f                   	pop    %edi
  803f72:	5d                   	pop    %ebp
  803f73:	c3                   	ret    
  803f74:	3b 04 24             	cmp    (%esp),%eax
  803f77:	72 06                	jb     803f7f <__umoddi3+0x113>
  803f79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f7d:	77 0f                	ja     803f8e <__umoddi3+0x122>
  803f7f:	89 f2                	mov    %esi,%edx
  803f81:	29 f9                	sub    %edi,%ecx
  803f83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f87:	89 14 24             	mov    %edx,(%esp)
  803f8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f92:	8b 14 24             	mov    (%esp),%edx
  803f95:	83 c4 1c             	add    $0x1c,%esp
  803f98:	5b                   	pop    %ebx
  803f99:	5e                   	pop    %esi
  803f9a:	5f                   	pop    %edi
  803f9b:	5d                   	pop    %ebp
  803f9c:	c3                   	ret    
  803f9d:	8d 76 00             	lea    0x0(%esi),%esi
  803fa0:	2b 04 24             	sub    (%esp),%eax
  803fa3:	19 fa                	sbb    %edi,%edx
  803fa5:	89 d1                	mov    %edx,%ecx
  803fa7:	89 c6                	mov    %eax,%esi
  803fa9:	e9 71 ff ff ff       	jmp    803f1f <__umoddi3+0xb3>
  803fae:	66 90                	xchg   %ax,%ax
  803fb0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803fb4:	72 ea                	jb     803fa0 <__umoddi3+0x134>
  803fb6:	89 d9                	mov    %ebx,%ecx
  803fb8:	e9 62 ff ff ff       	jmp    803f1f <__umoddi3+0xb3>
