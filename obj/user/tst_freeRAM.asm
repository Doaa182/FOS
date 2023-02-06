
obj/user/tst_freeRAM:     file format elf32-i386


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
  800031:	e8 85 14 00 00       	call   8014bb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

char arr[PAGE_SIZE*12];
uint32 WSEntries_before[1000];

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 8c 01 00 00    	sub    $0x18c,%esp
	vcprintf("\n\n===============================================================\n", NULL);
  800044:	83 ec 08             	sub    $0x8,%esp
  800047:	6a 00                	push   $0x0
  800049:	68 c0 2f 80 00       	push   $0x802fc0
  80004e:	e8 ed 17 00 00       	call   801840 <vcprintf>
  800053:	83 c4 10             	add    $0x10,%esp
	vcprintf("MAKE SURE to have a FRESH RUN for EACH SCENARIO of this test\n(i.e. don't run any program/test/multiple scenarios before it)\n", NULL);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	6a 00                	push   $0x0
  80005b:	68 04 30 80 00       	push   $0x803004
  800060:	e8 db 17 00 00       	call   801840 <vcprintf>
  800065:	83 c4 10             	add    $0x10,%esp
	vcprintf("===============================================================\n\n\n", NULL);
  800068:	83 ec 08             	sub    $0x8,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 84 30 80 00       	push   $0x803084
  800072:	e8 c9 17 00 00       	call   801840 <vcprintf>
  800077:	83 c4 10             	add    $0x10,%esp

	uint32 testCase;
	if (myEnv->page_WS_max_size == 1000)
  80007a:	a1 20 40 80 00       	mov    0x804020,%eax
  80007f:	8b 40 74             	mov    0x74(%eax),%eax
  800082:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  800087:	75 09                	jne    800092 <_main+0x5a>
	{
		//EVALUATION [40%]
		testCase = 1 ;
  800089:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800090:	eb 2a                	jmp    8000bc <_main+0x84>
	}
	else if (myEnv->page_WS_max_size == 10)
  800092:	a1 20 40 80 00       	mov    0x804020,%eax
  800097:	8b 40 74             	mov    0x74(%eax),%eax
  80009a:	83 f8 0a             	cmp    $0xa,%eax
  80009d:	75 09                	jne    8000a8 <_main+0x70>
	{
		//EVALUATION [30%]
		testCase = 2 ;
  80009f:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  8000a6:	eb 14                	jmp    8000bc <_main+0x84>
	}
	else if (myEnv->page_WS_max_size == 26)
  8000a8:	a1 20 40 80 00       	mov    0x804020,%eax
  8000ad:	8b 40 74             	mov    0x74(%eax),%eax
  8000b0:	83 f8 1a             	cmp    $0x1a,%eax
  8000b3:	75 07                	jne    8000bc <_main+0x84>
	{
		//EVALUATION [30%]
		testCase = 3 ;
  8000b5:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	}
	int32 envIdFib, envIdHelloWorld, helloWorldFrames;
	{
		//CASE1: free the exited env only
		//CASE3: free BOTH exited env's and WS
		if (testCase == 1 || testCase == 3)
  8000bc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8000c0:	74 0a                	je     8000cc <_main+0x94>
  8000c2:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8000c6:	0f 85 66 01 00 00    	jne    800232 <_main+0x1fa>
		{
			//Load "fib" & "fos_helloWorld" programs into RAM
			cprintf("Loading Fib & fos_helloWorld programs into RAM...");
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	68 c8 30 80 00       	push   $0x8030c8
  8000d4:	e8 d2 17 00 00       	call   8018ab <cprintf>
  8000d9:	83 c4 10             	add    $0x10,%esp
			envIdFib = sys_create_env("fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8000e1:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8000ec:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000f2:	89 c1                	mov    %eax,%ecx
  8000f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8000f9:	8b 40 74             	mov    0x74(%eax),%eax
  8000fc:	52                   	push   %edx
  8000fd:	51                   	push   %ecx
  8000fe:	50                   	push   %eax
  8000ff:	68 fa 30 80 00       	push   $0x8030fa
  800104:	e8 8a 28 00 00       	call   802993 <sys_create_env>
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int freeFrames = sys_calculate_free_frames() ;
  80010f:	e8 0d 26 00 00       	call   802721 <sys_calculate_free_frames>
  800114:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
			envIdHelloWorld = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80011a:	a1 20 40 80 00       	mov    0x804020,%eax
  80011f:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800125:	a1 20 40 80 00       	mov    0x804020,%eax
  80012a:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800130:	89 c1                	mov    %eax,%ecx
  800132:	a1 20 40 80 00       	mov    0x804020,%eax
  800137:	8b 40 74             	mov    0x74(%eax),%eax
  80013a:	52                   	push   %edx
  80013b:	51                   	push   %ecx
  80013c:	50                   	push   %eax
  80013d:	68 fe 30 80 00       	push   $0x8030fe
  800142:	e8 4c 28 00 00       	call   802993 <sys_create_env>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	89 45 dc             	mov    %eax,-0x24(%ebp)
			helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  80014d:	8b 9d 7c ff ff ff    	mov    -0x84(%ebp),%ebx
  800153:	e8 c9 25 00 00       	call   802721 <sys_calculate_free_frames>
  800158:	29 c3                	sub    %eax,%ebx
  80015a:	89 d8                	mov    %ebx,%eax
  80015c:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
			env_sleep(2000);
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 d0 07 00 00       	push   $0x7d0
  80016a:	e8 24 2b 00 00       	call   802c93 <env_sleep>
  80016f:	83 c4 10             	add    $0x10,%esp
			vcprintf("[DONE]\n\n", NULL);
  800172:	83 ec 08             	sub    $0x8,%esp
  800175:	6a 00                	push   $0x0
  800177:	68 0d 31 80 00       	push   $0x80310d
  80017c:	e8 bf 16 00 00       	call   801840 <vcprintf>
  800181:	83 c4 10             	add    $0x10,%esp

			//Load and run "fos_add"
			cprintf("Loading fos_add program into RAM...");
  800184:	83 ec 0c             	sub    $0xc,%esp
  800187:	68 18 31 80 00       	push   $0x803118
  80018c:	e8 1a 17 00 00       	call   8018ab <cprintf>
  800191:	83 c4 10             	add    $0x10,%esp
			int32 envIdFOSAdd= sys_create_env("fos_add", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800194:	a1 20 40 80 00       	mov    0x804020,%eax
  800199:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80019f:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a4:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8001aa:	89 c1                	mov    %eax,%ecx
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	8b 40 74             	mov    0x74(%eax),%eax
  8001b4:	52                   	push   %edx
  8001b5:	51                   	push   %ecx
  8001b6:	50                   	push   %eax
  8001b7:	68 3c 31 80 00       	push   $0x80313c
  8001bc:	e8 d2 27 00 00       	call   802993 <sys_create_env>
  8001c1:	83 c4 10             	add    $0x10,%esp
  8001c4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
			env_sleep(2000);
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 d0 07 00 00       	push   $0x7d0
  8001d2:	e8 bc 2a 00 00       	call   802c93 <env_sleep>
  8001d7:	83 c4 10             	add    $0x10,%esp
			vcprintf("[DONE]\n\n", NULL);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	6a 00                	push   $0x0
  8001df:	68 0d 31 80 00       	push   $0x80310d
  8001e4:	e8 57 16 00 00       	call   801840 <vcprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp

			cprintf("running fos_add program...\n\n");
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	68 44 31 80 00       	push   $0x803144
  8001f4:	e8 b2 16 00 00       	call   8018ab <cprintf>
  8001f9:	83 c4 10             	add    $0x10,%esp
			sys_run_env(envIdFOSAdd);
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	ff b5 74 ff ff ff    	pushl  -0x8c(%ebp)
  800205:	e8 a7 27 00 00       	call   8029b1 <sys_run_env>
  80020a:	83 c4 10             	add    $0x10,%esp

			cprintf("please be patient ...\n");
  80020d:	83 ec 0c             	sub    $0xc,%esp
  800210:	68 61 31 80 00       	push   $0x803161
  800215:	e8 91 16 00 00       	call   8018ab <cprintf>
  80021a:	83 c4 10             	add    $0x10,%esp
			env_sleep(5000);
  80021d:	83 ec 0c             	sub    $0xc,%esp
  800220:	68 88 13 00 00       	push   $0x1388
  800225:	e8 69 2a 00 00       	call   802c93 <env_sleep>
  80022a:	83 c4 10             	add    $0x10,%esp
	int32 envIdFib, envIdHelloWorld, helloWorldFrames;
	{
		//CASE1: free the exited env only
		//CASE3: free BOTH exited env's and WS
		if (testCase == 1 || testCase == 3)
		{
  80022d:	e9 4f 02 00 00       	jmp    800481 <_main+0x449>
				if( myEnv->page_last_WS_index !=  0)  										panic("InitialWSError2: INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
			}
		}
		 */
		//CASE2: free the WS ONLY using FIFO algorithm
		else if (testCase == 2)
  800232:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  800236:	0f 85 45 02 00 00    	jne    800481 <_main+0x449>
		{
			//("STEP 0: checking InitialWSError2: INITIAL WS entries ...\n");
			{
				if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x804000)  	panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80023c:	a1 20 40 80 00       	mov    0x804020,%eax
  800241:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800247:	8b 00                	mov    (%eax),%eax
  800249:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  80024c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80024f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800254:	3d 00 40 80 00       	cmp    $0x804000,%eax
  800259:	74 14                	je     80026f <_main+0x237>
  80025b:	83 ec 04             	sub    $0x4,%esp
  80025e:	68 78 31 80 00       	push   $0x803178
  800263:	6a 57                	push   $0x57
  800265:	68 ca 31 80 00       	push   $0x8031ca
  80026a:	e8 88 13 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80026f:	a1 20 40 80 00       	mov    0x804020,%eax
  800274:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80027a:	83 c0 18             	add    $0x18,%eax
  80027d:	8b 00                	mov    (%eax),%eax
  80027f:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800282:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800285:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80028a:	3d 00 10 20 00       	cmp    $0x201000,%eax
  80028f:	74 14                	je     8002a5 <_main+0x26d>
  800291:	83 ec 04             	sub    $0x4,%esp
  800294:	68 78 31 80 00       	push   $0x803178
  800299:	6a 58                	push   $0x58
  80029b:	68 ca 31 80 00       	push   $0x8031ca
  8002a0:	e8 52 13 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8002a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8002aa:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8002b0:	83 c0 30             	add    $0x30,%eax
  8002b3:	8b 00                	mov    (%eax),%eax
  8002b5:	89 45 9c             	mov    %eax,-0x64(%ebp)
  8002b8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002c0:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 78 31 80 00       	push   $0x803178
  8002cf:	6a 59                	push   $0x59
  8002d1:	68 ca 31 80 00       	push   $0x8031ca
  8002d6:	e8 1c 13 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8002db:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e0:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8002e6:	83 c0 48             	add    $0x48,%eax
  8002e9:	8b 00                	mov    (%eax),%eax
  8002eb:	89 45 98             	mov    %eax,-0x68(%ebp)
  8002ee:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002f6:	3d 00 30 20 00       	cmp    $0x203000,%eax
  8002fb:	74 14                	je     800311 <_main+0x2d9>
  8002fd:	83 ec 04             	sub    $0x4,%esp
  800300:	68 78 31 80 00       	push   $0x803178
  800305:	6a 5a                	push   $0x5a
  800307:	68 ca 31 80 00       	push   $0x8031ca
  80030c:	e8 e6 12 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800311:	a1 20 40 80 00       	mov    0x804020,%eax
  800316:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80031c:	83 c0 60             	add    $0x60,%eax
  80031f:	8b 00                	mov    (%eax),%eax
  800321:	89 45 94             	mov    %eax,-0x6c(%ebp)
  800324:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800327:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80032c:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800331:	74 14                	je     800347 <_main+0x30f>
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	68 78 31 80 00       	push   $0x803178
  80033b:	6a 5b                	push   $0x5b
  80033d:	68 ca 31 80 00       	push   $0x8031ca
  800342:	e8 b0 12 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800347:	a1 20 40 80 00       	mov    0x804020,%eax
  80034c:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800352:	83 c0 78             	add    $0x78,%eax
  800355:	8b 00                	mov    (%eax),%eax
  800357:	89 45 90             	mov    %eax,-0x70(%ebp)
  80035a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80035d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800362:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800367:	74 14                	je     80037d <_main+0x345>
  800369:	83 ec 04             	sub    $0x4,%esp
  80036c:	68 78 31 80 00       	push   $0x803178
  800371:	6a 5c                	push   $0x5c
  800373:	68 ca 31 80 00       	push   $0x8031ca
  800378:	e8 7a 12 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80037d:	a1 20 40 80 00       	mov    0x804020,%eax
  800382:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800388:	05 90 00 00 00       	add    $0x90,%eax
  80038d:	8b 00                	mov    (%eax),%eax
  80038f:	89 45 8c             	mov    %eax,-0x74(%ebp)
  800392:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800395:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80039a:	3d 00 00 80 00       	cmp    $0x800000,%eax
  80039f:	74 14                	je     8003b5 <_main+0x37d>
  8003a1:	83 ec 04             	sub    $0x4,%esp
  8003a4:	68 78 31 80 00       	push   $0x803178
  8003a9:	6a 5d                	push   $0x5d
  8003ab:	68 ca 31 80 00       	push   $0x8031ca
  8003b0:	e8 42 12 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8003b5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ba:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003c0:	05 a8 00 00 00       	add    $0xa8,%eax
  8003c5:	8b 00                	mov    (%eax),%eax
  8003c7:	89 45 88             	mov    %eax,-0x78(%ebp)
  8003ca:	8b 45 88             	mov    -0x78(%ebp),%eax
  8003cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d2:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8003d7:	74 14                	je     8003ed <_main+0x3b5>
  8003d9:	83 ec 04             	sub    $0x4,%esp
  8003dc:	68 78 31 80 00       	push   $0x803178
  8003e1:	6a 5e                	push   $0x5e
  8003e3:	68 ca 31 80 00       	push   $0x8031ca
  8003e8:	e8 0a 12 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8003ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f2:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8003f8:	05 c0 00 00 00       	add    $0xc0,%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	89 45 84             	mov    %eax,-0x7c(%ebp)
  800402:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800405:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040a:	3d 00 20 80 00       	cmp    $0x802000,%eax
  80040f:	74 14                	je     800425 <_main+0x3ed>
  800411:	83 ec 04             	sub    $0x4,%esp
  800414:	68 78 31 80 00       	push   $0x803178
  800419:	6a 5f                	push   $0x5f
  80041b:	68 ca 31 80 00       	push   $0x8031ca
  800420:	e8 d2 11 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800425:	a1 20 40 80 00       	mov    0x804020,%eax
  80042a:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800430:	05 d8 00 00 00       	add    $0xd8,%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	89 45 80             	mov    %eax,-0x80(%ebp)
  80043a:	8b 45 80             	mov    -0x80(%ebp),%eax
  80043d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800442:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800447:	74 14                	je     80045d <_main+0x425>
  800449:	83 ec 04             	sub    $0x4,%esp
  80044c:	68 78 31 80 00       	push   $0x803178
  800451:	6a 60                	push   $0x60
  800453:	68 ca 31 80 00       	push   $0x8031ca
  800458:	e8 9a 11 00 00       	call   8015f7 <_panic>
				if( myEnv->page_last_WS_index !=  1)  										panic("InitialWSError2: INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  80045d:	a1 20 40 80 00       	mov    0x804020,%eax
  800462:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  800468:	83 f8 01             	cmp    $0x1,%eax
  80046b:	74 14                	je     800481 <_main+0x449>
  80046d:	83 ec 04             	sub    $0x4,%esp
  800470:	68 e0 31 80 00       	push   $0x8031e0
  800475:	6a 61                	push   $0x61
  800477:	68 ca 31 80 00       	push   $0x8031ca
  80047c:	e8 76 11 00 00       	call   8015f7 <_panic>
			}
		}

		//Reading (Not Modified)
		char garbage1 = arr[PAGE_SIZE*10-1] ;
  800481:	a0 5f e0 80 00       	mov    0x80e05f,%al
  800486:	88 85 73 ff ff ff    	mov    %al,-0x8d(%ebp)
		char garbage2 = arr[PAGE_SIZE*11-1] ;
  80048c:	a0 5f f0 80 00       	mov    0x80f05f,%al
  800491:	88 85 72 ff ff ff    	mov    %al,-0x8e(%ebp)
		char garbage3 = arr[PAGE_SIZE*12-1] ;
  800497:	a0 5f 00 81 00       	mov    0x81005f,%al
  80049c:	88 85 71 ff ff ff    	mov    %al,-0x8f(%ebp)

		char garbage4, garbage5 ;
		//Writing (Modified)
		int i ;
		for (i = 0 ; i < PAGE_SIZE*4 ; i+=PAGE_SIZE/2)
  8004a2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  8004a9:	eb 26                	jmp    8004d1 <_main+0x499>
		{
			arr[i] = -1 ;
  8004ab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004ae:	05 60 40 80 00       	add    $0x804060,%eax
  8004b3:	c6 00 ff             	movb   $0xff,(%eax)
			//always use pages at 0x801000 and 0x804000
			garbage4 = *ptr ;
  8004b6:	a1 00 40 80 00       	mov    0x804000,%eax
  8004bb:	8a 00                	mov    (%eax),%al
  8004bd:	88 45 db             	mov    %al,-0x25(%ebp)
			garbage5 = *ptr2 ;
  8004c0:	a1 04 40 80 00       	mov    0x804004,%eax
  8004c5:	8a 00                	mov    (%eax),%al
  8004c7:	88 45 da             	mov    %al,-0x26(%ebp)
		char garbage3 = arr[PAGE_SIZE*12-1] ;

		char garbage4, garbage5 ;
		//Writing (Modified)
		int i ;
		for (i = 0 ; i < PAGE_SIZE*4 ; i+=PAGE_SIZE/2)
  8004ca:	81 45 d4 00 08 00 00 	addl   $0x800,-0x2c(%ebp)
  8004d1:	81 7d d4 ff 3f 00 00 	cmpl   $0x3fff,-0x2c(%ebp)
  8004d8:	7e d1                	jle    8004ab <_main+0x473>

		//===================

		//CASE1: free the exited env only
		//CASE3: free BOTH exited env's and WS
		if (testCase == 1 || testCase == 3)
  8004da:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8004de:	74 0a                	je     8004ea <_main+0x4b2>
  8004e0:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8004e4:	0f 85 92 00 00 00    	jne    80057c <_main+0x544>
		{
			int i = 0;
  8004ea:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
			numOfExistPages = 0;
  8004f1:	c7 05 20 01 81 00 00 	movl   $0x0,0x810120
  8004f8:	00 00 00 
			for (i = 0; i < myEnv->page_WS_max_size; ++i)
  8004fb:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800502:	eb 64                	jmp    800568 <_main+0x530>
			{
				if (!myEnv->__uptr_pws[i].empty)
  800504:	a1 20 40 80 00       	mov    0x804020,%eax
  800509:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80050f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800512:	89 d0                	mov    %edx,%eax
  800514:	01 c0                	add    %eax,%eax
  800516:	01 d0                	add    %edx,%eax
  800518:	c1 e0 03             	shl    $0x3,%eax
  80051b:	01 c8                	add    %ecx,%eax
  80051d:	8a 40 04             	mov    0x4(%eax),%al
  800520:	84 c0                	test   %al,%al
  800522:	75 41                	jne    800565 <_main+0x52d>
				{
					WSEntries_before[numOfExistPages++] = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address, PAGE_SIZE);
  800524:	8b 15 20 01 81 00    	mov    0x810120,%edx
  80052a:	8d 42 01             	lea    0x1(%edx),%eax
  80052d:	a3 20 01 81 00       	mov    %eax,0x810120
  800532:	a1 20 40 80 00       	mov    0x804020,%eax
  800537:	8b 98 9c 05 00 00    	mov    0x59c(%eax),%ebx
  80053d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800540:	89 c8                	mov    %ecx,%eax
  800542:	01 c0                	add    %eax,%eax
  800544:	01 c8                	add    %ecx,%eax
  800546:	c1 e0 03             	shl    $0x3,%eax
  800549:	01 d8                	add    %ebx,%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  800553:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800559:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80055e:	89 04 95 60 01 81 00 	mov    %eax,0x810160(,%edx,4)
		//CASE3: free BOTH exited env's and WS
		if (testCase == 1 || testCase == 3)
		{
			int i = 0;
			numOfExistPages = 0;
			for (i = 0; i < myEnv->page_WS_max_size; ++i)
  800565:	ff 45 d0             	incl   -0x30(%ebp)
  800568:	a1 20 40 80 00       	mov    0x804020,%eax
  80056d:	8b 50 74             	mov    0x74(%eax),%edx
  800570:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800573:	39 c2                	cmp    %eax,%edx
  800575:	77 8d                	ja     800504 <_main+0x4cc>
		//===================

		//CASE1: free the exited env only
		//CASE3: free BOTH exited env's and WS
		if (testCase == 1 || testCase == 3)
		{
  800577:	e9 ac 02 00 00       	jmp    800828 <_main+0x7f0>
				if(myEnv->page_last_WS_index != 9) panic("wrong PAGE WS pointer location");
			}
		}
		 */
		//CASE2: free the WS ONLY using FIFO algorithm
		else if (testCase == 2)
  80057c:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  800580:	0f 85 a2 02 00 00    	jne    800828 <_main+0x7f0>
		{
			//cprintf("Checking PAGE FIFO algorithm... \n");
			{
				if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=  0x804000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800586:	a1 20 40 80 00       	mov    0x804020,%eax
  80058b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800591:	8b 00                	mov    (%eax),%eax
  800593:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800599:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  80059f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005a4:	3d 00 40 80 00       	cmp    $0x804000,%eax
  8005a9:	74 17                	je     8005c2 <_main+0x58a>
  8005ab:	83 ec 04             	sub    $0x4,%esp
  8005ae:	68 38 32 80 00       	push   $0x803238
  8005b3:	68 9e 00 00 00       	push   $0x9e
  8005b8:	68 ca 31 80 00       	push   $0x8031ca
  8005bd:	e8 35 10 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=  0x80e000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8005c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8005c7:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8005cd:	83 c0 18             	add    $0x18,%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  8005d8:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8005de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e3:	3d 00 e0 80 00       	cmp    $0x80e000,%eax
  8005e8:	74 17                	je     800601 <_main+0x5c9>
  8005ea:	83 ec 04             	sub    $0x4,%esp
  8005ed:	68 38 32 80 00       	push   $0x803238
  8005f2:	68 9f 00 00 00       	push   $0x9f
  8005f7:	68 ca 31 80 00       	push   $0x8031ca
  8005fc:	e8 f6 0f 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=  0x80f000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800601:	a1 20 40 80 00       	mov    0x804020,%eax
  800606:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80060c:	83 c0 30             	add    $0x30,%eax
  80060f:	8b 00                	mov    (%eax),%eax
  800611:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  800617:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80061d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800622:	3d 00 f0 80 00       	cmp    $0x80f000,%eax
  800627:	74 17                	je     800640 <_main+0x608>
  800629:	83 ec 04             	sub    $0x4,%esp
  80062c:	68 38 32 80 00       	push   $0x803238
  800631:	68 a0 00 00 00       	push   $0xa0
  800636:	68 ca 31 80 00       	push   $0x8031ca
  80063b:	e8 b7 0f 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=  0x810000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  800640:	a1 20 40 80 00       	mov    0x804020,%eax
  800645:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80064b:	83 c0 48             	add    $0x48,%eax
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800656:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80065c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800661:	3d 00 00 81 00       	cmp    $0x810000,%eax
  800666:	74 17                	je     80067f <_main+0x647>
  800668:	83 ec 04             	sub    $0x4,%esp
  80066b:	68 38 32 80 00       	push   $0x803238
  800670:	68 a1 00 00 00       	push   $0xa1
  800675:	68 ca 31 80 00       	push   $0x8031ca
  80067a:	e8 78 0f 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=  0x805000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80067f:	a1 20 40 80 00       	mov    0x804020,%eax
  800684:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80068a:	83 c0 60             	add    $0x60,%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800695:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80069b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006a0:	3d 00 50 80 00       	cmp    $0x805000,%eax
  8006a5:	74 17                	je     8006be <_main+0x686>
  8006a7:	83 ec 04             	sub    $0x4,%esp
  8006aa:	68 38 32 80 00       	push   $0x803238
  8006af:	68 a2 00 00 00       	push   $0xa2
  8006b4:	68 ca 31 80 00       	push   $0x8031ca
  8006b9:	e8 39 0f 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=  0x806000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8006be:	a1 20 40 80 00       	mov    0x804020,%eax
  8006c3:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8006c9:	83 c0 78             	add    $0x78,%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  8006d4:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8006da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006df:	3d 00 60 80 00       	cmp    $0x806000,%eax
  8006e4:	74 17                	je     8006fd <_main+0x6c5>
  8006e6:	83 ec 04             	sub    $0x4,%esp
  8006e9:	68 38 32 80 00       	push   $0x803238
  8006ee:	68 a3 00 00 00       	push   $0xa3
  8006f3:	68 ca 31 80 00       	push   $0x8031ca
  8006f8:	e8 fa 0e 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=  0x807000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8006fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800702:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800708:	05 90 00 00 00       	add    $0x90,%eax
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800715:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  80071b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800720:	3d 00 70 80 00       	cmp    $0x807000,%eax
  800725:	74 17                	je     80073e <_main+0x706>
  800727:	83 ec 04             	sub    $0x4,%esp
  80072a:	68 38 32 80 00       	push   $0x803238
  80072f:	68 a4 00 00 00       	push   $0xa4
  800734:	68 ca 31 80 00       	push   $0x8031ca
  800739:	e8 b9 0e 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=  0x800000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80073e:	a1 20 40 80 00       	mov    0x804020,%eax
  800743:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800749:	05 a8 00 00 00       	add    $0xa8,%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800756:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  80075c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800761:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800766:	74 17                	je     80077f <_main+0x747>
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 38 32 80 00       	push   $0x803238
  800770:	68 a5 00 00 00       	push   $0xa5
  800775:	68 ca 31 80 00       	push   $0x8031ca
  80077a:	e8 78 0e 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=  0x801000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  80077f:	a1 20 40 80 00       	mov    0x804020,%eax
  800784:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80078a:	05 c0 00 00 00       	add    $0xc0,%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800797:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  80079d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007a2:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8007a7:	74 17                	je     8007c0 <_main+0x788>
  8007a9:	83 ec 04             	sub    $0x4,%esp
  8007ac:	68 38 32 80 00       	push   $0x803238
  8007b1:	68 a6 00 00 00       	push   $0xa6
  8007b6:	68 ca 31 80 00       	push   $0x8031ca
  8007bb:	e8 37 0e 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=  0xeebfd000)  panic("Page FIFO algo failed.. trace it by printing WS before and after page fault");
  8007c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8007c5:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8007cb:	05 d8 00 00 00       	add    $0xd8,%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  8007d8:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  8007de:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007e3:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  8007e8:	74 17                	je     800801 <_main+0x7c9>
  8007ea:	83 ec 04             	sub    $0x4,%esp
  8007ed:	68 38 32 80 00       	push   $0x803238
  8007f2:	68 a7 00 00 00       	push   $0xa7
  8007f7:	68 ca 31 80 00       	push   $0x8031ca
  8007fc:	e8 f6 0d 00 00       	call   8015f7 <_panic>

				if(myEnv->page_last_WS_index != 9) panic("wrong PAGE WS pointer location");
  800801:	a1 20 40 80 00       	mov    0x804020,%eax
  800806:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  80080c:	83 f8 09             	cmp    $0x9,%eax
  80080f:	74 17                	je     800828 <_main+0x7f0>
  800811:	83 ec 04             	sub    $0x4,%esp
  800814:	68 84 32 80 00       	push   $0x803284
  800819:	68 a9 00 00 00       	push   $0xa9
  80081e:	68 ca 31 80 00       	push   $0x8031ca
  800823:	e8 cf 0d 00 00       	call   8015f7 <_panic>
			}
		}

		//=========================================================//
		//Clear the FFL
		sys_clear_ffl();
  800828:	e8 3b 20 00 00       	call   802868 <sys_clear_ffl>
		//=========================================================//

		//Writing (Modified) after freeing the entire FFL:
		//	3 frames should be allocated (stack page, mem table, page file table)
		*ptr3 = garbage1 ;
  80082d:	a1 08 40 80 00       	mov    0x804008,%eax
  800832:	8a 95 73 ff ff ff    	mov    -0x8d(%ebp),%dl
  800838:	88 10                	mov    %dl,(%eax)
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr ;
  80083a:	a1 00 40 80 00       	mov    0x804000,%eax
  80083f:	8a 00                	mov    (%eax),%al
  800841:	88 45 db             	mov    %al,-0x25(%ebp)
		garbage5 = *ptr2 ;
  800844:	a1 04 40 80 00       	mov    0x804004,%eax
  800849:	8a 00                	mov    (%eax),%al
  80084b:	88 45 da             	mov    %al,-0x26(%ebp)

		//CASE1: free the exited env's ONLY
		//CASE3: free BOTH exited env's and WS
		if (testCase == 1 || testCase == 3)
  80084e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800852:	74 0a                	je     80085e <_main+0x826>
  800854:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  800858:	0f 85 99 00 00 00    	jne    8008f7 <_main+0x8bf>
		{
			//Add the last reference to our WS
			WSEntries_before[numOfExistPages++] = ROUNDDOWN((uint32)(ptr3), PAGE_SIZE);
  80085e:	a1 20 01 81 00       	mov    0x810120,%eax
  800863:	8d 50 01             	lea    0x1(%eax),%edx
  800866:	89 15 20 01 81 00    	mov    %edx,0x810120
  80086c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  800872:	89 95 3c ff ff ff    	mov    %edx,-0xc4(%ebp)
  800878:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  80087e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  800884:	89 14 85 60 01 81 00 	mov    %edx,0x810160(,%eax,4)

			//Make sure that WS is not affected
			for (i = 0; i < numOfExistPages; ++i)
  80088b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800892:	eb 54                	jmp    8008e8 <_main+0x8b0>
			{
				if (WSEntries_before[i] != ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address, PAGE_SIZE))
  800894:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800897:	8b 0c 85 60 01 81 00 	mov    0x810160(,%eax,4),%ecx
  80089e:	a1 20 40 80 00       	mov    0x804020,%eax
  8008a3:	8b 98 9c 05 00 00    	mov    0x59c(%eax),%ebx
  8008a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8008ac:	89 d0                	mov    %edx,%eax
  8008ae:	01 c0                	add    %eax,%eax
  8008b0:	01 d0                	add    %edx,%eax
  8008b2:	c1 e0 03             	shl    $0x3,%eax
  8008b5:	01 d8                	add    %ebx,%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  8008bf:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  8008c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008ca:	39 c1                	cmp    %eax,%ecx
  8008cc:	74 17                	je     8008e5 <_main+0x8ad>
					panic("FreeRAM.Scenario1 or 3: WS is changed while not expected to!");
  8008ce:	83 ec 04             	sub    $0x4,%esp
  8008d1:	68 a4 32 80 00       	push   $0x8032a4
  8008d6:	68 c4 00 00 00       	push   $0xc4
  8008db:	68 ca 31 80 00       	push   $0x8031ca
  8008e0:	e8 12 0d 00 00       	call   8015f7 <_panic>
		{
			//Add the last reference to our WS
			WSEntries_before[numOfExistPages++] = ROUNDDOWN((uint32)(ptr3), PAGE_SIZE);

			//Make sure that WS is not affected
			for (i = 0; i < numOfExistPages; ++i)
  8008e5:	ff 45 d4             	incl   -0x2c(%ebp)
  8008e8:	a1 20 01 81 00       	mov    0x810120,%eax
  8008ed:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
  8008f0:	7c a2                	jl     800894 <_main+0x85c>
		garbage4 = *ptr ;
		garbage5 = *ptr2 ;

		//CASE1: free the exited env's ONLY
		//CASE3: free BOTH exited env's and WS
		if (testCase == 1 || testCase == 3)
  8008f2:	e9 45 01 00 00       	jmp    800a3c <_main+0xa04>
				if (WSEntries_before[i] != ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address, PAGE_SIZE))
					panic("FreeRAM.Scenario1 or 3: WS is changed while not expected to!");
			}
		}
		//Case2: free the WS ONLY by clock algorithm
		else if (testCase == 2)
  8008f7:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  8008fb:	0f 85 3b 01 00 00    	jne    800a3c <_main+0xa04>
			}
			 */

			//Check the WS after FIFO algorithm

			if (garbage4 != *ptr || garbage5 != *ptr2) panic("test failed!");
  800901:	a1 00 40 80 00       	mov    0x804000,%eax
  800906:	8a 00                	mov    (%eax),%al
  800908:	3a 45 db             	cmp    -0x25(%ebp),%al
  80090b:	75 0c                	jne    800919 <_main+0x8e1>
  80090d:	a1 04 40 80 00       	mov    0x804004,%eax
  800912:	8a 00                	mov    (%eax),%al
  800914:	3a 45 da             	cmp    -0x26(%ebp),%al
  800917:	74 17                	je     800930 <_main+0x8f8>
  800919:	83 ec 04             	sub    $0x4,%esp
  80091c:	68 e1 32 80 00       	push   $0x8032e1
  800921:	68 d7 00 00 00       	push   $0xd7
  800926:	68 ca 31 80 00       	push   $0x8031ca
  80092b:	e8 c7 0c 00 00       	call   8015f7 <_panic>

			//There should be two empty locations that are freed for the two tables (mem table and page file table)
			int numOfEmptyLocs = 0 ;
  800930:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
			for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  800937:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80093e:	eb 26                	jmp    800966 <_main+0x92e>
			{
				if (myEnv->__uptr_pws[i].empty)
  800940:	a1 20 40 80 00       	mov    0x804020,%eax
  800945:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80094b:	8b 55 c8             	mov    -0x38(%ebp),%edx
  80094e:	89 d0                	mov    %edx,%eax
  800950:	01 c0                	add    %eax,%eax
  800952:	01 d0                	add    %edx,%eax
  800954:	c1 e0 03             	shl    $0x3,%eax
  800957:	01 c8                	add    %ecx,%eax
  800959:	8a 40 04             	mov    0x4(%eax),%al
  80095c:	84 c0                	test   %al,%al
  80095e:	74 03                	je     800963 <_main+0x92b>
					numOfEmptyLocs++ ;
  800960:	ff 45 cc             	incl   -0x34(%ebp)

			if (garbage4 != *ptr || garbage5 != *ptr2) panic("test failed!");

			//There should be two empty locations that are freed for the two tables (mem table and page file table)
			int numOfEmptyLocs = 0 ;
			for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  800963:	ff 45 c8             	incl   -0x38(%ebp)
  800966:	a1 20 40 80 00       	mov    0x804020,%eax
  80096b:	8b 50 74             	mov    0x74(%eax),%edx
  80096e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800971:	39 c2                	cmp    %eax,%edx
  800973:	77 cb                	ja     800940 <_main+0x908>
			{
				if (myEnv->__uptr_pws[i].empty)
					numOfEmptyLocs++ ;
			}
			if (numOfEmptyLocs != 2) panic("test failed! either wrong victim or victim is not removed from WS");
  800975:	83 7d cc 02          	cmpl   $0x2,-0x34(%ebp)
  800979:	74 17                	je     800992 <_main+0x95a>
  80097b:	83 ec 04             	sub    $0x4,%esp
  80097e:	68 f0 32 80 00       	push   $0x8032f0
  800983:	68 e0 00 00 00       	push   $0xe0
  800988:	68 ca 31 80 00       	push   $0x8031ca
  80098d:	e8 65 0c 00 00       	call   8015f7 <_panic>

			uint32 expectedAddresses[8] = {0x800000,0x801000,0x802000,0x803000,0x804000,0x807000,0xee7fe000,0xeebfd000} ;
  800992:	8d 85 6c fe ff ff    	lea    -0x194(%ebp),%eax
  800998:	bb 00 34 80 00       	mov    $0x803400,%ebx
  80099d:	ba 08 00 00 00       	mov    $0x8,%edx
  8009a2:	89 c7                	mov    %eax,%edi
  8009a4:	89 de                	mov    %ebx,%esi
  8009a6:	89 d1                	mov    %edx,%ecx
  8009a8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			int numOfFoundedAddresses = 0;
  8009aa:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for (int j = 0; j < 8; j++)
  8009b1:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8009b8:	eb 5f                	jmp    800a19 <_main+0x9e1>
			{
				for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  8009ba:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  8009c1:	eb 44                	jmp    800a07 <_main+0x9cf>
				{
					if (ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == expectedAddresses[j])
  8009c3:	a1 20 40 80 00       	mov    0x804020,%eax
  8009c8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009ce:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8009d1:	89 d0                	mov    %edx,%eax
  8009d3:	01 c0                	add    %eax,%eax
  8009d5:	01 d0                	add    %edx,%eax
  8009d7:	c1 e0 03             	shl    $0x3,%eax
  8009da:	01 c8                	add    %ecx,%eax
  8009dc:	8b 00                	mov    (%eax),%eax
  8009de:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  8009e4:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  8009ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009ef:	89 c2                	mov    %eax,%edx
  8009f1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8009f4:	8b 84 85 6c fe ff ff 	mov    -0x194(%ebp,%eax,4),%eax
  8009fb:	39 c2                	cmp    %eax,%edx
  8009fd:	75 05                	jne    800a04 <_main+0x9cc>
					{
						numOfFoundedAddresses++;
  8009ff:	ff 45 c4             	incl   -0x3c(%ebp)
						break;
  800a02:	eb 12                	jmp    800a16 <_main+0x9de>

			uint32 expectedAddresses[8] = {0x800000,0x801000,0x802000,0x803000,0x804000,0x807000,0xee7fe000,0xeebfd000} ;
			int numOfFoundedAddresses = 0;
			for (int j = 0; j < 8; j++)
			{
				for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  800a04:	ff 45 bc             	incl   -0x44(%ebp)
  800a07:	a1 20 40 80 00       	mov    0x804020,%eax
  800a0c:	8b 50 74             	mov    0x74(%eax),%edx
  800a0f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800a12:	39 c2                	cmp    %eax,%edx
  800a14:	77 ad                	ja     8009c3 <_main+0x98b>
			}
			if (numOfEmptyLocs != 2) panic("test failed! either wrong victim or victim is not removed from WS");

			uint32 expectedAddresses[8] = {0x800000,0x801000,0x802000,0x803000,0x804000,0x807000,0xee7fe000,0xeebfd000} ;
			int numOfFoundedAddresses = 0;
			for (int j = 0; j < 8; j++)
  800a16:	ff 45 c0             	incl   -0x40(%ebp)
  800a19:	83 7d c0 07          	cmpl   $0x7,-0x40(%ebp)
  800a1d:	7e 9b                	jle    8009ba <_main+0x982>
						numOfFoundedAddresses++;
						break;
					}
				}
			}
			if (numOfFoundedAddresses != 8) panic("test failed! either wrong victim or victim is not removed from WS");
  800a1f:	83 7d c4 08          	cmpl   $0x8,-0x3c(%ebp)
  800a23:	74 17                	je     800a3c <_main+0xa04>
  800a25:	83 ec 04             	sub    $0x4,%esp
  800a28:	68 f0 32 80 00       	push   $0x8032f0
  800a2d:	68 ef 00 00 00       	push   $0xef
  800a32:	68 ca 31 80 00       	push   $0x8031ca
  800a37:	e8 bb 0b 00 00       	call   8015f7 <_panic>

		}


		//Case1: free the exited env's ONLY
		if (testCase ==1)
  800a3c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800a40:	0f 85 81 00 00 00    	jne    800ac7 <_main+0xa8f>
		{
			cprintf("running fos_helloWorld program...\n\n");
  800a46:	83 ec 0c             	sub    $0xc,%esp
  800a49:	68 34 33 80 00       	push   $0x803334
  800a4e:	e8 58 0e 00 00       	call   8018ab <cprintf>
  800a53:	83 c4 10             	add    $0x10,%esp
			sys_run_env(envIdHelloWorld);
  800a56:	83 ec 0c             	sub    $0xc,%esp
  800a59:	ff 75 dc             	pushl  -0x24(%ebp)
  800a5c:	e8 50 1f 00 00       	call   8029b1 <sys_run_env>
  800a61:	83 c4 10             	add    $0x10,%esp
			cprintf("please be patient ...\n");
  800a64:	83 ec 0c             	sub    $0xc,%esp
  800a67:	68 61 31 80 00       	push   $0x803161
  800a6c:	e8 3a 0e 00 00       	call   8018ab <cprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
			env_sleep(3000);
  800a74:	83 ec 0c             	sub    $0xc,%esp
  800a77:	68 b8 0b 00 00       	push   $0xbb8
  800a7c:	e8 12 22 00 00       	call   802c93 <env_sleep>
  800a81:	83 c4 10             	add    $0x10,%esp

			cprintf("running fos_fib program...\n\n");
  800a84:	83 ec 0c             	sub    $0xc,%esp
  800a87:	68 58 33 80 00       	push   $0x803358
  800a8c:	e8 1a 0e 00 00       	call   8018ab <cprintf>
  800a91:	83 c4 10             	add    $0x10,%esp
			sys_run_env(envIdFib);
  800a94:	83 ec 0c             	sub    $0xc,%esp
  800a97:	ff 75 e0             	pushl  -0x20(%ebp)
  800a9a:	e8 12 1f 00 00       	call   8029b1 <sys_run_env>
  800a9f:	83 c4 10             	add    $0x10,%esp
			cprintf("please be patient ...\n");
  800aa2:	83 ec 0c             	sub    $0xc,%esp
  800aa5:	68 61 31 80 00       	push   $0x803161
  800aaa:	e8 fc 0d 00 00       	call   8018ab <cprintf>
  800aaf:	83 c4 10             	add    $0x10,%esp
			env_sleep(5000);
  800ab2:	83 ec 0c             	sub    $0xc,%esp
  800ab5:	68 88 13 00 00       	push   $0x1388
  800aba:	e8 d4 21 00 00       	call   802c93 <env_sleep>
  800abf:	83 c4 10             	add    $0x10,%esp
  800ac2:	e9 60 08 00 00       	jmp    801327 <_main+0x12ef>
		}
		//CASE3: free BOTH exited env's and WS
		else if (testCase ==3)
  800ac7:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  800acb:	0f 85 56 08 00 00    	jne    801327 <_main+0x12ef>
				if( ROUNDDOWN(myEnv->__uptr_pws[24].virtual_address,PAGE_SIZE) !=   0xee7fe000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
				if( myEnv->page_last_WS_index !=  0)  										panic("InitialWSError2: INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
			}
			 */

			cprintf("Checking PAGE FIFO algorithm... \n");
  800ad1:	83 ec 0c             	sub    $0xc,%esp
  800ad4:	68 78 33 80 00       	push   $0x803378
  800ad9:	e8 cd 0d 00 00       	call   8018ab <cprintf>
  800ade:	83 c4 10             	add    $0x10,%esp
			{
				if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800ae1:	a1 20 40 80 00       	mov    0x804020,%eax
  800ae6:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800aec:	8b 00                	mov    (%eax),%eax
  800aee:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800af4:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800afa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800aff:	3d 00 00 20 00       	cmp    $0x200000,%eax
  800b04:	74 17                	je     800b1d <_main+0xae5>
  800b06:	83 ec 04             	sub    $0x4,%esp
  800b09:	68 78 31 80 00       	push   $0x803178
  800b0e:	68 25 01 00 00       	push   $0x125
  800b13:	68 ca 31 80 00       	push   $0x8031ca
  800b18:	e8 da 0a 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800b1d:	a1 20 40 80 00       	mov    0x804020,%eax
  800b22:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800b28:	83 c0 18             	add    $0x18,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  800b33:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800b39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b3e:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800b43:	74 17                	je     800b5c <_main+0xb24>
  800b45:	83 ec 04             	sub    $0x4,%esp
  800b48:	68 78 31 80 00       	push   $0x803178
  800b4d:	68 26 01 00 00       	push   $0x126
  800b52:	68 ca 31 80 00       	push   $0x8031ca
  800b57:	e8 9b 0a 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800b5c:	a1 20 40 80 00       	mov    0x804020,%eax
  800b61:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800b67:	83 c0 30             	add    $0x30,%eax
  800b6a:	8b 00                	mov    (%eax),%eax
  800b6c:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  800b72:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800b78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b7d:	3d 00 20 20 00       	cmp    $0x202000,%eax
  800b82:	74 17                	je     800b9b <_main+0xb63>
  800b84:	83 ec 04             	sub    $0x4,%esp
  800b87:	68 78 31 80 00       	push   $0x803178
  800b8c:	68 27 01 00 00       	push   $0x127
  800b91:	68 ca 31 80 00       	push   $0x8031ca
  800b96:	e8 5c 0a 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800b9b:	a1 20 40 80 00       	mov    0x804020,%eax
  800ba0:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800ba6:	83 c0 48             	add    $0x48,%eax
  800ba9:	8b 00                	mov    (%eax),%eax
  800bab:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  800bb1:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800bb7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bbc:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800bc1:	74 17                	je     800bda <_main+0xba2>
  800bc3:	83 ec 04             	sub    $0x4,%esp
  800bc6:	68 78 31 80 00       	push   $0x803178
  800bcb:	68 28 01 00 00       	push   $0x128
  800bd0:	68 ca 31 80 00       	push   $0x8031ca
  800bd5:	e8 1d 0a 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800bda:	a1 20 40 80 00       	mov    0x804020,%eax
  800bdf:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800be5:	83 c0 60             	add    $0x60,%eax
  800be8:	8b 00                	mov    (%eax),%eax
  800bea:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  800bf0:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  800bf6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bfb:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800c00:	74 17                	je     800c19 <_main+0xbe1>
  800c02:	83 ec 04             	sub    $0x4,%esp
  800c05:	68 78 31 80 00       	push   $0x803178
  800c0a:	68 29 01 00 00       	push   $0x129
  800c0f:	68 ca 31 80 00       	push   $0x8031ca
  800c14:	e8 de 09 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800c19:	a1 20 40 80 00       	mov    0x804020,%eax
  800c1e:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800c24:	83 c0 78             	add    $0x78,%eax
  800c27:	8b 00                	mov    (%eax),%eax
  800c29:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  800c2f:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800c35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c3a:	3d 00 50 20 00       	cmp    $0x205000,%eax
  800c3f:	74 17                	je     800c58 <_main+0xc20>
  800c41:	83 ec 04             	sub    $0x4,%esp
  800c44:	68 78 31 80 00       	push   $0x803178
  800c49:	68 2a 01 00 00       	push   $0x12a
  800c4e:	68 ca 31 80 00       	push   $0x8031ca
  800c53:	e8 9f 09 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800c58:	a1 20 40 80 00       	mov    0x804020,%eax
  800c5d:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800c63:	05 90 00 00 00       	add    $0x90,%eax
  800c68:	8b 00                	mov    (%eax),%eax
  800c6a:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  800c70:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800c76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800c7b:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800c80:	74 17                	je     800c99 <_main+0xc61>
  800c82:	83 ec 04             	sub    $0x4,%esp
  800c85:	68 78 31 80 00       	push   $0x803178
  800c8a:	68 2b 01 00 00       	push   $0x12b
  800c8f:	68 ca 31 80 00       	push   $0x8031ca
  800c94:	e8 5e 09 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800c99:	a1 20 40 80 00       	mov    0x804020,%eax
  800c9e:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800ca4:	05 a8 00 00 00       	add    $0xa8,%eax
  800ca9:	8b 00                	mov    (%eax),%eax
  800cab:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  800cb1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800cb7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800cbc:	3d 00 10 80 00       	cmp    $0x801000,%eax
  800cc1:	74 17                	je     800cda <_main+0xca2>
  800cc3:	83 ec 04             	sub    $0x4,%esp
  800cc6:	68 78 31 80 00       	push   $0x803178
  800ccb:	68 2c 01 00 00       	push   $0x12c
  800cd0:	68 ca 31 80 00       	push   $0x8031ca
  800cd5:	e8 1d 09 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800cda:	a1 20 40 80 00       	mov    0x804020,%eax
  800cdf:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800ce5:	05 c0 00 00 00       	add    $0xc0,%eax
  800cea:	8b 00                	mov    (%eax),%eax
  800cec:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  800cf2:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  800cf8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800cfd:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800d02:	74 17                	je     800d1b <_main+0xce3>
  800d04:	83 ec 04             	sub    $0x4,%esp
  800d07:	68 78 31 80 00       	push   $0x803178
  800d0c:	68 2d 01 00 00       	push   $0x12d
  800d11:	68 ca 31 80 00       	push   $0x8031ca
  800d16:	e8 dc 08 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800d1b:	a1 20 40 80 00       	mov    0x804020,%eax
  800d20:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800d26:	05 d8 00 00 00       	add    $0xd8,%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
  800d33:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800d39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d3e:	3d 00 30 80 00       	cmp    $0x803000,%eax
  800d43:	74 17                	je     800d5c <_main+0xd24>
  800d45:	83 ec 04             	sub    $0x4,%esp
  800d48:	68 78 31 80 00       	push   $0x803178
  800d4d:	68 2e 01 00 00       	push   $0x12e
  800d52:	68 ca 31 80 00       	push   $0x8031ca
  800d57:	e8 9b 08 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x804000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800d5c:	a1 20 40 80 00       	mov    0x804020,%eax
  800d61:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800d67:	05 f0 00 00 00       	add    $0xf0,%eax
  800d6c:	8b 00                	mov    (%eax),%eax
  800d6e:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
  800d74:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  800d7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d7f:	3d 00 40 80 00       	cmp    $0x804000,%eax
  800d84:	74 17                	je     800d9d <_main+0xd65>
  800d86:	83 ec 04             	sub    $0x4,%esp
  800d89:	68 78 31 80 00       	push   $0x803178
  800d8e:	68 2f 01 00 00       	push   $0x12f
  800d93:	68 ca 31 80 00       	push   $0x8031ca
  800d98:	e8 5a 08 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0x805000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800d9d:	a1 20 40 80 00       	mov    0x804020,%eax
  800da2:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800da8:	05 08 01 00 00       	add    $0x108,%eax
  800dad:	8b 00                	mov    (%eax),%eax
  800daf:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  800db5:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  800dbb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dc0:	3d 00 50 80 00       	cmp    $0x805000,%eax
  800dc5:	74 17                	je     800dde <_main+0xda6>
  800dc7:	83 ec 04             	sub    $0x4,%esp
  800dca:	68 78 31 80 00       	push   $0x803178
  800dcf:	68 30 01 00 00       	push   $0x130
  800dd4:	68 ca 31 80 00       	push   $0x8031ca
  800dd9:	e8 19 08 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[12].virtual_address,PAGE_SIZE) !=   0x806000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800dde:	a1 20 40 80 00       	mov    0x804020,%eax
  800de3:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800de9:	05 20 01 00 00       	add    $0x120,%eax
  800dee:	8b 00                	mov    (%eax),%eax
  800df0:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  800df6:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  800dfc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e01:	3d 00 60 80 00       	cmp    $0x806000,%eax
  800e06:	74 17                	je     800e1f <_main+0xde7>
  800e08:	83 ec 04             	sub    $0x4,%esp
  800e0b:	68 78 31 80 00       	push   $0x803178
  800e10:	68 31 01 00 00       	push   $0x131
  800e15:	68 ca 31 80 00       	push   $0x8031ca
  800e1a:	e8 d8 07 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[13].virtual_address,PAGE_SIZE) !=   0x807000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800e1f:	a1 20 40 80 00       	mov    0x804020,%eax
  800e24:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800e2a:	05 38 01 00 00       	add    $0x138,%eax
  800e2f:	8b 00                	mov    (%eax),%eax
  800e31:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  800e37:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  800e3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e42:	3d 00 70 80 00       	cmp    $0x807000,%eax
  800e47:	74 17                	je     800e60 <_main+0xe28>
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	68 78 31 80 00       	push   $0x803178
  800e51:	68 32 01 00 00       	push   $0x132
  800e56:	68 ca 31 80 00       	push   $0x8031ca
  800e5b:	e8 97 07 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[14].virtual_address,PAGE_SIZE) !=   0x808000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800e60:	a1 20 40 80 00       	mov    0x804020,%eax
  800e65:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800e6b:	05 50 01 00 00       	add    $0x150,%eax
  800e70:	8b 00                	mov    (%eax),%eax
  800e72:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  800e78:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  800e7e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e83:	3d 00 80 80 00       	cmp    $0x808000,%eax
  800e88:	74 17                	je     800ea1 <_main+0xe69>
  800e8a:	83 ec 04             	sub    $0x4,%esp
  800e8d:	68 78 31 80 00       	push   $0x803178
  800e92:	68 33 01 00 00       	push   $0x133
  800e97:	68 ca 31 80 00       	push   $0x8031ca
  800e9c:	e8 56 07 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[15].virtual_address,PAGE_SIZE) !=   0x809000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800ea1:	a1 20 40 80 00       	mov    0x804020,%eax
  800ea6:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800eac:	05 68 01 00 00       	add    $0x168,%eax
  800eb1:	8b 00                	mov    (%eax),%eax
  800eb3:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
  800eb9:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
  800ebf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ec4:	3d 00 90 80 00       	cmp    $0x809000,%eax
  800ec9:	74 17                	je     800ee2 <_main+0xeaa>
  800ecb:	83 ec 04             	sub    $0x4,%esp
  800ece:	68 78 31 80 00       	push   $0x803178
  800ed3:	68 34 01 00 00       	push   $0x134
  800ed8:	68 ca 31 80 00       	push   $0x8031ca
  800edd:	e8 15 07 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[16].virtual_address,PAGE_SIZE) !=   0x80A000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800ee2:	a1 20 40 80 00       	mov    0x804020,%eax
  800ee7:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800eed:	05 80 01 00 00       	add    $0x180,%eax
  800ef2:	8b 00                	mov    (%eax),%eax
  800ef4:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  800efa:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800f00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f05:	3d 00 a0 80 00       	cmp    $0x80a000,%eax
  800f0a:	74 17                	je     800f23 <_main+0xeeb>
  800f0c:	83 ec 04             	sub    $0x4,%esp
  800f0f:	68 78 31 80 00       	push   $0x803178
  800f14:	68 35 01 00 00       	push   $0x135
  800f19:	68 ca 31 80 00       	push   $0x8031ca
  800f1e:	e8 d4 06 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[17].virtual_address,PAGE_SIZE) !=   0x80B000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800f23:	a1 20 40 80 00       	mov    0x804020,%eax
  800f28:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800f2e:	05 98 01 00 00       	add    $0x198,%eax
  800f33:	8b 00                	mov    (%eax),%eax
  800f35:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
  800f3b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800f41:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f46:	3d 00 b0 80 00       	cmp    $0x80b000,%eax
  800f4b:	74 17                	je     800f64 <_main+0xf2c>
  800f4d:	83 ec 04             	sub    $0x4,%esp
  800f50:	68 78 31 80 00       	push   $0x803178
  800f55:	68 36 01 00 00       	push   $0x136
  800f5a:	68 ca 31 80 00       	push   $0x8031ca
  800f5f:	e8 93 06 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[18].virtual_address,PAGE_SIZE) !=   0x80C000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800f64:	a1 20 40 80 00       	mov    0x804020,%eax
  800f69:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800f6f:	05 b0 01 00 00       	add    $0x1b0,%eax
  800f74:	8b 00                	mov    (%eax),%eax
  800f76:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  800f7c:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  800f82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f87:	3d 00 c0 80 00       	cmp    $0x80c000,%eax
  800f8c:	74 17                	je     800fa5 <_main+0xf6d>
  800f8e:	83 ec 04             	sub    $0x4,%esp
  800f91:	68 78 31 80 00       	push   $0x803178
  800f96:	68 37 01 00 00       	push   $0x137
  800f9b:	68 ca 31 80 00       	push   $0x8031ca
  800fa0:	e8 52 06 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[19].virtual_address,PAGE_SIZE) !=   0x80D000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800fa5:	a1 20 40 80 00       	mov    0x804020,%eax
  800faa:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800fb0:	05 c8 01 00 00       	add    $0x1c8,%eax
  800fb5:	8b 00                	mov    (%eax),%eax
  800fb7:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
  800fbd:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
  800fc3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fc8:	3d 00 d0 80 00       	cmp    $0x80d000,%eax
  800fcd:	74 17                	je     800fe6 <_main+0xfae>
  800fcf:	83 ec 04             	sub    $0x4,%esp
  800fd2:	68 78 31 80 00       	push   $0x803178
  800fd7:	68 38 01 00 00       	push   $0x138
  800fdc:	68 ca 31 80 00       	push   $0x8031ca
  800fe1:	e8 11 06 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[20].virtual_address,PAGE_SIZE) !=   0x80E000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800fe6:	a1 20 40 80 00       	mov    0x804020,%eax
  800feb:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800ff1:	05 e0 01 00 00       	add    $0x1e0,%eax
  800ff6:	8b 00                	mov    (%eax),%eax
  800ff8:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  800ffe:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
  801004:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801009:	3d 00 e0 80 00       	cmp    $0x80e000,%eax
  80100e:	74 17                	je     801027 <_main+0xfef>
  801010:	83 ec 04             	sub    $0x4,%esp
  801013:	68 78 31 80 00       	push   $0x803178
  801018:	68 39 01 00 00       	push   $0x139
  80101d:	68 ca 31 80 00       	push   $0x8031ca
  801022:	e8 d0 05 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[21].virtual_address,PAGE_SIZE) !=   0x80F000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  801027:	a1 20 40 80 00       	mov    0x804020,%eax
  80102c:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  801032:	05 f8 01 00 00       	add    $0x1f8,%eax
  801037:	8b 00                	mov    (%eax),%eax
  801039:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
  80103f:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  801045:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80104a:	3d 00 f0 80 00       	cmp    $0x80f000,%eax
  80104f:	74 17                	je     801068 <_main+0x1030>
  801051:	83 ec 04             	sub    $0x4,%esp
  801054:	68 78 31 80 00       	push   $0x803178
  801059:	68 3a 01 00 00       	push   $0x13a
  80105e:	68 ca 31 80 00       	push   $0x8031ca
  801063:	e8 8f 05 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[22].virtual_address,PAGE_SIZE) !=   0x810000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  801068:	a1 20 40 80 00       	mov    0x804020,%eax
  80106d:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  801073:	05 10 02 00 00       	add    $0x210,%eax
  801078:	8b 00                	mov    (%eax),%eax
  80107a:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
  801080:	8b 85 dc fe ff ff    	mov    -0x124(%ebp),%eax
  801086:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80108b:	3d 00 00 81 00       	cmp    $0x810000,%eax
  801090:	74 17                	je     8010a9 <_main+0x1071>
  801092:	83 ec 04             	sub    $0x4,%esp
  801095:	68 78 31 80 00       	push   $0x803178
  80109a:	68 3b 01 00 00       	push   $0x13b
  80109f:	68 ca 31 80 00       	push   $0x8031ca
  8010a4:	e8 4e 05 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[23].virtual_address,PAGE_SIZE) !=   0x811000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8010a9:	a1 20 40 80 00       	mov    0x804020,%eax
  8010ae:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8010b4:	05 28 02 00 00       	add    $0x228,%eax
  8010b9:	8b 00                	mov    (%eax),%eax
  8010bb:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  8010c1:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  8010c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010cc:	3d 00 10 81 00       	cmp    $0x811000,%eax
  8010d1:	74 17                	je     8010ea <_main+0x10b2>
  8010d3:	83 ec 04             	sub    $0x4,%esp
  8010d6:	68 78 31 80 00       	push   $0x803178
  8010db:	68 3c 01 00 00       	push   $0x13c
  8010e0:	68 ca 31 80 00       	push   $0x8031ca
  8010e5:	e8 0d 05 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[24].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8010ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8010ef:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8010f5:	05 40 02 00 00       	add    $0x240,%eax
  8010fa:	8b 00                	mov    (%eax),%eax
  8010fc:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
  801102:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801108:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80110d:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  801112:	74 17                	je     80112b <_main+0x10f3>
  801114:	83 ec 04             	sub    $0x4,%esp
  801117:	68 78 31 80 00       	push   $0x803178
  80111c:	68 3d 01 00 00       	push   $0x13d
  801121:	68 ca 31 80 00       	push   $0x8031ca
  801126:	e8 cc 04 00 00       	call   8015f7 <_panic>
				if( ROUNDDOWN(myEnv->__uptr_pws[25].virtual_address,PAGE_SIZE) !=   0xee7fe000)  panic("InitialWSError2: INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80112b:	a1 20 40 80 00       	mov    0x804020,%eax
  801130:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  801136:	05 58 02 00 00       	add    $0x258,%eax
  80113b:	8b 00                	mov    (%eax),%eax
  80113d:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
  801143:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  801149:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80114e:	3d 00 e0 7f ee       	cmp    $0xee7fe000,%eax
  801153:	74 17                	je     80116c <_main+0x1134>
  801155:	83 ec 04             	sub    $0x4,%esp
  801158:	68 78 31 80 00       	push   $0x803178
  80115d:	68 3e 01 00 00       	push   $0x13e
  801162:	68 ca 31 80 00       	push   $0x8031ca
  801167:	e8 8b 04 00 00       	call   8015f7 <_panic>
				if( myEnv->page_last_WS_index !=  0)  										panic("InitialWSError2: INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  80116c:	a1 20 40 80 00       	mov    0x804020,%eax
  801171:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  801177:	85 c0                	test   %eax,%eax
  801179:	74 17                	je     801192 <_main+0x115a>
  80117b:	83 ec 04             	sub    $0x4,%esp
  80117e:	68 e0 31 80 00       	push   $0x8031e0
  801183:	68 3f 01 00 00       	push   $0x13f
  801188:	68 ca 31 80 00       	push   $0x8031ca
  80118d:	e8 65 04 00 00       	call   8015f7 <_panic>
			}

			//=========================================================//
			//Clear the FFL
			sys_clear_ffl();
  801192:	e8 d1 16 00 00       	call   802868 <sys_clear_ffl>

			//NOW: it should take from WS

			//Writing (Modified) after freeing the entire FFL:
			//	3 frames should be allocated (stack page, mem table, page file table)
			*ptr4 = garbage2 ;
  801197:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80119c:	8a 95 72 ff ff ff    	mov    -0x8e(%ebp),%dl
  8011a2:	88 10                	mov    %dl,(%eax)
			//always use pages at 0x801000 and 0x804000
			//			if (garbage4 != *ptr) panic("test failed!");
			//			if (garbage5 != *ptr2) panic("test failed!");

			garbage4 = *ptr ;
  8011a4:	a1 00 40 80 00       	mov    0x804000,%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	88 45 db             	mov    %al,-0x25(%ebp)
			garbage5 = *ptr2 ;
  8011ae:	a1 04 40 80 00       	mov    0x804004,%eax
  8011b3:	8a 00                	mov    (%eax),%al
  8011b5:	88 45 da             	mov    %al,-0x26(%ebp)

			//Writing (Modified) after freeing the entire FFL:
			//	4 frames should be allocated (4 stack pages)
			*(ptr4+1*PAGE_SIZE) = 'A';
  8011b8:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8011bd:	05 00 10 00 00       	add    $0x1000,%eax
  8011c2:	c6 00 41             	movb   $0x41,(%eax)
			*(ptr4+2*PAGE_SIZE) = 'B';
  8011c5:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8011ca:	05 00 20 00 00       	add    $0x2000,%eax
  8011cf:	c6 00 42             	movb   $0x42,(%eax)
			*(ptr4+3*PAGE_SIZE) = 'C';
  8011d2:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8011d7:	05 00 30 00 00       	add    $0x3000,%eax
  8011dc:	c6 00 43             	movb   $0x43,(%eax)
			*(ptr4+4*PAGE_SIZE) = 'D';
  8011df:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8011e4:	05 00 40 00 00       	add    $0x4000,%eax
  8011e9:	c6 00 44             	movb   $0x44,(%eax)
						ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ==  0x802000)
					panic("test failed! either wrong victim or victim is not removed from WS");
			}
			 */
			//Check the WS after FIFO algorithm
			if (garbage4 != *ptr || garbage5 != *ptr2) panic("test failed!");
  8011ec:	a1 00 40 80 00       	mov    0x804000,%eax
  8011f1:	8a 00                	mov    (%eax),%al
  8011f3:	3a 45 db             	cmp    -0x25(%ebp),%al
  8011f6:	75 0c                	jne    801204 <_main+0x11cc>
  8011f8:	a1 04 40 80 00       	mov    0x804004,%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3a 45 da             	cmp    -0x26(%ebp),%al
  801202:	74 17                	je     80121b <_main+0x11e3>
  801204:	83 ec 04             	sub    $0x4,%esp
  801207:	68 e1 32 80 00       	push   $0x8032e1
  80120c:	68 69 01 00 00       	push   $0x169
  801211:	68 ca 31 80 00       	push   $0x8031ca
  801216:	e8 dc 03 00 00       	call   8015f7 <_panic>

			//There should be two empty locations that are freed for the two tables (mem table and page file table)
			int numOfEmptyLocs = 0 ;
  80121b:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  801222:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801229:	eb 26                	jmp    801251 <_main+0x1219>
			{
				if (myEnv->__uptr_pws[i].empty)
  80122b:	a1 20 40 80 00       	mov    0x804020,%eax
  801230:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801236:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801239:	89 d0                	mov    %edx,%eax
  80123b:	01 c0                	add    %eax,%eax
  80123d:	01 d0                	add    %edx,%eax
  80123f:	c1 e0 03             	shl    $0x3,%eax
  801242:	01 c8                	add    %ecx,%eax
  801244:	8a 40 04             	mov    0x4(%eax),%al
  801247:	84 c0                	test   %al,%al
  801249:	74 03                	je     80124e <_main+0x1216>
					numOfEmptyLocs++ ;
  80124b:	ff 45 b8             	incl   -0x48(%ebp)
			//Check the WS after FIFO algorithm
			if (garbage4 != *ptr || garbage5 != *ptr2) panic("test failed!");

			//There should be two empty locations that are freed for the two tables (mem table and page file table)
			int numOfEmptyLocs = 0 ;
			for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  80124e:	ff 45 b4             	incl   -0x4c(%ebp)
  801251:	a1 20 40 80 00       	mov    0x804020,%eax
  801256:	8b 50 74             	mov    0x74(%eax),%edx
  801259:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80125c:	39 c2                	cmp    %eax,%edx
  80125e:	77 cb                	ja     80122b <_main+0x11f3>
			{
				if (myEnv->__uptr_pws[i].empty)
					numOfEmptyLocs++ ;
			}
			if (numOfEmptyLocs != 2) panic("test failed! either wrong victim or victim is not removed from WS");
  801260:	83 7d b8 02          	cmpl   $0x2,-0x48(%ebp)
  801264:	74 17                	je     80127d <_main+0x1245>
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	68 f0 32 80 00       	push   $0x8032f0
  80126e:	68 72 01 00 00       	push   $0x172
  801273:	68 ca 31 80 00       	push   $0x8031ca
  801278:	e8 7a 03 00 00       	call   8015f7 <_panic>

			uint32 expectedAddresses[24] = {0x801000,0x802000,0x803000,0x804000,0x805000,0x806000,0x807000,0x808000,0x809000,0x80a000,0x80b000,0x80c000,0x80d000,0x80e000,0x80f000,0x810000,0x811000,
  80127d:	8d 85 6c fe ff ff    	lea    -0x194(%ebp),%eax
  801283:	bb 20 34 80 00       	mov    $0x803420,%ebx
  801288:	ba 18 00 00 00       	mov    $0x18,%edx
  80128d:	89 c7                	mov    %eax,%edi
  80128f:	89 de                	mov    %ebx,%esi
  801291:	89 d1                	mov    %edx,%ecx
  801293:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
					0xee3f9000,0xee3fa000,0xee3fb000,0xee3fc000,0xee3fd000,0xee7fe000,0xeebfd000} ;

			int numOfFoundedAddresses = 0;
  801295:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
			for (int j = 0; j < 24; j++)
  80129c:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
  8012a3:	eb 5f                	jmp    801304 <_main+0x12cc>
			{
				for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  8012a5:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
  8012ac:	eb 44                	jmp    8012f2 <_main+0x12ba>
				{
					if (ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == expectedAddresses[j])
  8012ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8012b3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8012b9:	8b 55 a8             	mov    -0x58(%ebp),%edx
  8012bc:	89 d0                	mov    %edx,%eax
  8012be:	01 c0                	add    %eax,%eax
  8012c0:	01 d0                	add    %edx,%eax
  8012c2:	c1 e0 03             	shl    $0x3,%eax
  8012c5:	01 c8                	add    %ecx,%eax
  8012c7:	8b 00                	mov    (%eax),%eax
  8012c9:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
  8012cf:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  8012d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012da:	89 c2                	mov    %eax,%edx
  8012dc:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8012df:	8b 84 85 6c fe ff ff 	mov    -0x194(%ebp,%eax,4),%eax
  8012e6:	39 c2                	cmp    %eax,%edx
  8012e8:	75 05                	jne    8012ef <_main+0x12b7>
					{
						numOfFoundedAddresses++;
  8012ea:	ff 45 b0             	incl   -0x50(%ebp)
						break;
  8012ed:	eb 12                	jmp    801301 <_main+0x12c9>
					0xee3f9000,0xee3fa000,0xee3fb000,0xee3fc000,0xee3fd000,0xee7fe000,0xeebfd000} ;

			int numOfFoundedAddresses = 0;
			for (int j = 0; j < 24; j++)
			{
				for (int i = 0 ; i < myEnv->page_WS_max_size; i++)
  8012ef:	ff 45 a8             	incl   -0x58(%ebp)
  8012f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8012f7:	8b 50 74             	mov    0x74(%eax),%edx
  8012fa:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8012fd:	39 c2                	cmp    %eax,%edx
  8012ff:	77 ad                	ja     8012ae <_main+0x1276>

			uint32 expectedAddresses[24] = {0x801000,0x802000,0x803000,0x804000,0x805000,0x806000,0x807000,0x808000,0x809000,0x80a000,0x80b000,0x80c000,0x80d000,0x80e000,0x80f000,0x810000,0x811000,
					0xee3f9000,0xee3fa000,0xee3fb000,0xee3fc000,0xee3fd000,0xee7fe000,0xeebfd000} ;

			int numOfFoundedAddresses = 0;
			for (int j = 0; j < 24; j++)
  801301:	ff 45 ac             	incl   -0x54(%ebp)
  801304:	83 7d ac 17          	cmpl   $0x17,-0x54(%ebp)
  801308:	7e 9b                	jle    8012a5 <_main+0x126d>
						numOfFoundedAddresses++;
						break;
					}
				}
			}
			if (numOfFoundedAddresses != 24) panic("test failed! either wrong victim or victim is not removed from WS");
  80130a:	83 7d b0 18          	cmpl   $0x18,-0x50(%ebp)
  80130e:	74 17                	je     801327 <_main+0x12ef>
  801310:	83 ec 04             	sub    $0x4,%esp
  801313:	68 f0 32 80 00       	push   $0x8032f0
  801318:	68 83 01 00 00       	push   $0x183
  80131d:	68 ca 31 80 00       	push   $0x8031ca
  801322:	e8 d0 02 00 00       	call   8015f7 <_panic>

		}


		//Check that the values are successfully stored
		for (i = 0 ; i < PAGE_SIZE*4 ; i+=PAGE_SIZE/2)
  801327:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  80132e:	eb 2c                	jmp    80135c <_main+0x1324>
		{
			//cprintf("i = %x, address = %x, arr[i] = %d\n", i, &(arr[i]), arr[i]);
			if (arr[i] != -1) panic("test failed!");
  801330:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801333:	05 60 40 80 00       	add    $0x804060,%eax
  801338:	8a 00                	mov    (%eax),%al
  80133a:	3c ff                	cmp    $0xff,%al
  80133c:	74 17                	je     801355 <_main+0x131d>
  80133e:	83 ec 04             	sub    $0x4,%esp
  801341:	68 e1 32 80 00       	push   $0x8032e1
  801346:	68 8d 01 00 00       	push   $0x18d
  80134b:	68 ca 31 80 00       	push   $0x8031ca
  801350:	e8 a2 02 00 00       	call   8015f7 <_panic>

		}


		//Check that the values are successfully stored
		for (i = 0 ; i < PAGE_SIZE*4 ; i+=PAGE_SIZE/2)
  801355:	81 45 d4 00 08 00 00 	addl   $0x800,-0x2c(%ebp)
  80135c:	81 7d d4 ff 3f 00 00 	cmpl   $0x3fff,-0x2c(%ebp)
  801363:	7e cb                	jle    801330 <_main+0x12f8>
		{
			//cprintf("i = %x, address = %x, arr[i] = %d\n", i, &(arr[i]), arr[i]);
			if (arr[i] != -1) panic("test failed!");
		}
		if (*ptr3 != arr[PAGE_SIZE*10-1]) panic("test failed!");
  801365:	a1 08 40 80 00       	mov    0x804008,%eax
  80136a:	8a 10                	mov    (%eax),%dl
  80136c:	a0 5f e0 80 00       	mov    0x80e05f,%al
  801371:	38 c2                	cmp    %al,%dl
  801373:	74 17                	je     80138c <_main+0x1354>
  801375:	83 ec 04             	sub    $0x4,%esp
  801378:	68 e1 32 80 00       	push   $0x8032e1
  80137d:	68 8f 01 00 00       	push   $0x18f
  801382:	68 ca 31 80 00       	push   $0x8031ca
  801387:	e8 6b 02 00 00       	call   8015f7 <_panic>


		if (testCase ==3)
  80138c:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  801390:	0f 85 09 01 00 00    	jne    80149f <_main+0x1467>
		{
			//			cprintf("garbage4 = %d, *ptr = %d\n",garbage4, *ptr);
			if (garbage4 != *ptr) panic("test failed!");
  801396:	a1 00 40 80 00       	mov    0x804000,%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	3a 45 db             	cmp    -0x25(%ebp),%al
  8013a0:	74 17                	je     8013b9 <_main+0x1381>
  8013a2:	83 ec 04             	sub    $0x4,%esp
  8013a5:	68 e1 32 80 00       	push   $0x8032e1
  8013aa:	68 95 01 00 00       	push   $0x195
  8013af:	68 ca 31 80 00       	push   $0x8031ca
  8013b4:	e8 3e 02 00 00       	call   8015f7 <_panic>
			if (garbage5 != *ptr2) panic("test failed!");
  8013b9:	a1 04 40 80 00       	mov    0x804004,%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	3a 45 da             	cmp    -0x26(%ebp),%al
  8013c3:	74 17                	je     8013dc <_main+0x13a4>
  8013c5:	83 ec 04             	sub    $0x4,%esp
  8013c8:	68 e1 32 80 00       	push   $0x8032e1
  8013cd:	68 96 01 00 00       	push   $0x196
  8013d2:	68 ca 31 80 00       	push   $0x8031ca
  8013d7:	e8 1b 02 00 00       	call   8015f7 <_panic>

			if (*ptr4 != arr[PAGE_SIZE*11-1]) panic("test failed!");
  8013dc:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8013e1:	8a 10                	mov    (%eax),%dl
  8013e3:	a0 5f f0 80 00       	mov    0x80f05f,%al
  8013e8:	38 c2                	cmp    %al,%dl
  8013ea:	74 17                	je     801403 <_main+0x13cb>
  8013ec:	83 ec 04             	sub    $0x4,%esp
  8013ef:	68 e1 32 80 00       	push   $0x8032e1
  8013f4:	68 98 01 00 00       	push   $0x198
  8013f9:	68 ca 31 80 00       	push   $0x8031ca
  8013fe:	e8 f4 01 00 00       	call   8015f7 <_panic>
			if (*(ptr4+1*PAGE_SIZE) != 'A') panic("test failed!");
  801403:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801408:	05 00 10 00 00       	add    $0x1000,%eax
  80140d:	8a 00                	mov    (%eax),%al
  80140f:	3c 41                	cmp    $0x41,%al
  801411:	74 17                	je     80142a <_main+0x13f2>
  801413:	83 ec 04             	sub    $0x4,%esp
  801416:	68 e1 32 80 00       	push   $0x8032e1
  80141b:	68 99 01 00 00       	push   $0x199
  801420:	68 ca 31 80 00       	push   $0x8031ca
  801425:	e8 cd 01 00 00       	call   8015f7 <_panic>
			if (*(ptr4+2*PAGE_SIZE) != 'B') panic("test failed!");
  80142a:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80142f:	05 00 20 00 00       	add    $0x2000,%eax
  801434:	8a 00                	mov    (%eax),%al
  801436:	3c 42                	cmp    $0x42,%al
  801438:	74 17                	je     801451 <_main+0x1419>
  80143a:	83 ec 04             	sub    $0x4,%esp
  80143d:	68 e1 32 80 00       	push   $0x8032e1
  801442:	68 9a 01 00 00       	push   $0x19a
  801447:	68 ca 31 80 00       	push   $0x8031ca
  80144c:	e8 a6 01 00 00       	call   8015f7 <_panic>
			if (*(ptr4+3*PAGE_SIZE) != 'C') panic("test failed!");
  801451:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801456:	05 00 30 00 00       	add    $0x3000,%eax
  80145b:	8a 00                	mov    (%eax),%al
  80145d:	3c 43                	cmp    $0x43,%al
  80145f:	74 17                	je     801478 <_main+0x1440>
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	68 e1 32 80 00       	push   $0x8032e1
  801469:	68 9b 01 00 00       	push   $0x19b
  80146e:	68 ca 31 80 00       	push   $0x8031ca
  801473:	e8 7f 01 00 00       	call   8015f7 <_panic>
			if (*(ptr4+4*PAGE_SIZE) != 'D') panic("test failed!");
  801478:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80147d:	05 00 40 00 00       	add    $0x4000,%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	3c 44                	cmp    $0x44,%al
  801486:	74 17                	je     80149f <_main+0x1467>
  801488:	83 ec 04             	sub    $0x4,%esp
  80148b:	68 e1 32 80 00       	push   $0x8032e1
  801490:	68 9c 01 00 00       	push   $0x19c
  801495:	68 ca 31 80 00       	push   $0x8031ca
  80149a:	e8 58 01 00 00       	call   8015f7 <_panic>
		}
	}

	cprintf("Congratulations!! test freeRAM (Scenario# %d) completed successfully.\n", testCase);
  80149f:	83 ec 08             	sub    $0x8,%esp
  8014a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a5:	68 9c 33 80 00       	push   $0x80339c
  8014aa:	e8 fc 03 00 00       	call   8018ab <cprintf>
  8014af:	83 c4 10             	add    $0x10,%esp

	return;
  8014b2:	90                   	nop
}
  8014b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b6:	5b                   	pop    %ebx
  8014b7:	5e                   	pop    %esi
  8014b8:	5f                   	pop    %edi
  8014b9:	5d                   	pop    %ebp
  8014ba:	c3                   	ret    

008014bb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8014c1:	e8 3b 15 00 00       	call   802a01 <sys_getenvindex>
  8014c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8014c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014cc:	89 d0                	mov    %edx,%eax
  8014ce:	c1 e0 03             	shl    $0x3,%eax
  8014d1:	01 d0                	add    %edx,%eax
  8014d3:	01 c0                	add    %eax,%eax
  8014d5:	01 d0                	add    %edx,%eax
  8014d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014de:	01 d0                	add    %edx,%eax
  8014e0:	c1 e0 04             	shl    $0x4,%eax
  8014e3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8014e8:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8014ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8014f2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8014f8:	84 c0                	test   %al,%al
  8014fa:	74 0f                	je     80150b <libmain+0x50>
		binaryname = myEnv->prog_name;
  8014fc:	a1 20 40 80 00       	mov    0x804020,%eax
  801501:	05 5c 05 00 00       	add    $0x55c,%eax
  801506:	a3 10 40 80 00       	mov    %eax,0x804010

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80150b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80150f:	7e 0a                	jle    80151b <libmain+0x60>
		binaryname = argv[0];
  801511:	8b 45 0c             	mov    0xc(%ebp),%eax
  801514:	8b 00                	mov    (%eax),%eax
  801516:	a3 10 40 80 00       	mov    %eax,0x804010

	// call user main routine
	_main(argc, argv);
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	ff 75 0c             	pushl  0xc(%ebp)
  801521:	ff 75 08             	pushl  0x8(%ebp)
  801524:	e8 0f eb ff ff       	call   800038 <_main>
  801529:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80152c:	e8 dd 12 00 00       	call   80280e <sys_disable_interrupt>
	cprintf("**************************************\n");
  801531:	83 ec 0c             	sub    $0xc,%esp
  801534:	68 98 34 80 00       	push   $0x803498
  801539:	e8 6d 03 00 00       	call   8018ab <cprintf>
  80153e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801541:	a1 20 40 80 00       	mov    0x804020,%eax
  801546:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80154c:	a1 20 40 80 00       	mov    0x804020,%eax
  801551:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  801557:	83 ec 04             	sub    $0x4,%esp
  80155a:	52                   	push   %edx
  80155b:	50                   	push   %eax
  80155c:	68 c0 34 80 00       	push   $0x8034c0
  801561:	e8 45 03 00 00       	call   8018ab <cprintf>
  801566:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801569:	a1 20 40 80 00       	mov    0x804020,%eax
  80156e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  801574:	a1 20 40 80 00       	mov    0x804020,%eax
  801579:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80157f:	a1 20 40 80 00       	mov    0x804020,%eax
  801584:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80158a:	51                   	push   %ecx
  80158b:	52                   	push   %edx
  80158c:	50                   	push   %eax
  80158d:	68 e8 34 80 00       	push   $0x8034e8
  801592:	e8 14 03 00 00       	call   8018ab <cprintf>
  801597:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80159a:	a1 20 40 80 00       	mov    0x804020,%eax
  80159f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8015a5:	83 ec 08             	sub    $0x8,%esp
  8015a8:	50                   	push   %eax
  8015a9:	68 40 35 80 00       	push   $0x803540
  8015ae:	e8 f8 02 00 00       	call   8018ab <cprintf>
  8015b3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8015b6:	83 ec 0c             	sub    $0xc,%esp
  8015b9:	68 98 34 80 00       	push   $0x803498
  8015be:	e8 e8 02 00 00       	call   8018ab <cprintf>
  8015c3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8015c6:	e8 5d 12 00 00       	call   802828 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8015cb:	e8 19 00 00 00       	call   8015e9 <exit>
}
  8015d0:	90                   	nop
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8015d9:	83 ec 0c             	sub    $0xc,%esp
  8015dc:	6a 00                	push   $0x0
  8015de:	e8 ea 13 00 00       	call   8029cd <sys_destroy_env>
  8015e3:	83 c4 10             	add    $0x10,%esp
}
  8015e6:	90                   	nop
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <exit>:

void
exit(void)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8015ef:	e8 3f 14 00 00       	call   802a33 <sys_exit_env>
}
  8015f4:	90                   	nop
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8015fd:	8d 45 10             	lea    0x10(%ebp),%eax
  801600:	83 c0 04             	add    $0x4,%eax
  801603:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801606:	a1 14 11 81 00       	mov    0x811114,%eax
  80160b:	85 c0                	test   %eax,%eax
  80160d:	74 16                	je     801625 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80160f:	a1 14 11 81 00       	mov    0x811114,%eax
  801614:	83 ec 08             	sub    $0x8,%esp
  801617:	50                   	push   %eax
  801618:	68 54 35 80 00       	push   $0x803554
  80161d:	e8 89 02 00 00       	call   8018ab <cprintf>
  801622:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801625:	a1 10 40 80 00       	mov    0x804010,%eax
  80162a:	ff 75 0c             	pushl  0xc(%ebp)
  80162d:	ff 75 08             	pushl  0x8(%ebp)
  801630:	50                   	push   %eax
  801631:	68 59 35 80 00       	push   $0x803559
  801636:	e8 70 02 00 00       	call   8018ab <cprintf>
  80163b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80163e:	8b 45 10             	mov    0x10(%ebp),%eax
  801641:	83 ec 08             	sub    $0x8,%esp
  801644:	ff 75 f4             	pushl  -0xc(%ebp)
  801647:	50                   	push   %eax
  801648:	e8 f3 01 00 00       	call   801840 <vcprintf>
  80164d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	6a 00                	push   $0x0
  801655:	68 75 35 80 00       	push   $0x803575
  80165a:	e8 e1 01 00 00       	call   801840 <vcprintf>
  80165f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801662:	e8 82 ff ff ff       	call   8015e9 <exit>

	// should not return here
	while (1) ;
  801667:	eb fe                	jmp    801667 <_panic+0x70>

00801669 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80166f:	a1 20 40 80 00       	mov    0x804020,%eax
  801674:	8b 50 74             	mov    0x74(%eax),%edx
  801677:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167a:	39 c2                	cmp    %eax,%edx
  80167c:	74 14                	je     801692 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80167e:	83 ec 04             	sub    $0x4,%esp
  801681:	68 78 35 80 00       	push   $0x803578
  801686:	6a 26                	push   $0x26
  801688:	68 c4 35 80 00       	push   $0x8035c4
  80168d:	e8 65 ff ff ff       	call   8015f7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801692:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801699:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8016a0:	e9 c2 00 00 00       	jmp    801767 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8016a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	01 d0                	add    %edx,%eax
  8016b4:	8b 00                	mov    (%eax),%eax
  8016b6:	85 c0                	test   %eax,%eax
  8016b8:	75 08                	jne    8016c2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8016ba:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8016bd:	e9 a2 00 00 00       	jmp    801764 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8016c2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016c9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8016d0:	eb 69                	jmp    80173b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8016d2:	a1 20 40 80 00       	mov    0x804020,%eax
  8016d7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8016dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016e0:	89 d0                	mov    %edx,%eax
  8016e2:	01 c0                	add    %eax,%eax
  8016e4:	01 d0                	add    %edx,%eax
  8016e6:	c1 e0 03             	shl    $0x3,%eax
  8016e9:	01 c8                	add    %ecx,%eax
  8016eb:	8a 40 04             	mov    0x4(%eax),%al
  8016ee:	84 c0                	test   %al,%al
  8016f0:	75 46                	jne    801738 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8016f7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8016fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801700:	89 d0                	mov    %edx,%eax
  801702:	01 c0                	add    %eax,%eax
  801704:	01 d0                	add    %edx,%eax
  801706:	c1 e0 03             	shl    $0x3,%eax
  801709:	01 c8                	add    %ecx,%eax
  80170b:	8b 00                	mov    (%eax),%eax
  80170d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801710:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801713:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801718:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80171a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	01 c8                	add    %ecx,%eax
  801729:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80172b:	39 c2                	cmp    %eax,%edx
  80172d:	75 09                	jne    801738 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80172f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801736:	eb 12                	jmp    80174a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801738:	ff 45 e8             	incl   -0x18(%ebp)
  80173b:	a1 20 40 80 00       	mov    0x804020,%eax
  801740:	8b 50 74             	mov    0x74(%eax),%edx
  801743:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801746:	39 c2                	cmp    %eax,%edx
  801748:	77 88                	ja     8016d2 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80174a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80174e:	75 14                	jne    801764 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	68 d0 35 80 00       	push   $0x8035d0
  801758:	6a 3a                	push   $0x3a
  80175a:	68 c4 35 80 00       	push   $0x8035c4
  80175f:	e8 93 fe ff ff       	call   8015f7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801764:	ff 45 f0             	incl   -0x10(%ebp)
  801767:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80176d:	0f 8c 32 ff ff ff    	jl     8016a5 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801773:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80177a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801781:	eb 26                	jmp    8017a9 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801783:	a1 20 40 80 00       	mov    0x804020,%eax
  801788:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80178e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801791:	89 d0                	mov    %edx,%eax
  801793:	01 c0                	add    %eax,%eax
  801795:	01 d0                	add    %edx,%eax
  801797:	c1 e0 03             	shl    $0x3,%eax
  80179a:	01 c8                	add    %ecx,%eax
  80179c:	8a 40 04             	mov    0x4(%eax),%al
  80179f:	3c 01                	cmp    $0x1,%al
  8017a1:	75 03                	jne    8017a6 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8017a3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017a6:	ff 45 e0             	incl   -0x20(%ebp)
  8017a9:	a1 20 40 80 00       	mov    0x804020,%eax
  8017ae:	8b 50 74             	mov    0x74(%eax),%edx
  8017b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017b4:	39 c2                	cmp    %eax,%edx
  8017b6:	77 cb                	ja     801783 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8017b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8017be:	74 14                	je     8017d4 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	68 24 36 80 00       	push   $0x803624
  8017c8:	6a 44                	push   $0x44
  8017ca:	68 c4 35 80 00       	push   $0x8035c4
  8017cf:	e8 23 fe ff ff       	call   8015f7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8017d4:	90                   	nop
  8017d5:	c9                   	leave  
  8017d6:	c3                   	ret    

008017d7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8017dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e0:	8b 00                	mov    (%eax),%eax
  8017e2:	8d 48 01             	lea    0x1(%eax),%ecx
  8017e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e8:	89 0a                	mov    %ecx,(%edx)
  8017ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ed:	88 d1                	mov    %dl,%cl
  8017ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8017f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f9:	8b 00                	mov    (%eax),%eax
  8017fb:	3d ff 00 00 00       	cmp    $0xff,%eax
  801800:	75 2c                	jne    80182e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801802:	a0 24 40 80 00       	mov    0x804024,%al
  801807:	0f b6 c0             	movzbl %al,%eax
  80180a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180d:	8b 12                	mov    (%edx),%edx
  80180f:	89 d1                	mov    %edx,%ecx
  801811:	8b 55 0c             	mov    0xc(%ebp),%edx
  801814:	83 c2 08             	add    $0x8,%edx
  801817:	83 ec 04             	sub    $0x4,%esp
  80181a:	50                   	push   %eax
  80181b:	51                   	push   %ecx
  80181c:	52                   	push   %edx
  80181d:	e8 3e 0e 00 00       	call   802660 <sys_cputs>
  801822:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801825:	8b 45 0c             	mov    0xc(%ebp),%eax
  801828:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80182e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801831:	8b 40 04             	mov    0x4(%eax),%eax
  801834:	8d 50 01             	lea    0x1(%eax),%edx
  801837:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80183d:	90                   	nop
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801849:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801850:	00 00 00 
	b.cnt = 0;
  801853:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80185a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80185d:	ff 75 0c             	pushl  0xc(%ebp)
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801869:	50                   	push   %eax
  80186a:	68 d7 17 80 00       	push   $0x8017d7
  80186f:	e8 11 02 00 00       	call   801a85 <vprintfmt>
  801874:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801877:	a0 24 40 80 00       	mov    0x804024,%al
  80187c:	0f b6 c0             	movzbl %al,%eax
  80187f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801885:	83 ec 04             	sub    $0x4,%esp
  801888:	50                   	push   %eax
  801889:	52                   	push   %edx
  80188a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801890:	83 c0 08             	add    $0x8,%eax
  801893:	50                   	push   %eax
  801894:	e8 c7 0d 00 00       	call   802660 <sys_cputs>
  801899:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80189c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8018a3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <cprintf>:

int cprintf(const char *fmt, ...) {
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8018b1:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8018b8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	83 ec 08             	sub    $0x8,%esp
  8018c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c7:	50                   	push   %eax
  8018c8:	e8 73 ff ff ff       	call   801840 <vcprintf>
  8018cd:	83 c4 10             	add    $0x10,%esp
  8018d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8018d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8018de:	e8 2b 0f 00 00       	call   80280e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8018e3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8018e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	83 ec 08             	sub    $0x8,%esp
  8018ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f2:	50                   	push   %eax
  8018f3:	e8 48 ff ff ff       	call   801840 <vcprintf>
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8018fe:	e8 25 0f 00 00       	call   802828 <sys_enable_interrupt>
	return cnt;
  801903:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	53                   	push   %ebx
  80190c:	83 ec 14             	sub    $0x14,%esp
  80190f:	8b 45 10             	mov    0x10(%ebp),%eax
  801912:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801915:	8b 45 14             	mov    0x14(%ebp),%eax
  801918:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80191b:	8b 45 18             	mov    0x18(%ebp),%eax
  80191e:	ba 00 00 00 00       	mov    $0x0,%edx
  801923:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801926:	77 55                	ja     80197d <printnum+0x75>
  801928:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80192b:	72 05                	jb     801932 <printnum+0x2a>
  80192d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801930:	77 4b                	ja     80197d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801932:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801935:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801938:	8b 45 18             	mov    0x18(%ebp),%eax
  80193b:	ba 00 00 00 00       	mov    $0x0,%edx
  801940:	52                   	push   %edx
  801941:	50                   	push   %eax
  801942:	ff 75 f4             	pushl  -0xc(%ebp)
  801945:	ff 75 f0             	pushl  -0x10(%ebp)
  801948:	e8 fb 13 00 00       	call   802d48 <__udivdi3>
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	83 ec 04             	sub    $0x4,%esp
  801953:	ff 75 20             	pushl  0x20(%ebp)
  801956:	53                   	push   %ebx
  801957:	ff 75 18             	pushl  0x18(%ebp)
  80195a:	52                   	push   %edx
  80195b:	50                   	push   %eax
  80195c:	ff 75 0c             	pushl  0xc(%ebp)
  80195f:	ff 75 08             	pushl  0x8(%ebp)
  801962:	e8 a1 ff ff ff       	call   801908 <printnum>
  801967:	83 c4 20             	add    $0x20,%esp
  80196a:	eb 1a                	jmp    801986 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80196c:	83 ec 08             	sub    $0x8,%esp
  80196f:	ff 75 0c             	pushl  0xc(%ebp)
  801972:	ff 75 20             	pushl  0x20(%ebp)
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	ff d0                	call   *%eax
  80197a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80197d:	ff 4d 1c             	decl   0x1c(%ebp)
  801980:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801984:	7f e6                	jg     80196c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801986:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801989:	bb 00 00 00 00       	mov    $0x0,%ebx
  80198e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801994:	53                   	push   %ebx
  801995:	51                   	push   %ecx
  801996:	52                   	push   %edx
  801997:	50                   	push   %eax
  801998:	e8 bb 14 00 00       	call   802e58 <__umoddi3>
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	05 94 38 80 00       	add    $0x803894,%eax
  8019a5:	8a 00                	mov    (%eax),%al
  8019a7:	0f be c0             	movsbl %al,%eax
  8019aa:	83 ec 08             	sub    $0x8,%esp
  8019ad:	ff 75 0c             	pushl  0xc(%ebp)
  8019b0:	50                   	push   %eax
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	ff d0                	call   *%eax
  8019b6:	83 c4 10             	add    $0x10,%esp
}
  8019b9:	90                   	nop
  8019ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019c6:	7e 1c                	jle    8019e4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	8b 00                	mov    (%eax),%eax
  8019cd:	8d 50 08             	lea    0x8(%eax),%edx
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	89 10                	mov    %edx,(%eax)
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	8b 00                	mov    (%eax),%eax
  8019da:	83 e8 08             	sub    $0x8,%eax
  8019dd:	8b 50 04             	mov    0x4(%eax),%edx
  8019e0:	8b 00                	mov    (%eax),%eax
  8019e2:	eb 40                	jmp    801a24 <getuint+0x65>
	else if (lflag)
  8019e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019e8:	74 1e                	je     801a08 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	8b 00                	mov    (%eax),%eax
  8019ef:	8d 50 04             	lea    0x4(%eax),%edx
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	89 10                	mov    %edx,(%eax)
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8b 00                	mov    (%eax),%eax
  8019fc:	83 e8 04             	sub    $0x4,%eax
  8019ff:	8b 00                	mov    (%eax),%eax
  801a01:	ba 00 00 00 00       	mov    $0x0,%edx
  801a06:	eb 1c                	jmp    801a24 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	8b 00                	mov    (%eax),%eax
  801a0d:	8d 50 04             	lea    0x4(%eax),%edx
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	89 10                	mov    %edx,(%eax)
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	8b 00                	mov    (%eax),%eax
  801a1a:	83 e8 04             	sub    $0x4,%eax
  801a1d:	8b 00                	mov    (%eax),%eax
  801a1f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a24:	5d                   	pop    %ebp
  801a25:	c3                   	ret    

00801a26 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a29:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a2d:	7e 1c                	jle    801a4b <getint+0x25>
		return va_arg(*ap, long long);
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	8b 00                	mov    (%eax),%eax
  801a34:	8d 50 08             	lea    0x8(%eax),%edx
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	89 10                	mov    %edx,(%eax)
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	8b 00                	mov    (%eax),%eax
  801a41:	83 e8 08             	sub    $0x8,%eax
  801a44:	8b 50 04             	mov    0x4(%eax),%edx
  801a47:	8b 00                	mov    (%eax),%eax
  801a49:	eb 38                	jmp    801a83 <getint+0x5d>
	else if (lflag)
  801a4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a4f:	74 1a                	je     801a6b <getint+0x45>
		return va_arg(*ap, long);
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	8b 00                	mov    (%eax),%eax
  801a56:	8d 50 04             	lea    0x4(%eax),%edx
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	89 10                	mov    %edx,(%eax)
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	8b 00                	mov    (%eax),%eax
  801a63:	83 e8 04             	sub    $0x4,%eax
  801a66:	8b 00                	mov    (%eax),%eax
  801a68:	99                   	cltd   
  801a69:	eb 18                	jmp    801a83 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	8b 00                	mov    (%eax),%eax
  801a70:	8d 50 04             	lea    0x4(%eax),%edx
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	89 10                	mov    %edx,(%eax)
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	8b 00                	mov    (%eax),%eax
  801a7d:	83 e8 04             	sub    $0x4,%eax
  801a80:	8b 00                	mov    (%eax),%eax
  801a82:	99                   	cltd   
}
  801a83:	5d                   	pop    %ebp
  801a84:	c3                   	ret    

00801a85 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	56                   	push   %esi
  801a89:	53                   	push   %ebx
  801a8a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a8d:	eb 17                	jmp    801aa6 <vprintfmt+0x21>
			if (ch == '\0')
  801a8f:	85 db                	test   %ebx,%ebx
  801a91:	0f 84 af 03 00 00    	je     801e46 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801a97:	83 ec 08             	sub    $0x8,%esp
  801a9a:	ff 75 0c             	pushl  0xc(%ebp)
  801a9d:	53                   	push   %ebx
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	ff d0                	call   *%eax
  801aa3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801aa6:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa9:	8d 50 01             	lea    0x1(%eax),%edx
  801aac:	89 55 10             	mov    %edx,0x10(%ebp)
  801aaf:	8a 00                	mov    (%eax),%al
  801ab1:	0f b6 d8             	movzbl %al,%ebx
  801ab4:	83 fb 25             	cmp    $0x25,%ebx
  801ab7:	75 d6                	jne    801a8f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801ab9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801abd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801ac4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801acb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801ad2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ad9:	8b 45 10             	mov    0x10(%ebp),%eax
  801adc:	8d 50 01             	lea    0x1(%eax),%edx
  801adf:	89 55 10             	mov    %edx,0x10(%ebp)
  801ae2:	8a 00                	mov    (%eax),%al
  801ae4:	0f b6 d8             	movzbl %al,%ebx
  801ae7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801aea:	83 f8 55             	cmp    $0x55,%eax
  801aed:	0f 87 2b 03 00 00    	ja     801e1e <vprintfmt+0x399>
  801af3:	8b 04 85 b8 38 80 00 	mov    0x8038b8(,%eax,4),%eax
  801afa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801afc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801b00:	eb d7                	jmp    801ad9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801b02:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801b06:	eb d1                	jmp    801ad9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b08:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801b0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b12:	89 d0                	mov    %edx,%eax
  801b14:	c1 e0 02             	shl    $0x2,%eax
  801b17:	01 d0                	add    %edx,%eax
  801b19:	01 c0                	add    %eax,%eax
  801b1b:	01 d8                	add    %ebx,%eax
  801b1d:	83 e8 30             	sub    $0x30,%eax
  801b20:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801b23:	8b 45 10             	mov    0x10(%ebp),%eax
  801b26:	8a 00                	mov    (%eax),%al
  801b28:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801b2b:	83 fb 2f             	cmp    $0x2f,%ebx
  801b2e:	7e 3e                	jle    801b6e <vprintfmt+0xe9>
  801b30:	83 fb 39             	cmp    $0x39,%ebx
  801b33:	7f 39                	jg     801b6e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b35:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b38:	eb d5                	jmp    801b0f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b3a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b3d:	83 c0 04             	add    $0x4,%eax
  801b40:	89 45 14             	mov    %eax,0x14(%ebp)
  801b43:	8b 45 14             	mov    0x14(%ebp),%eax
  801b46:	83 e8 04             	sub    $0x4,%eax
  801b49:	8b 00                	mov    (%eax),%eax
  801b4b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801b4e:	eb 1f                	jmp    801b6f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801b50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b54:	79 83                	jns    801ad9 <vprintfmt+0x54>
				width = 0;
  801b56:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801b5d:	e9 77 ff ff ff       	jmp    801ad9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801b62:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b69:	e9 6b ff ff ff       	jmp    801ad9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b6e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b73:	0f 89 60 ff ff ff    	jns    801ad9 <vprintfmt+0x54>
				width = precision, precision = -1;
  801b79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b7f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b86:	e9 4e ff ff ff       	jmp    801ad9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b8b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b8e:	e9 46 ff ff ff       	jmp    801ad9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b93:	8b 45 14             	mov    0x14(%ebp),%eax
  801b96:	83 c0 04             	add    $0x4,%eax
  801b99:	89 45 14             	mov    %eax,0x14(%ebp)
  801b9c:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9f:	83 e8 04             	sub    $0x4,%eax
  801ba2:	8b 00                	mov    (%eax),%eax
  801ba4:	83 ec 08             	sub    $0x8,%esp
  801ba7:	ff 75 0c             	pushl  0xc(%ebp)
  801baa:	50                   	push   %eax
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	ff d0                	call   *%eax
  801bb0:	83 c4 10             	add    $0x10,%esp
			break;
  801bb3:	e9 89 02 00 00       	jmp    801e41 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801bb8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bbb:	83 c0 04             	add    $0x4,%eax
  801bbe:	89 45 14             	mov    %eax,0x14(%ebp)
  801bc1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc4:	83 e8 04             	sub    $0x4,%eax
  801bc7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801bc9:	85 db                	test   %ebx,%ebx
  801bcb:	79 02                	jns    801bcf <vprintfmt+0x14a>
				err = -err;
  801bcd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801bcf:	83 fb 64             	cmp    $0x64,%ebx
  801bd2:	7f 0b                	jg     801bdf <vprintfmt+0x15a>
  801bd4:	8b 34 9d 00 37 80 00 	mov    0x803700(,%ebx,4),%esi
  801bdb:	85 f6                	test   %esi,%esi
  801bdd:	75 19                	jne    801bf8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801bdf:	53                   	push   %ebx
  801be0:	68 a5 38 80 00       	push   $0x8038a5
  801be5:	ff 75 0c             	pushl  0xc(%ebp)
  801be8:	ff 75 08             	pushl  0x8(%ebp)
  801beb:	e8 5e 02 00 00       	call   801e4e <printfmt>
  801bf0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801bf3:	e9 49 02 00 00       	jmp    801e41 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801bf8:	56                   	push   %esi
  801bf9:	68 ae 38 80 00       	push   $0x8038ae
  801bfe:	ff 75 0c             	pushl  0xc(%ebp)
  801c01:	ff 75 08             	pushl  0x8(%ebp)
  801c04:	e8 45 02 00 00       	call   801e4e <printfmt>
  801c09:	83 c4 10             	add    $0x10,%esp
			break;
  801c0c:	e9 30 02 00 00       	jmp    801e41 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c11:	8b 45 14             	mov    0x14(%ebp),%eax
  801c14:	83 c0 04             	add    $0x4,%eax
  801c17:	89 45 14             	mov    %eax,0x14(%ebp)
  801c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1d:	83 e8 04             	sub    $0x4,%eax
  801c20:	8b 30                	mov    (%eax),%esi
  801c22:	85 f6                	test   %esi,%esi
  801c24:	75 05                	jne    801c2b <vprintfmt+0x1a6>
				p = "(null)";
  801c26:	be b1 38 80 00       	mov    $0x8038b1,%esi
			if (width > 0 && padc != '-')
  801c2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c2f:	7e 6d                	jle    801c9e <vprintfmt+0x219>
  801c31:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801c35:	74 67                	je     801c9e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c3a:	83 ec 08             	sub    $0x8,%esp
  801c3d:	50                   	push   %eax
  801c3e:	56                   	push   %esi
  801c3f:	e8 0c 03 00 00       	call   801f50 <strnlen>
  801c44:	83 c4 10             	add    $0x10,%esp
  801c47:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801c4a:	eb 16                	jmp    801c62 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801c4c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801c50:	83 ec 08             	sub    $0x8,%esp
  801c53:	ff 75 0c             	pushl  0xc(%ebp)
  801c56:	50                   	push   %eax
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	ff d0                	call   *%eax
  801c5c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c5f:	ff 4d e4             	decl   -0x1c(%ebp)
  801c62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c66:	7f e4                	jg     801c4c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c68:	eb 34                	jmp    801c9e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c6a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c6e:	74 1c                	je     801c8c <vprintfmt+0x207>
  801c70:	83 fb 1f             	cmp    $0x1f,%ebx
  801c73:	7e 05                	jle    801c7a <vprintfmt+0x1f5>
  801c75:	83 fb 7e             	cmp    $0x7e,%ebx
  801c78:	7e 12                	jle    801c8c <vprintfmt+0x207>
					putch('?', putdat);
  801c7a:	83 ec 08             	sub    $0x8,%esp
  801c7d:	ff 75 0c             	pushl  0xc(%ebp)
  801c80:	6a 3f                	push   $0x3f
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	ff d0                	call   *%eax
  801c87:	83 c4 10             	add    $0x10,%esp
  801c8a:	eb 0f                	jmp    801c9b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c8c:	83 ec 08             	sub    $0x8,%esp
  801c8f:	ff 75 0c             	pushl  0xc(%ebp)
  801c92:	53                   	push   %ebx
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	ff d0                	call   *%eax
  801c98:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c9b:	ff 4d e4             	decl   -0x1c(%ebp)
  801c9e:	89 f0                	mov    %esi,%eax
  801ca0:	8d 70 01             	lea    0x1(%eax),%esi
  801ca3:	8a 00                	mov    (%eax),%al
  801ca5:	0f be d8             	movsbl %al,%ebx
  801ca8:	85 db                	test   %ebx,%ebx
  801caa:	74 24                	je     801cd0 <vprintfmt+0x24b>
  801cac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cb0:	78 b8                	js     801c6a <vprintfmt+0x1e5>
  801cb2:	ff 4d e0             	decl   -0x20(%ebp)
  801cb5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cb9:	79 af                	jns    801c6a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801cbb:	eb 13                	jmp    801cd0 <vprintfmt+0x24b>
				putch(' ', putdat);
  801cbd:	83 ec 08             	sub    $0x8,%esp
  801cc0:	ff 75 0c             	pushl  0xc(%ebp)
  801cc3:	6a 20                	push   $0x20
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	ff d0                	call   *%eax
  801cca:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ccd:	ff 4d e4             	decl   -0x1c(%ebp)
  801cd0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801cd4:	7f e7                	jg     801cbd <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801cd6:	e9 66 01 00 00       	jmp    801e41 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801cdb:	83 ec 08             	sub    $0x8,%esp
  801cde:	ff 75 e8             	pushl  -0x18(%ebp)
  801ce1:	8d 45 14             	lea    0x14(%ebp),%eax
  801ce4:	50                   	push   %eax
  801ce5:	e8 3c fd ff ff       	call   801a26 <getint>
  801cea:	83 c4 10             	add    $0x10,%esp
  801ced:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cf0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf9:	85 d2                	test   %edx,%edx
  801cfb:	79 23                	jns    801d20 <vprintfmt+0x29b>
				putch('-', putdat);
  801cfd:	83 ec 08             	sub    $0x8,%esp
  801d00:	ff 75 0c             	pushl  0xc(%ebp)
  801d03:	6a 2d                	push   $0x2d
  801d05:	8b 45 08             	mov    0x8(%ebp),%eax
  801d08:	ff d0                	call   *%eax
  801d0a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d13:	f7 d8                	neg    %eax
  801d15:	83 d2 00             	adc    $0x0,%edx
  801d18:	f7 da                	neg    %edx
  801d1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d1d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801d20:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d27:	e9 bc 00 00 00       	jmp    801de8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801d2c:	83 ec 08             	sub    $0x8,%esp
  801d2f:	ff 75 e8             	pushl  -0x18(%ebp)
  801d32:	8d 45 14             	lea    0x14(%ebp),%eax
  801d35:	50                   	push   %eax
  801d36:	e8 84 fc ff ff       	call   8019bf <getuint>
  801d3b:	83 c4 10             	add    $0x10,%esp
  801d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d41:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801d44:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801d4b:	e9 98 00 00 00       	jmp    801de8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801d50:	83 ec 08             	sub    $0x8,%esp
  801d53:	ff 75 0c             	pushl  0xc(%ebp)
  801d56:	6a 58                	push   $0x58
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	ff d0                	call   *%eax
  801d5d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d60:	83 ec 08             	sub    $0x8,%esp
  801d63:	ff 75 0c             	pushl  0xc(%ebp)
  801d66:	6a 58                	push   $0x58
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	ff d0                	call   *%eax
  801d6d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d70:	83 ec 08             	sub    $0x8,%esp
  801d73:	ff 75 0c             	pushl  0xc(%ebp)
  801d76:	6a 58                	push   $0x58
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	ff d0                	call   *%eax
  801d7d:	83 c4 10             	add    $0x10,%esp
			break;
  801d80:	e9 bc 00 00 00       	jmp    801e41 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801d85:	83 ec 08             	sub    $0x8,%esp
  801d88:	ff 75 0c             	pushl  0xc(%ebp)
  801d8b:	6a 30                	push   $0x30
  801d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d90:	ff d0                	call   *%eax
  801d92:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801d95:	83 ec 08             	sub    $0x8,%esp
  801d98:	ff 75 0c             	pushl  0xc(%ebp)
  801d9b:	6a 78                	push   $0x78
  801d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801da0:	ff d0                	call   *%eax
  801da2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801da5:	8b 45 14             	mov    0x14(%ebp),%eax
  801da8:	83 c0 04             	add    $0x4,%eax
  801dab:	89 45 14             	mov    %eax,0x14(%ebp)
  801dae:	8b 45 14             	mov    0x14(%ebp),%eax
  801db1:	83 e8 04             	sub    $0x4,%eax
  801db4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801db6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801db9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801dc0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801dc7:	eb 1f                	jmp    801de8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801dc9:	83 ec 08             	sub    $0x8,%esp
  801dcc:	ff 75 e8             	pushl  -0x18(%ebp)
  801dcf:	8d 45 14             	lea    0x14(%ebp),%eax
  801dd2:	50                   	push   %eax
  801dd3:	e8 e7 fb ff ff       	call   8019bf <getuint>
  801dd8:	83 c4 10             	add    $0x10,%esp
  801ddb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801dde:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801de1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801de8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801def:	83 ec 04             	sub    $0x4,%esp
  801df2:	52                   	push   %edx
  801df3:	ff 75 e4             	pushl  -0x1c(%ebp)
  801df6:	50                   	push   %eax
  801df7:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfa:	ff 75 f0             	pushl  -0x10(%ebp)
  801dfd:	ff 75 0c             	pushl  0xc(%ebp)
  801e00:	ff 75 08             	pushl  0x8(%ebp)
  801e03:	e8 00 fb ff ff       	call   801908 <printnum>
  801e08:	83 c4 20             	add    $0x20,%esp
			break;
  801e0b:	eb 34                	jmp    801e41 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e0d:	83 ec 08             	sub    $0x8,%esp
  801e10:	ff 75 0c             	pushl  0xc(%ebp)
  801e13:	53                   	push   %ebx
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	ff d0                	call   *%eax
  801e19:	83 c4 10             	add    $0x10,%esp
			break;
  801e1c:	eb 23                	jmp    801e41 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e1e:	83 ec 08             	sub    $0x8,%esp
  801e21:	ff 75 0c             	pushl  0xc(%ebp)
  801e24:	6a 25                	push   $0x25
  801e26:	8b 45 08             	mov    0x8(%ebp),%eax
  801e29:	ff d0                	call   *%eax
  801e2b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e2e:	ff 4d 10             	decl   0x10(%ebp)
  801e31:	eb 03                	jmp    801e36 <vprintfmt+0x3b1>
  801e33:	ff 4d 10             	decl   0x10(%ebp)
  801e36:	8b 45 10             	mov    0x10(%ebp),%eax
  801e39:	48                   	dec    %eax
  801e3a:	8a 00                	mov    (%eax),%al
  801e3c:	3c 25                	cmp    $0x25,%al
  801e3e:	75 f3                	jne    801e33 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801e40:	90                   	nop
		}
	}
  801e41:	e9 47 fc ff ff       	jmp    801a8d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801e46:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801e47:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e4a:	5b                   	pop    %ebx
  801e4b:	5e                   	pop    %esi
  801e4c:	5d                   	pop    %ebp
  801e4d:	c3                   	ret    

00801e4e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801e54:	8d 45 10             	lea    0x10(%ebp),%eax
  801e57:	83 c0 04             	add    $0x4,%eax
  801e5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801e5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e60:	ff 75 f4             	pushl  -0xc(%ebp)
  801e63:	50                   	push   %eax
  801e64:	ff 75 0c             	pushl  0xc(%ebp)
  801e67:	ff 75 08             	pushl  0x8(%ebp)
  801e6a:	e8 16 fc ff ff       	call   801a85 <vprintfmt>
  801e6f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e72:	90                   	nop
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7b:	8b 40 08             	mov    0x8(%eax),%eax
  801e7e:	8d 50 01             	lea    0x1(%eax),%edx
  801e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e84:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8a:	8b 10                	mov    (%eax),%edx
  801e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8f:	8b 40 04             	mov    0x4(%eax),%eax
  801e92:	39 c2                	cmp    %eax,%edx
  801e94:	73 12                	jae    801ea8 <sprintputch+0x33>
		*b->buf++ = ch;
  801e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e99:	8b 00                	mov    (%eax),%eax
  801e9b:	8d 48 01             	lea    0x1(%eax),%ecx
  801e9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea1:	89 0a                	mov    %ecx,(%edx)
  801ea3:	8b 55 08             	mov    0x8(%ebp),%edx
  801ea6:	88 10                	mov    %dl,(%eax)
}
  801ea8:	90                   	nop
  801ea9:	5d                   	pop    %ebp
  801eaa:	c3                   	ret    

00801eab <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eba:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	01 d0                	add    %edx,%eax
  801ec2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ec5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801ecc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ed0:	74 06                	je     801ed8 <vsnprintf+0x2d>
  801ed2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ed6:	7f 07                	jg     801edf <vsnprintf+0x34>
		return -E_INVAL;
  801ed8:	b8 03 00 00 00       	mov    $0x3,%eax
  801edd:	eb 20                	jmp    801eff <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801edf:	ff 75 14             	pushl  0x14(%ebp)
  801ee2:	ff 75 10             	pushl  0x10(%ebp)
  801ee5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ee8:	50                   	push   %eax
  801ee9:	68 75 1e 80 00       	push   $0x801e75
  801eee:	e8 92 fb ff ff       	call   801a85 <vprintfmt>
  801ef3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801ef6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f07:	8d 45 10             	lea    0x10(%ebp),%eax
  801f0a:	83 c0 04             	add    $0x4,%eax
  801f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801f10:	8b 45 10             	mov    0x10(%ebp),%eax
  801f13:	ff 75 f4             	pushl  -0xc(%ebp)
  801f16:	50                   	push   %eax
  801f17:	ff 75 0c             	pushl  0xc(%ebp)
  801f1a:	ff 75 08             	pushl  0x8(%ebp)
  801f1d:	e8 89 ff ff ff       	call   801eab <vsnprintf>
  801f22:	83 c4 10             	add    $0x10,%esp
  801f25:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801f33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f3a:	eb 06                	jmp    801f42 <strlen+0x15>
		n++;
  801f3c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f3f:	ff 45 08             	incl   0x8(%ebp)
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	8a 00                	mov    (%eax),%al
  801f47:	84 c0                	test   %al,%al
  801f49:	75 f1                	jne    801f3c <strlen+0xf>
		n++;
	return n;
  801f4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f56:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f5d:	eb 09                	jmp    801f68 <strnlen+0x18>
		n++;
  801f5f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f62:	ff 45 08             	incl   0x8(%ebp)
  801f65:	ff 4d 0c             	decl   0xc(%ebp)
  801f68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f6c:	74 09                	je     801f77 <strnlen+0x27>
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	8a 00                	mov    (%eax),%al
  801f73:	84 c0                	test   %al,%al
  801f75:	75 e8                	jne    801f5f <strnlen+0xf>
		n++;
	return n;
  801f77:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f88:	90                   	nop
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	8d 50 01             	lea    0x1(%eax),%edx
  801f8f:	89 55 08             	mov    %edx,0x8(%ebp)
  801f92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f95:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f98:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f9b:	8a 12                	mov    (%edx),%dl
  801f9d:	88 10                	mov    %dl,(%eax)
  801f9f:	8a 00                	mov    (%eax),%al
  801fa1:	84 c0                	test   %al,%al
  801fa3:	75 e4                	jne    801f89 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801fa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801fb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801fbd:	eb 1f                	jmp    801fde <strncpy+0x34>
		*dst++ = *src;
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	8d 50 01             	lea    0x1(%eax),%edx
  801fc5:	89 55 08             	mov    %edx,0x8(%ebp)
  801fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcb:	8a 12                	mov    (%edx),%dl
  801fcd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd2:	8a 00                	mov    (%eax),%al
  801fd4:	84 c0                	test   %al,%al
  801fd6:	74 03                	je     801fdb <strncpy+0x31>
			src++;
  801fd8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801fdb:	ff 45 fc             	incl   -0x4(%ebp)
  801fde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe1:	3b 45 10             	cmp    0x10(%ebp),%eax
  801fe4:	72 d9                	jb     801fbf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801fe6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801fe9:	c9                   	leave  
  801fea:	c3                   	ret    

00801feb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801feb:	55                   	push   %ebp
  801fec:	89 e5                	mov    %esp,%ebp
  801fee:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ffb:	74 30                	je     80202d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801ffd:	eb 16                	jmp    802015 <strlcpy+0x2a>
			*dst++ = *src++;
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	8d 50 01             	lea    0x1(%eax),%edx
  802005:	89 55 08             	mov    %edx,0x8(%ebp)
  802008:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80200e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  802011:	8a 12                	mov    (%edx),%dl
  802013:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802015:	ff 4d 10             	decl   0x10(%ebp)
  802018:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80201c:	74 09                	je     802027 <strlcpy+0x3c>
  80201e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802021:	8a 00                	mov    (%eax),%al
  802023:	84 c0                	test   %al,%al
  802025:	75 d8                	jne    801fff <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80202d:	8b 55 08             	mov    0x8(%ebp),%edx
  802030:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802033:	29 c2                	sub    %eax,%edx
  802035:	89 d0                	mov    %edx,%eax
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80203c:	eb 06                	jmp    802044 <strcmp+0xb>
		p++, q++;
  80203e:	ff 45 08             	incl   0x8(%ebp)
  802041:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	8a 00                	mov    (%eax),%al
  802049:	84 c0                	test   %al,%al
  80204b:	74 0e                	je     80205b <strcmp+0x22>
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	8a 10                	mov    (%eax),%dl
  802052:	8b 45 0c             	mov    0xc(%ebp),%eax
  802055:	8a 00                	mov    (%eax),%al
  802057:	38 c2                	cmp    %al,%dl
  802059:	74 e3                	je     80203e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	8a 00                	mov    (%eax),%al
  802060:	0f b6 d0             	movzbl %al,%edx
  802063:	8b 45 0c             	mov    0xc(%ebp),%eax
  802066:	8a 00                	mov    (%eax),%al
  802068:	0f b6 c0             	movzbl %al,%eax
  80206b:	29 c2                	sub    %eax,%edx
  80206d:	89 d0                	mov    %edx,%eax
}
  80206f:	5d                   	pop    %ebp
  802070:	c3                   	ret    

00802071 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802074:	eb 09                	jmp    80207f <strncmp+0xe>
		n--, p++, q++;
  802076:	ff 4d 10             	decl   0x10(%ebp)
  802079:	ff 45 08             	incl   0x8(%ebp)
  80207c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80207f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802083:	74 17                	je     80209c <strncmp+0x2b>
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	8a 00                	mov    (%eax),%al
  80208a:	84 c0                	test   %al,%al
  80208c:	74 0e                	je     80209c <strncmp+0x2b>
  80208e:	8b 45 08             	mov    0x8(%ebp),%eax
  802091:	8a 10                	mov    (%eax),%dl
  802093:	8b 45 0c             	mov    0xc(%ebp),%eax
  802096:	8a 00                	mov    (%eax),%al
  802098:	38 c2                	cmp    %al,%dl
  80209a:	74 da                	je     802076 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80209c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020a0:	75 07                	jne    8020a9 <strncmp+0x38>
		return 0;
  8020a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a7:	eb 14                	jmp    8020bd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	8a 00                	mov    (%eax),%al
  8020ae:	0f b6 d0             	movzbl %al,%edx
  8020b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b4:	8a 00                	mov    (%eax),%al
  8020b6:	0f b6 c0             	movzbl %al,%eax
  8020b9:	29 c2                	sub    %eax,%edx
  8020bb:	89 d0                	mov    %edx,%eax
}
  8020bd:	5d                   	pop    %ebp
  8020be:	c3                   	ret    

008020bf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 04             	sub    $0x4,%esp
  8020c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020cb:	eb 12                	jmp    8020df <strchr+0x20>
		if (*s == c)
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	8a 00                	mov    (%eax),%al
  8020d2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8020d5:	75 05                	jne    8020dc <strchr+0x1d>
			return (char *) s;
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	eb 11                	jmp    8020ed <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8020dc:	ff 45 08             	incl   0x8(%ebp)
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	8a 00                	mov    (%eax),%al
  8020e4:	84 c0                	test   %al,%al
  8020e6:	75 e5                	jne    8020cd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8020e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 04             	sub    $0x4,%esp
  8020f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8020fb:	eb 0d                	jmp    80210a <strfind+0x1b>
		if (*s == c)
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	8a 00                	mov    (%eax),%al
  802102:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802105:	74 0e                	je     802115 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802107:	ff 45 08             	incl   0x8(%ebp)
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	8a 00                	mov    (%eax),%al
  80210f:	84 c0                	test   %al,%al
  802111:	75 ea                	jne    8020fd <strfind+0xe>
  802113:	eb 01                	jmp    802116 <strfind+0x27>
		if (*s == c)
			break;
  802115:	90                   	nop
	return (char *) s;
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802119:	c9                   	leave  
  80211a:	c3                   	ret    

0080211b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  802127:	8b 45 10             	mov    0x10(%ebp),%eax
  80212a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80212d:	eb 0e                	jmp    80213d <memset+0x22>
		*p++ = c;
  80212f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802132:	8d 50 01             	lea    0x1(%eax),%edx
  802135:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802138:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80213d:	ff 4d f8             	decl   -0x8(%ebp)
  802140:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802144:	79 e9                	jns    80212f <memset+0x14>
		*p++ = c;

	return v;
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802151:	8b 45 0c             	mov    0xc(%ebp),%eax
  802154:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80215d:	eb 16                	jmp    802175 <memcpy+0x2a>
		*d++ = *s++;
  80215f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802162:	8d 50 01             	lea    0x1(%eax),%edx
  802165:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802168:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80216b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80216e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802171:	8a 12                	mov    (%edx),%dl
  802173:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  802175:	8b 45 10             	mov    0x10(%ebp),%eax
  802178:	8d 50 ff             	lea    -0x1(%eax),%edx
  80217b:	89 55 10             	mov    %edx,0x10(%ebp)
  80217e:	85 c0                	test   %eax,%eax
  802180:	75 dd                	jne    80215f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802185:	c9                   	leave  
  802186:	c3                   	ret    

00802187 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80218d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802190:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802199:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80219c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80219f:	73 50                	jae    8021f1 <memmove+0x6a>
  8021a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a7:	01 d0                	add    %edx,%eax
  8021a9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8021ac:	76 43                	jbe    8021f1 <memmove+0x6a>
		s += n;
  8021ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8021b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8021ba:	eb 10                	jmp    8021cc <memmove+0x45>
			*--d = *--s;
  8021bc:	ff 4d f8             	decl   -0x8(%ebp)
  8021bf:	ff 4d fc             	decl   -0x4(%ebp)
  8021c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c5:	8a 10                	mov    (%eax),%dl
  8021c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021ca:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8021cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021d2:	89 55 10             	mov    %edx,0x10(%ebp)
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	75 e3                	jne    8021bc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8021d9:	eb 23                	jmp    8021fe <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8021db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021de:	8d 50 01             	lea    0x1(%eax),%edx
  8021e1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8021e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021e7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021ea:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8021ed:	8a 12                	mov    (%edx),%dl
  8021ef:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8021f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	75 dd                	jne    8021db <memmove+0x54>
			*d++ = *s++;

	return dst;
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80220f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802212:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802215:	eb 2a                	jmp    802241 <memcmp+0x3e>
		if (*s1 != *s2)
  802217:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80221a:	8a 10                	mov    (%eax),%dl
  80221c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80221f:	8a 00                	mov    (%eax),%al
  802221:	38 c2                	cmp    %al,%dl
  802223:	74 16                	je     80223b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802225:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802228:	8a 00                	mov    (%eax),%al
  80222a:	0f b6 d0             	movzbl %al,%edx
  80222d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802230:	8a 00                	mov    (%eax),%al
  802232:	0f b6 c0             	movzbl %al,%eax
  802235:	29 c2                	sub    %eax,%edx
  802237:	89 d0                	mov    %edx,%eax
  802239:	eb 18                	jmp    802253 <memcmp+0x50>
		s1++, s2++;
  80223b:	ff 45 fc             	incl   -0x4(%ebp)
  80223e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802241:	8b 45 10             	mov    0x10(%ebp),%eax
  802244:	8d 50 ff             	lea    -0x1(%eax),%edx
  802247:	89 55 10             	mov    %edx,0x10(%ebp)
  80224a:	85 c0                	test   %eax,%eax
  80224c:	75 c9                	jne    802217 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80224e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80225b:	8b 55 08             	mov    0x8(%ebp),%edx
  80225e:	8b 45 10             	mov    0x10(%ebp),%eax
  802261:	01 d0                	add    %edx,%eax
  802263:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802266:	eb 15                	jmp    80227d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802268:	8b 45 08             	mov    0x8(%ebp),%eax
  80226b:	8a 00                	mov    (%eax),%al
  80226d:	0f b6 d0             	movzbl %al,%edx
  802270:	8b 45 0c             	mov    0xc(%ebp),%eax
  802273:	0f b6 c0             	movzbl %al,%eax
  802276:	39 c2                	cmp    %eax,%edx
  802278:	74 0d                	je     802287 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80227a:	ff 45 08             	incl   0x8(%ebp)
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802283:	72 e3                	jb     802268 <memfind+0x13>
  802285:	eb 01                	jmp    802288 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802287:	90                   	nop
	return (void *) s;
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802293:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80229a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8022a1:	eb 03                	jmp    8022a6 <strtol+0x19>
		s++;
  8022a3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	8a 00                	mov    (%eax),%al
  8022ab:	3c 20                	cmp    $0x20,%al
  8022ad:	74 f4                	je     8022a3 <strtol+0x16>
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	8a 00                	mov    (%eax),%al
  8022b4:	3c 09                	cmp    $0x9,%al
  8022b6:	74 eb                	je     8022a3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	8a 00                	mov    (%eax),%al
  8022bd:	3c 2b                	cmp    $0x2b,%al
  8022bf:	75 05                	jne    8022c6 <strtol+0x39>
		s++;
  8022c1:	ff 45 08             	incl   0x8(%ebp)
  8022c4:	eb 13                	jmp    8022d9 <strtol+0x4c>
	else if (*s == '-')
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	8a 00                	mov    (%eax),%al
  8022cb:	3c 2d                	cmp    $0x2d,%al
  8022cd:	75 0a                	jne    8022d9 <strtol+0x4c>
		s++, neg = 1;
  8022cf:	ff 45 08             	incl   0x8(%ebp)
  8022d2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8022d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022dd:	74 06                	je     8022e5 <strtol+0x58>
  8022df:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8022e3:	75 20                	jne    802305 <strtol+0x78>
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	8a 00                	mov    (%eax),%al
  8022ea:	3c 30                	cmp    $0x30,%al
  8022ec:	75 17                	jne    802305 <strtol+0x78>
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	40                   	inc    %eax
  8022f2:	8a 00                	mov    (%eax),%al
  8022f4:	3c 78                	cmp    $0x78,%al
  8022f6:	75 0d                	jne    802305 <strtol+0x78>
		s += 2, base = 16;
  8022f8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8022fc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802303:	eb 28                	jmp    80232d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802305:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802309:	75 15                	jne    802320 <strtol+0x93>
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	8a 00                	mov    (%eax),%al
  802310:	3c 30                	cmp    $0x30,%al
  802312:	75 0c                	jne    802320 <strtol+0x93>
		s++, base = 8;
  802314:	ff 45 08             	incl   0x8(%ebp)
  802317:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80231e:	eb 0d                	jmp    80232d <strtol+0xa0>
	else if (base == 0)
  802320:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802324:	75 07                	jne    80232d <strtol+0xa0>
		base = 10;
  802326:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	8a 00                	mov    (%eax),%al
  802332:	3c 2f                	cmp    $0x2f,%al
  802334:	7e 19                	jle    80234f <strtol+0xc2>
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	8a 00                	mov    (%eax),%al
  80233b:	3c 39                	cmp    $0x39,%al
  80233d:	7f 10                	jg     80234f <strtol+0xc2>
			dig = *s - '0';
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	8a 00                	mov    (%eax),%al
  802344:	0f be c0             	movsbl %al,%eax
  802347:	83 e8 30             	sub    $0x30,%eax
  80234a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234d:	eb 42                	jmp    802391 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	8a 00                	mov    (%eax),%al
  802354:	3c 60                	cmp    $0x60,%al
  802356:	7e 19                	jle    802371 <strtol+0xe4>
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	8a 00                	mov    (%eax),%al
  80235d:	3c 7a                	cmp    $0x7a,%al
  80235f:	7f 10                	jg     802371 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802361:	8b 45 08             	mov    0x8(%ebp),%eax
  802364:	8a 00                	mov    (%eax),%al
  802366:	0f be c0             	movsbl %al,%eax
  802369:	83 e8 57             	sub    $0x57,%eax
  80236c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80236f:	eb 20                	jmp    802391 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	8a 00                	mov    (%eax),%al
  802376:	3c 40                	cmp    $0x40,%al
  802378:	7e 39                	jle    8023b3 <strtol+0x126>
  80237a:	8b 45 08             	mov    0x8(%ebp),%eax
  80237d:	8a 00                	mov    (%eax),%al
  80237f:	3c 5a                	cmp    $0x5a,%al
  802381:	7f 30                	jg     8023b3 <strtol+0x126>
			dig = *s - 'A' + 10;
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	8a 00                	mov    (%eax),%al
  802388:	0f be c0             	movsbl %al,%eax
  80238b:	83 e8 37             	sub    $0x37,%eax
  80238e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	3b 45 10             	cmp    0x10(%ebp),%eax
  802397:	7d 19                	jge    8023b2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802399:	ff 45 08             	incl   0x8(%ebp)
  80239c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80239f:	0f af 45 10          	imul   0x10(%ebp),%eax
  8023a3:	89 c2                	mov    %eax,%edx
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	01 d0                	add    %edx,%eax
  8023aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8023ad:	e9 7b ff ff ff       	jmp    80232d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8023b2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8023b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023b7:	74 08                	je     8023c1 <strtol+0x134>
		*endptr = (char *) s;
  8023b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8023bf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8023c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023c5:	74 07                	je     8023ce <strtol+0x141>
  8023c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023ca:	f7 d8                	neg    %eax
  8023cc:	eb 03                	jmp    8023d1 <strtol+0x144>
  8023ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8023d1:	c9                   	leave  
  8023d2:	c3                   	ret    

008023d3 <ltostr>:

void
ltostr(long value, char *str)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
  8023d6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8023d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8023e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8023e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023eb:	79 13                	jns    802400 <ltostr+0x2d>
	{
		neg = 1;
  8023ed:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8023f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8023fa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8023fd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802408:	99                   	cltd   
  802409:	f7 f9                	idiv   %ecx
  80240b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80240e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802411:	8d 50 01             	lea    0x1(%eax),%edx
  802414:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802417:	89 c2                	mov    %eax,%edx
  802419:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241c:	01 d0                	add    %edx,%eax
  80241e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802421:	83 c2 30             	add    $0x30,%edx
  802424:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802426:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802429:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80242e:	f7 e9                	imul   %ecx
  802430:	c1 fa 02             	sar    $0x2,%edx
  802433:	89 c8                	mov    %ecx,%eax
  802435:	c1 f8 1f             	sar    $0x1f,%eax
  802438:	29 c2                	sub    %eax,%edx
  80243a:	89 d0                	mov    %edx,%eax
  80243c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80243f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802442:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802447:	f7 e9                	imul   %ecx
  802449:	c1 fa 02             	sar    $0x2,%edx
  80244c:	89 c8                	mov    %ecx,%eax
  80244e:	c1 f8 1f             	sar    $0x1f,%eax
  802451:	29 c2                	sub    %eax,%edx
  802453:	89 d0                	mov    %edx,%eax
  802455:	c1 e0 02             	shl    $0x2,%eax
  802458:	01 d0                	add    %edx,%eax
  80245a:	01 c0                	add    %eax,%eax
  80245c:	29 c1                	sub    %eax,%ecx
  80245e:	89 ca                	mov    %ecx,%edx
  802460:	85 d2                	test   %edx,%edx
  802462:	75 9c                	jne    802400 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802464:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80246b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80246e:	48                   	dec    %eax
  80246f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802472:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802476:	74 3d                	je     8024b5 <ltostr+0xe2>
		start = 1 ;
  802478:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80247f:	eb 34                	jmp    8024b5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802484:	8b 45 0c             	mov    0xc(%ebp),%eax
  802487:	01 d0                	add    %edx,%eax
  802489:	8a 00                	mov    (%eax),%al
  80248b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80248e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802491:	8b 45 0c             	mov    0xc(%ebp),%eax
  802494:	01 c2                	add    %eax,%edx
  802496:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802499:	8b 45 0c             	mov    0xc(%ebp),%eax
  80249c:	01 c8                	add    %ecx,%eax
  80249e:	8a 00                	mov    (%eax),%al
  8024a0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8024a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a8:	01 c2                	add    %eax,%edx
  8024aa:	8a 45 eb             	mov    -0x15(%ebp),%al
  8024ad:	88 02                	mov    %al,(%edx)
		start++ ;
  8024af:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8024b2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024bb:	7c c4                	jl     802481 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8024bd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8024c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c3:	01 d0                	add    %edx,%eax
  8024c5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8024c8:	90                   	nop
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
  8024ce:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8024d1:	ff 75 08             	pushl  0x8(%ebp)
  8024d4:	e8 54 fa ff ff       	call   801f2d <strlen>
  8024d9:	83 c4 04             	add    $0x4,%esp
  8024dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8024df:	ff 75 0c             	pushl  0xc(%ebp)
  8024e2:	e8 46 fa ff ff       	call   801f2d <strlen>
  8024e7:	83 c4 04             	add    $0x4,%esp
  8024ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8024ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8024f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024fb:	eb 17                	jmp    802514 <strcconcat+0x49>
		final[s] = str1[s] ;
  8024fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802500:	8b 45 10             	mov    0x10(%ebp),%eax
  802503:	01 c2                	add    %eax,%edx
  802505:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802508:	8b 45 08             	mov    0x8(%ebp),%eax
  80250b:	01 c8                	add    %ecx,%eax
  80250d:	8a 00                	mov    (%eax),%al
  80250f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802511:	ff 45 fc             	incl   -0x4(%ebp)
  802514:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802517:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80251a:	7c e1                	jl     8024fd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80251c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802523:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80252a:	eb 1f                	jmp    80254b <strcconcat+0x80>
		final[s++] = str2[i] ;
  80252c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80252f:	8d 50 01             	lea    0x1(%eax),%edx
  802532:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802535:	89 c2                	mov    %eax,%edx
  802537:	8b 45 10             	mov    0x10(%ebp),%eax
  80253a:	01 c2                	add    %eax,%edx
  80253c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80253f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802542:	01 c8                	add    %ecx,%eax
  802544:	8a 00                	mov    (%eax),%al
  802546:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802548:	ff 45 f8             	incl   -0x8(%ebp)
  80254b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80254e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802551:	7c d9                	jl     80252c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802553:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802556:	8b 45 10             	mov    0x10(%ebp),%eax
  802559:	01 d0                	add    %edx,%eax
  80255b:	c6 00 00             	movb   $0x0,(%eax)
}
  80255e:	90                   	nop
  80255f:	c9                   	leave  
  802560:	c3                   	ret    

00802561 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802564:	8b 45 14             	mov    0x14(%ebp),%eax
  802567:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80256d:	8b 45 14             	mov    0x14(%ebp),%eax
  802570:	8b 00                	mov    (%eax),%eax
  802572:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802579:	8b 45 10             	mov    0x10(%ebp),%eax
  80257c:	01 d0                	add    %edx,%eax
  80257e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802584:	eb 0c                	jmp    802592 <strsplit+0x31>
			*string++ = 0;
  802586:	8b 45 08             	mov    0x8(%ebp),%eax
  802589:	8d 50 01             	lea    0x1(%eax),%edx
  80258c:	89 55 08             	mov    %edx,0x8(%ebp)
  80258f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802592:	8b 45 08             	mov    0x8(%ebp),%eax
  802595:	8a 00                	mov    (%eax),%al
  802597:	84 c0                	test   %al,%al
  802599:	74 18                	je     8025b3 <strsplit+0x52>
  80259b:	8b 45 08             	mov    0x8(%ebp),%eax
  80259e:	8a 00                	mov    (%eax),%al
  8025a0:	0f be c0             	movsbl %al,%eax
  8025a3:	50                   	push   %eax
  8025a4:	ff 75 0c             	pushl  0xc(%ebp)
  8025a7:	e8 13 fb ff ff       	call   8020bf <strchr>
  8025ac:	83 c4 08             	add    $0x8,%esp
  8025af:	85 c0                	test   %eax,%eax
  8025b1:	75 d3                	jne    802586 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	8a 00                	mov    (%eax),%al
  8025b8:	84 c0                	test   %al,%al
  8025ba:	74 5a                	je     802616 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8025bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8025bf:	8b 00                	mov    (%eax),%eax
  8025c1:	83 f8 0f             	cmp    $0xf,%eax
  8025c4:	75 07                	jne    8025cd <strsplit+0x6c>
		{
			return 0;
  8025c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cb:	eb 66                	jmp    802633 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8025cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8025d0:	8b 00                	mov    (%eax),%eax
  8025d2:	8d 48 01             	lea    0x1(%eax),%ecx
  8025d5:	8b 55 14             	mov    0x14(%ebp),%edx
  8025d8:	89 0a                	mov    %ecx,(%edx)
  8025da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8025e4:	01 c2                	add    %eax,%edx
  8025e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8025eb:	eb 03                	jmp    8025f0 <strsplit+0x8f>
			string++;
  8025ed:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8025f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f3:	8a 00                	mov    (%eax),%al
  8025f5:	84 c0                	test   %al,%al
  8025f7:	74 8b                	je     802584 <strsplit+0x23>
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	8a 00                	mov    (%eax),%al
  8025fe:	0f be c0             	movsbl %al,%eax
  802601:	50                   	push   %eax
  802602:	ff 75 0c             	pushl  0xc(%ebp)
  802605:	e8 b5 fa ff ff       	call   8020bf <strchr>
  80260a:	83 c4 08             	add    $0x8,%esp
  80260d:	85 c0                	test   %eax,%eax
  80260f:	74 dc                	je     8025ed <strsplit+0x8c>
			string++;
	}
  802611:	e9 6e ff ff ff       	jmp    802584 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802616:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802617:	8b 45 14             	mov    0x14(%ebp),%eax
  80261a:	8b 00                	mov    (%eax),%eax
  80261c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802623:	8b 45 10             	mov    0x10(%ebp),%eax
  802626:	01 d0                	add    %edx,%eax
  802628:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80262e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802633:	c9                   	leave  
  802634:	c3                   	ret    

00802635 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
  802638:	57                   	push   %edi
  802639:	56                   	push   %esi
  80263a:	53                   	push   %ebx
  80263b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	8b 55 0c             	mov    0xc(%ebp),%edx
  802644:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802647:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80264a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80264d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802650:	cd 30                	int    $0x30
  802652:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802655:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802658:	83 c4 10             	add    $0x10,%esp
  80265b:	5b                   	pop    %ebx
  80265c:	5e                   	pop    %esi
  80265d:	5f                   	pop    %edi
  80265e:	5d                   	pop    %ebp
  80265f:	c3                   	ret    

00802660 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
  802663:	83 ec 04             	sub    $0x4,%esp
  802666:	8b 45 10             	mov    0x10(%ebp),%eax
  802669:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80266c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802670:	8b 45 08             	mov    0x8(%ebp),%eax
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	52                   	push   %edx
  802678:	ff 75 0c             	pushl  0xc(%ebp)
  80267b:	50                   	push   %eax
  80267c:	6a 00                	push   $0x0
  80267e:	e8 b2 ff ff ff       	call   802635 <syscall>
  802683:	83 c4 18             	add    $0x18,%esp
}
  802686:	90                   	nop
  802687:	c9                   	leave  
  802688:	c3                   	ret    

00802689 <sys_cgetc>:

int
sys_cgetc(void)
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 01                	push   $0x1
  802698:	e8 98 ff ff ff       	call   802635 <syscall>
  80269d:	83 c4 18             	add    $0x18,%esp
}
  8026a0:	c9                   	leave  
  8026a1:	c3                   	ret    

008026a2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8026a2:	55                   	push   %ebp
  8026a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8026a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	52                   	push   %edx
  8026b2:	50                   	push   %eax
  8026b3:	6a 05                	push   $0x5
  8026b5:	e8 7b ff ff ff       	call   802635 <syscall>
  8026ba:	83 c4 18             	add    $0x18,%esp
}
  8026bd:	c9                   	leave  
  8026be:	c3                   	ret    

008026bf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8026bf:	55                   	push   %ebp
  8026c0:	89 e5                	mov    %esp,%ebp
  8026c2:	56                   	push   %esi
  8026c3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8026c4:	8b 75 18             	mov    0x18(%ebp),%esi
  8026c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d3:	56                   	push   %esi
  8026d4:	53                   	push   %ebx
  8026d5:	51                   	push   %ecx
  8026d6:	52                   	push   %edx
  8026d7:	50                   	push   %eax
  8026d8:	6a 06                	push   $0x6
  8026da:	e8 56 ff ff ff       	call   802635 <syscall>
  8026df:	83 c4 18             	add    $0x18,%esp
}
  8026e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026e5:	5b                   	pop    %ebx
  8026e6:	5e                   	pop    %esi
  8026e7:	5d                   	pop    %ebp
  8026e8:	c3                   	ret    

008026e9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8026e9:	55                   	push   %ebp
  8026ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8026ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	52                   	push   %edx
  8026f9:	50                   	push   %eax
  8026fa:	6a 07                	push   $0x7
  8026fc:	e8 34 ff ff ff       	call   802635 <syscall>
  802701:	83 c4 18             	add    $0x18,%esp
}
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802709:	6a 00                	push   $0x0
  80270b:	6a 00                	push   $0x0
  80270d:	6a 00                	push   $0x0
  80270f:	ff 75 0c             	pushl  0xc(%ebp)
  802712:	ff 75 08             	pushl  0x8(%ebp)
  802715:	6a 08                	push   $0x8
  802717:	e8 19 ff ff ff       	call   802635 <syscall>
  80271c:	83 c4 18             	add    $0x18,%esp
}
  80271f:	c9                   	leave  
  802720:	c3                   	ret    

00802721 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802721:	55                   	push   %ebp
  802722:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	6a 00                	push   $0x0
  80272a:	6a 00                	push   $0x0
  80272c:	6a 00                	push   $0x0
  80272e:	6a 09                	push   $0x9
  802730:	e8 00 ff ff ff       	call   802635 <syscall>
  802735:	83 c4 18             	add    $0x18,%esp
}
  802738:	c9                   	leave  
  802739:	c3                   	ret    

0080273a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80273a:	55                   	push   %ebp
  80273b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	6a 00                	push   $0x0
  802747:	6a 0a                	push   $0xa
  802749:	e8 e7 fe ff ff       	call   802635 <syscall>
  80274e:	83 c4 18             	add    $0x18,%esp
}
  802751:	c9                   	leave  
  802752:	c3                   	ret    

00802753 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802753:	55                   	push   %ebp
  802754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	6a 00                	push   $0x0
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	6a 0b                	push   $0xb
  802762:	e8 ce fe ff ff       	call   802635 <syscall>
  802767:	83 c4 18             	add    $0x18,%esp
}
  80276a:	c9                   	leave  
  80276b:	c3                   	ret    

0080276c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80276c:	55                   	push   %ebp
  80276d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	ff 75 0c             	pushl  0xc(%ebp)
  802778:	ff 75 08             	pushl  0x8(%ebp)
  80277b:	6a 0f                	push   $0xf
  80277d:	e8 b3 fe ff ff       	call   802635 <syscall>
  802782:	83 c4 18             	add    $0x18,%esp
	return;
  802785:	90                   	nop
}
  802786:	c9                   	leave  
  802787:	c3                   	ret    

00802788 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802788:	55                   	push   %ebp
  802789:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80278b:	6a 00                	push   $0x0
  80278d:	6a 00                	push   $0x0
  80278f:	6a 00                	push   $0x0
  802791:	ff 75 0c             	pushl  0xc(%ebp)
  802794:	ff 75 08             	pushl  0x8(%ebp)
  802797:	6a 10                	push   $0x10
  802799:	e8 97 fe ff ff       	call   802635 <syscall>
  80279e:	83 c4 18             	add    $0x18,%esp
	return ;
  8027a1:	90                   	nop
}
  8027a2:	c9                   	leave  
  8027a3:	c3                   	ret    

008027a4 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8027a4:	55                   	push   %ebp
  8027a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	ff 75 10             	pushl  0x10(%ebp)
  8027ae:	ff 75 0c             	pushl  0xc(%ebp)
  8027b1:	ff 75 08             	pushl  0x8(%ebp)
  8027b4:	6a 11                	push   $0x11
  8027b6:	e8 7a fe ff ff       	call   802635 <syscall>
  8027bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8027be:	90                   	nop
}
  8027bf:	c9                   	leave  
  8027c0:	c3                   	ret    

008027c1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8027c1:	55                   	push   %ebp
  8027c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	6a 00                	push   $0x0
  8027ca:	6a 00                	push   $0x0
  8027cc:	6a 00                	push   $0x0
  8027ce:	6a 0c                	push   $0xc
  8027d0:	e8 60 fe ff ff       	call   802635 <syscall>
  8027d5:	83 c4 18             	add    $0x18,%esp
}
  8027d8:	c9                   	leave  
  8027d9:	c3                   	ret    

008027da <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 00                	push   $0x0
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 00                	push   $0x0
  8027e5:	ff 75 08             	pushl  0x8(%ebp)
  8027e8:	6a 0d                	push   $0xd
  8027ea:	e8 46 fe ff ff       	call   802635 <syscall>
  8027ef:	83 c4 18             	add    $0x18,%esp
}
  8027f2:	c9                   	leave  
  8027f3:	c3                   	ret    

008027f4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	6a 00                	push   $0x0
  8027ff:	6a 00                	push   $0x0
  802801:	6a 0e                	push   $0xe
  802803:	e8 2d fe ff ff       	call   802635 <syscall>
  802808:	83 c4 18             	add    $0x18,%esp
}
  80280b:	90                   	nop
  80280c:	c9                   	leave  
  80280d:	c3                   	ret    

0080280e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80280e:	55                   	push   %ebp
  80280f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	6a 00                	push   $0x0
  802819:	6a 00                	push   $0x0
  80281b:	6a 13                	push   $0x13
  80281d:	e8 13 fe ff ff       	call   802635 <syscall>
  802822:	83 c4 18             	add    $0x18,%esp
}
  802825:	90                   	nop
  802826:	c9                   	leave  
  802827:	c3                   	ret    

00802828 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802828:	55                   	push   %ebp
  802829:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80282b:	6a 00                	push   $0x0
  80282d:	6a 00                	push   $0x0
  80282f:	6a 00                	push   $0x0
  802831:	6a 00                	push   $0x0
  802833:	6a 00                	push   $0x0
  802835:	6a 14                	push   $0x14
  802837:	e8 f9 fd ff ff       	call   802635 <syscall>
  80283c:	83 c4 18             	add    $0x18,%esp
}
  80283f:	90                   	nop
  802840:	c9                   	leave  
  802841:	c3                   	ret    

00802842 <sys_cputc>:


void
sys_cputc(const char c)
{
  802842:	55                   	push   %ebp
  802843:	89 e5                	mov    %esp,%ebp
  802845:	83 ec 04             	sub    $0x4,%esp
  802848:	8b 45 08             	mov    0x8(%ebp),%eax
  80284b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80284e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802852:	6a 00                	push   $0x0
  802854:	6a 00                	push   $0x0
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	50                   	push   %eax
  80285b:	6a 15                	push   $0x15
  80285d:	e8 d3 fd ff ff       	call   802635 <syscall>
  802862:	83 c4 18             	add    $0x18,%esp
}
  802865:	90                   	nop
  802866:	c9                   	leave  
  802867:	c3                   	ret    

00802868 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802868:	55                   	push   %ebp
  802869:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80286b:	6a 00                	push   $0x0
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	6a 00                	push   $0x0
  802873:	6a 00                	push   $0x0
  802875:	6a 16                	push   $0x16
  802877:	e8 b9 fd ff ff       	call   802635 <syscall>
  80287c:	83 c4 18             	add    $0x18,%esp
}
  80287f:	90                   	nop
  802880:	c9                   	leave  
  802881:	c3                   	ret    

00802882 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802882:	55                   	push   %ebp
  802883:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802885:	8b 45 08             	mov    0x8(%ebp),%eax
  802888:	6a 00                	push   $0x0
  80288a:	6a 00                	push   $0x0
  80288c:	6a 00                	push   $0x0
  80288e:	ff 75 0c             	pushl  0xc(%ebp)
  802891:	50                   	push   %eax
  802892:	6a 17                	push   $0x17
  802894:	e8 9c fd ff ff       	call   802635 <syscall>
  802899:	83 c4 18             	add    $0x18,%esp
}
  80289c:	c9                   	leave  
  80289d:	c3                   	ret    

0080289e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80289e:	55                   	push   %ebp
  80289f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8028a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a7:	6a 00                	push   $0x0
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 00                	push   $0x0
  8028ad:	52                   	push   %edx
  8028ae:	50                   	push   %eax
  8028af:	6a 1a                	push   $0x1a
  8028b1:	e8 7f fd ff ff       	call   802635 <syscall>
  8028b6:	83 c4 18             	add    $0x18,%esp
}
  8028b9:	c9                   	leave  
  8028ba:	c3                   	ret    

008028bb <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8028bb:	55                   	push   %ebp
  8028bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8028be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	6a 00                	push   $0x0
  8028c6:	6a 00                	push   $0x0
  8028c8:	6a 00                	push   $0x0
  8028ca:	52                   	push   %edx
  8028cb:	50                   	push   %eax
  8028cc:	6a 18                	push   $0x18
  8028ce:	e8 62 fd ff ff       	call   802635 <syscall>
  8028d3:	83 c4 18             	add    $0x18,%esp
}
  8028d6:	90                   	nop
  8028d7:	c9                   	leave  
  8028d8:	c3                   	ret    

008028d9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8028d9:	55                   	push   %ebp
  8028da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8028dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028df:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e2:	6a 00                	push   $0x0
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 00                	push   $0x0
  8028e8:	52                   	push   %edx
  8028e9:	50                   	push   %eax
  8028ea:	6a 19                	push   $0x19
  8028ec:	e8 44 fd ff ff       	call   802635 <syscall>
  8028f1:	83 c4 18             	add    $0x18,%esp
}
  8028f4:	90                   	nop
  8028f5:	c9                   	leave  
  8028f6:	c3                   	ret    

008028f7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8028f7:	55                   	push   %ebp
  8028f8:	89 e5                	mov    %esp,%ebp
  8028fa:	83 ec 04             	sub    $0x4,%esp
  8028fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802900:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802903:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802906:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80290a:	8b 45 08             	mov    0x8(%ebp),%eax
  80290d:	6a 00                	push   $0x0
  80290f:	51                   	push   %ecx
  802910:	52                   	push   %edx
  802911:	ff 75 0c             	pushl  0xc(%ebp)
  802914:	50                   	push   %eax
  802915:	6a 1b                	push   $0x1b
  802917:	e8 19 fd ff ff       	call   802635 <syscall>
  80291c:	83 c4 18             	add    $0x18,%esp
}
  80291f:	c9                   	leave  
  802920:	c3                   	ret    

00802921 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802921:	55                   	push   %ebp
  802922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802924:	8b 55 0c             	mov    0xc(%ebp),%edx
  802927:	8b 45 08             	mov    0x8(%ebp),%eax
  80292a:	6a 00                	push   $0x0
  80292c:	6a 00                	push   $0x0
  80292e:	6a 00                	push   $0x0
  802930:	52                   	push   %edx
  802931:	50                   	push   %eax
  802932:	6a 1c                	push   $0x1c
  802934:	e8 fc fc ff ff       	call   802635 <syscall>
  802939:	83 c4 18             	add    $0x18,%esp
}
  80293c:	c9                   	leave  
  80293d:	c3                   	ret    

0080293e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80293e:	55                   	push   %ebp
  80293f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802941:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802944:	8b 55 0c             	mov    0xc(%ebp),%edx
  802947:	8b 45 08             	mov    0x8(%ebp),%eax
  80294a:	6a 00                	push   $0x0
  80294c:	6a 00                	push   $0x0
  80294e:	51                   	push   %ecx
  80294f:	52                   	push   %edx
  802950:	50                   	push   %eax
  802951:	6a 1d                	push   $0x1d
  802953:	e8 dd fc ff ff       	call   802635 <syscall>
  802958:	83 c4 18             	add    $0x18,%esp
}
  80295b:	c9                   	leave  
  80295c:	c3                   	ret    

0080295d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80295d:	55                   	push   %ebp
  80295e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802960:	8b 55 0c             	mov    0xc(%ebp),%edx
  802963:	8b 45 08             	mov    0x8(%ebp),%eax
  802966:	6a 00                	push   $0x0
  802968:	6a 00                	push   $0x0
  80296a:	6a 00                	push   $0x0
  80296c:	52                   	push   %edx
  80296d:	50                   	push   %eax
  80296e:	6a 1e                	push   $0x1e
  802970:	e8 c0 fc ff ff       	call   802635 <syscall>
  802975:	83 c4 18             	add    $0x18,%esp
}
  802978:	c9                   	leave  
  802979:	c3                   	ret    

0080297a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80297a:	55                   	push   %ebp
  80297b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80297d:	6a 00                	push   $0x0
  80297f:	6a 00                	push   $0x0
  802981:	6a 00                	push   $0x0
  802983:	6a 00                	push   $0x0
  802985:	6a 00                	push   $0x0
  802987:	6a 1f                	push   $0x1f
  802989:	e8 a7 fc ff ff       	call   802635 <syscall>
  80298e:	83 c4 18             	add    $0x18,%esp
}
  802991:	c9                   	leave  
  802992:	c3                   	ret    

00802993 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802993:	55                   	push   %ebp
  802994:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802996:	8b 45 08             	mov    0x8(%ebp),%eax
  802999:	6a 00                	push   $0x0
  80299b:	ff 75 14             	pushl  0x14(%ebp)
  80299e:	ff 75 10             	pushl  0x10(%ebp)
  8029a1:	ff 75 0c             	pushl  0xc(%ebp)
  8029a4:	50                   	push   %eax
  8029a5:	6a 20                	push   $0x20
  8029a7:	e8 89 fc ff ff       	call   802635 <syscall>
  8029ac:	83 c4 18             	add    $0x18,%esp
}
  8029af:	c9                   	leave  
  8029b0:	c3                   	ret    

008029b1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8029b1:	55                   	push   %ebp
  8029b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	6a 00                	push   $0x0
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 00                	push   $0x0
  8029bd:	6a 00                	push   $0x0
  8029bf:	50                   	push   %eax
  8029c0:	6a 21                	push   $0x21
  8029c2:	e8 6e fc ff ff       	call   802635 <syscall>
  8029c7:	83 c4 18             	add    $0x18,%esp
}
  8029ca:	90                   	nop
  8029cb:	c9                   	leave  
  8029cc:	c3                   	ret    

008029cd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8029cd:	55                   	push   %ebp
  8029ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8029d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d3:	6a 00                	push   $0x0
  8029d5:	6a 00                	push   $0x0
  8029d7:	6a 00                	push   $0x0
  8029d9:	6a 00                	push   $0x0
  8029db:	50                   	push   %eax
  8029dc:	6a 22                	push   $0x22
  8029de:	e8 52 fc ff ff       	call   802635 <syscall>
  8029e3:	83 c4 18             	add    $0x18,%esp
}
  8029e6:	c9                   	leave  
  8029e7:	c3                   	ret    

008029e8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8029e8:	55                   	push   %ebp
  8029e9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8029eb:	6a 00                	push   $0x0
  8029ed:	6a 00                	push   $0x0
  8029ef:	6a 00                	push   $0x0
  8029f1:	6a 00                	push   $0x0
  8029f3:	6a 00                	push   $0x0
  8029f5:	6a 02                	push   $0x2
  8029f7:	e8 39 fc ff ff       	call   802635 <syscall>
  8029fc:	83 c4 18             	add    $0x18,%esp
}
  8029ff:	c9                   	leave  
  802a00:	c3                   	ret    

00802a01 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802a01:	55                   	push   %ebp
  802a02:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	6a 00                	push   $0x0
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 00                	push   $0x0
  802a0e:	6a 03                	push   $0x3
  802a10:	e8 20 fc ff ff       	call   802635 <syscall>
  802a15:	83 c4 18             	add    $0x18,%esp
}
  802a18:	c9                   	leave  
  802a19:	c3                   	ret    

00802a1a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802a1a:	55                   	push   %ebp
  802a1b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802a1d:	6a 00                	push   $0x0
  802a1f:	6a 00                	push   $0x0
  802a21:	6a 00                	push   $0x0
  802a23:	6a 00                	push   $0x0
  802a25:	6a 00                	push   $0x0
  802a27:	6a 04                	push   $0x4
  802a29:	e8 07 fc ff ff       	call   802635 <syscall>
  802a2e:	83 c4 18             	add    $0x18,%esp
}
  802a31:	c9                   	leave  
  802a32:	c3                   	ret    

00802a33 <sys_exit_env>:


void sys_exit_env(void)
{
  802a33:	55                   	push   %ebp
  802a34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802a36:	6a 00                	push   $0x0
  802a38:	6a 00                	push   $0x0
  802a3a:	6a 00                	push   $0x0
  802a3c:	6a 00                	push   $0x0
  802a3e:	6a 00                	push   $0x0
  802a40:	6a 23                	push   $0x23
  802a42:	e8 ee fb ff ff       	call   802635 <syscall>
  802a47:	83 c4 18             	add    $0x18,%esp
}
  802a4a:	90                   	nop
  802a4b:	c9                   	leave  
  802a4c:	c3                   	ret    

00802a4d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802a4d:	55                   	push   %ebp
  802a4e:	89 e5                	mov    %esp,%ebp
  802a50:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802a53:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a56:	8d 50 04             	lea    0x4(%eax),%edx
  802a59:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802a5c:	6a 00                	push   $0x0
  802a5e:	6a 00                	push   $0x0
  802a60:	6a 00                	push   $0x0
  802a62:	52                   	push   %edx
  802a63:	50                   	push   %eax
  802a64:	6a 24                	push   $0x24
  802a66:	e8 ca fb ff ff       	call   802635 <syscall>
  802a6b:	83 c4 18             	add    $0x18,%esp
	return result;
  802a6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802a74:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802a77:	89 01                	mov    %eax,(%ecx)
  802a79:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7f:	c9                   	leave  
  802a80:	c2 04 00             	ret    $0x4

00802a83 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802a83:	55                   	push   %ebp
  802a84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802a86:	6a 00                	push   $0x0
  802a88:	6a 00                	push   $0x0
  802a8a:	ff 75 10             	pushl  0x10(%ebp)
  802a8d:	ff 75 0c             	pushl  0xc(%ebp)
  802a90:	ff 75 08             	pushl  0x8(%ebp)
  802a93:	6a 12                	push   $0x12
  802a95:	e8 9b fb ff ff       	call   802635 <syscall>
  802a9a:	83 c4 18             	add    $0x18,%esp
	return ;
  802a9d:	90                   	nop
}
  802a9e:	c9                   	leave  
  802a9f:	c3                   	ret    

00802aa0 <sys_rcr2>:
uint32 sys_rcr2()
{
  802aa0:	55                   	push   %ebp
  802aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802aa3:	6a 00                	push   $0x0
  802aa5:	6a 00                	push   $0x0
  802aa7:	6a 00                	push   $0x0
  802aa9:	6a 00                	push   $0x0
  802aab:	6a 00                	push   $0x0
  802aad:	6a 25                	push   $0x25
  802aaf:	e8 81 fb ff ff       	call   802635 <syscall>
  802ab4:	83 c4 18             	add    $0x18,%esp
}
  802ab7:	c9                   	leave  
  802ab8:	c3                   	ret    

00802ab9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802ab9:	55                   	push   %ebp
  802aba:	89 e5                	mov    %esp,%ebp
  802abc:	83 ec 04             	sub    $0x4,%esp
  802abf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ac5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802ac9:	6a 00                	push   $0x0
  802acb:	6a 00                	push   $0x0
  802acd:	6a 00                	push   $0x0
  802acf:	6a 00                	push   $0x0
  802ad1:	50                   	push   %eax
  802ad2:	6a 26                	push   $0x26
  802ad4:	e8 5c fb ff ff       	call   802635 <syscall>
  802ad9:	83 c4 18             	add    $0x18,%esp
	return ;
  802adc:	90                   	nop
}
  802add:	c9                   	leave  
  802ade:	c3                   	ret    

00802adf <rsttst>:
void rsttst()
{
  802adf:	55                   	push   %ebp
  802ae0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802ae2:	6a 00                	push   $0x0
  802ae4:	6a 00                	push   $0x0
  802ae6:	6a 00                	push   $0x0
  802ae8:	6a 00                	push   $0x0
  802aea:	6a 00                	push   $0x0
  802aec:	6a 28                	push   $0x28
  802aee:	e8 42 fb ff ff       	call   802635 <syscall>
  802af3:	83 c4 18             	add    $0x18,%esp
	return ;
  802af6:	90                   	nop
}
  802af7:	c9                   	leave  
  802af8:	c3                   	ret    

00802af9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802af9:	55                   	push   %ebp
  802afa:	89 e5                	mov    %esp,%ebp
  802afc:	83 ec 04             	sub    $0x4,%esp
  802aff:	8b 45 14             	mov    0x14(%ebp),%eax
  802b02:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802b05:	8b 55 18             	mov    0x18(%ebp),%edx
  802b08:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b0c:	52                   	push   %edx
  802b0d:	50                   	push   %eax
  802b0e:	ff 75 10             	pushl  0x10(%ebp)
  802b11:	ff 75 0c             	pushl  0xc(%ebp)
  802b14:	ff 75 08             	pushl  0x8(%ebp)
  802b17:	6a 27                	push   $0x27
  802b19:	e8 17 fb ff ff       	call   802635 <syscall>
  802b1e:	83 c4 18             	add    $0x18,%esp
	return ;
  802b21:	90                   	nop
}
  802b22:	c9                   	leave  
  802b23:	c3                   	ret    

00802b24 <chktst>:
void chktst(uint32 n)
{
  802b24:	55                   	push   %ebp
  802b25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802b27:	6a 00                	push   $0x0
  802b29:	6a 00                	push   $0x0
  802b2b:	6a 00                	push   $0x0
  802b2d:	6a 00                	push   $0x0
  802b2f:	ff 75 08             	pushl  0x8(%ebp)
  802b32:	6a 29                	push   $0x29
  802b34:	e8 fc fa ff ff       	call   802635 <syscall>
  802b39:	83 c4 18             	add    $0x18,%esp
	return ;
  802b3c:	90                   	nop
}
  802b3d:	c9                   	leave  
  802b3e:	c3                   	ret    

00802b3f <inctst>:

void inctst()
{
  802b3f:	55                   	push   %ebp
  802b40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802b42:	6a 00                	push   $0x0
  802b44:	6a 00                	push   $0x0
  802b46:	6a 00                	push   $0x0
  802b48:	6a 00                	push   $0x0
  802b4a:	6a 00                	push   $0x0
  802b4c:	6a 2a                	push   $0x2a
  802b4e:	e8 e2 fa ff ff       	call   802635 <syscall>
  802b53:	83 c4 18             	add    $0x18,%esp
	return ;
  802b56:	90                   	nop
}
  802b57:	c9                   	leave  
  802b58:	c3                   	ret    

00802b59 <gettst>:
uint32 gettst()
{
  802b59:	55                   	push   %ebp
  802b5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802b5c:	6a 00                	push   $0x0
  802b5e:	6a 00                	push   $0x0
  802b60:	6a 00                	push   $0x0
  802b62:	6a 00                	push   $0x0
  802b64:	6a 00                	push   $0x0
  802b66:	6a 2b                	push   $0x2b
  802b68:	e8 c8 fa ff ff       	call   802635 <syscall>
  802b6d:	83 c4 18             	add    $0x18,%esp
}
  802b70:	c9                   	leave  
  802b71:	c3                   	ret    

00802b72 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802b72:	55                   	push   %ebp
  802b73:	89 e5                	mov    %esp,%ebp
  802b75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802b78:	6a 00                	push   $0x0
  802b7a:	6a 00                	push   $0x0
  802b7c:	6a 00                	push   $0x0
  802b7e:	6a 00                	push   $0x0
  802b80:	6a 00                	push   $0x0
  802b82:	6a 2c                	push   $0x2c
  802b84:	e8 ac fa ff ff       	call   802635 <syscall>
  802b89:	83 c4 18             	add    $0x18,%esp
  802b8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802b8f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802b93:	75 07                	jne    802b9c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802b95:	b8 01 00 00 00       	mov    $0x1,%eax
  802b9a:	eb 05                	jmp    802ba1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802b9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ba1:	c9                   	leave  
  802ba2:	c3                   	ret    

00802ba3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802ba3:	55                   	push   %ebp
  802ba4:	89 e5                	mov    %esp,%ebp
  802ba6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802ba9:	6a 00                	push   $0x0
  802bab:	6a 00                	push   $0x0
  802bad:	6a 00                	push   $0x0
  802baf:	6a 00                	push   $0x0
  802bb1:	6a 00                	push   $0x0
  802bb3:	6a 2c                	push   $0x2c
  802bb5:	e8 7b fa ff ff       	call   802635 <syscall>
  802bba:	83 c4 18             	add    $0x18,%esp
  802bbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802bc0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802bc4:	75 07                	jne    802bcd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802bc6:	b8 01 00 00 00       	mov    $0x1,%eax
  802bcb:	eb 05                	jmp    802bd2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802bcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bd2:	c9                   	leave  
  802bd3:	c3                   	ret    

00802bd4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802bd4:	55                   	push   %ebp
  802bd5:	89 e5                	mov    %esp,%ebp
  802bd7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802bda:	6a 00                	push   $0x0
  802bdc:	6a 00                	push   $0x0
  802bde:	6a 00                	push   $0x0
  802be0:	6a 00                	push   $0x0
  802be2:	6a 00                	push   $0x0
  802be4:	6a 2c                	push   $0x2c
  802be6:	e8 4a fa ff ff       	call   802635 <syscall>
  802beb:	83 c4 18             	add    $0x18,%esp
  802bee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802bf1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802bf5:	75 07                	jne    802bfe <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802bf7:	b8 01 00 00 00       	mov    $0x1,%eax
  802bfc:	eb 05                	jmp    802c03 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c03:	c9                   	leave  
  802c04:	c3                   	ret    

00802c05 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802c05:	55                   	push   %ebp
  802c06:	89 e5                	mov    %esp,%ebp
  802c08:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c0b:	6a 00                	push   $0x0
  802c0d:	6a 00                	push   $0x0
  802c0f:	6a 00                	push   $0x0
  802c11:	6a 00                	push   $0x0
  802c13:	6a 00                	push   $0x0
  802c15:	6a 2c                	push   $0x2c
  802c17:	e8 19 fa ff ff       	call   802635 <syscall>
  802c1c:	83 c4 18             	add    $0x18,%esp
  802c1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802c22:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802c26:	75 07                	jne    802c2f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802c28:	b8 01 00 00 00       	mov    $0x1,%eax
  802c2d:	eb 05                	jmp    802c34 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802c2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c34:	c9                   	leave  
  802c35:	c3                   	ret    

00802c36 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802c36:	55                   	push   %ebp
  802c37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802c39:	6a 00                	push   $0x0
  802c3b:	6a 00                	push   $0x0
  802c3d:	6a 00                	push   $0x0
  802c3f:	6a 00                	push   $0x0
  802c41:	ff 75 08             	pushl  0x8(%ebp)
  802c44:	6a 2d                	push   $0x2d
  802c46:	e8 ea f9 ff ff       	call   802635 <syscall>
  802c4b:	83 c4 18             	add    $0x18,%esp
	return ;
  802c4e:	90                   	nop
}
  802c4f:	c9                   	leave  
  802c50:	c3                   	ret    

00802c51 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802c51:	55                   	push   %ebp
  802c52:	89 e5                	mov    %esp,%ebp
  802c54:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802c55:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c61:	6a 00                	push   $0x0
  802c63:	53                   	push   %ebx
  802c64:	51                   	push   %ecx
  802c65:	52                   	push   %edx
  802c66:	50                   	push   %eax
  802c67:	6a 2e                	push   $0x2e
  802c69:	e8 c7 f9 ff ff       	call   802635 <syscall>
  802c6e:	83 c4 18             	add    $0x18,%esp
}
  802c71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c74:	c9                   	leave  
  802c75:	c3                   	ret    

00802c76 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802c76:	55                   	push   %ebp
  802c77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802c79:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	6a 00                	push   $0x0
  802c81:	6a 00                	push   $0x0
  802c83:	6a 00                	push   $0x0
  802c85:	52                   	push   %edx
  802c86:	50                   	push   %eax
  802c87:	6a 2f                	push   $0x2f
  802c89:	e8 a7 f9 ff ff       	call   802635 <syscall>
  802c8e:	83 c4 18             	add    $0x18,%esp
}
  802c91:	c9                   	leave  
  802c92:	c3                   	ret    

00802c93 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802c93:	55                   	push   %ebp
  802c94:	89 e5                	mov    %esp,%ebp
  802c96:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802c99:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9c:	89 d0                	mov    %edx,%eax
  802c9e:	c1 e0 02             	shl    $0x2,%eax
  802ca1:	01 d0                	add    %edx,%eax
  802ca3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802caa:	01 d0                	add    %edx,%eax
  802cac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802cb3:	01 d0                	add    %edx,%eax
  802cb5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802cbc:	01 d0                	add    %edx,%eax
  802cbe:	c1 e0 04             	shl    $0x4,%eax
  802cc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802cc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802ccb:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802cce:	83 ec 0c             	sub    $0xc,%esp
  802cd1:	50                   	push   %eax
  802cd2:	e8 76 fd ff ff       	call   802a4d <sys_get_virtual_time>
  802cd7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802cda:	eb 41                	jmp    802d1d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802cdc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802cdf:	83 ec 0c             	sub    $0xc,%esp
  802ce2:	50                   	push   %eax
  802ce3:	e8 65 fd ff ff       	call   802a4d <sys_get_virtual_time>
  802ce8:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802ceb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf1:	29 c2                	sub    %eax,%edx
  802cf3:	89 d0                	mov    %edx,%eax
  802cf5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802cf8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfe:	89 d1                	mov    %edx,%ecx
  802d00:	29 c1                	sub    %eax,%ecx
  802d02:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802d05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d08:	39 c2                	cmp    %eax,%edx
  802d0a:	0f 97 c0             	seta   %al
  802d0d:	0f b6 c0             	movzbl %al,%eax
  802d10:	29 c1                	sub    %eax,%ecx
  802d12:	89 c8                	mov    %ecx,%eax
  802d14:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802d17:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d23:	72 b7                	jb     802cdc <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802d25:	90                   	nop
  802d26:	c9                   	leave  
  802d27:	c3                   	ret    

00802d28 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802d28:	55                   	push   %ebp
  802d29:	89 e5                	mov    %esp,%ebp
  802d2b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802d2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802d35:	eb 03                	jmp    802d3a <busy_wait+0x12>
  802d37:	ff 45 fc             	incl   -0x4(%ebp)
  802d3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802d3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d40:	72 f5                	jb     802d37 <busy_wait+0xf>
	return i;
  802d42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802d45:	c9                   	leave  
  802d46:	c3                   	ret    
  802d47:	90                   	nop

00802d48 <__udivdi3>:
  802d48:	55                   	push   %ebp
  802d49:	57                   	push   %edi
  802d4a:	56                   	push   %esi
  802d4b:	53                   	push   %ebx
  802d4c:	83 ec 1c             	sub    $0x1c,%esp
  802d4f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802d53:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802d57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802d5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d5f:	89 ca                	mov    %ecx,%edx
  802d61:	89 f8                	mov    %edi,%eax
  802d63:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802d67:	85 f6                	test   %esi,%esi
  802d69:	75 2d                	jne    802d98 <__udivdi3+0x50>
  802d6b:	39 cf                	cmp    %ecx,%edi
  802d6d:	77 65                	ja     802dd4 <__udivdi3+0x8c>
  802d6f:	89 fd                	mov    %edi,%ebp
  802d71:	85 ff                	test   %edi,%edi
  802d73:	75 0b                	jne    802d80 <__udivdi3+0x38>
  802d75:	b8 01 00 00 00       	mov    $0x1,%eax
  802d7a:	31 d2                	xor    %edx,%edx
  802d7c:	f7 f7                	div    %edi
  802d7e:	89 c5                	mov    %eax,%ebp
  802d80:	31 d2                	xor    %edx,%edx
  802d82:	89 c8                	mov    %ecx,%eax
  802d84:	f7 f5                	div    %ebp
  802d86:	89 c1                	mov    %eax,%ecx
  802d88:	89 d8                	mov    %ebx,%eax
  802d8a:	f7 f5                	div    %ebp
  802d8c:	89 cf                	mov    %ecx,%edi
  802d8e:	89 fa                	mov    %edi,%edx
  802d90:	83 c4 1c             	add    $0x1c,%esp
  802d93:	5b                   	pop    %ebx
  802d94:	5e                   	pop    %esi
  802d95:	5f                   	pop    %edi
  802d96:	5d                   	pop    %ebp
  802d97:	c3                   	ret    
  802d98:	39 ce                	cmp    %ecx,%esi
  802d9a:	77 28                	ja     802dc4 <__udivdi3+0x7c>
  802d9c:	0f bd fe             	bsr    %esi,%edi
  802d9f:	83 f7 1f             	xor    $0x1f,%edi
  802da2:	75 40                	jne    802de4 <__udivdi3+0x9c>
  802da4:	39 ce                	cmp    %ecx,%esi
  802da6:	72 0a                	jb     802db2 <__udivdi3+0x6a>
  802da8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802dac:	0f 87 9e 00 00 00    	ja     802e50 <__udivdi3+0x108>
  802db2:	b8 01 00 00 00       	mov    $0x1,%eax
  802db7:	89 fa                	mov    %edi,%edx
  802db9:	83 c4 1c             	add    $0x1c,%esp
  802dbc:	5b                   	pop    %ebx
  802dbd:	5e                   	pop    %esi
  802dbe:	5f                   	pop    %edi
  802dbf:	5d                   	pop    %ebp
  802dc0:	c3                   	ret    
  802dc1:	8d 76 00             	lea    0x0(%esi),%esi
  802dc4:	31 ff                	xor    %edi,%edi
  802dc6:	31 c0                	xor    %eax,%eax
  802dc8:	89 fa                	mov    %edi,%edx
  802dca:	83 c4 1c             	add    $0x1c,%esp
  802dcd:	5b                   	pop    %ebx
  802dce:	5e                   	pop    %esi
  802dcf:	5f                   	pop    %edi
  802dd0:	5d                   	pop    %ebp
  802dd1:	c3                   	ret    
  802dd2:	66 90                	xchg   %ax,%ax
  802dd4:	89 d8                	mov    %ebx,%eax
  802dd6:	f7 f7                	div    %edi
  802dd8:	31 ff                	xor    %edi,%edi
  802dda:	89 fa                	mov    %edi,%edx
  802ddc:	83 c4 1c             	add    $0x1c,%esp
  802ddf:	5b                   	pop    %ebx
  802de0:	5e                   	pop    %esi
  802de1:	5f                   	pop    %edi
  802de2:	5d                   	pop    %ebp
  802de3:	c3                   	ret    
  802de4:	bd 20 00 00 00       	mov    $0x20,%ebp
  802de9:	89 eb                	mov    %ebp,%ebx
  802deb:	29 fb                	sub    %edi,%ebx
  802ded:	89 f9                	mov    %edi,%ecx
  802def:	d3 e6                	shl    %cl,%esi
  802df1:	89 c5                	mov    %eax,%ebp
  802df3:	88 d9                	mov    %bl,%cl
  802df5:	d3 ed                	shr    %cl,%ebp
  802df7:	89 e9                	mov    %ebp,%ecx
  802df9:	09 f1                	or     %esi,%ecx
  802dfb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  802dff:	89 f9                	mov    %edi,%ecx
  802e01:	d3 e0                	shl    %cl,%eax
  802e03:	89 c5                	mov    %eax,%ebp
  802e05:	89 d6                	mov    %edx,%esi
  802e07:	88 d9                	mov    %bl,%cl
  802e09:	d3 ee                	shr    %cl,%esi
  802e0b:	89 f9                	mov    %edi,%ecx
  802e0d:	d3 e2                	shl    %cl,%edx
  802e0f:	8b 44 24 08          	mov    0x8(%esp),%eax
  802e13:	88 d9                	mov    %bl,%cl
  802e15:	d3 e8                	shr    %cl,%eax
  802e17:	09 c2                	or     %eax,%edx
  802e19:	89 d0                	mov    %edx,%eax
  802e1b:	89 f2                	mov    %esi,%edx
  802e1d:	f7 74 24 0c          	divl   0xc(%esp)
  802e21:	89 d6                	mov    %edx,%esi
  802e23:	89 c3                	mov    %eax,%ebx
  802e25:	f7 e5                	mul    %ebp
  802e27:	39 d6                	cmp    %edx,%esi
  802e29:	72 19                	jb     802e44 <__udivdi3+0xfc>
  802e2b:	74 0b                	je     802e38 <__udivdi3+0xf0>
  802e2d:	89 d8                	mov    %ebx,%eax
  802e2f:	31 ff                	xor    %edi,%edi
  802e31:	e9 58 ff ff ff       	jmp    802d8e <__udivdi3+0x46>
  802e36:	66 90                	xchg   %ax,%ax
  802e38:	8b 54 24 08          	mov    0x8(%esp),%edx
  802e3c:	89 f9                	mov    %edi,%ecx
  802e3e:	d3 e2                	shl    %cl,%edx
  802e40:	39 c2                	cmp    %eax,%edx
  802e42:	73 e9                	jae    802e2d <__udivdi3+0xe5>
  802e44:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802e47:	31 ff                	xor    %edi,%edi
  802e49:	e9 40 ff ff ff       	jmp    802d8e <__udivdi3+0x46>
  802e4e:	66 90                	xchg   %ax,%ax
  802e50:	31 c0                	xor    %eax,%eax
  802e52:	e9 37 ff ff ff       	jmp    802d8e <__udivdi3+0x46>
  802e57:	90                   	nop

00802e58 <__umoddi3>:
  802e58:	55                   	push   %ebp
  802e59:	57                   	push   %edi
  802e5a:	56                   	push   %esi
  802e5b:	53                   	push   %ebx
  802e5c:	83 ec 1c             	sub    $0x1c,%esp
  802e5f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802e63:	8b 74 24 34          	mov    0x34(%esp),%esi
  802e67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802e6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802e6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802e77:	89 f3                	mov    %esi,%ebx
  802e79:	89 fa                	mov    %edi,%edx
  802e7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802e7f:	89 34 24             	mov    %esi,(%esp)
  802e82:	85 c0                	test   %eax,%eax
  802e84:	75 1a                	jne    802ea0 <__umoddi3+0x48>
  802e86:	39 f7                	cmp    %esi,%edi
  802e88:	0f 86 a2 00 00 00    	jbe    802f30 <__umoddi3+0xd8>
  802e8e:	89 c8                	mov    %ecx,%eax
  802e90:	89 f2                	mov    %esi,%edx
  802e92:	f7 f7                	div    %edi
  802e94:	89 d0                	mov    %edx,%eax
  802e96:	31 d2                	xor    %edx,%edx
  802e98:	83 c4 1c             	add    $0x1c,%esp
  802e9b:	5b                   	pop    %ebx
  802e9c:	5e                   	pop    %esi
  802e9d:	5f                   	pop    %edi
  802e9e:	5d                   	pop    %ebp
  802e9f:	c3                   	ret    
  802ea0:	39 f0                	cmp    %esi,%eax
  802ea2:	0f 87 ac 00 00 00    	ja     802f54 <__umoddi3+0xfc>
  802ea8:	0f bd e8             	bsr    %eax,%ebp
  802eab:	83 f5 1f             	xor    $0x1f,%ebp
  802eae:	0f 84 ac 00 00 00    	je     802f60 <__umoddi3+0x108>
  802eb4:	bf 20 00 00 00       	mov    $0x20,%edi
  802eb9:	29 ef                	sub    %ebp,%edi
  802ebb:	89 fe                	mov    %edi,%esi
  802ebd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ec1:	89 e9                	mov    %ebp,%ecx
  802ec3:	d3 e0                	shl    %cl,%eax
  802ec5:	89 d7                	mov    %edx,%edi
  802ec7:	89 f1                	mov    %esi,%ecx
  802ec9:	d3 ef                	shr    %cl,%edi
  802ecb:	09 c7                	or     %eax,%edi
  802ecd:	89 e9                	mov    %ebp,%ecx
  802ecf:	d3 e2                	shl    %cl,%edx
  802ed1:	89 14 24             	mov    %edx,(%esp)
  802ed4:	89 d8                	mov    %ebx,%eax
  802ed6:	d3 e0                	shl    %cl,%eax
  802ed8:	89 c2                	mov    %eax,%edx
  802eda:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ede:	d3 e0                	shl    %cl,%eax
  802ee0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ee4:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ee8:	89 f1                	mov    %esi,%ecx
  802eea:	d3 e8                	shr    %cl,%eax
  802eec:	09 d0                	or     %edx,%eax
  802eee:	d3 eb                	shr    %cl,%ebx
  802ef0:	89 da                	mov    %ebx,%edx
  802ef2:	f7 f7                	div    %edi
  802ef4:	89 d3                	mov    %edx,%ebx
  802ef6:	f7 24 24             	mull   (%esp)
  802ef9:	89 c6                	mov    %eax,%esi
  802efb:	89 d1                	mov    %edx,%ecx
  802efd:	39 d3                	cmp    %edx,%ebx
  802eff:	0f 82 87 00 00 00    	jb     802f8c <__umoddi3+0x134>
  802f05:	0f 84 91 00 00 00    	je     802f9c <__umoddi3+0x144>
  802f0b:	8b 54 24 04          	mov    0x4(%esp),%edx
  802f0f:	29 f2                	sub    %esi,%edx
  802f11:	19 cb                	sbb    %ecx,%ebx
  802f13:	89 d8                	mov    %ebx,%eax
  802f15:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  802f19:	d3 e0                	shl    %cl,%eax
  802f1b:	89 e9                	mov    %ebp,%ecx
  802f1d:	d3 ea                	shr    %cl,%edx
  802f1f:	09 d0                	or     %edx,%eax
  802f21:	89 e9                	mov    %ebp,%ecx
  802f23:	d3 eb                	shr    %cl,%ebx
  802f25:	89 da                	mov    %ebx,%edx
  802f27:	83 c4 1c             	add    $0x1c,%esp
  802f2a:	5b                   	pop    %ebx
  802f2b:	5e                   	pop    %esi
  802f2c:	5f                   	pop    %edi
  802f2d:	5d                   	pop    %ebp
  802f2e:	c3                   	ret    
  802f2f:	90                   	nop
  802f30:	89 fd                	mov    %edi,%ebp
  802f32:	85 ff                	test   %edi,%edi
  802f34:	75 0b                	jne    802f41 <__umoddi3+0xe9>
  802f36:	b8 01 00 00 00       	mov    $0x1,%eax
  802f3b:	31 d2                	xor    %edx,%edx
  802f3d:	f7 f7                	div    %edi
  802f3f:	89 c5                	mov    %eax,%ebp
  802f41:	89 f0                	mov    %esi,%eax
  802f43:	31 d2                	xor    %edx,%edx
  802f45:	f7 f5                	div    %ebp
  802f47:	89 c8                	mov    %ecx,%eax
  802f49:	f7 f5                	div    %ebp
  802f4b:	89 d0                	mov    %edx,%eax
  802f4d:	e9 44 ff ff ff       	jmp    802e96 <__umoddi3+0x3e>
  802f52:	66 90                	xchg   %ax,%ax
  802f54:	89 c8                	mov    %ecx,%eax
  802f56:	89 f2                	mov    %esi,%edx
  802f58:	83 c4 1c             	add    $0x1c,%esp
  802f5b:	5b                   	pop    %ebx
  802f5c:	5e                   	pop    %esi
  802f5d:	5f                   	pop    %edi
  802f5e:	5d                   	pop    %ebp
  802f5f:	c3                   	ret    
  802f60:	3b 04 24             	cmp    (%esp),%eax
  802f63:	72 06                	jb     802f6b <__umoddi3+0x113>
  802f65:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802f69:	77 0f                	ja     802f7a <__umoddi3+0x122>
  802f6b:	89 f2                	mov    %esi,%edx
  802f6d:	29 f9                	sub    %edi,%ecx
  802f6f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802f73:	89 14 24             	mov    %edx,(%esp)
  802f76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802f7a:	8b 44 24 04          	mov    0x4(%esp),%eax
  802f7e:	8b 14 24             	mov    (%esp),%edx
  802f81:	83 c4 1c             	add    $0x1c,%esp
  802f84:	5b                   	pop    %ebx
  802f85:	5e                   	pop    %esi
  802f86:	5f                   	pop    %edi
  802f87:	5d                   	pop    %ebp
  802f88:	c3                   	ret    
  802f89:	8d 76 00             	lea    0x0(%esi),%esi
  802f8c:	2b 04 24             	sub    (%esp),%eax
  802f8f:	19 fa                	sbb    %edi,%edx
  802f91:	89 d1                	mov    %edx,%ecx
  802f93:	89 c6                	mov    %eax,%esi
  802f95:	e9 71 ff ff ff       	jmp    802f0b <__umoddi3+0xb3>
  802f9a:	66 90                	xchg   %ax,%ax
  802f9c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802fa0:	72 ea                	jb     802f8c <__umoddi3+0x134>
  802fa2:	89 d9                	mov    %ebx,%ecx
  802fa4:	e9 62 ff ff ff       	jmp    802f0b <__umoddi3+0xb3>
