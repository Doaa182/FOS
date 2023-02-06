
obj/user/tst_page_replacement_alloc:     file format elf32-i386


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
  800031:	e8 4f 03 00 00       	call   800385 <libmain>
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
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp

//	cprintf("envID = %d\n",envID);

	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80003f:	a1 20 30 80 00       	mov    0x803020,%eax
  800044:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80004a:	8b 00                	mov    (%eax),%eax
  80004c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80004f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800052:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800057:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005c:	74 14                	je     800072 <_main+0x3a>
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 e0 1d 80 00       	push   $0x801de0
  800066:	6a 12                	push   $0x12
  800068:	68 24 1e 80 00       	push   $0x801e24
  80006d:	e8 4f 04 00 00       	call   8004c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800072:	a1 20 30 80 00       	mov    0x803020,%eax
  800077:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80007d:	83 c0 18             	add    $0x18,%eax
  800080:	8b 00                	mov    (%eax),%eax
  800082:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800088:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008d:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800092:	74 14                	je     8000a8 <_main+0x70>
  800094:	83 ec 04             	sub    $0x4,%esp
  800097:	68 e0 1d 80 00       	push   $0x801de0
  80009c:	6a 13                	push   $0x13
  80009e:	68 24 1e 80 00       	push   $0x801e24
  8000a3:	e8 19 04 00 00       	call   8004c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000ad:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000b3:	83 c0 30             	add    $0x30,%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8000bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c3:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000c8:	74 14                	je     8000de <_main+0xa6>
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	68 e0 1d 80 00       	push   $0x801de0
  8000d2:	6a 14                	push   $0x14
  8000d4:	68 24 1e 80 00       	push   $0x801e24
  8000d9:	e8 e3 03 00 00       	call   8004c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000de:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e3:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000e9:	83 c0 48             	add    $0x48,%eax
  8000ec:	8b 00                	mov    (%eax),%eax
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000f9:	3d 00 30 20 00       	cmp    $0x203000,%eax
  8000fe:	74 14                	je     800114 <_main+0xdc>
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	68 e0 1d 80 00       	push   $0x801de0
  800108:	6a 15                	push   $0x15
  80010a:	68 24 1e 80 00       	push   $0x801e24
  80010f:	e8 ad 03 00 00       	call   8004c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800114:	a1 20 30 80 00       	mov    0x803020,%eax
  800119:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80011f:	83 c0 60             	add    $0x60,%eax
  800122:	8b 00                	mov    (%eax),%eax
  800124:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80012f:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800134:	74 14                	je     80014a <_main+0x112>
  800136:	83 ec 04             	sub    $0x4,%esp
  800139:	68 e0 1d 80 00       	push   $0x801de0
  80013e:	6a 16                	push   $0x16
  800140:	68 24 1e 80 00       	push   $0x801e24
  800145:	e8 77 03 00 00       	call   8004c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80014a:	a1 20 30 80 00       	mov    0x803020,%eax
  80014f:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800155:	83 c0 78             	add    $0x78,%eax
  800158:	8b 00                	mov    (%eax),%eax
  80015a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80015d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800160:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800165:	3d 00 50 20 00       	cmp    $0x205000,%eax
  80016a:	74 14                	je     800180 <_main+0x148>
  80016c:	83 ec 04             	sub    $0x4,%esp
  80016f:	68 e0 1d 80 00       	push   $0x801de0
  800174:	6a 17                	push   $0x17
  800176:	68 24 1e 80 00       	push   $0x801e24
  80017b:	e8 41 03 00 00       	call   8004c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800180:	a1 20 30 80 00       	mov    0x803020,%eax
  800185:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80018b:	05 90 00 00 00       	add    $0x90,%eax
  800190:	8b 00                	mov    (%eax),%eax
  800192:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800195:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800198:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019d:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a2:	74 14                	je     8001b8 <_main+0x180>
  8001a4:	83 ec 04             	sub    $0x4,%esp
  8001a7:	68 e0 1d 80 00       	push   $0x801de0
  8001ac:	6a 18                	push   $0x18
  8001ae:	68 24 1e 80 00       	push   $0x801e24
  8001b3:	e8 09 03 00 00       	call   8004c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bd:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001c3:	05 a8 00 00 00       	add    $0xa8,%eax
  8001c8:	8b 00                	mov    (%eax),%eax
  8001ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d5:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001da:	74 14                	je     8001f0 <_main+0x1b8>
  8001dc:	83 ec 04             	sub    $0x4,%esp
  8001df:	68 e0 1d 80 00       	push   $0x801de0
  8001e4:	6a 19                	push   $0x19
  8001e6:	68 24 1e 80 00       	push   $0x801e24
  8001eb:	e8 d1 02 00 00       	call   8004c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f5:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001fb:	05 c0 00 00 00       	add    $0xc0,%eax
  800200:	8b 00                	mov    (%eax),%eax
  800202:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800205:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800208:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020d:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800212:	74 14                	je     800228 <_main+0x1f0>
  800214:	83 ec 04             	sub    $0x4,%esp
  800217:	68 e0 1d 80 00       	push   $0x801de0
  80021c:	6a 1a                	push   $0x1a
  80021e:	68 24 1e 80 00       	push   $0x801e24
  800223:	e8 99 02 00 00       	call   8004c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800228:	a1 20 30 80 00       	mov    0x803020,%eax
  80022d:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800233:	05 d8 00 00 00       	add    $0xd8,%eax
  800238:	8b 00                	mov    (%eax),%eax
  80023a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80023d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800240:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800245:	3d 00 30 80 00       	cmp    $0x803000,%eax
  80024a:	74 14                	je     800260 <_main+0x228>
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	68 e0 1d 80 00       	push   $0x801de0
  800254:	6a 1b                	push   $0x1b
  800256:	68 24 1e 80 00       	push   $0x801e24
  80025b:	e8 61 02 00 00       	call   8004c1 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800260:	a1 20 30 80 00       	mov    0x803020,%eax
  800265:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80026b:	05 f0 00 00 00       	add    $0xf0,%eax
  800270:	8b 00                	mov    (%eax),%eax
  800272:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800275:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800278:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027d:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800282:	74 14                	je     800298 <_main+0x260>
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	68 e0 1d 80 00       	push   $0x801de0
  80028c:	6a 1c                	push   $0x1c
  80028e:	68 24 1e 80 00       	push   $0x801e24
  800293:	e8 29 02 00 00       	call   8004c1 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  800298:	a1 20 30 80 00       	mov    0x803020,%eax
  80029d:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  8002a3:	85 c0                	test   %eax,%eax
  8002a5:	74 14                	je     8002bb <_main+0x283>
  8002a7:	83 ec 04             	sub    $0x4,%esp
  8002aa:	68 48 1e 80 00       	push   $0x801e48
  8002af:	6a 1d                	push   $0x1d
  8002b1:	68 24 1e 80 00       	push   $0x801e24
  8002b6:	e8 06 02 00 00       	call   8004c1 <_panic>
	}

	int freePages = sys_calculate_free_frames();
  8002bb:	e8 2b 13 00 00       	call   8015eb <sys_calculate_free_frames>
  8002c0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c3:	e8 c3 13 00 00       	call   80168b <sys_pf_calculate_allocated_pages>
  8002c8:	89 45 c0             	mov    %eax,-0x40(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  8002cb:	a0 5f e0 80 00       	mov    0x80e05f,%al
  8002d0:	88 45 bf             	mov    %al,-0x41(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  8002d3:	a0 5f f0 80 00       	mov    0x80f05f,%al
  8002d8:	88 45 be             	mov    %al,-0x42(%ebp)

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8002e2:	eb 37                	jmp    80031b <_main+0x2e3>
	{
		arr[i] = -1 ;
  8002e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e7:	05 60 30 80 00       	add    $0x803060,%eax
  8002ec:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		*ptr2 = *ptr ;
  8002ef:	a1 04 30 80 00       	mov    0x803004,%eax
  8002f4:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8002fa:	8a 12                	mov    (%edx),%dl
  8002fc:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  8002fe:	a1 00 30 80 00       	mov    0x803000,%eax
  800303:	40                   	inc    %eax
  800304:	a3 00 30 80 00       	mov    %eax,0x803000
  800309:	a1 04 30 80 00       	mov    0x803004,%eax
  80030e:	40                   	inc    %eax
  80030f:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1] ;
	char garbage2 = arr[PAGE_SIZE*12-1] ;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800314:	81 45 f4 00 08 00 00 	addl   $0x800,-0xc(%ebp)
  80031b:	81 7d f4 ff 9f 00 00 	cmpl   $0x9fff,-0xc(%ebp)
  800322:	7e c0                	jle    8002e4 <_main+0x2ac>

	//===================

	//cprintf("Checking Allocation in Mem & Page File... \n");
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800324:	e8 62 13 00 00       	call   80168b <sys_pf_calculate_allocated_pages>
  800329:	3b 45 c0             	cmp    -0x40(%ebp),%eax
  80032c:	74 14                	je     800342 <_main+0x30a>
  80032e:	83 ec 04             	sub    $0x4,%esp
  800331:	68 90 1e 80 00       	push   $0x801e90
  800336:	6a 38                	push   $0x38
  800338:	68 24 1e 80 00       	push   $0x801e24
  80033d:	e8 7f 01 00 00       	call   8004c1 <_panic>

		uint32 freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800342:	e8 a4 12 00 00       	call   8015eb <sys_calculate_free_frames>
  800347:	89 c3                	mov    %eax,%ebx
  800349:	e8 b6 12 00 00       	call   801604 <sys_calculate_modified_frames>
  80034e:	01 d8                	add    %ebx,%eax
  800350:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  800353:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800356:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800359:	74 14                	je     80036f <_main+0x337>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  80035b:	83 ec 04             	sub    $0x4,%esp
  80035e:	68 fc 1e 80 00       	push   $0x801efc
  800363:	6a 3c                	push   $0x3c
  800365:	68 24 1e 80 00       	push   $0x801e24
  80036a:	e8 52 01 00 00       	call   8004c1 <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [ALLOCATION] by REMOVING ONLY ONE PAGE is completed successfully.\n");
  80036f:	83 ec 0c             	sub    $0xc,%esp
  800372:	68 60 1f 80 00       	push   $0x801f60
  800377:	e8 f9 03 00 00       	call   800775 <cprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	return;
  80037f:	90                   	nop
}
  800380:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800383:	c9                   	leave  
  800384:	c3                   	ret    

00800385 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80038b:	e8 3b 15 00 00       	call   8018cb <sys_getenvindex>
  800390:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800393:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800396:	89 d0                	mov    %edx,%eax
  800398:	c1 e0 03             	shl    $0x3,%eax
  80039b:	01 d0                	add    %edx,%eax
  80039d:	01 c0                	add    %eax,%eax
  80039f:	01 d0                	add    %edx,%eax
  8003a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a8:	01 d0                	add    %edx,%eax
  8003aa:	c1 e0 04             	shl    $0x4,%eax
  8003ad:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003b2:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8003bc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003c2:	84 c0                	test   %al,%al
  8003c4:	74 0f                	je     8003d5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003c6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003cb:	05 5c 05 00 00       	add    $0x55c,%eax
  8003d0:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003d9:	7e 0a                	jle    8003e5 <libmain+0x60>
		binaryname = argv[0];
  8003db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003de:	8b 00                	mov    (%eax),%eax
  8003e0:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  8003e5:	83 ec 08             	sub    $0x8,%esp
  8003e8:	ff 75 0c             	pushl  0xc(%ebp)
  8003eb:	ff 75 08             	pushl  0x8(%ebp)
  8003ee:	e8 45 fc ff ff       	call   800038 <_main>
  8003f3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003f6:	e8 dd 12 00 00       	call   8016d8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003fb:	83 ec 0c             	sub    $0xc,%esp
  8003fe:	68 e4 1f 80 00       	push   $0x801fe4
  800403:	e8 6d 03 00 00       	call   800775 <cprintf>
  800408:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80040b:	a1 20 30 80 00       	mov    0x803020,%eax
  800410:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800416:	a1 20 30 80 00       	mov    0x803020,%eax
  80041b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800421:	83 ec 04             	sub    $0x4,%esp
  800424:	52                   	push   %edx
  800425:	50                   	push   %eax
  800426:	68 0c 20 80 00       	push   $0x80200c
  80042b:	e8 45 03 00 00       	call   800775 <cprintf>
  800430:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800433:	a1 20 30 80 00       	mov    0x803020,%eax
  800438:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80043e:	a1 20 30 80 00       	mov    0x803020,%eax
  800443:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800449:	a1 20 30 80 00       	mov    0x803020,%eax
  80044e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800454:	51                   	push   %ecx
  800455:	52                   	push   %edx
  800456:	50                   	push   %eax
  800457:	68 34 20 80 00       	push   $0x802034
  80045c:	e8 14 03 00 00       	call   800775 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800464:	a1 20 30 80 00       	mov    0x803020,%eax
  800469:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80046f:	83 ec 08             	sub    $0x8,%esp
  800472:	50                   	push   %eax
  800473:	68 8c 20 80 00       	push   $0x80208c
  800478:	e8 f8 02 00 00       	call   800775 <cprintf>
  80047d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800480:	83 ec 0c             	sub    $0xc,%esp
  800483:	68 e4 1f 80 00       	push   $0x801fe4
  800488:	e8 e8 02 00 00       	call   800775 <cprintf>
  80048d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800490:	e8 5d 12 00 00       	call   8016f2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800495:	e8 19 00 00 00       	call   8004b3 <exit>
}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004a3:	83 ec 0c             	sub    $0xc,%esp
  8004a6:	6a 00                	push   $0x0
  8004a8:	e8 ea 13 00 00       	call   801897 <sys_destroy_env>
  8004ad:	83 c4 10             	add    $0x10,%esp
}
  8004b0:	90                   	nop
  8004b1:	c9                   	leave  
  8004b2:	c3                   	ret    

008004b3 <exit>:

void
exit(void)
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004b9:	e8 3f 14 00 00       	call   8018fd <sys_exit_env>
}
  8004be:	90                   	nop
  8004bf:	c9                   	leave  
  8004c0:	c3                   	ret    

008004c1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004c1:	55                   	push   %ebp
  8004c2:	89 e5                	mov    %esp,%ebp
  8004c4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004c7:	8d 45 10             	lea    0x10(%ebp),%eax
  8004ca:	83 c0 04             	add    $0x4,%eax
  8004cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004d0:	a1 5c f1 80 00       	mov    0x80f15c,%eax
  8004d5:	85 c0                	test   %eax,%eax
  8004d7:	74 16                	je     8004ef <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004d9:	a1 5c f1 80 00       	mov    0x80f15c,%eax
  8004de:	83 ec 08             	sub    $0x8,%esp
  8004e1:	50                   	push   %eax
  8004e2:	68 a0 20 80 00       	push   $0x8020a0
  8004e7:	e8 89 02 00 00       	call   800775 <cprintf>
  8004ec:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004ef:	a1 08 30 80 00       	mov    0x803008,%eax
  8004f4:	ff 75 0c             	pushl  0xc(%ebp)
  8004f7:	ff 75 08             	pushl  0x8(%ebp)
  8004fa:	50                   	push   %eax
  8004fb:	68 a5 20 80 00       	push   $0x8020a5
  800500:	e8 70 02 00 00       	call   800775 <cprintf>
  800505:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800508:	8b 45 10             	mov    0x10(%ebp),%eax
  80050b:	83 ec 08             	sub    $0x8,%esp
  80050e:	ff 75 f4             	pushl  -0xc(%ebp)
  800511:	50                   	push   %eax
  800512:	e8 f3 01 00 00       	call   80070a <vcprintf>
  800517:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80051a:	83 ec 08             	sub    $0x8,%esp
  80051d:	6a 00                	push   $0x0
  80051f:	68 c1 20 80 00       	push   $0x8020c1
  800524:	e8 e1 01 00 00       	call   80070a <vcprintf>
  800529:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80052c:	e8 82 ff ff ff       	call   8004b3 <exit>

	// should not return here
	while (1) ;
  800531:	eb fe                	jmp    800531 <_panic+0x70>

00800533 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800539:	a1 20 30 80 00       	mov    0x803020,%eax
  80053e:	8b 50 74             	mov    0x74(%eax),%edx
  800541:	8b 45 0c             	mov    0xc(%ebp),%eax
  800544:	39 c2                	cmp    %eax,%edx
  800546:	74 14                	je     80055c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800548:	83 ec 04             	sub    $0x4,%esp
  80054b:	68 c4 20 80 00       	push   $0x8020c4
  800550:	6a 26                	push   $0x26
  800552:	68 10 21 80 00       	push   $0x802110
  800557:	e8 65 ff ff ff       	call   8004c1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80055c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800563:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80056a:	e9 c2 00 00 00       	jmp    800631 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80056f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800572:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	01 d0                	add    %edx,%eax
  80057e:	8b 00                	mov    (%eax),%eax
  800580:	85 c0                	test   %eax,%eax
  800582:	75 08                	jne    80058c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800584:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800587:	e9 a2 00 00 00       	jmp    80062e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80058c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800593:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80059a:	eb 69                	jmp    800605 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80059c:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005aa:	89 d0                	mov    %edx,%eax
  8005ac:	01 c0                	add    %eax,%eax
  8005ae:	01 d0                	add    %edx,%eax
  8005b0:	c1 e0 03             	shl    $0x3,%eax
  8005b3:	01 c8                	add    %ecx,%eax
  8005b5:	8a 40 04             	mov    0x4(%eax),%al
  8005b8:	84 c0                	test   %al,%al
  8005ba:	75 46                	jne    800602 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005bc:	a1 20 30 80 00       	mov    0x803020,%eax
  8005c1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005ca:	89 d0                	mov    %edx,%eax
  8005cc:	01 c0                	add    %eax,%eax
  8005ce:	01 d0                	add    %edx,%eax
  8005d0:	c1 e0 03             	shl    $0x3,%eax
  8005d3:	01 c8                	add    %ecx,%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f1:	01 c8                	add    %ecx,%eax
  8005f3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005f5:	39 c2                	cmp    %eax,%edx
  8005f7:	75 09                	jne    800602 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005f9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800600:	eb 12                	jmp    800614 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800602:	ff 45 e8             	incl   -0x18(%ebp)
  800605:	a1 20 30 80 00       	mov    0x803020,%eax
  80060a:	8b 50 74             	mov    0x74(%eax),%edx
  80060d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800610:	39 c2                	cmp    %eax,%edx
  800612:	77 88                	ja     80059c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800614:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800618:	75 14                	jne    80062e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80061a:	83 ec 04             	sub    $0x4,%esp
  80061d:	68 1c 21 80 00       	push   $0x80211c
  800622:	6a 3a                	push   $0x3a
  800624:	68 10 21 80 00       	push   $0x802110
  800629:	e8 93 fe ff ff       	call   8004c1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80062e:	ff 45 f0             	incl   -0x10(%ebp)
  800631:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800634:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800637:	0f 8c 32 ff ff ff    	jl     80056f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80063d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800644:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80064b:	eb 26                	jmp    800673 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80064d:	a1 20 30 80 00       	mov    0x803020,%eax
  800652:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800658:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80065b:	89 d0                	mov    %edx,%eax
  80065d:	01 c0                	add    %eax,%eax
  80065f:	01 d0                	add    %edx,%eax
  800661:	c1 e0 03             	shl    $0x3,%eax
  800664:	01 c8                	add    %ecx,%eax
  800666:	8a 40 04             	mov    0x4(%eax),%al
  800669:	3c 01                	cmp    $0x1,%al
  80066b:	75 03                	jne    800670 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80066d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800670:	ff 45 e0             	incl   -0x20(%ebp)
  800673:	a1 20 30 80 00       	mov    0x803020,%eax
  800678:	8b 50 74             	mov    0x74(%eax),%edx
  80067b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80067e:	39 c2                	cmp    %eax,%edx
  800680:	77 cb                	ja     80064d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800685:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800688:	74 14                	je     80069e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80068a:	83 ec 04             	sub    $0x4,%esp
  80068d:	68 70 21 80 00       	push   $0x802170
  800692:	6a 44                	push   $0x44
  800694:	68 10 21 80 00       	push   $0x802110
  800699:	e8 23 fe ff ff       	call   8004c1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80069e:	90                   	nop
  80069f:	c9                   	leave  
  8006a0:	c3                   	ret    

008006a1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006a1:	55                   	push   %ebp
  8006a2:	89 e5                	mov    %esp,%ebp
  8006a4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006aa:	8b 00                	mov    (%eax),%eax
  8006ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8006af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b2:	89 0a                	mov    %ecx,(%edx)
  8006b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8006b7:	88 d1                	mov    %dl,%cl
  8006b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006bc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006ca:	75 2c                	jne    8006f8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006cc:	a0 24 30 80 00       	mov    0x803024,%al
  8006d1:	0f b6 c0             	movzbl %al,%eax
  8006d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d7:	8b 12                	mov    (%edx),%edx
  8006d9:	89 d1                	mov    %edx,%ecx
  8006db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006de:	83 c2 08             	add    $0x8,%edx
  8006e1:	83 ec 04             	sub    $0x4,%esp
  8006e4:	50                   	push   %eax
  8006e5:	51                   	push   %ecx
  8006e6:	52                   	push   %edx
  8006e7:	e8 3e 0e 00 00       	call   80152a <sys_cputs>
  8006ec:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fb:	8b 40 04             	mov    0x4(%eax),%eax
  8006fe:	8d 50 01             	lea    0x1(%eax),%edx
  800701:	8b 45 0c             	mov    0xc(%ebp),%eax
  800704:	89 50 04             	mov    %edx,0x4(%eax)
}
  800707:	90                   	nop
  800708:	c9                   	leave  
  800709:	c3                   	ret    

0080070a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80070a:	55                   	push   %ebp
  80070b:	89 e5                	mov    %esp,%ebp
  80070d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800713:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80071a:	00 00 00 
	b.cnt = 0;
  80071d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800724:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800727:	ff 75 0c             	pushl  0xc(%ebp)
  80072a:	ff 75 08             	pushl  0x8(%ebp)
  80072d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800733:	50                   	push   %eax
  800734:	68 a1 06 80 00       	push   $0x8006a1
  800739:	e8 11 02 00 00       	call   80094f <vprintfmt>
  80073e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800741:	a0 24 30 80 00       	mov    0x803024,%al
  800746:	0f b6 c0             	movzbl %al,%eax
  800749:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80074f:	83 ec 04             	sub    $0x4,%esp
  800752:	50                   	push   %eax
  800753:	52                   	push   %edx
  800754:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80075a:	83 c0 08             	add    $0x8,%eax
  80075d:	50                   	push   %eax
  80075e:	e8 c7 0d 00 00       	call   80152a <sys_cputs>
  800763:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800766:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80076d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800773:	c9                   	leave  
  800774:	c3                   	ret    

00800775 <cprintf>:

int cprintf(const char *fmt, ...) {
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80077b:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800782:	8d 45 0c             	lea    0xc(%ebp),%eax
  800785:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	ff 75 f4             	pushl  -0xc(%ebp)
  800791:	50                   	push   %eax
  800792:	e8 73 ff ff ff       	call   80070a <vcprintf>
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80079d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a0:	c9                   	leave  
  8007a1:	c3                   	ret    

008007a2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a8:	e8 2b 0f 00 00       	call   8016d8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007ad:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007bc:	50                   	push   %eax
  8007bd:	e8 48 ff ff ff       	call   80070a <vcprintf>
  8007c2:	83 c4 10             	add    $0x10,%esp
  8007c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007c8:	e8 25 0f 00 00       	call   8016f2 <sys_enable_interrupt>
	return cnt;
  8007cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d0:	c9                   	leave  
  8007d1:	c3                   	ret    

008007d2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	53                   	push   %ebx
  8007d6:	83 ec 14             	sub    $0x14,%esp
  8007d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ed:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f0:	77 55                	ja     800847 <printnum+0x75>
  8007f2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007f5:	72 05                	jb     8007fc <printnum+0x2a>
  8007f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007fa:	77 4b                	ja     800847 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007fc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007ff:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800802:	8b 45 18             	mov    0x18(%ebp),%eax
  800805:	ba 00 00 00 00       	mov    $0x0,%edx
  80080a:	52                   	push   %edx
  80080b:	50                   	push   %eax
  80080c:	ff 75 f4             	pushl  -0xc(%ebp)
  80080f:	ff 75 f0             	pushl  -0x10(%ebp)
  800812:	e8 49 13 00 00       	call   801b60 <__udivdi3>
  800817:	83 c4 10             	add    $0x10,%esp
  80081a:	83 ec 04             	sub    $0x4,%esp
  80081d:	ff 75 20             	pushl  0x20(%ebp)
  800820:	53                   	push   %ebx
  800821:	ff 75 18             	pushl  0x18(%ebp)
  800824:	52                   	push   %edx
  800825:	50                   	push   %eax
  800826:	ff 75 0c             	pushl  0xc(%ebp)
  800829:	ff 75 08             	pushl  0x8(%ebp)
  80082c:	e8 a1 ff ff ff       	call   8007d2 <printnum>
  800831:	83 c4 20             	add    $0x20,%esp
  800834:	eb 1a                	jmp    800850 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800836:	83 ec 08             	sub    $0x8,%esp
  800839:	ff 75 0c             	pushl  0xc(%ebp)
  80083c:	ff 75 20             	pushl  0x20(%ebp)
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	ff d0                	call   *%eax
  800844:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800847:	ff 4d 1c             	decl   0x1c(%ebp)
  80084a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80084e:	7f e6                	jg     800836 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800850:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800853:	bb 00 00 00 00       	mov    $0x0,%ebx
  800858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80085e:	53                   	push   %ebx
  80085f:	51                   	push   %ecx
  800860:	52                   	push   %edx
  800861:	50                   	push   %eax
  800862:	e8 09 14 00 00       	call   801c70 <__umoddi3>
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	05 d4 23 80 00       	add    $0x8023d4,%eax
  80086f:	8a 00                	mov    (%eax),%al
  800871:	0f be c0             	movsbl %al,%eax
  800874:	83 ec 08             	sub    $0x8,%esp
  800877:	ff 75 0c             	pushl  0xc(%ebp)
  80087a:	50                   	push   %eax
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	ff d0                	call   *%eax
  800880:	83 c4 10             	add    $0x10,%esp
}
  800883:	90                   	nop
  800884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800887:	c9                   	leave  
  800888:	c3                   	ret    

00800889 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80088c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800890:	7e 1c                	jle    8008ae <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800892:	8b 45 08             	mov    0x8(%ebp),%eax
  800895:	8b 00                	mov    (%eax),%eax
  800897:	8d 50 08             	lea    0x8(%eax),%edx
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	89 10                	mov    %edx,(%eax)
  80089f:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a2:	8b 00                	mov    (%eax),%eax
  8008a4:	83 e8 08             	sub    $0x8,%eax
  8008a7:	8b 50 04             	mov    0x4(%eax),%edx
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	eb 40                	jmp    8008ee <getuint+0x65>
	else if (lflag)
  8008ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b2:	74 1e                	je     8008d2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	8d 50 04             	lea    0x4(%eax),%edx
  8008bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bf:	89 10                	mov    %edx,(%eax)
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	83 e8 04             	sub    $0x4,%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d0:	eb 1c                	jmp    8008ee <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d5:	8b 00                	mov    (%eax),%eax
  8008d7:	8d 50 04             	lea    0x4(%eax),%edx
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	89 10                	mov    %edx,(%eax)
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	83 e8 04             	sub    $0x4,%eax
  8008e7:	8b 00                	mov    (%eax),%eax
  8008e9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    

008008f0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f7:	7e 1c                	jle    800915 <getint+0x25>
		return va_arg(*ap, long long);
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	8d 50 08             	lea    0x8(%eax),%edx
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	89 10                	mov    %edx,(%eax)
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	83 e8 08             	sub    $0x8,%eax
  80090e:	8b 50 04             	mov    0x4(%eax),%edx
  800911:	8b 00                	mov    (%eax),%eax
  800913:	eb 38                	jmp    80094d <getint+0x5d>
	else if (lflag)
  800915:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800919:	74 1a                	je     800935 <getint+0x45>
		return va_arg(*ap, long);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 04             	lea    0x4(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 04             	sub    $0x4,%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	99                   	cltd   
  800933:	eb 18                	jmp    80094d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	8d 50 04             	lea    0x4(%eax),%edx
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	89 10                	mov    %edx,(%eax)
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	83 e8 04             	sub    $0x4,%eax
  80094a:	8b 00                	mov    (%eax),%eax
  80094c:	99                   	cltd   
}
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	56                   	push   %esi
  800953:	53                   	push   %ebx
  800954:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800957:	eb 17                	jmp    800970 <vprintfmt+0x21>
			if (ch == '\0')
  800959:	85 db                	test   %ebx,%ebx
  80095b:	0f 84 af 03 00 00    	je     800d10 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	53                   	push   %ebx
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	ff d0                	call   *%eax
  80096d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800970:	8b 45 10             	mov    0x10(%ebp),%eax
  800973:	8d 50 01             	lea    0x1(%eax),%edx
  800976:	89 55 10             	mov    %edx,0x10(%ebp)
  800979:	8a 00                	mov    (%eax),%al
  80097b:	0f b6 d8             	movzbl %al,%ebx
  80097e:	83 fb 25             	cmp    $0x25,%ebx
  800981:	75 d6                	jne    800959 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800983:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800987:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80098e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800995:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80099c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a6:	8d 50 01             	lea    0x1(%eax),%edx
  8009a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8009ac:	8a 00                	mov    (%eax),%al
  8009ae:	0f b6 d8             	movzbl %al,%ebx
  8009b1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009b4:	83 f8 55             	cmp    $0x55,%eax
  8009b7:	0f 87 2b 03 00 00    	ja     800ce8 <vprintfmt+0x399>
  8009bd:	8b 04 85 f8 23 80 00 	mov    0x8023f8(,%eax,4),%eax
  8009c4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009ca:	eb d7                	jmp    8009a3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009cc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009d0:	eb d1                	jmp    8009a3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	c1 e0 02             	shl    $0x2,%eax
  8009e1:	01 d0                	add    %edx,%eax
  8009e3:	01 c0                	add    %eax,%eax
  8009e5:	01 d8                	add    %ebx,%eax
  8009e7:	83 e8 30             	sub    $0x30,%eax
  8009ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f0:	8a 00                	mov    (%eax),%al
  8009f2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009f5:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f8:	7e 3e                	jle    800a38 <vprintfmt+0xe9>
  8009fa:	83 fb 39             	cmp    $0x39,%ebx
  8009fd:	7f 39                	jg     800a38 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ff:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a02:	eb d5                	jmp    8009d9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	83 c0 04             	add    $0x4,%eax
  800a0a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	83 e8 04             	sub    $0x4,%eax
  800a13:	8b 00                	mov    (%eax),%eax
  800a15:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a18:	eb 1f                	jmp    800a39 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a1e:	79 83                	jns    8009a3 <vprintfmt+0x54>
				width = 0;
  800a20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a27:	e9 77 ff ff ff       	jmp    8009a3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a2c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a33:	e9 6b ff ff ff       	jmp    8009a3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a38:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3d:	0f 89 60 ff ff ff    	jns    8009a3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a49:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a50:	e9 4e ff ff ff       	jmp    8009a3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a55:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a58:	e9 46 ff ff ff       	jmp    8009a3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a60:	83 c0 04             	add    $0x4,%eax
  800a63:	89 45 14             	mov    %eax,0x14(%ebp)
  800a66:	8b 45 14             	mov    0x14(%ebp),%eax
  800a69:	83 e8 04             	sub    $0x4,%eax
  800a6c:	8b 00                	mov    (%eax),%eax
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	50                   	push   %eax
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	ff d0                	call   *%eax
  800a7a:	83 c4 10             	add    $0x10,%esp
			break;
  800a7d:	e9 89 02 00 00       	jmp    800d0b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a82:	8b 45 14             	mov    0x14(%ebp),%eax
  800a85:	83 c0 04             	add    $0x4,%eax
  800a88:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8e:	83 e8 04             	sub    $0x4,%eax
  800a91:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a93:	85 db                	test   %ebx,%ebx
  800a95:	79 02                	jns    800a99 <vprintfmt+0x14a>
				err = -err;
  800a97:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a99:	83 fb 64             	cmp    $0x64,%ebx
  800a9c:	7f 0b                	jg     800aa9 <vprintfmt+0x15a>
  800a9e:	8b 34 9d 40 22 80 00 	mov    0x802240(,%ebx,4),%esi
  800aa5:	85 f6                	test   %esi,%esi
  800aa7:	75 19                	jne    800ac2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa9:	53                   	push   %ebx
  800aaa:	68 e5 23 80 00       	push   $0x8023e5
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	ff 75 08             	pushl  0x8(%ebp)
  800ab5:	e8 5e 02 00 00       	call   800d18 <printfmt>
  800aba:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800abd:	e9 49 02 00 00       	jmp    800d0b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ac2:	56                   	push   %esi
  800ac3:	68 ee 23 80 00       	push   $0x8023ee
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	ff 75 08             	pushl  0x8(%ebp)
  800ace:	e8 45 02 00 00       	call   800d18 <printfmt>
  800ad3:	83 c4 10             	add    $0x10,%esp
			break;
  800ad6:	e9 30 02 00 00       	jmp    800d0b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800adb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ade:	83 c0 04             	add    $0x4,%eax
  800ae1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae7:	83 e8 04             	sub    $0x4,%eax
  800aea:	8b 30                	mov    (%eax),%esi
  800aec:	85 f6                	test   %esi,%esi
  800aee:	75 05                	jne    800af5 <vprintfmt+0x1a6>
				p = "(null)";
  800af0:	be f1 23 80 00       	mov    $0x8023f1,%esi
			if (width > 0 && padc != '-')
  800af5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af9:	7e 6d                	jle    800b68 <vprintfmt+0x219>
  800afb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800aff:	74 67                	je     800b68 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	50                   	push   %eax
  800b08:	56                   	push   %esi
  800b09:	e8 0c 03 00 00       	call   800e1a <strnlen>
  800b0e:	83 c4 10             	add    $0x10,%esp
  800b11:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b14:	eb 16                	jmp    800b2c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b16:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b1a:	83 ec 08             	sub    $0x8,%esp
  800b1d:	ff 75 0c             	pushl  0xc(%ebp)
  800b20:	50                   	push   %eax
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	ff d0                	call   *%eax
  800b26:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b29:	ff 4d e4             	decl   -0x1c(%ebp)
  800b2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b30:	7f e4                	jg     800b16 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b32:	eb 34                	jmp    800b68 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b34:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b38:	74 1c                	je     800b56 <vprintfmt+0x207>
  800b3a:	83 fb 1f             	cmp    $0x1f,%ebx
  800b3d:	7e 05                	jle    800b44 <vprintfmt+0x1f5>
  800b3f:	83 fb 7e             	cmp    $0x7e,%ebx
  800b42:	7e 12                	jle    800b56 <vprintfmt+0x207>
					putch('?', putdat);
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	6a 3f                	push   $0x3f
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	ff d0                	call   *%eax
  800b51:	83 c4 10             	add    $0x10,%esp
  800b54:	eb 0f                	jmp    800b65 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b56:	83 ec 08             	sub    $0x8,%esp
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	53                   	push   %ebx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
  800b62:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b65:	ff 4d e4             	decl   -0x1c(%ebp)
  800b68:	89 f0                	mov    %esi,%eax
  800b6a:	8d 70 01             	lea    0x1(%eax),%esi
  800b6d:	8a 00                	mov    (%eax),%al
  800b6f:	0f be d8             	movsbl %al,%ebx
  800b72:	85 db                	test   %ebx,%ebx
  800b74:	74 24                	je     800b9a <vprintfmt+0x24b>
  800b76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7a:	78 b8                	js     800b34 <vprintfmt+0x1e5>
  800b7c:	ff 4d e0             	decl   -0x20(%ebp)
  800b7f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b83:	79 af                	jns    800b34 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b85:	eb 13                	jmp    800b9a <vprintfmt+0x24b>
				putch(' ', putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	6a 20                	push   $0x20
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	ff d0                	call   *%eax
  800b94:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b97:	ff 4d e4             	decl   -0x1c(%ebp)
  800b9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9e:	7f e7                	jg     800b87 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ba0:	e9 66 01 00 00       	jmp    800d0b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 e8             	pushl  -0x18(%ebp)
  800bab:	8d 45 14             	lea    0x14(%ebp),%eax
  800bae:	50                   	push   %eax
  800baf:	e8 3c fd ff ff       	call   8008f0 <getint>
  800bb4:	83 c4 10             	add    $0x10,%esp
  800bb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc3:	85 d2                	test   %edx,%edx
  800bc5:	79 23                	jns    800bea <vprintfmt+0x29b>
				putch('-', putdat);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	6a 2d                	push   $0x2d
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	ff d0                	call   *%eax
  800bd4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bdd:	f7 d8                	neg    %eax
  800bdf:	83 d2 00             	adc    $0x0,%edx
  800be2:	f7 da                	neg    %edx
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bf1:	e9 bc 00 00 00       	jmp    800cb2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bfc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bff:	50                   	push   %eax
  800c00:	e8 84 fc ff ff       	call   800889 <getuint>
  800c05:	83 c4 10             	add    $0x10,%esp
  800c08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c0e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c15:	e9 98 00 00 00       	jmp    800cb2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c1a:	83 ec 08             	sub    $0x8,%esp
  800c1d:	ff 75 0c             	pushl  0xc(%ebp)
  800c20:	6a 58                	push   $0x58
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	ff d0                	call   *%eax
  800c27:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c2a:	83 ec 08             	sub    $0x8,%esp
  800c2d:	ff 75 0c             	pushl  0xc(%ebp)
  800c30:	6a 58                	push   $0x58
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	ff d0                	call   *%eax
  800c37:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	ff 75 0c             	pushl  0xc(%ebp)
  800c40:	6a 58                	push   $0x58
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
			break;
  800c4a:	e9 bc 00 00 00       	jmp    800d0b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 30                	push   $0x30
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	6a 78                	push   $0x78
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c72:	83 c0 04             	add    $0x4,%eax
  800c75:	89 45 14             	mov    %eax,0x14(%ebp)
  800c78:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7b:	83 e8 04             	sub    $0x4,%eax
  800c7e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c8a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c91:	eb 1f                	jmp    800cb2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 e8             	pushl  -0x18(%ebp)
  800c99:	8d 45 14             	lea    0x14(%ebp),%eax
  800c9c:	50                   	push   %eax
  800c9d:	e8 e7 fb ff ff       	call   800889 <getuint>
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cab:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cb2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb9:	83 ec 04             	sub    $0x4,%esp
  800cbc:	52                   	push   %edx
  800cbd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	ff 75 f4             	pushl  -0xc(%ebp)
  800cc4:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc7:	ff 75 0c             	pushl  0xc(%ebp)
  800cca:	ff 75 08             	pushl  0x8(%ebp)
  800ccd:	e8 00 fb ff ff       	call   8007d2 <printnum>
  800cd2:	83 c4 20             	add    $0x20,%esp
			break;
  800cd5:	eb 34                	jmp    800d0b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd7:	83 ec 08             	sub    $0x8,%esp
  800cda:	ff 75 0c             	pushl  0xc(%ebp)
  800cdd:	53                   	push   %ebx
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	ff d0                	call   *%eax
  800ce3:	83 c4 10             	add    $0x10,%esp
			break;
  800ce6:	eb 23                	jmp    800d0b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ce8:	83 ec 08             	sub    $0x8,%esp
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	6a 25                	push   $0x25
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	ff d0                	call   *%eax
  800cf5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cf8:	ff 4d 10             	decl   0x10(%ebp)
  800cfb:	eb 03                	jmp    800d00 <vprintfmt+0x3b1>
  800cfd:	ff 4d 10             	decl   0x10(%ebp)
  800d00:	8b 45 10             	mov    0x10(%ebp),%eax
  800d03:	48                   	dec    %eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	3c 25                	cmp    $0x25,%al
  800d08:	75 f3                	jne    800cfd <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d0a:	90                   	nop
		}
	}
  800d0b:	e9 47 fc ff ff       	jmp    800957 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d10:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d11:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d14:	5b                   	pop    %ebx
  800d15:	5e                   	pop    %esi
  800d16:	5d                   	pop    %ebp
  800d17:	c3                   	ret    

00800d18 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d1e:	8d 45 10             	lea    0x10(%ebp),%eax
  800d21:	83 c0 04             	add    $0x4,%eax
  800d24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d27:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d2d:	50                   	push   %eax
  800d2e:	ff 75 0c             	pushl  0xc(%ebp)
  800d31:	ff 75 08             	pushl  0x8(%ebp)
  800d34:	e8 16 fc ff ff       	call   80094f <vprintfmt>
  800d39:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d3c:	90                   	nop
  800d3d:	c9                   	leave  
  800d3e:	c3                   	ret    

00800d3f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	8b 40 08             	mov    0x8(%eax),%eax
  800d48:	8d 50 01             	lea    0x1(%eax),%edx
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d54:	8b 10                	mov    (%eax),%edx
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	8b 40 04             	mov    0x4(%eax),%eax
  800d5c:	39 c2                	cmp    %eax,%edx
  800d5e:	73 12                	jae    800d72 <sprintputch+0x33>
		*b->buf++ = ch;
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	8b 00                	mov    (%eax),%eax
  800d65:	8d 48 01             	lea    0x1(%eax),%ecx
  800d68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6b:	89 0a                	mov    %ecx,(%edx)
  800d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d70:	88 10                	mov    %dl,(%eax)
}
  800d72:	90                   	nop
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	01 d0                	add    %edx,%eax
  800d8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d9a:	74 06                	je     800da2 <vsnprintf+0x2d>
  800d9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da0:	7f 07                	jg     800da9 <vsnprintf+0x34>
		return -E_INVAL;
  800da2:	b8 03 00 00 00       	mov    $0x3,%eax
  800da7:	eb 20                	jmp    800dc9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800da9:	ff 75 14             	pushl  0x14(%ebp)
  800dac:	ff 75 10             	pushl  0x10(%ebp)
  800daf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800db2:	50                   	push   %eax
  800db3:	68 3f 0d 80 00       	push   $0x800d3f
  800db8:	e8 92 fb ff ff       	call   80094f <vprintfmt>
  800dbd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dc3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dc9:	c9                   	leave  
  800dca:	c3                   	ret    

00800dcb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dd1:	8d 45 10             	lea    0x10(%ebp),%eax
  800dd4:	83 c0 04             	add    $0x4,%eax
  800dd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dda:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddd:	ff 75 f4             	pushl  -0xc(%ebp)
  800de0:	50                   	push   %eax
  800de1:	ff 75 0c             	pushl  0xc(%ebp)
  800de4:	ff 75 08             	pushl  0x8(%ebp)
  800de7:	e8 89 ff ff ff       	call   800d75 <vsnprintf>
  800dec:	83 c4 10             	add    $0x10,%esp
  800def:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800df5:	c9                   	leave  
  800df6:	c3                   	ret    

00800df7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dfd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e04:	eb 06                	jmp    800e0c <strlen+0x15>
		n++;
  800e06:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e09:	ff 45 08             	incl   0x8(%ebp)
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8a 00                	mov    (%eax),%al
  800e11:	84 c0                	test   %al,%al
  800e13:	75 f1                	jne    800e06 <strlen+0xf>
		n++;
	return n;
  800e15:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e18:	c9                   	leave  
  800e19:	c3                   	ret    

00800e1a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e27:	eb 09                	jmp    800e32 <strnlen+0x18>
		n++;
  800e29:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e2c:	ff 45 08             	incl   0x8(%ebp)
  800e2f:	ff 4d 0c             	decl   0xc(%ebp)
  800e32:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e36:	74 09                	je     800e41 <strnlen+0x27>
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	84 c0                	test   %al,%al
  800e3f:	75 e8                	jne    800e29 <strnlen+0xf>
		n++;
	return n;
  800e41:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e52:	90                   	nop
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8d 50 01             	lea    0x1(%eax),%edx
  800e59:	89 55 08             	mov    %edx,0x8(%ebp)
  800e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e62:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e65:	8a 12                	mov    (%edx),%dl
  800e67:	88 10                	mov    %dl,(%eax)
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	84 c0                	test   %al,%al
  800e6d:	75 e4                	jne    800e53 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e72:	c9                   	leave  
  800e73:	c3                   	ret    

00800e74 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e87:	eb 1f                	jmp    800ea8 <strncpy+0x34>
		*dst++ = *src;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8d 50 01             	lea    0x1(%eax),%edx
  800e8f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e95:	8a 12                	mov    (%edx),%dl
  800e97:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9c:	8a 00                	mov    (%eax),%al
  800e9e:	84 c0                	test   %al,%al
  800ea0:	74 03                	je     800ea5 <strncpy+0x31>
			src++;
  800ea2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ea5:	ff 45 fc             	incl   -0x4(%ebp)
  800ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eab:	3b 45 10             	cmp    0x10(%ebp),%eax
  800eae:	72 d9                	jb     800e89 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eb3:	c9                   	leave  
  800eb4:	c3                   	ret    

00800eb5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ec1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ec5:	74 30                	je     800ef7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ec7:	eb 16                	jmp    800edf <strlcpy+0x2a>
			*dst++ = *src++;
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	8d 50 01             	lea    0x1(%eax),%edx
  800ecf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800edb:	8a 12                	mov    (%edx),%dl
  800edd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800edf:	ff 4d 10             	decl   0x10(%ebp)
  800ee2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee6:	74 09                	je     800ef1 <strlcpy+0x3c>
  800ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	84 c0                	test   %al,%al
  800eef:	75 d8                	jne    800ec9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ef7:	8b 55 08             	mov    0x8(%ebp),%edx
  800efa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800efd:	29 c2                	sub    %eax,%edx
  800eff:	89 d0                	mov    %edx,%eax
}
  800f01:	c9                   	leave  
  800f02:	c3                   	ret    

00800f03 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f06:	eb 06                	jmp    800f0e <strcmp+0xb>
		p++, q++;
  800f08:	ff 45 08             	incl   0x8(%ebp)
  800f0b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	84 c0                	test   %al,%al
  800f15:	74 0e                	je     800f25 <strcmp+0x22>
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 10                	mov    (%eax),%dl
  800f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	38 c2                	cmp    %al,%dl
  800f23:	74 e3                	je     800f08 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f25:	8b 45 08             	mov    0x8(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	0f b6 d0             	movzbl %al,%edx
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	0f b6 c0             	movzbl %al,%eax
  800f35:	29 c2                	sub    %eax,%edx
  800f37:	89 d0                	mov    %edx,%eax
}
  800f39:	5d                   	pop    %ebp
  800f3a:	c3                   	ret    

00800f3b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f3e:	eb 09                	jmp    800f49 <strncmp+0xe>
		n--, p++, q++;
  800f40:	ff 4d 10             	decl   0x10(%ebp)
  800f43:	ff 45 08             	incl   0x8(%ebp)
  800f46:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4d:	74 17                	je     800f66 <strncmp+0x2b>
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	84 c0                	test   %al,%al
  800f56:	74 0e                	je     800f66 <strncmp+0x2b>
  800f58:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5b:	8a 10                	mov    (%eax),%dl
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	8a 00                	mov    (%eax),%al
  800f62:	38 c2                	cmp    %al,%dl
  800f64:	74 da                	je     800f40 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6a:	75 07                	jne    800f73 <strncmp+0x38>
		return 0;
  800f6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f71:	eb 14                	jmp    800f87 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	0f b6 d0             	movzbl %al,%edx
  800f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	0f b6 c0             	movzbl %al,%eax
  800f83:	29 c2                	sub    %eax,%edx
  800f85:	89 d0                	mov    %edx,%eax
}
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    

00800f89 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	83 ec 04             	sub    $0x4,%esp
  800f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f92:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f95:	eb 12                	jmp    800fa9 <strchr+0x20>
		if (*s == c)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f9f:	75 05                	jne    800fa6 <strchr+0x1d>
			return (char *) s;
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	eb 11                	jmp    800fb7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fa6:	ff 45 08             	incl   0x8(%ebp)
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	84 c0                	test   %al,%al
  800fb0:	75 e5                	jne    800f97 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb7:	c9                   	leave  
  800fb8:	c3                   	ret    

00800fb9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	83 ec 04             	sub    $0x4,%esp
  800fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc5:	eb 0d                	jmp    800fd4 <strfind+0x1b>
		if (*s == c)
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fcf:	74 0e                	je     800fdf <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fd1:	ff 45 08             	incl   0x8(%ebp)
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	84 c0                	test   %al,%al
  800fdb:	75 ea                	jne    800fc7 <strfind+0xe>
  800fdd:	eb 01                	jmp    800fe0 <strfind+0x27>
		if (*s == c)
			break;
  800fdf:	90                   	nop
	return (char *) s;
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fe3:	c9                   	leave  
  800fe4:	c3                   	ret    

00800fe5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ff1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ff7:	eb 0e                	jmp    801007 <memset+0x22>
		*p++ = c;
  800ff9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ffc:	8d 50 01             	lea    0x1(%eax),%edx
  800fff:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801002:	8b 55 0c             	mov    0xc(%ebp),%edx
  801005:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801007:	ff 4d f8             	decl   -0x8(%ebp)
  80100a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80100e:	79 e9                	jns    800ff9 <memset+0x14>
		*p++ = c;

	return v;
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801013:	c9                   	leave  
  801014:	c3                   	ret    

00801015 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
  801024:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801027:	eb 16                	jmp    80103f <memcpy+0x2a>
		*d++ = *s++;
  801029:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102c:	8d 50 01             	lea    0x1(%eax),%edx
  80102f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801032:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801035:	8d 4a 01             	lea    0x1(%edx),%ecx
  801038:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80103b:	8a 12                	mov    (%edx),%dl
  80103d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	8d 50 ff             	lea    -0x1(%eax),%edx
  801045:	89 55 10             	mov    %edx,0x10(%ebp)
  801048:	85 c0                	test   %eax,%eax
  80104a:	75 dd                	jne    801029 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80104f:	c9                   	leave  
  801050:	c3                   	ret    

00801051 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801051:	55                   	push   %ebp
  801052:	89 e5                	mov    %esp,%ebp
  801054:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801063:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801066:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801069:	73 50                	jae    8010bb <memmove+0x6a>
  80106b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80106e:	8b 45 10             	mov    0x10(%ebp),%eax
  801071:	01 d0                	add    %edx,%eax
  801073:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801076:	76 43                	jbe    8010bb <memmove+0x6a>
		s += n;
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80107e:	8b 45 10             	mov    0x10(%ebp),%eax
  801081:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801084:	eb 10                	jmp    801096 <memmove+0x45>
			*--d = *--s;
  801086:	ff 4d f8             	decl   -0x8(%ebp)
  801089:	ff 4d fc             	decl   -0x4(%ebp)
  80108c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108f:	8a 10                	mov    (%eax),%dl
  801091:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801094:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801096:	8b 45 10             	mov    0x10(%ebp),%eax
  801099:	8d 50 ff             	lea    -0x1(%eax),%edx
  80109c:	89 55 10             	mov    %edx,0x10(%ebp)
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	75 e3                	jne    801086 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010a3:	eb 23                	jmp    8010c8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a8:	8d 50 01             	lea    0x1(%eax),%edx
  8010ab:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010b4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010b7:	8a 12                	mov    (%edx),%dl
  8010b9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010be:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c4:	85 c0                	test   %eax,%eax
  8010c6:	75 dd                	jne    8010a5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    

008010cd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010df:	eb 2a                	jmp    80110b <memcmp+0x3e>
		if (*s1 != *s2)
  8010e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e4:	8a 10                	mov    (%eax),%dl
  8010e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	38 c2                	cmp    %al,%dl
  8010ed:	74 16                	je     801105 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f2:	8a 00                	mov    (%eax),%al
  8010f4:	0f b6 d0             	movzbl %al,%edx
  8010f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	0f b6 c0             	movzbl %al,%eax
  8010ff:	29 c2                	sub    %eax,%edx
  801101:	89 d0                	mov    %edx,%eax
  801103:	eb 18                	jmp    80111d <memcmp+0x50>
		s1++, s2++;
  801105:	ff 45 fc             	incl   -0x4(%ebp)
  801108:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801111:	89 55 10             	mov    %edx,0x10(%ebp)
  801114:	85 c0                	test   %eax,%eax
  801116:	75 c9                	jne    8010e1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801118:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801125:	8b 55 08             	mov    0x8(%ebp),%edx
  801128:	8b 45 10             	mov    0x10(%ebp),%eax
  80112b:	01 d0                	add    %edx,%eax
  80112d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801130:	eb 15                	jmp    801147 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	0f b6 d0             	movzbl %al,%edx
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	0f b6 c0             	movzbl %al,%eax
  801140:	39 c2                	cmp    %eax,%edx
  801142:	74 0d                	je     801151 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801144:	ff 45 08             	incl   0x8(%ebp)
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80114d:	72 e3                	jb     801132 <memfind+0x13>
  80114f:	eb 01                	jmp    801152 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801151:	90                   	nop
	return (void *) s;
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80115d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801164:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80116b:	eb 03                	jmp    801170 <strtol+0x19>
		s++;
  80116d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801170:	8b 45 08             	mov    0x8(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	3c 20                	cmp    $0x20,%al
  801177:	74 f4                	je     80116d <strtol+0x16>
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	3c 09                	cmp    $0x9,%al
  801180:	74 eb                	je     80116d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	3c 2b                	cmp    $0x2b,%al
  801189:	75 05                	jne    801190 <strtol+0x39>
		s++;
  80118b:	ff 45 08             	incl   0x8(%ebp)
  80118e:	eb 13                	jmp    8011a3 <strtol+0x4c>
	else if (*s == '-')
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	8a 00                	mov    (%eax),%al
  801195:	3c 2d                	cmp    $0x2d,%al
  801197:	75 0a                	jne    8011a3 <strtol+0x4c>
		s++, neg = 1;
  801199:	ff 45 08             	incl   0x8(%ebp)
  80119c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a7:	74 06                	je     8011af <strtol+0x58>
  8011a9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011ad:	75 20                	jne    8011cf <strtol+0x78>
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8a 00                	mov    (%eax),%al
  8011b4:	3c 30                	cmp    $0x30,%al
  8011b6:	75 17                	jne    8011cf <strtol+0x78>
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	40                   	inc    %eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	3c 78                	cmp    $0x78,%al
  8011c0:	75 0d                	jne    8011cf <strtol+0x78>
		s += 2, base = 16;
  8011c2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011c6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011cd:	eb 28                	jmp    8011f7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d3:	75 15                	jne    8011ea <strtol+0x93>
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3c 30                	cmp    $0x30,%al
  8011dc:	75 0c                	jne    8011ea <strtol+0x93>
		s++, base = 8;
  8011de:	ff 45 08             	incl   0x8(%ebp)
  8011e1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011e8:	eb 0d                	jmp    8011f7 <strtol+0xa0>
	else if (base == 0)
  8011ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ee:	75 07                	jne    8011f7 <strtol+0xa0>
		base = 10;
  8011f0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	3c 2f                	cmp    $0x2f,%al
  8011fe:	7e 19                	jle    801219 <strtol+0xc2>
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	3c 39                	cmp    $0x39,%al
  801207:	7f 10                	jg     801219 <strtol+0xc2>
			dig = *s - '0';
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	0f be c0             	movsbl %al,%eax
  801211:	83 e8 30             	sub    $0x30,%eax
  801214:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801217:	eb 42                	jmp    80125b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 60                	cmp    $0x60,%al
  801220:	7e 19                	jle    80123b <strtol+0xe4>
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	3c 7a                	cmp    $0x7a,%al
  801229:	7f 10                	jg     80123b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	0f be c0             	movsbl %al,%eax
  801233:	83 e8 57             	sub    $0x57,%eax
  801236:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801239:	eb 20                	jmp    80125b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	3c 40                	cmp    $0x40,%al
  801242:	7e 39                	jle    80127d <strtol+0x126>
  801244:	8b 45 08             	mov    0x8(%ebp),%eax
  801247:	8a 00                	mov    (%eax),%al
  801249:	3c 5a                	cmp    $0x5a,%al
  80124b:	7f 30                	jg     80127d <strtol+0x126>
			dig = *s - 'A' + 10;
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	0f be c0             	movsbl %al,%eax
  801255:	83 e8 37             	sub    $0x37,%eax
  801258:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80125b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801261:	7d 19                	jge    80127c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801263:	ff 45 08             	incl   0x8(%ebp)
  801266:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801269:	0f af 45 10          	imul   0x10(%ebp),%eax
  80126d:	89 c2                	mov    %eax,%edx
  80126f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801272:	01 d0                	add    %edx,%eax
  801274:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801277:	e9 7b ff ff ff       	jmp    8011f7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80127c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	74 08                	je     80128b <strtol+0x134>
		*endptr = (char *) s;
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	8b 55 08             	mov    0x8(%ebp),%edx
  801289:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80128b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80128f:	74 07                	je     801298 <strtol+0x141>
  801291:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801294:	f7 d8                	neg    %eax
  801296:	eb 03                	jmp    80129b <strtol+0x144>
  801298:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80129b:	c9                   	leave  
  80129c:	c3                   	ret    

0080129d <ltostr>:

void
ltostr(long value, char *str)
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
  8012a0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012b5:	79 13                	jns    8012ca <ltostr+0x2d>
	{
		neg = 1;
  8012b7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012c4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012c7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012d2:	99                   	cltd   
  8012d3:	f7 f9                	idiv   %ecx
  8012d5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012db:	8d 50 01             	lea    0x1(%eax),%edx
  8012de:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012e1:	89 c2                	mov    %eax,%edx
  8012e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e6:	01 d0                	add    %edx,%eax
  8012e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012eb:	83 c2 30             	add    $0x30,%edx
  8012ee:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f8:	f7 e9                	imul   %ecx
  8012fa:	c1 fa 02             	sar    $0x2,%edx
  8012fd:	89 c8                	mov    %ecx,%eax
  8012ff:	c1 f8 1f             	sar    $0x1f,%eax
  801302:	29 c2                	sub    %eax,%edx
  801304:	89 d0                	mov    %edx,%eax
  801306:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801309:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80130c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801311:	f7 e9                	imul   %ecx
  801313:	c1 fa 02             	sar    $0x2,%edx
  801316:	89 c8                	mov    %ecx,%eax
  801318:	c1 f8 1f             	sar    $0x1f,%eax
  80131b:	29 c2                	sub    %eax,%edx
  80131d:	89 d0                	mov    %edx,%eax
  80131f:	c1 e0 02             	shl    $0x2,%eax
  801322:	01 d0                	add    %edx,%eax
  801324:	01 c0                	add    %eax,%eax
  801326:	29 c1                	sub    %eax,%ecx
  801328:	89 ca                	mov    %ecx,%edx
  80132a:	85 d2                	test   %edx,%edx
  80132c:	75 9c                	jne    8012ca <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80132e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801335:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801338:	48                   	dec    %eax
  801339:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80133c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801340:	74 3d                	je     80137f <ltostr+0xe2>
		start = 1 ;
  801342:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801349:	eb 34                	jmp    80137f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80134b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80134e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801351:	01 d0                	add    %edx,%eax
  801353:	8a 00                	mov    (%eax),%al
  801355:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801358:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80135b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135e:	01 c2                	add    %eax,%edx
  801360:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	01 c8                	add    %ecx,%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80136c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80136f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801372:	01 c2                	add    %eax,%edx
  801374:	8a 45 eb             	mov    -0x15(%ebp),%al
  801377:	88 02                	mov    %al,(%edx)
		start++ ;
  801379:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80137c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80137f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801382:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801385:	7c c4                	jl     80134b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801387:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80138a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138d:	01 d0                	add    %edx,%eax
  80138f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801392:	90                   	nop
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80139b:	ff 75 08             	pushl  0x8(%ebp)
  80139e:	e8 54 fa ff ff       	call   800df7 <strlen>
  8013a3:	83 c4 04             	add    $0x4,%esp
  8013a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013a9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ac:	e8 46 fa ff ff       	call   800df7 <strlen>
  8013b1:	83 c4 04             	add    $0x4,%esp
  8013b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013c5:	eb 17                	jmp    8013de <strcconcat+0x49>
		final[s] = str1[s] ;
  8013c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cd:	01 c2                	add    %eax,%edx
  8013cf:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	01 c8                	add    %ecx,%eax
  8013d7:	8a 00                	mov    (%eax),%al
  8013d9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013db:	ff 45 fc             	incl   -0x4(%ebp)
  8013de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013e1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013e4:	7c e1                	jl     8013c7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013e6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013f4:	eb 1f                	jmp    801415 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f9:	8d 50 01             	lea    0x1(%eax),%edx
  8013fc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013ff:	89 c2                	mov    %eax,%edx
  801401:	8b 45 10             	mov    0x10(%ebp),%eax
  801404:	01 c2                	add    %eax,%edx
  801406:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801409:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140c:	01 c8                	add    %ecx,%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801412:	ff 45 f8             	incl   -0x8(%ebp)
  801415:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801418:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80141b:	7c d9                	jl     8013f6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80141d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801420:	8b 45 10             	mov    0x10(%ebp),%eax
  801423:	01 d0                	add    %edx,%eax
  801425:	c6 00 00             	movb   $0x0,(%eax)
}
  801428:	90                   	nop
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80142e:	8b 45 14             	mov    0x14(%ebp),%eax
  801431:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801437:	8b 45 14             	mov    0x14(%ebp),%eax
  80143a:	8b 00                	mov    (%eax),%eax
  80143c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801443:	8b 45 10             	mov    0x10(%ebp),%eax
  801446:	01 d0                	add    %edx,%eax
  801448:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80144e:	eb 0c                	jmp    80145c <strsplit+0x31>
			*string++ = 0;
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	8d 50 01             	lea    0x1(%eax),%edx
  801456:	89 55 08             	mov    %edx,0x8(%ebp)
  801459:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	84 c0                	test   %al,%al
  801463:	74 18                	je     80147d <strsplit+0x52>
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8a 00                	mov    (%eax),%al
  80146a:	0f be c0             	movsbl %al,%eax
  80146d:	50                   	push   %eax
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	e8 13 fb ff ff       	call   800f89 <strchr>
  801476:	83 c4 08             	add    $0x8,%esp
  801479:	85 c0                	test   %eax,%eax
  80147b:	75 d3                	jne    801450 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	84 c0                	test   %al,%al
  801484:	74 5a                	je     8014e0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801486:	8b 45 14             	mov    0x14(%ebp),%eax
  801489:	8b 00                	mov    (%eax),%eax
  80148b:	83 f8 0f             	cmp    $0xf,%eax
  80148e:	75 07                	jne    801497 <strsplit+0x6c>
		{
			return 0;
  801490:	b8 00 00 00 00       	mov    $0x0,%eax
  801495:	eb 66                	jmp    8014fd <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801497:	8b 45 14             	mov    0x14(%ebp),%eax
  80149a:	8b 00                	mov    (%eax),%eax
  80149c:	8d 48 01             	lea    0x1(%eax),%ecx
  80149f:	8b 55 14             	mov    0x14(%ebp),%edx
  8014a2:	89 0a                	mov    %ecx,(%edx)
  8014a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ae:	01 c2                	add    %eax,%edx
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014b5:	eb 03                	jmp    8014ba <strsplit+0x8f>
			string++;
  8014b7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	84 c0                	test   %al,%al
  8014c1:	74 8b                	je     80144e <strsplit+0x23>
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	0f be c0             	movsbl %al,%eax
  8014cb:	50                   	push   %eax
  8014cc:	ff 75 0c             	pushl  0xc(%ebp)
  8014cf:	e8 b5 fa ff ff       	call   800f89 <strchr>
  8014d4:	83 c4 08             	add    $0x8,%esp
  8014d7:	85 c0                	test   %eax,%eax
  8014d9:	74 dc                	je     8014b7 <strsplit+0x8c>
			string++;
	}
  8014db:	e9 6e ff ff ff       	jmp    80144e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014e0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e4:	8b 00                	mov    (%eax),%eax
  8014e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	01 d0                	add    %edx,%eax
  8014f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014f8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	57                   	push   %edi
  801503:	56                   	push   %esi
  801504:	53                   	push   %ebx
  801505:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801511:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801514:	8b 7d 18             	mov    0x18(%ebp),%edi
  801517:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80151a:	cd 30                	int    $0x30
  80151c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80151f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	5b                   	pop    %ebx
  801526:	5e                   	pop    %esi
  801527:	5f                   	pop    %edi
  801528:	5d                   	pop    %ebp
  801529:	c3                   	ret    

0080152a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	83 ec 04             	sub    $0x4,%esp
  801530:	8b 45 10             	mov    0x10(%ebp),%eax
  801533:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801536:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	52                   	push   %edx
  801542:	ff 75 0c             	pushl  0xc(%ebp)
  801545:	50                   	push   %eax
  801546:	6a 00                	push   $0x0
  801548:	e8 b2 ff ff ff       	call   8014ff <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
}
  801550:	90                   	nop
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <sys_cgetc>:

int
sys_cgetc(void)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 01                	push   $0x1
  801562:	e8 98 ff ff ff       	call   8014ff <syscall>
  801567:	83 c4 18             	add    $0x18,%esp
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80156f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	52                   	push   %edx
  80157c:	50                   	push   %eax
  80157d:	6a 05                	push   $0x5
  80157f:	e8 7b ff ff ff       	call   8014ff <syscall>
  801584:	83 c4 18             	add    $0x18,%esp
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	56                   	push   %esi
  80158d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80158e:	8b 75 18             	mov    0x18(%ebp),%esi
  801591:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801594:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801597:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	56                   	push   %esi
  80159e:	53                   	push   %ebx
  80159f:	51                   	push   %ecx
  8015a0:	52                   	push   %edx
  8015a1:	50                   	push   %eax
  8015a2:	6a 06                	push   $0x6
  8015a4:	e8 56 ff ff ff       	call   8014ff <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
}
  8015ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015af:	5b                   	pop    %ebx
  8015b0:	5e                   	pop    %esi
  8015b1:	5d                   	pop    %ebp
  8015b2:	c3                   	ret    

008015b3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8015b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	52                   	push   %edx
  8015c3:	50                   	push   %eax
  8015c4:	6a 07                	push   $0x7
  8015c6:	e8 34 ff ff ff       	call   8014ff <syscall>
  8015cb:	83 c4 18             	add    $0x18,%esp
}
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	ff 75 0c             	pushl  0xc(%ebp)
  8015dc:	ff 75 08             	pushl  0x8(%ebp)
  8015df:	6a 08                	push   $0x8
  8015e1:	e8 19 ff ff ff       	call   8014ff <syscall>
  8015e6:	83 c4 18             	add    $0x18,%esp
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 09                	push   $0x9
  8015fa:	e8 00 ff ff ff       	call   8014ff <syscall>
  8015ff:	83 c4 18             	add    $0x18,%esp
}
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 0a                	push   $0xa
  801613:	e8 e7 fe ff ff       	call   8014ff <syscall>
  801618:	83 c4 18             	add    $0x18,%esp
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 0b                	push   $0xb
  80162c:	e8 ce fe ff ff       	call   8014ff <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	ff 75 08             	pushl  0x8(%ebp)
  801645:	6a 0f                	push   $0xf
  801647:	e8 b3 fe ff ff       	call   8014ff <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
	return;
  80164f:	90                   	nop
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	ff 75 0c             	pushl  0xc(%ebp)
  80165e:	ff 75 08             	pushl  0x8(%ebp)
  801661:	6a 10                	push   $0x10
  801663:	e8 97 fe ff ff       	call   8014ff <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
	return ;
  80166b:	90                   	nop
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	ff 75 10             	pushl  0x10(%ebp)
  801678:	ff 75 0c             	pushl  0xc(%ebp)
  80167b:	ff 75 08             	pushl  0x8(%ebp)
  80167e:	6a 11                	push   $0x11
  801680:	e8 7a fe ff ff       	call   8014ff <syscall>
  801685:	83 c4 18             	add    $0x18,%esp
	return ;
  801688:	90                   	nop
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 0c                	push   $0xc
  80169a:	e8 60 fe ff ff       	call   8014ff <syscall>
  80169f:	83 c4 18             	add    $0x18,%esp
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	ff 75 08             	pushl  0x8(%ebp)
  8016b2:	6a 0d                	push   $0xd
  8016b4:	e8 46 fe ff ff       	call   8014ff <syscall>
  8016b9:	83 c4 18             	add    $0x18,%esp
}
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 0e                	push   $0xe
  8016cd:	e8 2d fe ff ff       	call   8014ff <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
}
  8016d5:	90                   	nop
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 13                	push   $0x13
  8016e7:	e8 13 fe ff ff       	call   8014ff <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
}
  8016ef:	90                   	nop
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 14                	push   $0x14
  801701:	e8 f9 fd ff ff       	call   8014ff <syscall>
  801706:	83 c4 18             	add    $0x18,%esp
}
  801709:	90                   	nop
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <sys_cputc>:


void
sys_cputc(const char c)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801718:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	50                   	push   %eax
  801725:	6a 15                	push   $0x15
  801727:	e8 d3 fd ff ff       	call   8014ff <syscall>
  80172c:	83 c4 18             	add    $0x18,%esp
}
  80172f:	90                   	nop
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 16                	push   $0x16
  801741:	e8 b9 fd ff ff       	call   8014ff <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	90                   	nop
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	ff 75 0c             	pushl  0xc(%ebp)
  80175b:	50                   	push   %eax
  80175c:	6a 17                	push   $0x17
  80175e:	e8 9c fd ff ff       	call   8014ff <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80176b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	52                   	push   %edx
  801778:	50                   	push   %eax
  801779:	6a 1a                	push   $0x1a
  80177b:	e8 7f fd ff ff       	call   8014ff <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801788:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	52                   	push   %edx
  801795:	50                   	push   %eax
  801796:	6a 18                	push   $0x18
  801798:	e8 62 fd ff ff       	call   8014ff <syscall>
  80179d:	83 c4 18             	add    $0x18,%esp
}
  8017a0:	90                   	nop
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	52                   	push   %edx
  8017b3:	50                   	push   %eax
  8017b4:	6a 19                	push   $0x19
  8017b6:	e8 44 fd ff ff       	call   8014ff <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
}
  8017be:	90                   	nop
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017cd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017d0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	6a 00                	push   $0x0
  8017d9:	51                   	push   %ecx
  8017da:	52                   	push   %edx
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	50                   	push   %eax
  8017df:	6a 1b                	push   $0x1b
  8017e1:	e8 19 fd ff ff       	call   8014ff <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	52                   	push   %edx
  8017fb:	50                   	push   %eax
  8017fc:	6a 1c                	push   $0x1c
  8017fe:	e8 fc fc ff ff       	call   8014ff <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80180b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	51                   	push   %ecx
  801819:	52                   	push   %edx
  80181a:	50                   	push   %eax
  80181b:	6a 1d                	push   $0x1d
  80181d:	e8 dd fc ff ff       	call   8014ff <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80182a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	52                   	push   %edx
  801837:	50                   	push   %eax
  801838:	6a 1e                	push   $0x1e
  80183a:	e8 c0 fc ff ff       	call   8014ff <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 1f                	push   $0x1f
  801853:	e8 a7 fc ff ff       	call   8014ff <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	6a 00                	push   $0x0
  801865:	ff 75 14             	pushl  0x14(%ebp)
  801868:	ff 75 10             	pushl  0x10(%ebp)
  80186b:	ff 75 0c             	pushl  0xc(%ebp)
  80186e:	50                   	push   %eax
  80186f:	6a 20                	push   $0x20
  801871:	e8 89 fc ff ff       	call   8014ff <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80187e:	8b 45 08             	mov    0x8(%ebp),%eax
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	50                   	push   %eax
  80188a:	6a 21                	push   $0x21
  80188c:	e8 6e fc ff ff       	call   8014ff <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	90                   	nop
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80189a:	8b 45 08             	mov    0x8(%ebp),%eax
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	50                   	push   %eax
  8018a6:	6a 22                	push   $0x22
  8018a8:	e8 52 fc ff ff       	call   8014ff <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 02                	push   $0x2
  8018c1:	e8 39 fc ff ff       	call   8014ff <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 03                	push   $0x3
  8018da:	e8 20 fc ff ff       	call   8014ff <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
}
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 04                	push   $0x4
  8018f3:	e8 07 fc ff ff       	call   8014ff <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <sys_exit_env>:


void sys_exit_env(void)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 23                	push   $0x23
  80190c:	e8 ee fb ff ff       	call   8014ff <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
}
  801914:	90                   	nop
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80191d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801920:	8d 50 04             	lea    0x4(%eax),%edx
  801923:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	52                   	push   %edx
  80192d:	50                   	push   %eax
  80192e:	6a 24                	push   $0x24
  801930:	e8 ca fb ff ff       	call   8014ff <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
	return result;
  801938:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80193b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80193e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801941:	89 01                	mov    %eax,(%ecx)
  801943:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	c9                   	leave  
  80194a:	c2 04 00             	ret    $0x4

0080194d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	ff 75 10             	pushl  0x10(%ebp)
  801957:	ff 75 0c             	pushl  0xc(%ebp)
  80195a:	ff 75 08             	pushl  0x8(%ebp)
  80195d:	6a 12                	push   $0x12
  80195f:	e8 9b fb ff ff       	call   8014ff <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
	return ;
  801967:	90                   	nop
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_rcr2>:
uint32 sys_rcr2()
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 25                	push   $0x25
  801979:	e8 81 fb ff ff       	call   8014ff <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80198f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	50                   	push   %eax
  80199c:	6a 26                	push   $0x26
  80199e:	e8 5c fb ff ff       	call   8014ff <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a6:	90                   	nop
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <rsttst>:
void rsttst()
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 28                	push   $0x28
  8019b8:	e8 42 fb ff ff       	call   8014ff <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c0:	90                   	nop
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 04             	sub    $0x4,%esp
  8019c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8019cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019cf:	8b 55 18             	mov    0x18(%ebp),%edx
  8019d2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019d6:	52                   	push   %edx
  8019d7:	50                   	push   %eax
  8019d8:	ff 75 10             	pushl  0x10(%ebp)
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	ff 75 08             	pushl  0x8(%ebp)
  8019e1:	6a 27                	push   $0x27
  8019e3:	e8 17 fb ff ff       	call   8014ff <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019eb:	90                   	nop
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <chktst>:
void chktst(uint32 n)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	ff 75 08             	pushl  0x8(%ebp)
  8019fc:	6a 29                	push   $0x29
  8019fe:	e8 fc fa ff ff       	call   8014ff <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
	return ;
  801a06:	90                   	nop
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <inctst>:

void inctst()
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 2a                	push   $0x2a
  801a18:	e8 e2 fa ff ff       	call   8014ff <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a20:	90                   	nop
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <gettst>:
uint32 gettst()
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 2b                	push   $0x2b
  801a32:	e8 c8 fa ff ff       	call   8014ff <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 2c                	push   $0x2c
  801a4e:	e8 ac fa ff ff       	call   8014ff <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
  801a56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a59:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a5d:	75 07                	jne    801a66 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801a64:	eb 05                	jmp    801a6b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 2c                	push   $0x2c
  801a7f:	e8 7b fa ff ff       	call   8014ff <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
  801a87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a8a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a8e:	75 07                	jne    801a97 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a90:	b8 01 00 00 00       	mov    $0x1,%eax
  801a95:	eb 05                	jmp    801a9c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 2c                	push   $0x2c
  801ab0:	e8 4a fa ff ff       	call   8014ff <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
  801ab8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801abb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801abf:	75 07                	jne    801ac8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ac1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac6:	eb 05                	jmp    801acd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ac8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 2c                	push   $0x2c
  801ae1:	e8 19 fa ff ff       	call   8014ff <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
  801ae9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801aec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801af0:	75 07                	jne    801af9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801af2:	b8 01 00 00 00       	mov    $0x1,%eax
  801af7:	eb 05                	jmp    801afe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801af9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	ff 75 08             	pushl  0x8(%ebp)
  801b0e:	6a 2d                	push   $0x2d
  801b10:	e8 ea f9 ff ff       	call   8014ff <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
	return ;
  801b18:	90                   	nop
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b1f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	6a 00                	push   $0x0
  801b2d:	53                   	push   %ebx
  801b2e:	51                   	push   %ecx
  801b2f:	52                   	push   %edx
  801b30:	50                   	push   %eax
  801b31:	6a 2e                	push   $0x2e
  801b33:	e8 c7 f9 ff ff       	call   8014ff <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	52                   	push   %edx
  801b50:	50                   	push   %eax
  801b51:	6a 2f                	push   $0x2f
  801b53:	e8 a7 f9 ff ff       	call   8014ff <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    
  801b5d:	66 90                	xchg   %ax,%ax
  801b5f:	90                   	nop

00801b60 <__udivdi3>:
  801b60:	55                   	push   %ebp
  801b61:	57                   	push   %edi
  801b62:	56                   	push   %esi
  801b63:	53                   	push   %ebx
  801b64:	83 ec 1c             	sub    $0x1c,%esp
  801b67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b77:	89 ca                	mov    %ecx,%edx
  801b79:	89 f8                	mov    %edi,%eax
  801b7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b7f:	85 f6                	test   %esi,%esi
  801b81:	75 2d                	jne    801bb0 <__udivdi3+0x50>
  801b83:	39 cf                	cmp    %ecx,%edi
  801b85:	77 65                	ja     801bec <__udivdi3+0x8c>
  801b87:	89 fd                	mov    %edi,%ebp
  801b89:	85 ff                	test   %edi,%edi
  801b8b:	75 0b                	jne    801b98 <__udivdi3+0x38>
  801b8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b92:	31 d2                	xor    %edx,%edx
  801b94:	f7 f7                	div    %edi
  801b96:	89 c5                	mov    %eax,%ebp
  801b98:	31 d2                	xor    %edx,%edx
  801b9a:	89 c8                	mov    %ecx,%eax
  801b9c:	f7 f5                	div    %ebp
  801b9e:	89 c1                	mov    %eax,%ecx
  801ba0:	89 d8                	mov    %ebx,%eax
  801ba2:	f7 f5                	div    %ebp
  801ba4:	89 cf                	mov    %ecx,%edi
  801ba6:	89 fa                	mov    %edi,%edx
  801ba8:	83 c4 1c             	add    $0x1c,%esp
  801bab:	5b                   	pop    %ebx
  801bac:	5e                   	pop    %esi
  801bad:	5f                   	pop    %edi
  801bae:	5d                   	pop    %ebp
  801baf:	c3                   	ret    
  801bb0:	39 ce                	cmp    %ecx,%esi
  801bb2:	77 28                	ja     801bdc <__udivdi3+0x7c>
  801bb4:	0f bd fe             	bsr    %esi,%edi
  801bb7:	83 f7 1f             	xor    $0x1f,%edi
  801bba:	75 40                	jne    801bfc <__udivdi3+0x9c>
  801bbc:	39 ce                	cmp    %ecx,%esi
  801bbe:	72 0a                	jb     801bca <__udivdi3+0x6a>
  801bc0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bc4:	0f 87 9e 00 00 00    	ja     801c68 <__udivdi3+0x108>
  801bca:	b8 01 00 00 00       	mov    $0x1,%eax
  801bcf:	89 fa                	mov    %edi,%edx
  801bd1:	83 c4 1c             	add    $0x1c,%esp
  801bd4:	5b                   	pop    %ebx
  801bd5:	5e                   	pop    %esi
  801bd6:	5f                   	pop    %edi
  801bd7:	5d                   	pop    %ebp
  801bd8:	c3                   	ret    
  801bd9:	8d 76 00             	lea    0x0(%esi),%esi
  801bdc:	31 ff                	xor    %edi,%edi
  801bde:	31 c0                	xor    %eax,%eax
  801be0:	89 fa                	mov    %edi,%edx
  801be2:	83 c4 1c             	add    $0x1c,%esp
  801be5:	5b                   	pop    %ebx
  801be6:	5e                   	pop    %esi
  801be7:	5f                   	pop    %edi
  801be8:	5d                   	pop    %ebp
  801be9:	c3                   	ret    
  801bea:	66 90                	xchg   %ax,%ax
  801bec:	89 d8                	mov    %ebx,%eax
  801bee:	f7 f7                	div    %edi
  801bf0:	31 ff                	xor    %edi,%edi
  801bf2:	89 fa                	mov    %edi,%edx
  801bf4:	83 c4 1c             	add    $0x1c,%esp
  801bf7:	5b                   	pop    %ebx
  801bf8:	5e                   	pop    %esi
  801bf9:	5f                   	pop    %edi
  801bfa:	5d                   	pop    %ebp
  801bfb:	c3                   	ret    
  801bfc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c01:	89 eb                	mov    %ebp,%ebx
  801c03:	29 fb                	sub    %edi,%ebx
  801c05:	89 f9                	mov    %edi,%ecx
  801c07:	d3 e6                	shl    %cl,%esi
  801c09:	89 c5                	mov    %eax,%ebp
  801c0b:	88 d9                	mov    %bl,%cl
  801c0d:	d3 ed                	shr    %cl,%ebp
  801c0f:	89 e9                	mov    %ebp,%ecx
  801c11:	09 f1                	or     %esi,%ecx
  801c13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c17:	89 f9                	mov    %edi,%ecx
  801c19:	d3 e0                	shl    %cl,%eax
  801c1b:	89 c5                	mov    %eax,%ebp
  801c1d:	89 d6                	mov    %edx,%esi
  801c1f:	88 d9                	mov    %bl,%cl
  801c21:	d3 ee                	shr    %cl,%esi
  801c23:	89 f9                	mov    %edi,%ecx
  801c25:	d3 e2                	shl    %cl,%edx
  801c27:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c2b:	88 d9                	mov    %bl,%cl
  801c2d:	d3 e8                	shr    %cl,%eax
  801c2f:	09 c2                	or     %eax,%edx
  801c31:	89 d0                	mov    %edx,%eax
  801c33:	89 f2                	mov    %esi,%edx
  801c35:	f7 74 24 0c          	divl   0xc(%esp)
  801c39:	89 d6                	mov    %edx,%esi
  801c3b:	89 c3                	mov    %eax,%ebx
  801c3d:	f7 e5                	mul    %ebp
  801c3f:	39 d6                	cmp    %edx,%esi
  801c41:	72 19                	jb     801c5c <__udivdi3+0xfc>
  801c43:	74 0b                	je     801c50 <__udivdi3+0xf0>
  801c45:	89 d8                	mov    %ebx,%eax
  801c47:	31 ff                	xor    %edi,%edi
  801c49:	e9 58 ff ff ff       	jmp    801ba6 <__udivdi3+0x46>
  801c4e:	66 90                	xchg   %ax,%ax
  801c50:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c54:	89 f9                	mov    %edi,%ecx
  801c56:	d3 e2                	shl    %cl,%edx
  801c58:	39 c2                	cmp    %eax,%edx
  801c5a:	73 e9                	jae    801c45 <__udivdi3+0xe5>
  801c5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c5f:	31 ff                	xor    %edi,%edi
  801c61:	e9 40 ff ff ff       	jmp    801ba6 <__udivdi3+0x46>
  801c66:	66 90                	xchg   %ax,%ax
  801c68:	31 c0                	xor    %eax,%eax
  801c6a:	e9 37 ff ff ff       	jmp    801ba6 <__udivdi3+0x46>
  801c6f:	90                   	nop

00801c70 <__umoddi3>:
  801c70:	55                   	push   %ebp
  801c71:	57                   	push   %edi
  801c72:	56                   	push   %esi
  801c73:	53                   	push   %ebx
  801c74:	83 ec 1c             	sub    $0x1c,%esp
  801c77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c8f:	89 f3                	mov    %esi,%ebx
  801c91:	89 fa                	mov    %edi,%edx
  801c93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c97:	89 34 24             	mov    %esi,(%esp)
  801c9a:	85 c0                	test   %eax,%eax
  801c9c:	75 1a                	jne    801cb8 <__umoddi3+0x48>
  801c9e:	39 f7                	cmp    %esi,%edi
  801ca0:	0f 86 a2 00 00 00    	jbe    801d48 <__umoddi3+0xd8>
  801ca6:	89 c8                	mov    %ecx,%eax
  801ca8:	89 f2                	mov    %esi,%edx
  801caa:	f7 f7                	div    %edi
  801cac:	89 d0                	mov    %edx,%eax
  801cae:	31 d2                	xor    %edx,%edx
  801cb0:	83 c4 1c             	add    $0x1c,%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5e                   	pop    %esi
  801cb5:	5f                   	pop    %edi
  801cb6:	5d                   	pop    %ebp
  801cb7:	c3                   	ret    
  801cb8:	39 f0                	cmp    %esi,%eax
  801cba:	0f 87 ac 00 00 00    	ja     801d6c <__umoddi3+0xfc>
  801cc0:	0f bd e8             	bsr    %eax,%ebp
  801cc3:	83 f5 1f             	xor    $0x1f,%ebp
  801cc6:	0f 84 ac 00 00 00    	je     801d78 <__umoddi3+0x108>
  801ccc:	bf 20 00 00 00       	mov    $0x20,%edi
  801cd1:	29 ef                	sub    %ebp,%edi
  801cd3:	89 fe                	mov    %edi,%esi
  801cd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cd9:	89 e9                	mov    %ebp,%ecx
  801cdb:	d3 e0                	shl    %cl,%eax
  801cdd:	89 d7                	mov    %edx,%edi
  801cdf:	89 f1                	mov    %esi,%ecx
  801ce1:	d3 ef                	shr    %cl,%edi
  801ce3:	09 c7                	or     %eax,%edi
  801ce5:	89 e9                	mov    %ebp,%ecx
  801ce7:	d3 e2                	shl    %cl,%edx
  801ce9:	89 14 24             	mov    %edx,(%esp)
  801cec:	89 d8                	mov    %ebx,%eax
  801cee:	d3 e0                	shl    %cl,%eax
  801cf0:	89 c2                	mov    %eax,%edx
  801cf2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cf6:	d3 e0                	shl    %cl,%eax
  801cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cfc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d00:	89 f1                	mov    %esi,%ecx
  801d02:	d3 e8                	shr    %cl,%eax
  801d04:	09 d0                	or     %edx,%eax
  801d06:	d3 eb                	shr    %cl,%ebx
  801d08:	89 da                	mov    %ebx,%edx
  801d0a:	f7 f7                	div    %edi
  801d0c:	89 d3                	mov    %edx,%ebx
  801d0e:	f7 24 24             	mull   (%esp)
  801d11:	89 c6                	mov    %eax,%esi
  801d13:	89 d1                	mov    %edx,%ecx
  801d15:	39 d3                	cmp    %edx,%ebx
  801d17:	0f 82 87 00 00 00    	jb     801da4 <__umoddi3+0x134>
  801d1d:	0f 84 91 00 00 00    	je     801db4 <__umoddi3+0x144>
  801d23:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d27:	29 f2                	sub    %esi,%edx
  801d29:	19 cb                	sbb    %ecx,%ebx
  801d2b:	89 d8                	mov    %ebx,%eax
  801d2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d31:	d3 e0                	shl    %cl,%eax
  801d33:	89 e9                	mov    %ebp,%ecx
  801d35:	d3 ea                	shr    %cl,%edx
  801d37:	09 d0                	or     %edx,%eax
  801d39:	89 e9                	mov    %ebp,%ecx
  801d3b:	d3 eb                	shr    %cl,%ebx
  801d3d:	89 da                	mov    %ebx,%edx
  801d3f:	83 c4 1c             	add    $0x1c,%esp
  801d42:	5b                   	pop    %ebx
  801d43:	5e                   	pop    %esi
  801d44:	5f                   	pop    %edi
  801d45:	5d                   	pop    %ebp
  801d46:	c3                   	ret    
  801d47:	90                   	nop
  801d48:	89 fd                	mov    %edi,%ebp
  801d4a:	85 ff                	test   %edi,%edi
  801d4c:	75 0b                	jne    801d59 <__umoddi3+0xe9>
  801d4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d53:	31 d2                	xor    %edx,%edx
  801d55:	f7 f7                	div    %edi
  801d57:	89 c5                	mov    %eax,%ebp
  801d59:	89 f0                	mov    %esi,%eax
  801d5b:	31 d2                	xor    %edx,%edx
  801d5d:	f7 f5                	div    %ebp
  801d5f:	89 c8                	mov    %ecx,%eax
  801d61:	f7 f5                	div    %ebp
  801d63:	89 d0                	mov    %edx,%eax
  801d65:	e9 44 ff ff ff       	jmp    801cae <__umoddi3+0x3e>
  801d6a:	66 90                	xchg   %ax,%ax
  801d6c:	89 c8                	mov    %ecx,%eax
  801d6e:	89 f2                	mov    %esi,%edx
  801d70:	83 c4 1c             	add    $0x1c,%esp
  801d73:	5b                   	pop    %ebx
  801d74:	5e                   	pop    %esi
  801d75:	5f                   	pop    %edi
  801d76:	5d                   	pop    %ebp
  801d77:	c3                   	ret    
  801d78:	3b 04 24             	cmp    (%esp),%eax
  801d7b:	72 06                	jb     801d83 <__umoddi3+0x113>
  801d7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d81:	77 0f                	ja     801d92 <__umoddi3+0x122>
  801d83:	89 f2                	mov    %esi,%edx
  801d85:	29 f9                	sub    %edi,%ecx
  801d87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d8b:	89 14 24             	mov    %edx,(%esp)
  801d8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d92:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d96:	8b 14 24             	mov    (%esp),%edx
  801d99:	83 c4 1c             	add    $0x1c,%esp
  801d9c:	5b                   	pop    %ebx
  801d9d:	5e                   	pop    %esi
  801d9e:	5f                   	pop    %edi
  801d9f:	5d                   	pop    %ebp
  801da0:	c3                   	ret    
  801da1:	8d 76 00             	lea    0x0(%esi),%esi
  801da4:	2b 04 24             	sub    (%esp),%eax
  801da7:	19 fa                	sbb    %edi,%edx
  801da9:	89 d1                	mov    %edx,%ecx
  801dab:	89 c6                	mov    %eax,%esi
  801dad:	e9 71 ff ff ff       	jmp    801d23 <__umoddi3+0xb3>
  801db2:	66 90                	xchg   %ax,%ax
  801db4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801db8:	72 ea                	jb     801da4 <__umoddi3+0x134>
  801dba:	89 d9                	mov    %ebx,%ecx
  801dbc:	e9 62 ff ff ff       	jmp    801d23 <__umoddi3+0xb3>
