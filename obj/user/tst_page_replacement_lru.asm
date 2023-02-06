
obj/user/tst_page_replacement_lru:     file format elf32-i386


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
  800031:	e8 fc 02 00 00       	call   800332 <libmain>
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
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 6c             	sub    $0x6c,%esp
//	cprintf("envID = %d\n",envID);


	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800041:	a1 20 30 80 00       	mov    0x803020,%eax
  800046:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80004c:	8b 00                	mov    (%eax),%eax
  80004e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800051:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800054:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800059:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005e:	74 14                	je     800074 <_main+0x3c>
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 80 1d 80 00       	push   $0x801d80
  800068:	6a 13                	push   $0x13
  80006a:	68 c4 1d 80 00       	push   $0x801dc4
  80006f:	e8 fa 03 00 00       	call   80046e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800074:	a1 20 30 80 00       	mov    0x803020,%eax
  800079:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80007f:	83 c0 18             	add    $0x18,%eax
  800082:	8b 00                	mov    (%eax),%eax
  800084:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800087:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80008a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008f:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800094:	74 14                	je     8000aa <_main+0x72>
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	68 80 1d 80 00       	push   $0x801d80
  80009e:	6a 14                	push   $0x14
  8000a0:	68 c4 1d 80 00       	push   $0x801dc4
  8000a5:	e8 c4 03 00 00       	call   80046e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8000af:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000b5:	83 c0 30             	add    $0x30,%eax
  8000b8:	8b 00                	mov    (%eax),%eax
  8000ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8000bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c5:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 80 1d 80 00       	push   $0x801d80
  8000d4:	6a 15                	push   $0x15
  8000d6:	68 c4 1d 80 00       	push   $0x801dc4
  8000db:	e8 8e 03 00 00       	call   80046e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e5:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000eb:	83 c0 48             	add    $0x48,%eax
  8000ee:	8b 00                	mov    (%eax),%eax
  8000f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000fb:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800100:	74 14                	je     800116 <_main+0xde>
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	68 80 1d 80 00       	push   $0x801d80
  80010a:	6a 16                	push   $0x16
  80010c:	68 c4 1d 80 00       	push   $0x801dc4
  800111:	e8 58 03 00 00       	call   80046e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800116:	a1 20 30 80 00       	mov    0x803020,%eax
  80011b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800121:	83 c0 60             	add    $0x60,%eax
  800124:	8b 00                	mov    (%eax),%eax
  800126:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800129:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80012c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800131:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 80 1d 80 00       	push   $0x801d80
  800140:	6a 17                	push   $0x17
  800142:	68 c4 1d 80 00       	push   $0x801dc4
  800147:	e8 22 03 00 00       	call   80046e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80014c:	a1 20 30 80 00       	mov    0x803020,%eax
  800151:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800157:	83 c0 78             	add    $0x78,%eax
  80015a:	8b 00                	mov    (%eax),%eax
  80015c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80015f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800162:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800167:	3d 00 50 20 00       	cmp    $0x205000,%eax
  80016c:	74 14                	je     800182 <_main+0x14a>
  80016e:	83 ec 04             	sub    $0x4,%esp
  800171:	68 80 1d 80 00       	push   $0x801d80
  800176:	6a 18                	push   $0x18
  800178:	68 c4 1d 80 00       	push   $0x801dc4
  80017d:	e8 ec 02 00 00       	call   80046e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800182:	a1 20 30 80 00       	mov    0x803020,%eax
  800187:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80018d:	05 90 00 00 00       	add    $0x90,%eax
  800192:	8b 00                	mov    (%eax),%eax
  800194:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800197:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80019a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019f:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 80 1d 80 00       	push   $0x801d80
  8001ae:	6a 19                	push   $0x19
  8001b0:	68 c4 1d 80 00       	push   $0x801dc4
  8001b5:	e8 b4 02 00 00       	call   80046e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bf:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001c5:	05 a8 00 00 00       	add    $0xa8,%eax
  8001ca:	8b 00                	mov    (%eax),%eax
  8001cc:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8001cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d7:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001dc:	74 14                	je     8001f2 <_main+0x1ba>
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	68 80 1d 80 00       	push   $0x801d80
  8001e6:	6a 1a                	push   $0x1a
  8001e8:	68 c4 1d 80 00       	push   $0x801dc4
  8001ed:	e8 7c 02 00 00       	call   80046e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f7:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001fd:	05 c0 00 00 00       	add    $0xc0,%eax
  800202:	8b 00                	mov    (%eax),%eax
  800204:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800207:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80020a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020f:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800214:	74 14                	je     80022a <_main+0x1f2>
  800216:	83 ec 04             	sub    $0x4,%esp
  800219:	68 80 1d 80 00       	push   $0x801d80
  80021e:	6a 1b                	push   $0x1b
  800220:	68 c4 1d 80 00       	push   $0x801dc4
  800225:	e8 44 02 00 00       	call   80046e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80022a:	a1 20 30 80 00       	mov    0x803020,%eax
  80022f:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800235:	05 d8 00 00 00       	add    $0xd8,%eax
  80023a:	8b 00                	mov    (%eax),%eax
  80023c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80023f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800242:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800247:	3d 00 30 80 00       	cmp    $0x803000,%eax
  80024c:	74 14                	je     800262 <_main+0x22a>
  80024e:	83 ec 04             	sub    $0x4,%esp
  800251:	68 80 1d 80 00       	push   $0x801d80
  800256:	6a 1c                	push   $0x1c
  800258:	68 c4 1d 80 00       	push   $0x801dc4
  80025d:	e8 0c 02 00 00       	call   80046e <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800262:	a1 20 30 80 00       	mov    0x803020,%eax
  800267:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80026d:	05 f0 00 00 00       	add    $0xf0,%eax
  800272:	8b 00                	mov    (%eax),%eax
  800274:	89 45 b8             	mov    %eax,-0x48(%ebp)
  800277:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80027a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027f:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800284:	74 14                	je     80029a <_main+0x262>
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	68 80 1d 80 00       	push   $0x801d80
  80028e:	6a 1d                	push   $0x1d
  800290:	68 c4 1d 80 00       	push   $0x801dc4
  800295:	e8 d4 01 00 00       	call   80046e <_panic>
		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
	}

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  80029a:	a0 5f e0 80 00       	mov    0x80e05f,%al
  80029f:	88 45 b7             	mov    %al,-0x49(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  8002a2:	a0 5f f0 80 00       	mov    0x80f05f,%al
  8002a7:	88 45 b6             	mov    %al,-0x4a(%ebp)

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8002b1:	eb 37                	jmp    8002ea <_main+0x2b2>
	{
		arr[i] = -1 ;
  8002b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b6:	05 60 30 80 00       	add    $0x803060,%eax
  8002bb:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		*ptr2 = *ptr ;
  8002be:	a1 04 30 80 00       	mov    0x803004,%eax
  8002c3:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8002c9:	8a 12                	mov    (%edx),%dl
  8002cb:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  8002cd:	a1 00 30 80 00       	mov    0x803000,%eax
  8002d2:	40                   	inc    %eax
  8002d3:	a3 00 30 80 00       	mov    %eax,0x803000
  8002d8:	a1 04 30 80 00       	mov    0x803004,%eax
  8002dd:	40                   	inc    %eax
  8002de:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1] ;
	char garbage2 = arr[PAGE_SIZE*12-1] ;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8002e3:	81 45 e4 00 08 00 00 	addl   $0x800,-0x1c(%ebp)
  8002ea:	81 7d e4 ff 9f 00 00 	cmpl   $0x9fff,-0x1c(%ebp)
  8002f1:	7e c0                	jle    8002b3 <_main+0x27b>
		ptr++ ; ptr2++ ;
	}

	//===================

	uint32 expectedPages[11] = {0x809000,0x80a000,0x804000,0x80b000,0x80c000,0x800000,0x801000,0x808000,0x803000,0xeebfd000,0};
  8002f3:	8d 45 88             	lea    -0x78(%ebp),%eax
  8002f6:	bb 40 1e 80 00       	mov    $0x801e40,%ebx
  8002fb:	ba 0b 00 00 00       	mov    $0xb,%edx
  800300:	89 c7                	mov    %eax,%edi
  800302:	89 de                	mov    %ebx,%esi
  800304:	89 d1                	mov    %edx,%ecx
  800306:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	//cprintf("Checking PAGE LRU algorithm... \n");
	{
		CheckWSWithoutLastIndex(expectedPages, 11);
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	6a 0b                	push   $0xb
  80030d:	8d 45 88             	lea    -0x78(%ebp),%eax
  800310:	50                   	push   %eax
  800311:	e8 ca 01 00 00       	call   8004e0 <CheckWSWithoutLastIndex>
  800316:	83 c4 10             	add    $0x10,%esp
		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if(myEnv->page_last_WS_index != 5) panic("wrong PAGE WS pointer location");

	}

	cprintf("Congratulations!! test PAGE replacement [LRU Alg.] is completed successfully.\n");
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	68 e4 1d 80 00       	push   $0x801de4
  800321:	e8 fc 03 00 00       	call   800722 <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	return;
  800329:	90                   	nop
}
  80032a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80032d:	5b                   	pop    %ebx
  80032e:	5e                   	pop    %esi
  80032f:	5f                   	pop    %edi
  800330:	5d                   	pop    %ebp
  800331:	c3                   	ret    

00800332 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800338:	e8 3b 15 00 00       	call   801878 <sys_getenvindex>
  80033d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800340:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800343:	89 d0                	mov    %edx,%eax
  800345:	c1 e0 03             	shl    $0x3,%eax
  800348:	01 d0                	add    %edx,%eax
  80034a:	01 c0                	add    %eax,%eax
  80034c:	01 d0                	add    %edx,%eax
  80034e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800355:	01 d0                	add    %edx,%eax
  800357:	c1 e0 04             	shl    $0x4,%eax
  80035a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80035f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800364:	a1 20 30 80 00       	mov    0x803020,%eax
  800369:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80036f:	84 c0                	test   %al,%al
  800371:	74 0f                	je     800382 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800373:	a1 20 30 80 00       	mov    0x803020,%eax
  800378:	05 5c 05 00 00       	add    $0x55c,%eax
  80037d:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800382:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800386:	7e 0a                	jle    800392 <libmain+0x60>
		binaryname = argv[0];
  800388:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	ff 75 0c             	pushl  0xc(%ebp)
  800398:	ff 75 08             	pushl  0x8(%ebp)
  80039b:	e8 98 fc ff ff       	call   800038 <_main>
  8003a0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003a3:	e8 dd 12 00 00       	call   801685 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	68 84 1e 80 00       	push   $0x801e84
  8003b0:	e8 6d 03 00 00       	call   800722 <cprintf>
  8003b5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003bd:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003c8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	52                   	push   %edx
  8003d2:	50                   	push   %eax
  8003d3:	68 ac 1e 80 00       	push   $0x801eac
  8003d8:	e8 45 03 00 00       	call   800722 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8003e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8003eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8003f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8003fb:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800401:	51                   	push   %ecx
  800402:	52                   	push   %edx
  800403:	50                   	push   %eax
  800404:	68 d4 1e 80 00       	push   $0x801ed4
  800409:	e8 14 03 00 00       	call   800722 <cprintf>
  80040e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800411:	a1 20 30 80 00       	mov    0x803020,%eax
  800416:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	50                   	push   %eax
  800420:	68 2c 1f 80 00       	push   $0x801f2c
  800425:	e8 f8 02 00 00       	call   800722 <cprintf>
  80042a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80042d:	83 ec 0c             	sub    $0xc,%esp
  800430:	68 84 1e 80 00       	push   $0x801e84
  800435:	e8 e8 02 00 00       	call   800722 <cprintf>
  80043a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80043d:	e8 5d 12 00 00       	call   80169f <sys_enable_interrupt>

	// exit gracefully
	exit();
  800442:	e8 19 00 00 00       	call   800460 <exit>
}
  800447:	90                   	nop
  800448:	c9                   	leave  
  800449:	c3                   	ret    

0080044a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80044a:	55                   	push   %ebp
  80044b:	89 e5                	mov    %esp,%ebp
  80044d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800450:	83 ec 0c             	sub    $0xc,%esp
  800453:	6a 00                	push   $0x0
  800455:	e8 ea 13 00 00       	call   801844 <sys_destroy_env>
  80045a:	83 c4 10             	add    $0x10,%esp
}
  80045d:	90                   	nop
  80045e:	c9                   	leave  
  80045f:	c3                   	ret    

00800460 <exit>:

void
exit(void)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800466:	e8 3f 14 00 00       	call   8018aa <sys_exit_env>
}
  80046b:	90                   	nop
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800474:	8d 45 10             	lea    0x10(%ebp),%eax
  800477:	83 c0 04             	add    $0x4,%eax
  80047a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80047d:	a1 5c f1 80 00       	mov    0x80f15c,%eax
  800482:	85 c0                	test   %eax,%eax
  800484:	74 16                	je     80049c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800486:	a1 5c f1 80 00       	mov    0x80f15c,%eax
  80048b:	83 ec 08             	sub    $0x8,%esp
  80048e:	50                   	push   %eax
  80048f:	68 40 1f 80 00       	push   $0x801f40
  800494:	e8 89 02 00 00       	call   800722 <cprintf>
  800499:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80049c:	a1 08 30 80 00       	mov    0x803008,%eax
  8004a1:	ff 75 0c             	pushl  0xc(%ebp)
  8004a4:	ff 75 08             	pushl  0x8(%ebp)
  8004a7:	50                   	push   %eax
  8004a8:	68 45 1f 80 00       	push   $0x801f45
  8004ad:	e8 70 02 00 00       	call   800722 <cprintf>
  8004b2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b8:	83 ec 08             	sub    $0x8,%esp
  8004bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004be:	50                   	push   %eax
  8004bf:	e8 f3 01 00 00       	call   8006b7 <vcprintf>
  8004c4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	6a 00                	push   $0x0
  8004cc:	68 61 1f 80 00       	push   $0x801f61
  8004d1:	e8 e1 01 00 00       	call   8006b7 <vcprintf>
  8004d6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8004d9:	e8 82 ff ff ff       	call   800460 <exit>

	// should not return here
	while (1) ;
  8004de:	eb fe                	jmp    8004de <_panic+0x70>

008004e0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004e6:	a1 20 30 80 00       	mov    0x803020,%eax
  8004eb:	8b 50 74             	mov    0x74(%eax),%edx
  8004ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f1:	39 c2                	cmp    %eax,%edx
  8004f3:	74 14                	je     800509 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004f5:	83 ec 04             	sub    $0x4,%esp
  8004f8:	68 64 1f 80 00       	push   $0x801f64
  8004fd:	6a 26                	push   $0x26
  8004ff:	68 b0 1f 80 00       	push   $0x801fb0
  800504:	e8 65 ff ff ff       	call   80046e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800509:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800510:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800517:	e9 c2 00 00 00       	jmp    8005de <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80051c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800526:	8b 45 08             	mov    0x8(%ebp),%eax
  800529:	01 d0                	add    %edx,%eax
  80052b:	8b 00                	mov    (%eax),%eax
  80052d:	85 c0                	test   %eax,%eax
  80052f:	75 08                	jne    800539 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800531:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800534:	e9 a2 00 00 00       	jmp    8005db <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800539:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800540:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800547:	eb 69                	jmp    8005b2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800549:	a1 20 30 80 00       	mov    0x803020,%eax
  80054e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800554:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800557:	89 d0                	mov    %edx,%eax
  800559:	01 c0                	add    %eax,%eax
  80055b:	01 d0                	add    %edx,%eax
  80055d:	c1 e0 03             	shl    $0x3,%eax
  800560:	01 c8                	add    %ecx,%eax
  800562:	8a 40 04             	mov    0x4(%eax),%al
  800565:	84 c0                	test   %al,%al
  800567:	75 46                	jne    8005af <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800569:	a1 20 30 80 00       	mov    0x803020,%eax
  80056e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800574:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800577:	89 d0                	mov    %edx,%eax
  800579:	01 c0                	add    %eax,%eax
  80057b:	01 d0                	add    %edx,%eax
  80057d:	c1 e0 03             	shl    $0x3,%eax
  800580:	01 c8                	add    %ecx,%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800587:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80058a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80058f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800591:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800594:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	01 c8                	add    %ecx,%eax
  8005a0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a2:	39 c2                	cmp    %eax,%edx
  8005a4:	75 09                	jne    8005af <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005a6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005ad:	eb 12                	jmp    8005c1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005af:	ff 45 e8             	incl   -0x18(%ebp)
  8005b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b7:	8b 50 74             	mov    0x74(%eax),%edx
  8005ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005bd:	39 c2                	cmp    %eax,%edx
  8005bf:	77 88                	ja     800549 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005c5:	75 14                	jne    8005db <CheckWSWithoutLastIndex+0xfb>
			panic(
  8005c7:	83 ec 04             	sub    $0x4,%esp
  8005ca:	68 bc 1f 80 00       	push   $0x801fbc
  8005cf:	6a 3a                	push   $0x3a
  8005d1:	68 b0 1f 80 00       	push   $0x801fb0
  8005d6:	e8 93 fe ff ff       	call   80046e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8005db:	ff 45 f0             	incl   -0x10(%ebp)
  8005de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005e4:	0f 8c 32 ff ff ff    	jl     80051c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005ea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005f1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005f8:	eb 26                	jmp    800620 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ff:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800605:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800608:	89 d0                	mov    %edx,%eax
  80060a:	01 c0                	add    %eax,%eax
  80060c:	01 d0                	add    %edx,%eax
  80060e:	c1 e0 03             	shl    $0x3,%eax
  800611:	01 c8                	add    %ecx,%eax
  800613:	8a 40 04             	mov    0x4(%eax),%al
  800616:	3c 01                	cmp    $0x1,%al
  800618:	75 03                	jne    80061d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80061a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061d:	ff 45 e0             	incl   -0x20(%ebp)
  800620:	a1 20 30 80 00       	mov    0x803020,%eax
  800625:	8b 50 74             	mov    0x74(%eax),%edx
  800628:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80062b:	39 c2                	cmp    %eax,%edx
  80062d:	77 cb                	ja     8005fa <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80062f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800632:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800635:	74 14                	je     80064b <CheckWSWithoutLastIndex+0x16b>
		panic(
  800637:	83 ec 04             	sub    $0x4,%esp
  80063a:	68 10 20 80 00       	push   $0x802010
  80063f:	6a 44                	push   $0x44
  800641:	68 b0 1f 80 00       	push   $0x801fb0
  800646:	e8 23 fe ff ff       	call   80046e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80064b:	90                   	nop
  80064c:	c9                   	leave  
  80064d:	c3                   	ret    

0080064e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80064e:	55                   	push   %ebp
  80064f:	89 e5                	mov    %esp,%ebp
  800651:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800654:	8b 45 0c             	mov    0xc(%ebp),%eax
  800657:	8b 00                	mov    (%eax),%eax
  800659:	8d 48 01             	lea    0x1(%eax),%ecx
  80065c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80065f:	89 0a                	mov    %ecx,(%edx)
  800661:	8b 55 08             	mov    0x8(%ebp),%edx
  800664:	88 d1                	mov    %dl,%cl
  800666:	8b 55 0c             	mov    0xc(%ebp),%edx
  800669:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80066d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800670:	8b 00                	mov    (%eax),%eax
  800672:	3d ff 00 00 00       	cmp    $0xff,%eax
  800677:	75 2c                	jne    8006a5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800679:	a0 24 30 80 00       	mov    0x803024,%al
  80067e:	0f b6 c0             	movzbl %al,%eax
  800681:	8b 55 0c             	mov    0xc(%ebp),%edx
  800684:	8b 12                	mov    (%edx),%edx
  800686:	89 d1                	mov    %edx,%ecx
  800688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068b:	83 c2 08             	add    $0x8,%edx
  80068e:	83 ec 04             	sub    $0x4,%esp
  800691:	50                   	push   %eax
  800692:	51                   	push   %ecx
  800693:	52                   	push   %edx
  800694:	e8 3e 0e 00 00       	call   8014d7 <sys_cputs>
  800699:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80069c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a8:	8b 40 04             	mov    0x4(%eax),%eax
  8006ab:	8d 50 01             	lea    0x1(%eax),%edx
  8006ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006b4:	90                   	nop
  8006b5:	c9                   	leave  
  8006b6:	c3                   	ret    

008006b7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006b7:	55                   	push   %ebp
  8006b8:	89 e5                	mov    %esp,%ebp
  8006ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006c7:	00 00 00 
	b.cnt = 0;
  8006ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006d1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006d4:	ff 75 0c             	pushl  0xc(%ebp)
  8006d7:	ff 75 08             	pushl  0x8(%ebp)
  8006da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006e0:	50                   	push   %eax
  8006e1:	68 4e 06 80 00       	push   $0x80064e
  8006e6:	e8 11 02 00 00       	call   8008fc <vprintfmt>
  8006eb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8006ee:	a0 24 30 80 00       	mov    0x803024,%al
  8006f3:	0f b6 c0             	movzbl %al,%eax
  8006f6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	50                   	push   %eax
  800700:	52                   	push   %edx
  800701:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800707:	83 c0 08             	add    $0x8,%eax
  80070a:	50                   	push   %eax
  80070b:	e8 c7 0d 00 00       	call   8014d7 <sys_cputs>
  800710:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800713:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80071a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800720:	c9                   	leave  
  800721:	c3                   	ret    

00800722 <cprintf>:

int cprintf(const char *fmt, ...) {
  800722:	55                   	push   %ebp
  800723:	89 e5                	mov    %esp,%ebp
  800725:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800728:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  80072f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800732:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	83 ec 08             	sub    $0x8,%esp
  80073b:	ff 75 f4             	pushl  -0xc(%ebp)
  80073e:	50                   	push   %eax
  80073f:	e8 73 ff ff ff       	call   8006b7 <vcprintf>
  800744:	83 c4 10             	add    $0x10,%esp
  800747:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80074a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80074d:	c9                   	leave  
  80074e:	c3                   	ret    

0080074f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800755:	e8 2b 0f 00 00       	call   801685 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80075a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80075d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 f4             	pushl  -0xc(%ebp)
  800769:	50                   	push   %eax
  80076a:	e8 48 ff ff ff       	call   8006b7 <vcprintf>
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800775:	e8 25 0f 00 00       	call   80169f <sys_enable_interrupt>
	return cnt;
  80077a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80077d:	c9                   	leave  
  80077e:	c3                   	ret    

0080077f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80077f:	55                   	push   %ebp
  800780:	89 e5                	mov    %esp,%ebp
  800782:	53                   	push   %ebx
  800783:	83 ec 14             	sub    $0x14,%esp
  800786:	8b 45 10             	mov    0x10(%ebp),%eax
  800789:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800792:	8b 45 18             	mov    0x18(%ebp),%eax
  800795:	ba 00 00 00 00       	mov    $0x0,%edx
  80079a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80079d:	77 55                	ja     8007f4 <printnum+0x75>
  80079f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007a2:	72 05                	jb     8007a9 <printnum+0x2a>
  8007a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007a7:	77 4b                	ja     8007f4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007ac:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007af:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b7:	52                   	push   %edx
  8007b8:	50                   	push   %eax
  8007b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8007bf:	e8 48 13 00 00       	call   801b0c <__udivdi3>
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	83 ec 04             	sub    $0x4,%esp
  8007ca:	ff 75 20             	pushl  0x20(%ebp)
  8007cd:	53                   	push   %ebx
  8007ce:	ff 75 18             	pushl  0x18(%ebp)
  8007d1:	52                   	push   %edx
  8007d2:	50                   	push   %eax
  8007d3:	ff 75 0c             	pushl  0xc(%ebp)
  8007d6:	ff 75 08             	pushl  0x8(%ebp)
  8007d9:	e8 a1 ff ff ff       	call   80077f <printnum>
  8007de:	83 c4 20             	add    $0x20,%esp
  8007e1:	eb 1a                	jmp    8007fd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007e3:	83 ec 08             	sub    $0x8,%esp
  8007e6:	ff 75 0c             	pushl  0xc(%ebp)
  8007e9:	ff 75 20             	pushl  0x20(%ebp)
  8007ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ef:	ff d0                	call   *%eax
  8007f1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007f4:	ff 4d 1c             	decl   0x1c(%ebp)
  8007f7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007fb:	7f e6                	jg     8007e3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007fd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800800:	bb 00 00 00 00       	mov    $0x0,%ebx
  800805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800808:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80080b:	53                   	push   %ebx
  80080c:	51                   	push   %ecx
  80080d:	52                   	push   %edx
  80080e:	50                   	push   %eax
  80080f:	e8 08 14 00 00       	call   801c1c <__umoddi3>
  800814:	83 c4 10             	add    $0x10,%esp
  800817:	05 74 22 80 00       	add    $0x802274,%eax
  80081c:	8a 00                	mov    (%eax),%al
  80081e:	0f be c0             	movsbl %al,%eax
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	ff 75 0c             	pushl  0xc(%ebp)
  800827:	50                   	push   %eax
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
}
  800830:	90                   	nop
  800831:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800834:	c9                   	leave  
  800835:	c3                   	ret    

00800836 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800836:	55                   	push   %ebp
  800837:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800839:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80083d:	7e 1c                	jle    80085b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	8b 00                	mov    (%eax),%eax
  800844:	8d 50 08             	lea    0x8(%eax),%edx
  800847:	8b 45 08             	mov    0x8(%ebp),%eax
  80084a:	89 10                	mov    %edx,(%eax)
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	83 e8 08             	sub    $0x8,%eax
  800854:	8b 50 04             	mov    0x4(%eax),%edx
  800857:	8b 00                	mov    (%eax),%eax
  800859:	eb 40                	jmp    80089b <getuint+0x65>
	else if (lflag)
  80085b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80085f:	74 1e                	je     80087f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	8b 00                	mov    (%eax),%eax
  800866:	8d 50 04             	lea    0x4(%eax),%edx
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	89 10                	mov    %edx,(%eax)
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	8b 00                	mov    (%eax),%eax
  800873:	83 e8 04             	sub    $0x4,%eax
  800876:	8b 00                	mov    (%eax),%eax
  800878:	ba 00 00 00 00       	mov    $0x0,%edx
  80087d:	eb 1c                	jmp    80089b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	8b 00                	mov    (%eax),%eax
  800884:	8d 50 04             	lea    0x4(%eax),%edx
  800887:	8b 45 08             	mov    0x8(%ebp),%eax
  80088a:	89 10                	mov    %edx,(%eax)
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	83 e8 04             	sub    $0x4,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    

0080089d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a4:	7e 1c                	jle    8008c2 <getint+0x25>
		return va_arg(*ap, long long);
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	8b 00                	mov    (%eax),%eax
  8008ab:	8d 50 08             	lea    0x8(%eax),%edx
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	89 10                	mov    %edx,(%eax)
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	83 e8 08             	sub    $0x8,%eax
  8008bb:	8b 50 04             	mov    0x4(%eax),%edx
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	eb 38                	jmp    8008fa <getint+0x5d>
	else if (lflag)
  8008c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c6:	74 1a                	je     8008e2 <getint+0x45>
		return va_arg(*ap, long);
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	8b 00                	mov    (%eax),%eax
  8008cd:	8d 50 04             	lea    0x4(%eax),%edx
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	89 10                	mov    %edx,(%eax)
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	83 e8 04             	sub    $0x4,%eax
  8008dd:	8b 00                	mov    (%eax),%eax
  8008df:	99                   	cltd   
  8008e0:	eb 18                	jmp    8008fa <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	8b 00                	mov    (%eax),%eax
  8008e7:	8d 50 04             	lea    0x4(%eax),%edx
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	89 10                	mov    %edx,(%eax)
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	83 e8 04             	sub    $0x4,%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	99                   	cltd   
}
  8008fa:	5d                   	pop    %ebp
  8008fb:	c3                   	ret    

008008fc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	56                   	push   %esi
  800900:	53                   	push   %ebx
  800901:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800904:	eb 17                	jmp    80091d <vprintfmt+0x21>
			if (ch == '\0')
  800906:	85 db                	test   %ebx,%ebx
  800908:	0f 84 af 03 00 00    	je     800cbd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 0c             	pushl  0xc(%ebp)
  800914:	53                   	push   %ebx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	ff d0                	call   *%eax
  80091a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091d:	8b 45 10             	mov    0x10(%ebp),%eax
  800920:	8d 50 01             	lea    0x1(%eax),%edx
  800923:	89 55 10             	mov    %edx,0x10(%ebp)
  800926:	8a 00                	mov    (%eax),%al
  800928:	0f b6 d8             	movzbl %al,%ebx
  80092b:	83 fb 25             	cmp    $0x25,%ebx
  80092e:	75 d6                	jne    800906 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800930:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800934:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80093b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800942:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800949:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800950:	8b 45 10             	mov    0x10(%ebp),%eax
  800953:	8d 50 01             	lea    0x1(%eax),%edx
  800956:	89 55 10             	mov    %edx,0x10(%ebp)
  800959:	8a 00                	mov    (%eax),%al
  80095b:	0f b6 d8             	movzbl %al,%ebx
  80095e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800961:	83 f8 55             	cmp    $0x55,%eax
  800964:	0f 87 2b 03 00 00    	ja     800c95 <vprintfmt+0x399>
  80096a:	8b 04 85 98 22 80 00 	mov    0x802298(,%eax,4),%eax
  800971:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800973:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800977:	eb d7                	jmp    800950 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800979:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80097d:	eb d1                	jmp    800950 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80097f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800986:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800989:	89 d0                	mov    %edx,%eax
  80098b:	c1 e0 02             	shl    $0x2,%eax
  80098e:	01 d0                	add    %edx,%eax
  800990:	01 c0                	add    %eax,%eax
  800992:	01 d8                	add    %ebx,%eax
  800994:	83 e8 30             	sub    $0x30,%eax
  800997:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80099a:	8b 45 10             	mov    0x10(%ebp),%eax
  80099d:	8a 00                	mov    (%eax),%al
  80099f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009a2:	83 fb 2f             	cmp    $0x2f,%ebx
  8009a5:	7e 3e                	jle    8009e5 <vprintfmt+0xe9>
  8009a7:	83 fb 39             	cmp    $0x39,%ebx
  8009aa:	7f 39                	jg     8009e5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009ac:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009af:	eb d5                	jmp    800986 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b4:	83 c0 04             	add    $0x4,%eax
  8009b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bd:	83 e8 04             	sub    $0x4,%eax
  8009c0:	8b 00                	mov    (%eax),%eax
  8009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009c5:	eb 1f                	jmp    8009e6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009cb:	79 83                	jns    800950 <vprintfmt+0x54>
				width = 0;
  8009cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009d4:	e9 77 ff ff ff       	jmp    800950 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009d9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009e0:	e9 6b ff ff ff       	jmp    800950 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009e5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ea:	0f 89 60 ff ff ff    	jns    800950 <vprintfmt+0x54>
				width = precision, precision = -1;
  8009f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009fd:	e9 4e ff ff ff       	jmp    800950 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a02:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a05:	e9 46 ff ff ff       	jmp    800950 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a0a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0d:	83 c0 04             	add    $0x4,%eax
  800a10:	89 45 14             	mov    %eax,0x14(%ebp)
  800a13:	8b 45 14             	mov    0x14(%ebp),%eax
  800a16:	83 e8 04             	sub    $0x4,%eax
  800a19:	8b 00                	mov    (%eax),%eax
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	50                   	push   %eax
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	ff d0                	call   *%eax
  800a27:	83 c4 10             	add    $0x10,%esp
			break;
  800a2a:	e9 89 02 00 00       	jmp    800cb8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a32:	83 c0 04             	add    $0x4,%eax
  800a35:	89 45 14             	mov    %eax,0x14(%ebp)
  800a38:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3b:	83 e8 04             	sub    $0x4,%eax
  800a3e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a40:	85 db                	test   %ebx,%ebx
  800a42:	79 02                	jns    800a46 <vprintfmt+0x14a>
				err = -err;
  800a44:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a46:	83 fb 64             	cmp    $0x64,%ebx
  800a49:	7f 0b                	jg     800a56 <vprintfmt+0x15a>
  800a4b:	8b 34 9d e0 20 80 00 	mov    0x8020e0(,%ebx,4),%esi
  800a52:	85 f6                	test   %esi,%esi
  800a54:	75 19                	jne    800a6f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a56:	53                   	push   %ebx
  800a57:	68 85 22 80 00       	push   $0x802285
  800a5c:	ff 75 0c             	pushl  0xc(%ebp)
  800a5f:	ff 75 08             	pushl  0x8(%ebp)
  800a62:	e8 5e 02 00 00       	call   800cc5 <printfmt>
  800a67:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a6a:	e9 49 02 00 00       	jmp    800cb8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a6f:	56                   	push   %esi
  800a70:	68 8e 22 80 00       	push   $0x80228e
  800a75:	ff 75 0c             	pushl  0xc(%ebp)
  800a78:	ff 75 08             	pushl  0x8(%ebp)
  800a7b:	e8 45 02 00 00       	call   800cc5 <printfmt>
  800a80:	83 c4 10             	add    $0x10,%esp
			break;
  800a83:	e9 30 02 00 00       	jmp    800cb8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	83 c0 04             	add    $0x4,%eax
  800a8e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a91:	8b 45 14             	mov    0x14(%ebp),%eax
  800a94:	83 e8 04             	sub    $0x4,%eax
  800a97:	8b 30                	mov    (%eax),%esi
  800a99:	85 f6                	test   %esi,%esi
  800a9b:	75 05                	jne    800aa2 <vprintfmt+0x1a6>
				p = "(null)";
  800a9d:	be 91 22 80 00       	mov    $0x802291,%esi
			if (width > 0 && padc != '-')
  800aa2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa6:	7e 6d                	jle    800b15 <vprintfmt+0x219>
  800aa8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800aac:	74 67                	je     800b15 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800aae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	50                   	push   %eax
  800ab5:	56                   	push   %esi
  800ab6:	e8 0c 03 00 00       	call   800dc7 <strnlen>
  800abb:	83 c4 10             	add    $0x10,%esp
  800abe:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ac1:	eb 16                	jmp    800ad9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ac3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	50                   	push   %eax
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	ff d0                	call   *%eax
  800ad3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad6:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800add:	7f e4                	jg     800ac3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800adf:	eb 34                	jmp    800b15 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800ae1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ae5:	74 1c                	je     800b03 <vprintfmt+0x207>
  800ae7:	83 fb 1f             	cmp    $0x1f,%ebx
  800aea:	7e 05                	jle    800af1 <vprintfmt+0x1f5>
  800aec:	83 fb 7e             	cmp    $0x7e,%ebx
  800aef:	7e 12                	jle    800b03 <vprintfmt+0x207>
					putch('?', putdat);
  800af1:	83 ec 08             	sub    $0x8,%esp
  800af4:	ff 75 0c             	pushl  0xc(%ebp)
  800af7:	6a 3f                	push   $0x3f
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	ff d0                	call   *%eax
  800afe:	83 c4 10             	add    $0x10,%esp
  800b01:	eb 0f                	jmp    800b12 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b03:	83 ec 08             	sub    $0x8,%esp
  800b06:	ff 75 0c             	pushl  0xc(%ebp)
  800b09:	53                   	push   %ebx
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	ff d0                	call   *%eax
  800b0f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b12:	ff 4d e4             	decl   -0x1c(%ebp)
  800b15:	89 f0                	mov    %esi,%eax
  800b17:	8d 70 01             	lea    0x1(%eax),%esi
  800b1a:	8a 00                	mov    (%eax),%al
  800b1c:	0f be d8             	movsbl %al,%ebx
  800b1f:	85 db                	test   %ebx,%ebx
  800b21:	74 24                	je     800b47 <vprintfmt+0x24b>
  800b23:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b27:	78 b8                	js     800ae1 <vprintfmt+0x1e5>
  800b29:	ff 4d e0             	decl   -0x20(%ebp)
  800b2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b30:	79 af                	jns    800ae1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b32:	eb 13                	jmp    800b47 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b34:	83 ec 08             	sub    $0x8,%esp
  800b37:	ff 75 0c             	pushl  0xc(%ebp)
  800b3a:	6a 20                	push   $0x20
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	ff d0                	call   *%eax
  800b41:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b44:	ff 4d e4             	decl   -0x1c(%ebp)
  800b47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b4b:	7f e7                	jg     800b34 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b4d:	e9 66 01 00 00       	jmp    800cb8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b52:	83 ec 08             	sub    $0x8,%esp
  800b55:	ff 75 e8             	pushl  -0x18(%ebp)
  800b58:	8d 45 14             	lea    0x14(%ebp),%eax
  800b5b:	50                   	push   %eax
  800b5c:	e8 3c fd ff ff       	call   80089d <getint>
  800b61:	83 c4 10             	add    $0x10,%esp
  800b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b70:	85 d2                	test   %edx,%edx
  800b72:	79 23                	jns    800b97 <vprintfmt+0x29b>
				putch('-', putdat);
  800b74:	83 ec 08             	sub    $0x8,%esp
  800b77:	ff 75 0c             	pushl  0xc(%ebp)
  800b7a:	6a 2d                	push   $0x2d
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	ff d0                	call   *%eax
  800b81:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8a:	f7 d8                	neg    %eax
  800b8c:	83 d2 00             	adc    $0x0,%edx
  800b8f:	f7 da                	neg    %edx
  800b91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b9e:	e9 bc 00 00 00       	jmp    800c5f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba9:	8d 45 14             	lea    0x14(%ebp),%eax
  800bac:	50                   	push   %eax
  800bad:	e8 84 fc ff ff       	call   800836 <getuint>
  800bb2:	83 c4 10             	add    $0x10,%esp
  800bb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bbb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bc2:	e9 98 00 00 00       	jmp    800c5f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 0c             	pushl  0xc(%ebp)
  800bcd:	6a 58                	push   $0x58
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	ff d0                	call   *%eax
  800bd4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bd7:	83 ec 08             	sub    $0x8,%esp
  800bda:	ff 75 0c             	pushl  0xc(%ebp)
  800bdd:	6a 58                	push   $0x58
  800bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800be2:	ff d0                	call   *%eax
  800be4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800be7:	83 ec 08             	sub    $0x8,%esp
  800bea:	ff 75 0c             	pushl  0xc(%ebp)
  800bed:	6a 58                	push   $0x58
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	ff d0                	call   *%eax
  800bf4:	83 c4 10             	add    $0x10,%esp
			break;
  800bf7:	e9 bc 00 00 00       	jmp    800cb8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800bfc:	83 ec 08             	sub    $0x8,%esp
  800bff:	ff 75 0c             	pushl  0xc(%ebp)
  800c02:	6a 30                	push   $0x30
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	ff d0                	call   *%eax
  800c09:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c0c:	83 ec 08             	sub    $0x8,%esp
  800c0f:	ff 75 0c             	pushl  0xc(%ebp)
  800c12:	6a 78                	push   $0x78
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	ff d0                	call   *%eax
  800c19:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1f:	83 c0 04             	add    $0x4,%eax
  800c22:	89 45 14             	mov    %eax,0x14(%ebp)
  800c25:	8b 45 14             	mov    0x14(%ebp),%eax
  800c28:	83 e8 04             	sub    $0x4,%eax
  800c2b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c37:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c3e:	eb 1f                	jmp    800c5f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c40:	83 ec 08             	sub    $0x8,%esp
  800c43:	ff 75 e8             	pushl  -0x18(%ebp)
  800c46:	8d 45 14             	lea    0x14(%ebp),%eax
  800c49:	50                   	push   %eax
  800c4a:	e8 e7 fb ff ff       	call   800836 <getuint>
  800c4f:	83 c4 10             	add    $0x10,%esp
  800c52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c5f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c66:	83 ec 04             	sub    $0x4,%esp
  800c69:	52                   	push   %edx
  800c6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c6d:	50                   	push   %eax
  800c6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c71:	ff 75 f0             	pushl  -0x10(%ebp)
  800c74:	ff 75 0c             	pushl  0xc(%ebp)
  800c77:	ff 75 08             	pushl  0x8(%ebp)
  800c7a:	e8 00 fb ff ff       	call   80077f <printnum>
  800c7f:	83 c4 20             	add    $0x20,%esp
			break;
  800c82:	eb 34                	jmp    800cb8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c84:	83 ec 08             	sub    $0x8,%esp
  800c87:	ff 75 0c             	pushl  0xc(%ebp)
  800c8a:	53                   	push   %ebx
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	ff d0                	call   *%eax
  800c90:	83 c4 10             	add    $0x10,%esp
			break;
  800c93:	eb 23                	jmp    800cb8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c95:	83 ec 08             	sub    $0x8,%esp
  800c98:	ff 75 0c             	pushl  0xc(%ebp)
  800c9b:	6a 25                	push   $0x25
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	ff d0                	call   *%eax
  800ca2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ca5:	ff 4d 10             	decl   0x10(%ebp)
  800ca8:	eb 03                	jmp    800cad <vprintfmt+0x3b1>
  800caa:	ff 4d 10             	decl   0x10(%ebp)
  800cad:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb0:	48                   	dec    %eax
  800cb1:	8a 00                	mov    (%eax),%al
  800cb3:	3c 25                	cmp    $0x25,%al
  800cb5:	75 f3                	jne    800caa <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cb7:	90                   	nop
		}
	}
  800cb8:	e9 47 fc ff ff       	jmp    800904 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cbd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ccb:	8d 45 10             	lea    0x10(%ebp),%eax
  800cce:	83 c0 04             	add    $0x4,%eax
  800cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800cda:	50                   	push   %eax
  800cdb:	ff 75 0c             	pushl  0xc(%ebp)
  800cde:	ff 75 08             	pushl  0x8(%ebp)
  800ce1:	e8 16 fc ff ff       	call   8008fc <vprintfmt>
  800ce6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ce9:	90                   	nop
  800cea:	c9                   	leave  
  800ceb:	c3                   	ret    

00800cec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf2:	8b 40 08             	mov    0x8(%eax),%eax
  800cf5:	8d 50 01             	lea    0x1(%eax),%edx
  800cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	8b 10                	mov    (%eax),%edx
  800d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d06:	8b 40 04             	mov    0x4(%eax),%eax
  800d09:	39 c2                	cmp    %eax,%edx
  800d0b:	73 12                	jae    800d1f <sprintputch+0x33>
		*b->buf++ = ch;
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8b 00                	mov    (%eax),%eax
  800d12:	8d 48 01             	lea    0x1(%eax),%ecx
  800d15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d18:	89 0a                	mov    %ecx,(%edx)
  800d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1d:	88 10                	mov    %dl,(%eax)
}
  800d1f:	90                   	nop
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	01 d0                	add    %edx,%eax
  800d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d47:	74 06                	je     800d4f <vsnprintf+0x2d>
  800d49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4d:	7f 07                	jg     800d56 <vsnprintf+0x34>
		return -E_INVAL;
  800d4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800d54:	eb 20                	jmp    800d76 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d56:	ff 75 14             	pushl  0x14(%ebp)
  800d59:	ff 75 10             	pushl  0x10(%ebp)
  800d5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d5f:	50                   	push   %eax
  800d60:	68 ec 0c 80 00       	push   $0x800cec
  800d65:	e8 92 fb ff ff       	call   8008fc <vprintfmt>
  800d6a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d70:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d76:	c9                   	leave  
  800d77:	c3                   	ret    

00800d78 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800d81:	83 c0 04             	add    $0x4,%eax
  800d84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d87:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d8d:	50                   	push   %eax
  800d8e:	ff 75 0c             	pushl  0xc(%ebp)
  800d91:	ff 75 08             	pushl  0x8(%ebp)
  800d94:	e8 89 ff ff ff       	call   800d22 <vsnprintf>
  800d99:	83 c4 10             	add    $0x10,%esp
  800d9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800da2:	c9                   	leave  
  800da3:	c3                   	ret    

00800da4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800daa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800db1:	eb 06                	jmp    800db9 <strlen+0x15>
		n++;
  800db3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800db6:	ff 45 08             	incl   0x8(%ebp)
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	84 c0                	test   %al,%al
  800dc0:	75 f1                	jne    800db3 <strlen+0xf>
		n++;
	return n;
  800dc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc5:	c9                   	leave  
  800dc6:	c3                   	ret    

00800dc7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dcd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dd4:	eb 09                	jmp    800ddf <strnlen+0x18>
		n++;
  800dd6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd9:	ff 45 08             	incl   0x8(%ebp)
  800ddc:	ff 4d 0c             	decl   0xc(%ebp)
  800ddf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de3:	74 09                	je     800dee <strnlen+0x27>
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	84 c0                	test   %al,%al
  800dec:	75 e8                	jne    800dd6 <strnlen+0xf>
		n++;
	return n;
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dff:	90                   	nop
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8d 50 01             	lea    0x1(%eax),%edx
  800e06:	89 55 08             	mov    %edx,0x8(%ebp)
  800e09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e12:	8a 12                	mov    (%edx),%dl
  800e14:	88 10                	mov    %dl,(%eax)
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	84 c0                	test   %al,%al
  800e1a:	75 e4                	jne    800e00 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1f:	c9                   	leave  
  800e20:	c3                   	ret    

00800e21 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e34:	eb 1f                	jmp    800e55 <strncpy+0x34>
		*dst++ = *src;
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	8d 50 01             	lea    0x1(%eax),%edx
  800e3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e42:	8a 12                	mov    (%edx),%dl
  800e44:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e49:	8a 00                	mov    (%eax),%al
  800e4b:	84 c0                	test   %al,%al
  800e4d:	74 03                	je     800e52 <strncpy+0x31>
			src++;
  800e4f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e52:	ff 45 fc             	incl   -0x4(%ebp)
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e58:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e5b:	72 d9                	jb     800e36 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e72:	74 30                	je     800ea4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e74:	eb 16                	jmp    800e8c <strlcpy+0x2a>
			*dst++ = *src++;
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8d 50 01             	lea    0x1(%eax),%edx
  800e7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e88:	8a 12                	mov    (%edx),%dl
  800e8a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e8c:	ff 4d 10             	decl   0x10(%ebp)
  800e8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e93:	74 09                	je     800e9e <strlcpy+0x3c>
  800e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	84 c0                	test   %al,%al
  800e9c:	75 d8                	jne    800e76 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eaa:	29 c2                	sub    %eax,%edx
  800eac:	89 d0                	mov    %edx,%eax
}
  800eae:	c9                   	leave  
  800eaf:	c3                   	ret    

00800eb0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800eb3:	eb 06                	jmp    800ebb <strcmp+0xb>
		p++, q++;
  800eb5:	ff 45 08             	incl   0x8(%ebp)
  800eb8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	8a 00                	mov    (%eax),%al
  800ec0:	84 c0                	test   %al,%al
  800ec2:	74 0e                	je     800ed2 <strcmp+0x22>
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	8a 10                	mov    (%eax),%dl
  800ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecc:	8a 00                	mov    (%eax),%al
  800ece:	38 c2                	cmp    %al,%dl
  800ed0:	74 e3                	je     800eb5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	0f b6 d0             	movzbl %al,%edx
  800eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	0f b6 c0             	movzbl %al,%eax
  800ee2:	29 c2                	sub    %eax,%edx
  800ee4:	89 d0                	mov    %edx,%eax
}
  800ee6:	5d                   	pop    %ebp
  800ee7:	c3                   	ret    

00800ee8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800eeb:	eb 09                	jmp    800ef6 <strncmp+0xe>
		n--, p++, q++;
  800eed:	ff 4d 10             	decl   0x10(%ebp)
  800ef0:	ff 45 08             	incl   0x8(%ebp)
  800ef3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ef6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efa:	74 17                	je     800f13 <strncmp+0x2b>
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	84 c0                	test   %al,%al
  800f03:	74 0e                	je     800f13 <strncmp+0x2b>
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	8a 10                	mov    (%eax),%dl
  800f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	38 c2                	cmp    %al,%dl
  800f11:	74 da                	je     800eed <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	75 07                	jne    800f20 <strncmp+0x38>
		return 0;
  800f19:	b8 00 00 00 00       	mov    $0x0,%eax
  800f1e:	eb 14                	jmp    800f34 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	0f b6 d0             	movzbl %al,%edx
  800f28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2b:	8a 00                	mov    (%eax),%al
  800f2d:	0f b6 c0             	movzbl %al,%eax
  800f30:	29 c2                	sub    %eax,%edx
  800f32:	89 d0                	mov    %edx,%eax
}
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    

00800f36 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	83 ec 04             	sub    $0x4,%esp
  800f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f42:	eb 12                	jmp    800f56 <strchr+0x20>
		if (*s == c)
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f4c:	75 05                	jne    800f53 <strchr+0x1d>
			return (char *) s;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	eb 11                	jmp    800f64 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f53:	ff 45 08             	incl   0x8(%ebp)
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	84 c0                	test   %al,%al
  800f5d:	75 e5                	jne    800f44 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f64:	c9                   	leave  
  800f65:	c3                   	ret    

00800f66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	83 ec 04             	sub    $0x4,%esp
  800f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f72:	eb 0d                	jmp    800f81 <strfind+0x1b>
		if (*s == c)
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f7c:	74 0e                	je     800f8c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f7e:	ff 45 08             	incl   0x8(%ebp)
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	84 c0                	test   %al,%al
  800f88:	75 ea                	jne    800f74 <strfind+0xe>
  800f8a:	eb 01                	jmp    800f8d <strfind+0x27>
		if (*s == c)
			break;
  800f8c:	90                   	nop
	return (char *) s;
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f90:	c9                   	leave  
  800f91:	c3                   	ret    

00800f92 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fa4:	eb 0e                	jmp    800fb4 <memset+0x22>
		*p++ = c;
  800fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa9:	8d 50 01             	lea    0x1(%eax),%edx
  800fac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800faf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fb2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fb4:	ff 4d f8             	decl   -0x8(%ebp)
  800fb7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fbb:	79 e9                	jns    800fa6 <memset+0x14>
		*p++ = c;

	return v;
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc0:	c9                   	leave  
  800fc1:	c3                   	ret    

00800fc2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fd4:	eb 16                	jmp    800fec <memcpy+0x2a>
		*d++ = *s++;
  800fd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd9:	8d 50 01             	lea    0x1(%eax),%edx
  800fdc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fdf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fe8:	8a 12                	mov    (%edx),%dl
  800fea:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800fec:	8b 45 10             	mov    0x10(%ebp),%eax
  800fef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff5:	85 c0                	test   %eax,%eax
  800ff7:	75 dd                	jne    800fd6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801010:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801013:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801016:	73 50                	jae    801068 <memmove+0x6a>
  801018:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80101b:	8b 45 10             	mov    0x10(%ebp),%eax
  80101e:	01 d0                	add    %edx,%eax
  801020:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801023:	76 43                	jbe    801068 <memmove+0x6a>
		s += n;
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80102b:	8b 45 10             	mov    0x10(%ebp),%eax
  80102e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801031:	eb 10                	jmp    801043 <memmove+0x45>
			*--d = *--s;
  801033:	ff 4d f8             	decl   -0x8(%ebp)
  801036:	ff 4d fc             	decl   -0x4(%ebp)
  801039:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103c:	8a 10                	mov    (%eax),%dl
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801043:	8b 45 10             	mov    0x10(%ebp),%eax
  801046:	8d 50 ff             	lea    -0x1(%eax),%edx
  801049:	89 55 10             	mov    %edx,0x10(%ebp)
  80104c:	85 c0                	test   %eax,%eax
  80104e:	75 e3                	jne    801033 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801050:	eb 23                	jmp    801075 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801052:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801055:	8d 50 01             	lea    0x1(%eax),%edx
  801058:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80105b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80105e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801061:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801064:	8a 12                	mov    (%edx),%dl
  801066:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801068:	8b 45 10             	mov    0x10(%ebp),%eax
  80106b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80106e:	89 55 10             	mov    %edx,0x10(%ebp)
  801071:	85 c0                	test   %eax,%eax
  801073:	75 dd                	jne    801052 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801086:	8b 45 0c             	mov    0xc(%ebp),%eax
  801089:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80108c:	eb 2a                	jmp    8010b8 <memcmp+0x3e>
		if (*s1 != *s2)
  80108e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801091:	8a 10                	mov    (%eax),%dl
  801093:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801096:	8a 00                	mov    (%eax),%al
  801098:	38 c2                	cmp    %al,%dl
  80109a:	74 16                	je     8010b2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80109c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109f:	8a 00                	mov    (%eax),%al
  8010a1:	0f b6 d0             	movzbl %al,%edx
  8010a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	0f b6 c0             	movzbl %al,%eax
  8010ac:	29 c2                	sub    %eax,%edx
  8010ae:	89 d0                	mov    %edx,%eax
  8010b0:	eb 18                	jmp    8010ca <memcmp+0x50>
		s1++, s2++;
  8010b2:	ff 45 fc             	incl   -0x4(%ebp)
  8010b5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010be:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	75 c9                	jne    80108e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ca:	c9                   	leave  
  8010cb:	c3                   	ret    

008010cc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d8:	01 d0                	add    %edx,%eax
  8010da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010dd:	eb 15                	jmp    8010f4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	0f b6 d0             	movzbl %al,%edx
  8010e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ea:	0f b6 c0             	movzbl %al,%eax
  8010ed:	39 c2                	cmp    %eax,%edx
  8010ef:	74 0d                	je     8010fe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010f1:	ff 45 08             	incl   0x8(%ebp)
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010fa:	72 e3                	jb     8010df <memfind+0x13>
  8010fc:	eb 01                	jmp    8010ff <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010fe:	90                   	nop
	return (void *) s;
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80110a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801111:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801118:	eb 03                	jmp    80111d <strtol+0x19>
		s++;
  80111a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	8a 00                	mov    (%eax),%al
  801122:	3c 20                	cmp    $0x20,%al
  801124:	74 f4                	je     80111a <strtol+0x16>
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	3c 09                	cmp    $0x9,%al
  80112d:	74 eb                	je     80111a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	8a 00                	mov    (%eax),%al
  801134:	3c 2b                	cmp    $0x2b,%al
  801136:	75 05                	jne    80113d <strtol+0x39>
		s++;
  801138:	ff 45 08             	incl   0x8(%ebp)
  80113b:	eb 13                	jmp    801150 <strtol+0x4c>
	else if (*s == '-')
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	3c 2d                	cmp    $0x2d,%al
  801144:	75 0a                	jne    801150 <strtol+0x4c>
		s++, neg = 1;
  801146:	ff 45 08             	incl   0x8(%ebp)
  801149:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801150:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801154:	74 06                	je     80115c <strtol+0x58>
  801156:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80115a:	75 20                	jne    80117c <strtol+0x78>
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	8a 00                	mov    (%eax),%al
  801161:	3c 30                	cmp    $0x30,%al
  801163:	75 17                	jne    80117c <strtol+0x78>
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	40                   	inc    %eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	3c 78                	cmp    $0x78,%al
  80116d:	75 0d                	jne    80117c <strtol+0x78>
		s += 2, base = 16;
  80116f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801173:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80117a:	eb 28                	jmp    8011a4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80117c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801180:	75 15                	jne    801197 <strtol+0x93>
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	3c 30                	cmp    $0x30,%al
  801189:	75 0c                	jne    801197 <strtol+0x93>
		s++, base = 8;
  80118b:	ff 45 08             	incl   0x8(%ebp)
  80118e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801195:	eb 0d                	jmp    8011a4 <strtol+0xa0>
	else if (base == 0)
  801197:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119b:	75 07                	jne    8011a4 <strtol+0xa0>
		base = 10;
  80119d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	3c 2f                	cmp    $0x2f,%al
  8011ab:	7e 19                	jle    8011c6 <strtol+0xc2>
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	3c 39                	cmp    $0x39,%al
  8011b4:	7f 10                	jg     8011c6 <strtol+0xc2>
			dig = *s - '0';
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b9:	8a 00                	mov    (%eax),%al
  8011bb:	0f be c0             	movsbl %al,%eax
  8011be:	83 e8 30             	sub    $0x30,%eax
  8011c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011c4:	eb 42                	jmp    801208 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	3c 60                	cmp    $0x60,%al
  8011cd:	7e 19                	jle    8011e8 <strtol+0xe4>
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 7a                	cmp    $0x7a,%al
  8011d6:	7f 10                	jg     8011e8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	0f be c0             	movsbl %al,%eax
  8011e0:	83 e8 57             	sub    $0x57,%eax
  8011e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011e6:	eb 20                	jmp    801208 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	3c 40                	cmp    $0x40,%al
  8011ef:	7e 39                	jle    80122a <strtol+0x126>
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3c 5a                	cmp    $0x5a,%al
  8011f8:	7f 30                	jg     80122a <strtol+0x126>
			dig = *s - 'A' + 10;
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	0f be c0             	movsbl %al,%eax
  801202:	83 e8 37             	sub    $0x37,%eax
  801205:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80120b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80120e:	7d 19                	jge    801229 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801210:	ff 45 08             	incl   0x8(%ebp)
  801213:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801216:	0f af 45 10          	imul   0x10(%ebp),%eax
  80121a:	89 c2                	mov    %eax,%edx
  80121c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80121f:	01 d0                	add    %edx,%eax
  801221:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801224:	e9 7b ff ff ff       	jmp    8011a4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801229:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80122a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80122e:	74 08                	je     801238 <strtol+0x134>
		*endptr = (char *) s;
  801230:	8b 45 0c             	mov    0xc(%ebp),%eax
  801233:	8b 55 08             	mov    0x8(%ebp),%edx
  801236:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801238:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80123c:	74 07                	je     801245 <strtol+0x141>
  80123e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801241:	f7 d8                	neg    %eax
  801243:	eb 03                	jmp    801248 <strtol+0x144>
  801245:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801248:	c9                   	leave  
  801249:	c3                   	ret    

0080124a <ltostr>:

void
ltostr(long value, char *str)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801250:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801257:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80125e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801262:	79 13                	jns    801277 <ltostr+0x2d>
	{
		neg = 1;
  801264:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80126b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801271:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801274:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80127f:	99                   	cltd   
  801280:	f7 f9                	idiv   %ecx
  801282:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801285:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801288:	8d 50 01             	lea    0x1(%eax),%edx
  80128b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80128e:	89 c2                	mov    %eax,%edx
  801290:	8b 45 0c             	mov    0xc(%ebp),%eax
  801293:	01 d0                	add    %edx,%eax
  801295:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801298:	83 c2 30             	add    $0x30,%edx
  80129b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80129d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012a5:	f7 e9                	imul   %ecx
  8012a7:	c1 fa 02             	sar    $0x2,%edx
  8012aa:	89 c8                	mov    %ecx,%eax
  8012ac:	c1 f8 1f             	sar    $0x1f,%eax
  8012af:	29 c2                	sub    %eax,%edx
  8012b1:	89 d0                	mov    %edx,%eax
  8012b3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012b9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012be:	f7 e9                	imul   %ecx
  8012c0:	c1 fa 02             	sar    $0x2,%edx
  8012c3:	89 c8                	mov    %ecx,%eax
  8012c5:	c1 f8 1f             	sar    $0x1f,%eax
  8012c8:	29 c2                	sub    %eax,%edx
  8012ca:	89 d0                	mov    %edx,%eax
  8012cc:	c1 e0 02             	shl    $0x2,%eax
  8012cf:	01 d0                	add    %edx,%eax
  8012d1:	01 c0                	add    %eax,%eax
  8012d3:	29 c1                	sub    %eax,%ecx
  8012d5:	89 ca                	mov    %ecx,%edx
  8012d7:	85 d2                	test   %edx,%edx
  8012d9:	75 9c                	jne    801277 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e5:	48                   	dec    %eax
  8012e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8012e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012ed:	74 3d                	je     80132c <ltostr+0xe2>
		start = 1 ;
  8012ef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012f6:	eb 34                	jmp    80132c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8012f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fe:	01 d0                	add    %edx,%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801305:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130b:	01 c2                	add    %eax,%edx
  80130d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801310:	8b 45 0c             	mov    0xc(%ebp),%eax
  801313:	01 c8                	add    %ecx,%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801319:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80131c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131f:	01 c2                	add    %eax,%edx
  801321:	8a 45 eb             	mov    -0x15(%ebp),%al
  801324:	88 02                	mov    %al,(%edx)
		start++ ;
  801326:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801329:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80132c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801332:	7c c4                	jl     8012f8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801334:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	01 d0                	add    %edx,%eax
  80133c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80133f:	90                   	nop
  801340:	c9                   	leave  
  801341:	c3                   	ret    

00801342 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801348:	ff 75 08             	pushl  0x8(%ebp)
  80134b:	e8 54 fa ff ff       	call   800da4 <strlen>
  801350:	83 c4 04             	add    $0x4,%esp
  801353:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801356:	ff 75 0c             	pushl  0xc(%ebp)
  801359:	e8 46 fa ff ff       	call   800da4 <strlen>
  80135e:	83 c4 04             	add    $0x4,%esp
  801361:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801364:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80136b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801372:	eb 17                	jmp    80138b <strcconcat+0x49>
		final[s] = str1[s] ;
  801374:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801377:	8b 45 10             	mov    0x10(%ebp),%eax
  80137a:	01 c2                	add    %eax,%edx
  80137c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	01 c8                	add    %ecx,%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801388:	ff 45 fc             	incl   -0x4(%ebp)
  80138b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801391:	7c e1                	jl     801374 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801393:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80139a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013a1:	eb 1f                	jmp    8013c2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a6:	8d 50 01             	lea    0x1(%eax),%edx
  8013a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013ac:	89 c2                	mov    %eax,%edx
  8013ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b1:	01 c2                	add    %eax,%edx
  8013b3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b9:	01 c8                	add    %ecx,%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013bf:	ff 45 f8             	incl   -0x8(%ebp)
  8013c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013c8:	7c d9                	jl     8013a3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d0:	01 d0                	add    %edx,%eax
  8013d2:	c6 00 00             	movb   $0x0,(%eax)
}
  8013d5:	90                   	nop
  8013d6:	c9                   	leave  
  8013d7:	c3                   	ret    

008013d8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013db:	8b 45 14             	mov    0x14(%ebp),%eax
  8013de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e7:	8b 00                	mov    (%eax),%eax
  8013e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f3:	01 d0                	add    %edx,%eax
  8013f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013fb:	eb 0c                	jmp    801409 <strsplit+0x31>
			*string++ = 0;
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	8d 50 01             	lea    0x1(%eax),%edx
  801403:	89 55 08             	mov    %edx,0x8(%ebp)
  801406:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	8a 00                	mov    (%eax),%al
  80140e:	84 c0                	test   %al,%al
  801410:	74 18                	je     80142a <strsplit+0x52>
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	0f be c0             	movsbl %al,%eax
  80141a:	50                   	push   %eax
  80141b:	ff 75 0c             	pushl  0xc(%ebp)
  80141e:	e8 13 fb ff ff       	call   800f36 <strchr>
  801423:	83 c4 08             	add    $0x8,%esp
  801426:	85 c0                	test   %eax,%eax
  801428:	75 d3                	jne    8013fd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	8a 00                	mov    (%eax),%al
  80142f:	84 c0                	test   %al,%al
  801431:	74 5a                	je     80148d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801433:	8b 45 14             	mov    0x14(%ebp),%eax
  801436:	8b 00                	mov    (%eax),%eax
  801438:	83 f8 0f             	cmp    $0xf,%eax
  80143b:	75 07                	jne    801444 <strsplit+0x6c>
		{
			return 0;
  80143d:	b8 00 00 00 00       	mov    $0x0,%eax
  801442:	eb 66                	jmp    8014aa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801444:	8b 45 14             	mov    0x14(%ebp),%eax
  801447:	8b 00                	mov    (%eax),%eax
  801449:	8d 48 01             	lea    0x1(%eax),%ecx
  80144c:	8b 55 14             	mov    0x14(%ebp),%edx
  80144f:	89 0a                	mov    %ecx,(%edx)
  801451:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	01 c2                	add    %eax,%edx
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801462:	eb 03                	jmp    801467 <strsplit+0x8f>
			string++;
  801464:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	8a 00                	mov    (%eax),%al
  80146c:	84 c0                	test   %al,%al
  80146e:	74 8b                	je     8013fb <strsplit+0x23>
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	8a 00                	mov    (%eax),%al
  801475:	0f be c0             	movsbl %al,%eax
  801478:	50                   	push   %eax
  801479:	ff 75 0c             	pushl  0xc(%ebp)
  80147c:	e8 b5 fa ff ff       	call   800f36 <strchr>
  801481:	83 c4 08             	add    $0x8,%esp
  801484:	85 c0                	test   %eax,%eax
  801486:	74 dc                	je     801464 <strsplit+0x8c>
			string++;
	}
  801488:	e9 6e ff ff ff       	jmp    8013fb <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80148d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80148e:	8b 45 14             	mov    0x14(%ebp),%eax
  801491:	8b 00                	mov    (%eax),%eax
  801493:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80149a:	8b 45 10             	mov    0x10(%ebp),%eax
  80149d:	01 d0                	add    %edx,%eax
  80149f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	57                   	push   %edi
  8014b0:	56                   	push   %esi
  8014b1:	53                   	push   %ebx
  8014b2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014be:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014c1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014c4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014c7:	cd 30                	int    $0x30
  8014c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8014cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014cf:	83 c4 10             	add    $0x10,%esp
  8014d2:	5b                   	pop    %ebx
  8014d3:	5e                   	pop    %esi
  8014d4:	5f                   	pop    %edi
  8014d5:	5d                   	pop    %ebp
  8014d6:	c3                   	ret    

008014d7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 04             	sub    $0x4,%esp
  8014dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014e3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	52                   	push   %edx
  8014ef:	ff 75 0c             	pushl  0xc(%ebp)
  8014f2:	50                   	push   %eax
  8014f3:	6a 00                	push   $0x0
  8014f5:	e8 b2 ff ff ff       	call   8014ac <syscall>
  8014fa:	83 c4 18             	add    $0x18,%esp
}
  8014fd:	90                   	nop
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <sys_cgetc>:

int
sys_cgetc(void)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 01                	push   $0x1
  80150f:	e8 98 ff ff ff       	call   8014ac <syscall>
  801514:	83 c4 18             	add    $0x18,%esp
}
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80151c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	52                   	push   %edx
  801529:	50                   	push   %eax
  80152a:	6a 05                	push   $0x5
  80152c:	e8 7b ff ff ff       	call   8014ac <syscall>
  801531:	83 c4 18             	add    $0x18,%esp
}
  801534:	c9                   	leave  
  801535:	c3                   	ret    

00801536 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	56                   	push   %esi
  80153a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80153b:	8b 75 18             	mov    0x18(%ebp),%esi
  80153e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801541:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801544:	8b 55 0c             	mov    0xc(%ebp),%edx
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	56                   	push   %esi
  80154b:	53                   	push   %ebx
  80154c:	51                   	push   %ecx
  80154d:	52                   	push   %edx
  80154e:	50                   	push   %eax
  80154f:	6a 06                	push   $0x6
  801551:	e8 56 ff ff ff       	call   8014ac <syscall>
  801556:	83 c4 18             	add    $0x18,%esp
}
  801559:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80155c:	5b                   	pop    %ebx
  80155d:	5e                   	pop    %esi
  80155e:	5d                   	pop    %ebp
  80155f:	c3                   	ret    

00801560 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801563:	8b 55 0c             	mov    0xc(%ebp),%edx
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	52                   	push   %edx
  801570:	50                   	push   %eax
  801571:	6a 07                	push   $0x7
  801573:	e8 34 ff ff ff       	call   8014ac <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	ff 75 0c             	pushl  0xc(%ebp)
  801589:	ff 75 08             	pushl  0x8(%ebp)
  80158c:	6a 08                	push   $0x8
  80158e:	e8 19 ff ff ff       	call   8014ac <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 09                	push   $0x9
  8015a7:	e8 00 ff ff ff       	call   8014ac <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 0a                	push   $0xa
  8015c0:	e8 e7 fe ff ff       	call   8014ac <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 0b                	push   $0xb
  8015d9:	e8 ce fe ff ff       	call   8014ac <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	ff 75 0c             	pushl  0xc(%ebp)
  8015ef:	ff 75 08             	pushl  0x8(%ebp)
  8015f2:	6a 0f                	push   $0xf
  8015f4:	e8 b3 fe ff ff       	call   8014ac <syscall>
  8015f9:	83 c4 18             	add    $0x18,%esp
	return;
  8015fc:	90                   	nop
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	ff 75 0c             	pushl  0xc(%ebp)
  80160b:	ff 75 08             	pushl  0x8(%ebp)
  80160e:	6a 10                	push   $0x10
  801610:	e8 97 fe ff ff       	call   8014ac <syscall>
  801615:	83 c4 18             	add    $0x18,%esp
	return ;
  801618:	90                   	nop
}
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	ff 75 10             	pushl  0x10(%ebp)
  801625:	ff 75 0c             	pushl  0xc(%ebp)
  801628:	ff 75 08             	pushl  0x8(%ebp)
  80162b:	6a 11                	push   $0x11
  80162d:	e8 7a fe ff ff       	call   8014ac <syscall>
  801632:	83 c4 18             	add    $0x18,%esp
	return ;
  801635:	90                   	nop
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 0c                	push   $0xc
  801647:	e8 60 fe ff ff       	call   8014ac <syscall>
  80164c:	83 c4 18             	add    $0x18,%esp
}
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	ff 75 08             	pushl  0x8(%ebp)
  80165f:	6a 0d                	push   $0xd
  801661:	e8 46 fe ff ff       	call   8014ac <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 0e                	push   $0xe
  80167a:	e8 2d fe ff ff       	call   8014ac <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
}
  801682:	90                   	nop
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 13                	push   $0x13
  801694:	e8 13 fe ff ff       	call   8014ac <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
}
  80169c:	90                   	nop
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 14                	push   $0x14
  8016ae:	e8 f9 fd ff ff       	call   8014ac <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	90                   	nop
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	83 ec 04             	sub    $0x4,%esp
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016c5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	50                   	push   %eax
  8016d2:	6a 15                	push   $0x15
  8016d4:	e8 d3 fd ff ff       	call   8014ac <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
}
  8016dc:	90                   	nop
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 16                	push   $0x16
  8016ee:	e8 b9 fd ff ff       	call   8014ac <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	90                   	nop
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	ff 75 0c             	pushl  0xc(%ebp)
  801708:	50                   	push   %eax
  801709:	6a 17                	push   $0x17
  80170b:	e8 9c fd ff ff       	call   8014ac <syscall>
  801710:	83 c4 18             	add    $0x18,%esp
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801718:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	52                   	push   %edx
  801725:	50                   	push   %eax
  801726:	6a 1a                	push   $0x1a
  801728:	e8 7f fd ff ff       	call   8014ac <syscall>
  80172d:	83 c4 18             	add    $0x18,%esp
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801735:	8b 55 0c             	mov    0xc(%ebp),%edx
  801738:	8b 45 08             	mov    0x8(%ebp),%eax
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	52                   	push   %edx
  801742:	50                   	push   %eax
  801743:	6a 18                	push   $0x18
  801745:	e8 62 fd ff ff       	call   8014ac <syscall>
  80174a:	83 c4 18             	add    $0x18,%esp
}
  80174d:	90                   	nop
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801753:	8b 55 0c             	mov    0xc(%ebp),%edx
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	52                   	push   %edx
  801760:	50                   	push   %eax
  801761:	6a 19                	push   $0x19
  801763:	e8 44 fd ff ff       	call   8014ac <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
}
  80176b:	90                   	nop
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
  801771:	83 ec 04             	sub    $0x4,%esp
  801774:	8b 45 10             	mov    0x10(%ebp),%eax
  801777:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80177a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80177d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	6a 00                	push   $0x0
  801786:	51                   	push   %ecx
  801787:	52                   	push   %edx
  801788:	ff 75 0c             	pushl  0xc(%ebp)
  80178b:	50                   	push   %eax
  80178c:	6a 1b                	push   $0x1b
  80178e:	e8 19 fd ff ff       	call   8014ac <syscall>
  801793:	83 c4 18             	add    $0x18,%esp
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80179b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	52                   	push   %edx
  8017a8:	50                   	push   %eax
  8017a9:	6a 1c                	push   $0x1c
  8017ab:	e8 fc fc ff ff       	call   8014ac <syscall>
  8017b0:	83 c4 18             	add    $0x18,%esp
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	51                   	push   %ecx
  8017c6:	52                   	push   %edx
  8017c7:	50                   	push   %eax
  8017c8:	6a 1d                	push   $0x1d
  8017ca:	e8 dd fc ff ff       	call   8014ac <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	52                   	push   %edx
  8017e4:	50                   	push   %eax
  8017e5:	6a 1e                	push   $0x1e
  8017e7:	e8 c0 fc ff ff       	call   8014ac <syscall>
  8017ec:	83 c4 18             	add    $0x18,%esp
}
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 1f                	push   $0x1f
  801800:	e8 a7 fc ff ff       	call   8014ac <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	6a 00                	push   $0x0
  801812:	ff 75 14             	pushl  0x14(%ebp)
  801815:	ff 75 10             	pushl  0x10(%ebp)
  801818:	ff 75 0c             	pushl  0xc(%ebp)
  80181b:	50                   	push   %eax
  80181c:	6a 20                	push   $0x20
  80181e:	e8 89 fc ff ff       	call   8014ac <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	50                   	push   %eax
  801837:	6a 21                	push   $0x21
  801839:	e8 6e fc ff ff       	call   8014ac <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	90                   	nop
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	50                   	push   %eax
  801853:	6a 22                	push   $0x22
  801855:	e8 52 fc ff ff       	call   8014ac <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 02                	push   $0x2
  80186e:	e8 39 fc ff ff       	call   8014ac <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 03                	push   $0x3
  801887:	e8 20 fc ff ff       	call   8014ac <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 04                	push   $0x4
  8018a0:	e8 07 fc ff ff       	call   8014ac <syscall>
  8018a5:	83 c4 18             	add    $0x18,%esp
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <sys_exit_env>:


void sys_exit_env(void)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 23                	push   $0x23
  8018b9:	e8 ee fb ff ff       	call   8014ac <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	90                   	nop
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018ca:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018cd:	8d 50 04             	lea    0x4(%eax),%edx
  8018d0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	52                   	push   %edx
  8018da:	50                   	push   %eax
  8018db:	6a 24                	push   $0x24
  8018dd:	e8 ca fb ff ff       	call   8014ac <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
	return result;
  8018e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018ee:	89 01                	mov    %eax,(%ecx)
  8018f0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	c9                   	leave  
  8018f7:	c2 04 00             	ret    $0x4

008018fa <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	ff 75 10             	pushl  0x10(%ebp)
  801904:	ff 75 0c             	pushl  0xc(%ebp)
  801907:	ff 75 08             	pushl  0x8(%ebp)
  80190a:	6a 12                	push   $0x12
  80190c:	e8 9b fb ff ff       	call   8014ac <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
	return ;
  801914:	90                   	nop
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_rcr2>:
uint32 sys_rcr2()
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 25                	push   $0x25
  801926:	e8 81 fb ff ff       	call   8014ac <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	83 ec 04             	sub    $0x4,%esp
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80193c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	50                   	push   %eax
  801949:	6a 26                	push   $0x26
  80194b:	e8 5c fb ff ff       	call   8014ac <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
	return ;
  801953:	90                   	nop
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <rsttst>:
void rsttst()
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 28                	push   $0x28
  801965:	e8 42 fb ff ff       	call   8014ac <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
	return ;
  80196d:	90                   	nop
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	83 ec 04             	sub    $0x4,%esp
  801976:	8b 45 14             	mov    0x14(%ebp),%eax
  801979:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80197c:	8b 55 18             	mov    0x18(%ebp),%edx
  80197f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801983:	52                   	push   %edx
  801984:	50                   	push   %eax
  801985:	ff 75 10             	pushl  0x10(%ebp)
  801988:	ff 75 0c             	pushl  0xc(%ebp)
  80198b:	ff 75 08             	pushl  0x8(%ebp)
  80198e:	6a 27                	push   $0x27
  801990:	e8 17 fb ff ff       	call   8014ac <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
	return ;
  801998:	90                   	nop
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <chktst>:
void chktst(uint32 n)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	ff 75 08             	pushl  0x8(%ebp)
  8019a9:	6a 29                	push   $0x29
  8019ab:	e8 fc fa ff ff       	call   8014ac <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b3:	90                   	nop
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <inctst>:

void inctst()
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 2a                	push   $0x2a
  8019c5:	e8 e2 fa ff ff       	call   8014ac <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8019cd:	90                   	nop
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <gettst>:
uint32 gettst()
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 2b                	push   $0x2b
  8019df:	e8 c8 fa ff ff       	call   8014ac <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 2c                	push   $0x2c
  8019fb:	e8 ac fa ff ff       	call   8014ac <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
  801a03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a06:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a0a:	75 07                	jne    801a13 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a0c:	b8 01 00 00 00       	mov    $0x1,%eax
  801a11:	eb 05                	jmp    801a18 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 2c                	push   $0x2c
  801a2c:	e8 7b fa ff ff       	call   8014ac <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
  801a34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a37:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a3b:	75 07                	jne    801a44 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a42:	eb 05                	jmp    801a49 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 2c                	push   $0x2c
  801a5d:	e8 4a fa ff ff       	call   8014ac <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
  801a65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a68:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a6c:	75 07                	jne    801a75 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a73:	eb 05                	jmp    801a7a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 2c                	push   $0x2c
  801a8e:	e8 19 fa ff ff       	call   8014ac <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
  801a96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a99:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a9d:	75 07                	jne    801aa6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a9f:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa4:	eb 05                	jmp    801aab <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801aa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	ff 75 08             	pushl  0x8(%ebp)
  801abb:	6a 2d                	push   $0x2d
  801abd:	e8 ea f9 ff ff       	call   8014ac <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac5:	90                   	nop
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801acc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801acf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	53                   	push   %ebx
  801adb:	51                   	push   %ecx
  801adc:	52                   	push   %edx
  801add:	50                   	push   %eax
  801ade:	6a 2e                	push   $0x2e
  801ae0:	e8 c7 f9 ff ff       	call   8014ac <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	52                   	push   %edx
  801afd:	50                   	push   %eax
  801afe:	6a 2f                	push   $0x2f
  801b00:	e8 a7 f9 ff ff       	call   8014ac <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    
  801b0a:	66 90                	xchg   %ax,%ax

00801b0c <__udivdi3>:
  801b0c:	55                   	push   %ebp
  801b0d:	57                   	push   %edi
  801b0e:	56                   	push   %esi
  801b0f:	53                   	push   %ebx
  801b10:	83 ec 1c             	sub    $0x1c,%esp
  801b13:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b17:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b23:	89 ca                	mov    %ecx,%edx
  801b25:	89 f8                	mov    %edi,%eax
  801b27:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b2b:	85 f6                	test   %esi,%esi
  801b2d:	75 2d                	jne    801b5c <__udivdi3+0x50>
  801b2f:	39 cf                	cmp    %ecx,%edi
  801b31:	77 65                	ja     801b98 <__udivdi3+0x8c>
  801b33:	89 fd                	mov    %edi,%ebp
  801b35:	85 ff                	test   %edi,%edi
  801b37:	75 0b                	jne    801b44 <__udivdi3+0x38>
  801b39:	b8 01 00 00 00       	mov    $0x1,%eax
  801b3e:	31 d2                	xor    %edx,%edx
  801b40:	f7 f7                	div    %edi
  801b42:	89 c5                	mov    %eax,%ebp
  801b44:	31 d2                	xor    %edx,%edx
  801b46:	89 c8                	mov    %ecx,%eax
  801b48:	f7 f5                	div    %ebp
  801b4a:	89 c1                	mov    %eax,%ecx
  801b4c:	89 d8                	mov    %ebx,%eax
  801b4e:	f7 f5                	div    %ebp
  801b50:	89 cf                	mov    %ecx,%edi
  801b52:	89 fa                	mov    %edi,%edx
  801b54:	83 c4 1c             	add    $0x1c,%esp
  801b57:	5b                   	pop    %ebx
  801b58:	5e                   	pop    %esi
  801b59:	5f                   	pop    %edi
  801b5a:	5d                   	pop    %ebp
  801b5b:	c3                   	ret    
  801b5c:	39 ce                	cmp    %ecx,%esi
  801b5e:	77 28                	ja     801b88 <__udivdi3+0x7c>
  801b60:	0f bd fe             	bsr    %esi,%edi
  801b63:	83 f7 1f             	xor    $0x1f,%edi
  801b66:	75 40                	jne    801ba8 <__udivdi3+0x9c>
  801b68:	39 ce                	cmp    %ecx,%esi
  801b6a:	72 0a                	jb     801b76 <__udivdi3+0x6a>
  801b6c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b70:	0f 87 9e 00 00 00    	ja     801c14 <__udivdi3+0x108>
  801b76:	b8 01 00 00 00       	mov    $0x1,%eax
  801b7b:	89 fa                	mov    %edi,%edx
  801b7d:	83 c4 1c             	add    $0x1c,%esp
  801b80:	5b                   	pop    %ebx
  801b81:	5e                   	pop    %esi
  801b82:	5f                   	pop    %edi
  801b83:	5d                   	pop    %ebp
  801b84:	c3                   	ret    
  801b85:	8d 76 00             	lea    0x0(%esi),%esi
  801b88:	31 ff                	xor    %edi,%edi
  801b8a:	31 c0                	xor    %eax,%eax
  801b8c:	89 fa                	mov    %edi,%edx
  801b8e:	83 c4 1c             	add    $0x1c,%esp
  801b91:	5b                   	pop    %ebx
  801b92:	5e                   	pop    %esi
  801b93:	5f                   	pop    %edi
  801b94:	5d                   	pop    %ebp
  801b95:	c3                   	ret    
  801b96:	66 90                	xchg   %ax,%ax
  801b98:	89 d8                	mov    %ebx,%eax
  801b9a:	f7 f7                	div    %edi
  801b9c:	31 ff                	xor    %edi,%edi
  801b9e:	89 fa                	mov    %edi,%edx
  801ba0:	83 c4 1c             	add    $0x1c,%esp
  801ba3:	5b                   	pop    %ebx
  801ba4:	5e                   	pop    %esi
  801ba5:	5f                   	pop    %edi
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    
  801ba8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bad:	89 eb                	mov    %ebp,%ebx
  801baf:	29 fb                	sub    %edi,%ebx
  801bb1:	89 f9                	mov    %edi,%ecx
  801bb3:	d3 e6                	shl    %cl,%esi
  801bb5:	89 c5                	mov    %eax,%ebp
  801bb7:	88 d9                	mov    %bl,%cl
  801bb9:	d3 ed                	shr    %cl,%ebp
  801bbb:	89 e9                	mov    %ebp,%ecx
  801bbd:	09 f1                	or     %esi,%ecx
  801bbf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bc3:	89 f9                	mov    %edi,%ecx
  801bc5:	d3 e0                	shl    %cl,%eax
  801bc7:	89 c5                	mov    %eax,%ebp
  801bc9:	89 d6                	mov    %edx,%esi
  801bcb:	88 d9                	mov    %bl,%cl
  801bcd:	d3 ee                	shr    %cl,%esi
  801bcf:	89 f9                	mov    %edi,%ecx
  801bd1:	d3 e2                	shl    %cl,%edx
  801bd3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd7:	88 d9                	mov    %bl,%cl
  801bd9:	d3 e8                	shr    %cl,%eax
  801bdb:	09 c2                	or     %eax,%edx
  801bdd:	89 d0                	mov    %edx,%eax
  801bdf:	89 f2                	mov    %esi,%edx
  801be1:	f7 74 24 0c          	divl   0xc(%esp)
  801be5:	89 d6                	mov    %edx,%esi
  801be7:	89 c3                	mov    %eax,%ebx
  801be9:	f7 e5                	mul    %ebp
  801beb:	39 d6                	cmp    %edx,%esi
  801bed:	72 19                	jb     801c08 <__udivdi3+0xfc>
  801bef:	74 0b                	je     801bfc <__udivdi3+0xf0>
  801bf1:	89 d8                	mov    %ebx,%eax
  801bf3:	31 ff                	xor    %edi,%edi
  801bf5:	e9 58 ff ff ff       	jmp    801b52 <__udivdi3+0x46>
  801bfa:	66 90                	xchg   %ax,%ax
  801bfc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c00:	89 f9                	mov    %edi,%ecx
  801c02:	d3 e2                	shl    %cl,%edx
  801c04:	39 c2                	cmp    %eax,%edx
  801c06:	73 e9                	jae    801bf1 <__udivdi3+0xe5>
  801c08:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c0b:	31 ff                	xor    %edi,%edi
  801c0d:	e9 40 ff ff ff       	jmp    801b52 <__udivdi3+0x46>
  801c12:	66 90                	xchg   %ax,%ax
  801c14:	31 c0                	xor    %eax,%eax
  801c16:	e9 37 ff ff ff       	jmp    801b52 <__udivdi3+0x46>
  801c1b:	90                   	nop

00801c1c <__umoddi3>:
  801c1c:	55                   	push   %ebp
  801c1d:	57                   	push   %edi
  801c1e:	56                   	push   %esi
  801c1f:	53                   	push   %ebx
  801c20:	83 ec 1c             	sub    $0x1c,%esp
  801c23:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c27:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c2f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c3b:	89 f3                	mov    %esi,%ebx
  801c3d:	89 fa                	mov    %edi,%edx
  801c3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c43:	89 34 24             	mov    %esi,(%esp)
  801c46:	85 c0                	test   %eax,%eax
  801c48:	75 1a                	jne    801c64 <__umoddi3+0x48>
  801c4a:	39 f7                	cmp    %esi,%edi
  801c4c:	0f 86 a2 00 00 00    	jbe    801cf4 <__umoddi3+0xd8>
  801c52:	89 c8                	mov    %ecx,%eax
  801c54:	89 f2                	mov    %esi,%edx
  801c56:	f7 f7                	div    %edi
  801c58:	89 d0                	mov    %edx,%eax
  801c5a:	31 d2                	xor    %edx,%edx
  801c5c:	83 c4 1c             	add    $0x1c,%esp
  801c5f:	5b                   	pop    %ebx
  801c60:	5e                   	pop    %esi
  801c61:	5f                   	pop    %edi
  801c62:	5d                   	pop    %ebp
  801c63:	c3                   	ret    
  801c64:	39 f0                	cmp    %esi,%eax
  801c66:	0f 87 ac 00 00 00    	ja     801d18 <__umoddi3+0xfc>
  801c6c:	0f bd e8             	bsr    %eax,%ebp
  801c6f:	83 f5 1f             	xor    $0x1f,%ebp
  801c72:	0f 84 ac 00 00 00    	je     801d24 <__umoddi3+0x108>
  801c78:	bf 20 00 00 00       	mov    $0x20,%edi
  801c7d:	29 ef                	sub    %ebp,%edi
  801c7f:	89 fe                	mov    %edi,%esi
  801c81:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c85:	89 e9                	mov    %ebp,%ecx
  801c87:	d3 e0                	shl    %cl,%eax
  801c89:	89 d7                	mov    %edx,%edi
  801c8b:	89 f1                	mov    %esi,%ecx
  801c8d:	d3 ef                	shr    %cl,%edi
  801c8f:	09 c7                	or     %eax,%edi
  801c91:	89 e9                	mov    %ebp,%ecx
  801c93:	d3 e2                	shl    %cl,%edx
  801c95:	89 14 24             	mov    %edx,(%esp)
  801c98:	89 d8                	mov    %ebx,%eax
  801c9a:	d3 e0                	shl    %cl,%eax
  801c9c:	89 c2                	mov    %eax,%edx
  801c9e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ca2:	d3 e0                	shl    %cl,%eax
  801ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cac:	89 f1                	mov    %esi,%ecx
  801cae:	d3 e8                	shr    %cl,%eax
  801cb0:	09 d0                	or     %edx,%eax
  801cb2:	d3 eb                	shr    %cl,%ebx
  801cb4:	89 da                	mov    %ebx,%edx
  801cb6:	f7 f7                	div    %edi
  801cb8:	89 d3                	mov    %edx,%ebx
  801cba:	f7 24 24             	mull   (%esp)
  801cbd:	89 c6                	mov    %eax,%esi
  801cbf:	89 d1                	mov    %edx,%ecx
  801cc1:	39 d3                	cmp    %edx,%ebx
  801cc3:	0f 82 87 00 00 00    	jb     801d50 <__umoddi3+0x134>
  801cc9:	0f 84 91 00 00 00    	je     801d60 <__umoddi3+0x144>
  801ccf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801cd3:	29 f2                	sub    %esi,%edx
  801cd5:	19 cb                	sbb    %ecx,%ebx
  801cd7:	89 d8                	mov    %ebx,%eax
  801cd9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cdd:	d3 e0                	shl    %cl,%eax
  801cdf:	89 e9                	mov    %ebp,%ecx
  801ce1:	d3 ea                	shr    %cl,%edx
  801ce3:	09 d0                	or     %edx,%eax
  801ce5:	89 e9                	mov    %ebp,%ecx
  801ce7:	d3 eb                	shr    %cl,%ebx
  801ce9:	89 da                	mov    %ebx,%edx
  801ceb:	83 c4 1c             	add    $0x1c,%esp
  801cee:	5b                   	pop    %ebx
  801cef:	5e                   	pop    %esi
  801cf0:	5f                   	pop    %edi
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    
  801cf3:	90                   	nop
  801cf4:	89 fd                	mov    %edi,%ebp
  801cf6:	85 ff                	test   %edi,%edi
  801cf8:	75 0b                	jne    801d05 <__umoddi3+0xe9>
  801cfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801cff:	31 d2                	xor    %edx,%edx
  801d01:	f7 f7                	div    %edi
  801d03:	89 c5                	mov    %eax,%ebp
  801d05:	89 f0                	mov    %esi,%eax
  801d07:	31 d2                	xor    %edx,%edx
  801d09:	f7 f5                	div    %ebp
  801d0b:	89 c8                	mov    %ecx,%eax
  801d0d:	f7 f5                	div    %ebp
  801d0f:	89 d0                	mov    %edx,%eax
  801d11:	e9 44 ff ff ff       	jmp    801c5a <__umoddi3+0x3e>
  801d16:	66 90                	xchg   %ax,%ax
  801d18:	89 c8                	mov    %ecx,%eax
  801d1a:	89 f2                	mov    %esi,%edx
  801d1c:	83 c4 1c             	add    $0x1c,%esp
  801d1f:	5b                   	pop    %ebx
  801d20:	5e                   	pop    %esi
  801d21:	5f                   	pop    %edi
  801d22:	5d                   	pop    %ebp
  801d23:	c3                   	ret    
  801d24:	3b 04 24             	cmp    (%esp),%eax
  801d27:	72 06                	jb     801d2f <__umoddi3+0x113>
  801d29:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d2d:	77 0f                	ja     801d3e <__umoddi3+0x122>
  801d2f:	89 f2                	mov    %esi,%edx
  801d31:	29 f9                	sub    %edi,%ecx
  801d33:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d37:	89 14 24             	mov    %edx,(%esp)
  801d3a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d3e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d42:	8b 14 24             	mov    (%esp),%edx
  801d45:	83 c4 1c             	add    $0x1c,%esp
  801d48:	5b                   	pop    %ebx
  801d49:	5e                   	pop    %esi
  801d4a:	5f                   	pop    %edi
  801d4b:	5d                   	pop    %ebp
  801d4c:	c3                   	ret    
  801d4d:	8d 76 00             	lea    0x0(%esi),%esi
  801d50:	2b 04 24             	sub    (%esp),%eax
  801d53:	19 fa                	sbb    %edi,%edx
  801d55:	89 d1                	mov    %edx,%ecx
  801d57:	89 c6                	mov    %eax,%esi
  801d59:	e9 71 ff ff ff       	jmp    801ccf <__umoddi3+0xb3>
  801d5e:	66 90                	xchg   %ax,%ax
  801d60:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d64:	72 ea                	jb     801d50 <__umoddi3+0x134>
  801d66:	89 d9                	mov    %ebx,%ecx
  801d68:	e9 62 ff ff ff       	jmp    801ccf <__umoddi3+0xb3>
