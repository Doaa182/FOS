
obj/user/tst_page_replacement_LRU_Lists_2:     file format elf32-i386


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
  800031:	e8 83 02 00 00       	call   8002b9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
char arr[PAGE_SIZE*13];
char* ptr = (char* )0x0801000 ;
char* ptr2 = (char* )0x0804000 ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
//	cprintf("envID = %d\n",envID);
	int x = 0;
  800044:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

	//("STEP 0: checking Initial WS entries ...\n");
	{
		uint32 actual_active_list[6] = {0x803000, 0x801000, 0x800000, 0xeebfd000, 0x204000, 0x203000};
  80004b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80004e:	bb d8 1e 80 00       	mov    $0x801ed8,%ebx
  800053:	ba 06 00 00 00       	mov    $0x6,%edx
  800058:	89 c7                	mov    %eax,%edi
  80005a:	89 de                	mov    %ebx,%esi
  80005c:	89 d1                	mov    %edx,%ecx
  80005e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		uint32 actual_second_list[5] = {0x202000, 0x201000, 0x200000, 0x802000, 0x205000};
  800060:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  800066:	bb f0 1e 80 00       	mov    $0x801ef0,%ebx
  80006b:	ba 05 00 00 00       	mov    $0x5,%edx
  800070:	89 c7                	mov    %eax,%edi
  800072:	89 de                	mov    %ebx,%esi
  800074:	89 d1                	mov    %edx,%ecx
  800076:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 6, 5);
  800078:	6a 05                	push   $0x5
  80007a:	6a 06                	push   $0x6
  80007c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
  800082:	50                   	push   %eax
  800083:	8d 45 84             	lea    -0x7c(%ebp),%eax
  800086:	50                   	push   %eax
  800087:	e8 c3 19 00 00       	call   801a4f <sys_check_LRU_lists>
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if(check == 0)
  800092:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800096:	75 14                	jne    8000ac <_main+0x74>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists..!!");
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 00 1d 80 00       	push   $0x801d00
  8000a0:	6a 18                	push   $0x18
  8000a2:	68 50 1d 80 00       	push   $0x801d50
  8000a7:	e8 49 03 00 00       	call   8003f5 <_panic>
	}

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  8000ac:	a0 5f e0 80 00       	mov    0x80e05f,%al
  8000b1:	88 45 db             	mov    %al,-0x25(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  8000b4:	a0 5f f0 80 00       	mov    0x80f05f,%al
  8000b9:	88 45 da             	mov    %al,-0x26(%ebp)

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000bc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000c3:	eb 37                	jmp    8000fc <_main+0xc4>
	{
		arr[i] = -1 ;
  8000c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000c8:	05 60 30 80 00       	add    $0x803060,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		*ptr2 = *ptr ;
  8000d0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000d5:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8000db:	8a 12                	mov    (%edx),%dl
  8000dd:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  8000df:	a1 00 30 80 00       	mov    0x803000,%eax
  8000e4:	40                   	inc    %eax
  8000e5:	a3 00 30 80 00       	mov    %eax,0x803000
  8000ea:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ef:	40                   	inc    %eax
  8000f0:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1] ;
	char garbage2 = arr[PAGE_SIZE*12-1] ;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000f5:	81 45 e4 00 08 00 00 	addl   $0x800,-0x1c(%ebp)
  8000fc:	81 7d e4 ff 9f 00 00 	cmpl   $0x9fff,-0x1c(%ebp)
  800103:	7e c0                	jle    8000c5 <_main+0x8d>
	}

	//===================

	//("STEP 1: checking LRU LISTS after a new page FAULTS...\n");
	uint32 actual_active_list[6] = {0x803000, 0x801000, 0x800000, 0xeebfd000, 0x804000, 0x80c000};
  800105:	8d 45 b0             	lea    -0x50(%ebp),%eax
  800108:	bb 04 1f 80 00       	mov    $0x801f04,%ebx
  80010d:	ba 06 00 00 00       	mov    $0x6,%edx
  800112:	89 c7                	mov    %eax,%edi
  800114:	89 de                	mov    %ebx,%esi
  800116:	89 d1                	mov    %edx,%ecx
  800118:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	uint32 actual_second_list[5] = {0x80b000, 0x80a000, 0x809000, 0x808000, 0x807000};
  80011a:	8d 45 9c             	lea    -0x64(%ebp),%eax
  80011d:	bb 1c 1f 80 00       	mov    $0x801f1c,%ebx
  800122:	ba 05 00 00 00       	mov    $0x5,%edx
  800127:	89 c7                	mov    %eax,%edi
  800129:	89 de                	mov    %ebx,%esi
  80012b:	89 d1                	mov    %edx,%ecx
  80012d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 6, 5);
  80012f:	6a 05                	push   $0x5
  800131:	6a 06                	push   $0x6
  800133:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800136:	50                   	push   %eax
  800137:	8d 45 b0             	lea    -0x50(%ebp),%eax
  80013a:	50                   	push   %eax
  80013b:	e8 0f 19 00 00       	call   801a4f <sys_check_LRU_lists>
  800140:	83 c4 10             	add    $0x10,%esp
  800143:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if(check == 0)
  800146:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80014a:	75 14                	jne    800160 <_main+0x128>
		panic("PAGE LRU Lists entry checking failed when a new PAGE FAULTs occurred..!!");
  80014c:	83 ec 04             	sub    $0x4,%esp
  80014f:	68 78 1d 80 00       	push   $0x801d78
  800154:	6a 33                	push   $0x33
  800156:	68 50 1d 80 00       	push   $0x801d50
  80015b:	e8 95 02 00 00       	call   8003f5 <_panic>


	//("STEP 2: Checking PAGE LRU LIST algorithm after faults due to ACCESS in the second chance list... \n");
	{
		uint32* secondlistVA = (uint32*)0x809000;
  800160:	c7 45 d0 00 90 80 00 	movl   $0x809000,-0x30(%ebp)
		x = x + *secondlistVA;
  800167:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80016a:	8b 10                	mov    (%eax),%edx
  80016c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016f:	01 d0                	add    %edx,%eax
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)
		secondlistVA = (uint32*)0x807000;
  800174:	c7 45 d0 00 70 80 00 	movl   $0x807000,-0x30(%ebp)
		x = x + *secondlistVA;
  80017b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80017e:	8b 10                	mov    (%eax),%edx
  800180:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800183:	01 d0                	add    %edx,%eax
  800185:	89 45 e0             	mov    %eax,-0x20(%ebp)
		secondlistVA = (uint32*)0x804000;
  800188:	c7 45 d0 00 40 80 00 	movl   $0x804000,-0x30(%ebp)
		x = x + *secondlistVA;
  80018f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800192:	8b 10                	mov    (%eax),%edx
  800194:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800197:	01 d0                	add    %edx,%eax
  800199:	89 45 e0             	mov    %eax,-0x20(%ebp)

		actual_active_list[0] = 0x801000;
  80019c:	c7 45 b0 00 10 80 00 	movl   $0x801000,-0x50(%ebp)
		actual_active_list[1] = 0x800000;
  8001a3:	c7 45 b4 00 00 80 00 	movl   $0x800000,-0x4c(%ebp)
		actual_active_list[2] = 0xeebfd000;
  8001aa:	c7 45 b8 00 d0 bf ee 	movl   $0xeebfd000,-0x48(%ebp)
		actual_active_list[3] = 0x804000;
  8001b1:	c7 45 bc 00 40 80 00 	movl   $0x804000,-0x44(%ebp)
		actual_active_list[4] = 0x807000;
  8001b8:	c7 45 c0 00 70 80 00 	movl   $0x807000,-0x40(%ebp)
		actual_active_list[5] = 0x809000;
  8001bf:	c7 45 c4 00 90 80 00 	movl   $0x809000,-0x3c(%ebp)

		actual_second_list[0] = 0x803000;
  8001c6:	c7 45 9c 00 30 80 00 	movl   $0x803000,-0x64(%ebp)
		actual_second_list[1] = 0x80c000;
  8001cd:	c7 45 a0 00 c0 80 00 	movl   $0x80c000,-0x60(%ebp)
		actual_second_list[2] = 0x80b000;
  8001d4:	c7 45 a4 00 b0 80 00 	movl   $0x80b000,-0x5c(%ebp)
		actual_second_list[3] = 0x80a000;
  8001db:	c7 45 a8 00 a0 80 00 	movl   $0x80a000,-0x58(%ebp)
		actual_second_list[4] = 0x808000;
  8001e2:	c7 45 ac 00 80 80 00 	movl   $0x808000,-0x54(%ebp)
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 6, 5);
  8001e9:	6a 05                	push   $0x5
  8001eb:	6a 06                	push   $0x6
  8001ed:	8d 45 9c             	lea    -0x64(%ebp),%eax
  8001f0:	50                   	push   %eax
  8001f1:	8d 45 b0             	lea    -0x50(%ebp),%eax
  8001f4:	50                   	push   %eax
  8001f5:	e8 55 18 00 00       	call   801a4f <sys_check_LRU_lists>
  8001fa:	83 c4 10             	add    $0x10,%esp
  8001fd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if(check == 0)
  800200:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  800204:	75 14                	jne    80021a <_main+0x1e2>
			panic("PAGE LRU Lists entry checking failed when a new PAGE ACCESS from the SECOND LIST is occurred..!!");
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 c4 1d 80 00       	push   $0x801dc4
  80020e:	6a 4d                	push   $0x4d
  800210:	68 50 1d 80 00       	push   $0x801d50
  800215:	e8 db 01 00 00       	call   8003f5 <_panic>
	}

	//("STEP 3: NEW FAULTS to test applying LRU algorithm on the second list by removing the LRU page... \n");
	{
		//Reading (Not Modified)
		char garbage3 = arr[PAGE_SIZE*13-1] ;
  80021a:	a0 5f 00 81 00       	mov    0x81005f,%al
  80021f:	88 45 cb             	mov    %al,-0x35(%ebp)
		actual_active_list[0] = 0x810000;
  800222:	c7 45 b0 00 00 81 00 	movl   $0x810000,-0x50(%ebp)
		actual_active_list[1] = 0x801000;
  800229:	c7 45 b4 00 10 80 00 	movl   $0x801000,-0x4c(%ebp)
		actual_active_list[2] = 0x800000;
  800230:	c7 45 b8 00 00 80 00 	movl   $0x800000,-0x48(%ebp)
		actual_active_list[3] = 0xeebfd000;
  800237:	c7 45 bc 00 d0 bf ee 	movl   $0xeebfd000,-0x44(%ebp)
		actual_active_list[4] = 0x804000;
  80023e:	c7 45 c0 00 40 80 00 	movl   $0x804000,-0x40(%ebp)
		actual_active_list[5] = 0x807000;
  800245:	c7 45 c4 00 70 80 00 	movl   $0x807000,-0x3c(%ebp)

		actual_second_list[0] = 0x809000;
  80024c:	c7 45 9c 00 90 80 00 	movl   $0x809000,-0x64(%ebp)
		actual_second_list[1] = 0x803000;
  800253:	c7 45 a0 00 30 80 00 	movl   $0x803000,-0x60(%ebp)
		actual_second_list[2] = 0x80c000;
  80025a:	c7 45 a4 00 c0 80 00 	movl   $0x80c000,-0x5c(%ebp)
		actual_second_list[3] = 0x80b000;
  800261:	c7 45 a8 00 b0 80 00 	movl   $0x80b000,-0x58(%ebp)
		actual_second_list[4] = 0x80a000;
  800268:	c7 45 ac 00 a0 80 00 	movl   $0x80a000,-0x54(%ebp)
		check = sys_check_LRU_lists(actual_active_list, actual_second_list, 6, 5);
  80026f:	6a 05                	push   $0x5
  800271:	6a 06                	push   $0x6
  800273:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800276:	50                   	push   %eax
  800277:	8d 45 b0             	lea    -0x50(%ebp),%eax
  80027a:	50                   	push   %eax
  80027b:	e8 cf 17 00 00       	call   801a4f <sys_check_LRU_lists>
  800280:	83 c4 10             	add    $0x10,%esp
  800283:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if(check == 0)
  800286:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80028a:	75 14                	jne    8002a0 <_main+0x268>
			panic("PAGE LRU Lists entry checking failed when a new PAGE FAULT occurred..!!");
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	68 28 1e 80 00       	push   $0x801e28
  800294:	6a 62                	push   $0x62
  800296:	68 50 1d 80 00       	push   $0x801d50
  80029b:	e8 55 01 00 00       	call   8003f5 <_panic>
	}
	cprintf("Congratulations!! test PAGE replacement [LRU Alg. on the 2nd chance list] is completed successfully.\n");
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	68 70 1e 80 00       	push   $0x801e70
  8002a8:	e8 fc 03 00 00       	call   8006a9 <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	return;
  8002b0:	90                   	nop
}
  8002b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b4:	5b                   	pop    %ebx
  8002b5:	5e                   	pop    %esi
  8002b6:	5f                   	pop    %edi
  8002b7:	5d                   	pop    %ebp
  8002b8:	c3                   	ret    

008002b9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002bf:	e8 3b 15 00 00       	call   8017ff <sys_getenvindex>
  8002c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002ca:	89 d0                	mov    %edx,%eax
  8002cc:	c1 e0 03             	shl    $0x3,%eax
  8002cf:	01 d0                	add    %edx,%eax
  8002d1:	01 c0                	add    %eax,%eax
  8002d3:	01 d0                	add    %edx,%eax
  8002d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002dc:	01 d0                	add    %edx,%eax
  8002de:	c1 e0 04             	shl    $0x4,%eax
  8002e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e6:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f0:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002f6:	84 c0                	test   %al,%al
  8002f8:	74 0f                	je     800309 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ff:	05 5c 05 00 00       	add    $0x55c,%eax
  800304:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800309:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80030d:	7e 0a                	jle    800319 <libmain+0x60>
		binaryname = argv[0];
  80030f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  800319:	83 ec 08             	sub    $0x8,%esp
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	e8 11 fd ff ff       	call   800038 <_main>
  800327:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80032a:	e8 dd 12 00 00       	call   80160c <sys_disable_interrupt>
	cprintf("**************************************\n");
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	68 48 1f 80 00       	push   $0x801f48
  800337:	e8 6d 03 00 00       	call   8006a9 <cprintf>
  80033c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80033f:	a1 20 30 80 00       	mov    0x803020,%eax
  800344:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80034a:	a1 20 30 80 00       	mov    0x803020,%eax
  80034f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	52                   	push   %edx
  800359:	50                   	push   %eax
  80035a:	68 70 1f 80 00       	push   $0x801f70
  80035f:	e8 45 03 00 00       	call   8006a9 <cprintf>
  800364:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800367:	a1 20 30 80 00       	mov    0x803020,%eax
  80036c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800372:	a1 20 30 80 00       	mov    0x803020,%eax
  800377:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80037d:	a1 20 30 80 00       	mov    0x803020,%eax
  800382:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800388:	51                   	push   %ecx
  800389:	52                   	push   %edx
  80038a:	50                   	push   %eax
  80038b:	68 98 1f 80 00       	push   $0x801f98
  800390:	e8 14 03 00 00       	call   8006a9 <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800398:	a1 20 30 80 00       	mov    0x803020,%eax
  80039d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003a3:	83 ec 08             	sub    $0x8,%esp
  8003a6:	50                   	push   %eax
  8003a7:	68 f0 1f 80 00       	push   $0x801ff0
  8003ac:	e8 f8 02 00 00       	call   8006a9 <cprintf>
  8003b1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003b4:	83 ec 0c             	sub    $0xc,%esp
  8003b7:	68 48 1f 80 00       	push   $0x801f48
  8003bc:	e8 e8 02 00 00       	call   8006a9 <cprintf>
  8003c1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003c4:	e8 5d 12 00 00       	call   801626 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003c9:	e8 19 00 00 00       	call   8003e7 <exit>
}
  8003ce:	90                   	nop
  8003cf:	c9                   	leave  
  8003d0:	c3                   	ret    

008003d1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
  8003d4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003d7:	83 ec 0c             	sub    $0xc,%esp
  8003da:	6a 00                	push   $0x0
  8003dc:	e8 ea 13 00 00       	call   8017cb <sys_destroy_env>
  8003e1:	83 c4 10             	add    $0x10,%esp
}
  8003e4:	90                   	nop
  8003e5:	c9                   	leave  
  8003e6:	c3                   	ret    

008003e7 <exit>:

void
exit(void)
{
  8003e7:	55                   	push   %ebp
  8003e8:	89 e5                	mov    %esp,%ebp
  8003ea:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003ed:	e8 3f 14 00 00       	call   801831 <sys_exit_env>
}
  8003f2:	90                   	nop
  8003f3:	c9                   	leave  
  8003f4:	c3                   	ret    

008003f5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003f5:	55                   	push   %ebp
  8003f6:	89 e5                	mov    %esp,%ebp
  8003f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003fb:	8d 45 10             	lea    0x10(%ebp),%eax
  8003fe:	83 c0 04             	add    $0x4,%eax
  800401:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800404:	a1 5c 01 81 00       	mov    0x81015c,%eax
  800409:	85 c0                	test   %eax,%eax
  80040b:	74 16                	je     800423 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80040d:	a1 5c 01 81 00       	mov    0x81015c,%eax
  800412:	83 ec 08             	sub    $0x8,%esp
  800415:	50                   	push   %eax
  800416:	68 04 20 80 00       	push   $0x802004
  80041b:	e8 89 02 00 00       	call   8006a9 <cprintf>
  800420:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800423:	a1 08 30 80 00       	mov    0x803008,%eax
  800428:	ff 75 0c             	pushl  0xc(%ebp)
  80042b:	ff 75 08             	pushl  0x8(%ebp)
  80042e:	50                   	push   %eax
  80042f:	68 09 20 80 00       	push   $0x802009
  800434:	e8 70 02 00 00       	call   8006a9 <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80043c:	8b 45 10             	mov    0x10(%ebp),%eax
  80043f:	83 ec 08             	sub    $0x8,%esp
  800442:	ff 75 f4             	pushl  -0xc(%ebp)
  800445:	50                   	push   %eax
  800446:	e8 f3 01 00 00       	call   80063e <vcprintf>
  80044b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80044e:	83 ec 08             	sub    $0x8,%esp
  800451:	6a 00                	push   $0x0
  800453:	68 25 20 80 00       	push   $0x802025
  800458:	e8 e1 01 00 00       	call   80063e <vcprintf>
  80045d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800460:	e8 82 ff ff ff       	call   8003e7 <exit>

	// should not return here
	while (1) ;
  800465:	eb fe                	jmp    800465 <_panic+0x70>

00800467 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
  80046a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80046d:	a1 20 30 80 00       	mov    0x803020,%eax
  800472:	8b 50 74             	mov    0x74(%eax),%edx
  800475:	8b 45 0c             	mov    0xc(%ebp),%eax
  800478:	39 c2                	cmp    %eax,%edx
  80047a:	74 14                	je     800490 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80047c:	83 ec 04             	sub    $0x4,%esp
  80047f:	68 28 20 80 00       	push   $0x802028
  800484:	6a 26                	push   $0x26
  800486:	68 74 20 80 00       	push   $0x802074
  80048b:	e8 65 ff ff ff       	call   8003f5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800490:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800497:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80049e:	e9 c2 00 00 00       	jmp    800565 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	01 d0                	add    %edx,%eax
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	85 c0                	test   %eax,%eax
  8004b6:	75 08                	jne    8004c0 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004b8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004bb:	e9 a2 00 00 00       	jmp    800562 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004c0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004ce:	eb 69                	jmp    800539 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004de:	89 d0                	mov    %edx,%eax
  8004e0:	01 c0                	add    %eax,%eax
  8004e2:	01 d0                	add    %edx,%eax
  8004e4:	c1 e0 03             	shl    $0x3,%eax
  8004e7:	01 c8                	add    %ecx,%eax
  8004e9:	8a 40 04             	mov    0x4(%eax),%al
  8004ec:	84 c0                	test   %al,%al
  8004ee:	75 46                	jne    800536 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8004f5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004fe:	89 d0                	mov    %edx,%eax
  800500:	01 c0                	add    %eax,%eax
  800502:	01 d0                	add    %edx,%eax
  800504:	c1 e0 03             	shl    $0x3,%eax
  800507:	01 c8                	add    %ecx,%eax
  800509:	8b 00                	mov    (%eax),%eax
  80050b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80050e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800511:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800516:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	01 c8                	add    %ecx,%eax
  800527:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800529:	39 c2                	cmp    %eax,%edx
  80052b:	75 09                	jne    800536 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80052d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800534:	eb 12                	jmp    800548 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800536:	ff 45 e8             	incl   -0x18(%ebp)
  800539:	a1 20 30 80 00       	mov    0x803020,%eax
  80053e:	8b 50 74             	mov    0x74(%eax),%edx
  800541:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800544:	39 c2                	cmp    %eax,%edx
  800546:	77 88                	ja     8004d0 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800548:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80054c:	75 14                	jne    800562 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80054e:	83 ec 04             	sub    $0x4,%esp
  800551:	68 80 20 80 00       	push   $0x802080
  800556:	6a 3a                	push   $0x3a
  800558:	68 74 20 80 00       	push   $0x802074
  80055d:	e8 93 fe ff ff       	call   8003f5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800562:	ff 45 f0             	incl   -0x10(%ebp)
  800565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800568:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80056b:	0f 8c 32 ff ff ff    	jl     8004a3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800571:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800578:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80057f:	eb 26                	jmp    8005a7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800581:	a1 20 30 80 00       	mov    0x803020,%eax
  800586:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80058c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058f:	89 d0                	mov    %edx,%eax
  800591:	01 c0                	add    %eax,%eax
  800593:	01 d0                	add    %edx,%eax
  800595:	c1 e0 03             	shl    $0x3,%eax
  800598:	01 c8                	add    %ecx,%eax
  80059a:	8a 40 04             	mov    0x4(%eax),%al
  80059d:	3c 01                	cmp    $0x1,%al
  80059f:	75 03                	jne    8005a4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005a1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a4:	ff 45 e0             	incl   -0x20(%ebp)
  8005a7:	a1 20 30 80 00       	mov    0x803020,%eax
  8005ac:	8b 50 74             	mov    0x74(%eax),%edx
  8005af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b2:	39 c2                	cmp    %eax,%edx
  8005b4:	77 cb                	ja     800581 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005bc:	74 14                	je     8005d2 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005be:	83 ec 04             	sub    $0x4,%esp
  8005c1:	68 d4 20 80 00       	push   $0x8020d4
  8005c6:	6a 44                	push   $0x44
  8005c8:	68 74 20 80 00       	push   $0x802074
  8005cd:	e8 23 fe ff ff       	call   8003f5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d2:	90                   	nop
  8005d3:	c9                   	leave  
  8005d4:	c3                   	ret    

008005d5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
  8005d8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	8d 48 01             	lea    0x1(%eax),%ecx
  8005e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e6:	89 0a                	mov    %ecx,(%edx)
  8005e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8005eb:	88 d1                	mov    %dl,%cl
  8005ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f7:	8b 00                	mov    (%eax),%eax
  8005f9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005fe:	75 2c                	jne    80062c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800600:	a0 24 30 80 00       	mov    0x803024,%al
  800605:	0f b6 c0             	movzbl %al,%eax
  800608:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060b:	8b 12                	mov    (%edx),%edx
  80060d:	89 d1                	mov    %edx,%ecx
  80060f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800612:	83 c2 08             	add    $0x8,%edx
  800615:	83 ec 04             	sub    $0x4,%esp
  800618:	50                   	push   %eax
  800619:	51                   	push   %ecx
  80061a:	52                   	push   %edx
  80061b:	e8 3e 0e 00 00       	call   80145e <sys_cputs>
  800620:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800623:	8b 45 0c             	mov    0xc(%ebp),%eax
  800626:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80062c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062f:	8b 40 04             	mov    0x4(%eax),%eax
  800632:	8d 50 01             	lea    0x1(%eax),%edx
  800635:	8b 45 0c             	mov    0xc(%ebp),%eax
  800638:	89 50 04             	mov    %edx,0x4(%eax)
}
  80063b:	90                   	nop
  80063c:	c9                   	leave  
  80063d:	c3                   	ret    

0080063e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80063e:	55                   	push   %ebp
  80063f:	89 e5                	mov    %esp,%ebp
  800641:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800647:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80064e:	00 00 00 
	b.cnt = 0;
  800651:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800658:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80065b:	ff 75 0c             	pushl  0xc(%ebp)
  80065e:	ff 75 08             	pushl  0x8(%ebp)
  800661:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800667:	50                   	push   %eax
  800668:	68 d5 05 80 00       	push   $0x8005d5
  80066d:	e8 11 02 00 00       	call   800883 <vprintfmt>
  800672:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800675:	a0 24 30 80 00       	mov    0x803024,%al
  80067a:	0f b6 c0             	movzbl %al,%eax
  80067d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800683:	83 ec 04             	sub    $0x4,%esp
  800686:	50                   	push   %eax
  800687:	52                   	push   %edx
  800688:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80068e:	83 c0 08             	add    $0x8,%eax
  800691:	50                   	push   %eax
  800692:	e8 c7 0d 00 00       	call   80145e <sys_cputs>
  800697:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80069a:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8006a1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006a7:	c9                   	leave  
  8006a8:	c3                   	ret    

008006a9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006a9:	55                   	push   %ebp
  8006aa:	89 e5                	mov    %esp,%ebp
  8006ac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006af:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8006b6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c5:	50                   	push   %eax
  8006c6:	e8 73 ff ff ff       	call   80063e <vcprintf>
  8006cb:	83 c4 10             	add    $0x10,%esp
  8006ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d4:	c9                   	leave  
  8006d5:	c3                   	ret    

008006d6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006d6:	55                   	push   %ebp
  8006d7:	89 e5                	mov    %esp,%ebp
  8006d9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006dc:	e8 2b 0f 00 00       	call   80160c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	83 ec 08             	sub    $0x8,%esp
  8006ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f0:	50                   	push   %eax
  8006f1:	e8 48 ff ff ff       	call   80063e <vcprintf>
  8006f6:	83 c4 10             	add    $0x10,%esp
  8006f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006fc:	e8 25 0f 00 00       	call   801626 <sys_enable_interrupt>
	return cnt;
  800701:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800704:	c9                   	leave  
  800705:	c3                   	ret    

00800706 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	53                   	push   %ebx
  80070a:	83 ec 14             	sub    $0x14,%esp
  80070d:	8b 45 10             	mov    0x10(%ebp),%eax
  800710:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800713:	8b 45 14             	mov    0x14(%ebp),%eax
  800716:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800719:	8b 45 18             	mov    0x18(%ebp),%eax
  80071c:	ba 00 00 00 00       	mov    $0x0,%edx
  800721:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800724:	77 55                	ja     80077b <printnum+0x75>
  800726:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800729:	72 05                	jb     800730 <printnum+0x2a>
  80072b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80072e:	77 4b                	ja     80077b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800730:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800733:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800736:	8b 45 18             	mov    0x18(%ebp),%eax
  800739:	ba 00 00 00 00       	mov    $0x0,%edx
  80073e:	52                   	push   %edx
  80073f:	50                   	push   %eax
  800740:	ff 75 f4             	pushl  -0xc(%ebp)
  800743:	ff 75 f0             	pushl  -0x10(%ebp)
  800746:	e8 49 13 00 00       	call   801a94 <__udivdi3>
  80074b:	83 c4 10             	add    $0x10,%esp
  80074e:	83 ec 04             	sub    $0x4,%esp
  800751:	ff 75 20             	pushl  0x20(%ebp)
  800754:	53                   	push   %ebx
  800755:	ff 75 18             	pushl  0x18(%ebp)
  800758:	52                   	push   %edx
  800759:	50                   	push   %eax
  80075a:	ff 75 0c             	pushl  0xc(%ebp)
  80075d:	ff 75 08             	pushl  0x8(%ebp)
  800760:	e8 a1 ff ff ff       	call   800706 <printnum>
  800765:	83 c4 20             	add    $0x20,%esp
  800768:	eb 1a                	jmp    800784 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	ff 75 20             	pushl  0x20(%ebp)
  800773:	8b 45 08             	mov    0x8(%ebp),%eax
  800776:	ff d0                	call   *%eax
  800778:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80077b:	ff 4d 1c             	decl   0x1c(%ebp)
  80077e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800782:	7f e6                	jg     80076a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800784:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800787:	bb 00 00 00 00       	mov    $0x0,%ebx
  80078c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800792:	53                   	push   %ebx
  800793:	51                   	push   %ecx
  800794:	52                   	push   %edx
  800795:	50                   	push   %eax
  800796:	e8 09 14 00 00       	call   801ba4 <__umoddi3>
  80079b:	83 c4 10             	add    $0x10,%esp
  80079e:	05 34 23 80 00       	add    $0x802334,%eax
  8007a3:	8a 00                	mov    (%eax),%al
  8007a5:	0f be c0             	movsbl %al,%eax
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	ff 75 0c             	pushl  0xc(%ebp)
  8007ae:	50                   	push   %eax
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	ff d0                	call   *%eax
  8007b4:	83 c4 10             	add    $0x10,%esp
}
  8007b7:	90                   	nop
  8007b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007bb:	c9                   	leave  
  8007bc:	c3                   	ret    

008007bd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007bd:	55                   	push   %ebp
  8007be:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c4:	7e 1c                	jle    8007e2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	8d 50 08             	lea    0x8(%eax),%edx
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	89 10                	mov    %edx,(%eax)
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	83 e8 08             	sub    $0x8,%eax
  8007db:	8b 50 04             	mov    0x4(%eax),%edx
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	eb 40                	jmp    800822 <getuint+0x65>
	else if (lflag)
  8007e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e6:	74 1e                	je     800806 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 00                	mov    (%eax),%eax
  8007ed:	8d 50 04             	lea    0x4(%eax),%edx
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	89 10                	mov    %edx,(%eax)
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	8b 00                	mov    (%eax),%eax
  8007fa:	83 e8 04             	sub    $0x4,%eax
  8007fd:	8b 00                	mov    (%eax),%eax
  8007ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800804:	eb 1c                	jmp    800822 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	8b 00                	mov    (%eax),%eax
  80080b:	8d 50 04             	lea    0x4(%eax),%edx
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	89 10                	mov    %edx,(%eax)
  800813:	8b 45 08             	mov    0x8(%ebp),%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	83 e8 04             	sub    $0x4,%eax
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800822:	5d                   	pop    %ebp
  800823:	c3                   	ret    

00800824 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800827:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80082b:	7e 1c                	jle    800849 <getint+0x25>
		return va_arg(*ap, long long);
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	8b 00                	mov    (%eax),%eax
  800832:	8d 50 08             	lea    0x8(%eax),%edx
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	89 10                	mov    %edx,(%eax)
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	8b 00                	mov    (%eax),%eax
  80083f:	83 e8 08             	sub    $0x8,%eax
  800842:	8b 50 04             	mov    0x4(%eax),%edx
  800845:	8b 00                	mov    (%eax),%eax
  800847:	eb 38                	jmp    800881 <getint+0x5d>
	else if (lflag)
  800849:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80084d:	74 1a                	je     800869 <getint+0x45>
		return va_arg(*ap, long);
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	8b 00                	mov    (%eax),%eax
  800854:	8d 50 04             	lea    0x4(%eax),%edx
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	89 10                	mov    %edx,(%eax)
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	8b 00                	mov    (%eax),%eax
  800861:	83 e8 04             	sub    $0x4,%eax
  800864:	8b 00                	mov    (%eax),%eax
  800866:	99                   	cltd   
  800867:	eb 18                	jmp    800881 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	8d 50 04             	lea    0x4(%eax),%edx
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	89 10                	mov    %edx,(%eax)
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	83 e8 04             	sub    $0x4,%eax
  80087e:	8b 00                	mov    (%eax),%eax
  800880:	99                   	cltd   
}
  800881:	5d                   	pop    %ebp
  800882:	c3                   	ret    

00800883 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
  800886:	56                   	push   %esi
  800887:	53                   	push   %ebx
  800888:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088b:	eb 17                	jmp    8008a4 <vprintfmt+0x21>
			if (ch == '\0')
  80088d:	85 db                	test   %ebx,%ebx
  80088f:	0f 84 af 03 00 00    	je     800c44 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800895:	83 ec 08             	sub    $0x8,%esp
  800898:	ff 75 0c             	pushl  0xc(%ebp)
  80089b:	53                   	push   %ebx
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	ff d0                	call   *%eax
  8008a1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a7:	8d 50 01             	lea    0x1(%eax),%edx
  8008aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ad:	8a 00                	mov    (%eax),%al
  8008af:	0f b6 d8             	movzbl %al,%ebx
  8008b2:	83 fb 25             	cmp    $0x25,%ebx
  8008b5:	75 d6                	jne    80088d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008bb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008c9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008d0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008da:	8d 50 01             	lea    0x1(%eax),%edx
  8008dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8008e0:	8a 00                	mov    (%eax),%al
  8008e2:	0f b6 d8             	movzbl %al,%ebx
  8008e5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008e8:	83 f8 55             	cmp    $0x55,%eax
  8008eb:	0f 87 2b 03 00 00    	ja     800c1c <vprintfmt+0x399>
  8008f1:	8b 04 85 58 23 80 00 	mov    0x802358(,%eax,4),%eax
  8008f8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008fa:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008fe:	eb d7                	jmp    8008d7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800900:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800904:	eb d1                	jmp    8008d7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800906:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80090d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800910:	89 d0                	mov    %edx,%eax
  800912:	c1 e0 02             	shl    $0x2,%eax
  800915:	01 d0                	add    %edx,%eax
  800917:	01 c0                	add    %eax,%eax
  800919:	01 d8                	add    %ebx,%eax
  80091b:	83 e8 30             	sub    $0x30,%eax
  80091e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800921:	8b 45 10             	mov    0x10(%ebp),%eax
  800924:	8a 00                	mov    (%eax),%al
  800926:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800929:	83 fb 2f             	cmp    $0x2f,%ebx
  80092c:	7e 3e                	jle    80096c <vprintfmt+0xe9>
  80092e:	83 fb 39             	cmp    $0x39,%ebx
  800931:	7f 39                	jg     80096c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800933:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800936:	eb d5                	jmp    80090d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 c0 04             	add    $0x4,%eax
  80093e:	89 45 14             	mov    %eax,0x14(%ebp)
  800941:	8b 45 14             	mov    0x14(%ebp),%eax
  800944:	83 e8 04             	sub    $0x4,%eax
  800947:	8b 00                	mov    (%eax),%eax
  800949:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80094c:	eb 1f                	jmp    80096d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80094e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800952:	79 83                	jns    8008d7 <vprintfmt+0x54>
				width = 0;
  800954:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80095b:	e9 77 ff ff ff       	jmp    8008d7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800960:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800967:	e9 6b ff ff ff       	jmp    8008d7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80096c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80096d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800971:	0f 89 60 ff ff ff    	jns    8008d7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800977:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80097a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800984:	e9 4e ff ff ff       	jmp    8008d7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800989:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80098c:	e9 46 ff ff ff       	jmp    8008d7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	83 c0 04             	add    $0x4,%eax
  800997:	89 45 14             	mov    %eax,0x14(%ebp)
  80099a:	8b 45 14             	mov    0x14(%ebp),%eax
  80099d:	83 e8 04             	sub    $0x4,%eax
  8009a0:	8b 00                	mov    (%eax),%eax
  8009a2:	83 ec 08             	sub    $0x8,%esp
  8009a5:	ff 75 0c             	pushl  0xc(%ebp)
  8009a8:	50                   	push   %eax
  8009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ac:	ff d0                	call   *%eax
  8009ae:	83 c4 10             	add    $0x10,%esp
			break;
  8009b1:	e9 89 02 00 00       	jmp    800c3f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b9:	83 c0 04             	add    $0x4,%eax
  8009bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8009bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c2:	83 e8 04             	sub    $0x4,%eax
  8009c5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009c7:	85 db                	test   %ebx,%ebx
  8009c9:	79 02                	jns    8009cd <vprintfmt+0x14a>
				err = -err;
  8009cb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009cd:	83 fb 64             	cmp    $0x64,%ebx
  8009d0:	7f 0b                	jg     8009dd <vprintfmt+0x15a>
  8009d2:	8b 34 9d a0 21 80 00 	mov    0x8021a0(,%ebx,4),%esi
  8009d9:	85 f6                	test   %esi,%esi
  8009db:	75 19                	jne    8009f6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009dd:	53                   	push   %ebx
  8009de:	68 45 23 80 00       	push   $0x802345
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	ff 75 08             	pushl  0x8(%ebp)
  8009e9:	e8 5e 02 00 00       	call   800c4c <printfmt>
  8009ee:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f1:	e9 49 02 00 00       	jmp    800c3f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009f6:	56                   	push   %esi
  8009f7:	68 4e 23 80 00       	push   $0x80234e
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	ff 75 08             	pushl  0x8(%ebp)
  800a02:	e8 45 02 00 00       	call   800c4c <printfmt>
  800a07:	83 c4 10             	add    $0x10,%esp
			break;
  800a0a:	e9 30 02 00 00       	jmp    800c3f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a0f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a12:	83 c0 04             	add    $0x4,%eax
  800a15:	89 45 14             	mov    %eax,0x14(%ebp)
  800a18:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1b:	83 e8 04             	sub    $0x4,%eax
  800a1e:	8b 30                	mov    (%eax),%esi
  800a20:	85 f6                	test   %esi,%esi
  800a22:	75 05                	jne    800a29 <vprintfmt+0x1a6>
				p = "(null)";
  800a24:	be 51 23 80 00       	mov    $0x802351,%esi
			if (width > 0 && padc != '-')
  800a29:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2d:	7e 6d                	jle    800a9c <vprintfmt+0x219>
  800a2f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a33:	74 67                	je     800a9c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a38:	83 ec 08             	sub    $0x8,%esp
  800a3b:	50                   	push   %eax
  800a3c:	56                   	push   %esi
  800a3d:	e8 0c 03 00 00       	call   800d4e <strnlen>
  800a42:	83 c4 10             	add    $0x10,%esp
  800a45:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a48:	eb 16                	jmp    800a60 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a4a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 0c             	pushl  0xc(%ebp)
  800a54:	50                   	push   %eax
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	ff d0                	call   *%eax
  800a5a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5d:	ff 4d e4             	decl   -0x1c(%ebp)
  800a60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a64:	7f e4                	jg     800a4a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a66:	eb 34                	jmp    800a9c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a68:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a6c:	74 1c                	je     800a8a <vprintfmt+0x207>
  800a6e:	83 fb 1f             	cmp    $0x1f,%ebx
  800a71:	7e 05                	jle    800a78 <vprintfmt+0x1f5>
  800a73:	83 fb 7e             	cmp    $0x7e,%ebx
  800a76:	7e 12                	jle    800a8a <vprintfmt+0x207>
					putch('?', putdat);
  800a78:	83 ec 08             	sub    $0x8,%esp
  800a7b:	ff 75 0c             	pushl  0xc(%ebp)
  800a7e:	6a 3f                	push   $0x3f
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	ff d0                	call   *%eax
  800a85:	83 c4 10             	add    $0x10,%esp
  800a88:	eb 0f                	jmp    800a99 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a8a:	83 ec 08             	sub    $0x8,%esp
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	53                   	push   %ebx
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	ff d0                	call   *%eax
  800a96:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a99:	ff 4d e4             	decl   -0x1c(%ebp)
  800a9c:	89 f0                	mov    %esi,%eax
  800a9e:	8d 70 01             	lea    0x1(%eax),%esi
  800aa1:	8a 00                	mov    (%eax),%al
  800aa3:	0f be d8             	movsbl %al,%ebx
  800aa6:	85 db                	test   %ebx,%ebx
  800aa8:	74 24                	je     800ace <vprintfmt+0x24b>
  800aaa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aae:	78 b8                	js     800a68 <vprintfmt+0x1e5>
  800ab0:	ff 4d e0             	decl   -0x20(%ebp)
  800ab3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab7:	79 af                	jns    800a68 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab9:	eb 13                	jmp    800ace <vprintfmt+0x24b>
				putch(' ', putdat);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	6a 20                	push   $0x20
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	ff d0                	call   *%eax
  800ac8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800acb:	ff 4d e4             	decl   -0x1c(%ebp)
  800ace:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad2:	7f e7                	jg     800abb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ad4:	e9 66 01 00 00       	jmp    800c3f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 e8             	pushl  -0x18(%ebp)
  800adf:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae2:	50                   	push   %eax
  800ae3:	e8 3c fd ff ff       	call   800824 <getint>
  800ae8:	83 c4 10             	add    $0x10,%esp
  800aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af7:	85 d2                	test   %edx,%edx
  800af9:	79 23                	jns    800b1e <vprintfmt+0x29b>
				putch('-', putdat);
  800afb:	83 ec 08             	sub    $0x8,%esp
  800afe:	ff 75 0c             	pushl  0xc(%ebp)
  800b01:	6a 2d                	push   $0x2d
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	ff d0                	call   *%eax
  800b08:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b11:	f7 d8                	neg    %eax
  800b13:	83 d2 00             	adc    $0x0,%edx
  800b16:	f7 da                	neg    %edx
  800b18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b1e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b25:	e9 bc 00 00 00       	jmp    800be6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	ff 75 e8             	pushl  -0x18(%ebp)
  800b30:	8d 45 14             	lea    0x14(%ebp),%eax
  800b33:	50                   	push   %eax
  800b34:	e8 84 fc ff ff       	call   8007bd <getuint>
  800b39:	83 c4 10             	add    $0x10,%esp
  800b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b42:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b49:	e9 98 00 00 00       	jmp    800be6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b4e:	83 ec 08             	sub    $0x8,%esp
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	6a 58                	push   $0x58
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	ff d0                	call   *%eax
  800b5b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b5e:	83 ec 08             	sub    $0x8,%esp
  800b61:	ff 75 0c             	pushl  0xc(%ebp)
  800b64:	6a 58                	push   $0x58
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	ff d0                	call   *%eax
  800b6b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b6e:	83 ec 08             	sub    $0x8,%esp
  800b71:	ff 75 0c             	pushl  0xc(%ebp)
  800b74:	6a 58                	push   $0x58
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
			break;
  800b7e:	e9 bc 00 00 00       	jmp    800c3f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b83:	83 ec 08             	sub    $0x8,%esp
  800b86:	ff 75 0c             	pushl  0xc(%ebp)
  800b89:	6a 30                	push   $0x30
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b93:	83 ec 08             	sub    $0x8,%esp
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	6a 78                	push   $0x78
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	ff d0                	call   *%eax
  800ba0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ba3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba6:	83 c0 04             	add    $0x4,%eax
  800ba9:	89 45 14             	mov    %eax,0x14(%ebp)
  800bac:	8b 45 14             	mov    0x14(%ebp),%eax
  800baf:	83 e8 04             	sub    $0x4,%eax
  800bb2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bbe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bc5:	eb 1f                	jmp    800be6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	ff 75 e8             	pushl  -0x18(%ebp)
  800bcd:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd0:	50                   	push   %eax
  800bd1:	e8 e7 fb ff ff       	call   8007bd <getuint>
  800bd6:	83 c4 10             	add    $0x10,%esp
  800bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bdf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bed:	83 ec 04             	sub    $0x4,%esp
  800bf0:	52                   	push   %edx
  800bf1:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf4:	50                   	push   %eax
  800bf5:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf8:	ff 75 f0             	pushl  -0x10(%ebp)
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	ff 75 08             	pushl  0x8(%ebp)
  800c01:	e8 00 fb ff ff       	call   800706 <printnum>
  800c06:	83 c4 20             	add    $0x20,%esp
			break;
  800c09:	eb 34                	jmp    800c3f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 0c             	pushl  0xc(%ebp)
  800c11:	53                   	push   %ebx
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	ff d0                	call   *%eax
  800c17:	83 c4 10             	add    $0x10,%esp
			break;
  800c1a:	eb 23                	jmp    800c3f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c1c:	83 ec 08             	sub    $0x8,%esp
  800c1f:	ff 75 0c             	pushl  0xc(%ebp)
  800c22:	6a 25                	push   $0x25
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	ff d0                	call   *%eax
  800c29:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c2c:	ff 4d 10             	decl   0x10(%ebp)
  800c2f:	eb 03                	jmp    800c34 <vprintfmt+0x3b1>
  800c31:	ff 4d 10             	decl   0x10(%ebp)
  800c34:	8b 45 10             	mov    0x10(%ebp),%eax
  800c37:	48                   	dec    %eax
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	3c 25                	cmp    $0x25,%al
  800c3c:	75 f3                	jne    800c31 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c3e:	90                   	nop
		}
	}
  800c3f:	e9 47 fc ff ff       	jmp    80088b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c44:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c45:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c48:	5b                   	pop    %ebx
  800c49:	5e                   	pop    %esi
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    

00800c4c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c52:	8d 45 10             	lea    0x10(%ebp),%eax
  800c55:	83 c0 04             	add    $0x4,%eax
  800c58:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c61:	50                   	push   %eax
  800c62:	ff 75 0c             	pushl  0xc(%ebp)
  800c65:	ff 75 08             	pushl  0x8(%ebp)
  800c68:	e8 16 fc ff ff       	call   800883 <vprintfmt>
  800c6d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c70:	90                   	nop
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c79:	8b 40 08             	mov    0x8(%eax),%eax
  800c7c:	8d 50 01             	lea    0x1(%eax),%edx
  800c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c82:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c88:	8b 10                	mov    (%eax),%edx
  800c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8d:	8b 40 04             	mov    0x4(%eax),%eax
  800c90:	39 c2                	cmp    %eax,%edx
  800c92:	73 12                	jae    800ca6 <sprintputch+0x33>
		*b->buf++ = ch;
  800c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c97:	8b 00                	mov    (%eax),%eax
  800c99:	8d 48 01             	lea    0x1(%eax),%ecx
  800c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9f:	89 0a                	mov    %ecx,(%edx)
  800ca1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca4:	88 10                	mov    %dl,(%eax)
}
  800ca6:	90                   	nop
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	01 d0                	add    %edx,%eax
  800cc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cce:	74 06                	je     800cd6 <vsnprintf+0x2d>
  800cd0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd4:	7f 07                	jg     800cdd <vsnprintf+0x34>
		return -E_INVAL;
  800cd6:	b8 03 00 00 00       	mov    $0x3,%eax
  800cdb:	eb 20                	jmp    800cfd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cdd:	ff 75 14             	pushl  0x14(%ebp)
  800ce0:	ff 75 10             	pushl  0x10(%ebp)
  800ce3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce6:	50                   	push   %eax
  800ce7:	68 73 0c 80 00       	push   $0x800c73
  800cec:	e8 92 fb ff ff       	call   800883 <vprintfmt>
  800cf1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d05:	8d 45 10             	lea    0x10(%ebp),%eax
  800d08:	83 c0 04             	add    $0x4,%eax
  800d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d11:	ff 75 f4             	pushl  -0xc(%ebp)
  800d14:	50                   	push   %eax
  800d15:	ff 75 0c             	pushl  0xc(%ebp)
  800d18:	ff 75 08             	pushl  0x8(%ebp)
  800d1b:	e8 89 ff ff ff       	call   800ca9 <vsnprintf>
  800d20:	83 c4 10             	add    $0x10,%esp
  800d23:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d38:	eb 06                	jmp    800d40 <strlen+0x15>
		n++;
  800d3a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d3d:	ff 45 08             	incl   0x8(%ebp)
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	84 c0                	test   %al,%al
  800d47:	75 f1                	jne    800d3a <strlen+0xf>
		n++;
	return n;
  800d49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4c:	c9                   	leave  
  800d4d:	c3                   	ret    

00800d4e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5b:	eb 09                	jmp    800d66 <strnlen+0x18>
		n++;
  800d5d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d60:	ff 45 08             	incl   0x8(%ebp)
  800d63:	ff 4d 0c             	decl   0xc(%ebp)
  800d66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6a:	74 09                	je     800d75 <strnlen+0x27>
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	84 c0                	test   %al,%al
  800d73:	75 e8                	jne    800d5d <strnlen+0xf>
		n++;
	return n;
  800d75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d86:	90                   	nop
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8d 50 01             	lea    0x1(%eax),%edx
  800d8d:	89 55 08             	mov    %edx,0x8(%ebp)
  800d90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d96:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d99:	8a 12                	mov    (%edx),%dl
  800d9b:	88 10                	mov    %dl,(%eax)
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	84 c0                	test   %al,%al
  800da1:	75 e4                	jne    800d87 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800da3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da6:	c9                   	leave  
  800da7:	c3                   	ret    

00800da8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800db4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dbb:	eb 1f                	jmp    800ddc <strncpy+0x34>
		*dst++ = *src;
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8d 50 01             	lea    0x1(%eax),%edx
  800dc3:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc9:	8a 12                	mov    (%edx),%dl
  800dcb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd0:	8a 00                	mov    (%eax),%al
  800dd2:	84 c0                	test   %al,%al
  800dd4:	74 03                	je     800dd9 <strncpy+0x31>
			src++;
  800dd6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd9:	ff 45 fc             	incl   -0x4(%ebp)
  800ddc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddf:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de2:	72 d9                	jb     800dbd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800de4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de7:	c9                   	leave  
  800de8:	c3                   	ret    

00800de9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800df5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df9:	74 30                	je     800e2b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dfb:	eb 16                	jmp    800e13 <strlcpy+0x2a>
			*dst++ = *src++;
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8d 50 01             	lea    0x1(%eax),%edx
  800e03:	89 55 08             	mov    %edx,0x8(%ebp)
  800e06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e09:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0f:	8a 12                	mov    (%edx),%dl
  800e11:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e13:	ff 4d 10             	decl   0x10(%ebp)
  800e16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1a:	74 09                	je     800e25 <strlcpy+0x3c>
  800e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	84 c0                	test   %al,%al
  800e23:	75 d8                	jne    800dfd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e31:	29 c2                	sub    %eax,%edx
  800e33:	89 d0                	mov    %edx,%eax
}
  800e35:	c9                   	leave  
  800e36:	c3                   	ret    

00800e37 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e3a:	eb 06                	jmp    800e42 <strcmp+0xb>
		p++, q++;
  800e3c:	ff 45 08             	incl   0x8(%ebp)
  800e3f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	84 c0                	test   %al,%al
  800e49:	74 0e                	je     800e59 <strcmp+0x22>
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 10                	mov    (%eax),%dl
  800e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	38 c2                	cmp    %al,%dl
  800e57:	74 e3                	je     800e3c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	8a 00                	mov    (%eax),%al
  800e5e:	0f b6 d0             	movzbl %al,%edx
  800e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	0f b6 c0             	movzbl %al,%eax
  800e69:	29 c2                	sub    %eax,%edx
  800e6b:	89 d0                	mov    %edx,%eax
}
  800e6d:	5d                   	pop    %ebp
  800e6e:	c3                   	ret    

00800e6f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e72:	eb 09                	jmp    800e7d <strncmp+0xe>
		n--, p++, q++;
  800e74:	ff 4d 10             	decl   0x10(%ebp)
  800e77:	ff 45 08             	incl   0x8(%ebp)
  800e7a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e81:	74 17                	je     800e9a <strncmp+0x2b>
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8a 00                	mov    (%eax),%al
  800e88:	84 c0                	test   %al,%al
  800e8a:	74 0e                	je     800e9a <strncmp+0x2b>
  800e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8f:	8a 10                	mov    (%eax),%dl
  800e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	38 c2                	cmp    %al,%dl
  800e98:	74 da                	je     800e74 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9e:	75 07                	jne    800ea7 <strncmp+0x38>
		return 0;
  800ea0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea5:	eb 14                	jmp    800ebb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f b6 d0             	movzbl %al,%edx
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	0f b6 c0             	movzbl %al,%eax
  800eb7:	29 c2                	sub    %eax,%edx
  800eb9:	89 d0                	mov    %edx,%eax
}
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    

00800ebd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	83 ec 04             	sub    $0x4,%esp
  800ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ec9:	eb 12                	jmp    800edd <strchr+0x20>
		if (*s == c)
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ed3:	75 05                	jne    800eda <strchr+0x1d>
			return (char *) s;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	eb 11                	jmp    800eeb <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eda:	ff 45 08             	incl   0x8(%ebp)
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	84 c0                	test   %al,%al
  800ee4:	75 e5                	jne    800ecb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ee6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eeb:	c9                   	leave  
  800eec:	c3                   	ret    

00800eed <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	83 ec 04             	sub    $0x4,%esp
  800ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef9:	eb 0d                	jmp    800f08 <strfind+0x1b>
		if (*s == c)
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f03:	74 0e                	je     800f13 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f05:	ff 45 08             	incl   0x8(%ebp)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	84 c0                	test   %al,%al
  800f0f:	75 ea                	jne    800efb <strfind+0xe>
  800f11:	eb 01                	jmp    800f14 <strfind+0x27>
		if (*s == c)
			break;
  800f13:	90                   	nop
	return (char *) s;
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f17:	c9                   	leave  
  800f18:	c3                   	ret    

00800f19 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f2b:	eb 0e                	jmp    800f3b <memset+0x22>
		*p++ = c;
  800f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f30:	8d 50 01             	lea    0x1(%eax),%edx
  800f33:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f39:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f3b:	ff 4d f8             	decl   -0x8(%ebp)
  800f3e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f42:	79 e9                	jns    800f2d <memset+0x14>
		*p++ = c;

	return v;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f47:	c9                   	leave  
  800f48:	c3                   	ret    

00800f49 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f5b:	eb 16                	jmp    800f73 <memcpy+0x2a>
		*d++ = *s++;
  800f5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f60:	8d 50 01             	lea    0x1(%eax),%edx
  800f63:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f66:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f69:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6f:	8a 12                	mov    (%edx),%dl
  800f71:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f73:	8b 45 10             	mov    0x10(%ebp),%eax
  800f76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f79:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	75 dd                	jne    800f5d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f83:	c9                   	leave  
  800f84:	c3                   	ret    

00800f85 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
  800f88:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9d:	73 50                	jae    800fef <memmove+0x6a>
  800f9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa5:	01 d0                	add    %edx,%eax
  800fa7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800faa:	76 43                	jbe    800fef <memmove+0x6a>
		s += n;
  800fac:	8b 45 10             	mov    0x10(%ebp),%eax
  800faf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb8:	eb 10                	jmp    800fca <memmove+0x45>
			*--d = *--s;
  800fba:	ff 4d f8             	decl   -0x8(%ebp)
  800fbd:	ff 4d fc             	decl   -0x4(%ebp)
  800fc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc3:	8a 10                	mov    (%eax),%dl
  800fc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fca:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	75 e3                	jne    800fba <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd7:	eb 23                	jmp    800ffc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdc:	8d 50 01             	lea    0x1(%eax),%edx
  800fdf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800feb:	8a 12                	mov    (%edx),%dl
  800fed:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fef:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff5:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff8:	85 c0                	test   %eax,%eax
  800ffa:	75 dd                	jne    800fd9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fff:	c9                   	leave  
  801000:	c3                   	ret    

00801001 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80100d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801010:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801013:	eb 2a                	jmp    80103f <memcmp+0x3e>
		if (*s1 != *s2)
  801015:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801018:	8a 10                	mov    (%eax),%dl
  80101a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	38 c2                	cmp    %al,%dl
  801021:	74 16                	je     801039 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	0f b6 d0             	movzbl %al,%edx
  80102b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	0f b6 c0             	movzbl %al,%eax
  801033:	29 c2                	sub    %eax,%edx
  801035:	89 d0                	mov    %edx,%eax
  801037:	eb 18                	jmp    801051 <memcmp+0x50>
		s1++, s2++;
  801039:	ff 45 fc             	incl   -0x4(%ebp)
  80103c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	8d 50 ff             	lea    -0x1(%eax),%edx
  801045:	89 55 10             	mov    %edx,0x10(%ebp)
  801048:	85 c0                	test   %eax,%eax
  80104a:	75 c9                	jne    801015 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80104c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801059:	8b 55 08             	mov    0x8(%ebp),%edx
  80105c:	8b 45 10             	mov    0x10(%ebp),%eax
  80105f:	01 d0                	add    %edx,%eax
  801061:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801064:	eb 15                	jmp    80107b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	0f b6 d0             	movzbl %al,%edx
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	0f b6 c0             	movzbl %al,%eax
  801074:	39 c2                	cmp    %eax,%edx
  801076:	74 0d                	je     801085 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801078:	ff 45 08             	incl   0x8(%ebp)
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801081:	72 e3                	jb     801066 <memfind+0x13>
  801083:	eb 01                	jmp    801086 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801085:	90                   	nop
	return (void *) s;
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801089:	c9                   	leave  
  80108a:	c3                   	ret    

0080108b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801091:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801098:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109f:	eb 03                	jmp    8010a4 <strtol+0x19>
		s++;
  8010a1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 20                	cmp    $0x20,%al
  8010ab:	74 f4                	je     8010a1 <strtol+0x16>
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	3c 09                	cmp    $0x9,%al
  8010b4:	74 eb                	je     8010a1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	3c 2b                	cmp    $0x2b,%al
  8010bd:	75 05                	jne    8010c4 <strtol+0x39>
		s++;
  8010bf:	ff 45 08             	incl   0x8(%ebp)
  8010c2:	eb 13                	jmp    8010d7 <strtol+0x4c>
	else if (*s == '-')
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	8a 00                	mov    (%eax),%al
  8010c9:	3c 2d                	cmp    $0x2d,%al
  8010cb:	75 0a                	jne    8010d7 <strtol+0x4c>
		s++, neg = 1;
  8010cd:	ff 45 08             	incl   0x8(%ebp)
  8010d0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010db:	74 06                	je     8010e3 <strtol+0x58>
  8010dd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e1:	75 20                	jne    801103 <strtol+0x78>
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	3c 30                	cmp    $0x30,%al
  8010ea:	75 17                	jne    801103 <strtol+0x78>
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	40                   	inc    %eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	3c 78                	cmp    $0x78,%al
  8010f4:	75 0d                	jne    801103 <strtol+0x78>
		s += 2, base = 16;
  8010f6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010fa:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801101:	eb 28                	jmp    80112b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801103:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801107:	75 15                	jne    80111e <strtol+0x93>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	8a 00                	mov    (%eax),%al
  80110e:	3c 30                	cmp    $0x30,%al
  801110:	75 0c                	jne    80111e <strtol+0x93>
		s++, base = 8;
  801112:	ff 45 08             	incl   0x8(%ebp)
  801115:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80111c:	eb 0d                	jmp    80112b <strtol+0xa0>
	else if (base == 0)
  80111e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801122:	75 07                	jne    80112b <strtol+0xa0>
		base = 10;
  801124:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	8a 00                	mov    (%eax),%al
  801130:	3c 2f                	cmp    $0x2f,%al
  801132:	7e 19                	jle    80114d <strtol+0xc2>
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	3c 39                	cmp    $0x39,%al
  80113b:	7f 10                	jg     80114d <strtol+0xc2>
			dig = *s - '0';
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	0f be c0             	movsbl %al,%eax
  801145:	83 e8 30             	sub    $0x30,%eax
  801148:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80114b:	eb 42                	jmp    80118f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80114d:	8b 45 08             	mov    0x8(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	3c 60                	cmp    $0x60,%al
  801154:	7e 19                	jle    80116f <strtol+0xe4>
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	3c 7a                	cmp    $0x7a,%al
  80115d:	7f 10                	jg     80116f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	0f be c0             	movsbl %al,%eax
  801167:	83 e8 57             	sub    $0x57,%eax
  80116a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116d:	eb 20                	jmp    80118f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	3c 40                	cmp    $0x40,%al
  801176:	7e 39                	jle    8011b1 <strtol+0x126>
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	3c 5a                	cmp    $0x5a,%al
  80117f:	7f 30                	jg     8011b1 <strtol+0x126>
			dig = *s - 'A' + 10;
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	0f be c0             	movsbl %al,%eax
  801189:	83 e8 37             	sub    $0x37,%eax
  80118c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80118f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801192:	3b 45 10             	cmp    0x10(%ebp),%eax
  801195:	7d 19                	jge    8011b0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801197:	ff 45 08             	incl   0x8(%ebp)
  80119a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119d:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a1:	89 c2                	mov    %eax,%edx
  8011a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a6:	01 d0                	add    %edx,%eax
  8011a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011ab:	e9 7b ff ff ff       	jmp    80112b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011b0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b5:	74 08                	je     8011bf <strtol+0x134>
		*endptr = (char *) s;
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c3:	74 07                	je     8011cc <strtol+0x141>
  8011c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c8:	f7 d8                	neg    %eax
  8011ca:	eb 03                	jmp    8011cf <strtol+0x144>
  8011cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011cf:	c9                   	leave  
  8011d0:	c3                   	ret    

008011d1 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e9:	79 13                	jns    8011fe <ltostr+0x2d>
	{
		neg = 1;
  8011eb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011f8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011fb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801206:	99                   	cltd   
  801207:	f7 f9                	idiv   %ecx
  801209:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80120c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120f:	8d 50 01             	lea    0x1(%eax),%edx
  801212:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801215:	89 c2                	mov    %eax,%edx
  801217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121a:	01 d0                	add    %edx,%eax
  80121c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121f:	83 c2 30             	add    $0x30,%edx
  801222:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801224:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801227:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80122c:	f7 e9                	imul   %ecx
  80122e:	c1 fa 02             	sar    $0x2,%edx
  801231:	89 c8                	mov    %ecx,%eax
  801233:	c1 f8 1f             	sar    $0x1f,%eax
  801236:	29 c2                	sub    %eax,%edx
  801238:	89 d0                	mov    %edx,%eax
  80123a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80123d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801240:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801245:	f7 e9                	imul   %ecx
  801247:	c1 fa 02             	sar    $0x2,%edx
  80124a:	89 c8                	mov    %ecx,%eax
  80124c:	c1 f8 1f             	sar    $0x1f,%eax
  80124f:	29 c2                	sub    %eax,%edx
  801251:	89 d0                	mov    %edx,%eax
  801253:	c1 e0 02             	shl    $0x2,%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	01 c0                	add    %eax,%eax
  80125a:	29 c1                	sub    %eax,%ecx
  80125c:	89 ca                	mov    %ecx,%edx
  80125e:	85 d2                	test   %edx,%edx
  801260:	75 9c                	jne    8011fe <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801262:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	48                   	dec    %eax
  80126d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801270:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801274:	74 3d                	je     8012b3 <ltostr+0xe2>
		start = 1 ;
  801276:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127d:	eb 34                	jmp    8012b3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80127f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801282:	8b 45 0c             	mov    0xc(%ebp),%eax
  801285:	01 d0                	add    %edx,%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80128c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801292:	01 c2                	add    %eax,%edx
  801294:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129a:	01 c8                	add    %ecx,%eax
  80129c:	8a 00                	mov    (%eax),%al
  80129e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a6:	01 c2                	add    %eax,%edx
  8012a8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012ab:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ad:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012b0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b9:	7c c4                	jl     80127f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c1:	01 d0                	add    %edx,%eax
  8012c3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c6:	90                   	nop
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    

008012c9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012cf:	ff 75 08             	pushl  0x8(%ebp)
  8012d2:	e8 54 fa ff ff       	call   800d2b <strlen>
  8012d7:	83 c4 04             	add    $0x4,%esp
  8012da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	e8 46 fa ff ff       	call   800d2b <strlen>
  8012e5:	83 c4 04             	add    $0x4,%esp
  8012e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f9:	eb 17                	jmp    801312 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801301:	01 c2                	add    %eax,%edx
  801303:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	01 c8                	add    %ecx,%eax
  80130b:	8a 00                	mov    (%eax),%al
  80130d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130f:	ff 45 fc             	incl   -0x4(%ebp)
  801312:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801315:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801318:	7c e1                	jl     8012fb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80131a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801321:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801328:	eb 1f                	jmp    801349 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80132a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132d:	8d 50 01             	lea    0x1(%eax),%edx
  801330:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801333:	89 c2                	mov    %eax,%edx
  801335:	8b 45 10             	mov    0x10(%ebp),%eax
  801338:	01 c2                	add    %eax,%edx
  80133a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801340:	01 c8                	add    %ecx,%eax
  801342:	8a 00                	mov    (%eax),%al
  801344:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801346:	ff 45 f8             	incl   -0x8(%ebp)
  801349:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134f:	7c d9                	jl     80132a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801351:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	01 d0                	add    %edx,%eax
  801359:	c6 00 00             	movb   $0x0,(%eax)
}
  80135c:	90                   	nop
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801362:	8b 45 14             	mov    0x14(%ebp),%eax
  801365:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80136b:	8b 45 14             	mov    0x14(%ebp),%eax
  80136e:	8b 00                	mov    (%eax),%eax
  801370:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801377:	8b 45 10             	mov    0x10(%ebp),%eax
  80137a:	01 d0                	add    %edx,%eax
  80137c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801382:	eb 0c                	jmp    801390 <strsplit+0x31>
			*string++ = 0;
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	8d 50 01             	lea    0x1(%eax),%edx
  80138a:	89 55 08             	mov    %edx,0x8(%ebp)
  80138d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	84 c0                	test   %al,%al
  801397:	74 18                	je     8013b1 <strsplit+0x52>
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	0f be c0             	movsbl %al,%eax
  8013a1:	50                   	push   %eax
  8013a2:	ff 75 0c             	pushl  0xc(%ebp)
  8013a5:	e8 13 fb ff ff       	call   800ebd <strchr>
  8013aa:	83 c4 08             	add    $0x8,%esp
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	75 d3                	jne    801384 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	8a 00                	mov    (%eax),%al
  8013b6:	84 c0                	test   %al,%al
  8013b8:	74 5a                	je     801414 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bd:	8b 00                	mov    (%eax),%eax
  8013bf:	83 f8 0f             	cmp    $0xf,%eax
  8013c2:	75 07                	jne    8013cb <strsplit+0x6c>
		{
			return 0;
  8013c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c9:	eb 66                	jmp    801431 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ce:	8b 00                	mov    (%eax),%eax
  8013d0:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d3:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d6:	89 0a                	mov    %ecx,(%edx)
  8013d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	01 c2                	add    %eax,%edx
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e9:	eb 03                	jmp    8013ee <strsplit+0x8f>
			string++;
  8013eb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	84 c0                	test   %al,%al
  8013f5:	74 8b                	je     801382 <strsplit+0x23>
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	8a 00                	mov    (%eax),%al
  8013fc:	0f be c0             	movsbl %al,%eax
  8013ff:	50                   	push   %eax
  801400:	ff 75 0c             	pushl  0xc(%ebp)
  801403:	e8 b5 fa ff ff       	call   800ebd <strchr>
  801408:	83 c4 08             	add    $0x8,%esp
  80140b:	85 c0                	test   %eax,%eax
  80140d:	74 dc                	je     8013eb <strsplit+0x8c>
			string++;
	}
  80140f:	e9 6e ff ff ff       	jmp    801382 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801414:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801415:	8b 45 14             	mov    0x14(%ebp),%eax
  801418:	8b 00                	mov    (%eax),%eax
  80141a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801421:	8b 45 10             	mov    0x10(%ebp),%eax
  801424:	01 d0                	add    %edx,%eax
  801426:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80142c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	57                   	push   %edi
  801437:	56                   	push   %esi
  801438:	53                   	push   %ebx
  801439:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80143c:	8b 45 08             	mov    0x8(%ebp),%eax
  80143f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801442:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801445:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801448:	8b 7d 18             	mov    0x18(%ebp),%edi
  80144b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80144e:	cd 30                	int    $0x30
  801450:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801453:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801456:	83 c4 10             	add    $0x10,%esp
  801459:	5b                   	pop    %ebx
  80145a:	5e                   	pop    %esi
  80145b:	5f                   	pop    %edi
  80145c:	5d                   	pop    %ebp
  80145d:	c3                   	ret    

0080145e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	8b 45 10             	mov    0x10(%ebp),%eax
  801467:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80146a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	52                   	push   %edx
  801476:	ff 75 0c             	pushl  0xc(%ebp)
  801479:	50                   	push   %eax
  80147a:	6a 00                	push   $0x0
  80147c:	e8 b2 ff ff ff       	call   801433 <syscall>
  801481:	83 c4 18             	add    $0x18,%esp
}
  801484:	90                   	nop
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <sys_cgetc>:

int
sys_cgetc(void)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 01                	push   $0x1
  801496:	e8 98 ff ff ff       	call   801433 <syscall>
  80149b:	83 c4 18             	add    $0x18,%esp
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	52                   	push   %edx
  8014b0:	50                   	push   %eax
  8014b1:	6a 05                	push   $0x5
  8014b3:	e8 7b ff ff ff       	call   801433 <syscall>
  8014b8:	83 c4 18             	add    $0x18,%esp
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	56                   	push   %esi
  8014c1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014c2:	8b 75 18             	mov    0x18(%ebp),%esi
  8014c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	56                   	push   %esi
  8014d2:	53                   	push   %ebx
  8014d3:	51                   	push   %ecx
  8014d4:	52                   	push   %edx
  8014d5:	50                   	push   %eax
  8014d6:	6a 06                	push   $0x6
  8014d8:	e8 56 ff ff ff       	call   801433 <syscall>
  8014dd:	83 c4 18             	add    $0x18,%esp
}
  8014e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e3:	5b                   	pop    %ebx
  8014e4:	5e                   	pop    %esi
  8014e5:	5d                   	pop    %ebp
  8014e6:	c3                   	ret    

008014e7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	52                   	push   %edx
  8014f7:	50                   	push   %eax
  8014f8:	6a 07                	push   $0x7
  8014fa:	e8 34 ff ff ff       	call   801433 <syscall>
  8014ff:	83 c4 18             	add    $0x18,%esp
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	ff 75 0c             	pushl  0xc(%ebp)
  801510:	ff 75 08             	pushl  0x8(%ebp)
  801513:	6a 08                	push   $0x8
  801515:	e8 19 ff ff ff       	call   801433 <syscall>
  80151a:	83 c4 18             	add    $0x18,%esp
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 09                	push   $0x9
  80152e:	e8 00 ff ff ff       	call   801433 <syscall>
  801533:	83 c4 18             	add    $0x18,%esp
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 0a                	push   $0xa
  801547:	e8 e7 fe ff ff       	call   801433 <syscall>
  80154c:	83 c4 18             	add    $0x18,%esp
}
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 0b                	push   $0xb
  801560:	e8 ce fe ff ff       	call   801433 <syscall>
  801565:	83 c4 18             	add    $0x18,%esp
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	ff 75 0c             	pushl  0xc(%ebp)
  801576:	ff 75 08             	pushl  0x8(%ebp)
  801579:	6a 0f                	push   $0xf
  80157b:	e8 b3 fe ff ff       	call   801433 <syscall>
  801580:	83 c4 18             	add    $0x18,%esp
	return;
  801583:	90                   	nop
}
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	ff 75 0c             	pushl  0xc(%ebp)
  801592:	ff 75 08             	pushl  0x8(%ebp)
  801595:	6a 10                	push   $0x10
  801597:	e8 97 fe ff ff       	call   801433 <syscall>
  80159c:	83 c4 18             	add    $0x18,%esp
	return ;
  80159f:	90                   	nop
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	ff 75 10             	pushl  0x10(%ebp)
  8015ac:	ff 75 0c             	pushl  0xc(%ebp)
  8015af:	ff 75 08             	pushl  0x8(%ebp)
  8015b2:	6a 11                	push   $0x11
  8015b4:	e8 7a fe ff ff       	call   801433 <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8015bc:	90                   	nop
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 0c                	push   $0xc
  8015ce:	e8 60 fe ff ff       	call   801433 <syscall>
  8015d3:	83 c4 18             	add    $0x18,%esp
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	ff 75 08             	pushl  0x8(%ebp)
  8015e6:	6a 0d                	push   $0xd
  8015e8:	e8 46 fe ff ff       	call   801433 <syscall>
  8015ed:	83 c4 18             	add    $0x18,%esp
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 0e                	push   $0xe
  801601:	e8 2d fe ff ff       	call   801433 <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	90                   	nop
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 13                	push   $0x13
  80161b:	e8 13 fe ff ff       	call   801433 <syscall>
  801620:	83 c4 18             	add    $0x18,%esp
}
  801623:	90                   	nop
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 14                	push   $0x14
  801635:	e8 f9 fd ff ff       	call   801433 <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
}
  80163d:	90                   	nop
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <sys_cputc>:


void
sys_cputc(const char c)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 04             	sub    $0x4,%esp
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80164c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	50                   	push   %eax
  801659:	6a 15                	push   $0x15
  80165b:	e8 d3 fd ff ff       	call   801433 <syscall>
  801660:	83 c4 18             	add    $0x18,%esp
}
  801663:	90                   	nop
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 16                	push   $0x16
  801675:	e8 b9 fd ff ff       	call   801433 <syscall>
  80167a:	83 c4 18             	add    $0x18,%esp
}
  80167d:	90                   	nop
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	ff 75 0c             	pushl  0xc(%ebp)
  80168f:	50                   	push   %eax
  801690:	6a 17                	push   $0x17
  801692:	e8 9c fd ff ff       	call   801433 <syscall>
  801697:	83 c4 18             	add    $0x18,%esp
}
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80169f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	52                   	push   %edx
  8016ac:	50                   	push   %eax
  8016ad:	6a 1a                	push   $0x1a
  8016af:	e8 7f fd ff ff       	call   801433 <syscall>
  8016b4:	83 c4 18             	add    $0x18,%esp
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	52                   	push   %edx
  8016c9:	50                   	push   %eax
  8016ca:	6a 18                	push   $0x18
  8016cc:	e8 62 fd ff ff       	call   801433 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
}
  8016d4:	90                   	nop
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	52                   	push   %edx
  8016e7:	50                   	push   %eax
  8016e8:	6a 19                	push   $0x19
  8016ea:	e8 44 fd ff ff       	call   801433 <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
}
  8016f2:	90                   	nop
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 04             	sub    $0x4,%esp
  8016fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801701:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801704:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	6a 00                	push   $0x0
  80170d:	51                   	push   %ecx
  80170e:	52                   	push   %edx
  80170f:	ff 75 0c             	pushl  0xc(%ebp)
  801712:	50                   	push   %eax
  801713:	6a 1b                	push   $0x1b
  801715:	e8 19 fd ff ff       	call   801433 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801722:	8b 55 0c             	mov    0xc(%ebp),%edx
  801725:	8b 45 08             	mov    0x8(%ebp),%eax
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	52                   	push   %edx
  80172f:	50                   	push   %eax
  801730:	6a 1c                	push   $0x1c
  801732:	e8 fc fc ff ff       	call   801433 <syscall>
  801737:	83 c4 18             	add    $0x18,%esp
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80173f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801742:	8b 55 0c             	mov    0xc(%ebp),%edx
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	51                   	push   %ecx
  80174d:	52                   	push   %edx
  80174e:	50                   	push   %eax
  80174f:	6a 1d                	push   $0x1d
  801751:	e8 dd fc ff ff       	call   801433 <syscall>
  801756:	83 c4 18             	add    $0x18,%esp
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80175e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	52                   	push   %edx
  80176b:	50                   	push   %eax
  80176c:	6a 1e                	push   $0x1e
  80176e:	e8 c0 fc ff ff       	call   801433 <syscall>
  801773:	83 c4 18             	add    $0x18,%esp
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 1f                	push   $0x1f
  801787:	e8 a7 fc ff ff       	call   801433 <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	6a 00                	push   $0x0
  801799:	ff 75 14             	pushl  0x14(%ebp)
  80179c:	ff 75 10             	pushl  0x10(%ebp)
  80179f:	ff 75 0c             	pushl  0xc(%ebp)
  8017a2:	50                   	push   %eax
  8017a3:	6a 20                	push   $0x20
  8017a5:	e8 89 fc ff ff       	call   801433 <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	50                   	push   %eax
  8017be:	6a 21                	push   $0x21
  8017c0:	e8 6e fc ff ff       	call   801433 <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
}
  8017c8:	90                   	nop
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	50                   	push   %eax
  8017da:	6a 22                	push   $0x22
  8017dc:	e8 52 fc ff ff       	call   801433 <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 02                	push   $0x2
  8017f5:	e8 39 fc ff ff       	call   801433 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 03                	push   $0x3
  80180e:	e8 20 fc ff ff       	call   801433 <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 04                	push   $0x4
  801827:	e8 07 fc ff ff       	call   801433 <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_exit_env>:


void sys_exit_env(void)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 23                	push   $0x23
  801840:	e8 ee fb ff ff       	call   801433 <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
}
  801848:	90                   	nop
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801851:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801854:	8d 50 04             	lea    0x4(%eax),%edx
  801857:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	52                   	push   %edx
  801861:	50                   	push   %eax
  801862:	6a 24                	push   $0x24
  801864:	e8 ca fb ff ff       	call   801433 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
	return result;
  80186c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80186f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801872:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801875:	89 01                	mov    %eax,(%ecx)
  801877:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	c9                   	leave  
  80187e:	c2 04 00             	ret    $0x4

00801881 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	ff 75 10             	pushl  0x10(%ebp)
  80188b:	ff 75 0c             	pushl  0xc(%ebp)
  80188e:	ff 75 08             	pushl  0x8(%ebp)
  801891:	6a 12                	push   $0x12
  801893:	e8 9b fb ff ff       	call   801433 <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
	return ;
  80189b:	90                   	nop
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_rcr2>:
uint32 sys_rcr2()
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 25                	push   $0x25
  8018ad:	e8 81 fb ff ff       	call   801433 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 04             	sub    $0x4,%esp
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018c3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	50                   	push   %eax
  8018d0:	6a 26                	push   $0x26
  8018d2:	e8 5c fb ff ff       	call   801433 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018da:	90                   	nop
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <rsttst>:
void rsttst()
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 28                	push   $0x28
  8018ec:	e8 42 fb ff ff       	call   801433 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f4:	90                   	nop
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	83 ec 04             	sub    $0x4,%esp
  8018fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801900:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801903:	8b 55 18             	mov    0x18(%ebp),%edx
  801906:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80190a:	52                   	push   %edx
  80190b:	50                   	push   %eax
  80190c:	ff 75 10             	pushl  0x10(%ebp)
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	ff 75 08             	pushl  0x8(%ebp)
  801915:	6a 27                	push   $0x27
  801917:	e8 17 fb ff ff       	call   801433 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
	return ;
  80191f:	90                   	nop
}
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <chktst>:
void chktst(uint32 n)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	ff 75 08             	pushl  0x8(%ebp)
  801930:	6a 29                	push   $0x29
  801932:	e8 fc fa ff ff       	call   801433 <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
	return ;
  80193a:	90                   	nop
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <inctst>:

void inctst()
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 2a                	push   $0x2a
  80194c:	e8 e2 fa ff ff       	call   801433 <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
	return ;
  801954:	90                   	nop
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <gettst>:
uint32 gettst()
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 2b                	push   $0x2b
  801966:	e8 c8 fa ff ff       	call   801433 <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 2c                	push   $0x2c
  801982:	e8 ac fa ff ff       	call   801433 <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
  80198a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80198d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801991:	75 07                	jne    80199a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801993:	b8 01 00 00 00       	mov    $0x1,%eax
  801998:	eb 05                	jmp    80199f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80199a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 2c                	push   $0x2c
  8019b3:	e8 7b fa ff ff       	call   801433 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
  8019bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019be:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019c2:	75 07                	jne    8019cb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8019c9:	eb 05                	jmp    8019d0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 2c                	push   $0x2c
  8019e4:	e8 4a fa ff ff       	call   801433 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
  8019ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8019ef:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8019f3:	75 07                	jne    8019fc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8019f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fa:	eb 05                	jmp    801a01 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8019fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 2c                	push   $0x2c
  801a15:	e8 19 fa ff ff       	call   801433 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
  801a1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a20:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a24:	75 07                	jne    801a2d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a26:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2b:	eb 05                	jmp    801a32 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	ff 75 08             	pushl  0x8(%ebp)
  801a42:	6a 2d                	push   $0x2d
  801a44:	e8 ea f9 ff ff       	call   801433 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4c:	90                   	nop
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a53:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a56:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	6a 00                	push   $0x0
  801a61:	53                   	push   %ebx
  801a62:	51                   	push   %ecx
  801a63:	52                   	push   %edx
  801a64:	50                   	push   %eax
  801a65:	6a 2e                	push   $0x2e
  801a67:	e8 c7 f9 ff ff       	call   801433 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	52                   	push   %edx
  801a84:	50                   	push   %eax
  801a85:	6a 2f                	push   $0x2f
  801a87:	e8 a7 f9 ff ff       	call   801433 <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    
  801a91:	66 90                	xchg   %ax,%ax
  801a93:	90                   	nop

00801a94 <__udivdi3>:
  801a94:	55                   	push   %ebp
  801a95:	57                   	push   %edi
  801a96:	56                   	push   %esi
  801a97:	53                   	push   %ebx
  801a98:	83 ec 1c             	sub    $0x1c,%esp
  801a9b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a9f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801aa3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aa7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aab:	89 ca                	mov    %ecx,%edx
  801aad:	89 f8                	mov    %edi,%eax
  801aaf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ab3:	85 f6                	test   %esi,%esi
  801ab5:	75 2d                	jne    801ae4 <__udivdi3+0x50>
  801ab7:	39 cf                	cmp    %ecx,%edi
  801ab9:	77 65                	ja     801b20 <__udivdi3+0x8c>
  801abb:	89 fd                	mov    %edi,%ebp
  801abd:	85 ff                	test   %edi,%edi
  801abf:	75 0b                	jne    801acc <__udivdi3+0x38>
  801ac1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac6:	31 d2                	xor    %edx,%edx
  801ac8:	f7 f7                	div    %edi
  801aca:	89 c5                	mov    %eax,%ebp
  801acc:	31 d2                	xor    %edx,%edx
  801ace:	89 c8                	mov    %ecx,%eax
  801ad0:	f7 f5                	div    %ebp
  801ad2:	89 c1                	mov    %eax,%ecx
  801ad4:	89 d8                	mov    %ebx,%eax
  801ad6:	f7 f5                	div    %ebp
  801ad8:	89 cf                	mov    %ecx,%edi
  801ada:	89 fa                	mov    %edi,%edx
  801adc:	83 c4 1c             	add    $0x1c,%esp
  801adf:	5b                   	pop    %ebx
  801ae0:	5e                   	pop    %esi
  801ae1:	5f                   	pop    %edi
  801ae2:	5d                   	pop    %ebp
  801ae3:	c3                   	ret    
  801ae4:	39 ce                	cmp    %ecx,%esi
  801ae6:	77 28                	ja     801b10 <__udivdi3+0x7c>
  801ae8:	0f bd fe             	bsr    %esi,%edi
  801aeb:	83 f7 1f             	xor    $0x1f,%edi
  801aee:	75 40                	jne    801b30 <__udivdi3+0x9c>
  801af0:	39 ce                	cmp    %ecx,%esi
  801af2:	72 0a                	jb     801afe <__udivdi3+0x6a>
  801af4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801af8:	0f 87 9e 00 00 00    	ja     801b9c <__udivdi3+0x108>
  801afe:	b8 01 00 00 00       	mov    $0x1,%eax
  801b03:	89 fa                	mov    %edi,%edx
  801b05:	83 c4 1c             	add    $0x1c,%esp
  801b08:	5b                   	pop    %ebx
  801b09:	5e                   	pop    %esi
  801b0a:	5f                   	pop    %edi
  801b0b:	5d                   	pop    %ebp
  801b0c:	c3                   	ret    
  801b0d:	8d 76 00             	lea    0x0(%esi),%esi
  801b10:	31 ff                	xor    %edi,%edi
  801b12:	31 c0                	xor    %eax,%eax
  801b14:	89 fa                	mov    %edi,%edx
  801b16:	83 c4 1c             	add    $0x1c,%esp
  801b19:	5b                   	pop    %ebx
  801b1a:	5e                   	pop    %esi
  801b1b:	5f                   	pop    %edi
  801b1c:	5d                   	pop    %ebp
  801b1d:	c3                   	ret    
  801b1e:	66 90                	xchg   %ax,%ax
  801b20:	89 d8                	mov    %ebx,%eax
  801b22:	f7 f7                	div    %edi
  801b24:	31 ff                	xor    %edi,%edi
  801b26:	89 fa                	mov    %edi,%edx
  801b28:	83 c4 1c             	add    $0x1c,%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5f                   	pop    %edi
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    
  801b30:	bd 20 00 00 00       	mov    $0x20,%ebp
  801b35:	89 eb                	mov    %ebp,%ebx
  801b37:	29 fb                	sub    %edi,%ebx
  801b39:	89 f9                	mov    %edi,%ecx
  801b3b:	d3 e6                	shl    %cl,%esi
  801b3d:	89 c5                	mov    %eax,%ebp
  801b3f:	88 d9                	mov    %bl,%cl
  801b41:	d3 ed                	shr    %cl,%ebp
  801b43:	89 e9                	mov    %ebp,%ecx
  801b45:	09 f1                	or     %esi,%ecx
  801b47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801b4b:	89 f9                	mov    %edi,%ecx
  801b4d:	d3 e0                	shl    %cl,%eax
  801b4f:	89 c5                	mov    %eax,%ebp
  801b51:	89 d6                	mov    %edx,%esi
  801b53:	88 d9                	mov    %bl,%cl
  801b55:	d3 ee                	shr    %cl,%esi
  801b57:	89 f9                	mov    %edi,%ecx
  801b59:	d3 e2                	shl    %cl,%edx
  801b5b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b5f:	88 d9                	mov    %bl,%cl
  801b61:	d3 e8                	shr    %cl,%eax
  801b63:	09 c2                	or     %eax,%edx
  801b65:	89 d0                	mov    %edx,%eax
  801b67:	89 f2                	mov    %esi,%edx
  801b69:	f7 74 24 0c          	divl   0xc(%esp)
  801b6d:	89 d6                	mov    %edx,%esi
  801b6f:	89 c3                	mov    %eax,%ebx
  801b71:	f7 e5                	mul    %ebp
  801b73:	39 d6                	cmp    %edx,%esi
  801b75:	72 19                	jb     801b90 <__udivdi3+0xfc>
  801b77:	74 0b                	je     801b84 <__udivdi3+0xf0>
  801b79:	89 d8                	mov    %ebx,%eax
  801b7b:	31 ff                	xor    %edi,%edi
  801b7d:	e9 58 ff ff ff       	jmp    801ada <__udivdi3+0x46>
  801b82:	66 90                	xchg   %ax,%ax
  801b84:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b88:	89 f9                	mov    %edi,%ecx
  801b8a:	d3 e2                	shl    %cl,%edx
  801b8c:	39 c2                	cmp    %eax,%edx
  801b8e:	73 e9                	jae    801b79 <__udivdi3+0xe5>
  801b90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b93:	31 ff                	xor    %edi,%edi
  801b95:	e9 40 ff ff ff       	jmp    801ada <__udivdi3+0x46>
  801b9a:	66 90                	xchg   %ax,%ax
  801b9c:	31 c0                	xor    %eax,%eax
  801b9e:	e9 37 ff ff ff       	jmp    801ada <__udivdi3+0x46>
  801ba3:	90                   	nop

00801ba4 <__umoddi3>:
  801ba4:	55                   	push   %ebp
  801ba5:	57                   	push   %edi
  801ba6:	56                   	push   %esi
  801ba7:	53                   	push   %ebx
  801ba8:	83 ec 1c             	sub    $0x1c,%esp
  801bab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801baf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801bb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bb7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801bbb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bbf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bc3:	89 f3                	mov    %esi,%ebx
  801bc5:	89 fa                	mov    %edi,%edx
  801bc7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bcb:	89 34 24             	mov    %esi,(%esp)
  801bce:	85 c0                	test   %eax,%eax
  801bd0:	75 1a                	jne    801bec <__umoddi3+0x48>
  801bd2:	39 f7                	cmp    %esi,%edi
  801bd4:	0f 86 a2 00 00 00    	jbe    801c7c <__umoddi3+0xd8>
  801bda:	89 c8                	mov    %ecx,%eax
  801bdc:	89 f2                	mov    %esi,%edx
  801bde:	f7 f7                	div    %edi
  801be0:	89 d0                	mov    %edx,%eax
  801be2:	31 d2                	xor    %edx,%edx
  801be4:	83 c4 1c             	add    $0x1c,%esp
  801be7:	5b                   	pop    %ebx
  801be8:	5e                   	pop    %esi
  801be9:	5f                   	pop    %edi
  801bea:	5d                   	pop    %ebp
  801beb:	c3                   	ret    
  801bec:	39 f0                	cmp    %esi,%eax
  801bee:	0f 87 ac 00 00 00    	ja     801ca0 <__umoddi3+0xfc>
  801bf4:	0f bd e8             	bsr    %eax,%ebp
  801bf7:	83 f5 1f             	xor    $0x1f,%ebp
  801bfa:	0f 84 ac 00 00 00    	je     801cac <__umoddi3+0x108>
  801c00:	bf 20 00 00 00       	mov    $0x20,%edi
  801c05:	29 ef                	sub    %ebp,%edi
  801c07:	89 fe                	mov    %edi,%esi
  801c09:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c0d:	89 e9                	mov    %ebp,%ecx
  801c0f:	d3 e0                	shl    %cl,%eax
  801c11:	89 d7                	mov    %edx,%edi
  801c13:	89 f1                	mov    %esi,%ecx
  801c15:	d3 ef                	shr    %cl,%edi
  801c17:	09 c7                	or     %eax,%edi
  801c19:	89 e9                	mov    %ebp,%ecx
  801c1b:	d3 e2                	shl    %cl,%edx
  801c1d:	89 14 24             	mov    %edx,(%esp)
  801c20:	89 d8                	mov    %ebx,%eax
  801c22:	d3 e0                	shl    %cl,%eax
  801c24:	89 c2                	mov    %eax,%edx
  801c26:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c2a:	d3 e0                	shl    %cl,%eax
  801c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c30:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c34:	89 f1                	mov    %esi,%ecx
  801c36:	d3 e8                	shr    %cl,%eax
  801c38:	09 d0                	or     %edx,%eax
  801c3a:	d3 eb                	shr    %cl,%ebx
  801c3c:	89 da                	mov    %ebx,%edx
  801c3e:	f7 f7                	div    %edi
  801c40:	89 d3                	mov    %edx,%ebx
  801c42:	f7 24 24             	mull   (%esp)
  801c45:	89 c6                	mov    %eax,%esi
  801c47:	89 d1                	mov    %edx,%ecx
  801c49:	39 d3                	cmp    %edx,%ebx
  801c4b:	0f 82 87 00 00 00    	jb     801cd8 <__umoddi3+0x134>
  801c51:	0f 84 91 00 00 00    	je     801ce8 <__umoddi3+0x144>
  801c57:	8b 54 24 04          	mov    0x4(%esp),%edx
  801c5b:	29 f2                	sub    %esi,%edx
  801c5d:	19 cb                	sbb    %ecx,%ebx
  801c5f:	89 d8                	mov    %ebx,%eax
  801c61:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c65:	d3 e0                	shl    %cl,%eax
  801c67:	89 e9                	mov    %ebp,%ecx
  801c69:	d3 ea                	shr    %cl,%edx
  801c6b:	09 d0                	or     %edx,%eax
  801c6d:	89 e9                	mov    %ebp,%ecx
  801c6f:	d3 eb                	shr    %cl,%ebx
  801c71:	89 da                	mov    %ebx,%edx
  801c73:	83 c4 1c             	add    $0x1c,%esp
  801c76:	5b                   	pop    %ebx
  801c77:	5e                   	pop    %esi
  801c78:	5f                   	pop    %edi
  801c79:	5d                   	pop    %ebp
  801c7a:	c3                   	ret    
  801c7b:	90                   	nop
  801c7c:	89 fd                	mov    %edi,%ebp
  801c7e:	85 ff                	test   %edi,%edi
  801c80:	75 0b                	jne    801c8d <__umoddi3+0xe9>
  801c82:	b8 01 00 00 00       	mov    $0x1,%eax
  801c87:	31 d2                	xor    %edx,%edx
  801c89:	f7 f7                	div    %edi
  801c8b:	89 c5                	mov    %eax,%ebp
  801c8d:	89 f0                	mov    %esi,%eax
  801c8f:	31 d2                	xor    %edx,%edx
  801c91:	f7 f5                	div    %ebp
  801c93:	89 c8                	mov    %ecx,%eax
  801c95:	f7 f5                	div    %ebp
  801c97:	89 d0                	mov    %edx,%eax
  801c99:	e9 44 ff ff ff       	jmp    801be2 <__umoddi3+0x3e>
  801c9e:	66 90                	xchg   %ax,%ax
  801ca0:	89 c8                	mov    %ecx,%eax
  801ca2:	89 f2                	mov    %esi,%edx
  801ca4:	83 c4 1c             	add    $0x1c,%esp
  801ca7:	5b                   	pop    %ebx
  801ca8:	5e                   	pop    %esi
  801ca9:	5f                   	pop    %edi
  801caa:	5d                   	pop    %ebp
  801cab:	c3                   	ret    
  801cac:	3b 04 24             	cmp    (%esp),%eax
  801caf:	72 06                	jb     801cb7 <__umoddi3+0x113>
  801cb1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801cb5:	77 0f                	ja     801cc6 <__umoddi3+0x122>
  801cb7:	89 f2                	mov    %esi,%edx
  801cb9:	29 f9                	sub    %edi,%ecx
  801cbb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801cbf:	89 14 24             	mov    %edx,(%esp)
  801cc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cc6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801cca:	8b 14 24             	mov    (%esp),%edx
  801ccd:	83 c4 1c             	add    $0x1c,%esp
  801cd0:	5b                   	pop    %ebx
  801cd1:	5e                   	pop    %esi
  801cd2:	5f                   	pop    %edi
  801cd3:	5d                   	pop    %ebp
  801cd4:	c3                   	ret    
  801cd5:	8d 76 00             	lea    0x0(%esi),%esi
  801cd8:	2b 04 24             	sub    (%esp),%eax
  801cdb:	19 fa                	sbb    %edi,%edx
  801cdd:	89 d1                	mov    %edx,%ecx
  801cdf:	89 c6                	mov    %eax,%esi
  801ce1:	e9 71 ff ff ff       	jmp    801c57 <__umoddi3+0xb3>
  801ce6:	66 90                	xchg   %ax,%ax
  801ce8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801cec:	72 ea                	jb     801cd8 <__umoddi3+0x134>
  801cee:	89 d9                	mov    %ebx,%ecx
  801cf0:	e9 62 ff ff ff       	jmp    801c57 <__umoddi3+0xb3>
