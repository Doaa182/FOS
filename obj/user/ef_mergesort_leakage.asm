
obj/user/ef_mergesort_leakage:     file format elf32-i386


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
  800031:	e8 9a 07 00 00       	call   8007d0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	char Line[255] ;
	char Chose ;
	int numOfRep = 0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{
		numOfRep++ ;
  800048:	ff 45 f0             	incl   -0x10(%ebp)
		//2012: lock the interrupt
		sys_disable_interrupt();
  80004b:	e8 15 20 00 00       	call   802065 <sys_disable_interrupt>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 a0 38 80 00       	push   $0x8038a0
  800058:	e8 63 0b 00 00       	call   800bc0 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 a2 38 80 00       	push   $0x8038a2
  800068:	e8 53 0b 00 00       	call   800bc0 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 b8 38 80 00       	push   $0x8038b8
  800078:	e8 43 0b 00 00       	call   800bc0 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 a2 38 80 00       	push   $0x8038a2
  800088:	e8 33 0b 00 00       	call   800bc0 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 a0 38 80 00       	push   $0x8038a0
  800098:	e8 23 0b 00 00       	call   800bc0 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 d0 38 80 00       	push   $0x8038d0
  8000a8:	e8 13 0b 00 00       	call   800bc0 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp

		int NumOfElements ;

		if (numOfRep == 1)
  8000b0:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  8000b4:	75 09                	jne    8000bf <_main+0x87>
			NumOfElements = 32;
  8000b6:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
  8000bd:	eb 0d                	jmp    8000cc <_main+0x94>
		else if (numOfRep == 2)
  8000bf:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8000c3:	75 07                	jne    8000cc <_main+0x94>
			NumOfElements = 32;
  8000c5:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)

		cprintf("%d\n", NumOfElements) ;
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d2:	68 ef 38 80 00       	push   $0x8038ef
  8000d7:	e8 e4 0a 00 00       	call   800bc0 <cprintf>
  8000dc:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e2:	c1 e0 02             	shl    $0x2,%eax
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	50                   	push   %eax
  8000e9:	e8 4b 1a 00 00       	call   801b39 <malloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 f4 38 80 00       	push   $0x8038f4
  8000fc:	e8 bf 0a 00 00       	call   800bc0 <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 16 39 80 00       	push   $0x803916
  80010c:	e8 af 0a 00 00       	call   800bc0 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 24 39 80 00       	push   $0x803924
  80011c:	e8 9f 0a 00 00       	call   800bc0 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 33 39 80 00       	push   $0x803933
  80012c:	e8 8f 0a 00 00       	call   800bc0 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 43 39 80 00       	push   $0x803943
  80013c:	e8 7f 0a 00 00       	call   800bc0 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  800144:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800148:	75 06                	jne    800150 <_main+0x118>
				Chose = 'a' ;
  80014a:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
  80014e:	eb 0a                	jmp    80015a <_main+0x122>
			else if (numOfRep == 2)
  800150:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800154:	75 04                	jne    80015a <_main+0x122>
				Chose = 'c' ;
  800156:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80015a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	50                   	push   %eax
  800162:	e8 c9 05 00 00       	call   800730 <cputchar>
  800167:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	6a 0a                	push   $0xa
  80016f:	e8 bc 05 00 00       	call   800730 <cputchar>
  800174:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800177:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80017b:	74 0c                	je     800189 <_main+0x151>
  80017d:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800181:	74 06                	je     800189 <_main+0x151>
  800183:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800187:	75 ab                	jne    800134 <_main+0xfc>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800189:	e8 f1 1e 00 00       	call   80207f <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80018e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800192:	83 f8 62             	cmp    $0x62,%eax
  800195:	74 1d                	je     8001b4 <_main+0x17c>
  800197:	83 f8 63             	cmp    $0x63,%eax
  80019a:	74 2b                	je     8001c7 <_main+0x18f>
  80019c:	83 f8 61             	cmp    $0x61,%eax
  80019f:	75 39                	jne    8001da <_main+0x1a2>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 f4 01 00 00       	call   8003a3 <InitializeAscending>
  8001af:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b2:	eb 37                	jmp    8001eb <_main+0x1b3>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8001bd:	e8 12 02 00 00       	call   8003d4 <InitializeDescending>
  8001c2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c5:	eb 24                	jmp    8001eb <_main+0x1b3>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d0:	e8 34 02 00 00       	call   800409 <InitializeSemiRandom>
  8001d5:	83 c4 10             	add    $0x10,%esp
			break ;
  8001d8:	eb 11                	jmp    8001eb <_main+0x1b3>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e3:	e8 21 02 00 00       	call   800409 <InitializeSemiRandom>
  8001e8:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f1:	6a 01                	push   $0x1
  8001f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f6:	e8 e0 02 00 00       	call   8004db <MSort>
  8001fb:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001fe:	e8 62 1e 00 00       	call   802065 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 4c 39 80 00       	push   $0x80394c
  80020b:	e8 b0 09 00 00       	call   800bc0 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  800213:	e8 67 1e 00 00       	call   80207f <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	ff 75 ec             	pushl  -0x14(%ebp)
  80021e:	ff 75 e8             	pushl  -0x18(%ebp)
  800221:	e8 d3 00 00 00       	call   8002f9 <CheckSorted>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  80022c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800230:	75 14                	jne    800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 80 39 80 00       	push   $0x803980
  80023a:	6a 58                	push   $0x58
  80023c:	68 a2 39 80 00       	push   $0x8039a2
  800241:	e8 c6 06 00 00       	call   80090c <_panic>
		else
		{
			sys_disable_interrupt();
  800246:	e8 1a 1e 00 00       	call   802065 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 c0 39 80 00       	push   $0x8039c0
  800253:	e8 68 09 00 00       	call   800bc0 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 f4 39 80 00       	push   $0x8039f4
  800263:	e8 58 09 00 00       	call   800bc0 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 28 3a 80 00       	push   $0x803a28
  800273:	e8 48 09 00 00       	call   800bc0 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80027b:	e8 ff 1d 00 00       	call   80207f <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800280:	e8 e0 1d 00 00       	call   802065 <sys_disable_interrupt>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 5a 3a 80 00       	push   $0x803a5a
  800293:	e8 28 09 00 00       	call   800bc0 <cprintf>
  800298:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  80029b:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80029f:	75 06                	jne    8002a7 <_main+0x26f>
				Chose = 'y' ;
  8002a1:	c6 45 f7 79          	movb   $0x79,-0x9(%ebp)
  8002a5:	eb 0a                	jmp    8002b1 <_main+0x279>
			else if (numOfRep == 2)
  8002a7:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ab:	75 04                	jne    8002b1 <_main+0x279>
				Chose = 'n' ;
  8002ad:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  8002b1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	e8 72 04 00 00       	call   800730 <cputchar>
  8002be:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 0a                	push   $0xa
  8002c6:	e8 65 04 00 00       	call   800730 <cputchar>
  8002cb:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 0a                	push   $0xa
  8002d3:	e8 58 04 00 00       	call   800730 <cputchar>
  8002d8:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  8002db:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002df:	74 06                	je     8002e7 <_main+0x2af>
  8002e1:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002e5:	75 a4                	jne    80028b <_main+0x253>
				Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_enable_interrupt();
  8002e7:	e8 93 1d 00 00       	call   80207f <sys_enable_interrupt>

	} while (Chose == 'y');
  8002ec:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002f0:	0f 84 52 fd ff ff    	je     800048 <_main+0x10>
}
  8002f6:	90                   	nop
  8002f7:	c9                   	leave  
  8002f8:	c3                   	ret    

008002f9 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800306:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80030d:	eb 33                	jmp    800342 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80030f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800323:	40                   	inc    %eax
  800324:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 c8                	add    %ecx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	39 c2                	cmp    %eax,%edx
  800334:	7e 09                	jle    80033f <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800336:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80033d:	eb 0c                	jmp    80034b <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80033f:	ff 45 f8             	incl   -0x8(%ebp)
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
  800345:	48                   	dec    %eax
  800346:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800349:	7f c4                	jg     80030f <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80034b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800356:	8b 45 0c             	mov    0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 08             	mov    0x8(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 00                	mov    (%eax),%eax
  800367:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80036a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	01 c2                	add    %eax,%edx
  800379:	8b 45 10             	mov    0x10(%ebp),%eax
  80037c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	01 c8                	add    %ecx,%eax
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80038c:	8b 45 10             	mov    0x10(%ebp),%eax
  80038f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	01 c2                	add    %eax,%edx
  80039b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039e:	89 02                	mov    %eax,(%edx)
}
  8003a0:	90                   	nop
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b0:	eb 17                	jmp    8003c9 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8003b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	01 c2                	add    %eax,%edx
  8003c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c e1                	jl     8003b2 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e1:	eb 1b                	jmp    8003fe <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 c2                	add    %eax,%edx
  8003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f5:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003f8:	48                   	dec    %eax
  8003f9:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003fb:	ff 45 fc             	incl   -0x4(%ebp)
  8003fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800401:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800404:	7c dd                	jl     8003e3 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800406:	90                   	nop
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80040f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800412:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800417:	f7 e9                	imul   %ecx
  800419:	c1 f9 1f             	sar    $0x1f,%ecx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	29 c8                	sub    %ecx,%eax
  800420:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800423:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80042a:	eb 1e                	jmp    80044a <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80042c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80042f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80043c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043f:	99                   	cltd   
  800440:	f7 7d f8             	idivl  -0x8(%ebp)
  800443:	89 d0                	mov    %edx,%eax
  800445:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800447:	ff 45 fc             	incl   -0x4(%ebp)
  80044a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80044d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800450:	7c da                	jl     80042c <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800452:	90                   	nop
  800453:	c9                   	leave  
  800454:	c3                   	ret    

00800455 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800455:	55                   	push   %ebp
  800456:	89 e5                	mov    %esp,%ebp
  800458:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80045b:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800469:	eb 42                	jmp    8004ad <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80046b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80046e:	99                   	cltd   
  80046f:	f7 7d f0             	idivl  -0x10(%ebp)
  800472:	89 d0                	mov    %edx,%eax
  800474:	85 c0                	test   %eax,%eax
  800476:	75 10                	jne    800488 <PrintElements+0x33>
			cprintf("\n");
  800478:	83 ec 0c             	sub    $0xc,%esp
  80047b:	68 a0 38 80 00       	push   $0x8038a0
  800480:	e8 3b 07 00 00       	call   800bc0 <cprintf>
  800485:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	01 d0                	add    %edx,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	50                   	push   %eax
  80049d:	68 78 3a 80 00       	push   $0x803a78
  8004a2:	e8 19 07 00 00       	call   800bc0 <cprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004aa:	ff 45 f4             	incl   -0xc(%ebp)
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	48                   	dec    %eax
  8004b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004b4:	7f b5                	jg     80046b <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8004b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	01 d0                	add    %edx,%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	50                   	push   %eax
  8004cb:	68 ef 38 80 00       	push   $0x8038ef
  8004d0:	e8 eb 06 00 00       	call   800bc0 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp

}
  8004d8:	90                   	nop
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    

008004db <MSort>:


void MSort(int* A, int p, int r)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004e7:	7d 54                	jge    80053d <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	89 c2                	mov    %eax,%edx
  8004f3:	c1 ea 1f             	shr    $0x1f,%edx
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	d1 f8                	sar    %eax
  8004fa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	ff 75 f4             	pushl  -0xc(%ebp)
  800503:	ff 75 0c             	pushl  0xc(%ebp)
  800506:	ff 75 08             	pushl  0x8(%ebp)
  800509:	e8 cd ff ff ff       	call   8004db <MSort>
  80050e:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  800511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800514:	40                   	inc    %eax
  800515:	83 ec 04             	sub    $0x4,%esp
  800518:	ff 75 10             	pushl  0x10(%ebp)
  80051b:	50                   	push   %eax
  80051c:	ff 75 08             	pushl  0x8(%ebp)
  80051f:	e8 b7 ff ff ff       	call   8004db <MSort>
  800524:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800527:	ff 75 10             	pushl  0x10(%ebp)
  80052a:	ff 75 f4             	pushl  -0xc(%ebp)
  80052d:	ff 75 0c             	pushl  0xc(%ebp)
  800530:	ff 75 08             	pushl  0x8(%ebp)
  800533:	e8 08 00 00 00       	call   800540 <Merge>
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	eb 01                	jmp    80053e <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80053d:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800546:	8b 45 10             	mov    0x10(%ebp),%eax
  800549:	2b 45 0c             	sub    0xc(%ebp),%eax
  80054c:	40                   	inc    %eax
  80054d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	2b 45 10             	sub    0x10(%ebp),%eax
  800556:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800559:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800560:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056a:	c1 e0 02             	shl    $0x2,%eax
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	50                   	push   %eax
  800571:	e8 c3 15 00 00       	call   801b39 <malloc>
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80057c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80057f:	c1 e0 02             	shl    $0x2,%eax
  800582:	83 ec 0c             	sub    $0xc,%esp
  800585:	50                   	push   %eax
  800586:	e8 ae 15 00 00       	call   801b39 <malloc>
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800598:	eb 2f                	jmp    8005c9 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  80059a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005a7:	01 c2                	add    %eax,%edx
  8005a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005af:	01 c8                	add    %ecx,%eax
  8005b1:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	01 c8                	add    %ecx,%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005c6:	ff 45 ec             	incl   -0x14(%ebp)
  8005c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005cf:	7c c9                	jl     80059a <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005d8:	eb 2a                	jmp    800604 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005e7:	01 c2                	add    %eax,%edx
  8005e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ef:	01 c8                	add    %ecx,%eax
  8005f1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fb:	01 c8                	add    %ecx,%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800601:	ff 45 e8             	incl   -0x18(%ebp)
  800604:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800607:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80060a:	7c ce                	jl     8005da <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80060c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800612:	e9 0a 01 00 00       	jmp    800721 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  800617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80061a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80061d:	0f 8d 95 00 00 00    	jge    8006b8 <Merge+0x178>
  800623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800626:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800629:	0f 8d 89 00 00 00    	jge    8006b8 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80062f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800632:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800639:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063c:	01 d0                	add    %edx,%eax
  80063e:	8b 10                	mov    (%eax),%edx
  800640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800643:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80064a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80064d:	01 c8                	add    %ecx,%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	39 c2                	cmp    %eax,%edx
  800653:	7d 33                	jge    800688 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800658:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80066a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066d:	8d 50 01             	lea    0x1(%eax),%edx
  800670:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800673:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80067d:	01 d0                	add    %edx,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800683:	e9 96 00 00 00       	jmp    80071e <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068b:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800690:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80069d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a0:	8d 50 01             	lea    0x1(%eax),%edx
  8006a3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006b0:	01 d0                	add    %edx,%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8006b6:	eb 66                	jmp    80071e <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8006b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006bb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006be:	7d 30                	jge    8006f0 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8006c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d8:	8d 50 01             	lea    0x1(%eax),%edx
  8006db:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	89 01                	mov    %eax,(%ecx)
  8006ee:	eb 2e                	jmp    80071e <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8d 50 01             	lea    0x1(%eax),%edx
  80070b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80070e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800715:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800718:	01 d0                	add    %edx,%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80071e:	ff 45 e4             	incl   -0x1c(%ebp)
  800721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800724:	3b 45 14             	cmp    0x14(%ebp),%eax
  800727:	0f 8e ea fe ff ff    	jle    800617 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  80072d:	90                   	nop
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80073c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 50 19 00 00       	call   802099 <sys_cputc>
  800749:	83 c4 10             	add    $0x10,%esp
}
  80074c:	90                   	nop
  80074d:	c9                   	leave  
  80074e:	c3                   	ret    

0080074f <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800755:	e8 0b 19 00 00       	call   802065 <sys_disable_interrupt>
	char c = ch;
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800760:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800764:	83 ec 0c             	sub    $0xc,%esp
  800767:	50                   	push   %eax
  800768:	e8 2c 19 00 00       	call   802099 <sys_cputc>
  80076d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800770:	e8 0a 19 00 00       	call   80207f <sys_enable_interrupt>
}
  800775:	90                   	nop
  800776:	c9                   	leave  
  800777:	c3                   	ret    

00800778 <getchar>:

int
getchar(void)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80077e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800785:	eb 08                	jmp    80078f <getchar+0x17>
	{
		c = sys_cgetc();
  800787:	e8 54 17 00 00       	call   801ee0 <sys_cgetc>
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80078f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800793:	74 f2                	je     800787 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800795:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <atomic_getchar>:

int
atomic_getchar(void)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a0:	e8 c0 18 00 00       	call   802065 <sys_disable_interrupt>
	int c=0;
  8007a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007ac:	eb 08                	jmp    8007b6 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007ae:	e8 2d 17 00 00       	call   801ee0 <sys_cgetc>
  8007b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007ba:	74 f2                	je     8007ae <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007bc:	e8 be 18 00 00       	call   80207f <sys_enable_interrupt>
	return c;
  8007c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <iscons>:

int iscons(int fdnum)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007ce:	5d                   	pop    %ebp
  8007cf:	c3                   	ret    

008007d0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007d6:	e8 7d 1a 00 00       	call   802258 <sys_getenvindex>
  8007db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e1:	89 d0                	mov    %edx,%eax
  8007e3:	c1 e0 03             	shl    $0x3,%eax
  8007e6:	01 d0                	add    %edx,%eax
  8007e8:	01 c0                	add    %eax,%eax
  8007ea:	01 d0                	add    %edx,%eax
  8007ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007f3:	01 d0                	add    %edx,%eax
  8007f5:	c1 e0 04             	shl    $0x4,%eax
  8007f8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007fd:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800802:	a1 24 50 80 00       	mov    0x805024,%eax
  800807:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80080d:	84 c0                	test   %al,%al
  80080f:	74 0f                	je     800820 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800811:	a1 24 50 80 00       	mov    0x805024,%eax
  800816:	05 5c 05 00 00       	add    $0x55c,%eax
  80081b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800820:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800824:	7e 0a                	jle    800830 <libmain+0x60>
		binaryname = argv[0];
  800826:	8b 45 0c             	mov    0xc(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 08             	pushl  0x8(%ebp)
  800839:	e8 fa f7 ff ff       	call   800038 <_main>
  80083e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800841:	e8 1f 18 00 00       	call   802065 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800846:	83 ec 0c             	sub    $0xc,%esp
  800849:	68 98 3a 80 00       	push   $0x803a98
  80084e:	e8 6d 03 00 00       	call   800bc0 <cprintf>
  800853:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800856:	a1 24 50 80 00       	mov    0x805024,%eax
  80085b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800861:	a1 24 50 80 00       	mov    0x805024,%eax
  800866:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	52                   	push   %edx
  800870:	50                   	push   %eax
  800871:	68 c0 3a 80 00       	push   $0x803ac0
  800876:	e8 45 03 00 00       	call   800bc0 <cprintf>
  80087b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80087e:	a1 24 50 80 00       	mov    0x805024,%eax
  800883:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800889:	a1 24 50 80 00       	mov    0x805024,%eax
  80088e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800894:	a1 24 50 80 00       	mov    0x805024,%eax
  800899:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80089f:	51                   	push   %ecx
  8008a0:	52                   	push   %edx
  8008a1:	50                   	push   %eax
  8008a2:	68 e8 3a 80 00       	push   $0x803ae8
  8008a7:	e8 14 03 00 00       	call   800bc0 <cprintf>
  8008ac:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008af:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 40 3b 80 00       	push   $0x803b40
  8008c3:	e8 f8 02 00 00       	call   800bc0 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008cb:	83 ec 0c             	sub    $0xc,%esp
  8008ce:	68 98 3a 80 00       	push   $0x803a98
  8008d3:	e8 e8 02 00 00       	call   800bc0 <cprintf>
  8008d8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008db:	e8 9f 17 00 00       	call   80207f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008e0:	e8 19 00 00 00       	call   8008fe <exit>
}
  8008e5:	90                   	nop
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    

008008e8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008ee:	83 ec 0c             	sub    $0xc,%esp
  8008f1:	6a 00                	push   $0x0
  8008f3:	e8 2c 19 00 00       	call   802224 <sys_destroy_env>
  8008f8:	83 c4 10             	add    $0x10,%esp
}
  8008fb:	90                   	nop
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <exit>:

void
exit(void)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800904:	e8 81 19 00 00       	call   80228a <sys_exit_env>
}
  800909:	90                   	nop
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800912:	8d 45 10             	lea    0x10(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80091b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800920:	85 c0                	test   %eax,%eax
  800922:	74 16                	je     80093a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800924:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	50                   	push   %eax
  80092d:	68 54 3b 80 00       	push   $0x803b54
  800932:	e8 89 02 00 00       	call   800bc0 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80093a:	a1 00 50 80 00       	mov    0x805000,%eax
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	ff 75 08             	pushl  0x8(%ebp)
  800945:	50                   	push   %eax
  800946:	68 59 3b 80 00       	push   $0x803b59
  80094b:	e8 70 02 00 00       	call   800bc0 <cprintf>
  800950:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800953:	8b 45 10             	mov    0x10(%ebp),%eax
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 f4             	pushl  -0xc(%ebp)
  80095c:	50                   	push   %eax
  80095d:	e8 f3 01 00 00       	call   800b55 <vcprintf>
  800962:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	6a 00                	push   $0x0
  80096a:	68 75 3b 80 00       	push   $0x803b75
  80096f:	e8 e1 01 00 00       	call   800b55 <vcprintf>
  800974:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800977:	e8 82 ff ff ff       	call   8008fe <exit>

	// should not return here
	while (1) ;
  80097c:	eb fe                	jmp    80097c <_panic+0x70>

0080097e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800984:	a1 24 50 80 00       	mov    0x805024,%eax
  800989:	8b 50 74             	mov    0x74(%eax),%edx
  80098c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098f:	39 c2                	cmp    %eax,%edx
  800991:	74 14                	je     8009a7 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800993:	83 ec 04             	sub    $0x4,%esp
  800996:	68 78 3b 80 00       	push   $0x803b78
  80099b:	6a 26                	push   $0x26
  80099d:	68 c4 3b 80 00       	push   $0x803bc4
  8009a2:	e8 65 ff ff ff       	call   80090c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b5:	e9 c2 00 00 00       	jmp    800a7c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	75 08                	jne    8009d7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009cf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009d2:	e9 a2 00 00 00       	jmp    800a79 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009e5:	eb 69                	jmp    800a50 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009e7:	a1 24 50 80 00       	mov    0x805024,%eax
  8009ec:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f5:	89 d0                	mov    %edx,%eax
  8009f7:	01 c0                	add    %eax,%eax
  8009f9:	01 d0                	add    %edx,%eax
  8009fb:	c1 e0 03             	shl    $0x3,%eax
  8009fe:	01 c8                	add    %ecx,%eax
  800a00:	8a 40 04             	mov    0x4(%eax),%al
  800a03:	84 c0                	test   %al,%al
  800a05:	75 46                	jne    800a4d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a07:	a1 24 50 80 00       	mov    0x805024,%eax
  800a0c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a12:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a15:	89 d0                	mov    %edx,%eax
  800a17:	01 c0                	add    %eax,%eax
  800a19:	01 d0                	add    %edx,%eax
  800a1b:	c1 e0 03             	shl    $0x3,%eax
  800a1e:	01 c8                	add    %ecx,%eax
  800a20:	8b 00                	mov    (%eax),%eax
  800a22:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a2d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a32:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	01 c8                	add    %ecx,%eax
  800a3e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a40:	39 c2                	cmp    %eax,%edx
  800a42:	75 09                	jne    800a4d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a44:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a4b:	eb 12                	jmp    800a5f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4d:	ff 45 e8             	incl   -0x18(%ebp)
  800a50:	a1 24 50 80 00       	mov    0x805024,%eax
  800a55:	8b 50 74             	mov    0x74(%eax),%edx
  800a58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a5b:	39 c2                	cmp    %eax,%edx
  800a5d:	77 88                	ja     8009e7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a63:	75 14                	jne    800a79 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a65:	83 ec 04             	sub    $0x4,%esp
  800a68:	68 d0 3b 80 00       	push   $0x803bd0
  800a6d:	6a 3a                	push   $0x3a
  800a6f:	68 c4 3b 80 00       	push   $0x803bc4
  800a74:	e8 93 fe ff ff       	call   80090c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a79:	ff 45 f0             	incl   -0x10(%ebp)
  800a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a82:	0f 8c 32 ff ff ff    	jl     8009ba <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a96:	eb 26                	jmp    800abe <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a98:	a1 24 50 80 00       	mov    0x805024,%eax
  800a9d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800aa3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aa6:	89 d0                	mov    %edx,%eax
  800aa8:	01 c0                	add    %eax,%eax
  800aaa:	01 d0                	add    %edx,%eax
  800aac:	c1 e0 03             	shl    $0x3,%eax
  800aaf:	01 c8                	add    %ecx,%eax
  800ab1:	8a 40 04             	mov    0x4(%eax),%al
  800ab4:	3c 01                	cmp    $0x1,%al
  800ab6:	75 03                	jne    800abb <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ab8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800abb:	ff 45 e0             	incl   -0x20(%ebp)
  800abe:	a1 24 50 80 00       	mov    0x805024,%eax
  800ac3:	8b 50 74             	mov    0x74(%eax),%edx
  800ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac9:	39 c2                	cmp    %eax,%edx
  800acb:	77 cb                	ja     800a98 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ad3:	74 14                	je     800ae9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ad5:	83 ec 04             	sub    $0x4,%esp
  800ad8:	68 24 3c 80 00       	push   $0x803c24
  800add:	6a 44                	push   $0x44
  800adf:	68 c4 3b 80 00       	push   $0x803bc4
  800ae4:	e8 23 fe ff ff       	call   80090c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ae9:	90                   	nop
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	8d 48 01             	lea    0x1(%eax),%ecx
  800afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afd:	89 0a                	mov    %ecx,(%edx)
  800aff:	8b 55 08             	mov    0x8(%ebp),%edx
  800b02:	88 d1                	mov    %dl,%cl
  800b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b07:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	8b 00                	mov    (%eax),%eax
  800b10:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b15:	75 2c                	jne    800b43 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b17:	a0 28 50 80 00       	mov    0x805028,%al
  800b1c:	0f b6 c0             	movzbl %al,%eax
  800b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b22:	8b 12                	mov    (%edx),%edx
  800b24:	89 d1                	mov    %edx,%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	83 c2 08             	add    $0x8,%edx
  800b2c:	83 ec 04             	sub    $0x4,%esp
  800b2f:	50                   	push   %eax
  800b30:	51                   	push   %ecx
  800b31:	52                   	push   %edx
  800b32:	e8 80 13 00 00       	call   801eb7 <sys_cputs>
  800b37:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8b 40 04             	mov    0x4(%eax),%eax
  800b49:	8d 50 01             	lea    0x1(%eax),%edx
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b52:	90                   	nop
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b5e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b65:	00 00 00 
	b.cnt = 0;
  800b68:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b6f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b7e:	50                   	push   %eax
  800b7f:	68 ec 0a 80 00       	push   $0x800aec
  800b84:	e8 11 02 00 00       	call   800d9a <vprintfmt>
  800b89:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b8c:	a0 28 50 80 00       	mov    0x805028,%al
  800b91:	0f b6 c0             	movzbl %al,%eax
  800b94:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b9a:	83 ec 04             	sub    $0x4,%esp
  800b9d:	50                   	push   %eax
  800b9e:	52                   	push   %edx
  800b9f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ba5:	83 c0 08             	add    $0x8,%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 09 13 00 00       	call   801eb7 <sys_cputs>
  800bae:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bb1:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800bb8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bc6:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bcd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	e8 73 ff ff ff       	call   800b55 <vcprintf>
  800be2:	83 c4 10             	add    $0x10,%esp
  800be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    

00800bed <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bf3:	e8 6d 14 00 00       	call   802065 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bf8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	ff 75 f4             	pushl  -0xc(%ebp)
  800c07:	50                   	push   %eax
  800c08:	e8 48 ff ff ff       	call   800b55 <vcprintf>
  800c0d:	83 c4 10             	add    $0x10,%esp
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c13:	e8 67 14 00 00       	call   80207f <sys_enable_interrupt>
	return cnt;
  800c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	53                   	push   %ebx
  800c21:	83 ec 14             	sub    $0x14,%esp
  800c24:	8b 45 10             	mov    0x10(%ebp),%eax
  800c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c30:	8b 45 18             	mov    0x18(%ebp),%eax
  800c33:	ba 00 00 00 00       	mov    $0x0,%edx
  800c38:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c3b:	77 55                	ja     800c92 <printnum+0x75>
  800c3d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c40:	72 05                	jb     800c47 <printnum+0x2a>
  800c42:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c45:	77 4b                	ja     800c92 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c47:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c4a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c4d:	8b 45 18             	mov    0x18(%ebp),%eax
  800c50:	ba 00 00 00 00       	mov    $0x0,%edx
  800c55:	52                   	push   %edx
  800c56:	50                   	push   %eax
  800c57:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5a:	ff 75 f0             	pushl  -0x10(%ebp)
  800c5d:	e8 ce 29 00 00       	call   803630 <__udivdi3>
  800c62:	83 c4 10             	add    $0x10,%esp
  800c65:	83 ec 04             	sub    $0x4,%esp
  800c68:	ff 75 20             	pushl  0x20(%ebp)
  800c6b:	53                   	push   %ebx
  800c6c:	ff 75 18             	pushl  0x18(%ebp)
  800c6f:	52                   	push   %edx
  800c70:	50                   	push   %eax
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	ff 75 08             	pushl  0x8(%ebp)
  800c77:	e8 a1 ff ff ff       	call   800c1d <printnum>
  800c7c:	83 c4 20             	add    $0x20,%esp
  800c7f:	eb 1a                	jmp    800c9b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c81:	83 ec 08             	sub    $0x8,%esp
  800c84:	ff 75 0c             	pushl  0xc(%ebp)
  800c87:	ff 75 20             	pushl  0x20(%ebp)
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	ff d0                	call   *%eax
  800c8f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c92:	ff 4d 1c             	decl   0x1c(%ebp)
  800c95:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c99:	7f e6                	jg     800c81 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c9b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca9:	53                   	push   %ebx
  800caa:	51                   	push   %ecx
  800cab:	52                   	push   %edx
  800cac:	50                   	push   %eax
  800cad:	e8 8e 2a 00 00       	call   803740 <__umoddi3>
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	05 94 3e 80 00       	add    $0x803e94,%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	0f be c0             	movsbl %al,%eax
  800cbf:	83 ec 08             	sub    $0x8,%esp
  800cc2:	ff 75 0c             	pushl  0xc(%ebp)
  800cc5:	50                   	push   %eax
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	ff d0                	call   *%eax
  800ccb:	83 c4 10             	add    $0x10,%esp
}
  800cce:	90                   	nop
  800ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cd7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cdb:	7e 1c                	jle    800cf9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	8d 50 08             	lea    0x8(%eax),%edx
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	89 10                	mov    %edx,(%eax)
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	83 e8 08             	sub    $0x8,%eax
  800cf2:	8b 50 04             	mov    0x4(%eax),%edx
  800cf5:	8b 00                	mov    (%eax),%eax
  800cf7:	eb 40                	jmp    800d39 <getuint+0x65>
	else if (lflag)
  800cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfd:	74 1e                	je     800d1d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	8d 50 04             	lea    0x4(%eax),%edx
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	89 10                	mov    %edx,(%eax)
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8b 00                	mov    (%eax),%eax
  800d11:	83 e8 04             	sub    $0x4,%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1b:	eb 1c                	jmp    800d39 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8b 00                	mov    (%eax),%eax
  800d22:	8d 50 04             	lea    0x4(%eax),%edx
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	89 10                	mov    %edx,(%eax)
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8b 00                	mov    (%eax),%eax
  800d2f:	83 e8 04             	sub    $0x4,%eax
  800d32:	8b 00                	mov    (%eax),%eax
  800d34:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d3e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d42:	7e 1c                	jle    800d60 <getint+0x25>
		return va_arg(*ap, long long);
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 00                	mov    (%eax),%eax
  800d49:	8d 50 08             	lea    0x8(%eax),%edx
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 10                	mov    %edx,(%eax)
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	83 e8 08             	sub    $0x8,%eax
  800d59:	8b 50 04             	mov    0x4(%eax),%edx
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	eb 38                	jmp    800d98 <getint+0x5d>
	else if (lflag)
  800d60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d64:	74 1a                	je     800d80 <getint+0x45>
		return va_arg(*ap, long);
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8b 00                	mov    (%eax),%eax
  800d6b:	8d 50 04             	lea    0x4(%eax),%edx
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	89 10                	mov    %edx,(%eax)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	83 e8 04             	sub    $0x4,%eax
  800d7b:	8b 00                	mov    (%eax),%eax
  800d7d:	99                   	cltd   
  800d7e:	eb 18                	jmp    800d98 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	8d 50 04             	lea    0x4(%eax),%edx
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 10                	mov    %edx,(%eax)
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8b 00                	mov    (%eax),%eax
  800d92:	83 e8 04             	sub    $0x4,%eax
  800d95:	8b 00                	mov    (%eax),%eax
  800d97:	99                   	cltd   
}
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
  800d9f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da2:	eb 17                	jmp    800dbb <vprintfmt+0x21>
			if (ch == '\0')
  800da4:	85 db                	test   %ebx,%ebx
  800da6:	0f 84 af 03 00 00    	je     80115b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800dac:	83 ec 08             	sub    $0x8,%esp
  800daf:	ff 75 0c             	pushl  0xc(%ebp)
  800db2:	53                   	push   %ebx
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	ff d0                	call   *%eax
  800db8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbe:	8d 50 01             	lea    0x1(%eax),%edx
  800dc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	0f b6 d8             	movzbl %al,%ebx
  800dc9:	83 fb 25             	cmp    $0x25,%ebx
  800dcc:	75 d6                	jne    800da4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dce:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dd2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dd9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800de0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800de7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 10             	mov    %edx,0x10(%ebp)
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d8             	movzbl %al,%ebx
  800dfc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dff:	83 f8 55             	cmp    $0x55,%eax
  800e02:	0f 87 2b 03 00 00    	ja     801133 <vprintfmt+0x399>
  800e08:	8b 04 85 b8 3e 80 00 	mov    0x803eb8(,%eax,4),%eax
  800e0f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e11:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e15:	eb d7                	jmp    800dee <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e17:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e1b:	eb d1                	jmp    800dee <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e1d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e27:	89 d0                	mov    %edx,%eax
  800e29:	c1 e0 02             	shl    $0x2,%eax
  800e2c:	01 d0                	add    %edx,%eax
  800e2e:	01 c0                	add    %eax,%eax
  800e30:	01 d8                	add    %ebx,%eax
  800e32:	83 e8 30             	sub    $0x30,%eax
  800e35:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e38:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e40:	83 fb 2f             	cmp    $0x2f,%ebx
  800e43:	7e 3e                	jle    800e83 <vprintfmt+0xe9>
  800e45:	83 fb 39             	cmp    $0x39,%ebx
  800e48:	7f 39                	jg     800e83 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e4a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e4d:	eb d5                	jmp    800e24 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e52:	83 c0 04             	add    $0x4,%eax
  800e55:	89 45 14             	mov    %eax,0x14(%ebp)
  800e58:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5b:	83 e8 04             	sub    $0x4,%eax
  800e5e:	8b 00                	mov    (%eax),%eax
  800e60:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e63:	eb 1f                	jmp    800e84 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e69:	79 83                	jns    800dee <vprintfmt+0x54>
				width = 0;
  800e6b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e72:	e9 77 ff ff ff       	jmp    800dee <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e77:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e7e:	e9 6b ff ff ff       	jmp    800dee <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e83:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e88:	0f 89 60 ff ff ff    	jns    800dee <vprintfmt+0x54>
				width = precision, precision = -1;
  800e8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e94:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e9b:	e9 4e ff ff ff       	jmp    800dee <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ea0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ea3:	e9 46 ff ff ff       	jmp    800dee <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ea8:	8b 45 14             	mov    0x14(%ebp),%eax
  800eab:	83 c0 04             	add    $0x4,%eax
  800eae:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb4:	83 e8 04             	sub    $0x4,%eax
  800eb7:	8b 00                	mov    (%eax),%eax
  800eb9:	83 ec 08             	sub    $0x8,%esp
  800ebc:	ff 75 0c             	pushl  0xc(%ebp)
  800ebf:	50                   	push   %eax
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	ff d0                	call   *%eax
  800ec5:	83 c4 10             	add    $0x10,%esp
			break;
  800ec8:	e9 89 02 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ecd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed0:	83 c0 04             	add    $0x4,%eax
  800ed3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed9:	83 e8 04             	sub    $0x4,%eax
  800edc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ede:	85 db                	test   %ebx,%ebx
  800ee0:	79 02                	jns    800ee4 <vprintfmt+0x14a>
				err = -err;
  800ee2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ee4:	83 fb 64             	cmp    $0x64,%ebx
  800ee7:	7f 0b                	jg     800ef4 <vprintfmt+0x15a>
  800ee9:	8b 34 9d 00 3d 80 00 	mov    0x803d00(,%ebx,4),%esi
  800ef0:	85 f6                	test   %esi,%esi
  800ef2:	75 19                	jne    800f0d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ef4:	53                   	push   %ebx
  800ef5:	68 a5 3e 80 00       	push   $0x803ea5
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	ff 75 08             	pushl  0x8(%ebp)
  800f00:	e8 5e 02 00 00       	call   801163 <printfmt>
  800f05:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f08:	e9 49 02 00 00       	jmp    801156 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f0d:	56                   	push   %esi
  800f0e:	68 ae 3e 80 00       	push   $0x803eae
  800f13:	ff 75 0c             	pushl  0xc(%ebp)
  800f16:	ff 75 08             	pushl  0x8(%ebp)
  800f19:	e8 45 02 00 00       	call   801163 <printfmt>
  800f1e:	83 c4 10             	add    $0x10,%esp
			break;
  800f21:	e9 30 02 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f26:	8b 45 14             	mov    0x14(%ebp),%eax
  800f29:	83 c0 04             	add    $0x4,%eax
  800f2c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f32:	83 e8 04             	sub    $0x4,%eax
  800f35:	8b 30                	mov    (%eax),%esi
  800f37:	85 f6                	test   %esi,%esi
  800f39:	75 05                	jne    800f40 <vprintfmt+0x1a6>
				p = "(null)";
  800f3b:	be b1 3e 80 00       	mov    $0x803eb1,%esi
			if (width > 0 && padc != '-')
  800f40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f44:	7e 6d                	jle    800fb3 <vprintfmt+0x219>
  800f46:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f4a:	74 67                	je     800fb3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	50                   	push   %eax
  800f53:	56                   	push   %esi
  800f54:	e8 0c 03 00 00       	call   801265 <strnlen>
  800f59:	83 c4 10             	add    $0x10,%esp
  800f5c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f5f:	eb 16                	jmp    800f77 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f61:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	ff 75 0c             	pushl  0xc(%ebp)
  800f6b:	50                   	push   %eax
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	ff d0                	call   *%eax
  800f71:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f74:	ff 4d e4             	decl   -0x1c(%ebp)
  800f77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7b:	7f e4                	jg     800f61 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7d:	eb 34                	jmp    800fb3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f83:	74 1c                	je     800fa1 <vprintfmt+0x207>
  800f85:	83 fb 1f             	cmp    $0x1f,%ebx
  800f88:	7e 05                	jle    800f8f <vprintfmt+0x1f5>
  800f8a:	83 fb 7e             	cmp    $0x7e,%ebx
  800f8d:	7e 12                	jle    800fa1 <vprintfmt+0x207>
					putch('?', putdat);
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	ff 75 0c             	pushl  0xc(%ebp)
  800f95:	6a 3f                	push   $0x3f
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	ff d0                	call   *%eax
  800f9c:	83 c4 10             	add    $0x10,%esp
  800f9f:	eb 0f                	jmp    800fb0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fa1:	83 ec 08             	sub    $0x8,%esp
  800fa4:	ff 75 0c             	pushl  0xc(%ebp)
  800fa7:	53                   	push   %ebx
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	ff d0                	call   *%eax
  800fad:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fb0:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb3:	89 f0                	mov    %esi,%eax
  800fb5:	8d 70 01             	lea    0x1(%eax),%esi
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	0f be d8             	movsbl %al,%ebx
  800fbd:	85 db                	test   %ebx,%ebx
  800fbf:	74 24                	je     800fe5 <vprintfmt+0x24b>
  800fc1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc5:	78 b8                	js     800f7f <vprintfmt+0x1e5>
  800fc7:	ff 4d e0             	decl   -0x20(%ebp)
  800fca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fce:	79 af                	jns    800f7f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd0:	eb 13                	jmp    800fe5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	6a 20                	push   $0x20
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	ff d0                	call   *%eax
  800fdf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fe2:	ff 4d e4             	decl   -0x1c(%ebp)
  800fe5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe9:	7f e7                	jg     800fd2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800feb:	e9 66 01 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ff6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff9:	50                   	push   %eax
  800ffa:	e8 3c fd ff ff       	call   800d3b <getint>
  800fff:	83 c4 10             	add    $0x10,%esp
  801002:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801005:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100e:	85 d2                	test   %edx,%edx
  801010:	79 23                	jns    801035 <vprintfmt+0x29b>
				putch('-', putdat);
  801012:	83 ec 08             	sub    $0x8,%esp
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	6a 2d                	push   $0x2d
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	ff d0                	call   *%eax
  80101f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801028:	f7 d8                	neg    %eax
  80102a:	83 d2 00             	adc    $0x0,%edx
  80102d:	f7 da                	neg    %edx
  80102f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801032:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801035:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80103c:	e9 bc 00 00 00       	jmp    8010fd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801041:	83 ec 08             	sub    $0x8,%esp
  801044:	ff 75 e8             	pushl  -0x18(%ebp)
  801047:	8d 45 14             	lea    0x14(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	e8 84 fc ff ff       	call   800cd4 <getuint>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801056:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801059:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801060:	e9 98 00 00 00       	jmp    8010fd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	6a 58                	push   $0x58
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	ff d0                	call   *%eax
  801072:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	6a 58                	push   $0x58
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801085:	83 ec 08             	sub    $0x8,%esp
  801088:	ff 75 0c             	pushl  0xc(%ebp)
  80108b:	6a 58                	push   $0x58
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	ff d0                	call   *%eax
  801092:	83 c4 10             	add    $0x10,%esp
			break;
  801095:	e9 bc 00 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	6a 30                	push   $0x30
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	ff d0                	call   *%eax
  8010a7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	6a 78                	push   $0x78
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bd:	83 c0 04             	add    $0x4,%eax
  8010c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8010c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c6:	83 e8 04             	sub    $0x4,%eax
  8010c9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010d5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010dc:	eb 1f                	jmp    8010fd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010de:	83 ec 08             	sub    $0x8,%esp
  8010e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8010e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e7:	50                   	push   %eax
  8010e8:	e8 e7 fb ff ff       	call   800cd4 <getuint>
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010f6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010fd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801104:	83 ec 04             	sub    $0x4,%esp
  801107:	52                   	push   %edx
  801108:	ff 75 e4             	pushl  -0x1c(%ebp)
  80110b:	50                   	push   %eax
  80110c:	ff 75 f4             	pushl  -0xc(%ebp)
  80110f:	ff 75 f0             	pushl  -0x10(%ebp)
  801112:	ff 75 0c             	pushl  0xc(%ebp)
  801115:	ff 75 08             	pushl  0x8(%ebp)
  801118:	e8 00 fb ff ff       	call   800c1d <printnum>
  80111d:	83 c4 20             	add    $0x20,%esp
			break;
  801120:	eb 34                	jmp    801156 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	53                   	push   %ebx
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	ff d0                	call   *%eax
  80112e:	83 c4 10             	add    $0x10,%esp
			break;
  801131:	eb 23                	jmp    801156 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801133:	83 ec 08             	sub    $0x8,%esp
  801136:	ff 75 0c             	pushl  0xc(%ebp)
  801139:	6a 25                	push   $0x25
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	ff d0                	call   *%eax
  801140:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801143:	ff 4d 10             	decl   0x10(%ebp)
  801146:	eb 03                	jmp    80114b <vprintfmt+0x3b1>
  801148:	ff 4d 10             	decl   0x10(%ebp)
  80114b:	8b 45 10             	mov    0x10(%ebp),%eax
  80114e:	48                   	dec    %eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 25                	cmp    $0x25,%al
  801153:	75 f3                	jne    801148 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801155:	90                   	nop
		}
	}
  801156:	e9 47 fc ff ff       	jmp    800da2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80115b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80115c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80115f:	5b                   	pop    %ebx
  801160:	5e                   	pop    %esi
  801161:	5d                   	pop    %ebp
  801162:	c3                   	ret    

00801163 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801169:	8d 45 10             	lea    0x10(%ebp),%eax
  80116c:	83 c0 04             	add    $0x4,%eax
  80116f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801172:	8b 45 10             	mov    0x10(%ebp),%eax
  801175:	ff 75 f4             	pushl  -0xc(%ebp)
  801178:	50                   	push   %eax
  801179:	ff 75 0c             	pushl  0xc(%ebp)
  80117c:	ff 75 08             	pushl  0x8(%ebp)
  80117f:	e8 16 fc ff ff       	call   800d9a <vprintfmt>
  801184:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	8b 40 08             	mov    0x8(%eax),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80119c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119f:	8b 10                	mov    (%eax),%edx
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	8b 40 04             	mov    0x4(%eax),%eax
  8011a7:	39 c2                	cmp    %eax,%edx
  8011a9:	73 12                	jae    8011bd <sprintputch+0x33>
		*b->buf++ = ch;
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	8b 00                	mov    (%eax),%eax
  8011b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8011b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b6:	89 0a                	mov    %ecx,(%edx)
  8011b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bb:	88 10                	mov    %dl,(%eax)
}
  8011bd:	90                   	nop
  8011be:	5d                   	pop    %ebp
  8011bf:	c3                   	ret    

008011c0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e5:	74 06                	je     8011ed <vsnprintf+0x2d>
  8011e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011eb:	7f 07                	jg     8011f4 <vsnprintf+0x34>
		return -E_INVAL;
  8011ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8011f2:	eb 20                	jmp    801214 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011f4:	ff 75 14             	pushl  0x14(%ebp)
  8011f7:	ff 75 10             	pushl  0x10(%ebp)
  8011fa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011fd:	50                   	push   %eax
  8011fe:	68 8a 11 80 00       	push   $0x80118a
  801203:	e8 92 fb ff ff       	call   800d9a <vprintfmt>
  801208:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80120b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80120e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801211:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80121c:	8d 45 10             	lea    0x10(%ebp),%eax
  80121f:	83 c0 04             	add    $0x4,%eax
  801222:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801225:	8b 45 10             	mov    0x10(%ebp),%eax
  801228:	ff 75 f4             	pushl  -0xc(%ebp)
  80122b:	50                   	push   %eax
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	ff 75 08             	pushl  0x8(%ebp)
  801232:	e8 89 ff ff ff       	call   8011c0 <vsnprintf>
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80123d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80124f:	eb 06                	jmp    801257 <strlen+0x15>
		n++;
  801251:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801254:	ff 45 08             	incl   0x8(%ebp)
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	84 c0                	test   %al,%al
  80125e:	75 f1                	jne    801251 <strlen+0xf>
		n++;
	return n;
  801260:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801272:	eb 09                	jmp    80127d <strnlen+0x18>
		n++;
  801274:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801277:	ff 45 08             	incl   0x8(%ebp)
  80127a:	ff 4d 0c             	decl   0xc(%ebp)
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	74 09                	je     80128c <strnlen+0x27>
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	75 e8                	jne    801274 <strnlen+0xf>
		n++;
	return n;
  80128c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80129d:	90                   	nop
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8d 50 01             	lea    0x1(%eax),%edx
  8012a4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012b0:	8a 12                	mov    (%edx),%dl
  8012b2:	88 10                	mov    %dl,(%eax)
  8012b4:	8a 00                	mov    (%eax),%al
  8012b6:	84 c0                	test   %al,%al
  8012b8:	75 e4                	jne    80129e <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d2:	eb 1f                	jmp    8012f3 <strncpy+0x34>
		*dst++ = *src;
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8d 50 01             	lea    0x1(%eax),%edx
  8012da:	89 55 08             	mov    %edx,0x8(%ebp)
  8012dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e0:	8a 12                	mov    (%edx),%dl
  8012e2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	84 c0                	test   %al,%al
  8012eb:	74 03                	je     8012f0 <strncpy+0x31>
			src++;
  8012ed:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012f0:	ff 45 fc             	incl   -0x4(%ebp)
  8012f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012f9:	72 d9                	jb     8012d4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80130c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801310:	74 30                	je     801342 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801312:	eb 16                	jmp    80132a <strlcpy+0x2a>
			*dst++ = *src++;
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8d 50 01             	lea    0x1(%eax),%edx
  80131a:	89 55 08             	mov    %edx,0x8(%ebp)
  80131d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801320:	8d 4a 01             	lea    0x1(%edx),%ecx
  801323:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801326:	8a 12                	mov    (%edx),%dl
  801328:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80132a:	ff 4d 10             	decl   0x10(%ebp)
  80132d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801331:	74 09                	je     80133c <strlcpy+0x3c>
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	84 c0                	test   %al,%al
  80133a:	75 d8                	jne    801314 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801342:	8b 55 08             	mov    0x8(%ebp),%edx
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801348:	29 c2                	sub    %eax,%edx
  80134a:	89 d0                	mov    %edx,%eax
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801351:	eb 06                	jmp    801359 <strcmp+0xb>
		p++, q++;
  801353:	ff 45 08             	incl   0x8(%ebp)
  801356:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	74 0e                	je     801370 <strcmp+0x22>
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 10                	mov    (%eax),%dl
  801367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	38 c2                	cmp    %al,%dl
  80136e:	74 e3                	je     801353 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f b6 d0             	movzbl %al,%edx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	0f b6 c0             	movzbl %al,%eax
  801380:	29 c2                	sub    %eax,%edx
  801382:	89 d0                	mov    %edx,%eax
}
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    

00801386 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801389:	eb 09                	jmp    801394 <strncmp+0xe>
		n--, p++, q++;
  80138b:	ff 4d 10             	decl   0x10(%ebp)
  80138e:	ff 45 08             	incl   0x8(%ebp)
  801391:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801394:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801398:	74 17                	je     8013b1 <strncmp+0x2b>
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8a 00                	mov    (%eax),%al
  80139f:	84 c0                	test   %al,%al
  8013a1:	74 0e                	je     8013b1 <strncmp+0x2b>
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	8a 10                	mov    (%eax),%dl
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	38 c2                	cmp    %al,%dl
  8013af:	74 da                	je     80138b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b5:	75 07                	jne    8013be <strncmp+0x38>
		return 0;
  8013b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bc:	eb 14                	jmp    8013d2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	0f b6 d0             	movzbl %al,%edx
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	0f b6 c0             	movzbl %al,%eax
  8013ce:	29 c2                	sub    %eax,%edx
  8013d0:	89 d0                	mov    %edx,%eax
}
  8013d2:	5d                   	pop    %ebp
  8013d3:	c3                   	ret    

008013d4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013e0:	eb 12                	jmp    8013f4 <strchr+0x20>
		if (*s == c)
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013ea:	75 05                	jne    8013f1 <strchr+0x1d>
			return (char *) s;
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	eb 11                	jmp    801402 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013f1:	ff 45 08             	incl   0x8(%ebp)
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	84 c0                	test   %al,%al
  8013fb:	75 e5                	jne    8013e2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 04             	sub    $0x4,%esp
  80140a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801410:	eb 0d                	jmp    80141f <strfind+0x1b>
		if (*s == c)
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80141a:	74 0e                	je     80142a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80141c:	ff 45 08             	incl   0x8(%ebp)
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	84 c0                	test   %al,%al
  801426:	75 ea                	jne    801412 <strfind+0xe>
  801428:	eb 01                	jmp    80142b <strfind+0x27>
		if (*s == c)
			break;
  80142a:	90                   	nop
	return (char *) s;
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80143c:	8b 45 10             	mov    0x10(%ebp),%eax
  80143f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801442:	eb 0e                	jmp    801452 <memset+0x22>
		*p++ = c;
  801444:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801447:	8d 50 01             	lea    0x1(%eax),%edx
  80144a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80144d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801450:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801452:	ff 4d f8             	decl   -0x8(%ebp)
  801455:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801459:	79 e9                	jns    801444 <memset+0x14>
		*p++ = c;

	return v;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801466:	8b 45 0c             	mov    0xc(%ebp),%eax
  801469:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801472:	eb 16                	jmp    80148a <memcpy+0x2a>
		*d++ = *s++;
  801474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801477:	8d 50 01             	lea    0x1(%eax),%edx
  80147a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80147d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801480:	8d 4a 01             	lea    0x1(%edx),%ecx
  801483:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801486:	8a 12                	mov    (%edx),%dl
  801488:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801490:	89 55 10             	mov    %edx,0x10(%ebp)
  801493:	85 c0                	test   %eax,%eax
  801495:	75 dd                	jne    801474 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014b4:	73 50                	jae    801506 <memmove+0x6a>
  8014b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014c1:	76 43                	jbe    801506 <memmove+0x6a>
		s += n;
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014cf:	eb 10                	jmp    8014e1 <memmove+0x45>
			*--d = *--s;
  8014d1:	ff 4d f8             	decl   -0x8(%ebp)
  8014d4:	ff 4d fc             	decl   -0x4(%ebp)
  8014d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014da:	8a 10                	mov    (%eax),%dl
  8014dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014df:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	75 e3                	jne    8014d1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014ee:	eb 23                	jmp    801513 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f3:	8d 50 01             	lea    0x1(%eax),%edx
  8014f6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ff:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801502:	8a 12                	mov    (%edx),%dl
  801504:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801506:	8b 45 10             	mov    0x10(%ebp),%eax
  801509:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150c:	89 55 10             	mov    %edx,0x10(%ebp)
  80150f:	85 c0                	test   %eax,%eax
  801511:	75 dd                	jne    8014f0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80152a:	eb 2a                	jmp    801556 <memcmp+0x3e>
		if (*s1 != *s2)
  80152c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152f:	8a 10                	mov    (%eax),%dl
  801531:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	38 c2                	cmp    %al,%dl
  801538:	74 16                	je     801550 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80153a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	0f b6 d0             	movzbl %al,%edx
  801542:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	0f b6 c0             	movzbl %al,%eax
  80154a:	29 c2                	sub    %eax,%edx
  80154c:	89 d0                	mov    %edx,%eax
  80154e:	eb 18                	jmp    801568 <memcmp+0x50>
		s1++, s2++;
  801550:	ff 45 fc             	incl   -0x4(%ebp)
  801553:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801556:	8b 45 10             	mov    0x10(%ebp),%eax
  801559:	8d 50 ff             	lea    -0x1(%eax),%edx
  80155c:	89 55 10             	mov    %edx,0x10(%ebp)
  80155f:	85 c0                	test   %eax,%eax
  801561:	75 c9                	jne    80152c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801570:	8b 55 08             	mov    0x8(%ebp),%edx
  801573:	8b 45 10             	mov    0x10(%ebp),%eax
  801576:	01 d0                	add    %edx,%eax
  801578:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80157b:	eb 15                	jmp    801592 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	8a 00                	mov    (%eax),%al
  801582:	0f b6 d0             	movzbl %al,%edx
  801585:	8b 45 0c             	mov    0xc(%ebp),%eax
  801588:	0f b6 c0             	movzbl %al,%eax
  80158b:	39 c2                	cmp    %eax,%edx
  80158d:	74 0d                	je     80159c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80158f:	ff 45 08             	incl   0x8(%ebp)
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801598:	72 e3                	jb     80157d <memfind+0x13>
  80159a:	eb 01                	jmp    80159d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80159c:	90                   	nop
	return (void *) s;
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b6:	eb 03                	jmp    8015bb <strtol+0x19>
		s++;
  8015b8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	3c 20                	cmp    $0x20,%al
  8015c2:	74 f4                	je     8015b8 <strtol+0x16>
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	8a 00                	mov    (%eax),%al
  8015c9:	3c 09                	cmp    $0x9,%al
  8015cb:	74 eb                	je     8015b8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	3c 2b                	cmp    $0x2b,%al
  8015d4:	75 05                	jne    8015db <strtol+0x39>
		s++;
  8015d6:	ff 45 08             	incl   0x8(%ebp)
  8015d9:	eb 13                	jmp    8015ee <strtol+0x4c>
	else if (*s == '-')
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 2d                	cmp    $0x2d,%al
  8015e2:	75 0a                	jne    8015ee <strtol+0x4c>
		s++, neg = 1;
  8015e4:	ff 45 08             	incl   0x8(%ebp)
  8015e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015f2:	74 06                	je     8015fa <strtol+0x58>
  8015f4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015f8:	75 20                	jne    80161a <strtol+0x78>
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	8a 00                	mov    (%eax),%al
  8015ff:	3c 30                	cmp    $0x30,%al
  801601:	75 17                	jne    80161a <strtol+0x78>
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	40                   	inc    %eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	3c 78                	cmp    $0x78,%al
  80160b:	75 0d                	jne    80161a <strtol+0x78>
		s += 2, base = 16;
  80160d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801611:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801618:	eb 28                	jmp    801642 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80161a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80161e:	75 15                	jne    801635 <strtol+0x93>
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	8a 00                	mov    (%eax),%al
  801625:	3c 30                	cmp    $0x30,%al
  801627:	75 0c                	jne    801635 <strtol+0x93>
		s++, base = 8;
  801629:	ff 45 08             	incl   0x8(%ebp)
  80162c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801633:	eb 0d                	jmp    801642 <strtol+0xa0>
	else if (base == 0)
  801635:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801639:	75 07                	jne    801642 <strtol+0xa0>
		base = 10;
  80163b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8a 00                	mov    (%eax),%al
  801647:	3c 2f                	cmp    $0x2f,%al
  801649:	7e 19                	jle    801664 <strtol+0xc2>
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 39                	cmp    $0x39,%al
  801652:	7f 10                	jg     801664 <strtol+0xc2>
			dig = *s - '0';
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	0f be c0             	movsbl %al,%eax
  80165c:	83 e8 30             	sub    $0x30,%eax
  80165f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801662:	eb 42                	jmp    8016a6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	8a 00                	mov    (%eax),%al
  801669:	3c 60                	cmp    $0x60,%al
  80166b:	7e 19                	jle    801686 <strtol+0xe4>
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 7a                	cmp    $0x7a,%al
  801674:	7f 10                	jg     801686 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	0f be c0             	movsbl %al,%eax
  80167e:	83 e8 57             	sub    $0x57,%eax
  801681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801684:	eb 20                	jmp    8016a6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	8a 00                	mov    (%eax),%al
  80168b:	3c 40                	cmp    $0x40,%al
  80168d:	7e 39                	jle    8016c8 <strtol+0x126>
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 5a                	cmp    $0x5a,%al
  801696:	7f 30                	jg     8016c8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f be c0             	movsbl %al,%eax
  8016a0:	83 e8 37             	sub    $0x37,%eax
  8016a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016ac:	7d 19                	jge    8016c7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016ae:	ff 45 08             	incl   0x8(%ebp)
  8016b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016b8:	89 c2                	mov    %eax,%edx
  8016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bd:	01 d0                	add    %edx,%eax
  8016bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016c2:	e9 7b ff ff ff       	jmp    801642 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016c7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016cc:	74 08                	je     8016d6 <strtol+0x134>
		*endptr = (char *) s;
  8016ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016da:	74 07                	je     8016e3 <strtol+0x141>
  8016dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016df:	f7 d8                	neg    %eax
  8016e1:	eb 03                	jmp    8016e6 <strtol+0x144>
  8016e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <ltostr>:

void
ltostr(long value, char *str)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801700:	79 13                	jns    801715 <ltostr+0x2d>
	{
		neg = 1;
  801702:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80170f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801712:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80171d:	99                   	cltd   
  80171e:	f7 f9                	idiv   %ecx
  801720:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801723:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801726:	8d 50 01             	lea    0x1(%eax),%edx
  801729:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80172c:	89 c2                	mov    %eax,%edx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	01 d0                	add    %edx,%eax
  801733:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801736:	83 c2 30             	add    $0x30,%edx
  801739:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80173b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801743:	f7 e9                	imul   %ecx
  801745:	c1 fa 02             	sar    $0x2,%edx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	c1 f8 1f             	sar    $0x1f,%eax
  80174d:	29 c2                	sub    %eax,%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801754:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801757:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80175c:	f7 e9                	imul   %ecx
  80175e:	c1 fa 02             	sar    $0x2,%edx
  801761:	89 c8                	mov    %ecx,%eax
  801763:	c1 f8 1f             	sar    $0x1f,%eax
  801766:	29 c2                	sub    %eax,%edx
  801768:	89 d0                	mov    %edx,%eax
  80176a:	c1 e0 02             	shl    $0x2,%eax
  80176d:	01 d0                	add    %edx,%eax
  80176f:	01 c0                	add    %eax,%eax
  801771:	29 c1                	sub    %eax,%ecx
  801773:	89 ca                	mov    %ecx,%edx
  801775:	85 d2                	test   %edx,%edx
  801777:	75 9c                	jne    801715 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801779:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801780:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801783:	48                   	dec    %eax
  801784:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801787:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80178b:	74 3d                	je     8017ca <ltostr+0xe2>
		start = 1 ;
  80178d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801794:	eb 34                	jmp    8017ca <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801799:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179c:	01 d0                	add    %edx,%eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a9:	01 c2                	add    %eax,%edx
  8017ab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b1:	01 c8                	add    %ecx,%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bd:	01 c2                	add    %eax,%edx
  8017bf:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017c2:	88 02                	mov    %al,(%edx)
		start++ ;
  8017c4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017c7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017d0:	7c c4                	jl     801796 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017dd:	90                   	nop
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017e6:	ff 75 08             	pushl  0x8(%ebp)
  8017e9:	e8 54 fa ff ff       	call   801242 <strlen>
  8017ee:	83 c4 04             	add    $0x4,%esp
  8017f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017f4:	ff 75 0c             	pushl  0xc(%ebp)
  8017f7:	e8 46 fa ff ff       	call   801242 <strlen>
  8017fc:	83 c4 04             	add    $0x4,%esp
  8017ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801802:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801809:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801810:	eb 17                	jmp    801829 <strcconcat+0x49>
		final[s] = str1[s] ;
  801812:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801815:	8b 45 10             	mov    0x10(%ebp),%eax
  801818:	01 c2                	add    %eax,%edx
  80181a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	01 c8                	add    %ecx,%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801826:	ff 45 fc             	incl   -0x4(%ebp)
  801829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80182f:	7c e1                	jl     801812 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801831:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801838:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80183f:	eb 1f                	jmp    801860 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801841:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801844:	8d 50 01             	lea    0x1(%eax),%edx
  801847:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80184a:	89 c2                	mov    %eax,%edx
  80184c:	8b 45 10             	mov    0x10(%ebp),%eax
  80184f:	01 c2                	add    %eax,%edx
  801851:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801854:	8b 45 0c             	mov    0xc(%ebp),%eax
  801857:	01 c8                	add    %ecx,%eax
  801859:	8a 00                	mov    (%eax),%al
  80185b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80185d:	ff 45 f8             	incl   -0x8(%ebp)
  801860:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801863:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801866:	7c d9                	jl     801841 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801868:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80186b:	8b 45 10             	mov    0x10(%ebp),%eax
  80186e:	01 d0                	add    %edx,%eax
  801870:	c6 00 00             	movb   $0x0,(%eax)
}
  801873:	90                   	nop
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801879:	8b 45 14             	mov    0x14(%ebp),%eax
  80187c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801882:	8b 45 14             	mov    0x14(%ebp),%eax
  801885:	8b 00                	mov    (%eax),%eax
  801887:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	01 d0                	add    %edx,%eax
  801893:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801899:	eb 0c                	jmp    8018a7 <strsplit+0x31>
			*string++ = 0;
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	8d 50 01             	lea    0x1(%eax),%edx
  8018a1:	89 55 08             	mov    %edx,0x8(%ebp)
  8018a4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	8a 00                	mov    (%eax),%al
  8018ac:	84 c0                	test   %al,%al
  8018ae:	74 18                	je     8018c8 <strsplit+0x52>
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	8a 00                	mov    (%eax),%al
  8018b5:	0f be c0             	movsbl %al,%eax
  8018b8:	50                   	push   %eax
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	e8 13 fb ff ff       	call   8013d4 <strchr>
  8018c1:	83 c4 08             	add    $0x8,%esp
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	75 d3                	jne    80189b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	8a 00                	mov    (%eax),%al
  8018cd:	84 c0                	test   %al,%al
  8018cf:	74 5a                	je     80192b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d4:	8b 00                	mov    (%eax),%eax
  8018d6:	83 f8 0f             	cmp    $0xf,%eax
  8018d9:	75 07                	jne    8018e2 <strsplit+0x6c>
		{
			return 0;
  8018db:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e0:	eb 66                	jmp    801948 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e5:	8b 00                	mov    (%eax),%eax
  8018e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8018ea:	8b 55 14             	mov    0x14(%ebp),%edx
  8018ed:	89 0a                	mov    %ecx,(%edx)
  8018ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	01 c2                	add    %eax,%edx
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801900:	eb 03                	jmp    801905 <strsplit+0x8f>
			string++;
  801902:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	84 c0                	test   %al,%al
  80190c:	74 8b                	je     801899 <strsplit+0x23>
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	8a 00                	mov    (%eax),%al
  801913:	0f be c0             	movsbl %al,%eax
  801916:	50                   	push   %eax
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	e8 b5 fa ff ff       	call   8013d4 <strchr>
  80191f:	83 c4 08             	add    $0x8,%esp
  801922:	85 c0                	test   %eax,%eax
  801924:	74 dc                	je     801902 <strsplit+0x8c>
			string++;
	}
  801926:	e9 6e ff ff ff       	jmp    801899 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80192b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80192c:	8b 45 14             	mov    0x14(%ebp),%eax
  80192f:	8b 00                	mov    (%eax),%eax
  801931:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801938:	8b 45 10             	mov    0x10(%ebp),%eax
  80193b:	01 d0                	add    %edx,%eax
  80193d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801943:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801950:	a1 04 50 80 00       	mov    0x805004,%eax
  801955:	85 c0                	test   %eax,%eax
  801957:	74 1f                	je     801978 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801959:	e8 1d 00 00 00       	call   80197b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80195e:	83 ec 0c             	sub    $0xc,%esp
  801961:	68 10 40 80 00       	push   $0x804010
  801966:	e8 55 f2 ff ff       	call   800bc0 <cprintf>
  80196b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80196e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801975:	00 00 00 
	}
}
  801978:	90                   	nop
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801981:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801988:	00 00 00 
  80198b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801992:	00 00 00 
  801995:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80199c:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  80199f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8019a6:	00 00 00 
  8019a9:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8019b0:	00 00 00 
  8019b3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8019ba:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  8019bd:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8019c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019cc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019d1:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8019d6:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019dd:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8019e0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ea:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8019ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fa:	f7 75 f0             	divl   -0x10(%ebp)
  8019fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a00:	29 d0                	sub    %edx,%eax
  801a02:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801a05:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801a0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a14:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a19:	83 ec 04             	sub    $0x4,%esp
  801a1c:	6a 06                	push   $0x6
  801a1e:	ff 75 e8             	pushl  -0x18(%ebp)
  801a21:	50                   	push   %eax
  801a22:	e8 d4 05 00 00       	call   801ffb <sys_allocate_chunk>
  801a27:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a2a:	a1 20 51 80 00       	mov    0x805120,%eax
  801a2f:	83 ec 0c             	sub    $0xc,%esp
  801a32:	50                   	push   %eax
  801a33:	e8 49 0c 00 00       	call   802681 <initialize_MemBlocksList>
  801a38:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801a3b:	a1 48 51 80 00       	mov    0x805148,%eax
  801a40:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801a43:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a47:	75 14                	jne    801a5d <initialize_dyn_block_system+0xe2>
  801a49:	83 ec 04             	sub    $0x4,%esp
  801a4c:	68 35 40 80 00       	push   $0x804035
  801a51:	6a 39                	push   $0x39
  801a53:	68 53 40 80 00       	push   $0x804053
  801a58:	e8 af ee ff ff       	call   80090c <_panic>
  801a5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a60:	8b 00                	mov    (%eax),%eax
  801a62:	85 c0                	test   %eax,%eax
  801a64:	74 10                	je     801a76 <initialize_dyn_block_system+0xfb>
  801a66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a69:	8b 00                	mov    (%eax),%eax
  801a6b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a6e:	8b 52 04             	mov    0x4(%edx),%edx
  801a71:	89 50 04             	mov    %edx,0x4(%eax)
  801a74:	eb 0b                	jmp    801a81 <initialize_dyn_block_system+0x106>
  801a76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a79:	8b 40 04             	mov    0x4(%eax),%eax
  801a7c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801a81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a84:	8b 40 04             	mov    0x4(%eax),%eax
  801a87:	85 c0                	test   %eax,%eax
  801a89:	74 0f                	je     801a9a <initialize_dyn_block_system+0x11f>
  801a8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a8e:	8b 40 04             	mov    0x4(%eax),%eax
  801a91:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a94:	8b 12                	mov    (%edx),%edx
  801a96:	89 10                	mov    %edx,(%eax)
  801a98:	eb 0a                	jmp    801aa4 <initialize_dyn_block_system+0x129>
  801a9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a9d:	8b 00                	mov    (%eax),%eax
  801a9f:	a3 48 51 80 00       	mov    %eax,0x805148
  801aa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aa7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ab0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ab7:	a1 54 51 80 00       	mov    0x805154,%eax
  801abc:	48                   	dec    %eax
  801abd:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801ac2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ac5:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801acf:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801ad6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ada:	75 14                	jne    801af0 <initialize_dyn_block_system+0x175>
  801adc:	83 ec 04             	sub    $0x4,%esp
  801adf:	68 60 40 80 00       	push   $0x804060
  801ae4:	6a 3f                	push   $0x3f
  801ae6:	68 53 40 80 00       	push   $0x804053
  801aeb:	e8 1c ee ff ff       	call   80090c <_panic>
  801af0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801af6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801af9:	89 10                	mov    %edx,(%eax)
  801afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801afe:	8b 00                	mov    (%eax),%eax
  801b00:	85 c0                	test   %eax,%eax
  801b02:	74 0d                	je     801b11 <initialize_dyn_block_system+0x196>
  801b04:	a1 38 51 80 00       	mov    0x805138,%eax
  801b09:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b0c:	89 50 04             	mov    %edx,0x4(%eax)
  801b0f:	eb 08                	jmp    801b19 <initialize_dyn_block_system+0x19e>
  801b11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b14:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801b19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b1c:	a3 38 51 80 00       	mov    %eax,0x805138
  801b21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b2b:	a1 44 51 80 00       	mov    0x805144,%eax
  801b30:	40                   	inc    %eax
  801b31:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801b36:	90                   	nop
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b3f:	e8 06 fe ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801b44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b48:	75 07                	jne    801b51 <malloc+0x18>
  801b4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4f:	eb 7d                	jmp    801bce <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801b51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801b58:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b5f:	8b 55 08             	mov    0x8(%ebp),%edx
  801b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b65:	01 d0                	add    %edx,%eax
  801b67:	48                   	dec    %eax
  801b68:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b73:	f7 75 f0             	divl   -0x10(%ebp)
  801b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b79:	29 d0                	sub    %edx,%eax
  801b7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801b7e:	e8 46 08 00 00       	call   8023c9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b83:	83 f8 01             	cmp    $0x1,%eax
  801b86:	75 07                	jne    801b8f <malloc+0x56>
  801b88:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801b8f:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801b93:	75 34                	jne    801bc9 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801b95:	83 ec 0c             	sub    $0xc,%esp
  801b98:	ff 75 e8             	pushl  -0x18(%ebp)
  801b9b:	e8 73 0e 00 00       	call   802a13 <alloc_block_FF>
  801ba0:	83 c4 10             	add    $0x10,%esp
  801ba3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801ba6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801baa:	74 16                	je     801bc2 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801bac:	83 ec 0c             	sub    $0xc,%esp
  801baf:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bb2:	e8 ff 0b 00 00       	call   8027b6 <insert_sorted_allocList>
  801bb7:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801bba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bbd:	8b 40 08             	mov    0x8(%eax),%eax
  801bc0:	eb 0c                	jmp    801bce <malloc+0x95>
	             }
	             else
	             	return NULL;
  801bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc7:	eb 05                	jmp    801bce <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801bc9:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bea:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801bed:	83 ec 08             	sub    $0x8,%esp
  801bf0:	ff 75 f4             	pushl  -0xc(%ebp)
  801bf3:	68 40 50 80 00       	push   $0x805040
  801bf8:	e8 61 0b 00 00       	call   80275e <find_block>
  801bfd:	83 c4 10             	add    $0x10,%esp
  801c00:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801c03:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c07:	0f 84 a5 00 00 00    	je     801cb2 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801c0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c10:	8b 40 0c             	mov    0xc(%eax),%eax
  801c13:	83 ec 08             	sub    $0x8,%esp
  801c16:	50                   	push   %eax
  801c17:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1a:	e8 a4 03 00 00       	call   801fc3 <sys_free_user_mem>
  801c1f:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801c22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c26:	75 17                	jne    801c3f <free+0x6f>
  801c28:	83 ec 04             	sub    $0x4,%esp
  801c2b:	68 35 40 80 00       	push   $0x804035
  801c30:	68 87 00 00 00       	push   $0x87
  801c35:	68 53 40 80 00       	push   $0x804053
  801c3a:	e8 cd ec ff ff       	call   80090c <_panic>
  801c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c42:	8b 00                	mov    (%eax),%eax
  801c44:	85 c0                	test   %eax,%eax
  801c46:	74 10                	je     801c58 <free+0x88>
  801c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c4b:	8b 00                	mov    (%eax),%eax
  801c4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c50:	8b 52 04             	mov    0x4(%edx),%edx
  801c53:	89 50 04             	mov    %edx,0x4(%eax)
  801c56:	eb 0b                	jmp    801c63 <free+0x93>
  801c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c5b:	8b 40 04             	mov    0x4(%eax),%eax
  801c5e:	a3 44 50 80 00       	mov    %eax,0x805044
  801c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c66:	8b 40 04             	mov    0x4(%eax),%eax
  801c69:	85 c0                	test   %eax,%eax
  801c6b:	74 0f                	je     801c7c <free+0xac>
  801c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c70:	8b 40 04             	mov    0x4(%eax),%eax
  801c73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c76:	8b 12                	mov    (%edx),%edx
  801c78:	89 10                	mov    %edx,(%eax)
  801c7a:	eb 0a                	jmp    801c86 <free+0xb6>
  801c7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c7f:	8b 00                	mov    (%eax),%eax
  801c81:	a3 40 50 80 00       	mov    %eax,0x805040
  801c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c99:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c9e:	48                   	dec    %eax
  801c9f:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801ca4:	83 ec 0c             	sub    $0xc,%esp
  801ca7:	ff 75 ec             	pushl  -0x14(%ebp)
  801caa:	e8 37 12 00 00       	call   802ee6 <insert_sorted_with_merge_freeList>
  801caf:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801cb2:	90                   	nop
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	83 ec 38             	sub    $0x38,%esp
  801cbb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbe:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cc1:	e8 84 fc ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801cc6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cca:	75 07                	jne    801cd3 <smalloc+0x1e>
  801ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd1:	eb 7e                	jmp    801d51 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801cd3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801cda:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ce1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce7:	01 d0                	add    %edx,%eax
  801ce9:	48                   	dec    %eax
  801cea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ced:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf0:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf5:	f7 75 f0             	divl   -0x10(%ebp)
  801cf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cfb:	29 d0                	sub    %edx,%eax
  801cfd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801d00:	e8 c4 06 00 00       	call   8023c9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d05:	83 f8 01             	cmp    $0x1,%eax
  801d08:	75 42                	jne    801d4c <smalloc+0x97>

		  va = malloc(newsize) ;
  801d0a:	83 ec 0c             	sub    $0xc,%esp
  801d0d:	ff 75 e8             	pushl  -0x18(%ebp)
  801d10:	e8 24 fe ff ff       	call   801b39 <malloc>
  801d15:	83 c4 10             	add    $0x10,%esp
  801d18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801d1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d1f:	74 24                	je     801d45 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801d21:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d25:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d28:	50                   	push   %eax
  801d29:	ff 75 e8             	pushl  -0x18(%ebp)
  801d2c:	ff 75 08             	pushl  0x8(%ebp)
  801d2f:	e8 1a 04 00 00       	call   80214e <sys_createSharedObject>
  801d34:	83 c4 10             	add    $0x10,%esp
  801d37:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801d3a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d3e:	78 0c                	js     801d4c <smalloc+0x97>
					  return va ;
  801d40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d43:	eb 0c                	jmp    801d51 <smalloc+0x9c>
				 }
				 else
					return NULL;
  801d45:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4a:	eb 05                	jmp    801d51 <smalloc+0x9c>
	  }
		  return NULL ;
  801d4c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d59:	e8 ec fb ff ff       	call   80194a <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801d5e:	83 ec 08             	sub    $0x8,%esp
  801d61:	ff 75 0c             	pushl  0xc(%ebp)
  801d64:	ff 75 08             	pushl  0x8(%ebp)
  801d67:	e8 0c 04 00 00       	call   802178 <sys_getSizeOfSharedObject>
  801d6c:	83 c4 10             	add    $0x10,%esp
  801d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801d72:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801d76:	75 07                	jne    801d7f <sget+0x2c>
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7d:	eb 75                	jmp    801df4 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801d7f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8c:	01 d0                	add    %edx,%eax
  801d8e:	48                   	dec    %eax
  801d8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d95:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9a:	f7 75 f0             	divl   -0x10(%ebp)
  801d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da0:	29 d0                	sub    %edx,%eax
  801da2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801da5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801dac:	e8 18 06 00 00       	call   8023c9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801db1:	83 f8 01             	cmp    $0x1,%eax
  801db4:	75 39                	jne    801def <sget+0x9c>

		  va = malloc(newsize) ;
  801db6:	83 ec 0c             	sub    $0xc,%esp
  801db9:	ff 75 e8             	pushl  -0x18(%ebp)
  801dbc:	e8 78 fd ff ff       	call   801b39 <malloc>
  801dc1:	83 c4 10             	add    $0x10,%esp
  801dc4:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801dc7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dcb:	74 22                	je     801def <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801dcd:	83 ec 04             	sub    $0x4,%esp
  801dd0:	ff 75 e0             	pushl  -0x20(%ebp)
  801dd3:	ff 75 0c             	pushl  0xc(%ebp)
  801dd6:	ff 75 08             	pushl  0x8(%ebp)
  801dd9:	e8 b7 03 00 00       	call   802195 <sys_getSharedObject>
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801de4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801de8:	78 05                	js     801def <sget+0x9c>
					  return va;
  801dea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ded:	eb 05                	jmp    801df4 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801def:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dfc:	e8 49 fb ff ff       	call   80194a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e01:	83 ec 04             	sub    $0x4,%esp
  801e04:	68 84 40 80 00       	push   $0x804084
  801e09:	68 1e 01 00 00       	push   $0x11e
  801e0e:	68 53 40 80 00       	push   $0x804053
  801e13:	e8 f4 ea ff ff       	call   80090c <_panic>

00801e18 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e1e:	83 ec 04             	sub    $0x4,%esp
  801e21:	68 ac 40 80 00       	push   $0x8040ac
  801e26:	68 32 01 00 00       	push   $0x132
  801e2b:	68 53 40 80 00       	push   $0x804053
  801e30:	e8 d7 ea ff ff       	call   80090c <_panic>

00801e35 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e3b:	83 ec 04             	sub    $0x4,%esp
  801e3e:	68 d0 40 80 00       	push   $0x8040d0
  801e43:	68 3d 01 00 00       	push   $0x13d
  801e48:	68 53 40 80 00       	push   $0x804053
  801e4d:	e8 ba ea ff ff       	call   80090c <_panic>

00801e52 <shrink>:

}
void shrink(uint32 newSize)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e58:	83 ec 04             	sub    $0x4,%esp
  801e5b:	68 d0 40 80 00       	push   $0x8040d0
  801e60:	68 42 01 00 00       	push   $0x142
  801e65:	68 53 40 80 00       	push   $0x804053
  801e6a:	e8 9d ea ff ff       	call   80090c <_panic>

00801e6f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e75:	83 ec 04             	sub    $0x4,%esp
  801e78:	68 d0 40 80 00       	push   $0x8040d0
  801e7d:	68 47 01 00 00       	push   $0x147
  801e82:	68 53 40 80 00       	push   $0x804053
  801e87:	e8 80 ea ff ff       	call   80090c <_panic>

00801e8c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	57                   	push   %edi
  801e90:	56                   	push   %esi
  801e91:	53                   	push   %ebx
  801e92:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e9e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ea1:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ea4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ea7:	cd 30                	int    $0x30
  801ea9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801eaf:	83 c4 10             	add    $0x10,%esp
  801eb2:	5b                   	pop    %ebx
  801eb3:	5e                   	pop    %esi
  801eb4:	5f                   	pop    %edi
  801eb5:	5d                   	pop    %ebp
  801eb6:	c3                   	ret    

00801eb7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	83 ec 04             	sub    $0x4,%esp
  801ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ec3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	52                   	push   %edx
  801ecf:	ff 75 0c             	pushl  0xc(%ebp)
  801ed2:	50                   	push   %eax
  801ed3:	6a 00                	push   $0x0
  801ed5:	e8 b2 ff ff ff       	call   801e8c <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
}
  801edd:	90                   	nop
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 01                	push   $0x1
  801eef:	e8 98 ff ff ff       	call   801e8c <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801efc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	52                   	push   %edx
  801f09:	50                   	push   %eax
  801f0a:	6a 05                	push   $0x5
  801f0c:	e8 7b ff ff ff       	call   801e8c <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	56                   	push   %esi
  801f1a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f1b:	8b 75 18             	mov    0x18(%ebp),%esi
  801f1e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f21:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	56                   	push   %esi
  801f2b:	53                   	push   %ebx
  801f2c:	51                   	push   %ecx
  801f2d:	52                   	push   %edx
  801f2e:	50                   	push   %eax
  801f2f:	6a 06                	push   $0x6
  801f31:	e8 56 ff ff ff       	call   801e8c <syscall>
  801f36:	83 c4 18             	add    $0x18,%esp
}
  801f39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f3c:	5b                   	pop    %ebx
  801f3d:	5e                   	pop    %esi
  801f3e:	5d                   	pop    %ebp
  801f3f:	c3                   	ret    

00801f40 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	52                   	push   %edx
  801f50:	50                   	push   %eax
  801f51:	6a 07                	push   $0x7
  801f53:	e8 34 ff ff ff       	call   801e8c <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	ff 75 0c             	pushl  0xc(%ebp)
  801f69:	ff 75 08             	pushl  0x8(%ebp)
  801f6c:	6a 08                	push   $0x8
  801f6e:	e8 19 ff ff ff       	call   801e8c <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 09                	push   $0x9
  801f87:	e8 00 ff ff ff       	call   801e8c <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 0a                	push   $0xa
  801fa0:	e8 e7 fe ff ff       	call   801e8c <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 0b                	push   $0xb
  801fb9:	e8 ce fe ff ff       	call   801e8c <syscall>
  801fbe:	83 c4 18             	add    $0x18,%esp
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	ff 75 0c             	pushl  0xc(%ebp)
  801fcf:	ff 75 08             	pushl  0x8(%ebp)
  801fd2:	6a 0f                	push   $0xf
  801fd4:	e8 b3 fe ff ff       	call   801e8c <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
	return;
  801fdc:	90                   	nop
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	ff 75 0c             	pushl  0xc(%ebp)
  801feb:	ff 75 08             	pushl  0x8(%ebp)
  801fee:	6a 10                	push   $0x10
  801ff0:	e8 97 fe ff ff       	call   801e8c <syscall>
  801ff5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff8:	90                   	nop
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	ff 75 10             	pushl  0x10(%ebp)
  802005:	ff 75 0c             	pushl  0xc(%ebp)
  802008:	ff 75 08             	pushl  0x8(%ebp)
  80200b:	6a 11                	push   $0x11
  80200d:	e8 7a fe ff ff       	call   801e8c <syscall>
  802012:	83 c4 18             	add    $0x18,%esp
	return ;
  802015:	90                   	nop
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 0c                	push   $0xc
  802027:	e8 60 fe ff ff       	call   801e8c <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	ff 75 08             	pushl  0x8(%ebp)
  80203f:	6a 0d                	push   $0xd
  802041:	e8 46 fe ff ff       	call   801e8c <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
}
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 0e                	push   $0xe
  80205a:	e8 2d fe ff ff       	call   801e8c <syscall>
  80205f:	83 c4 18             	add    $0x18,%esp
}
  802062:	90                   	nop
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 13                	push   $0x13
  802074:	e8 13 fe ff ff       	call   801e8c <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
}
  80207c:	90                   	nop
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 14                	push   $0x14
  80208e:	e8 f9 fd ff ff       	call   801e8c <syscall>
  802093:	83 c4 18             	add    $0x18,%esp
}
  802096:	90                   	nop
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <sys_cputc>:


void
sys_cputc(const char c)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 04             	sub    $0x4,%esp
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020a5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	50                   	push   %eax
  8020b2:	6a 15                	push   $0x15
  8020b4:	e8 d3 fd ff ff       	call   801e8c <syscall>
  8020b9:	83 c4 18             	add    $0x18,%esp
}
  8020bc:	90                   	nop
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 16                	push   $0x16
  8020ce:	e8 b9 fd ff ff       	call   801e8c <syscall>
  8020d3:	83 c4 18             	add    $0x18,%esp
}
  8020d6:	90                   	nop
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	ff 75 0c             	pushl  0xc(%ebp)
  8020e8:	50                   	push   %eax
  8020e9:	6a 17                	push   $0x17
  8020eb:	e8 9c fd ff ff       	call   801e8c <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	52                   	push   %edx
  802105:	50                   	push   %eax
  802106:	6a 1a                	push   $0x1a
  802108:	e8 7f fd ff ff       	call   801e8c <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802115:	8b 55 0c             	mov    0xc(%ebp),%edx
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	52                   	push   %edx
  802122:	50                   	push   %eax
  802123:	6a 18                	push   $0x18
  802125:	e8 62 fd ff ff       	call   801e8c <syscall>
  80212a:	83 c4 18             	add    $0x18,%esp
}
  80212d:	90                   	nop
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802133:	8b 55 0c             	mov    0xc(%ebp),%edx
  802136:	8b 45 08             	mov    0x8(%ebp),%eax
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	52                   	push   %edx
  802140:	50                   	push   %eax
  802141:	6a 19                	push   $0x19
  802143:	e8 44 fd ff ff       	call   801e8c <syscall>
  802148:	83 c4 18             	add    $0x18,%esp
}
  80214b:	90                   	nop
  80214c:	c9                   	leave  
  80214d:	c3                   	ret    

0080214e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
  802151:	83 ec 04             	sub    $0x4,%esp
  802154:	8b 45 10             	mov    0x10(%ebp),%eax
  802157:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80215a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80215d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	6a 00                	push   $0x0
  802166:	51                   	push   %ecx
  802167:	52                   	push   %edx
  802168:	ff 75 0c             	pushl  0xc(%ebp)
  80216b:	50                   	push   %eax
  80216c:	6a 1b                	push   $0x1b
  80216e:	e8 19 fd ff ff       	call   801e8c <syscall>
  802173:	83 c4 18             	add    $0x18,%esp
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80217b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	52                   	push   %edx
  802188:	50                   	push   %eax
  802189:	6a 1c                	push   $0x1c
  80218b:	e8 fc fc ff ff       	call   801e8c <syscall>
  802190:	83 c4 18             	add    $0x18,%esp
}
  802193:	c9                   	leave  
  802194:	c3                   	ret    

00802195 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802198:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80219b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	51                   	push   %ecx
  8021a6:	52                   	push   %edx
  8021a7:	50                   	push   %eax
  8021a8:	6a 1d                	push   $0x1d
  8021aa:	e8 dd fc ff ff       	call   801e8c <syscall>
  8021af:	83 c4 18             	add    $0x18,%esp
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	52                   	push   %edx
  8021c4:	50                   	push   %eax
  8021c5:	6a 1e                	push   $0x1e
  8021c7:	e8 c0 fc ff ff       	call   801e8c <syscall>
  8021cc:	83 c4 18             	add    $0x18,%esp
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 1f                	push   $0x1f
  8021e0:	e8 a7 fc ff ff       	call   801e8c <syscall>
  8021e5:	83 c4 18             	add    $0x18,%esp
}
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	6a 00                	push   $0x0
  8021f2:	ff 75 14             	pushl  0x14(%ebp)
  8021f5:	ff 75 10             	pushl  0x10(%ebp)
  8021f8:	ff 75 0c             	pushl  0xc(%ebp)
  8021fb:	50                   	push   %eax
  8021fc:	6a 20                	push   $0x20
  8021fe:	e8 89 fc ff ff       	call   801e8c <syscall>
  802203:	83 c4 18             	add    $0x18,%esp
}
  802206:	c9                   	leave  
  802207:	c3                   	ret    

00802208 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	50                   	push   %eax
  802217:	6a 21                	push   $0x21
  802219:	e8 6e fc ff ff       	call   801e8c <syscall>
  80221e:	83 c4 18             	add    $0x18,%esp
}
  802221:	90                   	nop
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	50                   	push   %eax
  802233:	6a 22                	push   $0x22
  802235:	e8 52 fc ff ff       	call   801e8c <syscall>
  80223a:	83 c4 18             	add    $0x18,%esp
}
  80223d:	c9                   	leave  
  80223e:	c3                   	ret    

0080223f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 02                	push   $0x2
  80224e:	e8 39 fc ff ff       	call   801e8c <syscall>
  802253:	83 c4 18             	add    $0x18,%esp
}
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 03                	push   $0x3
  802267:	e8 20 fc ff ff       	call   801e8c <syscall>
  80226c:	83 c4 18             	add    $0x18,%esp
}
  80226f:	c9                   	leave  
  802270:	c3                   	ret    

00802271 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 04                	push   $0x4
  802280:	e8 07 fc ff ff       	call   801e8c <syscall>
  802285:	83 c4 18             	add    $0x18,%esp
}
  802288:	c9                   	leave  
  802289:	c3                   	ret    

0080228a <sys_exit_env>:


void sys_exit_env(void)
{
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 23                	push   $0x23
  802299:	e8 ee fb ff ff       	call   801e8c <syscall>
  80229e:	83 c4 18             	add    $0x18,%esp
}
  8022a1:	90                   	nop
  8022a2:	c9                   	leave  
  8022a3:	c3                   	ret    

008022a4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022aa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022ad:	8d 50 04             	lea    0x4(%eax),%edx
  8022b0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	52                   	push   %edx
  8022ba:	50                   	push   %eax
  8022bb:	6a 24                	push   $0x24
  8022bd:	e8 ca fb ff ff       	call   801e8c <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
	return result;
  8022c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022ce:	89 01                	mov    %eax,(%ecx)
  8022d0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	c9                   	leave  
  8022d7:	c2 04 00             	ret    $0x4

008022da <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	ff 75 10             	pushl  0x10(%ebp)
  8022e4:	ff 75 0c             	pushl  0xc(%ebp)
  8022e7:	ff 75 08             	pushl  0x8(%ebp)
  8022ea:	6a 12                	push   $0x12
  8022ec:	e8 9b fb ff ff       	call   801e8c <syscall>
  8022f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f4:	90                   	nop
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 25                	push   $0x25
  802306:	e8 81 fb ff ff       	call   801e8c <syscall>
  80230b:	83 c4 18             	add    $0x18,%esp
}
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	83 ec 04             	sub    $0x4,%esp
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80231c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	50                   	push   %eax
  802329:	6a 26                	push   $0x26
  80232b:	e8 5c fb ff ff       	call   801e8c <syscall>
  802330:	83 c4 18             	add    $0x18,%esp
	return ;
  802333:	90                   	nop
}
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <rsttst>:
void rsttst()
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 28                	push   $0x28
  802345:	e8 42 fb ff ff       	call   801e8c <syscall>
  80234a:	83 c4 18             	add    $0x18,%esp
	return ;
  80234d:	90                   	nop
}
  80234e:	c9                   	leave  
  80234f:	c3                   	ret    

00802350 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
  802353:	83 ec 04             	sub    $0x4,%esp
  802356:	8b 45 14             	mov    0x14(%ebp),%eax
  802359:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80235c:	8b 55 18             	mov    0x18(%ebp),%edx
  80235f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802363:	52                   	push   %edx
  802364:	50                   	push   %eax
  802365:	ff 75 10             	pushl  0x10(%ebp)
  802368:	ff 75 0c             	pushl  0xc(%ebp)
  80236b:	ff 75 08             	pushl  0x8(%ebp)
  80236e:	6a 27                	push   $0x27
  802370:	e8 17 fb ff ff       	call   801e8c <syscall>
  802375:	83 c4 18             	add    $0x18,%esp
	return ;
  802378:	90                   	nop
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <chktst>:
void chktst(uint32 n)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	ff 75 08             	pushl  0x8(%ebp)
  802389:	6a 29                	push   $0x29
  80238b:	e8 fc fa ff ff       	call   801e8c <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
	return ;
  802393:	90                   	nop
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <inctst>:

void inctst()
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 2a                	push   $0x2a
  8023a5:	e8 e2 fa ff ff       	call   801e8c <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ad:	90                   	nop
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <gettst>:
uint32 gettst()
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 2b                	push   $0x2b
  8023bf:	e8 c8 fa ff ff       	call   801e8c <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
}
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 2c                	push   $0x2c
  8023db:	e8 ac fa ff ff       	call   801e8c <syscall>
  8023e0:	83 c4 18             	add    $0x18,%esp
  8023e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023e6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023ea:	75 07                	jne    8023f3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f1:	eb 05                	jmp    8023f8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 2c                	push   $0x2c
  80240c:	e8 7b fa ff ff       	call   801e8c <syscall>
  802411:	83 c4 18             	add    $0x18,%esp
  802414:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802417:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80241b:	75 07                	jne    802424 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80241d:	b8 01 00 00 00       	mov    $0x1,%eax
  802422:	eb 05                	jmp    802429 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802424:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
  80242e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 2c                	push   $0x2c
  80243d:	e8 4a fa ff ff       	call   801e8c <syscall>
  802442:	83 c4 18             	add    $0x18,%esp
  802445:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802448:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80244c:	75 07                	jne    802455 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80244e:	b8 01 00 00 00       	mov    $0x1,%eax
  802453:	eb 05                	jmp    80245a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802455:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80245a:	c9                   	leave  
  80245b:	c3                   	ret    

0080245c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
  80245f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 2c                	push   $0x2c
  80246e:	e8 19 fa ff ff       	call   801e8c <syscall>
  802473:	83 c4 18             	add    $0x18,%esp
  802476:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802479:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80247d:	75 07                	jne    802486 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80247f:	b8 01 00 00 00       	mov    $0x1,%eax
  802484:	eb 05                	jmp    80248b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802486:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	ff 75 08             	pushl  0x8(%ebp)
  80249b:	6a 2d                	push   $0x2d
  80249d:	e8 ea f9 ff ff       	call   801e8c <syscall>
  8024a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a5:	90                   	nop
}
  8024a6:	c9                   	leave  
  8024a7:	c3                   	ret    

008024a8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
  8024ab:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	6a 00                	push   $0x0
  8024ba:	53                   	push   %ebx
  8024bb:	51                   	push   %ecx
  8024bc:	52                   	push   %edx
  8024bd:	50                   	push   %eax
  8024be:	6a 2e                	push   $0x2e
  8024c0:	e8 c7 f9 ff ff       	call   801e8c <syscall>
  8024c5:	83 c4 18             	add    $0x18,%esp
}
  8024c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024cb:	c9                   	leave  
  8024cc:	c3                   	ret    

008024cd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024cd:	55                   	push   %ebp
  8024ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	52                   	push   %edx
  8024dd:	50                   	push   %eax
  8024de:	6a 2f                	push   $0x2f
  8024e0:	e8 a7 f9 ff ff       	call   801e8c <syscall>
  8024e5:	83 c4 18             	add    $0x18,%esp
}
  8024e8:	c9                   	leave  
  8024e9:	c3                   	ret    

008024ea <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
  8024ed:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024f0:	83 ec 0c             	sub    $0xc,%esp
  8024f3:	68 e0 40 80 00       	push   $0x8040e0
  8024f8:	e8 c3 e6 ff ff       	call   800bc0 <cprintf>
  8024fd:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802500:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802507:	83 ec 0c             	sub    $0xc,%esp
  80250a:	68 0c 41 80 00       	push   $0x80410c
  80250f:	e8 ac e6 ff ff       	call   800bc0 <cprintf>
  802514:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802517:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80251b:	a1 38 51 80 00       	mov    0x805138,%eax
  802520:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802523:	eb 56                	jmp    80257b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802525:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802529:	74 1c                	je     802547 <print_mem_block_lists+0x5d>
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 50 08             	mov    0x8(%eax),%edx
  802531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802534:	8b 48 08             	mov    0x8(%eax),%ecx
  802537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253a:	8b 40 0c             	mov    0xc(%eax),%eax
  80253d:	01 c8                	add    %ecx,%eax
  80253f:	39 c2                	cmp    %eax,%edx
  802541:	73 04                	jae    802547 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802543:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 50 08             	mov    0x8(%eax),%edx
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 40 0c             	mov    0xc(%eax),%eax
  802553:	01 c2                	add    %eax,%edx
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 40 08             	mov    0x8(%eax),%eax
  80255b:	83 ec 04             	sub    $0x4,%esp
  80255e:	52                   	push   %edx
  80255f:	50                   	push   %eax
  802560:	68 21 41 80 00       	push   $0x804121
  802565:	e8 56 e6 ff ff       	call   800bc0 <cprintf>
  80256a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802573:	a1 40 51 80 00       	mov    0x805140,%eax
  802578:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257f:	74 07                	je     802588 <print_mem_block_lists+0x9e>
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 00                	mov    (%eax),%eax
  802586:	eb 05                	jmp    80258d <print_mem_block_lists+0xa3>
  802588:	b8 00 00 00 00       	mov    $0x0,%eax
  80258d:	a3 40 51 80 00       	mov    %eax,0x805140
  802592:	a1 40 51 80 00       	mov    0x805140,%eax
  802597:	85 c0                	test   %eax,%eax
  802599:	75 8a                	jne    802525 <print_mem_block_lists+0x3b>
  80259b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259f:	75 84                	jne    802525 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025a1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025a5:	75 10                	jne    8025b7 <print_mem_block_lists+0xcd>
  8025a7:	83 ec 0c             	sub    $0xc,%esp
  8025aa:	68 30 41 80 00       	push   $0x804130
  8025af:	e8 0c e6 ff ff       	call   800bc0 <cprintf>
  8025b4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025be:	83 ec 0c             	sub    $0xc,%esp
  8025c1:	68 54 41 80 00       	push   $0x804154
  8025c6:	e8 f5 e5 ff ff       	call   800bc0 <cprintf>
  8025cb:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025ce:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025d2:	a1 40 50 80 00       	mov    0x805040,%eax
  8025d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025da:	eb 56                	jmp    802632 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025e0:	74 1c                	je     8025fe <print_mem_block_lists+0x114>
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	8b 50 08             	mov    0x8(%eax),%edx
  8025e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025eb:	8b 48 08             	mov    0x8(%eax),%ecx
  8025ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f4:	01 c8                	add    %ecx,%eax
  8025f6:	39 c2                	cmp    %eax,%edx
  8025f8:	73 04                	jae    8025fe <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025fa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 50 08             	mov    0x8(%eax),%edx
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 40 0c             	mov    0xc(%eax),%eax
  80260a:	01 c2                	add    %eax,%edx
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 40 08             	mov    0x8(%eax),%eax
  802612:	83 ec 04             	sub    $0x4,%esp
  802615:	52                   	push   %edx
  802616:	50                   	push   %eax
  802617:	68 21 41 80 00       	push   $0x804121
  80261c:	e8 9f e5 ff ff       	call   800bc0 <cprintf>
  802621:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80262a:	a1 48 50 80 00       	mov    0x805048,%eax
  80262f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802632:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802636:	74 07                	je     80263f <print_mem_block_lists+0x155>
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 00                	mov    (%eax),%eax
  80263d:	eb 05                	jmp    802644 <print_mem_block_lists+0x15a>
  80263f:	b8 00 00 00 00       	mov    $0x0,%eax
  802644:	a3 48 50 80 00       	mov    %eax,0x805048
  802649:	a1 48 50 80 00       	mov    0x805048,%eax
  80264e:	85 c0                	test   %eax,%eax
  802650:	75 8a                	jne    8025dc <print_mem_block_lists+0xf2>
  802652:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802656:	75 84                	jne    8025dc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802658:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80265c:	75 10                	jne    80266e <print_mem_block_lists+0x184>
  80265e:	83 ec 0c             	sub    $0xc,%esp
  802661:	68 6c 41 80 00       	push   $0x80416c
  802666:	e8 55 e5 ff ff       	call   800bc0 <cprintf>
  80266b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80266e:	83 ec 0c             	sub    $0xc,%esp
  802671:	68 e0 40 80 00       	push   $0x8040e0
  802676:	e8 45 e5 ff ff       	call   800bc0 <cprintf>
  80267b:	83 c4 10             	add    $0x10,%esp

}
  80267e:	90                   	nop
  80267f:	c9                   	leave  
  802680:	c3                   	ret    

00802681 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802681:	55                   	push   %ebp
  802682:	89 e5                	mov    %esp,%ebp
  802684:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802687:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80268e:	00 00 00 
  802691:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802698:	00 00 00 
  80269b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026a2:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8026a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026ac:	e9 9e 00 00 00       	jmp    80274f <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8026b1:	a1 50 50 80 00       	mov    0x805050,%eax
  8026b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b9:	c1 e2 04             	shl    $0x4,%edx
  8026bc:	01 d0                	add    %edx,%eax
  8026be:	85 c0                	test   %eax,%eax
  8026c0:	75 14                	jne    8026d6 <initialize_MemBlocksList+0x55>
  8026c2:	83 ec 04             	sub    $0x4,%esp
  8026c5:	68 94 41 80 00       	push   $0x804194
  8026ca:	6a 47                	push   $0x47
  8026cc:	68 b7 41 80 00       	push   $0x8041b7
  8026d1:	e8 36 e2 ff ff       	call   80090c <_panic>
  8026d6:	a1 50 50 80 00       	mov    0x805050,%eax
  8026db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026de:	c1 e2 04             	shl    $0x4,%edx
  8026e1:	01 d0                	add    %edx,%eax
  8026e3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026e9:	89 10                	mov    %edx,(%eax)
  8026eb:	8b 00                	mov    (%eax),%eax
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	74 18                	je     802709 <initialize_MemBlocksList+0x88>
  8026f1:	a1 48 51 80 00       	mov    0x805148,%eax
  8026f6:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026fc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026ff:	c1 e1 04             	shl    $0x4,%ecx
  802702:	01 ca                	add    %ecx,%edx
  802704:	89 50 04             	mov    %edx,0x4(%eax)
  802707:	eb 12                	jmp    80271b <initialize_MemBlocksList+0x9a>
  802709:	a1 50 50 80 00       	mov    0x805050,%eax
  80270e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802711:	c1 e2 04             	shl    $0x4,%edx
  802714:	01 d0                	add    %edx,%eax
  802716:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80271b:	a1 50 50 80 00       	mov    0x805050,%eax
  802720:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802723:	c1 e2 04             	shl    $0x4,%edx
  802726:	01 d0                	add    %edx,%eax
  802728:	a3 48 51 80 00       	mov    %eax,0x805148
  80272d:	a1 50 50 80 00       	mov    0x805050,%eax
  802732:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802735:	c1 e2 04             	shl    $0x4,%edx
  802738:	01 d0                	add    %edx,%eax
  80273a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802741:	a1 54 51 80 00       	mov    0x805154,%eax
  802746:	40                   	inc    %eax
  802747:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80274c:	ff 45 f4             	incl   -0xc(%ebp)
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	3b 45 08             	cmp    0x8(%ebp),%eax
  802755:	0f 82 56 ff ff ff    	jb     8026b1 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  80275b:	90                   	nop
  80275c:	c9                   	leave  
  80275d:	c3                   	ret    

0080275e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80275e:	55                   	push   %ebp
  80275f:	89 e5                	mov    %esp,%ebp
  802761:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802764:	8b 45 08             	mov    0x8(%ebp),%eax
  802767:	8b 00                	mov    (%eax),%eax
  802769:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80276c:	eb 19                	jmp    802787 <find_block+0x29>
	{
		if(element->sva == va){
  80276e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802771:	8b 40 08             	mov    0x8(%eax),%eax
  802774:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802777:	75 05                	jne    80277e <find_block+0x20>
			 		return element;
  802779:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80277c:	eb 36                	jmp    8027b4 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80277e:	8b 45 08             	mov    0x8(%ebp),%eax
  802781:	8b 40 08             	mov    0x8(%eax),%eax
  802784:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802787:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80278b:	74 07                	je     802794 <find_block+0x36>
  80278d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802790:	8b 00                	mov    (%eax),%eax
  802792:	eb 05                	jmp    802799 <find_block+0x3b>
  802794:	b8 00 00 00 00       	mov    $0x0,%eax
  802799:	8b 55 08             	mov    0x8(%ebp),%edx
  80279c:	89 42 08             	mov    %eax,0x8(%edx)
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	8b 40 08             	mov    0x8(%eax),%eax
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	75 c5                	jne    80276e <find_block+0x10>
  8027a9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027ad:	75 bf                	jne    80276e <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  8027af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
  8027b9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  8027bc:	a1 44 50 80 00       	mov    0x805044,%eax
  8027c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  8027c4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  8027cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027d0:	74 0a                	je     8027dc <insert_sorted_allocList+0x26>
  8027d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d5:	8b 40 08             	mov    0x8(%eax),%eax
  8027d8:	85 c0                	test   %eax,%eax
  8027da:	75 65                	jne    802841 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8027dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027e0:	75 14                	jne    8027f6 <insert_sorted_allocList+0x40>
  8027e2:	83 ec 04             	sub    $0x4,%esp
  8027e5:	68 94 41 80 00       	push   $0x804194
  8027ea:	6a 6e                	push   $0x6e
  8027ec:	68 b7 41 80 00       	push   $0x8041b7
  8027f1:	e8 16 e1 ff ff       	call   80090c <_panic>
  8027f6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ff:	89 10                	mov    %edx,(%eax)
  802801:	8b 45 08             	mov    0x8(%ebp),%eax
  802804:	8b 00                	mov    (%eax),%eax
  802806:	85 c0                	test   %eax,%eax
  802808:	74 0d                	je     802817 <insert_sorted_allocList+0x61>
  80280a:	a1 40 50 80 00       	mov    0x805040,%eax
  80280f:	8b 55 08             	mov    0x8(%ebp),%edx
  802812:	89 50 04             	mov    %edx,0x4(%eax)
  802815:	eb 08                	jmp    80281f <insert_sorted_allocList+0x69>
  802817:	8b 45 08             	mov    0x8(%ebp),%eax
  80281a:	a3 44 50 80 00       	mov    %eax,0x805044
  80281f:	8b 45 08             	mov    0x8(%ebp),%eax
  802822:	a3 40 50 80 00       	mov    %eax,0x805040
  802827:	8b 45 08             	mov    0x8(%ebp),%eax
  80282a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802831:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802836:	40                   	inc    %eax
  802837:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80283c:	e9 cf 01 00 00       	jmp    802a10 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802844:	8b 50 08             	mov    0x8(%eax),%edx
  802847:	8b 45 08             	mov    0x8(%ebp),%eax
  80284a:	8b 40 08             	mov    0x8(%eax),%eax
  80284d:	39 c2                	cmp    %eax,%edx
  80284f:	73 65                	jae    8028b6 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802851:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802855:	75 14                	jne    80286b <insert_sorted_allocList+0xb5>
  802857:	83 ec 04             	sub    $0x4,%esp
  80285a:	68 d0 41 80 00       	push   $0x8041d0
  80285f:	6a 72                	push   $0x72
  802861:	68 b7 41 80 00       	push   $0x8041b7
  802866:	e8 a1 e0 ff ff       	call   80090c <_panic>
  80286b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802871:	8b 45 08             	mov    0x8(%ebp),%eax
  802874:	89 50 04             	mov    %edx,0x4(%eax)
  802877:	8b 45 08             	mov    0x8(%ebp),%eax
  80287a:	8b 40 04             	mov    0x4(%eax),%eax
  80287d:	85 c0                	test   %eax,%eax
  80287f:	74 0c                	je     80288d <insert_sorted_allocList+0xd7>
  802881:	a1 44 50 80 00       	mov    0x805044,%eax
  802886:	8b 55 08             	mov    0x8(%ebp),%edx
  802889:	89 10                	mov    %edx,(%eax)
  80288b:	eb 08                	jmp    802895 <insert_sorted_allocList+0xdf>
  80288d:	8b 45 08             	mov    0x8(%ebp),%eax
  802890:	a3 40 50 80 00       	mov    %eax,0x805040
  802895:	8b 45 08             	mov    0x8(%ebp),%eax
  802898:	a3 44 50 80 00       	mov    %eax,0x805044
  80289d:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028ab:	40                   	inc    %eax
  8028ac:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8028b1:	e9 5a 01 00 00       	jmp    802a10 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  8028b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b9:	8b 50 08             	mov    0x8(%eax),%edx
  8028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bf:	8b 40 08             	mov    0x8(%eax),%eax
  8028c2:	39 c2                	cmp    %eax,%edx
  8028c4:	75 70                	jne    802936 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  8028c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ca:	74 06                	je     8028d2 <insert_sorted_allocList+0x11c>
  8028cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028d0:	75 14                	jne    8028e6 <insert_sorted_allocList+0x130>
  8028d2:	83 ec 04             	sub    $0x4,%esp
  8028d5:	68 f4 41 80 00       	push   $0x8041f4
  8028da:	6a 75                	push   $0x75
  8028dc:	68 b7 41 80 00       	push   $0x8041b7
  8028e1:	e8 26 e0 ff ff       	call   80090c <_panic>
  8028e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e9:	8b 10                	mov    (%eax),%edx
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	89 10                	mov    %edx,(%eax)
  8028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f3:	8b 00                	mov    (%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 0b                	je     802904 <insert_sorted_allocList+0x14e>
  8028f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fc:	8b 00                	mov    (%eax),%eax
  8028fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802901:	89 50 04             	mov    %edx,0x4(%eax)
  802904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802907:	8b 55 08             	mov    0x8(%ebp),%edx
  80290a:	89 10                	mov    %edx,(%eax)
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802912:	89 50 04             	mov    %edx,0x4(%eax)
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	8b 00                	mov    (%eax),%eax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	75 08                	jne    802926 <insert_sorted_allocList+0x170>
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	a3 44 50 80 00       	mov    %eax,0x805044
  802926:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80292b:	40                   	inc    %eax
  80292c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802931:	e9 da 00 00 00       	jmp    802a10 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802936:	a1 40 50 80 00       	mov    0x805040,%eax
  80293b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80293e:	e9 9d 00 00 00       	jmp    8029e0 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	8b 00                	mov    (%eax),%eax
  802948:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  80294b:	8b 45 08             	mov    0x8(%ebp),%eax
  80294e:	8b 50 08             	mov    0x8(%eax),%edx
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	8b 40 08             	mov    0x8(%eax),%eax
  802957:	39 c2                	cmp    %eax,%edx
  802959:	76 7d                	jbe    8029d8 <insert_sorted_allocList+0x222>
  80295b:	8b 45 08             	mov    0x8(%ebp),%eax
  80295e:	8b 50 08             	mov    0x8(%eax),%edx
  802961:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802964:	8b 40 08             	mov    0x8(%eax),%eax
  802967:	39 c2                	cmp    %eax,%edx
  802969:	73 6d                	jae    8029d8 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80296b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296f:	74 06                	je     802977 <insert_sorted_allocList+0x1c1>
  802971:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802975:	75 14                	jne    80298b <insert_sorted_allocList+0x1d5>
  802977:	83 ec 04             	sub    $0x4,%esp
  80297a:	68 f4 41 80 00       	push   $0x8041f4
  80297f:	6a 7c                	push   $0x7c
  802981:	68 b7 41 80 00       	push   $0x8041b7
  802986:	e8 81 df ff ff       	call   80090c <_panic>
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	8b 10                	mov    (%eax),%edx
  802990:	8b 45 08             	mov    0x8(%ebp),%eax
  802993:	89 10                	mov    %edx,(%eax)
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	8b 00                	mov    (%eax),%eax
  80299a:	85 c0                	test   %eax,%eax
  80299c:	74 0b                	je     8029a9 <insert_sorted_allocList+0x1f3>
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	8b 00                	mov    (%eax),%eax
  8029a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a6:	89 50 04             	mov    %edx,0x4(%eax)
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8029af:	89 10                	mov    %edx,(%eax)
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	85 c0                	test   %eax,%eax
  8029c1:	75 08                	jne    8029cb <insert_sorted_allocList+0x215>
  8029c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c6:	a3 44 50 80 00       	mov    %eax,0x805044
  8029cb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029d0:	40                   	inc    %eax
  8029d1:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8029d6:	eb 38                	jmp    802a10 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8029d8:	a1 48 50 80 00       	mov    0x805048,%eax
  8029dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e4:	74 07                	je     8029ed <insert_sorted_allocList+0x237>
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 00                	mov    (%eax),%eax
  8029eb:	eb 05                	jmp    8029f2 <insert_sorted_allocList+0x23c>
  8029ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f2:	a3 48 50 80 00       	mov    %eax,0x805048
  8029f7:	a1 48 50 80 00       	mov    0x805048,%eax
  8029fc:	85 c0                	test   %eax,%eax
  8029fe:	0f 85 3f ff ff ff    	jne    802943 <insert_sorted_allocList+0x18d>
  802a04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a08:	0f 85 35 ff ff ff    	jne    802943 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802a0e:	eb 00                	jmp    802a10 <insert_sorted_allocList+0x25a>
  802a10:	90                   	nop
  802a11:	c9                   	leave  
  802a12:	c3                   	ret    

00802a13 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a13:	55                   	push   %ebp
  802a14:	89 e5                	mov    %esp,%ebp
  802a16:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802a19:	a1 38 51 80 00       	mov    0x805138,%eax
  802a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a21:	e9 6b 02 00 00       	jmp    802c91 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a2f:	0f 85 90 00 00 00    	jne    802ac5 <alloc_block_FF+0xb2>
			  temp=element;
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802a3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3f:	75 17                	jne    802a58 <alloc_block_FF+0x45>
  802a41:	83 ec 04             	sub    $0x4,%esp
  802a44:	68 28 42 80 00       	push   $0x804228
  802a49:	68 92 00 00 00       	push   $0x92
  802a4e:	68 b7 41 80 00       	push   $0x8041b7
  802a53:	e8 b4 de ff ff       	call   80090c <_panic>
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	8b 00                	mov    (%eax),%eax
  802a5d:	85 c0                	test   %eax,%eax
  802a5f:	74 10                	je     802a71 <alloc_block_FF+0x5e>
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 00                	mov    (%eax),%eax
  802a66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a69:	8b 52 04             	mov    0x4(%edx),%edx
  802a6c:	89 50 04             	mov    %edx,0x4(%eax)
  802a6f:	eb 0b                	jmp    802a7c <alloc_block_FF+0x69>
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 40 04             	mov    0x4(%eax),%eax
  802a77:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 40 04             	mov    0x4(%eax),%eax
  802a82:	85 c0                	test   %eax,%eax
  802a84:	74 0f                	je     802a95 <alloc_block_FF+0x82>
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	8b 40 04             	mov    0x4(%eax),%eax
  802a8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8f:	8b 12                	mov    (%edx),%edx
  802a91:	89 10                	mov    %edx,(%eax)
  802a93:	eb 0a                	jmp    802a9f <alloc_block_FF+0x8c>
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 00                	mov    (%eax),%eax
  802a9a:	a3 38 51 80 00       	mov    %eax,0x805138
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ab7:	48                   	dec    %eax
  802ab8:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802abd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac0:	e9 ff 01 00 00       	jmp    802cc4 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 40 0c             	mov    0xc(%eax),%eax
  802acb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ace:	0f 86 b5 01 00 00    	jbe    802c89 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	8b 40 0c             	mov    0xc(%eax),%eax
  802ada:	2b 45 08             	sub    0x8(%ebp),%eax
  802add:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802ae0:	a1 48 51 80 00       	mov    0x805148,%eax
  802ae5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802ae8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aec:	75 17                	jne    802b05 <alloc_block_FF+0xf2>
  802aee:	83 ec 04             	sub    $0x4,%esp
  802af1:	68 28 42 80 00       	push   $0x804228
  802af6:	68 99 00 00 00       	push   $0x99
  802afb:	68 b7 41 80 00       	push   $0x8041b7
  802b00:	e8 07 de ff ff       	call   80090c <_panic>
  802b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b08:	8b 00                	mov    (%eax),%eax
  802b0a:	85 c0                	test   %eax,%eax
  802b0c:	74 10                	je     802b1e <alloc_block_FF+0x10b>
  802b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b11:	8b 00                	mov    (%eax),%eax
  802b13:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b16:	8b 52 04             	mov    0x4(%edx),%edx
  802b19:	89 50 04             	mov    %edx,0x4(%eax)
  802b1c:	eb 0b                	jmp    802b29 <alloc_block_FF+0x116>
  802b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b21:	8b 40 04             	mov    0x4(%eax),%eax
  802b24:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2c:	8b 40 04             	mov    0x4(%eax),%eax
  802b2f:	85 c0                	test   %eax,%eax
  802b31:	74 0f                	je     802b42 <alloc_block_FF+0x12f>
  802b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b36:	8b 40 04             	mov    0x4(%eax),%eax
  802b39:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b3c:	8b 12                	mov    (%edx),%edx
  802b3e:	89 10                	mov    %edx,(%eax)
  802b40:	eb 0a                	jmp    802b4c <alloc_block_FF+0x139>
  802b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	a3 48 51 80 00       	mov    %eax,0x805148
  802b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5f:	a1 54 51 80 00       	mov    0x805154,%eax
  802b64:	48                   	dec    %eax
  802b65:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802b6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b6e:	75 17                	jne    802b87 <alloc_block_FF+0x174>
  802b70:	83 ec 04             	sub    $0x4,%esp
  802b73:	68 d0 41 80 00       	push   $0x8041d0
  802b78:	68 9a 00 00 00       	push   $0x9a
  802b7d:	68 b7 41 80 00       	push   $0x8041b7
  802b82:	e8 85 dd ff ff       	call   80090c <_panic>
  802b87:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b90:	89 50 04             	mov    %edx,0x4(%eax)
  802b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b96:	8b 40 04             	mov    0x4(%eax),%eax
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	74 0c                	je     802ba9 <alloc_block_FF+0x196>
  802b9d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ba2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ba5:	89 10                	mov    %edx,(%eax)
  802ba7:	eb 08                	jmp    802bb1 <alloc_block_FF+0x19e>
  802ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bac:	a3 38 51 80 00       	mov    %eax,0x805138
  802bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc2:	a1 44 51 80 00       	mov    0x805144,%eax
  802bc7:	40                   	inc    %eax
  802bc8:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd0:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd3:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	8b 50 08             	mov    0x8(%eax),%edx
  802bdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdf:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be8:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	8b 50 08             	mov    0x8(%eax),%edx
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	01 c2                	add    %eax,%edx
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802bfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bff:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802c02:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c06:	75 17                	jne    802c1f <alloc_block_FF+0x20c>
  802c08:	83 ec 04             	sub    $0x4,%esp
  802c0b:	68 28 42 80 00       	push   $0x804228
  802c10:	68 a2 00 00 00       	push   $0xa2
  802c15:	68 b7 41 80 00       	push   $0x8041b7
  802c1a:	e8 ed dc ff ff       	call   80090c <_panic>
  802c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	85 c0                	test   %eax,%eax
  802c26:	74 10                	je     802c38 <alloc_block_FF+0x225>
  802c28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2b:	8b 00                	mov    (%eax),%eax
  802c2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c30:	8b 52 04             	mov    0x4(%edx),%edx
  802c33:	89 50 04             	mov    %edx,0x4(%eax)
  802c36:	eb 0b                	jmp    802c43 <alloc_block_FF+0x230>
  802c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3b:	8b 40 04             	mov    0x4(%eax),%eax
  802c3e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c46:	8b 40 04             	mov    0x4(%eax),%eax
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	74 0f                	je     802c5c <alloc_block_FF+0x249>
  802c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c50:	8b 40 04             	mov    0x4(%eax),%eax
  802c53:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c56:	8b 12                	mov    (%edx),%edx
  802c58:	89 10                	mov    %edx,(%eax)
  802c5a:	eb 0a                	jmp    802c66 <alloc_block_FF+0x253>
  802c5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5f:	8b 00                	mov    (%eax),%eax
  802c61:	a3 38 51 80 00       	mov    %eax,0x805138
  802c66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c79:	a1 44 51 80 00       	mov    0x805144,%eax
  802c7e:	48                   	dec    %eax
  802c7f:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802c84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c87:	eb 3b                	jmp    802cc4 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802c89:	a1 40 51 80 00       	mov    0x805140,%eax
  802c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c95:	74 07                	je     802c9e <alloc_block_FF+0x28b>
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	eb 05                	jmp    802ca3 <alloc_block_FF+0x290>
  802c9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca3:	a3 40 51 80 00       	mov    %eax,0x805140
  802ca8:	a1 40 51 80 00       	mov    0x805140,%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	0f 85 71 fd ff ff    	jne    802a26 <alloc_block_FF+0x13>
  802cb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb9:	0f 85 67 fd ff ff    	jne    802a26 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc4:	c9                   	leave  
  802cc5:	c3                   	ret    

00802cc6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802cc6:	55                   	push   %ebp
  802cc7:	89 e5                	mov    %esp,%ebp
  802cc9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802ccc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802cd3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802cda:	a1 38 51 80 00       	mov    0x805138,%eax
  802cdf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802ce2:	e9 d3 00 00 00       	jmp    802dba <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802ce7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cea:	8b 40 0c             	mov    0xc(%eax),%eax
  802ced:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cf0:	0f 85 90 00 00 00    	jne    802d86 <alloc_block_BF+0xc0>
	   temp = element;
  802cf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802cfc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d00:	75 17                	jne    802d19 <alloc_block_BF+0x53>
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	68 28 42 80 00       	push   $0x804228
  802d0a:	68 bd 00 00 00       	push   $0xbd
  802d0f:	68 b7 41 80 00       	push   $0x8041b7
  802d14:	e8 f3 db ff ff       	call   80090c <_panic>
  802d19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	85 c0                	test   %eax,%eax
  802d20:	74 10                	je     802d32 <alloc_block_BF+0x6c>
  802d22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d2a:	8b 52 04             	mov    0x4(%edx),%edx
  802d2d:	89 50 04             	mov    %edx,0x4(%eax)
  802d30:	eb 0b                	jmp    802d3d <alloc_block_BF+0x77>
  802d32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d35:	8b 40 04             	mov    0x4(%eax),%eax
  802d38:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d40:	8b 40 04             	mov    0x4(%eax),%eax
  802d43:	85 c0                	test   %eax,%eax
  802d45:	74 0f                	je     802d56 <alloc_block_BF+0x90>
  802d47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d4a:	8b 40 04             	mov    0x4(%eax),%eax
  802d4d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d50:	8b 12                	mov    (%edx),%edx
  802d52:	89 10                	mov    %edx,(%eax)
  802d54:	eb 0a                	jmp    802d60 <alloc_block_BF+0x9a>
  802d56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d59:	8b 00                	mov    (%eax),%eax
  802d5b:	a3 38 51 80 00       	mov    %eax,0x805138
  802d60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d73:	a1 44 51 80 00       	mov    0x805144,%eax
  802d78:	48                   	dec    %eax
  802d79:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802d7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d81:	e9 41 01 00 00       	jmp    802ec7 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802d86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d89:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d8f:	76 21                	jbe    802db2 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802d91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d94:	8b 40 0c             	mov    0xc(%eax),%eax
  802d97:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d9a:	73 16                	jae    802db2 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802d9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802da5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802dab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802db2:	a1 40 51 80 00       	mov    0x805140,%eax
  802db7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802dba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802dbe:	74 07                	je     802dc7 <alloc_block_BF+0x101>
  802dc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc3:	8b 00                	mov    (%eax),%eax
  802dc5:	eb 05                	jmp    802dcc <alloc_block_BF+0x106>
  802dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dcc:	a3 40 51 80 00       	mov    %eax,0x805140
  802dd1:	a1 40 51 80 00       	mov    0x805140,%eax
  802dd6:	85 c0                	test   %eax,%eax
  802dd8:	0f 85 09 ff ff ff    	jne    802ce7 <alloc_block_BF+0x21>
  802dde:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802de2:	0f 85 ff fe ff ff    	jne    802ce7 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802de8:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802dec:	0f 85 d0 00 00 00    	jne    802ec2 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802df2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df5:	8b 40 0c             	mov    0xc(%eax),%eax
  802df8:	2b 45 08             	sub    0x8(%ebp),%eax
  802dfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802dfe:	a1 48 51 80 00       	mov    0x805148,%eax
  802e03:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802e06:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e0a:	75 17                	jne    802e23 <alloc_block_BF+0x15d>
  802e0c:	83 ec 04             	sub    $0x4,%esp
  802e0f:	68 28 42 80 00       	push   $0x804228
  802e14:	68 d1 00 00 00       	push   $0xd1
  802e19:	68 b7 41 80 00       	push   $0x8041b7
  802e1e:	e8 e9 da ff ff       	call   80090c <_panic>
  802e23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e26:	8b 00                	mov    (%eax),%eax
  802e28:	85 c0                	test   %eax,%eax
  802e2a:	74 10                	je     802e3c <alloc_block_BF+0x176>
  802e2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e34:	8b 52 04             	mov    0x4(%edx),%edx
  802e37:	89 50 04             	mov    %edx,0x4(%eax)
  802e3a:	eb 0b                	jmp    802e47 <alloc_block_BF+0x181>
  802e3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e3f:	8b 40 04             	mov    0x4(%eax),%eax
  802e42:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e4a:	8b 40 04             	mov    0x4(%eax),%eax
  802e4d:	85 c0                	test   %eax,%eax
  802e4f:	74 0f                	je     802e60 <alloc_block_BF+0x19a>
  802e51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e54:	8b 40 04             	mov    0x4(%eax),%eax
  802e57:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e5a:	8b 12                	mov    (%edx),%edx
  802e5c:	89 10                	mov    %edx,(%eax)
  802e5e:	eb 0a                	jmp    802e6a <alloc_block_BF+0x1a4>
  802e60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e63:	8b 00                	mov    (%eax),%eax
  802e65:	a3 48 51 80 00       	mov    %eax,0x805148
  802e6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7d:	a1 54 51 80 00       	mov    0x805154,%eax
  802e82:	48                   	dec    %eax
  802e83:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  802e88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e8e:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802e91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e94:	8b 50 08             	mov    0x8(%eax),%edx
  802e97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e9a:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802e9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ea3:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802ea6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea9:	8b 50 08             	mov    0x8(%eax),%edx
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	01 c2                	add    %eax,%edx
  802eb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb4:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802eb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eba:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802ebd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ec0:	eb 05                	jmp    802ec7 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802ec2:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802ec7:	c9                   	leave  
  802ec8:	c3                   	ret    

00802ec9 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ec9:	55                   	push   %ebp
  802eca:	89 e5                	mov    %esp,%ebp
  802ecc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802ecf:	83 ec 04             	sub    $0x4,%esp
  802ed2:	68 48 42 80 00       	push   $0x804248
  802ed7:	68 e8 00 00 00       	push   $0xe8
  802edc:	68 b7 41 80 00       	push   $0x8041b7
  802ee1:	e8 26 da ff ff       	call   80090c <_panic>

00802ee6 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ee6:	55                   	push   %ebp
  802ee7:	89 e5                	mov    %esp,%ebp
  802ee9:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802eec:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ef1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802ef4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802efc:	a1 44 51 80 00       	mov    0x805144,%eax
  802f01:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802f04:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f08:	75 68                	jne    802f72 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802f0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f0e:	75 17                	jne    802f27 <insert_sorted_with_merge_freeList+0x41>
  802f10:	83 ec 04             	sub    $0x4,%esp
  802f13:	68 94 41 80 00       	push   $0x804194
  802f18:	68 36 01 00 00       	push   $0x136
  802f1d:	68 b7 41 80 00       	push   $0x8041b7
  802f22:	e8 e5 d9 ff ff       	call   80090c <_panic>
  802f27:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	89 10                	mov    %edx,(%eax)
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	8b 00                	mov    (%eax),%eax
  802f37:	85 c0                	test   %eax,%eax
  802f39:	74 0d                	je     802f48 <insert_sorted_with_merge_freeList+0x62>
  802f3b:	a1 38 51 80 00       	mov    0x805138,%eax
  802f40:	8b 55 08             	mov    0x8(%ebp),%edx
  802f43:	89 50 04             	mov    %edx,0x4(%eax)
  802f46:	eb 08                	jmp    802f50 <insert_sorted_with_merge_freeList+0x6a>
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	a3 38 51 80 00       	mov    %eax,0x805138
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f62:	a1 44 51 80 00       	mov    0x805144,%eax
  802f67:	40                   	inc    %eax
  802f68:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802f6d:	e9 ba 06 00 00       	jmp    80362c <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f75:	8b 50 08             	mov    0x8(%eax),%edx
  802f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7e:	01 c2                	add    %eax,%edx
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	8b 40 08             	mov    0x8(%eax),%eax
  802f86:	39 c2                	cmp    %eax,%edx
  802f88:	73 68                	jae    802ff2 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8e:	75 17                	jne    802fa7 <insert_sorted_with_merge_freeList+0xc1>
  802f90:	83 ec 04             	sub    $0x4,%esp
  802f93:	68 d0 41 80 00       	push   $0x8041d0
  802f98:	68 3a 01 00 00       	push   $0x13a
  802f9d:	68 b7 41 80 00       	push   $0x8041b7
  802fa2:	e8 65 d9 ff ff       	call   80090c <_panic>
  802fa7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fad:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb0:	89 50 04             	mov    %edx,0x4(%eax)
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	8b 40 04             	mov    0x4(%eax),%eax
  802fb9:	85 c0                	test   %eax,%eax
  802fbb:	74 0c                	je     802fc9 <insert_sorted_with_merge_freeList+0xe3>
  802fbd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fc2:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc5:	89 10                	mov    %edx,(%eax)
  802fc7:	eb 08                	jmp    802fd1 <insert_sorted_with_merge_freeList+0xeb>
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe2:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe7:	40                   	inc    %eax
  802fe8:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802fed:	e9 3a 06 00 00       	jmp    80362c <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff5:	8b 50 08             	mov    0x8(%eax),%edx
  802ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffe:	01 c2                	add    %eax,%edx
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	8b 40 08             	mov    0x8(%eax),%eax
  803006:	39 c2                	cmp    %eax,%edx
  803008:	0f 85 90 00 00 00    	jne    80309e <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  80300e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803011:	8b 50 0c             	mov    0xc(%eax),%edx
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	8b 40 0c             	mov    0xc(%eax),%eax
  80301a:	01 c2                	add    %eax,%edx
  80301c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301f:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803036:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80303a:	75 17                	jne    803053 <insert_sorted_with_merge_freeList+0x16d>
  80303c:	83 ec 04             	sub    $0x4,%esp
  80303f:	68 94 41 80 00       	push   $0x804194
  803044:	68 41 01 00 00       	push   $0x141
  803049:	68 b7 41 80 00       	push   $0x8041b7
  80304e:	e8 b9 d8 ff ff       	call   80090c <_panic>
  803053:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	89 10                	mov    %edx,(%eax)
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	8b 00                	mov    (%eax),%eax
  803063:	85 c0                	test   %eax,%eax
  803065:	74 0d                	je     803074 <insert_sorted_with_merge_freeList+0x18e>
  803067:	a1 48 51 80 00       	mov    0x805148,%eax
  80306c:	8b 55 08             	mov    0x8(%ebp),%edx
  80306f:	89 50 04             	mov    %edx,0x4(%eax)
  803072:	eb 08                	jmp    80307c <insert_sorted_with_merge_freeList+0x196>
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	a3 48 51 80 00       	mov    %eax,0x805148
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308e:	a1 54 51 80 00       	mov    0x805154,%eax
  803093:	40                   	inc    %eax
  803094:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803099:	e9 8e 05 00 00       	jmp    80362c <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  80309e:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a1:	8b 50 08             	mov    0x8(%eax),%edx
  8030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030aa:	01 c2                	add    %eax,%edx
  8030ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030af:	8b 40 08             	mov    0x8(%eax),%eax
  8030b2:	39 c2                	cmp    %eax,%edx
  8030b4:	73 68                	jae    80311e <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8030b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ba:	75 17                	jne    8030d3 <insert_sorted_with_merge_freeList+0x1ed>
  8030bc:	83 ec 04             	sub    $0x4,%esp
  8030bf:	68 94 41 80 00       	push   $0x804194
  8030c4:	68 45 01 00 00       	push   $0x145
  8030c9:	68 b7 41 80 00       	push   $0x8041b7
  8030ce:	e8 39 d8 ff ff       	call   80090c <_panic>
  8030d3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	89 10                	mov    %edx,(%eax)
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	8b 00                	mov    (%eax),%eax
  8030e3:	85 c0                	test   %eax,%eax
  8030e5:	74 0d                	je     8030f4 <insert_sorted_with_merge_freeList+0x20e>
  8030e7:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ef:	89 50 04             	mov    %edx,0x4(%eax)
  8030f2:	eb 08                	jmp    8030fc <insert_sorted_with_merge_freeList+0x216>
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	a3 38 51 80 00       	mov    %eax,0x805138
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310e:	a1 44 51 80 00       	mov    0x805144,%eax
  803113:	40                   	inc    %eax
  803114:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803119:	e9 0e 05 00 00       	jmp    80362c <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  80311e:	8b 45 08             	mov    0x8(%ebp),%eax
  803121:	8b 50 08             	mov    0x8(%eax),%edx
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	8b 40 0c             	mov    0xc(%eax),%eax
  80312a:	01 c2                	add    %eax,%edx
  80312c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312f:	8b 40 08             	mov    0x8(%eax),%eax
  803132:	39 c2                	cmp    %eax,%edx
  803134:	0f 85 9c 00 00 00    	jne    8031d6 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  80313a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313d:	8b 50 0c             	mov    0xc(%eax),%edx
  803140:	8b 45 08             	mov    0x8(%ebp),%eax
  803143:	8b 40 0c             	mov    0xc(%eax),%eax
  803146:	01 c2                	add    %eax,%edx
  803148:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80314b:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  80314e:	8b 45 08             	mov    0x8(%ebp),%eax
  803151:	8b 50 08             	mov    0x8(%eax),%edx
  803154:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803157:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80316e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803172:	75 17                	jne    80318b <insert_sorted_with_merge_freeList+0x2a5>
  803174:	83 ec 04             	sub    $0x4,%esp
  803177:	68 94 41 80 00       	push   $0x804194
  80317c:	68 4d 01 00 00       	push   $0x14d
  803181:	68 b7 41 80 00       	push   $0x8041b7
  803186:	e8 81 d7 ff ff       	call   80090c <_panic>
  80318b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	89 10                	mov    %edx,(%eax)
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	8b 00                	mov    (%eax),%eax
  80319b:	85 c0                	test   %eax,%eax
  80319d:	74 0d                	je     8031ac <insert_sorted_with_merge_freeList+0x2c6>
  80319f:	a1 48 51 80 00       	mov    0x805148,%eax
  8031a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a7:	89 50 04             	mov    %edx,0x4(%eax)
  8031aa:	eb 08                	jmp    8031b4 <insert_sorted_with_merge_freeList+0x2ce>
  8031ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8031af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	a3 48 51 80 00       	mov    %eax,0x805148
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c6:	a1 54 51 80 00       	mov    0x805154,%eax
  8031cb:	40                   	inc    %eax
  8031cc:	a3 54 51 80 00       	mov    %eax,0x805154





}
  8031d1:	e9 56 04 00 00       	jmp    80362c <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8031d6:	a1 38 51 80 00       	mov    0x805138,%eax
  8031db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031de:	e9 19 04 00 00       	jmp    8035fc <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  8031e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  8031eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ee:	8b 50 08             	mov    0x8(%eax),%edx
  8031f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f7:	01 c2                	add    %eax,%edx
  8031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fc:	8b 40 08             	mov    0x8(%eax),%eax
  8031ff:	39 c2                	cmp    %eax,%edx
  803201:	0f 85 ad 01 00 00    	jne    8033b4 <insert_sorted_with_merge_freeList+0x4ce>
  803207:	8b 45 08             	mov    0x8(%ebp),%eax
  80320a:	8b 50 08             	mov    0x8(%eax),%edx
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	8b 40 0c             	mov    0xc(%eax),%eax
  803213:	01 c2                	add    %eax,%edx
  803215:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803218:	8b 40 08             	mov    0x8(%eax),%eax
  80321b:	39 c2                	cmp    %eax,%edx
  80321d:	0f 85 91 01 00 00    	jne    8033b4 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	8b 50 0c             	mov    0xc(%eax),%edx
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	8b 48 0c             	mov    0xc(%eax),%ecx
  80322f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803232:	8b 40 0c             	mov    0xc(%eax),%eax
  803235:	01 c8                	add    %ecx,%eax
  803237:	01 c2                	add    %eax,%edx
  803239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323c:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  803253:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803256:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  80325d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803260:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  803267:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80326b:	75 17                	jne    803284 <insert_sorted_with_merge_freeList+0x39e>
  80326d:	83 ec 04             	sub    $0x4,%esp
  803270:	68 28 42 80 00       	push   $0x804228
  803275:	68 5b 01 00 00       	push   $0x15b
  80327a:	68 b7 41 80 00       	push   $0x8041b7
  80327f:	e8 88 d6 ff ff       	call   80090c <_panic>
  803284:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803287:	8b 00                	mov    (%eax),%eax
  803289:	85 c0                	test   %eax,%eax
  80328b:	74 10                	je     80329d <insert_sorted_with_merge_freeList+0x3b7>
  80328d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803290:	8b 00                	mov    (%eax),%eax
  803292:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803295:	8b 52 04             	mov    0x4(%edx),%edx
  803298:	89 50 04             	mov    %edx,0x4(%eax)
  80329b:	eb 0b                	jmp    8032a8 <insert_sorted_with_merge_freeList+0x3c2>
  80329d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a0:	8b 40 04             	mov    0x4(%eax),%eax
  8032a3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ab:	8b 40 04             	mov    0x4(%eax),%eax
  8032ae:	85 c0                	test   %eax,%eax
  8032b0:	74 0f                	je     8032c1 <insert_sorted_with_merge_freeList+0x3db>
  8032b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b5:	8b 40 04             	mov    0x4(%eax),%eax
  8032b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032bb:	8b 12                	mov    (%edx),%edx
  8032bd:	89 10                	mov    %edx,(%eax)
  8032bf:	eb 0a                	jmp    8032cb <insert_sorted_with_merge_freeList+0x3e5>
  8032c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c4:	8b 00                	mov    (%eax),%eax
  8032c6:	a3 38 51 80 00       	mov    %eax,0x805138
  8032cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032de:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e3:	48                   	dec    %eax
  8032e4:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ed:	75 17                	jne    803306 <insert_sorted_with_merge_freeList+0x420>
  8032ef:	83 ec 04             	sub    $0x4,%esp
  8032f2:	68 94 41 80 00       	push   $0x804194
  8032f7:	68 5c 01 00 00       	push   $0x15c
  8032fc:	68 b7 41 80 00       	push   $0x8041b7
  803301:	e8 06 d6 ff ff       	call   80090c <_panic>
  803306:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	89 10                	mov    %edx,(%eax)
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	8b 00                	mov    (%eax),%eax
  803316:	85 c0                	test   %eax,%eax
  803318:	74 0d                	je     803327 <insert_sorted_with_merge_freeList+0x441>
  80331a:	a1 48 51 80 00       	mov    0x805148,%eax
  80331f:	8b 55 08             	mov    0x8(%ebp),%edx
  803322:	89 50 04             	mov    %edx,0x4(%eax)
  803325:	eb 08                	jmp    80332f <insert_sorted_with_merge_freeList+0x449>
  803327:	8b 45 08             	mov    0x8(%ebp),%eax
  80332a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80332f:	8b 45 08             	mov    0x8(%ebp),%eax
  803332:	a3 48 51 80 00       	mov    %eax,0x805148
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803341:	a1 54 51 80 00       	mov    0x805154,%eax
  803346:	40                   	inc    %eax
  803347:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  80334c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803350:	75 17                	jne    803369 <insert_sorted_with_merge_freeList+0x483>
  803352:	83 ec 04             	sub    $0x4,%esp
  803355:	68 94 41 80 00       	push   $0x804194
  80335a:	68 5d 01 00 00       	push   $0x15d
  80335f:	68 b7 41 80 00       	push   $0x8041b7
  803364:	e8 a3 d5 ff ff       	call   80090c <_panic>
  803369:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80336f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803372:	89 10                	mov    %edx,(%eax)
  803374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803377:	8b 00                	mov    (%eax),%eax
  803379:	85 c0                	test   %eax,%eax
  80337b:	74 0d                	je     80338a <insert_sorted_with_merge_freeList+0x4a4>
  80337d:	a1 48 51 80 00       	mov    0x805148,%eax
  803382:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803385:	89 50 04             	mov    %edx,0x4(%eax)
  803388:	eb 08                	jmp    803392 <insert_sorted_with_merge_freeList+0x4ac>
  80338a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803392:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803395:	a3 48 51 80 00       	mov    %eax,0x805148
  80339a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80339d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a4:	a1 54 51 80 00       	mov    0x805154,%eax
  8033a9:	40                   	inc    %eax
  8033aa:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  8033af:	e9 78 02 00 00       	jmp    80362c <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  8033b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b7:	8b 50 08             	mov    0x8(%eax),%edx
  8033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c0:	01 c2                	add    %eax,%edx
  8033c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c5:	8b 40 08             	mov    0x8(%eax),%eax
  8033c8:	39 c2                	cmp    %eax,%edx
  8033ca:	0f 83 b8 00 00 00    	jae    803488 <insert_sorted_with_merge_freeList+0x5a2>
  8033d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d3:	8b 50 08             	mov    0x8(%eax),%edx
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8033dc:	01 c2                	add    %eax,%edx
  8033de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e1:	8b 40 08             	mov    0x8(%eax),%eax
  8033e4:	39 c2                	cmp    %eax,%edx
  8033e6:	0f 85 9c 00 00 00    	jne    803488 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  8033ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ef:	8b 50 0c             	mov    0xc(%eax),%edx
  8033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f8:	01 c2                	add    %eax,%edx
  8033fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fd:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  803400:	8b 45 08             	mov    0x8(%ebp),%eax
  803403:	8b 50 08             	mov    0x8(%eax),%edx
  803406:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803409:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  80340c:	8b 45 08             	mov    0x8(%ebp),%eax
  80340f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803420:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803424:	75 17                	jne    80343d <insert_sorted_with_merge_freeList+0x557>
  803426:	83 ec 04             	sub    $0x4,%esp
  803429:	68 94 41 80 00       	push   $0x804194
  80342e:	68 67 01 00 00       	push   $0x167
  803433:	68 b7 41 80 00       	push   $0x8041b7
  803438:	e8 cf d4 ff ff       	call   80090c <_panic>
  80343d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803443:	8b 45 08             	mov    0x8(%ebp),%eax
  803446:	89 10                	mov    %edx,(%eax)
  803448:	8b 45 08             	mov    0x8(%ebp),%eax
  80344b:	8b 00                	mov    (%eax),%eax
  80344d:	85 c0                	test   %eax,%eax
  80344f:	74 0d                	je     80345e <insert_sorted_with_merge_freeList+0x578>
  803451:	a1 48 51 80 00       	mov    0x805148,%eax
  803456:	8b 55 08             	mov    0x8(%ebp),%edx
  803459:	89 50 04             	mov    %edx,0x4(%eax)
  80345c:	eb 08                	jmp    803466 <insert_sorted_with_merge_freeList+0x580>
  80345e:	8b 45 08             	mov    0x8(%ebp),%eax
  803461:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803466:	8b 45 08             	mov    0x8(%ebp),%eax
  803469:	a3 48 51 80 00       	mov    %eax,0x805148
  80346e:	8b 45 08             	mov    0x8(%ebp),%eax
  803471:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803478:	a1 54 51 80 00       	mov    0x805154,%eax
  80347d:	40                   	inc    %eax
  80347e:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803483:	e9 a4 01 00 00       	jmp    80362c <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348b:	8b 50 08             	mov    0x8(%eax),%edx
  80348e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803491:	8b 40 0c             	mov    0xc(%eax),%eax
  803494:	01 c2                	add    %eax,%edx
  803496:	8b 45 08             	mov    0x8(%ebp),%eax
  803499:	8b 40 08             	mov    0x8(%eax),%eax
  80349c:	39 c2                	cmp    %eax,%edx
  80349e:	0f 85 ac 00 00 00    	jne    803550 <insert_sorted_with_merge_freeList+0x66a>
  8034a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a7:	8b 50 08             	mov    0x8(%eax),%edx
  8034aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b0:	01 c2                	add    %eax,%edx
  8034b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b5:	8b 40 08             	mov    0x8(%eax),%eax
  8034b8:	39 c2                	cmp    %eax,%edx
  8034ba:	0f 83 90 00 00 00    	jae    803550 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  8034c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c3:	8b 50 0c             	mov    0xc(%eax),%edx
  8034c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8034cc:	01 c2                	add    %eax,%edx
  8034ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d1:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  8034d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ec:	75 17                	jne    803505 <insert_sorted_with_merge_freeList+0x61f>
  8034ee:	83 ec 04             	sub    $0x4,%esp
  8034f1:	68 94 41 80 00       	push   $0x804194
  8034f6:	68 70 01 00 00       	push   $0x170
  8034fb:	68 b7 41 80 00       	push   $0x8041b7
  803500:	e8 07 d4 ff ff       	call   80090c <_panic>
  803505:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80350b:	8b 45 08             	mov    0x8(%ebp),%eax
  80350e:	89 10                	mov    %edx,(%eax)
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	8b 00                	mov    (%eax),%eax
  803515:	85 c0                	test   %eax,%eax
  803517:	74 0d                	je     803526 <insert_sorted_with_merge_freeList+0x640>
  803519:	a1 48 51 80 00       	mov    0x805148,%eax
  80351e:	8b 55 08             	mov    0x8(%ebp),%edx
  803521:	89 50 04             	mov    %edx,0x4(%eax)
  803524:	eb 08                	jmp    80352e <insert_sorted_with_merge_freeList+0x648>
  803526:	8b 45 08             	mov    0x8(%ebp),%eax
  803529:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	a3 48 51 80 00       	mov    %eax,0x805148
  803536:	8b 45 08             	mov    0x8(%ebp),%eax
  803539:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803540:	a1 54 51 80 00       	mov    0x805154,%eax
  803545:	40                   	inc    %eax
  803546:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  80354b:	e9 dc 00 00 00       	jmp    80362c <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803553:	8b 50 08             	mov    0x8(%eax),%edx
  803556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803559:	8b 40 0c             	mov    0xc(%eax),%eax
  80355c:	01 c2                	add    %eax,%edx
  80355e:	8b 45 08             	mov    0x8(%ebp),%eax
  803561:	8b 40 08             	mov    0x8(%eax),%eax
  803564:	39 c2                	cmp    %eax,%edx
  803566:	0f 83 88 00 00 00    	jae    8035f4 <insert_sorted_with_merge_freeList+0x70e>
  80356c:	8b 45 08             	mov    0x8(%ebp),%eax
  80356f:	8b 50 08             	mov    0x8(%eax),%edx
  803572:	8b 45 08             	mov    0x8(%ebp),%eax
  803575:	8b 40 0c             	mov    0xc(%eax),%eax
  803578:	01 c2                	add    %eax,%edx
  80357a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80357d:	8b 40 08             	mov    0x8(%eax),%eax
  803580:	39 c2                	cmp    %eax,%edx
  803582:	73 70                	jae    8035f4 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803584:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803588:	74 06                	je     803590 <insert_sorted_with_merge_freeList+0x6aa>
  80358a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80358e:	75 17                	jne    8035a7 <insert_sorted_with_merge_freeList+0x6c1>
  803590:	83 ec 04             	sub    $0x4,%esp
  803593:	68 f4 41 80 00       	push   $0x8041f4
  803598:	68 75 01 00 00       	push   $0x175
  80359d:	68 b7 41 80 00       	push   $0x8041b7
  8035a2:	e8 65 d3 ff ff       	call   80090c <_panic>
  8035a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035aa:	8b 10                	mov    (%eax),%edx
  8035ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8035af:	89 10                	mov    %edx,(%eax)
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	8b 00                	mov    (%eax),%eax
  8035b6:	85 c0                	test   %eax,%eax
  8035b8:	74 0b                	je     8035c5 <insert_sorted_with_merge_freeList+0x6df>
  8035ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bd:	8b 00                	mov    (%eax),%eax
  8035bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c2:	89 50 04             	mov    %edx,0x4(%eax)
  8035c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8035cb:	89 10                	mov    %edx,(%eax)
  8035cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035d3:	89 50 04             	mov    %edx,0x4(%eax)
  8035d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d9:	8b 00                	mov    (%eax),%eax
  8035db:	85 c0                	test   %eax,%eax
  8035dd:	75 08                	jne    8035e7 <insert_sorted_with_merge_freeList+0x701>
  8035df:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035e7:	a1 44 51 80 00       	mov    0x805144,%eax
  8035ec:	40                   	inc    %eax
  8035ed:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  8035f2:	eb 38                	jmp    80362c <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8035f4:	a1 40 51 80 00       	mov    0x805140,%eax
  8035f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803600:	74 07                	je     803609 <insert_sorted_with_merge_freeList+0x723>
  803602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803605:	8b 00                	mov    (%eax),%eax
  803607:	eb 05                	jmp    80360e <insert_sorted_with_merge_freeList+0x728>
  803609:	b8 00 00 00 00       	mov    $0x0,%eax
  80360e:	a3 40 51 80 00       	mov    %eax,0x805140
  803613:	a1 40 51 80 00       	mov    0x805140,%eax
  803618:	85 c0                	test   %eax,%eax
  80361a:	0f 85 c3 fb ff ff    	jne    8031e3 <insert_sorted_with_merge_freeList+0x2fd>
  803620:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803624:	0f 85 b9 fb ff ff    	jne    8031e3 <insert_sorted_with_merge_freeList+0x2fd>





}
  80362a:	eb 00                	jmp    80362c <insert_sorted_with_merge_freeList+0x746>
  80362c:	90                   	nop
  80362d:	c9                   	leave  
  80362e:	c3                   	ret    
  80362f:	90                   	nop

00803630 <__udivdi3>:
  803630:	55                   	push   %ebp
  803631:	57                   	push   %edi
  803632:	56                   	push   %esi
  803633:	53                   	push   %ebx
  803634:	83 ec 1c             	sub    $0x1c,%esp
  803637:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80363b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80363f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803643:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803647:	89 ca                	mov    %ecx,%edx
  803649:	89 f8                	mov    %edi,%eax
  80364b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80364f:	85 f6                	test   %esi,%esi
  803651:	75 2d                	jne    803680 <__udivdi3+0x50>
  803653:	39 cf                	cmp    %ecx,%edi
  803655:	77 65                	ja     8036bc <__udivdi3+0x8c>
  803657:	89 fd                	mov    %edi,%ebp
  803659:	85 ff                	test   %edi,%edi
  80365b:	75 0b                	jne    803668 <__udivdi3+0x38>
  80365d:	b8 01 00 00 00       	mov    $0x1,%eax
  803662:	31 d2                	xor    %edx,%edx
  803664:	f7 f7                	div    %edi
  803666:	89 c5                	mov    %eax,%ebp
  803668:	31 d2                	xor    %edx,%edx
  80366a:	89 c8                	mov    %ecx,%eax
  80366c:	f7 f5                	div    %ebp
  80366e:	89 c1                	mov    %eax,%ecx
  803670:	89 d8                	mov    %ebx,%eax
  803672:	f7 f5                	div    %ebp
  803674:	89 cf                	mov    %ecx,%edi
  803676:	89 fa                	mov    %edi,%edx
  803678:	83 c4 1c             	add    $0x1c,%esp
  80367b:	5b                   	pop    %ebx
  80367c:	5e                   	pop    %esi
  80367d:	5f                   	pop    %edi
  80367e:	5d                   	pop    %ebp
  80367f:	c3                   	ret    
  803680:	39 ce                	cmp    %ecx,%esi
  803682:	77 28                	ja     8036ac <__udivdi3+0x7c>
  803684:	0f bd fe             	bsr    %esi,%edi
  803687:	83 f7 1f             	xor    $0x1f,%edi
  80368a:	75 40                	jne    8036cc <__udivdi3+0x9c>
  80368c:	39 ce                	cmp    %ecx,%esi
  80368e:	72 0a                	jb     80369a <__udivdi3+0x6a>
  803690:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803694:	0f 87 9e 00 00 00    	ja     803738 <__udivdi3+0x108>
  80369a:	b8 01 00 00 00       	mov    $0x1,%eax
  80369f:	89 fa                	mov    %edi,%edx
  8036a1:	83 c4 1c             	add    $0x1c,%esp
  8036a4:	5b                   	pop    %ebx
  8036a5:	5e                   	pop    %esi
  8036a6:	5f                   	pop    %edi
  8036a7:	5d                   	pop    %ebp
  8036a8:	c3                   	ret    
  8036a9:	8d 76 00             	lea    0x0(%esi),%esi
  8036ac:	31 ff                	xor    %edi,%edi
  8036ae:	31 c0                	xor    %eax,%eax
  8036b0:	89 fa                	mov    %edi,%edx
  8036b2:	83 c4 1c             	add    $0x1c,%esp
  8036b5:	5b                   	pop    %ebx
  8036b6:	5e                   	pop    %esi
  8036b7:	5f                   	pop    %edi
  8036b8:	5d                   	pop    %ebp
  8036b9:	c3                   	ret    
  8036ba:	66 90                	xchg   %ax,%ax
  8036bc:	89 d8                	mov    %ebx,%eax
  8036be:	f7 f7                	div    %edi
  8036c0:	31 ff                	xor    %edi,%edi
  8036c2:	89 fa                	mov    %edi,%edx
  8036c4:	83 c4 1c             	add    $0x1c,%esp
  8036c7:	5b                   	pop    %ebx
  8036c8:	5e                   	pop    %esi
  8036c9:	5f                   	pop    %edi
  8036ca:	5d                   	pop    %ebp
  8036cb:	c3                   	ret    
  8036cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036d1:	89 eb                	mov    %ebp,%ebx
  8036d3:	29 fb                	sub    %edi,%ebx
  8036d5:	89 f9                	mov    %edi,%ecx
  8036d7:	d3 e6                	shl    %cl,%esi
  8036d9:	89 c5                	mov    %eax,%ebp
  8036db:	88 d9                	mov    %bl,%cl
  8036dd:	d3 ed                	shr    %cl,%ebp
  8036df:	89 e9                	mov    %ebp,%ecx
  8036e1:	09 f1                	or     %esi,%ecx
  8036e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036e7:	89 f9                	mov    %edi,%ecx
  8036e9:	d3 e0                	shl    %cl,%eax
  8036eb:	89 c5                	mov    %eax,%ebp
  8036ed:	89 d6                	mov    %edx,%esi
  8036ef:	88 d9                	mov    %bl,%cl
  8036f1:	d3 ee                	shr    %cl,%esi
  8036f3:	89 f9                	mov    %edi,%ecx
  8036f5:	d3 e2                	shl    %cl,%edx
  8036f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036fb:	88 d9                	mov    %bl,%cl
  8036fd:	d3 e8                	shr    %cl,%eax
  8036ff:	09 c2                	or     %eax,%edx
  803701:	89 d0                	mov    %edx,%eax
  803703:	89 f2                	mov    %esi,%edx
  803705:	f7 74 24 0c          	divl   0xc(%esp)
  803709:	89 d6                	mov    %edx,%esi
  80370b:	89 c3                	mov    %eax,%ebx
  80370d:	f7 e5                	mul    %ebp
  80370f:	39 d6                	cmp    %edx,%esi
  803711:	72 19                	jb     80372c <__udivdi3+0xfc>
  803713:	74 0b                	je     803720 <__udivdi3+0xf0>
  803715:	89 d8                	mov    %ebx,%eax
  803717:	31 ff                	xor    %edi,%edi
  803719:	e9 58 ff ff ff       	jmp    803676 <__udivdi3+0x46>
  80371e:	66 90                	xchg   %ax,%ax
  803720:	8b 54 24 08          	mov    0x8(%esp),%edx
  803724:	89 f9                	mov    %edi,%ecx
  803726:	d3 e2                	shl    %cl,%edx
  803728:	39 c2                	cmp    %eax,%edx
  80372a:	73 e9                	jae    803715 <__udivdi3+0xe5>
  80372c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80372f:	31 ff                	xor    %edi,%edi
  803731:	e9 40 ff ff ff       	jmp    803676 <__udivdi3+0x46>
  803736:	66 90                	xchg   %ax,%ax
  803738:	31 c0                	xor    %eax,%eax
  80373a:	e9 37 ff ff ff       	jmp    803676 <__udivdi3+0x46>
  80373f:	90                   	nop

00803740 <__umoddi3>:
  803740:	55                   	push   %ebp
  803741:	57                   	push   %edi
  803742:	56                   	push   %esi
  803743:	53                   	push   %ebx
  803744:	83 ec 1c             	sub    $0x1c,%esp
  803747:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80374b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80374f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803753:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803757:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80375b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80375f:	89 f3                	mov    %esi,%ebx
  803761:	89 fa                	mov    %edi,%edx
  803763:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803767:	89 34 24             	mov    %esi,(%esp)
  80376a:	85 c0                	test   %eax,%eax
  80376c:	75 1a                	jne    803788 <__umoddi3+0x48>
  80376e:	39 f7                	cmp    %esi,%edi
  803770:	0f 86 a2 00 00 00    	jbe    803818 <__umoddi3+0xd8>
  803776:	89 c8                	mov    %ecx,%eax
  803778:	89 f2                	mov    %esi,%edx
  80377a:	f7 f7                	div    %edi
  80377c:	89 d0                	mov    %edx,%eax
  80377e:	31 d2                	xor    %edx,%edx
  803780:	83 c4 1c             	add    $0x1c,%esp
  803783:	5b                   	pop    %ebx
  803784:	5e                   	pop    %esi
  803785:	5f                   	pop    %edi
  803786:	5d                   	pop    %ebp
  803787:	c3                   	ret    
  803788:	39 f0                	cmp    %esi,%eax
  80378a:	0f 87 ac 00 00 00    	ja     80383c <__umoddi3+0xfc>
  803790:	0f bd e8             	bsr    %eax,%ebp
  803793:	83 f5 1f             	xor    $0x1f,%ebp
  803796:	0f 84 ac 00 00 00    	je     803848 <__umoddi3+0x108>
  80379c:	bf 20 00 00 00       	mov    $0x20,%edi
  8037a1:	29 ef                	sub    %ebp,%edi
  8037a3:	89 fe                	mov    %edi,%esi
  8037a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037a9:	89 e9                	mov    %ebp,%ecx
  8037ab:	d3 e0                	shl    %cl,%eax
  8037ad:	89 d7                	mov    %edx,%edi
  8037af:	89 f1                	mov    %esi,%ecx
  8037b1:	d3 ef                	shr    %cl,%edi
  8037b3:	09 c7                	or     %eax,%edi
  8037b5:	89 e9                	mov    %ebp,%ecx
  8037b7:	d3 e2                	shl    %cl,%edx
  8037b9:	89 14 24             	mov    %edx,(%esp)
  8037bc:	89 d8                	mov    %ebx,%eax
  8037be:	d3 e0                	shl    %cl,%eax
  8037c0:	89 c2                	mov    %eax,%edx
  8037c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037c6:	d3 e0                	shl    %cl,%eax
  8037c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037d0:	89 f1                	mov    %esi,%ecx
  8037d2:	d3 e8                	shr    %cl,%eax
  8037d4:	09 d0                	or     %edx,%eax
  8037d6:	d3 eb                	shr    %cl,%ebx
  8037d8:	89 da                	mov    %ebx,%edx
  8037da:	f7 f7                	div    %edi
  8037dc:	89 d3                	mov    %edx,%ebx
  8037de:	f7 24 24             	mull   (%esp)
  8037e1:	89 c6                	mov    %eax,%esi
  8037e3:	89 d1                	mov    %edx,%ecx
  8037e5:	39 d3                	cmp    %edx,%ebx
  8037e7:	0f 82 87 00 00 00    	jb     803874 <__umoddi3+0x134>
  8037ed:	0f 84 91 00 00 00    	je     803884 <__umoddi3+0x144>
  8037f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037f7:	29 f2                	sub    %esi,%edx
  8037f9:	19 cb                	sbb    %ecx,%ebx
  8037fb:	89 d8                	mov    %ebx,%eax
  8037fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803801:	d3 e0                	shl    %cl,%eax
  803803:	89 e9                	mov    %ebp,%ecx
  803805:	d3 ea                	shr    %cl,%edx
  803807:	09 d0                	or     %edx,%eax
  803809:	89 e9                	mov    %ebp,%ecx
  80380b:	d3 eb                	shr    %cl,%ebx
  80380d:	89 da                	mov    %ebx,%edx
  80380f:	83 c4 1c             	add    $0x1c,%esp
  803812:	5b                   	pop    %ebx
  803813:	5e                   	pop    %esi
  803814:	5f                   	pop    %edi
  803815:	5d                   	pop    %ebp
  803816:	c3                   	ret    
  803817:	90                   	nop
  803818:	89 fd                	mov    %edi,%ebp
  80381a:	85 ff                	test   %edi,%edi
  80381c:	75 0b                	jne    803829 <__umoddi3+0xe9>
  80381e:	b8 01 00 00 00       	mov    $0x1,%eax
  803823:	31 d2                	xor    %edx,%edx
  803825:	f7 f7                	div    %edi
  803827:	89 c5                	mov    %eax,%ebp
  803829:	89 f0                	mov    %esi,%eax
  80382b:	31 d2                	xor    %edx,%edx
  80382d:	f7 f5                	div    %ebp
  80382f:	89 c8                	mov    %ecx,%eax
  803831:	f7 f5                	div    %ebp
  803833:	89 d0                	mov    %edx,%eax
  803835:	e9 44 ff ff ff       	jmp    80377e <__umoddi3+0x3e>
  80383a:	66 90                	xchg   %ax,%ax
  80383c:	89 c8                	mov    %ecx,%eax
  80383e:	89 f2                	mov    %esi,%edx
  803840:	83 c4 1c             	add    $0x1c,%esp
  803843:	5b                   	pop    %ebx
  803844:	5e                   	pop    %esi
  803845:	5f                   	pop    %edi
  803846:	5d                   	pop    %ebp
  803847:	c3                   	ret    
  803848:	3b 04 24             	cmp    (%esp),%eax
  80384b:	72 06                	jb     803853 <__umoddi3+0x113>
  80384d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803851:	77 0f                	ja     803862 <__umoddi3+0x122>
  803853:	89 f2                	mov    %esi,%edx
  803855:	29 f9                	sub    %edi,%ecx
  803857:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80385b:	89 14 24             	mov    %edx,(%esp)
  80385e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803862:	8b 44 24 04          	mov    0x4(%esp),%eax
  803866:	8b 14 24             	mov    (%esp),%edx
  803869:	83 c4 1c             	add    $0x1c,%esp
  80386c:	5b                   	pop    %ebx
  80386d:	5e                   	pop    %esi
  80386e:	5f                   	pop    %edi
  80386f:	5d                   	pop    %ebp
  803870:	c3                   	ret    
  803871:	8d 76 00             	lea    0x0(%esi),%esi
  803874:	2b 04 24             	sub    (%esp),%eax
  803877:	19 fa                	sbb    %edi,%edx
  803879:	89 d1                	mov    %edx,%ecx
  80387b:	89 c6                	mov    %eax,%esi
  80387d:	e9 71 ff ff ff       	jmp    8037f3 <__umoddi3+0xb3>
  803882:	66 90                	xchg   %ax,%ax
  803884:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803888:	72 ea                	jb     803874 <__umoddi3+0x134>
  80388a:	89 d9                	mov    %ebx,%ecx
  80388c:	e9 62 ff ff ff       	jmp    8037f3 <__umoddi3+0xb3>
