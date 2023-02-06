
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 2b 07 00 00       	call   800761 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 88 00 00 00    	sub    $0x88,%esp
	/*[1] CREATE SHARED ARRAY*/
	int ret;
	char Chose;
	char Line[30];
	//2012: lock the interrupt
	sys_disable_interrupt();
  800041:	e8 b6 21 00 00       	call   8021fc <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 3a 80 00       	push   $0x803a40
  80004e:	e8 fe 0a 00 00       	call   800b51 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 3a 80 00       	push   $0x803a42
  80005e:	e8 ee 0a 00 00       	call   800b51 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 60 3a 80 00       	push   $0x803a60
  80006e:	e8 de 0a 00 00       	call   800b51 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 3a 80 00       	push   $0x803a42
  80007e:	e8 ce 0a 00 00       	call   800b51 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 3a 80 00       	push   $0x803a40
  80008e:	e8 be 0a 00 00       	call   800b51 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 80 3a 80 00       	push   $0x803a80
  8000a2:	e8 2c 11 00 00       	call   8011d3 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 9f 3a 80 00       	push   $0x803a9f
  8000b6:	e8 91 1d 00 00       	call   801e4c <smalloc>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 0a                	push   $0xa
  8000c6:	6a 00                	push   $0x0
  8000c8:	8d 45 82             	lea    -0x7e(%ebp),%eax
  8000cb:	50                   	push   %eax
  8000cc:	e8 68 16 00 00       	call   801739 <strtol>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	89 c2                	mov    %eax,%edx
  8000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d9:	89 10                	mov    %edx,(%eax)
		int NumOfElements = *arrSize;
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8b 00                	mov    (%eax),%eax
  8000e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  8000e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e6:	c1 e0 02             	shl    $0x2,%eax
  8000e9:	83 ec 04             	sub    $0x4,%esp
  8000ec:	6a 00                	push   $0x0
  8000ee:	50                   	push   %eax
  8000ef:	68 a7 3a 80 00       	push   $0x803aa7
  8000f4:	e8 53 1d 00 00       	call   801e4c <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 ac 3a 80 00       	push   $0x803aac
  800107:	e8 45 0a 00 00       	call   800b51 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 ce 3a 80 00       	push   $0x803ace
  800117:	e8 35 0a 00 00       	call   800b51 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 dc 3a 80 00       	push   $0x803adc
  800127:	e8 25 0a 00 00       	call   800b51 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 eb 3a 80 00       	push   $0x803aeb
  800137:	e8 15 0a 00 00       	call   800b51 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 fb 3a 80 00       	push   $0x803afb
  800147:	e8 05 0a 00 00       	call   800b51 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80014f:	e8 b5 05 00 00       	call   800709 <getchar>
  800154:	88 45 eb             	mov    %al,-0x15(%ebp)
			cputchar(Chose);
  800157:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	50                   	push   %eax
  80015f:	e8 5d 05 00 00       	call   8006c1 <cputchar>
  800164:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	6a 0a                	push   $0xa
  80016c:	e8 50 05 00 00       	call   8006c1 <cputchar>
  800171:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800174:	80 7d eb 61          	cmpb   $0x61,-0x15(%ebp)
  800178:	74 0c                	je     800186 <_main+0x14e>
  80017a:	80 7d eb 62          	cmpb   $0x62,-0x15(%ebp)
  80017e:	74 06                	je     800186 <_main+0x14e>
  800180:	80 7d eb 63          	cmpb   $0x63,-0x15(%ebp)
  800184:	75 b9                	jne    80013f <_main+0x107>

	//2012: unlock the interrupt
	sys_enable_interrupt();
  800186:	e8 8b 20 00 00       	call   802216 <sys_enable_interrupt>

	int  i ;
	switch (Chose)
  80018b:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80018f:	83 f8 62             	cmp    $0x62,%eax
  800192:	74 1d                	je     8001b1 <_main+0x179>
  800194:	83 f8 63             	cmp    $0x63,%eax
  800197:	74 2b                	je     8001c4 <_main+0x18c>
  800199:	83 f8 61             	cmp    $0x61,%eax
  80019c:	75 39                	jne    8001d7 <_main+0x19f>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	e8 9b 03 00 00       	call   800547 <InitializeAscending>
  8001ac:	83 c4 10             	add    $0x10,%esp
		break ;
  8001af:	eb 37                	jmp    8001e8 <_main+0x1b0>
	case 'b':
		InitializeDescending(Elements, NumOfElements);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 b9 03 00 00       	call   800578 <InitializeDescending>
  8001bf:	83 c4 10             	add    $0x10,%esp
		break ;
  8001c2:	eb 24                	jmp    8001e8 <_main+0x1b0>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 db 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001d2:	83 c4 10             	add    $0x10,%esp
		break ;
  8001d5:	eb 11                	jmp    8001e8 <_main+0x1b0>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	ff 75 f0             	pushl  -0x10(%ebp)
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	e8 c8 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001e5:	83 c4 10             	add    $0x10,%esp
	}

	//Create the check-finishing counter
	int numOfSlaveProgs = 3 ;
  8001e8:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	6a 04                	push   $0x4
  8001f6:	68 04 3b 80 00       	push   $0x803b04
  8001fb:	e8 4c 1c 00 00       	call   801e4c <smalloc>
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  800206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[2] RUN THE SLAVES PROGRAMS*/
	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  80020f:	a1 20 50 80 00       	mov    0x805020,%eax
  800214:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800225:	89 c1                	mov    %eax,%ecx
  800227:	a1 20 50 80 00       	mov    0x805020,%eax
  80022c:	8b 40 74             	mov    0x74(%eax),%eax
  80022f:	52                   	push   %edx
  800230:	51                   	push   %ecx
  800231:	50                   	push   %eax
  800232:	68 12 3b 80 00       	push   $0x803b12
  800237:	e8 45 21 00 00       	call   802381 <sys_create_env>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800242:	a1 20 50 80 00       	mov    0x805020,%eax
  800247:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80024d:	a1 20 50 80 00       	mov    0x805020,%eax
  800252:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800258:	89 c1                	mov    %eax,%ecx
  80025a:	a1 20 50 80 00       	mov    0x805020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	52                   	push   %edx
  800263:	51                   	push   %ecx
  800264:	50                   	push   %eax
  800265:	68 1b 3b 80 00       	push   $0x803b1b
  80026a:	e8 12 21 00 00       	call   802381 <sys_create_env>
  80026f:	83 c4 10             	add    $0x10,%esp
  800272:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800275:	a1 20 50 80 00       	mov    0x805020,%eax
  80027a:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800280:	a1 20 50 80 00       	mov    0x805020,%eax
  800285:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80028b:	89 c1                	mov    %eax,%ecx
  80028d:	a1 20 50 80 00       	mov    0x805020,%eax
  800292:	8b 40 74             	mov    0x74(%eax),%eax
  800295:	52                   	push   %edx
  800296:	51                   	push   %ecx
  800297:	50                   	push   %eax
  800298:	68 24 3b 80 00       	push   $0x803b24
  80029d:	e8 df 20 00 00       	call   802381 <sys_create_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  8002a8:	83 7d dc ef          	cmpl   $0xffffffef,-0x24(%ebp)
  8002ac:	74 0c                	je     8002ba <_main+0x282>
  8002ae:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  8002b2:	74 06                	je     8002ba <_main+0x282>
  8002b4:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  8002b8:	75 14                	jne    8002ce <_main+0x296>
		panic("NO AVAILABLE ENVs...");
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 30 3b 80 00       	push   $0x803b30
  8002c2:	6a 4b                	push   $0x4b
  8002c4:	68 45 3b 80 00       	push   $0x803b45
  8002c9:	e8 cf 05 00 00       	call   80089d <_panic>

	sys_run_env(envIdQuickSort);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d4:	e8 c6 20 00 00       	call   80239f <sys_run_env>
  8002d9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e2:	e8 b8 20 00 00       	call   80239f <sys_run_env>
  8002e7:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f0:	e8 aa 20 00 00       	call   80239f <sys_run_env>
  8002f5:	83 c4 10             	add    $0x10,%esp

	/*[3] BUSY-WAIT TILL FINISHING THEM*/
	while (*numOfFinished != numOfSlaveProgs) ;
  8002f8:	90                   	nop
  8002f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fc:	8b 00                	mov    (%eax),%eax
  8002fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800301:	75 f6                	jne    8002f9 <_main+0x2c1>

	/*[4] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  800303:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int *mergesortedArr = NULL;
  80030a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	int *mean = NULL;
  800311:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	int *var = NULL;
  800318:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	int *min = NULL;
  80031f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
	int *max = NULL;
  800326:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int *med = NULL;
  80032d:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	68 63 3b 80 00       	push   $0x803b63
  80033c:	ff 75 dc             	pushl  -0x24(%ebp)
  80033f:	e8 a6 1b 00 00       	call   801eea <sget>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	68 72 3b 80 00       	push   $0x803b72
  800352:	ff 75 d8             	pushl  -0x28(%ebp)
  800355:	e8 90 1b 00 00       	call   801eea <sget>
  80035a:	83 c4 10             	add    $0x10,%esp
  80035d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	68 81 3b 80 00       	push   $0x803b81
  800368:	ff 75 d4             	pushl  -0x2c(%ebp)
  80036b:	e8 7a 1b 00 00       	call   801eea <sget>
  800370:	83 c4 10             	add    $0x10,%esp
  800373:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	68 86 3b 80 00       	push   $0x803b86
  80037e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800381:	e8 64 1b 00 00       	call   801eea <sget>
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	68 8a 3b 80 00       	push   $0x803b8a
  800394:	ff 75 d4             	pushl  -0x2c(%ebp)
  800397:	e8 4e 1b 00 00       	call   801eea <sget>
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	68 8e 3b 80 00       	push   $0x803b8e
  8003aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003ad:	e8 38 1b 00 00       	call   801eea <sget>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	68 92 3b 80 00       	push   $0x803b92
  8003c0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003c3:	e8 22 1b 00 00       	call   801eea <sget>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 b8             	mov    %eax,-0x48(%ebp)

	/*[5] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003d4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d7:	e8 14 01 00 00       	call   8004f0 <CheckSorted>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  8003e2:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8003e6:	75 14                	jne    8003fc <_main+0x3c4>
  8003e8:	83 ec 04             	sub    $0x4,%esp
  8003eb:	68 98 3b 80 00       	push   $0x803b98
  8003f0:	6a 66                	push   $0x66
  8003f2:	68 45 3b 80 00       	push   $0x803b45
  8003f7:	e8 a1 04 00 00       	call   80089d <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	ff 75 f0             	pushl  -0x10(%ebp)
  800402:	ff 75 cc             	pushl  -0x34(%ebp)
  800405:	e8 e6 00 00 00       	call   8004f0 <CheckSorted>
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  800410:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  800414:	75 14                	jne    80042a <_main+0x3f2>
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 c0 3b 80 00       	push   $0x803bc0
  80041e:	6a 68                	push   $0x68
  800420:	68 45 3b 80 00       	push   $0x803b45
  800425:	e8 73 04 00 00       	call   80089d <_panic>
	int correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  80042a:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  800430:	50                   	push   %eax
  800431:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800437:	50                   	push   %eax
  800438:	ff 75 f0             	pushl  -0x10(%ebp)
  80043b:	ff 75 ec             	pushl  -0x14(%ebp)
  80043e:	e8 b6 01 00 00       	call   8005f9 <ArrayStats>
  800443:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  800446:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int last = NumOfElements-1;
  80044e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800451:	48                   	dec    %eax
  800452:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int middle = (NumOfElements-1)/2;
  800455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800458:	48                   	dec    %eax
  800459:	89 c2                	mov    %eax,%edx
  80045b:	c1 ea 1f             	shr    $0x1f,%edx
  80045e:	01 d0                	add    %edx,%eax
  800460:	d1 f8                	sar    %eax
  800462:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int correctMax = quicksortedArr[last];
  800465:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int correctMed = quicksortedArr[middle];
  800479:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//cprintf("Array is correctly sorted\n");
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);

	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  80048d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800490:	8b 10                	mov    (%eax),%edx
  800492:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800498:	39 c2                	cmp    %eax,%edx
  80049a:	75 2d                	jne    8004c9 <_main+0x491>
  80049c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80049f:	8b 10                	mov    (%eax),%edx
  8004a1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8004a7:	39 c2                	cmp    %eax,%edx
  8004a9:	75 1e                	jne    8004c9 <_main+0x491>
  8004ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  8004b3:	75 14                	jne    8004c9 <_main+0x491>
  8004b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8004bd:	75 0a                	jne    8004c9 <_main+0x491>
  8004bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	3b 45 a0             	cmp    -0x60(%ebp),%eax
  8004c7:	74 14                	je     8004dd <_main+0x4a5>
		panic("The array STATS are NOT calculated correctly") ;
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	68 e8 3b 80 00       	push   $0x803be8
  8004d1:	6a 75                	push   $0x75
  8004d3:	68 45 3b 80 00       	push   $0x803b45
  8004d8:	e8 c0 03 00 00       	call   80089d <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004dd:	83 ec 0c             	sub    $0xc,%esp
  8004e0:	68 18 3c 80 00       	push   $0x803c18
  8004e5:	e8 67 06 00 00       	call   800b51 <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp

	return;
  8004ed:	90                   	nop
}
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8004f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8004fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800504:	eb 33                	jmp    800539 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800506:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	01 d0                	add    %edx,%eax
  800515:	8b 10                	mov    (%eax),%edx
  800517:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80051a:	40                   	inc    %eax
  80051b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	01 c8                	add    %ecx,%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	39 c2                	cmp    %eax,%edx
  80052b:	7e 09                	jle    800536 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80052d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800534:	eb 0c                	jmp    800542 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800536:	ff 45 f8             	incl   -0x8(%ebp)
  800539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053c:	48                   	dec    %eax
  80053d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800540:	7f c4                	jg     800506 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800542:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80054d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800554:	eb 17                	jmp    80056d <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800556:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	01 c2                	add    %eax,%edx
  800565:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800568:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80056a:	ff 45 fc             	incl   -0x4(%ebp)
  80056d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800570:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800573:	7c e1                	jl     800556 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800575:	90                   	nop
  800576:	c9                   	leave  
  800577:	c3                   	ret    

00800578 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800578:	55                   	push   %ebp
  800579:	89 e5                	mov    %esp,%ebp
  80057b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80057e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800585:	eb 1b                	jmp    8005a2 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800587:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80058a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	01 c2                	add    %eax,%edx
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80059c:	48                   	dec    %eax
  80059d:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80059f:	ff 45 fc             	incl   -0x4(%ebp)
  8005a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005a8:	7c dd                	jl     800587 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8005aa:	90                   	nop
  8005ab:	c9                   	leave  
  8005ac:	c3                   	ret    

008005ad <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8005b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b6:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8005bb:	f7 e9                	imul   %ecx
  8005bd:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c0:	89 d0                	mov    %edx,%eax
  8005c2:	29 c8                	sub    %ecx,%eax
  8005c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8005c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8005ce:	eb 1e                	jmp    8005ee <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8005d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8005e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005e3:	99                   	cltd   
  8005e4:	f7 7d f8             	idivl  -0x8(%ebp)
  8005e7:	89 d0                	mov    %edx,%eax
  8005e9:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8005eb:	ff 45 fc             	incl   -0x4(%ebp)
  8005ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005f4:	7c da                	jl     8005d0 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  8005f6:	90                   	nop
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	53                   	push   %ebx
  8005fd:	83 ec 10             	sub    $0x10,%esp
	int i ;
	*mean =0 ;
  800600:	8b 45 10             	mov    0x10(%ebp),%eax
  800603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800609:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800610:	eb 20                	jmp    800632 <ArrayStats+0x39>
	{
		*mean += Elements[i];
  800612:	8b 45 10             	mov    0x10(%ebp),%eax
  800615:	8b 10                	mov    (%eax),%edx
  800617:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80061a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	01 c8                	add    %ecx,%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	01 c2                	add    %eax,%edx
  80062a:	8b 45 10             	mov    0x10(%ebp),%eax
  80062d:	89 10                	mov    %edx,(%eax)

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  80062f:	ff 45 f8             	incl   -0x8(%ebp)
  800632:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800635:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800638:	7c d8                	jl     800612 <ArrayStats+0x19>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  80063a:	8b 45 10             	mov    0x10(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	99                   	cltd   
  800640:	f7 7d 0c             	idivl  0xc(%ebp)
  800643:	89 c2                	mov    %eax,%edx
  800645:	8b 45 10             	mov    0x10(%ebp),%eax
  800648:	89 10                	mov    %edx,(%eax)
	*var = 0;
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800653:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80065a:	eb 46                	jmp    8006a2 <ArrayStats+0xa9>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800664:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	01 c8                	add    %ecx,%eax
  800670:	8b 08                	mov    (%eax),%ecx
  800672:	8b 45 10             	mov    0x10(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 cb                	mov    %ecx,%ebx
  800679:	29 c3                	sub    %eax,%ebx
  80067b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80067e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	01 c8                	add    %ecx,%eax
  80068a:	8b 08                	mov    (%eax),%ecx
  80068c:	8b 45 10             	mov    0x10(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	29 c1                	sub    %eax,%ecx
  800693:	89 c8                	mov    %ecx,%eax
  800695:	0f af c3             	imul   %ebx,%eax
  800698:	01 c2                	add    %eax,%edx
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	89 10                	mov    %edx,(%eax)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  80069f:	ff 45 f8             	incl   -0x8(%ebp)
  8006a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006a8:	7c b2                	jl     80065c <ArrayStats+0x63>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
	}
	*var /= NumOfElements;
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	99                   	cltd   
  8006b0:	f7 7d 0c             	idivl  0xc(%ebp)
  8006b3:	89 c2                	mov    %eax,%edx
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	89 10                	mov    %edx,(%eax)
}
  8006ba:	90                   	nop
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	5b                   	pop    %ebx
  8006bf:	5d                   	pop    %ebp
  8006c0:	c3                   	ret    

008006c1 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006cd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006d1:	83 ec 0c             	sub    $0xc,%esp
  8006d4:	50                   	push   %eax
  8006d5:	e8 56 1b 00 00       	call   802230 <sys_cputc>
  8006da:	83 c4 10             	add    $0x10,%esp
}
  8006dd:	90                   	nop
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e6:	e8 11 1b 00 00       	call   8021fc <sys_disable_interrupt>
	char c = ch;
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006f1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006f5:	83 ec 0c             	sub    $0xc,%esp
  8006f8:	50                   	push   %eax
  8006f9:	e8 32 1b 00 00       	call   802230 <sys_cputc>
  8006fe:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800701:	e8 10 1b 00 00       	call   802216 <sys_enable_interrupt>
}
  800706:	90                   	nop
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <getchar>:

int
getchar(void)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80070f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800716:	eb 08                	jmp    800720 <getchar+0x17>
	{
		c = sys_cgetc();
  800718:	e8 5a 19 00 00       	call   802077 <sys_cgetc>
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800724:	74 f2                	je     800718 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800726:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <atomic_getchar>:

int
atomic_getchar(void)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800731:	e8 c6 1a 00 00       	call   8021fc <sys_disable_interrupt>
	int c=0;
  800736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80073d:	eb 08                	jmp    800747 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  80073f:	e8 33 19 00 00       	call   802077 <sys_cgetc>
  800744:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800747:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80074b:	74 f2                	je     80073f <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  80074d:	e8 c4 1a 00 00       	call   802216 <sys_enable_interrupt>
	return c;
  800752:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800755:	c9                   	leave  
  800756:	c3                   	ret    

00800757 <iscons>:

int iscons(int fdnum)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80075a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800767:	e8 83 1c 00 00       	call   8023ef <sys_getenvindex>
  80076c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80076f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800772:	89 d0                	mov    %edx,%eax
  800774:	c1 e0 03             	shl    $0x3,%eax
  800777:	01 d0                	add    %edx,%eax
  800779:	01 c0                	add    %eax,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800784:	01 d0                	add    %edx,%eax
  800786:	c1 e0 04             	shl    $0x4,%eax
  800789:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80078e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800793:	a1 20 50 80 00       	mov    0x805020,%eax
  800798:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80079e:	84 c0                	test   %al,%al
  8007a0:	74 0f                	je     8007b1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007a7:	05 5c 05 00 00       	add    $0x55c,%eax
  8007ac:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007b5:	7e 0a                	jle    8007c1 <libmain+0x60>
		binaryname = argv[0];
  8007b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 69 f8 ff ff       	call   800038 <_main>
  8007cf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8007d2:	e8 25 1a 00 00       	call   8021fc <sys_disable_interrupt>
	cprintf("**************************************\n");
  8007d7:	83 ec 0c             	sub    $0xc,%esp
  8007da:	68 94 3c 80 00       	push   $0x803c94
  8007df:	e8 6d 03 00 00       	call   800b51 <cprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007ec:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8007f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007f7:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	52                   	push   %edx
  800801:	50                   	push   %eax
  800802:	68 bc 3c 80 00       	push   $0x803cbc
  800807:	e8 45 03 00 00       	call   800b51 <cprintf>
  80080c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80080f:	a1 20 50 80 00       	mov    0x805020,%eax
  800814:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80081a:	a1 20 50 80 00       	mov    0x805020,%eax
  80081f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800825:	a1 20 50 80 00       	mov    0x805020,%eax
  80082a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800830:	51                   	push   %ecx
  800831:	52                   	push   %edx
  800832:	50                   	push   %eax
  800833:	68 e4 3c 80 00       	push   $0x803ce4
  800838:	e8 14 03 00 00       	call   800b51 <cprintf>
  80083d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800840:	a1 20 50 80 00       	mov    0x805020,%eax
  800845:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	50                   	push   %eax
  80084f:	68 3c 3d 80 00       	push   $0x803d3c
  800854:	e8 f8 02 00 00       	call   800b51 <cprintf>
  800859:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	68 94 3c 80 00       	push   $0x803c94
  800864:	e8 e8 02 00 00       	call   800b51 <cprintf>
  800869:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80086c:	e8 a5 19 00 00       	call   802216 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800871:	e8 19 00 00 00       	call   80088f <exit>
}
  800876:	90                   	nop
  800877:	c9                   	leave  
  800878:	c3                   	ret    

00800879 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80087f:	83 ec 0c             	sub    $0xc,%esp
  800882:	6a 00                	push   $0x0
  800884:	e8 32 1b 00 00       	call   8023bb <sys_destroy_env>
  800889:	83 c4 10             	add    $0x10,%esp
}
  80088c:	90                   	nop
  80088d:	c9                   	leave  
  80088e:	c3                   	ret    

0080088f <exit>:

void
exit(void)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800895:	e8 87 1b 00 00       	call   802421 <sys_exit_env>
}
  80089a:	90                   	nop
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    

0080089d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8008a6:	83 c0 04             	add    $0x4,%eax
  8008a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008ac:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008b1:	85 c0                	test   %eax,%eax
  8008b3:	74 16                	je     8008cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008b5:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 50 3d 80 00       	push   $0x803d50
  8008c3:	e8 89 02 00 00       	call   800b51 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8008d0:	ff 75 0c             	pushl  0xc(%ebp)
  8008d3:	ff 75 08             	pushl  0x8(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	68 55 3d 80 00       	push   $0x803d55
  8008dc:	e8 70 02 00 00       	call   800b51 <cprintf>
  8008e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ed:	50                   	push   %eax
  8008ee:	e8 f3 01 00 00       	call   800ae6 <vcprintf>
  8008f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	6a 00                	push   $0x0
  8008fb:	68 71 3d 80 00       	push   $0x803d71
  800900:	e8 e1 01 00 00       	call   800ae6 <vcprintf>
  800905:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800908:	e8 82 ff ff ff       	call   80088f <exit>

	// should not return here
	while (1) ;
  80090d:	eb fe                	jmp    80090d <_panic+0x70>

0080090f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800915:	a1 20 50 80 00       	mov    0x805020,%eax
  80091a:	8b 50 74             	mov    0x74(%eax),%edx
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	39 c2                	cmp    %eax,%edx
  800922:	74 14                	je     800938 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	68 74 3d 80 00       	push   $0x803d74
  80092c:	6a 26                	push   $0x26
  80092e:	68 c0 3d 80 00       	push   $0x803dc0
  800933:	e8 65 ff ff ff       	call   80089d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800938:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80093f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800946:	e9 c2 00 00 00       	jmp    800a0d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80094b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	01 d0                	add    %edx,%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	85 c0                	test   %eax,%eax
  80095e:	75 08                	jne    800968 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800960:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800963:	e9 a2 00 00 00       	jmp    800a0a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800968:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800976:	eb 69                	jmp    8009e1 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800978:	a1 20 50 80 00       	mov    0x805020,%eax
  80097d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800983:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800986:	89 d0                	mov    %edx,%eax
  800988:	01 c0                	add    %eax,%eax
  80098a:	01 d0                	add    %edx,%eax
  80098c:	c1 e0 03             	shl    $0x3,%eax
  80098f:	01 c8                	add    %ecx,%eax
  800991:	8a 40 04             	mov    0x4(%eax),%al
  800994:	84 c0                	test   %al,%al
  800996:	75 46                	jne    8009de <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800998:	a1 20 50 80 00       	mov    0x805020,%eax
  80099d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	01 c0                	add    %eax,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	c1 e0 03             	shl    $0x3,%eax
  8009af:	01 c8                	add    %ecx,%eax
  8009b1:	8b 00                	mov    (%eax),%eax
  8009b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	01 c8                	add    %ecx,%eax
  8009cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d1:	39 c2                	cmp    %eax,%edx
  8009d3:	75 09                	jne    8009de <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8009d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009dc:	eb 12                	jmp    8009f0 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009de:	ff 45 e8             	incl   -0x18(%ebp)
  8009e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8009e6:	8b 50 74             	mov    0x74(%eax),%edx
  8009e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009ec:	39 c2                	cmp    %eax,%edx
  8009ee:	77 88                	ja     800978 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009f4:	75 14                	jne    800a0a <CheckWSWithoutLastIndex+0xfb>
			panic(
  8009f6:	83 ec 04             	sub    $0x4,%esp
  8009f9:	68 cc 3d 80 00       	push   $0x803dcc
  8009fe:	6a 3a                	push   $0x3a
  800a00:	68 c0 3d 80 00       	push   $0x803dc0
  800a05:	e8 93 fe ff ff       	call   80089d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a0a:	ff 45 f0             	incl   -0x10(%ebp)
  800a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a10:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a13:	0f 8c 32 ff ff ff    	jl     80094b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a27:	eb 26                	jmp    800a4f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a29:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a37:	89 d0                	mov    %edx,%eax
  800a39:	01 c0                	add    %eax,%eax
  800a3b:	01 d0                	add    %edx,%eax
  800a3d:	c1 e0 03             	shl    $0x3,%eax
  800a40:	01 c8                	add    %ecx,%eax
  800a42:	8a 40 04             	mov    0x4(%eax),%al
  800a45:	3c 01                	cmp    $0x1,%al
  800a47:	75 03                	jne    800a4c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a49:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4c:	ff 45 e0             	incl   -0x20(%ebp)
  800a4f:	a1 20 50 80 00       	mov    0x805020,%eax
  800a54:	8b 50 74             	mov    0x74(%eax),%edx
  800a57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5a:	39 c2                	cmp    %eax,%edx
  800a5c:	77 cb                	ja     800a29 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a61:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a64:	74 14                	je     800a7a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800a66:	83 ec 04             	sub    $0x4,%esp
  800a69:	68 20 3e 80 00       	push   $0x803e20
  800a6e:	6a 44                	push   $0x44
  800a70:	68 c0 3d 80 00       	push   $0x803dc0
  800a75:	e8 23 fe ff ff       	call   80089d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a7a:	90                   	nop
  800a7b:	c9                   	leave  
  800a7c:	c3                   	ret    

00800a7d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	8b 00                	mov    (%eax),%eax
  800a88:	8d 48 01             	lea    0x1(%eax),%ecx
  800a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8e:	89 0a                	mov    %ecx,(%edx)
  800a90:	8b 55 08             	mov    0x8(%ebp),%edx
  800a93:	88 d1                	mov    %dl,%cl
  800a95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a98:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9f:	8b 00                	mov    (%eax),%eax
  800aa1:	3d ff 00 00 00       	cmp    $0xff,%eax
  800aa6:	75 2c                	jne    800ad4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800aa8:	a0 24 50 80 00       	mov    0x805024,%al
  800aad:	0f b6 c0             	movzbl %al,%eax
  800ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab3:	8b 12                	mov    (%edx),%edx
  800ab5:	89 d1                	mov    %edx,%ecx
  800ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aba:	83 c2 08             	add    $0x8,%edx
  800abd:	83 ec 04             	sub    $0x4,%esp
  800ac0:	50                   	push   %eax
  800ac1:	51                   	push   %ecx
  800ac2:	52                   	push   %edx
  800ac3:	e8 86 15 00 00       	call   80204e <sys_cputs>
  800ac8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ace:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad7:	8b 40 04             	mov    0x4(%eax),%eax
  800ada:	8d 50 01             	lea    0x1(%eax),%edx
  800add:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae0:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ae3:	90                   	nop
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800af6:	00 00 00 
	b.cnt = 0;
  800af9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b00:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b0f:	50                   	push   %eax
  800b10:	68 7d 0a 80 00       	push   $0x800a7d
  800b15:	e8 11 02 00 00       	call   800d2b <vprintfmt>
  800b1a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b1d:	a0 24 50 80 00       	mov    0x805024,%al
  800b22:	0f b6 c0             	movzbl %al,%eax
  800b25:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b2b:	83 ec 04             	sub    $0x4,%esp
  800b2e:	50                   	push   %eax
  800b2f:	52                   	push   %edx
  800b30:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b36:	83 c0 08             	add    $0x8,%eax
  800b39:	50                   	push   %eax
  800b3a:	e8 0f 15 00 00       	call   80204e <sys_cputs>
  800b3f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b42:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800b49:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <cprintf>:

int cprintf(const char *fmt, ...) {
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b57:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800b5e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	83 ec 08             	sub    $0x8,%esp
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	e8 73 ff ff ff       	call   800ae6 <vcprintf>
  800b73:	83 c4 10             	add    $0x10,%esp
  800b76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b84:	e8 73 16 00 00       	call   8021fc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b89:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 f4             	pushl  -0xc(%ebp)
  800b98:	50                   	push   %eax
  800b99:	e8 48 ff ff ff       	call   800ae6 <vcprintf>
  800b9e:	83 c4 10             	add    $0x10,%esp
  800ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ba4:	e8 6d 16 00 00       	call   802216 <sys_enable_interrupt>
	return cnt;
  800ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	53                   	push   %ebx
  800bb2:	83 ec 14             	sub    $0x14,%esp
  800bb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc1:	8b 45 18             	mov    0x18(%ebp),%eax
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bcc:	77 55                	ja     800c23 <printnum+0x75>
  800bce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bd1:	72 05                	jb     800bd8 <printnum+0x2a>
  800bd3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bd6:	77 4b                	ja     800c23 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bdb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bde:	8b 45 18             	mov    0x18(%ebp),%eax
  800be1:	ba 00 00 00 00       	mov    $0x0,%edx
  800be6:	52                   	push   %edx
  800be7:	50                   	push   %eax
  800be8:	ff 75 f4             	pushl  -0xc(%ebp)
  800beb:	ff 75 f0             	pushl  -0x10(%ebp)
  800bee:	e8 d5 2b 00 00       	call   8037c8 <__udivdi3>
  800bf3:	83 c4 10             	add    $0x10,%esp
  800bf6:	83 ec 04             	sub    $0x4,%esp
  800bf9:	ff 75 20             	pushl  0x20(%ebp)
  800bfc:	53                   	push   %ebx
  800bfd:	ff 75 18             	pushl  0x18(%ebp)
  800c00:	52                   	push   %edx
  800c01:	50                   	push   %eax
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	ff 75 08             	pushl  0x8(%ebp)
  800c08:	e8 a1 ff ff ff       	call   800bae <printnum>
  800c0d:	83 c4 20             	add    $0x20,%esp
  800c10:	eb 1a                	jmp    800c2c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	ff 75 20             	pushl  0x20(%ebp)
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c23:	ff 4d 1c             	decl   0x1c(%ebp)
  800c26:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c2a:	7f e6                	jg     800c12 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c2c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3a:	53                   	push   %ebx
  800c3b:	51                   	push   %ecx
  800c3c:	52                   	push   %edx
  800c3d:	50                   	push   %eax
  800c3e:	e8 95 2c 00 00       	call   8038d8 <__umoddi3>
  800c43:	83 c4 10             	add    $0x10,%esp
  800c46:	05 94 40 80 00       	add    $0x804094,%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	0f be c0             	movsbl %al,%eax
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	50                   	push   %eax
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
}
  800c5f:	90                   	nop
  800c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c68:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c6c:	7e 1c                	jle    800c8a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	8d 50 08             	lea    0x8(%eax),%edx
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 10                	mov    %edx,(%eax)
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8b 00                	mov    (%eax),%eax
  800c80:	83 e8 08             	sub    $0x8,%eax
  800c83:	8b 50 04             	mov    0x4(%eax),%edx
  800c86:	8b 00                	mov    (%eax),%eax
  800c88:	eb 40                	jmp    800cca <getuint+0x65>
	else if (lflag)
  800c8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8e:	74 1e                	je     800cae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8b 00                	mov    (%eax),%eax
  800c95:	8d 50 04             	lea    0x4(%eax),%edx
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	89 10                	mov    %edx,(%eax)
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8b 00                	mov    (%eax),%eax
  800ca2:	83 e8 04             	sub    $0x4,%eax
  800ca5:	8b 00                	mov    (%eax),%eax
  800ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cac:	eb 1c                	jmp    800cca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8b 00                	mov    (%eax),%eax
  800cb3:	8d 50 04             	lea    0x4(%eax),%edx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 10                	mov    %edx,(%eax)
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8b 00                	mov    (%eax),%eax
  800cc0:	83 e8 04             	sub    $0x4,%eax
  800cc3:	8b 00                	mov    (%eax),%eax
  800cc5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ccf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd3:	7e 1c                	jle    800cf1 <getint+0x25>
		return va_arg(*ap, long long);
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8b 00                	mov    (%eax),%eax
  800cda:	8d 50 08             	lea    0x8(%eax),%edx
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	89 10                	mov    %edx,(%eax)
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8b 00                	mov    (%eax),%eax
  800ce7:	83 e8 08             	sub    $0x8,%eax
  800cea:	8b 50 04             	mov    0x4(%eax),%edx
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	eb 38                	jmp    800d29 <getint+0x5d>
	else if (lflag)
  800cf1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf5:	74 1a                	je     800d11 <getint+0x45>
		return va_arg(*ap, long);
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8b 00                	mov    (%eax),%eax
  800cfc:	8d 50 04             	lea    0x4(%eax),%edx
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	89 10                	mov    %edx,(%eax)
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	83 e8 04             	sub    $0x4,%eax
  800d0c:	8b 00                	mov    (%eax),%eax
  800d0e:	99                   	cltd   
  800d0f:	eb 18                	jmp    800d29 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	8d 50 04             	lea    0x4(%eax),%edx
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	89 10                	mov    %edx,(%eax)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8b 00                	mov    (%eax),%eax
  800d23:	83 e8 04             	sub    $0x4,%eax
  800d26:	8b 00                	mov    (%eax),%eax
  800d28:	99                   	cltd   
}
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d33:	eb 17                	jmp    800d4c <vprintfmt+0x21>
			if (ch == '\0')
  800d35:	85 db                	test   %ebx,%ebx
  800d37:	0f 84 af 03 00 00    	je     8010ec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d3d:	83 ec 08             	sub    $0x8,%esp
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	53                   	push   %ebx
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	ff d0                	call   *%eax
  800d49:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4f:	8d 50 01             	lea    0x1(%eax),%edx
  800d52:	89 55 10             	mov    %edx,0x10(%ebp)
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	0f b6 d8             	movzbl %al,%ebx
  800d5a:	83 fb 25             	cmp    $0x25,%ebx
  800d5d:	75 d6                	jne    800d35 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d5f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d63:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d6a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d71:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d78:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	8d 50 01             	lea    0x1(%eax),%edx
  800d85:	89 55 10             	mov    %edx,0x10(%ebp)
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	0f b6 d8             	movzbl %al,%ebx
  800d8d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d90:	83 f8 55             	cmp    $0x55,%eax
  800d93:	0f 87 2b 03 00 00    	ja     8010c4 <vprintfmt+0x399>
  800d99:	8b 04 85 b8 40 80 00 	mov    0x8040b8(,%eax,4),%eax
  800da0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800da2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800da6:	eb d7                	jmp    800d7f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800da8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800dac:	eb d1                	jmp    800d7f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800db5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800db8:	89 d0                	mov    %edx,%eax
  800dba:	c1 e0 02             	shl    $0x2,%eax
  800dbd:	01 d0                	add    %edx,%eax
  800dbf:	01 c0                	add    %eax,%eax
  800dc1:	01 d8                	add    %ebx,%eax
  800dc3:	83 e8 30             	sub    $0x30,%eax
  800dc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dd1:	83 fb 2f             	cmp    $0x2f,%ebx
  800dd4:	7e 3e                	jle    800e14 <vprintfmt+0xe9>
  800dd6:	83 fb 39             	cmp    $0x39,%ebx
  800dd9:	7f 39                	jg     800e14 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ddb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dde:	eb d5                	jmp    800db5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800de0:	8b 45 14             	mov    0x14(%ebp),%eax
  800de3:	83 c0 04             	add    $0x4,%eax
  800de6:	89 45 14             	mov    %eax,0x14(%ebp)
  800de9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dec:	83 e8 04             	sub    $0x4,%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800df4:	eb 1f                	jmp    800e15 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800df6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfa:	79 83                	jns    800d7f <vprintfmt+0x54>
				width = 0;
  800dfc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e03:	e9 77 ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e08:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e0f:	e9 6b ff ff ff       	jmp    800d7f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e14:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e19:	0f 89 60 ff ff ff    	jns    800d7f <vprintfmt+0x54>
				width = precision, precision = -1;
  800e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e25:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e2c:	e9 4e ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e31:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e34:	e9 46 ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e39:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3c:	83 c0 04             	add    $0x4,%eax
  800e3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e42:	8b 45 14             	mov    0x14(%ebp),%eax
  800e45:	83 e8 04             	sub    $0x4,%eax
  800e48:	8b 00                	mov    (%eax),%eax
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	50                   	push   %eax
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	ff d0                	call   *%eax
  800e56:	83 c4 10             	add    $0x10,%esp
			break;
  800e59:	e9 89 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e61:	83 c0 04             	add    $0x4,%eax
  800e64:	89 45 14             	mov    %eax,0x14(%ebp)
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	83 e8 04             	sub    $0x4,%eax
  800e6d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e6f:	85 db                	test   %ebx,%ebx
  800e71:	79 02                	jns    800e75 <vprintfmt+0x14a>
				err = -err;
  800e73:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e75:	83 fb 64             	cmp    $0x64,%ebx
  800e78:	7f 0b                	jg     800e85 <vprintfmt+0x15a>
  800e7a:	8b 34 9d 00 3f 80 00 	mov    0x803f00(,%ebx,4),%esi
  800e81:	85 f6                	test   %esi,%esi
  800e83:	75 19                	jne    800e9e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e85:	53                   	push   %ebx
  800e86:	68 a5 40 80 00       	push   $0x8040a5
  800e8b:	ff 75 0c             	pushl  0xc(%ebp)
  800e8e:	ff 75 08             	pushl  0x8(%ebp)
  800e91:	e8 5e 02 00 00       	call   8010f4 <printfmt>
  800e96:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e99:	e9 49 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e9e:	56                   	push   %esi
  800e9f:	68 ae 40 80 00       	push   $0x8040ae
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	ff 75 08             	pushl  0x8(%ebp)
  800eaa:	e8 45 02 00 00       	call   8010f4 <printfmt>
  800eaf:	83 c4 10             	add    $0x10,%esp
			break;
  800eb2:	e9 30 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800eb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eba:	83 c0 04             	add    $0x4,%eax
  800ebd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec3:	83 e8 04             	sub    $0x4,%eax
  800ec6:	8b 30                	mov    (%eax),%esi
  800ec8:	85 f6                	test   %esi,%esi
  800eca:	75 05                	jne    800ed1 <vprintfmt+0x1a6>
				p = "(null)";
  800ecc:	be b1 40 80 00       	mov    $0x8040b1,%esi
			if (width > 0 && padc != '-')
  800ed1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed5:	7e 6d                	jle    800f44 <vprintfmt+0x219>
  800ed7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800edb:	74 67                	je     800f44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800edd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	50                   	push   %eax
  800ee4:	56                   	push   %esi
  800ee5:	e8 12 05 00 00       	call   8013fc <strnlen>
  800eea:	83 c4 10             	add    $0x10,%esp
  800eed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ef0:	eb 16                	jmp    800f08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ef2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	50                   	push   %eax
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	ff d0                	call   *%eax
  800f02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f05:	ff 4d e4             	decl   -0x1c(%ebp)
  800f08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0c:	7f e4                	jg     800ef2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f0e:	eb 34                	jmp    800f44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f14:	74 1c                	je     800f32 <vprintfmt+0x207>
  800f16:	83 fb 1f             	cmp    $0x1f,%ebx
  800f19:	7e 05                	jle    800f20 <vprintfmt+0x1f5>
  800f1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800f1e:	7e 12                	jle    800f32 <vprintfmt+0x207>
					putch('?', putdat);
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	ff 75 0c             	pushl  0xc(%ebp)
  800f26:	6a 3f                	push   $0x3f
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	ff d0                	call   *%eax
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	eb 0f                	jmp    800f41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f32:	83 ec 08             	sub    $0x8,%esp
  800f35:	ff 75 0c             	pushl  0xc(%ebp)
  800f38:	53                   	push   %ebx
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	ff d0                	call   *%eax
  800f3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f41:	ff 4d e4             	decl   -0x1c(%ebp)
  800f44:	89 f0                	mov    %esi,%eax
  800f46:	8d 70 01             	lea    0x1(%eax),%esi
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	0f be d8             	movsbl %al,%ebx
  800f4e:	85 db                	test   %ebx,%ebx
  800f50:	74 24                	je     800f76 <vprintfmt+0x24b>
  800f52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f56:	78 b8                	js     800f10 <vprintfmt+0x1e5>
  800f58:	ff 4d e0             	decl   -0x20(%ebp)
  800f5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f5f:	79 af                	jns    800f10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f61:	eb 13                	jmp    800f76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 0c             	pushl  0xc(%ebp)
  800f69:	6a 20                	push   $0x20
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	ff d0                	call   *%eax
  800f70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f73:	ff 4d e4             	decl   -0x1c(%ebp)
  800f76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7a:	7f e7                	jg     800f63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f7c:	e9 66 01 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f81:	83 ec 08             	sub    $0x8,%esp
  800f84:	ff 75 e8             	pushl  -0x18(%ebp)
  800f87:	8d 45 14             	lea    0x14(%ebp),%eax
  800f8a:	50                   	push   %eax
  800f8b:	e8 3c fd ff ff       	call   800ccc <getint>
  800f90:	83 c4 10             	add    $0x10,%esp
  800f93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9f:	85 d2                	test   %edx,%edx
  800fa1:	79 23                	jns    800fc6 <vprintfmt+0x29b>
				putch('-', putdat);
  800fa3:	83 ec 08             	sub    $0x8,%esp
  800fa6:	ff 75 0c             	pushl  0xc(%ebp)
  800fa9:	6a 2d                	push   $0x2d
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	ff d0                	call   *%eax
  800fb0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb9:	f7 d8                	neg    %eax
  800fbb:	83 d2 00             	adc    $0x0,%edx
  800fbe:	f7 da                	neg    %edx
  800fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fc6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fcd:	e9 bc 00 00 00       	jmp    80108e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 e8             	pushl  -0x18(%ebp)
  800fd8:	8d 45 14             	lea    0x14(%ebp),%eax
  800fdb:	50                   	push   %eax
  800fdc:	e8 84 fc ff ff       	call   800c65 <getuint>
  800fe1:	83 c4 10             	add    $0x10,%esp
  800fe4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ff1:	e9 98 00 00 00       	jmp    80108e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ff6:	83 ec 08             	sub    $0x8,%esp
  800ff9:	ff 75 0c             	pushl  0xc(%ebp)
  800ffc:	6a 58                	push   $0x58
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	6a 58                	push   $0x58
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	ff d0                	call   *%eax
  801013:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801016:	83 ec 08             	sub    $0x8,%esp
  801019:	ff 75 0c             	pushl  0xc(%ebp)
  80101c:	6a 58                	push   $0x58
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	ff d0                	call   *%eax
  801023:	83 c4 10             	add    $0x10,%esp
			break;
  801026:	e9 bc 00 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	6a 30                	push   $0x30
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	ff d0                	call   *%eax
  801038:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80103b:	83 ec 08             	sub    $0x8,%esp
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	6a 78                	push   $0x78
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	ff d0                	call   *%eax
  801048:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80104b:	8b 45 14             	mov    0x14(%ebp),%eax
  80104e:	83 c0 04             	add    $0x4,%eax
  801051:	89 45 14             	mov    %eax,0x14(%ebp)
  801054:	8b 45 14             	mov    0x14(%ebp),%eax
  801057:	83 e8 04             	sub    $0x4,%eax
  80105a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801066:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80106d:	eb 1f                	jmp    80108e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80106f:	83 ec 08             	sub    $0x8,%esp
  801072:	ff 75 e8             	pushl  -0x18(%ebp)
  801075:	8d 45 14             	lea    0x14(%ebp),%eax
  801078:	50                   	push   %eax
  801079:	e8 e7 fb ff ff       	call   800c65 <getuint>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801084:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801087:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80108e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	52                   	push   %edx
  801099:	ff 75 e4             	pushl  -0x1c(%ebp)
  80109c:	50                   	push   %eax
  80109d:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	ff 75 08             	pushl  0x8(%ebp)
  8010a9:	e8 00 fb ff ff       	call   800bae <printnum>
  8010ae:	83 c4 20             	add    $0x20,%esp
			break;
  8010b1:	eb 34                	jmp    8010e7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010b3:	83 ec 08             	sub    $0x8,%esp
  8010b6:	ff 75 0c             	pushl  0xc(%ebp)
  8010b9:	53                   	push   %ebx
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	ff d0                	call   *%eax
  8010bf:	83 c4 10             	add    $0x10,%esp
			break;
  8010c2:	eb 23                	jmp    8010e7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010c4:	83 ec 08             	sub    $0x8,%esp
  8010c7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ca:	6a 25                	push   $0x25
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	ff d0                	call   *%eax
  8010d1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010d4:	ff 4d 10             	decl   0x10(%ebp)
  8010d7:	eb 03                	jmp    8010dc <vprintfmt+0x3b1>
  8010d9:	ff 4d 10             	decl   0x10(%ebp)
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	48                   	dec    %eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	3c 25                	cmp    $0x25,%al
  8010e4:	75 f3                	jne    8010d9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8010e6:	90                   	nop
		}
	}
  8010e7:	e9 47 fc ff ff       	jmp    800d33 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010ec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    

008010f4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8010fd:	83 c0 04             	add    $0x4,%eax
  801100:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801103:	8b 45 10             	mov    0x10(%ebp),%eax
  801106:	ff 75 f4             	pushl  -0xc(%ebp)
  801109:	50                   	push   %eax
  80110a:	ff 75 0c             	pushl  0xc(%ebp)
  80110d:	ff 75 08             	pushl  0x8(%ebp)
  801110:	e8 16 fc ff ff       	call   800d2b <vprintfmt>
  801115:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801118:	90                   	nop
  801119:	c9                   	leave  
  80111a:	c3                   	ret    

0080111b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	8b 40 08             	mov    0x8(%eax),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	8b 10                	mov    (%eax),%edx
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	8b 40 04             	mov    0x4(%eax),%eax
  801138:	39 c2                	cmp    %eax,%edx
  80113a:	73 12                	jae    80114e <sprintputch+0x33>
		*b->buf++ = ch;
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8b 00                	mov    (%eax),%eax
  801141:	8d 48 01             	lea    0x1(%eax),%ecx
  801144:	8b 55 0c             	mov    0xc(%ebp),%edx
  801147:	89 0a                	mov    %ecx,(%edx)
  801149:	8b 55 08             	mov    0x8(%ebp),%edx
  80114c:	88 10                	mov    %dl,(%eax)
}
  80114e:	90                   	nop
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    

00801151 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	8d 50 ff             	lea    -0x1(%eax),%edx
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	01 d0                	add    %edx,%eax
  801168:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80116b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801172:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801176:	74 06                	je     80117e <vsnprintf+0x2d>
  801178:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80117c:	7f 07                	jg     801185 <vsnprintf+0x34>
		return -E_INVAL;
  80117e:	b8 03 00 00 00       	mov    $0x3,%eax
  801183:	eb 20                	jmp    8011a5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801185:	ff 75 14             	pushl  0x14(%ebp)
  801188:	ff 75 10             	pushl  0x10(%ebp)
  80118b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80118e:	50                   	push   %eax
  80118f:	68 1b 11 80 00       	push   $0x80111b
  801194:	e8 92 fb ff ff       	call   800d2b <vprintfmt>
  801199:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80119c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    

008011a7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8011b0:	83 c0 04             	add    $0x4,%eax
  8011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bc:	50                   	push   %eax
  8011bd:	ff 75 0c             	pushl  0xc(%ebp)
  8011c0:	ff 75 08             	pushl  0x8(%ebp)
  8011c3:	e8 89 ff ff ff       	call   801151 <vsnprintf>
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8011d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011dd:	74 13                	je     8011f2 <readline+0x1f>
		cprintf("%s", prompt);
  8011df:	83 ec 08             	sub    $0x8,%esp
  8011e2:	ff 75 08             	pushl  0x8(%ebp)
  8011e5:	68 10 42 80 00       	push   $0x804210
  8011ea:	e8 62 f9 ff ff       	call   800b51 <cprintf>
  8011ef:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f9:	83 ec 0c             	sub    $0xc,%esp
  8011fc:	6a 00                	push   $0x0
  8011fe:	e8 54 f5 ff ff       	call   800757 <iscons>
  801203:	83 c4 10             	add    $0x10,%esp
  801206:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801209:	e8 fb f4 ff ff       	call   800709 <getchar>
  80120e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801211:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801215:	79 22                	jns    801239 <readline+0x66>
			if (c != -E_EOF)
  801217:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80121b:	0f 84 ad 00 00 00    	je     8012ce <readline+0xfb>
				cprintf("read error: %e\n", c);
  801221:	83 ec 08             	sub    $0x8,%esp
  801224:	ff 75 ec             	pushl  -0x14(%ebp)
  801227:	68 13 42 80 00       	push   $0x804213
  80122c:	e8 20 f9 ff ff       	call   800b51 <cprintf>
  801231:	83 c4 10             	add    $0x10,%esp
			return;
  801234:	e9 95 00 00 00       	jmp    8012ce <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801239:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80123d:	7e 34                	jle    801273 <readline+0xa0>
  80123f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801246:	7f 2b                	jg     801273 <readline+0xa0>
			if (echoing)
  801248:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80124c:	74 0e                	je     80125c <readline+0x89>
				cputchar(c);
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	ff 75 ec             	pushl  -0x14(%ebp)
  801254:	e8 68 f4 ff ff       	call   8006c1 <cputchar>
  801259:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80125c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125f:	8d 50 01             	lea    0x1(%eax),%edx
  801262:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801265:	89 c2                	mov    %eax,%edx
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	01 d0                	add    %edx,%eax
  80126c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80126f:	88 10                	mov    %dl,(%eax)
  801271:	eb 56                	jmp    8012c9 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801273:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801277:	75 1f                	jne    801298 <readline+0xc5>
  801279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80127d:	7e 19                	jle    801298 <readline+0xc5>
			if (echoing)
  80127f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801283:	74 0e                	je     801293 <readline+0xc0>
				cputchar(c);
  801285:	83 ec 0c             	sub    $0xc,%esp
  801288:	ff 75 ec             	pushl  -0x14(%ebp)
  80128b:	e8 31 f4 ff ff       	call   8006c1 <cputchar>
  801290:	83 c4 10             	add    $0x10,%esp

			i--;
  801293:	ff 4d f4             	decl   -0xc(%ebp)
  801296:	eb 31                	jmp    8012c9 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801298:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80129c:	74 0a                	je     8012a8 <readline+0xd5>
  80129e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012a2:	0f 85 61 ff ff ff    	jne    801209 <readline+0x36>
			if (echoing)
  8012a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012ac:	74 0e                	je     8012bc <readline+0xe9>
				cputchar(c);
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b4:	e8 08 f4 ff ff       	call   8006c1 <cputchar>
  8012b9:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	01 d0                	add    %edx,%eax
  8012c4:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8012c7:	eb 06                	jmp    8012cf <readline+0xfc>
		}
	}
  8012c9:	e9 3b ff ff ff       	jmp    801209 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8012ce:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8012d7:	e8 20 0f 00 00       	call   8021fc <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8012dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e0:	74 13                	je     8012f5 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8012e2:	83 ec 08             	sub    $0x8,%esp
  8012e5:	ff 75 08             	pushl  0x8(%ebp)
  8012e8:	68 10 42 80 00       	push   $0x804210
  8012ed:	e8 5f f8 ff ff       	call   800b51 <cprintf>
  8012f2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	6a 00                	push   $0x0
  801301:	e8 51 f4 ff ff       	call   800757 <iscons>
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80130c:	e8 f8 f3 ff ff       	call   800709 <getchar>
  801311:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801314:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801318:	79 23                	jns    80133d <atomic_readline+0x6c>
			if (c != -E_EOF)
  80131a:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80131e:	74 13                	je     801333 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801320:	83 ec 08             	sub    $0x8,%esp
  801323:	ff 75 ec             	pushl  -0x14(%ebp)
  801326:	68 13 42 80 00       	push   $0x804213
  80132b:	e8 21 f8 ff ff       	call   800b51 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801333:	e8 de 0e 00 00       	call   802216 <sys_enable_interrupt>
			return;
  801338:	e9 9a 00 00 00       	jmp    8013d7 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80133d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801341:	7e 34                	jle    801377 <atomic_readline+0xa6>
  801343:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134a:	7f 2b                	jg     801377 <atomic_readline+0xa6>
			if (echoing)
  80134c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801350:	74 0e                	je     801360 <atomic_readline+0x8f>
				cputchar(c);
  801352:	83 ec 0c             	sub    $0xc,%esp
  801355:	ff 75 ec             	pushl  -0x14(%ebp)
  801358:	e8 64 f3 ff ff       	call   8006c1 <cputchar>
  80135d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801363:	8d 50 01             	lea    0x1(%eax),%edx
  801366:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801369:	89 c2                	mov    %eax,%edx
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801373:	88 10                	mov    %dl,(%eax)
  801375:	eb 5b                	jmp    8013d2 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801377:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137b:	75 1f                	jne    80139c <atomic_readline+0xcb>
  80137d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801381:	7e 19                	jle    80139c <atomic_readline+0xcb>
			if (echoing)
  801383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801387:	74 0e                	je     801397 <atomic_readline+0xc6>
				cputchar(c);
  801389:	83 ec 0c             	sub    $0xc,%esp
  80138c:	ff 75 ec             	pushl  -0x14(%ebp)
  80138f:	e8 2d f3 ff ff       	call   8006c1 <cputchar>
  801394:	83 c4 10             	add    $0x10,%esp
			i--;
  801397:	ff 4d f4             	decl   -0xc(%ebp)
  80139a:	eb 36                	jmp    8013d2 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80139c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a0:	74 0a                	je     8013ac <atomic_readline+0xdb>
  8013a2:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a6:	0f 85 60 ff ff ff    	jne    80130c <atomic_readline+0x3b>
			if (echoing)
  8013ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b0:	74 0e                	je     8013c0 <atomic_readline+0xef>
				cputchar(c);
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b8:	e8 04 f3 ff ff       	call   8006c1 <cputchar>
  8013bd:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c6:	01 d0                	add    %edx,%eax
  8013c8:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8013cb:	e8 46 0e 00 00       	call   802216 <sys_enable_interrupt>
			return;
  8013d0:	eb 05                	jmp    8013d7 <atomic_readline+0x106>
		}
	}
  8013d2:	e9 35 ff ff ff       	jmp    80130c <atomic_readline+0x3b>
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e6:	eb 06                	jmp    8013ee <strlen+0x15>
		n++;
  8013e8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013eb:	ff 45 08             	incl   0x8(%ebp)
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	84 c0                	test   %al,%al
  8013f5:	75 f1                	jne    8013e8 <strlen+0xf>
		n++;
	return n;
  8013f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801409:	eb 09                	jmp    801414 <strnlen+0x18>
		n++;
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80140e:	ff 45 08             	incl   0x8(%ebp)
  801411:	ff 4d 0c             	decl   0xc(%ebp)
  801414:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801418:	74 09                	je     801423 <strnlen+0x27>
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	84 c0                	test   %al,%al
  801421:	75 e8                	jne    80140b <strnlen+0xf>
		n++;
	return n;
  801423:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801434:	90                   	nop
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8d 50 01             	lea    0x1(%eax),%edx
  80143b:	89 55 08             	mov    %edx,0x8(%ebp)
  80143e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801441:	8d 4a 01             	lea    0x1(%edx),%ecx
  801444:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801447:	8a 12                	mov    (%edx),%dl
  801449:	88 10                	mov    %dl,(%eax)
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	84 c0                	test   %al,%al
  80144f:	75 e4                	jne    801435 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801451:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801462:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801469:	eb 1f                	jmp    80148a <strncpy+0x34>
		*dst++ = *src;
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8d 50 01             	lea    0x1(%eax),%edx
  801471:	89 55 08             	mov    %edx,0x8(%ebp)
  801474:	8b 55 0c             	mov    0xc(%ebp),%edx
  801477:	8a 12                	mov    (%edx),%dl
  801479:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80147b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	84 c0                	test   %al,%al
  801482:	74 03                	je     801487 <strncpy+0x31>
			src++;
  801484:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801487:	ff 45 fc             	incl   -0x4(%ebp)
  80148a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801490:	72 d9                	jb     80146b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801492:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a7:	74 30                	je     8014d9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014a9:	eb 16                	jmp    8014c1 <strlcpy+0x2a>
			*dst++ = *src++;
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8d 50 01             	lea    0x1(%eax),%edx
  8014b1:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014bd:	8a 12                	mov    (%edx),%dl
  8014bf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014c1:	ff 4d 10             	decl   0x10(%ebp)
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	74 09                	je     8014d3 <strlcpy+0x3c>
  8014ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	84 c0                	test   %al,%al
  8014d1:	75 d8                	jne    8014ab <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014df:	29 c2                	sub    %eax,%edx
  8014e1:	89 d0                	mov    %edx,%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014e8:	eb 06                	jmp    8014f0 <strcmp+0xb>
		p++, q++;
  8014ea:	ff 45 08             	incl   0x8(%ebp)
  8014ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	84 c0                	test   %al,%al
  8014f7:	74 0e                	je     801507 <strcmp+0x22>
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	8a 10                	mov    (%eax),%dl
  8014fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	38 c2                	cmp    %al,%dl
  801505:	74 e3                	je     8014ea <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	0f b6 d0             	movzbl %al,%edx
  80150f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	0f b6 c0             	movzbl %al,%eax
  801517:	29 c2                	sub    %eax,%edx
  801519:	89 d0                	mov    %edx,%eax
}
  80151b:	5d                   	pop    %ebp
  80151c:	c3                   	ret    

0080151d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801520:	eb 09                	jmp    80152b <strncmp+0xe>
		n--, p++, q++;
  801522:	ff 4d 10             	decl   0x10(%ebp)
  801525:	ff 45 08             	incl   0x8(%ebp)
  801528:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80152b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152f:	74 17                	je     801548 <strncmp+0x2b>
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	84 c0                	test   %al,%al
  801538:	74 0e                	je     801548 <strncmp+0x2b>
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 10                	mov    (%eax),%dl
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	38 c2                	cmp    %al,%dl
  801546:	74 da                	je     801522 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801548:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80154c:	75 07                	jne    801555 <strncmp+0x38>
		return 0;
  80154e:	b8 00 00 00 00       	mov    $0x0,%eax
  801553:	eb 14                	jmp    801569 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	8a 00                	mov    (%eax),%al
  80155a:	0f b6 d0             	movzbl %al,%edx
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	0f b6 c0             	movzbl %al,%eax
  801565:	29 c2                	sub    %eax,%edx
  801567:	89 d0                	mov    %edx,%eax
}
  801569:	5d                   	pop    %ebp
  80156a:	c3                   	ret    

0080156b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801577:	eb 12                	jmp    80158b <strchr+0x20>
		if (*s == c)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801581:	75 05                	jne    801588 <strchr+0x1d>
			return (char *) s;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	eb 11                	jmp    801599 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801588:	ff 45 08             	incl   0x8(%ebp)
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	84 c0                	test   %al,%al
  801592:	75 e5                	jne    801579 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801594:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015a7:	eb 0d                	jmp    8015b6 <strfind+0x1b>
		if (*s == c)
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	8a 00                	mov    (%eax),%al
  8015ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015b1:	74 0e                	je     8015c1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015b3:	ff 45 08             	incl   0x8(%ebp)
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8a 00                	mov    (%eax),%al
  8015bb:	84 c0                	test   %al,%al
  8015bd:	75 ea                	jne    8015a9 <strfind+0xe>
  8015bf:	eb 01                	jmp    8015c2 <strfind+0x27>
		if (*s == c)
			break;
  8015c1:	90                   	nop
	return (char *) s;
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015d9:	eb 0e                	jmp    8015e9 <memset+0x22>
		*p++ = c;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015de:	8d 50 01             	lea    0x1(%eax),%edx
  8015e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015e9:	ff 4d f8             	decl   -0x8(%ebp)
  8015ec:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015f0:	79 e9                	jns    8015db <memset+0x14>
		*p++ = c;

	return v;
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801600:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801609:	eb 16                	jmp    801621 <memcpy+0x2a>
		*d++ = *s++;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	8d 50 ff             	lea    -0x1(%eax),%edx
  801627:	89 55 10             	mov    %edx,0x10(%ebp)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	75 dd                	jne    80160b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801645:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801648:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80164b:	73 50                	jae    80169d <memmove+0x6a>
  80164d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801650:	8b 45 10             	mov    0x10(%ebp),%eax
  801653:	01 d0                	add    %edx,%eax
  801655:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801658:	76 43                	jbe    80169d <memmove+0x6a>
		s += n;
  80165a:	8b 45 10             	mov    0x10(%ebp),%eax
  80165d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801660:	8b 45 10             	mov    0x10(%ebp),%eax
  801663:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801666:	eb 10                	jmp    801678 <memmove+0x45>
			*--d = *--s;
  801668:	ff 4d f8             	decl   -0x8(%ebp)
  80166b:	ff 4d fc             	decl   -0x4(%ebp)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	8a 10                	mov    (%eax),%dl
  801673:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801676:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801678:	8b 45 10             	mov    0x10(%ebp),%eax
  80167b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80167e:	89 55 10             	mov    %edx,0x10(%ebp)
  801681:	85 c0                	test   %eax,%eax
  801683:	75 e3                	jne    801668 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801685:	eb 23                	jmp    8016aa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801687:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168a:	8d 50 01             	lea    0x1(%eax),%edx
  80168d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801690:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801693:	8d 4a 01             	lea    0x1(%edx),%ecx
  801696:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801699:	8a 12                	mov    (%edx),%dl
  80169b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	75 dd                	jne    801687 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016be:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016c1:	eb 2a                	jmp    8016ed <memcmp+0x3e>
		if (*s1 != *s2)
  8016c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c6:	8a 10                	mov    (%eax),%dl
  8016c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	38 c2                	cmp    %al,%dl
  8016cf:	74 16                	je     8016e7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f b6 d0             	movzbl %al,%edx
  8016d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dc:	8a 00                	mov    (%eax),%al
  8016de:	0f b6 c0             	movzbl %al,%eax
  8016e1:	29 c2                	sub    %eax,%edx
  8016e3:	89 d0                	mov    %edx,%eax
  8016e5:	eb 18                	jmp    8016ff <memcmp+0x50>
		s1++, s2++;
  8016e7:	ff 45 fc             	incl   -0x4(%ebp)
  8016ea:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	75 c9                	jne    8016c3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801707:	8b 55 08             	mov    0x8(%ebp),%edx
  80170a:	8b 45 10             	mov    0x10(%ebp),%eax
  80170d:	01 d0                	add    %edx,%eax
  80170f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801712:	eb 15                	jmp    801729 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	8a 00                	mov    (%eax),%al
  801719:	0f b6 d0             	movzbl %al,%edx
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	0f b6 c0             	movzbl %al,%eax
  801722:	39 c2                	cmp    %eax,%edx
  801724:	74 0d                	je     801733 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801726:	ff 45 08             	incl   0x8(%ebp)
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80172f:	72 e3                	jb     801714 <memfind+0x13>
  801731:	eb 01                	jmp    801734 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801733:	90                   	nop
	return (void *) s;
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80173f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801746:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174d:	eb 03                	jmp    801752 <strtol+0x19>
		s++;
  80174f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	3c 20                	cmp    $0x20,%al
  801759:	74 f4                	je     80174f <strtol+0x16>
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	3c 09                	cmp    $0x9,%al
  801762:	74 eb                	je     80174f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 2b                	cmp    $0x2b,%al
  80176b:	75 05                	jne    801772 <strtol+0x39>
		s++;
  80176d:	ff 45 08             	incl   0x8(%ebp)
  801770:	eb 13                	jmp    801785 <strtol+0x4c>
	else if (*s == '-')
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	8a 00                	mov    (%eax),%al
  801777:	3c 2d                	cmp    $0x2d,%al
  801779:	75 0a                	jne    801785 <strtol+0x4c>
		s++, neg = 1;
  80177b:	ff 45 08             	incl   0x8(%ebp)
  80177e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801785:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801789:	74 06                	je     801791 <strtol+0x58>
  80178b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80178f:	75 20                	jne    8017b1 <strtol+0x78>
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	3c 30                	cmp    $0x30,%al
  801798:	75 17                	jne    8017b1 <strtol+0x78>
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	40                   	inc    %eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	3c 78                	cmp    $0x78,%al
  8017a2:	75 0d                	jne    8017b1 <strtol+0x78>
		s += 2, base = 16;
  8017a4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017a8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017af:	eb 28                	jmp    8017d9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b5:	75 15                	jne    8017cc <strtol+0x93>
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	8a 00                	mov    (%eax),%al
  8017bc:	3c 30                	cmp    $0x30,%al
  8017be:	75 0c                	jne    8017cc <strtol+0x93>
		s++, base = 8;
  8017c0:	ff 45 08             	incl   0x8(%ebp)
  8017c3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017ca:	eb 0d                	jmp    8017d9 <strtol+0xa0>
	else if (base == 0)
  8017cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d0:	75 07                	jne    8017d9 <strtol+0xa0>
		base = 10;
  8017d2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8a 00                	mov    (%eax),%al
  8017de:	3c 2f                	cmp    $0x2f,%al
  8017e0:	7e 19                	jle    8017fb <strtol+0xc2>
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	3c 39                	cmp    $0x39,%al
  8017e9:	7f 10                	jg     8017fb <strtol+0xc2>
			dig = *s - '0';
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	0f be c0             	movsbl %al,%eax
  8017f3:	83 e8 30             	sub    $0x30,%eax
  8017f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f9:	eb 42                	jmp    80183d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8a 00                	mov    (%eax),%al
  801800:	3c 60                	cmp    $0x60,%al
  801802:	7e 19                	jle    80181d <strtol+0xe4>
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8a 00                	mov    (%eax),%al
  801809:	3c 7a                	cmp    $0x7a,%al
  80180b:	7f 10                	jg     80181d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	0f be c0             	movsbl %al,%eax
  801815:	83 e8 57             	sub    $0x57,%eax
  801818:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80181b:	eb 20                	jmp    80183d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	8a 00                	mov    (%eax),%al
  801822:	3c 40                	cmp    $0x40,%al
  801824:	7e 39                	jle    80185f <strtol+0x126>
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	3c 5a                	cmp    $0x5a,%al
  80182d:	7f 30                	jg     80185f <strtol+0x126>
			dig = *s - 'A' + 10;
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	0f be c0             	movsbl %al,%eax
  801837:	83 e8 37             	sub    $0x37,%eax
  80183a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80183d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801840:	3b 45 10             	cmp    0x10(%ebp),%eax
  801843:	7d 19                	jge    80185e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801845:	ff 45 08             	incl   0x8(%ebp)
  801848:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80184f:	89 c2                	mov    %eax,%edx
  801851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801854:	01 d0                	add    %edx,%eax
  801856:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801859:	e9 7b ff ff ff       	jmp    8017d9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80185e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80185f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801863:	74 08                	je     80186d <strtol+0x134>
		*endptr = (char *) s;
  801865:	8b 45 0c             	mov    0xc(%ebp),%eax
  801868:	8b 55 08             	mov    0x8(%ebp),%edx
  80186b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80186d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801871:	74 07                	je     80187a <strtol+0x141>
  801873:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801876:	f7 d8                	neg    %eax
  801878:	eb 03                	jmp    80187d <strtol+0x144>
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <ltostr>:

void
ltostr(long value, char *str)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801885:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80188c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801893:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801897:	79 13                	jns    8018ac <ltostr+0x2d>
	{
		neg = 1;
  801899:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018a6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018a9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018b4:	99                   	cltd   
  8018b5:	f7 f9                	idiv   %ecx
  8018b7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018bd:	8d 50 01             	lea    0x1(%eax),%edx
  8018c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018c3:	89 c2                	mov    %eax,%edx
  8018c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c8:	01 d0                	add    %edx,%eax
  8018ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018cd:	83 c2 30             	add    $0x30,%edx
  8018d0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018da:	f7 e9                	imul   %ecx
  8018dc:	c1 fa 02             	sar    $0x2,%edx
  8018df:	89 c8                	mov    %ecx,%eax
  8018e1:	c1 f8 1f             	sar    $0x1f,%eax
  8018e4:	29 c2                	sub    %eax,%edx
  8018e6:	89 d0                	mov    %edx,%eax
  8018e8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018f3:	f7 e9                	imul   %ecx
  8018f5:	c1 fa 02             	sar    $0x2,%edx
  8018f8:	89 c8                	mov    %ecx,%eax
  8018fa:	c1 f8 1f             	sar    $0x1f,%eax
  8018fd:	29 c2                	sub    %eax,%edx
  8018ff:	89 d0                	mov    %edx,%eax
  801901:	c1 e0 02             	shl    $0x2,%eax
  801904:	01 d0                	add    %edx,%eax
  801906:	01 c0                	add    %eax,%eax
  801908:	29 c1                	sub    %eax,%ecx
  80190a:	89 ca                	mov    %ecx,%edx
  80190c:	85 d2                	test   %edx,%edx
  80190e:	75 9c                	jne    8018ac <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801917:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191a:	48                   	dec    %eax
  80191b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80191e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801922:	74 3d                	je     801961 <ltostr+0xe2>
		start = 1 ;
  801924:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80192b:	eb 34                	jmp    801961 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80192d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801930:	8b 45 0c             	mov    0xc(%ebp),%eax
  801933:	01 d0                	add    %edx,%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80193a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80193d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801940:	01 c2                	add    %eax,%edx
  801942:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801945:	8b 45 0c             	mov    0xc(%ebp),%eax
  801948:	01 c8                	add    %ecx,%eax
  80194a:	8a 00                	mov    (%eax),%al
  80194c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80194e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801951:	8b 45 0c             	mov    0xc(%ebp),%eax
  801954:	01 c2                	add    %eax,%edx
  801956:	8a 45 eb             	mov    -0x15(%ebp),%al
  801959:	88 02                	mov    %al,(%edx)
		start++ ;
  80195b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80195e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801964:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801967:	7c c4                	jl     80192d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801969:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80196c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196f:	01 d0                	add    %edx,%eax
  801971:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801974:	90                   	nop
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80197d:	ff 75 08             	pushl  0x8(%ebp)
  801980:	e8 54 fa ff ff       	call   8013d9 <strlen>
  801985:	83 c4 04             	add    $0x4,%esp
  801988:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80198b:	ff 75 0c             	pushl  0xc(%ebp)
  80198e:	e8 46 fa ff ff       	call   8013d9 <strlen>
  801993:	83 c4 04             	add    $0x4,%esp
  801996:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801999:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019a7:	eb 17                	jmp    8019c0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8019af:	01 c2                	add    %eax,%edx
  8019b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	01 c8                	add    %ecx,%eax
  8019b9:	8a 00                	mov    (%eax),%al
  8019bb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019bd:	ff 45 fc             	incl   -0x4(%ebp)
  8019c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019c6:	7c e1                	jl     8019a9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019d6:	eb 1f                	jmp    8019f7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019db:	8d 50 01             	lea    0x1(%eax),%edx
  8019de:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019e1:	89 c2                	mov    %eax,%edx
  8019e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e6:	01 c2                	add    %eax,%edx
  8019e8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ee:	01 c8                	add    %ecx,%eax
  8019f0:	8a 00                	mov    (%eax),%al
  8019f2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019f4:	ff 45 f8             	incl   -0x8(%ebp)
  8019f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019fd:	7c d9                	jl     8019d8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a02:	8b 45 10             	mov    0x10(%ebp),%eax
  801a05:	01 d0                	add    %edx,%eax
  801a07:	c6 00 00             	movb   $0x0,(%eax)
}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a10:	8b 45 14             	mov    0x14(%ebp),%eax
  801a13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a19:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1c:	8b 00                	mov    (%eax),%eax
  801a1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a25:	8b 45 10             	mov    0x10(%ebp),%eax
  801a28:	01 d0                	add    %edx,%eax
  801a2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a30:	eb 0c                	jmp    801a3e <strsplit+0x31>
			*string++ = 0;
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	8d 50 01             	lea    0x1(%eax),%edx
  801a38:	89 55 08             	mov    %edx,0x8(%ebp)
  801a3b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	84 c0                	test   %al,%al
  801a45:	74 18                	je     801a5f <strsplit+0x52>
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	8a 00                	mov    (%eax),%al
  801a4c:	0f be c0             	movsbl %al,%eax
  801a4f:	50                   	push   %eax
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	e8 13 fb ff ff       	call   80156b <strchr>
  801a58:	83 c4 08             	add    $0x8,%esp
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	75 d3                	jne    801a32 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	8a 00                	mov    (%eax),%al
  801a64:	84 c0                	test   %al,%al
  801a66:	74 5a                	je     801ac2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a68:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6b:	8b 00                	mov    (%eax),%eax
  801a6d:	83 f8 0f             	cmp    $0xf,%eax
  801a70:	75 07                	jne    801a79 <strsplit+0x6c>
		{
			return 0;
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax
  801a77:	eb 66                	jmp    801adf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a79:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7c:	8b 00                	mov    (%eax),%eax
  801a7e:	8d 48 01             	lea    0x1(%eax),%ecx
  801a81:	8b 55 14             	mov    0x14(%ebp),%edx
  801a84:	89 0a                	mov    %ecx,(%edx)
  801a86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a90:	01 c2                	add    %eax,%edx
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a97:	eb 03                	jmp    801a9c <strsplit+0x8f>
			string++;
  801a99:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8a 00                	mov    (%eax),%al
  801aa1:	84 c0                	test   %al,%al
  801aa3:	74 8b                	je     801a30 <strsplit+0x23>
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	8a 00                	mov    (%eax),%al
  801aaa:	0f be c0             	movsbl %al,%eax
  801aad:	50                   	push   %eax
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	e8 b5 fa ff ff       	call   80156b <strchr>
  801ab6:	83 c4 08             	add    $0x8,%esp
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	74 dc                	je     801a99 <strsplit+0x8c>
			string++;
	}
  801abd:	e9 6e ff ff ff       	jmp    801a30 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ac2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac6:	8b 00                	mov    (%eax),%eax
  801ac8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801acf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad2:	01 d0                	add    %edx,%eax
  801ad4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ada:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801ae7:	a1 04 50 80 00       	mov    0x805004,%eax
  801aec:	85 c0                	test   %eax,%eax
  801aee:	74 1f                	je     801b0f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801af0:	e8 1d 00 00 00       	call   801b12 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801af5:	83 ec 0c             	sub    $0xc,%esp
  801af8:	68 24 42 80 00       	push   $0x804224
  801afd:	e8 4f f0 ff ff       	call   800b51 <cprintf>
  801b02:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b05:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b0c:	00 00 00 
	}
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801b18:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b1f:	00 00 00 
  801b22:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b29:	00 00 00 
  801b2c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b33:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801b36:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b3d:	00 00 00 
  801b40:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b47:	00 00 00 
  801b4a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b51:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801b54:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b63:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b68:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801b6d:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b74:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801b77:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b81:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801b86:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b91:	f7 75 f0             	divl   -0x10(%ebp)
  801b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b97:	29 d0                	sub    %edx,%eax
  801b99:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801b9c:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801ba3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ba6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bab:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bb0:	83 ec 04             	sub    $0x4,%esp
  801bb3:	6a 06                	push   $0x6
  801bb5:	ff 75 e8             	pushl  -0x18(%ebp)
  801bb8:	50                   	push   %eax
  801bb9:	e8 d4 05 00 00       	call   802192 <sys_allocate_chunk>
  801bbe:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bc1:	a1 20 51 80 00       	mov    0x805120,%eax
  801bc6:	83 ec 0c             	sub    $0xc,%esp
  801bc9:	50                   	push   %eax
  801bca:	e8 49 0c 00 00       	call   802818 <initialize_MemBlocksList>
  801bcf:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801bd2:	a1 48 51 80 00       	mov    0x805148,%eax
  801bd7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801bda:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801bde:	75 14                	jne    801bf4 <initialize_dyn_block_system+0xe2>
  801be0:	83 ec 04             	sub    $0x4,%esp
  801be3:	68 49 42 80 00       	push   $0x804249
  801be8:	6a 39                	push   $0x39
  801bea:	68 67 42 80 00       	push   $0x804267
  801bef:	e8 a9 ec ff ff       	call   80089d <_panic>
  801bf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bf7:	8b 00                	mov    (%eax),%eax
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	74 10                	je     801c0d <initialize_dyn_block_system+0xfb>
  801bfd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c00:	8b 00                	mov    (%eax),%eax
  801c02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c05:	8b 52 04             	mov    0x4(%edx),%edx
  801c08:	89 50 04             	mov    %edx,0x4(%eax)
  801c0b:	eb 0b                	jmp    801c18 <initialize_dyn_block_system+0x106>
  801c0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c10:	8b 40 04             	mov    0x4(%eax),%eax
  801c13:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c1b:	8b 40 04             	mov    0x4(%eax),%eax
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	74 0f                	je     801c31 <initialize_dyn_block_system+0x11f>
  801c22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c25:	8b 40 04             	mov    0x4(%eax),%eax
  801c28:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c2b:	8b 12                	mov    (%edx),%edx
  801c2d:	89 10                	mov    %edx,(%eax)
  801c2f:	eb 0a                	jmp    801c3b <initialize_dyn_block_system+0x129>
  801c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c34:	8b 00                	mov    (%eax),%eax
  801c36:	a3 48 51 80 00       	mov    %eax,0x805148
  801c3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c4e:	a1 54 51 80 00       	mov    0x805154,%eax
  801c53:	48                   	dec    %eax
  801c54:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801c59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c5c:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801c63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c66:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801c6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c71:	75 14                	jne    801c87 <initialize_dyn_block_system+0x175>
  801c73:	83 ec 04             	sub    $0x4,%esp
  801c76:	68 74 42 80 00       	push   $0x804274
  801c7b:	6a 3f                	push   $0x3f
  801c7d:	68 67 42 80 00       	push   $0x804267
  801c82:	e8 16 ec ff ff       	call   80089d <_panic>
  801c87:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801c8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c90:	89 10                	mov    %edx,(%eax)
  801c92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c95:	8b 00                	mov    (%eax),%eax
  801c97:	85 c0                	test   %eax,%eax
  801c99:	74 0d                	je     801ca8 <initialize_dyn_block_system+0x196>
  801c9b:	a1 38 51 80 00       	mov    0x805138,%eax
  801ca0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ca3:	89 50 04             	mov    %edx,0x4(%eax)
  801ca6:	eb 08                	jmp    801cb0 <initialize_dyn_block_system+0x19e>
  801ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cab:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801cb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cb3:	a3 38 51 80 00       	mov    %eax,0x805138
  801cb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cc2:	a1 44 51 80 00       	mov    0x805144,%eax
  801cc7:	40                   	inc    %eax
  801cc8:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801ccd:	90                   	nop
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cd6:	e8 06 fe ff ff       	call   801ae1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cdb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cdf:	75 07                	jne    801ce8 <malloc+0x18>
  801ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce6:	eb 7d                	jmp    801d65 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801ce8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801cef:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  801cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfc:	01 d0                	add    %edx,%eax
  801cfe:	48                   	dec    %eax
  801cff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d05:	ba 00 00 00 00       	mov    $0x0,%edx
  801d0a:	f7 75 f0             	divl   -0x10(%ebp)
  801d0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d10:	29 d0                	sub    %edx,%eax
  801d12:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801d15:	e8 46 08 00 00       	call   802560 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d1a:	83 f8 01             	cmp    $0x1,%eax
  801d1d:	75 07                	jne    801d26 <malloc+0x56>
  801d1f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801d26:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801d2a:	75 34                	jne    801d60 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801d2c:	83 ec 0c             	sub    $0xc,%esp
  801d2f:	ff 75 e8             	pushl  -0x18(%ebp)
  801d32:	e8 73 0e 00 00       	call   802baa <alloc_block_FF>
  801d37:	83 c4 10             	add    $0x10,%esp
  801d3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801d3d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d41:	74 16                	je     801d59 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801d43:	83 ec 0c             	sub    $0xc,%esp
  801d46:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d49:	e8 ff 0b 00 00       	call   80294d <insert_sorted_allocList>
  801d4e:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801d51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d54:	8b 40 08             	mov    0x8(%eax),%eax
  801d57:	eb 0c                	jmp    801d65 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801d59:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5e:	eb 05                	jmp    801d65 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801d60:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d81:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801d84:	83 ec 08             	sub    $0x8,%esp
  801d87:	ff 75 f4             	pushl  -0xc(%ebp)
  801d8a:	68 40 50 80 00       	push   $0x805040
  801d8f:	e8 61 0b 00 00       	call   8028f5 <find_block>
  801d94:	83 c4 10             	add    $0x10,%esp
  801d97:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801d9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d9e:	0f 84 a5 00 00 00    	je     801e49 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da7:	8b 40 0c             	mov    0xc(%eax),%eax
  801daa:	83 ec 08             	sub    $0x8,%esp
  801dad:	50                   	push   %eax
  801dae:	ff 75 f4             	pushl  -0xc(%ebp)
  801db1:	e8 a4 03 00 00       	call   80215a <sys_free_user_mem>
  801db6:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801db9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801dbd:	75 17                	jne    801dd6 <free+0x6f>
  801dbf:	83 ec 04             	sub    $0x4,%esp
  801dc2:	68 49 42 80 00       	push   $0x804249
  801dc7:	68 87 00 00 00       	push   $0x87
  801dcc:	68 67 42 80 00       	push   $0x804267
  801dd1:	e8 c7 ea ff ff       	call   80089d <_panic>
  801dd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dd9:	8b 00                	mov    (%eax),%eax
  801ddb:	85 c0                	test   %eax,%eax
  801ddd:	74 10                	je     801def <free+0x88>
  801ddf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de2:	8b 00                	mov    (%eax),%eax
  801de4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801de7:	8b 52 04             	mov    0x4(%edx),%edx
  801dea:	89 50 04             	mov    %edx,0x4(%eax)
  801ded:	eb 0b                	jmp    801dfa <free+0x93>
  801def:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df2:	8b 40 04             	mov    0x4(%eax),%eax
  801df5:	a3 44 50 80 00       	mov    %eax,0x805044
  801dfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dfd:	8b 40 04             	mov    0x4(%eax),%eax
  801e00:	85 c0                	test   %eax,%eax
  801e02:	74 0f                	je     801e13 <free+0xac>
  801e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e07:	8b 40 04             	mov    0x4(%eax),%eax
  801e0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e0d:	8b 12                	mov    (%edx),%edx
  801e0f:	89 10                	mov    %edx,(%eax)
  801e11:	eb 0a                	jmp    801e1d <free+0xb6>
  801e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e16:	8b 00                	mov    (%eax),%eax
  801e18:	a3 40 50 80 00       	mov    %eax,0x805040
  801e1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e30:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e35:	48                   	dec    %eax
  801e36:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801e3b:	83 ec 0c             	sub    $0xc,%esp
  801e3e:	ff 75 ec             	pushl  -0x14(%ebp)
  801e41:	e8 37 12 00 00       	call   80307d <insert_sorted_with_merge_freeList>
  801e46:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801e49:	90                   	nop
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	83 ec 38             	sub    $0x38,%esp
  801e52:	8b 45 10             	mov    0x10(%ebp),%eax
  801e55:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e58:	e8 84 fc ff ff       	call   801ae1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e61:	75 07                	jne    801e6a <smalloc+0x1e>
  801e63:	b8 00 00 00 00       	mov    $0x0,%eax
  801e68:	eb 7e                	jmp    801ee8 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801e6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801e71:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7e:	01 d0                	add    %edx,%eax
  801e80:	48                   	dec    %eax
  801e81:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e87:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8c:	f7 75 f0             	divl   -0x10(%ebp)
  801e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e92:	29 d0                	sub    %edx,%eax
  801e94:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801e97:	e8 c4 06 00 00       	call   802560 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e9c:	83 f8 01             	cmp    $0x1,%eax
  801e9f:	75 42                	jne    801ee3 <smalloc+0x97>

		  va = malloc(newsize) ;
  801ea1:	83 ec 0c             	sub    $0xc,%esp
  801ea4:	ff 75 e8             	pushl  -0x18(%ebp)
  801ea7:	e8 24 fe ff ff       	call   801cd0 <malloc>
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801eb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801eb6:	74 24                	je     801edc <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801eb8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ebc:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ebf:	50                   	push   %eax
  801ec0:	ff 75 e8             	pushl  -0x18(%ebp)
  801ec3:	ff 75 08             	pushl  0x8(%ebp)
  801ec6:	e8 1a 04 00 00       	call   8022e5 <sys_createSharedObject>
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801ed1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ed5:	78 0c                	js     801ee3 <smalloc+0x97>
					  return va ;
  801ed7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eda:	eb 0c                	jmp    801ee8 <smalloc+0x9c>
				 }
				 else
					return NULL;
  801edc:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee1:	eb 05                	jmp    801ee8 <smalloc+0x9c>
	  }
		  return NULL ;
  801ee3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ef0:	e8 ec fb ff ff       	call   801ae1 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801ef5:	83 ec 08             	sub    $0x8,%esp
  801ef8:	ff 75 0c             	pushl  0xc(%ebp)
  801efb:	ff 75 08             	pushl  0x8(%ebp)
  801efe:	e8 0c 04 00 00       	call   80230f <sys_getSizeOfSharedObject>
  801f03:	83 c4 10             	add    $0x10,%esp
  801f06:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801f09:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801f0d:	75 07                	jne    801f16 <sget+0x2c>
  801f0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f14:	eb 75                	jmp    801f8b <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801f16:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f23:	01 d0                	add    %edx,%eax
  801f25:	48                   	dec    %eax
  801f26:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f31:	f7 75 f0             	divl   -0x10(%ebp)
  801f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f37:	29 d0                	sub    %edx,%eax
  801f39:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801f3c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801f43:	e8 18 06 00 00       	call   802560 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f48:	83 f8 01             	cmp    $0x1,%eax
  801f4b:	75 39                	jne    801f86 <sget+0x9c>

		  va = malloc(newsize) ;
  801f4d:	83 ec 0c             	sub    $0xc,%esp
  801f50:	ff 75 e8             	pushl  -0x18(%ebp)
  801f53:	e8 78 fd ff ff       	call   801cd0 <malloc>
  801f58:	83 c4 10             	add    $0x10,%esp
  801f5b:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801f5e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f62:	74 22                	je     801f86 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801f64:	83 ec 04             	sub    $0x4,%esp
  801f67:	ff 75 e0             	pushl  -0x20(%ebp)
  801f6a:	ff 75 0c             	pushl  0xc(%ebp)
  801f6d:	ff 75 08             	pushl  0x8(%ebp)
  801f70:	e8 b7 03 00 00       	call   80232c <sys_getSharedObject>
  801f75:	83 c4 10             	add    $0x10,%esp
  801f78:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801f7b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801f7f:	78 05                	js     801f86 <sget+0x9c>
					  return va;
  801f81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f84:	eb 05                	jmp    801f8b <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801f86:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
  801f90:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f93:	e8 49 fb ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f98:	83 ec 04             	sub    $0x4,%esp
  801f9b:	68 98 42 80 00       	push   $0x804298
  801fa0:	68 1e 01 00 00       	push   $0x11e
  801fa5:	68 67 42 80 00       	push   $0x804267
  801faa:	e8 ee e8 ff ff       	call   80089d <_panic>

00801faf <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fb5:	83 ec 04             	sub    $0x4,%esp
  801fb8:	68 c0 42 80 00       	push   $0x8042c0
  801fbd:	68 32 01 00 00       	push   $0x132
  801fc2:	68 67 42 80 00       	push   $0x804267
  801fc7:	e8 d1 e8 ff ff       	call   80089d <_panic>

00801fcc <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fd2:	83 ec 04             	sub    $0x4,%esp
  801fd5:	68 e4 42 80 00       	push   $0x8042e4
  801fda:	68 3d 01 00 00       	push   $0x13d
  801fdf:	68 67 42 80 00       	push   $0x804267
  801fe4:	e8 b4 e8 ff ff       	call   80089d <_panic>

00801fe9 <shrink>:

}
void shrink(uint32 newSize)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fef:	83 ec 04             	sub    $0x4,%esp
  801ff2:	68 e4 42 80 00       	push   $0x8042e4
  801ff7:	68 42 01 00 00       	push   $0x142
  801ffc:	68 67 42 80 00       	push   $0x804267
  802001:	e8 97 e8 ff ff       	call   80089d <_panic>

00802006 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
  802009:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80200c:	83 ec 04             	sub    $0x4,%esp
  80200f:	68 e4 42 80 00       	push   $0x8042e4
  802014:	68 47 01 00 00       	push   $0x147
  802019:	68 67 42 80 00       	push   $0x804267
  80201e:	e8 7a e8 ff ff       	call   80089d <_panic>

00802023 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	57                   	push   %edi
  802027:	56                   	push   %esi
  802028:	53                   	push   %ebx
  802029:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802032:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802035:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802038:	8b 7d 18             	mov    0x18(%ebp),%edi
  80203b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80203e:	cd 30                	int    $0x30
  802040:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802043:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802046:	83 c4 10             	add    $0x10,%esp
  802049:	5b                   	pop    %ebx
  80204a:	5e                   	pop    %esi
  80204b:	5f                   	pop    %edi
  80204c:	5d                   	pop    %ebp
  80204d:	c3                   	ret    

0080204e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	83 ec 04             	sub    $0x4,%esp
  802054:	8b 45 10             	mov    0x10(%ebp),%eax
  802057:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80205a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	52                   	push   %edx
  802066:	ff 75 0c             	pushl  0xc(%ebp)
  802069:	50                   	push   %eax
  80206a:	6a 00                	push   $0x0
  80206c:	e8 b2 ff ff ff       	call   802023 <syscall>
  802071:	83 c4 18             	add    $0x18,%esp
}
  802074:	90                   	nop
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_cgetc>:

int
sys_cgetc(void)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 01                	push   $0x1
  802086:	e8 98 ff ff ff       	call   802023 <syscall>
  80208b:	83 c4 18             	add    $0x18,%esp
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802093:	8b 55 0c             	mov    0xc(%ebp),%edx
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	52                   	push   %edx
  8020a0:	50                   	push   %eax
  8020a1:	6a 05                	push   $0x5
  8020a3:	e8 7b ff ff ff       	call   802023 <syscall>
  8020a8:	83 c4 18             	add    $0x18,%esp
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	56                   	push   %esi
  8020b1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020b2:	8b 75 18             	mov    0x18(%ebp),%esi
  8020b5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020be:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c1:	56                   	push   %esi
  8020c2:	53                   	push   %ebx
  8020c3:	51                   	push   %ecx
  8020c4:	52                   	push   %edx
  8020c5:	50                   	push   %eax
  8020c6:	6a 06                	push   $0x6
  8020c8:	e8 56 ff ff ff       	call   802023 <syscall>
  8020cd:	83 c4 18             	add    $0x18,%esp
}
  8020d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d3:	5b                   	pop    %ebx
  8020d4:	5e                   	pop    %esi
  8020d5:	5d                   	pop    %ebp
  8020d6:	c3                   	ret    

008020d7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	52                   	push   %edx
  8020e7:	50                   	push   %eax
  8020e8:	6a 07                	push   $0x7
  8020ea:	e8 34 ff ff ff       	call   802023 <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
}
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	ff 75 0c             	pushl  0xc(%ebp)
  802100:	ff 75 08             	pushl  0x8(%ebp)
  802103:	6a 08                	push   $0x8
  802105:	e8 19 ff ff ff       	call   802023 <syscall>
  80210a:	83 c4 18             	add    $0x18,%esp
}
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 09                	push   $0x9
  80211e:	e8 00 ff ff ff       	call   802023 <syscall>
  802123:	83 c4 18             	add    $0x18,%esp
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 0a                	push   $0xa
  802137:	e8 e7 fe ff ff       	call   802023 <syscall>
  80213c:	83 c4 18             	add    $0x18,%esp
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 0b                	push   $0xb
  802150:	e8 ce fe ff ff       	call   802023 <syscall>
  802155:	83 c4 18             	add    $0x18,%esp
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	ff 75 0c             	pushl  0xc(%ebp)
  802166:	ff 75 08             	pushl  0x8(%ebp)
  802169:	6a 0f                	push   $0xf
  80216b:	e8 b3 fe ff ff       	call   802023 <syscall>
  802170:	83 c4 18             	add    $0x18,%esp
	return;
  802173:	90                   	nop
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	ff 75 0c             	pushl  0xc(%ebp)
  802182:	ff 75 08             	pushl  0x8(%ebp)
  802185:	6a 10                	push   $0x10
  802187:	e8 97 fe ff ff       	call   802023 <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
	return ;
  80218f:	90                   	nop
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	ff 75 10             	pushl  0x10(%ebp)
  80219c:	ff 75 0c             	pushl  0xc(%ebp)
  80219f:	ff 75 08             	pushl  0x8(%ebp)
  8021a2:	6a 11                	push   $0x11
  8021a4:	e8 7a fe ff ff       	call   802023 <syscall>
  8021a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ac:	90                   	nop
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 0c                	push   $0xc
  8021be:	e8 60 fe ff ff       	call   802023 <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	ff 75 08             	pushl  0x8(%ebp)
  8021d6:	6a 0d                	push   $0xd
  8021d8:	e8 46 fe ff ff       	call   802023 <syscall>
  8021dd:	83 c4 18             	add    $0x18,%esp
}
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 0e                	push   $0xe
  8021f1:	e8 2d fe ff ff       	call   802023 <syscall>
  8021f6:	83 c4 18             	add    $0x18,%esp
}
  8021f9:	90                   	nop
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 13                	push   $0x13
  80220b:	e8 13 fe ff ff       	call   802023 <syscall>
  802210:	83 c4 18             	add    $0x18,%esp
}
  802213:	90                   	nop
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 14                	push   $0x14
  802225:	e8 f9 fd ff ff       	call   802023 <syscall>
  80222a:	83 c4 18             	add    $0x18,%esp
}
  80222d:	90                   	nop
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <sys_cputc>:


void
sys_cputc(const char c)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	83 ec 04             	sub    $0x4,%esp
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80223c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	50                   	push   %eax
  802249:	6a 15                	push   $0x15
  80224b:	e8 d3 fd ff ff       	call   802023 <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
}
  802253:	90                   	nop
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 16                	push   $0x16
  802265:	e8 b9 fd ff ff       	call   802023 <syscall>
  80226a:	83 c4 18             	add    $0x18,%esp
}
  80226d:	90                   	nop
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	ff 75 0c             	pushl  0xc(%ebp)
  80227f:	50                   	push   %eax
  802280:	6a 17                	push   $0x17
  802282:	e8 9c fd ff ff       	call   802023 <syscall>
  802287:	83 c4 18             	add    $0x18,%esp
}
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80228f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	52                   	push   %edx
  80229c:	50                   	push   %eax
  80229d:	6a 1a                	push   $0x1a
  80229f:	e8 7f fd ff ff       	call   802023 <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	52                   	push   %edx
  8022b9:	50                   	push   %eax
  8022ba:	6a 18                	push   $0x18
  8022bc:	e8 62 fd ff ff       	call   802023 <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
}
  8022c4:	90                   	nop
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	52                   	push   %edx
  8022d7:	50                   	push   %eax
  8022d8:	6a 19                	push   $0x19
  8022da:	e8 44 fd ff ff       	call   802023 <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
}
  8022e2:	90                   	nop
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
  8022e8:	83 ec 04             	sub    $0x4,%esp
  8022eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022f1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022f4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	6a 00                	push   $0x0
  8022fd:	51                   	push   %ecx
  8022fe:	52                   	push   %edx
  8022ff:	ff 75 0c             	pushl  0xc(%ebp)
  802302:	50                   	push   %eax
  802303:	6a 1b                	push   $0x1b
  802305:	e8 19 fd ff ff       	call   802023 <syscall>
  80230a:	83 c4 18             	add    $0x18,%esp
}
  80230d:	c9                   	leave  
  80230e:	c3                   	ret    

0080230f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802312:	8b 55 0c             	mov    0xc(%ebp),%edx
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	52                   	push   %edx
  80231f:	50                   	push   %eax
  802320:	6a 1c                	push   $0x1c
  802322:	e8 fc fc ff ff       	call   802023 <syscall>
  802327:	83 c4 18             	add    $0x18,%esp
}
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80232f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802332:	8b 55 0c             	mov    0xc(%ebp),%edx
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	51                   	push   %ecx
  80233d:	52                   	push   %edx
  80233e:	50                   	push   %eax
  80233f:	6a 1d                	push   $0x1d
  802341:	e8 dd fc ff ff       	call   802023 <syscall>
  802346:	83 c4 18             	add    $0x18,%esp
}
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80234e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	52                   	push   %edx
  80235b:	50                   	push   %eax
  80235c:	6a 1e                	push   $0x1e
  80235e:	e8 c0 fc ff ff       	call   802023 <syscall>
  802363:	83 c4 18             	add    $0x18,%esp
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 1f                	push   $0x1f
  802377:	e8 a7 fc ff ff       	call   802023 <syscall>
  80237c:	83 c4 18             	add    $0x18,%esp
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802384:	8b 45 08             	mov    0x8(%ebp),%eax
  802387:	6a 00                	push   $0x0
  802389:	ff 75 14             	pushl  0x14(%ebp)
  80238c:	ff 75 10             	pushl  0x10(%ebp)
  80238f:	ff 75 0c             	pushl  0xc(%ebp)
  802392:	50                   	push   %eax
  802393:	6a 20                	push   $0x20
  802395:	e8 89 fc ff ff       	call   802023 <syscall>
  80239a:	83 c4 18             	add    $0x18,%esp
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	50                   	push   %eax
  8023ae:	6a 21                	push   $0x21
  8023b0:	e8 6e fc ff ff       	call   802023 <syscall>
  8023b5:	83 c4 18             	add    $0x18,%esp
}
  8023b8:	90                   	nop
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	50                   	push   %eax
  8023ca:	6a 22                	push   $0x22
  8023cc:	e8 52 fc ff ff       	call   802023 <syscall>
  8023d1:	83 c4 18             	add    $0x18,%esp
}
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 02                	push   $0x2
  8023e5:	e8 39 fc ff ff       	call   802023 <syscall>
  8023ea:	83 c4 18             	add    $0x18,%esp
}
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 03                	push   $0x3
  8023fe:	e8 20 fc ff ff       	call   802023 <syscall>
  802403:	83 c4 18             	add    $0x18,%esp
}
  802406:	c9                   	leave  
  802407:	c3                   	ret    

00802408 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802408:	55                   	push   %ebp
  802409:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 04                	push   $0x4
  802417:	e8 07 fc ff ff       	call   802023 <syscall>
  80241c:	83 c4 18             	add    $0x18,%esp
}
  80241f:	c9                   	leave  
  802420:	c3                   	ret    

00802421 <sys_exit_env>:


void sys_exit_env(void)
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 23                	push   $0x23
  802430:	e8 ee fb ff ff       	call   802023 <syscall>
  802435:	83 c4 18             	add    $0x18,%esp
}
  802438:	90                   	nop
  802439:	c9                   	leave  
  80243a:	c3                   	ret    

0080243b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
  80243e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802441:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802444:	8d 50 04             	lea    0x4(%eax),%edx
  802447:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	52                   	push   %edx
  802451:	50                   	push   %eax
  802452:	6a 24                	push   $0x24
  802454:	e8 ca fb ff ff       	call   802023 <syscall>
  802459:	83 c4 18             	add    $0x18,%esp
	return result;
  80245c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80245f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802462:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802465:	89 01                	mov    %eax,(%ecx)
  802467:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	c9                   	leave  
  80246e:	c2 04 00             	ret    $0x4

00802471 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802474:	6a 00                	push   $0x0
  802476:	6a 00                	push   $0x0
  802478:	ff 75 10             	pushl  0x10(%ebp)
  80247b:	ff 75 0c             	pushl  0xc(%ebp)
  80247e:	ff 75 08             	pushl  0x8(%ebp)
  802481:	6a 12                	push   $0x12
  802483:	e8 9b fb ff ff       	call   802023 <syscall>
  802488:	83 c4 18             	add    $0x18,%esp
	return ;
  80248b:	90                   	nop
}
  80248c:	c9                   	leave  
  80248d:	c3                   	ret    

0080248e <sys_rcr2>:
uint32 sys_rcr2()
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 25                	push   $0x25
  80249d:	e8 81 fb ff ff       	call   802023 <syscall>
  8024a2:	83 c4 18             	add    $0x18,%esp
}
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
  8024aa:	83 ec 04             	sub    $0x4,%esp
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024b3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	50                   	push   %eax
  8024c0:	6a 26                	push   $0x26
  8024c2:	e8 5c fb ff ff       	call   802023 <syscall>
  8024c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ca:	90                   	nop
}
  8024cb:	c9                   	leave  
  8024cc:	c3                   	ret    

008024cd <rsttst>:
void rsttst()
{
  8024cd:	55                   	push   %ebp
  8024ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 28                	push   $0x28
  8024dc:	e8 42 fb ff ff       	call   802023 <syscall>
  8024e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e4:	90                   	nop
}
  8024e5:	c9                   	leave  
  8024e6:	c3                   	ret    

008024e7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024e7:	55                   	push   %ebp
  8024e8:	89 e5                	mov    %esp,%ebp
  8024ea:	83 ec 04             	sub    $0x4,%esp
  8024ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8024f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024f3:	8b 55 18             	mov    0x18(%ebp),%edx
  8024f6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024fa:	52                   	push   %edx
  8024fb:	50                   	push   %eax
  8024fc:	ff 75 10             	pushl  0x10(%ebp)
  8024ff:	ff 75 0c             	pushl  0xc(%ebp)
  802502:	ff 75 08             	pushl  0x8(%ebp)
  802505:	6a 27                	push   $0x27
  802507:	e8 17 fb ff ff       	call   802023 <syscall>
  80250c:	83 c4 18             	add    $0x18,%esp
	return ;
  80250f:	90                   	nop
}
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <chktst>:
void chktst(uint32 n)
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	ff 75 08             	pushl  0x8(%ebp)
  802520:	6a 29                	push   $0x29
  802522:	e8 fc fa ff ff       	call   802023 <syscall>
  802527:	83 c4 18             	add    $0x18,%esp
	return ;
  80252a:	90                   	nop
}
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <inctst>:

void inctst()
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 2a                	push   $0x2a
  80253c:	e8 e2 fa ff ff       	call   802023 <syscall>
  802541:	83 c4 18             	add    $0x18,%esp
	return ;
  802544:	90                   	nop
}
  802545:	c9                   	leave  
  802546:	c3                   	ret    

00802547 <gettst>:
uint32 gettst()
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 2b                	push   $0x2b
  802556:	e8 c8 fa ff ff       	call   802023 <syscall>
  80255b:	83 c4 18             	add    $0x18,%esp
}
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 2c                	push   $0x2c
  802572:	e8 ac fa ff ff       	call   802023 <syscall>
  802577:	83 c4 18             	add    $0x18,%esp
  80257a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80257d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802581:	75 07                	jne    80258a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802583:	b8 01 00 00 00       	mov    $0x1,%eax
  802588:	eb 05                	jmp    80258f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80258a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80258f:	c9                   	leave  
  802590:	c3                   	ret    

00802591 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
  802594:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 2c                	push   $0x2c
  8025a3:	e8 7b fa ff ff       	call   802023 <syscall>
  8025a8:	83 c4 18             	add    $0x18,%esp
  8025ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025ae:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025b2:	75 07                	jne    8025bb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b9:	eb 05                	jmp    8025c0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
  8025c5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025c8:	6a 00                	push   $0x0
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 2c                	push   $0x2c
  8025d4:	e8 4a fa ff ff       	call   802023 <syscall>
  8025d9:	83 c4 18             	add    $0x18,%esp
  8025dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025df:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025e3:	75 07                	jne    8025ec <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ea:	eb 05                	jmp    8025f1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f1:	c9                   	leave  
  8025f2:	c3                   	ret    

008025f3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025f3:	55                   	push   %ebp
  8025f4:	89 e5                	mov    %esp,%ebp
  8025f6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	6a 2c                	push   $0x2c
  802605:	e8 19 fa ff ff       	call   802023 <syscall>
  80260a:	83 c4 18             	add    $0x18,%esp
  80260d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802610:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802614:	75 07                	jne    80261d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802616:	b8 01 00 00 00       	mov    $0x1,%eax
  80261b:	eb 05                	jmp    802622 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80261d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802622:	c9                   	leave  
  802623:	c3                   	ret    

00802624 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	ff 75 08             	pushl  0x8(%ebp)
  802632:	6a 2d                	push   $0x2d
  802634:	e8 ea f9 ff ff       	call   802023 <syscall>
  802639:	83 c4 18             	add    $0x18,%esp
	return ;
  80263c:	90                   	nop
}
  80263d:	c9                   	leave  
  80263e:	c3                   	ret    

0080263f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
  802642:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802643:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802646:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802649:	8b 55 0c             	mov    0xc(%ebp),%edx
  80264c:	8b 45 08             	mov    0x8(%ebp),%eax
  80264f:	6a 00                	push   $0x0
  802651:	53                   	push   %ebx
  802652:	51                   	push   %ecx
  802653:	52                   	push   %edx
  802654:	50                   	push   %eax
  802655:	6a 2e                	push   $0x2e
  802657:	e8 c7 f9 ff ff       	call   802023 <syscall>
  80265c:	83 c4 18             	add    $0x18,%esp
}
  80265f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802662:	c9                   	leave  
  802663:	c3                   	ret    

00802664 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802664:	55                   	push   %ebp
  802665:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802667:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266a:	8b 45 08             	mov    0x8(%ebp),%eax
  80266d:	6a 00                	push   $0x0
  80266f:	6a 00                	push   $0x0
  802671:	6a 00                	push   $0x0
  802673:	52                   	push   %edx
  802674:	50                   	push   %eax
  802675:	6a 2f                	push   $0x2f
  802677:	e8 a7 f9 ff ff       	call   802023 <syscall>
  80267c:	83 c4 18             	add    $0x18,%esp
}
  80267f:	c9                   	leave  
  802680:	c3                   	ret    

00802681 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802681:	55                   	push   %ebp
  802682:	89 e5                	mov    %esp,%ebp
  802684:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802687:	83 ec 0c             	sub    $0xc,%esp
  80268a:	68 f4 42 80 00       	push   $0x8042f4
  80268f:	e8 bd e4 ff ff       	call   800b51 <cprintf>
  802694:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802697:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80269e:	83 ec 0c             	sub    $0xc,%esp
  8026a1:	68 20 43 80 00       	push   $0x804320
  8026a6:	e8 a6 e4 ff ff       	call   800b51 <cprintf>
  8026ab:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026ae:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026b2:	a1 38 51 80 00       	mov    0x805138,%eax
  8026b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ba:	eb 56                	jmp    802712 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026c0:	74 1c                	je     8026de <print_mem_block_lists+0x5d>
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 50 08             	mov    0x8(%eax),%edx
  8026c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cb:	8b 48 08             	mov    0x8(%eax),%ecx
  8026ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d4:	01 c8                	add    %ecx,%eax
  8026d6:	39 c2                	cmp    %eax,%edx
  8026d8:	73 04                	jae    8026de <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026da:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	8b 50 08             	mov    0x8(%eax),%edx
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ea:	01 c2                	add    %eax,%edx
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 40 08             	mov    0x8(%eax),%eax
  8026f2:	83 ec 04             	sub    $0x4,%esp
  8026f5:	52                   	push   %edx
  8026f6:	50                   	push   %eax
  8026f7:	68 35 43 80 00       	push   $0x804335
  8026fc:	e8 50 e4 ff ff       	call   800b51 <cprintf>
  802701:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80270a:	a1 40 51 80 00       	mov    0x805140,%eax
  80270f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802716:	74 07                	je     80271f <print_mem_block_lists+0x9e>
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 00                	mov    (%eax),%eax
  80271d:	eb 05                	jmp    802724 <print_mem_block_lists+0xa3>
  80271f:	b8 00 00 00 00       	mov    $0x0,%eax
  802724:	a3 40 51 80 00       	mov    %eax,0x805140
  802729:	a1 40 51 80 00       	mov    0x805140,%eax
  80272e:	85 c0                	test   %eax,%eax
  802730:	75 8a                	jne    8026bc <print_mem_block_lists+0x3b>
  802732:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802736:	75 84                	jne    8026bc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802738:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80273c:	75 10                	jne    80274e <print_mem_block_lists+0xcd>
  80273e:	83 ec 0c             	sub    $0xc,%esp
  802741:	68 44 43 80 00       	push   $0x804344
  802746:	e8 06 e4 ff ff       	call   800b51 <cprintf>
  80274b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80274e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802755:	83 ec 0c             	sub    $0xc,%esp
  802758:	68 68 43 80 00       	push   $0x804368
  80275d:	e8 ef e3 ff ff       	call   800b51 <cprintf>
  802762:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802765:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802769:	a1 40 50 80 00       	mov    0x805040,%eax
  80276e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802771:	eb 56                	jmp    8027c9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802773:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802777:	74 1c                	je     802795 <print_mem_block_lists+0x114>
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 50 08             	mov    0x8(%eax),%edx
  80277f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802782:	8b 48 08             	mov    0x8(%eax),%ecx
  802785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802788:	8b 40 0c             	mov    0xc(%eax),%eax
  80278b:	01 c8                	add    %ecx,%eax
  80278d:	39 c2                	cmp    %eax,%edx
  80278f:	73 04                	jae    802795 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802791:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 50 08             	mov    0x8(%eax),%edx
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a1:	01 c2                	add    %eax,%edx
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 40 08             	mov    0x8(%eax),%eax
  8027a9:	83 ec 04             	sub    $0x4,%esp
  8027ac:	52                   	push   %edx
  8027ad:	50                   	push   %eax
  8027ae:	68 35 43 80 00       	push   $0x804335
  8027b3:	e8 99 e3 ff ff       	call   800b51 <cprintf>
  8027b8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027c1:	a1 48 50 80 00       	mov    0x805048,%eax
  8027c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027cd:	74 07                	je     8027d6 <print_mem_block_lists+0x155>
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	8b 00                	mov    (%eax),%eax
  8027d4:	eb 05                	jmp    8027db <print_mem_block_lists+0x15a>
  8027d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027db:	a3 48 50 80 00       	mov    %eax,0x805048
  8027e0:	a1 48 50 80 00       	mov    0x805048,%eax
  8027e5:	85 c0                	test   %eax,%eax
  8027e7:	75 8a                	jne    802773 <print_mem_block_lists+0xf2>
  8027e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ed:	75 84                	jne    802773 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8027ef:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027f3:	75 10                	jne    802805 <print_mem_block_lists+0x184>
  8027f5:	83 ec 0c             	sub    $0xc,%esp
  8027f8:	68 80 43 80 00       	push   $0x804380
  8027fd:	e8 4f e3 ff ff       	call   800b51 <cprintf>
  802802:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802805:	83 ec 0c             	sub    $0xc,%esp
  802808:	68 f4 42 80 00       	push   $0x8042f4
  80280d:	e8 3f e3 ff ff       	call   800b51 <cprintf>
  802812:	83 c4 10             	add    $0x10,%esp

}
  802815:	90                   	nop
  802816:	c9                   	leave  
  802817:	c3                   	ret    

00802818 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802818:	55                   	push   %ebp
  802819:	89 e5                	mov    %esp,%ebp
  80281b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  80281e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802825:	00 00 00 
  802828:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80282f:	00 00 00 
  802832:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802839:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80283c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802843:	e9 9e 00 00 00       	jmp    8028e6 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802848:	a1 50 50 80 00       	mov    0x805050,%eax
  80284d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802850:	c1 e2 04             	shl    $0x4,%edx
  802853:	01 d0                	add    %edx,%eax
  802855:	85 c0                	test   %eax,%eax
  802857:	75 14                	jne    80286d <initialize_MemBlocksList+0x55>
  802859:	83 ec 04             	sub    $0x4,%esp
  80285c:	68 a8 43 80 00       	push   $0x8043a8
  802861:	6a 47                	push   $0x47
  802863:	68 cb 43 80 00       	push   $0x8043cb
  802868:	e8 30 e0 ff ff       	call   80089d <_panic>
  80286d:	a1 50 50 80 00       	mov    0x805050,%eax
  802872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802875:	c1 e2 04             	shl    $0x4,%edx
  802878:	01 d0                	add    %edx,%eax
  80287a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802880:	89 10                	mov    %edx,(%eax)
  802882:	8b 00                	mov    (%eax),%eax
  802884:	85 c0                	test   %eax,%eax
  802886:	74 18                	je     8028a0 <initialize_MemBlocksList+0x88>
  802888:	a1 48 51 80 00       	mov    0x805148,%eax
  80288d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802893:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802896:	c1 e1 04             	shl    $0x4,%ecx
  802899:	01 ca                	add    %ecx,%edx
  80289b:	89 50 04             	mov    %edx,0x4(%eax)
  80289e:	eb 12                	jmp    8028b2 <initialize_MemBlocksList+0x9a>
  8028a0:	a1 50 50 80 00       	mov    0x805050,%eax
  8028a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a8:	c1 e2 04             	shl    $0x4,%edx
  8028ab:	01 d0                	add    %edx,%eax
  8028ad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028b2:	a1 50 50 80 00       	mov    0x805050,%eax
  8028b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ba:	c1 e2 04             	shl    $0x4,%edx
  8028bd:	01 d0                	add    %edx,%eax
  8028bf:	a3 48 51 80 00       	mov    %eax,0x805148
  8028c4:	a1 50 50 80 00       	mov    0x805050,%eax
  8028c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cc:	c1 e2 04             	shl    $0x4,%edx
  8028cf:	01 d0                	add    %edx,%eax
  8028d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d8:	a1 54 51 80 00       	mov    0x805154,%eax
  8028dd:	40                   	inc    %eax
  8028de:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8028e3:	ff 45 f4             	incl   -0xc(%ebp)
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ec:	0f 82 56 ff ff ff    	jb     802848 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8028f2:	90                   	nop
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    

008028f5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8028f5:	55                   	push   %ebp
  8028f6:	89 e5                	mov    %esp,%ebp
  8028f8:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8028fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fe:	8b 00                	mov    (%eax),%eax
  802900:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802903:	eb 19                	jmp    80291e <find_block+0x29>
	{
		if(element->sva == va){
  802905:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802908:	8b 40 08             	mov    0x8(%eax),%eax
  80290b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80290e:	75 05                	jne    802915 <find_block+0x20>
			 		return element;
  802910:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802913:	eb 36                	jmp    80294b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	8b 40 08             	mov    0x8(%eax),%eax
  80291b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80291e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802922:	74 07                	je     80292b <find_block+0x36>
  802924:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802927:	8b 00                	mov    (%eax),%eax
  802929:	eb 05                	jmp    802930 <find_block+0x3b>
  80292b:	b8 00 00 00 00       	mov    $0x0,%eax
  802930:	8b 55 08             	mov    0x8(%ebp),%edx
  802933:	89 42 08             	mov    %eax,0x8(%edx)
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	8b 40 08             	mov    0x8(%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	75 c5                	jne    802905 <find_block+0x10>
  802940:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802944:	75 bf                	jne    802905 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802946:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80294b:	c9                   	leave  
  80294c:	c3                   	ret    

0080294d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80294d:	55                   	push   %ebp
  80294e:	89 e5                	mov    %esp,%ebp
  802950:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802953:	a1 44 50 80 00       	mov    0x805044,%eax
  802958:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  80295b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802960:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802963:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802967:	74 0a                	je     802973 <insert_sorted_allocList+0x26>
  802969:	8b 45 08             	mov    0x8(%ebp),%eax
  80296c:	8b 40 08             	mov    0x8(%eax),%eax
  80296f:	85 c0                	test   %eax,%eax
  802971:	75 65                	jne    8029d8 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802973:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802977:	75 14                	jne    80298d <insert_sorted_allocList+0x40>
  802979:	83 ec 04             	sub    $0x4,%esp
  80297c:	68 a8 43 80 00       	push   $0x8043a8
  802981:	6a 6e                	push   $0x6e
  802983:	68 cb 43 80 00       	push   $0x8043cb
  802988:	e8 10 df ff ff       	call   80089d <_panic>
  80298d:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	89 10                	mov    %edx,(%eax)
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	8b 00                	mov    (%eax),%eax
  80299d:	85 c0                	test   %eax,%eax
  80299f:	74 0d                	je     8029ae <insert_sorted_allocList+0x61>
  8029a1:	a1 40 50 80 00       	mov    0x805040,%eax
  8029a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a9:	89 50 04             	mov    %edx,0x4(%eax)
  8029ac:	eb 08                	jmp    8029b6 <insert_sorted_allocList+0x69>
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	a3 44 50 80 00       	mov    %eax,0x805044
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	a3 40 50 80 00       	mov    %eax,0x805040
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029cd:	40                   	inc    %eax
  8029ce:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8029d3:	e9 cf 01 00 00       	jmp    802ba7 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8029d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029db:	8b 50 08             	mov    0x8(%eax),%edx
  8029de:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e1:	8b 40 08             	mov    0x8(%eax),%eax
  8029e4:	39 c2                	cmp    %eax,%edx
  8029e6:	73 65                	jae    802a4d <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8029e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ec:	75 14                	jne    802a02 <insert_sorted_allocList+0xb5>
  8029ee:	83 ec 04             	sub    $0x4,%esp
  8029f1:	68 e4 43 80 00       	push   $0x8043e4
  8029f6:	6a 72                	push   $0x72
  8029f8:	68 cb 43 80 00       	push   $0x8043cb
  8029fd:	e8 9b de ff ff       	call   80089d <_panic>
  802a02:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	89 50 04             	mov    %edx,0x4(%eax)
  802a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a11:	8b 40 04             	mov    0x4(%eax),%eax
  802a14:	85 c0                	test   %eax,%eax
  802a16:	74 0c                	je     802a24 <insert_sorted_allocList+0xd7>
  802a18:	a1 44 50 80 00       	mov    0x805044,%eax
  802a1d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a20:	89 10                	mov    %edx,(%eax)
  802a22:	eb 08                	jmp    802a2c <insert_sorted_allocList+0xdf>
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	a3 40 50 80 00       	mov    %eax,0x805040
  802a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2f:	a3 44 50 80 00       	mov    %eax,0x805044
  802a34:	8b 45 08             	mov    0x8(%ebp),%eax
  802a37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a3d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a42:	40                   	inc    %eax
  802a43:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802a48:	e9 5a 01 00 00       	jmp    802ba7 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a50:	8b 50 08             	mov    0x8(%eax),%edx
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	8b 40 08             	mov    0x8(%eax),%eax
  802a59:	39 c2                	cmp    %eax,%edx
  802a5b:	75 70                	jne    802acd <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802a5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a61:	74 06                	je     802a69 <insert_sorted_allocList+0x11c>
  802a63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a67:	75 14                	jne    802a7d <insert_sorted_allocList+0x130>
  802a69:	83 ec 04             	sub    $0x4,%esp
  802a6c:	68 08 44 80 00       	push   $0x804408
  802a71:	6a 75                	push   $0x75
  802a73:	68 cb 43 80 00       	push   $0x8043cb
  802a78:	e8 20 de ff ff       	call   80089d <_panic>
  802a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a80:	8b 10                	mov    (%eax),%edx
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	89 10                	mov    %edx,(%eax)
  802a87:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	85 c0                	test   %eax,%eax
  802a8e:	74 0b                	je     802a9b <insert_sorted_allocList+0x14e>
  802a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a93:	8b 00                	mov    (%eax),%eax
  802a95:	8b 55 08             	mov    0x8(%ebp),%edx
  802a98:	89 50 04             	mov    %edx,0x4(%eax)
  802a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa1:	89 10                	mov    %edx,(%eax)
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aa9:	89 50 04             	mov    %edx,0x4(%eax)
  802aac:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaf:	8b 00                	mov    (%eax),%eax
  802ab1:	85 c0                	test   %eax,%eax
  802ab3:	75 08                	jne    802abd <insert_sorted_allocList+0x170>
  802ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab8:	a3 44 50 80 00       	mov    %eax,0x805044
  802abd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ac2:	40                   	inc    %eax
  802ac3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802ac8:	e9 da 00 00 00       	jmp    802ba7 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802acd:	a1 40 50 80 00       	mov    0x805040,%eax
  802ad2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad5:	e9 9d 00 00 00       	jmp    802b77 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802add:	8b 00                	mov    (%eax),%eax
  802adf:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	8b 50 08             	mov    0x8(%eax),%edx
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 40 08             	mov    0x8(%eax),%eax
  802aee:	39 c2                	cmp    %eax,%edx
  802af0:	76 7d                	jbe    802b6f <insert_sorted_allocList+0x222>
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	8b 50 08             	mov    0x8(%eax),%edx
  802af8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afb:	8b 40 08             	mov    0x8(%eax),%eax
  802afe:	39 c2                	cmp    %eax,%edx
  802b00:	73 6d                	jae    802b6f <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802b02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b06:	74 06                	je     802b0e <insert_sorted_allocList+0x1c1>
  802b08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b0c:	75 14                	jne    802b22 <insert_sorted_allocList+0x1d5>
  802b0e:	83 ec 04             	sub    $0x4,%esp
  802b11:	68 08 44 80 00       	push   $0x804408
  802b16:	6a 7c                	push   $0x7c
  802b18:	68 cb 43 80 00       	push   $0x8043cb
  802b1d:	e8 7b dd ff ff       	call   80089d <_panic>
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 10                	mov    (%eax),%edx
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	89 10                	mov    %edx,(%eax)
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	8b 00                	mov    (%eax),%eax
  802b31:	85 c0                	test   %eax,%eax
  802b33:	74 0b                	je     802b40 <insert_sorted_allocList+0x1f3>
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3d:	89 50 04             	mov    %edx,0x4(%eax)
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	8b 55 08             	mov    0x8(%ebp),%edx
  802b46:	89 10                	mov    %edx,(%eax)
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b4e:	89 50 04             	mov    %edx,0x4(%eax)
  802b51:	8b 45 08             	mov    0x8(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	85 c0                	test   %eax,%eax
  802b58:	75 08                	jne    802b62 <insert_sorted_allocList+0x215>
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	a3 44 50 80 00       	mov    %eax,0x805044
  802b62:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b67:	40                   	inc    %eax
  802b68:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802b6d:	eb 38                	jmp    802ba7 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802b6f:	a1 48 50 80 00       	mov    0x805048,%eax
  802b74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7b:	74 07                	je     802b84 <insert_sorted_allocList+0x237>
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	8b 00                	mov    (%eax),%eax
  802b82:	eb 05                	jmp    802b89 <insert_sorted_allocList+0x23c>
  802b84:	b8 00 00 00 00       	mov    $0x0,%eax
  802b89:	a3 48 50 80 00       	mov    %eax,0x805048
  802b8e:	a1 48 50 80 00       	mov    0x805048,%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	0f 85 3f ff ff ff    	jne    802ada <insert_sorted_allocList+0x18d>
  802b9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9f:	0f 85 35 ff ff ff    	jne    802ada <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802ba5:	eb 00                	jmp    802ba7 <insert_sorted_allocList+0x25a>
  802ba7:	90                   	nop
  802ba8:	c9                   	leave  
  802ba9:	c3                   	ret    

00802baa <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802baa:	55                   	push   %ebp
  802bab:	89 e5                	mov    %esp,%ebp
  802bad:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802bb0:	a1 38 51 80 00       	mov    0x805138,%eax
  802bb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb8:	e9 6b 02 00 00       	jmp    802e28 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc6:	0f 85 90 00 00 00    	jne    802c5c <alloc_block_FF+0xb2>
			  temp=element;
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802bd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd6:	75 17                	jne    802bef <alloc_block_FF+0x45>
  802bd8:	83 ec 04             	sub    $0x4,%esp
  802bdb:	68 3c 44 80 00       	push   $0x80443c
  802be0:	68 92 00 00 00       	push   $0x92
  802be5:	68 cb 43 80 00       	push   $0x8043cb
  802bea:	e8 ae dc ff ff       	call   80089d <_panic>
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	8b 00                	mov    (%eax),%eax
  802bf4:	85 c0                	test   %eax,%eax
  802bf6:	74 10                	je     802c08 <alloc_block_FF+0x5e>
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	8b 00                	mov    (%eax),%eax
  802bfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c00:	8b 52 04             	mov    0x4(%edx),%edx
  802c03:	89 50 04             	mov    %edx,0x4(%eax)
  802c06:	eb 0b                	jmp    802c13 <alloc_block_FF+0x69>
  802c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0b:	8b 40 04             	mov    0x4(%eax),%eax
  802c0e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c16:	8b 40 04             	mov    0x4(%eax),%eax
  802c19:	85 c0                	test   %eax,%eax
  802c1b:	74 0f                	je     802c2c <alloc_block_FF+0x82>
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 40 04             	mov    0x4(%eax),%eax
  802c23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c26:	8b 12                	mov    (%edx),%edx
  802c28:	89 10                	mov    %edx,(%eax)
  802c2a:	eb 0a                	jmp    802c36 <alloc_block_FF+0x8c>
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 00                	mov    (%eax),%eax
  802c31:	a3 38 51 80 00       	mov    %eax,0x805138
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c49:	a1 44 51 80 00       	mov    0x805144,%eax
  802c4e:	48                   	dec    %eax
  802c4f:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802c54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c57:	e9 ff 01 00 00       	jmp    802e5b <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c62:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c65:	0f 86 b5 01 00 00    	jbe    802e20 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c71:	2b 45 08             	sub    0x8(%ebp),%eax
  802c74:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802c77:	a1 48 51 80 00       	mov    0x805148,%eax
  802c7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802c7f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c83:	75 17                	jne    802c9c <alloc_block_FF+0xf2>
  802c85:	83 ec 04             	sub    $0x4,%esp
  802c88:	68 3c 44 80 00       	push   $0x80443c
  802c8d:	68 99 00 00 00       	push   $0x99
  802c92:	68 cb 43 80 00       	push   $0x8043cb
  802c97:	e8 01 dc ff ff       	call   80089d <_panic>
  802c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9f:	8b 00                	mov    (%eax),%eax
  802ca1:	85 c0                	test   %eax,%eax
  802ca3:	74 10                	je     802cb5 <alloc_block_FF+0x10b>
  802ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca8:	8b 00                	mov    (%eax),%eax
  802caa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cad:	8b 52 04             	mov    0x4(%edx),%edx
  802cb0:	89 50 04             	mov    %edx,0x4(%eax)
  802cb3:	eb 0b                	jmp    802cc0 <alloc_block_FF+0x116>
  802cb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb8:	8b 40 04             	mov    0x4(%eax),%eax
  802cbb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc3:	8b 40 04             	mov    0x4(%eax),%eax
  802cc6:	85 c0                	test   %eax,%eax
  802cc8:	74 0f                	je     802cd9 <alloc_block_FF+0x12f>
  802cca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccd:	8b 40 04             	mov    0x4(%eax),%eax
  802cd0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cd3:	8b 12                	mov    (%edx),%edx
  802cd5:	89 10                	mov    %edx,(%eax)
  802cd7:	eb 0a                	jmp    802ce3 <alloc_block_FF+0x139>
  802cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdc:	8b 00                	mov    (%eax),%eax
  802cde:	a3 48 51 80 00       	mov    %eax,0x805148
  802ce3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf6:	a1 54 51 80 00       	mov    0x805154,%eax
  802cfb:	48                   	dec    %eax
  802cfc:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802d01:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d05:	75 17                	jne    802d1e <alloc_block_FF+0x174>
  802d07:	83 ec 04             	sub    $0x4,%esp
  802d0a:	68 e4 43 80 00       	push   $0x8043e4
  802d0f:	68 9a 00 00 00       	push   $0x9a
  802d14:	68 cb 43 80 00       	push   $0x8043cb
  802d19:	e8 7f db ff ff       	call   80089d <_panic>
  802d1e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802d24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d27:	89 50 04             	mov    %edx,0x4(%eax)
  802d2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2d:	8b 40 04             	mov    0x4(%eax),%eax
  802d30:	85 c0                	test   %eax,%eax
  802d32:	74 0c                	je     802d40 <alloc_block_FF+0x196>
  802d34:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d39:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d3c:	89 10                	mov    %edx,(%eax)
  802d3e:	eb 08                	jmp    802d48 <alloc_block_FF+0x19e>
  802d40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d43:	a3 38 51 80 00       	mov    %eax,0x805138
  802d48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d59:	a1 44 51 80 00       	mov    0x805144,%eax
  802d5e:	40                   	inc    %eax
  802d5f:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802d64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d67:	8b 55 08             	mov    0x8(%ebp),%edx
  802d6a:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 50 08             	mov    0x8(%eax),%edx
  802d73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d76:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d7f:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 50 08             	mov    0x8(%eax),%edx
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	01 c2                	add    %eax,%edx
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802d93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d96:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802d99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d9d:	75 17                	jne    802db6 <alloc_block_FF+0x20c>
  802d9f:	83 ec 04             	sub    $0x4,%esp
  802da2:	68 3c 44 80 00       	push   $0x80443c
  802da7:	68 a2 00 00 00       	push   $0xa2
  802dac:	68 cb 43 80 00       	push   $0x8043cb
  802db1:	e8 e7 da ff ff       	call   80089d <_panic>
  802db6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	85 c0                	test   %eax,%eax
  802dbd:	74 10                	je     802dcf <alloc_block_FF+0x225>
  802dbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc2:	8b 00                	mov    (%eax),%eax
  802dc4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dc7:	8b 52 04             	mov    0x4(%edx),%edx
  802dca:	89 50 04             	mov    %edx,0x4(%eax)
  802dcd:	eb 0b                	jmp    802dda <alloc_block_FF+0x230>
  802dcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddd:	8b 40 04             	mov    0x4(%eax),%eax
  802de0:	85 c0                	test   %eax,%eax
  802de2:	74 0f                	je     802df3 <alloc_block_FF+0x249>
  802de4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de7:	8b 40 04             	mov    0x4(%eax),%eax
  802dea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ded:	8b 12                	mov    (%edx),%edx
  802def:	89 10                	mov    %edx,(%eax)
  802df1:	eb 0a                	jmp    802dfd <alloc_block_FF+0x253>
  802df3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df6:	8b 00                	mov    (%eax),%eax
  802df8:	a3 38 51 80 00       	mov    %eax,0x805138
  802dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e10:	a1 44 51 80 00       	mov    0x805144,%eax
  802e15:	48                   	dec    %eax
  802e16:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802e1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1e:	eb 3b                	jmp    802e5b <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802e20:	a1 40 51 80 00       	mov    0x805140,%eax
  802e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2c:	74 07                	je     802e35 <alloc_block_FF+0x28b>
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 00                	mov    (%eax),%eax
  802e33:	eb 05                	jmp    802e3a <alloc_block_FF+0x290>
  802e35:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3a:	a3 40 51 80 00       	mov    %eax,0x805140
  802e3f:	a1 40 51 80 00       	mov    0x805140,%eax
  802e44:	85 c0                	test   %eax,%eax
  802e46:	0f 85 71 fd ff ff    	jne    802bbd <alloc_block_FF+0x13>
  802e4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e50:	0f 85 67 fd ff ff    	jne    802bbd <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802e56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e5b:	c9                   	leave  
  802e5c:	c3                   	ret    

00802e5d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e5d:	55                   	push   %ebp
  802e5e:	89 e5                	mov    %esp,%ebp
  802e60:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802e63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802e6a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802e71:	a1 38 51 80 00       	mov    0x805138,%eax
  802e76:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802e79:	e9 d3 00 00 00       	jmp    802f51 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802e7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e81:	8b 40 0c             	mov    0xc(%eax),%eax
  802e84:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e87:	0f 85 90 00 00 00    	jne    802f1d <alloc_block_BF+0xc0>
	   temp = element;
  802e8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e90:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802e93:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e97:	75 17                	jne    802eb0 <alloc_block_BF+0x53>
  802e99:	83 ec 04             	sub    $0x4,%esp
  802e9c:	68 3c 44 80 00       	push   $0x80443c
  802ea1:	68 bd 00 00 00       	push   $0xbd
  802ea6:	68 cb 43 80 00       	push   $0x8043cb
  802eab:	e8 ed d9 ff ff       	call   80089d <_panic>
  802eb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb3:	8b 00                	mov    (%eax),%eax
  802eb5:	85 c0                	test   %eax,%eax
  802eb7:	74 10                	je     802ec9 <alloc_block_BF+0x6c>
  802eb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebc:	8b 00                	mov    (%eax),%eax
  802ebe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ec1:	8b 52 04             	mov    0x4(%edx),%edx
  802ec4:	89 50 04             	mov    %edx,0x4(%eax)
  802ec7:	eb 0b                	jmp    802ed4 <alloc_block_BF+0x77>
  802ec9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ecc:	8b 40 04             	mov    0x4(%eax),%eax
  802ecf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ed4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed7:	8b 40 04             	mov    0x4(%eax),%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	74 0f                	je     802eed <alloc_block_BF+0x90>
  802ede:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee1:	8b 40 04             	mov    0x4(%eax),%eax
  802ee4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ee7:	8b 12                	mov    (%edx),%edx
  802ee9:	89 10                	mov    %edx,(%eax)
  802eeb:	eb 0a                	jmp    802ef7 <alloc_block_BF+0x9a>
  802eed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ef7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0a:	a1 44 51 80 00       	mov    0x805144,%eax
  802f0f:	48                   	dec    %eax
  802f10:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802f15:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f18:	e9 41 01 00 00       	jmp    80305e <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802f1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f20:	8b 40 0c             	mov    0xc(%eax),%eax
  802f23:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f26:	76 21                	jbe    802f49 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802f28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f31:	73 16                	jae    802f49 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802f33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f36:	8b 40 0c             	mov    0xc(%eax),%eax
  802f39:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802f3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802f42:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802f49:	a1 40 51 80 00       	mov    0x805140,%eax
  802f4e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802f51:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f55:	74 07                	je     802f5e <alloc_block_BF+0x101>
  802f57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5a:	8b 00                	mov    (%eax),%eax
  802f5c:	eb 05                	jmp    802f63 <alloc_block_BF+0x106>
  802f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f63:	a3 40 51 80 00       	mov    %eax,0x805140
  802f68:	a1 40 51 80 00       	mov    0x805140,%eax
  802f6d:	85 c0                	test   %eax,%eax
  802f6f:	0f 85 09 ff ff ff    	jne    802e7e <alloc_block_BF+0x21>
  802f75:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f79:	0f 85 ff fe ff ff    	jne    802e7e <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802f7f:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802f83:	0f 85 d0 00 00 00    	jne    803059 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802f89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8f:	2b 45 08             	sub    0x8(%ebp),%eax
  802f92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802f95:	a1 48 51 80 00       	mov    0x805148,%eax
  802f9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802f9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fa1:	75 17                	jne    802fba <alloc_block_BF+0x15d>
  802fa3:	83 ec 04             	sub    $0x4,%esp
  802fa6:	68 3c 44 80 00       	push   $0x80443c
  802fab:	68 d1 00 00 00       	push   $0xd1
  802fb0:	68 cb 43 80 00       	push   $0x8043cb
  802fb5:	e8 e3 d8 ff ff       	call   80089d <_panic>
  802fba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fbd:	8b 00                	mov    (%eax),%eax
  802fbf:	85 c0                	test   %eax,%eax
  802fc1:	74 10                	je     802fd3 <alloc_block_BF+0x176>
  802fc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fcb:	8b 52 04             	mov    0x4(%edx),%edx
  802fce:	89 50 04             	mov    %edx,0x4(%eax)
  802fd1:	eb 0b                	jmp    802fde <alloc_block_BF+0x181>
  802fd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd6:	8b 40 04             	mov    0x4(%eax),%eax
  802fd9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe1:	8b 40 04             	mov    0x4(%eax),%eax
  802fe4:	85 c0                	test   %eax,%eax
  802fe6:	74 0f                	je     802ff7 <alloc_block_BF+0x19a>
  802fe8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802feb:	8b 40 04             	mov    0x4(%eax),%eax
  802fee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ff1:	8b 12                	mov    (%edx),%edx
  802ff3:	89 10                	mov    %edx,(%eax)
  802ff5:	eb 0a                	jmp    803001 <alloc_block_BF+0x1a4>
  802ff7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ffa:	8b 00                	mov    (%eax),%eax
  802ffc:	a3 48 51 80 00       	mov    %eax,0x805148
  803001:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80300d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803014:	a1 54 51 80 00       	mov    0x805154,%eax
  803019:	48                   	dec    %eax
  80301a:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  80301f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803022:	8b 55 08             	mov    0x8(%ebp),%edx
  803025:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  803028:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302b:	8b 50 08             	mov    0x8(%eax),%edx
  80302e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803031:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  803034:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803037:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80303a:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  80303d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803040:	8b 50 08             	mov    0x8(%eax),%edx
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	01 c2                	add    %eax,%edx
  803048:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304b:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  80304e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803051:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  803054:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803057:	eb 05                	jmp    80305e <alloc_block_BF+0x201>
	 }
	 return NULL;
  803059:	b8 00 00 00 00       	mov    $0x0,%eax


}
  80305e:	c9                   	leave  
  80305f:	c3                   	ret    

00803060 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803060:	55                   	push   %ebp
  803061:	89 e5                	mov    %esp,%ebp
  803063:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  803066:	83 ec 04             	sub    $0x4,%esp
  803069:	68 5c 44 80 00       	push   $0x80445c
  80306e:	68 e8 00 00 00       	push   $0xe8
  803073:	68 cb 43 80 00       	push   $0x8043cb
  803078:	e8 20 d8 ff ff       	call   80089d <_panic>

0080307d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80307d:	55                   	push   %ebp
  80307e:	89 e5                	mov    %esp,%ebp
  803080:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  803083:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803088:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  80308b:	a1 38 51 80 00       	mov    0x805138,%eax
  803090:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  803093:	a1 44 51 80 00       	mov    0x805144,%eax
  803098:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  80309b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80309f:	75 68                	jne    803109 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8030a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a5:	75 17                	jne    8030be <insert_sorted_with_merge_freeList+0x41>
  8030a7:	83 ec 04             	sub    $0x4,%esp
  8030aa:	68 a8 43 80 00       	push   $0x8043a8
  8030af:	68 36 01 00 00       	push   $0x136
  8030b4:	68 cb 43 80 00       	push   $0x8043cb
  8030b9:	e8 df d7 ff ff       	call   80089d <_panic>
  8030be:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	89 10                	mov    %edx,(%eax)
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	8b 00                	mov    (%eax),%eax
  8030ce:	85 c0                	test   %eax,%eax
  8030d0:	74 0d                	je     8030df <insert_sorted_with_merge_freeList+0x62>
  8030d2:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030da:	89 50 04             	mov    %edx,0x4(%eax)
  8030dd:	eb 08                	jmp    8030e7 <insert_sorted_with_merge_freeList+0x6a>
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f9:	a1 44 51 80 00       	mov    0x805144,%eax
  8030fe:	40                   	inc    %eax
  8030ff:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803104:	e9 ba 06 00 00       	jmp    8037c3 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  803109:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310c:	8b 50 08             	mov    0x8(%eax),%edx
  80310f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803112:	8b 40 0c             	mov    0xc(%eax),%eax
  803115:	01 c2                	add    %eax,%edx
  803117:	8b 45 08             	mov    0x8(%ebp),%eax
  80311a:	8b 40 08             	mov    0x8(%eax),%eax
  80311d:	39 c2                	cmp    %eax,%edx
  80311f:	73 68                	jae    803189 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803121:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803125:	75 17                	jne    80313e <insert_sorted_with_merge_freeList+0xc1>
  803127:	83 ec 04             	sub    $0x4,%esp
  80312a:	68 e4 43 80 00       	push   $0x8043e4
  80312f:	68 3a 01 00 00       	push   $0x13a
  803134:	68 cb 43 80 00       	push   $0x8043cb
  803139:	e8 5f d7 ff ff       	call   80089d <_panic>
  80313e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	89 50 04             	mov    %edx,0x4(%eax)
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	8b 40 04             	mov    0x4(%eax),%eax
  803150:	85 c0                	test   %eax,%eax
  803152:	74 0c                	je     803160 <insert_sorted_with_merge_freeList+0xe3>
  803154:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803159:	8b 55 08             	mov    0x8(%ebp),%edx
  80315c:	89 10                	mov    %edx,(%eax)
  80315e:	eb 08                	jmp    803168 <insert_sorted_with_merge_freeList+0xeb>
  803160:	8b 45 08             	mov    0x8(%ebp),%eax
  803163:	a3 38 51 80 00       	mov    %eax,0x805138
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803179:	a1 44 51 80 00       	mov    0x805144,%eax
  80317e:	40                   	inc    %eax
  80317f:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803184:	e9 3a 06 00 00       	jmp    8037c3 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  803189:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318c:	8b 50 08             	mov    0x8(%eax),%edx
  80318f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803192:	8b 40 0c             	mov    0xc(%eax),%eax
  803195:	01 c2                	add    %eax,%edx
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	8b 40 08             	mov    0x8(%eax),%eax
  80319d:	39 c2                	cmp    %eax,%edx
  80319f:	0f 85 90 00 00 00    	jne    803235 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8031a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a8:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b1:	01 c2                	add    %eax,%edx
  8031b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b6:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8031b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8031c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d1:	75 17                	jne    8031ea <insert_sorted_with_merge_freeList+0x16d>
  8031d3:	83 ec 04             	sub    $0x4,%esp
  8031d6:	68 a8 43 80 00       	push   $0x8043a8
  8031db:	68 41 01 00 00       	push   $0x141
  8031e0:	68 cb 43 80 00       	push   $0x8043cb
  8031e5:	e8 b3 d6 ff ff       	call   80089d <_panic>
  8031ea:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f3:	89 10                	mov    %edx,(%eax)
  8031f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f8:	8b 00                	mov    (%eax),%eax
  8031fa:	85 c0                	test   %eax,%eax
  8031fc:	74 0d                	je     80320b <insert_sorted_with_merge_freeList+0x18e>
  8031fe:	a1 48 51 80 00       	mov    0x805148,%eax
  803203:	8b 55 08             	mov    0x8(%ebp),%edx
  803206:	89 50 04             	mov    %edx,0x4(%eax)
  803209:	eb 08                	jmp    803213 <insert_sorted_with_merge_freeList+0x196>
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803213:	8b 45 08             	mov    0x8(%ebp),%eax
  803216:	a3 48 51 80 00       	mov    %eax,0x805148
  80321b:	8b 45 08             	mov    0x8(%ebp),%eax
  80321e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803225:	a1 54 51 80 00       	mov    0x805154,%eax
  80322a:	40                   	inc    %eax
  80322b:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803230:	e9 8e 05 00 00       	jmp    8037c3 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	8b 50 08             	mov    0x8(%eax),%edx
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	8b 40 0c             	mov    0xc(%eax),%eax
  803241:	01 c2                	add    %eax,%edx
  803243:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803246:	8b 40 08             	mov    0x8(%eax),%eax
  803249:	39 c2                	cmp    %eax,%edx
  80324b:	73 68                	jae    8032b5 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80324d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803251:	75 17                	jne    80326a <insert_sorted_with_merge_freeList+0x1ed>
  803253:	83 ec 04             	sub    $0x4,%esp
  803256:	68 a8 43 80 00       	push   $0x8043a8
  80325b:	68 45 01 00 00       	push   $0x145
  803260:	68 cb 43 80 00       	push   $0x8043cb
  803265:	e8 33 d6 ff ff       	call   80089d <_panic>
  80326a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	89 10                	mov    %edx,(%eax)
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	8b 00                	mov    (%eax),%eax
  80327a:	85 c0                	test   %eax,%eax
  80327c:	74 0d                	je     80328b <insert_sorted_with_merge_freeList+0x20e>
  80327e:	a1 38 51 80 00       	mov    0x805138,%eax
  803283:	8b 55 08             	mov    0x8(%ebp),%edx
  803286:	89 50 04             	mov    %edx,0x4(%eax)
  803289:	eb 08                	jmp    803293 <insert_sorted_with_merge_freeList+0x216>
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803293:	8b 45 08             	mov    0x8(%ebp),%eax
  803296:	a3 38 51 80 00       	mov    %eax,0x805138
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a5:	a1 44 51 80 00       	mov    0x805144,%eax
  8032aa:	40                   	inc    %eax
  8032ab:	a3 44 51 80 00       	mov    %eax,0x805144





}
  8032b0:	e9 0e 05 00 00       	jmp    8037c3 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  8032b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b8:	8b 50 08             	mov    0x8(%eax),%edx
  8032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032be:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c1:	01 c2                	add    %eax,%edx
  8032c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032c6:	8b 40 08             	mov    0x8(%eax),%eax
  8032c9:	39 c2                	cmp    %eax,%edx
  8032cb:	0f 85 9c 00 00 00    	jne    80336d <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  8032d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d4:	8b 50 0c             	mov    0xc(%eax),%edx
  8032d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032da:	8b 40 0c             	mov    0xc(%eax),%eax
  8032dd:	01 c2                	add    %eax,%edx
  8032df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e2:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  8032e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e8:	8b 50 08             	mov    0x8(%eax),%edx
  8032eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ee:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803305:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803309:	75 17                	jne    803322 <insert_sorted_with_merge_freeList+0x2a5>
  80330b:	83 ec 04             	sub    $0x4,%esp
  80330e:	68 a8 43 80 00       	push   $0x8043a8
  803313:	68 4d 01 00 00       	push   $0x14d
  803318:	68 cb 43 80 00       	push   $0x8043cb
  80331d:	e8 7b d5 ff ff       	call   80089d <_panic>
  803322:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	89 10                	mov    %edx,(%eax)
  80332d:	8b 45 08             	mov    0x8(%ebp),%eax
  803330:	8b 00                	mov    (%eax),%eax
  803332:	85 c0                	test   %eax,%eax
  803334:	74 0d                	je     803343 <insert_sorted_with_merge_freeList+0x2c6>
  803336:	a1 48 51 80 00       	mov    0x805148,%eax
  80333b:	8b 55 08             	mov    0x8(%ebp),%edx
  80333e:	89 50 04             	mov    %edx,0x4(%eax)
  803341:	eb 08                	jmp    80334b <insert_sorted_with_merge_freeList+0x2ce>
  803343:	8b 45 08             	mov    0x8(%ebp),%eax
  803346:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	a3 48 51 80 00       	mov    %eax,0x805148
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80335d:	a1 54 51 80 00       	mov    0x805154,%eax
  803362:	40                   	inc    %eax
  803363:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803368:	e9 56 04 00 00       	jmp    8037c3 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  80336d:	a1 38 51 80 00       	mov    0x805138,%eax
  803372:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803375:	e9 19 04 00 00       	jmp    803793 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  80337a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337d:	8b 00                	mov    (%eax),%eax
  80337f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803385:	8b 50 08             	mov    0x8(%eax),%edx
  803388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338b:	8b 40 0c             	mov    0xc(%eax),%eax
  80338e:	01 c2                	add    %eax,%edx
  803390:	8b 45 08             	mov    0x8(%ebp),%eax
  803393:	8b 40 08             	mov    0x8(%eax),%eax
  803396:	39 c2                	cmp    %eax,%edx
  803398:	0f 85 ad 01 00 00    	jne    80354b <insert_sorted_with_merge_freeList+0x4ce>
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	8b 50 08             	mov    0x8(%eax),%edx
  8033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8033aa:	01 c2                	add    %eax,%edx
  8033ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033af:	8b 40 08             	mov    0x8(%eax),%eax
  8033b2:	39 c2                	cmp    %eax,%edx
  8033b4:	0f 85 91 01 00 00    	jne    80354b <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  8033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bd:	8b 50 0c             	mov    0xc(%eax),%edx
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	8b 48 0c             	mov    0xc(%eax),%ecx
  8033c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8033cc:	01 c8                	add    %ecx,%eax
  8033ce:	01 c2                	add    %eax,%edx
  8033d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d3:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8033e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  8033ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  8033f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  8033fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803402:	75 17                	jne    80341b <insert_sorted_with_merge_freeList+0x39e>
  803404:	83 ec 04             	sub    $0x4,%esp
  803407:	68 3c 44 80 00       	push   $0x80443c
  80340c:	68 5b 01 00 00       	push   $0x15b
  803411:	68 cb 43 80 00       	push   $0x8043cb
  803416:	e8 82 d4 ff ff       	call   80089d <_panic>
  80341b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341e:	8b 00                	mov    (%eax),%eax
  803420:	85 c0                	test   %eax,%eax
  803422:	74 10                	je     803434 <insert_sorted_with_merge_freeList+0x3b7>
  803424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803427:	8b 00                	mov    (%eax),%eax
  803429:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80342c:	8b 52 04             	mov    0x4(%edx),%edx
  80342f:	89 50 04             	mov    %edx,0x4(%eax)
  803432:	eb 0b                	jmp    80343f <insert_sorted_with_merge_freeList+0x3c2>
  803434:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803437:	8b 40 04             	mov    0x4(%eax),%eax
  80343a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80343f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803442:	8b 40 04             	mov    0x4(%eax),%eax
  803445:	85 c0                	test   %eax,%eax
  803447:	74 0f                	je     803458 <insert_sorted_with_merge_freeList+0x3db>
  803449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80344c:	8b 40 04             	mov    0x4(%eax),%eax
  80344f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803452:	8b 12                	mov    (%edx),%edx
  803454:	89 10                	mov    %edx,(%eax)
  803456:	eb 0a                	jmp    803462 <insert_sorted_with_merge_freeList+0x3e5>
  803458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345b:	8b 00                	mov    (%eax),%eax
  80345d:	a3 38 51 80 00       	mov    %eax,0x805138
  803462:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803465:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80346b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803475:	a1 44 51 80 00       	mov    0x805144,%eax
  80347a:	48                   	dec    %eax
  80347b:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803480:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803484:	75 17                	jne    80349d <insert_sorted_with_merge_freeList+0x420>
  803486:	83 ec 04             	sub    $0x4,%esp
  803489:	68 a8 43 80 00       	push   $0x8043a8
  80348e:	68 5c 01 00 00       	push   $0x15c
  803493:	68 cb 43 80 00       	push   $0x8043cb
  803498:	e8 00 d4 ff ff       	call   80089d <_panic>
  80349d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a6:	89 10                	mov    %edx,(%eax)
  8034a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ab:	8b 00                	mov    (%eax),%eax
  8034ad:	85 c0                	test   %eax,%eax
  8034af:	74 0d                	je     8034be <insert_sorted_with_merge_freeList+0x441>
  8034b1:	a1 48 51 80 00       	mov    0x805148,%eax
  8034b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8034b9:	89 50 04             	mov    %edx,0x4(%eax)
  8034bc:	eb 08                	jmp    8034c6 <insert_sorted_with_merge_freeList+0x449>
  8034be:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c9:	a3 48 51 80 00       	mov    %eax,0x805148
  8034ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d8:	a1 54 51 80 00       	mov    0x805154,%eax
  8034dd:	40                   	inc    %eax
  8034de:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  8034e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034e7:	75 17                	jne    803500 <insert_sorted_with_merge_freeList+0x483>
  8034e9:	83 ec 04             	sub    $0x4,%esp
  8034ec:	68 a8 43 80 00       	push   $0x8043a8
  8034f1:	68 5d 01 00 00       	push   $0x15d
  8034f6:	68 cb 43 80 00       	push   $0x8043cb
  8034fb:	e8 9d d3 ff ff       	call   80089d <_panic>
  803500:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803509:	89 10                	mov    %edx,(%eax)
  80350b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80350e:	8b 00                	mov    (%eax),%eax
  803510:	85 c0                	test   %eax,%eax
  803512:	74 0d                	je     803521 <insert_sorted_with_merge_freeList+0x4a4>
  803514:	a1 48 51 80 00       	mov    0x805148,%eax
  803519:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80351c:	89 50 04             	mov    %edx,0x4(%eax)
  80351f:	eb 08                	jmp    803529 <insert_sorted_with_merge_freeList+0x4ac>
  803521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803524:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803529:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80352c:	a3 48 51 80 00       	mov    %eax,0x805148
  803531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803534:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80353b:	a1 54 51 80 00       	mov    0x805154,%eax
  803540:	40                   	inc    %eax
  803541:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803546:	e9 78 02 00 00       	jmp    8037c3 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  80354b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354e:	8b 50 08             	mov    0x8(%eax),%edx
  803551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803554:	8b 40 0c             	mov    0xc(%eax),%eax
  803557:	01 c2                	add    %eax,%edx
  803559:	8b 45 08             	mov    0x8(%ebp),%eax
  80355c:	8b 40 08             	mov    0x8(%eax),%eax
  80355f:	39 c2                	cmp    %eax,%edx
  803561:	0f 83 b8 00 00 00    	jae    80361f <insert_sorted_with_merge_freeList+0x5a2>
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	8b 50 08             	mov    0x8(%eax),%edx
  80356d:	8b 45 08             	mov    0x8(%ebp),%eax
  803570:	8b 40 0c             	mov    0xc(%eax),%eax
  803573:	01 c2                	add    %eax,%edx
  803575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803578:	8b 40 08             	mov    0x8(%eax),%eax
  80357b:	39 c2                	cmp    %eax,%edx
  80357d:	0f 85 9c 00 00 00    	jne    80361f <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  803583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803586:	8b 50 0c             	mov    0xc(%eax),%edx
  803589:	8b 45 08             	mov    0x8(%ebp),%eax
  80358c:	8b 40 0c             	mov    0xc(%eax),%eax
  80358f:	01 c2                	add    %eax,%edx
  803591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803594:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  803597:	8b 45 08             	mov    0x8(%ebp),%eax
  80359a:	8b 50 08             	mov    0x8(%eax),%edx
  80359d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a0:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8035b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035bb:	75 17                	jne    8035d4 <insert_sorted_with_merge_freeList+0x557>
  8035bd:	83 ec 04             	sub    $0x4,%esp
  8035c0:	68 a8 43 80 00       	push   $0x8043a8
  8035c5:	68 67 01 00 00       	push   $0x167
  8035ca:	68 cb 43 80 00       	push   $0x8043cb
  8035cf:	e8 c9 d2 ff ff       	call   80089d <_panic>
  8035d4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035da:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dd:	89 10                	mov    %edx,(%eax)
  8035df:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e2:	8b 00                	mov    (%eax),%eax
  8035e4:	85 c0                	test   %eax,%eax
  8035e6:	74 0d                	je     8035f5 <insert_sorted_with_merge_freeList+0x578>
  8035e8:	a1 48 51 80 00       	mov    0x805148,%eax
  8035ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8035f0:	89 50 04             	mov    %edx,0x4(%eax)
  8035f3:	eb 08                	jmp    8035fd <insert_sorted_with_merge_freeList+0x580>
  8035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803600:	a3 48 51 80 00       	mov    %eax,0x805148
  803605:	8b 45 08             	mov    0x8(%ebp),%eax
  803608:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80360f:	a1 54 51 80 00       	mov    0x805154,%eax
  803614:	40                   	inc    %eax
  803615:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80361a:	e9 a4 01 00 00       	jmp    8037c3 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803622:	8b 50 08             	mov    0x8(%eax),%edx
  803625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803628:	8b 40 0c             	mov    0xc(%eax),%eax
  80362b:	01 c2                	add    %eax,%edx
  80362d:	8b 45 08             	mov    0x8(%ebp),%eax
  803630:	8b 40 08             	mov    0x8(%eax),%eax
  803633:	39 c2                	cmp    %eax,%edx
  803635:	0f 85 ac 00 00 00    	jne    8036e7 <insert_sorted_with_merge_freeList+0x66a>
  80363b:	8b 45 08             	mov    0x8(%ebp),%eax
  80363e:	8b 50 08             	mov    0x8(%eax),%edx
  803641:	8b 45 08             	mov    0x8(%ebp),%eax
  803644:	8b 40 0c             	mov    0xc(%eax),%eax
  803647:	01 c2                	add    %eax,%edx
  803649:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364c:	8b 40 08             	mov    0x8(%eax),%eax
  80364f:	39 c2                	cmp    %eax,%edx
  803651:	0f 83 90 00 00 00    	jae    8036e7 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  803657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365a:	8b 50 0c             	mov    0xc(%eax),%edx
  80365d:	8b 45 08             	mov    0x8(%ebp),%eax
  803660:	8b 40 0c             	mov    0xc(%eax),%eax
  803663:	01 c2                	add    %eax,%edx
  803665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803668:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  80366b:	8b 45 08             	mov    0x8(%ebp),%eax
  80366e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  803675:	8b 45 08             	mov    0x8(%ebp),%eax
  803678:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80367f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803683:	75 17                	jne    80369c <insert_sorted_with_merge_freeList+0x61f>
  803685:	83 ec 04             	sub    $0x4,%esp
  803688:	68 a8 43 80 00       	push   $0x8043a8
  80368d:	68 70 01 00 00       	push   $0x170
  803692:	68 cb 43 80 00       	push   $0x8043cb
  803697:	e8 01 d2 ff ff       	call   80089d <_panic>
  80369c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a5:	89 10                	mov    %edx,(%eax)
  8036a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036aa:	8b 00                	mov    (%eax),%eax
  8036ac:	85 c0                	test   %eax,%eax
  8036ae:	74 0d                	je     8036bd <insert_sorted_with_merge_freeList+0x640>
  8036b0:	a1 48 51 80 00       	mov    0x805148,%eax
  8036b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8036b8:	89 50 04             	mov    %edx,0x4(%eax)
  8036bb:	eb 08                	jmp    8036c5 <insert_sorted_with_merge_freeList+0x648>
  8036bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c8:	a3 48 51 80 00       	mov    %eax,0x805148
  8036cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d7:	a1 54 51 80 00       	mov    0x805154,%eax
  8036dc:	40                   	inc    %eax
  8036dd:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  8036e2:	e9 dc 00 00 00       	jmp    8037c3 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8036e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ea:	8b 50 08             	mov    0x8(%eax),%edx
  8036ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f3:	01 c2                	add    %eax,%edx
  8036f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f8:	8b 40 08             	mov    0x8(%eax),%eax
  8036fb:	39 c2                	cmp    %eax,%edx
  8036fd:	0f 83 88 00 00 00    	jae    80378b <insert_sorted_with_merge_freeList+0x70e>
  803703:	8b 45 08             	mov    0x8(%ebp),%eax
  803706:	8b 50 08             	mov    0x8(%eax),%edx
  803709:	8b 45 08             	mov    0x8(%ebp),%eax
  80370c:	8b 40 0c             	mov    0xc(%eax),%eax
  80370f:	01 c2                	add    %eax,%edx
  803711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803714:	8b 40 08             	mov    0x8(%eax),%eax
  803717:	39 c2                	cmp    %eax,%edx
  803719:	73 70                	jae    80378b <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  80371b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80371f:	74 06                	je     803727 <insert_sorted_with_merge_freeList+0x6aa>
  803721:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803725:	75 17                	jne    80373e <insert_sorted_with_merge_freeList+0x6c1>
  803727:	83 ec 04             	sub    $0x4,%esp
  80372a:	68 08 44 80 00       	push   $0x804408
  80372f:	68 75 01 00 00       	push   $0x175
  803734:	68 cb 43 80 00       	push   $0x8043cb
  803739:	e8 5f d1 ff ff       	call   80089d <_panic>
  80373e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803741:	8b 10                	mov    (%eax),%edx
  803743:	8b 45 08             	mov    0x8(%ebp),%eax
  803746:	89 10                	mov    %edx,(%eax)
  803748:	8b 45 08             	mov    0x8(%ebp),%eax
  80374b:	8b 00                	mov    (%eax),%eax
  80374d:	85 c0                	test   %eax,%eax
  80374f:	74 0b                	je     80375c <insert_sorted_with_merge_freeList+0x6df>
  803751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803754:	8b 00                	mov    (%eax),%eax
  803756:	8b 55 08             	mov    0x8(%ebp),%edx
  803759:	89 50 04             	mov    %edx,0x4(%eax)
  80375c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375f:	8b 55 08             	mov    0x8(%ebp),%edx
  803762:	89 10                	mov    %edx,(%eax)
  803764:	8b 45 08             	mov    0x8(%ebp),%eax
  803767:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80376a:	89 50 04             	mov    %edx,0x4(%eax)
  80376d:	8b 45 08             	mov    0x8(%ebp),%eax
  803770:	8b 00                	mov    (%eax),%eax
  803772:	85 c0                	test   %eax,%eax
  803774:	75 08                	jne    80377e <insert_sorted_with_merge_freeList+0x701>
  803776:	8b 45 08             	mov    0x8(%ebp),%eax
  803779:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80377e:	a1 44 51 80 00       	mov    0x805144,%eax
  803783:	40                   	inc    %eax
  803784:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  803789:	eb 38                	jmp    8037c3 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  80378b:	a1 40 51 80 00       	mov    0x805140,%eax
  803790:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803793:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803797:	74 07                	je     8037a0 <insert_sorted_with_merge_freeList+0x723>
  803799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379c:	8b 00                	mov    (%eax),%eax
  80379e:	eb 05                	jmp    8037a5 <insert_sorted_with_merge_freeList+0x728>
  8037a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a5:	a3 40 51 80 00       	mov    %eax,0x805140
  8037aa:	a1 40 51 80 00       	mov    0x805140,%eax
  8037af:	85 c0                	test   %eax,%eax
  8037b1:	0f 85 c3 fb ff ff    	jne    80337a <insert_sorted_with_merge_freeList+0x2fd>
  8037b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037bb:	0f 85 b9 fb ff ff    	jne    80337a <insert_sorted_with_merge_freeList+0x2fd>





}
  8037c1:	eb 00                	jmp    8037c3 <insert_sorted_with_merge_freeList+0x746>
  8037c3:	90                   	nop
  8037c4:	c9                   	leave  
  8037c5:	c3                   	ret    
  8037c6:	66 90                	xchg   %ax,%ax

008037c8 <__udivdi3>:
  8037c8:	55                   	push   %ebp
  8037c9:	57                   	push   %edi
  8037ca:	56                   	push   %esi
  8037cb:	53                   	push   %ebx
  8037cc:	83 ec 1c             	sub    $0x1c,%esp
  8037cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037df:	89 ca                	mov    %ecx,%edx
  8037e1:	89 f8                	mov    %edi,%eax
  8037e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037e7:	85 f6                	test   %esi,%esi
  8037e9:	75 2d                	jne    803818 <__udivdi3+0x50>
  8037eb:	39 cf                	cmp    %ecx,%edi
  8037ed:	77 65                	ja     803854 <__udivdi3+0x8c>
  8037ef:	89 fd                	mov    %edi,%ebp
  8037f1:	85 ff                	test   %edi,%edi
  8037f3:	75 0b                	jne    803800 <__udivdi3+0x38>
  8037f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8037fa:	31 d2                	xor    %edx,%edx
  8037fc:	f7 f7                	div    %edi
  8037fe:	89 c5                	mov    %eax,%ebp
  803800:	31 d2                	xor    %edx,%edx
  803802:	89 c8                	mov    %ecx,%eax
  803804:	f7 f5                	div    %ebp
  803806:	89 c1                	mov    %eax,%ecx
  803808:	89 d8                	mov    %ebx,%eax
  80380a:	f7 f5                	div    %ebp
  80380c:	89 cf                	mov    %ecx,%edi
  80380e:	89 fa                	mov    %edi,%edx
  803810:	83 c4 1c             	add    $0x1c,%esp
  803813:	5b                   	pop    %ebx
  803814:	5e                   	pop    %esi
  803815:	5f                   	pop    %edi
  803816:	5d                   	pop    %ebp
  803817:	c3                   	ret    
  803818:	39 ce                	cmp    %ecx,%esi
  80381a:	77 28                	ja     803844 <__udivdi3+0x7c>
  80381c:	0f bd fe             	bsr    %esi,%edi
  80381f:	83 f7 1f             	xor    $0x1f,%edi
  803822:	75 40                	jne    803864 <__udivdi3+0x9c>
  803824:	39 ce                	cmp    %ecx,%esi
  803826:	72 0a                	jb     803832 <__udivdi3+0x6a>
  803828:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80382c:	0f 87 9e 00 00 00    	ja     8038d0 <__udivdi3+0x108>
  803832:	b8 01 00 00 00       	mov    $0x1,%eax
  803837:	89 fa                	mov    %edi,%edx
  803839:	83 c4 1c             	add    $0x1c,%esp
  80383c:	5b                   	pop    %ebx
  80383d:	5e                   	pop    %esi
  80383e:	5f                   	pop    %edi
  80383f:	5d                   	pop    %ebp
  803840:	c3                   	ret    
  803841:	8d 76 00             	lea    0x0(%esi),%esi
  803844:	31 ff                	xor    %edi,%edi
  803846:	31 c0                	xor    %eax,%eax
  803848:	89 fa                	mov    %edi,%edx
  80384a:	83 c4 1c             	add    $0x1c,%esp
  80384d:	5b                   	pop    %ebx
  80384e:	5e                   	pop    %esi
  80384f:	5f                   	pop    %edi
  803850:	5d                   	pop    %ebp
  803851:	c3                   	ret    
  803852:	66 90                	xchg   %ax,%ax
  803854:	89 d8                	mov    %ebx,%eax
  803856:	f7 f7                	div    %edi
  803858:	31 ff                	xor    %edi,%edi
  80385a:	89 fa                	mov    %edi,%edx
  80385c:	83 c4 1c             	add    $0x1c,%esp
  80385f:	5b                   	pop    %ebx
  803860:	5e                   	pop    %esi
  803861:	5f                   	pop    %edi
  803862:	5d                   	pop    %ebp
  803863:	c3                   	ret    
  803864:	bd 20 00 00 00       	mov    $0x20,%ebp
  803869:	89 eb                	mov    %ebp,%ebx
  80386b:	29 fb                	sub    %edi,%ebx
  80386d:	89 f9                	mov    %edi,%ecx
  80386f:	d3 e6                	shl    %cl,%esi
  803871:	89 c5                	mov    %eax,%ebp
  803873:	88 d9                	mov    %bl,%cl
  803875:	d3 ed                	shr    %cl,%ebp
  803877:	89 e9                	mov    %ebp,%ecx
  803879:	09 f1                	or     %esi,%ecx
  80387b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80387f:	89 f9                	mov    %edi,%ecx
  803881:	d3 e0                	shl    %cl,%eax
  803883:	89 c5                	mov    %eax,%ebp
  803885:	89 d6                	mov    %edx,%esi
  803887:	88 d9                	mov    %bl,%cl
  803889:	d3 ee                	shr    %cl,%esi
  80388b:	89 f9                	mov    %edi,%ecx
  80388d:	d3 e2                	shl    %cl,%edx
  80388f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803893:	88 d9                	mov    %bl,%cl
  803895:	d3 e8                	shr    %cl,%eax
  803897:	09 c2                	or     %eax,%edx
  803899:	89 d0                	mov    %edx,%eax
  80389b:	89 f2                	mov    %esi,%edx
  80389d:	f7 74 24 0c          	divl   0xc(%esp)
  8038a1:	89 d6                	mov    %edx,%esi
  8038a3:	89 c3                	mov    %eax,%ebx
  8038a5:	f7 e5                	mul    %ebp
  8038a7:	39 d6                	cmp    %edx,%esi
  8038a9:	72 19                	jb     8038c4 <__udivdi3+0xfc>
  8038ab:	74 0b                	je     8038b8 <__udivdi3+0xf0>
  8038ad:	89 d8                	mov    %ebx,%eax
  8038af:	31 ff                	xor    %edi,%edi
  8038b1:	e9 58 ff ff ff       	jmp    80380e <__udivdi3+0x46>
  8038b6:	66 90                	xchg   %ax,%ax
  8038b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038bc:	89 f9                	mov    %edi,%ecx
  8038be:	d3 e2                	shl    %cl,%edx
  8038c0:	39 c2                	cmp    %eax,%edx
  8038c2:	73 e9                	jae    8038ad <__udivdi3+0xe5>
  8038c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038c7:	31 ff                	xor    %edi,%edi
  8038c9:	e9 40 ff ff ff       	jmp    80380e <__udivdi3+0x46>
  8038ce:	66 90                	xchg   %ax,%ax
  8038d0:	31 c0                	xor    %eax,%eax
  8038d2:	e9 37 ff ff ff       	jmp    80380e <__udivdi3+0x46>
  8038d7:	90                   	nop

008038d8 <__umoddi3>:
  8038d8:	55                   	push   %ebp
  8038d9:	57                   	push   %edi
  8038da:	56                   	push   %esi
  8038db:	53                   	push   %ebx
  8038dc:	83 ec 1c             	sub    $0x1c,%esp
  8038df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038f7:	89 f3                	mov    %esi,%ebx
  8038f9:	89 fa                	mov    %edi,%edx
  8038fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038ff:	89 34 24             	mov    %esi,(%esp)
  803902:	85 c0                	test   %eax,%eax
  803904:	75 1a                	jne    803920 <__umoddi3+0x48>
  803906:	39 f7                	cmp    %esi,%edi
  803908:	0f 86 a2 00 00 00    	jbe    8039b0 <__umoddi3+0xd8>
  80390e:	89 c8                	mov    %ecx,%eax
  803910:	89 f2                	mov    %esi,%edx
  803912:	f7 f7                	div    %edi
  803914:	89 d0                	mov    %edx,%eax
  803916:	31 d2                	xor    %edx,%edx
  803918:	83 c4 1c             	add    $0x1c,%esp
  80391b:	5b                   	pop    %ebx
  80391c:	5e                   	pop    %esi
  80391d:	5f                   	pop    %edi
  80391e:	5d                   	pop    %ebp
  80391f:	c3                   	ret    
  803920:	39 f0                	cmp    %esi,%eax
  803922:	0f 87 ac 00 00 00    	ja     8039d4 <__umoddi3+0xfc>
  803928:	0f bd e8             	bsr    %eax,%ebp
  80392b:	83 f5 1f             	xor    $0x1f,%ebp
  80392e:	0f 84 ac 00 00 00    	je     8039e0 <__umoddi3+0x108>
  803934:	bf 20 00 00 00       	mov    $0x20,%edi
  803939:	29 ef                	sub    %ebp,%edi
  80393b:	89 fe                	mov    %edi,%esi
  80393d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803941:	89 e9                	mov    %ebp,%ecx
  803943:	d3 e0                	shl    %cl,%eax
  803945:	89 d7                	mov    %edx,%edi
  803947:	89 f1                	mov    %esi,%ecx
  803949:	d3 ef                	shr    %cl,%edi
  80394b:	09 c7                	or     %eax,%edi
  80394d:	89 e9                	mov    %ebp,%ecx
  80394f:	d3 e2                	shl    %cl,%edx
  803951:	89 14 24             	mov    %edx,(%esp)
  803954:	89 d8                	mov    %ebx,%eax
  803956:	d3 e0                	shl    %cl,%eax
  803958:	89 c2                	mov    %eax,%edx
  80395a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80395e:	d3 e0                	shl    %cl,%eax
  803960:	89 44 24 04          	mov    %eax,0x4(%esp)
  803964:	8b 44 24 08          	mov    0x8(%esp),%eax
  803968:	89 f1                	mov    %esi,%ecx
  80396a:	d3 e8                	shr    %cl,%eax
  80396c:	09 d0                	or     %edx,%eax
  80396e:	d3 eb                	shr    %cl,%ebx
  803970:	89 da                	mov    %ebx,%edx
  803972:	f7 f7                	div    %edi
  803974:	89 d3                	mov    %edx,%ebx
  803976:	f7 24 24             	mull   (%esp)
  803979:	89 c6                	mov    %eax,%esi
  80397b:	89 d1                	mov    %edx,%ecx
  80397d:	39 d3                	cmp    %edx,%ebx
  80397f:	0f 82 87 00 00 00    	jb     803a0c <__umoddi3+0x134>
  803985:	0f 84 91 00 00 00    	je     803a1c <__umoddi3+0x144>
  80398b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80398f:	29 f2                	sub    %esi,%edx
  803991:	19 cb                	sbb    %ecx,%ebx
  803993:	89 d8                	mov    %ebx,%eax
  803995:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803999:	d3 e0                	shl    %cl,%eax
  80399b:	89 e9                	mov    %ebp,%ecx
  80399d:	d3 ea                	shr    %cl,%edx
  80399f:	09 d0                	or     %edx,%eax
  8039a1:	89 e9                	mov    %ebp,%ecx
  8039a3:	d3 eb                	shr    %cl,%ebx
  8039a5:	89 da                	mov    %ebx,%edx
  8039a7:	83 c4 1c             	add    $0x1c,%esp
  8039aa:	5b                   	pop    %ebx
  8039ab:	5e                   	pop    %esi
  8039ac:	5f                   	pop    %edi
  8039ad:	5d                   	pop    %ebp
  8039ae:	c3                   	ret    
  8039af:	90                   	nop
  8039b0:	89 fd                	mov    %edi,%ebp
  8039b2:	85 ff                	test   %edi,%edi
  8039b4:	75 0b                	jne    8039c1 <__umoddi3+0xe9>
  8039b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8039bb:	31 d2                	xor    %edx,%edx
  8039bd:	f7 f7                	div    %edi
  8039bf:	89 c5                	mov    %eax,%ebp
  8039c1:	89 f0                	mov    %esi,%eax
  8039c3:	31 d2                	xor    %edx,%edx
  8039c5:	f7 f5                	div    %ebp
  8039c7:	89 c8                	mov    %ecx,%eax
  8039c9:	f7 f5                	div    %ebp
  8039cb:	89 d0                	mov    %edx,%eax
  8039cd:	e9 44 ff ff ff       	jmp    803916 <__umoddi3+0x3e>
  8039d2:	66 90                	xchg   %ax,%ax
  8039d4:	89 c8                	mov    %ecx,%eax
  8039d6:	89 f2                	mov    %esi,%edx
  8039d8:	83 c4 1c             	add    $0x1c,%esp
  8039db:	5b                   	pop    %ebx
  8039dc:	5e                   	pop    %esi
  8039dd:	5f                   	pop    %edi
  8039de:	5d                   	pop    %ebp
  8039df:	c3                   	ret    
  8039e0:	3b 04 24             	cmp    (%esp),%eax
  8039e3:	72 06                	jb     8039eb <__umoddi3+0x113>
  8039e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039e9:	77 0f                	ja     8039fa <__umoddi3+0x122>
  8039eb:	89 f2                	mov    %esi,%edx
  8039ed:	29 f9                	sub    %edi,%ecx
  8039ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039f3:	89 14 24             	mov    %edx,(%esp)
  8039f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039fe:	8b 14 24             	mov    (%esp),%edx
  803a01:	83 c4 1c             	add    $0x1c,%esp
  803a04:	5b                   	pop    %ebx
  803a05:	5e                   	pop    %esi
  803a06:	5f                   	pop    %edi
  803a07:	5d                   	pop    %ebp
  803a08:	c3                   	ret    
  803a09:	8d 76 00             	lea    0x0(%esi),%esi
  803a0c:	2b 04 24             	sub    (%esp),%eax
  803a0f:	19 fa                	sbb    %edi,%edx
  803a11:	89 d1                	mov    %edx,%ecx
  803a13:	89 c6                	mov    %eax,%esi
  803a15:	e9 71 ff ff ff       	jmp    80398b <__umoddi3+0xb3>
  803a1a:	66 90                	xchg   %ax,%ax
  803a1c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a20:	72 ea                	jb     803a0c <__umoddi3+0x134>
  803a22:	89 d9                	mov    %ebx,%ecx
  803a24:	e9 62 ff ff ff       	jmp    80398b <__umoddi3+0xb3>
