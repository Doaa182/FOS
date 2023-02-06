
obj/user/quicksort_heap:     file format elf32-i386


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
  800031:	e8 1f 06 00 00       	call   800655 <libmain>
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
  800041:	e8 aa 20 00 00       	call   8020f0 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 39 80 00       	push   $0x803920
  80004e:	e8 f2 09 00 00       	call   800a45 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 39 80 00       	push   $0x803922
  80005e:	e8 e2 09 00 00       	call   800a45 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 3b 39 80 00       	push   $0x80393b
  80006e:	e8 d2 09 00 00       	call   800a45 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 39 80 00       	push   $0x803922
  80007e:	e8 c2 09 00 00       	call   800a45 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 39 80 00       	push   $0x803920
  80008e:	e8 b2 09 00 00       	call   800a45 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 54 39 80 00       	push   $0x803954
  8000a5:	e8 1d 10 00 00       	call   8010c7 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 6d 15 00 00       	call   80162d <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 ef 1a 00 00       	call   801bc4 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 74 39 80 00       	push   $0x803974
  8000e3:	e8 5d 09 00 00       	call   800a45 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 96 39 80 00       	push   $0x803996
  8000f3:	e8 4d 09 00 00       	call   800a45 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 a4 39 80 00       	push   $0x8039a4
  800103:	e8 3d 09 00 00       	call   800a45 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 b3 39 80 00       	push   $0x8039b3
  800113:	e8 2d 09 00 00       	call   800a45 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 c3 39 80 00       	push   $0x8039c3
  800123:	e8 1d 09 00 00       	call   800a45 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 cd 04 00 00       	call   8005fd <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 75 04 00 00       	call   8005b5 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 68 04 00 00       	call   8005b5 <cputchar>
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
  800162:	e8 a3 1f 00 00       	call   80210a <sys_enable_interrupt>

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
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 16 1f 00 00       	call   8020f0 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 cc 39 80 00       	push   $0x8039cc
  8001e2:	e8 5e 08 00 00       	call   800a45 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 1b 1f 00 00       	call   80210a <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 00 3a 80 00       	push   $0x803a00
  800211:	6a 48                	push   $0x48
  800213:	68 22 3a 80 00       	push   $0x803a22
  800218:	e8 74 05 00 00       	call   800791 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 ce 1e 00 00       	call   8020f0 <sys_disable_interrupt>
			cprintf("\n===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 38 3a 80 00       	push   $0x803a38
  80022a:	e8 16 08 00 00       	call   800a45 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 6c 3a 80 00       	push   $0x803a6c
  80023a:	e8 06 08 00 00       	call   800a45 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 a0 3a 80 00       	push   $0x803aa0
  80024a:	e8 f6 07 00 00       	call   800a45 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 b3 1e 00 00       	call   80210a <sys_enable_interrupt>
		}

		sys_disable_interrupt();
  800257:	e8 94 1e 00 00       	call   8020f0 <sys_disable_interrupt>
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 d2 3a 80 00       	push   $0x803ad2
  80026a:	e8 d6 07 00 00       	call   800a45 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 86 03 00 00       	call   8005fd <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 2e 03 00 00       	call   8005b5 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 21 03 00 00       	call   8005b5 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 14 03 00 00       	call   8005b5 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
		}

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b0:	e8 55 1e 00 00       	call   80210a <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800504:	eb 1e                	jmp    800524 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800519:	99                   	cltd   
  80051a:	f7 7d f8             	idivl  -0x8(%ebp)
  80051d:	89 d0                	mov    %edx,%eax
  80051f:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800521:	ff 45 fc             	incl   -0x4(%ebp)
  800524:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800527:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80052a:	7c da                	jl     800506 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80052c:	90                   	nop
  80052d:	c9                   	leave  
  80052e:	c3                   	ret    

0080052f <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
  800532:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800535:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80053c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800543:	eb 42                	jmp    800587 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800548:	99                   	cltd   
  800549:	f7 7d f0             	idivl  -0x10(%ebp)
  80054c:	89 d0                	mov    %edx,%eax
  80054e:	85 c0                	test   %eax,%eax
  800550:	75 10                	jne    800562 <PrintElements+0x33>
			cprintf("\n");
  800552:	83 ec 0c             	sub    $0xc,%esp
  800555:	68 20 39 80 00       	push   $0x803920
  80055a:	e8 e6 04 00 00       	call   800a45 <cprintf>
  80055f:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800565:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056c:	8b 45 08             	mov    0x8(%ebp),%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	50                   	push   %eax
  800577:	68 f0 3a 80 00       	push   $0x803af0
  80057c:	e8 c4 04 00 00       	call   800a45 <cprintf>
  800581:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800584:	ff 45 f4             	incl   -0xc(%ebp)
  800587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058a:	48                   	dec    %eax
  80058b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80058e:	7f b5                	jg     800545 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	01 d0                	add    %edx,%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	50                   	push   %eax
  8005a5:	68 f5 3a 80 00       	push   $0x803af5
  8005aa:	e8 96 04 00 00       	call   800a45 <cprintf>
  8005af:	83 c4 10             	add    $0x10,%esp

}
  8005b2:	90                   	nop
  8005b3:	c9                   	leave  
  8005b4:	c3                   	ret    

008005b5 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005c1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005c5:	83 ec 0c             	sub    $0xc,%esp
  8005c8:	50                   	push   %eax
  8005c9:	e8 56 1b 00 00       	call   802124 <sys_cputc>
  8005ce:	83 c4 10             	add    $0x10,%esp
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005da:	e8 11 1b 00 00       	call   8020f0 <sys_disable_interrupt>
	char c = ch;
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005e5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005e9:	83 ec 0c             	sub    $0xc,%esp
  8005ec:	50                   	push   %eax
  8005ed:	e8 32 1b 00 00       	call   802124 <sys_cputc>
  8005f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005f5:	e8 10 1b 00 00       	call   80210a <sys_enable_interrupt>
}
  8005fa:	90                   	nop
  8005fb:	c9                   	leave  
  8005fc:	c3                   	ret    

008005fd <getchar>:

int
getchar(void)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800603:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80060a:	eb 08                	jmp    800614 <getchar+0x17>
	{
		c = sys_cgetc();
  80060c:	e8 5a 19 00 00       	call   801f6b <sys_cgetc>
  800611:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800618:	74 f2                	je     80060c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80061a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80061d:	c9                   	leave  
  80061e:	c3                   	ret    

0080061f <atomic_getchar>:

int
atomic_getchar(void)
{
  80061f:	55                   	push   %ebp
  800620:	89 e5                	mov    %esp,%ebp
  800622:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800625:	e8 c6 1a 00 00       	call   8020f0 <sys_disable_interrupt>
	int c=0;
  80062a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800631:	eb 08                	jmp    80063b <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800633:	e8 33 19 00 00       	call   801f6b <sys_cgetc>
  800638:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80063b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80063f:	74 f2                	je     800633 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800641:	e8 c4 1a 00 00       	call   80210a <sys_enable_interrupt>
	return c;
  800646:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <iscons>:

int iscons(int fdnum)
{
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80064e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800653:	5d                   	pop    %ebp
  800654:	c3                   	ret    

00800655 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80065b:	e8 83 1c 00 00       	call   8022e3 <sys_getenvindex>
  800660:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800666:	89 d0                	mov    %edx,%eax
  800668:	c1 e0 03             	shl    $0x3,%eax
  80066b:	01 d0                	add    %edx,%eax
  80066d:	01 c0                	add    %eax,%eax
  80066f:	01 d0                	add    %edx,%eax
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	01 d0                	add    %edx,%eax
  80067a:	c1 e0 04             	shl    $0x4,%eax
  80067d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800682:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800687:	a1 24 50 80 00       	mov    0x805024,%eax
  80068c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800692:	84 c0                	test   %al,%al
  800694:	74 0f                	je     8006a5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800696:	a1 24 50 80 00       	mov    0x805024,%eax
  80069b:	05 5c 05 00 00       	add    $0x55c,%eax
  8006a0:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006a9:	7e 0a                	jle    8006b5 <libmain+0x60>
		binaryname = argv[0];
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	ff 75 08             	pushl  0x8(%ebp)
  8006be:	e8 75 f9 ff ff       	call   800038 <_main>
  8006c3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006c6:	e8 25 1a 00 00       	call   8020f0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006cb:	83 ec 0c             	sub    $0xc,%esp
  8006ce:	68 14 3b 80 00       	push   $0x803b14
  8006d3:	e8 6d 03 00 00       	call   800a45 <cprintf>
  8006d8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006db:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006e6:	a1 24 50 80 00       	mov    0x805024,%eax
  8006eb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006f1:	83 ec 04             	sub    $0x4,%esp
  8006f4:	52                   	push   %edx
  8006f5:	50                   	push   %eax
  8006f6:	68 3c 3b 80 00       	push   $0x803b3c
  8006fb:	e8 45 03 00 00       	call   800a45 <cprintf>
  800700:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800703:	a1 24 50 80 00       	mov    0x805024,%eax
  800708:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80070e:	a1 24 50 80 00       	mov    0x805024,%eax
  800713:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800719:	a1 24 50 80 00       	mov    0x805024,%eax
  80071e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800724:	51                   	push   %ecx
  800725:	52                   	push   %edx
  800726:	50                   	push   %eax
  800727:	68 64 3b 80 00       	push   $0x803b64
  80072c:	e8 14 03 00 00       	call   800a45 <cprintf>
  800731:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800734:	a1 24 50 80 00       	mov    0x805024,%eax
  800739:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	50                   	push   %eax
  800743:	68 bc 3b 80 00       	push   $0x803bbc
  800748:	e8 f8 02 00 00       	call   800a45 <cprintf>
  80074d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	68 14 3b 80 00       	push   $0x803b14
  800758:	e8 e8 02 00 00       	call   800a45 <cprintf>
  80075d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800760:	e8 a5 19 00 00       	call   80210a <sys_enable_interrupt>

	// exit gracefully
	exit();
  800765:	e8 19 00 00 00       	call   800783 <exit>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800773:	83 ec 0c             	sub    $0xc,%esp
  800776:	6a 00                	push   $0x0
  800778:	e8 32 1b 00 00       	call   8022af <sys_destroy_env>
  80077d:	83 c4 10             	add    $0x10,%esp
}
  800780:	90                   	nop
  800781:	c9                   	leave  
  800782:	c3                   	ret    

00800783 <exit>:

void
exit(void)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800789:	e8 87 1b 00 00       	call   802315 <sys_exit_env>
}
  80078e:	90                   	nop
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800797:	8d 45 10             	lea    0x10(%ebp),%eax
  80079a:	83 c0 04             	add    $0x4,%eax
  80079d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007a0:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007a5:	85 c0                	test   %eax,%eax
  8007a7:	74 16                	je     8007bf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007a9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	50                   	push   %eax
  8007b2:	68 d0 3b 80 00       	push   $0x803bd0
  8007b7:	e8 89 02 00 00       	call   800a45 <cprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007bf:	a1 00 50 80 00       	mov    0x805000,%eax
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	68 d5 3b 80 00       	push   $0x803bd5
  8007d0:	e8 70 02 00 00       	call   800a45 <cprintf>
  8007d5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e1:	50                   	push   %eax
  8007e2:	e8 f3 01 00 00       	call   8009da <vcprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	6a 00                	push   $0x0
  8007ef:	68 f1 3b 80 00       	push   $0x803bf1
  8007f4:	e8 e1 01 00 00       	call   8009da <vcprintf>
  8007f9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007fc:	e8 82 ff ff ff       	call   800783 <exit>

	// should not return here
	while (1) ;
  800801:	eb fe                	jmp    800801 <_panic+0x70>

00800803 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800809:	a1 24 50 80 00       	mov    0x805024,%eax
  80080e:	8b 50 74             	mov    0x74(%eax),%edx
  800811:	8b 45 0c             	mov    0xc(%ebp),%eax
  800814:	39 c2                	cmp    %eax,%edx
  800816:	74 14                	je     80082c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800818:	83 ec 04             	sub    $0x4,%esp
  80081b:	68 f4 3b 80 00       	push   $0x803bf4
  800820:	6a 26                	push   $0x26
  800822:	68 40 3c 80 00       	push   $0x803c40
  800827:	e8 65 ff ff ff       	call   800791 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80082c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800833:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80083a:	e9 c2 00 00 00       	jmp    800901 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	01 d0                	add    %edx,%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	85 c0                	test   %eax,%eax
  800852:	75 08                	jne    80085c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800854:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800857:	e9 a2 00 00 00       	jmp    8008fe <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80085c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800863:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80086a:	eb 69                	jmp    8008d5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80086c:	a1 24 50 80 00       	mov    0x805024,%eax
  800871:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800877:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80087a:	89 d0                	mov    %edx,%eax
  80087c:	01 c0                	add    %eax,%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	c1 e0 03             	shl    $0x3,%eax
  800883:	01 c8                	add    %ecx,%eax
  800885:	8a 40 04             	mov    0x4(%eax),%al
  800888:	84 c0                	test   %al,%al
  80088a:	75 46                	jne    8008d2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088c:	a1 24 50 80 00       	mov    0x805024,%eax
  800891:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800897:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089a:	89 d0                	mov    %edx,%eax
  80089c:	01 c0                	add    %eax,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	c1 e0 03             	shl    $0x3,%eax
  8008a3:	01 c8                	add    %ecx,%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	75 09                	jne    8008d2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008d0:	eb 12                	jmp    8008e4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d2:	ff 45 e8             	incl   -0x18(%ebp)
  8008d5:	a1 24 50 80 00       	mov    0x805024,%eax
  8008da:	8b 50 74             	mov    0x74(%eax),%edx
  8008dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e0:	39 c2                	cmp    %eax,%edx
  8008e2:	77 88                	ja     80086c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008e8:	75 14                	jne    8008fe <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008ea:	83 ec 04             	sub    $0x4,%esp
  8008ed:	68 4c 3c 80 00       	push   $0x803c4c
  8008f2:	6a 3a                	push   $0x3a
  8008f4:	68 40 3c 80 00       	push   $0x803c40
  8008f9:	e8 93 fe ff ff       	call   800791 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008fe:	ff 45 f0             	incl   -0x10(%ebp)
  800901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800904:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800907:	0f 8c 32 ff ff ff    	jl     80083f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80090d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800914:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80091b:	eb 26                	jmp    800943 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80091d:	a1 24 50 80 00       	mov    0x805024,%eax
  800922:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800928:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80092b:	89 d0                	mov    %edx,%eax
  80092d:	01 c0                	add    %eax,%eax
  80092f:	01 d0                	add    %edx,%eax
  800931:	c1 e0 03             	shl    $0x3,%eax
  800934:	01 c8                	add    %ecx,%eax
  800936:	8a 40 04             	mov    0x4(%eax),%al
  800939:	3c 01                	cmp    $0x1,%al
  80093b:	75 03                	jne    800940 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80093d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800940:	ff 45 e0             	incl   -0x20(%ebp)
  800943:	a1 24 50 80 00       	mov    0x805024,%eax
  800948:	8b 50 74             	mov    0x74(%eax),%edx
  80094b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80094e:	39 c2                	cmp    %eax,%edx
  800950:	77 cb                	ja     80091d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800955:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800958:	74 14                	je     80096e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 a0 3c 80 00       	push   $0x803ca0
  800962:	6a 44                	push   $0x44
  800964:	68 40 3c 80 00       	push   $0x803c40
  800969:	e8 23 fe ff ff       	call   800791 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80096e:	90                   	nop
  80096f:	c9                   	leave  
  800970:	c3                   	ret    

00800971 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	8d 48 01             	lea    0x1(%eax),%ecx
  80097f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800982:	89 0a                	mov    %ecx,(%edx)
  800984:	8b 55 08             	mov    0x8(%ebp),%edx
  800987:	88 d1                	mov    %dl,%cl
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	3d ff 00 00 00       	cmp    $0xff,%eax
  80099a:	75 2c                	jne    8009c8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80099c:	a0 28 50 80 00       	mov    0x805028,%al
  8009a1:	0f b6 c0             	movzbl %al,%eax
  8009a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a7:	8b 12                	mov    (%edx),%edx
  8009a9:	89 d1                	mov    %edx,%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ae:	83 c2 08             	add    $0x8,%edx
  8009b1:	83 ec 04             	sub    $0x4,%esp
  8009b4:	50                   	push   %eax
  8009b5:	51                   	push   %ecx
  8009b6:	52                   	push   %edx
  8009b7:	e8 86 15 00 00       	call   801f42 <sys_cputs>
  8009bc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cb:	8b 40 04             	mov    0x4(%eax),%eax
  8009ce:	8d 50 01             	lea    0x1(%eax),%edx
  8009d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009d7:	90                   	nop
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009ea:	00 00 00 
	b.cnt = 0;
  8009ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009f4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	ff 75 08             	pushl  0x8(%ebp)
  8009fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a03:	50                   	push   %eax
  800a04:	68 71 09 80 00       	push   $0x800971
  800a09:	e8 11 02 00 00       	call   800c1f <vprintfmt>
  800a0e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a11:	a0 28 50 80 00       	mov    0x805028,%al
  800a16:	0f b6 c0             	movzbl %al,%eax
  800a19:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a1f:	83 ec 04             	sub    $0x4,%esp
  800a22:	50                   	push   %eax
  800a23:	52                   	push   %edx
  800a24:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2a:	83 c0 08             	add    $0x8,%eax
  800a2d:	50                   	push   %eax
  800a2e:	e8 0f 15 00 00       	call   801f42 <sys_cputs>
  800a33:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a36:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800a3d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a43:	c9                   	leave  
  800a44:	c3                   	ret    

00800a45 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a4b:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800a52:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a61:	50                   	push   %eax
  800a62:	e8 73 ff ff ff       	call   8009da <vcprintf>
  800a67:	83 c4 10             	add    $0x10,%esp
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a78:	e8 73 16 00 00       	call   8020f0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a7d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	e8 48 ff ff ff       	call   8009da <vcprintf>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a98:	e8 6d 16 00 00       	call   80210a <sys_enable_interrupt>
	return cnt;
  800a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa0:	c9                   	leave  
  800aa1:	c3                   	ret    

00800aa2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	53                   	push   %ebx
  800aa6:	83 ec 14             	sub    $0x14,%esp
  800aa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800aac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ab5:	8b 45 18             	mov    0x18(%ebp),%eax
  800ab8:	ba 00 00 00 00       	mov    $0x0,%edx
  800abd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac0:	77 55                	ja     800b17 <printnum+0x75>
  800ac2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac5:	72 05                	jb     800acc <printnum+0x2a>
  800ac7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800aca:	77 4b                	ja     800b17 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800acc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800acf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ad2:	8b 45 18             	mov    0x18(%ebp),%eax
  800ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  800ada:	52                   	push   %edx
  800adb:	50                   	push   %eax
  800adc:	ff 75 f4             	pushl  -0xc(%ebp)
  800adf:	ff 75 f0             	pushl  -0x10(%ebp)
  800ae2:	e8 d5 2b 00 00       	call   8036bc <__udivdi3>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	ff 75 20             	pushl  0x20(%ebp)
  800af0:	53                   	push   %ebx
  800af1:	ff 75 18             	pushl  0x18(%ebp)
  800af4:	52                   	push   %edx
  800af5:	50                   	push   %eax
  800af6:	ff 75 0c             	pushl  0xc(%ebp)
  800af9:	ff 75 08             	pushl  0x8(%ebp)
  800afc:	e8 a1 ff ff ff       	call   800aa2 <printnum>
  800b01:	83 c4 20             	add    $0x20,%esp
  800b04:	eb 1a                	jmp    800b20 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	ff 75 20             	pushl  0x20(%ebp)
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	ff d0                	call   *%eax
  800b14:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b17:	ff 4d 1c             	decl   0x1c(%ebp)
  800b1a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b1e:	7f e6                	jg     800b06 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b20:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b2e:	53                   	push   %ebx
  800b2f:	51                   	push   %ecx
  800b30:	52                   	push   %edx
  800b31:	50                   	push   %eax
  800b32:	e8 95 2c 00 00       	call   8037cc <__umoddi3>
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	05 14 3f 80 00       	add    $0x803f14,%eax
  800b3f:	8a 00                	mov    (%eax),%al
  800b41:	0f be c0             	movsbl %al,%eax
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	50                   	push   %eax
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	ff d0                	call   *%eax
  800b50:	83 c4 10             	add    $0x10,%esp
}
  800b53:	90                   	nop
  800b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b60:	7e 1c                	jle    800b7e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	8d 50 08             	lea    0x8(%eax),%edx
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	89 10                	mov    %edx,(%eax)
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	83 e8 08             	sub    $0x8,%eax
  800b77:	8b 50 04             	mov    0x4(%eax),%edx
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	eb 40                	jmp    800bbe <getuint+0x65>
	else if (lflag)
  800b7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b82:	74 1e                	je     800ba2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8b 00                	mov    (%eax),%eax
  800b89:	8d 50 04             	lea    0x4(%eax),%edx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	89 10                	mov    %edx,(%eax)
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	83 e8 04             	sub    $0x4,%eax
  800b99:	8b 00                	mov    (%eax),%eax
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	eb 1c                	jmp    800bbe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	8d 50 04             	lea    0x4(%eax),%edx
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	89 10                	mov    %edx,(%eax)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	83 e8 04             	sub    $0x4,%eax
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bc3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bc7:	7e 1c                	jle    800be5 <getint+0x25>
		return va_arg(*ap, long long);
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 00                	mov    (%eax),%eax
  800bce:	8d 50 08             	lea    0x8(%eax),%edx
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	89 10                	mov    %edx,(%eax)
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 00                	mov    (%eax),%eax
  800bdb:	83 e8 08             	sub    $0x8,%eax
  800bde:	8b 50 04             	mov    0x4(%eax),%edx
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	eb 38                	jmp    800c1d <getint+0x5d>
	else if (lflag)
  800be5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be9:	74 1a                	je     800c05 <getint+0x45>
		return va_arg(*ap, long);
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 00                	mov    (%eax),%eax
  800bf0:	8d 50 04             	lea    0x4(%eax),%edx
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	89 10                	mov    %edx,(%eax)
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	83 e8 04             	sub    $0x4,%eax
  800c00:	8b 00                	mov    (%eax),%eax
  800c02:	99                   	cltd   
  800c03:	eb 18                	jmp    800c1d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8b 00                	mov    (%eax),%eax
  800c0a:	8d 50 04             	lea    0x4(%eax),%edx
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 10                	mov    %edx,(%eax)
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	8b 00                	mov    (%eax),%eax
  800c17:	83 e8 04             	sub    $0x4,%eax
  800c1a:	8b 00                	mov    (%eax),%eax
  800c1c:	99                   	cltd   
}
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c27:	eb 17                	jmp    800c40 <vprintfmt+0x21>
			if (ch == '\0')
  800c29:	85 db                	test   %ebx,%ebx
  800c2b:	0f 84 af 03 00 00    	je     800fe0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	53                   	push   %ebx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	ff d0                	call   *%eax
  800c3d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c40:	8b 45 10             	mov    0x10(%ebp),%eax
  800c43:	8d 50 01             	lea    0x1(%eax),%edx
  800c46:	89 55 10             	mov    %edx,0x10(%ebp)
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	0f b6 d8             	movzbl %al,%ebx
  800c4e:	83 fb 25             	cmp    $0x25,%ebx
  800c51:	75 d6                	jne    800c29 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c53:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c57:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c6c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c73:	8b 45 10             	mov    0x10(%ebp),%eax
  800c76:	8d 50 01             	lea    0x1(%eax),%edx
  800c79:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	0f b6 d8             	movzbl %al,%ebx
  800c81:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c84:	83 f8 55             	cmp    $0x55,%eax
  800c87:	0f 87 2b 03 00 00    	ja     800fb8 <vprintfmt+0x399>
  800c8d:	8b 04 85 38 3f 80 00 	mov    0x803f38(,%eax,4),%eax
  800c94:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c96:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c9a:	eb d7                	jmp    800c73 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c9c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ca0:	eb d1                	jmp    800c73 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ca9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	c1 e0 02             	shl    $0x2,%eax
  800cb1:	01 d0                	add    %edx,%eax
  800cb3:	01 c0                	add    %eax,%eax
  800cb5:	01 d8                	add    %ebx,%eax
  800cb7:	83 e8 30             	sub    $0x30,%eax
  800cba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cc5:	83 fb 2f             	cmp    $0x2f,%ebx
  800cc8:	7e 3e                	jle    800d08 <vprintfmt+0xe9>
  800cca:	83 fb 39             	cmp    $0x39,%ebx
  800ccd:	7f 39                	jg     800d08 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cd2:	eb d5                	jmp    800ca9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd7:	83 c0 04             	add    $0x4,%eax
  800cda:	89 45 14             	mov    %eax,0x14(%ebp)
  800cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce0:	83 e8 04             	sub    $0x4,%eax
  800ce3:	8b 00                	mov    (%eax),%eax
  800ce5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ce8:	eb 1f                	jmp    800d09 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cee:	79 83                	jns    800c73 <vprintfmt+0x54>
				width = 0;
  800cf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cf7:	e9 77 ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cfc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d03:	e9 6b ff ff ff       	jmp    800c73 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d08:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0d:	0f 89 60 ff ff ff    	jns    800c73 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d19:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d20:	e9 4e ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d25:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d28:	e9 46 ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d30:	83 c0 04             	add    $0x4,%eax
  800d33:	89 45 14             	mov    %eax,0x14(%ebp)
  800d36:	8b 45 14             	mov    0x14(%ebp),%eax
  800d39:	83 e8 04             	sub    $0x4,%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	50                   	push   %eax
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	ff d0                	call   *%eax
  800d4a:	83 c4 10             	add    $0x10,%esp
			break;
  800d4d:	e9 89 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d52:	8b 45 14             	mov    0x14(%ebp),%eax
  800d55:	83 c0 04             	add    $0x4,%eax
  800d58:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5e:	83 e8 04             	sub    $0x4,%eax
  800d61:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d63:	85 db                	test   %ebx,%ebx
  800d65:	79 02                	jns    800d69 <vprintfmt+0x14a>
				err = -err;
  800d67:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d69:	83 fb 64             	cmp    $0x64,%ebx
  800d6c:	7f 0b                	jg     800d79 <vprintfmt+0x15a>
  800d6e:	8b 34 9d 80 3d 80 00 	mov    0x803d80(,%ebx,4),%esi
  800d75:	85 f6                	test   %esi,%esi
  800d77:	75 19                	jne    800d92 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d79:	53                   	push   %ebx
  800d7a:	68 25 3f 80 00       	push   $0x803f25
  800d7f:	ff 75 0c             	pushl  0xc(%ebp)
  800d82:	ff 75 08             	pushl  0x8(%ebp)
  800d85:	e8 5e 02 00 00       	call   800fe8 <printfmt>
  800d8a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d8d:	e9 49 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d92:	56                   	push   %esi
  800d93:	68 2e 3f 80 00       	push   $0x803f2e
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	ff 75 08             	pushl  0x8(%ebp)
  800d9e:	e8 45 02 00 00       	call   800fe8 <printfmt>
  800da3:	83 c4 10             	add    $0x10,%esp
			break;
  800da6:	e9 30 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dab:	8b 45 14             	mov    0x14(%ebp),%eax
  800dae:	83 c0 04             	add    $0x4,%eax
  800db1:	89 45 14             	mov    %eax,0x14(%ebp)
  800db4:	8b 45 14             	mov    0x14(%ebp),%eax
  800db7:	83 e8 04             	sub    $0x4,%eax
  800dba:	8b 30                	mov    (%eax),%esi
  800dbc:	85 f6                	test   %esi,%esi
  800dbe:	75 05                	jne    800dc5 <vprintfmt+0x1a6>
				p = "(null)";
  800dc0:	be 31 3f 80 00       	mov    $0x803f31,%esi
			if (width > 0 && padc != '-')
  800dc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc9:	7e 6d                	jle    800e38 <vprintfmt+0x219>
  800dcb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dcf:	74 67                	je     800e38 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dd4:	83 ec 08             	sub    $0x8,%esp
  800dd7:	50                   	push   %eax
  800dd8:	56                   	push   %esi
  800dd9:	e8 12 05 00 00       	call   8012f0 <strnlen>
  800dde:	83 c4 10             	add    $0x10,%esp
  800de1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800de4:	eb 16                	jmp    800dfc <vprintfmt+0x1dd>
					putch(padc, putdat);
  800de6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dea:	83 ec 08             	sub    $0x8,%esp
  800ded:	ff 75 0c             	pushl  0xc(%ebp)
  800df0:	50                   	push   %eax
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	ff d0                	call   *%eax
  800df6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800df9:	ff 4d e4             	decl   -0x1c(%ebp)
  800dfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e00:	7f e4                	jg     800de6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e02:	eb 34                	jmp    800e38 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e08:	74 1c                	je     800e26 <vprintfmt+0x207>
  800e0a:	83 fb 1f             	cmp    $0x1f,%ebx
  800e0d:	7e 05                	jle    800e14 <vprintfmt+0x1f5>
  800e0f:	83 fb 7e             	cmp    $0x7e,%ebx
  800e12:	7e 12                	jle    800e26 <vprintfmt+0x207>
					putch('?', putdat);
  800e14:	83 ec 08             	sub    $0x8,%esp
  800e17:	ff 75 0c             	pushl  0xc(%ebp)
  800e1a:	6a 3f                	push   $0x3f
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
  800e24:	eb 0f                	jmp    800e35 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e26:	83 ec 08             	sub    $0x8,%esp
  800e29:	ff 75 0c             	pushl  0xc(%ebp)
  800e2c:	53                   	push   %ebx
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	ff d0                	call   *%eax
  800e32:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e35:	ff 4d e4             	decl   -0x1c(%ebp)
  800e38:	89 f0                	mov    %esi,%eax
  800e3a:	8d 70 01             	lea    0x1(%eax),%esi
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	0f be d8             	movsbl %al,%ebx
  800e42:	85 db                	test   %ebx,%ebx
  800e44:	74 24                	je     800e6a <vprintfmt+0x24b>
  800e46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e4a:	78 b8                	js     800e04 <vprintfmt+0x1e5>
  800e4c:	ff 4d e0             	decl   -0x20(%ebp)
  800e4f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e53:	79 af                	jns    800e04 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e55:	eb 13                	jmp    800e6a <vprintfmt+0x24b>
				putch(' ', putdat);
  800e57:	83 ec 08             	sub    $0x8,%esp
  800e5a:	ff 75 0c             	pushl  0xc(%ebp)
  800e5d:	6a 20                	push   $0x20
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	ff d0                	call   *%eax
  800e64:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e67:	ff 4d e4             	decl   -0x1c(%ebp)
  800e6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6e:	7f e7                	jg     800e57 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e70:	e9 66 01 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e75:	83 ec 08             	sub    $0x8,%esp
  800e78:	ff 75 e8             	pushl  -0x18(%ebp)
  800e7b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e7e:	50                   	push   %eax
  800e7f:	e8 3c fd ff ff       	call   800bc0 <getint>
  800e84:	83 c4 10             	add    $0x10,%esp
  800e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e93:	85 d2                	test   %edx,%edx
  800e95:	79 23                	jns    800eba <vprintfmt+0x29b>
				putch('-', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 2d                	push   $0x2d
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ead:	f7 d8                	neg    %eax
  800eaf:	83 d2 00             	adc    $0x0,%edx
  800eb2:	f7 da                	neg    %edx
  800eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800eba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ec1:	e9 bc 00 00 00       	jmp    800f82 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ec6:	83 ec 08             	sub    $0x8,%esp
  800ec9:	ff 75 e8             	pushl  -0x18(%ebp)
  800ecc:	8d 45 14             	lea    0x14(%ebp),%eax
  800ecf:	50                   	push   %eax
  800ed0:	e8 84 fc ff ff       	call   800b59 <getuint>
  800ed5:	83 c4 10             	add    $0x10,%esp
  800ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ede:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ee5:	e9 98 00 00 00       	jmp    800f82 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eea:	83 ec 08             	sub    $0x8,%esp
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	6a 58                	push   $0x58
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	ff d0                	call   *%eax
  800ef7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800efa:	83 ec 08             	sub    $0x8,%esp
  800efd:	ff 75 0c             	pushl  0xc(%ebp)
  800f00:	6a 58                	push   $0x58
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	ff d0                	call   *%eax
  800f07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 0c             	pushl  0xc(%ebp)
  800f10:	6a 58                	push   $0x58
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	ff d0                	call   *%eax
  800f17:	83 c4 10             	add    $0x10,%esp
			break;
  800f1a:	e9 bc 00 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f1f:	83 ec 08             	sub    $0x8,%esp
  800f22:	ff 75 0c             	pushl  0xc(%ebp)
  800f25:	6a 30                	push   $0x30
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	ff d0                	call   *%eax
  800f2c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f2f:	83 ec 08             	sub    $0x8,%esp
  800f32:	ff 75 0c             	pushl  0xc(%ebp)
  800f35:	6a 78                	push   $0x78
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	ff d0                	call   *%eax
  800f3c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f42:	83 c0 04             	add    $0x4,%eax
  800f45:	89 45 14             	mov    %eax,0x14(%ebp)
  800f48:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4b:	83 e8 04             	sub    $0x4,%eax
  800f4e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f61:	eb 1f                	jmp    800f82 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 e8             	pushl  -0x18(%ebp)
  800f69:	8d 45 14             	lea    0x14(%ebp),%eax
  800f6c:	50                   	push   %eax
  800f6d:	e8 e7 fb ff ff       	call   800b59 <getuint>
  800f72:	83 c4 10             	add    $0x10,%esp
  800f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f78:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f82:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f89:	83 ec 04             	sub    $0x4,%esp
  800f8c:	52                   	push   %edx
  800f8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f90:	50                   	push   %eax
  800f91:	ff 75 f4             	pushl  -0xc(%ebp)
  800f94:	ff 75 f0             	pushl  -0x10(%ebp)
  800f97:	ff 75 0c             	pushl  0xc(%ebp)
  800f9a:	ff 75 08             	pushl  0x8(%ebp)
  800f9d:	e8 00 fb ff ff       	call   800aa2 <printnum>
  800fa2:	83 c4 20             	add    $0x20,%esp
			break;
  800fa5:	eb 34                	jmp    800fdb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	53                   	push   %ebx
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	ff d0                	call   *%eax
  800fb3:	83 c4 10             	add    $0x10,%esp
			break;
  800fb6:	eb 23                	jmp    800fdb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fb8:	83 ec 08             	sub    $0x8,%esp
  800fbb:	ff 75 0c             	pushl  0xc(%ebp)
  800fbe:	6a 25                	push   $0x25
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	ff d0                	call   *%eax
  800fc5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fc8:	ff 4d 10             	decl   0x10(%ebp)
  800fcb:	eb 03                	jmp    800fd0 <vprintfmt+0x3b1>
  800fcd:	ff 4d 10             	decl   0x10(%ebp)
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	48                   	dec    %eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 25                	cmp    $0x25,%al
  800fd8:	75 f3                	jne    800fcd <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fda:	90                   	nop
		}
	}
  800fdb:	e9 47 fc ff ff       	jmp    800c27 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fe0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fe1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fe4:	5b                   	pop    %ebx
  800fe5:	5e                   	pop    %esi
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fee:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff1:	83 c0 04             	add    $0x4,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	ff 75 f4             	pushl  -0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	ff 75 08             	pushl  0x8(%ebp)
  801004:	e8 16 fc ff ff       	call   800c1f <vprintfmt>
  801009:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80100c:	90                   	nop
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801012:	8b 45 0c             	mov    0xc(%ebp),%eax
  801015:	8b 40 08             	mov    0x8(%eax),%eax
  801018:	8d 50 01             	lea    0x1(%eax),%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	8b 10                	mov    (%eax),%edx
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	8b 40 04             	mov    0x4(%eax),%eax
  80102c:	39 c2                	cmp    %eax,%edx
  80102e:	73 12                	jae    801042 <sprintputch+0x33>
		*b->buf++ = ch;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8b 00                	mov    (%eax),%eax
  801035:	8d 48 01             	lea    0x1(%eax),%ecx
  801038:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103b:	89 0a                	mov    %ecx,(%edx)
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	88 10                	mov    %dl,(%eax)
}
  801042:	90                   	nop
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    

00801045 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8d 50 ff             	lea    -0x1(%eax),%edx
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	01 d0                	add    %edx,%eax
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801066:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106a:	74 06                	je     801072 <vsnprintf+0x2d>
  80106c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801070:	7f 07                	jg     801079 <vsnprintf+0x34>
		return -E_INVAL;
  801072:	b8 03 00 00 00       	mov    $0x3,%eax
  801077:	eb 20                	jmp    801099 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801079:	ff 75 14             	pushl  0x14(%ebp)
  80107c:	ff 75 10             	pushl  0x10(%ebp)
  80107f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801082:	50                   	push   %eax
  801083:	68 0f 10 80 00       	push   $0x80100f
  801088:	e8 92 fb ff ff       	call   800c1f <vprintfmt>
  80108d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801090:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801093:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801096:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b0:	50                   	push   %eax
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	ff 75 08             	pushl  0x8(%ebp)
  8010b7:	e8 89 ff ff ff       	call   801045 <vsnprintf>
  8010bc:	83 c4 10             	add    $0x10,%esp
  8010bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010d1:	74 13                	je     8010e6 <readline+0x1f>
		cprintf("%s", prompt);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	ff 75 08             	pushl  0x8(%ebp)
  8010d9:	68 90 40 80 00       	push   $0x804090
  8010de:	e8 62 f9 ff ff       	call   800a45 <cprintf>
  8010e3:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010ed:	83 ec 0c             	sub    $0xc,%esp
  8010f0:	6a 00                	push   $0x0
  8010f2:	e8 54 f5 ff ff       	call   80064b <iscons>
  8010f7:	83 c4 10             	add    $0x10,%esp
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010fd:	e8 fb f4 ff ff       	call   8005fd <getchar>
  801102:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801105:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801109:	79 22                	jns    80112d <readline+0x66>
			if (c != -E_EOF)
  80110b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80110f:	0f 84 ad 00 00 00    	je     8011c2 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801115:	83 ec 08             	sub    $0x8,%esp
  801118:	ff 75 ec             	pushl  -0x14(%ebp)
  80111b:	68 93 40 80 00       	push   $0x804093
  801120:	e8 20 f9 ff ff       	call   800a45 <cprintf>
  801125:	83 c4 10             	add    $0x10,%esp
			return;
  801128:	e9 95 00 00 00       	jmp    8011c2 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80112d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801131:	7e 34                	jle    801167 <readline+0xa0>
  801133:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80113a:	7f 2b                	jg     801167 <readline+0xa0>
			if (echoing)
  80113c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801140:	74 0e                	je     801150 <readline+0x89>
				cputchar(c);
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	ff 75 ec             	pushl  -0x14(%ebp)
  801148:	e8 68 f4 ff ff       	call   8005b5 <cputchar>
  80114d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801153:	8d 50 01             	lea    0x1(%eax),%edx
  801156:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801159:	89 c2                	mov    %eax,%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801163:	88 10                	mov    %dl,(%eax)
  801165:	eb 56                	jmp    8011bd <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801167:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80116b:	75 1f                	jne    80118c <readline+0xc5>
  80116d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801171:	7e 19                	jle    80118c <readline+0xc5>
			if (echoing)
  801173:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801177:	74 0e                	je     801187 <readline+0xc0>
				cputchar(c);
  801179:	83 ec 0c             	sub    $0xc,%esp
  80117c:	ff 75 ec             	pushl  -0x14(%ebp)
  80117f:	e8 31 f4 ff ff       	call   8005b5 <cputchar>
  801184:	83 c4 10             	add    $0x10,%esp

			i--;
  801187:	ff 4d f4             	decl   -0xc(%ebp)
  80118a:	eb 31                	jmp    8011bd <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80118c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801190:	74 0a                	je     80119c <readline+0xd5>
  801192:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801196:	0f 85 61 ff ff ff    	jne    8010fd <readline+0x36>
			if (echoing)
  80119c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011a0:	74 0e                	je     8011b0 <readline+0xe9>
				cputchar(c);
  8011a2:	83 ec 0c             	sub    $0xc,%esp
  8011a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8011a8:	e8 08 f4 ff ff       	call   8005b5 <cputchar>
  8011ad:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011bb:	eb 06                	jmp    8011c3 <readline+0xfc>
		}
	}
  8011bd:	e9 3b ff ff ff       	jmp    8010fd <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011c2:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011cb:	e8 20 0f 00 00       	call   8020f0 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d4:	74 13                	je     8011e9 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 08             	pushl  0x8(%ebp)
  8011dc:	68 90 40 80 00       	push   $0x804090
  8011e1:	e8 5f f8 ff ff       	call   800a45 <cprintf>
  8011e6:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	6a 00                	push   $0x0
  8011f5:	e8 51 f4 ff ff       	call   80064b <iscons>
  8011fa:	83 c4 10             	add    $0x10,%esp
  8011fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801200:	e8 f8 f3 ff ff       	call   8005fd <getchar>
  801205:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801208:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80120c:	79 23                	jns    801231 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80120e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801212:	74 13                	je     801227 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801214:	83 ec 08             	sub    $0x8,%esp
  801217:	ff 75 ec             	pushl  -0x14(%ebp)
  80121a:	68 93 40 80 00       	push   $0x804093
  80121f:	e8 21 f8 ff ff       	call   800a45 <cprintf>
  801224:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801227:	e8 de 0e 00 00       	call   80210a <sys_enable_interrupt>
			return;
  80122c:	e9 9a 00 00 00       	jmp    8012cb <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801231:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801235:	7e 34                	jle    80126b <atomic_readline+0xa6>
  801237:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80123e:	7f 2b                	jg     80126b <atomic_readline+0xa6>
			if (echoing)
  801240:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801244:	74 0e                	je     801254 <atomic_readline+0x8f>
				cputchar(c);
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	ff 75 ec             	pushl  -0x14(%ebp)
  80124c:	e8 64 f3 ff ff       	call   8005b5 <cputchar>
  801251:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801257:	8d 50 01             	lea    0x1(%eax),%edx
  80125a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80125d:	89 c2                	mov    %eax,%edx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 d0                	add    %edx,%eax
  801264:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801267:	88 10                	mov    %dl,(%eax)
  801269:	eb 5b                	jmp    8012c6 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80126b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80126f:	75 1f                	jne    801290 <atomic_readline+0xcb>
  801271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801275:	7e 19                	jle    801290 <atomic_readline+0xcb>
			if (echoing)
  801277:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80127b:	74 0e                	je     80128b <atomic_readline+0xc6>
				cputchar(c);
  80127d:	83 ec 0c             	sub    $0xc,%esp
  801280:	ff 75 ec             	pushl  -0x14(%ebp)
  801283:	e8 2d f3 ff ff       	call   8005b5 <cputchar>
  801288:	83 c4 10             	add    $0x10,%esp
			i--;
  80128b:	ff 4d f4             	decl   -0xc(%ebp)
  80128e:	eb 36                	jmp    8012c6 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801290:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801294:	74 0a                	je     8012a0 <atomic_readline+0xdb>
  801296:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80129a:	0f 85 60 ff ff ff    	jne    801200 <atomic_readline+0x3b>
			if (echoing)
  8012a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012a4:	74 0e                	je     8012b4 <atomic_readline+0xef>
				cputchar(c);
  8012a6:	83 ec 0c             	sub    $0xc,%esp
  8012a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ac:	e8 04 f3 ff ff       	call   8005b5 <cputchar>
  8012b1:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012bf:	e8 46 0e 00 00       	call   80210a <sys_enable_interrupt>
			return;
  8012c4:	eb 05                	jmp    8012cb <atomic_readline+0x106>
		}
	}
  8012c6:	e9 35 ff ff ff       	jmp    801200 <atomic_readline+0x3b>
}
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012da:	eb 06                	jmp    8012e2 <strlen+0x15>
		n++;
  8012dc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012df:	ff 45 08             	incl   0x8(%ebp)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	75 f1                	jne    8012dc <strlen+0xf>
		n++;
	return n;
  8012eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fd:	eb 09                	jmp    801308 <strnlen+0x18>
		n++;
  8012ff:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801302:	ff 45 08             	incl   0x8(%ebp)
  801305:	ff 4d 0c             	decl   0xc(%ebp)
  801308:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130c:	74 09                	je     801317 <strnlen+0x27>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	75 e8                	jne    8012ff <strnlen+0xf>
		n++;
	return n;
  801317:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801328:	90                   	nop
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 08             	mov    %edx,0x8(%ebp)
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
  801335:	8d 4a 01             	lea    0x1(%edx),%ecx
  801338:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80133b:	8a 12                	mov    (%edx),%dl
  80133d:	88 10                	mov    %dl,(%eax)
  80133f:	8a 00                	mov    (%eax),%al
  801341:	84 c0                	test   %al,%al
  801343:	75 e4                	jne    801329 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801356:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80135d:	eb 1f                	jmp    80137e <strncpy+0x34>
		*dst++ = *src;
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8d 50 01             	lea    0x1(%eax),%edx
  801365:	89 55 08             	mov    %edx,0x8(%ebp)
  801368:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136b:	8a 12                	mov    (%edx),%dl
  80136d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80136f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801372:	8a 00                	mov    (%eax),%al
  801374:	84 c0                	test   %al,%al
  801376:	74 03                	je     80137b <strncpy+0x31>
			src++;
  801378:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80137b:	ff 45 fc             	incl   -0x4(%ebp)
  80137e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801381:	3b 45 10             	cmp    0x10(%ebp),%eax
  801384:	72 d9                	jb     80135f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801397:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139b:	74 30                	je     8013cd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80139d:	eb 16                	jmp    8013b5 <strlcpy+0x2a>
			*dst++ = *src++;
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8d 50 01             	lea    0x1(%eax),%edx
  8013a5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013ae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013b1:	8a 12                	mov    (%edx),%dl
  8013b3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013b5:	ff 4d 10             	decl   0x10(%ebp)
  8013b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013bc:	74 09                	je     8013c7 <strlcpy+0x3c>
  8013be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	84 c0                	test   %al,%al
  8013c5:	75 d8                	jne    80139f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d3:	29 c2                	sub    %eax,%edx
  8013d5:	89 d0                	mov    %edx,%eax
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013dc:	eb 06                	jmp    8013e4 <strcmp+0xb>
		p++, q++;
  8013de:	ff 45 08             	incl   0x8(%ebp)
  8013e1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	84 c0                	test   %al,%al
  8013eb:	74 0e                	je     8013fb <strcmp+0x22>
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 10                	mov    (%eax),%dl
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	38 c2                	cmp    %al,%dl
  8013f9:	74 e3                	je     8013de <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f b6 d0             	movzbl %al,%edx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	0f b6 c0             	movzbl %al,%eax
  80140b:	29 c2                	sub    %eax,%edx
  80140d:	89 d0                	mov    %edx,%eax
}
  80140f:	5d                   	pop    %ebp
  801410:	c3                   	ret    

00801411 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801414:	eb 09                	jmp    80141f <strncmp+0xe>
		n--, p++, q++;
  801416:	ff 4d 10             	decl   0x10(%ebp)
  801419:	ff 45 08             	incl   0x8(%ebp)
  80141c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80141f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801423:	74 17                	je     80143c <strncmp+0x2b>
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	84 c0                	test   %al,%al
  80142c:	74 0e                	je     80143c <strncmp+0x2b>
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8a 10                	mov    (%eax),%dl
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	38 c2                	cmp    %al,%dl
  80143a:	74 da                	je     801416 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80143c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801440:	75 07                	jne    801449 <strncmp+0x38>
		return 0;
  801442:	b8 00 00 00 00       	mov    $0x0,%eax
  801447:	eb 14                	jmp    80145d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	0f b6 d0             	movzbl %al,%edx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	0f b6 c0             	movzbl %al,%eax
  801459:	29 c2                	sub    %eax,%edx
  80145b:	89 d0                	mov    %edx,%eax
}
  80145d:	5d                   	pop    %ebp
  80145e:	c3                   	ret    

0080145f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	8b 45 0c             	mov    0xc(%ebp),%eax
  801468:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80146b:	eb 12                	jmp    80147f <strchr+0x20>
		if (*s == c)
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801475:	75 05                	jne    80147c <strchr+0x1d>
			return (char *) s;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	eb 11                	jmp    80148d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80147c:	ff 45 08             	incl   0x8(%ebp)
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	84 c0                	test   %al,%al
  801486:	75 e5                	jne    80146d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	8b 45 0c             	mov    0xc(%ebp),%eax
  801498:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80149b:	eb 0d                	jmp    8014aa <strfind+0x1b>
		if (*s == c)
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014a5:	74 0e                	je     8014b5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014a7:	ff 45 08             	incl   0x8(%ebp)
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	84 c0                	test   %al,%al
  8014b1:	75 ea                	jne    80149d <strfind+0xe>
  8014b3:	eb 01                	jmp    8014b6 <strfind+0x27>
		if (*s == c)
			break;
  8014b5:	90                   	nop
	return (char *) s;
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014cd:	eb 0e                	jmp    8014dd <memset+0x22>
		*p++ = c;
  8014cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014dd:	ff 4d f8             	decl   -0x8(%ebp)
  8014e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014e4:	79 e9                	jns    8014cf <memset+0x14>
		*p++ = c;

	return v;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014fd:	eb 16                	jmp    801515 <memcpy+0x2a>
		*d++ = *s++;
  8014ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801502:	8d 50 01             	lea    0x1(%eax),%edx
  801505:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801508:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80150e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801511:	8a 12                	mov    (%edx),%dl
  801513:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801515:	8b 45 10             	mov    0x10(%ebp),%eax
  801518:	8d 50 ff             	lea    -0x1(%eax),%edx
  80151b:	89 55 10             	mov    %edx,0x10(%ebp)
  80151e:	85 c0                	test   %eax,%eax
  801520:	75 dd                	jne    8014ff <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80152d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801530:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801539:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153f:	73 50                	jae    801591 <memmove+0x6a>
  801541:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801544:	8b 45 10             	mov    0x10(%ebp),%eax
  801547:	01 d0                	add    %edx,%eax
  801549:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80154c:	76 43                	jbe    801591 <memmove+0x6a>
		s += n;
  80154e:	8b 45 10             	mov    0x10(%ebp),%eax
  801551:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801554:	8b 45 10             	mov    0x10(%ebp),%eax
  801557:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80155a:	eb 10                	jmp    80156c <memmove+0x45>
			*--d = *--s;
  80155c:	ff 4d f8             	decl   -0x8(%ebp)
  80155f:	ff 4d fc             	decl   -0x4(%ebp)
  801562:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801565:	8a 10                	mov    (%eax),%dl
  801567:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80156c:	8b 45 10             	mov    0x10(%ebp),%eax
  80156f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801572:	89 55 10             	mov    %edx,0x10(%ebp)
  801575:	85 c0                	test   %eax,%eax
  801577:	75 e3                	jne    80155c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801579:	eb 23                	jmp    80159e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80157b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157e:	8d 50 01             	lea    0x1(%eax),%edx
  801581:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801584:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801587:	8d 4a 01             	lea    0x1(%edx),%ecx
  80158a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80158d:	8a 12                	mov    (%edx),%dl
  80158f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801591:	8b 45 10             	mov    0x10(%ebp),%eax
  801594:	8d 50 ff             	lea    -0x1(%eax),%edx
  801597:	89 55 10             	mov    %edx,0x10(%ebp)
  80159a:	85 c0                	test   %eax,%eax
  80159c:	75 dd                	jne    80157b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015b5:	eb 2a                	jmp    8015e1 <memcmp+0x3e>
		if (*s1 != *s2)
  8015b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ba:	8a 10                	mov    (%eax),%dl
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	38 c2                	cmp    %al,%dl
  8015c3:	74 16                	je     8015db <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	0f b6 d0             	movzbl %al,%edx
  8015cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	0f b6 c0             	movzbl %al,%eax
  8015d5:	29 c2                	sub    %eax,%edx
  8015d7:	89 d0                	mov    %edx,%eax
  8015d9:	eb 18                	jmp    8015f3 <memcmp+0x50>
		s1++, s2++;
  8015db:	ff 45 fc             	incl   -0x4(%ebp)
  8015de:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	75 c9                	jne    8015b7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801601:	01 d0                	add    %edx,%eax
  801603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801606:	eb 15                	jmp    80161d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	0f b6 d0             	movzbl %al,%edx
  801610:	8b 45 0c             	mov    0xc(%ebp),%eax
  801613:	0f b6 c0             	movzbl %al,%eax
  801616:	39 c2                	cmp    %eax,%edx
  801618:	74 0d                	je     801627 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80161a:	ff 45 08             	incl   0x8(%ebp)
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801623:	72 e3                	jb     801608 <memfind+0x13>
  801625:	eb 01                	jmp    801628 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801627:	90                   	nop
	return (void *) s;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801633:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80163a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801641:	eb 03                	jmp    801646 <strtol+0x19>
		s++;
  801643:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	3c 20                	cmp    $0x20,%al
  80164d:	74 f4                	je     801643 <strtol+0x16>
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8a 00                	mov    (%eax),%al
  801654:	3c 09                	cmp    $0x9,%al
  801656:	74 eb                	je     801643 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	8a 00                	mov    (%eax),%al
  80165d:	3c 2b                	cmp    $0x2b,%al
  80165f:	75 05                	jne    801666 <strtol+0x39>
		s++;
  801661:	ff 45 08             	incl   0x8(%ebp)
  801664:	eb 13                	jmp    801679 <strtol+0x4c>
	else if (*s == '-')
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	8a 00                	mov    (%eax),%al
  80166b:	3c 2d                	cmp    $0x2d,%al
  80166d:	75 0a                	jne    801679 <strtol+0x4c>
		s++, neg = 1;
  80166f:	ff 45 08             	incl   0x8(%ebp)
  801672:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801679:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80167d:	74 06                	je     801685 <strtol+0x58>
  80167f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801683:	75 20                	jne    8016a5 <strtol+0x78>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	3c 30                	cmp    $0x30,%al
  80168c:	75 17                	jne    8016a5 <strtol+0x78>
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	40                   	inc    %eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 78                	cmp    $0x78,%al
  801696:	75 0d                	jne    8016a5 <strtol+0x78>
		s += 2, base = 16;
  801698:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80169c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016a3:	eb 28                	jmp    8016cd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a9:	75 15                	jne    8016c0 <strtol+0x93>
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	8a 00                	mov    (%eax),%al
  8016b0:	3c 30                	cmp    $0x30,%al
  8016b2:	75 0c                	jne    8016c0 <strtol+0x93>
		s++, base = 8;
  8016b4:	ff 45 08             	incl   0x8(%ebp)
  8016b7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016be:	eb 0d                	jmp    8016cd <strtol+0xa0>
	else if (base == 0)
  8016c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c4:	75 07                	jne    8016cd <strtol+0xa0>
		base = 10;
  8016c6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	3c 2f                	cmp    $0x2f,%al
  8016d4:	7e 19                	jle    8016ef <strtol+0xc2>
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	3c 39                	cmp    $0x39,%al
  8016dd:	7f 10                	jg     8016ef <strtol+0xc2>
			dig = *s - '0';
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	0f be c0             	movsbl %al,%eax
  8016e7:	83 e8 30             	sub    $0x30,%eax
  8016ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ed:	eb 42                	jmp    801731 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	3c 60                	cmp    $0x60,%al
  8016f6:	7e 19                	jle    801711 <strtol+0xe4>
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	8a 00                	mov    (%eax),%al
  8016fd:	3c 7a                	cmp    $0x7a,%al
  8016ff:	7f 10                	jg     801711 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	0f be c0             	movsbl %al,%eax
  801709:	83 e8 57             	sub    $0x57,%eax
  80170c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80170f:	eb 20                	jmp    801731 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8a 00                	mov    (%eax),%al
  801716:	3c 40                	cmp    $0x40,%al
  801718:	7e 39                	jle    801753 <strtol+0x126>
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3c 5a                	cmp    $0x5a,%al
  801721:	7f 30                	jg     801753 <strtol+0x126>
			dig = *s - 'A' + 10;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	0f be c0             	movsbl %al,%eax
  80172b:	83 e8 37             	sub    $0x37,%eax
  80172e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	3b 45 10             	cmp    0x10(%ebp),%eax
  801737:	7d 19                	jge    801752 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801739:	ff 45 08             	incl   0x8(%ebp)
  80173c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801743:	89 c2                	mov    %eax,%edx
  801745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801748:	01 d0                	add    %edx,%eax
  80174a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80174d:	e9 7b ff ff ff       	jmp    8016cd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801752:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801753:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801757:	74 08                	je     801761 <strtol+0x134>
		*endptr = (char *) s;
  801759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175c:	8b 55 08             	mov    0x8(%ebp),%edx
  80175f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801761:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801765:	74 07                	je     80176e <strtol+0x141>
  801767:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176a:	f7 d8                	neg    %eax
  80176c:	eb 03                	jmp    801771 <strtol+0x144>
  80176e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <ltostr>:

void
ltostr(long value, char *str)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801779:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801780:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801787:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80178b:	79 13                	jns    8017a0 <ltostr+0x2d>
	{
		neg = 1;
  80178d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80179a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80179d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017a8:	99                   	cltd   
  8017a9:	f7 f9                	idiv   %ecx
  8017ab:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b1:	8d 50 01             	lea    0x1(%eax),%edx
  8017b4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b7:	89 c2                	mov    %eax,%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017c1:	83 c2 30             	add    $0x30,%edx
  8017c4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017ce:	f7 e9                	imul   %ecx
  8017d0:	c1 fa 02             	sar    $0x2,%edx
  8017d3:	89 c8                	mov    %ecx,%eax
  8017d5:	c1 f8 1f             	sar    $0x1f,%eax
  8017d8:	29 c2                	sub    %eax,%edx
  8017da:	89 d0                	mov    %edx,%eax
  8017dc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017e2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017e7:	f7 e9                	imul   %ecx
  8017e9:	c1 fa 02             	sar    $0x2,%edx
  8017ec:	89 c8                	mov    %ecx,%eax
  8017ee:	c1 f8 1f             	sar    $0x1f,%eax
  8017f1:	29 c2                	sub    %eax,%edx
  8017f3:	89 d0                	mov    %edx,%eax
  8017f5:	c1 e0 02             	shl    $0x2,%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	01 c0                	add    %eax,%eax
  8017fc:	29 c1                	sub    %eax,%ecx
  8017fe:	89 ca                	mov    %ecx,%edx
  801800:	85 d2                	test   %edx,%edx
  801802:	75 9c                	jne    8017a0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801804:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80180b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180e:	48                   	dec    %eax
  80180f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801812:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801816:	74 3d                	je     801855 <ltostr+0xe2>
		start = 1 ;
  801818:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80181f:	eb 34                	jmp    801855 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	01 d0                	add    %edx,%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80182e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	01 c2                	add    %eax,%edx
  801836:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183c:	01 c8                	add    %ecx,%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801842:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801845:	8b 45 0c             	mov    0xc(%ebp),%eax
  801848:	01 c2                	add    %eax,%edx
  80184a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80184d:	88 02                	mov    %al,(%edx)
		start++ ;
  80184f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801852:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801858:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80185b:	7c c4                	jl     801821 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80185d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801860:	8b 45 0c             	mov    0xc(%ebp),%eax
  801863:	01 d0                	add    %edx,%eax
  801865:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801868:	90                   	nop
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	e8 54 fa ff ff       	call   8012cd <strlen>
  801879:	83 c4 04             	add    $0x4,%esp
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	e8 46 fa ff ff       	call   8012cd <strlen>
  801887:	83 c4 04             	add    $0x4,%esp
  80188a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80188d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801894:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80189b:	eb 17                	jmp    8018b4 <strcconcat+0x49>
		final[s] = str1[s] ;
  80189d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a3:	01 c2                	add    %eax,%edx
  8018a5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	01 c8                	add    %ecx,%eax
  8018ad:	8a 00                	mov    (%eax),%al
  8018af:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018b1:	ff 45 fc             	incl   -0x4(%ebp)
  8018b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018ba:	7c e1                	jl     80189d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018ca:	eb 1f                	jmp    8018eb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cf:	8d 50 01             	lea    0x1(%eax),%edx
  8018d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018da:	01 c2                	add    %eax,%edx
  8018dc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e2:	01 c8                	add    %ecx,%eax
  8018e4:	8a 00                	mov    (%eax),%al
  8018e6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018e8:	ff 45 f8             	incl   -0x8(%ebp)
  8018eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018f1:	7c d9                	jl     8018cc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	01 d0                	add    %edx,%eax
  8018fb:	c6 00 00             	movb   $0x0,(%eax)
}
  8018fe:	90                   	nop
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801904:	8b 45 14             	mov    0x14(%ebp),%eax
  801907:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80190d:	8b 45 14             	mov    0x14(%ebp),%eax
  801910:	8b 00                	mov    (%eax),%eax
  801912:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801919:	8b 45 10             	mov    0x10(%ebp),%eax
  80191c:	01 d0                	add    %edx,%eax
  80191e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801924:	eb 0c                	jmp    801932 <strsplit+0x31>
			*string++ = 0;
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8d 50 01             	lea    0x1(%eax),%edx
  80192c:	89 55 08             	mov    %edx,0x8(%ebp)
  80192f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	84 c0                	test   %al,%al
  801939:	74 18                	je     801953 <strsplit+0x52>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	8a 00                	mov    (%eax),%al
  801940:	0f be c0             	movsbl %al,%eax
  801943:	50                   	push   %eax
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	e8 13 fb ff ff       	call   80145f <strchr>
  80194c:	83 c4 08             	add    $0x8,%esp
  80194f:	85 c0                	test   %eax,%eax
  801951:	75 d3                	jne    801926 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8a 00                	mov    (%eax),%al
  801958:	84 c0                	test   %al,%al
  80195a:	74 5a                	je     8019b6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	8b 00                	mov    (%eax),%eax
  801961:	83 f8 0f             	cmp    $0xf,%eax
  801964:	75 07                	jne    80196d <strsplit+0x6c>
		{
			return 0;
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
  80196b:	eb 66                	jmp    8019d3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80196d:	8b 45 14             	mov    0x14(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	8d 48 01             	lea    0x1(%eax),%ecx
  801975:	8b 55 14             	mov    0x14(%ebp),%edx
  801978:	89 0a                	mov    %ecx,(%edx)
  80197a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801981:	8b 45 10             	mov    0x10(%ebp),%eax
  801984:	01 c2                	add    %eax,%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80198b:	eb 03                	jmp    801990 <strsplit+0x8f>
			string++;
  80198d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8a 00                	mov    (%eax),%al
  801995:	84 c0                	test   %al,%al
  801997:	74 8b                	je     801924 <strsplit+0x23>
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f be c0             	movsbl %al,%eax
  8019a1:	50                   	push   %eax
  8019a2:	ff 75 0c             	pushl  0xc(%ebp)
  8019a5:	e8 b5 fa ff ff       	call   80145f <strchr>
  8019aa:	83 c4 08             	add    $0x8,%esp
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	74 dc                	je     80198d <strsplit+0x8c>
			string++;
	}
  8019b1:	e9 6e ff ff ff       	jmp    801924 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019b6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ba:	8b 00                	mov    (%eax),%eax
  8019bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c6:	01 d0                	add    %edx,%eax
  8019c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8019db:	a1 04 50 80 00       	mov    0x805004,%eax
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	74 1f                	je     801a03 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8019e4:	e8 1d 00 00 00       	call   801a06 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8019e9:	83 ec 0c             	sub    $0xc,%esp
  8019ec:	68 a4 40 80 00       	push   $0x8040a4
  8019f1:	e8 4f f0 ff ff       	call   800a45 <cprintf>
  8019f6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019f9:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801a00:	00 00 00 
	}
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801a0c:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801a13:	00 00 00 
  801a16:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801a1d:	00 00 00 
  801a20:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801a27:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801a2a:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801a31:	00 00 00 
  801a34:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801a3b:	00 00 00 
  801a3e:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801a45:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801a48:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a57:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a5c:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801a61:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801a68:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801a6b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a75:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801a7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a80:	ba 00 00 00 00       	mov    $0x0,%edx
  801a85:	f7 75 f0             	divl   -0x10(%ebp)
  801a88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a8b:	29 d0                	sub    %edx,%eax
  801a8d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801a90:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801a97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a9a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a9f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801aa4:	83 ec 04             	sub    $0x4,%esp
  801aa7:	6a 06                	push   $0x6
  801aa9:	ff 75 e8             	pushl  -0x18(%ebp)
  801aac:	50                   	push   %eax
  801aad:	e8 d4 05 00 00       	call   802086 <sys_allocate_chunk>
  801ab2:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ab5:	a1 20 51 80 00       	mov    0x805120,%eax
  801aba:	83 ec 0c             	sub    $0xc,%esp
  801abd:	50                   	push   %eax
  801abe:	e8 49 0c 00 00       	call   80270c <initialize_MemBlocksList>
  801ac3:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801ac6:	a1 48 51 80 00       	mov    0x805148,%eax
  801acb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801ace:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ad2:	75 14                	jne    801ae8 <initialize_dyn_block_system+0xe2>
  801ad4:	83 ec 04             	sub    $0x4,%esp
  801ad7:	68 c9 40 80 00       	push   $0x8040c9
  801adc:	6a 39                	push   $0x39
  801ade:	68 e7 40 80 00       	push   $0x8040e7
  801ae3:	e8 a9 ec ff ff       	call   800791 <_panic>
  801ae8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aeb:	8b 00                	mov    (%eax),%eax
  801aed:	85 c0                	test   %eax,%eax
  801aef:	74 10                	je     801b01 <initialize_dyn_block_system+0xfb>
  801af1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801af4:	8b 00                	mov    (%eax),%eax
  801af6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801af9:	8b 52 04             	mov    0x4(%edx),%edx
  801afc:	89 50 04             	mov    %edx,0x4(%eax)
  801aff:	eb 0b                	jmp    801b0c <initialize_dyn_block_system+0x106>
  801b01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b04:	8b 40 04             	mov    0x4(%eax),%eax
  801b07:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801b0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b0f:	8b 40 04             	mov    0x4(%eax),%eax
  801b12:	85 c0                	test   %eax,%eax
  801b14:	74 0f                	je     801b25 <initialize_dyn_block_system+0x11f>
  801b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b19:	8b 40 04             	mov    0x4(%eax),%eax
  801b1c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b1f:	8b 12                	mov    (%edx),%edx
  801b21:	89 10                	mov    %edx,(%eax)
  801b23:	eb 0a                	jmp    801b2f <initialize_dyn_block_system+0x129>
  801b25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b28:	8b 00                	mov    (%eax),%eax
  801b2a:	a3 48 51 80 00       	mov    %eax,0x805148
  801b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b42:	a1 54 51 80 00       	mov    0x805154,%eax
  801b47:	48                   	dec    %eax
  801b48:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801b4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b50:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801b57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b5a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801b61:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b65:	75 14                	jne    801b7b <initialize_dyn_block_system+0x175>
  801b67:	83 ec 04             	sub    $0x4,%esp
  801b6a:	68 f4 40 80 00       	push   $0x8040f4
  801b6f:	6a 3f                	push   $0x3f
  801b71:	68 e7 40 80 00       	push   $0x8040e7
  801b76:	e8 16 ec ff ff       	call   800791 <_panic>
  801b7b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801b81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b84:	89 10                	mov    %edx,(%eax)
  801b86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b89:	8b 00                	mov    (%eax),%eax
  801b8b:	85 c0                	test   %eax,%eax
  801b8d:	74 0d                	je     801b9c <initialize_dyn_block_system+0x196>
  801b8f:	a1 38 51 80 00       	mov    0x805138,%eax
  801b94:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b97:	89 50 04             	mov    %edx,0x4(%eax)
  801b9a:	eb 08                	jmp    801ba4 <initialize_dyn_block_system+0x19e>
  801b9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b9f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801ba4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ba7:	a3 38 51 80 00       	mov    %eax,0x805138
  801bac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801baf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801bb6:	a1 44 51 80 00       	mov    0x805144,%eax
  801bbb:	40                   	inc    %eax
  801bbc:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801bc1:	90                   	nop
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bca:	e8 06 fe ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801bcf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bd3:	75 07                	jne    801bdc <malloc+0x18>
  801bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bda:	eb 7d                	jmp    801c59 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801bdc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801be3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bea:	8b 55 08             	mov    0x8(%ebp),%edx
  801bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf0:	01 d0                	add    %edx,%eax
  801bf2:	48                   	dec    %eax
  801bf3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf9:	ba 00 00 00 00       	mov    $0x0,%edx
  801bfe:	f7 75 f0             	divl   -0x10(%ebp)
  801c01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c04:	29 d0                	sub    %edx,%eax
  801c06:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801c09:	e8 46 08 00 00       	call   802454 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c0e:	83 f8 01             	cmp    $0x1,%eax
  801c11:	75 07                	jne    801c1a <malloc+0x56>
  801c13:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801c1a:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801c1e:	75 34                	jne    801c54 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801c20:	83 ec 0c             	sub    $0xc,%esp
  801c23:	ff 75 e8             	pushl  -0x18(%ebp)
  801c26:	e8 73 0e 00 00       	call   802a9e <alloc_block_FF>
  801c2b:	83 c4 10             	add    $0x10,%esp
  801c2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801c31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c35:	74 16                	je     801c4d <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801c37:	83 ec 0c             	sub    $0xc,%esp
  801c3a:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c3d:	e8 ff 0b 00 00       	call   802841 <insert_sorted_allocList>
  801c42:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801c45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c48:	8b 40 08             	mov    0x8(%eax),%eax
  801c4b:	eb 0c                	jmp    801c59 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c52:	eb 05                	jmp    801c59 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801c54:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c70:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c75:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801c78:	83 ec 08             	sub    $0x8,%esp
  801c7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c7e:	68 40 50 80 00       	push   $0x805040
  801c83:	e8 61 0b 00 00       	call   8027e9 <find_block>
  801c88:	83 c4 10             	add    $0x10,%esp
  801c8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801c8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c92:	0f 84 a5 00 00 00    	je     801d3d <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c9b:	8b 40 0c             	mov    0xc(%eax),%eax
  801c9e:	83 ec 08             	sub    $0x8,%esp
  801ca1:	50                   	push   %eax
  801ca2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ca5:	e8 a4 03 00 00       	call   80204e <sys_free_user_mem>
  801caa:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801cad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cb1:	75 17                	jne    801cca <free+0x6f>
  801cb3:	83 ec 04             	sub    $0x4,%esp
  801cb6:	68 c9 40 80 00       	push   $0x8040c9
  801cbb:	68 87 00 00 00       	push   $0x87
  801cc0:	68 e7 40 80 00       	push   $0x8040e7
  801cc5:	e8 c7 ea ff ff       	call   800791 <_panic>
  801cca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ccd:	8b 00                	mov    (%eax),%eax
  801ccf:	85 c0                	test   %eax,%eax
  801cd1:	74 10                	je     801ce3 <free+0x88>
  801cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd6:	8b 00                	mov    (%eax),%eax
  801cd8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cdb:	8b 52 04             	mov    0x4(%edx),%edx
  801cde:	89 50 04             	mov    %edx,0x4(%eax)
  801ce1:	eb 0b                	jmp    801cee <free+0x93>
  801ce3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ce6:	8b 40 04             	mov    0x4(%eax),%eax
  801ce9:	a3 44 50 80 00       	mov    %eax,0x805044
  801cee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf1:	8b 40 04             	mov    0x4(%eax),%eax
  801cf4:	85 c0                	test   %eax,%eax
  801cf6:	74 0f                	je     801d07 <free+0xac>
  801cf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cfb:	8b 40 04             	mov    0x4(%eax),%eax
  801cfe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d01:	8b 12                	mov    (%edx),%edx
  801d03:	89 10                	mov    %edx,(%eax)
  801d05:	eb 0a                	jmp    801d11 <free+0xb6>
  801d07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d0a:	8b 00                	mov    (%eax),%eax
  801d0c:	a3 40 50 80 00       	mov    %eax,0x805040
  801d11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d24:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801d29:	48                   	dec    %eax
  801d2a:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801d2f:	83 ec 0c             	sub    $0xc,%esp
  801d32:	ff 75 ec             	pushl  -0x14(%ebp)
  801d35:	e8 37 12 00 00       	call   802f71 <insert_sorted_with_merge_freeList>
  801d3a:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801d3d:	90                   	nop
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	83 ec 38             	sub    $0x38,%esp
  801d46:	8b 45 10             	mov    0x10(%ebp),%eax
  801d49:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d4c:	e8 84 fc ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d55:	75 07                	jne    801d5e <smalloc+0x1e>
  801d57:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5c:	eb 7e                	jmp    801ddc <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801d5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801d65:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d72:	01 d0                	add    %edx,%eax
  801d74:	48                   	dec    %eax
  801d75:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d80:	f7 75 f0             	divl   -0x10(%ebp)
  801d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d86:	29 d0                	sub    %edx,%eax
  801d88:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801d8b:	e8 c4 06 00 00       	call   802454 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d90:	83 f8 01             	cmp    $0x1,%eax
  801d93:	75 42                	jne    801dd7 <smalloc+0x97>

		  va = malloc(newsize) ;
  801d95:	83 ec 0c             	sub    $0xc,%esp
  801d98:	ff 75 e8             	pushl  -0x18(%ebp)
  801d9b:	e8 24 fe ff ff       	call   801bc4 <malloc>
  801da0:	83 c4 10             	add    $0x10,%esp
  801da3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801da6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801daa:	74 24                	je     801dd0 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801dac:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801db0:	ff 75 e4             	pushl  -0x1c(%ebp)
  801db3:	50                   	push   %eax
  801db4:	ff 75 e8             	pushl  -0x18(%ebp)
  801db7:	ff 75 08             	pushl  0x8(%ebp)
  801dba:	e8 1a 04 00 00       	call   8021d9 <sys_createSharedObject>
  801dbf:	83 c4 10             	add    $0x10,%esp
  801dc2:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801dc5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dc9:	78 0c                	js     801dd7 <smalloc+0x97>
					  return va ;
  801dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dce:	eb 0c                	jmp    801ddc <smalloc+0x9c>
				 }
				 else
					return NULL;
  801dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd5:	eb 05                	jmp    801ddc <smalloc+0x9c>
	  }
		  return NULL ;
  801dd7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801de4:	e8 ec fb ff ff       	call   8019d5 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801de9:	83 ec 08             	sub    $0x8,%esp
  801dec:	ff 75 0c             	pushl  0xc(%ebp)
  801def:	ff 75 08             	pushl  0x8(%ebp)
  801df2:	e8 0c 04 00 00       	call   802203 <sys_getSizeOfSharedObject>
  801df7:	83 c4 10             	add    $0x10,%esp
  801dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801dfd:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801e01:	75 07                	jne    801e0a <sget+0x2c>
  801e03:	b8 00 00 00 00       	mov    $0x0,%eax
  801e08:	eb 75                	jmp    801e7f <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801e0a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801e11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e17:	01 d0                	add    %edx,%eax
  801e19:	48                   	dec    %eax
  801e1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e20:	ba 00 00 00 00       	mov    $0x0,%edx
  801e25:	f7 75 f0             	divl   -0x10(%ebp)
  801e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e2b:	29 d0                	sub    %edx,%eax
  801e2d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801e30:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801e37:	e8 18 06 00 00       	call   802454 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e3c:	83 f8 01             	cmp    $0x1,%eax
  801e3f:	75 39                	jne    801e7a <sget+0x9c>

		  va = malloc(newsize) ;
  801e41:	83 ec 0c             	sub    $0xc,%esp
  801e44:	ff 75 e8             	pushl  -0x18(%ebp)
  801e47:	e8 78 fd ff ff       	call   801bc4 <malloc>
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801e52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e56:	74 22                	je     801e7a <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801e58:	83 ec 04             	sub    $0x4,%esp
  801e5b:	ff 75 e0             	pushl  -0x20(%ebp)
  801e5e:	ff 75 0c             	pushl  0xc(%ebp)
  801e61:	ff 75 08             	pushl  0x8(%ebp)
  801e64:	e8 b7 03 00 00       	call   802220 <sys_getSharedObject>
  801e69:	83 c4 10             	add    $0x10,%esp
  801e6c:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801e6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e73:	78 05                	js     801e7a <sget+0x9c>
					  return va;
  801e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e78:	eb 05                	jmp    801e7f <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801e7a:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e87:	e8 49 fb ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e8c:	83 ec 04             	sub    $0x4,%esp
  801e8f:	68 18 41 80 00       	push   $0x804118
  801e94:	68 1e 01 00 00       	push   $0x11e
  801e99:	68 e7 40 80 00       	push   $0x8040e7
  801e9e:	e8 ee e8 ff ff       	call   800791 <_panic>

00801ea3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	68 40 41 80 00       	push   $0x804140
  801eb1:	68 32 01 00 00       	push   $0x132
  801eb6:	68 e7 40 80 00       	push   $0x8040e7
  801ebb:	e8 d1 e8 ff ff       	call   800791 <_panic>

00801ec0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec6:	83 ec 04             	sub    $0x4,%esp
  801ec9:	68 64 41 80 00       	push   $0x804164
  801ece:	68 3d 01 00 00       	push   $0x13d
  801ed3:	68 e7 40 80 00       	push   $0x8040e7
  801ed8:	e8 b4 e8 ff ff       	call   800791 <_panic>

00801edd <shrink>:

}
void shrink(uint32 newSize)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ee3:	83 ec 04             	sub    $0x4,%esp
  801ee6:	68 64 41 80 00       	push   $0x804164
  801eeb:	68 42 01 00 00       	push   $0x142
  801ef0:	68 e7 40 80 00       	push   $0x8040e7
  801ef5:	e8 97 e8 ff ff       	call   800791 <_panic>

00801efa <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f00:	83 ec 04             	sub    $0x4,%esp
  801f03:	68 64 41 80 00       	push   $0x804164
  801f08:	68 47 01 00 00       	push   $0x147
  801f0d:	68 e7 40 80 00       	push   $0x8040e7
  801f12:	e8 7a e8 ff ff       	call   800791 <_panic>

00801f17 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	57                   	push   %edi
  801f1b:	56                   	push   %esi
  801f1c:	53                   	push   %ebx
  801f1d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f20:	8b 45 08             	mov    0x8(%ebp),%eax
  801f23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f26:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f29:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f2c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f2f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f32:	cd 30                	int    $0x30
  801f34:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f3a:	83 c4 10             	add    $0x10,%esp
  801f3d:	5b                   	pop    %ebx
  801f3e:	5e                   	pop    %esi
  801f3f:	5f                   	pop    %edi
  801f40:	5d                   	pop    %ebp
  801f41:	c3                   	ret    

00801f42 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 04             	sub    $0x4,%esp
  801f48:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f4e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	52                   	push   %edx
  801f5a:	ff 75 0c             	pushl  0xc(%ebp)
  801f5d:	50                   	push   %eax
  801f5e:	6a 00                	push   $0x0
  801f60:	e8 b2 ff ff ff       	call   801f17 <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
}
  801f68:	90                   	nop
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <sys_cgetc>:

int
sys_cgetc(void)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 01                	push   $0x1
  801f7a:	e8 98 ff ff ff       	call   801f17 <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	52                   	push   %edx
  801f94:	50                   	push   %eax
  801f95:	6a 05                	push   $0x5
  801f97:	e8 7b ff ff ff       	call   801f17 <syscall>
  801f9c:	83 c4 18             	add    $0x18,%esp
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	56                   	push   %esi
  801fa5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fa6:	8b 75 18             	mov    0x18(%ebp),%esi
  801fa9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801faf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	56                   	push   %esi
  801fb6:	53                   	push   %ebx
  801fb7:	51                   	push   %ecx
  801fb8:	52                   	push   %edx
  801fb9:	50                   	push   %eax
  801fba:	6a 06                	push   $0x6
  801fbc:	e8 56 ff ff ff       	call   801f17 <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc7:	5b                   	pop    %ebx
  801fc8:	5e                   	pop    %esi
  801fc9:	5d                   	pop    %ebp
  801fca:	c3                   	ret    

00801fcb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	52                   	push   %edx
  801fdb:	50                   	push   %eax
  801fdc:	6a 07                	push   $0x7
  801fde:	e8 34 ff ff ff       	call   801f17 <syscall>
  801fe3:	83 c4 18             	add    $0x18,%esp
}
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	ff 75 0c             	pushl  0xc(%ebp)
  801ff4:	ff 75 08             	pushl  0x8(%ebp)
  801ff7:	6a 08                	push   $0x8
  801ff9:	e8 19 ff ff ff       	call   801f17 <syscall>
  801ffe:	83 c4 18             	add    $0x18,%esp
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 09                	push   $0x9
  802012:	e8 00 ff ff ff       	call   801f17 <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 0a                	push   $0xa
  80202b:	e8 e7 fe ff ff       	call   801f17 <syscall>
  802030:	83 c4 18             	add    $0x18,%esp
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 0b                	push   $0xb
  802044:	e8 ce fe ff ff       	call   801f17 <syscall>
  802049:	83 c4 18             	add    $0x18,%esp
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	ff 75 0c             	pushl  0xc(%ebp)
  80205a:	ff 75 08             	pushl  0x8(%ebp)
  80205d:	6a 0f                	push   $0xf
  80205f:	e8 b3 fe ff ff       	call   801f17 <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
	return;
  802067:	90                   	nop
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	ff 75 0c             	pushl  0xc(%ebp)
  802076:	ff 75 08             	pushl  0x8(%ebp)
  802079:	6a 10                	push   $0x10
  80207b:	e8 97 fe ff ff       	call   801f17 <syscall>
  802080:	83 c4 18             	add    $0x18,%esp
	return ;
  802083:	90                   	nop
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	ff 75 10             	pushl  0x10(%ebp)
  802090:	ff 75 0c             	pushl  0xc(%ebp)
  802093:	ff 75 08             	pushl  0x8(%ebp)
  802096:	6a 11                	push   $0x11
  802098:	e8 7a fe ff ff       	call   801f17 <syscall>
  80209d:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a0:	90                   	nop
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 0c                	push   $0xc
  8020b2:	e8 60 fe ff ff       	call   801f17 <syscall>
  8020b7:	83 c4 18             	add    $0x18,%esp
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	ff 75 08             	pushl  0x8(%ebp)
  8020ca:	6a 0d                	push   $0xd
  8020cc:	e8 46 fe ff ff       	call   801f17 <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 0e                	push   $0xe
  8020e5:	e8 2d fe ff ff       	call   801f17 <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
}
  8020ed:	90                   	nop
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 13                	push   $0x13
  8020ff:	e8 13 fe ff ff       	call   801f17 <syscall>
  802104:	83 c4 18             	add    $0x18,%esp
}
  802107:	90                   	nop
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 14                	push   $0x14
  802119:	e8 f9 fd ff ff       	call   801f17 <syscall>
  80211e:	83 c4 18             	add    $0x18,%esp
}
  802121:	90                   	nop
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <sys_cputc>:


void
sys_cputc(const char c)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	83 ec 04             	sub    $0x4,%esp
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802130:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 00                	push   $0x0
  80213c:	50                   	push   %eax
  80213d:	6a 15                	push   $0x15
  80213f:	e8 d3 fd ff ff       	call   801f17 <syscall>
  802144:	83 c4 18             	add    $0x18,%esp
}
  802147:	90                   	nop
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 16                	push   $0x16
  802159:	e8 b9 fd ff ff       	call   801f17 <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
}
  802161:	90                   	nop
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	ff 75 0c             	pushl  0xc(%ebp)
  802173:	50                   	push   %eax
  802174:	6a 17                	push   $0x17
  802176:	e8 9c fd ff ff       	call   801f17 <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802183:	8b 55 0c             	mov    0xc(%ebp),%edx
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	52                   	push   %edx
  802190:	50                   	push   %eax
  802191:	6a 1a                	push   $0x1a
  802193:	e8 7f fd ff ff       	call   801f17 <syscall>
  802198:	83 c4 18             	add    $0x18,%esp
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	52                   	push   %edx
  8021ad:	50                   	push   %eax
  8021ae:	6a 18                	push   $0x18
  8021b0:	e8 62 fd ff ff       	call   801f17 <syscall>
  8021b5:	83 c4 18             	add    $0x18,%esp
}
  8021b8:	90                   	nop
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	6a 00                	push   $0x0
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	52                   	push   %edx
  8021cb:	50                   	push   %eax
  8021cc:	6a 19                	push   $0x19
  8021ce:	e8 44 fd ff ff       	call   801f17 <syscall>
  8021d3:	83 c4 18             	add    $0x18,%esp
}
  8021d6:	90                   	nop
  8021d7:	c9                   	leave  
  8021d8:	c3                   	ret    

008021d9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	83 ec 04             	sub    $0x4,%esp
  8021df:	8b 45 10             	mov    0x10(%ebp),%eax
  8021e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021e5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021e8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	6a 00                	push   $0x0
  8021f1:	51                   	push   %ecx
  8021f2:	52                   	push   %edx
  8021f3:	ff 75 0c             	pushl  0xc(%ebp)
  8021f6:	50                   	push   %eax
  8021f7:	6a 1b                	push   $0x1b
  8021f9:	e8 19 fd ff ff       	call   801f17 <syscall>
  8021fe:	83 c4 18             	add    $0x18,%esp
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802206:	8b 55 0c             	mov    0xc(%ebp),%edx
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	52                   	push   %edx
  802213:	50                   	push   %eax
  802214:	6a 1c                	push   $0x1c
  802216:	e8 fc fc ff ff       	call   801f17 <syscall>
  80221b:	83 c4 18             	add    $0x18,%esp
}
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802223:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802226:	8b 55 0c             	mov    0xc(%ebp),%edx
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	51                   	push   %ecx
  802231:	52                   	push   %edx
  802232:	50                   	push   %eax
  802233:	6a 1d                	push   $0x1d
  802235:	e8 dd fc ff ff       	call   801f17 <syscall>
  80223a:	83 c4 18             	add    $0x18,%esp
}
  80223d:	c9                   	leave  
  80223e:	c3                   	ret    

0080223f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802242:	8b 55 0c             	mov    0xc(%ebp),%edx
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	52                   	push   %edx
  80224f:	50                   	push   %eax
  802250:	6a 1e                	push   $0x1e
  802252:	e8 c0 fc ff ff       	call   801f17 <syscall>
  802257:	83 c4 18             	add    $0x18,%esp
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 1f                	push   $0x1f
  80226b:	e8 a7 fc ff ff       	call   801f17 <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	6a 00                	push   $0x0
  80227d:	ff 75 14             	pushl  0x14(%ebp)
  802280:	ff 75 10             	pushl  0x10(%ebp)
  802283:	ff 75 0c             	pushl  0xc(%ebp)
  802286:	50                   	push   %eax
  802287:	6a 20                	push   $0x20
  802289:	e8 89 fc ff ff       	call   801f17 <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
}
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	50                   	push   %eax
  8022a2:	6a 21                	push   $0x21
  8022a4:	e8 6e fc ff ff       	call   801f17 <syscall>
  8022a9:	83 c4 18             	add    $0x18,%esp
}
  8022ac:	90                   	nop
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	50                   	push   %eax
  8022be:	6a 22                	push   $0x22
  8022c0:	e8 52 fc ff ff       	call   801f17 <syscall>
  8022c5:	83 c4 18             	add    $0x18,%esp
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 02                	push   $0x2
  8022d9:	e8 39 fc ff ff       	call   801f17 <syscall>
  8022de:	83 c4 18             	add    $0x18,%esp
}
  8022e1:	c9                   	leave  
  8022e2:	c3                   	ret    

008022e3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 03                	push   $0x3
  8022f2:	e8 20 fc ff ff       	call   801f17 <syscall>
  8022f7:	83 c4 18             	add    $0x18,%esp
}
  8022fa:	c9                   	leave  
  8022fb:	c3                   	ret    

008022fc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 04                	push   $0x4
  80230b:	e8 07 fc ff ff       	call   801f17 <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
}
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <sys_exit_env>:


void sys_exit_env(void)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 23                	push   $0x23
  802324:	e8 ee fb ff ff       	call   801f17 <syscall>
  802329:	83 c4 18             	add    $0x18,%esp
}
  80232c:	90                   	nop
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802335:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802338:	8d 50 04             	lea    0x4(%eax),%edx
  80233b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	52                   	push   %edx
  802345:	50                   	push   %eax
  802346:	6a 24                	push   $0x24
  802348:	e8 ca fb ff ff       	call   801f17 <syscall>
  80234d:	83 c4 18             	add    $0x18,%esp
	return result;
  802350:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802353:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802356:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802359:	89 01                	mov    %eax,(%ecx)
  80235b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	c9                   	leave  
  802362:	c2 04 00             	ret    $0x4

00802365 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	ff 75 10             	pushl  0x10(%ebp)
  80236f:	ff 75 0c             	pushl  0xc(%ebp)
  802372:	ff 75 08             	pushl  0x8(%ebp)
  802375:	6a 12                	push   $0x12
  802377:	e8 9b fb ff ff       	call   801f17 <syscall>
  80237c:	83 c4 18             	add    $0x18,%esp
	return ;
  80237f:	90                   	nop
}
  802380:	c9                   	leave  
  802381:	c3                   	ret    

00802382 <sys_rcr2>:
uint32 sys_rcr2()
{
  802382:	55                   	push   %ebp
  802383:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 25                	push   $0x25
  802391:	e8 81 fb ff ff       	call   801f17 <syscall>
  802396:	83 c4 18             	add    $0x18,%esp
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	83 ec 04             	sub    $0x4,%esp
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023a7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	50                   	push   %eax
  8023b4:	6a 26                	push   $0x26
  8023b6:	e8 5c fb ff ff       	call   801f17 <syscall>
  8023bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8023be:	90                   	nop
}
  8023bf:	c9                   	leave  
  8023c0:	c3                   	ret    

008023c1 <rsttst>:
void rsttst()
{
  8023c1:	55                   	push   %ebp
  8023c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 28                	push   $0x28
  8023d0:	e8 42 fb ff ff       	call   801f17 <syscall>
  8023d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d8:	90                   	nop
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	83 ec 04             	sub    $0x4,%esp
  8023e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8023e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023e7:	8b 55 18             	mov    0x18(%ebp),%edx
  8023ea:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023ee:	52                   	push   %edx
  8023ef:	50                   	push   %eax
  8023f0:	ff 75 10             	pushl  0x10(%ebp)
  8023f3:	ff 75 0c             	pushl  0xc(%ebp)
  8023f6:	ff 75 08             	pushl  0x8(%ebp)
  8023f9:	6a 27                	push   $0x27
  8023fb:	e8 17 fb ff ff       	call   801f17 <syscall>
  802400:	83 c4 18             	add    $0x18,%esp
	return ;
  802403:	90                   	nop
}
  802404:	c9                   	leave  
  802405:	c3                   	ret    

00802406 <chktst>:
void chktst(uint32 n)
{
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	ff 75 08             	pushl  0x8(%ebp)
  802414:	6a 29                	push   $0x29
  802416:	e8 fc fa ff ff       	call   801f17 <syscall>
  80241b:	83 c4 18             	add    $0x18,%esp
	return ;
  80241e:	90                   	nop
}
  80241f:	c9                   	leave  
  802420:	c3                   	ret    

00802421 <inctst>:

void inctst()
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 2a                	push   $0x2a
  802430:	e8 e2 fa ff ff       	call   801f17 <syscall>
  802435:	83 c4 18             	add    $0x18,%esp
	return ;
  802438:	90                   	nop
}
  802439:	c9                   	leave  
  80243a:	c3                   	ret    

0080243b <gettst>:
uint32 gettst()
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 2b                	push   $0x2b
  80244a:	e8 c8 fa ff ff       	call   801f17 <syscall>
  80244f:	83 c4 18             	add    $0x18,%esp
}
  802452:	c9                   	leave  
  802453:	c3                   	ret    

00802454 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
  802457:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 2c                	push   $0x2c
  802466:	e8 ac fa ff ff       	call   801f17 <syscall>
  80246b:	83 c4 18             	add    $0x18,%esp
  80246e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802471:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802475:	75 07                	jne    80247e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802477:	b8 01 00 00 00       	mov    $0x1,%eax
  80247c:	eb 05                	jmp    802483 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80247e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 2c                	push   $0x2c
  802497:	e8 7b fa ff ff       	call   801f17 <syscall>
  80249c:	83 c4 18             	add    $0x18,%esp
  80249f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024a2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024a6:	75 07                	jne    8024af <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024a8:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ad:	eb 05                	jmp    8024b4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 2c                	push   $0x2c
  8024c8:	e8 4a fa ff ff       	call   801f17 <syscall>
  8024cd:	83 c4 18             	add    $0x18,%esp
  8024d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024d3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024d7:	75 07                	jne    8024e0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8024de:	eb 05                	jmp    8024e5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e5:	c9                   	leave  
  8024e6:	c3                   	ret    

008024e7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024e7:	55                   	push   %ebp
  8024e8:	89 e5                	mov    %esp,%ebp
  8024ea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 2c                	push   $0x2c
  8024f9:	e8 19 fa ff ff       	call   801f17 <syscall>
  8024fe:	83 c4 18             	add    $0x18,%esp
  802501:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802504:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802508:	75 07                	jne    802511 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80250a:	b8 01 00 00 00       	mov    $0x1,%eax
  80250f:	eb 05                	jmp    802516 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802511:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	ff 75 08             	pushl  0x8(%ebp)
  802526:	6a 2d                	push   $0x2d
  802528:	e8 ea f9 ff ff       	call   801f17 <syscall>
  80252d:	83 c4 18             	add    $0x18,%esp
	return ;
  802530:	90                   	nop
}
  802531:	c9                   	leave  
  802532:	c3                   	ret    

00802533 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp
  802536:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802537:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80253a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80253d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	6a 00                	push   $0x0
  802545:	53                   	push   %ebx
  802546:	51                   	push   %ecx
  802547:	52                   	push   %edx
  802548:	50                   	push   %eax
  802549:	6a 2e                	push   $0x2e
  80254b:	e8 c7 f9 ff ff       	call   801f17 <syscall>
  802550:	83 c4 18             	add    $0x18,%esp
}
  802553:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80255b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80255e:	8b 45 08             	mov    0x8(%ebp),%eax
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	52                   	push   %edx
  802568:	50                   	push   %eax
  802569:	6a 2f                	push   $0x2f
  80256b:	e8 a7 f9 ff ff       	call   801f17 <syscall>
  802570:	83 c4 18             	add    $0x18,%esp
}
  802573:	c9                   	leave  
  802574:	c3                   	ret    

00802575 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
  802578:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80257b:	83 ec 0c             	sub    $0xc,%esp
  80257e:	68 74 41 80 00       	push   $0x804174
  802583:	e8 bd e4 ff ff       	call   800a45 <cprintf>
  802588:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80258b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802592:	83 ec 0c             	sub    $0xc,%esp
  802595:	68 a0 41 80 00       	push   $0x8041a0
  80259a:	e8 a6 e4 ff ff       	call   800a45 <cprintf>
  80259f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8025a2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025a6:	a1 38 51 80 00       	mov    0x805138,%eax
  8025ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ae:	eb 56                	jmp    802606 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025b4:	74 1c                	je     8025d2 <print_mem_block_lists+0x5d>
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	8b 50 08             	mov    0x8(%eax),%edx
  8025bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bf:	8b 48 08             	mov    0x8(%eax),%ecx
  8025c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c8:	01 c8                	add    %ecx,%eax
  8025ca:	39 c2                	cmp    %eax,%edx
  8025cc:	73 04                	jae    8025d2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8025ce:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 50 08             	mov    0x8(%eax),%edx
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 40 0c             	mov    0xc(%eax),%eax
  8025de:	01 c2                	add    %eax,%edx
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	8b 40 08             	mov    0x8(%eax),%eax
  8025e6:	83 ec 04             	sub    $0x4,%esp
  8025e9:	52                   	push   %edx
  8025ea:	50                   	push   %eax
  8025eb:	68 b5 41 80 00       	push   $0x8041b5
  8025f0:	e8 50 e4 ff ff       	call   800a45 <cprintf>
  8025f5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025fe:	a1 40 51 80 00       	mov    0x805140,%eax
  802603:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802606:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260a:	74 07                	je     802613 <print_mem_block_lists+0x9e>
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 00                	mov    (%eax),%eax
  802611:	eb 05                	jmp    802618 <print_mem_block_lists+0xa3>
  802613:	b8 00 00 00 00       	mov    $0x0,%eax
  802618:	a3 40 51 80 00       	mov    %eax,0x805140
  80261d:	a1 40 51 80 00       	mov    0x805140,%eax
  802622:	85 c0                	test   %eax,%eax
  802624:	75 8a                	jne    8025b0 <print_mem_block_lists+0x3b>
  802626:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262a:	75 84                	jne    8025b0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80262c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802630:	75 10                	jne    802642 <print_mem_block_lists+0xcd>
  802632:	83 ec 0c             	sub    $0xc,%esp
  802635:	68 c4 41 80 00       	push   $0x8041c4
  80263a:	e8 06 e4 ff ff       	call   800a45 <cprintf>
  80263f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802642:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802649:	83 ec 0c             	sub    $0xc,%esp
  80264c:	68 e8 41 80 00       	push   $0x8041e8
  802651:	e8 ef e3 ff ff       	call   800a45 <cprintf>
  802656:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802659:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80265d:	a1 40 50 80 00       	mov    0x805040,%eax
  802662:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802665:	eb 56                	jmp    8026bd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802667:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80266b:	74 1c                	je     802689 <print_mem_block_lists+0x114>
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	8b 50 08             	mov    0x8(%eax),%edx
  802673:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802676:	8b 48 08             	mov    0x8(%eax),%ecx
  802679:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267c:	8b 40 0c             	mov    0xc(%eax),%eax
  80267f:	01 c8                	add    %ecx,%eax
  802681:	39 c2                	cmp    %eax,%edx
  802683:	73 04                	jae    802689 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802685:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 50 08             	mov    0x8(%eax),%edx
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 40 0c             	mov    0xc(%eax),%eax
  802695:	01 c2                	add    %eax,%edx
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	8b 40 08             	mov    0x8(%eax),%eax
  80269d:	83 ec 04             	sub    $0x4,%esp
  8026a0:	52                   	push   %edx
  8026a1:	50                   	push   %eax
  8026a2:	68 b5 41 80 00       	push   $0x8041b5
  8026a7:	e8 99 e3 ff ff       	call   800a45 <cprintf>
  8026ac:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026b5:	a1 48 50 80 00       	mov    0x805048,%eax
  8026ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c1:	74 07                	je     8026ca <print_mem_block_lists+0x155>
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 00                	mov    (%eax),%eax
  8026c8:	eb 05                	jmp    8026cf <print_mem_block_lists+0x15a>
  8026ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cf:	a3 48 50 80 00       	mov    %eax,0x805048
  8026d4:	a1 48 50 80 00       	mov    0x805048,%eax
  8026d9:	85 c0                	test   %eax,%eax
  8026db:	75 8a                	jne    802667 <print_mem_block_lists+0xf2>
  8026dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e1:	75 84                	jne    802667 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026e3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026e7:	75 10                	jne    8026f9 <print_mem_block_lists+0x184>
  8026e9:	83 ec 0c             	sub    $0xc,%esp
  8026ec:	68 00 42 80 00       	push   $0x804200
  8026f1:	e8 4f e3 ff ff       	call   800a45 <cprintf>
  8026f6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026f9:	83 ec 0c             	sub    $0xc,%esp
  8026fc:	68 74 41 80 00       	push   $0x804174
  802701:	e8 3f e3 ff ff       	call   800a45 <cprintf>
  802706:	83 c4 10             	add    $0x10,%esp

}
  802709:	90                   	nop
  80270a:	c9                   	leave  
  80270b:	c3                   	ret    

0080270c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80270c:	55                   	push   %ebp
  80270d:	89 e5                	mov    %esp,%ebp
  80270f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802712:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802719:	00 00 00 
  80271c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802723:	00 00 00 
  802726:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80272d:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802730:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802737:	e9 9e 00 00 00       	jmp    8027da <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80273c:	a1 50 50 80 00       	mov    0x805050,%eax
  802741:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802744:	c1 e2 04             	shl    $0x4,%edx
  802747:	01 d0                	add    %edx,%eax
  802749:	85 c0                	test   %eax,%eax
  80274b:	75 14                	jne    802761 <initialize_MemBlocksList+0x55>
  80274d:	83 ec 04             	sub    $0x4,%esp
  802750:	68 28 42 80 00       	push   $0x804228
  802755:	6a 47                	push   $0x47
  802757:	68 4b 42 80 00       	push   $0x80424b
  80275c:	e8 30 e0 ff ff       	call   800791 <_panic>
  802761:	a1 50 50 80 00       	mov    0x805050,%eax
  802766:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802769:	c1 e2 04             	shl    $0x4,%edx
  80276c:	01 d0                	add    %edx,%eax
  80276e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802774:	89 10                	mov    %edx,(%eax)
  802776:	8b 00                	mov    (%eax),%eax
  802778:	85 c0                	test   %eax,%eax
  80277a:	74 18                	je     802794 <initialize_MemBlocksList+0x88>
  80277c:	a1 48 51 80 00       	mov    0x805148,%eax
  802781:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802787:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80278a:	c1 e1 04             	shl    $0x4,%ecx
  80278d:	01 ca                	add    %ecx,%edx
  80278f:	89 50 04             	mov    %edx,0x4(%eax)
  802792:	eb 12                	jmp    8027a6 <initialize_MemBlocksList+0x9a>
  802794:	a1 50 50 80 00       	mov    0x805050,%eax
  802799:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279c:	c1 e2 04             	shl    $0x4,%edx
  80279f:	01 d0                	add    %edx,%eax
  8027a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027a6:	a1 50 50 80 00       	mov    0x805050,%eax
  8027ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ae:	c1 e2 04             	shl    $0x4,%edx
  8027b1:	01 d0                	add    %edx,%eax
  8027b3:	a3 48 51 80 00       	mov    %eax,0x805148
  8027b8:	a1 50 50 80 00       	mov    0x805050,%eax
  8027bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c0:	c1 e2 04             	shl    $0x4,%edx
  8027c3:	01 d0                	add    %edx,%eax
  8027c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8027d1:	40                   	inc    %eax
  8027d2:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8027d7:	ff 45 f4             	incl   -0xc(%ebp)
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e0:	0f 82 56 ff ff ff    	jb     80273c <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8027e6:	90                   	nop
  8027e7:	c9                   	leave  
  8027e8:	c3                   	ret    

008027e9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027e9:	55                   	push   %ebp
  8027ea:	89 e5                	mov    %esp,%ebp
  8027ec:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8027ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f2:	8b 00                	mov    (%eax),%eax
  8027f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027f7:	eb 19                	jmp    802812 <find_block+0x29>
	{
		if(element->sva == va){
  8027f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027fc:	8b 40 08             	mov    0x8(%eax),%eax
  8027ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802802:	75 05                	jne    802809 <find_block+0x20>
			 		return element;
  802804:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802807:	eb 36                	jmp    80283f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802809:	8b 45 08             	mov    0x8(%ebp),%eax
  80280c:	8b 40 08             	mov    0x8(%eax),%eax
  80280f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802812:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802816:	74 07                	je     80281f <find_block+0x36>
  802818:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80281b:	8b 00                	mov    (%eax),%eax
  80281d:	eb 05                	jmp    802824 <find_block+0x3b>
  80281f:	b8 00 00 00 00       	mov    $0x0,%eax
  802824:	8b 55 08             	mov    0x8(%ebp),%edx
  802827:	89 42 08             	mov    %eax,0x8(%edx)
  80282a:	8b 45 08             	mov    0x8(%ebp),%eax
  80282d:	8b 40 08             	mov    0x8(%eax),%eax
  802830:	85 c0                	test   %eax,%eax
  802832:	75 c5                	jne    8027f9 <find_block+0x10>
  802834:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802838:	75 bf                	jne    8027f9 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80283f:	c9                   	leave  
  802840:	c3                   	ret    

00802841 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802841:	55                   	push   %ebp
  802842:	89 e5                	mov    %esp,%ebp
  802844:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802847:	a1 44 50 80 00       	mov    0x805044,%eax
  80284c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  80284f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802854:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802857:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80285b:	74 0a                	je     802867 <insert_sorted_allocList+0x26>
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	8b 40 08             	mov    0x8(%eax),%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	75 65                	jne    8028cc <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802867:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80286b:	75 14                	jne    802881 <insert_sorted_allocList+0x40>
  80286d:	83 ec 04             	sub    $0x4,%esp
  802870:	68 28 42 80 00       	push   $0x804228
  802875:	6a 6e                	push   $0x6e
  802877:	68 4b 42 80 00       	push   $0x80424b
  80287c:	e8 10 df ff ff       	call   800791 <_panic>
  802881:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802887:	8b 45 08             	mov    0x8(%ebp),%eax
  80288a:	89 10                	mov    %edx,(%eax)
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	85 c0                	test   %eax,%eax
  802893:	74 0d                	je     8028a2 <insert_sorted_allocList+0x61>
  802895:	a1 40 50 80 00       	mov    0x805040,%eax
  80289a:	8b 55 08             	mov    0x8(%ebp),%edx
  80289d:	89 50 04             	mov    %edx,0x4(%eax)
  8028a0:	eb 08                	jmp    8028aa <insert_sorted_allocList+0x69>
  8028a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a5:	a3 44 50 80 00       	mov    %eax,0x805044
  8028aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ad:	a3 40 50 80 00       	mov    %eax,0x805040
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028bc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028c1:	40                   	inc    %eax
  8028c2:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8028c7:	e9 cf 01 00 00       	jmp    802a9b <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8028cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cf:	8b 50 08             	mov    0x8(%eax),%edx
  8028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d5:	8b 40 08             	mov    0x8(%eax),%eax
  8028d8:	39 c2                	cmp    %eax,%edx
  8028da:	73 65                	jae    802941 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8028dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028e0:	75 14                	jne    8028f6 <insert_sorted_allocList+0xb5>
  8028e2:	83 ec 04             	sub    $0x4,%esp
  8028e5:	68 64 42 80 00       	push   $0x804264
  8028ea:	6a 72                	push   $0x72
  8028ec:	68 4b 42 80 00       	push   $0x80424b
  8028f1:	e8 9b de ff ff       	call   800791 <_panic>
  8028f6:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ff:	89 50 04             	mov    %edx,0x4(%eax)
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	8b 40 04             	mov    0x4(%eax),%eax
  802908:	85 c0                	test   %eax,%eax
  80290a:	74 0c                	je     802918 <insert_sorted_allocList+0xd7>
  80290c:	a1 44 50 80 00       	mov    0x805044,%eax
  802911:	8b 55 08             	mov    0x8(%ebp),%edx
  802914:	89 10                	mov    %edx,(%eax)
  802916:	eb 08                	jmp    802920 <insert_sorted_allocList+0xdf>
  802918:	8b 45 08             	mov    0x8(%ebp),%eax
  80291b:	a3 40 50 80 00       	mov    %eax,0x805040
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	a3 44 50 80 00       	mov    %eax,0x805044
  802928:	8b 45 08             	mov    0x8(%ebp),%eax
  80292b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802931:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802936:	40                   	inc    %eax
  802937:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  80293c:	e9 5a 01 00 00       	jmp    802a9b <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802944:	8b 50 08             	mov    0x8(%eax),%edx
  802947:	8b 45 08             	mov    0x8(%ebp),%eax
  80294a:	8b 40 08             	mov    0x8(%eax),%eax
  80294d:	39 c2                	cmp    %eax,%edx
  80294f:	75 70                	jne    8029c1 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802951:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802955:	74 06                	je     80295d <insert_sorted_allocList+0x11c>
  802957:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80295b:	75 14                	jne    802971 <insert_sorted_allocList+0x130>
  80295d:	83 ec 04             	sub    $0x4,%esp
  802960:	68 88 42 80 00       	push   $0x804288
  802965:	6a 75                	push   $0x75
  802967:	68 4b 42 80 00       	push   $0x80424b
  80296c:	e8 20 de ff ff       	call   800791 <_panic>
  802971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802974:	8b 10                	mov    (%eax),%edx
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	89 10                	mov    %edx,(%eax)
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	85 c0                	test   %eax,%eax
  802982:	74 0b                	je     80298f <insert_sorted_allocList+0x14e>
  802984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	8b 55 08             	mov    0x8(%ebp),%edx
  80298c:	89 50 04             	mov    %edx,0x4(%eax)
  80298f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802992:	8b 55 08             	mov    0x8(%ebp),%edx
  802995:	89 10                	mov    %edx,(%eax)
  802997:	8b 45 08             	mov    0x8(%ebp),%eax
  80299a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80299d:	89 50 04             	mov    %edx,0x4(%eax)
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	8b 00                	mov    (%eax),%eax
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	75 08                	jne    8029b1 <insert_sorted_allocList+0x170>
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	a3 44 50 80 00       	mov    %eax,0x805044
  8029b1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029b6:	40                   	inc    %eax
  8029b7:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8029bc:	e9 da 00 00 00       	jmp    802a9b <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8029c1:	a1 40 50 80 00       	mov    0x805040,%eax
  8029c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c9:	e9 9d 00 00 00       	jmp    802a6b <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 00                	mov    (%eax),%eax
  8029d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	8b 50 08             	mov    0x8(%eax),%edx
  8029dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029df:	8b 40 08             	mov    0x8(%eax),%eax
  8029e2:	39 c2                	cmp    %eax,%edx
  8029e4:	76 7d                	jbe    802a63 <insert_sorted_allocList+0x222>
  8029e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e9:	8b 50 08             	mov    0x8(%eax),%edx
  8029ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ef:	8b 40 08             	mov    0x8(%eax),%eax
  8029f2:	39 c2                	cmp    %eax,%edx
  8029f4:	73 6d                	jae    802a63 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8029f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fa:	74 06                	je     802a02 <insert_sorted_allocList+0x1c1>
  8029fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a00:	75 14                	jne    802a16 <insert_sorted_allocList+0x1d5>
  802a02:	83 ec 04             	sub    $0x4,%esp
  802a05:	68 88 42 80 00       	push   $0x804288
  802a0a:	6a 7c                	push   $0x7c
  802a0c:	68 4b 42 80 00       	push   $0x80424b
  802a11:	e8 7b dd ff ff       	call   800791 <_panic>
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 10                	mov    (%eax),%edx
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	89 10                	mov    %edx,(%eax)
  802a20:	8b 45 08             	mov    0x8(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	74 0b                	je     802a34 <insert_sorted_allocList+0x1f3>
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 00                	mov    (%eax),%eax
  802a2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a31:	89 50 04             	mov    %edx,0x4(%eax)
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 55 08             	mov    0x8(%ebp),%edx
  802a3a:	89 10                	mov    %edx,(%eax)
  802a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a42:	89 50 04             	mov    %edx,0x4(%eax)
  802a45:	8b 45 08             	mov    0x8(%ebp),%eax
  802a48:	8b 00                	mov    (%eax),%eax
  802a4a:	85 c0                	test   %eax,%eax
  802a4c:	75 08                	jne    802a56 <insert_sorted_allocList+0x215>
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	a3 44 50 80 00       	mov    %eax,0x805044
  802a56:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a5b:	40                   	inc    %eax
  802a5c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802a61:	eb 38                	jmp    802a9b <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802a63:	a1 48 50 80 00       	mov    0x805048,%eax
  802a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6f:	74 07                	je     802a78 <insert_sorted_allocList+0x237>
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 00                	mov    (%eax),%eax
  802a76:	eb 05                	jmp    802a7d <insert_sorted_allocList+0x23c>
  802a78:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7d:	a3 48 50 80 00       	mov    %eax,0x805048
  802a82:	a1 48 50 80 00       	mov    0x805048,%eax
  802a87:	85 c0                	test   %eax,%eax
  802a89:	0f 85 3f ff ff ff    	jne    8029ce <insert_sorted_allocList+0x18d>
  802a8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a93:	0f 85 35 ff ff ff    	jne    8029ce <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802a99:	eb 00                	jmp    802a9b <insert_sorted_allocList+0x25a>
  802a9b:	90                   	nop
  802a9c:	c9                   	leave  
  802a9d:	c3                   	ret    

00802a9e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a9e:	55                   	push   %ebp
  802a9f:	89 e5                	mov    %esp,%ebp
  802aa1:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802aa4:	a1 38 51 80 00       	mov    0x805138,%eax
  802aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aac:	e9 6b 02 00 00       	jmp    802d1c <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aba:	0f 85 90 00 00 00    	jne    802b50 <alloc_block_FF+0xb2>
			  temp=element;
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802ac6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aca:	75 17                	jne    802ae3 <alloc_block_FF+0x45>
  802acc:	83 ec 04             	sub    $0x4,%esp
  802acf:	68 bc 42 80 00       	push   $0x8042bc
  802ad4:	68 92 00 00 00       	push   $0x92
  802ad9:	68 4b 42 80 00       	push   $0x80424b
  802ade:	e8 ae dc ff ff       	call   800791 <_panic>
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 00                	mov    (%eax),%eax
  802ae8:	85 c0                	test   %eax,%eax
  802aea:	74 10                	je     802afc <alloc_block_FF+0x5e>
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 00                	mov    (%eax),%eax
  802af1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af4:	8b 52 04             	mov    0x4(%edx),%edx
  802af7:	89 50 04             	mov    %edx,0x4(%eax)
  802afa:	eb 0b                	jmp    802b07 <alloc_block_FF+0x69>
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	8b 40 04             	mov    0x4(%eax),%eax
  802b02:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 40 04             	mov    0x4(%eax),%eax
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	74 0f                	je     802b20 <alloc_block_FF+0x82>
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	8b 40 04             	mov    0x4(%eax),%eax
  802b17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1a:	8b 12                	mov    (%edx),%edx
  802b1c:	89 10                	mov    %edx,(%eax)
  802b1e:	eb 0a                	jmp    802b2a <alloc_block_FF+0x8c>
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 00                	mov    (%eax),%eax
  802b25:	a3 38 51 80 00       	mov    %eax,0x805138
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3d:	a1 44 51 80 00       	mov    0x805144,%eax
  802b42:	48                   	dec    %eax
  802b43:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802b48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4b:	e9 ff 01 00 00       	jmp    802d4f <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	8b 40 0c             	mov    0xc(%eax),%eax
  802b56:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b59:	0f 86 b5 01 00 00    	jbe    802d14 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8b 40 0c             	mov    0xc(%eax),%eax
  802b65:	2b 45 08             	sub    0x8(%ebp),%eax
  802b68:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802b6b:	a1 48 51 80 00       	mov    0x805148,%eax
  802b70:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802b73:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b77:	75 17                	jne    802b90 <alloc_block_FF+0xf2>
  802b79:	83 ec 04             	sub    $0x4,%esp
  802b7c:	68 bc 42 80 00       	push   $0x8042bc
  802b81:	68 99 00 00 00       	push   $0x99
  802b86:	68 4b 42 80 00       	push   $0x80424b
  802b8b:	e8 01 dc ff ff       	call   800791 <_panic>
  802b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b93:	8b 00                	mov    (%eax),%eax
  802b95:	85 c0                	test   %eax,%eax
  802b97:	74 10                	je     802ba9 <alloc_block_FF+0x10b>
  802b99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9c:	8b 00                	mov    (%eax),%eax
  802b9e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ba1:	8b 52 04             	mov    0x4(%edx),%edx
  802ba4:	89 50 04             	mov    %edx,0x4(%eax)
  802ba7:	eb 0b                	jmp    802bb4 <alloc_block_FF+0x116>
  802ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bac:	8b 40 04             	mov    0x4(%eax),%eax
  802baf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb7:	8b 40 04             	mov    0x4(%eax),%eax
  802bba:	85 c0                	test   %eax,%eax
  802bbc:	74 0f                	je     802bcd <alloc_block_FF+0x12f>
  802bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc1:	8b 40 04             	mov    0x4(%eax),%eax
  802bc4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bc7:	8b 12                	mov    (%edx),%edx
  802bc9:	89 10                	mov    %edx,(%eax)
  802bcb:	eb 0a                	jmp    802bd7 <alloc_block_FF+0x139>
  802bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd0:	8b 00                	mov    (%eax),%eax
  802bd2:	a3 48 51 80 00       	mov    %eax,0x805148
  802bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bea:	a1 54 51 80 00       	mov    0x805154,%eax
  802bef:	48                   	dec    %eax
  802bf0:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802bf5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bf9:	75 17                	jne    802c12 <alloc_block_FF+0x174>
  802bfb:	83 ec 04             	sub    $0x4,%esp
  802bfe:	68 64 42 80 00       	push   $0x804264
  802c03:	68 9a 00 00 00       	push   $0x9a
  802c08:	68 4b 42 80 00       	push   $0x80424b
  802c0d:	e8 7f db ff ff       	call   800791 <_panic>
  802c12:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802c18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1b:	89 50 04             	mov    %edx,0x4(%eax)
  802c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c21:	8b 40 04             	mov    0x4(%eax),%eax
  802c24:	85 c0                	test   %eax,%eax
  802c26:	74 0c                	je     802c34 <alloc_block_FF+0x196>
  802c28:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c30:	89 10                	mov    %edx,(%eax)
  802c32:	eb 08                	jmp    802c3c <alloc_block_FF+0x19e>
  802c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c37:	a3 38 51 80 00       	mov    %eax,0x805138
  802c3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c4d:	a1 44 51 80 00       	mov    0x805144,%eax
  802c52:	40                   	inc    %eax
  802c53:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5e:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c64:	8b 50 08             	mov    0x8(%eax),%edx
  802c67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6a:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c73:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	8b 50 08             	mov    0x8(%eax),%edx
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	01 c2                	add    %eax,%edx
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802c87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802c8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c91:	75 17                	jne    802caa <alloc_block_FF+0x20c>
  802c93:	83 ec 04             	sub    $0x4,%esp
  802c96:	68 bc 42 80 00       	push   $0x8042bc
  802c9b:	68 a2 00 00 00       	push   $0xa2
  802ca0:	68 4b 42 80 00       	push   $0x80424b
  802ca5:	e8 e7 da ff ff       	call   800791 <_panic>
  802caa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cad:	8b 00                	mov    (%eax),%eax
  802caf:	85 c0                	test   %eax,%eax
  802cb1:	74 10                	je     802cc3 <alloc_block_FF+0x225>
  802cb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cbb:	8b 52 04             	mov    0x4(%edx),%edx
  802cbe:	89 50 04             	mov    %edx,0x4(%eax)
  802cc1:	eb 0b                	jmp    802cce <alloc_block_FF+0x230>
  802cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc6:	8b 40 04             	mov    0x4(%eax),%eax
  802cc9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd1:	8b 40 04             	mov    0x4(%eax),%eax
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	74 0f                	je     802ce7 <alloc_block_FF+0x249>
  802cd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdb:	8b 40 04             	mov    0x4(%eax),%eax
  802cde:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce1:	8b 12                	mov    (%edx),%edx
  802ce3:	89 10                	mov    %edx,(%eax)
  802ce5:	eb 0a                	jmp    802cf1 <alloc_block_FF+0x253>
  802ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cea:	8b 00                	mov    (%eax),%eax
  802cec:	a3 38 51 80 00       	mov    %eax,0x805138
  802cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d04:	a1 44 51 80 00       	mov    0x805144,%eax
  802d09:	48                   	dec    %eax
  802d0a:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802d0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d12:	eb 3b                	jmp    802d4f <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802d14:	a1 40 51 80 00       	mov    0x805140,%eax
  802d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d20:	74 07                	je     802d29 <alloc_block_FF+0x28b>
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	eb 05                	jmp    802d2e <alloc_block_FF+0x290>
  802d29:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2e:	a3 40 51 80 00       	mov    %eax,0x805140
  802d33:	a1 40 51 80 00       	mov    0x805140,%eax
  802d38:	85 c0                	test   %eax,%eax
  802d3a:	0f 85 71 fd ff ff    	jne    802ab1 <alloc_block_FF+0x13>
  802d40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d44:	0f 85 67 fd ff ff    	jne    802ab1 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802d4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d4f:	c9                   	leave  
  802d50:	c3                   	ret    

00802d51 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802d51:	55                   	push   %ebp
  802d52:	89 e5                	mov    %esp,%ebp
  802d54:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802d57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802d5e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802d65:	a1 38 51 80 00       	mov    0x805138,%eax
  802d6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802d6d:	e9 d3 00 00 00       	jmp    802e45 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802d72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d75:	8b 40 0c             	mov    0xc(%eax),%eax
  802d78:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d7b:	0f 85 90 00 00 00    	jne    802e11 <alloc_block_BF+0xc0>
	   temp = element;
  802d81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d84:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802d87:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d8b:	75 17                	jne    802da4 <alloc_block_BF+0x53>
  802d8d:	83 ec 04             	sub    $0x4,%esp
  802d90:	68 bc 42 80 00       	push   $0x8042bc
  802d95:	68 bd 00 00 00       	push   $0xbd
  802d9a:	68 4b 42 80 00       	push   $0x80424b
  802d9f:	e8 ed d9 ff ff       	call   800791 <_panic>
  802da4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da7:	8b 00                	mov    (%eax),%eax
  802da9:	85 c0                	test   %eax,%eax
  802dab:	74 10                	je     802dbd <alloc_block_BF+0x6c>
  802dad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db0:	8b 00                	mov    (%eax),%eax
  802db2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802db5:	8b 52 04             	mov    0x4(%edx),%edx
  802db8:	89 50 04             	mov    %edx,0x4(%eax)
  802dbb:	eb 0b                	jmp    802dc8 <alloc_block_BF+0x77>
  802dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc0:	8b 40 04             	mov    0x4(%eax),%eax
  802dc3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dcb:	8b 40 04             	mov    0x4(%eax),%eax
  802dce:	85 c0                	test   %eax,%eax
  802dd0:	74 0f                	je     802de1 <alloc_block_BF+0x90>
  802dd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd5:	8b 40 04             	mov    0x4(%eax),%eax
  802dd8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ddb:	8b 12                	mov    (%edx),%edx
  802ddd:	89 10                	mov    %edx,(%eax)
  802ddf:	eb 0a                	jmp    802deb <alloc_block_BF+0x9a>
  802de1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de4:	8b 00                	mov    (%eax),%eax
  802de6:	a3 38 51 80 00       	mov    %eax,0x805138
  802deb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfe:	a1 44 51 80 00       	mov    0x805144,%eax
  802e03:	48                   	dec    %eax
  802e04:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802e09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e0c:	e9 41 01 00 00       	jmp    802f52 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802e11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e14:	8b 40 0c             	mov    0xc(%eax),%eax
  802e17:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e1a:	76 21                	jbe    802e3d <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802e1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e22:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e25:	73 16                	jae    802e3d <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802e27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802e30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e33:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802e36:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802e3d:	a1 40 51 80 00       	mov    0x805140,%eax
  802e42:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802e45:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e49:	74 07                	je     802e52 <alloc_block_BF+0x101>
  802e4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e4e:	8b 00                	mov    (%eax),%eax
  802e50:	eb 05                	jmp    802e57 <alloc_block_BF+0x106>
  802e52:	b8 00 00 00 00       	mov    $0x0,%eax
  802e57:	a3 40 51 80 00       	mov    %eax,0x805140
  802e5c:	a1 40 51 80 00       	mov    0x805140,%eax
  802e61:	85 c0                	test   %eax,%eax
  802e63:	0f 85 09 ff ff ff    	jne    802d72 <alloc_block_BF+0x21>
  802e69:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e6d:	0f 85 ff fe ff ff    	jne    802d72 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802e73:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802e77:	0f 85 d0 00 00 00    	jne    802f4d <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e80:	8b 40 0c             	mov    0xc(%eax),%eax
  802e83:	2b 45 08             	sub    0x8(%ebp),%eax
  802e86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802e89:	a1 48 51 80 00       	mov    0x805148,%eax
  802e8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802e91:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e95:	75 17                	jne    802eae <alloc_block_BF+0x15d>
  802e97:	83 ec 04             	sub    $0x4,%esp
  802e9a:	68 bc 42 80 00       	push   $0x8042bc
  802e9f:	68 d1 00 00 00       	push   $0xd1
  802ea4:	68 4b 42 80 00       	push   $0x80424b
  802ea9:	e8 e3 d8 ff ff       	call   800791 <_panic>
  802eae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eb1:	8b 00                	mov    (%eax),%eax
  802eb3:	85 c0                	test   %eax,%eax
  802eb5:	74 10                	je     802ec7 <alloc_block_BF+0x176>
  802eb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eba:	8b 00                	mov    (%eax),%eax
  802ebc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ebf:	8b 52 04             	mov    0x4(%edx),%edx
  802ec2:	89 50 04             	mov    %edx,0x4(%eax)
  802ec5:	eb 0b                	jmp    802ed2 <alloc_block_BF+0x181>
  802ec7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eca:	8b 40 04             	mov    0x4(%eax),%eax
  802ecd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ed2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed5:	8b 40 04             	mov    0x4(%eax),%eax
  802ed8:	85 c0                	test   %eax,%eax
  802eda:	74 0f                	je     802eeb <alloc_block_BF+0x19a>
  802edc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802edf:	8b 40 04             	mov    0x4(%eax),%eax
  802ee2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ee5:	8b 12                	mov    (%edx),%edx
  802ee7:	89 10                	mov    %edx,(%eax)
  802ee9:	eb 0a                	jmp    802ef5 <alloc_block_BF+0x1a4>
  802eeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eee:	8b 00                	mov    (%eax),%eax
  802ef0:	a3 48 51 80 00       	mov    %eax,0x805148
  802ef5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802efe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f08:	a1 54 51 80 00       	mov    0x805154,%eax
  802f0d:	48                   	dec    %eax
  802f0e:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  802f13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f16:	8b 55 08             	mov    0x8(%ebp),%edx
  802f19:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802f1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1f:	8b 50 08             	mov    0x8(%eax),%edx
  802f22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f25:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f2e:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f34:	8b 50 08             	mov    0x8(%eax),%edx
  802f37:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3a:	01 c2                	add    %eax,%edx
  802f3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3f:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802f42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f45:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802f48:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f4b:	eb 05                	jmp    802f52 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802f4d:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802f52:	c9                   	leave  
  802f53:	c3                   	ret    

00802f54 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802f54:	55                   	push   %ebp
  802f55:	89 e5                	mov    %esp,%ebp
  802f57:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802f5a:	83 ec 04             	sub    $0x4,%esp
  802f5d:	68 dc 42 80 00       	push   $0x8042dc
  802f62:	68 e8 00 00 00       	push   $0xe8
  802f67:	68 4b 42 80 00       	push   $0x80424b
  802f6c:	e8 20 d8 ff ff       	call   800791 <_panic>

00802f71 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f71:	55                   	push   %ebp
  802f72:	89 e5                	mov    %esp,%ebp
  802f74:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802f77:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802f7f:	a1 38 51 80 00       	mov    0x805138,%eax
  802f84:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802f87:	a1 44 51 80 00       	mov    0x805144,%eax
  802f8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802f8f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f93:	75 68                	jne    802ffd <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802f95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f99:	75 17                	jne    802fb2 <insert_sorted_with_merge_freeList+0x41>
  802f9b:	83 ec 04             	sub    $0x4,%esp
  802f9e:	68 28 42 80 00       	push   $0x804228
  802fa3:	68 36 01 00 00       	push   $0x136
  802fa8:	68 4b 42 80 00       	push   $0x80424b
  802fad:	e8 df d7 ff ff       	call   800791 <_panic>
  802fb2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbb:	89 10                	mov    %edx,(%eax)
  802fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc0:	8b 00                	mov    (%eax),%eax
  802fc2:	85 c0                	test   %eax,%eax
  802fc4:	74 0d                	je     802fd3 <insert_sorted_with_merge_freeList+0x62>
  802fc6:	a1 38 51 80 00       	mov    0x805138,%eax
  802fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  802fce:	89 50 04             	mov    %edx,0x4(%eax)
  802fd1:	eb 08                	jmp    802fdb <insert_sorted_with_merge_freeList+0x6a>
  802fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fed:	a1 44 51 80 00       	mov    0x805144,%eax
  802ff2:	40                   	inc    %eax
  802ff3:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802ff8:	e9 ba 06 00 00       	jmp    8036b7 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803000:	8b 50 08             	mov    0x8(%eax),%edx
  803003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803006:	8b 40 0c             	mov    0xc(%eax),%eax
  803009:	01 c2                	add    %eax,%edx
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	8b 40 08             	mov    0x8(%eax),%eax
  803011:	39 c2                	cmp    %eax,%edx
  803013:	73 68                	jae    80307d <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803015:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803019:	75 17                	jne    803032 <insert_sorted_with_merge_freeList+0xc1>
  80301b:	83 ec 04             	sub    $0x4,%esp
  80301e:	68 64 42 80 00       	push   $0x804264
  803023:	68 3a 01 00 00       	push   $0x13a
  803028:	68 4b 42 80 00       	push   $0x80424b
  80302d:	e8 5f d7 ff ff       	call   800791 <_panic>
  803032:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	89 50 04             	mov    %edx,0x4(%eax)
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	8b 40 04             	mov    0x4(%eax),%eax
  803044:	85 c0                	test   %eax,%eax
  803046:	74 0c                	je     803054 <insert_sorted_with_merge_freeList+0xe3>
  803048:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80304d:	8b 55 08             	mov    0x8(%ebp),%edx
  803050:	89 10                	mov    %edx,(%eax)
  803052:	eb 08                	jmp    80305c <insert_sorted_with_merge_freeList+0xeb>
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	a3 38 51 80 00       	mov    %eax,0x805138
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803064:	8b 45 08             	mov    0x8(%ebp),%eax
  803067:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306d:	a1 44 51 80 00       	mov    0x805144,%eax
  803072:	40                   	inc    %eax
  803073:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803078:	e9 3a 06 00 00       	jmp    8036b7 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  80307d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803080:	8b 50 08             	mov    0x8(%eax),%edx
  803083:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803086:	8b 40 0c             	mov    0xc(%eax),%eax
  803089:	01 c2                	add    %eax,%edx
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	8b 40 08             	mov    0x8(%eax),%eax
  803091:	39 c2                	cmp    %eax,%edx
  803093:	0f 85 90 00 00 00    	jne    803129 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  803099:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309c:	8b 50 0c             	mov    0xc(%eax),%edx
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a5:	01 c2                	add    %eax,%edx
  8030a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030aa:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8030b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ba:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c5:	75 17                	jne    8030de <insert_sorted_with_merge_freeList+0x16d>
  8030c7:	83 ec 04             	sub    $0x4,%esp
  8030ca:	68 28 42 80 00       	push   $0x804228
  8030cf:	68 41 01 00 00       	push   $0x141
  8030d4:	68 4b 42 80 00       	push   $0x80424b
  8030d9:	e8 b3 d6 ff ff       	call   800791 <_panic>
  8030de:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e7:	89 10                	mov    %edx,(%eax)
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	8b 00                	mov    (%eax),%eax
  8030ee:	85 c0                	test   %eax,%eax
  8030f0:	74 0d                	je     8030ff <insert_sorted_with_merge_freeList+0x18e>
  8030f2:	a1 48 51 80 00       	mov    0x805148,%eax
  8030f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fa:	89 50 04             	mov    %edx,0x4(%eax)
  8030fd:	eb 08                	jmp    803107 <insert_sorted_with_merge_freeList+0x196>
  8030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803102:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	a3 48 51 80 00       	mov    %eax,0x805148
  80310f:	8b 45 08             	mov    0x8(%ebp),%eax
  803112:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803119:	a1 54 51 80 00       	mov    0x805154,%eax
  80311e:	40                   	inc    %eax
  80311f:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803124:	e9 8e 05 00 00       	jmp    8036b7 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  803129:	8b 45 08             	mov    0x8(%ebp),%eax
  80312c:	8b 50 08             	mov    0x8(%eax),%edx
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	8b 40 0c             	mov    0xc(%eax),%eax
  803135:	01 c2                	add    %eax,%edx
  803137:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313a:	8b 40 08             	mov    0x8(%eax),%eax
  80313d:	39 c2                	cmp    %eax,%edx
  80313f:	73 68                	jae    8031a9 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803141:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803145:	75 17                	jne    80315e <insert_sorted_with_merge_freeList+0x1ed>
  803147:	83 ec 04             	sub    $0x4,%esp
  80314a:	68 28 42 80 00       	push   $0x804228
  80314f:	68 45 01 00 00       	push   $0x145
  803154:	68 4b 42 80 00       	push   $0x80424b
  803159:	e8 33 d6 ff ff       	call   800791 <_panic>
  80315e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	89 10                	mov    %edx,(%eax)
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	8b 00                	mov    (%eax),%eax
  80316e:	85 c0                	test   %eax,%eax
  803170:	74 0d                	je     80317f <insert_sorted_with_merge_freeList+0x20e>
  803172:	a1 38 51 80 00       	mov    0x805138,%eax
  803177:	8b 55 08             	mov    0x8(%ebp),%edx
  80317a:	89 50 04             	mov    %edx,0x4(%eax)
  80317d:	eb 08                	jmp    803187 <insert_sorted_with_merge_freeList+0x216>
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	a3 38 51 80 00       	mov    %eax,0x805138
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803199:	a1 44 51 80 00       	mov    0x805144,%eax
  80319e:	40                   	inc    %eax
  80319f:	a3 44 51 80 00       	mov    %eax,0x805144





}
  8031a4:	e9 0e 05 00 00       	jmp    8036b7 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	8b 50 08             	mov    0x8(%eax),%edx
  8031af:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b5:	01 c2                	add    %eax,%edx
  8031b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ba:	8b 40 08             	mov    0x8(%eax),%eax
  8031bd:	39 c2                	cmp    %eax,%edx
  8031bf:	0f 85 9c 00 00 00    	jne    803261 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  8031c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c8:	8b 50 0c             	mov    0xc(%eax),%edx
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d1:	01 c2                	add    %eax,%edx
  8031d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d6:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	8b 50 08             	mov    0x8(%eax),%edx
  8031df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e2:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  8031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031fd:	75 17                	jne    803216 <insert_sorted_with_merge_freeList+0x2a5>
  8031ff:	83 ec 04             	sub    $0x4,%esp
  803202:	68 28 42 80 00       	push   $0x804228
  803207:	68 4d 01 00 00       	push   $0x14d
  80320c:	68 4b 42 80 00       	push   $0x80424b
  803211:	e8 7b d5 ff ff       	call   800791 <_panic>
  803216:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80321c:	8b 45 08             	mov    0x8(%ebp),%eax
  80321f:	89 10                	mov    %edx,(%eax)
  803221:	8b 45 08             	mov    0x8(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	85 c0                	test   %eax,%eax
  803228:	74 0d                	je     803237 <insert_sorted_with_merge_freeList+0x2c6>
  80322a:	a1 48 51 80 00       	mov    0x805148,%eax
  80322f:	8b 55 08             	mov    0x8(%ebp),%edx
  803232:	89 50 04             	mov    %edx,0x4(%eax)
  803235:	eb 08                	jmp    80323f <insert_sorted_with_merge_freeList+0x2ce>
  803237:	8b 45 08             	mov    0x8(%ebp),%eax
  80323a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	a3 48 51 80 00       	mov    %eax,0x805148
  803247:	8b 45 08             	mov    0x8(%ebp),%eax
  80324a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803251:	a1 54 51 80 00       	mov    0x805154,%eax
  803256:	40                   	inc    %eax
  803257:	a3 54 51 80 00       	mov    %eax,0x805154





}
  80325c:	e9 56 04 00 00       	jmp    8036b7 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803261:	a1 38 51 80 00       	mov    0x805138,%eax
  803266:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803269:	e9 19 04 00 00       	jmp    803687 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  80326e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803271:	8b 00                	mov    (%eax),%eax
  803273:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803279:	8b 50 08             	mov    0x8(%eax),%edx
  80327c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327f:	8b 40 0c             	mov    0xc(%eax),%eax
  803282:	01 c2                	add    %eax,%edx
  803284:	8b 45 08             	mov    0x8(%ebp),%eax
  803287:	8b 40 08             	mov    0x8(%eax),%eax
  80328a:	39 c2                	cmp    %eax,%edx
  80328c:	0f 85 ad 01 00 00    	jne    80343f <insert_sorted_with_merge_freeList+0x4ce>
  803292:	8b 45 08             	mov    0x8(%ebp),%eax
  803295:	8b 50 08             	mov    0x8(%eax),%edx
  803298:	8b 45 08             	mov    0x8(%ebp),%eax
  80329b:	8b 40 0c             	mov    0xc(%eax),%eax
  80329e:	01 c2                	add    %eax,%edx
  8032a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a3:	8b 40 08             	mov    0x8(%eax),%eax
  8032a6:	39 c2                	cmp    %eax,%edx
  8032a8:	0f 85 91 01 00 00    	jne    80343f <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  8032ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b1:	8b 50 0c             	mov    0xc(%eax),%edx
  8032b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b7:	8b 48 0c             	mov    0xc(%eax),%ecx
  8032ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c0:	01 c8                	add    %ecx,%eax
  8032c2:	01 c2                	add    %eax,%edx
  8032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c7:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  8032ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  8032de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  8032e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  8032f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032f6:	75 17                	jne    80330f <insert_sorted_with_merge_freeList+0x39e>
  8032f8:	83 ec 04             	sub    $0x4,%esp
  8032fb:	68 bc 42 80 00       	push   $0x8042bc
  803300:	68 5b 01 00 00       	push   $0x15b
  803305:	68 4b 42 80 00       	push   $0x80424b
  80330a:	e8 82 d4 ff ff       	call   800791 <_panic>
  80330f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803312:	8b 00                	mov    (%eax),%eax
  803314:	85 c0                	test   %eax,%eax
  803316:	74 10                	je     803328 <insert_sorted_with_merge_freeList+0x3b7>
  803318:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80331b:	8b 00                	mov    (%eax),%eax
  80331d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803320:	8b 52 04             	mov    0x4(%edx),%edx
  803323:	89 50 04             	mov    %edx,0x4(%eax)
  803326:	eb 0b                	jmp    803333 <insert_sorted_with_merge_freeList+0x3c2>
  803328:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80332b:	8b 40 04             	mov    0x4(%eax),%eax
  80332e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803336:	8b 40 04             	mov    0x4(%eax),%eax
  803339:	85 c0                	test   %eax,%eax
  80333b:	74 0f                	je     80334c <insert_sorted_with_merge_freeList+0x3db>
  80333d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803340:	8b 40 04             	mov    0x4(%eax),%eax
  803343:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803346:	8b 12                	mov    (%edx),%edx
  803348:	89 10                	mov    %edx,(%eax)
  80334a:	eb 0a                	jmp    803356 <insert_sorted_with_merge_freeList+0x3e5>
  80334c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80334f:	8b 00                	mov    (%eax),%eax
  803351:	a3 38 51 80 00       	mov    %eax,0x805138
  803356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803359:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80335f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803362:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803369:	a1 44 51 80 00       	mov    0x805144,%eax
  80336e:	48                   	dec    %eax
  80336f:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803374:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803378:	75 17                	jne    803391 <insert_sorted_with_merge_freeList+0x420>
  80337a:	83 ec 04             	sub    $0x4,%esp
  80337d:	68 28 42 80 00       	push   $0x804228
  803382:	68 5c 01 00 00       	push   $0x15c
  803387:	68 4b 42 80 00       	push   $0x80424b
  80338c:	e8 00 d4 ff ff       	call   800791 <_panic>
  803391:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	89 10                	mov    %edx,(%eax)
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	8b 00                	mov    (%eax),%eax
  8033a1:	85 c0                	test   %eax,%eax
  8033a3:	74 0d                	je     8033b2 <insert_sorted_with_merge_freeList+0x441>
  8033a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8033aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ad:	89 50 04             	mov    %edx,0x4(%eax)
  8033b0:	eb 08                	jmp    8033ba <insert_sorted_with_merge_freeList+0x449>
  8033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8033c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8033d1:	40                   	inc    %eax
  8033d2:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  8033d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033db:	75 17                	jne    8033f4 <insert_sorted_with_merge_freeList+0x483>
  8033dd:	83 ec 04             	sub    $0x4,%esp
  8033e0:	68 28 42 80 00       	push   $0x804228
  8033e5:	68 5d 01 00 00       	push   $0x15d
  8033ea:	68 4b 42 80 00       	push   $0x80424b
  8033ef:	e8 9d d3 ff ff       	call   800791 <_panic>
  8033f4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033fd:	89 10                	mov    %edx,(%eax)
  8033ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803402:	8b 00                	mov    (%eax),%eax
  803404:	85 c0                	test   %eax,%eax
  803406:	74 0d                	je     803415 <insert_sorted_with_merge_freeList+0x4a4>
  803408:	a1 48 51 80 00       	mov    0x805148,%eax
  80340d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803410:	89 50 04             	mov    %edx,0x4(%eax)
  803413:	eb 08                	jmp    80341d <insert_sorted_with_merge_freeList+0x4ac>
  803415:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803418:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80341d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803420:	a3 48 51 80 00       	mov    %eax,0x805148
  803425:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803428:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342f:	a1 54 51 80 00       	mov    0x805154,%eax
  803434:	40                   	inc    %eax
  803435:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80343a:	e9 78 02 00 00       	jmp    8036b7 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  80343f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803442:	8b 50 08             	mov    0x8(%eax),%edx
  803445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803448:	8b 40 0c             	mov    0xc(%eax),%eax
  80344b:	01 c2                	add    %eax,%edx
  80344d:	8b 45 08             	mov    0x8(%ebp),%eax
  803450:	8b 40 08             	mov    0x8(%eax),%eax
  803453:	39 c2                	cmp    %eax,%edx
  803455:	0f 83 b8 00 00 00    	jae    803513 <insert_sorted_with_merge_freeList+0x5a2>
  80345b:	8b 45 08             	mov    0x8(%ebp),%eax
  80345e:	8b 50 08             	mov    0x8(%eax),%edx
  803461:	8b 45 08             	mov    0x8(%ebp),%eax
  803464:	8b 40 0c             	mov    0xc(%eax),%eax
  803467:	01 c2                	add    %eax,%edx
  803469:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346c:	8b 40 08             	mov    0x8(%eax),%eax
  80346f:	39 c2                	cmp    %eax,%edx
  803471:	0f 85 9c 00 00 00    	jne    803513 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  803477:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347a:	8b 50 0c             	mov    0xc(%eax),%edx
  80347d:	8b 45 08             	mov    0x8(%ebp),%eax
  803480:	8b 40 0c             	mov    0xc(%eax),%eax
  803483:	01 c2                	add    %eax,%edx
  803485:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803488:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  80348b:	8b 45 08             	mov    0x8(%ebp),%eax
  80348e:	8b 50 08             	mov    0x8(%eax),%edx
  803491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803494:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  803497:	8b 45 08             	mov    0x8(%ebp),%eax
  80349a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8034a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034af:	75 17                	jne    8034c8 <insert_sorted_with_merge_freeList+0x557>
  8034b1:	83 ec 04             	sub    $0x4,%esp
  8034b4:	68 28 42 80 00       	push   $0x804228
  8034b9:	68 67 01 00 00       	push   $0x167
  8034be:	68 4b 42 80 00       	push   $0x80424b
  8034c3:	e8 c9 d2 ff ff       	call   800791 <_panic>
  8034c8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d1:	89 10                	mov    %edx,(%eax)
  8034d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d6:	8b 00                	mov    (%eax),%eax
  8034d8:	85 c0                	test   %eax,%eax
  8034da:	74 0d                	je     8034e9 <insert_sorted_with_merge_freeList+0x578>
  8034dc:	a1 48 51 80 00       	mov    0x805148,%eax
  8034e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e4:	89 50 04             	mov    %edx,0x4(%eax)
  8034e7:	eb 08                	jmp    8034f1 <insert_sorted_with_merge_freeList+0x580>
  8034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f4:	a3 48 51 80 00       	mov    %eax,0x805148
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803503:	a1 54 51 80 00       	mov    0x805154,%eax
  803508:	40                   	inc    %eax
  803509:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80350e:	e9 a4 01 00 00       	jmp    8036b7 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803516:	8b 50 08             	mov    0x8(%eax),%edx
  803519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351c:	8b 40 0c             	mov    0xc(%eax),%eax
  80351f:	01 c2                	add    %eax,%edx
  803521:	8b 45 08             	mov    0x8(%ebp),%eax
  803524:	8b 40 08             	mov    0x8(%eax),%eax
  803527:	39 c2                	cmp    %eax,%edx
  803529:	0f 85 ac 00 00 00    	jne    8035db <insert_sorted_with_merge_freeList+0x66a>
  80352f:	8b 45 08             	mov    0x8(%ebp),%eax
  803532:	8b 50 08             	mov    0x8(%eax),%edx
  803535:	8b 45 08             	mov    0x8(%ebp),%eax
  803538:	8b 40 0c             	mov    0xc(%eax),%eax
  80353b:	01 c2                	add    %eax,%edx
  80353d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803540:	8b 40 08             	mov    0x8(%eax),%eax
  803543:	39 c2                	cmp    %eax,%edx
  803545:	0f 83 90 00 00 00    	jae    8035db <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  80354b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354e:	8b 50 0c             	mov    0xc(%eax),%edx
  803551:	8b 45 08             	mov    0x8(%ebp),%eax
  803554:	8b 40 0c             	mov    0xc(%eax),%eax
  803557:	01 c2                	add    %eax,%edx
  803559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355c:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  80355f:	8b 45 08             	mov    0x8(%ebp),%eax
  803562:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  803569:	8b 45 08             	mov    0x8(%ebp),%eax
  80356c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803573:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803577:	75 17                	jne    803590 <insert_sorted_with_merge_freeList+0x61f>
  803579:	83 ec 04             	sub    $0x4,%esp
  80357c:	68 28 42 80 00       	push   $0x804228
  803581:	68 70 01 00 00       	push   $0x170
  803586:	68 4b 42 80 00       	push   $0x80424b
  80358b:	e8 01 d2 ff ff       	call   800791 <_panic>
  803590:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803596:	8b 45 08             	mov    0x8(%ebp),%eax
  803599:	89 10                	mov    %edx,(%eax)
  80359b:	8b 45 08             	mov    0x8(%ebp),%eax
  80359e:	8b 00                	mov    (%eax),%eax
  8035a0:	85 c0                	test   %eax,%eax
  8035a2:	74 0d                	je     8035b1 <insert_sorted_with_merge_freeList+0x640>
  8035a4:	a1 48 51 80 00       	mov    0x805148,%eax
  8035a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ac:	89 50 04             	mov    %edx,0x4(%eax)
  8035af:	eb 08                	jmp    8035b9 <insert_sorted_with_merge_freeList+0x648>
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bc:	a3 48 51 80 00       	mov    %eax,0x805148
  8035c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035cb:	a1 54 51 80 00       	mov    0x805154,%eax
  8035d0:	40                   	inc    %eax
  8035d1:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  8035d6:	e9 dc 00 00 00       	jmp    8036b7 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8035db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035de:	8b 50 08             	mov    0x8(%eax),%edx
  8035e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e7:	01 c2                	add    %eax,%edx
  8035e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ec:	8b 40 08             	mov    0x8(%eax),%eax
  8035ef:	39 c2                	cmp    %eax,%edx
  8035f1:	0f 83 88 00 00 00    	jae    80367f <insert_sorted_with_merge_freeList+0x70e>
  8035f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fa:	8b 50 08             	mov    0x8(%eax),%edx
  8035fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803600:	8b 40 0c             	mov    0xc(%eax),%eax
  803603:	01 c2                	add    %eax,%edx
  803605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803608:	8b 40 08             	mov    0x8(%eax),%eax
  80360b:	39 c2                	cmp    %eax,%edx
  80360d:	73 70                	jae    80367f <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  80360f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803613:	74 06                	je     80361b <insert_sorted_with_merge_freeList+0x6aa>
  803615:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803619:	75 17                	jne    803632 <insert_sorted_with_merge_freeList+0x6c1>
  80361b:	83 ec 04             	sub    $0x4,%esp
  80361e:	68 88 42 80 00       	push   $0x804288
  803623:	68 75 01 00 00       	push   $0x175
  803628:	68 4b 42 80 00       	push   $0x80424b
  80362d:	e8 5f d1 ff ff       	call   800791 <_panic>
  803632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803635:	8b 10                	mov    (%eax),%edx
  803637:	8b 45 08             	mov    0x8(%ebp),%eax
  80363a:	89 10                	mov    %edx,(%eax)
  80363c:	8b 45 08             	mov    0x8(%ebp),%eax
  80363f:	8b 00                	mov    (%eax),%eax
  803641:	85 c0                	test   %eax,%eax
  803643:	74 0b                	je     803650 <insert_sorted_with_merge_freeList+0x6df>
  803645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803648:	8b 00                	mov    (%eax),%eax
  80364a:	8b 55 08             	mov    0x8(%ebp),%edx
  80364d:	89 50 04             	mov    %edx,0x4(%eax)
  803650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803653:	8b 55 08             	mov    0x8(%ebp),%edx
  803656:	89 10                	mov    %edx,(%eax)
  803658:	8b 45 08             	mov    0x8(%ebp),%eax
  80365b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80365e:	89 50 04             	mov    %edx,0x4(%eax)
  803661:	8b 45 08             	mov    0x8(%ebp),%eax
  803664:	8b 00                	mov    (%eax),%eax
  803666:	85 c0                	test   %eax,%eax
  803668:	75 08                	jne    803672 <insert_sorted_with_merge_freeList+0x701>
  80366a:	8b 45 08             	mov    0x8(%ebp),%eax
  80366d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803672:	a1 44 51 80 00       	mov    0x805144,%eax
  803677:	40                   	inc    %eax
  803678:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  80367d:	eb 38                	jmp    8036b7 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  80367f:	a1 40 51 80 00       	mov    0x805140,%eax
  803684:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803687:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80368b:	74 07                	je     803694 <insert_sorted_with_merge_freeList+0x723>
  80368d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803690:	8b 00                	mov    (%eax),%eax
  803692:	eb 05                	jmp    803699 <insert_sorted_with_merge_freeList+0x728>
  803694:	b8 00 00 00 00       	mov    $0x0,%eax
  803699:	a3 40 51 80 00       	mov    %eax,0x805140
  80369e:	a1 40 51 80 00       	mov    0x805140,%eax
  8036a3:	85 c0                	test   %eax,%eax
  8036a5:	0f 85 c3 fb ff ff    	jne    80326e <insert_sorted_with_merge_freeList+0x2fd>
  8036ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036af:	0f 85 b9 fb ff ff    	jne    80326e <insert_sorted_with_merge_freeList+0x2fd>





}
  8036b5:	eb 00                	jmp    8036b7 <insert_sorted_with_merge_freeList+0x746>
  8036b7:	90                   	nop
  8036b8:	c9                   	leave  
  8036b9:	c3                   	ret    
  8036ba:	66 90                	xchg   %ax,%ax

008036bc <__udivdi3>:
  8036bc:	55                   	push   %ebp
  8036bd:	57                   	push   %edi
  8036be:	56                   	push   %esi
  8036bf:	53                   	push   %ebx
  8036c0:	83 ec 1c             	sub    $0x1c,%esp
  8036c3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036c7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036d3:	89 ca                	mov    %ecx,%edx
  8036d5:	89 f8                	mov    %edi,%eax
  8036d7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036db:	85 f6                	test   %esi,%esi
  8036dd:	75 2d                	jne    80370c <__udivdi3+0x50>
  8036df:	39 cf                	cmp    %ecx,%edi
  8036e1:	77 65                	ja     803748 <__udivdi3+0x8c>
  8036e3:	89 fd                	mov    %edi,%ebp
  8036e5:	85 ff                	test   %edi,%edi
  8036e7:	75 0b                	jne    8036f4 <__udivdi3+0x38>
  8036e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8036ee:	31 d2                	xor    %edx,%edx
  8036f0:	f7 f7                	div    %edi
  8036f2:	89 c5                	mov    %eax,%ebp
  8036f4:	31 d2                	xor    %edx,%edx
  8036f6:	89 c8                	mov    %ecx,%eax
  8036f8:	f7 f5                	div    %ebp
  8036fa:	89 c1                	mov    %eax,%ecx
  8036fc:	89 d8                	mov    %ebx,%eax
  8036fe:	f7 f5                	div    %ebp
  803700:	89 cf                	mov    %ecx,%edi
  803702:	89 fa                	mov    %edi,%edx
  803704:	83 c4 1c             	add    $0x1c,%esp
  803707:	5b                   	pop    %ebx
  803708:	5e                   	pop    %esi
  803709:	5f                   	pop    %edi
  80370a:	5d                   	pop    %ebp
  80370b:	c3                   	ret    
  80370c:	39 ce                	cmp    %ecx,%esi
  80370e:	77 28                	ja     803738 <__udivdi3+0x7c>
  803710:	0f bd fe             	bsr    %esi,%edi
  803713:	83 f7 1f             	xor    $0x1f,%edi
  803716:	75 40                	jne    803758 <__udivdi3+0x9c>
  803718:	39 ce                	cmp    %ecx,%esi
  80371a:	72 0a                	jb     803726 <__udivdi3+0x6a>
  80371c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803720:	0f 87 9e 00 00 00    	ja     8037c4 <__udivdi3+0x108>
  803726:	b8 01 00 00 00       	mov    $0x1,%eax
  80372b:	89 fa                	mov    %edi,%edx
  80372d:	83 c4 1c             	add    $0x1c,%esp
  803730:	5b                   	pop    %ebx
  803731:	5e                   	pop    %esi
  803732:	5f                   	pop    %edi
  803733:	5d                   	pop    %ebp
  803734:	c3                   	ret    
  803735:	8d 76 00             	lea    0x0(%esi),%esi
  803738:	31 ff                	xor    %edi,%edi
  80373a:	31 c0                	xor    %eax,%eax
  80373c:	89 fa                	mov    %edi,%edx
  80373e:	83 c4 1c             	add    $0x1c,%esp
  803741:	5b                   	pop    %ebx
  803742:	5e                   	pop    %esi
  803743:	5f                   	pop    %edi
  803744:	5d                   	pop    %ebp
  803745:	c3                   	ret    
  803746:	66 90                	xchg   %ax,%ax
  803748:	89 d8                	mov    %ebx,%eax
  80374a:	f7 f7                	div    %edi
  80374c:	31 ff                	xor    %edi,%edi
  80374e:	89 fa                	mov    %edi,%edx
  803750:	83 c4 1c             	add    $0x1c,%esp
  803753:	5b                   	pop    %ebx
  803754:	5e                   	pop    %esi
  803755:	5f                   	pop    %edi
  803756:	5d                   	pop    %ebp
  803757:	c3                   	ret    
  803758:	bd 20 00 00 00       	mov    $0x20,%ebp
  80375d:	89 eb                	mov    %ebp,%ebx
  80375f:	29 fb                	sub    %edi,%ebx
  803761:	89 f9                	mov    %edi,%ecx
  803763:	d3 e6                	shl    %cl,%esi
  803765:	89 c5                	mov    %eax,%ebp
  803767:	88 d9                	mov    %bl,%cl
  803769:	d3 ed                	shr    %cl,%ebp
  80376b:	89 e9                	mov    %ebp,%ecx
  80376d:	09 f1                	or     %esi,%ecx
  80376f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803773:	89 f9                	mov    %edi,%ecx
  803775:	d3 e0                	shl    %cl,%eax
  803777:	89 c5                	mov    %eax,%ebp
  803779:	89 d6                	mov    %edx,%esi
  80377b:	88 d9                	mov    %bl,%cl
  80377d:	d3 ee                	shr    %cl,%esi
  80377f:	89 f9                	mov    %edi,%ecx
  803781:	d3 e2                	shl    %cl,%edx
  803783:	8b 44 24 08          	mov    0x8(%esp),%eax
  803787:	88 d9                	mov    %bl,%cl
  803789:	d3 e8                	shr    %cl,%eax
  80378b:	09 c2                	or     %eax,%edx
  80378d:	89 d0                	mov    %edx,%eax
  80378f:	89 f2                	mov    %esi,%edx
  803791:	f7 74 24 0c          	divl   0xc(%esp)
  803795:	89 d6                	mov    %edx,%esi
  803797:	89 c3                	mov    %eax,%ebx
  803799:	f7 e5                	mul    %ebp
  80379b:	39 d6                	cmp    %edx,%esi
  80379d:	72 19                	jb     8037b8 <__udivdi3+0xfc>
  80379f:	74 0b                	je     8037ac <__udivdi3+0xf0>
  8037a1:	89 d8                	mov    %ebx,%eax
  8037a3:	31 ff                	xor    %edi,%edi
  8037a5:	e9 58 ff ff ff       	jmp    803702 <__udivdi3+0x46>
  8037aa:	66 90                	xchg   %ax,%ax
  8037ac:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037b0:	89 f9                	mov    %edi,%ecx
  8037b2:	d3 e2                	shl    %cl,%edx
  8037b4:	39 c2                	cmp    %eax,%edx
  8037b6:	73 e9                	jae    8037a1 <__udivdi3+0xe5>
  8037b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037bb:	31 ff                	xor    %edi,%edi
  8037bd:	e9 40 ff ff ff       	jmp    803702 <__udivdi3+0x46>
  8037c2:	66 90                	xchg   %ax,%ax
  8037c4:	31 c0                	xor    %eax,%eax
  8037c6:	e9 37 ff ff ff       	jmp    803702 <__udivdi3+0x46>
  8037cb:	90                   	nop

008037cc <__umoddi3>:
  8037cc:	55                   	push   %ebp
  8037cd:	57                   	push   %edi
  8037ce:	56                   	push   %esi
  8037cf:	53                   	push   %ebx
  8037d0:	83 ec 1c             	sub    $0x1c,%esp
  8037d3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037d7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037eb:	89 f3                	mov    %esi,%ebx
  8037ed:	89 fa                	mov    %edi,%edx
  8037ef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037f3:	89 34 24             	mov    %esi,(%esp)
  8037f6:	85 c0                	test   %eax,%eax
  8037f8:	75 1a                	jne    803814 <__umoddi3+0x48>
  8037fa:	39 f7                	cmp    %esi,%edi
  8037fc:	0f 86 a2 00 00 00    	jbe    8038a4 <__umoddi3+0xd8>
  803802:	89 c8                	mov    %ecx,%eax
  803804:	89 f2                	mov    %esi,%edx
  803806:	f7 f7                	div    %edi
  803808:	89 d0                	mov    %edx,%eax
  80380a:	31 d2                	xor    %edx,%edx
  80380c:	83 c4 1c             	add    $0x1c,%esp
  80380f:	5b                   	pop    %ebx
  803810:	5e                   	pop    %esi
  803811:	5f                   	pop    %edi
  803812:	5d                   	pop    %ebp
  803813:	c3                   	ret    
  803814:	39 f0                	cmp    %esi,%eax
  803816:	0f 87 ac 00 00 00    	ja     8038c8 <__umoddi3+0xfc>
  80381c:	0f bd e8             	bsr    %eax,%ebp
  80381f:	83 f5 1f             	xor    $0x1f,%ebp
  803822:	0f 84 ac 00 00 00    	je     8038d4 <__umoddi3+0x108>
  803828:	bf 20 00 00 00       	mov    $0x20,%edi
  80382d:	29 ef                	sub    %ebp,%edi
  80382f:	89 fe                	mov    %edi,%esi
  803831:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803835:	89 e9                	mov    %ebp,%ecx
  803837:	d3 e0                	shl    %cl,%eax
  803839:	89 d7                	mov    %edx,%edi
  80383b:	89 f1                	mov    %esi,%ecx
  80383d:	d3 ef                	shr    %cl,%edi
  80383f:	09 c7                	or     %eax,%edi
  803841:	89 e9                	mov    %ebp,%ecx
  803843:	d3 e2                	shl    %cl,%edx
  803845:	89 14 24             	mov    %edx,(%esp)
  803848:	89 d8                	mov    %ebx,%eax
  80384a:	d3 e0                	shl    %cl,%eax
  80384c:	89 c2                	mov    %eax,%edx
  80384e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803852:	d3 e0                	shl    %cl,%eax
  803854:	89 44 24 04          	mov    %eax,0x4(%esp)
  803858:	8b 44 24 08          	mov    0x8(%esp),%eax
  80385c:	89 f1                	mov    %esi,%ecx
  80385e:	d3 e8                	shr    %cl,%eax
  803860:	09 d0                	or     %edx,%eax
  803862:	d3 eb                	shr    %cl,%ebx
  803864:	89 da                	mov    %ebx,%edx
  803866:	f7 f7                	div    %edi
  803868:	89 d3                	mov    %edx,%ebx
  80386a:	f7 24 24             	mull   (%esp)
  80386d:	89 c6                	mov    %eax,%esi
  80386f:	89 d1                	mov    %edx,%ecx
  803871:	39 d3                	cmp    %edx,%ebx
  803873:	0f 82 87 00 00 00    	jb     803900 <__umoddi3+0x134>
  803879:	0f 84 91 00 00 00    	je     803910 <__umoddi3+0x144>
  80387f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803883:	29 f2                	sub    %esi,%edx
  803885:	19 cb                	sbb    %ecx,%ebx
  803887:	89 d8                	mov    %ebx,%eax
  803889:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80388d:	d3 e0                	shl    %cl,%eax
  80388f:	89 e9                	mov    %ebp,%ecx
  803891:	d3 ea                	shr    %cl,%edx
  803893:	09 d0                	or     %edx,%eax
  803895:	89 e9                	mov    %ebp,%ecx
  803897:	d3 eb                	shr    %cl,%ebx
  803899:	89 da                	mov    %ebx,%edx
  80389b:	83 c4 1c             	add    $0x1c,%esp
  80389e:	5b                   	pop    %ebx
  80389f:	5e                   	pop    %esi
  8038a0:	5f                   	pop    %edi
  8038a1:	5d                   	pop    %ebp
  8038a2:	c3                   	ret    
  8038a3:	90                   	nop
  8038a4:	89 fd                	mov    %edi,%ebp
  8038a6:	85 ff                	test   %edi,%edi
  8038a8:	75 0b                	jne    8038b5 <__umoddi3+0xe9>
  8038aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8038af:	31 d2                	xor    %edx,%edx
  8038b1:	f7 f7                	div    %edi
  8038b3:	89 c5                	mov    %eax,%ebp
  8038b5:	89 f0                	mov    %esi,%eax
  8038b7:	31 d2                	xor    %edx,%edx
  8038b9:	f7 f5                	div    %ebp
  8038bb:	89 c8                	mov    %ecx,%eax
  8038bd:	f7 f5                	div    %ebp
  8038bf:	89 d0                	mov    %edx,%eax
  8038c1:	e9 44 ff ff ff       	jmp    80380a <__umoddi3+0x3e>
  8038c6:	66 90                	xchg   %ax,%ax
  8038c8:	89 c8                	mov    %ecx,%eax
  8038ca:	89 f2                	mov    %esi,%edx
  8038cc:	83 c4 1c             	add    $0x1c,%esp
  8038cf:	5b                   	pop    %ebx
  8038d0:	5e                   	pop    %esi
  8038d1:	5f                   	pop    %edi
  8038d2:	5d                   	pop    %ebp
  8038d3:	c3                   	ret    
  8038d4:	3b 04 24             	cmp    (%esp),%eax
  8038d7:	72 06                	jb     8038df <__umoddi3+0x113>
  8038d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038dd:	77 0f                	ja     8038ee <__umoddi3+0x122>
  8038df:	89 f2                	mov    %esi,%edx
  8038e1:	29 f9                	sub    %edi,%ecx
  8038e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038e7:	89 14 24             	mov    %edx,(%esp)
  8038ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038f2:	8b 14 24             	mov    (%esp),%edx
  8038f5:	83 c4 1c             	add    $0x1c,%esp
  8038f8:	5b                   	pop    %ebx
  8038f9:	5e                   	pop    %esi
  8038fa:	5f                   	pop    %edi
  8038fb:	5d                   	pop    %ebp
  8038fc:	c3                   	ret    
  8038fd:	8d 76 00             	lea    0x0(%esi),%esi
  803900:	2b 04 24             	sub    (%esp),%eax
  803903:	19 fa                	sbb    %edi,%edx
  803905:	89 d1                	mov    %edx,%ecx
  803907:	89 c6                	mov    %eax,%esi
  803909:	e9 71 ff ff ff       	jmp    80387f <__umoddi3+0xb3>
  80390e:	66 90                	xchg   %ax,%ax
  803910:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803914:	72 ea                	jb     803900 <__umoddi3+0x134>
  803916:	89 d9                	mov    %ebx,%ecx
  803918:	e9 62 ff ff ff       	jmp    80387f <__umoddi3+0xb3>
