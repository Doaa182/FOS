
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 0e 06 00 00       	call   800644 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
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
  800041:	e8 99 20 00 00       	call   8020df <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 39 80 00       	push   $0x803920
  80004e:	e8 e1 09 00 00       	call   800a34 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 39 80 00       	push   $0x803922
  80005e:	e8 d1 09 00 00       	call   800a34 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 3b 39 80 00       	push   $0x80393b
  80006e:	e8 c1 09 00 00       	call   800a34 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 39 80 00       	push   $0x803922
  80007e:	e8 b1 09 00 00       	call   800a34 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 39 80 00       	push   $0x803920
  80008e:	e8 a1 09 00 00       	call   800a34 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 54 39 80 00       	push   $0x803954
  8000a5:	e8 0c 10 00 00       	call   8010b6 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 5c 15 00 00       	call   80161c <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 de 1a 00 00       	call   801bb3 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 74 39 80 00       	push   $0x803974
  8000e3:	e8 4c 09 00 00       	call   800a34 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 96 39 80 00       	push   $0x803996
  8000f3:	e8 3c 09 00 00       	call   800a34 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 a4 39 80 00       	push   $0x8039a4
  800103:	e8 2c 09 00 00       	call   800a34 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 b3 39 80 00       	push   $0x8039b3
  800113:	e8 1c 09 00 00       	call   800a34 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 c3 39 80 00       	push   $0x8039c3
  800123:	e8 0c 09 00 00       	call   800a34 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 bc 04 00 00       	call   8005ec <getchar>
  800130:	88 45 ef             	mov    %al,-0x11(%ebp)
			cputchar(Chose);
  800133:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 64 04 00 00       	call   8005a4 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 57 04 00 00       	call   8005a4 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d ef 61          	cmpb   $0x61,-0x11(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d ef 62          	cmpb   $0x62,-0x11(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d ef 63          	cmpb   $0x63,-0x11(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 92 1f 00 00       	call   8020f9 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
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
  80017d:	ff 75 f4             	pushl  -0xc(%ebp)
  800180:	ff 75 f0             	pushl  -0x10(%ebp)
  800183:	e8 e4 02 00 00       	call   80046c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f4             	pushl  -0xc(%ebp)
  800193:	ff 75 f0             	pushl  -0x10(%ebp)
  800196:	e8 02 03 00 00       	call   80049d <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 24 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8001b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8001bc:	e8 11 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8001cd:	e8 df 00 00 00       	call   8002b1 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 05 1f 00 00       	call   8020df <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 cc 39 80 00       	push   $0x8039cc
  8001e2:	e8 4d 08 00 00       	call   800a34 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 0a 1f 00 00       	call   8020f9 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f8:	e8 c5 01 00 00       	call   8003c2 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 00 3a 80 00       	push   $0x803a00
  800211:	6a 49                	push   $0x49
  800213:	68 22 3a 80 00       	push   $0x803a22
  800218:	e8 63 05 00 00       	call   800780 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 bd 1e 00 00       	call   8020df <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 40 3a 80 00       	push   $0x803a40
  80022a:	e8 05 08 00 00       	call   800a34 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 74 3a 80 00       	push   $0x803a74
  80023a:	e8 f5 07 00 00       	call   800a34 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 a8 3a 80 00       	push   $0x803aa8
  80024a:	e8 e5 07 00 00       	call   800a34 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 a2 1e 00 00       	call   8020f9 <sys_enable_interrupt>

		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 f0             	pushl  -0x10(%ebp)
  80025d:	e8 e8 19 00 00       	call   801c4a <free>
  800262:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800265:	e8 75 1e 00 00       	call   8020df <sys_disable_interrupt>

		cprintf("Do you want to repeat (y/n): ") ;
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 da 3a 80 00       	push   $0x803ada
  800272:	e8 bd 07 00 00       	call   800a34 <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80027a:	e8 6d 03 00 00       	call   8005ec <getchar>
  80027f:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800282:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 15 03 00 00       	call   8005a4 <cputchar>
  80028f:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 0a                	push   $0xa
  800297:	e8 08 03 00 00       	call   8005a4 <cputchar>
  80029c:	83 c4 10             	add    $0x10,%esp

		sys_enable_interrupt();
  80029f:	e8 55 1e 00 00       	call   8020f9 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002a4:	80 7d ef 79          	cmpb   $0x79,-0x11(%ebp)
  8002a8:	0f 84 93 fd ff ff    	je     800041 <_main+0x9>

}
  8002ae:	90                   	nop
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	48                   	dec    %eax
  8002bb:	50                   	push   %eax
  8002bc:	6a 00                	push   $0x0
  8002be:	ff 75 0c             	pushl  0xc(%ebp)
  8002c1:	ff 75 08             	pushl  0x8(%ebp)
  8002c4:	e8 06 00 00 00       	call   8002cf <QSort>
  8002c9:	83 c4 10             	add    $0x10,%esp
}
  8002cc:	90                   	nop
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d8:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002db:	0f 8d de 00 00 00    	jge    8003bf <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e4:	40                   	inc    %eax
  8002e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8002eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ee:	e9 80 00 00 00       	jmp    800373 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002f3:	ff 45 f4             	incl   -0xc(%ebp)
  8002f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fc:	7f 2b                	jg     800329 <QSort+0x5a>
  8002fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800301:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	8b 10                	mov    (%eax),%edx
  80030f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800312:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 c8                	add    %ecx,%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	39 c2                	cmp    %eax,%edx
  800322:	7d cf                	jge    8002f3 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800324:	eb 03                	jmp    800329 <QSort+0x5a>
  800326:	ff 4d f0             	decl   -0x10(%ebp)
  800329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80032f:	7e 26                	jle    800357 <QSort+0x88>
  800331:	8b 45 10             	mov    0x10(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 10                	mov    (%eax),%edx
  800342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800345:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 c8                	add    %ecx,%eax
  800351:	8b 00                	mov    (%eax),%eax
  800353:	39 c2                	cmp    %eax,%edx
  800355:	7e cf                	jle    800326 <QSort+0x57>

		if (i <= j)
  800357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80035d:	7f 14                	jg     800373 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	ff 75 f0             	pushl  -0x10(%ebp)
  800365:	ff 75 f4             	pushl  -0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 a9 00 00 00       	call   800419 <Swap>
  800370:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800379:	0f 8e 77 ff ff ff    	jle    8002f6 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	ff 75 f0             	pushl  -0x10(%ebp)
  800385:	ff 75 10             	pushl  0x10(%ebp)
  800388:	ff 75 08             	pushl  0x8(%ebp)
  80038b:	e8 89 00 00 00       	call   800419 <Swap>
  800390:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800396:	48                   	dec    %eax
  800397:	50                   	push   %eax
  800398:	ff 75 10             	pushl  0x10(%ebp)
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	e8 29 ff ff ff       	call   8002cf <QSort>
  8003a6:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003a9:	ff 75 14             	pushl  0x14(%ebp)
  8003ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 08             	pushl  0x8(%ebp)
  8003b5:	e8 15 ff ff ff       	call   8002cf <QSort>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	eb 01                	jmp    8003c0 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003bf:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    

008003c2 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003c8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003d6:	eb 33                	jmp    80040b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	01 d0                	add    %edx,%eax
  8003e7:	8b 10                	mov    (%eax),%edx
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	40                   	inc    %eax
  8003ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	01 c8                	add    %ecx,%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	39 c2                	cmp    %eax,%edx
  8003fd:	7e 09                	jle    800408 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800406:	eb 0c                	jmp    800414 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800408:	ff 45 f8             	incl   -0x8(%ebp)
  80040b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040e:	48                   	dec    %eax
  80040f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800412:	7f c4                	jg     8003d8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800414:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800417:	c9                   	leave  
  800418:	c3                   	ret    

00800419 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80041f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800433:	8b 45 0c             	mov    0xc(%ebp),%eax
  800436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	01 c2                	add    %eax,%edx
  800442:	8b 45 10             	mov    0x10(%ebp),%eax
  800445:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	01 c8                	add    %ecx,%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800455:	8b 45 10             	mov    0x10(%ebp),%eax
  800458:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	01 c2                	add    %eax,%edx
  800464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800467:	89 02                	mov    %eax,(%edx)
}
  800469:	90                   	nop
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    

0080046c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800479:	eb 17                	jmp    800492 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80047b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c2                	add    %eax,%edx
  80048a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80048f:	ff 45 fc             	incl   -0x4(%ebp)
  800492:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800495:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800498:	7c e1                	jl     80047b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004aa:	eb 1b                	jmp    8004c7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	01 c2                	add    %eax,%edx
  8004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004be:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c4:	ff 45 fc             	incl   -0x4(%ebp)
  8004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004cd:	7c dd                	jl     8004ac <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004cf:	90                   	nop
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004db:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004e0:	f7 e9                	imul   %ecx
  8004e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	29 c8                	sub    %ecx,%eax
  8004e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004f3:	eb 1e                	jmp    800513 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800508:	99                   	cltd   
  800509:	f7 7d f8             	idivl  -0x8(%ebp)
  80050c:	89 d0                	mov    %edx,%eax
  80050e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800510:	ff 45 fc             	incl   -0x4(%ebp)
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800519:	7c da                	jl     8004f5 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80051b:	90                   	nop
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800524:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80052b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800532:	eb 42                	jmp    800576 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800537:	99                   	cltd   
  800538:	f7 7d f0             	idivl  -0x10(%ebp)
  80053b:	89 d0                	mov    %edx,%eax
  80053d:	85 c0                	test   %eax,%eax
  80053f:	75 10                	jne    800551 <PrintElements+0x33>
			cprintf("\n");
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	68 20 39 80 00       	push   $0x803920
  800549:	e8 e6 04 00 00       	call   800a34 <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	01 d0                	add    %edx,%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	50                   	push   %eax
  800566:	68 f8 3a 80 00       	push   $0x803af8
  80056b:	e8 c4 04 00 00       	call   800a34 <cprintf>
  800570:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800573:	ff 45 f4             	incl   -0xc(%ebp)
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	48                   	dec    %eax
  80057a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80057d:	7f b5                	jg     800534 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80057f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800582:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	01 d0                	add    %edx,%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	50                   	push   %eax
  800594:	68 fd 3a 80 00       	push   $0x803afd
  800599:	e8 96 04 00 00       	call   800a34 <cprintf>
  80059e:	83 c4 10             	add    $0x10,%esp

}
  8005a1:	90                   	nop
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005b0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	50                   	push   %eax
  8005b8:	e8 56 1b 00 00       	call   802113 <sys_cputc>
  8005bd:	83 c4 10             	add    $0x10,%esp
}
  8005c0:	90                   	nop
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005c9:	e8 11 1b 00 00       	call   8020df <sys_disable_interrupt>
	char c = ch;
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005d4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	50                   	push   %eax
  8005dc:	e8 32 1b 00 00       	call   802113 <sys_cputc>
  8005e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005e4:	e8 10 1b 00 00       	call   8020f9 <sys_enable_interrupt>
}
  8005e9:	90                   	nop
  8005ea:	c9                   	leave  
  8005eb:	c3                   	ret    

008005ec <getchar>:

int
getchar(void)
{
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005f9:	eb 08                	jmp    800603 <getchar+0x17>
	{
		c = sys_cgetc();
  8005fb:	e8 5a 19 00 00       	call   801f5a <sys_cgetc>
  800600:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800607:	74 f2                	je     8005fb <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800609:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <atomic_getchar>:

int
atomic_getchar(void)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800614:	e8 c6 1a 00 00       	call   8020df <sys_disable_interrupt>
	int c=0;
  800619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800620:	eb 08                	jmp    80062a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800622:	e8 33 19 00 00       	call   801f5a <sys_cgetc>
  800627:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80062a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80062e:	74 f2                	je     800622 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800630:	e8 c4 1a 00 00       	call   8020f9 <sys_enable_interrupt>
	return c;
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800638:	c9                   	leave  
  800639:	c3                   	ret    

0080063a <iscons>:

int iscons(int fdnum)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80063d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800642:	5d                   	pop    %ebp
  800643:	c3                   	ret    

00800644 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80064a:	e8 83 1c 00 00       	call   8022d2 <sys_getenvindex>
  80064f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	c1 e0 03             	shl    $0x3,%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	01 c0                	add    %eax,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800667:	01 d0                	add    %edx,%eax
  800669:	c1 e0 04             	shl    $0x4,%eax
  80066c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800671:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800676:	a1 24 50 80 00       	mov    0x805024,%eax
  80067b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800681:	84 c0                	test   %al,%al
  800683:	74 0f                	je     800694 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800685:	a1 24 50 80 00       	mov    0x805024,%eax
  80068a:	05 5c 05 00 00       	add    $0x55c,%eax
  80068f:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800694:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800698:	7e 0a                	jle    8006a4 <libmain+0x60>
		binaryname = argv[0];
  80069a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	ff 75 0c             	pushl  0xc(%ebp)
  8006aa:	ff 75 08             	pushl  0x8(%ebp)
  8006ad:	e8 86 f9 ff ff       	call   800038 <_main>
  8006b2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006b5:	e8 25 1a 00 00       	call   8020df <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006ba:	83 ec 0c             	sub    $0xc,%esp
  8006bd:	68 1c 3b 80 00       	push   $0x803b1c
  8006c2:	e8 6d 03 00 00       	call   800a34 <cprintf>
  8006c7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006ca:	a1 24 50 80 00       	mov    0x805024,%eax
  8006cf:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006d5:	a1 24 50 80 00       	mov    0x805024,%eax
  8006da:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006e0:	83 ec 04             	sub    $0x4,%esp
  8006e3:	52                   	push   %edx
  8006e4:	50                   	push   %eax
  8006e5:	68 44 3b 80 00       	push   $0x803b44
  8006ea:	e8 45 03 00 00       	call   800a34 <cprintf>
  8006ef:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006f2:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f7:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006fd:	a1 24 50 80 00       	mov    0x805024,%eax
  800702:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800708:	a1 24 50 80 00       	mov    0x805024,%eax
  80070d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800713:	51                   	push   %ecx
  800714:	52                   	push   %edx
  800715:	50                   	push   %eax
  800716:	68 6c 3b 80 00       	push   $0x803b6c
  80071b:	e8 14 03 00 00       	call   800a34 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800723:	a1 24 50 80 00       	mov    0x805024,%eax
  800728:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	50                   	push   %eax
  800732:	68 c4 3b 80 00       	push   $0x803bc4
  800737:	e8 f8 02 00 00       	call   800a34 <cprintf>
  80073c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80073f:	83 ec 0c             	sub    $0xc,%esp
  800742:	68 1c 3b 80 00       	push   $0x803b1c
  800747:	e8 e8 02 00 00       	call   800a34 <cprintf>
  80074c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80074f:	e8 a5 19 00 00       	call   8020f9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800754:	e8 19 00 00 00       	call   800772 <exit>
}
  800759:	90                   	nop
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    

0080075c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	6a 00                	push   $0x0
  800767:	e8 32 1b 00 00       	call   80229e <sys_destroy_env>
  80076c:	83 c4 10             	add    $0x10,%esp
}
  80076f:	90                   	nop
  800770:	c9                   	leave  
  800771:	c3                   	ret    

00800772 <exit>:

void
exit(void)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800778:	e8 87 1b 00 00       	call   802304 <sys_exit_env>
}
  80077d:	90                   	nop
  80077e:	c9                   	leave  
  80077f:	c3                   	ret    

00800780 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800786:	8d 45 10             	lea    0x10(%ebp),%eax
  800789:	83 c0 04             	add    $0x4,%eax
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80078f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800794:	85 c0                	test   %eax,%eax
  800796:	74 16                	je     8007ae <_panic+0x2e>
		cprintf("%s: ", argv0);
  800798:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	50                   	push   %eax
  8007a1:	68 d8 3b 80 00       	push   $0x803bd8
  8007a6:	e8 89 02 00 00       	call   800a34 <cprintf>
  8007ab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ae:	a1 00 50 80 00       	mov    0x805000,%eax
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	68 dd 3b 80 00       	push   $0x803bdd
  8007bf:	e8 70 02 00 00       	call   800a34 <cprintf>
  8007c4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d0:	50                   	push   %eax
  8007d1:	e8 f3 01 00 00       	call   8009c9 <vcprintf>
  8007d6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	6a 00                	push   $0x0
  8007de:	68 f9 3b 80 00       	push   $0x803bf9
  8007e3:	e8 e1 01 00 00       	call   8009c9 <vcprintf>
  8007e8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007eb:	e8 82 ff ff ff       	call   800772 <exit>

	// should not return here
	while (1) ;
  8007f0:	eb fe                	jmp    8007f0 <_panic+0x70>

008007f2 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fd:	8b 50 74             	mov    0x74(%eax),%edx
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
  800803:	39 c2                	cmp    %eax,%edx
  800805:	74 14                	je     80081b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800807:	83 ec 04             	sub    $0x4,%esp
  80080a:	68 fc 3b 80 00       	push   $0x803bfc
  80080f:	6a 26                	push   $0x26
  800811:	68 48 3c 80 00       	push   $0x803c48
  800816:	e8 65 ff ff ff       	call   800780 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80081b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800822:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800829:	e9 c2 00 00 00       	jmp    8008f0 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80082e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800831:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	01 d0                	add    %edx,%eax
  80083d:	8b 00                	mov    (%eax),%eax
  80083f:	85 c0                	test   %eax,%eax
  800841:	75 08                	jne    80084b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800843:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800846:	e9 a2 00 00 00       	jmp    8008ed <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80084b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800852:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800859:	eb 69                	jmp    8008c4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80085b:	a1 24 50 80 00       	mov    0x805024,%eax
  800860:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800866:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800869:	89 d0                	mov    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	c1 e0 03             	shl    $0x3,%eax
  800872:	01 c8                	add    %ecx,%eax
  800874:	8a 40 04             	mov    0x4(%eax),%al
  800877:	84 c0                	test   %al,%al
  800879:	75 46                	jne    8008c1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80087b:	a1 24 50 80 00       	mov    0x805024,%eax
  800880:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800886:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	01 c0                	add    %eax,%eax
  80088d:	01 d0                	add    %edx,%eax
  80088f:	c1 e0 03             	shl    $0x3,%eax
  800892:	01 c8                	add    %ecx,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800899:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80089c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	01 c8                	add    %ecx,%eax
  8008b2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b4:	39 c2                	cmp    %eax,%edx
  8008b6:	75 09                	jne    8008c1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008b8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008bf:	eb 12                	jmp    8008d3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008c1:	ff 45 e8             	incl   -0x18(%ebp)
  8008c4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008c9:	8b 50 74             	mov    0x74(%eax),%edx
  8008cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	77 88                	ja     80085b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008d7:	75 14                	jne    8008ed <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008d9:	83 ec 04             	sub    $0x4,%esp
  8008dc:	68 54 3c 80 00       	push   $0x803c54
  8008e1:	6a 3a                	push   $0x3a
  8008e3:	68 48 3c 80 00       	push   $0x803c48
  8008e8:	e8 93 fe ff ff       	call   800780 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008ed:	ff 45 f0             	incl   -0x10(%ebp)
  8008f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008f6:	0f 8c 32 ff ff ff    	jl     80082e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800903:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80090a:	eb 26                	jmp    800932 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80090c:	a1 24 50 80 00       	mov    0x805024,%eax
  800911:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800917:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80091a:	89 d0                	mov    %edx,%eax
  80091c:	01 c0                	add    %eax,%eax
  80091e:	01 d0                	add    %edx,%eax
  800920:	c1 e0 03             	shl    $0x3,%eax
  800923:	01 c8                	add    %ecx,%eax
  800925:	8a 40 04             	mov    0x4(%eax),%al
  800928:	3c 01                	cmp    $0x1,%al
  80092a:	75 03                	jne    80092f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80092c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80092f:	ff 45 e0             	incl   -0x20(%ebp)
  800932:	a1 24 50 80 00       	mov    0x805024,%eax
  800937:	8b 50 74             	mov    0x74(%eax),%edx
  80093a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80093d:	39 c2                	cmp    %eax,%edx
  80093f:	77 cb                	ja     80090c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800944:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800947:	74 14                	je     80095d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800949:	83 ec 04             	sub    $0x4,%esp
  80094c:	68 a8 3c 80 00       	push   $0x803ca8
  800951:	6a 44                	push   $0x44
  800953:	68 48 3c 80 00       	push   $0x803c48
  800958:	e8 23 fe ff ff       	call   800780 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80095d:	90                   	nop
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    

00800960 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 48 01             	lea    0x1(%eax),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 0a                	mov    %ecx,(%edx)
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
  800976:	88 d1                	mov    %dl,%cl
  800978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80097f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	3d ff 00 00 00       	cmp    $0xff,%eax
  800989:	75 2c                	jne    8009b7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80098b:	a0 28 50 80 00       	mov    0x805028,%al
  800990:	0f b6 c0             	movzbl %al,%eax
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	8b 12                	mov    (%edx),%edx
  800998:	89 d1                	mov    %edx,%ecx
  80099a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099d:	83 c2 08             	add    $0x8,%edx
  8009a0:	83 ec 04             	sub    $0x4,%esp
  8009a3:	50                   	push   %eax
  8009a4:	51                   	push   %ecx
  8009a5:	52                   	push   %edx
  8009a6:	e8 86 15 00 00       	call   801f31 <sys_cputs>
  8009ab:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	8b 40 04             	mov    0x4(%eax),%eax
  8009bd:	8d 50 01             	lea    0x1(%eax),%edx
  8009c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009c6:	90                   	nop
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009d9:	00 00 00 
	b.cnt = 0;
  8009dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009e3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	ff 75 08             	pushl  0x8(%ebp)
  8009ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f2:	50                   	push   %eax
  8009f3:	68 60 09 80 00       	push   $0x800960
  8009f8:	e8 11 02 00 00       	call   800c0e <vprintfmt>
  8009fd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a00:	a0 28 50 80 00       	mov    0x805028,%al
  800a05:	0f b6 c0             	movzbl %al,%eax
  800a08:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a0e:	83 ec 04             	sub    $0x4,%esp
  800a11:	50                   	push   %eax
  800a12:	52                   	push   %edx
  800a13:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a19:	83 c0 08             	add    $0x8,%eax
  800a1c:	50                   	push   %eax
  800a1d:	e8 0f 15 00 00       	call   801f31 <sys_cputs>
  800a22:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a25:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800a2c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a3a:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800a41:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a50:	50                   	push   %eax
  800a51:	e8 73 ff ff ff       	call   8009c9 <vcprintf>
  800a56:	83 c4 10             	add    $0x10,%esp
  800a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a67:	e8 73 16 00 00       	call   8020df <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a6c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	83 ec 08             	sub    $0x8,%esp
  800a78:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7b:	50                   	push   %eax
  800a7c:	e8 48 ff ff ff       	call   8009c9 <vcprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
  800a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a87:	e8 6d 16 00 00       	call   8020f9 <sys_enable_interrupt>
	return cnt;
  800a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	53                   	push   %ebx
  800a95:	83 ec 14             	sub    $0x14,%esp
  800a98:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800aa4:	8b 45 18             	mov    0x18(%ebp),%eax
  800aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  800aac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aaf:	77 55                	ja     800b06 <printnum+0x75>
  800ab1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ab4:	72 05                	jb     800abb <printnum+0x2a>
  800ab6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ab9:	77 4b                	ja     800b06 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800abb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800abe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ac1:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac9:	52                   	push   %edx
  800aca:	50                   	push   %eax
  800acb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ace:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad1:	e8 d6 2b 00 00       	call   8036ac <__udivdi3>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	ff 75 20             	pushl  0x20(%ebp)
  800adf:	53                   	push   %ebx
  800ae0:	ff 75 18             	pushl  0x18(%ebp)
  800ae3:	52                   	push   %edx
  800ae4:	50                   	push   %eax
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	ff 75 08             	pushl  0x8(%ebp)
  800aeb:	e8 a1 ff ff ff       	call   800a91 <printnum>
  800af0:	83 c4 20             	add    $0x20,%esp
  800af3:	eb 1a                	jmp    800b0f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	ff 75 20             	pushl  0x20(%ebp)
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b06:	ff 4d 1c             	decl   0x1c(%ebp)
  800b09:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b0d:	7f e6                	jg     800af5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b0f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1d:	53                   	push   %ebx
  800b1e:	51                   	push   %ecx
  800b1f:	52                   	push   %edx
  800b20:	50                   	push   %eax
  800b21:	e8 96 2c 00 00       	call   8037bc <__umoddi3>
  800b26:	83 c4 10             	add    $0x10,%esp
  800b29:	05 14 3f 80 00       	add    $0x803f14,%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f be c0             	movsbl %al,%eax
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	50                   	push   %eax
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
}
  800b42:	90                   	nop
  800b43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b4b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b4f:	7e 1c                	jle    800b6d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	8d 50 08             	lea    0x8(%eax),%edx
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	89 10                	mov    %edx,(%eax)
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	83 e8 08             	sub    $0x8,%eax
  800b66:	8b 50 04             	mov    0x4(%eax),%edx
  800b69:	8b 00                	mov    (%eax),%eax
  800b6b:	eb 40                	jmp    800bad <getuint+0x65>
	else if (lflag)
  800b6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b71:	74 1e                	je     800b91 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	8d 50 04             	lea    0x4(%eax),%edx
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	89 10                	mov    %edx,(%eax)
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	83 e8 04             	sub    $0x4,%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	eb 1c                	jmp    800bad <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8d 50 04             	lea    0x4(%eax),%edx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 10                	mov    %edx,(%eax)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	83 e8 04             	sub    $0x4,%eax
  800ba6:	8b 00                	mov    (%eax),%eax
  800ba8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bb2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bb6:	7e 1c                	jle    800bd4 <getint+0x25>
		return va_arg(*ap, long long);
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8b 00                	mov    (%eax),%eax
  800bbd:	8d 50 08             	lea    0x8(%eax),%edx
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	89 10                	mov    %edx,(%eax)
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	83 e8 08             	sub    $0x8,%eax
  800bcd:	8b 50 04             	mov    0x4(%eax),%edx
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	eb 38                	jmp    800c0c <getint+0x5d>
	else if (lflag)
  800bd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd8:	74 1a                	je     800bf4 <getint+0x45>
		return va_arg(*ap, long);
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	8d 50 04             	lea    0x4(%eax),%edx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	89 10                	mov    %edx,(%eax)
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8b 00                	mov    (%eax),%eax
  800bec:	83 e8 04             	sub    $0x4,%eax
  800bef:	8b 00                	mov    (%eax),%eax
  800bf1:	99                   	cltd   
  800bf2:	eb 18                	jmp    800c0c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	8d 50 04             	lea    0x4(%eax),%edx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 10                	mov    %edx,(%eax)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	83 e8 04             	sub    $0x4,%eax
  800c09:	8b 00                	mov    (%eax),%eax
  800c0b:	99                   	cltd   
}
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	56                   	push   %esi
  800c12:	53                   	push   %ebx
  800c13:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c16:	eb 17                	jmp    800c2f <vprintfmt+0x21>
			if (ch == '\0')
  800c18:	85 db                	test   %ebx,%ebx
  800c1a:	0f 84 af 03 00 00    	je     800fcf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	53                   	push   %ebx
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	ff d0                	call   *%eax
  800c2c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 10             	mov    %edx,0x10(%ebp)
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	0f b6 d8             	movzbl %al,%ebx
  800c3d:	83 fb 25             	cmp    $0x25,%ebx
  800c40:	75 d6                	jne    800c18 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c42:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c46:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c4d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c54:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c5b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	8d 50 01             	lea    0x1(%eax),%edx
  800c68:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	0f b6 d8             	movzbl %al,%ebx
  800c70:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c73:	83 f8 55             	cmp    $0x55,%eax
  800c76:	0f 87 2b 03 00 00    	ja     800fa7 <vprintfmt+0x399>
  800c7c:	8b 04 85 38 3f 80 00 	mov    0x803f38(,%eax,4),%eax
  800c83:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c85:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c89:	eb d7                	jmp    800c62 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c8b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c8f:	eb d1                	jmp    800c62 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c9b:	89 d0                	mov    %edx,%eax
  800c9d:	c1 e0 02             	shl    $0x2,%eax
  800ca0:	01 d0                	add    %edx,%eax
  800ca2:	01 c0                	add    %eax,%eax
  800ca4:	01 d8                	add    %ebx,%eax
  800ca6:	83 e8 30             	sub    $0x30,%eax
  800ca9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cac:	8b 45 10             	mov    0x10(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cb4:	83 fb 2f             	cmp    $0x2f,%ebx
  800cb7:	7e 3e                	jle    800cf7 <vprintfmt+0xe9>
  800cb9:	83 fb 39             	cmp    $0x39,%ebx
  800cbc:	7f 39                	jg     800cf7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cbe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cc1:	eb d5                	jmp    800c98 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 c0 04             	add    $0x4,%eax
  800cc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccf:	83 e8 04             	sub    $0x4,%eax
  800cd2:	8b 00                	mov    (%eax),%eax
  800cd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cd7:	eb 1f                	jmp    800cf8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cd9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cdd:	79 83                	jns    800c62 <vprintfmt+0x54>
				width = 0;
  800cdf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ce6:	e9 77 ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ceb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cf2:	e9 6b ff ff ff       	jmp    800c62 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cf7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cf8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cfc:	0f 89 60 ff ff ff    	jns    800c62 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d08:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d0f:	e9 4e ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d14:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d17:	e9 46 ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1f:	83 c0 04             	add    $0x4,%eax
  800d22:	89 45 14             	mov    %eax,0x14(%ebp)
  800d25:	8b 45 14             	mov    0x14(%ebp),%eax
  800d28:	83 e8 04             	sub    $0x4,%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	83 ec 08             	sub    $0x8,%esp
  800d30:	ff 75 0c             	pushl  0xc(%ebp)
  800d33:	50                   	push   %eax
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	ff d0                	call   *%eax
  800d39:	83 c4 10             	add    $0x10,%esp
			break;
  800d3c:	e9 89 02 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 c0 04             	add    $0x4,%eax
  800d47:	89 45 14             	mov    %eax,0x14(%ebp)
  800d4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4d:	83 e8 04             	sub    $0x4,%eax
  800d50:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d52:	85 db                	test   %ebx,%ebx
  800d54:	79 02                	jns    800d58 <vprintfmt+0x14a>
				err = -err;
  800d56:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d58:	83 fb 64             	cmp    $0x64,%ebx
  800d5b:	7f 0b                	jg     800d68 <vprintfmt+0x15a>
  800d5d:	8b 34 9d 80 3d 80 00 	mov    0x803d80(,%ebx,4),%esi
  800d64:	85 f6                	test   %esi,%esi
  800d66:	75 19                	jne    800d81 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d68:	53                   	push   %ebx
  800d69:	68 25 3f 80 00       	push   $0x803f25
  800d6e:	ff 75 0c             	pushl  0xc(%ebp)
  800d71:	ff 75 08             	pushl  0x8(%ebp)
  800d74:	e8 5e 02 00 00       	call   800fd7 <printfmt>
  800d79:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d7c:	e9 49 02 00 00       	jmp    800fca <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d81:	56                   	push   %esi
  800d82:	68 2e 3f 80 00       	push   $0x803f2e
  800d87:	ff 75 0c             	pushl  0xc(%ebp)
  800d8a:	ff 75 08             	pushl  0x8(%ebp)
  800d8d:	e8 45 02 00 00       	call   800fd7 <printfmt>
  800d92:	83 c4 10             	add    $0x10,%esp
			break;
  800d95:	e9 30 02 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9d:	83 c0 04             	add    $0x4,%eax
  800da0:	89 45 14             	mov    %eax,0x14(%ebp)
  800da3:	8b 45 14             	mov    0x14(%ebp),%eax
  800da6:	83 e8 04             	sub    $0x4,%eax
  800da9:	8b 30                	mov    (%eax),%esi
  800dab:	85 f6                	test   %esi,%esi
  800dad:	75 05                	jne    800db4 <vprintfmt+0x1a6>
				p = "(null)";
  800daf:	be 31 3f 80 00       	mov    $0x803f31,%esi
			if (width > 0 && padc != '-')
  800db4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db8:	7e 6d                	jle    800e27 <vprintfmt+0x219>
  800dba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dbe:	74 67                	je     800e27 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dc3:	83 ec 08             	sub    $0x8,%esp
  800dc6:	50                   	push   %eax
  800dc7:	56                   	push   %esi
  800dc8:	e8 12 05 00 00       	call   8012df <strnlen>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dd3:	eb 16                	jmp    800deb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dd5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dd9:	83 ec 08             	sub    $0x8,%esp
  800ddc:	ff 75 0c             	pushl  0xc(%ebp)
  800ddf:	50                   	push   %eax
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	ff d0                	call   *%eax
  800de5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800de8:	ff 4d e4             	decl   -0x1c(%ebp)
  800deb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800def:	7f e4                	jg     800dd5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df1:	eb 34                	jmp    800e27 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800df3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800df7:	74 1c                	je     800e15 <vprintfmt+0x207>
  800df9:	83 fb 1f             	cmp    $0x1f,%ebx
  800dfc:	7e 05                	jle    800e03 <vprintfmt+0x1f5>
  800dfe:	83 fb 7e             	cmp    $0x7e,%ebx
  800e01:	7e 12                	jle    800e15 <vprintfmt+0x207>
					putch('?', putdat);
  800e03:	83 ec 08             	sub    $0x8,%esp
  800e06:	ff 75 0c             	pushl  0xc(%ebp)
  800e09:	6a 3f                	push   $0x3f
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	ff d0                	call   *%eax
  800e10:	83 c4 10             	add    $0x10,%esp
  800e13:	eb 0f                	jmp    800e24 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	53                   	push   %ebx
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e24:	ff 4d e4             	decl   -0x1c(%ebp)
  800e27:	89 f0                	mov    %esi,%eax
  800e29:	8d 70 01             	lea    0x1(%eax),%esi
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	0f be d8             	movsbl %al,%ebx
  800e31:	85 db                	test   %ebx,%ebx
  800e33:	74 24                	je     800e59 <vprintfmt+0x24b>
  800e35:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e39:	78 b8                	js     800df3 <vprintfmt+0x1e5>
  800e3b:	ff 4d e0             	decl   -0x20(%ebp)
  800e3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e42:	79 af                	jns    800df3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e44:	eb 13                	jmp    800e59 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e46:	83 ec 08             	sub    $0x8,%esp
  800e49:	ff 75 0c             	pushl  0xc(%ebp)
  800e4c:	6a 20                	push   $0x20
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	ff d0                	call   *%eax
  800e53:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e56:	ff 4d e4             	decl   -0x1c(%ebp)
  800e59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5d:	7f e7                	jg     800e46 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e5f:	e9 66 01 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e64:	83 ec 08             	sub    $0x8,%esp
  800e67:	ff 75 e8             	pushl  -0x18(%ebp)
  800e6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e6d:	50                   	push   %eax
  800e6e:	e8 3c fd ff ff       	call   800baf <getint>
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e82:	85 d2                	test   %edx,%edx
  800e84:	79 23                	jns    800ea9 <vprintfmt+0x29b>
				putch('-', putdat);
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	ff 75 0c             	pushl  0xc(%ebp)
  800e8c:	6a 2d                	push   $0x2d
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	ff d0                	call   *%eax
  800e93:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9c:	f7 d8                	neg    %eax
  800e9e:	83 d2 00             	adc    $0x0,%edx
  800ea1:	f7 da                	neg    %edx
  800ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ea9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eb0:	e9 bc 00 00 00       	jmp    800f71 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	ff 75 e8             	pushl  -0x18(%ebp)
  800ebb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebe:	50                   	push   %eax
  800ebf:	e8 84 fc ff ff       	call   800b48 <getuint>
  800ec4:	83 c4 10             	add    $0x10,%esp
  800ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ecd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ed4:	e9 98 00 00 00       	jmp    800f71 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 0c             	pushl  0xc(%ebp)
  800edf:	6a 58                	push   $0x58
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	ff d0                	call   *%eax
  800ee6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ee9:	83 ec 08             	sub    $0x8,%esp
  800eec:	ff 75 0c             	pushl  0xc(%ebp)
  800eef:	6a 58                	push   $0x58
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	ff d0                	call   *%eax
  800ef6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ef9:	83 ec 08             	sub    $0x8,%esp
  800efc:	ff 75 0c             	pushl  0xc(%ebp)
  800eff:	6a 58                	push   $0x58
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	ff d0                	call   *%eax
  800f06:	83 c4 10             	add    $0x10,%esp
			break;
  800f09:	e9 bc 00 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 0c             	pushl  0xc(%ebp)
  800f14:	6a 30                	push   $0x30
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	ff d0                	call   *%eax
  800f1b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	ff 75 0c             	pushl  0xc(%ebp)
  800f24:	6a 78                	push   $0x78
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	ff d0                	call   *%eax
  800f2b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f31:	83 c0 04             	add    $0x4,%eax
  800f34:	89 45 14             	mov    %eax,0x14(%ebp)
  800f37:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3a:	83 e8 04             	sub    $0x4,%eax
  800f3d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f49:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f50:	eb 1f                	jmp    800f71 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f52:	83 ec 08             	sub    $0x8,%esp
  800f55:	ff 75 e8             	pushl  -0x18(%ebp)
  800f58:	8d 45 14             	lea    0x14(%ebp),%eax
  800f5b:	50                   	push   %eax
  800f5c:	e8 e7 fb ff ff       	call   800b48 <getuint>
  800f61:	83 c4 10             	add    $0x10,%esp
  800f64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f71:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f78:	83 ec 04             	sub    $0x4,%esp
  800f7b:	52                   	push   %edx
  800f7c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f7f:	50                   	push   %eax
  800f80:	ff 75 f4             	pushl  -0xc(%ebp)
  800f83:	ff 75 f0             	pushl  -0x10(%ebp)
  800f86:	ff 75 0c             	pushl  0xc(%ebp)
  800f89:	ff 75 08             	pushl  0x8(%ebp)
  800f8c:	e8 00 fb ff ff       	call   800a91 <printnum>
  800f91:	83 c4 20             	add    $0x20,%esp
			break;
  800f94:	eb 34                	jmp    800fca <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	53                   	push   %ebx
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	ff d0                	call   *%eax
  800fa2:	83 c4 10             	add    $0x10,%esp
			break;
  800fa5:	eb 23                	jmp    800fca <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	6a 25                	push   $0x25
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	ff d0                	call   *%eax
  800fb4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fb7:	ff 4d 10             	decl   0x10(%ebp)
  800fba:	eb 03                	jmp    800fbf <vprintfmt+0x3b1>
  800fbc:	ff 4d 10             	decl   0x10(%ebp)
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	48                   	dec    %eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3c 25                	cmp    $0x25,%al
  800fc7:	75 f3                	jne    800fbc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fc9:	90                   	nop
		}
	}
  800fca:	e9 47 fc ff ff       	jmp    800c16 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fcf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fd3:	5b                   	pop    %ebx
  800fd4:	5e                   	pop    %esi
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    

00800fd7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fdd:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe0:	83 c0 04             	add    $0x4,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe9:	ff 75 f4             	pushl  -0xc(%ebp)
  800fec:	50                   	push   %eax
  800fed:	ff 75 0c             	pushl  0xc(%ebp)
  800ff0:	ff 75 08             	pushl  0x8(%ebp)
  800ff3:	e8 16 fc ff ff       	call   800c0e <vprintfmt>
  800ff8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ffb:	90                   	nop
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	8b 40 08             	mov    0x8(%eax),%eax
  801007:	8d 50 01             	lea    0x1(%eax),%edx
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	8b 10                	mov    (%eax),%edx
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	8b 40 04             	mov    0x4(%eax),%eax
  80101b:	39 c2                	cmp    %eax,%edx
  80101d:	73 12                	jae    801031 <sprintputch+0x33>
		*b->buf++ = ch;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	8b 00                	mov    (%eax),%eax
  801024:	8d 48 01             	lea    0x1(%eax),%ecx
  801027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102a:	89 0a                	mov    %ecx,(%edx)
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	88 10                	mov    %dl,(%eax)
}
  801031:	90                   	nop
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	8d 50 ff             	lea    -0x1(%eax),%edx
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801055:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801059:	74 06                	je     801061 <vsnprintf+0x2d>
  80105b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80105f:	7f 07                	jg     801068 <vsnprintf+0x34>
		return -E_INVAL;
  801061:	b8 03 00 00 00       	mov    $0x3,%eax
  801066:	eb 20                	jmp    801088 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801068:	ff 75 14             	pushl  0x14(%ebp)
  80106b:	ff 75 10             	pushl  0x10(%ebp)
  80106e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801071:	50                   	push   %eax
  801072:	68 fe 0f 80 00       	push   $0x800ffe
  801077:	e8 92 fb ff ff       	call   800c0e <vprintfmt>
  80107c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80107f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801082:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801085:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801090:	8d 45 10             	lea    0x10(%ebp),%eax
  801093:	83 c0 04             	add    $0x4,%eax
  801096:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	ff 75 f4             	pushl  -0xc(%ebp)
  80109f:	50                   	push   %eax
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 08             	pushl  0x8(%ebp)
  8010a6:	e8 89 ff ff ff       	call   801034 <vsnprintf>
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c0:	74 13                	je     8010d5 <readline+0x1f>
		cprintf("%s", prompt);
  8010c2:	83 ec 08             	sub    $0x8,%esp
  8010c5:	ff 75 08             	pushl  0x8(%ebp)
  8010c8:	68 90 40 80 00       	push   $0x804090
  8010cd:	e8 62 f9 ff ff       	call   800a34 <cprintf>
  8010d2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010dc:	83 ec 0c             	sub    $0xc,%esp
  8010df:	6a 00                	push   $0x0
  8010e1:	e8 54 f5 ff ff       	call   80063a <iscons>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010ec:	e8 fb f4 ff ff       	call   8005ec <getchar>
  8010f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010f8:	79 22                	jns    80111c <readline+0x66>
			if (c != -E_EOF)
  8010fa:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010fe:	0f 84 ad 00 00 00    	je     8011b1 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801104:	83 ec 08             	sub    $0x8,%esp
  801107:	ff 75 ec             	pushl  -0x14(%ebp)
  80110a:	68 93 40 80 00       	push   $0x804093
  80110f:	e8 20 f9 ff ff       	call   800a34 <cprintf>
  801114:	83 c4 10             	add    $0x10,%esp
			return;
  801117:	e9 95 00 00 00       	jmp    8011b1 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80111c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801120:	7e 34                	jle    801156 <readline+0xa0>
  801122:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801129:	7f 2b                	jg     801156 <readline+0xa0>
			if (echoing)
  80112b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80112f:	74 0e                	je     80113f <readline+0x89>
				cputchar(c);
  801131:	83 ec 0c             	sub    $0xc,%esp
  801134:	ff 75 ec             	pushl  -0x14(%ebp)
  801137:	e8 68 f4 ff ff       	call   8005a4 <cputchar>
  80113c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80113f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801142:	8d 50 01             	lea    0x1(%eax),%edx
  801145:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801148:	89 c2                	mov    %eax,%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801152:	88 10                	mov    %dl,(%eax)
  801154:	eb 56                	jmp    8011ac <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801156:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80115a:	75 1f                	jne    80117b <readline+0xc5>
  80115c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801160:	7e 19                	jle    80117b <readline+0xc5>
			if (echoing)
  801162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801166:	74 0e                	je     801176 <readline+0xc0>
				cputchar(c);
  801168:	83 ec 0c             	sub    $0xc,%esp
  80116b:	ff 75 ec             	pushl  -0x14(%ebp)
  80116e:	e8 31 f4 ff ff       	call   8005a4 <cputchar>
  801173:	83 c4 10             	add    $0x10,%esp

			i--;
  801176:	ff 4d f4             	decl   -0xc(%ebp)
  801179:	eb 31                	jmp    8011ac <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80117b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80117f:	74 0a                	je     80118b <readline+0xd5>
  801181:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801185:	0f 85 61 ff ff ff    	jne    8010ec <readline+0x36>
			if (echoing)
  80118b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80118f:	74 0e                	je     80119f <readline+0xe9>
				cputchar(c);
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	ff 75 ec             	pushl  -0x14(%ebp)
  801197:	e8 08 f4 ff ff       	call   8005a4 <cputchar>
  80119c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011aa:	eb 06                	jmp    8011b2 <readline+0xfc>
		}
	}
  8011ac:	e9 3b ff ff ff       	jmp    8010ec <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011b1:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011ba:	e8 20 0f 00 00       	call   8020df <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	74 13                	je     8011d8 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	68 90 40 80 00       	push   $0x804090
  8011d0:	e8 5f f8 ff ff       	call   800a34 <cprintf>
  8011d5:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	6a 00                	push   $0x0
  8011e4:	e8 51 f4 ff ff       	call   80063a <iscons>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011ef:	e8 f8 f3 ff ff       	call   8005ec <getchar>
  8011f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011fb:	79 23                	jns    801220 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011fd:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801201:	74 13                	je     801216 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801203:	83 ec 08             	sub    $0x8,%esp
  801206:	ff 75 ec             	pushl  -0x14(%ebp)
  801209:	68 93 40 80 00       	push   $0x804093
  80120e:	e8 21 f8 ff ff       	call   800a34 <cprintf>
  801213:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801216:	e8 de 0e 00 00       	call   8020f9 <sys_enable_interrupt>
			return;
  80121b:	e9 9a 00 00 00       	jmp    8012ba <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801220:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801224:	7e 34                	jle    80125a <atomic_readline+0xa6>
  801226:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80122d:	7f 2b                	jg     80125a <atomic_readline+0xa6>
			if (echoing)
  80122f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801233:	74 0e                	je     801243 <atomic_readline+0x8f>
				cputchar(c);
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	ff 75 ec             	pushl  -0x14(%ebp)
  80123b:	e8 64 f3 ff ff       	call   8005a4 <cputchar>
  801240:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801246:	8d 50 01             	lea    0x1(%eax),%edx
  801249:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80124c:	89 c2                	mov    %eax,%edx
  80124e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801251:	01 d0                	add    %edx,%eax
  801253:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801256:	88 10                	mov    %dl,(%eax)
  801258:	eb 5b                	jmp    8012b5 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80125a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80125e:	75 1f                	jne    80127f <atomic_readline+0xcb>
  801260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801264:	7e 19                	jle    80127f <atomic_readline+0xcb>
			if (echoing)
  801266:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126a:	74 0e                	je     80127a <atomic_readline+0xc6>
				cputchar(c);
  80126c:	83 ec 0c             	sub    $0xc,%esp
  80126f:	ff 75 ec             	pushl  -0x14(%ebp)
  801272:	e8 2d f3 ff ff       	call   8005a4 <cputchar>
  801277:	83 c4 10             	add    $0x10,%esp
			i--;
  80127a:	ff 4d f4             	decl   -0xc(%ebp)
  80127d:	eb 36                	jmp    8012b5 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80127f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801283:	74 0a                	je     80128f <atomic_readline+0xdb>
  801285:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801289:	0f 85 60 ff ff ff    	jne    8011ef <atomic_readline+0x3b>
			if (echoing)
  80128f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801293:	74 0e                	je     8012a3 <atomic_readline+0xef>
				cputchar(c);
  801295:	83 ec 0c             	sub    $0xc,%esp
  801298:	ff 75 ec             	pushl  -0x14(%ebp)
  80129b:	e8 04 f3 ff ff       	call   8005a4 <cputchar>
  8012a0:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a9:	01 d0                	add    %edx,%eax
  8012ab:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012ae:	e8 46 0e 00 00       	call   8020f9 <sys_enable_interrupt>
			return;
  8012b3:	eb 05                	jmp    8012ba <atomic_readline+0x106>
		}
	}
  8012b5:	e9 35 ff ff ff       	jmp    8011ef <atomic_readline+0x3b>
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c9:	eb 06                	jmp    8012d1 <strlen+0x15>
		n++;
  8012cb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ce:	ff 45 08             	incl   0x8(%ebp)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 f1                	jne    8012cb <strlen+0xf>
		n++;
	return n;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ec:	eb 09                	jmp    8012f7 <strnlen+0x18>
		n++;
  8012ee:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f1:	ff 45 08             	incl   0x8(%ebp)
  8012f4:	ff 4d 0c             	decl   0xc(%ebp)
  8012f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012fb:	74 09                	je     801306 <strnlen+0x27>
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	84 c0                	test   %al,%al
  801304:	75 e8                	jne    8012ee <strnlen+0xf>
		n++;
	return n;
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801317:	90                   	nop
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8d 50 01             	lea    0x1(%eax),%edx
  80131e:	89 55 08             	mov    %edx,0x8(%ebp)
  801321:	8b 55 0c             	mov    0xc(%ebp),%edx
  801324:	8d 4a 01             	lea    0x1(%edx),%ecx
  801327:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80132a:	8a 12                	mov    (%edx),%dl
  80132c:	88 10                	mov    %dl,(%eax)
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	75 e4                	jne    801318 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801334:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80134c:	eb 1f                	jmp    80136d <strncpy+0x34>
		*dst++ = *src;
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8d 50 01             	lea    0x1(%eax),%edx
  801354:	89 55 08             	mov    %edx,0x8(%ebp)
  801357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135a:	8a 12                	mov    (%edx),%dl
  80135c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	84 c0                	test   %al,%al
  801365:	74 03                	je     80136a <strncpy+0x31>
			src++;
  801367:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80136a:	ff 45 fc             	incl   -0x4(%ebp)
  80136d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801370:	3b 45 10             	cmp    0x10(%ebp),%eax
  801373:	72 d9                	jb     80134e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138a:	74 30                	je     8013bc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80138c:	eb 16                	jmp    8013a4 <strlcpy+0x2a>
			*dst++ = *src++;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8d 50 01             	lea    0x1(%eax),%edx
  801394:	89 55 08             	mov    %edx,0x8(%ebp)
  801397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80139d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013a0:	8a 12                	mov    (%edx),%dl
  8013a2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013a4:	ff 4d 10             	decl   0x10(%ebp)
  8013a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ab:	74 09                	je     8013b6 <strlcpy+0x3c>
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	84 c0                	test   %al,%al
  8013b4:	75 d8                	jne    80138e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c2:	29 c2                	sub    %eax,%edx
  8013c4:	89 d0                	mov    %edx,%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013cb:	eb 06                	jmp    8013d3 <strcmp+0xb>
		p++, q++;
  8013cd:	ff 45 08             	incl   0x8(%ebp)
  8013d0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	84 c0                	test   %al,%al
  8013da:	74 0e                	je     8013ea <strcmp+0x22>
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 e3                	je     8013cd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
}
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    

00801400 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801403:	eb 09                	jmp    80140e <strncmp+0xe>
		n--, p++, q++;
  801405:	ff 4d 10             	decl   0x10(%ebp)
  801408:	ff 45 08             	incl   0x8(%ebp)
  80140b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80140e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801412:	74 17                	je     80142b <strncmp+0x2b>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	74 0e                	je     80142b <strncmp+0x2b>
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 10                	mov    (%eax),%dl
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	38 c2                	cmp    %al,%dl
  801429:	74 da                	je     801405 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80142b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142f:	75 07                	jne    801438 <strncmp+0x38>
		return 0;
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
  801436:	eb 14                	jmp    80144c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	0f b6 d0             	movzbl %al,%edx
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	0f b6 c0             	movzbl %al,%eax
  801448:	29 c2                	sub    %eax,%edx
  80144a:	89 d0                	mov    %edx,%eax
}
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    

0080144e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80145a:	eb 12                	jmp    80146e <strchr+0x20>
		if (*s == c)
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801464:	75 05                	jne    80146b <strchr+0x1d>
			return (char *) s;
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	eb 11                	jmp    80147c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80146b:	ff 45 08             	incl   0x8(%ebp)
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	84 c0                	test   %al,%al
  801475:	75 e5                	jne    80145c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	8b 45 0c             	mov    0xc(%ebp),%eax
  801487:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80148a:	eb 0d                	jmp    801499 <strfind+0x1b>
		if (*s == c)
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801494:	74 0e                	je     8014a4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801496:	ff 45 08             	incl   0x8(%ebp)
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	84 c0                	test   %al,%al
  8014a0:	75 ea                	jne    80148c <strfind+0xe>
  8014a2:	eb 01                	jmp    8014a5 <strfind+0x27>
		if (*s == c)
			break;
  8014a4:	90                   	nop
	return (char *) s;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014bc:	eb 0e                	jmp    8014cc <memset+0x22>
		*p++ = c;
  8014be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c1:	8d 50 01             	lea    0x1(%eax),%edx
  8014c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ca:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014cc:	ff 4d f8             	decl   -0x8(%ebp)
  8014cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014d3:	79 e9                	jns    8014be <memset+0x14>
		*p++ = c;

	return v;
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014ec:	eb 16                	jmp    801504 <memcpy+0x2a>
		*d++ = *s++;
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	8d 50 01             	lea    0x1(%eax),%edx
  8014f4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014fd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801500:	8a 12                	mov    (%edx),%dl
  801502:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801504:	8b 45 10             	mov    0x10(%ebp),%eax
  801507:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150a:	89 55 10             	mov    %edx,0x10(%ebp)
  80150d:	85 c0                	test   %eax,%eax
  80150f:	75 dd                	jne    8014ee <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801528:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80152e:	73 50                	jae    801580 <memmove+0x6a>
  801530:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801533:	8b 45 10             	mov    0x10(%ebp),%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153b:	76 43                	jbe    801580 <memmove+0x6a>
		s += n;
  80153d:	8b 45 10             	mov    0x10(%ebp),%eax
  801540:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801543:	8b 45 10             	mov    0x10(%ebp),%eax
  801546:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801549:	eb 10                	jmp    80155b <memmove+0x45>
			*--d = *--s;
  80154b:	ff 4d f8             	decl   -0x8(%ebp)
  80154e:	ff 4d fc             	decl   -0x4(%ebp)
  801551:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801554:	8a 10                	mov    (%eax),%dl
  801556:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801559:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80155b:	8b 45 10             	mov    0x10(%ebp),%eax
  80155e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801561:	89 55 10             	mov    %edx,0x10(%ebp)
  801564:	85 c0                	test   %eax,%eax
  801566:	75 e3                	jne    80154b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801568:	eb 23                	jmp    80158d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80156a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156d:	8d 50 01             	lea    0x1(%eax),%edx
  801570:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801573:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801576:	8d 4a 01             	lea    0x1(%edx),%ecx
  801579:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80157c:	8a 12                	mov    (%edx),%dl
  80157e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801580:	8b 45 10             	mov    0x10(%ebp),%eax
  801583:	8d 50 ff             	lea    -0x1(%eax),%edx
  801586:	89 55 10             	mov    %edx,0x10(%ebp)
  801589:	85 c0                	test   %eax,%eax
  80158b:	75 dd                	jne    80156a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015a4:	eb 2a                	jmp    8015d0 <memcmp+0x3e>
		if (*s1 != *s2)
  8015a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a9:	8a 10                	mov    (%eax),%dl
  8015ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	38 c2                	cmp    %al,%dl
  8015b2:	74 16                	je     8015ca <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	0f b6 d0             	movzbl %al,%edx
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	0f b6 c0             	movzbl %al,%eax
  8015c4:	29 c2                	sub    %eax,%edx
  8015c6:	89 d0                	mov    %edx,%eax
  8015c8:	eb 18                	jmp    8015e2 <memcmp+0x50>
		s1++, s2++;
  8015ca:	ff 45 fc             	incl   -0x4(%ebp)
  8015cd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	75 c9                	jne    8015a6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f0:	01 d0                	add    %edx,%eax
  8015f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015f5:	eb 15                	jmp    80160c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	0f b6 d0             	movzbl %al,%edx
  8015ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801602:	0f b6 c0             	movzbl %al,%eax
  801605:	39 c2                	cmp    %eax,%edx
  801607:	74 0d                	je     801616 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801609:	ff 45 08             	incl   0x8(%ebp)
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801612:	72 e3                	jb     8015f7 <memfind+0x13>
  801614:	eb 01                	jmp    801617 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801616:	90                   	nop
	return (void *) s;
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801622:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801629:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801630:	eb 03                	jmp    801635 <strtol+0x19>
		s++;
  801632:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	3c 20                	cmp    $0x20,%al
  80163c:	74 f4                	je     801632 <strtol+0x16>
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8a 00                	mov    (%eax),%al
  801643:	3c 09                	cmp    $0x9,%al
  801645:	74 eb                	je     801632 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	3c 2b                	cmp    $0x2b,%al
  80164e:	75 05                	jne    801655 <strtol+0x39>
		s++;
  801650:	ff 45 08             	incl   0x8(%ebp)
  801653:	eb 13                	jmp    801668 <strtol+0x4c>
	else if (*s == '-')
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	3c 2d                	cmp    $0x2d,%al
  80165c:	75 0a                	jne    801668 <strtol+0x4c>
		s++, neg = 1;
  80165e:	ff 45 08             	incl   0x8(%ebp)
  801661:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801668:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80166c:	74 06                	je     801674 <strtol+0x58>
  80166e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801672:	75 20                	jne    801694 <strtol+0x78>
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	3c 30                	cmp    $0x30,%al
  80167b:	75 17                	jne    801694 <strtol+0x78>
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	40                   	inc    %eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3c 78                	cmp    $0x78,%al
  801685:	75 0d                	jne    801694 <strtol+0x78>
		s += 2, base = 16;
  801687:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80168b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801692:	eb 28                	jmp    8016bc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801694:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801698:	75 15                	jne    8016af <strtol+0x93>
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 00                	mov    (%eax),%al
  80169f:	3c 30                	cmp    $0x30,%al
  8016a1:	75 0c                	jne    8016af <strtol+0x93>
		s++, base = 8;
  8016a3:	ff 45 08             	incl   0x8(%ebp)
  8016a6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016ad:	eb 0d                	jmp    8016bc <strtol+0xa0>
	else if (base == 0)
  8016af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b3:	75 07                	jne    8016bc <strtol+0xa0>
		base = 10;
  8016b5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8a 00                	mov    (%eax),%al
  8016c1:	3c 2f                	cmp    $0x2f,%al
  8016c3:	7e 19                	jle    8016de <strtol+0xc2>
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8a 00                	mov    (%eax),%al
  8016ca:	3c 39                	cmp    $0x39,%al
  8016cc:	7f 10                	jg     8016de <strtol+0xc2>
			dig = *s - '0';
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8a 00                	mov    (%eax),%al
  8016d3:	0f be c0             	movsbl %al,%eax
  8016d6:	83 e8 30             	sub    $0x30,%eax
  8016d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016dc:	eb 42                	jmp    801720 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	8a 00                	mov    (%eax),%al
  8016e3:	3c 60                	cmp    $0x60,%al
  8016e5:	7e 19                	jle    801700 <strtol+0xe4>
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8a 00                	mov    (%eax),%al
  8016ec:	3c 7a                	cmp    $0x7a,%al
  8016ee:	7f 10                	jg     801700 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8a 00                	mov    (%eax),%al
  8016f5:	0f be c0             	movsbl %al,%eax
  8016f8:	83 e8 57             	sub    $0x57,%eax
  8016fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016fe:	eb 20                	jmp    801720 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	3c 40                	cmp    $0x40,%al
  801707:	7e 39                	jle    801742 <strtol+0x126>
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	3c 5a                	cmp    $0x5a,%al
  801710:	7f 30                	jg     801742 <strtol+0x126>
			dig = *s - 'A' + 10;
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	8a 00                	mov    (%eax),%al
  801717:	0f be c0             	movsbl %al,%eax
  80171a:	83 e8 37             	sub    $0x37,%eax
  80171d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801723:	3b 45 10             	cmp    0x10(%ebp),%eax
  801726:	7d 19                	jge    801741 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801728:	ff 45 08             	incl   0x8(%ebp)
  80172b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801732:	89 c2                	mov    %eax,%edx
  801734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80173c:	e9 7b ff ff ff       	jmp    8016bc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801741:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801742:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801746:	74 08                	je     801750 <strtol+0x134>
		*endptr = (char *) s;
  801748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174b:	8b 55 08             	mov    0x8(%ebp),%edx
  80174e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801750:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801754:	74 07                	je     80175d <strtol+0x141>
  801756:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801759:	f7 d8                	neg    %eax
  80175b:	eb 03                	jmp    801760 <strtol+0x144>
  80175d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <ltostr>:

void
ltostr(long value, char *str)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80176f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801776:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80177a:	79 13                	jns    80178f <ltostr+0x2d>
	{
		neg = 1;
  80177c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801789:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80178c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801797:	99                   	cltd   
  801798:	f7 f9                	idiv   %ecx
  80179a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80179d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a0:	8d 50 01             	lea    0x1(%eax),%edx
  8017a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017a6:	89 c2                	mov    %eax,%edx
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	01 d0                	add    %edx,%eax
  8017ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017b0:	83 c2 30             	add    $0x30,%edx
  8017b3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017bd:	f7 e9                	imul   %ecx
  8017bf:	c1 fa 02             	sar    $0x2,%edx
  8017c2:	89 c8                	mov    %ecx,%eax
  8017c4:	c1 f8 1f             	sar    $0x1f,%eax
  8017c7:	29 c2                	sub    %eax,%edx
  8017c9:	89 d0                	mov    %edx,%eax
  8017cb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017d6:	f7 e9                	imul   %ecx
  8017d8:	c1 fa 02             	sar    $0x2,%edx
  8017db:	89 c8                	mov    %ecx,%eax
  8017dd:	c1 f8 1f             	sar    $0x1f,%eax
  8017e0:	29 c2                	sub    %eax,%edx
  8017e2:	89 d0                	mov    %edx,%eax
  8017e4:	c1 e0 02             	shl    $0x2,%eax
  8017e7:	01 d0                	add    %edx,%eax
  8017e9:	01 c0                	add    %eax,%eax
  8017eb:	29 c1                	sub    %eax,%ecx
  8017ed:	89 ca                	mov    %ecx,%edx
  8017ef:	85 d2                	test   %edx,%edx
  8017f1:	75 9c                	jne    80178f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fd:	48                   	dec    %eax
  8017fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801801:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801805:	74 3d                	je     801844 <ltostr+0xe2>
		start = 1 ;
  801807:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80180e:	eb 34                	jmp    801844 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801810:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801813:	8b 45 0c             	mov    0xc(%ebp),%eax
  801816:	01 d0                	add    %edx,%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80181d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801820:	8b 45 0c             	mov    0xc(%ebp),%eax
  801823:	01 c2                	add    %eax,%edx
  801825:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	01 c8                	add    %ecx,%eax
  80182d:	8a 00                	mov    (%eax),%al
  80182f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801831:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801834:	8b 45 0c             	mov    0xc(%ebp),%eax
  801837:	01 c2                	add    %eax,%edx
  801839:	8a 45 eb             	mov    -0x15(%ebp),%al
  80183c:	88 02                	mov    %al,(%edx)
		start++ ;
  80183e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801841:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801847:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184a:	7c c4                	jl     801810 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80184c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80184f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801852:	01 d0                	add    %edx,%eax
  801854:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801857:	90                   	nop
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	e8 54 fa ff ff       	call   8012bc <strlen>
  801868:	83 c4 04             	add    $0x4,%esp
  80186b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	e8 46 fa ff ff       	call   8012bc <strlen>
  801876:	83 c4 04             	add    $0x4,%esp
  801879:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80187c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801883:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80188a:	eb 17                	jmp    8018a3 <strcconcat+0x49>
		final[s] = str1[s] ;
  80188c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188f:	8b 45 10             	mov    0x10(%ebp),%eax
  801892:	01 c2                	add    %eax,%edx
  801894:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	01 c8                	add    %ecx,%eax
  80189c:	8a 00                	mov    (%eax),%al
  80189e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018a0:	ff 45 fc             	incl   -0x4(%ebp)
  8018a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018a9:	7c e1                	jl     80188c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018b9:	eb 1f                	jmp    8018da <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018be:	8d 50 01             	lea    0x1(%eax),%edx
  8018c1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018c4:	89 c2                	mov    %eax,%edx
  8018c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c9:	01 c2                	add    %eax,%edx
  8018cb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d1:	01 c8                	add    %ecx,%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018d7:	ff 45 f8             	incl   -0x8(%ebp)
  8018da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018e0:	7c d9                	jl     8018bb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 d0                	add    %edx,%eax
  8018ea:	c6 00 00             	movb   $0x0,(%eax)
}
  8018ed:	90                   	nop
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ff:	8b 00                	mov    (%eax),%eax
  801901:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801908:	8b 45 10             	mov    0x10(%ebp),%eax
  80190b:	01 d0                	add    %edx,%eax
  80190d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801913:	eb 0c                	jmp    801921 <strsplit+0x31>
			*string++ = 0;
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	8d 50 01             	lea    0x1(%eax),%edx
  80191b:	89 55 08             	mov    %edx,0x8(%ebp)
  80191e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	8a 00                	mov    (%eax),%al
  801926:	84 c0                	test   %al,%al
  801928:	74 18                	je     801942 <strsplit+0x52>
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	8a 00                	mov    (%eax),%al
  80192f:	0f be c0             	movsbl %al,%eax
  801932:	50                   	push   %eax
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	e8 13 fb ff ff       	call   80144e <strchr>
  80193b:	83 c4 08             	add    $0x8,%esp
  80193e:	85 c0                	test   %eax,%eax
  801940:	75 d3                	jne    801915 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	8a 00                	mov    (%eax),%al
  801947:	84 c0                	test   %al,%al
  801949:	74 5a                	je     8019a5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80194b:	8b 45 14             	mov    0x14(%ebp),%eax
  80194e:	8b 00                	mov    (%eax),%eax
  801950:	83 f8 0f             	cmp    $0xf,%eax
  801953:	75 07                	jne    80195c <strsplit+0x6c>
		{
			return 0;
  801955:	b8 00 00 00 00       	mov    $0x0,%eax
  80195a:	eb 66                	jmp    8019c2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	8b 00                	mov    (%eax),%eax
  801961:	8d 48 01             	lea    0x1(%eax),%ecx
  801964:	8b 55 14             	mov    0x14(%ebp),%edx
  801967:	89 0a                	mov    %ecx,(%edx)
  801969:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801970:	8b 45 10             	mov    0x10(%ebp),%eax
  801973:	01 c2                	add    %eax,%edx
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197a:	eb 03                	jmp    80197f <strsplit+0x8f>
			string++;
  80197c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	84 c0                	test   %al,%al
  801986:	74 8b                	je     801913 <strsplit+0x23>
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	8a 00                	mov    (%eax),%al
  80198d:	0f be c0             	movsbl %al,%eax
  801990:	50                   	push   %eax
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	e8 b5 fa ff ff       	call   80144e <strchr>
  801999:	83 c4 08             	add    $0x8,%esp
  80199c:	85 c0                	test   %eax,%eax
  80199e:	74 dc                	je     80197c <strsplit+0x8c>
			string++;
	}
  8019a0:	e9 6e ff ff ff       	jmp    801913 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019a5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a9:	8b 00                	mov    (%eax),%eax
  8019ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b5:	01 d0                	add    %edx,%eax
  8019b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8019ca:	a1 04 50 80 00       	mov    0x805004,%eax
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	74 1f                	je     8019f2 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8019d3:	e8 1d 00 00 00       	call   8019f5 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8019d8:	83 ec 0c             	sub    $0xc,%esp
  8019db:	68 a4 40 80 00       	push   $0x8040a4
  8019e0:	e8 4f f0 ff ff       	call   800a34 <cprintf>
  8019e5:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019e8:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8019ef:	00 00 00 
	}
}
  8019f2:	90                   	nop
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  8019fb:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801a02:	00 00 00 
  801a05:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801a0c:	00 00 00 
  801a0f:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801a16:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801a19:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801a20:	00 00 00 
  801a23:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801a2a:	00 00 00 
  801a2d:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801a34:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801a37:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a41:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a46:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a4b:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801a50:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801a57:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801a5a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a64:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801a69:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a74:	f7 75 f0             	divl   -0x10(%ebp)
  801a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a7a:	29 d0                	sub    %edx,%eax
  801a7c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801a7f:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801a86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a8e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a93:	83 ec 04             	sub    $0x4,%esp
  801a96:	6a 06                	push   $0x6
  801a98:	ff 75 e8             	pushl  -0x18(%ebp)
  801a9b:	50                   	push   %eax
  801a9c:	e8 d4 05 00 00       	call   802075 <sys_allocate_chunk>
  801aa1:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801aa4:	a1 20 51 80 00       	mov    0x805120,%eax
  801aa9:	83 ec 0c             	sub    $0xc,%esp
  801aac:	50                   	push   %eax
  801aad:	e8 49 0c 00 00       	call   8026fb <initialize_MemBlocksList>
  801ab2:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801ab5:	a1 48 51 80 00       	mov    0x805148,%eax
  801aba:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801abd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ac1:	75 14                	jne    801ad7 <initialize_dyn_block_system+0xe2>
  801ac3:	83 ec 04             	sub    $0x4,%esp
  801ac6:	68 c9 40 80 00       	push   $0x8040c9
  801acb:	6a 39                	push   $0x39
  801acd:	68 e7 40 80 00       	push   $0x8040e7
  801ad2:	e8 a9 ec ff ff       	call   800780 <_panic>
  801ad7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ada:	8b 00                	mov    (%eax),%eax
  801adc:	85 c0                	test   %eax,%eax
  801ade:	74 10                	je     801af0 <initialize_dyn_block_system+0xfb>
  801ae0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ae3:	8b 00                	mov    (%eax),%eax
  801ae5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ae8:	8b 52 04             	mov    0x4(%edx),%edx
  801aeb:	89 50 04             	mov    %edx,0x4(%eax)
  801aee:	eb 0b                	jmp    801afb <initialize_dyn_block_system+0x106>
  801af0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801af3:	8b 40 04             	mov    0x4(%eax),%eax
  801af6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801afe:	8b 40 04             	mov    0x4(%eax),%eax
  801b01:	85 c0                	test   %eax,%eax
  801b03:	74 0f                	je     801b14 <initialize_dyn_block_system+0x11f>
  801b05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b08:	8b 40 04             	mov    0x4(%eax),%eax
  801b0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b0e:	8b 12                	mov    (%edx),%edx
  801b10:	89 10                	mov    %edx,(%eax)
  801b12:	eb 0a                	jmp    801b1e <initialize_dyn_block_system+0x129>
  801b14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b17:	8b 00                	mov    (%eax),%eax
  801b19:	a3 48 51 80 00       	mov    %eax,0x805148
  801b1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b31:	a1 54 51 80 00       	mov    0x805154,%eax
  801b36:	48                   	dec    %eax
  801b37:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801b3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b3f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801b46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b49:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801b50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b54:	75 14                	jne    801b6a <initialize_dyn_block_system+0x175>
  801b56:	83 ec 04             	sub    $0x4,%esp
  801b59:	68 f4 40 80 00       	push   $0x8040f4
  801b5e:	6a 3f                	push   $0x3f
  801b60:	68 e7 40 80 00       	push   $0x8040e7
  801b65:	e8 16 ec ff ff       	call   800780 <_panic>
  801b6a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801b70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b73:	89 10                	mov    %edx,(%eax)
  801b75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b78:	8b 00                	mov    (%eax),%eax
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	74 0d                	je     801b8b <initialize_dyn_block_system+0x196>
  801b7e:	a1 38 51 80 00       	mov    0x805138,%eax
  801b83:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b86:	89 50 04             	mov    %edx,0x4(%eax)
  801b89:	eb 08                	jmp    801b93 <initialize_dyn_block_system+0x19e>
  801b8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b8e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801b93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b96:	a3 38 51 80 00       	mov    %eax,0x805138
  801b9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ba5:	a1 44 51 80 00       	mov    0x805144,%eax
  801baa:	40                   	inc    %eax
  801bab:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801bb0:	90                   	nop
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bb9:	e8 06 fe ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bc2:	75 07                	jne    801bcb <malloc+0x18>
  801bc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc9:	eb 7d                	jmp    801c48 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801bcb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801bd2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bd9:	8b 55 08             	mov    0x8(%ebp),%edx
  801bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bdf:	01 d0                	add    %edx,%eax
  801be1:	48                   	dec    %eax
  801be2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801be5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bed:	f7 75 f0             	divl   -0x10(%ebp)
  801bf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf3:	29 d0                	sub    %edx,%eax
  801bf5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801bf8:	e8 46 08 00 00       	call   802443 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bfd:	83 f8 01             	cmp    $0x1,%eax
  801c00:	75 07                	jne    801c09 <malloc+0x56>
  801c02:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801c09:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801c0d:	75 34                	jne    801c43 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801c0f:	83 ec 0c             	sub    $0xc,%esp
  801c12:	ff 75 e8             	pushl  -0x18(%ebp)
  801c15:	e8 73 0e 00 00       	call   802a8d <alloc_block_FF>
  801c1a:	83 c4 10             	add    $0x10,%esp
  801c1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801c20:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c24:	74 16                	je     801c3c <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801c26:	83 ec 0c             	sub    $0xc,%esp
  801c29:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c2c:	e8 ff 0b 00 00       	call   802830 <insert_sorted_allocList>
  801c31:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801c34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c37:	8b 40 08             	mov    0x8(%eax),%eax
  801c3a:	eb 0c                	jmp    801c48 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c41:	eb 05                	jmp    801c48 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801c43:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801c50:	8b 45 08             	mov    0x8(%ebp),%eax
  801c53:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c64:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801c67:	83 ec 08             	sub    $0x8,%esp
  801c6a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c6d:	68 40 50 80 00       	push   $0x805040
  801c72:	e8 61 0b 00 00       	call   8027d8 <find_block>
  801c77:	83 c4 10             	add    $0x10,%esp
  801c7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801c7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c81:	0f 84 a5 00 00 00    	je     801d2c <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801c87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c8a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c8d:	83 ec 08             	sub    $0x8,%esp
  801c90:	50                   	push   %eax
  801c91:	ff 75 f4             	pushl  -0xc(%ebp)
  801c94:	e8 a4 03 00 00       	call   80203d <sys_free_user_mem>
  801c99:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801c9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ca0:	75 17                	jne    801cb9 <free+0x6f>
  801ca2:	83 ec 04             	sub    $0x4,%esp
  801ca5:	68 c9 40 80 00       	push   $0x8040c9
  801caa:	68 87 00 00 00       	push   $0x87
  801caf:	68 e7 40 80 00       	push   $0x8040e7
  801cb4:	e8 c7 ea ff ff       	call   800780 <_panic>
  801cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cbc:	8b 00                	mov    (%eax),%eax
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	74 10                	je     801cd2 <free+0x88>
  801cc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cc5:	8b 00                	mov    (%eax),%eax
  801cc7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cca:	8b 52 04             	mov    0x4(%edx),%edx
  801ccd:	89 50 04             	mov    %edx,0x4(%eax)
  801cd0:	eb 0b                	jmp    801cdd <free+0x93>
  801cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd5:	8b 40 04             	mov    0x4(%eax),%eax
  801cd8:	a3 44 50 80 00       	mov    %eax,0x805044
  801cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ce0:	8b 40 04             	mov    0x4(%eax),%eax
  801ce3:	85 c0                	test   %eax,%eax
  801ce5:	74 0f                	je     801cf6 <free+0xac>
  801ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cea:	8b 40 04             	mov    0x4(%eax),%eax
  801ced:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cf0:	8b 12                	mov    (%edx),%edx
  801cf2:	89 10                	mov    %edx,(%eax)
  801cf4:	eb 0a                	jmp    801d00 <free+0xb6>
  801cf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf9:	8b 00                	mov    (%eax),%eax
  801cfb:	a3 40 50 80 00       	mov    %eax,0x805040
  801d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d13:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801d18:	48                   	dec    %eax
  801d19:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801d1e:	83 ec 0c             	sub    $0xc,%esp
  801d21:	ff 75 ec             	pushl  -0x14(%ebp)
  801d24:	e8 37 12 00 00       	call   802f60 <insert_sorted_with_merge_freeList>
  801d29:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801d2c:	90                   	nop
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	83 ec 38             	sub    $0x38,%esp
  801d35:	8b 45 10             	mov    0x10(%ebp),%eax
  801d38:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d3b:	e8 84 fc ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d44:	75 07                	jne    801d4d <smalloc+0x1e>
  801d46:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4b:	eb 7e                	jmp    801dcb <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801d4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801d54:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d61:	01 d0                	add    %edx,%eax
  801d63:	48                   	dec    %eax
  801d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6f:	f7 75 f0             	divl   -0x10(%ebp)
  801d72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d75:	29 d0                	sub    %edx,%eax
  801d77:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801d7a:	e8 c4 06 00 00       	call   802443 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d7f:	83 f8 01             	cmp    $0x1,%eax
  801d82:	75 42                	jne    801dc6 <smalloc+0x97>

		  va = malloc(newsize) ;
  801d84:	83 ec 0c             	sub    $0xc,%esp
  801d87:	ff 75 e8             	pushl  -0x18(%ebp)
  801d8a:	e8 24 fe ff ff       	call   801bb3 <malloc>
  801d8f:	83 c4 10             	add    $0x10,%esp
  801d92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801d95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d99:	74 24                	je     801dbf <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801d9b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d9f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801da2:	50                   	push   %eax
  801da3:	ff 75 e8             	pushl  -0x18(%ebp)
  801da6:	ff 75 08             	pushl  0x8(%ebp)
  801da9:	e8 1a 04 00 00       	call   8021c8 <sys_createSharedObject>
  801dae:	83 c4 10             	add    $0x10,%esp
  801db1:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801db4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801db8:	78 0c                	js     801dc6 <smalloc+0x97>
					  return va ;
  801dba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dbd:	eb 0c                	jmp    801dcb <smalloc+0x9c>
				 }
				 else
					return NULL;
  801dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc4:	eb 05                	jmp    801dcb <smalloc+0x9c>
	  }
		  return NULL ;
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dd3:	e8 ec fb ff ff       	call   8019c4 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801dd8:	83 ec 08             	sub    $0x8,%esp
  801ddb:	ff 75 0c             	pushl  0xc(%ebp)
  801dde:	ff 75 08             	pushl  0x8(%ebp)
  801de1:	e8 0c 04 00 00       	call   8021f2 <sys_getSizeOfSharedObject>
  801de6:	83 c4 10             	add    $0x10,%esp
  801de9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801dec:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801df0:	75 07                	jne    801df9 <sget+0x2c>
  801df2:	b8 00 00 00 00       	mov    $0x0,%eax
  801df7:	eb 75                	jmp    801e6e <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801df9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e06:	01 d0                	add    %edx,%eax
  801e08:	48                   	dec    %eax
  801e09:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e0f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e14:	f7 75 f0             	divl   -0x10(%ebp)
  801e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e1a:	29 d0                	sub    %edx,%eax
  801e1c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801e1f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801e26:	e8 18 06 00 00       	call   802443 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e2b:	83 f8 01             	cmp    $0x1,%eax
  801e2e:	75 39                	jne    801e69 <sget+0x9c>

		  va = malloc(newsize) ;
  801e30:	83 ec 0c             	sub    $0xc,%esp
  801e33:	ff 75 e8             	pushl  -0x18(%ebp)
  801e36:	e8 78 fd ff ff       	call   801bb3 <malloc>
  801e3b:	83 c4 10             	add    $0x10,%esp
  801e3e:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801e41:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e45:	74 22                	je     801e69 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801e47:	83 ec 04             	sub    $0x4,%esp
  801e4a:	ff 75 e0             	pushl  -0x20(%ebp)
  801e4d:	ff 75 0c             	pushl  0xc(%ebp)
  801e50:	ff 75 08             	pushl  0x8(%ebp)
  801e53:	e8 b7 03 00 00       	call   80220f <sys_getSharedObject>
  801e58:	83 c4 10             	add    $0x10,%esp
  801e5b:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801e5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e62:	78 05                	js     801e69 <sget+0x9c>
					  return va;
  801e64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e67:	eb 05                	jmp    801e6e <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801e69:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e76:	e8 49 fb ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e7b:	83 ec 04             	sub    $0x4,%esp
  801e7e:	68 18 41 80 00       	push   $0x804118
  801e83:	68 1e 01 00 00       	push   $0x11e
  801e88:	68 e7 40 80 00       	push   $0x8040e7
  801e8d:	e8 ee e8 ff ff       	call   800780 <_panic>

00801e92 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e98:	83 ec 04             	sub    $0x4,%esp
  801e9b:	68 40 41 80 00       	push   $0x804140
  801ea0:	68 32 01 00 00       	push   $0x132
  801ea5:	68 e7 40 80 00       	push   $0x8040e7
  801eaa:	e8 d1 e8 ff ff       	call   800780 <_panic>

00801eaf <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eb5:	83 ec 04             	sub    $0x4,%esp
  801eb8:	68 64 41 80 00       	push   $0x804164
  801ebd:	68 3d 01 00 00       	push   $0x13d
  801ec2:	68 e7 40 80 00       	push   $0x8040e7
  801ec7:	e8 b4 e8 ff ff       	call   800780 <_panic>

00801ecc <shrink>:

}
void shrink(uint32 newSize)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ed2:	83 ec 04             	sub    $0x4,%esp
  801ed5:	68 64 41 80 00       	push   $0x804164
  801eda:	68 42 01 00 00       	push   $0x142
  801edf:	68 e7 40 80 00       	push   $0x8040e7
  801ee4:	e8 97 e8 ff ff       	call   800780 <_panic>

00801ee9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eef:	83 ec 04             	sub    $0x4,%esp
  801ef2:	68 64 41 80 00       	push   $0x804164
  801ef7:	68 47 01 00 00       	push   $0x147
  801efc:	68 e7 40 80 00       	push   $0x8040e7
  801f01:	e8 7a e8 ff ff       	call   800780 <_panic>

00801f06 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	57                   	push   %edi
  801f0a:	56                   	push   %esi
  801f0b:	53                   	push   %ebx
  801f0c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f15:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f18:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f1b:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f1e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f21:	cd 30                	int    $0x30
  801f23:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	5b                   	pop    %ebx
  801f2d:	5e                   	pop    %esi
  801f2e:	5f                   	pop    %edi
  801f2f:	5d                   	pop    %ebp
  801f30:	c3                   	ret    

00801f31 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 04             	sub    $0x4,%esp
  801f37:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f3d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f41:	8b 45 08             	mov    0x8(%ebp),%eax
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	52                   	push   %edx
  801f49:	ff 75 0c             	pushl  0xc(%ebp)
  801f4c:	50                   	push   %eax
  801f4d:	6a 00                	push   $0x0
  801f4f:	e8 b2 ff ff ff       	call   801f06 <syscall>
  801f54:	83 c4 18             	add    $0x18,%esp
}
  801f57:	90                   	nop
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <sys_cgetc>:

int
sys_cgetc(void)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 01                	push   $0x1
  801f69:	e8 98 ff ff ff       	call   801f06 <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	52                   	push   %edx
  801f83:	50                   	push   %eax
  801f84:	6a 05                	push   $0x5
  801f86:	e8 7b ff ff ff       	call   801f06 <syscall>
  801f8b:	83 c4 18             	add    $0x18,%esp
}
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	56                   	push   %esi
  801f94:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f95:	8b 75 18             	mov    0x18(%ebp),%esi
  801f98:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	56                   	push   %esi
  801fa5:	53                   	push   %ebx
  801fa6:	51                   	push   %ecx
  801fa7:	52                   	push   %edx
  801fa8:	50                   	push   %eax
  801fa9:	6a 06                	push   $0x6
  801fab:	e8 56 ff ff ff       	call   801f06 <syscall>
  801fb0:	83 c4 18             	add    $0x18,%esp
}
  801fb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fb6:	5b                   	pop    %ebx
  801fb7:	5e                   	pop    %esi
  801fb8:	5d                   	pop    %ebp
  801fb9:	c3                   	ret    

00801fba <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fbd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	52                   	push   %edx
  801fca:	50                   	push   %eax
  801fcb:	6a 07                	push   $0x7
  801fcd:	e8 34 ff ff ff       	call   801f06 <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	ff 75 0c             	pushl  0xc(%ebp)
  801fe3:	ff 75 08             	pushl  0x8(%ebp)
  801fe6:	6a 08                	push   $0x8
  801fe8:	e8 19 ff ff ff       	call   801f06 <syscall>
  801fed:	83 c4 18             	add    $0x18,%esp
}
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 09                	push   $0x9
  802001:	e8 00 ff ff ff       	call   801f06 <syscall>
  802006:	83 c4 18             	add    $0x18,%esp
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 0a                	push   $0xa
  80201a:	e8 e7 fe ff ff       	call   801f06 <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
}
  802022:	c9                   	leave  
  802023:	c3                   	ret    

00802024 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 0b                	push   $0xb
  802033:	e8 ce fe ff ff       	call   801f06 <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	ff 75 0c             	pushl  0xc(%ebp)
  802049:	ff 75 08             	pushl  0x8(%ebp)
  80204c:	6a 0f                	push   $0xf
  80204e:	e8 b3 fe ff ff       	call   801f06 <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
	return;
  802056:	90                   	nop
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	ff 75 0c             	pushl  0xc(%ebp)
  802065:	ff 75 08             	pushl  0x8(%ebp)
  802068:	6a 10                	push   $0x10
  80206a:	e8 97 fe ff ff       	call   801f06 <syscall>
  80206f:	83 c4 18             	add    $0x18,%esp
	return ;
  802072:	90                   	nop
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	ff 75 10             	pushl  0x10(%ebp)
  80207f:	ff 75 0c             	pushl  0xc(%ebp)
  802082:	ff 75 08             	pushl  0x8(%ebp)
  802085:	6a 11                	push   $0x11
  802087:	e8 7a fe ff ff       	call   801f06 <syscall>
  80208c:	83 c4 18             	add    $0x18,%esp
	return ;
  80208f:	90                   	nop
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 0c                	push   $0xc
  8020a1:	e8 60 fe ff ff       	call   801f06 <syscall>
  8020a6:	83 c4 18             	add    $0x18,%esp
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	ff 75 08             	pushl  0x8(%ebp)
  8020b9:	6a 0d                	push   $0xd
  8020bb:	e8 46 fe ff ff       	call   801f06 <syscall>
  8020c0:	83 c4 18             	add    $0x18,%esp
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 0e                	push   $0xe
  8020d4:	e8 2d fe ff ff       	call   801f06 <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
}
  8020dc:	90                   	nop
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 13                	push   $0x13
  8020ee:	e8 13 fe ff ff       	call   801f06 <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
}
  8020f6:	90                   	nop
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 14                	push   $0x14
  802108:	e8 f9 fd ff ff       	call   801f06 <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
}
  802110:	90                   	nop
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <sys_cputc>:


void
sys_cputc(const char c)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	83 ec 04             	sub    $0x4,%esp
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80211f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	50                   	push   %eax
  80212c:	6a 15                	push   $0x15
  80212e:	e8 d3 fd ff ff       	call   801f06 <syscall>
  802133:	83 c4 18             	add    $0x18,%esp
}
  802136:	90                   	nop
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 16                	push   $0x16
  802148:	e8 b9 fd ff ff       	call   801f06 <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
}
  802150:	90                   	nop
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	ff 75 0c             	pushl  0xc(%ebp)
  802162:	50                   	push   %eax
  802163:	6a 17                	push   $0x17
  802165:	e8 9c fd ff ff       	call   801f06 <syscall>
  80216a:	83 c4 18             	add    $0x18,%esp
}
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    

0080216f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80216f:	55                   	push   %ebp
  802170:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802172:	8b 55 0c             	mov    0xc(%ebp),%edx
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	52                   	push   %edx
  80217f:	50                   	push   %eax
  802180:	6a 1a                	push   $0x1a
  802182:	e8 7f fd ff ff       	call   801f06 <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80218f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	52                   	push   %edx
  80219c:	50                   	push   %eax
  80219d:	6a 18                	push   $0x18
  80219f:	e8 62 fd ff ff       	call   801f06 <syscall>
  8021a4:	83 c4 18             	add    $0x18,%esp
}
  8021a7:	90                   	nop
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	52                   	push   %edx
  8021ba:	50                   	push   %eax
  8021bb:	6a 19                	push   $0x19
  8021bd:	e8 44 fd ff ff       	call   801f06 <syscall>
  8021c2:	83 c4 18             	add    $0x18,%esp
}
  8021c5:	90                   	nop
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	83 ec 04             	sub    $0x4,%esp
  8021ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021d4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021d7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	6a 00                	push   $0x0
  8021e0:	51                   	push   %ecx
  8021e1:	52                   	push   %edx
  8021e2:	ff 75 0c             	pushl  0xc(%ebp)
  8021e5:	50                   	push   %eax
  8021e6:	6a 1b                	push   $0x1b
  8021e8:	e8 19 fd ff ff       	call   801f06 <syscall>
  8021ed:	83 c4 18             	add    $0x18,%esp
}
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	52                   	push   %edx
  802202:	50                   	push   %eax
  802203:	6a 1c                	push   $0x1c
  802205:	e8 fc fc ff ff       	call   801f06 <syscall>
  80220a:	83 c4 18             	add    $0x18,%esp
}
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802212:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802215:	8b 55 0c             	mov    0xc(%ebp),%edx
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	51                   	push   %ecx
  802220:	52                   	push   %edx
  802221:	50                   	push   %eax
  802222:	6a 1d                	push   $0x1d
  802224:	e8 dd fc ff ff       	call   801f06 <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802231:	8b 55 0c             	mov    0xc(%ebp),%edx
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	52                   	push   %edx
  80223e:	50                   	push   %eax
  80223f:	6a 1e                	push   $0x1e
  802241:	e8 c0 fc ff ff       	call   801f06 <syscall>
  802246:	83 c4 18             	add    $0x18,%esp
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 1f                	push   $0x1f
  80225a:	e8 a7 fc ff ff       	call   801f06 <syscall>
  80225f:	83 c4 18             	add    $0x18,%esp
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	6a 00                	push   $0x0
  80226c:	ff 75 14             	pushl  0x14(%ebp)
  80226f:	ff 75 10             	pushl  0x10(%ebp)
  802272:	ff 75 0c             	pushl  0xc(%ebp)
  802275:	50                   	push   %eax
  802276:	6a 20                	push   $0x20
  802278:	e8 89 fc ff ff       	call   801f06 <syscall>
  80227d:	83 c4 18             	add    $0x18,%esp
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	50                   	push   %eax
  802291:	6a 21                	push   $0x21
  802293:	e8 6e fc ff ff       	call   801f06 <syscall>
  802298:	83 c4 18             	add    $0x18,%esp
}
  80229b:	90                   	nop
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	50                   	push   %eax
  8022ad:	6a 22                	push   $0x22
  8022af:	e8 52 fc ff ff       	call   801f06 <syscall>
  8022b4:	83 c4 18             	add    $0x18,%esp
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 02                	push   $0x2
  8022c8:	e8 39 fc ff ff       	call   801f06 <syscall>
  8022cd:	83 c4 18             	add    $0x18,%esp
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 03                	push   $0x3
  8022e1:	e8 20 fc ff ff       	call   801f06 <syscall>
  8022e6:	83 c4 18             	add    $0x18,%esp
}
  8022e9:	c9                   	leave  
  8022ea:	c3                   	ret    

008022eb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 04                	push   $0x4
  8022fa:	e8 07 fc ff ff       	call   801f06 <syscall>
  8022ff:	83 c4 18             	add    $0x18,%esp
}
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <sys_exit_env>:


void sys_exit_env(void)
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 23                	push   $0x23
  802313:	e8 ee fb ff ff       	call   801f06 <syscall>
  802318:	83 c4 18             	add    $0x18,%esp
}
  80231b:	90                   	nop
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802324:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802327:	8d 50 04             	lea    0x4(%eax),%edx
  80232a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 00                	push   $0x0
  802333:	52                   	push   %edx
  802334:	50                   	push   %eax
  802335:	6a 24                	push   $0x24
  802337:	e8 ca fb ff ff       	call   801f06 <syscall>
  80233c:	83 c4 18             	add    $0x18,%esp
	return result;
  80233f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802342:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802345:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802348:	89 01                	mov    %eax,(%ecx)
  80234a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	c9                   	leave  
  802351:	c2 04 00             	ret    $0x4

00802354 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	ff 75 10             	pushl  0x10(%ebp)
  80235e:	ff 75 0c             	pushl  0xc(%ebp)
  802361:	ff 75 08             	pushl  0x8(%ebp)
  802364:	6a 12                	push   $0x12
  802366:	e8 9b fb ff ff       	call   801f06 <syscall>
  80236b:	83 c4 18             	add    $0x18,%esp
	return ;
  80236e:	90                   	nop
}
  80236f:	c9                   	leave  
  802370:	c3                   	ret    

00802371 <sys_rcr2>:
uint32 sys_rcr2()
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 25                	push   $0x25
  802380:	e8 81 fb ff ff       	call   801f06 <syscall>
  802385:	83 c4 18             	add    $0x18,%esp
}
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	83 ec 04             	sub    $0x4,%esp
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802396:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	50                   	push   %eax
  8023a3:	6a 26                	push   $0x26
  8023a5:	e8 5c fb ff ff       	call   801f06 <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ad:	90                   	nop
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <rsttst>:
void rsttst()
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 28                	push   $0x28
  8023bf:	e8 42 fb ff ff       	call   801f06 <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c7:	90                   	nop
}
  8023c8:	c9                   	leave  
  8023c9:	c3                   	ret    

008023ca <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	83 ec 04             	sub    $0x4,%esp
  8023d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8023d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023d6:	8b 55 18             	mov    0x18(%ebp),%edx
  8023d9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023dd:	52                   	push   %edx
  8023de:	50                   	push   %eax
  8023df:	ff 75 10             	pushl  0x10(%ebp)
  8023e2:	ff 75 0c             	pushl  0xc(%ebp)
  8023e5:	ff 75 08             	pushl  0x8(%ebp)
  8023e8:	6a 27                	push   $0x27
  8023ea:	e8 17 fb ff ff       	call   801f06 <syscall>
  8023ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f2:	90                   	nop
}
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <chktst>:
void chktst(uint32 n)
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	ff 75 08             	pushl  0x8(%ebp)
  802403:	6a 29                	push   $0x29
  802405:	e8 fc fa ff ff       	call   801f06 <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
	return ;
  80240d:	90                   	nop
}
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <inctst>:

void inctst()
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 2a                	push   $0x2a
  80241f:	e8 e2 fa ff ff       	call   801f06 <syscall>
  802424:	83 c4 18             	add    $0x18,%esp
	return ;
  802427:	90                   	nop
}
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <gettst>:
uint32 gettst()
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 2b                	push   $0x2b
  802439:	e8 c8 fa ff ff       	call   801f06 <syscall>
  80243e:	83 c4 18             	add    $0x18,%esp
}
  802441:	c9                   	leave  
  802442:	c3                   	ret    

00802443 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802443:	55                   	push   %ebp
  802444:	89 e5                	mov    %esp,%ebp
  802446:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 2c                	push   $0x2c
  802455:	e8 ac fa ff ff       	call   801f06 <syscall>
  80245a:	83 c4 18             	add    $0x18,%esp
  80245d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802460:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802464:	75 07                	jne    80246d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802466:	b8 01 00 00 00       	mov    $0x1,%eax
  80246b:	eb 05                	jmp    802472 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80246d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802472:	c9                   	leave  
  802473:	c3                   	ret    

00802474 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
  802477:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 2c                	push   $0x2c
  802486:	e8 7b fa ff ff       	call   801f06 <syscall>
  80248b:	83 c4 18             	add    $0x18,%esp
  80248e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802491:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802495:	75 07                	jne    80249e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802497:	b8 01 00 00 00       	mov    $0x1,%eax
  80249c:	eb 05                	jmp    8024a3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80249e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
  8024a8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 2c                	push   $0x2c
  8024b7:	e8 4a fa ff ff       	call   801f06 <syscall>
  8024bc:	83 c4 18             	add    $0x18,%esp
  8024bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024c2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024c6:	75 07                	jne    8024cf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8024cd:	eb 05                	jmp    8024d4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 2c                	push   $0x2c
  8024e8:	e8 19 fa ff ff       	call   801f06 <syscall>
  8024ed:	83 c4 18             	add    $0x18,%esp
  8024f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024f3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024f7:	75 07                	jne    802500 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8024fe:	eb 05                	jmp    802505 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802500:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	ff 75 08             	pushl  0x8(%ebp)
  802515:	6a 2d                	push   $0x2d
  802517:	e8 ea f9 ff ff       	call   801f06 <syscall>
  80251c:	83 c4 18             	add    $0x18,%esp
	return ;
  80251f:	90                   	nop
}
  802520:	c9                   	leave  
  802521:	c3                   	ret    

00802522 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
  802525:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802526:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802529:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80252c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80252f:	8b 45 08             	mov    0x8(%ebp),%eax
  802532:	6a 00                	push   $0x0
  802534:	53                   	push   %ebx
  802535:	51                   	push   %ecx
  802536:	52                   	push   %edx
  802537:	50                   	push   %eax
  802538:	6a 2e                	push   $0x2e
  80253a:	e8 c7 f9 ff ff       	call   801f06 <syscall>
  80253f:	83 c4 18             	add    $0x18,%esp
}
  802542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802545:	c9                   	leave  
  802546:	c3                   	ret    

00802547 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80254a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	52                   	push   %edx
  802557:	50                   	push   %eax
  802558:	6a 2f                	push   $0x2f
  80255a:	e8 a7 f9 ff ff       	call   801f06 <syscall>
  80255f:	83 c4 18             	add    $0x18,%esp
}
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80256a:	83 ec 0c             	sub    $0xc,%esp
  80256d:	68 74 41 80 00       	push   $0x804174
  802572:	e8 bd e4 ff ff       	call   800a34 <cprintf>
  802577:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80257a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802581:	83 ec 0c             	sub    $0xc,%esp
  802584:	68 a0 41 80 00       	push   $0x8041a0
  802589:	e8 a6 e4 ff ff       	call   800a34 <cprintf>
  80258e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802591:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802595:	a1 38 51 80 00       	mov    0x805138,%eax
  80259a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259d:	eb 56                	jmp    8025f5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80259f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025a3:	74 1c                	je     8025c1 <print_mem_block_lists+0x5d>
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 50 08             	mov    0x8(%eax),%edx
  8025ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ae:	8b 48 08             	mov    0x8(%eax),%ecx
  8025b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b7:	01 c8                	add    %ecx,%eax
  8025b9:	39 c2                	cmp    %eax,%edx
  8025bb:	73 04                	jae    8025c1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8025bd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 50 08             	mov    0x8(%eax),%edx
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8025cd:	01 c2                	add    %eax,%edx
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 40 08             	mov    0x8(%eax),%eax
  8025d5:	83 ec 04             	sub    $0x4,%esp
  8025d8:	52                   	push   %edx
  8025d9:	50                   	push   %eax
  8025da:	68 b5 41 80 00       	push   $0x8041b5
  8025df:	e8 50 e4 ff ff       	call   800a34 <cprintf>
  8025e4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025ed:	a1 40 51 80 00       	mov    0x805140,%eax
  8025f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f9:	74 07                	je     802602 <print_mem_block_lists+0x9e>
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 00                	mov    (%eax),%eax
  802600:	eb 05                	jmp    802607 <print_mem_block_lists+0xa3>
  802602:	b8 00 00 00 00       	mov    $0x0,%eax
  802607:	a3 40 51 80 00       	mov    %eax,0x805140
  80260c:	a1 40 51 80 00       	mov    0x805140,%eax
  802611:	85 c0                	test   %eax,%eax
  802613:	75 8a                	jne    80259f <print_mem_block_lists+0x3b>
  802615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802619:	75 84                	jne    80259f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80261b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80261f:	75 10                	jne    802631 <print_mem_block_lists+0xcd>
  802621:	83 ec 0c             	sub    $0xc,%esp
  802624:	68 c4 41 80 00       	push   $0x8041c4
  802629:	e8 06 e4 ff ff       	call   800a34 <cprintf>
  80262e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802631:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802638:	83 ec 0c             	sub    $0xc,%esp
  80263b:	68 e8 41 80 00       	push   $0x8041e8
  802640:	e8 ef e3 ff ff       	call   800a34 <cprintf>
  802645:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802648:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80264c:	a1 40 50 80 00       	mov    0x805040,%eax
  802651:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802654:	eb 56                	jmp    8026ac <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802656:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80265a:	74 1c                	je     802678 <print_mem_block_lists+0x114>
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 50 08             	mov    0x8(%eax),%edx
  802662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802665:	8b 48 08             	mov    0x8(%eax),%ecx
  802668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266b:	8b 40 0c             	mov    0xc(%eax),%eax
  80266e:	01 c8                	add    %ecx,%eax
  802670:	39 c2                	cmp    %eax,%edx
  802672:	73 04                	jae    802678 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802674:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	8b 50 08             	mov    0x8(%eax),%edx
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 40 0c             	mov    0xc(%eax),%eax
  802684:	01 c2                	add    %eax,%edx
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 40 08             	mov    0x8(%eax),%eax
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	52                   	push   %edx
  802690:	50                   	push   %eax
  802691:	68 b5 41 80 00       	push   $0x8041b5
  802696:	e8 99 e3 ff ff       	call   800a34 <cprintf>
  80269b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026a4:	a1 48 50 80 00       	mov    0x805048,%eax
  8026a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b0:	74 07                	je     8026b9 <print_mem_block_lists+0x155>
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 00                	mov    (%eax),%eax
  8026b7:	eb 05                	jmp    8026be <print_mem_block_lists+0x15a>
  8026b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026be:	a3 48 50 80 00       	mov    %eax,0x805048
  8026c3:	a1 48 50 80 00       	mov    0x805048,%eax
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	75 8a                	jne    802656 <print_mem_block_lists+0xf2>
  8026cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d0:	75 84                	jne    802656 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026d2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026d6:	75 10                	jne    8026e8 <print_mem_block_lists+0x184>
  8026d8:	83 ec 0c             	sub    $0xc,%esp
  8026db:	68 00 42 80 00       	push   $0x804200
  8026e0:	e8 4f e3 ff ff       	call   800a34 <cprintf>
  8026e5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026e8:	83 ec 0c             	sub    $0xc,%esp
  8026eb:	68 74 41 80 00       	push   $0x804174
  8026f0:	e8 3f e3 ff ff       	call   800a34 <cprintf>
  8026f5:	83 c4 10             	add    $0x10,%esp

}
  8026f8:	90                   	nop
  8026f9:	c9                   	leave  
  8026fa:	c3                   	ret    

008026fb <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026fb:	55                   	push   %ebp
  8026fc:	89 e5                	mov    %esp,%ebp
  8026fe:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802701:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802708:	00 00 00 
  80270b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802712:	00 00 00 
  802715:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80271c:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80271f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802726:	e9 9e 00 00 00       	jmp    8027c9 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80272b:	a1 50 50 80 00       	mov    0x805050,%eax
  802730:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802733:	c1 e2 04             	shl    $0x4,%edx
  802736:	01 d0                	add    %edx,%eax
  802738:	85 c0                	test   %eax,%eax
  80273a:	75 14                	jne    802750 <initialize_MemBlocksList+0x55>
  80273c:	83 ec 04             	sub    $0x4,%esp
  80273f:	68 28 42 80 00       	push   $0x804228
  802744:	6a 47                	push   $0x47
  802746:	68 4b 42 80 00       	push   $0x80424b
  80274b:	e8 30 e0 ff ff       	call   800780 <_panic>
  802750:	a1 50 50 80 00       	mov    0x805050,%eax
  802755:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802758:	c1 e2 04             	shl    $0x4,%edx
  80275b:	01 d0                	add    %edx,%eax
  80275d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802763:	89 10                	mov    %edx,(%eax)
  802765:	8b 00                	mov    (%eax),%eax
  802767:	85 c0                	test   %eax,%eax
  802769:	74 18                	je     802783 <initialize_MemBlocksList+0x88>
  80276b:	a1 48 51 80 00       	mov    0x805148,%eax
  802770:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802776:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802779:	c1 e1 04             	shl    $0x4,%ecx
  80277c:	01 ca                	add    %ecx,%edx
  80277e:	89 50 04             	mov    %edx,0x4(%eax)
  802781:	eb 12                	jmp    802795 <initialize_MemBlocksList+0x9a>
  802783:	a1 50 50 80 00       	mov    0x805050,%eax
  802788:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278b:	c1 e2 04             	shl    $0x4,%edx
  80278e:	01 d0                	add    %edx,%eax
  802790:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802795:	a1 50 50 80 00       	mov    0x805050,%eax
  80279a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279d:	c1 e2 04             	shl    $0x4,%edx
  8027a0:	01 d0                	add    %edx,%eax
  8027a2:	a3 48 51 80 00       	mov    %eax,0x805148
  8027a7:	a1 50 50 80 00       	mov    0x805050,%eax
  8027ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027af:	c1 e2 04             	shl    $0x4,%edx
  8027b2:	01 d0                	add    %edx,%eax
  8027b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027bb:	a1 54 51 80 00       	mov    0x805154,%eax
  8027c0:	40                   	inc    %eax
  8027c1:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8027c6:	ff 45 f4             	incl   -0xc(%ebp)
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027cf:	0f 82 56 ff ff ff    	jb     80272b <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8027d5:	90                   	nop
  8027d6:	c9                   	leave  
  8027d7:	c3                   	ret    

008027d8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027d8:	55                   	push   %ebp
  8027d9:	89 e5                	mov    %esp,%ebp
  8027db:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	8b 00                	mov    (%eax),%eax
  8027e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027e6:	eb 19                	jmp    802801 <find_block+0x29>
	{
		if(element->sva == va){
  8027e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027eb:	8b 40 08             	mov    0x8(%eax),%eax
  8027ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027f1:	75 05                	jne    8027f8 <find_block+0x20>
			 		return element;
  8027f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027f6:	eb 36                	jmp    80282e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8027f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fb:	8b 40 08             	mov    0x8(%eax),%eax
  8027fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802801:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802805:	74 07                	je     80280e <find_block+0x36>
  802807:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	eb 05                	jmp    802813 <find_block+0x3b>
  80280e:	b8 00 00 00 00       	mov    $0x0,%eax
  802813:	8b 55 08             	mov    0x8(%ebp),%edx
  802816:	89 42 08             	mov    %eax,0x8(%edx)
  802819:	8b 45 08             	mov    0x8(%ebp),%eax
  80281c:	8b 40 08             	mov    0x8(%eax),%eax
  80281f:	85 c0                	test   %eax,%eax
  802821:	75 c5                	jne    8027e8 <find_block+0x10>
  802823:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802827:	75 bf                	jne    8027e8 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802829:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80282e:	c9                   	leave  
  80282f:	c3                   	ret    

00802830 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
  802833:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802836:	a1 44 50 80 00       	mov    0x805044,%eax
  80283b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  80283e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802843:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802846:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80284a:	74 0a                	je     802856 <insert_sorted_allocList+0x26>
  80284c:	8b 45 08             	mov    0x8(%ebp),%eax
  80284f:	8b 40 08             	mov    0x8(%eax),%eax
  802852:	85 c0                	test   %eax,%eax
  802854:	75 65                	jne    8028bb <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802856:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80285a:	75 14                	jne    802870 <insert_sorted_allocList+0x40>
  80285c:	83 ec 04             	sub    $0x4,%esp
  80285f:	68 28 42 80 00       	push   $0x804228
  802864:	6a 6e                	push   $0x6e
  802866:	68 4b 42 80 00       	push   $0x80424b
  80286b:	e8 10 df ff ff       	call   800780 <_panic>
  802870:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	89 10                	mov    %edx,(%eax)
  80287b:	8b 45 08             	mov    0x8(%ebp),%eax
  80287e:	8b 00                	mov    (%eax),%eax
  802880:	85 c0                	test   %eax,%eax
  802882:	74 0d                	je     802891 <insert_sorted_allocList+0x61>
  802884:	a1 40 50 80 00       	mov    0x805040,%eax
  802889:	8b 55 08             	mov    0x8(%ebp),%edx
  80288c:	89 50 04             	mov    %edx,0x4(%eax)
  80288f:	eb 08                	jmp    802899 <insert_sorted_allocList+0x69>
  802891:	8b 45 08             	mov    0x8(%ebp),%eax
  802894:	a3 44 50 80 00       	mov    %eax,0x805044
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	a3 40 50 80 00       	mov    %eax,0x805040
  8028a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ab:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028b0:	40                   	inc    %eax
  8028b1:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8028b6:	e9 cf 01 00 00       	jmp    802a8a <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8028bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028be:	8b 50 08             	mov    0x8(%eax),%edx
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	8b 40 08             	mov    0x8(%eax),%eax
  8028c7:	39 c2                	cmp    %eax,%edx
  8028c9:	73 65                	jae    802930 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8028cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028cf:	75 14                	jne    8028e5 <insert_sorted_allocList+0xb5>
  8028d1:	83 ec 04             	sub    $0x4,%esp
  8028d4:	68 64 42 80 00       	push   $0x804264
  8028d9:	6a 72                	push   $0x72
  8028db:	68 4b 42 80 00       	push   $0x80424b
  8028e0:	e8 9b de ff ff       	call   800780 <_panic>
  8028e5:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	89 50 04             	mov    %edx,0x4(%eax)
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	8b 40 04             	mov    0x4(%eax),%eax
  8028f7:	85 c0                	test   %eax,%eax
  8028f9:	74 0c                	je     802907 <insert_sorted_allocList+0xd7>
  8028fb:	a1 44 50 80 00       	mov    0x805044,%eax
  802900:	8b 55 08             	mov    0x8(%ebp),%edx
  802903:	89 10                	mov    %edx,(%eax)
  802905:	eb 08                	jmp    80290f <insert_sorted_allocList+0xdf>
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	a3 40 50 80 00       	mov    %eax,0x805040
  80290f:	8b 45 08             	mov    0x8(%ebp),%eax
  802912:	a3 44 50 80 00       	mov    %eax,0x805044
  802917:	8b 45 08             	mov    0x8(%ebp),%eax
  80291a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802920:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802925:	40                   	inc    %eax
  802926:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  80292b:	e9 5a 01 00 00       	jmp    802a8a <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802933:	8b 50 08             	mov    0x8(%eax),%edx
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	8b 40 08             	mov    0x8(%eax),%eax
  80293c:	39 c2                	cmp    %eax,%edx
  80293e:	75 70                	jne    8029b0 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802940:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802944:	74 06                	je     80294c <insert_sorted_allocList+0x11c>
  802946:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80294a:	75 14                	jne    802960 <insert_sorted_allocList+0x130>
  80294c:	83 ec 04             	sub    $0x4,%esp
  80294f:	68 88 42 80 00       	push   $0x804288
  802954:	6a 75                	push   $0x75
  802956:	68 4b 42 80 00       	push   $0x80424b
  80295b:	e8 20 de ff ff       	call   800780 <_panic>
  802960:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802963:	8b 10                	mov    (%eax),%edx
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	89 10                	mov    %edx,(%eax)
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	8b 00                	mov    (%eax),%eax
  80296f:	85 c0                	test   %eax,%eax
  802971:	74 0b                	je     80297e <insert_sorted_allocList+0x14e>
  802973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802976:	8b 00                	mov    (%eax),%eax
  802978:	8b 55 08             	mov    0x8(%ebp),%edx
  80297b:	89 50 04             	mov    %edx,0x4(%eax)
  80297e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802981:	8b 55 08             	mov    0x8(%ebp),%edx
  802984:	89 10                	mov    %edx,(%eax)
  802986:	8b 45 08             	mov    0x8(%ebp),%eax
  802989:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80298c:	89 50 04             	mov    %edx,0x4(%eax)
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	85 c0                	test   %eax,%eax
  802996:	75 08                	jne    8029a0 <insert_sorted_allocList+0x170>
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	a3 44 50 80 00       	mov    %eax,0x805044
  8029a0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029a5:	40                   	inc    %eax
  8029a6:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8029ab:	e9 da 00 00 00       	jmp    802a8a <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8029b0:	a1 40 50 80 00       	mov    0x805040,%eax
  8029b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b8:	e9 9d 00 00 00       	jmp    802a5a <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	8b 00                	mov    (%eax),%eax
  8029c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8029c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c8:	8b 50 08             	mov    0x8(%eax),%edx
  8029cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ce:	8b 40 08             	mov    0x8(%eax),%eax
  8029d1:	39 c2                	cmp    %eax,%edx
  8029d3:	76 7d                	jbe    802a52 <insert_sorted_allocList+0x222>
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	8b 50 08             	mov    0x8(%eax),%edx
  8029db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029de:	8b 40 08             	mov    0x8(%eax),%eax
  8029e1:	39 c2                	cmp    %eax,%edx
  8029e3:	73 6d                	jae    802a52 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8029e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e9:	74 06                	je     8029f1 <insert_sorted_allocList+0x1c1>
  8029eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ef:	75 14                	jne    802a05 <insert_sorted_allocList+0x1d5>
  8029f1:	83 ec 04             	sub    $0x4,%esp
  8029f4:	68 88 42 80 00       	push   $0x804288
  8029f9:	6a 7c                	push   $0x7c
  8029fb:	68 4b 42 80 00       	push   $0x80424b
  802a00:	e8 7b dd ff ff       	call   800780 <_panic>
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	8b 10                	mov    (%eax),%edx
  802a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0d:	89 10                	mov    %edx,(%eax)
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	8b 00                	mov    (%eax),%eax
  802a14:	85 c0                	test   %eax,%eax
  802a16:	74 0b                	je     802a23 <insert_sorted_allocList+0x1f3>
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a20:	89 50 04             	mov    %edx,0x4(%eax)
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 55 08             	mov    0x8(%ebp),%edx
  802a29:	89 10                	mov    %edx,(%eax)
  802a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a31:	89 50 04             	mov    %edx,0x4(%eax)
  802a34:	8b 45 08             	mov    0x8(%ebp),%eax
  802a37:	8b 00                	mov    (%eax),%eax
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	75 08                	jne    802a45 <insert_sorted_allocList+0x215>
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	a3 44 50 80 00       	mov    %eax,0x805044
  802a45:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a4a:	40                   	inc    %eax
  802a4b:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a50:	eb 38                	jmp    802a8a <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802a52:	a1 48 50 80 00       	mov    0x805048,%eax
  802a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5e:	74 07                	je     802a67 <insert_sorted_allocList+0x237>
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	8b 00                	mov    (%eax),%eax
  802a65:	eb 05                	jmp    802a6c <insert_sorted_allocList+0x23c>
  802a67:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6c:	a3 48 50 80 00       	mov    %eax,0x805048
  802a71:	a1 48 50 80 00       	mov    0x805048,%eax
  802a76:	85 c0                	test   %eax,%eax
  802a78:	0f 85 3f ff ff ff    	jne    8029bd <insert_sorted_allocList+0x18d>
  802a7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a82:	0f 85 35 ff ff ff    	jne    8029bd <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802a88:	eb 00                	jmp    802a8a <insert_sorted_allocList+0x25a>
  802a8a:	90                   	nop
  802a8b:	c9                   	leave  
  802a8c:	c3                   	ret    

00802a8d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a8d:	55                   	push   %ebp
  802a8e:	89 e5                	mov    %esp,%ebp
  802a90:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802a93:	a1 38 51 80 00       	mov    0x805138,%eax
  802a98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a9b:	e9 6b 02 00 00       	jmp    802d0b <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa9:	0f 85 90 00 00 00    	jne    802b3f <alloc_block_FF+0xb2>
			  temp=element;
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802ab5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab9:	75 17                	jne    802ad2 <alloc_block_FF+0x45>
  802abb:	83 ec 04             	sub    $0x4,%esp
  802abe:	68 bc 42 80 00       	push   $0x8042bc
  802ac3:	68 92 00 00 00       	push   $0x92
  802ac8:	68 4b 42 80 00       	push   $0x80424b
  802acd:	e8 ae dc ff ff       	call   800780 <_panic>
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	8b 00                	mov    (%eax),%eax
  802ad7:	85 c0                	test   %eax,%eax
  802ad9:	74 10                	je     802aeb <alloc_block_FF+0x5e>
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 00                	mov    (%eax),%eax
  802ae0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae3:	8b 52 04             	mov    0x4(%edx),%edx
  802ae6:	89 50 04             	mov    %edx,0x4(%eax)
  802ae9:	eb 0b                	jmp    802af6 <alloc_block_FF+0x69>
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	8b 40 04             	mov    0x4(%eax),%eax
  802af1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	8b 40 04             	mov    0x4(%eax),%eax
  802afc:	85 c0                	test   %eax,%eax
  802afe:	74 0f                	je     802b0f <alloc_block_FF+0x82>
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 40 04             	mov    0x4(%eax),%eax
  802b06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b09:	8b 12                	mov    (%edx),%edx
  802b0b:	89 10                	mov    %edx,(%eax)
  802b0d:	eb 0a                	jmp    802b19 <alloc_block_FF+0x8c>
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 00                	mov    (%eax),%eax
  802b14:	a3 38 51 80 00       	mov    %eax,0x805138
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2c:	a1 44 51 80 00       	mov    0x805144,%eax
  802b31:	48                   	dec    %eax
  802b32:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802b37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b3a:	e9 ff 01 00 00       	jmp    802d3e <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	8b 40 0c             	mov    0xc(%eax),%eax
  802b45:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b48:	0f 86 b5 01 00 00    	jbe    802d03 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	8b 40 0c             	mov    0xc(%eax),%eax
  802b54:	2b 45 08             	sub    0x8(%ebp),%eax
  802b57:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802b5a:	a1 48 51 80 00       	mov    0x805148,%eax
  802b5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802b62:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b66:	75 17                	jne    802b7f <alloc_block_FF+0xf2>
  802b68:	83 ec 04             	sub    $0x4,%esp
  802b6b:	68 bc 42 80 00       	push   $0x8042bc
  802b70:	68 99 00 00 00       	push   $0x99
  802b75:	68 4b 42 80 00       	push   $0x80424b
  802b7a:	e8 01 dc ff ff       	call   800780 <_panic>
  802b7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b82:	8b 00                	mov    (%eax),%eax
  802b84:	85 c0                	test   %eax,%eax
  802b86:	74 10                	je     802b98 <alloc_block_FF+0x10b>
  802b88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8b:	8b 00                	mov    (%eax),%eax
  802b8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b90:	8b 52 04             	mov    0x4(%edx),%edx
  802b93:	89 50 04             	mov    %edx,0x4(%eax)
  802b96:	eb 0b                	jmp    802ba3 <alloc_block_FF+0x116>
  802b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9b:	8b 40 04             	mov    0x4(%eax),%eax
  802b9e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ba3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba6:	8b 40 04             	mov    0x4(%eax),%eax
  802ba9:	85 c0                	test   %eax,%eax
  802bab:	74 0f                	je     802bbc <alloc_block_FF+0x12f>
  802bad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb0:	8b 40 04             	mov    0x4(%eax),%eax
  802bb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bb6:	8b 12                	mov    (%edx),%edx
  802bb8:	89 10                	mov    %edx,(%eax)
  802bba:	eb 0a                	jmp    802bc6 <alloc_block_FF+0x139>
  802bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	a3 48 51 80 00       	mov    %eax,0x805148
  802bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd9:	a1 54 51 80 00       	mov    0x805154,%eax
  802bde:	48                   	dec    %eax
  802bdf:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802be4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802be8:	75 17                	jne    802c01 <alloc_block_FF+0x174>
  802bea:	83 ec 04             	sub    $0x4,%esp
  802bed:	68 64 42 80 00       	push   $0x804264
  802bf2:	68 9a 00 00 00       	push   $0x9a
  802bf7:	68 4b 42 80 00       	push   $0x80424b
  802bfc:	e8 7f db ff ff       	call   800780 <_panic>
  802c01:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802c07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0a:	89 50 04             	mov    %edx,0x4(%eax)
  802c0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c10:	8b 40 04             	mov    0x4(%eax),%eax
  802c13:	85 c0                	test   %eax,%eax
  802c15:	74 0c                	je     802c23 <alloc_block_FF+0x196>
  802c17:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c1f:	89 10                	mov    %edx,(%eax)
  802c21:	eb 08                	jmp    802c2b <alloc_block_FF+0x19e>
  802c23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c26:	a3 38 51 80 00       	mov    %eax,0x805138
  802c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c3c:	a1 44 51 80 00       	mov    0x805144,%eax
  802c41:	40                   	inc    %eax
  802c42:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802c47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4d:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 50 08             	mov    0x8(%eax),%edx
  802c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c59:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c62:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 50 08             	mov    0x8(%eax),%edx
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	01 c2                	add    %eax,%edx
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802c76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c79:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802c7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c80:	75 17                	jne    802c99 <alloc_block_FF+0x20c>
  802c82:	83 ec 04             	sub    $0x4,%esp
  802c85:	68 bc 42 80 00       	push   $0x8042bc
  802c8a:	68 a2 00 00 00       	push   $0xa2
  802c8f:	68 4b 42 80 00       	push   $0x80424b
  802c94:	e8 e7 da ff ff       	call   800780 <_panic>
  802c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9c:	8b 00                	mov    (%eax),%eax
  802c9e:	85 c0                	test   %eax,%eax
  802ca0:	74 10                	je     802cb2 <alloc_block_FF+0x225>
  802ca2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca5:	8b 00                	mov    (%eax),%eax
  802ca7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802caa:	8b 52 04             	mov    0x4(%edx),%edx
  802cad:	89 50 04             	mov    %edx,0x4(%eax)
  802cb0:	eb 0b                	jmp    802cbd <alloc_block_FF+0x230>
  802cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb5:	8b 40 04             	mov    0x4(%eax),%eax
  802cb8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc0:	8b 40 04             	mov    0x4(%eax),%eax
  802cc3:	85 c0                	test   %eax,%eax
  802cc5:	74 0f                	je     802cd6 <alloc_block_FF+0x249>
  802cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cca:	8b 40 04             	mov    0x4(%eax),%eax
  802ccd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cd0:	8b 12                	mov    (%edx),%edx
  802cd2:	89 10                	mov    %edx,(%eax)
  802cd4:	eb 0a                	jmp    802ce0 <alloc_block_FF+0x253>
  802cd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd9:	8b 00                	mov    (%eax),%eax
  802cdb:	a3 38 51 80 00       	mov    %eax,0x805138
  802ce0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf3:	a1 44 51 80 00       	mov    0x805144,%eax
  802cf8:	48                   	dec    %eax
  802cf9:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802cfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d01:	eb 3b                	jmp    802d3e <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802d03:	a1 40 51 80 00       	mov    0x805140,%eax
  802d08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0f:	74 07                	je     802d18 <alloc_block_FF+0x28b>
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	8b 00                	mov    (%eax),%eax
  802d16:	eb 05                	jmp    802d1d <alloc_block_FF+0x290>
  802d18:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1d:	a3 40 51 80 00       	mov    %eax,0x805140
  802d22:	a1 40 51 80 00       	mov    0x805140,%eax
  802d27:	85 c0                	test   %eax,%eax
  802d29:	0f 85 71 fd ff ff    	jne    802aa0 <alloc_block_FF+0x13>
  802d2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d33:	0f 85 67 fd ff ff    	jne    802aa0 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d3e:	c9                   	leave  
  802d3f:	c3                   	ret    

00802d40 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802d40:	55                   	push   %ebp
  802d41:	89 e5                	mov    %esp,%ebp
  802d43:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802d46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802d4d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802d54:	a1 38 51 80 00       	mov    0x805138,%eax
  802d59:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802d5c:	e9 d3 00 00 00       	jmp    802e34 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802d61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d64:	8b 40 0c             	mov    0xc(%eax),%eax
  802d67:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d6a:	0f 85 90 00 00 00    	jne    802e00 <alloc_block_BF+0xc0>
	   temp = element;
  802d70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d73:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802d76:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d7a:	75 17                	jne    802d93 <alloc_block_BF+0x53>
  802d7c:	83 ec 04             	sub    $0x4,%esp
  802d7f:	68 bc 42 80 00       	push   $0x8042bc
  802d84:	68 bd 00 00 00       	push   $0xbd
  802d89:	68 4b 42 80 00       	push   $0x80424b
  802d8e:	e8 ed d9 ff ff       	call   800780 <_panic>
  802d93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d96:	8b 00                	mov    (%eax),%eax
  802d98:	85 c0                	test   %eax,%eax
  802d9a:	74 10                	je     802dac <alloc_block_BF+0x6c>
  802d9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9f:	8b 00                	mov    (%eax),%eax
  802da1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802da4:	8b 52 04             	mov    0x4(%edx),%edx
  802da7:	89 50 04             	mov    %edx,0x4(%eax)
  802daa:	eb 0b                	jmp    802db7 <alloc_block_BF+0x77>
  802dac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802daf:	8b 40 04             	mov    0x4(%eax),%eax
  802db2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802db7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dba:	8b 40 04             	mov    0x4(%eax),%eax
  802dbd:	85 c0                	test   %eax,%eax
  802dbf:	74 0f                	je     802dd0 <alloc_block_BF+0x90>
  802dc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc4:	8b 40 04             	mov    0x4(%eax),%eax
  802dc7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dca:	8b 12                	mov    (%edx),%edx
  802dcc:	89 10                	mov    %edx,(%eax)
  802dce:	eb 0a                	jmp    802dda <alloc_block_BF+0x9a>
  802dd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd3:	8b 00                	mov    (%eax),%eax
  802dd5:	a3 38 51 80 00       	mov    %eax,0x805138
  802dda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ddd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ded:	a1 44 51 80 00       	mov    0x805144,%eax
  802df2:	48                   	dec    %eax
  802df3:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802df8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dfb:	e9 41 01 00 00       	jmp    802f41 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802e00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e03:	8b 40 0c             	mov    0xc(%eax),%eax
  802e06:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e09:	76 21                	jbe    802e2c <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802e0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e11:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e14:	73 16                	jae    802e2c <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802e16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e19:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802e1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e22:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802e25:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802e2c:	a1 40 51 80 00       	mov    0x805140,%eax
  802e31:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802e34:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e38:	74 07                	je     802e41 <alloc_block_BF+0x101>
  802e3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3d:	8b 00                	mov    (%eax),%eax
  802e3f:	eb 05                	jmp    802e46 <alloc_block_BF+0x106>
  802e41:	b8 00 00 00 00       	mov    $0x0,%eax
  802e46:	a3 40 51 80 00       	mov    %eax,0x805140
  802e4b:	a1 40 51 80 00       	mov    0x805140,%eax
  802e50:	85 c0                	test   %eax,%eax
  802e52:	0f 85 09 ff ff ff    	jne    802d61 <alloc_block_BF+0x21>
  802e58:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e5c:	0f 85 ff fe ff ff    	jne    802d61 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802e62:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802e66:	0f 85 d0 00 00 00    	jne    802f3c <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e72:	2b 45 08             	sub    0x8(%ebp),%eax
  802e75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802e78:	a1 48 51 80 00       	mov    0x805148,%eax
  802e7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802e80:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e84:	75 17                	jne    802e9d <alloc_block_BF+0x15d>
  802e86:	83 ec 04             	sub    $0x4,%esp
  802e89:	68 bc 42 80 00       	push   $0x8042bc
  802e8e:	68 d1 00 00 00       	push   $0xd1
  802e93:	68 4b 42 80 00       	push   $0x80424b
  802e98:	e8 e3 d8 ff ff       	call   800780 <_panic>
  802e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	85 c0                	test   %eax,%eax
  802ea4:	74 10                	je     802eb6 <alloc_block_BF+0x176>
  802ea6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eae:	8b 52 04             	mov    0x4(%edx),%edx
  802eb1:	89 50 04             	mov    %edx,0x4(%eax)
  802eb4:	eb 0b                	jmp    802ec1 <alloc_block_BF+0x181>
  802eb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eb9:	8b 40 04             	mov    0x4(%eax),%eax
  802ebc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ec1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec4:	8b 40 04             	mov    0x4(%eax),%eax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	74 0f                	je     802eda <alloc_block_BF+0x19a>
  802ecb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ece:	8b 40 04             	mov    0x4(%eax),%eax
  802ed1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ed4:	8b 12                	mov    (%edx),%edx
  802ed6:	89 10                	mov    %edx,(%eax)
  802ed8:	eb 0a                	jmp    802ee4 <alloc_block_BF+0x1a4>
  802eda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802edd:	8b 00                	mov    (%eax),%eax
  802edf:	a3 48 51 80 00       	mov    %eax,0x805148
  802ee4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef7:	a1 54 51 80 00       	mov    0x805154,%eax
  802efc:	48                   	dec    %eax
  802efd:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  802f02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f05:	8b 55 08             	mov    0x8(%ebp),%edx
  802f08:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802f0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0e:	8b 50 08             	mov    0x8(%eax),%edx
  802f11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f14:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f1d:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802f20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f23:	8b 50 08             	mov    0x8(%eax),%edx
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	01 c2                	add    %eax,%edx
  802f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2e:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802f31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f34:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802f37:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f3a:	eb 05                	jmp    802f41 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802f3c:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802f41:	c9                   	leave  
  802f42:	c3                   	ret    

00802f43 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802f43:	55                   	push   %ebp
  802f44:	89 e5                	mov    %esp,%ebp
  802f46:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802f49:	83 ec 04             	sub    $0x4,%esp
  802f4c:	68 dc 42 80 00       	push   $0x8042dc
  802f51:	68 e8 00 00 00       	push   $0xe8
  802f56:	68 4b 42 80 00       	push   $0x80424b
  802f5b:	e8 20 d8 ff ff       	call   800780 <_panic>

00802f60 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f60:	55                   	push   %ebp
  802f61:	89 e5                	mov    %esp,%ebp
  802f63:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802f66:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802f6e:	a1 38 51 80 00       	mov    0x805138,%eax
  802f73:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802f76:	a1 44 51 80 00       	mov    0x805144,%eax
  802f7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802f7e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f82:	75 68                	jne    802fec <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802f84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f88:	75 17                	jne    802fa1 <insert_sorted_with_merge_freeList+0x41>
  802f8a:	83 ec 04             	sub    $0x4,%esp
  802f8d:	68 28 42 80 00       	push   $0x804228
  802f92:	68 36 01 00 00       	push   $0x136
  802f97:	68 4b 42 80 00       	push   $0x80424b
  802f9c:	e8 df d7 ff ff       	call   800780 <_panic>
  802fa1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	89 10                	mov    %edx,(%eax)
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	85 c0                	test   %eax,%eax
  802fb3:	74 0d                	je     802fc2 <insert_sorted_with_merge_freeList+0x62>
  802fb5:	a1 38 51 80 00       	mov    0x805138,%eax
  802fba:	8b 55 08             	mov    0x8(%ebp),%edx
  802fbd:	89 50 04             	mov    %edx,0x4(%eax)
  802fc0:	eb 08                	jmp    802fca <insert_sorted_with_merge_freeList+0x6a>
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fdc:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe1:	40                   	inc    %eax
  802fe2:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802fe7:	e9 ba 06 00 00       	jmp    8036a6 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fef:	8b 50 08             	mov    0x8(%eax),%edx
  802ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff8:	01 c2                	add    %eax,%edx
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	8b 40 08             	mov    0x8(%eax),%eax
  803000:	39 c2                	cmp    %eax,%edx
  803002:	73 68                	jae    80306c <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803004:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803008:	75 17                	jne    803021 <insert_sorted_with_merge_freeList+0xc1>
  80300a:	83 ec 04             	sub    $0x4,%esp
  80300d:	68 64 42 80 00       	push   $0x804264
  803012:	68 3a 01 00 00       	push   $0x13a
  803017:	68 4b 42 80 00       	push   $0x80424b
  80301c:	e8 5f d7 ff ff       	call   800780 <_panic>
  803021:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803027:	8b 45 08             	mov    0x8(%ebp),%eax
  80302a:	89 50 04             	mov    %edx,0x4(%eax)
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	8b 40 04             	mov    0x4(%eax),%eax
  803033:	85 c0                	test   %eax,%eax
  803035:	74 0c                	je     803043 <insert_sorted_with_merge_freeList+0xe3>
  803037:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80303c:	8b 55 08             	mov    0x8(%ebp),%edx
  80303f:	89 10                	mov    %edx,(%eax)
  803041:	eb 08                	jmp    80304b <insert_sorted_with_merge_freeList+0xeb>
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	a3 38 51 80 00       	mov    %eax,0x805138
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80305c:	a1 44 51 80 00       	mov    0x805144,%eax
  803061:	40                   	inc    %eax
  803062:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803067:	e9 3a 06 00 00       	jmp    8036a6 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  80306c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306f:	8b 50 08             	mov    0x8(%eax),%edx
  803072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803075:	8b 40 0c             	mov    0xc(%eax),%eax
  803078:	01 c2                	add    %eax,%edx
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	8b 40 08             	mov    0x8(%eax),%eax
  803080:	39 c2                	cmp    %eax,%edx
  803082:	0f 85 90 00 00 00    	jne    803118 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  803088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308b:	8b 50 0c             	mov    0xc(%eax),%edx
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	8b 40 0c             	mov    0xc(%eax),%eax
  803094:	01 c2                	add    %eax,%edx
  803096:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803099:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b4:	75 17                	jne    8030cd <insert_sorted_with_merge_freeList+0x16d>
  8030b6:	83 ec 04             	sub    $0x4,%esp
  8030b9:	68 28 42 80 00       	push   $0x804228
  8030be:	68 41 01 00 00       	push   $0x141
  8030c3:	68 4b 42 80 00       	push   $0x80424b
  8030c8:	e8 b3 d6 ff ff       	call   800780 <_panic>
  8030cd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	89 10                	mov    %edx,(%eax)
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	85 c0                	test   %eax,%eax
  8030df:	74 0d                	je     8030ee <insert_sorted_with_merge_freeList+0x18e>
  8030e1:	a1 48 51 80 00       	mov    0x805148,%eax
  8030e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e9:	89 50 04             	mov    %edx,0x4(%eax)
  8030ec:	eb 08                	jmp    8030f6 <insert_sorted_with_merge_freeList+0x196>
  8030ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f9:	a3 48 51 80 00       	mov    %eax,0x805148
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803108:	a1 54 51 80 00       	mov    0x805154,%eax
  80310d:	40                   	inc    %eax
  80310e:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803113:	e9 8e 05 00 00       	jmp    8036a6 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  803118:	8b 45 08             	mov    0x8(%ebp),%eax
  80311b:	8b 50 08             	mov    0x8(%eax),%edx
  80311e:	8b 45 08             	mov    0x8(%ebp),%eax
  803121:	8b 40 0c             	mov    0xc(%eax),%eax
  803124:	01 c2                	add    %eax,%edx
  803126:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803129:	8b 40 08             	mov    0x8(%eax),%eax
  80312c:	39 c2                	cmp    %eax,%edx
  80312e:	73 68                	jae    803198 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803130:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803134:	75 17                	jne    80314d <insert_sorted_with_merge_freeList+0x1ed>
  803136:	83 ec 04             	sub    $0x4,%esp
  803139:	68 28 42 80 00       	push   $0x804228
  80313e:	68 45 01 00 00       	push   $0x145
  803143:	68 4b 42 80 00       	push   $0x80424b
  803148:	e8 33 d6 ff ff       	call   800780 <_panic>
  80314d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	89 10                	mov    %edx,(%eax)
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	74 0d                	je     80316e <insert_sorted_with_merge_freeList+0x20e>
  803161:	a1 38 51 80 00       	mov    0x805138,%eax
  803166:	8b 55 08             	mov    0x8(%ebp),%edx
  803169:	89 50 04             	mov    %edx,0x4(%eax)
  80316c:	eb 08                	jmp    803176 <insert_sorted_with_merge_freeList+0x216>
  80316e:	8b 45 08             	mov    0x8(%ebp),%eax
  803171:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	a3 38 51 80 00       	mov    %eax,0x805138
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803188:	a1 44 51 80 00       	mov    0x805144,%eax
  80318d:	40                   	inc    %eax
  80318e:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803193:	e9 0e 05 00 00       	jmp    8036a6 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	8b 50 08             	mov    0x8(%eax),%edx
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a4:	01 c2                	add    %eax,%edx
  8031a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a9:	8b 40 08             	mov    0x8(%eax),%eax
  8031ac:	39 c2                	cmp    %eax,%edx
  8031ae:	0f 85 9c 00 00 00    	jne    803250 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  8031b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b7:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c0:	01 c2                	add    %eax,%edx
  8031c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c5:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	8b 50 08             	mov    0x8(%eax),%edx
  8031ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d1:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ec:	75 17                	jne    803205 <insert_sorted_with_merge_freeList+0x2a5>
  8031ee:	83 ec 04             	sub    $0x4,%esp
  8031f1:	68 28 42 80 00       	push   $0x804228
  8031f6:	68 4d 01 00 00       	push   $0x14d
  8031fb:	68 4b 42 80 00       	push   $0x80424b
  803200:	e8 7b d5 ff ff       	call   800780 <_panic>
  803205:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	89 10                	mov    %edx,(%eax)
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	74 0d                	je     803226 <insert_sorted_with_merge_freeList+0x2c6>
  803219:	a1 48 51 80 00       	mov    0x805148,%eax
  80321e:	8b 55 08             	mov    0x8(%ebp),%edx
  803221:	89 50 04             	mov    %edx,0x4(%eax)
  803224:	eb 08                	jmp    80322e <insert_sorted_with_merge_freeList+0x2ce>
  803226:	8b 45 08             	mov    0x8(%ebp),%eax
  803229:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80322e:	8b 45 08             	mov    0x8(%ebp),%eax
  803231:	a3 48 51 80 00       	mov    %eax,0x805148
  803236:	8b 45 08             	mov    0x8(%ebp),%eax
  803239:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803240:	a1 54 51 80 00       	mov    0x805154,%eax
  803245:	40                   	inc    %eax
  803246:	a3 54 51 80 00       	mov    %eax,0x805154





}
  80324b:	e9 56 04 00 00       	jmp    8036a6 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803250:	a1 38 51 80 00       	mov    0x805138,%eax
  803255:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803258:	e9 19 04 00 00       	jmp    803676 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  80325d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803260:	8b 00                	mov    (%eax),%eax
  803262:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803268:	8b 50 08             	mov    0x8(%eax),%edx
  80326b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326e:	8b 40 0c             	mov    0xc(%eax),%eax
  803271:	01 c2                	add    %eax,%edx
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	8b 40 08             	mov    0x8(%eax),%eax
  803279:	39 c2                	cmp    %eax,%edx
  80327b:	0f 85 ad 01 00 00    	jne    80342e <insert_sorted_with_merge_freeList+0x4ce>
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	8b 50 08             	mov    0x8(%eax),%edx
  803287:	8b 45 08             	mov    0x8(%ebp),%eax
  80328a:	8b 40 0c             	mov    0xc(%eax),%eax
  80328d:	01 c2                	add    %eax,%edx
  80328f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803292:	8b 40 08             	mov    0x8(%eax),%eax
  803295:	39 c2                	cmp    %eax,%edx
  803297:	0f 85 91 01 00 00    	jne    80342e <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  80329d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a0:	8b 50 0c             	mov    0xc(%eax),%edx
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	8b 48 0c             	mov    0xc(%eax),%ecx
  8032a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8032af:	01 c8                	add    %ecx,%eax
  8032b1:	01 c2                	add    %eax,%edx
  8032b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b6:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  8032b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  8032cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  8032d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  8032e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032e5:	75 17                	jne    8032fe <insert_sorted_with_merge_freeList+0x39e>
  8032e7:	83 ec 04             	sub    $0x4,%esp
  8032ea:	68 bc 42 80 00       	push   $0x8042bc
  8032ef:	68 5b 01 00 00       	push   $0x15b
  8032f4:	68 4b 42 80 00       	push   $0x80424b
  8032f9:	e8 82 d4 ff ff       	call   800780 <_panic>
  8032fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803301:	8b 00                	mov    (%eax),%eax
  803303:	85 c0                	test   %eax,%eax
  803305:	74 10                	je     803317 <insert_sorted_with_merge_freeList+0x3b7>
  803307:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80330a:	8b 00                	mov    (%eax),%eax
  80330c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80330f:	8b 52 04             	mov    0x4(%edx),%edx
  803312:	89 50 04             	mov    %edx,0x4(%eax)
  803315:	eb 0b                	jmp    803322 <insert_sorted_with_merge_freeList+0x3c2>
  803317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331a:	8b 40 04             	mov    0x4(%eax),%eax
  80331d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803322:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803325:	8b 40 04             	mov    0x4(%eax),%eax
  803328:	85 c0                	test   %eax,%eax
  80332a:	74 0f                	je     80333b <insert_sorted_with_merge_freeList+0x3db>
  80332c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332f:	8b 40 04             	mov    0x4(%eax),%eax
  803332:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803335:	8b 12                	mov    (%edx),%edx
  803337:	89 10                	mov    %edx,(%eax)
  803339:	eb 0a                	jmp    803345 <insert_sorted_with_merge_freeList+0x3e5>
  80333b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80333e:	8b 00                	mov    (%eax),%eax
  803340:	a3 38 51 80 00       	mov    %eax,0x805138
  803345:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803348:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80334e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803351:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803358:	a1 44 51 80 00       	mov    0x805144,%eax
  80335d:	48                   	dec    %eax
  80335e:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803363:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803367:	75 17                	jne    803380 <insert_sorted_with_merge_freeList+0x420>
  803369:	83 ec 04             	sub    $0x4,%esp
  80336c:	68 28 42 80 00       	push   $0x804228
  803371:	68 5c 01 00 00       	push   $0x15c
  803376:	68 4b 42 80 00       	push   $0x80424b
  80337b:	e8 00 d4 ff ff       	call   800780 <_panic>
  803380:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	89 10                	mov    %edx,(%eax)
  80338b:	8b 45 08             	mov    0x8(%ebp),%eax
  80338e:	8b 00                	mov    (%eax),%eax
  803390:	85 c0                	test   %eax,%eax
  803392:	74 0d                	je     8033a1 <insert_sorted_with_merge_freeList+0x441>
  803394:	a1 48 51 80 00       	mov    0x805148,%eax
  803399:	8b 55 08             	mov    0x8(%ebp),%edx
  80339c:	89 50 04             	mov    %edx,0x4(%eax)
  80339f:	eb 08                	jmp    8033a9 <insert_sorted_with_merge_freeList+0x449>
  8033a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	a3 48 51 80 00       	mov    %eax,0x805148
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033bb:	a1 54 51 80 00       	mov    0x805154,%eax
  8033c0:	40                   	inc    %eax
  8033c1:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  8033c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033ca:	75 17                	jne    8033e3 <insert_sorted_with_merge_freeList+0x483>
  8033cc:	83 ec 04             	sub    $0x4,%esp
  8033cf:	68 28 42 80 00       	push   $0x804228
  8033d4:	68 5d 01 00 00       	push   $0x15d
  8033d9:	68 4b 42 80 00       	push   $0x80424b
  8033de:	e8 9d d3 ff ff       	call   800780 <_panic>
  8033e3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ec:	89 10                	mov    %edx,(%eax)
  8033ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f1:	8b 00                	mov    (%eax),%eax
  8033f3:	85 c0                	test   %eax,%eax
  8033f5:	74 0d                	je     803404 <insert_sorted_with_merge_freeList+0x4a4>
  8033f7:	a1 48 51 80 00       	mov    0x805148,%eax
  8033fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033ff:	89 50 04             	mov    %edx,0x4(%eax)
  803402:	eb 08                	jmp    80340c <insert_sorted_with_merge_freeList+0x4ac>
  803404:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803407:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80340c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340f:	a3 48 51 80 00       	mov    %eax,0x805148
  803414:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803417:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80341e:	a1 54 51 80 00       	mov    0x805154,%eax
  803423:	40                   	inc    %eax
  803424:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803429:	e9 78 02 00 00       	jmp    8036a6 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	8b 50 08             	mov    0x8(%eax),%edx
  803434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803437:	8b 40 0c             	mov    0xc(%eax),%eax
  80343a:	01 c2                	add    %eax,%edx
  80343c:	8b 45 08             	mov    0x8(%ebp),%eax
  80343f:	8b 40 08             	mov    0x8(%eax),%eax
  803442:	39 c2                	cmp    %eax,%edx
  803444:	0f 83 b8 00 00 00    	jae    803502 <insert_sorted_with_merge_freeList+0x5a2>
  80344a:	8b 45 08             	mov    0x8(%ebp),%eax
  80344d:	8b 50 08             	mov    0x8(%eax),%edx
  803450:	8b 45 08             	mov    0x8(%ebp),%eax
  803453:	8b 40 0c             	mov    0xc(%eax),%eax
  803456:	01 c2                	add    %eax,%edx
  803458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345b:	8b 40 08             	mov    0x8(%eax),%eax
  80345e:	39 c2                	cmp    %eax,%edx
  803460:	0f 85 9c 00 00 00    	jne    803502 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  803466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803469:	8b 50 0c             	mov    0xc(%eax),%edx
  80346c:	8b 45 08             	mov    0x8(%ebp),%eax
  80346f:	8b 40 0c             	mov    0xc(%eax),%eax
  803472:	01 c2                	add    %eax,%edx
  803474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803477:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  80347a:	8b 45 08             	mov    0x8(%ebp),%eax
  80347d:	8b 50 08             	mov    0x8(%eax),%edx
  803480:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803483:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803490:	8b 45 08             	mov    0x8(%ebp),%eax
  803493:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80349a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80349e:	75 17                	jne    8034b7 <insert_sorted_with_merge_freeList+0x557>
  8034a0:	83 ec 04             	sub    $0x4,%esp
  8034a3:	68 28 42 80 00       	push   $0x804228
  8034a8:	68 67 01 00 00       	push   $0x167
  8034ad:	68 4b 42 80 00       	push   $0x80424b
  8034b2:	e8 c9 d2 ff ff       	call   800780 <_panic>
  8034b7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c0:	89 10                	mov    %edx,(%eax)
  8034c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c5:	8b 00                	mov    (%eax),%eax
  8034c7:	85 c0                	test   %eax,%eax
  8034c9:	74 0d                	je     8034d8 <insert_sorted_with_merge_freeList+0x578>
  8034cb:	a1 48 51 80 00       	mov    0x805148,%eax
  8034d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d3:	89 50 04             	mov    %edx,0x4(%eax)
  8034d6:	eb 08                	jmp    8034e0 <insert_sorted_with_merge_freeList+0x580>
  8034d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034db:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8034e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f2:	a1 54 51 80 00       	mov    0x805154,%eax
  8034f7:	40                   	inc    %eax
  8034f8:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  8034fd:	e9 a4 01 00 00       	jmp    8036a6 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803505:	8b 50 08             	mov    0x8(%eax),%edx
  803508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350b:	8b 40 0c             	mov    0xc(%eax),%eax
  80350e:	01 c2                	add    %eax,%edx
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	8b 40 08             	mov    0x8(%eax),%eax
  803516:	39 c2                	cmp    %eax,%edx
  803518:	0f 85 ac 00 00 00    	jne    8035ca <insert_sorted_with_merge_freeList+0x66a>
  80351e:	8b 45 08             	mov    0x8(%ebp),%eax
  803521:	8b 50 08             	mov    0x8(%eax),%edx
  803524:	8b 45 08             	mov    0x8(%ebp),%eax
  803527:	8b 40 0c             	mov    0xc(%eax),%eax
  80352a:	01 c2                	add    %eax,%edx
  80352c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80352f:	8b 40 08             	mov    0x8(%eax),%eax
  803532:	39 c2                	cmp    %eax,%edx
  803534:	0f 83 90 00 00 00    	jae    8035ca <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  80353a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353d:	8b 50 0c             	mov    0xc(%eax),%edx
  803540:	8b 45 08             	mov    0x8(%ebp),%eax
  803543:	8b 40 0c             	mov    0xc(%eax),%eax
  803546:	01 c2                	add    %eax,%edx
  803548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354b:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  80354e:	8b 45 08             	mov    0x8(%ebp),%eax
  803551:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  803558:	8b 45 08             	mov    0x8(%ebp),%eax
  80355b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803562:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803566:	75 17                	jne    80357f <insert_sorted_with_merge_freeList+0x61f>
  803568:	83 ec 04             	sub    $0x4,%esp
  80356b:	68 28 42 80 00       	push   $0x804228
  803570:	68 70 01 00 00       	push   $0x170
  803575:	68 4b 42 80 00       	push   $0x80424b
  80357a:	e8 01 d2 ff ff       	call   800780 <_panic>
  80357f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803585:	8b 45 08             	mov    0x8(%ebp),%eax
  803588:	89 10                	mov    %edx,(%eax)
  80358a:	8b 45 08             	mov    0x8(%ebp),%eax
  80358d:	8b 00                	mov    (%eax),%eax
  80358f:	85 c0                	test   %eax,%eax
  803591:	74 0d                	je     8035a0 <insert_sorted_with_merge_freeList+0x640>
  803593:	a1 48 51 80 00       	mov    0x805148,%eax
  803598:	8b 55 08             	mov    0x8(%ebp),%edx
  80359b:	89 50 04             	mov    %edx,0x4(%eax)
  80359e:	eb 08                	jmp    8035a8 <insert_sorted_with_merge_freeList+0x648>
  8035a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ab:	a3 48 51 80 00       	mov    %eax,0x805148
  8035b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8035bf:	40                   	inc    %eax
  8035c0:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  8035c5:	e9 dc 00 00 00       	jmp    8036a6 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8035ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cd:	8b 50 08             	mov    0x8(%eax),%edx
  8035d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d6:	01 c2                	add    %eax,%edx
  8035d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035db:	8b 40 08             	mov    0x8(%eax),%eax
  8035de:	39 c2                	cmp    %eax,%edx
  8035e0:	0f 83 88 00 00 00    	jae    80366e <insert_sorted_with_merge_freeList+0x70e>
  8035e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e9:	8b 50 08             	mov    0x8(%eax),%edx
  8035ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f2:	01 c2                	add    %eax,%edx
  8035f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f7:	8b 40 08             	mov    0x8(%eax),%eax
  8035fa:	39 c2                	cmp    %eax,%edx
  8035fc:	73 70                	jae    80366e <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  8035fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803602:	74 06                	je     80360a <insert_sorted_with_merge_freeList+0x6aa>
  803604:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803608:	75 17                	jne    803621 <insert_sorted_with_merge_freeList+0x6c1>
  80360a:	83 ec 04             	sub    $0x4,%esp
  80360d:	68 88 42 80 00       	push   $0x804288
  803612:	68 75 01 00 00       	push   $0x175
  803617:	68 4b 42 80 00       	push   $0x80424b
  80361c:	e8 5f d1 ff ff       	call   800780 <_panic>
  803621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803624:	8b 10                	mov    (%eax),%edx
  803626:	8b 45 08             	mov    0x8(%ebp),%eax
  803629:	89 10                	mov    %edx,(%eax)
  80362b:	8b 45 08             	mov    0x8(%ebp),%eax
  80362e:	8b 00                	mov    (%eax),%eax
  803630:	85 c0                	test   %eax,%eax
  803632:	74 0b                	je     80363f <insert_sorted_with_merge_freeList+0x6df>
  803634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803637:	8b 00                	mov    (%eax),%eax
  803639:	8b 55 08             	mov    0x8(%ebp),%edx
  80363c:	89 50 04             	mov    %edx,0x4(%eax)
  80363f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803642:	8b 55 08             	mov    0x8(%ebp),%edx
  803645:	89 10                	mov    %edx,(%eax)
  803647:	8b 45 08             	mov    0x8(%ebp),%eax
  80364a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80364d:	89 50 04             	mov    %edx,0x4(%eax)
  803650:	8b 45 08             	mov    0x8(%ebp),%eax
  803653:	8b 00                	mov    (%eax),%eax
  803655:	85 c0                	test   %eax,%eax
  803657:	75 08                	jne    803661 <insert_sorted_with_merge_freeList+0x701>
  803659:	8b 45 08             	mov    0x8(%ebp),%eax
  80365c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803661:	a1 44 51 80 00       	mov    0x805144,%eax
  803666:	40                   	inc    %eax
  803667:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  80366c:	eb 38                	jmp    8036a6 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  80366e:	a1 40 51 80 00       	mov    0x805140,%eax
  803673:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803676:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80367a:	74 07                	je     803683 <insert_sorted_with_merge_freeList+0x723>
  80367c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367f:	8b 00                	mov    (%eax),%eax
  803681:	eb 05                	jmp    803688 <insert_sorted_with_merge_freeList+0x728>
  803683:	b8 00 00 00 00       	mov    $0x0,%eax
  803688:	a3 40 51 80 00       	mov    %eax,0x805140
  80368d:	a1 40 51 80 00       	mov    0x805140,%eax
  803692:	85 c0                	test   %eax,%eax
  803694:	0f 85 c3 fb ff ff    	jne    80325d <insert_sorted_with_merge_freeList+0x2fd>
  80369a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80369e:	0f 85 b9 fb ff ff    	jne    80325d <insert_sorted_with_merge_freeList+0x2fd>





}
  8036a4:	eb 00                	jmp    8036a6 <insert_sorted_with_merge_freeList+0x746>
  8036a6:	90                   	nop
  8036a7:	c9                   	leave  
  8036a8:	c3                   	ret    
  8036a9:	66 90                	xchg   %ax,%ax
  8036ab:	90                   	nop

008036ac <__udivdi3>:
  8036ac:	55                   	push   %ebp
  8036ad:	57                   	push   %edi
  8036ae:	56                   	push   %esi
  8036af:	53                   	push   %ebx
  8036b0:	83 ec 1c             	sub    $0x1c,%esp
  8036b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036c3:	89 ca                	mov    %ecx,%edx
  8036c5:	89 f8                	mov    %edi,%eax
  8036c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036cb:	85 f6                	test   %esi,%esi
  8036cd:	75 2d                	jne    8036fc <__udivdi3+0x50>
  8036cf:	39 cf                	cmp    %ecx,%edi
  8036d1:	77 65                	ja     803738 <__udivdi3+0x8c>
  8036d3:	89 fd                	mov    %edi,%ebp
  8036d5:	85 ff                	test   %edi,%edi
  8036d7:	75 0b                	jne    8036e4 <__udivdi3+0x38>
  8036d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8036de:	31 d2                	xor    %edx,%edx
  8036e0:	f7 f7                	div    %edi
  8036e2:	89 c5                	mov    %eax,%ebp
  8036e4:	31 d2                	xor    %edx,%edx
  8036e6:	89 c8                	mov    %ecx,%eax
  8036e8:	f7 f5                	div    %ebp
  8036ea:	89 c1                	mov    %eax,%ecx
  8036ec:	89 d8                	mov    %ebx,%eax
  8036ee:	f7 f5                	div    %ebp
  8036f0:	89 cf                	mov    %ecx,%edi
  8036f2:	89 fa                	mov    %edi,%edx
  8036f4:	83 c4 1c             	add    $0x1c,%esp
  8036f7:	5b                   	pop    %ebx
  8036f8:	5e                   	pop    %esi
  8036f9:	5f                   	pop    %edi
  8036fa:	5d                   	pop    %ebp
  8036fb:	c3                   	ret    
  8036fc:	39 ce                	cmp    %ecx,%esi
  8036fe:	77 28                	ja     803728 <__udivdi3+0x7c>
  803700:	0f bd fe             	bsr    %esi,%edi
  803703:	83 f7 1f             	xor    $0x1f,%edi
  803706:	75 40                	jne    803748 <__udivdi3+0x9c>
  803708:	39 ce                	cmp    %ecx,%esi
  80370a:	72 0a                	jb     803716 <__udivdi3+0x6a>
  80370c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803710:	0f 87 9e 00 00 00    	ja     8037b4 <__udivdi3+0x108>
  803716:	b8 01 00 00 00       	mov    $0x1,%eax
  80371b:	89 fa                	mov    %edi,%edx
  80371d:	83 c4 1c             	add    $0x1c,%esp
  803720:	5b                   	pop    %ebx
  803721:	5e                   	pop    %esi
  803722:	5f                   	pop    %edi
  803723:	5d                   	pop    %ebp
  803724:	c3                   	ret    
  803725:	8d 76 00             	lea    0x0(%esi),%esi
  803728:	31 ff                	xor    %edi,%edi
  80372a:	31 c0                	xor    %eax,%eax
  80372c:	89 fa                	mov    %edi,%edx
  80372e:	83 c4 1c             	add    $0x1c,%esp
  803731:	5b                   	pop    %ebx
  803732:	5e                   	pop    %esi
  803733:	5f                   	pop    %edi
  803734:	5d                   	pop    %ebp
  803735:	c3                   	ret    
  803736:	66 90                	xchg   %ax,%ax
  803738:	89 d8                	mov    %ebx,%eax
  80373a:	f7 f7                	div    %edi
  80373c:	31 ff                	xor    %edi,%edi
  80373e:	89 fa                	mov    %edi,%edx
  803740:	83 c4 1c             	add    $0x1c,%esp
  803743:	5b                   	pop    %ebx
  803744:	5e                   	pop    %esi
  803745:	5f                   	pop    %edi
  803746:	5d                   	pop    %ebp
  803747:	c3                   	ret    
  803748:	bd 20 00 00 00       	mov    $0x20,%ebp
  80374d:	89 eb                	mov    %ebp,%ebx
  80374f:	29 fb                	sub    %edi,%ebx
  803751:	89 f9                	mov    %edi,%ecx
  803753:	d3 e6                	shl    %cl,%esi
  803755:	89 c5                	mov    %eax,%ebp
  803757:	88 d9                	mov    %bl,%cl
  803759:	d3 ed                	shr    %cl,%ebp
  80375b:	89 e9                	mov    %ebp,%ecx
  80375d:	09 f1                	or     %esi,%ecx
  80375f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803763:	89 f9                	mov    %edi,%ecx
  803765:	d3 e0                	shl    %cl,%eax
  803767:	89 c5                	mov    %eax,%ebp
  803769:	89 d6                	mov    %edx,%esi
  80376b:	88 d9                	mov    %bl,%cl
  80376d:	d3 ee                	shr    %cl,%esi
  80376f:	89 f9                	mov    %edi,%ecx
  803771:	d3 e2                	shl    %cl,%edx
  803773:	8b 44 24 08          	mov    0x8(%esp),%eax
  803777:	88 d9                	mov    %bl,%cl
  803779:	d3 e8                	shr    %cl,%eax
  80377b:	09 c2                	or     %eax,%edx
  80377d:	89 d0                	mov    %edx,%eax
  80377f:	89 f2                	mov    %esi,%edx
  803781:	f7 74 24 0c          	divl   0xc(%esp)
  803785:	89 d6                	mov    %edx,%esi
  803787:	89 c3                	mov    %eax,%ebx
  803789:	f7 e5                	mul    %ebp
  80378b:	39 d6                	cmp    %edx,%esi
  80378d:	72 19                	jb     8037a8 <__udivdi3+0xfc>
  80378f:	74 0b                	je     80379c <__udivdi3+0xf0>
  803791:	89 d8                	mov    %ebx,%eax
  803793:	31 ff                	xor    %edi,%edi
  803795:	e9 58 ff ff ff       	jmp    8036f2 <__udivdi3+0x46>
  80379a:	66 90                	xchg   %ax,%ax
  80379c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037a0:	89 f9                	mov    %edi,%ecx
  8037a2:	d3 e2                	shl    %cl,%edx
  8037a4:	39 c2                	cmp    %eax,%edx
  8037a6:	73 e9                	jae    803791 <__udivdi3+0xe5>
  8037a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037ab:	31 ff                	xor    %edi,%edi
  8037ad:	e9 40 ff ff ff       	jmp    8036f2 <__udivdi3+0x46>
  8037b2:	66 90                	xchg   %ax,%ax
  8037b4:	31 c0                	xor    %eax,%eax
  8037b6:	e9 37 ff ff ff       	jmp    8036f2 <__udivdi3+0x46>
  8037bb:	90                   	nop

008037bc <__umoddi3>:
  8037bc:	55                   	push   %ebp
  8037bd:	57                   	push   %edi
  8037be:	56                   	push   %esi
  8037bf:	53                   	push   %ebx
  8037c0:	83 ec 1c             	sub    $0x1c,%esp
  8037c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037db:	89 f3                	mov    %esi,%ebx
  8037dd:	89 fa                	mov    %edi,%edx
  8037df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037e3:	89 34 24             	mov    %esi,(%esp)
  8037e6:	85 c0                	test   %eax,%eax
  8037e8:	75 1a                	jne    803804 <__umoddi3+0x48>
  8037ea:	39 f7                	cmp    %esi,%edi
  8037ec:	0f 86 a2 00 00 00    	jbe    803894 <__umoddi3+0xd8>
  8037f2:	89 c8                	mov    %ecx,%eax
  8037f4:	89 f2                	mov    %esi,%edx
  8037f6:	f7 f7                	div    %edi
  8037f8:	89 d0                	mov    %edx,%eax
  8037fa:	31 d2                	xor    %edx,%edx
  8037fc:	83 c4 1c             	add    $0x1c,%esp
  8037ff:	5b                   	pop    %ebx
  803800:	5e                   	pop    %esi
  803801:	5f                   	pop    %edi
  803802:	5d                   	pop    %ebp
  803803:	c3                   	ret    
  803804:	39 f0                	cmp    %esi,%eax
  803806:	0f 87 ac 00 00 00    	ja     8038b8 <__umoddi3+0xfc>
  80380c:	0f bd e8             	bsr    %eax,%ebp
  80380f:	83 f5 1f             	xor    $0x1f,%ebp
  803812:	0f 84 ac 00 00 00    	je     8038c4 <__umoddi3+0x108>
  803818:	bf 20 00 00 00       	mov    $0x20,%edi
  80381d:	29 ef                	sub    %ebp,%edi
  80381f:	89 fe                	mov    %edi,%esi
  803821:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803825:	89 e9                	mov    %ebp,%ecx
  803827:	d3 e0                	shl    %cl,%eax
  803829:	89 d7                	mov    %edx,%edi
  80382b:	89 f1                	mov    %esi,%ecx
  80382d:	d3 ef                	shr    %cl,%edi
  80382f:	09 c7                	or     %eax,%edi
  803831:	89 e9                	mov    %ebp,%ecx
  803833:	d3 e2                	shl    %cl,%edx
  803835:	89 14 24             	mov    %edx,(%esp)
  803838:	89 d8                	mov    %ebx,%eax
  80383a:	d3 e0                	shl    %cl,%eax
  80383c:	89 c2                	mov    %eax,%edx
  80383e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803842:	d3 e0                	shl    %cl,%eax
  803844:	89 44 24 04          	mov    %eax,0x4(%esp)
  803848:	8b 44 24 08          	mov    0x8(%esp),%eax
  80384c:	89 f1                	mov    %esi,%ecx
  80384e:	d3 e8                	shr    %cl,%eax
  803850:	09 d0                	or     %edx,%eax
  803852:	d3 eb                	shr    %cl,%ebx
  803854:	89 da                	mov    %ebx,%edx
  803856:	f7 f7                	div    %edi
  803858:	89 d3                	mov    %edx,%ebx
  80385a:	f7 24 24             	mull   (%esp)
  80385d:	89 c6                	mov    %eax,%esi
  80385f:	89 d1                	mov    %edx,%ecx
  803861:	39 d3                	cmp    %edx,%ebx
  803863:	0f 82 87 00 00 00    	jb     8038f0 <__umoddi3+0x134>
  803869:	0f 84 91 00 00 00    	je     803900 <__umoddi3+0x144>
  80386f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803873:	29 f2                	sub    %esi,%edx
  803875:	19 cb                	sbb    %ecx,%ebx
  803877:	89 d8                	mov    %ebx,%eax
  803879:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80387d:	d3 e0                	shl    %cl,%eax
  80387f:	89 e9                	mov    %ebp,%ecx
  803881:	d3 ea                	shr    %cl,%edx
  803883:	09 d0                	or     %edx,%eax
  803885:	89 e9                	mov    %ebp,%ecx
  803887:	d3 eb                	shr    %cl,%ebx
  803889:	89 da                	mov    %ebx,%edx
  80388b:	83 c4 1c             	add    $0x1c,%esp
  80388e:	5b                   	pop    %ebx
  80388f:	5e                   	pop    %esi
  803890:	5f                   	pop    %edi
  803891:	5d                   	pop    %ebp
  803892:	c3                   	ret    
  803893:	90                   	nop
  803894:	89 fd                	mov    %edi,%ebp
  803896:	85 ff                	test   %edi,%edi
  803898:	75 0b                	jne    8038a5 <__umoddi3+0xe9>
  80389a:	b8 01 00 00 00       	mov    $0x1,%eax
  80389f:	31 d2                	xor    %edx,%edx
  8038a1:	f7 f7                	div    %edi
  8038a3:	89 c5                	mov    %eax,%ebp
  8038a5:	89 f0                	mov    %esi,%eax
  8038a7:	31 d2                	xor    %edx,%edx
  8038a9:	f7 f5                	div    %ebp
  8038ab:	89 c8                	mov    %ecx,%eax
  8038ad:	f7 f5                	div    %ebp
  8038af:	89 d0                	mov    %edx,%eax
  8038b1:	e9 44 ff ff ff       	jmp    8037fa <__umoddi3+0x3e>
  8038b6:	66 90                	xchg   %ax,%ax
  8038b8:	89 c8                	mov    %ecx,%eax
  8038ba:	89 f2                	mov    %esi,%edx
  8038bc:	83 c4 1c             	add    $0x1c,%esp
  8038bf:	5b                   	pop    %ebx
  8038c0:	5e                   	pop    %esi
  8038c1:	5f                   	pop    %edi
  8038c2:	5d                   	pop    %ebp
  8038c3:	c3                   	ret    
  8038c4:	3b 04 24             	cmp    (%esp),%eax
  8038c7:	72 06                	jb     8038cf <__umoddi3+0x113>
  8038c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038cd:	77 0f                	ja     8038de <__umoddi3+0x122>
  8038cf:	89 f2                	mov    %esi,%edx
  8038d1:	29 f9                	sub    %edi,%ecx
  8038d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038d7:	89 14 24             	mov    %edx,(%esp)
  8038da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038e2:	8b 14 24             	mov    (%esp),%edx
  8038e5:	83 c4 1c             	add    $0x1c,%esp
  8038e8:	5b                   	pop    %ebx
  8038e9:	5e                   	pop    %esi
  8038ea:	5f                   	pop    %edi
  8038eb:	5d                   	pop    %ebp
  8038ec:	c3                   	ret    
  8038ed:	8d 76 00             	lea    0x0(%esi),%esi
  8038f0:	2b 04 24             	sub    (%esp),%eax
  8038f3:	19 fa                	sbb    %edi,%edx
  8038f5:	89 d1                	mov    %edx,%ecx
  8038f7:	89 c6                	mov    %eax,%esi
  8038f9:	e9 71 ff ff ff       	jmp    80386f <__umoddi3+0xb3>
  8038fe:	66 90                	xchg   %ax,%ax
  803900:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803904:	72 ea                	jb     8038f0 <__umoddi3+0x134>
  803906:	89 d9                	mov    %ebx,%ecx
  803908:	e9 62 ff ff ff       	jmp    80386f <__umoddi3+0xb3>
