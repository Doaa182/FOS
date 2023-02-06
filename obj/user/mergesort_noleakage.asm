
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 8f 07 00 00       	call   8007c5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_disable_interrupt();
  800041:	e8 1a 22 00 00       	call   802260 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 3a 80 00       	push   $0x803aa0
  80004e:	e8 62 0b 00 00       	call   800bb5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 3a 80 00       	push   $0x803aa2
  80005e:	e8 52 0b 00 00       	call   800bb5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 b8 3a 80 00       	push   $0x803ab8
  80006e:	e8 42 0b 00 00       	call   800bb5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 3a 80 00       	push   $0x803aa2
  80007e:	e8 32 0b 00 00       	call   800bb5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 3a 80 00       	push   $0x803aa0
  80008e:	e8 22 0b 00 00       	call   800bb5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 d0 3a 80 00       	push   $0x803ad0
  8000a5:	e8 8d 11 00 00       	call   801237 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 dd 16 00 00       	call   80179d <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 5f 1c 00 00       	call   801d34 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 f0 3a 80 00       	push   $0x803af0
  8000e3:	e8 cd 0a 00 00       	call   800bb5 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 12 3b 80 00       	push   $0x803b12
  8000f3:	e8 bd 0a 00 00       	call   800bb5 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 20 3b 80 00       	push   $0x803b20
  800103:	e8 ad 0a 00 00       	call   800bb5 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 2f 3b 80 00       	push   $0x803b2f
  800113:	e8 9d 0a 00 00       	call   800bb5 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 3f 3b 80 00       	push   $0x803b3f
  800123:	e8 8d 0a 00 00       	call   800bb5 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 3d 06 00 00       	call   80076d <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 e5 05 00 00       	call   800725 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 d8 05 00 00       	call   800725 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 13 21 00 00       	call   80227a <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 f4 01 00 00       	call   80037c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 12 02 00 00       	call   8003ad <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 34 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 21 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 e0 02 00 00       	call   8004b4 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 84 20 00 00       	call   802260 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 48 3b 80 00       	push   $0x803b48
  8001e4:	e8 cc 09 00 00       	call   800bb5 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 89 20 00 00       	call   80227a <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 d3 00 00 00       	call   8002d2 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 7c 3b 80 00       	push   $0x803b7c
  800213:	6a 4a                	push   $0x4a
  800215:	68 9e 3b 80 00       	push   $0x803b9e
  80021a:	e8 e2 06 00 00       	call   800901 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 3c 20 00 00       	call   802260 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 bc 3b 80 00       	push   $0x803bbc
  80022c:	e8 84 09 00 00       	call   800bb5 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 f0 3b 80 00       	push   $0x803bf0
  80023c:	e8 74 09 00 00       	call   800bb5 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 24 3c 80 00       	push   $0x803c24
  80024c:	e8 64 09 00 00       	call   800bb5 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 21 20 00 00       	call   80227a <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 67 1b 00 00       	call   801dcb <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 f4 1f 00 00       	call   802260 <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 56 3c 80 00       	push   $0x803c56
  80027a:	e8 36 09 00 00       	call   800bb5 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800282:	e8 e6 04 00 00       	call   80076d <getchar>
  800287:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80028a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	e8 8e 04 00 00       	call   800725 <cputchar>
  800297:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	6a 0a                	push   $0xa
  80029f:	e8 81 04 00 00       	call   800725 <cputchar>
  8002a4:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a7:	83 ec 0c             	sub    $0xc,%esp
  8002aa:	6a 0a                	push   $0xa
  8002ac:	e8 74 04 00 00       	call   800725 <cputchar>
  8002b1:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b8:	74 06                	je     8002c0 <_main+0x288>
  8002ba:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002be:	75 b2                	jne    800272 <_main+0x23a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002c0:	e8 b5 1f 00 00       	call   80227a <sys_enable_interrupt>

	} while (Chose == 'y');
  8002c5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c9:	0f 84 72 fd ff ff    	je     800041 <_main+0x9>

}
  8002cf:	90                   	nop
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002e6:	eb 33                	jmp    80031b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	8b 10                	mov    (%eax),%edx
  8002f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002fc:	40                   	inc    %eax
  8002fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	01 c8                	add    %ecx,%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	39 c2                	cmp    %eax,%edx
  80030d:	7e 09                	jle    800318 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80030f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800316:	eb 0c                	jmp    800324 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800318:	ff 45 f8             	incl   -0x8(%ebp)
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	48                   	dec    %eax
  80031f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800322:	7f c4                	jg     8002e8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800324:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	01 d0                	add    %edx,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
  800346:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	01 c2                	add    %eax,%edx
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	01 c8                	add    %ecx,%eax
  800361:	8b 00                	mov    (%eax),%eax
  800363:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800365:	8b 45 10             	mov    0x10(%ebp),%eax
  800368:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	01 c2                	add    %eax,%edx
  800374:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800377:	89 02                	mov    %eax,(%edx)
}
  800379:	90                   	nop
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800389:	eb 17                	jmp    8003a2 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80038b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 c2                	add    %eax,%edx
  80039a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80039f:	ff 45 fc             	incl   -0x4(%ebp)
  8003a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003a8:	7c e1                	jl     80038b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003aa:	90                   	nop
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ba:	eb 1b                	jmp    8003d7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	01 c2                	add    %eax,%edx
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ce:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003d1:	48                   	dec    %eax
  8003d2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003d4:	ff 45 fc             	incl   -0x4(%ebp)
  8003d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003dd:	7c dd                	jl     8003bc <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003df:	90                   	nop
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003f0:	f7 e9                	imul   %ecx
  8003f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	29 c8                	sub    %ecx,%eax
  8003f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800403:	eb 1e                	jmp    800423 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800408:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	99                   	cltd   
  800419:	f7 7d f8             	idivl  -0x8(%ebp)
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 fc             	incl   -0x4(%ebp)
  800423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	7c da                	jl     800405 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
			//cprintf("i=%d\n",i);
	}

}
  80042b:	90                   	nop
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800434:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800442:	eb 42                	jmp    800486 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800447:	99                   	cltd   
  800448:	f7 7d f0             	idivl  -0x10(%ebp)
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	85 c0                	test   %eax,%eax
  80044f:	75 10                	jne    800461 <PrintElements+0x33>
			cprintf("\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 a0 3a 80 00       	push   $0x803aa0
  800459:	e8 57 07 00 00       	call   800bb5 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800464:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 d0                	add    %edx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	50                   	push   %eax
  800476:	68 74 3c 80 00       	push   $0x803c74
  80047b:	e8 35 07 00 00       	call   800bb5 <cprintf>
  800480:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800483:	ff 45 f4             	incl   -0xc(%ebp)
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
  800489:	48                   	dec    %eax
  80048a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80048d:	7f b5                	jg     800444 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	01 d0                	add    %edx,%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 79 3c 80 00       	push   $0x803c79
  8004a9:	e8 07 07 00 00       	call   800bb5 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp

}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c0:	7d 54                	jge    800516 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	89 c2                	mov    %eax,%edx
  8004cc:	c1 ea 1f             	shr    $0x1f,%edx
  8004cf:	01 d0                	add    %edx,%eax
  8004d1:	d1 f8                	sar    %eax
  8004d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004dc:	ff 75 0c             	pushl  0xc(%ebp)
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	e8 cd ff ff ff       	call   8004b4 <MSort>
  8004e7:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ed:	40                   	inc    %eax
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	ff 75 10             	pushl  0x10(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	ff 75 08             	pushl  0x8(%ebp)
  8004f8:	e8 b7 ff ff ff       	call   8004b4 <MSort>
  8004fd:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800500:	ff 75 10             	pushl  0x10(%ebp)
  800503:	ff 75 f4             	pushl  -0xc(%ebp)
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	e8 08 00 00 00       	call   800519 <Merge>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	eb 01                	jmp    800517 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800516:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80051f:	8b 45 10             	mov    0x10(%ebp),%eax
  800522:	2b 45 0c             	sub    0xc(%ebp),%eax
  800525:	40                   	inc    %eax
  800526:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	2b 45 10             	sub    0x10(%ebp),%eax
  80052f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800532:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800543:	c1 e0 02             	shl    $0x2,%eax
  800546:	83 ec 0c             	sub    $0xc,%esp
  800549:	50                   	push   %eax
  80054a:	e8 e5 17 00 00       	call   801d34 <malloc>
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  800555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800558:	c1 e0 02             	shl    $0x2,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 d0 17 00 00       	call   801d34 <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800571:	eb 2f                	jmp    8005a2 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800576:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800580:	01 c2                	add    %eax,%edx
  800582:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800588:	01 c8                	add    %ecx,%eax
  80058a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80058f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80059f:	ff 45 ec             	incl   -0x14(%ebp)
  8005a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005a8:	7c c9                	jl     800573 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b1:	eb 2a                	jmp    8005dd <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c0:	01 c2                	add    %eax,%edx
  8005c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	01 c8                	add    %ecx,%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e3:	7c ce                	jl     8005b3 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005eb:	e9 0a 01 00 00       	jmp    8006fa <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005f6:	0f 8d 95 00 00 00    	jge    800691 <Merge+0x178>
  8005fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ff:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800602:	0f 8d 89 00 00 00    	jge    800691 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800612:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800615:	01 d0                	add    %edx,%eax
  800617:	8b 10                	mov    (%eax),%edx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800626:	01 c8                	add    %ecx,%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	7d 33                	jge    800661 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80062e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800631:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800636:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800646:	8d 50 01             	lea    0x1(%eax),%edx
  800649:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80064c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800653:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800656:	01 d0                	add    %edx,%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80065c:	e9 96 00 00 00       	jmp    8006f7 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800664:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800669:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800679:	8d 50 01             	lea    0x1(%eax),%edx
  80067c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80067f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800689:	01 d0                	add    %edx,%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80068f:	eb 66                	jmp    8006f7 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800694:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800697:	7d 30                	jge    8006c9 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b1:	8d 50 01             	lea    0x1(%eax),%edx
  8006b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c1:	01 d0                	add    %edx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 01                	mov    %eax,(%ecx)
  8006c7:	eb 2e                	jmp    8006f7 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006cc:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e1:	8d 50 01             	lea    0x1(%eax),%edx
  8006e4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f1:	01 d0                	add    %edx,%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006f7:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  800700:	0f 8e ea fe ff ff    	jle    8005f0 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d8             	pushl  -0x28(%ebp)
  80070c:	e8 ba 16 00 00       	call   801dcb <free>
  800711:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071a:	e8 ac 16 00 00       	call   801dcb <free>
  80071f:	83 c4 10             	add    $0x10,%esp

}
  800722:	90                   	nop
  800723:	c9                   	leave  
  800724:	c3                   	ret    

00800725 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800731:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	50                   	push   %eax
  800739:	e8 56 1b 00 00       	call   802294 <sys_cputc>
  80073e:	83 c4 10             	add    $0x10,%esp
}
  800741:	90                   	nop
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80074a:	e8 11 1b 00 00       	call   802260 <sys_disable_interrupt>
	char c = ch;
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800755:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800759:	83 ec 0c             	sub    $0xc,%esp
  80075c:	50                   	push   %eax
  80075d:	e8 32 1b 00 00       	call   802294 <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 10 1b 00 00       	call   80227a <sys_enable_interrupt>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <getchar>:

int
getchar(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80077a:	eb 08                	jmp    800784 <getchar+0x17>
	{
		c = sys_cgetc();
  80077c:	e8 5a 19 00 00       	call   8020db <sys_cgetc>
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800788:	74 f2                	je     80077c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <atomic_getchar>:

int
atomic_getchar(void)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800795:	e8 c6 1a 00 00       	call   802260 <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 33 19 00 00       	call   8020db <sys_cgetc>
  8007a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007af:	74 f2                	je     8007a3 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007b1:	e8 c4 1a 00 00       	call   80227a <sys_enable_interrupt>
	return c;
  8007b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <iscons>:

int iscons(int fdnum)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007cb:	e8 83 1c 00 00       	call   802453 <sys_getenvindex>
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d6:	89 d0                	mov    %edx,%eax
  8007d8:	c1 e0 03             	shl    $0x3,%eax
  8007db:	01 d0                	add    %edx,%eax
  8007dd:	01 c0                	add    %eax,%eax
  8007df:	01 d0                	add    %edx,%eax
  8007e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007e8:	01 d0                	add    %edx,%eax
  8007ea:	c1 e0 04             	shl    $0x4,%eax
  8007ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007f2:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800802:	84 c0                	test   %al,%al
  800804:	74 0f                	je     800815 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800806:	a1 24 50 80 00       	mov    0x805024,%eax
  80080b:	05 5c 05 00 00       	add    $0x55c,%eax
  800810:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800815:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800819:	7e 0a                	jle    800825 <libmain+0x60>
		binaryname = argv[0];
  80081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	ff 75 08             	pushl  0x8(%ebp)
  80082e:	e8 05 f8 ff ff       	call   800038 <_main>
  800833:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800836:	e8 25 1a 00 00       	call   802260 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80083b:	83 ec 0c             	sub    $0xc,%esp
  80083e:	68 98 3c 80 00       	push   $0x803c98
  800843:	e8 6d 03 00 00       	call   800bb5 <cprintf>
  800848:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80084b:	a1 24 50 80 00       	mov    0x805024,%eax
  800850:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800856:	a1 24 50 80 00       	mov    0x805024,%eax
  80085b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800861:	83 ec 04             	sub    $0x4,%esp
  800864:	52                   	push   %edx
  800865:	50                   	push   %eax
  800866:	68 c0 3c 80 00       	push   $0x803cc0
  80086b:	e8 45 03 00 00       	call   800bb5 <cprintf>
  800870:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800873:	a1 24 50 80 00       	mov    0x805024,%eax
  800878:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80087e:	a1 24 50 80 00       	mov    0x805024,%eax
  800883:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800889:	a1 24 50 80 00       	mov    0x805024,%eax
  80088e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800894:	51                   	push   %ecx
  800895:	52                   	push   %edx
  800896:	50                   	push   %eax
  800897:	68 e8 3c 80 00       	push   $0x803ce8
  80089c:	e8 14 03 00 00       	call   800bb5 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008a9:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	50                   	push   %eax
  8008b3:	68 40 3d 80 00       	push   $0x803d40
  8008b8:	e8 f8 02 00 00       	call   800bb5 <cprintf>
  8008bd:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	68 98 3c 80 00       	push   $0x803c98
  8008c8:	e8 e8 02 00 00       	call   800bb5 <cprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008d0:	e8 a5 19 00 00       	call   80227a <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008d5:	e8 19 00 00 00       	call   8008f3 <exit>
}
  8008da:	90                   	nop
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008e3:	83 ec 0c             	sub    $0xc,%esp
  8008e6:	6a 00                	push   $0x0
  8008e8:	e8 32 1b 00 00       	call   80241f <sys_destroy_env>
  8008ed:	83 c4 10             	add    $0x10,%esp
}
  8008f0:	90                   	nop
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <exit>:

void
exit(void)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008f9:	e8 87 1b 00 00       	call   802485 <sys_exit_env>
}
  8008fe:	90                   	nop
  8008ff:	c9                   	leave  
  800900:	c3                   	ret    

00800901 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800907:	8d 45 10             	lea    0x10(%ebp),%eax
  80090a:	83 c0 04             	add    $0x4,%eax
  80090d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800910:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800915:	85 c0                	test   %eax,%eax
  800917:	74 16                	je     80092f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800919:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	50                   	push   %eax
  800922:	68 54 3d 80 00       	push   $0x803d54
  800927:	e8 89 02 00 00       	call   800bb5 <cprintf>
  80092c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80092f:	a1 00 50 80 00       	mov    0x805000,%eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	50                   	push   %eax
  80093b:	68 59 3d 80 00       	push   $0x803d59
  800940:	e8 70 02 00 00       	call   800bb5 <cprintf>
  800945:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 f4             	pushl  -0xc(%ebp)
  800951:	50                   	push   %eax
  800952:	e8 f3 01 00 00       	call   800b4a <vcprintf>
  800957:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	6a 00                	push   $0x0
  80095f:	68 75 3d 80 00       	push   $0x803d75
  800964:	e8 e1 01 00 00       	call   800b4a <vcprintf>
  800969:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80096c:	e8 82 ff ff ff       	call   8008f3 <exit>

	// should not return here
	while (1) ;
  800971:	eb fe                	jmp    800971 <_panic+0x70>

00800973 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800979:	a1 24 50 80 00       	mov    0x805024,%eax
  80097e:	8b 50 74             	mov    0x74(%eax),%edx
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	39 c2                	cmp    %eax,%edx
  800986:	74 14                	je     80099c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 78 3d 80 00       	push   $0x803d78
  800990:	6a 26                	push   $0x26
  800992:	68 c4 3d 80 00       	push   $0x803dc4
  800997:	e8 65 ff ff ff       	call   800901 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80099c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009aa:	e9 c2 00 00 00       	jmp    800a71 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	01 d0                	add    %edx,%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	85 c0                	test   %eax,%eax
  8009c2:	75 08                	jne    8009cc <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009c4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009c7:	e9 a2 00 00 00       	jmp    800a6e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009da:	eb 69                	jmp    800a45 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009dc:	a1 24 50 80 00       	mov    0x805024,%eax
  8009e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ea:	89 d0                	mov    %edx,%eax
  8009ec:	01 c0                	add    %eax,%eax
  8009ee:	01 d0                	add    %edx,%eax
  8009f0:	c1 e0 03             	shl    $0x3,%eax
  8009f3:	01 c8                	add    %ecx,%eax
  8009f5:	8a 40 04             	mov    0x4(%eax),%al
  8009f8:	84 c0                	test   %al,%al
  8009fa:	75 46                	jne    800a42 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009fc:	a1 24 50 80 00       	mov    0x805024,%eax
  800a01:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	01 c0                	add    %eax,%eax
  800a0e:	01 d0                	add    %edx,%eax
  800a10:	c1 e0 03             	shl    $0x3,%eax
  800a13:	01 c8                	add    %ecx,%eax
  800a15:	8b 00                	mov    (%eax),%eax
  800a17:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a22:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a27:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	01 c8                	add    %ecx,%eax
  800a33:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a35:	39 c2                	cmp    %eax,%edx
  800a37:	75 09                	jne    800a42 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a39:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a40:	eb 12                	jmp    800a54 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a42:	ff 45 e8             	incl   -0x18(%ebp)
  800a45:	a1 24 50 80 00       	mov    0x805024,%eax
  800a4a:	8b 50 74             	mov    0x74(%eax),%edx
  800a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a50:	39 c2                	cmp    %eax,%edx
  800a52:	77 88                	ja     8009dc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a58:	75 14                	jne    800a6e <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a5a:	83 ec 04             	sub    $0x4,%esp
  800a5d:	68 d0 3d 80 00       	push   $0x803dd0
  800a62:	6a 3a                	push   $0x3a
  800a64:	68 c4 3d 80 00       	push   $0x803dc4
  800a69:	e8 93 fe ff ff       	call   800901 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a6e:	ff 45 f0             	incl   -0x10(%ebp)
  800a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a74:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a77:	0f 8c 32 ff ff ff    	jl     8009af <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a84:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a8b:	eb 26                	jmp    800ab3 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a8d:	a1 24 50 80 00       	mov    0x805024,%eax
  800a92:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a9b:	89 d0                	mov    %edx,%eax
  800a9d:	01 c0                	add    %eax,%eax
  800a9f:	01 d0                	add    %edx,%eax
  800aa1:	c1 e0 03             	shl    $0x3,%eax
  800aa4:	01 c8                	add    %ecx,%eax
  800aa6:	8a 40 04             	mov    0x4(%eax),%al
  800aa9:	3c 01                	cmp    $0x1,%al
  800aab:	75 03                	jne    800ab0 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800aad:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ab0:	ff 45 e0             	incl   -0x20(%ebp)
  800ab3:	a1 24 50 80 00       	mov    0x805024,%eax
  800ab8:	8b 50 74             	mov    0x74(%eax),%edx
  800abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800abe:	39 c2                	cmp    %eax,%edx
  800ac0:	77 cb                	ja     800a8d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ac5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ac8:	74 14                	je     800ade <CheckWSWithoutLastIndex+0x16b>
		panic(
  800aca:	83 ec 04             	sub    $0x4,%esp
  800acd:	68 24 3e 80 00       	push   $0x803e24
  800ad2:	6a 44                	push   $0x44
  800ad4:	68 c4 3d 80 00       	push   $0x803dc4
  800ad9:	e8 23 fe ff ff       	call   800901 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ade:	90                   	nop
  800adf:	c9                   	leave  
  800ae0:	c3                   	ret    

00800ae1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	8b 00                	mov    (%eax),%eax
  800aec:	8d 48 01             	lea    0x1(%eax),%ecx
  800aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af2:	89 0a                	mov    %ecx,(%edx)
  800af4:	8b 55 08             	mov    0x8(%ebp),%edx
  800af7:	88 d1                	mov    %dl,%cl
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b0a:	75 2c                	jne    800b38 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b0c:	a0 28 50 80 00       	mov    0x805028,%al
  800b11:	0f b6 c0             	movzbl %al,%eax
  800b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b17:	8b 12                	mov    (%edx),%edx
  800b19:	89 d1                	mov    %edx,%ecx
  800b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1e:	83 c2 08             	add    $0x8,%edx
  800b21:	83 ec 04             	sub    $0x4,%esp
  800b24:	50                   	push   %eax
  800b25:	51                   	push   %ecx
  800b26:	52                   	push   %edx
  800b27:	e8 86 15 00 00       	call   8020b2 <sys_cputs>
  800b2c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	8b 40 04             	mov    0x4(%eax),%eax
  800b3e:	8d 50 01             	lea    0x1(%eax),%edx
  800b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b44:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b47:	90                   	nop
  800b48:	c9                   	leave  
  800b49:	c3                   	ret    

00800b4a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b53:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b5a:	00 00 00 
	b.cnt = 0;
  800b5d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b64:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	ff 75 08             	pushl  0x8(%ebp)
  800b6d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 e1 0a 80 00       	push   $0x800ae1
  800b79:	e8 11 02 00 00       	call   800d8f <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b81:	a0 28 50 80 00       	mov    0x805028,%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	50                   	push   %eax
  800b93:	52                   	push   %edx
  800b94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b9a:	83 c0 08             	add    $0x8,%eax
  800b9d:	50                   	push   %eax
  800b9e:	e8 0f 15 00 00       	call   8020b2 <sys_cputs>
  800ba3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ba6:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800bad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bbb:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bc2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	e8 73 ff ff ff       	call   800b4a <vcprintf>
  800bd7:	83 c4 10             	add    $0x10,%esp
  800bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800be8:	e8 73 16 00 00       	call   802260 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bed:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	e8 48 ff ff ff       	call   800b4a <vcprintf>
  800c02:	83 c4 10             	add    $0x10,%esp
  800c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c08:	e8 6d 16 00 00       	call   80227a <sys_enable_interrupt>
	return cnt;
  800c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	53                   	push   %ebx
  800c16:	83 ec 14             	sub    $0x14,%esp
  800c19:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c25:	8b 45 18             	mov    0x18(%ebp),%eax
  800c28:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c30:	77 55                	ja     800c87 <printnum+0x75>
  800c32:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c35:	72 05                	jb     800c3c <printnum+0x2a>
  800c37:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c3a:	77 4b                	ja     800c87 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c3c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c3f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c42:	8b 45 18             	mov    0x18(%ebp),%eax
  800c45:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4a:	52                   	push   %edx
  800c4b:	50                   	push   %eax
  800c4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4f:	ff 75 f0             	pushl  -0x10(%ebp)
  800c52:	e8 d5 2b 00 00       	call   80382c <__udivdi3>
  800c57:	83 c4 10             	add    $0x10,%esp
  800c5a:	83 ec 04             	sub    $0x4,%esp
  800c5d:	ff 75 20             	pushl  0x20(%ebp)
  800c60:	53                   	push   %ebx
  800c61:	ff 75 18             	pushl  0x18(%ebp)
  800c64:	52                   	push   %edx
  800c65:	50                   	push   %eax
  800c66:	ff 75 0c             	pushl  0xc(%ebp)
  800c69:	ff 75 08             	pushl  0x8(%ebp)
  800c6c:	e8 a1 ff ff ff       	call   800c12 <printnum>
  800c71:	83 c4 20             	add    $0x20,%esp
  800c74:	eb 1a                	jmp    800c90 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	ff 75 20             	pushl  0x20(%ebp)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	ff d0                	call   *%eax
  800c84:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c87:	ff 4d 1c             	decl   0x1c(%ebp)
  800c8a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c8e:	7f e6                	jg     800c76 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c90:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c9e:	53                   	push   %ebx
  800c9f:	51                   	push   %ecx
  800ca0:	52                   	push   %edx
  800ca1:	50                   	push   %eax
  800ca2:	e8 95 2c 00 00       	call   80393c <__umoddi3>
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	05 94 40 80 00       	add    $0x804094,%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f be c0             	movsbl %al,%eax
  800cb4:	83 ec 08             	sub    $0x8,%esp
  800cb7:	ff 75 0c             	pushl  0xc(%ebp)
  800cba:	50                   	push   %eax
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	ff d0                	call   *%eax
  800cc0:	83 c4 10             	add    $0x10,%esp
}
  800cc3:	90                   	nop
  800cc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ccc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd0:	7e 1c                	jle    800cee <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8b 00                	mov    (%eax),%eax
  800cd7:	8d 50 08             	lea    0x8(%eax),%edx
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	89 10                	mov    %edx,(%eax)
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8b 00                	mov    (%eax),%eax
  800ce4:	83 e8 08             	sub    $0x8,%eax
  800ce7:	8b 50 04             	mov    0x4(%eax),%edx
  800cea:	8b 00                	mov    (%eax),%eax
  800cec:	eb 40                	jmp    800d2e <getuint+0x65>
	else if (lflag)
  800cee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf2:	74 1e                	je     800d12 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8b 00                	mov    (%eax),%eax
  800cf9:	8d 50 04             	lea    0x4(%eax),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	89 10                	mov    %edx,(%eax)
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 e8 04             	sub    $0x4,%eax
  800d09:	8b 00                	mov    (%eax),%eax
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	eb 1c                	jmp    800d2e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8b 00                	mov    (%eax),%eax
  800d17:	8d 50 04             	lea    0x4(%eax),%edx
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 10                	mov    %edx,(%eax)
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	83 e8 04             	sub    $0x4,%eax
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d33:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d37:	7e 1c                	jle    800d55 <getint+0x25>
		return va_arg(*ap, long long);
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	8d 50 08             	lea    0x8(%eax),%edx
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	89 10                	mov    %edx,(%eax)
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	83 e8 08             	sub    $0x8,%eax
  800d4e:	8b 50 04             	mov    0x4(%eax),%edx
  800d51:	8b 00                	mov    (%eax),%eax
  800d53:	eb 38                	jmp    800d8d <getint+0x5d>
	else if (lflag)
  800d55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d59:	74 1a                	je     800d75 <getint+0x45>
		return va_arg(*ap, long);
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8b 00                	mov    (%eax),%eax
  800d60:	8d 50 04             	lea    0x4(%eax),%edx
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	89 10                	mov    %edx,(%eax)
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8b 00                	mov    (%eax),%eax
  800d6d:	83 e8 04             	sub    $0x4,%eax
  800d70:	8b 00                	mov    (%eax),%eax
  800d72:	99                   	cltd   
  800d73:	eb 18                	jmp    800d8d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 50 04             	lea    0x4(%eax),%edx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	89 10                	mov    %edx,(%eax)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8b 00                	mov    (%eax),%eax
  800d87:	83 e8 04             	sub    $0x4,%eax
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	99                   	cltd   
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d97:	eb 17                	jmp    800db0 <vprintfmt+0x21>
			if (ch == '\0')
  800d99:	85 db                	test   %ebx,%ebx
  800d9b:	0f 84 af 03 00 00    	je     801150 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	53                   	push   %ebx
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	ff d0                	call   *%eax
  800dad:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800db0:	8b 45 10             	mov    0x10(%ebp),%eax
  800db3:	8d 50 01             	lea    0x1(%eax),%edx
  800db6:	89 55 10             	mov    %edx,0x10(%ebp)
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	0f b6 d8             	movzbl %al,%ebx
  800dbe:	83 fb 25             	cmp    $0x25,%ebx
  800dc1:	75 d6                	jne    800d99 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dc3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dc7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dd5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ddc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800de3:	8b 45 10             	mov    0x10(%ebp),%eax
  800de6:	8d 50 01             	lea    0x1(%eax),%edx
  800de9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	0f b6 d8             	movzbl %al,%ebx
  800df1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800df4:	83 f8 55             	cmp    $0x55,%eax
  800df7:	0f 87 2b 03 00 00    	ja     801128 <vprintfmt+0x399>
  800dfd:	8b 04 85 b8 40 80 00 	mov    0x8040b8(,%eax,4),%eax
  800e04:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e06:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e0a:	eb d7                	jmp    800de3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e0c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e10:	eb d1                	jmp    800de3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e12:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e1c:	89 d0                	mov    %edx,%eax
  800e1e:	c1 e0 02             	shl    $0x2,%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	01 d8                	add    %ebx,%eax
  800e27:	83 e8 30             	sub    $0x30,%eax
  800e2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e35:	83 fb 2f             	cmp    $0x2f,%ebx
  800e38:	7e 3e                	jle    800e78 <vprintfmt+0xe9>
  800e3a:	83 fb 39             	cmp    $0x39,%ebx
  800e3d:	7f 39                	jg     800e78 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e3f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e42:	eb d5                	jmp    800e19 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e44:	8b 45 14             	mov    0x14(%ebp),%eax
  800e47:	83 c0 04             	add    $0x4,%eax
  800e4a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e50:	83 e8 04             	sub    $0x4,%eax
  800e53:	8b 00                	mov    (%eax),%eax
  800e55:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e58:	eb 1f                	jmp    800e79 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5e:	79 83                	jns    800de3 <vprintfmt+0x54>
				width = 0;
  800e60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e67:	e9 77 ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e6c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e73:	e9 6b ff ff ff       	jmp    800de3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e78:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7d:	0f 89 60 ff ff ff    	jns    800de3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e90:	e9 4e ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e95:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e98:	e9 46 ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea0:	83 c0 04             	add    $0x4,%eax
  800ea3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea9:	83 e8 04             	sub    $0x4,%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	83 ec 08             	sub    $0x8,%esp
  800eb1:	ff 75 0c             	pushl  0xc(%ebp)
  800eb4:	50                   	push   %eax
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	ff d0                	call   *%eax
  800eba:	83 c4 10             	add    $0x10,%esp
			break;
  800ebd:	e9 89 02 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ec2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec5:	83 c0 04             	add    $0x4,%eax
  800ec8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ecb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ece:	83 e8 04             	sub    $0x4,%eax
  800ed1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ed3:	85 db                	test   %ebx,%ebx
  800ed5:	79 02                	jns    800ed9 <vprintfmt+0x14a>
				err = -err;
  800ed7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ed9:	83 fb 64             	cmp    $0x64,%ebx
  800edc:	7f 0b                	jg     800ee9 <vprintfmt+0x15a>
  800ede:	8b 34 9d 00 3f 80 00 	mov    0x803f00(,%ebx,4),%esi
  800ee5:	85 f6                	test   %esi,%esi
  800ee7:	75 19                	jne    800f02 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ee9:	53                   	push   %ebx
  800eea:	68 a5 40 80 00       	push   $0x8040a5
  800eef:	ff 75 0c             	pushl  0xc(%ebp)
  800ef2:	ff 75 08             	pushl  0x8(%ebp)
  800ef5:	e8 5e 02 00 00       	call   801158 <printfmt>
  800efa:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800efd:	e9 49 02 00 00       	jmp    80114b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f02:	56                   	push   %esi
  800f03:	68 ae 40 80 00       	push   $0x8040ae
  800f08:	ff 75 0c             	pushl  0xc(%ebp)
  800f0b:	ff 75 08             	pushl  0x8(%ebp)
  800f0e:	e8 45 02 00 00       	call   801158 <printfmt>
  800f13:	83 c4 10             	add    $0x10,%esp
			break;
  800f16:	e9 30 02 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1e:	83 c0 04             	add    $0x4,%eax
  800f21:	89 45 14             	mov    %eax,0x14(%ebp)
  800f24:	8b 45 14             	mov    0x14(%ebp),%eax
  800f27:	83 e8 04             	sub    $0x4,%eax
  800f2a:	8b 30                	mov    (%eax),%esi
  800f2c:	85 f6                	test   %esi,%esi
  800f2e:	75 05                	jne    800f35 <vprintfmt+0x1a6>
				p = "(null)";
  800f30:	be b1 40 80 00       	mov    $0x8040b1,%esi
			if (width > 0 && padc != '-')
  800f35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f39:	7e 6d                	jle    800fa8 <vprintfmt+0x219>
  800f3b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f3f:	74 67                	je     800fa8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	83 ec 08             	sub    $0x8,%esp
  800f47:	50                   	push   %eax
  800f48:	56                   	push   %esi
  800f49:	e8 12 05 00 00       	call   801460 <strnlen>
  800f4e:	83 c4 10             	add    $0x10,%esp
  800f51:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f54:	eb 16                	jmp    800f6c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f56:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	50                   	push   %eax
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	ff d0                	call   *%eax
  800f66:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f69:	ff 4d e4             	decl   -0x1c(%ebp)
  800f6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f70:	7f e4                	jg     800f56 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f72:	eb 34                	jmp    800fa8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f74:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f78:	74 1c                	je     800f96 <vprintfmt+0x207>
  800f7a:	83 fb 1f             	cmp    $0x1f,%ebx
  800f7d:	7e 05                	jle    800f84 <vprintfmt+0x1f5>
  800f7f:	83 fb 7e             	cmp    $0x7e,%ebx
  800f82:	7e 12                	jle    800f96 <vprintfmt+0x207>
					putch('?', putdat);
  800f84:	83 ec 08             	sub    $0x8,%esp
  800f87:	ff 75 0c             	pushl  0xc(%ebp)
  800f8a:	6a 3f                	push   $0x3f
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	ff d0                	call   *%eax
  800f91:	83 c4 10             	add    $0x10,%esp
  800f94:	eb 0f                	jmp    800fa5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	53                   	push   %ebx
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	ff d0                	call   *%eax
  800fa2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fa5:	ff 4d e4             	decl   -0x1c(%ebp)
  800fa8:	89 f0                	mov    %esi,%eax
  800faa:	8d 70 01             	lea    0x1(%eax),%esi
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f be d8             	movsbl %al,%ebx
  800fb2:	85 db                	test   %ebx,%ebx
  800fb4:	74 24                	je     800fda <vprintfmt+0x24b>
  800fb6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fba:	78 b8                	js     800f74 <vprintfmt+0x1e5>
  800fbc:	ff 4d e0             	decl   -0x20(%ebp)
  800fbf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc3:	79 af                	jns    800f74 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc5:	eb 13                	jmp    800fda <vprintfmt+0x24b>
				putch(' ', putdat);
  800fc7:	83 ec 08             	sub    $0x8,%esp
  800fca:	ff 75 0c             	pushl  0xc(%ebp)
  800fcd:	6a 20                	push   $0x20
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	ff d0                	call   *%eax
  800fd4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd7:	ff 4d e4             	decl   -0x1c(%ebp)
  800fda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fde:	7f e7                	jg     800fc7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fe0:	e9 66 01 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	ff 75 e8             	pushl  -0x18(%ebp)
  800feb:	8d 45 14             	lea    0x14(%ebp),%eax
  800fee:	50                   	push   %eax
  800fef:	e8 3c fd ff ff       	call   800d30 <getint>
  800ff4:	83 c4 10             	add    $0x10,%esp
  800ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801000:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801003:	85 d2                	test   %edx,%edx
  801005:	79 23                	jns    80102a <vprintfmt+0x29b>
				putch('-', putdat);
  801007:	83 ec 08             	sub    $0x8,%esp
  80100a:	ff 75 0c             	pushl  0xc(%ebp)
  80100d:	6a 2d                	push   $0x2d
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	ff d0                	call   *%eax
  801014:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101d:	f7 d8                	neg    %eax
  80101f:	83 d2 00             	adc    $0x0,%edx
  801022:	f7 da                	neg    %edx
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801027:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80102a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801031:	e9 bc 00 00 00       	jmp    8010f2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801036:	83 ec 08             	sub    $0x8,%esp
  801039:	ff 75 e8             	pushl  -0x18(%ebp)
  80103c:	8d 45 14             	lea    0x14(%ebp),%eax
  80103f:	50                   	push   %eax
  801040:	e8 84 fc ff ff       	call   800cc9 <getuint>
  801045:	83 c4 10             	add    $0x10,%esp
  801048:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80104e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801055:	e9 98 00 00 00       	jmp    8010f2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80105a:	83 ec 08             	sub    $0x8,%esp
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	6a 58                	push   $0x58
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	ff d0                	call   *%eax
  801067:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	ff 75 0c             	pushl  0xc(%ebp)
  801070:	6a 58                	push   $0x58
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	ff d0                	call   *%eax
  801077:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80107a:	83 ec 08             	sub    $0x8,%esp
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	6a 58                	push   $0x58
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	ff d0                	call   *%eax
  801087:	83 c4 10             	add    $0x10,%esp
			break;
  80108a:	e9 bc 00 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80108f:	83 ec 08             	sub    $0x8,%esp
  801092:	ff 75 0c             	pushl  0xc(%ebp)
  801095:	6a 30                	push   $0x30
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	ff d0                	call   *%eax
  80109c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80109f:	83 ec 08             	sub    $0x8,%esp
  8010a2:	ff 75 0c             	pushl  0xc(%ebp)
  8010a5:	6a 78                	push   $0x78
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	ff d0                	call   *%eax
  8010ac:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010af:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b2:	83 c0 04             	add    $0x4,%eax
  8010b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bb:	83 e8 04             	sub    $0x4,%eax
  8010be:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010ca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010d1:	eb 1f                	jmp    8010f2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8010d9:	8d 45 14             	lea    0x14(%ebp),%eax
  8010dc:	50                   	push   %eax
  8010dd:	e8 e7 fb ff ff       	call   800cc9 <getuint>
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010eb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010f2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	52                   	push   %edx
  8010fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801100:	50                   	push   %eax
  801101:	ff 75 f4             	pushl  -0xc(%ebp)
  801104:	ff 75 f0             	pushl  -0x10(%ebp)
  801107:	ff 75 0c             	pushl  0xc(%ebp)
  80110a:	ff 75 08             	pushl  0x8(%ebp)
  80110d:	e8 00 fb ff ff       	call   800c12 <printnum>
  801112:	83 c4 20             	add    $0x20,%esp
			break;
  801115:	eb 34                	jmp    80114b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801117:	83 ec 08             	sub    $0x8,%esp
  80111a:	ff 75 0c             	pushl  0xc(%ebp)
  80111d:	53                   	push   %ebx
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	ff d0                	call   *%eax
  801123:	83 c4 10             	add    $0x10,%esp
			break;
  801126:	eb 23                	jmp    80114b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	ff 75 0c             	pushl  0xc(%ebp)
  80112e:	6a 25                	push   $0x25
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	ff d0                	call   *%eax
  801135:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801138:	ff 4d 10             	decl   0x10(%ebp)
  80113b:	eb 03                	jmp    801140 <vprintfmt+0x3b1>
  80113d:	ff 4d 10             	decl   0x10(%ebp)
  801140:	8b 45 10             	mov    0x10(%ebp),%eax
  801143:	48                   	dec    %eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 25                	cmp    $0x25,%al
  801148:	75 f3                	jne    80113d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80114a:	90                   	nop
		}
	}
  80114b:	e9 47 fc ff ff       	jmp    800d97 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801150:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801151:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801154:	5b                   	pop    %ebx
  801155:	5e                   	pop    %esi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    

00801158 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80115e:	8d 45 10             	lea    0x10(%ebp),%eax
  801161:	83 c0 04             	add    $0x4,%eax
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801167:	8b 45 10             	mov    0x10(%ebp),%eax
  80116a:	ff 75 f4             	pushl  -0xc(%ebp)
  80116d:	50                   	push   %eax
  80116e:	ff 75 0c             	pushl  0xc(%ebp)
  801171:	ff 75 08             	pushl  0x8(%ebp)
  801174:	e8 16 fc ff ff       	call   800d8f <vprintfmt>
  801179:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80117c:	90                   	nop
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	8b 40 08             	mov    0x8(%eax),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 10                	mov    (%eax),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	8b 40 04             	mov    0x4(%eax),%eax
  80119c:	39 c2                	cmp    %eax,%edx
  80119e:	73 12                	jae    8011b2 <sprintputch+0x33>
		*b->buf++ = ch;
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	8b 00                	mov    (%eax),%eax
  8011a5:	8d 48 01             	lea    0x1(%eax),%ecx
  8011a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ab:	89 0a                	mov    %ecx,(%edx)
  8011ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b0:	88 10                	mov    %dl,(%eax)
}
  8011b2:	90                   	nop
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    

008011b5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011da:	74 06                	je     8011e2 <vsnprintf+0x2d>
  8011dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e0:	7f 07                	jg     8011e9 <vsnprintf+0x34>
		return -E_INVAL;
  8011e2:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e7:	eb 20                	jmp    801209 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011e9:	ff 75 14             	pushl  0x14(%ebp)
  8011ec:	ff 75 10             	pushl  0x10(%ebp)
  8011ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011f2:	50                   	push   %eax
  8011f3:	68 7f 11 80 00       	push   $0x80117f
  8011f8:	e8 92 fb ff ff       	call   800d8f <vprintfmt>
  8011fd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801203:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801206:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801211:	8d 45 10             	lea    0x10(%ebp),%eax
  801214:	83 c0 04             	add    $0x4,%eax
  801217:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	ff 75 f4             	pushl  -0xc(%ebp)
  801220:	50                   	push   %eax
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	ff 75 08             	pushl  0x8(%ebp)
  801227:	e8 89 ff ff ff       	call   8011b5 <vsnprintf>
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80123d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801241:	74 13                	je     801256 <readline+0x1f>
		cprintf("%s", prompt);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	ff 75 08             	pushl  0x8(%ebp)
  801249:	68 10 42 80 00       	push   $0x804210
  80124e:	e8 62 f9 ff ff       	call   800bb5 <cprintf>
  801253:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801256:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80125d:	83 ec 0c             	sub    $0xc,%esp
  801260:	6a 00                	push   $0x0
  801262:	e8 54 f5 ff ff       	call   8007bb <iscons>
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80126d:	e8 fb f4 ff ff       	call   80076d <getchar>
  801272:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801275:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801279:	79 22                	jns    80129d <readline+0x66>
			if (c != -E_EOF)
  80127b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80127f:	0f 84 ad 00 00 00    	je     801332 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	ff 75 ec             	pushl  -0x14(%ebp)
  80128b:	68 13 42 80 00       	push   $0x804213
  801290:	e8 20 f9 ff ff       	call   800bb5 <cprintf>
  801295:	83 c4 10             	add    $0x10,%esp
			return;
  801298:	e9 95 00 00 00       	jmp    801332 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80129d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012a1:	7e 34                	jle    8012d7 <readline+0xa0>
  8012a3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012aa:	7f 2b                	jg     8012d7 <readline+0xa0>
			if (echoing)
  8012ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012b0:	74 0e                	je     8012c0 <readline+0x89>
				cputchar(c);
  8012b2:	83 ec 0c             	sub    $0xc,%esp
  8012b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b8:	e8 68 f4 ff ff       	call   800725 <cputchar>
  8012bd:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8012c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c3:	8d 50 01             	lea    0x1(%eax),%edx
  8012c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012c9:	89 c2                	mov    %eax,%edx
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d3:	88 10                	mov    %dl,(%eax)
  8012d5:	eb 56                	jmp    80132d <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012d7:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012db:	75 1f                	jne    8012fc <readline+0xc5>
  8012dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012e1:	7e 19                	jle    8012fc <readline+0xc5>
			if (echoing)
  8012e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e7:	74 0e                	je     8012f7 <readline+0xc0>
				cputchar(c);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ef:	e8 31 f4 ff ff       	call   800725 <cputchar>
  8012f4:	83 c4 10             	add    $0x10,%esp

			i--;
  8012f7:	ff 4d f4             	decl   -0xc(%ebp)
  8012fa:	eb 31                	jmp    80132d <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012fc:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801300:	74 0a                	je     80130c <readline+0xd5>
  801302:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801306:	0f 85 61 ff ff ff    	jne    80126d <readline+0x36>
			if (echoing)
  80130c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801310:	74 0e                	je     801320 <readline+0xe9>
				cputchar(c);
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	ff 75 ec             	pushl  -0x14(%ebp)
  801318:	e8 08 f4 ff ff       	call   800725 <cputchar>
  80131d:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 d0                	add    %edx,%eax
  801328:	c6 00 00             	movb   $0x0,(%eax)
			return;
  80132b:	eb 06                	jmp    801333 <readline+0xfc>
		}
	}
  80132d:	e9 3b ff ff ff       	jmp    80126d <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801332:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80133b:	e8 20 0f 00 00       	call   802260 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801344:	74 13                	je     801359 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	68 10 42 80 00       	push   $0x804210
  801351:	e8 5f f8 ff ff       	call   800bb5 <cprintf>
  801356:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801359:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	6a 00                	push   $0x0
  801365:	e8 51 f4 ff ff       	call   8007bb <iscons>
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801370:	e8 f8 f3 ff ff       	call   80076d <getchar>
  801375:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801378:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80137c:	79 23                	jns    8013a1 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80137e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801382:	74 13                	je     801397 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801384:	83 ec 08             	sub    $0x8,%esp
  801387:	ff 75 ec             	pushl  -0x14(%ebp)
  80138a:	68 13 42 80 00       	push   $0x804213
  80138f:	e8 21 f8 ff ff       	call   800bb5 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801397:	e8 de 0e 00 00       	call   80227a <sys_enable_interrupt>
			return;
  80139c:	e9 9a 00 00 00       	jmp    80143b <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013a1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013a5:	7e 34                	jle    8013db <atomic_readline+0xa6>
  8013a7:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013ae:	7f 2b                	jg     8013db <atomic_readline+0xa6>
			if (echoing)
  8013b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b4:	74 0e                	je     8013c4 <atomic_readline+0x8f>
				cputchar(c);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8013bc:	e8 64 f3 ff ff       	call   800725 <cputchar>
  8013c1:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013cd:	89 c2                	mov    %eax,%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d7:	88 10                	mov    %dl,(%eax)
  8013d9:	eb 5b                	jmp    801436 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013db:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013df:	75 1f                	jne    801400 <atomic_readline+0xcb>
  8013e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013e5:	7e 19                	jle    801400 <atomic_readline+0xcb>
			if (echoing)
  8013e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013eb:	74 0e                	je     8013fb <atomic_readline+0xc6>
				cputchar(c);
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f3:	e8 2d f3 ff ff       	call   800725 <cputchar>
  8013f8:	83 c4 10             	add    $0x10,%esp
			i--;
  8013fb:	ff 4d f4             	decl   -0xc(%ebp)
  8013fe:	eb 36                	jmp    801436 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801400:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801404:	74 0a                	je     801410 <atomic_readline+0xdb>
  801406:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80140a:	0f 85 60 ff ff ff    	jne    801370 <atomic_readline+0x3b>
			if (echoing)
  801410:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801414:	74 0e                	je     801424 <atomic_readline+0xef>
				cputchar(c);
  801416:	83 ec 0c             	sub    $0xc,%esp
  801419:	ff 75 ec             	pushl  -0x14(%ebp)
  80141c:	e8 04 f3 ff ff       	call   800725 <cputchar>
  801421:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142a:	01 d0                	add    %edx,%eax
  80142c:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  80142f:	e8 46 0e 00 00       	call   80227a <sys_enable_interrupt>
			return;
  801434:	eb 05                	jmp    80143b <atomic_readline+0x106>
		}
	}
  801436:	e9 35 ff ff ff       	jmp    801370 <atomic_readline+0x3b>
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801443:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144a:	eb 06                	jmp    801452 <strlen+0x15>
		n++;
  80144c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80144f:	ff 45 08             	incl   0x8(%ebp)
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	84 c0                	test   %al,%al
  801459:	75 f1                	jne    80144c <strlen+0xf>
		n++;
	return n;
  80145b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801466:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80146d:	eb 09                	jmp    801478 <strnlen+0x18>
		n++;
  80146f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801472:	ff 45 08             	incl   0x8(%ebp)
  801475:	ff 4d 0c             	decl   0xc(%ebp)
  801478:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80147c:	74 09                	je     801487 <strnlen+0x27>
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	84 c0                	test   %al,%al
  801485:	75 e8                	jne    80146f <strnlen+0xf>
		n++;
	return n;
  801487:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801498:	90                   	nop
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8d 50 01             	lea    0x1(%eax),%edx
  80149f:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014ab:	8a 12                	mov    (%edx),%dl
  8014ad:	88 10                	mov    %dl,(%eax)
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	84 c0                	test   %al,%al
  8014b3:	75 e4                	jne    801499 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8014b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014cd:	eb 1f                	jmp    8014ee <strncpy+0x34>
		*dst++ = *src;
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	8a 12                	mov    (%edx),%dl
  8014dd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	84 c0                	test   %al,%al
  8014e6:	74 03                	je     8014eb <strncpy+0x31>
			src++;
  8014e8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014eb:	ff 45 fc             	incl   -0x4(%ebp)
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f4:	72 d9                	jb     8014cf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801507:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150b:	74 30                	je     80153d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80150d:	eb 16                	jmp    801525 <strlcpy+0x2a>
			*dst++ = *src++;
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8d 50 01             	lea    0x1(%eax),%edx
  801515:	89 55 08             	mov    %edx,0x8(%ebp)
  801518:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801521:	8a 12                	mov    (%edx),%dl
  801523:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801525:	ff 4d 10             	decl   0x10(%ebp)
  801528:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152c:	74 09                	je     801537 <strlcpy+0x3c>
  80152e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	84 c0                	test   %al,%al
  801535:	75 d8                	jne    80150f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80153d:	8b 55 08             	mov    0x8(%ebp),%edx
  801540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801543:	29 c2                	sub    %eax,%edx
  801545:	89 d0                	mov    %edx,%eax
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80154c:	eb 06                	jmp    801554 <strcmp+0xb>
		p++, q++;
  80154e:	ff 45 08             	incl   0x8(%ebp)
  801551:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	84 c0                	test   %al,%al
  80155b:	74 0e                	je     80156b <strcmp+0x22>
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 10                	mov    (%eax),%dl
  801562:	8b 45 0c             	mov    0xc(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	38 c2                	cmp    %al,%dl
  801569:	74 e3                	je     80154e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	0f b6 d0             	movzbl %al,%edx
  801573:	8b 45 0c             	mov    0xc(%ebp),%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	0f b6 c0             	movzbl %al,%eax
  80157b:	29 c2                	sub    %eax,%edx
  80157d:	89 d0                	mov    %edx,%eax
}
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    

00801581 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801584:	eb 09                	jmp    80158f <strncmp+0xe>
		n--, p++, q++;
  801586:	ff 4d 10             	decl   0x10(%ebp)
  801589:	ff 45 08             	incl   0x8(%ebp)
  80158c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80158f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801593:	74 17                	je     8015ac <strncmp+0x2b>
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8a 00                	mov    (%eax),%al
  80159a:	84 c0                	test   %al,%al
  80159c:	74 0e                	je     8015ac <strncmp+0x2b>
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	8a 10                	mov    (%eax),%dl
  8015a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a6:	8a 00                	mov    (%eax),%al
  8015a8:	38 c2                	cmp    %al,%dl
  8015aa:	74 da                	je     801586 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8015ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015b0:	75 07                	jne    8015b9 <strncmp+0x38>
		return 0;
  8015b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b7:	eb 14                	jmp    8015cd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	0f b6 d0             	movzbl %al,%edx
  8015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c4:	8a 00                	mov    (%eax),%al
  8015c6:	0f b6 c0             	movzbl %al,%eax
  8015c9:	29 c2                	sub    %eax,%edx
  8015cb:	89 d0                	mov    %edx,%eax
}
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015db:	eb 12                	jmp    8015ef <strchr+0x20>
		if (*s == c)
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	8a 00                	mov    (%eax),%al
  8015e2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015e5:	75 05                	jne    8015ec <strchr+0x1d>
			return (char *) s;
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	eb 11                	jmp    8015fd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015ec:	ff 45 08             	incl   0x8(%ebp)
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	8a 00                	mov    (%eax),%al
  8015f4:	84 c0                	test   %al,%al
  8015f6:	75 e5                	jne    8015dd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
  801608:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80160b:	eb 0d                	jmp    80161a <strfind+0x1b>
		if (*s == c)
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	8a 00                	mov    (%eax),%al
  801612:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801615:	74 0e                	je     801625 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801617:	ff 45 08             	incl   0x8(%ebp)
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	84 c0                	test   %al,%al
  801621:	75 ea                	jne    80160d <strfind+0xe>
  801623:	eb 01                	jmp    801626 <strfind+0x27>
		if (*s == c)
			break;
  801625:	90                   	nop
	return (char *) s;
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801637:	8b 45 10             	mov    0x10(%ebp),%eax
  80163a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80163d:	eb 0e                	jmp    80164d <memset+0x22>
		*p++ = c;
  80163f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801642:	8d 50 01             	lea    0x1(%eax),%edx
  801645:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80164d:	ff 4d f8             	decl   -0x8(%ebp)
  801650:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801654:	79 e9                	jns    80163f <memset+0x14>
		*p++ = c;

	return v;
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801661:	8b 45 0c             	mov    0xc(%ebp),%eax
  801664:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80166d:	eb 16                	jmp    801685 <memcpy+0x2a>
		*d++ = *s++;
  80166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801672:	8d 50 01             	lea    0x1(%eax),%edx
  801675:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801678:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801681:	8a 12                	mov    (%edx),%dl
  801683:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801685:	8b 45 10             	mov    0x10(%ebp),%eax
  801688:	8d 50 ff             	lea    -0x1(%eax),%edx
  80168b:	89 55 10             	mov    %edx,0x10(%ebp)
  80168e:	85 c0                	test   %eax,%eax
  801690:	75 dd                	jne    80166f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80169d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016af:	73 50                	jae    801701 <memmove+0x6a>
  8016b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b7:	01 d0                	add    %edx,%eax
  8016b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016bc:	76 43                	jbe    801701 <memmove+0x6a>
		s += n;
  8016be:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016ca:	eb 10                	jmp    8016dc <memmove+0x45>
			*--d = *--s;
  8016cc:	ff 4d f8             	decl   -0x8(%ebp)
  8016cf:	ff 4d fc             	decl   -0x4(%ebp)
  8016d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d5:	8a 10                	mov    (%eax),%dl
  8016d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016da:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	75 e3                	jne    8016cc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016e9:	eb 23                	jmp    80170e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	8d 50 01             	lea    0x1(%eax),%edx
  8016f1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016fa:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016fd:	8a 12                	mov    (%edx),%dl
  8016ff:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	8d 50 ff             	lea    -0x1(%eax),%edx
  801707:	89 55 10             	mov    %edx,0x10(%ebp)
  80170a:	85 c0                	test   %eax,%eax
  80170c:	75 dd                	jne    8016eb <memmove+0x54>
			*d++ = *s++;

	return dst;
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80171f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801722:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801725:	eb 2a                	jmp    801751 <memcmp+0x3e>
		if (*s1 != *s2)
  801727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172a:	8a 10                	mov    (%eax),%dl
  80172c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	38 c2                	cmp    %al,%dl
  801733:	74 16                	je     80174b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801738:	8a 00                	mov    (%eax),%al
  80173a:	0f b6 d0             	movzbl %al,%edx
  80173d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801740:	8a 00                	mov    (%eax),%al
  801742:	0f b6 c0             	movzbl %al,%eax
  801745:	29 c2                	sub    %eax,%edx
  801747:	89 d0                	mov    %edx,%eax
  801749:	eb 18                	jmp    801763 <memcmp+0x50>
		s1++, s2++;
  80174b:	ff 45 fc             	incl   -0x4(%ebp)
  80174e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801751:	8b 45 10             	mov    0x10(%ebp),%eax
  801754:	8d 50 ff             	lea    -0x1(%eax),%edx
  801757:	89 55 10             	mov    %edx,0x10(%ebp)
  80175a:	85 c0                	test   %eax,%eax
  80175c:	75 c9                	jne    801727 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80176b:	8b 55 08             	mov    0x8(%ebp),%edx
  80176e:	8b 45 10             	mov    0x10(%ebp),%eax
  801771:	01 d0                	add    %edx,%eax
  801773:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801776:	eb 15                	jmp    80178d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	0f b6 d0             	movzbl %al,%edx
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	0f b6 c0             	movzbl %al,%eax
  801786:	39 c2                	cmp    %eax,%edx
  801788:	74 0d                	je     801797 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80178a:	ff 45 08             	incl   0x8(%ebp)
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801793:	72 e3                	jb     801778 <memfind+0x13>
  801795:	eb 01                	jmp    801798 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801797:	90                   	nop
	return (void *) s;
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b1:	eb 03                	jmp    8017b6 <strtol+0x19>
		s++;
  8017b3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	3c 20                	cmp    $0x20,%al
  8017bd:	74 f4                	je     8017b3 <strtol+0x16>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	3c 09                	cmp    $0x9,%al
  8017c6:	74 eb                	je     8017b3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	3c 2b                	cmp    $0x2b,%al
  8017cf:	75 05                	jne    8017d6 <strtol+0x39>
		s++;
  8017d1:	ff 45 08             	incl   0x8(%ebp)
  8017d4:	eb 13                	jmp    8017e9 <strtol+0x4c>
	else if (*s == '-')
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	3c 2d                	cmp    $0x2d,%al
  8017dd:	75 0a                	jne    8017e9 <strtol+0x4c>
		s++, neg = 1;
  8017df:	ff 45 08             	incl   0x8(%ebp)
  8017e2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ed:	74 06                	je     8017f5 <strtol+0x58>
  8017ef:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017f3:	75 20                	jne    801815 <strtol+0x78>
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8a 00                	mov    (%eax),%al
  8017fa:	3c 30                	cmp    $0x30,%al
  8017fc:	75 17                	jne    801815 <strtol+0x78>
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	40                   	inc    %eax
  801802:	8a 00                	mov    (%eax),%al
  801804:	3c 78                	cmp    $0x78,%al
  801806:	75 0d                	jne    801815 <strtol+0x78>
		s += 2, base = 16;
  801808:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80180c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801813:	eb 28                	jmp    80183d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801815:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801819:	75 15                	jne    801830 <strtol+0x93>
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	8a 00                	mov    (%eax),%al
  801820:	3c 30                	cmp    $0x30,%al
  801822:	75 0c                	jne    801830 <strtol+0x93>
		s++, base = 8;
  801824:	ff 45 08             	incl   0x8(%ebp)
  801827:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80182e:	eb 0d                	jmp    80183d <strtol+0xa0>
	else if (base == 0)
  801830:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801834:	75 07                	jne    80183d <strtol+0xa0>
		base = 10;
  801836:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	3c 2f                	cmp    $0x2f,%al
  801844:	7e 19                	jle    80185f <strtol+0xc2>
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	3c 39                	cmp    $0x39,%al
  80184d:	7f 10                	jg     80185f <strtol+0xc2>
			dig = *s - '0';
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	8a 00                	mov    (%eax),%al
  801854:	0f be c0             	movsbl %al,%eax
  801857:	83 e8 30             	sub    $0x30,%eax
  80185a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185d:	eb 42                	jmp    8018a1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	3c 60                	cmp    $0x60,%al
  801866:	7e 19                	jle    801881 <strtol+0xe4>
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8a 00                	mov    (%eax),%al
  80186d:	3c 7a                	cmp    $0x7a,%al
  80186f:	7f 10                	jg     801881 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	8a 00                	mov    (%eax),%al
  801876:	0f be c0             	movsbl %al,%eax
  801879:	83 e8 57             	sub    $0x57,%eax
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80187f:	eb 20                	jmp    8018a1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	3c 40                	cmp    $0x40,%al
  801888:	7e 39                	jle    8018c3 <strtol+0x126>
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 00                	mov    (%eax),%al
  80188f:	3c 5a                	cmp    $0x5a,%al
  801891:	7f 30                	jg     8018c3 <strtol+0x126>
			dig = *s - 'A' + 10;
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	8a 00                	mov    (%eax),%al
  801898:	0f be c0             	movsbl %al,%eax
  80189b:	83 e8 37             	sub    $0x37,%eax
  80189e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018a7:	7d 19                	jge    8018c2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018a9:	ff 45 08             	incl   0x8(%ebp)
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018b3:	89 c2                	mov    %eax,%edx
  8018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b8:	01 d0                	add    %edx,%eax
  8018ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018bd:	e9 7b ff ff ff       	jmp    80183d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018c2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018c7:	74 08                	je     8018d1 <strtol+0x134>
		*endptr = (char *) s;
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8018cf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018d5:	74 07                	je     8018de <strtol+0x141>
  8018d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018da:	f7 d8                	neg    %eax
  8018dc:	eb 03                	jmp    8018e1 <strtol+0x144>
  8018de:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <ltostr>:

void
ltostr(long value, char *str)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018fb:	79 13                	jns    801910 <ltostr+0x2d>
	{
		neg = 1;
  8018fd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801904:	8b 45 0c             	mov    0xc(%ebp),%eax
  801907:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80190a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80190d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801918:	99                   	cltd   
  801919:	f7 f9                	idiv   %ecx
  80191b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80191e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801921:	8d 50 01             	lea    0x1(%eax),%edx
  801924:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801927:	89 c2                	mov    %eax,%edx
  801929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192c:	01 d0                	add    %edx,%eax
  80192e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801931:	83 c2 30             	add    $0x30,%edx
  801934:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801936:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801939:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80193e:	f7 e9                	imul   %ecx
  801940:	c1 fa 02             	sar    $0x2,%edx
  801943:	89 c8                	mov    %ecx,%eax
  801945:	c1 f8 1f             	sar    $0x1f,%eax
  801948:	29 c2                	sub    %eax,%edx
  80194a:	89 d0                	mov    %edx,%eax
  80194c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80194f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801952:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801957:	f7 e9                	imul   %ecx
  801959:	c1 fa 02             	sar    $0x2,%edx
  80195c:	89 c8                	mov    %ecx,%eax
  80195e:	c1 f8 1f             	sar    $0x1f,%eax
  801961:	29 c2                	sub    %eax,%edx
  801963:	89 d0                	mov    %edx,%eax
  801965:	c1 e0 02             	shl    $0x2,%eax
  801968:	01 d0                	add    %edx,%eax
  80196a:	01 c0                	add    %eax,%eax
  80196c:	29 c1                	sub    %eax,%ecx
  80196e:	89 ca                	mov    %ecx,%edx
  801970:	85 d2                	test   %edx,%edx
  801972:	75 9c                	jne    801910 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801974:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197e:	48                   	dec    %eax
  80197f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801982:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801986:	74 3d                	je     8019c5 <ltostr+0xe2>
		start = 1 ;
  801988:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80198f:	eb 34                	jmp    8019c5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801994:	8b 45 0c             	mov    0xc(%ebp),%eax
  801997:	01 d0                	add    %edx,%eax
  801999:	8a 00                	mov    (%eax),%al
  80199b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80199e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	01 c2                	add    %eax,%edx
  8019a6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ac:	01 c8                	add    %ecx,%eax
  8019ae:	8a 00                	mov    (%eax),%al
  8019b0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b8:	01 c2                	add    %eax,%edx
  8019ba:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019bd:	88 02                	mov    %al,(%edx)
		start++ ;
  8019bf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019c2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019cb:	7c c4                	jl     801991 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d3:	01 d0                	add    %edx,%eax
  8019d5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019d8:	90                   	nop
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	e8 54 fa ff ff       	call   80143d <strlen>
  8019e9:	83 c4 04             	add    $0x4,%esp
  8019ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	e8 46 fa ff ff       	call   80143d <strlen>
  8019f7:	83 c4 04             	add    $0x4,%esp
  8019fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a0b:	eb 17                	jmp    801a24 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a10:	8b 45 10             	mov    0x10(%ebp),%eax
  801a13:	01 c2                	add    %eax,%edx
  801a15:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	01 c8                	add    %ecx,%eax
  801a1d:	8a 00                	mov    (%eax),%al
  801a1f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a21:	ff 45 fc             	incl   -0x4(%ebp)
  801a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a27:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a2a:	7c e1                	jl     801a0d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a2c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a3a:	eb 1f                	jmp    801a5b <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a3f:	8d 50 01             	lea    0x1(%eax),%edx
  801a42:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a45:	89 c2                	mov    %eax,%edx
  801a47:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4a:	01 c2                	add    %eax,%edx
  801a4c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a52:	01 c8                	add    %ecx,%eax
  801a54:	8a 00                	mov    (%eax),%al
  801a56:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a58:	ff 45 f8             	incl   -0x8(%ebp)
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a61:	7c d9                	jl     801a3c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a66:	8b 45 10             	mov    0x10(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	c6 00 00             	movb   $0x0,(%eax)
}
  801a6e:	90                   	nop
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a74:	8b 45 14             	mov    0x14(%ebp),%eax
  801a77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a80:	8b 00                	mov    (%eax),%eax
  801a82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	01 d0                	add    %edx,%eax
  801a8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a94:	eb 0c                	jmp    801aa2 <strsplit+0x31>
			*string++ = 0;
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	8d 50 01             	lea    0x1(%eax),%edx
  801a9c:	89 55 08             	mov    %edx,0x8(%ebp)
  801a9f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	84 c0                	test   %al,%al
  801aa9:	74 18                	je     801ac3 <strsplit+0x52>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	0f be c0             	movsbl %al,%eax
  801ab3:	50                   	push   %eax
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	e8 13 fb ff ff       	call   8015cf <strchr>
  801abc:	83 c4 08             	add    $0x8,%esp
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	75 d3                	jne    801a96 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	8a 00                	mov    (%eax),%al
  801ac8:	84 c0                	test   %al,%al
  801aca:	74 5a                	je     801b26 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801acc:	8b 45 14             	mov    0x14(%ebp),%eax
  801acf:	8b 00                	mov    (%eax),%eax
  801ad1:	83 f8 0f             	cmp    $0xf,%eax
  801ad4:	75 07                	jne    801add <strsplit+0x6c>
		{
			return 0;
  801ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  801adb:	eb 66                	jmp    801b43 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801add:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae0:	8b 00                	mov    (%eax),%eax
  801ae2:	8d 48 01             	lea    0x1(%eax),%ecx
  801ae5:	8b 55 14             	mov    0x14(%ebp),%edx
  801ae8:	89 0a                	mov    %ecx,(%edx)
  801aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af1:	8b 45 10             	mov    0x10(%ebp),%eax
  801af4:	01 c2                	add    %eax,%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801afb:	eb 03                	jmp    801b00 <strsplit+0x8f>
			string++;
  801afd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	8a 00                	mov    (%eax),%al
  801b05:	84 c0                	test   %al,%al
  801b07:	74 8b                	je     801a94 <strsplit+0x23>
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	8a 00                	mov    (%eax),%al
  801b0e:	0f be c0             	movsbl %al,%eax
  801b11:	50                   	push   %eax
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	e8 b5 fa ff ff       	call   8015cf <strchr>
  801b1a:	83 c4 08             	add    $0x8,%esp
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	74 dc                	je     801afd <strsplit+0x8c>
			string++;
	}
  801b21:	e9 6e ff ff ff       	jmp    801a94 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b26:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b27:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2a:	8b 00                	mov    (%eax),%eax
  801b2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b33:	8b 45 10             	mov    0x10(%ebp),%eax
  801b36:	01 d0                	add    %edx,%eax
  801b38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b3e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801b4b:	a1 04 50 80 00       	mov    0x805004,%eax
  801b50:	85 c0                	test   %eax,%eax
  801b52:	74 1f                	je     801b73 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b54:	e8 1d 00 00 00       	call   801b76 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	68 24 42 80 00       	push   $0x804224
  801b61:	e8 4f f0 ff ff       	call   800bb5 <cprintf>
  801b66:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b69:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b70:	00 00 00 
	}
}
  801b73:	90                   	nop
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801b7c:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b83:	00 00 00 
  801b86:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b8d:	00 00 00 
  801b90:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b97:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801b9a:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801ba1:	00 00 00 
  801ba4:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801bab:	00 00 00 
  801bae:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801bb5:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801bb8:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bc7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bcc:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801bd1:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801bd8:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801bdb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be5:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801bea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf0:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf5:	f7 75 f0             	divl   -0x10(%ebp)
  801bf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bfb:	29 d0                	sub    %edx,%eax
  801bfd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801c00:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801c07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c0a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c0f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c14:	83 ec 04             	sub    $0x4,%esp
  801c17:	6a 06                	push   $0x6
  801c19:	ff 75 e8             	pushl  -0x18(%ebp)
  801c1c:	50                   	push   %eax
  801c1d:	e8 d4 05 00 00       	call   8021f6 <sys_allocate_chunk>
  801c22:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c25:	a1 20 51 80 00       	mov    0x805120,%eax
  801c2a:	83 ec 0c             	sub    $0xc,%esp
  801c2d:	50                   	push   %eax
  801c2e:	e8 49 0c 00 00       	call   80287c <initialize_MemBlocksList>
  801c33:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801c36:	a1 48 51 80 00       	mov    0x805148,%eax
  801c3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801c3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c42:	75 14                	jne    801c58 <initialize_dyn_block_system+0xe2>
  801c44:	83 ec 04             	sub    $0x4,%esp
  801c47:	68 49 42 80 00       	push   $0x804249
  801c4c:	6a 39                	push   $0x39
  801c4e:	68 67 42 80 00       	push   $0x804267
  801c53:	e8 a9 ec ff ff       	call   800901 <_panic>
  801c58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c5b:	8b 00                	mov    (%eax),%eax
  801c5d:	85 c0                	test   %eax,%eax
  801c5f:	74 10                	je     801c71 <initialize_dyn_block_system+0xfb>
  801c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c64:	8b 00                	mov    (%eax),%eax
  801c66:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c69:	8b 52 04             	mov    0x4(%edx),%edx
  801c6c:	89 50 04             	mov    %edx,0x4(%eax)
  801c6f:	eb 0b                	jmp    801c7c <initialize_dyn_block_system+0x106>
  801c71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c74:	8b 40 04             	mov    0x4(%eax),%eax
  801c77:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c7f:	8b 40 04             	mov    0x4(%eax),%eax
  801c82:	85 c0                	test   %eax,%eax
  801c84:	74 0f                	je     801c95 <initialize_dyn_block_system+0x11f>
  801c86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c89:	8b 40 04             	mov    0x4(%eax),%eax
  801c8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c8f:	8b 12                	mov    (%edx),%edx
  801c91:	89 10                	mov    %edx,(%eax)
  801c93:	eb 0a                	jmp    801c9f <initialize_dyn_block_system+0x129>
  801c95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c98:	8b 00                	mov    (%eax),%eax
  801c9a:	a3 48 51 80 00       	mov    %eax,0x805148
  801c9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cb2:	a1 54 51 80 00       	mov    0x805154,%eax
  801cb7:	48                   	dec    %eax
  801cb8:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801cbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cc0:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cca:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801cd1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cd5:	75 14                	jne    801ceb <initialize_dyn_block_system+0x175>
  801cd7:	83 ec 04             	sub    $0x4,%esp
  801cda:	68 74 42 80 00       	push   $0x804274
  801cdf:	6a 3f                	push   $0x3f
  801ce1:	68 67 42 80 00       	push   $0x804267
  801ce6:	e8 16 ec ff ff       	call   800901 <_panic>
  801ceb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801cf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cf4:	89 10                	mov    %edx,(%eax)
  801cf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cf9:	8b 00                	mov    (%eax),%eax
  801cfb:	85 c0                	test   %eax,%eax
  801cfd:	74 0d                	je     801d0c <initialize_dyn_block_system+0x196>
  801cff:	a1 38 51 80 00       	mov    0x805138,%eax
  801d04:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d07:	89 50 04             	mov    %edx,0x4(%eax)
  801d0a:	eb 08                	jmp    801d14 <initialize_dyn_block_system+0x19e>
  801d0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d0f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801d14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d17:	a3 38 51 80 00       	mov    %eax,0x805138
  801d1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d26:	a1 44 51 80 00       	mov    0x805144,%eax
  801d2b:	40                   	inc    %eax
  801d2c:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801d31:	90                   	nop
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d3a:	e8 06 fe ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d43:	75 07                	jne    801d4c <malloc+0x18>
  801d45:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4a:	eb 7d                	jmp    801dc9 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801d4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801d53:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  801d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d60:	01 d0                	add    %edx,%eax
  801d62:	48                   	dec    %eax
  801d63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d69:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6e:	f7 75 f0             	divl   -0x10(%ebp)
  801d71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d74:	29 d0                	sub    %edx,%eax
  801d76:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801d79:	e8 46 08 00 00       	call   8025c4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d7e:	83 f8 01             	cmp    $0x1,%eax
  801d81:	75 07                	jne    801d8a <malloc+0x56>
  801d83:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801d8a:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801d8e:	75 34                	jne    801dc4 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801d90:	83 ec 0c             	sub    $0xc,%esp
  801d93:	ff 75 e8             	pushl  -0x18(%ebp)
  801d96:	e8 73 0e 00 00       	call   802c0e <alloc_block_FF>
  801d9b:	83 c4 10             	add    $0x10,%esp
  801d9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801da1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801da5:	74 16                	je     801dbd <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801da7:	83 ec 0c             	sub    $0xc,%esp
  801daa:	ff 75 e4             	pushl  -0x1c(%ebp)
  801dad:	e8 ff 0b 00 00       	call   8029b1 <insert_sorted_allocList>
  801db2:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801db5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801db8:	8b 40 08             	mov    0x8(%eax),%eax
  801dbb:	eb 0c                	jmp    801dc9 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc2:	eb 05                	jmp    801dc9 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801dc4:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801de5:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801de8:	83 ec 08             	sub    $0x8,%esp
  801deb:	ff 75 f4             	pushl  -0xc(%ebp)
  801dee:	68 40 50 80 00       	push   $0x805040
  801df3:	e8 61 0b 00 00       	call   802959 <find_block>
  801df8:	83 c4 10             	add    $0x10,%esp
  801dfb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801dfe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e02:	0f 84 a5 00 00 00    	je     801ead <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801e08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e0b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e0e:	83 ec 08             	sub    $0x8,%esp
  801e11:	50                   	push   %eax
  801e12:	ff 75 f4             	pushl  -0xc(%ebp)
  801e15:	e8 a4 03 00 00       	call   8021be <sys_free_user_mem>
  801e1a:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801e1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e21:	75 17                	jne    801e3a <free+0x6f>
  801e23:	83 ec 04             	sub    $0x4,%esp
  801e26:	68 49 42 80 00       	push   $0x804249
  801e2b:	68 87 00 00 00       	push   $0x87
  801e30:	68 67 42 80 00       	push   $0x804267
  801e35:	e8 c7 ea ff ff       	call   800901 <_panic>
  801e3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e3d:	8b 00                	mov    (%eax),%eax
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	74 10                	je     801e53 <free+0x88>
  801e43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e46:	8b 00                	mov    (%eax),%eax
  801e48:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e4b:	8b 52 04             	mov    0x4(%edx),%edx
  801e4e:	89 50 04             	mov    %edx,0x4(%eax)
  801e51:	eb 0b                	jmp    801e5e <free+0x93>
  801e53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e56:	8b 40 04             	mov    0x4(%eax),%eax
  801e59:	a3 44 50 80 00       	mov    %eax,0x805044
  801e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e61:	8b 40 04             	mov    0x4(%eax),%eax
  801e64:	85 c0                	test   %eax,%eax
  801e66:	74 0f                	je     801e77 <free+0xac>
  801e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e6b:	8b 40 04             	mov    0x4(%eax),%eax
  801e6e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e71:	8b 12                	mov    (%edx),%edx
  801e73:	89 10                	mov    %edx,(%eax)
  801e75:	eb 0a                	jmp    801e81 <free+0xb6>
  801e77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e7a:	8b 00                	mov    (%eax),%eax
  801e7c:	a3 40 50 80 00       	mov    %eax,0x805040
  801e81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e94:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e99:	48                   	dec    %eax
  801e9a:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801e9f:	83 ec 0c             	sub    $0xc,%esp
  801ea2:	ff 75 ec             	pushl  -0x14(%ebp)
  801ea5:	e8 37 12 00 00       	call   8030e1 <insert_sorted_with_merge_freeList>
  801eaa:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801ead:	90                   	nop
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	83 ec 38             	sub    $0x38,%esp
  801eb6:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb9:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ebc:	e8 84 fc ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ec1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ec5:	75 07                	jne    801ece <smalloc+0x1e>
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecc:	eb 7e                	jmp    801f4c <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801ece:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801ed5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801edc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee2:	01 d0                	add    %edx,%eax
  801ee4:	48                   	dec    %eax
  801ee5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ee8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eeb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef0:	f7 75 f0             	divl   -0x10(%ebp)
  801ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef6:	29 d0                	sub    %edx,%eax
  801ef8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801efb:	e8 c4 06 00 00       	call   8025c4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f00:	83 f8 01             	cmp    $0x1,%eax
  801f03:	75 42                	jne    801f47 <smalloc+0x97>

		  va = malloc(newsize) ;
  801f05:	83 ec 0c             	sub    $0xc,%esp
  801f08:	ff 75 e8             	pushl  -0x18(%ebp)
  801f0b:	e8 24 fe ff ff       	call   801d34 <malloc>
  801f10:	83 c4 10             	add    $0x10,%esp
  801f13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801f16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f1a:	74 24                	je     801f40 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801f1c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801f20:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f23:	50                   	push   %eax
  801f24:	ff 75 e8             	pushl  -0x18(%ebp)
  801f27:	ff 75 08             	pushl  0x8(%ebp)
  801f2a:	e8 1a 04 00 00       	call   802349 <sys_createSharedObject>
  801f2f:	83 c4 10             	add    $0x10,%esp
  801f32:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801f35:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f39:	78 0c                	js     801f47 <smalloc+0x97>
					  return va ;
  801f3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f3e:	eb 0c                	jmp    801f4c <smalloc+0x9c>
				 }
				 else
					return NULL;
  801f40:	b8 00 00 00 00       	mov    $0x0,%eax
  801f45:	eb 05                	jmp    801f4c <smalloc+0x9c>
	  }
		  return NULL ;
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f54:	e8 ec fb ff ff       	call   801b45 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801f59:	83 ec 08             	sub    $0x8,%esp
  801f5c:	ff 75 0c             	pushl  0xc(%ebp)
  801f5f:	ff 75 08             	pushl  0x8(%ebp)
  801f62:	e8 0c 04 00 00       	call   802373 <sys_getSizeOfSharedObject>
  801f67:	83 c4 10             	add    $0x10,%esp
  801f6a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801f6d:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801f71:	75 07                	jne    801f7a <sget+0x2c>
  801f73:	b8 00 00 00 00       	mov    $0x0,%eax
  801f78:	eb 75                	jmp    801fef <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801f7a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f87:	01 d0                	add    %edx,%eax
  801f89:	48                   	dec    %eax
  801f8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f90:	ba 00 00 00 00       	mov    $0x0,%edx
  801f95:	f7 75 f0             	divl   -0x10(%ebp)
  801f98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f9b:	29 d0                	sub    %edx,%eax
  801f9d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801fa0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801fa7:	e8 18 06 00 00       	call   8025c4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fac:	83 f8 01             	cmp    $0x1,%eax
  801faf:	75 39                	jne    801fea <sget+0x9c>

		  va = malloc(newsize) ;
  801fb1:	83 ec 0c             	sub    $0xc,%esp
  801fb4:	ff 75 e8             	pushl  -0x18(%ebp)
  801fb7:	e8 78 fd ff ff       	call   801d34 <malloc>
  801fbc:	83 c4 10             	add    $0x10,%esp
  801fbf:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801fc2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fc6:	74 22                	je     801fea <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801fc8:	83 ec 04             	sub    $0x4,%esp
  801fcb:	ff 75 e0             	pushl  -0x20(%ebp)
  801fce:	ff 75 0c             	pushl  0xc(%ebp)
  801fd1:	ff 75 08             	pushl  0x8(%ebp)
  801fd4:	e8 b7 03 00 00       	call   802390 <sys_getSharedObject>
  801fd9:	83 c4 10             	add    $0x10,%esp
  801fdc:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801fdf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801fe3:	78 05                	js     801fea <sget+0x9c>
					  return va;
  801fe5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fe8:	eb 05                	jmp    801fef <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ff7:	e8 49 fb ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ffc:	83 ec 04             	sub    $0x4,%esp
  801fff:	68 98 42 80 00       	push   $0x804298
  802004:	68 1e 01 00 00       	push   $0x11e
  802009:	68 67 42 80 00       	push   $0x804267
  80200e:	e8 ee e8 ff ff       	call   800901 <_panic>

00802013 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
  802016:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802019:	83 ec 04             	sub    $0x4,%esp
  80201c:	68 c0 42 80 00       	push   $0x8042c0
  802021:	68 32 01 00 00       	push   $0x132
  802026:	68 67 42 80 00       	push   $0x804267
  80202b:	e8 d1 e8 ff ff       	call   800901 <_panic>

00802030 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802036:	83 ec 04             	sub    $0x4,%esp
  802039:	68 e4 42 80 00       	push   $0x8042e4
  80203e:	68 3d 01 00 00       	push   $0x13d
  802043:	68 67 42 80 00       	push   $0x804267
  802048:	e8 b4 e8 ff ff       	call   800901 <_panic>

0080204d <shrink>:

}
void shrink(uint32 newSize)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802053:	83 ec 04             	sub    $0x4,%esp
  802056:	68 e4 42 80 00       	push   $0x8042e4
  80205b:	68 42 01 00 00       	push   $0x142
  802060:	68 67 42 80 00       	push   $0x804267
  802065:	e8 97 e8 ff ff       	call   800901 <_panic>

0080206a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802070:	83 ec 04             	sub    $0x4,%esp
  802073:	68 e4 42 80 00       	push   $0x8042e4
  802078:	68 47 01 00 00       	push   $0x147
  80207d:	68 67 42 80 00       	push   $0x804267
  802082:	e8 7a e8 ff ff       	call   800901 <_panic>

00802087 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	57                   	push   %edi
  80208b:	56                   	push   %esi
  80208c:	53                   	push   %ebx
  80208d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802090:	8b 45 08             	mov    0x8(%ebp),%eax
  802093:	8b 55 0c             	mov    0xc(%ebp),%edx
  802096:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802099:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80209c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80209f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020a2:	cd 30                	int    $0x30
  8020a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020aa:	83 c4 10             	add    $0x10,%esp
  8020ad:	5b                   	pop    %ebx
  8020ae:	5e                   	pop    %esi
  8020af:	5f                   	pop    %edi
  8020b0:	5d                   	pop    %ebp
  8020b1:	c3                   	ret    

008020b2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	83 ec 04             	sub    $0x4,%esp
  8020b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8020bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020be:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	52                   	push   %edx
  8020ca:	ff 75 0c             	pushl  0xc(%ebp)
  8020cd:	50                   	push   %eax
  8020ce:	6a 00                	push   $0x0
  8020d0:	e8 b2 ff ff ff       	call   802087 <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	90                   	nop
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <sys_cgetc>:

int
sys_cgetc(void)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 01                	push   $0x1
  8020ea:	e8 98 ff ff ff       	call   802087 <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
}
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	52                   	push   %edx
  802104:	50                   	push   %eax
  802105:	6a 05                	push   $0x5
  802107:	e8 7b ff ff ff       	call   802087 <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	56                   	push   %esi
  802115:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802116:	8b 75 18             	mov    0x18(%ebp),%esi
  802119:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80211c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80211f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	56                   	push   %esi
  802126:	53                   	push   %ebx
  802127:	51                   	push   %ecx
  802128:	52                   	push   %edx
  802129:	50                   	push   %eax
  80212a:	6a 06                	push   $0x6
  80212c:	e8 56 ff ff ff       	call   802087 <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802137:	5b                   	pop    %ebx
  802138:	5e                   	pop    %esi
  802139:	5d                   	pop    %ebp
  80213a:	c3                   	ret    

0080213b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80213e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	52                   	push   %edx
  80214b:	50                   	push   %eax
  80214c:	6a 07                	push   $0x7
  80214e:	e8 34 ff ff ff       	call   802087 <syscall>
  802153:	83 c4 18             	add    $0x18,%esp
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	ff 75 0c             	pushl  0xc(%ebp)
  802164:	ff 75 08             	pushl  0x8(%ebp)
  802167:	6a 08                	push   $0x8
  802169:	e8 19 ff ff ff       	call   802087 <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 09                	push   $0x9
  802182:	e8 00 ff ff ff       	call   802087 <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 0a                	push   $0xa
  80219b:	e8 e7 fe ff ff       	call   802087 <syscall>
  8021a0:	83 c4 18             	add    $0x18,%esp
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 0b                	push   $0xb
  8021b4:	e8 ce fe ff ff       	call   802087 <syscall>
  8021b9:	83 c4 18             	add    $0x18,%esp
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ca:	ff 75 08             	pushl  0x8(%ebp)
  8021cd:	6a 0f                	push   $0xf
  8021cf:	e8 b3 fe ff ff       	call   802087 <syscall>
  8021d4:	83 c4 18             	add    $0x18,%esp
	return;
  8021d7:	90                   	nop
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	ff 75 0c             	pushl  0xc(%ebp)
  8021e6:	ff 75 08             	pushl  0x8(%ebp)
  8021e9:	6a 10                	push   $0x10
  8021eb:	e8 97 fe ff ff       	call   802087 <syscall>
  8021f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f3:	90                   	nop
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	ff 75 10             	pushl  0x10(%ebp)
  802200:	ff 75 0c             	pushl  0xc(%ebp)
  802203:	ff 75 08             	pushl  0x8(%ebp)
  802206:	6a 11                	push   $0x11
  802208:	e8 7a fe ff ff       	call   802087 <syscall>
  80220d:	83 c4 18             	add    $0x18,%esp
	return ;
  802210:	90                   	nop
}
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 0c                	push   $0xc
  802222:	e8 60 fe ff ff       	call   802087 <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	ff 75 08             	pushl  0x8(%ebp)
  80223a:	6a 0d                	push   $0xd
  80223c:	e8 46 fe ff ff       	call   802087 <syscall>
  802241:	83 c4 18             	add    $0x18,%esp
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 0e                	push   $0xe
  802255:	e8 2d fe ff ff       	call   802087 <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
}
  80225d:	90                   	nop
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 00                	push   $0x0
  80226d:	6a 13                	push   $0x13
  80226f:	e8 13 fe ff ff       	call   802087 <syscall>
  802274:	83 c4 18             	add    $0x18,%esp
}
  802277:	90                   	nop
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 14                	push   $0x14
  802289:	e8 f9 fd ff ff       	call   802087 <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
}
  802291:	90                   	nop
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <sys_cputc>:


void
sys_cputc(const char c)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
  802297:	83 ec 04             	sub    $0x4,%esp
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022a0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	50                   	push   %eax
  8022ad:	6a 15                	push   $0x15
  8022af:	e8 d3 fd ff ff       	call   802087 <syscall>
  8022b4:	83 c4 18             	add    $0x18,%esp
}
  8022b7:	90                   	nop
  8022b8:	c9                   	leave  
  8022b9:	c3                   	ret    

008022ba <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 16                	push   $0x16
  8022c9:	e8 b9 fd ff ff       	call   802087 <syscall>
  8022ce:	83 c4 18             	add    $0x18,%esp
}
  8022d1:	90                   	nop
  8022d2:	c9                   	leave  
  8022d3:	c3                   	ret    

008022d4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	ff 75 0c             	pushl  0xc(%ebp)
  8022e3:	50                   	push   %eax
  8022e4:	6a 17                	push   $0x17
  8022e6:	e8 9c fd ff ff       	call   802087 <syscall>
  8022eb:	83 c4 18             	add    $0x18,%esp
}
  8022ee:	c9                   	leave  
  8022ef:	c3                   	ret    

008022f0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	52                   	push   %edx
  802300:	50                   	push   %eax
  802301:	6a 1a                	push   $0x1a
  802303:	e8 7f fd ff ff       	call   802087 <syscall>
  802308:	83 c4 18             	add    $0x18,%esp
}
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802310:	8b 55 0c             	mov    0xc(%ebp),%edx
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	52                   	push   %edx
  80231d:	50                   	push   %eax
  80231e:	6a 18                	push   $0x18
  802320:	e8 62 fd ff ff       	call   802087 <syscall>
  802325:	83 c4 18             	add    $0x18,%esp
}
  802328:	90                   	nop
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80232e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	52                   	push   %edx
  80233b:	50                   	push   %eax
  80233c:	6a 19                	push   $0x19
  80233e:	e8 44 fd ff ff       	call   802087 <syscall>
  802343:	83 c4 18             	add    $0x18,%esp
}
  802346:	90                   	nop
  802347:	c9                   	leave  
  802348:	c3                   	ret    

00802349 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
  80234c:	83 ec 04             	sub    $0x4,%esp
  80234f:	8b 45 10             	mov    0x10(%ebp),%eax
  802352:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802355:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802358:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	6a 00                	push   $0x0
  802361:	51                   	push   %ecx
  802362:	52                   	push   %edx
  802363:	ff 75 0c             	pushl  0xc(%ebp)
  802366:	50                   	push   %eax
  802367:	6a 1b                	push   $0x1b
  802369:	e8 19 fd ff ff       	call   802087 <syscall>
  80236e:	83 c4 18             	add    $0x18,%esp
}
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802376:	8b 55 0c             	mov    0xc(%ebp),%edx
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	52                   	push   %edx
  802383:	50                   	push   %eax
  802384:	6a 1c                	push   $0x1c
  802386:	e8 fc fc ff ff       	call   802087 <syscall>
  80238b:	83 c4 18             	add    $0x18,%esp
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802393:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802396:	8b 55 0c             	mov    0xc(%ebp),%edx
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	51                   	push   %ecx
  8023a1:	52                   	push   %edx
  8023a2:	50                   	push   %eax
  8023a3:	6a 1d                	push   $0x1d
  8023a5:	e8 dd fc ff ff       	call   802087 <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
}
  8023ad:	c9                   	leave  
  8023ae:	c3                   	ret    

008023af <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	52                   	push   %edx
  8023bf:	50                   	push   %eax
  8023c0:	6a 1e                	push   $0x1e
  8023c2:	e8 c0 fc ff ff       	call   802087 <syscall>
  8023c7:	83 c4 18             	add    $0x18,%esp
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 1f                	push   $0x1f
  8023db:	e8 a7 fc ff ff       	call   802087 <syscall>
  8023e0:	83 c4 18             	add    $0x18,%esp
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	6a 00                	push   $0x0
  8023ed:	ff 75 14             	pushl  0x14(%ebp)
  8023f0:	ff 75 10             	pushl  0x10(%ebp)
  8023f3:	ff 75 0c             	pushl  0xc(%ebp)
  8023f6:	50                   	push   %eax
  8023f7:	6a 20                	push   $0x20
  8023f9:	e8 89 fc ff ff       	call   802087 <syscall>
  8023fe:	83 c4 18             	add    $0x18,%esp
}
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	50                   	push   %eax
  802412:	6a 21                	push   $0x21
  802414:	e8 6e fc ff ff       	call   802087 <syscall>
  802419:	83 c4 18             	add    $0x18,%esp
}
  80241c:	90                   	nop
  80241d:	c9                   	leave  
  80241e:	c3                   	ret    

0080241f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80241f:	55                   	push   %ebp
  802420:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	50                   	push   %eax
  80242e:	6a 22                	push   $0x22
  802430:	e8 52 fc ff ff       	call   802087 <syscall>
  802435:	83 c4 18             	add    $0x18,%esp
}
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 02                	push   $0x2
  802449:	e8 39 fc ff ff       	call   802087 <syscall>
  80244e:	83 c4 18             	add    $0x18,%esp
}
  802451:	c9                   	leave  
  802452:	c3                   	ret    

00802453 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802453:	55                   	push   %ebp
  802454:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 03                	push   $0x3
  802462:	e8 20 fc ff ff       	call   802087 <syscall>
  802467:	83 c4 18             	add    $0x18,%esp
}
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 04                	push   $0x4
  80247b:	e8 07 fc ff ff       	call   802087 <syscall>
  802480:	83 c4 18             	add    $0x18,%esp
}
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <sys_exit_env>:


void sys_exit_env(void)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 23                	push   $0x23
  802494:	e8 ee fb ff ff       	call   802087 <syscall>
  802499:	83 c4 18             	add    $0x18,%esp
}
  80249c:	90                   	nop
  80249d:	c9                   	leave  
  80249e:	c3                   	ret    

0080249f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
  8024a2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024a5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024a8:	8d 50 04             	lea    0x4(%eax),%edx
  8024ab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	52                   	push   %edx
  8024b5:	50                   	push   %eax
  8024b6:	6a 24                	push   $0x24
  8024b8:	e8 ca fb ff ff       	call   802087 <syscall>
  8024bd:	83 c4 18             	add    $0x18,%esp
	return result;
  8024c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024c9:	89 01                	mov    %eax,(%ecx)
  8024cb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d1:	c9                   	leave  
  8024d2:	c2 04 00             	ret    $0x4

008024d5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	ff 75 10             	pushl  0x10(%ebp)
  8024df:	ff 75 0c             	pushl  0xc(%ebp)
  8024e2:	ff 75 08             	pushl  0x8(%ebp)
  8024e5:	6a 12                	push   $0x12
  8024e7:	e8 9b fb ff ff       	call   802087 <syscall>
  8024ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ef:	90                   	nop
}
  8024f0:	c9                   	leave  
  8024f1:	c3                   	ret    

008024f2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 25                	push   $0x25
  802501:	e8 81 fb ff ff       	call   802087 <syscall>
  802506:	83 c4 18             	add    $0x18,%esp
}
  802509:	c9                   	leave  
  80250a:	c3                   	ret    

0080250b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
  80250e:	83 ec 04             	sub    $0x4,%esp
  802511:	8b 45 08             	mov    0x8(%ebp),%eax
  802514:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802517:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	50                   	push   %eax
  802524:	6a 26                	push   $0x26
  802526:	e8 5c fb ff ff       	call   802087 <syscall>
  80252b:	83 c4 18             	add    $0x18,%esp
	return ;
  80252e:	90                   	nop
}
  80252f:	c9                   	leave  
  802530:	c3                   	ret    

00802531 <rsttst>:
void rsttst()
{
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	6a 28                	push   $0x28
  802540:	e8 42 fb ff ff       	call   802087 <syscall>
  802545:	83 c4 18             	add    $0x18,%esp
	return ;
  802548:	90                   	nop
}
  802549:	c9                   	leave  
  80254a:	c3                   	ret    

0080254b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
  80254e:	83 ec 04             	sub    $0x4,%esp
  802551:	8b 45 14             	mov    0x14(%ebp),%eax
  802554:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802557:	8b 55 18             	mov    0x18(%ebp),%edx
  80255a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80255e:	52                   	push   %edx
  80255f:	50                   	push   %eax
  802560:	ff 75 10             	pushl  0x10(%ebp)
  802563:	ff 75 0c             	pushl  0xc(%ebp)
  802566:	ff 75 08             	pushl  0x8(%ebp)
  802569:	6a 27                	push   $0x27
  80256b:	e8 17 fb ff ff       	call   802087 <syscall>
  802570:	83 c4 18             	add    $0x18,%esp
	return ;
  802573:	90                   	nop
}
  802574:	c9                   	leave  
  802575:	c3                   	ret    

00802576 <chktst>:
void chktst(uint32 n)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	ff 75 08             	pushl  0x8(%ebp)
  802584:	6a 29                	push   $0x29
  802586:	e8 fc fa ff ff       	call   802087 <syscall>
  80258b:	83 c4 18             	add    $0x18,%esp
	return ;
  80258e:	90                   	nop
}
  80258f:	c9                   	leave  
  802590:	c3                   	ret    

00802591 <inctst>:

void inctst()
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 2a                	push   $0x2a
  8025a0:	e8 e2 fa ff ff       	call   802087 <syscall>
  8025a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a8:	90                   	nop
}
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <gettst>:
uint32 gettst()
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 2b                	push   $0x2b
  8025ba:	e8 c8 fa ff ff       	call   802087 <syscall>
  8025bf:	83 c4 18             	add    $0x18,%esp
}
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ca:	6a 00                	push   $0x0
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 2c                	push   $0x2c
  8025d6:	e8 ac fa ff ff       	call   802087 <syscall>
  8025db:	83 c4 18             	add    $0x18,%esp
  8025de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025e1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025e5:	75 07                	jne    8025ee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ec:	eb 05                	jmp    8025f3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f3:	c9                   	leave  
  8025f4:	c3                   	ret    

008025f5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025f5:	55                   	push   %ebp
  8025f6:	89 e5                	mov    %esp,%ebp
  8025f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 2c                	push   $0x2c
  802607:	e8 7b fa ff ff       	call   802087 <syscall>
  80260c:	83 c4 18             	add    $0x18,%esp
  80260f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802612:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802616:	75 07                	jne    80261f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802618:	b8 01 00 00 00       	mov    $0x1,%eax
  80261d:	eb 05                	jmp    802624 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80261f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802624:	c9                   	leave  
  802625:	c3                   	ret    

00802626 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
  802629:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 2c                	push   $0x2c
  802638:	e8 4a fa ff ff       	call   802087 <syscall>
  80263d:	83 c4 18             	add    $0x18,%esp
  802640:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802643:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802647:	75 07                	jne    802650 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802649:	b8 01 00 00 00       	mov    $0x1,%eax
  80264e:	eb 05                	jmp    802655 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802650:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802655:	c9                   	leave  
  802656:	c3                   	ret    

00802657 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
  80265a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 2c                	push   $0x2c
  802669:	e8 19 fa ff ff       	call   802087 <syscall>
  80266e:	83 c4 18             	add    $0x18,%esp
  802671:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802674:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802678:	75 07                	jne    802681 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80267a:	b8 01 00 00 00       	mov    $0x1,%eax
  80267f:	eb 05                	jmp    802686 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802681:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802686:	c9                   	leave  
  802687:	c3                   	ret    

00802688 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80268b:	6a 00                	push   $0x0
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	ff 75 08             	pushl  0x8(%ebp)
  802696:	6a 2d                	push   $0x2d
  802698:	e8 ea f9 ff ff       	call   802087 <syscall>
  80269d:	83 c4 18             	add    $0x18,%esp
	return ;
  8026a0:	90                   	nop
}
  8026a1:	c9                   	leave  
  8026a2:	c3                   	ret    

008026a3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026a3:	55                   	push   %ebp
  8026a4:	89 e5                	mov    %esp,%ebp
  8026a6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b3:	6a 00                	push   $0x0
  8026b5:	53                   	push   %ebx
  8026b6:	51                   	push   %ecx
  8026b7:	52                   	push   %edx
  8026b8:	50                   	push   %eax
  8026b9:	6a 2e                	push   $0x2e
  8026bb:	e8 c7 f9 ff ff       	call   802087 <syscall>
  8026c0:	83 c4 18             	add    $0x18,%esp
}
  8026c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026c6:	c9                   	leave  
  8026c7:	c3                   	ret    

008026c8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026c8:	55                   	push   %ebp
  8026c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	52                   	push   %edx
  8026d8:	50                   	push   %eax
  8026d9:	6a 2f                	push   $0x2f
  8026db:	e8 a7 f9 ff ff       	call   802087 <syscall>
  8026e0:	83 c4 18             	add    $0x18,%esp
}
  8026e3:	c9                   	leave  
  8026e4:	c3                   	ret    

008026e5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
  8026e8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026eb:	83 ec 0c             	sub    $0xc,%esp
  8026ee:	68 f4 42 80 00       	push   $0x8042f4
  8026f3:	e8 bd e4 ff ff       	call   800bb5 <cprintf>
  8026f8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802702:	83 ec 0c             	sub    $0xc,%esp
  802705:	68 20 43 80 00       	push   $0x804320
  80270a:	e8 a6 e4 ff ff       	call   800bb5 <cprintf>
  80270f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802712:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802716:	a1 38 51 80 00       	mov    0x805138,%eax
  80271b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271e:	eb 56                	jmp    802776 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802720:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802724:	74 1c                	je     802742 <print_mem_block_lists+0x5d>
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 50 08             	mov    0x8(%eax),%edx
  80272c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272f:	8b 48 08             	mov    0x8(%eax),%ecx
  802732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802735:	8b 40 0c             	mov    0xc(%eax),%eax
  802738:	01 c8                	add    %ecx,%eax
  80273a:	39 c2                	cmp    %eax,%edx
  80273c:	73 04                	jae    802742 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80273e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 50 08             	mov    0x8(%eax),%edx
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 40 0c             	mov    0xc(%eax),%eax
  80274e:	01 c2                	add    %eax,%edx
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 40 08             	mov    0x8(%eax),%eax
  802756:	83 ec 04             	sub    $0x4,%esp
  802759:	52                   	push   %edx
  80275a:	50                   	push   %eax
  80275b:	68 35 43 80 00       	push   $0x804335
  802760:	e8 50 e4 ff ff       	call   800bb5 <cprintf>
  802765:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80276e:	a1 40 51 80 00       	mov    0x805140,%eax
  802773:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277a:	74 07                	je     802783 <print_mem_block_lists+0x9e>
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	8b 00                	mov    (%eax),%eax
  802781:	eb 05                	jmp    802788 <print_mem_block_lists+0xa3>
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
  802788:	a3 40 51 80 00       	mov    %eax,0x805140
  80278d:	a1 40 51 80 00       	mov    0x805140,%eax
  802792:	85 c0                	test   %eax,%eax
  802794:	75 8a                	jne    802720 <print_mem_block_lists+0x3b>
  802796:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279a:	75 84                	jne    802720 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80279c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027a0:	75 10                	jne    8027b2 <print_mem_block_lists+0xcd>
  8027a2:	83 ec 0c             	sub    $0xc,%esp
  8027a5:	68 44 43 80 00       	push   $0x804344
  8027aa:	e8 06 e4 ff ff       	call   800bb5 <cprintf>
  8027af:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8027b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8027b9:	83 ec 0c             	sub    $0xc,%esp
  8027bc:	68 68 43 80 00       	push   $0x804368
  8027c1:	e8 ef e3 ff ff       	call   800bb5 <cprintf>
  8027c6:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8027c9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027cd:	a1 40 50 80 00       	mov    0x805040,%eax
  8027d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d5:	eb 56                	jmp    80282d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027db:	74 1c                	je     8027f9 <print_mem_block_lists+0x114>
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 50 08             	mov    0x8(%eax),%edx
  8027e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e6:	8b 48 08             	mov    0x8(%eax),%ecx
  8027e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ef:	01 c8                	add    %ecx,%eax
  8027f1:	39 c2                	cmp    %eax,%edx
  8027f3:	73 04                	jae    8027f9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027f5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 50 08             	mov    0x8(%eax),%edx
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 40 0c             	mov    0xc(%eax),%eax
  802805:	01 c2                	add    %eax,%edx
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 40 08             	mov    0x8(%eax),%eax
  80280d:	83 ec 04             	sub    $0x4,%esp
  802810:	52                   	push   %edx
  802811:	50                   	push   %eax
  802812:	68 35 43 80 00       	push   $0x804335
  802817:	e8 99 e3 ff ff       	call   800bb5 <cprintf>
  80281c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802825:	a1 48 50 80 00       	mov    0x805048,%eax
  80282a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802831:	74 07                	je     80283a <print_mem_block_lists+0x155>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	eb 05                	jmp    80283f <print_mem_block_lists+0x15a>
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
  80283f:	a3 48 50 80 00       	mov    %eax,0x805048
  802844:	a1 48 50 80 00       	mov    0x805048,%eax
  802849:	85 c0                	test   %eax,%eax
  80284b:	75 8a                	jne    8027d7 <print_mem_block_lists+0xf2>
  80284d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802851:	75 84                	jne    8027d7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802853:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802857:	75 10                	jne    802869 <print_mem_block_lists+0x184>
  802859:	83 ec 0c             	sub    $0xc,%esp
  80285c:	68 80 43 80 00       	push   $0x804380
  802861:	e8 4f e3 ff ff       	call   800bb5 <cprintf>
  802866:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802869:	83 ec 0c             	sub    $0xc,%esp
  80286c:	68 f4 42 80 00       	push   $0x8042f4
  802871:	e8 3f e3 ff ff       	call   800bb5 <cprintf>
  802876:	83 c4 10             	add    $0x10,%esp

}
  802879:	90                   	nop
  80287a:	c9                   	leave  
  80287b:	c3                   	ret    

0080287c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80287c:	55                   	push   %ebp
  80287d:	89 e5                	mov    %esp,%ebp
  80287f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802882:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802889:	00 00 00 
  80288c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802893:	00 00 00 
  802896:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80289d:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8028a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028a7:	e9 9e 00 00 00       	jmp    80294a <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8028ac:	a1 50 50 80 00       	mov    0x805050,%eax
  8028b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b4:	c1 e2 04             	shl    $0x4,%edx
  8028b7:	01 d0                	add    %edx,%eax
  8028b9:	85 c0                	test   %eax,%eax
  8028bb:	75 14                	jne    8028d1 <initialize_MemBlocksList+0x55>
  8028bd:	83 ec 04             	sub    $0x4,%esp
  8028c0:	68 a8 43 80 00       	push   $0x8043a8
  8028c5:	6a 47                	push   $0x47
  8028c7:	68 cb 43 80 00       	push   $0x8043cb
  8028cc:	e8 30 e0 ff ff       	call   800901 <_panic>
  8028d1:	a1 50 50 80 00       	mov    0x805050,%eax
  8028d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d9:	c1 e2 04             	shl    $0x4,%edx
  8028dc:	01 d0                	add    %edx,%eax
  8028de:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8028e4:	89 10                	mov    %edx,(%eax)
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	85 c0                	test   %eax,%eax
  8028ea:	74 18                	je     802904 <initialize_MemBlocksList+0x88>
  8028ec:	a1 48 51 80 00       	mov    0x805148,%eax
  8028f1:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028f7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028fa:	c1 e1 04             	shl    $0x4,%ecx
  8028fd:	01 ca                	add    %ecx,%edx
  8028ff:	89 50 04             	mov    %edx,0x4(%eax)
  802902:	eb 12                	jmp    802916 <initialize_MemBlocksList+0x9a>
  802904:	a1 50 50 80 00       	mov    0x805050,%eax
  802909:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290c:	c1 e2 04             	shl    $0x4,%edx
  80290f:	01 d0                	add    %edx,%eax
  802911:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802916:	a1 50 50 80 00       	mov    0x805050,%eax
  80291b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291e:	c1 e2 04             	shl    $0x4,%edx
  802921:	01 d0                	add    %edx,%eax
  802923:	a3 48 51 80 00       	mov    %eax,0x805148
  802928:	a1 50 50 80 00       	mov    0x805050,%eax
  80292d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802930:	c1 e2 04             	shl    $0x4,%edx
  802933:	01 d0                	add    %edx,%eax
  802935:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293c:	a1 54 51 80 00       	mov    0x805154,%eax
  802941:	40                   	inc    %eax
  802942:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802947:	ff 45 f4             	incl   -0xc(%ebp)
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802950:	0f 82 56 ff ff ff    	jb     8028ac <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802956:	90                   	nop
  802957:	c9                   	leave  
  802958:	c3                   	ret    

00802959 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802959:	55                   	push   %ebp
  80295a:	89 e5                	mov    %esp,%ebp
  80295c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80295f:	8b 45 08             	mov    0x8(%ebp),%eax
  802962:	8b 00                	mov    (%eax),%eax
  802964:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802967:	eb 19                	jmp    802982 <find_block+0x29>
	{
		if(element->sva == va){
  802969:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80296c:	8b 40 08             	mov    0x8(%eax),%eax
  80296f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802972:	75 05                	jne    802979 <find_block+0x20>
			 		return element;
  802974:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802977:	eb 36                	jmp    8029af <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	8b 40 08             	mov    0x8(%eax),%eax
  80297f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802982:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802986:	74 07                	je     80298f <find_block+0x36>
  802988:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	eb 05                	jmp    802994 <find_block+0x3b>
  80298f:	b8 00 00 00 00       	mov    $0x0,%eax
  802994:	8b 55 08             	mov    0x8(%ebp),%edx
  802997:	89 42 08             	mov    %eax,0x8(%edx)
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	8b 40 08             	mov    0x8(%eax),%eax
  8029a0:	85 c0                	test   %eax,%eax
  8029a2:	75 c5                	jne    802969 <find_block+0x10>
  8029a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029a8:	75 bf                	jne    802969 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  8029aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029af:	c9                   	leave  
  8029b0:	c3                   	ret    

008029b1 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8029b1:	55                   	push   %ebp
  8029b2:	89 e5                	mov    %esp,%ebp
  8029b4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  8029b7:	a1 44 50 80 00       	mov    0x805044,%eax
  8029bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  8029bf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  8029c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029cb:	74 0a                	je     8029d7 <insert_sorted_allocList+0x26>
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	8b 40 08             	mov    0x8(%eax),%eax
  8029d3:	85 c0                	test   %eax,%eax
  8029d5:	75 65                	jne    802a3c <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8029d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029db:	75 14                	jne    8029f1 <insert_sorted_allocList+0x40>
  8029dd:	83 ec 04             	sub    $0x4,%esp
  8029e0:	68 a8 43 80 00       	push   $0x8043a8
  8029e5:	6a 6e                	push   $0x6e
  8029e7:	68 cb 43 80 00       	push   $0x8043cb
  8029ec:	e8 10 df ff ff       	call   800901 <_panic>
  8029f1:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fa:	89 10                	mov    %edx,(%eax)
  8029fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ff:	8b 00                	mov    (%eax),%eax
  802a01:	85 c0                	test   %eax,%eax
  802a03:	74 0d                	je     802a12 <insert_sorted_allocList+0x61>
  802a05:	a1 40 50 80 00       	mov    0x805040,%eax
  802a0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0d:	89 50 04             	mov    %edx,0x4(%eax)
  802a10:	eb 08                	jmp    802a1a <insert_sorted_allocList+0x69>
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	a3 44 50 80 00       	mov    %eax,0x805044
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	a3 40 50 80 00       	mov    %eax,0x805040
  802a22:	8b 45 08             	mov    0x8(%ebp),%eax
  802a25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a31:	40                   	inc    %eax
  802a32:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802a37:	e9 cf 01 00 00       	jmp    802c0b <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3f:	8b 50 08             	mov    0x8(%eax),%edx
  802a42:	8b 45 08             	mov    0x8(%ebp),%eax
  802a45:	8b 40 08             	mov    0x8(%eax),%eax
  802a48:	39 c2                	cmp    %eax,%edx
  802a4a:	73 65                	jae    802ab1 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802a4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a50:	75 14                	jne    802a66 <insert_sorted_allocList+0xb5>
  802a52:	83 ec 04             	sub    $0x4,%esp
  802a55:	68 e4 43 80 00       	push   $0x8043e4
  802a5a:	6a 72                	push   $0x72
  802a5c:	68 cb 43 80 00       	push   $0x8043cb
  802a61:	e8 9b de ff ff       	call   800901 <_panic>
  802a66:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6f:	89 50 04             	mov    %edx,0x4(%eax)
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	8b 40 04             	mov    0x4(%eax),%eax
  802a78:	85 c0                	test   %eax,%eax
  802a7a:	74 0c                	je     802a88 <insert_sorted_allocList+0xd7>
  802a7c:	a1 44 50 80 00       	mov    0x805044,%eax
  802a81:	8b 55 08             	mov    0x8(%ebp),%edx
  802a84:	89 10                	mov    %edx,(%eax)
  802a86:	eb 08                	jmp    802a90 <insert_sorted_allocList+0xdf>
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	a3 40 50 80 00       	mov    %eax,0x805040
  802a90:	8b 45 08             	mov    0x8(%ebp),%eax
  802a93:	a3 44 50 80 00       	mov    %eax,0x805044
  802a98:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802aa6:	40                   	inc    %eax
  802aa7:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802aac:	e9 5a 01 00 00       	jmp    802c0b <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab4:	8b 50 08             	mov    0x8(%eax),%edx
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	8b 40 08             	mov    0x8(%eax),%eax
  802abd:	39 c2                	cmp    %eax,%edx
  802abf:	75 70                	jne    802b31 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802ac1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac5:	74 06                	je     802acd <insert_sorted_allocList+0x11c>
  802ac7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802acb:	75 14                	jne    802ae1 <insert_sorted_allocList+0x130>
  802acd:	83 ec 04             	sub    $0x4,%esp
  802ad0:	68 08 44 80 00       	push   $0x804408
  802ad5:	6a 75                	push   $0x75
  802ad7:	68 cb 43 80 00       	push   $0x8043cb
  802adc:	e8 20 de ff ff       	call   800901 <_panic>
  802ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae4:	8b 10                	mov    (%eax),%edx
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	89 10                	mov    %edx,(%eax)
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	8b 00                	mov    (%eax),%eax
  802af0:	85 c0                	test   %eax,%eax
  802af2:	74 0b                	je     802aff <insert_sorted_allocList+0x14e>
  802af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	8b 55 08             	mov    0x8(%ebp),%edx
  802afc:	89 50 04             	mov    %edx,0x4(%eax)
  802aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b02:	8b 55 08             	mov    0x8(%ebp),%edx
  802b05:	89 10                	mov    %edx,(%eax)
  802b07:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b0d:	89 50 04             	mov    %edx,0x4(%eax)
  802b10:	8b 45 08             	mov    0x8(%ebp),%eax
  802b13:	8b 00                	mov    (%eax),%eax
  802b15:	85 c0                	test   %eax,%eax
  802b17:	75 08                	jne    802b21 <insert_sorted_allocList+0x170>
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	a3 44 50 80 00       	mov    %eax,0x805044
  802b21:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b26:	40                   	inc    %eax
  802b27:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802b2c:	e9 da 00 00 00       	jmp    802c0b <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802b31:	a1 40 50 80 00       	mov    0x805040,%eax
  802b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b39:	e9 9d 00 00 00       	jmp    802bdb <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802b46:	8b 45 08             	mov    0x8(%ebp),%eax
  802b49:	8b 50 08             	mov    0x8(%eax),%edx
  802b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4f:	8b 40 08             	mov    0x8(%eax),%eax
  802b52:	39 c2                	cmp    %eax,%edx
  802b54:	76 7d                	jbe    802bd3 <insert_sorted_allocList+0x222>
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	8b 50 08             	mov    0x8(%eax),%edx
  802b5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5f:	8b 40 08             	mov    0x8(%eax),%eax
  802b62:	39 c2                	cmp    %eax,%edx
  802b64:	73 6d                	jae    802bd3 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802b66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6a:	74 06                	je     802b72 <insert_sorted_allocList+0x1c1>
  802b6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b70:	75 14                	jne    802b86 <insert_sorted_allocList+0x1d5>
  802b72:	83 ec 04             	sub    $0x4,%esp
  802b75:	68 08 44 80 00       	push   $0x804408
  802b7a:	6a 7c                	push   $0x7c
  802b7c:	68 cb 43 80 00       	push   $0x8043cb
  802b81:	e8 7b dd ff ff       	call   800901 <_panic>
  802b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b89:	8b 10                	mov    (%eax),%edx
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	89 10                	mov    %edx,(%eax)
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	8b 00                	mov    (%eax),%eax
  802b95:	85 c0                	test   %eax,%eax
  802b97:	74 0b                	je     802ba4 <insert_sorted_allocList+0x1f3>
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 00                	mov    (%eax),%eax
  802b9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba1:	89 50 04             	mov    %edx,0x4(%eax)
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  802baa:	89 10                	mov    %edx,(%eax)
  802bac:	8b 45 08             	mov    0x8(%ebp),%eax
  802baf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb2:	89 50 04             	mov    %edx,0x4(%eax)
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	8b 00                	mov    (%eax),%eax
  802bba:	85 c0                	test   %eax,%eax
  802bbc:	75 08                	jne    802bc6 <insert_sorted_allocList+0x215>
  802bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc1:	a3 44 50 80 00       	mov    %eax,0x805044
  802bc6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bcb:	40                   	inc    %eax
  802bcc:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802bd1:	eb 38                	jmp    802c0b <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802bd3:	a1 48 50 80 00       	mov    0x805048,%eax
  802bd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdf:	74 07                	je     802be8 <insert_sorted_allocList+0x237>
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	8b 00                	mov    (%eax),%eax
  802be6:	eb 05                	jmp    802bed <insert_sorted_allocList+0x23c>
  802be8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bed:	a3 48 50 80 00       	mov    %eax,0x805048
  802bf2:	a1 48 50 80 00       	mov    0x805048,%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	0f 85 3f ff ff ff    	jne    802b3e <insert_sorted_allocList+0x18d>
  802bff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c03:	0f 85 35 ff ff ff    	jne    802b3e <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802c09:	eb 00                	jmp    802c0b <insert_sorted_allocList+0x25a>
  802c0b:	90                   	nop
  802c0c:	c9                   	leave  
  802c0d:	c3                   	ret    

00802c0e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c0e:	55                   	push   %ebp
  802c0f:	89 e5                	mov    %esp,%ebp
  802c11:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802c14:	a1 38 51 80 00       	mov    0x805138,%eax
  802c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1c:	e9 6b 02 00 00       	jmp    802e8c <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 40 0c             	mov    0xc(%eax),%eax
  802c27:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c2a:	0f 85 90 00 00 00    	jne    802cc0 <alloc_block_FF+0xb2>
			  temp=element;
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802c36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3a:	75 17                	jne    802c53 <alloc_block_FF+0x45>
  802c3c:	83 ec 04             	sub    $0x4,%esp
  802c3f:	68 3c 44 80 00       	push   $0x80443c
  802c44:	68 92 00 00 00       	push   $0x92
  802c49:	68 cb 43 80 00       	push   $0x8043cb
  802c4e:	e8 ae dc ff ff       	call   800901 <_panic>
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	74 10                	je     802c6c <alloc_block_FF+0x5e>
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 00                	mov    (%eax),%eax
  802c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c64:	8b 52 04             	mov    0x4(%edx),%edx
  802c67:	89 50 04             	mov    %edx,0x4(%eax)
  802c6a:	eb 0b                	jmp    802c77 <alloc_block_FF+0x69>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 40 04             	mov    0x4(%eax),%eax
  802c72:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 40 04             	mov    0x4(%eax),%eax
  802c7d:	85 c0                	test   %eax,%eax
  802c7f:	74 0f                	je     802c90 <alloc_block_FF+0x82>
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 40 04             	mov    0x4(%eax),%eax
  802c87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8a:	8b 12                	mov    (%edx),%edx
  802c8c:	89 10                	mov    %edx,(%eax)
  802c8e:	eb 0a                	jmp    802c9a <alloc_block_FF+0x8c>
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	a3 38 51 80 00       	mov    %eax,0x805138
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cad:	a1 44 51 80 00       	mov    0x805144,%eax
  802cb2:	48                   	dec    %eax
  802cb3:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802cb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cbb:	e9 ff 01 00 00       	jmp    802ebf <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cc9:	0f 86 b5 01 00 00    	jbe    802e84 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd5:	2b 45 08             	sub    0x8(%ebp),%eax
  802cd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802cdb:	a1 48 51 80 00       	mov    0x805148,%eax
  802ce0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802ce3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ce7:	75 17                	jne    802d00 <alloc_block_FF+0xf2>
  802ce9:	83 ec 04             	sub    $0x4,%esp
  802cec:	68 3c 44 80 00       	push   $0x80443c
  802cf1:	68 99 00 00 00       	push   $0x99
  802cf6:	68 cb 43 80 00       	push   $0x8043cb
  802cfb:	e8 01 dc ff ff       	call   800901 <_panic>
  802d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d03:	8b 00                	mov    (%eax),%eax
  802d05:	85 c0                	test   %eax,%eax
  802d07:	74 10                	je     802d19 <alloc_block_FF+0x10b>
  802d09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0c:	8b 00                	mov    (%eax),%eax
  802d0e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d11:	8b 52 04             	mov    0x4(%edx),%edx
  802d14:	89 50 04             	mov    %edx,0x4(%eax)
  802d17:	eb 0b                	jmp    802d24 <alloc_block_FF+0x116>
  802d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1c:	8b 40 04             	mov    0x4(%eax),%eax
  802d1f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d27:	8b 40 04             	mov    0x4(%eax),%eax
  802d2a:	85 c0                	test   %eax,%eax
  802d2c:	74 0f                	je     802d3d <alloc_block_FF+0x12f>
  802d2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d31:	8b 40 04             	mov    0x4(%eax),%eax
  802d34:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d37:	8b 12                	mov    (%edx),%edx
  802d39:	89 10                	mov    %edx,(%eax)
  802d3b:	eb 0a                	jmp    802d47 <alloc_block_FF+0x139>
  802d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d40:	8b 00                	mov    (%eax),%eax
  802d42:	a3 48 51 80 00       	mov    %eax,0x805148
  802d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5a:	a1 54 51 80 00       	mov    0x805154,%eax
  802d5f:	48                   	dec    %eax
  802d60:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802d65:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d69:	75 17                	jne    802d82 <alloc_block_FF+0x174>
  802d6b:	83 ec 04             	sub    $0x4,%esp
  802d6e:	68 e4 43 80 00       	push   $0x8043e4
  802d73:	68 9a 00 00 00       	push   $0x9a
  802d78:	68 cb 43 80 00       	push   $0x8043cb
  802d7d:	e8 7f db ff ff       	call   800901 <_panic>
  802d82:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8b:	89 50 04             	mov    %edx,0x4(%eax)
  802d8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d91:	8b 40 04             	mov    0x4(%eax),%eax
  802d94:	85 c0                	test   %eax,%eax
  802d96:	74 0c                	je     802da4 <alloc_block_FF+0x196>
  802d98:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802da0:	89 10                	mov    %edx,(%eax)
  802da2:	eb 08                	jmp    802dac <alloc_block_FF+0x19e>
  802da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da7:	a3 38 51 80 00       	mov    %eax,0x805138
  802dac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802daf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802db4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dbd:	a1 44 51 80 00       	mov    0x805144,%eax
  802dc2:	40                   	inc    %eax
  802dc3:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802dc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dce:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	8b 50 08             	mov    0x8(%eax),%edx
  802dd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dda:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802de3:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	8b 50 08             	mov    0x8(%eax),%edx
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	01 c2                	add    %eax,%edx
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802dfd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e01:	75 17                	jne    802e1a <alloc_block_FF+0x20c>
  802e03:	83 ec 04             	sub    $0x4,%esp
  802e06:	68 3c 44 80 00       	push   $0x80443c
  802e0b:	68 a2 00 00 00       	push   $0xa2
  802e10:	68 cb 43 80 00       	push   $0x8043cb
  802e15:	e8 e7 da ff ff       	call   800901 <_panic>
  802e1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 10                	je     802e33 <alloc_block_FF+0x225>
  802e23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e26:	8b 00                	mov    (%eax),%eax
  802e28:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e2b:	8b 52 04             	mov    0x4(%edx),%edx
  802e2e:	89 50 04             	mov    %edx,0x4(%eax)
  802e31:	eb 0b                	jmp    802e3e <alloc_block_FF+0x230>
  802e33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e36:	8b 40 04             	mov    0x4(%eax),%eax
  802e39:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e41:	8b 40 04             	mov    0x4(%eax),%eax
  802e44:	85 c0                	test   %eax,%eax
  802e46:	74 0f                	je     802e57 <alloc_block_FF+0x249>
  802e48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4b:	8b 40 04             	mov    0x4(%eax),%eax
  802e4e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e51:	8b 12                	mov    (%edx),%edx
  802e53:	89 10                	mov    %edx,(%eax)
  802e55:	eb 0a                	jmp    802e61 <alloc_block_FF+0x253>
  802e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5a:	8b 00                	mov    (%eax),%eax
  802e5c:	a3 38 51 80 00       	mov    %eax,0x805138
  802e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e74:	a1 44 51 80 00       	mov    0x805144,%eax
  802e79:	48                   	dec    %eax
  802e7a:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802e7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e82:	eb 3b                	jmp    802ebf <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802e84:	a1 40 51 80 00       	mov    0x805140,%eax
  802e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e90:	74 07                	je     802e99 <alloc_block_FF+0x28b>
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8b 00                	mov    (%eax),%eax
  802e97:	eb 05                	jmp    802e9e <alloc_block_FF+0x290>
  802e99:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9e:	a3 40 51 80 00       	mov    %eax,0x805140
  802ea3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ea8:	85 c0                	test   %eax,%eax
  802eaa:	0f 85 71 fd ff ff    	jne    802c21 <alloc_block_FF+0x13>
  802eb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb4:	0f 85 67 fd ff ff    	jne    802c21 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802eba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ebf:	c9                   	leave  
  802ec0:	c3                   	ret    

00802ec1 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ec1:	55                   	push   %ebp
  802ec2:	89 e5                	mov    %esp,%ebp
  802ec4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802ec7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802ece:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802ed5:	a1 38 51 80 00       	mov    0x805138,%eax
  802eda:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802edd:	e9 d3 00 00 00       	jmp    802fb5 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802ee2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eeb:	0f 85 90 00 00 00    	jne    802f81 <alloc_block_BF+0xc0>
	   temp = element;
  802ef1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802ef7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802efb:	75 17                	jne    802f14 <alloc_block_BF+0x53>
  802efd:	83 ec 04             	sub    $0x4,%esp
  802f00:	68 3c 44 80 00       	push   $0x80443c
  802f05:	68 bd 00 00 00       	push   $0xbd
  802f0a:	68 cb 43 80 00       	push   $0x8043cb
  802f0f:	e8 ed d9 ff ff       	call   800901 <_panic>
  802f14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f17:	8b 00                	mov    (%eax),%eax
  802f19:	85 c0                	test   %eax,%eax
  802f1b:	74 10                	je     802f2d <alloc_block_BF+0x6c>
  802f1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f20:	8b 00                	mov    (%eax),%eax
  802f22:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f25:	8b 52 04             	mov    0x4(%edx),%edx
  802f28:	89 50 04             	mov    %edx,0x4(%eax)
  802f2b:	eb 0b                	jmp    802f38 <alloc_block_BF+0x77>
  802f2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f30:	8b 40 04             	mov    0x4(%eax),%eax
  802f33:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3b:	8b 40 04             	mov    0x4(%eax),%eax
  802f3e:	85 c0                	test   %eax,%eax
  802f40:	74 0f                	je     802f51 <alloc_block_BF+0x90>
  802f42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f45:	8b 40 04             	mov    0x4(%eax),%eax
  802f48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f4b:	8b 12                	mov    (%edx),%edx
  802f4d:	89 10                	mov    %edx,(%eax)
  802f4f:	eb 0a                	jmp    802f5b <alloc_block_BF+0x9a>
  802f51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f54:	8b 00                	mov    (%eax),%eax
  802f56:	a3 38 51 80 00       	mov    %eax,0x805138
  802f5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6e:	a1 44 51 80 00       	mov    0x805144,%eax
  802f73:	48                   	dec    %eax
  802f74:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802f79:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f7c:	e9 41 01 00 00       	jmp    8030c2 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802f81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f84:	8b 40 0c             	mov    0xc(%eax),%eax
  802f87:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f8a:	76 21                	jbe    802fad <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802f8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f92:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f95:	73 16                	jae    802fad <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802f97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802fa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802fa6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802fad:	a1 40 51 80 00       	mov    0x805140,%eax
  802fb2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802fb5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fb9:	74 07                	je     802fc2 <alloc_block_BF+0x101>
  802fbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbe:	8b 00                	mov    (%eax),%eax
  802fc0:	eb 05                	jmp    802fc7 <alloc_block_BF+0x106>
  802fc2:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc7:	a3 40 51 80 00       	mov    %eax,0x805140
  802fcc:	a1 40 51 80 00       	mov    0x805140,%eax
  802fd1:	85 c0                	test   %eax,%eax
  802fd3:	0f 85 09 ff ff ff    	jne    802ee2 <alloc_block_BF+0x21>
  802fd9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fdd:	0f 85 ff fe ff ff    	jne    802ee2 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802fe3:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802fe7:	0f 85 d0 00 00 00    	jne    8030bd <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802fed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff3:	2b 45 08             	sub    0x8(%ebp),%eax
  802ff6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802ff9:	a1 48 51 80 00       	mov    0x805148,%eax
  802ffe:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  803001:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803005:	75 17                	jne    80301e <alloc_block_BF+0x15d>
  803007:	83 ec 04             	sub    $0x4,%esp
  80300a:	68 3c 44 80 00       	push   $0x80443c
  80300f:	68 d1 00 00 00       	push   $0xd1
  803014:	68 cb 43 80 00       	push   $0x8043cb
  803019:	e8 e3 d8 ff ff       	call   800901 <_panic>
  80301e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803021:	8b 00                	mov    (%eax),%eax
  803023:	85 c0                	test   %eax,%eax
  803025:	74 10                	je     803037 <alloc_block_BF+0x176>
  803027:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80302a:	8b 00                	mov    (%eax),%eax
  80302c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80302f:	8b 52 04             	mov    0x4(%edx),%edx
  803032:	89 50 04             	mov    %edx,0x4(%eax)
  803035:	eb 0b                	jmp    803042 <alloc_block_BF+0x181>
  803037:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80303a:	8b 40 04             	mov    0x4(%eax),%eax
  80303d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803042:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803045:	8b 40 04             	mov    0x4(%eax),%eax
  803048:	85 c0                	test   %eax,%eax
  80304a:	74 0f                	je     80305b <alloc_block_BF+0x19a>
  80304c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80304f:	8b 40 04             	mov    0x4(%eax),%eax
  803052:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803055:	8b 12                	mov    (%edx),%edx
  803057:	89 10                	mov    %edx,(%eax)
  803059:	eb 0a                	jmp    803065 <alloc_block_BF+0x1a4>
  80305b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80305e:	8b 00                	mov    (%eax),%eax
  803060:	a3 48 51 80 00       	mov    %eax,0x805148
  803065:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803068:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803071:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803078:	a1 54 51 80 00       	mov    0x805154,%eax
  80307d:	48                   	dec    %eax
  80307e:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  803083:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803086:	8b 55 08             	mov    0x8(%ebp),%edx
  803089:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  80308c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308f:	8b 50 08             	mov    0x8(%eax),%edx
  803092:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803095:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  803098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80309e:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  8030a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a4:	8b 50 08             	mov    0x8(%eax),%edx
  8030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030aa:	01 c2                	add    %eax,%edx
  8030ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030af:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  8030b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  8030b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030bb:	eb 05                	jmp    8030c2 <alloc_block_BF+0x201>
	 }
	 return NULL;
  8030bd:	b8 00 00 00 00       	mov    $0x0,%eax


}
  8030c2:	c9                   	leave  
  8030c3:	c3                   	ret    

008030c4 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8030c4:	55                   	push   %ebp
  8030c5:	89 e5                	mov    %esp,%ebp
  8030c7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8030ca:	83 ec 04             	sub    $0x4,%esp
  8030cd:	68 5c 44 80 00       	push   $0x80445c
  8030d2:	68 e8 00 00 00       	push   $0xe8
  8030d7:	68 cb 43 80 00       	push   $0x8043cb
  8030dc:	e8 20 d8 ff ff       	call   800901 <_panic>

008030e1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8030e1:	55                   	push   %ebp
  8030e2:	89 e5                	mov    %esp,%ebp
  8030e4:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  8030e7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  8030ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8030f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8030f7:	a1 44 51 80 00       	mov    0x805144,%eax
  8030fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8030ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803103:	75 68                	jne    80316d <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803109:	75 17                	jne    803122 <insert_sorted_with_merge_freeList+0x41>
  80310b:	83 ec 04             	sub    $0x4,%esp
  80310e:	68 a8 43 80 00       	push   $0x8043a8
  803113:	68 36 01 00 00       	push   $0x136
  803118:	68 cb 43 80 00       	push   $0x8043cb
  80311d:	e8 df d7 ff ff       	call   800901 <_panic>
  803122:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803128:	8b 45 08             	mov    0x8(%ebp),%eax
  80312b:	89 10                	mov    %edx,(%eax)
  80312d:	8b 45 08             	mov    0x8(%ebp),%eax
  803130:	8b 00                	mov    (%eax),%eax
  803132:	85 c0                	test   %eax,%eax
  803134:	74 0d                	je     803143 <insert_sorted_with_merge_freeList+0x62>
  803136:	a1 38 51 80 00       	mov    0x805138,%eax
  80313b:	8b 55 08             	mov    0x8(%ebp),%edx
  80313e:	89 50 04             	mov    %edx,0x4(%eax)
  803141:	eb 08                	jmp    80314b <insert_sorted_with_merge_freeList+0x6a>
  803143:	8b 45 08             	mov    0x8(%ebp),%eax
  803146:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	a3 38 51 80 00       	mov    %eax,0x805138
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315d:	a1 44 51 80 00       	mov    0x805144,%eax
  803162:	40                   	inc    %eax
  803163:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803168:	e9 ba 06 00 00       	jmp    803827 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  80316d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803170:	8b 50 08             	mov    0x8(%eax),%edx
  803173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803176:	8b 40 0c             	mov    0xc(%eax),%eax
  803179:	01 c2                	add    %eax,%edx
  80317b:	8b 45 08             	mov    0x8(%ebp),%eax
  80317e:	8b 40 08             	mov    0x8(%eax),%eax
  803181:	39 c2                	cmp    %eax,%edx
  803183:	73 68                	jae    8031ed <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803185:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803189:	75 17                	jne    8031a2 <insert_sorted_with_merge_freeList+0xc1>
  80318b:	83 ec 04             	sub    $0x4,%esp
  80318e:	68 e4 43 80 00       	push   $0x8043e4
  803193:	68 3a 01 00 00       	push   $0x13a
  803198:	68 cb 43 80 00       	push   $0x8043cb
  80319d:	e8 5f d7 ff ff       	call   800901 <_panic>
  8031a2:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	89 50 04             	mov    %edx,0x4(%eax)
  8031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b1:	8b 40 04             	mov    0x4(%eax),%eax
  8031b4:	85 c0                	test   %eax,%eax
  8031b6:	74 0c                	je     8031c4 <insert_sorted_with_merge_freeList+0xe3>
  8031b8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c0:	89 10                	mov    %edx,(%eax)
  8031c2:	eb 08                	jmp    8031cc <insert_sorted_with_merge_freeList+0xeb>
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	a3 38 51 80 00       	mov    %eax,0x805138
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031dd:	a1 44 51 80 00       	mov    0x805144,%eax
  8031e2:	40                   	inc    %eax
  8031e3:	a3 44 51 80 00       	mov    %eax,0x805144





}
  8031e8:	e9 3a 06 00 00       	jmp    803827 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  8031ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f0:	8b 50 08             	mov    0x8(%eax),%edx
  8031f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f9:	01 c2                	add    %eax,%edx
  8031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fe:	8b 40 08             	mov    0x8(%eax),%eax
  803201:	39 c2                	cmp    %eax,%edx
  803203:	0f 85 90 00 00 00    	jne    803299 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  803209:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320c:	8b 50 0c             	mov    0xc(%eax),%edx
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	8b 40 0c             	mov    0xc(%eax),%eax
  803215:	01 c2                	add    %eax,%edx
  803217:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321a:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  80321d:	8b 45 08             	mov    0x8(%ebp),%eax
  803220:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803231:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803235:	75 17                	jne    80324e <insert_sorted_with_merge_freeList+0x16d>
  803237:	83 ec 04             	sub    $0x4,%esp
  80323a:	68 a8 43 80 00       	push   $0x8043a8
  80323f:	68 41 01 00 00       	push   $0x141
  803244:	68 cb 43 80 00       	push   $0x8043cb
  803249:	e8 b3 d6 ff ff       	call   800901 <_panic>
  80324e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803254:	8b 45 08             	mov    0x8(%ebp),%eax
  803257:	89 10                	mov    %edx,(%eax)
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	8b 00                	mov    (%eax),%eax
  80325e:	85 c0                	test   %eax,%eax
  803260:	74 0d                	je     80326f <insert_sorted_with_merge_freeList+0x18e>
  803262:	a1 48 51 80 00       	mov    0x805148,%eax
  803267:	8b 55 08             	mov    0x8(%ebp),%edx
  80326a:	89 50 04             	mov    %edx,0x4(%eax)
  80326d:	eb 08                	jmp    803277 <insert_sorted_with_merge_freeList+0x196>
  80326f:	8b 45 08             	mov    0x8(%ebp),%eax
  803272:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803277:	8b 45 08             	mov    0x8(%ebp),%eax
  80327a:	a3 48 51 80 00       	mov    %eax,0x805148
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803289:	a1 54 51 80 00       	mov    0x805154,%eax
  80328e:	40                   	inc    %eax
  80328f:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803294:	e9 8e 05 00 00       	jmp    803827 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  803299:	8b 45 08             	mov    0x8(%ebp),%eax
  80329c:	8b 50 08             	mov    0x8(%eax),%edx
  80329f:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a5:	01 c2                	add    %eax,%edx
  8032a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032aa:	8b 40 08             	mov    0x8(%eax),%eax
  8032ad:	39 c2                	cmp    %eax,%edx
  8032af:	73 68                	jae    803319 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8032b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b5:	75 17                	jne    8032ce <insert_sorted_with_merge_freeList+0x1ed>
  8032b7:	83 ec 04             	sub    $0x4,%esp
  8032ba:	68 a8 43 80 00       	push   $0x8043a8
  8032bf:	68 45 01 00 00       	push   $0x145
  8032c4:	68 cb 43 80 00       	push   $0x8043cb
  8032c9:	e8 33 d6 ff ff       	call   800901 <_panic>
  8032ce:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d7:	89 10                	mov    %edx,(%eax)
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	8b 00                	mov    (%eax),%eax
  8032de:	85 c0                	test   %eax,%eax
  8032e0:	74 0d                	je     8032ef <insert_sorted_with_merge_freeList+0x20e>
  8032e2:	a1 38 51 80 00       	mov    0x805138,%eax
  8032e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ea:	89 50 04             	mov    %edx,0x4(%eax)
  8032ed:	eb 08                	jmp    8032f7 <insert_sorted_with_merge_freeList+0x216>
  8032ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803302:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803309:	a1 44 51 80 00       	mov    0x805144,%eax
  80330e:	40                   	inc    %eax
  80330f:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803314:	e9 0e 05 00 00       	jmp    803827 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  803319:	8b 45 08             	mov    0x8(%ebp),%eax
  80331c:	8b 50 08             	mov    0x8(%eax),%edx
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	8b 40 0c             	mov    0xc(%eax),%eax
  803325:	01 c2                	add    %eax,%edx
  803327:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332a:	8b 40 08             	mov    0x8(%eax),%eax
  80332d:	39 c2                	cmp    %eax,%edx
  80332f:	0f 85 9c 00 00 00    	jne    8033d1 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  803335:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803338:	8b 50 0c             	mov    0xc(%eax),%edx
  80333b:	8b 45 08             	mov    0x8(%ebp),%eax
  80333e:	8b 40 0c             	mov    0xc(%eax),%eax
  803341:	01 c2                	add    %eax,%edx
  803343:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803346:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	8b 50 08             	mov    0x8(%eax),%edx
  80334f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803352:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  803355:	8b 45 08             	mov    0x8(%ebp),%eax
  803358:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  80335f:	8b 45 08             	mov    0x8(%ebp),%eax
  803362:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803369:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80336d:	75 17                	jne    803386 <insert_sorted_with_merge_freeList+0x2a5>
  80336f:	83 ec 04             	sub    $0x4,%esp
  803372:	68 a8 43 80 00       	push   $0x8043a8
  803377:	68 4d 01 00 00       	push   $0x14d
  80337c:	68 cb 43 80 00       	push   $0x8043cb
  803381:	e8 7b d5 ff ff       	call   800901 <_panic>
  803386:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	89 10                	mov    %edx,(%eax)
  803391:	8b 45 08             	mov    0x8(%ebp),%eax
  803394:	8b 00                	mov    (%eax),%eax
  803396:	85 c0                	test   %eax,%eax
  803398:	74 0d                	je     8033a7 <insert_sorted_with_merge_freeList+0x2c6>
  80339a:	a1 48 51 80 00       	mov    0x805148,%eax
  80339f:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a2:	89 50 04             	mov    %edx,0x4(%eax)
  8033a5:	eb 08                	jmp    8033af <insert_sorted_with_merge_freeList+0x2ce>
  8033a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033aa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033af:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b2:	a3 48 51 80 00       	mov    %eax,0x805148
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c1:	a1 54 51 80 00       	mov    0x805154,%eax
  8033c6:	40                   	inc    %eax
  8033c7:	a3 54 51 80 00       	mov    %eax,0x805154





}
  8033cc:	e9 56 04 00 00       	jmp    803827 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8033d1:	a1 38 51 80 00       	mov    0x805138,%eax
  8033d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033d9:	e9 19 04 00 00       	jmp    8037f7 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  8033de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e1:	8b 00                	mov    (%eax),%eax
  8033e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  8033e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e9:	8b 50 08             	mov    0x8(%eax),%edx
  8033ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f2:	01 c2                	add    %eax,%edx
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	8b 40 08             	mov    0x8(%eax),%eax
  8033fa:	39 c2                	cmp    %eax,%edx
  8033fc:	0f 85 ad 01 00 00    	jne    8035af <insert_sorted_with_merge_freeList+0x4ce>
  803402:	8b 45 08             	mov    0x8(%ebp),%eax
  803405:	8b 50 08             	mov    0x8(%eax),%edx
  803408:	8b 45 08             	mov    0x8(%ebp),%eax
  80340b:	8b 40 0c             	mov    0xc(%eax),%eax
  80340e:	01 c2                	add    %eax,%edx
  803410:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803413:	8b 40 08             	mov    0x8(%eax),%eax
  803416:	39 c2                	cmp    %eax,%edx
  803418:	0f 85 91 01 00 00    	jne    8035af <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  80341e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803421:	8b 50 0c             	mov    0xc(%eax),%edx
  803424:	8b 45 08             	mov    0x8(%ebp),%eax
  803427:	8b 48 0c             	mov    0xc(%eax),%ecx
  80342a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80342d:	8b 40 0c             	mov    0xc(%eax),%eax
  803430:	01 c8                	add    %ecx,%eax
  803432:	01 c2                	add    %eax,%edx
  803434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803437:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  80343a:	8b 45 08             	mov    0x8(%ebp),%eax
  80343d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803444:	8b 45 08             	mov    0x8(%ebp),%eax
  803447:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  80344e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803451:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  803458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  803462:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803466:	75 17                	jne    80347f <insert_sorted_with_merge_freeList+0x39e>
  803468:	83 ec 04             	sub    $0x4,%esp
  80346b:	68 3c 44 80 00       	push   $0x80443c
  803470:	68 5b 01 00 00       	push   $0x15b
  803475:	68 cb 43 80 00       	push   $0x8043cb
  80347a:	e8 82 d4 ff ff       	call   800901 <_panic>
  80347f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803482:	8b 00                	mov    (%eax),%eax
  803484:	85 c0                	test   %eax,%eax
  803486:	74 10                	je     803498 <insert_sorted_with_merge_freeList+0x3b7>
  803488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348b:	8b 00                	mov    (%eax),%eax
  80348d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803490:	8b 52 04             	mov    0x4(%edx),%edx
  803493:	89 50 04             	mov    %edx,0x4(%eax)
  803496:	eb 0b                	jmp    8034a3 <insert_sorted_with_merge_freeList+0x3c2>
  803498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80349b:	8b 40 04             	mov    0x4(%eax),%eax
  80349e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a6:	8b 40 04             	mov    0x4(%eax),%eax
  8034a9:	85 c0                	test   %eax,%eax
  8034ab:	74 0f                	je     8034bc <insert_sorted_with_merge_freeList+0x3db>
  8034ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b0:	8b 40 04             	mov    0x4(%eax),%eax
  8034b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034b6:	8b 12                	mov    (%edx),%edx
  8034b8:	89 10                	mov    %edx,(%eax)
  8034ba:	eb 0a                	jmp    8034c6 <insert_sorted_with_merge_freeList+0x3e5>
  8034bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034bf:	8b 00                	mov    (%eax),%eax
  8034c1:	a3 38 51 80 00       	mov    %eax,0x805138
  8034c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034d9:	a1 44 51 80 00       	mov    0x805144,%eax
  8034de:	48                   	dec    %eax
  8034df:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034e8:	75 17                	jne    803501 <insert_sorted_with_merge_freeList+0x420>
  8034ea:	83 ec 04             	sub    $0x4,%esp
  8034ed:	68 a8 43 80 00       	push   $0x8043a8
  8034f2:	68 5c 01 00 00       	push   $0x15c
  8034f7:	68 cb 43 80 00       	push   $0x8043cb
  8034fc:	e8 00 d4 ff ff       	call   800901 <_panic>
  803501:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803507:	8b 45 08             	mov    0x8(%ebp),%eax
  80350a:	89 10                	mov    %edx,(%eax)
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	8b 00                	mov    (%eax),%eax
  803511:	85 c0                	test   %eax,%eax
  803513:	74 0d                	je     803522 <insert_sorted_with_merge_freeList+0x441>
  803515:	a1 48 51 80 00       	mov    0x805148,%eax
  80351a:	8b 55 08             	mov    0x8(%ebp),%edx
  80351d:	89 50 04             	mov    %edx,0x4(%eax)
  803520:	eb 08                	jmp    80352a <insert_sorted_with_merge_freeList+0x449>
  803522:	8b 45 08             	mov    0x8(%ebp),%eax
  803525:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80352a:	8b 45 08             	mov    0x8(%ebp),%eax
  80352d:	a3 48 51 80 00       	mov    %eax,0x805148
  803532:	8b 45 08             	mov    0x8(%ebp),%eax
  803535:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80353c:	a1 54 51 80 00       	mov    0x805154,%eax
  803541:	40                   	inc    %eax
  803542:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  803547:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80354b:	75 17                	jne    803564 <insert_sorted_with_merge_freeList+0x483>
  80354d:	83 ec 04             	sub    $0x4,%esp
  803550:	68 a8 43 80 00       	push   $0x8043a8
  803555:	68 5d 01 00 00       	push   $0x15d
  80355a:	68 cb 43 80 00       	push   $0x8043cb
  80355f:	e8 9d d3 ff ff       	call   800901 <_panic>
  803564:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80356a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356d:	89 10                	mov    %edx,(%eax)
  80356f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803572:	8b 00                	mov    (%eax),%eax
  803574:	85 c0                	test   %eax,%eax
  803576:	74 0d                	je     803585 <insert_sorted_with_merge_freeList+0x4a4>
  803578:	a1 48 51 80 00       	mov    0x805148,%eax
  80357d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803580:	89 50 04             	mov    %edx,0x4(%eax)
  803583:	eb 08                	jmp    80358d <insert_sorted_with_merge_freeList+0x4ac>
  803585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803588:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80358d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803590:	a3 48 51 80 00       	mov    %eax,0x805148
  803595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803598:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80359f:	a1 54 51 80 00       	mov    0x805154,%eax
  8035a4:	40                   	inc    %eax
  8035a5:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  8035aa:	e9 78 02 00 00       	jmp    803827 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  8035af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b2:	8b 50 08             	mov    0x8(%eax),%edx
  8035b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8035bb:	01 c2                	add    %eax,%edx
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	8b 40 08             	mov    0x8(%eax),%eax
  8035c3:	39 c2                	cmp    %eax,%edx
  8035c5:	0f 83 b8 00 00 00    	jae    803683 <insert_sorted_with_merge_freeList+0x5a2>
  8035cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ce:	8b 50 08             	mov    0x8(%eax),%edx
  8035d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d7:	01 c2                	add    %eax,%edx
  8035d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035dc:	8b 40 08             	mov    0x8(%eax),%eax
  8035df:	39 c2                	cmp    %eax,%edx
  8035e1:	0f 85 9c 00 00 00    	jne    803683 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  8035e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ea:	8b 50 0c             	mov    0xc(%eax),%edx
  8035ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f3:	01 c2                	add    %eax,%edx
  8035f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f8:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  8035fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fe:	8b 50 08             	mov    0x8(%eax),%edx
  803601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803604:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  803607:	8b 45 08             	mov    0x8(%ebp),%eax
  80360a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803611:	8b 45 08             	mov    0x8(%ebp),%eax
  803614:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80361b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80361f:	75 17                	jne    803638 <insert_sorted_with_merge_freeList+0x557>
  803621:	83 ec 04             	sub    $0x4,%esp
  803624:	68 a8 43 80 00       	push   $0x8043a8
  803629:	68 67 01 00 00       	push   $0x167
  80362e:	68 cb 43 80 00       	push   $0x8043cb
  803633:	e8 c9 d2 ff ff       	call   800901 <_panic>
  803638:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80363e:	8b 45 08             	mov    0x8(%ebp),%eax
  803641:	89 10                	mov    %edx,(%eax)
  803643:	8b 45 08             	mov    0x8(%ebp),%eax
  803646:	8b 00                	mov    (%eax),%eax
  803648:	85 c0                	test   %eax,%eax
  80364a:	74 0d                	je     803659 <insert_sorted_with_merge_freeList+0x578>
  80364c:	a1 48 51 80 00       	mov    0x805148,%eax
  803651:	8b 55 08             	mov    0x8(%ebp),%edx
  803654:	89 50 04             	mov    %edx,0x4(%eax)
  803657:	eb 08                	jmp    803661 <insert_sorted_with_merge_freeList+0x580>
  803659:	8b 45 08             	mov    0x8(%ebp),%eax
  80365c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803661:	8b 45 08             	mov    0x8(%ebp),%eax
  803664:	a3 48 51 80 00       	mov    %eax,0x805148
  803669:	8b 45 08             	mov    0x8(%ebp),%eax
  80366c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803673:	a1 54 51 80 00       	mov    0x805154,%eax
  803678:	40                   	inc    %eax
  803679:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80367e:	e9 a4 01 00 00       	jmp    803827 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803686:	8b 50 08             	mov    0x8(%eax),%edx
  803689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368c:	8b 40 0c             	mov    0xc(%eax),%eax
  80368f:	01 c2                	add    %eax,%edx
  803691:	8b 45 08             	mov    0x8(%ebp),%eax
  803694:	8b 40 08             	mov    0x8(%eax),%eax
  803697:	39 c2                	cmp    %eax,%edx
  803699:	0f 85 ac 00 00 00    	jne    80374b <insert_sorted_with_merge_freeList+0x66a>
  80369f:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a2:	8b 50 08             	mov    0x8(%eax),%edx
  8036a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ab:	01 c2                	add    %eax,%edx
  8036ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b0:	8b 40 08             	mov    0x8(%eax),%eax
  8036b3:	39 c2                	cmp    %eax,%edx
  8036b5:	0f 83 90 00 00 00    	jae    80374b <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  8036bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036be:	8b 50 0c             	mov    0xc(%eax),%edx
  8036c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c7:	01 c2                	add    %eax,%edx
  8036c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cc:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  8036cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  8036d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8036e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e7:	75 17                	jne    803700 <insert_sorted_with_merge_freeList+0x61f>
  8036e9:	83 ec 04             	sub    $0x4,%esp
  8036ec:	68 a8 43 80 00       	push   $0x8043a8
  8036f1:	68 70 01 00 00       	push   $0x170
  8036f6:	68 cb 43 80 00       	push   $0x8043cb
  8036fb:	e8 01 d2 ff ff       	call   800901 <_panic>
  803700:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803706:	8b 45 08             	mov    0x8(%ebp),%eax
  803709:	89 10                	mov    %edx,(%eax)
  80370b:	8b 45 08             	mov    0x8(%ebp),%eax
  80370e:	8b 00                	mov    (%eax),%eax
  803710:	85 c0                	test   %eax,%eax
  803712:	74 0d                	je     803721 <insert_sorted_with_merge_freeList+0x640>
  803714:	a1 48 51 80 00       	mov    0x805148,%eax
  803719:	8b 55 08             	mov    0x8(%ebp),%edx
  80371c:	89 50 04             	mov    %edx,0x4(%eax)
  80371f:	eb 08                	jmp    803729 <insert_sorted_with_merge_freeList+0x648>
  803721:	8b 45 08             	mov    0x8(%ebp),%eax
  803724:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803729:	8b 45 08             	mov    0x8(%ebp),%eax
  80372c:	a3 48 51 80 00       	mov    %eax,0x805148
  803731:	8b 45 08             	mov    0x8(%ebp),%eax
  803734:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373b:	a1 54 51 80 00       	mov    0x805154,%eax
  803740:	40                   	inc    %eax
  803741:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  803746:	e9 dc 00 00 00       	jmp    803827 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80374b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374e:	8b 50 08             	mov    0x8(%eax),%edx
  803751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803754:	8b 40 0c             	mov    0xc(%eax),%eax
  803757:	01 c2                	add    %eax,%edx
  803759:	8b 45 08             	mov    0x8(%ebp),%eax
  80375c:	8b 40 08             	mov    0x8(%eax),%eax
  80375f:	39 c2                	cmp    %eax,%edx
  803761:	0f 83 88 00 00 00    	jae    8037ef <insert_sorted_with_merge_freeList+0x70e>
  803767:	8b 45 08             	mov    0x8(%ebp),%eax
  80376a:	8b 50 08             	mov    0x8(%eax),%edx
  80376d:	8b 45 08             	mov    0x8(%ebp),%eax
  803770:	8b 40 0c             	mov    0xc(%eax),%eax
  803773:	01 c2                	add    %eax,%edx
  803775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803778:	8b 40 08             	mov    0x8(%eax),%eax
  80377b:	39 c2                	cmp    %eax,%edx
  80377d:	73 70                	jae    8037ef <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  80377f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803783:	74 06                	je     80378b <insert_sorted_with_merge_freeList+0x6aa>
  803785:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803789:	75 17                	jne    8037a2 <insert_sorted_with_merge_freeList+0x6c1>
  80378b:	83 ec 04             	sub    $0x4,%esp
  80378e:	68 08 44 80 00       	push   $0x804408
  803793:	68 75 01 00 00       	push   $0x175
  803798:	68 cb 43 80 00       	push   $0x8043cb
  80379d:	e8 5f d1 ff ff       	call   800901 <_panic>
  8037a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a5:	8b 10                	mov    (%eax),%edx
  8037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037aa:	89 10                	mov    %edx,(%eax)
  8037ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8037af:	8b 00                	mov    (%eax),%eax
  8037b1:	85 c0                	test   %eax,%eax
  8037b3:	74 0b                	je     8037c0 <insert_sorted_with_merge_freeList+0x6df>
  8037b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b8:	8b 00                	mov    (%eax),%eax
  8037ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8037bd:	89 50 04             	mov    %edx,0x4(%eax)
  8037c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8037c6:	89 10                	mov    %edx,(%eax)
  8037c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037ce:	89 50 04             	mov    %edx,0x4(%eax)
  8037d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d4:	8b 00                	mov    (%eax),%eax
  8037d6:	85 c0                	test   %eax,%eax
  8037d8:	75 08                	jne    8037e2 <insert_sorted_with_merge_freeList+0x701>
  8037da:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037e2:	a1 44 51 80 00       	mov    0x805144,%eax
  8037e7:	40                   	inc    %eax
  8037e8:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  8037ed:	eb 38                	jmp    803827 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8037ef:	a1 40 51 80 00       	mov    0x805140,%eax
  8037f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037fb:	74 07                	je     803804 <insert_sorted_with_merge_freeList+0x723>
  8037fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803800:	8b 00                	mov    (%eax),%eax
  803802:	eb 05                	jmp    803809 <insert_sorted_with_merge_freeList+0x728>
  803804:	b8 00 00 00 00       	mov    $0x0,%eax
  803809:	a3 40 51 80 00       	mov    %eax,0x805140
  80380e:	a1 40 51 80 00       	mov    0x805140,%eax
  803813:	85 c0                	test   %eax,%eax
  803815:	0f 85 c3 fb ff ff    	jne    8033de <insert_sorted_with_merge_freeList+0x2fd>
  80381b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80381f:	0f 85 b9 fb ff ff    	jne    8033de <insert_sorted_with_merge_freeList+0x2fd>





}
  803825:	eb 00                	jmp    803827 <insert_sorted_with_merge_freeList+0x746>
  803827:	90                   	nop
  803828:	c9                   	leave  
  803829:	c3                   	ret    
  80382a:	66 90                	xchg   %ax,%ax

0080382c <__udivdi3>:
  80382c:	55                   	push   %ebp
  80382d:	57                   	push   %edi
  80382e:	56                   	push   %esi
  80382f:	53                   	push   %ebx
  803830:	83 ec 1c             	sub    $0x1c,%esp
  803833:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803837:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80383b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80383f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803843:	89 ca                	mov    %ecx,%edx
  803845:	89 f8                	mov    %edi,%eax
  803847:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80384b:	85 f6                	test   %esi,%esi
  80384d:	75 2d                	jne    80387c <__udivdi3+0x50>
  80384f:	39 cf                	cmp    %ecx,%edi
  803851:	77 65                	ja     8038b8 <__udivdi3+0x8c>
  803853:	89 fd                	mov    %edi,%ebp
  803855:	85 ff                	test   %edi,%edi
  803857:	75 0b                	jne    803864 <__udivdi3+0x38>
  803859:	b8 01 00 00 00       	mov    $0x1,%eax
  80385e:	31 d2                	xor    %edx,%edx
  803860:	f7 f7                	div    %edi
  803862:	89 c5                	mov    %eax,%ebp
  803864:	31 d2                	xor    %edx,%edx
  803866:	89 c8                	mov    %ecx,%eax
  803868:	f7 f5                	div    %ebp
  80386a:	89 c1                	mov    %eax,%ecx
  80386c:	89 d8                	mov    %ebx,%eax
  80386e:	f7 f5                	div    %ebp
  803870:	89 cf                	mov    %ecx,%edi
  803872:	89 fa                	mov    %edi,%edx
  803874:	83 c4 1c             	add    $0x1c,%esp
  803877:	5b                   	pop    %ebx
  803878:	5e                   	pop    %esi
  803879:	5f                   	pop    %edi
  80387a:	5d                   	pop    %ebp
  80387b:	c3                   	ret    
  80387c:	39 ce                	cmp    %ecx,%esi
  80387e:	77 28                	ja     8038a8 <__udivdi3+0x7c>
  803880:	0f bd fe             	bsr    %esi,%edi
  803883:	83 f7 1f             	xor    $0x1f,%edi
  803886:	75 40                	jne    8038c8 <__udivdi3+0x9c>
  803888:	39 ce                	cmp    %ecx,%esi
  80388a:	72 0a                	jb     803896 <__udivdi3+0x6a>
  80388c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803890:	0f 87 9e 00 00 00    	ja     803934 <__udivdi3+0x108>
  803896:	b8 01 00 00 00       	mov    $0x1,%eax
  80389b:	89 fa                	mov    %edi,%edx
  80389d:	83 c4 1c             	add    $0x1c,%esp
  8038a0:	5b                   	pop    %ebx
  8038a1:	5e                   	pop    %esi
  8038a2:	5f                   	pop    %edi
  8038a3:	5d                   	pop    %ebp
  8038a4:	c3                   	ret    
  8038a5:	8d 76 00             	lea    0x0(%esi),%esi
  8038a8:	31 ff                	xor    %edi,%edi
  8038aa:	31 c0                	xor    %eax,%eax
  8038ac:	89 fa                	mov    %edi,%edx
  8038ae:	83 c4 1c             	add    $0x1c,%esp
  8038b1:	5b                   	pop    %ebx
  8038b2:	5e                   	pop    %esi
  8038b3:	5f                   	pop    %edi
  8038b4:	5d                   	pop    %ebp
  8038b5:	c3                   	ret    
  8038b6:	66 90                	xchg   %ax,%ax
  8038b8:	89 d8                	mov    %ebx,%eax
  8038ba:	f7 f7                	div    %edi
  8038bc:	31 ff                	xor    %edi,%edi
  8038be:	89 fa                	mov    %edi,%edx
  8038c0:	83 c4 1c             	add    $0x1c,%esp
  8038c3:	5b                   	pop    %ebx
  8038c4:	5e                   	pop    %esi
  8038c5:	5f                   	pop    %edi
  8038c6:	5d                   	pop    %ebp
  8038c7:	c3                   	ret    
  8038c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038cd:	89 eb                	mov    %ebp,%ebx
  8038cf:	29 fb                	sub    %edi,%ebx
  8038d1:	89 f9                	mov    %edi,%ecx
  8038d3:	d3 e6                	shl    %cl,%esi
  8038d5:	89 c5                	mov    %eax,%ebp
  8038d7:	88 d9                	mov    %bl,%cl
  8038d9:	d3 ed                	shr    %cl,%ebp
  8038db:	89 e9                	mov    %ebp,%ecx
  8038dd:	09 f1                	or     %esi,%ecx
  8038df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038e3:	89 f9                	mov    %edi,%ecx
  8038e5:	d3 e0                	shl    %cl,%eax
  8038e7:	89 c5                	mov    %eax,%ebp
  8038e9:	89 d6                	mov    %edx,%esi
  8038eb:	88 d9                	mov    %bl,%cl
  8038ed:	d3 ee                	shr    %cl,%esi
  8038ef:	89 f9                	mov    %edi,%ecx
  8038f1:	d3 e2                	shl    %cl,%edx
  8038f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038f7:	88 d9                	mov    %bl,%cl
  8038f9:	d3 e8                	shr    %cl,%eax
  8038fb:	09 c2                	or     %eax,%edx
  8038fd:	89 d0                	mov    %edx,%eax
  8038ff:	89 f2                	mov    %esi,%edx
  803901:	f7 74 24 0c          	divl   0xc(%esp)
  803905:	89 d6                	mov    %edx,%esi
  803907:	89 c3                	mov    %eax,%ebx
  803909:	f7 e5                	mul    %ebp
  80390b:	39 d6                	cmp    %edx,%esi
  80390d:	72 19                	jb     803928 <__udivdi3+0xfc>
  80390f:	74 0b                	je     80391c <__udivdi3+0xf0>
  803911:	89 d8                	mov    %ebx,%eax
  803913:	31 ff                	xor    %edi,%edi
  803915:	e9 58 ff ff ff       	jmp    803872 <__udivdi3+0x46>
  80391a:	66 90                	xchg   %ax,%ax
  80391c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803920:	89 f9                	mov    %edi,%ecx
  803922:	d3 e2                	shl    %cl,%edx
  803924:	39 c2                	cmp    %eax,%edx
  803926:	73 e9                	jae    803911 <__udivdi3+0xe5>
  803928:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80392b:	31 ff                	xor    %edi,%edi
  80392d:	e9 40 ff ff ff       	jmp    803872 <__udivdi3+0x46>
  803932:	66 90                	xchg   %ax,%ax
  803934:	31 c0                	xor    %eax,%eax
  803936:	e9 37 ff ff ff       	jmp    803872 <__udivdi3+0x46>
  80393b:	90                   	nop

0080393c <__umoddi3>:
  80393c:	55                   	push   %ebp
  80393d:	57                   	push   %edi
  80393e:	56                   	push   %esi
  80393f:	53                   	push   %ebx
  803940:	83 ec 1c             	sub    $0x1c,%esp
  803943:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803947:	8b 74 24 34          	mov    0x34(%esp),%esi
  80394b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80394f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803953:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803957:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80395b:	89 f3                	mov    %esi,%ebx
  80395d:	89 fa                	mov    %edi,%edx
  80395f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803963:	89 34 24             	mov    %esi,(%esp)
  803966:	85 c0                	test   %eax,%eax
  803968:	75 1a                	jne    803984 <__umoddi3+0x48>
  80396a:	39 f7                	cmp    %esi,%edi
  80396c:	0f 86 a2 00 00 00    	jbe    803a14 <__umoddi3+0xd8>
  803972:	89 c8                	mov    %ecx,%eax
  803974:	89 f2                	mov    %esi,%edx
  803976:	f7 f7                	div    %edi
  803978:	89 d0                	mov    %edx,%eax
  80397a:	31 d2                	xor    %edx,%edx
  80397c:	83 c4 1c             	add    $0x1c,%esp
  80397f:	5b                   	pop    %ebx
  803980:	5e                   	pop    %esi
  803981:	5f                   	pop    %edi
  803982:	5d                   	pop    %ebp
  803983:	c3                   	ret    
  803984:	39 f0                	cmp    %esi,%eax
  803986:	0f 87 ac 00 00 00    	ja     803a38 <__umoddi3+0xfc>
  80398c:	0f bd e8             	bsr    %eax,%ebp
  80398f:	83 f5 1f             	xor    $0x1f,%ebp
  803992:	0f 84 ac 00 00 00    	je     803a44 <__umoddi3+0x108>
  803998:	bf 20 00 00 00       	mov    $0x20,%edi
  80399d:	29 ef                	sub    %ebp,%edi
  80399f:	89 fe                	mov    %edi,%esi
  8039a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039a5:	89 e9                	mov    %ebp,%ecx
  8039a7:	d3 e0                	shl    %cl,%eax
  8039a9:	89 d7                	mov    %edx,%edi
  8039ab:	89 f1                	mov    %esi,%ecx
  8039ad:	d3 ef                	shr    %cl,%edi
  8039af:	09 c7                	or     %eax,%edi
  8039b1:	89 e9                	mov    %ebp,%ecx
  8039b3:	d3 e2                	shl    %cl,%edx
  8039b5:	89 14 24             	mov    %edx,(%esp)
  8039b8:	89 d8                	mov    %ebx,%eax
  8039ba:	d3 e0                	shl    %cl,%eax
  8039bc:	89 c2                	mov    %eax,%edx
  8039be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039c2:	d3 e0                	shl    %cl,%eax
  8039c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039cc:	89 f1                	mov    %esi,%ecx
  8039ce:	d3 e8                	shr    %cl,%eax
  8039d0:	09 d0                	or     %edx,%eax
  8039d2:	d3 eb                	shr    %cl,%ebx
  8039d4:	89 da                	mov    %ebx,%edx
  8039d6:	f7 f7                	div    %edi
  8039d8:	89 d3                	mov    %edx,%ebx
  8039da:	f7 24 24             	mull   (%esp)
  8039dd:	89 c6                	mov    %eax,%esi
  8039df:	89 d1                	mov    %edx,%ecx
  8039e1:	39 d3                	cmp    %edx,%ebx
  8039e3:	0f 82 87 00 00 00    	jb     803a70 <__umoddi3+0x134>
  8039e9:	0f 84 91 00 00 00    	je     803a80 <__umoddi3+0x144>
  8039ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039f3:	29 f2                	sub    %esi,%edx
  8039f5:	19 cb                	sbb    %ecx,%ebx
  8039f7:	89 d8                	mov    %ebx,%eax
  8039f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039fd:	d3 e0                	shl    %cl,%eax
  8039ff:	89 e9                	mov    %ebp,%ecx
  803a01:	d3 ea                	shr    %cl,%edx
  803a03:	09 d0                	or     %edx,%eax
  803a05:	89 e9                	mov    %ebp,%ecx
  803a07:	d3 eb                	shr    %cl,%ebx
  803a09:	89 da                	mov    %ebx,%edx
  803a0b:	83 c4 1c             	add    $0x1c,%esp
  803a0e:	5b                   	pop    %ebx
  803a0f:	5e                   	pop    %esi
  803a10:	5f                   	pop    %edi
  803a11:	5d                   	pop    %ebp
  803a12:	c3                   	ret    
  803a13:	90                   	nop
  803a14:	89 fd                	mov    %edi,%ebp
  803a16:	85 ff                	test   %edi,%edi
  803a18:	75 0b                	jne    803a25 <__umoddi3+0xe9>
  803a1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a1f:	31 d2                	xor    %edx,%edx
  803a21:	f7 f7                	div    %edi
  803a23:	89 c5                	mov    %eax,%ebp
  803a25:	89 f0                	mov    %esi,%eax
  803a27:	31 d2                	xor    %edx,%edx
  803a29:	f7 f5                	div    %ebp
  803a2b:	89 c8                	mov    %ecx,%eax
  803a2d:	f7 f5                	div    %ebp
  803a2f:	89 d0                	mov    %edx,%eax
  803a31:	e9 44 ff ff ff       	jmp    80397a <__umoddi3+0x3e>
  803a36:	66 90                	xchg   %ax,%ax
  803a38:	89 c8                	mov    %ecx,%eax
  803a3a:	89 f2                	mov    %esi,%edx
  803a3c:	83 c4 1c             	add    $0x1c,%esp
  803a3f:	5b                   	pop    %ebx
  803a40:	5e                   	pop    %esi
  803a41:	5f                   	pop    %edi
  803a42:	5d                   	pop    %ebp
  803a43:	c3                   	ret    
  803a44:	3b 04 24             	cmp    (%esp),%eax
  803a47:	72 06                	jb     803a4f <__umoddi3+0x113>
  803a49:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a4d:	77 0f                	ja     803a5e <__umoddi3+0x122>
  803a4f:	89 f2                	mov    %esi,%edx
  803a51:	29 f9                	sub    %edi,%ecx
  803a53:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a57:	89 14 24             	mov    %edx,(%esp)
  803a5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a5e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a62:	8b 14 24             	mov    (%esp),%edx
  803a65:	83 c4 1c             	add    $0x1c,%esp
  803a68:	5b                   	pop    %ebx
  803a69:	5e                   	pop    %esi
  803a6a:	5f                   	pop    %edi
  803a6b:	5d                   	pop    %ebp
  803a6c:	c3                   	ret    
  803a6d:	8d 76 00             	lea    0x0(%esi),%esi
  803a70:	2b 04 24             	sub    (%esp),%eax
  803a73:	19 fa                	sbb    %edi,%edx
  803a75:	89 d1                	mov    %edx,%ecx
  803a77:	89 c6                	mov    %eax,%esi
  803a79:	e9 71 ff ff ff       	jmp    8039ef <__umoddi3+0xb3>
  803a7e:	66 90                	xchg   %ax,%ax
  803a80:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a84:	72 ea                	jb     803a70 <__umoddi3+0x134>
  803a86:	89 d9                	mov    %ebx,%ecx
  803a88:	e9 62 ff ff ff       	jmp    8039ef <__umoddi3+0xb3>
