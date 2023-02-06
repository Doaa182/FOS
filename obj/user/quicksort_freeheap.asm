
obj/user/quicksort_freeheap:     file format elf32-i386


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
  800031:	e8 b4 05 00 00       	call   8005ea <libmain>
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
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 4a 1f 00 00       	call   801f98 <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 5c 1f 00 00       	call   801fb1 <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

		//	sys_disable_interrupt();

		readline("Enter the number of elements: ", Line);
  80005d:	83 ec 08             	sub    $0x8,%esp
  800060:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	68 c0 38 80 00       	push   $0x8038c0
  80006c:	e8 eb 0f 00 00       	call   80105c <readline>
  800071:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800074:	83 ec 04             	sub    $0x4,%esp
  800077:	6a 0a                	push   $0xa
  800079:	6a 00                	push   $0x0
  80007b:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800081:	50                   	push   %eax
  800082:	e8 3b 15 00 00       	call   8015c2 <strtol>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  80008d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	e8 bd 1a 00 00       	call   801b59 <malloc>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Choose the initialization method:\n") ;
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 e0 38 80 00       	push   $0x8038e0
  8000aa:	e8 2b 09 00 00       	call   8009da <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 03 39 80 00       	push   $0x803903
  8000ba:	e8 1b 09 00 00       	call   8009da <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 11 39 80 00       	push   $0x803911
  8000ca:	e8 0b 09 00 00       	call   8009da <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 20 39 80 00       	push   $0x803920
  8000da:	e8 fb 08 00 00       	call   8009da <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 30 39 80 00       	push   $0x803930
  8000ea:	e8 eb 08 00 00       	call   8009da <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8000f2:	e8 9b 04 00 00       	call   800592 <getchar>
  8000f7:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8000fa:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	50                   	push   %eax
  800102:	e8 43 04 00 00       	call   80054a <cputchar>
  800107:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	6a 0a                	push   $0xa
  80010f:	e8 36 04 00 00       	call   80054a <cputchar>
  800114:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800117:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  80011b:	74 0c                	je     800129 <_main+0xf1>
  80011d:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800121:	74 06                	je     800129 <_main+0xf1>
  800123:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  800127:	75 b9                	jne    8000e2 <_main+0xaa>
		//sys_enable_interrupt();
		int  i ;
		switch (Chose)
  800129:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80012d:	83 f8 62             	cmp    $0x62,%eax
  800130:	74 1d                	je     80014f <_main+0x117>
  800132:	83 f8 63             	cmp    $0x63,%eax
  800135:	74 2b                	je     800162 <_main+0x12a>
  800137:	83 f8 61             	cmp    $0x61,%eax
  80013a:	75 39                	jne    800175 <_main+0x13d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	ff 75 ec             	pushl  -0x14(%ebp)
  800142:	ff 75 e8             	pushl  -0x18(%ebp)
  800145:	e8 c8 02 00 00       	call   800412 <InitializeAscending>
  80014a:	83 c4 10             	add    $0x10,%esp
			break ;
  80014d:	eb 37                	jmp    800186 <_main+0x14e>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	ff 75 ec             	pushl  -0x14(%ebp)
  800155:	ff 75 e8             	pushl  -0x18(%ebp)
  800158:	e8 e6 02 00 00       	call   800443 <InitializeDescending>
  80015d:	83 c4 10             	add    $0x10,%esp
			break ;
  800160:	eb 24                	jmp    800186 <_main+0x14e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 75 ec             	pushl  -0x14(%ebp)
  800168:	ff 75 e8             	pushl  -0x18(%ebp)
  80016b:	e8 08 03 00 00       	call   800478 <InitializeSemiRandom>
  800170:	83 c4 10             	add    $0x10,%esp
			break ;
  800173:	eb 11                	jmp    800186 <_main+0x14e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 75 ec             	pushl  -0x14(%ebp)
  80017b:	ff 75 e8             	pushl  -0x18(%ebp)
  80017e:	e8 f5 02 00 00       	call   800478 <InitializeSemiRandom>
  800183:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	ff 75 e8             	pushl  -0x18(%ebp)
  80018f:	e8 c3 00 00 00       	call   800257 <QuickSort>
  800194:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 ec             	pushl  -0x14(%ebp)
  80019d:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a0:	e8 c3 01 00 00       	call   800368 <CheckSorted>
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001af:	75 14                	jne    8001c5 <_main+0x18d>
  8001b1:	83 ec 04             	sub    $0x4,%esp
  8001b4:	68 3c 39 80 00       	push   $0x80393c
  8001b9:	6a 45                	push   $0x45
  8001bb:	68 5e 39 80 00       	push   $0x80395e
  8001c0:	e8 61 05 00 00       	call   800726 <_panic>
		else
		{ 
			cprintf("===============================================\n") ;
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 78 39 80 00       	push   $0x803978
  8001cd:	e8 08 08 00 00       	call   8009da <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 ac 39 80 00       	push   $0x8039ac
  8001dd:	e8 f8 07 00 00       	call   8009da <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 e0 39 80 00       	push   $0x8039e0
  8001ed:	e8 e8 07 00 00       	call   8009da <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 12 3a 80 00       	push   $0x803a12
  8001fd:	e8 d8 07 00 00       	call   8009da <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
		//sys_disable_interrupt();
		cprintf("Do you want to repeat (y/n): ") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 28 3a 80 00       	push   $0x803a28
  80020d:	e8 c8 07 00 00       	call   8009da <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  800215:	e8 78 03 00 00       	call   800592 <getchar>
  80021a:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  80021d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 20 03 00 00       	call   80054a <cputchar>
  80022a:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 0a                	push   $0xa
  800232:	e8 13 03 00 00       	call   80054a <cputchar>
  800237:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	6a 0a                	push   $0xa
  80023f:	e8 06 03 00 00       	call   80054a <cputchar>
  800244:	83 c4 10             	add    $0x10,%esp
		//sys_enable_interrupt();

	} while (Chose == 'y');
  800247:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  80024b:	0f 84 f8 fd ff ff    	je     800049 <_main+0x11>

}
  800251:	90                   	nop
  800252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  80025d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800260:	48                   	dec    %eax
  800261:	50                   	push   %eax
  800262:	6a 00                	push   $0x0
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 06 00 00 00       	call   800275 <QSort>
  80026f:	83 c4 10             	add    $0x10,%esp
}
  800272:	90                   	nop
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80027b:	8b 45 10             	mov    0x10(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	0f 8d de 00 00 00    	jge    800365 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800287:	8b 45 10             	mov    0x10(%ebp),%eax
  80028a:	40                   	inc    %eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80028e:	8b 45 14             	mov    0x14(%ebp),%eax
  800291:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800294:	e9 80 00 00 00       	jmp    800319 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800299:	ff 45 f4             	incl   -0xc(%ebp)
  80029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80029f:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a2:	7f 2b                	jg     8002cf <QSort+0x5a>
  8002a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	01 c8                	add    %ecx,%eax
  8002c4:	8b 00                	mov    (%eax),%eax
  8002c6:	39 c2                	cmp    %eax,%edx
  8002c8:	7d cf                	jge    800299 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002ca:	eb 03                	jmp    8002cf <QSort+0x5a>
  8002cc:	ff 4d f0             	decl   -0x10(%ebp)
  8002cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002d5:	7e 26                	jle    8002fd <QSort+0x88>
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	01 d0                	add    %edx,%eax
  8002e6:	8b 10                	mov    (%eax),%edx
  8002e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 c8                	add    %ecx,%eax
  8002f7:	8b 00                	mov    (%eax),%eax
  8002f9:	39 c2                	cmp    %eax,%edx
  8002fb:	7e cf                	jle    8002cc <QSort+0x57>

		if (i <= j)
  8002fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800303:	7f 14                	jg     800319 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	ff 75 f0             	pushl  -0x10(%ebp)
  80030b:	ff 75 f4             	pushl  -0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 a9 00 00 00       	call   8003bf <Swap>
  800316:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80031c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031f:	0f 8e 77 ff ff ff    	jle    80029c <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 f0             	pushl  -0x10(%ebp)
  80032b:	ff 75 10             	pushl  0x10(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	e8 89 00 00 00       	call   8003bf <Swap>
  800336:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	48                   	dec    %eax
  80033d:	50                   	push   %eax
  80033e:	ff 75 10             	pushl  0x10(%ebp)
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	e8 29 ff ff ff       	call   800275 <QSort>
  80034c:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80034f:	ff 75 14             	pushl  0x14(%ebp)
  800352:	ff 75 f4             	pushl  -0xc(%ebp)
  800355:	ff 75 0c             	pushl  0xc(%ebp)
  800358:	ff 75 08             	pushl  0x8(%ebp)
  80035b:	e8 15 ff ff ff       	call   800275 <QSort>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	eb 01                	jmp    800366 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800365:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80036e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800375:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80037c:	eb 33                	jmp    8003b1 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80037e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	8b 10                	mov    (%eax),%edx
  80038f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800392:	40                   	inc    %eax
  800393:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	01 c8                	add    %ecx,%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	39 c2                	cmp    %eax,%edx
  8003a3:	7e 09                	jle    8003ae <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003ac:	eb 0c                	jmp    8003ba <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ae:	ff 45 f8             	incl   -0x8(%ebp)
  8003b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b4:	48                   	dec    %eax
  8003b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003b8:	7f c4                	jg     80037e <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c2                	add    %eax,%edx
  8003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c8                	add    %ecx,%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c2                	add    %eax,%edx
  80040a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040d:	89 02                	mov    %eax,(%edx)
}
  80040f:	90                   	nop
  800410:	c9                   	leave  
  800411:	c3                   	ret    

00800412 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80041f:	eb 17                	jmp    800438 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800421:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	01 c2                	add    %eax,%edx
  800430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800433:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	ff 45 fc             	incl   -0x4(%ebp)
  800438:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043e:	7c e1                	jl     800421 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800450:	eb 1b                	jmp    80046d <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800467:	48                   	dec    %eax
  800468:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80046a:	ff 45 fc             	incl   -0x4(%ebp)
  80046d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800470:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800473:	7c dd                	jl     800452 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800475:	90                   	nop
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800486:	f7 e9                	imul   %ecx
  800488:	c1 f9 1f             	sar    $0x1f,%ecx
  80048b:	89 d0                	mov    %edx,%eax
  80048d:	29 c8                	sub    %ecx,%eax
  80048f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800492:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800499:	eb 1e                	jmp    8004b9 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ae:	99                   	cltd   
  8004af:	f7 7d f8             	idivl  -0x8(%ebp)
  8004b2:	89 d0                	mov    %edx,%eax
  8004b4:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b6:	ff 45 fc             	incl   -0x4(%ebp)
  8004b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004bf:	7c da                	jl     80049b <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004c1:	90                   	nop
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8004ca:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004d8:	eb 42                	jmp    80051c <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8004da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004dd:	99                   	cltd   
  8004de:	f7 7d f0             	idivl  -0x10(%ebp)
  8004e1:	89 d0                	mov    %edx,%eax
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	75 10                	jne    8004f7 <PrintElements+0x33>
			cprintf("\n");
  8004e7:	83 ec 0c             	sub    $0xc,%esp
  8004ea:	68 46 3a 80 00       	push   $0x803a46
  8004ef:	e8 e6 04 00 00       	call   8009da <cprintf>
  8004f4:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8004f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	01 d0                	add    %edx,%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	50                   	push   %eax
  80050c:	68 48 3a 80 00       	push   $0x803a48
  800511:	e8 c4 04 00 00       	call   8009da <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800519:	ff 45 f4             	incl   -0xc(%ebp)
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	48                   	dec    %eax
  800520:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800523:	7f b5                	jg     8004da <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800528:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	01 d0                	add    %edx,%eax
  800534:	8b 00                	mov    (%eax),%eax
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	50                   	push   %eax
  80053a:	68 4d 3a 80 00       	push   $0x803a4d
  80053f:	e8 96 04 00 00       	call   8009da <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800556:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80055a:	83 ec 0c             	sub    $0xc,%esp
  80055d:	50                   	push   %eax
  80055e:	e8 56 1b 00 00       	call   8020b9 <sys_cputc>
  800563:	83 c4 10             	add    $0x10,%esp
}
  800566:	90                   	nop
  800567:	c9                   	leave  
  800568:	c3                   	ret    

00800569 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80056f:	e8 11 1b 00 00       	call   802085 <sys_disable_interrupt>
	char c = ch;
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80057a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80057e:	83 ec 0c             	sub    $0xc,%esp
  800581:	50                   	push   %eax
  800582:	e8 32 1b 00 00       	call   8020b9 <sys_cputc>
  800587:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80058a:	e8 10 1b 00 00       	call   80209f <sys_enable_interrupt>
}
  80058f:	90                   	nop
  800590:	c9                   	leave  
  800591:	c3                   	ret    

00800592 <getchar>:

int
getchar(void)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800598:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80059f:	eb 08                	jmp    8005a9 <getchar+0x17>
	{
		c = sys_cgetc();
  8005a1:	e8 5a 19 00 00       	call   801f00 <sys_cgetc>
  8005a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8005a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005ad:	74 f2                	je     8005a1 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8005af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005b2:	c9                   	leave  
  8005b3:	c3                   	ret    

008005b4 <atomic_getchar>:

int
atomic_getchar(void)
{
  8005b4:	55                   	push   %ebp
  8005b5:	89 e5                	mov    %esp,%ebp
  8005b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005ba:	e8 c6 1a 00 00       	call   802085 <sys_disable_interrupt>
	int c=0;
  8005bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005c6:	eb 08                	jmp    8005d0 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005c8:	e8 33 19 00 00       	call   801f00 <sys_cgetc>
  8005cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8005d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005d4:	74 f2                	je     8005c8 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8005d6:	e8 c4 1a 00 00       	call   80209f <sys_enable_interrupt>
	return c;
  8005db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <iscons>:

int iscons(int fdnum)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005e8:	5d                   	pop    %ebp
  8005e9:	c3                   	ret    

008005ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005ea:	55                   	push   %ebp
  8005eb:	89 e5                	mov    %esp,%ebp
  8005ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005f0:	e8 83 1c 00 00       	call   802278 <sys_getenvindex>
  8005f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	c1 e0 03             	shl    $0x3,%eax
  800600:	01 d0                	add    %edx,%eax
  800602:	01 c0                	add    %eax,%eax
  800604:	01 d0                	add    %edx,%eax
  800606:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80060d:	01 d0                	add    %edx,%eax
  80060f:	c1 e0 04             	shl    $0x4,%eax
  800612:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800617:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80061c:	a1 24 50 80 00       	mov    0x805024,%eax
  800621:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800627:	84 c0                	test   %al,%al
  800629:	74 0f                	je     80063a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80062b:	a1 24 50 80 00       	mov    0x805024,%eax
  800630:	05 5c 05 00 00       	add    $0x55c,%eax
  800635:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80063a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80063e:	7e 0a                	jle    80064a <libmain+0x60>
		binaryname = argv[0];
  800640:	8b 45 0c             	mov    0xc(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	ff 75 08             	pushl  0x8(%ebp)
  800653:	e8 e0 f9 ff ff       	call   800038 <_main>
  800658:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80065b:	e8 25 1a 00 00       	call   802085 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800660:	83 ec 0c             	sub    $0xc,%esp
  800663:	68 6c 3a 80 00       	push   $0x803a6c
  800668:	e8 6d 03 00 00       	call   8009da <cprintf>
  80066d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800670:	a1 24 50 80 00       	mov    0x805024,%eax
  800675:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80067b:	a1 24 50 80 00       	mov    0x805024,%eax
  800680:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	68 94 3a 80 00       	push   $0x803a94
  800690:	e8 45 03 00 00       	call   8009da <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800698:	a1 24 50 80 00       	mov    0x805024,%eax
  80069d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006a3:	a1 24 50 80 00       	mov    0x805024,%eax
  8006a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006ae:	a1 24 50 80 00       	mov    0x805024,%eax
  8006b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b9:	51                   	push   %ecx
  8006ba:	52                   	push   %edx
  8006bb:	50                   	push   %eax
  8006bc:	68 bc 3a 80 00       	push   $0x803abc
  8006c1:	e8 14 03 00 00       	call   8009da <cprintf>
  8006c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c9:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	50                   	push   %eax
  8006d8:	68 14 3b 80 00       	push   $0x803b14
  8006dd:	e8 f8 02 00 00       	call   8009da <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006e5:	83 ec 0c             	sub    $0xc,%esp
  8006e8:	68 6c 3a 80 00       	push   $0x803a6c
  8006ed:	e8 e8 02 00 00       	call   8009da <cprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006f5:	e8 a5 19 00 00       	call   80209f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006fa:	e8 19 00 00 00       	call   800718 <exit>
}
  8006ff:	90                   	nop
  800700:	c9                   	leave  
  800701:	c3                   	ret    

00800702 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800708:	83 ec 0c             	sub    $0xc,%esp
  80070b:	6a 00                	push   $0x0
  80070d:	e8 32 1b 00 00       	call   802244 <sys_destroy_env>
  800712:	83 c4 10             	add    $0x10,%esp
}
  800715:	90                   	nop
  800716:	c9                   	leave  
  800717:	c3                   	ret    

00800718 <exit>:

void
exit(void)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80071e:	e8 87 1b 00 00       	call   8022aa <sys_exit_env>
}
  800723:	90                   	nop
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80072c:	8d 45 10             	lea    0x10(%ebp),%eax
  80072f:	83 c0 04             	add    $0x4,%eax
  800732:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800735:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80073a:	85 c0                	test   %eax,%eax
  80073c:	74 16                	je     800754 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80073e:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	50                   	push   %eax
  800747:	68 28 3b 80 00       	push   $0x803b28
  80074c:	e8 89 02 00 00       	call   8009da <cprintf>
  800751:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800754:	a1 00 50 80 00       	mov    0x805000,%eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	50                   	push   %eax
  800760:	68 2d 3b 80 00       	push   $0x803b2d
  800765:	e8 70 02 00 00       	call   8009da <cprintf>
  80076a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80076d:	8b 45 10             	mov    0x10(%ebp),%eax
  800770:	83 ec 08             	sub    $0x8,%esp
  800773:	ff 75 f4             	pushl  -0xc(%ebp)
  800776:	50                   	push   %eax
  800777:	e8 f3 01 00 00       	call   80096f <vcprintf>
  80077c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	6a 00                	push   $0x0
  800784:	68 49 3b 80 00       	push   $0x803b49
  800789:	e8 e1 01 00 00       	call   80096f <vcprintf>
  80078e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800791:	e8 82 ff ff ff       	call   800718 <exit>

	// should not return here
	while (1) ;
  800796:	eb fe                	jmp    800796 <_panic+0x70>

00800798 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80079e:	a1 24 50 80 00       	mov    0x805024,%eax
  8007a3:	8b 50 74             	mov    0x74(%eax),%edx
  8007a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a9:	39 c2                	cmp    %eax,%edx
  8007ab:	74 14                	je     8007c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007ad:	83 ec 04             	sub    $0x4,%esp
  8007b0:	68 4c 3b 80 00       	push   $0x803b4c
  8007b5:	6a 26                	push   $0x26
  8007b7:	68 98 3b 80 00       	push   $0x803b98
  8007bc:	e8 65 ff ff ff       	call   800726 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007cf:	e9 c2 00 00 00       	jmp    800896 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	01 d0                	add    %edx,%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	85 c0                	test   %eax,%eax
  8007e7:	75 08                	jne    8007f1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007ec:	e9 a2 00 00 00       	jmp    800893 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ff:	eb 69                	jmp    80086a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800801:	a1 24 50 80 00       	mov    0x805024,%eax
  800806:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80080c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80080f:	89 d0                	mov    %edx,%eax
  800811:	01 c0                	add    %eax,%eax
  800813:	01 d0                	add    %edx,%eax
  800815:	c1 e0 03             	shl    $0x3,%eax
  800818:	01 c8                	add    %ecx,%eax
  80081a:	8a 40 04             	mov    0x4(%eax),%al
  80081d:	84 c0                	test   %al,%al
  80081f:	75 46                	jne    800867 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800821:	a1 24 50 80 00       	mov    0x805024,%eax
  800826:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80082c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082f:	89 d0                	mov    %edx,%eax
  800831:	01 c0                	add    %eax,%eax
  800833:	01 d0                	add    %edx,%eax
  800835:	c1 e0 03             	shl    $0x3,%eax
  800838:	01 c8                	add    %ecx,%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80083f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800842:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800847:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	01 c8                	add    %ecx,%eax
  800858:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	75 09                	jne    800867 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80085e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800865:	eb 12                	jmp    800879 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800867:	ff 45 e8             	incl   -0x18(%ebp)
  80086a:	a1 24 50 80 00       	mov    0x805024,%eax
  80086f:	8b 50 74             	mov    0x74(%eax),%edx
  800872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800875:	39 c2                	cmp    %eax,%edx
  800877:	77 88                	ja     800801 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800879:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80087d:	75 14                	jne    800893 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80087f:	83 ec 04             	sub    $0x4,%esp
  800882:	68 a4 3b 80 00       	push   $0x803ba4
  800887:	6a 3a                	push   $0x3a
  800889:	68 98 3b 80 00       	push   $0x803b98
  80088e:	e8 93 fe ff ff       	call   800726 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800893:	ff 45 f0             	incl   -0x10(%ebp)
  800896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800899:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80089c:	0f 8c 32 ff ff ff    	jl     8007d4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008b0:	eb 26                	jmp    8008d8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c0:	89 d0                	mov    %edx,%eax
  8008c2:	01 c0                	add    %eax,%eax
  8008c4:	01 d0                	add    %edx,%eax
  8008c6:	c1 e0 03             	shl    $0x3,%eax
  8008c9:	01 c8                	add    %ecx,%eax
  8008cb:	8a 40 04             	mov    0x4(%eax),%al
  8008ce:	3c 01                	cmp    $0x1,%al
  8008d0:	75 03                	jne    8008d5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d5:	ff 45 e0             	incl   -0x20(%ebp)
  8008d8:	a1 24 50 80 00       	mov    0x805024,%eax
  8008dd:	8b 50 74             	mov    0x74(%eax),%edx
  8008e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e3:	39 c2                	cmp    %eax,%edx
  8008e5:	77 cb                	ja     8008b2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008ed:	74 14                	je     800903 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008ef:	83 ec 04             	sub    $0x4,%esp
  8008f2:	68 f8 3b 80 00       	push   $0x803bf8
  8008f7:	6a 44                	push   $0x44
  8008f9:	68 98 3b 80 00       	push   $0x803b98
  8008fe:	e8 23 fe ff ff       	call   800726 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800903:	90                   	nop
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80090c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	8d 48 01             	lea    0x1(%eax),%ecx
  800914:	8b 55 0c             	mov    0xc(%ebp),%edx
  800917:	89 0a                	mov    %ecx,(%edx)
  800919:	8b 55 08             	mov    0x8(%ebp),%edx
  80091c:	88 d1                	mov    %dl,%cl
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800921:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80092f:	75 2c                	jne    80095d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800931:	a0 28 50 80 00       	mov    0x805028,%al
  800936:	0f b6 c0             	movzbl %al,%eax
  800939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093c:	8b 12                	mov    (%edx),%edx
  80093e:	89 d1                	mov    %edx,%ecx
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
  800943:	83 c2 08             	add    $0x8,%edx
  800946:	83 ec 04             	sub    $0x4,%esp
  800949:	50                   	push   %eax
  80094a:	51                   	push   %ecx
  80094b:	52                   	push   %edx
  80094c:	e8 86 15 00 00       	call   801ed7 <sys_cputs>
  800951:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8b 40 04             	mov    0x4(%eax),%eax
  800963:	8d 50 01             	lea    0x1(%eax),%edx
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	89 50 04             	mov    %edx,0x4(%eax)
}
  80096c:	90                   	nop
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    

0080096f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800978:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80097f:	00 00 00 
	b.cnt = 0;
  800982:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800989:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	ff 75 08             	pushl  0x8(%ebp)
  800992:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800998:	50                   	push   %eax
  800999:	68 06 09 80 00       	push   $0x800906
  80099e:	e8 11 02 00 00       	call   800bb4 <vprintfmt>
  8009a3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009a6:	a0 28 50 80 00       	mov    0x805028,%al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009b4:	83 ec 04             	sub    $0x4,%esp
  8009b7:	50                   	push   %eax
  8009b8:	52                   	push   %edx
  8009b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009bf:	83 c0 08             	add    $0x8,%eax
  8009c2:	50                   	push   %eax
  8009c3:	e8 0f 15 00 00       	call   801ed7 <sys_cputs>
  8009c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009cb:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  8009d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <cprintf>:

int cprintf(const char *fmt, ...) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009e0:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  8009e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f6:	50                   	push   %eax
  8009f7:	e8 73 ff ff ff       	call   80096f <vcprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a05:	c9                   	leave  
  800a06:	c3                   	ret    

00800a07 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a0d:	e8 73 16 00 00       	call   802085 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a12:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a21:	50                   	push   %eax
  800a22:	e8 48 ff ff ff       	call   80096f <vcprintf>
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a2d:	e8 6d 16 00 00       	call   80209f <sys_enable_interrupt>
	return cnt;
  800a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	53                   	push   %ebx
  800a3b:	83 ec 14             	sub    $0x14,%esp
  800a3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a4a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a52:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a55:	77 55                	ja     800aac <printnum+0x75>
  800a57:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a5a:	72 05                	jb     800a61 <printnum+0x2a>
  800a5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a5f:	77 4b                	ja     800aac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a61:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a64:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a67:	8b 45 18             	mov    0x18(%ebp),%eax
  800a6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a6f:	52                   	push   %edx
  800a70:	50                   	push   %eax
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	ff 75 f0             	pushl  -0x10(%ebp)
  800a77:	e8 d4 2b 00 00       	call   803650 <__udivdi3>
  800a7c:	83 c4 10             	add    $0x10,%esp
  800a7f:	83 ec 04             	sub    $0x4,%esp
  800a82:	ff 75 20             	pushl  0x20(%ebp)
  800a85:	53                   	push   %ebx
  800a86:	ff 75 18             	pushl  0x18(%ebp)
  800a89:	52                   	push   %edx
  800a8a:	50                   	push   %eax
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 a1 ff ff ff       	call   800a37 <printnum>
  800a96:	83 c4 20             	add    $0x20,%esp
  800a99:	eb 1a                	jmp    800ab5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	ff 75 20             	pushl  0x20(%ebp)
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aac:	ff 4d 1c             	decl   0x1c(%ebp)
  800aaf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ab3:	7f e6                	jg     800a9b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ab5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac3:	53                   	push   %ebx
  800ac4:	51                   	push   %ecx
  800ac5:	52                   	push   %edx
  800ac6:	50                   	push   %eax
  800ac7:	e8 94 2c 00 00       	call   803760 <__umoddi3>
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	05 74 3e 80 00       	add    $0x803e74,%eax
  800ad4:	8a 00                	mov    (%eax),%al
  800ad6:	0f be c0             	movsbl %al,%eax
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	50                   	push   %eax
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	ff d0                	call   *%eax
  800ae5:	83 c4 10             	add    $0x10,%esp
}
  800ae8:	90                   	nop
  800ae9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800af1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800af5:	7e 1c                	jle    800b13 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8b 00                	mov    (%eax),%eax
  800afc:	8d 50 08             	lea    0x8(%eax),%edx
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	89 10                	mov    %edx,(%eax)
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	83 e8 08             	sub    $0x8,%eax
  800b0c:	8b 50 04             	mov    0x4(%eax),%edx
  800b0f:	8b 00                	mov    (%eax),%eax
  800b11:	eb 40                	jmp    800b53 <getuint+0x65>
	else if (lflag)
  800b13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b17:	74 1e                	je     800b37 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 50 04             	lea    0x4(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 10                	mov    %edx,(%eax)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	83 e8 04             	sub    $0x4,%eax
  800b2e:	8b 00                	mov    (%eax),%eax
  800b30:	ba 00 00 00 00       	mov    $0x0,%edx
  800b35:	eb 1c                	jmp    800b53 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	8d 50 04             	lea    0x4(%eax),%edx
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	89 10                	mov    %edx,(%eax)
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	8b 00                	mov    (%eax),%eax
  800b49:	83 e8 04             	sub    $0x4,%eax
  800b4c:	8b 00                	mov    (%eax),%eax
  800b4e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b58:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b5c:	7e 1c                	jle    800b7a <getint+0x25>
		return va_arg(*ap, long long);
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	8d 50 08             	lea    0x8(%eax),%edx
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	89 10                	mov    %edx,(%eax)
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	83 e8 08             	sub    $0x8,%eax
  800b73:	8b 50 04             	mov    0x4(%eax),%edx
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	eb 38                	jmp    800bb2 <getint+0x5d>
	else if (lflag)
  800b7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7e:	74 1a                	je     800b9a <getint+0x45>
		return va_arg(*ap, long);
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	8d 50 04             	lea    0x4(%eax),%edx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 10                	mov    %edx,(%eax)
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	83 e8 04             	sub    $0x4,%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	99                   	cltd   
  800b98:	eb 18                	jmp    800bb2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	8d 50 04             	lea    0x4(%eax),%edx
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	89 10                	mov    %edx,(%eax)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 00                	mov    (%eax),%eax
  800bac:	83 e8 04             	sub    $0x4,%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	99                   	cltd   
}
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bbc:	eb 17                	jmp    800bd5 <vprintfmt+0x21>
			if (ch == '\0')
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	0f 84 af 03 00 00    	je     800f75 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	53                   	push   %ebx
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	ff d0                	call   *%eax
  800bd2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd8:	8d 50 01             	lea    0x1(%eax),%edx
  800bdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	0f b6 d8             	movzbl %al,%ebx
  800be3:	83 fb 25             	cmp    $0x25,%ebx
  800be6:	75 d6                	jne    800bbe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bf3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 d8             	movzbl %al,%ebx
  800c16:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c19:	83 f8 55             	cmp    $0x55,%eax
  800c1c:	0f 87 2b 03 00 00    	ja     800f4d <vprintfmt+0x399>
  800c22:	8b 04 85 98 3e 80 00 	mov    0x803e98(,%eax,4),%eax
  800c29:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c2b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c2f:	eb d7                	jmp    800c08 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c31:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c35:	eb d1                	jmp    800c08 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c37:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c41:	89 d0                	mov    %edx,%eax
  800c43:	c1 e0 02             	shl    $0x2,%eax
  800c46:	01 d0                	add    %edx,%eax
  800c48:	01 c0                	add    %eax,%eax
  800c4a:	01 d8                	add    %ebx,%eax
  800c4c:	83 e8 30             	sub    $0x30,%eax
  800c4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c5a:	83 fb 2f             	cmp    $0x2f,%ebx
  800c5d:	7e 3e                	jle    800c9d <vprintfmt+0xe9>
  800c5f:	83 fb 39             	cmp    $0x39,%ebx
  800c62:	7f 39                	jg     800c9d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c64:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c67:	eb d5                	jmp    800c3e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	83 e8 04             	sub    $0x4,%eax
  800c78:	8b 00                	mov    (%eax),%eax
  800c7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c7d:	eb 1f                	jmp    800c9e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c83:	79 83                	jns    800c08 <vprintfmt+0x54>
				width = 0;
  800c85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c8c:	e9 77 ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c91:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c98:	e9 6b ff ff ff       	jmp    800c08 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c9d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca2:	0f 89 60 ff ff ff    	jns    800c08 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cb5:	e9 4e ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cbd:	e9 46 ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc5:	83 c0 04             	add    $0x4,%eax
  800cc8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cce:	83 e8 04             	sub    $0x4,%eax
  800cd1:	8b 00                	mov    (%eax),%eax
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	50                   	push   %eax
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	ff d0                	call   *%eax
  800cdf:	83 c4 10             	add    $0x10,%esp
			break;
  800ce2:	e9 89 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 c0 04             	add    $0x4,%eax
  800ced:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf3:	83 e8 04             	sub    $0x4,%eax
  800cf6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf8:	85 db                	test   %ebx,%ebx
  800cfa:	79 02                	jns    800cfe <vprintfmt+0x14a>
				err = -err;
  800cfc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cfe:	83 fb 64             	cmp    $0x64,%ebx
  800d01:	7f 0b                	jg     800d0e <vprintfmt+0x15a>
  800d03:	8b 34 9d e0 3c 80 00 	mov    0x803ce0(,%ebx,4),%esi
  800d0a:	85 f6                	test   %esi,%esi
  800d0c:	75 19                	jne    800d27 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d0e:	53                   	push   %ebx
  800d0f:	68 85 3e 80 00       	push   $0x803e85
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 5e 02 00 00       	call   800f7d <printfmt>
  800d1f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d22:	e9 49 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d27:	56                   	push   %esi
  800d28:	68 8e 3e 80 00       	push   $0x803e8e
  800d2d:	ff 75 0c             	pushl  0xc(%ebp)
  800d30:	ff 75 08             	pushl  0x8(%ebp)
  800d33:	e8 45 02 00 00       	call   800f7d <printfmt>
  800d38:	83 c4 10             	add    $0x10,%esp
			break;
  800d3b:	e9 30 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 c0 04             	add    $0x4,%eax
  800d46:	89 45 14             	mov    %eax,0x14(%ebp)
  800d49:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4c:	83 e8 04             	sub    $0x4,%eax
  800d4f:	8b 30                	mov    (%eax),%esi
  800d51:	85 f6                	test   %esi,%esi
  800d53:	75 05                	jne    800d5a <vprintfmt+0x1a6>
				p = "(null)";
  800d55:	be 91 3e 80 00       	mov    $0x803e91,%esi
			if (width > 0 && padc != '-')
  800d5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d5e:	7e 6d                	jle    800dcd <vprintfmt+0x219>
  800d60:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d64:	74 67                	je     800dcd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d69:	83 ec 08             	sub    $0x8,%esp
  800d6c:	50                   	push   %eax
  800d6d:	56                   	push   %esi
  800d6e:	e8 12 05 00 00       	call   801285 <strnlen>
  800d73:	83 c4 10             	add    $0x10,%esp
  800d76:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d79:	eb 16                	jmp    800d91 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d7b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 0c             	pushl  0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	ff d0                	call   *%eax
  800d8b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800d91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d95:	7f e4                	jg     800d7b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d97:	eb 34                	jmp    800dcd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d99:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d9d:	74 1c                	je     800dbb <vprintfmt+0x207>
  800d9f:	83 fb 1f             	cmp    $0x1f,%ebx
  800da2:	7e 05                	jle    800da9 <vprintfmt+0x1f5>
  800da4:	83 fb 7e             	cmp    $0x7e,%ebx
  800da7:	7e 12                	jle    800dbb <vprintfmt+0x207>
					putch('?', putdat);
  800da9:	83 ec 08             	sub    $0x8,%esp
  800dac:	ff 75 0c             	pushl  0xc(%ebp)
  800daf:	6a 3f                	push   $0x3f
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	ff d0                	call   *%eax
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	eb 0f                	jmp    800dca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	53                   	push   %ebx
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	ff d0                	call   *%eax
  800dc7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dca:	ff 4d e4             	decl   -0x1c(%ebp)
  800dcd:	89 f0                	mov    %esi,%eax
  800dcf:	8d 70 01             	lea    0x1(%eax),%esi
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f be d8             	movsbl %al,%ebx
  800dd7:	85 db                	test   %ebx,%ebx
  800dd9:	74 24                	je     800dff <vprintfmt+0x24b>
  800ddb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ddf:	78 b8                	js     800d99 <vprintfmt+0x1e5>
  800de1:	ff 4d e0             	decl   -0x20(%ebp)
  800de4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de8:	79 af                	jns    800d99 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dea:	eb 13                	jmp    800dff <vprintfmt+0x24b>
				putch(' ', putdat);
  800dec:	83 ec 08             	sub    $0x8,%esp
  800def:	ff 75 0c             	pushl  0xc(%ebp)
  800df2:	6a 20                	push   $0x20
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	ff d0                	call   *%eax
  800df9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dfc:	ff 4d e4             	decl   -0x1c(%ebp)
  800dff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e03:	7f e7                	jg     800dec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e05:	e9 66 01 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e0a:	83 ec 08             	sub    $0x8,%esp
  800e0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800e10:	8d 45 14             	lea    0x14(%ebp),%eax
  800e13:	50                   	push   %eax
  800e14:	e8 3c fd ff ff       	call   800b55 <getint>
  800e19:	83 c4 10             	add    $0x10,%esp
  800e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e28:	85 d2                	test   %edx,%edx
  800e2a:	79 23                	jns    800e4f <vprintfmt+0x29b>
				putch('-', putdat);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	6a 2d                	push   $0x2d
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e42:	f7 d8                	neg    %eax
  800e44:	83 d2 00             	adc    $0x0,%edx
  800e47:	f7 da                	neg    %edx
  800e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e56:	e9 bc 00 00 00       	jmp    800f17 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800e61:	8d 45 14             	lea    0x14(%ebp),%eax
  800e64:	50                   	push   %eax
  800e65:	e8 84 fc ff ff       	call   800aee <getuint>
  800e6a:	83 c4 10             	add    $0x10,%esp
  800e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e7a:	e9 98 00 00 00       	jmp    800f17 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 58                	push   $0x58
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e8f:	83 ec 08             	sub    $0x8,%esp
  800e92:	ff 75 0c             	pushl  0xc(%ebp)
  800e95:	6a 58                	push   $0x58
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	ff d0                	call   *%eax
  800e9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	6a 58                	push   $0x58
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			break;
  800eaf:	e9 bc 00 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eb4:	83 ec 08             	sub    $0x8,%esp
  800eb7:	ff 75 0c             	pushl  0xc(%ebp)
  800eba:	6a 30                	push   $0x30
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	ff d0                	call   *%eax
  800ec1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ec4:	83 ec 08             	sub    $0x8,%esp
  800ec7:	ff 75 0c             	pushl  0xc(%ebp)
  800eca:	6a 78                	push   $0x78
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	ff d0                	call   *%eax
  800ed1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ed4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed7:	83 c0 04             	add    $0x4,%eax
  800eda:	89 45 14             	mov    %eax,0x14(%ebp)
  800edd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee0:	83 e8 04             	sub    $0x4,%eax
  800ee3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ef6:	eb 1f                	jmp    800f17 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef8:	83 ec 08             	sub    $0x8,%esp
  800efb:	ff 75 e8             	pushl  -0x18(%ebp)
  800efe:	8d 45 14             	lea    0x14(%ebp),%eax
  800f01:	50                   	push   %eax
  800f02:	e8 e7 fb ff ff       	call   800aee <getuint>
  800f07:	83 c4 10             	add    $0x10,%esp
  800f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f17:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f1e:	83 ec 04             	sub    $0x4,%esp
  800f21:	52                   	push   %edx
  800f22:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f25:	50                   	push   %eax
  800f26:	ff 75 f4             	pushl  -0xc(%ebp)
  800f29:	ff 75 f0             	pushl  -0x10(%ebp)
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	ff 75 08             	pushl  0x8(%ebp)
  800f32:	e8 00 fb ff ff       	call   800a37 <printnum>
  800f37:	83 c4 20             	add    $0x20,%esp
			break;
  800f3a:	eb 34                	jmp    800f70 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f3c:	83 ec 08             	sub    $0x8,%esp
  800f3f:	ff 75 0c             	pushl  0xc(%ebp)
  800f42:	53                   	push   %ebx
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	ff d0                	call   *%eax
  800f48:	83 c4 10             	add    $0x10,%esp
			break;
  800f4b:	eb 23                	jmp    800f70 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	6a 25                	push   $0x25
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	ff d0                	call   *%eax
  800f5a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f5d:	ff 4d 10             	decl   0x10(%ebp)
  800f60:	eb 03                	jmp    800f65 <vprintfmt+0x3b1>
  800f62:	ff 4d 10             	decl   0x10(%ebp)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	48                   	dec    %eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	3c 25                	cmp    $0x25,%al
  800f6d:	75 f3                	jne    800f62 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f6f:	90                   	nop
		}
	}
  800f70:	e9 47 fc ff ff       	jmp    800bbc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f75:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    

00800f7d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f83:	8d 45 10             	lea    0x10(%ebp),%eax
  800f86:	83 c0 04             	add    $0x4,%eax
  800f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	50                   	push   %eax
  800f93:	ff 75 0c             	pushl  0xc(%ebp)
  800f96:	ff 75 08             	pushl  0x8(%ebp)
  800f99:	e8 16 fc ff ff       	call   800bb4 <vprintfmt>
  800f9e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fa1:	90                   	nop
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faa:	8b 40 08             	mov    0x8(%eax),%eax
  800fad:	8d 50 01             	lea    0x1(%eax),%edx
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8b 10                	mov    (%eax),%edx
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	8b 40 04             	mov    0x4(%eax),%eax
  800fc1:	39 c2                	cmp    %eax,%edx
  800fc3:	73 12                	jae    800fd7 <sprintputch+0x33>
		*b->buf++ = ch;
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	8b 00                	mov    (%eax),%eax
  800fca:	8d 48 01             	lea    0x1(%eax),%ecx
  800fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd0:	89 0a                	mov    %ecx,(%edx)
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	88 10                	mov    %dl,(%eax)
}
  800fd7:	90                   	nop
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	01 d0                	add    %edx,%eax
  800ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ffb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fff:	74 06                	je     801007 <vsnprintf+0x2d>
  801001:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801005:	7f 07                	jg     80100e <vsnprintf+0x34>
		return -E_INVAL;
  801007:	b8 03 00 00 00       	mov    $0x3,%eax
  80100c:	eb 20                	jmp    80102e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80100e:	ff 75 14             	pushl  0x14(%ebp)
  801011:	ff 75 10             	pushl  0x10(%ebp)
  801014:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801017:	50                   	push   %eax
  801018:	68 a4 0f 80 00       	push   $0x800fa4
  80101d:	e8 92 fb ff ff       	call   800bb4 <vprintfmt>
  801022:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801028:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80102b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    

00801030 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801036:	8d 45 10             	lea    0x10(%ebp),%eax
  801039:	83 c0 04             	add    $0x4,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	ff 75 f4             	pushl  -0xc(%ebp)
  801045:	50                   	push   %eax
  801046:	ff 75 0c             	pushl  0xc(%ebp)
  801049:	ff 75 08             	pushl  0x8(%ebp)
  80104c:	e8 89 ff ff ff       	call   800fda <vsnprintf>
  801051:	83 c4 10             	add    $0x10,%esp
  801054:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801057:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    

0080105c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801066:	74 13                	je     80107b <readline+0x1f>
		cprintf("%s", prompt);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	ff 75 08             	pushl  0x8(%ebp)
  80106e:	68 f0 3f 80 00       	push   $0x803ff0
  801073:	e8 62 f9 ff ff       	call   8009da <cprintf>
  801078:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80107b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801082:	83 ec 0c             	sub    $0xc,%esp
  801085:	6a 00                	push   $0x0
  801087:	e8 54 f5 ff ff       	call   8005e0 <iscons>
  80108c:	83 c4 10             	add    $0x10,%esp
  80108f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801092:	e8 fb f4 ff ff       	call   800592 <getchar>
  801097:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80109a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80109e:	79 22                	jns    8010c2 <readline+0x66>
			if (c != -E_EOF)
  8010a0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010a4:	0f 84 ad 00 00 00    	je     801157 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 ec             	pushl  -0x14(%ebp)
  8010b0:	68 f3 3f 80 00       	push   $0x803ff3
  8010b5:	e8 20 f9 ff ff       	call   8009da <cprintf>
  8010ba:	83 c4 10             	add    $0x10,%esp
			return;
  8010bd:	e9 95 00 00 00       	jmp    801157 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010c2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010c6:	7e 34                	jle    8010fc <readline+0xa0>
  8010c8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8010cf:	7f 2b                	jg     8010fc <readline+0xa0>
			if (echoing)
  8010d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010d5:	74 0e                	je     8010e5 <readline+0x89>
				cputchar(c);
  8010d7:	83 ec 0c             	sub    $0xc,%esp
  8010da:	ff 75 ec             	pushl  -0x14(%ebp)
  8010dd:	e8 68 f4 ff ff       	call   80054a <cputchar>
  8010e2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8010e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f8:	88 10                	mov    %dl,(%eax)
  8010fa:	eb 56                	jmp    801152 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8010fc:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801100:	75 1f                	jne    801121 <readline+0xc5>
  801102:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801106:	7e 19                	jle    801121 <readline+0xc5>
			if (echoing)
  801108:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80110c:	74 0e                	je     80111c <readline+0xc0>
				cputchar(c);
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	ff 75 ec             	pushl  -0x14(%ebp)
  801114:	e8 31 f4 ff ff       	call   80054a <cputchar>
  801119:	83 c4 10             	add    $0x10,%esp

			i--;
  80111c:	ff 4d f4             	decl   -0xc(%ebp)
  80111f:	eb 31                	jmp    801152 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801121:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801125:	74 0a                	je     801131 <readline+0xd5>
  801127:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80112b:	0f 85 61 ff ff ff    	jne    801092 <readline+0x36>
			if (echoing)
  801131:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801135:	74 0e                	je     801145 <readline+0xe9>
				cputchar(c);
  801137:	83 ec 0c             	sub    $0xc,%esp
  80113a:	ff 75 ec             	pushl  -0x14(%ebp)
  80113d:	e8 08 f4 ff ff       	call   80054a <cputchar>
  801142:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801145:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801150:	eb 06                	jmp    801158 <readline+0xfc>
		}
	}
  801152:	e9 3b ff ff ff       	jmp    801092 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801157:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801160:	e8 20 0f 00 00       	call   802085 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801169:	74 13                	je     80117e <atomic_readline+0x24>
		cprintf("%s", prompt);
  80116b:	83 ec 08             	sub    $0x8,%esp
  80116e:	ff 75 08             	pushl  0x8(%ebp)
  801171:	68 f0 3f 80 00       	push   $0x803ff0
  801176:	e8 5f f8 ff ff       	call   8009da <cprintf>
  80117b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80117e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801185:	83 ec 0c             	sub    $0xc,%esp
  801188:	6a 00                	push   $0x0
  80118a:	e8 51 f4 ff ff       	call   8005e0 <iscons>
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801195:	e8 f8 f3 ff ff       	call   800592 <getchar>
  80119a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80119d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011a1:	79 23                	jns    8011c6 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011a3:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011a7:	74 13                	je     8011bc <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8011a9:	83 ec 08             	sub    $0x8,%esp
  8011ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8011af:	68 f3 3f 80 00       	push   $0x803ff3
  8011b4:	e8 21 f8 ff ff       	call   8009da <cprintf>
  8011b9:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011bc:	e8 de 0e 00 00       	call   80209f <sys_enable_interrupt>
			return;
  8011c1:	e9 9a 00 00 00       	jmp    801260 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011c6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011ca:	7e 34                	jle    801200 <atomic_readline+0xa6>
  8011cc:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011d3:	7f 2b                	jg     801200 <atomic_readline+0xa6>
			if (echoing)
  8011d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011d9:	74 0e                	je     8011e9 <atomic_readline+0x8f>
				cputchar(c);
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e1:	e8 64 f3 ff ff       	call   80054a <cputchar>
  8011e6:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ec:	8d 50 01             	lea    0x1(%eax),%edx
  8011ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011f2:	89 c2                	mov    %eax,%edx
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	01 d0                	add    %edx,%eax
  8011f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011fc:	88 10                	mov    %dl,(%eax)
  8011fe:	eb 5b                	jmp    80125b <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801200:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801204:	75 1f                	jne    801225 <atomic_readline+0xcb>
  801206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80120a:	7e 19                	jle    801225 <atomic_readline+0xcb>
			if (echoing)
  80120c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801210:	74 0e                	je     801220 <atomic_readline+0xc6>
				cputchar(c);
  801212:	83 ec 0c             	sub    $0xc,%esp
  801215:	ff 75 ec             	pushl  -0x14(%ebp)
  801218:	e8 2d f3 ff ff       	call   80054a <cputchar>
  80121d:	83 c4 10             	add    $0x10,%esp
			i--;
  801220:	ff 4d f4             	decl   -0xc(%ebp)
  801223:	eb 36                	jmp    80125b <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801225:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801229:	74 0a                	je     801235 <atomic_readline+0xdb>
  80122b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80122f:	0f 85 60 ff ff ff    	jne    801195 <atomic_readline+0x3b>
			if (echoing)
  801235:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801239:	74 0e                	je     801249 <atomic_readline+0xef>
				cputchar(c);
  80123b:	83 ec 0c             	sub    $0xc,%esp
  80123e:	ff 75 ec             	pushl  -0x14(%ebp)
  801241:	e8 04 f3 ff ff       	call   80054a <cputchar>
  801246:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801249:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124f:	01 d0                	add    %edx,%eax
  801251:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801254:	e8 46 0e 00 00       	call   80209f <sys_enable_interrupt>
			return;
  801259:	eb 05                	jmp    801260 <atomic_readline+0x106>
		}
	}
  80125b:	e9 35 ff ff ff       	jmp    801195 <atomic_readline+0x3b>
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801268:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126f:	eb 06                	jmp    801277 <strlen+0x15>
		n++;
  801271:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801274:	ff 45 08             	incl   0x8(%ebp)
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	84 c0                	test   %al,%al
  80127e:	75 f1                	jne    801271 <strlen+0xf>
		n++;
	return n;
  801280:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80128b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801292:	eb 09                	jmp    80129d <strnlen+0x18>
		n++;
  801294:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801297:	ff 45 08             	incl   0x8(%ebp)
  80129a:	ff 4d 0c             	decl   0xc(%ebp)
  80129d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a1:	74 09                	je     8012ac <strnlen+0x27>
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	84 c0                	test   %al,%al
  8012aa:	75 e8                	jne    801294 <strnlen+0xf>
		n++;
	return n;
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012bd:	90                   	nop
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012cd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012d0:	8a 12                	mov    (%edx),%dl
  8012d2:	88 10                	mov    %dl,(%eax)
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 e4                	jne    8012be <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f2:	eb 1f                	jmp    801313 <strncpy+0x34>
		*dst++ = *src;
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	8a 12                	mov    (%edx),%dl
  801302:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801304:	8b 45 0c             	mov    0xc(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	84 c0                	test   %al,%al
  80130b:	74 03                	je     801310 <strncpy+0x31>
			src++;
  80130d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801310:	ff 45 fc             	incl   -0x4(%ebp)
  801313:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801316:	3b 45 10             	cmp    0x10(%ebp),%eax
  801319:	72 d9                	jb     8012f4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80132c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801330:	74 30                	je     801362 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801332:	eb 16                	jmp    80134a <strlcpy+0x2a>
			*dst++ = *src++;
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8d 50 01             	lea    0x1(%eax),%edx
  80133a:	89 55 08             	mov    %edx,0x8(%ebp)
  80133d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801340:	8d 4a 01             	lea    0x1(%edx),%ecx
  801343:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801346:	8a 12                	mov    (%edx),%dl
  801348:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80134a:	ff 4d 10             	decl   0x10(%ebp)
  80134d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801351:	74 09                	je     80135c <strlcpy+0x3c>
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	84 c0                	test   %al,%al
  80135a:	75 d8                	jne    801334 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801362:	8b 55 08             	mov    0x8(%ebp),%edx
  801365:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801368:	29 c2                	sub    %eax,%edx
  80136a:	89 d0                	mov    %edx,%eax
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801371:	eb 06                	jmp    801379 <strcmp+0xb>
		p++, q++;
  801373:	ff 45 08             	incl   0x8(%ebp)
  801376:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	84 c0                	test   %al,%al
  801380:	74 0e                	je     801390 <strcmp+0x22>
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 10                	mov    (%eax),%dl
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	38 c2                	cmp    %al,%dl
  80138e:	74 e3                	je     801373 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	0f b6 d0             	movzbl %al,%edx
  801398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f b6 c0             	movzbl %al,%eax
  8013a0:	29 c2                	sub    %eax,%edx
  8013a2:	89 d0                	mov    %edx,%eax
}
  8013a4:	5d                   	pop    %ebp
  8013a5:	c3                   	ret    

008013a6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013a9:	eb 09                	jmp    8013b4 <strncmp+0xe>
		n--, p++, q++;
  8013ab:	ff 4d 10             	decl   0x10(%ebp)
  8013ae:	ff 45 08             	incl   0x8(%ebp)
  8013b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b8:	74 17                	je     8013d1 <strncmp+0x2b>
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	84 c0                	test   %al,%al
  8013c1:	74 0e                	je     8013d1 <strncmp+0x2b>
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 10                	mov    (%eax),%dl
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	38 c2                	cmp    %al,%dl
  8013cf:	74 da                	je     8013ab <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d5:	75 07                	jne    8013de <strncmp+0x38>
		return 0;
  8013d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013dc:	eb 14                	jmp    8013f2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	8a 00                	mov    (%eax),%al
  8013e3:	0f b6 d0             	movzbl %al,%edx
  8013e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	0f b6 c0             	movzbl %al,%eax
  8013ee:	29 c2                	sub    %eax,%edx
  8013f0:	89 d0                	mov    %edx,%eax
}
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801400:	eb 12                	jmp    801414 <strchr+0x20>
		if (*s == c)
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80140a:	75 05                	jne    801411 <strchr+0x1d>
			return (char *) s;
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	eb 11                	jmp    801422 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801411:	ff 45 08             	incl   0x8(%ebp)
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	75 e5                	jne    801402 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80141d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 04             	sub    $0x4,%esp
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801430:	eb 0d                	jmp    80143f <strfind+0x1b>
		if (*s == c)
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80143a:	74 0e                	je     80144a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80143c:	ff 45 08             	incl   0x8(%ebp)
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	84 c0                	test   %al,%al
  801446:	75 ea                	jne    801432 <strfind+0xe>
  801448:	eb 01                	jmp    80144b <strfind+0x27>
		if (*s == c)
			break;
  80144a:	90                   	nop
	return (char *) s;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80145c:	8b 45 10             	mov    0x10(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801462:	eb 0e                	jmp    801472 <memset+0x22>
		*p++ = c;
  801464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801467:	8d 50 01             	lea    0x1(%eax),%edx
  80146a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80146d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801470:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801472:	ff 4d f8             	decl   -0x8(%ebp)
  801475:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801479:	79 e9                	jns    801464 <memset+0x14>
		*p++ = c;

	return v;
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801486:	8b 45 0c             	mov    0xc(%ebp),%eax
  801489:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801492:	eb 16                	jmp    8014aa <memcpy+0x2a>
		*d++ = *s++;
  801494:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801497:	8d 50 01             	lea    0x1(%eax),%edx
  80149a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80149d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014a6:	8a 12                	mov    (%edx),%dl
  8014a8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	75 dd                	jne    801494 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014d4:	73 50                	jae    801526 <memmove+0x6a>
  8014d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014e1:	76 43                	jbe    801526 <memmove+0x6a>
		s += n;
  8014e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014ef:	eb 10                	jmp    801501 <memmove+0x45>
			*--d = *--s;
  8014f1:	ff 4d f8             	decl   -0x8(%ebp)
  8014f4:	ff 4d fc             	decl   -0x4(%ebp)
  8014f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fa:	8a 10                	mov    (%eax),%dl
  8014fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ff:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801501:	8b 45 10             	mov    0x10(%ebp),%eax
  801504:	8d 50 ff             	lea    -0x1(%eax),%edx
  801507:	89 55 10             	mov    %edx,0x10(%ebp)
  80150a:	85 c0                	test   %eax,%eax
  80150c:	75 e3                	jne    8014f1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80150e:	eb 23                	jmp    801533 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801510:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801513:	8d 50 01             	lea    0x1(%eax),%edx
  801516:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801519:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801522:	8a 12                	mov    (%edx),%dl
  801524:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801526:	8b 45 10             	mov    0x10(%ebp),%eax
  801529:	8d 50 ff             	lea    -0x1(%eax),%edx
  80152c:	89 55 10             	mov    %edx,0x10(%ebp)
  80152f:	85 c0                	test   %eax,%eax
  801531:	75 dd                	jne    801510 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801544:	8b 45 0c             	mov    0xc(%ebp),%eax
  801547:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80154a:	eb 2a                	jmp    801576 <memcmp+0x3e>
		if (*s1 != *s2)
  80154c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154f:	8a 10                	mov    (%eax),%dl
  801551:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	38 c2                	cmp    %al,%dl
  801558:	74 16                	je     801570 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80155a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155d:	8a 00                	mov    (%eax),%al
  80155f:	0f b6 d0             	movzbl %al,%edx
  801562:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	0f b6 c0             	movzbl %al,%eax
  80156a:	29 c2                	sub    %eax,%edx
  80156c:	89 d0                	mov    %edx,%eax
  80156e:	eb 18                	jmp    801588 <memcmp+0x50>
		s1++, s2++;
  801570:	ff 45 fc             	incl   -0x4(%ebp)
  801573:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	8d 50 ff             	lea    -0x1(%eax),%edx
  80157c:	89 55 10             	mov    %edx,0x10(%ebp)
  80157f:	85 c0                	test   %eax,%eax
  801581:	75 c9                	jne    80154c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801583:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801590:	8b 55 08             	mov    0x8(%ebp),%edx
  801593:	8b 45 10             	mov    0x10(%ebp),%eax
  801596:	01 d0                	add    %edx,%eax
  801598:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80159b:	eb 15                	jmp    8015b2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	0f b6 d0             	movzbl %al,%edx
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	0f b6 c0             	movzbl %al,%eax
  8015ab:	39 c2                	cmp    %eax,%edx
  8015ad:	74 0d                	je     8015bc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015b8:	72 e3                	jb     80159d <memfind+0x13>
  8015ba:	eb 01                	jmp    8015bd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015bc:	90                   	nop
	return (void *) s;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d6:	eb 03                	jmp    8015db <strtol+0x19>
		s++;
  8015d8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 20                	cmp    $0x20,%al
  8015e2:	74 f4                	je     8015d8 <strtol+0x16>
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	8a 00                	mov    (%eax),%al
  8015e9:	3c 09                	cmp    $0x9,%al
  8015eb:	74 eb                	je     8015d8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	8a 00                	mov    (%eax),%al
  8015f2:	3c 2b                	cmp    $0x2b,%al
  8015f4:	75 05                	jne    8015fb <strtol+0x39>
		s++;
  8015f6:	ff 45 08             	incl   0x8(%ebp)
  8015f9:	eb 13                	jmp    80160e <strtol+0x4c>
	else if (*s == '-')
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	8a 00                	mov    (%eax),%al
  801600:	3c 2d                	cmp    $0x2d,%al
  801602:	75 0a                	jne    80160e <strtol+0x4c>
		s++, neg = 1;
  801604:	ff 45 08             	incl   0x8(%ebp)
  801607:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80160e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801612:	74 06                	je     80161a <strtol+0x58>
  801614:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801618:	75 20                	jne    80163a <strtol+0x78>
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	3c 30                	cmp    $0x30,%al
  801621:	75 17                	jne    80163a <strtol+0x78>
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	40                   	inc    %eax
  801627:	8a 00                	mov    (%eax),%al
  801629:	3c 78                	cmp    $0x78,%al
  80162b:	75 0d                	jne    80163a <strtol+0x78>
		s += 2, base = 16;
  80162d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801631:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801638:	eb 28                	jmp    801662 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80163a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163e:	75 15                	jne    801655 <strtol+0x93>
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	8a 00                	mov    (%eax),%al
  801645:	3c 30                	cmp    $0x30,%al
  801647:	75 0c                	jne    801655 <strtol+0x93>
		s++, base = 8;
  801649:	ff 45 08             	incl   0x8(%ebp)
  80164c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801653:	eb 0d                	jmp    801662 <strtol+0xa0>
	else if (base == 0)
  801655:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801659:	75 07                	jne    801662 <strtol+0xa0>
		base = 10;
  80165b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	3c 2f                	cmp    $0x2f,%al
  801669:	7e 19                	jle    801684 <strtol+0xc2>
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	3c 39                	cmp    $0x39,%al
  801672:	7f 10                	jg     801684 <strtol+0xc2>
			dig = *s - '0';
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	0f be c0             	movsbl %al,%eax
  80167c:	83 e8 30             	sub    $0x30,%eax
  80167f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801682:	eb 42                	jmp    8016c6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	8a 00                	mov    (%eax),%al
  801689:	3c 60                	cmp    $0x60,%al
  80168b:	7e 19                	jle    8016a6 <strtol+0xe4>
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	3c 7a                	cmp    $0x7a,%al
  801694:	7f 10                	jg     8016a6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	8a 00                	mov    (%eax),%al
  80169b:	0f be c0             	movsbl %al,%eax
  80169e:	83 e8 57             	sub    $0x57,%eax
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016a4:	eb 20                	jmp    8016c6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	8a 00                	mov    (%eax),%al
  8016ab:	3c 40                	cmp    $0x40,%al
  8016ad:	7e 39                	jle    8016e8 <strtol+0x126>
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8a 00                	mov    (%eax),%al
  8016b4:	3c 5a                	cmp    $0x5a,%al
  8016b6:	7f 30                	jg     8016e8 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	8a 00                	mov    (%eax),%al
  8016bd:	0f be c0             	movsbl %al,%eax
  8016c0:	83 e8 37             	sub    $0x37,%eax
  8016c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016cc:	7d 19                	jge    8016e7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016ce:	ff 45 08             	incl   0x8(%ebp)
  8016d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016d8:	89 c2                	mov    %eax,%edx
  8016da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dd:	01 d0                	add    %edx,%eax
  8016df:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016e2:	e9 7b ff ff ff       	jmp    801662 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016e7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ec:	74 08                	je     8016f6 <strtol+0x134>
		*endptr = (char *) s;
  8016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016fa:	74 07                	je     801703 <strtol+0x141>
  8016fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ff:	f7 d8                	neg    %eax
  801701:	eb 03                	jmp    801706 <strtol+0x144>
  801703:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <ltostr>:

void
ltostr(long value, char *str)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80170e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801715:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80171c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801720:	79 13                	jns    801735 <ltostr+0x2d>
	{
		neg = 1;
  801722:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80172f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801732:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80173d:	99                   	cltd   
  80173e:	f7 f9                	idiv   %ecx
  801740:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801743:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801746:	8d 50 01             	lea    0x1(%eax),%edx
  801749:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80174c:	89 c2                	mov    %eax,%edx
  80174e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801751:	01 d0                	add    %edx,%eax
  801753:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801756:	83 c2 30             	add    $0x30,%edx
  801759:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80175b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80175e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801763:	f7 e9                	imul   %ecx
  801765:	c1 fa 02             	sar    $0x2,%edx
  801768:	89 c8                	mov    %ecx,%eax
  80176a:	c1 f8 1f             	sar    $0x1f,%eax
  80176d:	29 c2                	sub    %eax,%edx
  80176f:	89 d0                	mov    %edx,%eax
  801771:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801774:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801777:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80177c:	f7 e9                	imul   %ecx
  80177e:	c1 fa 02             	sar    $0x2,%edx
  801781:	89 c8                	mov    %ecx,%eax
  801783:	c1 f8 1f             	sar    $0x1f,%eax
  801786:	29 c2                	sub    %eax,%edx
  801788:	89 d0                	mov    %edx,%eax
  80178a:	c1 e0 02             	shl    $0x2,%eax
  80178d:	01 d0                	add    %edx,%eax
  80178f:	01 c0                	add    %eax,%eax
  801791:	29 c1                	sub    %eax,%ecx
  801793:	89 ca                	mov    %ecx,%edx
  801795:	85 d2                	test   %edx,%edx
  801797:	75 9c                	jne    801735 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801799:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a3:	48                   	dec    %eax
  8017a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017ab:	74 3d                	je     8017ea <ltostr+0xe2>
		start = 1 ;
  8017ad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017b4:	eb 34                	jmp    8017ea <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8a 00                	mov    (%eax),%al
  8017c0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	01 c2                	add    %eax,%edx
  8017cb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d1:	01 c8                	add    %ecx,%eax
  8017d3:	8a 00                	mov    (%eax),%al
  8017d5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	01 c2                	add    %eax,%edx
  8017df:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017e2:	88 02                	mov    %al,(%edx)
		start++ ;
  8017e4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017e7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017f0:	7c c4                	jl     8017b6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017fd:	90                   	nop
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801806:	ff 75 08             	pushl  0x8(%ebp)
  801809:	e8 54 fa ff ff       	call   801262 <strlen>
  80180e:	83 c4 04             	add    $0x4,%esp
  801811:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	e8 46 fa ff ff       	call   801262 <strlen>
  80181c:	83 c4 04             	add    $0x4,%esp
  80181f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801822:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801829:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801830:	eb 17                	jmp    801849 <strcconcat+0x49>
		final[s] = str1[s] ;
  801832:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801835:	8b 45 10             	mov    0x10(%ebp),%eax
  801838:	01 c2                	add    %eax,%edx
  80183a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	01 c8                	add    %ecx,%eax
  801842:	8a 00                	mov    (%eax),%al
  801844:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801846:	ff 45 fc             	incl   -0x4(%ebp)
  801849:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80184f:	7c e1                	jl     801832 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801851:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801858:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80185f:	eb 1f                	jmp    801880 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801861:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801864:	8d 50 01             	lea    0x1(%eax),%edx
  801867:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80186a:	89 c2                	mov    %eax,%edx
  80186c:	8b 45 10             	mov    0x10(%ebp),%eax
  80186f:	01 c2                	add    %eax,%edx
  801871:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801874:	8b 45 0c             	mov    0xc(%ebp),%eax
  801877:	01 c8                	add    %ecx,%eax
  801879:	8a 00                	mov    (%eax),%al
  80187b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80187d:	ff 45 f8             	incl   -0x8(%ebp)
  801880:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801883:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801886:	7c d9                	jl     801861 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801888:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188b:	8b 45 10             	mov    0x10(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	c6 00 00             	movb   $0x0,(%eax)
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801899:	8b 45 14             	mov    0x14(%ebp),%eax
  80189c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a5:	8b 00                	mov    (%eax),%eax
  8018a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b1:	01 d0                	add    %edx,%eax
  8018b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018b9:	eb 0c                	jmp    8018c7 <strsplit+0x31>
			*string++ = 0;
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	8d 50 01             	lea    0x1(%eax),%edx
  8018c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8018c4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	84 c0                	test   %al,%al
  8018ce:	74 18                	je     8018e8 <strsplit+0x52>
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	0f be c0             	movsbl %al,%eax
  8018d8:	50                   	push   %eax
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	e8 13 fb ff ff       	call   8013f4 <strchr>
  8018e1:	83 c4 08             	add    $0x8,%esp
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	75 d3                	jne    8018bb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	8a 00                	mov    (%eax),%al
  8018ed:	84 c0                	test   %al,%al
  8018ef:	74 5a                	je     80194b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f4:	8b 00                	mov    (%eax),%eax
  8018f6:	83 f8 0f             	cmp    $0xf,%eax
  8018f9:	75 07                	jne    801902 <strsplit+0x6c>
		{
			return 0;
  8018fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801900:	eb 66                	jmp    801968 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801902:	8b 45 14             	mov    0x14(%ebp),%eax
  801905:	8b 00                	mov    (%eax),%eax
  801907:	8d 48 01             	lea    0x1(%eax),%ecx
  80190a:	8b 55 14             	mov    0x14(%ebp),%edx
  80190d:	89 0a                	mov    %ecx,(%edx)
  80190f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801916:	8b 45 10             	mov    0x10(%ebp),%eax
  801919:	01 c2                	add    %eax,%edx
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801920:	eb 03                	jmp    801925 <strsplit+0x8f>
			string++;
  801922:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	8a 00                	mov    (%eax),%al
  80192a:	84 c0                	test   %al,%al
  80192c:	74 8b                	je     8018b9 <strsplit+0x23>
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	0f be c0             	movsbl %al,%eax
  801936:	50                   	push   %eax
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	e8 b5 fa ff ff       	call   8013f4 <strchr>
  80193f:	83 c4 08             	add    $0x8,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	74 dc                	je     801922 <strsplit+0x8c>
			string++;
	}
  801946:	e9 6e ff ff ff       	jmp    8018b9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80194b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80194c:	8b 45 14             	mov    0x14(%ebp),%eax
  80194f:	8b 00                	mov    (%eax),%eax
  801951:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801958:	8b 45 10             	mov    0x10(%ebp),%eax
  80195b:	01 d0                	add    %edx,%eax
  80195d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801963:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801970:	a1 04 50 80 00       	mov    0x805004,%eax
  801975:	85 c0                	test   %eax,%eax
  801977:	74 1f                	je     801998 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801979:	e8 1d 00 00 00       	call   80199b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80197e:	83 ec 0c             	sub    $0xc,%esp
  801981:	68 04 40 80 00       	push   $0x804004
  801986:	e8 4f f0 ff ff       	call   8009da <cprintf>
  80198b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80198e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801995:	00 00 00 
	}
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  8019a1:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8019a8:	00 00 00 
  8019ab:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8019b2:	00 00 00 
  8019b5:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8019bc:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  8019bf:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8019c6:	00 00 00 
  8019c9:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8019d0:	00 00 00 
  8019d3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8019da:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  8019dd:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8019e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019ec:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019f1:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8019f6:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019fd:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801a00:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0a:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801a0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a15:	ba 00 00 00 00       	mov    $0x0,%edx
  801a1a:	f7 75 f0             	divl   -0x10(%ebp)
  801a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a20:	29 d0                	sub    %edx,%eax
  801a22:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801a25:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a2f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a34:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a39:	83 ec 04             	sub    $0x4,%esp
  801a3c:	6a 06                	push   $0x6
  801a3e:	ff 75 e8             	pushl  -0x18(%ebp)
  801a41:	50                   	push   %eax
  801a42:	e8 d4 05 00 00       	call   80201b <sys_allocate_chunk>
  801a47:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a4a:	a1 20 51 80 00       	mov    0x805120,%eax
  801a4f:	83 ec 0c             	sub    $0xc,%esp
  801a52:	50                   	push   %eax
  801a53:	e8 49 0c 00 00       	call   8026a1 <initialize_MemBlocksList>
  801a58:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801a5b:	a1 48 51 80 00       	mov    0x805148,%eax
  801a60:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801a63:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a67:	75 14                	jne    801a7d <initialize_dyn_block_system+0xe2>
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	68 29 40 80 00       	push   $0x804029
  801a71:	6a 39                	push   $0x39
  801a73:	68 47 40 80 00       	push   $0x804047
  801a78:	e8 a9 ec ff ff       	call   800726 <_panic>
  801a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a80:	8b 00                	mov    (%eax),%eax
  801a82:	85 c0                	test   %eax,%eax
  801a84:	74 10                	je     801a96 <initialize_dyn_block_system+0xfb>
  801a86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a89:	8b 00                	mov    (%eax),%eax
  801a8b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a8e:	8b 52 04             	mov    0x4(%edx),%edx
  801a91:	89 50 04             	mov    %edx,0x4(%eax)
  801a94:	eb 0b                	jmp    801aa1 <initialize_dyn_block_system+0x106>
  801a96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a99:	8b 40 04             	mov    0x4(%eax),%eax
  801a9c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801aa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aa4:	8b 40 04             	mov    0x4(%eax),%eax
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	74 0f                	je     801aba <initialize_dyn_block_system+0x11f>
  801aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aae:	8b 40 04             	mov    0x4(%eax),%eax
  801ab1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ab4:	8b 12                	mov    (%edx),%edx
  801ab6:	89 10                	mov    %edx,(%eax)
  801ab8:	eb 0a                	jmp    801ac4 <initialize_dyn_block_system+0x129>
  801aba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801abd:	8b 00                	mov    (%eax),%eax
  801abf:	a3 48 51 80 00       	mov    %eax,0x805148
  801ac4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ac7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801acd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ad0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ad7:	a1 54 51 80 00       	mov    0x805154,%eax
  801adc:	48                   	dec    %eax
  801add:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ae5:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801aec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aef:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801af6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801afa:	75 14                	jne    801b10 <initialize_dyn_block_system+0x175>
  801afc:	83 ec 04             	sub    $0x4,%esp
  801aff:	68 54 40 80 00       	push   $0x804054
  801b04:	6a 3f                	push   $0x3f
  801b06:	68 47 40 80 00       	push   $0x804047
  801b0b:	e8 16 ec ff ff       	call   800726 <_panic>
  801b10:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b19:	89 10                	mov    %edx,(%eax)
  801b1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b1e:	8b 00                	mov    (%eax),%eax
  801b20:	85 c0                	test   %eax,%eax
  801b22:	74 0d                	je     801b31 <initialize_dyn_block_system+0x196>
  801b24:	a1 38 51 80 00       	mov    0x805138,%eax
  801b29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b2c:	89 50 04             	mov    %edx,0x4(%eax)
  801b2f:	eb 08                	jmp    801b39 <initialize_dyn_block_system+0x19e>
  801b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b34:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801b39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b3c:	a3 38 51 80 00       	mov    %eax,0x805138
  801b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b4b:	a1 44 51 80 00       	mov    0x805144,%eax
  801b50:	40                   	inc    %eax
  801b51:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801b56:	90                   	nop
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b5f:	e8 06 fe ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801b64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b68:	75 07                	jne    801b71 <malloc+0x18>
  801b6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6f:	eb 7d                	jmp    801bee <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801b71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801b78:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b7f:	8b 55 08             	mov    0x8(%ebp),%edx
  801b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b85:	01 d0                	add    %edx,%eax
  801b87:	48                   	dec    %eax
  801b88:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b93:	f7 75 f0             	divl   -0x10(%ebp)
  801b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b99:	29 d0                	sub    %edx,%eax
  801b9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801b9e:	e8 46 08 00 00       	call   8023e9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ba3:	83 f8 01             	cmp    $0x1,%eax
  801ba6:	75 07                	jne    801baf <malloc+0x56>
  801ba8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801baf:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801bb3:	75 34                	jne    801be9 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801bb5:	83 ec 0c             	sub    $0xc,%esp
  801bb8:	ff 75 e8             	pushl  -0x18(%ebp)
  801bbb:	e8 73 0e 00 00       	call   802a33 <alloc_block_FF>
  801bc0:	83 c4 10             	add    $0x10,%esp
  801bc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801bc6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bca:	74 16                	je     801be2 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801bcc:	83 ec 0c             	sub    $0xc,%esp
  801bcf:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bd2:	e8 ff 0b 00 00       	call   8027d6 <insert_sorted_allocList>
  801bd7:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801bda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bdd:	8b 40 08             	mov    0x8(%eax),%eax
  801be0:	eb 0c                	jmp    801bee <malloc+0x95>
	             }
	             else
	             	return NULL;
  801be2:	b8 00 00 00 00       	mov    $0x0,%eax
  801be7:	eb 05                	jmp    801bee <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801be9:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c05:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c0a:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801c0d:	83 ec 08             	sub    $0x8,%esp
  801c10:	ff 75 f4             	pushl  -0xc(%ebp)
  801c13:	68 40 50 80 00       	push   $0x805040
  801c18:	e8 61 0b 00 00       	call   80277e <find_block>
  801c1d:	83 c4 10             	add    $0x10,%esp
  801c20:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801c23:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c27:	0f 84 a5 00 00 00    	je     801cd2 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c30:	8b 40 0c             	mov    0xc(%eax),%eax
  801c33:	83 ec 08             	sub    $0x8,%esp
  801c36:	50                   	push   %eax
  801c37:	ff 75 f4             	pushl  -0xc(%ebp)
  801c3a:	e8 a4 03 00 00       	call   801fe3 <sys_free_user_mem>
  801c3f:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801c42:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c46:	75 17                	jne    801c5f <free+0x6f>
  801c48:	83 ec 04             	sub    $0x4,%esp
  801c4b:	68 29 40 80 00       	push   $0x804029
  801c50:	68 87 00 00 00       	push   $0x87
  801c55:	68 47 40 80 00       	push   $0x804047
  801c5a:	e8 c7 ea ff ff       	call   800726 <_panic>
  801c5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c62:	8b 00                	mov    (%eax),%eax
  801c64:	85 c0                	test   %eax,%eax
  801c66:	74 10                	je     801c78 <free+0x88>
  801c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c6b:	8b 00                	mov    (%eax),%eax
  801c6d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c70:	8b 52 04             	mov    0x4(%edx),%edx
  801c73:	89 50 04             	mov    %edx,0x4(%eax)
  801c76:	eb 0b                	jmp    801c83 <free+0x93>
  801c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c7b:	8b 40 04             	mov    0x4(%eax),%eax
  801c7e:	a3 44 50 80 00       	mov    %eax,0x805044
  801c83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c86:	8b 40 04             	mov    0x4(%eax),%eax
  801c89:	85 c0                	test   %eax,%eax
  801c8b:	74 0f                	je     801c9c <free+0xac>
  801c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c90:	8b 40 04             	mov    0x4(%eax),%eax
  801c93:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c96:	8b 12                	mov    (%edx),%edx
  801c98:	89 10                	mov    %edx,(%eax)
  801c9a:	eb 0a                	jmp    801ca6 <free+0xb6>
  801c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c9f:	8b 00                	mov    (%eax),%eax
  801ca1:	a3 40 50 80 00       	mov    %eax,0x805040
  801ca6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ca9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801caf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cb9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801cbe:	48                   	dec    %eax
  801cbf:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801cc4:	83 ec 0c             	sub    $0xc,%esp
  801cc7:	ff 75 ec             	pushl  -0x14(%ebp)
  801cca:	e8 37 12 00 00       	call   802f06 <insert_sorted_with_merge_freeList>
  801ccf:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801cd2:	90                   	nop
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	83 ec 38             	sub    $0x38,%esp
  801cdb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cde:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ce1:	e8 84 fc ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801ce6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cea:	75 07                	jne    801cf3 <smalloc+0x1e>
  801cec:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf1:	eb 7e                	jmp    801d71 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801cf3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801cfa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d07:	01 d0                	add    %edx,%eax
  801d09:	48                   	dec    %eax
  801d0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d10:	ba 00 00 00 00       	mov    $0x0,%edx
  801d15:	f7 75 f0             	divl   -0x10(%ebp)
  801d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d1b:	29 d0                	sub    %edx,%eax
  801d1d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801d20:	e8 c4 06 00 00       	call   8023e9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d25:	83 f8 01             	cmp    $0x1,%eax
  801d28:	75 42                	jne    801d6c <smalloc+0x97>

		  va = malloc(newsize) ;
  801d2a:	83 ec 0c             	sub    $0xc,%esp
  801d2d:	ff 75 e8             	pushl  -0x18(%ebp)
  801d30:	e8 24 fe ff ff       	call   801b59 <malloc>
  801d35:	83 c4 10             	add    $0x10,%esp
  801d38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801d3b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d3f:	74 24                	je     801d65 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801d41:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d45:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d48:	50                   	push   %eax
  801d49:	ff 75 e8             	pushl  -0x18(%ebp)
  801d4c:	ff 75 08             	pushl  0x8(%ebp)
  801d4f:	e8 1a 04 00 00       	call   80216e <sys_createSharedObject>
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801d5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d5e:	78 0c                	js     801d6c <smalloc+0x97>
					  return va ;
  801d60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d63:	eb 0c                	jmp    801d71 <smalloc+0x9c>
				 }
				 else
					return NULL;
  801d65:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6a:	eb 05                	jmp    801d71 <smalloc+0x9c>
	  }
		  return NULL ;
  801d6c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d79:	e8 ec fb ff ff       	call   80196a <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801d7e:	83 ec 08             	sub    $0x8,%esp
  801d81:	ff 75 0c             	pushl  0xc(%ebp)
  801d84:	ff 75 08             	pushl  0x8(%ebp)
  801d87:	e8 0c 04 00 00       	call   802198 <sys_getSizeOfSharedObject>
  801d8c:	83 c4 10             	add    $0x10,%esp
  801d8f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801d92:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801d96:	75 07                	jne    801d9f <sget+0x2c>
  801d98:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9d:	eb 75                	jmp    801e14 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801d9f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801da6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dac:	01 d0                	add    %edx,%eax
  801dae:	48                   	dec    %eax
  801daf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db5:	ba 00 00 00 00       	mov    $0x0,%edx
  801dba:	f7 75 f0             	divl   -0x10(%ebp)
  801dbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc0:	29 d0                	sub    %edx,%eax
  801dc2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801dc5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801dcc:	e8 18 06 00 00       	call   8023e9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dd1:	83 f8 01             	cmp    $0x1,%eax
  801dd4:	75 39                	jne    801e0f <sget+0x9c>

		  va = malloc(newsize) ;
  801dd6:	83 ec 0c             	sub    $0xc,%esp
  801dd9:	ff 75 e8             	pushl  -0x18(%ebp)
  801ddc:	e8 78 fd ff ff       	call   801b59 <malloc>
  801de1:	83 c4 10             	add    $0x10,%esp
  801de4:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801de7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801deb:	74 22                	je     801e0f <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801ded:	83 ec 04             	sub    $0x4,%esp
  801df0:	ff 75 e0             	pushl  -0x20(%ebp)
  801df3:	ff 75 0c             	pushl  0xc(%ebp)
  801df6:	ff 75 08             	pushl  0x8(%ebp)
  801df9:	e8 b7 03 00 00       	call   8021b5 <sys_getSharedObject>
  801dfe:	83 c4 10             	add    $0x10,%esp
  801e01:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801e04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e08:	78 05                	js     801e0f <sget+0x9c>
					  return va;
  801e0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e0d:	eb 05                	jmp    801e14 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801e0f:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e1c:	e8 49 fb ff ff       	call   80196a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e21:	83 ec 04             	sub    $0x4,%esp
  801e24:	68 78 40 80 00       	push   $0x804078
  801e29:	68 1e 01 00 00       	push   $0x11e
  801e2e:	68 47 40 80 00       	push   $0x804047
  801e33:	e8 ee e8 ff ff       	call   800726 <_panic>

00801e38 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e3e:	83 ec 04             	sub    $0x4,%esp
  801e41:	68 a0 40 80 00       	push   $0x8040a0
  801e46:	68 32 01 00 00       	push   $0x132
  801e4b:	68 47 40 80 00       	push   $0x804047
  801e50:	e8 d1 e8 ff ff       	call   800726 <_panic>

00801e55 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e5b:	83 ec 04             	sub    $0x4,%esp
  801e5e:	68 c4 40 80 00       	push   $0x8040c4
  801e63:	68 3d 01 00 00       	push   $0x13d
  801e68:	68 47 40 80 00       	push   $0x804047
  801e6d:	e8 b4 e8 ff ff       	call   800726 <_panic>

00801e72 <shrink>:

}
void shrink(uint32 newSize)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e78:	83 ec 04             	sub    $0x4,%esp
  801e7b:	68 c4 40 80 00       	push   $0x8040c4
  801e80:	68 42 01 00 00       	push   $0x142
  801e85:	68 47 40 80 00       	push   $0x804047
  801e8a:	e8 97 e8 ff ff       	call   800726 <_panic>

00801e8f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e95:	83 ec 04             	sub    $0x4,%esp
  801e98:	68 c4 40 80 00       	push   $0x8040c4
  801e9d:	68 47 01 00 00       	push   $0x147
  801ea2:	68 47 40 80 00       	push   $0x804047
  801ea7:	e8 7a e8 ff ff       	call   800726 <_panic>

00801eac <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	57                   	push   %edi
  801eb0:	56                   	push   %esi
  801eb1:	53                   	push   %ebx
  801eb2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ebe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ec1:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ec4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ec7:	cd 30                	int    $0x30
  801ec9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ecf:	83 c4 10             	add    $0x10,%esp
  801ed2:	5b                   	pop    %ebx
  801ed3:	5e                   	pop    %esi
  801ed4:	5f                   	pop    %edi
  801ed5:	5d                   	pop    %ebp
  801ed6:	c3                   	ret    

00801ed7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 04             	sub    $0x4,%esp
  801edd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ee3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	52                   	push   %edx
  801eef:	ff 75 0c             	pushl  0xc(%ebp)
  801ef2:	50                   	push   %eax
  801ef3:	6a 00                	push   $0x0
  801ef5:	e8 b2 ff ff ff       	call   801eac <syscall>
  801efa:	83 c4 18             	add    $0x18,%esp
}
  801efd:	90                   	nop
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 01                	push   $0x1
  801f0f:	e8 98 ff ff ff       	call   801eac <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	52                   	push   %edx
  801f29:	50                   	push   %eax
  801f2a:	6a 05                	push   $0x5
  801f2c:	e8 7b ff ff ff       	call   801eac <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	56                   	push   %esi
  801f3a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f3b:	8b 75 18             	mov    0x18(%ebp),%esi
  801f3e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f41:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f47:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4a:	56                   	push   %esi
  801f4b:	53                   	push   %ebx
  801f4c:	51                   	push   %ecx
  801f4d:	52                   	push   %edx
  801f4e:	50                   	push   %eax
  801f4f:	6a 06                	push   $0x6
  801f51:	e8 56 ff ff ff       	call   801eac <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
}
  801f59:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f5c:	5b                   	pop    %ebx
  801f5d:	5e                   	pop    %esi
  801f5e:	5d                   	pop    %ebp
  801f5f:	c3                   	ret    

00801f60 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	52                   	push   %edx
  801f70:	50                   	push   %eax
  801f71:	6a 07                	push   $0x7
  801f73:	e8 34 ff ff ff       	call   801eac <syscall>
  801f78:	83 c4 18             	add    $0x18,%esp
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	ff 75 0c             	pushl  0xc(%ebp)
  801f89:	ff 75 08             	pushl  0x8(%ebp)
  801f8c:	6a 08                	push   $0x8
  801f8e:	e8 19 ff ff ff       	call   801eac <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 09                	push   $0x9
  801fa7:	e8 00 ff ff ff       	call   801eac <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 0a                	push   $0xa
  801fc0:	e8 e7 fe ff ff       	call   801eac <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 0b                	push   $0xb
  801fd9:	e8 ce fe ff ff       	call   801eac <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	ff 75 0c             	pushl  0xc(%ebp)
  801fef:	ff 75 08             	pushl  0x8(%ebp)
  801ff2:	6a 0f                	push   $0xf
  801ff4:	e8 b3 fe ff ff       	call   801eac <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
	return;
  801ffc:	90                   	nop
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	ff 75 0c             	pushl  0xc(%ebp)
  80200b:	ff 75 08             	pushl  0x8(%ebp)
  80200e:	6a 10                	push   $0x10
  802010:	e8 97 fe ff ff       	call   801eac <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
	return ;
  802018:	90                   	nop
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	ff 75 10             	pushl  0x10(%ebp)
  802025:	ff 75 0c             	pushl  0xc(%ebp)
  802028:	ff 75 08             	pushl  0x8(%ebp)
  80202b:	6a 11                	push   $0x11
  80202d:	e8 7a fe ff ff       	call   801eac <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
	return ;
  802035:	90                   	nop
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 0c                	push   $0xc
  802047:	e8 60 fe ff ff       	call   801eac <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	ff 75 08             	pushl  0x8(%ebp)
  80205f:	6a 0d                	push   $0xd
  802061:	e8 46 fe ff ff       	call   801eac <syscall>
  802066:	83 c4 18             	add    $0x18,%esp
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 0e                	push   $0xe
  80207a:	e8 2d fe ff ff       	call   801eac <syscall>
  80207f:	83 c4 18             	add    $0x18,%esp
}
  802082:	90                   	nop
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 13                	push   $0x13
  802094:	e8 13 fe ff ff       	call   801eac <syscall>
  802099:	83 c4 18             	add    $0x18,%esp
}
  80209c:	90                   	nop
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 14                	push   $0x14
  8020ae:	e8 f9 fd ff ff       	call   801eac <syscall>
  8020b3:	83 c4 18             	add    $0x18,%esp
}
  8020b6:	90                   	nop
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 04             	sub    $0x4,%esp
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020c5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	50                   	push   %eax
  8020d2:	6a 15                	push   $0x15
  8020d4:	e8 d3 fd ff ff       	call   801eac <syscall>
  8020d9:	83 c4 18             	add    $0x18,%esp
}
  8020dc:	90                   	nop
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 16                	push   $0x16
  8020ee:	e8 b9 fd ff ff       	call   801eac <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
}
  8020f6:	90                   	nop
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	ff 75 0c             	pushl  0xc(%ebp)
  802108:	50                   	push   %eax
  802109:	6a 17                	push   $0x17
  80210b:	e8 9c fd ff ff       	call   801eac <syscall>
  802110:	83 c4 18             	add    $0x18,%esp
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802118:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	52                   	push   %edx
  802125:	50                   	push   %eax
  802126:	6a 1a                	push   $0x1a
  802128:	e8 7f fd ff ff       	call   801eac <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
}
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802135:	8b 55 0c             	mov    0xc(%ebp),%edx
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	52                   	push   %edx
  802142:	50                   	push   %eax
  802143:	6a 18                	push   $0x18
  802145:	e8 62 fd ff ff       	call   801eac <syscall>
  80214a:	83 c4 18             	add    $0x18,%esp
}
  80214d:	90                   	nop
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802153:	8b 55 0c             	mov    0xc(%ebp),%edx
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	52                   	push   %edx
  802160:	50                   	push   %eax
  802161:	6a 19                	push   $0x19
  802163:	e8 44 fd ff ff       	call   801eac <syscall>
  802168:	83 c4 18             	add    $0x18,%esp
}
  80216b:	90                   	nop
  80216c:	c9                   	leave  
  80216d:	c3                   	ret    

0080216e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
  802171:	83 ec 04             	sub    $0x4,%esp
  802174:	8b 45 10             	mov    0x10(%ebp),%eax
  802177:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80217a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80217d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	6a 00                	push   $0x0
  802186:	51                   	push   %ecx
  802187:	52                   	push   %edx
  802188:	ff 75 0c             	pushl  0xc(%ebp)
  80218b:	50                   	push   %eax
  80218c:	6a 1b                	push   $0x1b
  80218e:	e8 19 fd ff ff       	call   801eac <syscall>
  802193:	83 c4 18             	add    $0x18,%esp
}
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80219b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	52                   	push   %edx
  8021a8:	50                   	push   %eax
  8021a9:	6a 1c                	push   $0x1c
  8021ab:	e8 fc fc ff ff       	call   801eac <syscall>
  8021b0:	83 c4 18             	add    $0x18,%esp
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	51                   	push   %ecx
  8021c6:	52                   	push   %edx
  8021c7:	50                   	push   %eax
  8021c8:	6a 1d                	push   $0x1d
  8021ca:	e8 dd fc ff ff       	call   801eac <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
}
  8021d2:	c9                   	leave  
  8021d3:	c3                   	ret    

008021d4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021d4:	55                   	push   %ebp
  8021d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	52                   	push   %edx
  8021e4:	50                   	push   %eax
  8021e5:	6a 1e                	push   $0x1e
  8021e7:	e8 c0 fc ff ff       	call   801eac <syscall>
  8021ec:	83 c4 18             	add    $0x18,%esp
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 1f                	push   $0x1f
  802200:	e8 a7 fc ff ff       	call   801eac <syscall>
  802205:	83 c4 18             	add    $0x18,%esp
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	6a 00                	push   $0x0
  802212:	ff 75 14             	pushl  0x14(%ebp)
  802215:	ff 75 10             	pushl  0x10(%ebp)
  802218:	ff 75 0c             	pushl  0xc(%ebp)
  80221b:	50                   	push   %eax
  80221c:	6a 20                	push   $0x20
  80221e:	e8 89 fc ff ff       	call   801eac <syscall>
  802223:	83 c4 18             	add    $0x18,%esp
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	50                   	push   %eax
  802237:	6a 21                	push   $0x21
  802239:	e8 6e fc ff ff       	call   801eac <syscall>
  80223e:	83 c4 18             	add    $0x18,%esp
}
  802241:	90                   	nop
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	50                   	push   %eax
  802253:	6a 22                	push   $0x22
  802255:	e8 52 fc ff ff       	call   801eac <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 02                	push   $0x2
  80226e:	e8 39 fc ff ff       	call   801eac <syscall>
  802273:	83 c4 18             	add    $0x18,%esp
}
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 03                	push   $0x3
  802287:	e8 20 fc ff ff       	call   801eac <syscall>
  80228c:	83 c4 18             	add    $0x18,%esp
}
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 04                	push   $0x4
  8022a0:	e8 07 fc ff ff       	call   801eac <syscall>
  8022a5:	83 c4 18             	add    $0x18,%esp
}
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <sys_exit_env>:


void sys_exit_env(void)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 23                	push   $0x23
  8022b9:	e8 ee fb ff ff       	call   801eac <syscall>
  8022be:	83 c4 18             	add    $0x18,%esp
}
  8022c1:	90                   	nop
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
  8022c7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022ca:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022cd:	8d 50 04             	lea    0x4(%eax),%edx
  8022d0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	52                   	push   %edx
  8022da:	50                   	push   %eax
  8022db:	6a 24                	push   $0x24
  8022dd:	e8 ca fb ff ff       	call   801eac <syscall>
  8022e2:	83 c4 18             	add    $0x18,%esp
	return result;
  8022e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022ee:	89 01                	mov    %eax,(%ecx)
  8022f0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	c9                   	leave  
  8022f7:	c2 04 00             	ret    $0x4

008022fa <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	ff 75 10             	pushl  0x10(%ebp)
  802304:	ff 75 0c             	pushl  0xc(%ebp)
  802307:	ff 75 08             	pushl  0x8(%ebp)
  80230a:	6a 12                	push   $0x12
  80230c:	e8 9b fb ff ff       	call   801eac <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
	return ;
  802314:	90                   	nop
}
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <sys_rcr2>:
uint32 sys_rcr2()
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 25                	push   $0x25
  802326:	e8 81 fb ff ff       	call   801eac <syscall>
  80232b:	83 c4 18             	add    $0x18,%esp
}
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
  802333:	83 ec 04             	sub    $0x4,%esp
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80233c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	50                   	push   %eax
  802349:	6a 26                	push   $0x26
  80234b:	e8 5c fb ff ff       	call   801eac <syscall>
  802350:	83 c4 18             	add    $0x18,%esp
	return ;
  802353:	90                   	nop
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <rsttst>:
void rsttst()
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 28                	push   $0x28
  802365:	e8 42 fb ff ff       	call   801eac <syscall>
  80236a:	83 c4 18             	add    $0x18,%esp
	return ;
  80236d:	90                   	nop
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 04             	sub    $0x4,%esp
  802376:	8b 45 14             	mov    0x14(%ebp),%eax
  802379:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80237c:	8b 55 18             	mov    0x18(%ebp),%edx
  80237f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802383:	52                   	push   %edx
  802384:	50                   	push   %eax
  802385:	ff 75 10             	pushl  0x10(%ebp)
  802388:	ff 75 0c             	pushl  0xc(%ebp)
  80238b:	ff 75 08             	pushl  0x8(%ebp)
  80238e:	6a 27                	push   $0x27
  802390:	e8 17 fb ff ff       	call   801eac <syscall>
  802395:	83 c4 18             	add    $0x18,%esp
	return ;
  802398:	90                   	nop
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <chktst>:
void chktst(uint32 n)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	ff 75 08             	pushl  0x8(%ebp)
  8023a9:	6a 29                	push   $0x29
  8023ab:	e8 fc fa ff ff       	call   801eac <syscall>
  8023b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b3:	90                   	nop
}
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    

008023b6 <inctst>:

void inctst()
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 2a                	push   $0x2a
  8023c5:	e8 e2 fa ff ff       	call   801eac <syscall>
  8023ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8023cd:	90                   	nop
}
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <gettst>:
uint32 gettst()
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 2b                	push   $0x2b
  8023df:	e8 c8 fa ff ff       	call   801eac <syscall>
  8023e4:	83 c4 18             	add    $0x18,%esp
}
  8023e7:	c9                   	leave  
  8023e8:	c3                   	ret    

008023e9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
  8023ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 2c                	push   $0x2c
  8023fb:	e8 ac fa ff ff       	call   801eac <syscall>
  802400:	83 c4 18             	add    $0x18,%esp
  802403:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802406:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80240a:	75 07                	jne    802413 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80240c:	b8 01 00 00 00       	mov    $0x1,%eax
  802411:	eb 05                	jmp    802418 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
  80241d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 2c                	push   $0x2c
  80242c:	e8 7b fa ff ff       	call   801eac <syscall>
  802431:	83 c4 18             	add    $0x18,%esp
  802434:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802437:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80243b:	75 07                	jne    802444 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80243d:	b8 01 00 00 00       	mov    $0x1,%eax
  802442:	eb 05                	jmp    802449 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802444:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802449:	c9                   	leave  
  80244a:	c3                   	ret    

0080244b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
  80244e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 2c                	push   $0x2c
  80245d:	e8 4a fa ff ff       	call   801eac <syscall>
  802462:	83 c4 18             	add    $0x18,%esp
  802465:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802468:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80246c:	75 07                	jne    802475 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80246e:	b8 01 00 00 00       	mov    $0x1,%eax
  802473:	eb 05                	jmp    80247a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802475:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
  80247f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 2c                	push   $0x2c
  80248e:	e8 19 fa ff ff       	call   801eac <syscall>
  802493:	83 c4 18             	add    $0x18,%esp
  802496:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802499:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80249d:	75 07                	jne    8024a6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80249f:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a4:	eb 05                	jmp    8024ab <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	ff 75 08             	pushl  0x8(%ebp)
  8024bb:	6a 2d                	push   $0x2d
  8024bd:	e8 ea f9 ff ff       	call   801eac <syscall>
  8024c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c5:	90                   	nop
}
  8024c6:	c9                   	leave  
  8024c7:	c3                   	ret    

008024c8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
  8024cb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	6a 00                	push   $0x0
  8024da:	53                   	push   %ebx
  8024db:	51                   	push   %ecx
  8024dc:	52                   	push   %edx
  8024dd:	50                   	push   %eax
  8024de:	6a 2e                	push   $0x2e
  8024e0:	e8 c7 f9 ff ff       	call   801eac <syscall>
  8024e5:	83 c4 18             	add    $0x18,%esp
}
  8024e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	52                   	push   %edx
  8024fd:	50                   	push   %eax
  8024fe:	6a 2f                	push   $0x2f
  802500:	e8 a7 f9 ff ff       	call   801eac <syscall>
  802505:	83 c4 18             	add    $0x18,%esp
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802510:	83 ec 0c             	sub    $0xc,%esp
  802513:	68 d4 40 80 00       	push   $0x8040d4
  802518:	e8 bd e4 ff ff       	call   8009da <cprintf>
  80251d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802520:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802527:	83 ec 0c             	sub    $0xc,%esp
  80252a:	68 00 41 80 00       	push   $0x804100
  80252f:	e8 a6 e4 ff ff       	call   8009da <cprintf>
  802534:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802537:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80253b:	a1 38 51 80 00       	mov    0x805138,%eax
  802540:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802543:	eb 56                	jmp    80259b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802545:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802549:	74 1c                	je     802567 <print_mem_block_lists+0x5d>
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 50 08             	mov    0x8(%eax),%edx
  802551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802554:	8b 48 08             	mov    0x8(%eax),%ecx
  802557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255a:	8b 40 0c             	mov    0xc(%eax),%eax
  80255d:	01 c8                	add    %ecx,%eax
  80255f:	39 c2                	cmp    %eax,%edx
  802561:	73 04                	jae    802567 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802563:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	8b 50 08             	mov    0x8(%eax),%edx
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	8b 40 0c             	mov    0xc(%eax),%eax
  802573:	01 c2                	add    %eax,%edx
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	8b 40 08             	mov    0x8(%eax),%eax
  80257b:	83 ec 04             	sub    $0x4,%esp
  80257e:	52                   	push   %edx
  80257f:	50                   	push   %eax
  802580:	68 15 41 80 00       	push   $0x804115
  802585:	e8 50 e4 ff ff       	call   8009da <cprintf>
  80258a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802593:	a1 40 51 80 00       	mov    0x805140,%eax
  802598:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259f:	74 07                	je     8025a8 <print_mem_block_lists+0x9e>
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	8b 00                	mov    (%eax),%eax
  8025a6:	eb 05                	jmp    8025ad <print_mem_block_lists+0xa3>
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ad:	a3 40 51 80 00       	mov    %eax,0x805140
  8025b2:	a1 40 51 80 00       	mov    0x805140,%eax
  8025b7:	85 c0                	test   %eax,%eax
  8025b9:	75 8a                	jne    802545 <print_mem_block_lists+0x3b>
  8025bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bf:	75 84                	jne    802545 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025c1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025c5:	75 10                	jne    8025d7 <print_mem_block_lists+0xcd>
  8025c7:	83 ec 0c             	sub    $0xc,%esp
  8025ca:	68 24 41 80 00       	push   $0x804124
  8025cf:	e8 06 e4 ff ff       	call   8009da <cprintf>
  8025d4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025de:	83 ec 0c             	sub    $0xc,%esp
  8025e1:	68 48 41 80 00       	push   $0x804148
  8025e6:	e8 ef e3 ff ff       	call   8009da <cprintf>
  8025eb:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025ee:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025f2:	a1 40 50 80 00       	mov    0x805040,%eax
  8025f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fa:	eb 56                	jmp    802652 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802600:	74 1c                	je     80261e <print_mem_block_lists+0x114>
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	8b 50 08             	mov    0x8(%eax),%edx
  802608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260b:	8b 48 08             	mov    0x8(%eax),%ecx
  80260e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802611:	8b 40 0c             	mov    0xc(%eax),%eax
  802614:	01 c8                	add    %ecx,%eax
  802616:	39 c2                	cmp    %eax,%edx
  802618:	73 04                	jae    80261e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80261a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 50 08             	mov    0x8(%eax),%edx
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 40 0c             	mov    0xc(%eax),%eax
  80262a:	01 c2                	add    %eax,%edx
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	8b 40 08             	mov    0x8(%eax),%eax
  802632:	83 ec 04             	sub    $0x4,%esp
  802635:	52                   	push   %edx
  802636:	50                   	push   %eax
  802637:	68 15 41 80 00       	push   $0x804115
  80263c:	e8 99 e3 ff ff       	call   8009da <cprintf>
  802641:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80264a:	a1 48 50 80 00       	mov    0x805048,%eax
  80264f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802652:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802656:	74 07                	je     80265f <print_mem_block_lists+0x155>
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 00                	mov    (%eax),%eax
  80265d:	eb 05                	jmp    802664 <print_mem_block_lists+0x15a>
  80265f:	b8 00 00 00 00       	mov    $0x0,%eax
  802664:	a3 48 50 80 00       	mov    %eax,0x805048
  802669:	a1 48 50 80 00       	mov    0x805048,%eax
  80266e:	85 c0                	test   %eax,%eax
  802670:	75 8a                	jne    8025fc <print_mem_block_lists+0xf2>
  802672:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802676:	75 84                	jne    8025fc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802678:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80267c:	75 10                	jne    80268e <print_mem_block_lists+0x184>
  80267e:	83 ec 0c             	sub    $0xc,%esp
  802681:	68 60 41 80 00       	push   $0x804160
  802686:	e8 4f e3 ff ff       	call   8009da <cprintf>
  80268b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80268e:	83 ec 0c             	sub    $0xc,%esp
  802691:	68 d4 40 80 00       	push   $0x8040d4
  802696:	e8 3f e3 ff ff       	call   8009da <cprintf>
  80269b:	83 c4 10             	add    $0x10,%esp

}
  80269e:	90                   	nop
  80269f:	c9                   	leave  
  8026a0:	c3                   	ret    

008026a1 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026a1:	55                   	push   %ebp
  8026a2:	89 e5                	mov    %esp,%ebp
  8026a4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  8026a7:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026ae:	00 00 00 
  8026b1:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026b8:	00 00 00 
  8026bb:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026c2:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8026c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026cc:	e9 9e 00 00 00       	jmp    80276f <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8026d1:	a1 50 50 80 00       	mov    0x805050,%eax
  8026d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d9:	c1 e2 04             	shl    $0x4,%edx
  8026dc:	01 d0                	add    %edx,%eax
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	75 14                	jne    8026f6 <initialize_MemBlocksList+0x55>
  8026e2:	83 ec 04             	sub    $0x4,%esp
  8026e5:	68 88 41 80 00       	push   $0x804188
  8026ea:	6a 47                	push   $0x47
  8026ec:	68 ab 41 80 00       	push   $0x8041ab
  8026f1:	e8 30 e0 ff ff       	call   800726 <_panic>
  8026f6:	a1 50 50 80 00       	mov    0x805050,%eax
  8026fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fe:	c1 e2 04             	shl    $0x4,%edx
  802701:	01 d0                	add    %edx,%eax
  802703:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802709:	89 10                	mov    %edx,(%eax)
  80270b:	8b 00                	mov    (%eax),%eax
  80270d:	85 c0                	test   %eax,%eax
  80270f:	74 18                	je     802729 <initialize_MemBlocksList+0x88>
  802711:	a1 48 51 80 00       	mov    0x805148,%eax
  802716:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80271c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80271f:	c1 e1 04             	shl    $0x4,%ecx
  802722:	01 ca                	add    %ecx,%edx
  802724:	89 50 04             	mov    %edx,0x4(%eax)
  802727:	eb 12                	jmp    80273b <initialize_MemBlocksList+0x9a>
  802729:	a1 50 50 80 00       	mov    0x805050,%eax
  80272e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802731:	c1 e2 04             	shl    $0x4,%edx
  802734:	01 d0                	add    %edx,%eax
  802736:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80273b:	a1 50 50 80 00       	mov    0x805050,%eax
  802740:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802743:	c1 e2 04             	shl    $0x4,%edx
  802746:	01 d0                	add    %edx,%eax
  802748:	a3 48 51 80 00       	mov    %eax,0x805148
  80274d:	a1 50 50 80 00       	mov    0x805050,%eax
  802752:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802755:	c1 e2 04             	shl    $0x4,%edx
  802758:	01 d0                	add    %edx,%eax
  80275a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802761:	a1 54 51 80 00       	mov    0x805154,%eax
  802766:	40                   	inc    %eax
  802767:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80276c:	ff 45 f4             	incl   -0xc(%ebp)
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	3b 45 08             	cmp    0x8(%ebp),%eax
  802775:	0f 82 56 ff ff ff    	jb     8026d1 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  80277b:	90                   	nop
  80277c:	c9                   	leave  
  80277d:	c3                   	ret    

0080277e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80277e:	55                   	push   %ebp
  80277f:	89 e5                	mov    %esp,%ebp
  802781:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802784:	8b 45 08             	mov    0x8(%ebp),%eax
  802787:	8b 00                	mov    (%eax),%eax
  802789:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80278c:	eb 19                	jmp    8027a7 <find_block+0x29>
	{
		if(element->sva == va){
  80278e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802791:	8b 40 08             	mov    0x8(%eax),%eax
  802794:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802797:	75 05                	jne    80279e <find_block+0x20>
			 		return element;
  802799:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80279c:	eb 36                	jmp    8027d4 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80279e:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a1:	8b 40 08             	mov    0x8(%eax),%eax
  8027a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027ab:	74 07                	je     8027b4 <find_block+0x36>
  8027ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027b0:	8b 00                	mov    (%eax),%eax
  8027b2:	eb 05                	jmp    8027b9 <find_block+0x3b>
  8027b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027bc:	89 42 08             	mov    %eax,0x8(%edx)
  8027bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c2:	8b 40 08             	mov    0x8(%eax),%eax
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	75 c5                	jne    80278e <find_block+0x10>
  8027c9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027cd:	75 bf                	jne    80278e <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  8027cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027d4:	c9                   	leave  
  8027d5:	c3                   	ret    

008027d6 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027d6:	55                   	push   %ebp
  8027d7:	89 e5                	mov    %esp,%ebp
  8027d9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  8027dc:	a1 44 50 80 00       	mov    0x805044,%eax
  8027e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  8027e4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  8027ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027f0:	74 0a                	je     8027fc <insert_sorted_allocList+0x26>
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	8b 40 08             	mov    0x8(%eax),%eax
  8027f8:	85 c0                	test   %eax,%eax
  8027fa:	75 65                	jne    802861 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8027fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802800:	75 14                	jne    802816 <insert_sorted_allocList+0x40>
  802802:	83 ec 04             	sub    $0x4,%esp
  802805:	68 88 41 80 00       	push   $0x804188
  80280a:	6a 6e                	push   $0x6e
  80280c:	68 ab 41 80 00       	push   $0x8041ab
  802811:	e8 10 df ff ff       	call   800726 <_panic>
  802816:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80281c:	8b 45 08             	mov    0x8(%ebp),%eax
  80281f:	89 10                	mov    %edx,(%eax)
  802821:	8b 45 08             	mov    0x8(%ebp),%eax
  802824:	8b 00                	mov    (%eax),%eax
  802826:	85 c0                	test   %eax,%eax
  802828:	74 0d                	je     802837 <insert_sorted_allocList+0x61>
  80282a:	a1 40 50 80 00       	mov    0x805040,%eax
  80282f:	8b 55 08             	mov    0x8(%ebp),%edx
  802832:	89 50 04             	mov    %edx,0x4(%eax)
  802835:	eb 08                	jmp    80283f <insert_sorted_allocList+0x69>
  802837:	8b 45 08             	mov    0x8(%ebp),%eax
  80283a:	a3 44 50 80 00       	mov    %eax,0x805044
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	a3 40 50 80 00       	mov    %eax,0x805040
  802847:	8b 45 08             	mov    0x8(%ebp),%eax
  80284a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802851:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802856:	40                   	inc    %eax
  802857:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80285c:	e9 cf 01 00 00       	jmp    802a30 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802864:	8b 50 08             	mov    0x8(%eax),%edx
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	8b 40 08             	mov    0x8(%eax),%eax
  80286d:	39 c2                	cmp    %eax,%edx
  80286f:	73 65                	jae    8028d6 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802871:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802875:	75 14                	jne    80288b <insert_sorted_allocList+0xb5>
  802877:	83 ec 04             	sub    $0x4,%esp
  80287a:	68 c4 41 80 00       	push   $0x8041c4
  80287f:	6a 72                	push   $0x72
  802881:	68 ab 41 80 00       	push   $0x8041ab
  802886:	e8 9b de ff ff       	call   800726 <_panic>
  80288b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802891:	8b 45 08             	mov    0x8(%ebp),%eax
  802894:	89 50 04             	mov    %edx,0x4(%eax)
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	8b 40 04             	mov    0x4(%eax),%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	74 0c                	je     8028ad <insert_sorted_allocList+0xd7>
  8028a1:	a1 44 50 80 00       	mov    0x805044,%eax
  8028a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a9:	89 10                	mov    %edx,(%eax)
  8028ab:	eb 08                	jmp    8028b5 <insert_sorted_allocList+0xdf>
  8028ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b0:	a3 40 50 80 00       	mov    %eax,0x805040
  8028b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b8:	a3 44 50 80 00       	mov    %eax,0x805044
  8028bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028cb:	40                   	inc    %eax
  8028cc:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8028d1:	e9 5a 01 00 00       	jmp    802a30 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  8028d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d9:	8b 50 08             	mov    0x8(%eax),%edx
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	8b 40 08             	mov    0x8(%eax),%eax
  8028e2:	39 c2                	cmp    %eax,%edx
  8028e4:	75 70                	jne    802956 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  8028e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ea:	74 06                	je     8028f2 <insert_sorted_allocList+0x11c>
  8028ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028f0:	75 14                	jne    802906 <insert_sorted_allocList+0x130>
  8028f2:	83 ec 04             	sub    $0x4,%esp
  8028f5:	68 e8 41 80 00       	push   $0x8041e8
  8028fa:	6a 75                	push   $0x75
  8028fc:	68 ab 41 80 00       	push   $0x8041ab
  802901:	e8 20 de ff ff       	call   800726 <_panic>
  802906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802909:	8b 10                	mov    (%eax),%edx
  80290b:	8b 45 08             	mov    0x8(%ebp),%eax
  80290e:	89 10                	mov    %edx,(%eax)
  802910:	8b 45 08             	mov    0x8(%ebp),%eax
  802913:	8b 00                	mov    (%eax),%eax
  802915:	85 c0                	test   %eax,%eax
  802917:	74 0b                	je     802924 <insert_sorted_allocList+0x14e>
  802919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291c:	8b 00                	mov    (%eax),%eax
  80291e:	8b 55 08             	mov    0x8(%ebp),%edx
  802921:	89 50 04             	mov    %edx,0x4(%eax)
  802924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802927:	8b 55 08             	mov    0x8(%ebp),%edx
  80292a:	89 10                	mov    %edx,(%eax)
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802932:	89 50 04             	mov    %edx,0x4(%eax)
  802935:	8b 45 08             	mov    0x8(%ebp),%eax
  802938:	8b 00                	mov    (%eax),%eax
  80293a:	85 c0                	test   %eax,%eax
  80293c:	75 08                	jne    802946 <insert_sorted_allocList+0x170>
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	a3 44 50 80 00       	mov    %eax,0x805044
  802946:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80294b:	40                   	inc    %eax
  80294c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802951:	e9 da 00 00 00       	jmp    802a30 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802956:	a1 40 50 80 00       	mov    0x805040,%eax
  80295b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295e:	e9 9d 00 00 00       	jmp    802a00 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	8b 00                	mov    (%eax),%eax
  802968:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  80296b:	8b 45 08             	mov    0x8(%ebp),%eax
  80296e:	8b 50 08             	mov    0x8(%eax),%edx
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	8b 40 08             	mov    0x8(%eax),%eax
  802977:	39 c2                	cmp    %eax,%edx
  802979:	76 7d                	jbe    8029f8 <insert_sorted_allocList+0x222>
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	8b 50 08             	mov    0x8(%eax),%edx
  802981:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802984:	8b 40 08             	mov    0x8(%eax),%eax
  802987:	39 c2                	cmp    %eax,%edx
  802989:	73 6d                	jae    8029f8 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80298b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298f:	74 06                	je     802997 <insert_sorted_allocList+0x1c1>
  802991:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802995:	75 14                	jne    8029ab <insert_sorted_allocList+0x1d5>
  802997:	83 ec 04             	sub    $0x4,%esp
  80299a:	68 e8 41 80 00       	push   $0x8041e8
  80299f:	6a 7c                	push   $0x7c
  8029a1:	68 ab 41 80 00       	push   $0x8041ab
  8029a6:	e8 7b dd ff ff       	call   800726 <_panic>
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	8b 10                	mov    (%eax),%edx
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	89 10                	mov    %edx,(%eax)
  8029b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b8:	8b 00                	mov    (%eax),%eax
  8029ba:	85 c0                	test   %eax,%eax
  8029bc:	74 0b                	je     8029c9 <insert_sorted_allocList+0x1f3>
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c6:	89 50 04             	mov    %edx,0x4(%eax)
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cf:	89 10                	mov    %edx,(%eax)
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d7:	89 50 04             	mov    %edx,0x4(%eax)
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	8b 00                	mov    (%eax),%eax
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	75 08                	jne    8029eb <insert_sorted_allocList+0x215>
  8029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e6:	a3 44 50 80 00       	mov    %eax,0x805044
  8029eb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029f0:	40                   	inc    %eax
  8029f1:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8029f6:	eb 38                	jmp    802a30 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8029f8:	a1 48 50 80 00       	mov    0x805048,%eax
  8029fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a04:	74 07                	je     802a0d <insert_sorted_allocList+0x237>
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	8b 00                	mov    (%eax),%eax
  802a0b:	eb 05                	jmp    802a12 <insert_sorted_allocList+0x23c>
  802a0d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a12:	a3 48 50 80 00       	mov    %eax,0x805048
  802a17:	a1 48 50 80 00       	mov    0x805048,%eax
  802a1c:	85 c0                	test   %eax,%eax
  802a1e:	0f 85 3f ff ff ff    	jne    802963 <insert_sorted_allocList+0x18d>
  802a24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a28:	0f 85 35 ff ff ff    	jne    802963 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802a2e:	eb 00                	jmp    802a30 <insert_sorted_allocList+0x25a>
  802a30:	90                   	nop
  802a31:	c9                   	leave  
  802a32:	c3                   	ret    

00802a33 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a33:	55                   	push   %ebp
  802a34:	89 e5                	mov    %esp,%ebp
  802a36:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802a39:	a1 38 51 80 00       	mov    0x805138,%eax
  802a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a41:	e9 6b 02 00 00       	jmp    802cb1 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a4f:	0f 85 90 00 00 00    	jne    802ae5 <alloc_block_FF+0xb2>
			  temp=element;
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802a5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5f:	75 17                	jne    802a78 <alloc_block_FF+0x45>
  802a61:	83 ec 04             	sub    $0x4,%esp
  802a64:	68 1c 42 80 00       	push   $0x80421c
  802a69:	68 92 00 00 00       	push   $0x92
  802a6e:	68 ab 41 80 00       	push   $0x8041ab
  802a73:	e8 ae dc ff ff       	call   800726 <_panic>
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	74 10                	je     802a91 <alloc_block_FF+0x5e>
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 00                	mov    (%eax),%eax
  802a86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a89:	8b 52 04             	mov    0x4(%edx),%edx
  802a8c:	89 50 04             	mov    %edx,0x4(%eax)
  802a8f:	eb 0b                	jmp    802a9c <alloc_block_FF+0x69>
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 40 04             	mov    0x4(%eax),%eax
  802a97:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	8b 40 04             	mov    0x4(%eax),%eax
  802aa2:	85 c0                	test   %eax,%eax
  802aa4:	74 0f                	je     802ab5 <alloc_block_FF+0x82>
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 40 04             	mov    0x4(%eax),%eax
  802aac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aaf:	8b 12                	mov    (%edx),%edx
  802ab1:	89 10                	mov    %edx,(%eax)
  802ab3:	eb 0a                	jmp    802abf <alloc_block_FF+0x8c>
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	a3 38 51 80 00       	mov    %eax,0x805138
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ad7:	48                   	dec    %eax
  802ad8:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802add:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae0:	e9 ff 01 00 00       	jmp    802ce4 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 40 0c             	mov    0xc(%eax),%eax
  802aeb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aee:	0f 86 b5 01 00 00    	jbe    802ca9 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 40 0c             	mov    0xc(%eax),%eax
  802afa:	2b 45 08             	sub    0x8(%ebp),%eax
  802afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802b00:	a1 48 51 80 00       	mov    0x805148,%eax
  802b05:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802b08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b0c:	75 17                	jne    802b25 <alloc_block_FF+0xf2>
  802b0e:	83 ec 04             	sub    $0x4,%esp
  802b11:	68 1c 42 80 00       	push   $0x80421c
  802b16:	68 99 00 00 00       	push   $0x99
  802b1b:	68 ab 41 80 00       	push   $0x8041ab
  802b20:	e8 01 dc ff ff       	call   800726 <_panic>
  802b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b28:	8b 00                	mov    (%eax),%eax
  802b2a:	85 c0                	test   %eax,%eax
  802b2c:	74 10                	je     802b3e <alloc_block_FF+0x10b>
  802b2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b31:	8b 00                	mov    (%eax),%eax
  802b33:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b36:	8b 52 04             	mov    0x4(%edx),%edx
  802b39:	89 50 04             	mov    %edx,0x4(%eax)
  802b3c:	eb 0b                	jmp    802b49 <alloc_block_FF+0x116>
  802b3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b41:	8b 40 04             	mov    0x4(%eax),%eax
  802b44:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4c:	8b 40 04             	mov    0x4(%eax),%eax
  802b4f:	85 c0                	test   %eax,%eax
  802b51:	74 0f                	je     802b62 <alloc_block_FF+0x12f>
  802b53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b56:	8b 40 04             	mov    0x4(%eax),%eax
  802b59:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b5c:	8b 12                	mov    (%edx),%edx
  802b5e:	89 10                	mov    %edx,(%eax)
  802b60:	eb 0a                	jmp    802b6c <alloc_block_FF+0x139>
  802b62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b65:	8b 00                	mov    (%eax),%eax
  802b67:	a3 48 51 80 00       	mov    %eax,0x805148
  802b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7f:	a1 54 51 80 00       	mov    0x805154,%eax
  802b84:	48                   	dec    %eax
  802b85:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802b8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b8e:	75 17                	jne    802ba7 <alloc_block_FF+0x174>
  802b90:	83 ec 04             	sub    $0x4,%esp
  802b93:	68 c4 41 80 00       	push   $0x8041c4
  802b98:	68 9a 00 00 00       	push   $0x9a
  802b9d:	68 ab 41 80 00       	push   $0x8041ab
  802ba2:	e8 7f db ff ff       	call   800726 <_panic>
  802ba7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802bad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb0:	89 50 04             	mov    %edx,0x4(%eax)
  802bb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb6:	8b 40 04             	mov    0x4(%eax),%eax
  802bb9:	85 c0                	test   %eax,%eax
  802bbb:	74 0c                	je     802bc9 <alloc_block_FF+0x196>
  802bbd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bc2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bc5:	89 10                	mov    %edx,(%eax)
  802bc7:	eb 08                	jmp    802bd1 <alloc_block_FF+0x19e>
  802bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcc:	a3 38 51 80 00       	mov    %eax,0x805138
  802bd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be2:	a1 44 51 80 00       	mov    0x805144,%eax
  802be7:	40                   	inc    %eax
  802be8:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802bed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf0:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf3:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 50 08             	mov    0x8(%eax),%edx
  802bfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bff:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c08:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 50 08             	mov    0x8(%eax),%edx
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	01 c2                	add    %eax,%edx
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802c22:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c26:	75 17                	jne    802c3f <alloc_block_FF+0x20c>
  802c28:	83 ec 04             	sub    $0x4,%esp
  802c2b:	68 1c 42 80 00       	push   $0x80421c
  802c30:	68 a2 00 00 00       	push   $0xa2
  802c35:	68 ab 41 80 00       	push   $0x8041ab
  802c3a:	e8 e7 da ff ff       	call   800726 <_panic>
  802c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c42:	8b 00                	mov    (%eax),%eax
  802c44:	85 c0                	test   %eax,%eax
  802c46:	74 10                	je     802c58 <alloc_block_FF+0x225>
  802c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4b:	8b 00                	mov    (%eax),%eax
  802c4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c50:	8b 52 04             	mov    0x4(%edx),%edx
  802c53:	89 50 04             	mov    %edx,0x4(%eax)
  802c56:	eb 0b                	jmp    802c63 <alloc_block_FF+0x230>
  802c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5b:	8b 40 04             	mov    0x4(%eax),%eax
  802c5e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c66:	8b 40 04             	mov    0x4(%eax),%eax
  802c69:	85 c0                	test   %eax,%eax
  802c6b:	74 0f                	je     802c7c <alloc_block_FF+0x249>
  802c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c70:	8b 40 04             	mov    0x4(%eax),%eax
  802c73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c76:	8b 12                	mov    (%edx),%edx
  802c78:	89 10                	mov    %edx,(%eax)
  802c7a:	eb 0a                	jmp    802c86 <alloc_block_FF+0x253>
  802c7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7f:	8b 00                	mov    (%eax),%eax
  802c81:	a3 38 51 80 00       	mov    %eax,0x805138
  802c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c99:	a1 44 51 80 00       	mov    0x805144,%eax
  802c9e:	48                   	dec    %eax
  802c9f:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802ca4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ca7:	eb 3b                	jmp    802ce4 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802ca9:	a1 40 51 80 00       	mov    0x805140,%eax
  802cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb5:	74 07                	je     802cbe <alloc_block_FF+0x28b>
  802cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cba:	8b 00                	mov    (%eax),%eax
  802cbc:	eb 05                	jmp    802cc3 <alloc_block_FF+0x290>
  802cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc3:	a3 40 51 80 00       	mov    %eax,0x805140
  802cc8:	a1 40 51 80 00       	mov    0x805140,%eax
  802ccd:	85 c0                	test   %eax,%eax
  802ccf:	0f 85 71 fd ff ff    	jne    802a46 <alloc_block_FF+0x13>
  802cd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd9:	0f 85 67 fd ff ff    	jne    802a46 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802cdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ce4:	c9                   	leave  
  802ce5:	c3                   	ret    

00802ce6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ce6:	55                   	push   %ebp
  802ce7:	89 e5                	mov    %esp,%ebp
  802ce9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802cec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802cf3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802cfa:	a1 38 51 80 00       	mov    0x805138,%eax
  802cff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802d02:	e9 d3 00 00 00       	jmp    802dda <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802d07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d10:	0f 85 90 00 00 00    	jne    802da6 <alloc_block_BF+0xc0>
	   temp = element;
  802d16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d19:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802d1c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d20:	75 17                	jne    802d39 <alloc_block_BF+0x53>
  802d22:	83 ec 04             	sub    $0x4,%esp
  802d25:	68 1c 42 80 00       	push   $0x80421c
  802d2a:	68 bd 00 00 00       	push   $0xbd
  802d2f:	68 ab 41 80 00       	push   $0x8041ab
  802d34:	e8 ed d9 ff ff       	call   800726 <_panic>
  802d39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	74 10                	je     802d52 <alloc_block_BF+0x6c>
  802d42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d4a:	8b 52 04             	mov    0x4(%edx),%edx
  802d4d:	89 50 04             	mov    %edx,0x4(%eax)
  802d50:	eb 0b                	jmp    802d5d <alloc_block_BF+0x77>
  802d52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d55:	8b 40 04             	mov    0x4(%eax),%eax
  802d58:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d60:	8b 40 04             	mov    0x4(%eax),%eax
  802d63:	85 c0                	test   %eax,%eax
  802d65:	74 0f                	je     802d76 <alloc_block_BF+0x90>
  802d67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d6a:	8b 40 04             	mov    0x4(%eax),%eax
  802d6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d70:	8b 12                	mov    (%edx),%edx
  802d72:	89 10                	mov    %edx,(%eax)
  802d74:	eb 0a                	jmp    802d80 <alloc_block_BF+0x9a>
  802d76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d79:	8b 00                	mov    (%eax),%eax
  802d7b:	a3 38 51 80 00       	mov    %eax,0x805138
  802d80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d93:	a1 44 51 80 00       	mov    0x805144,%eax
  802d98:	48                   	dec    %eax
  802d99:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802d9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802da1:	e9 41 01 00 00       	jmp    802ee7 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802da6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dac:	3b 45 08             	cmp    0x8(%ebp),%eax
  802daf:	76 21                	jbe    802dd2 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802db1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db4:	8b 40 0c             	mov    0xc(%eax),%eax
  802db7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802dba:	73 16                	jae    802dd2 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802dbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802dc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802dcb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802dd2:	a1 40 51 80 00       	mov    0x805140,%eax
  802dd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802dda:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802dde:	74 07                	je     802de7 <alloc_block_BF+0x101>
  802de0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de3:	8b 00                	mov    (%eax),%eax
  802de5:	eb 05                	jmp    802dec <alloc_block_BF+0x106>
  802de7:	b8 00 00 00 00       	mov    $0x0,%eax
  802dec:	a3 40 51 80 00       	mov    %eax,0x805140
  802df1:	a1 40 51 80 00       	mov    0x805140,%eax
  802df6:	85 c0                	test   %eax,%eax
  802df8:	0f 85 09 ff ff ff    	jne    802d07 <alloc_block_BF+0x21>
  802dfe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e02:	0f 85 ff fe ff ff    	jne    802d07 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802e08:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802e0c:	0f 85 d0 00 00 00    	jne    802ee2 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802e12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e15:	8b 40 0c             	mov    0xc(%eax),%eax
  802e18:	2b 45 08             	sub    0x8(%ebp),%eax
  802e1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802e1e:	a1 48 51 80 00       	mov    0x805148,%eax
  802e23:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802e26:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e2a:	75 17                	jne    802e43 <alloc_block_BF+0x15d>
  802e2c:	83 ec 04             	sub    $0x4,%esp
  802e2f:	68 1c 42 80 00       	push   $0x80421c
  802e34:	68 d1 00 00 00       	push   $0xd1
  802e39:	68 ab 41 80 00       	push   $0x8041ab
  802e3e:	e8 e3 d8 ff ff       	call   800726 <_panic>
  802e43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e46:	8b 00                	mov    (%eax),%eax
  802e48:	85 c0                	test   %eax,%eax
  802e4a:	74 10                	je     802e5c <alloc_block_BF+0x176>
  802e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e4f:	8b 00                	mov    (%eax),%eax
  802e51:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e54:	8b 52 04             	mov    0x4(%edx),%edx
  802e57:	89 50 04             	mov    %edx,0x4(%eax)
  802e5a:	eb 0b                	jmp    802e67 <alloc_block_BF+0x181>
  802e5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e5f:	8b 40 04             	mov    0x4(%eax),%eax
  802e62:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e6a:	8b 40 04             	mov    0x4(%eax),%eax
  802e6d:	85 c0                	test   %eax,%eax
  802e6f:	74 0f                	je     802e80 <alloc_block_BF+0x19a>
  802e71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e74:	8b 40 04             	mov    0x4(%eax),%eax
  802e77:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e7a:	8b 12                	mov    (%edx),%edx
  802e7c:	89 10                	mov    %edx,(%eax)
  802e7e:	eb 0a                	jmp    802e8a <alloc_block_BF+0x1a4>
  802e80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e83:	8b 00                	mov    (%eax),%eax
  802e85:	a3 48 51 80 00       	mov    %eax,0x805148
  802e8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9d:	a1 54 51 80 00       	mov    0x805154,%eax
  802ea2:	48                   	dec    %eax
  802ea3:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  802ea8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eab:	8b 55 08             	mov    0x8(%ebp),%edx
  802eae:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802eb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb4:	8b 50 08             	mov    0x8(%eax),%edx
  802eb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eba:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802ebd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ec3:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802ec6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec9:	8b 50 08             	mov    0x8(%eax),%edx
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	01 c2                	add    %eax,%edx
  802ed1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed4:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802ed7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eda:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802edd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ee0:	eb 05                	jmp    802ee7 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802ee2:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802ee7:	c9                   	leave  
  802ee8:	c3                   	ret    

00802ee9 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ee9:	55                   	push   %ebp
  802eea:	89 e5                	mov    %esp,%ebp
  802eec:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802eef:	83 ec 04             	sub    $0x4,%esp
  802ef2:	68 3c 42 80 00       	push   $0x80423c
  802ef7:	68 e8 00 00 00       	push   $0xe8
  802efc:	68 ab 41 80 00       	push   $0x8041ab
  802f01:	e8 20 d8 ff ff       	call   800726 <_panic>

00802f06 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f06:	55                   	push   %ebp
  802f07:	89 e5                	mov    %esp,%ebp
  802f09:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802f0c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f11:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802f14:	a1 38 51 80 00       	mov    0x805138,%eax
  802f19:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802f1c:	a1 44 51 80 00       	mov    0x805144,%eax
  802f21:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802f24:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f28:	75 68                	jne    802f92 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802f2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f2e:	75 17                	jne    802f47 <insert_sorted_with_merge_freeList+0x41>
  802f30:	83 ec 04             	sub    $0x4,%esp
  802f33:	68 88 41 80 00       	push   $0x804188
  802f38:	68 36 01 00 00       	push   $0x136
  802f3d:	68 ab 41 80 00       	push   $0x8041ab
  802f42:	e8 df d7 ff ff       	call   800726 <_panic>
  802f47:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	89 10                	mov    %edx,(%eax)
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	8b 00                	mov    (%eax),%eax
  802f57:	85 c0                	test   %eax,%eax
  802f59:	74 0d                	je     802f68 <insert_sorted_with_merge_freeList+0x62>
  802f5b:	a1 38 51 80 00       	mov    0x805138,%eax
  802f60:	8b 55 08             	mov    0x8(%ebp),%edx
  802f63:	89 50 04             	mov    %edx,0x4(%eax)
  802f66:	eb 08                	jmp    802f70 <insert_sorted_with_merge_freeList+0x6a>
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f70:	8b 45 08             	mov    0x8(%ebp),%eax
  802f73:	a3 38 51 80 00       	mov    %eax,0x805138
  802f78:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f82:	a1 44 51 80 00       	mov    0x805144,%eax
  802f87:	40                   	inc    %eax
  802f88:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802f8d:	e9 ba 06 00 00       	jmp    80364c <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f95:	8b 50 08             	mov    0x8(%eax),%edx
  802f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9e:	01 c2                	add    %eax,%edx
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	8b 40 08             	mov    0x8(%eax),%eax
  802fa6:	39 c2                	cmp    %eax,%edx
  802fa8:	73 68                	jae    803012 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802faa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fae:	75 17                	jne    802fc7 <insert_sorted_with_merge_freeList+0xc1>
  802fb0:	83 ec 04             	sub    $0x4,%esp
  802fb3:	68 c4 41 80 00       	push   $0x8041c4
  802fb8:	68 3a 01 00 00       	push   $0x13a
  802fbd:	68 ab 41 80 00       	push   $0x8041ab
  802fc2:	e8 5f d7 ff ff       	call   800726 <_panic>
  802fc7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd0:	89 50 04             	mov    %edx,0x4(%eax)
  802fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd6:	8b 40 04             	mov    0x4(%eax),%eax
  802fd9:	85 c0                	test   %eax,%eax
  802fdb:	74 0c                	je     802fe9 <insert_sorted_with_merge_freeList+0xe3>
  802fdd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe5:	89 10                	mov    %edx,(%eax)
  802fe7:	eb 08                	jmp    802ff1 <insert_sorted_with_merge_freeList+0xeb>
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	a3 38 51 80 00       	mov    %eax,0x805138
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803002:	a1 44 51 80 00       	mov    0x805144,%eax
  803007:	40                   	inc    %eax
  803008:	a3 44 51 80 00       	mov    %eax,0x805144





}
  80300d:	e9 3a 06 00 00       	jmp    80364c <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  803012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803015:	8b 50 08             	mov    0x8(%eax),%edx
  803018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301b:	8b 40 0c             	mov    0xc(%eax),%eax
  80301e:	01 c2                	add    %eax,%edx
  803020:	8b 45 08             	mov    0x8(%ebp),%eax
  803023:	8b 40 08             	mov    0x8(%eax),%eax
  803026:	39 c2                	cmp    %eax,%edx
  803028:	0f 85 90 00 00 00    	jne    8030be <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  80302e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803031:	8b 50 0c             	mov    0xc(%eax),%edx
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	8b 40 0c             	mov    0xc(%eax),%eax
  80303a:	01 c2                	add    %eax,%edx
  80303c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303f:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  803042:	8b 45 08             	mov    0x8(%ebp),%eax
  803045:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  80304c:	8b 45 08             	mov    0x8(%ebp),%eax
  80304f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803056:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80305a:	75 17                	jne    803073 <insert_sorted_with_merge_freeList+0x16d>
  80305c:	83 ec 04             	sub    $0x4,%esp
  80305f:	68 88 41 80 00       	push   $0x804188
  803064:	68 41 01 00 00       	push   $0x141
  803069:	68 ab 41 80 00       	push   $0x8041ab
  80306e:	e8 b3 d6 ff ff       	call   800726 <_panic>
  803073:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	89 10                	mov    %edx,(%eax)
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	8b 00                	mov    (%eax),%eax
  803083:	85 c0                	test   %eax,%eax
  803085:	74 0d                	je     803094 <insert_sorted_with_merge_freeList+0x18e>
  803087:	a1 48 51 80 00       	mov    0x805148,%eax
  80308c:	8b 55 08             	mov    0x8(%ebp),%edx
  80308f:	89 50 04             	mov    %edx,0x4(%eax)
  803092:	eb 08                	jmp    80309c <insert_sorted_with_merge_freeList+0x196>
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ae:	a1 54 51 80 00       	mov    0x805154,%eax
  8030b3:	40                   	inc    %eax
  8030b4:	a3 54 51 80 00       	mov    %eax,0x805154





}
  8030b9:	e9 8e 05 00 00       	jmp    80364c <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	8b 50 08             	mov    0x8(%eax),%edx
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ca:	01 c2                	add    %eax,%edx
  8030cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030cf:	8b 40 08             	mov    0x8(%eax),%eax
  8030d2:	39 c2                	cmp    %eax,%edx
  8030d4:	73 68                	jae    80313e <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8030d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030da:	75 17                	jne    8030f3 <insert_sorted_with_merge_freeList+0x1ed>
  8030dc:	83 ec 04             	sub    $0x4,%esp
  8030df:	68 88 41 80 00       	push   $0x804188
  8030e4:	68 45 01 00 00       	push   $0x145
  8030e9:	68 ab 41 80 00       	push   $0x8041ab
  8030ee:	e8 33 d6 ff ff       	call   800726 <_panic>
  8030f3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	89 10                	mov    %edx,(%eax)
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	8b 00                	mov    (%eax),%eax
  803103:	85 c0                	test   %eax,%eax
  803105:	74 0d                	je     803114 <insert_sorted_with_merge_freeList+0x20e>
  803107:	a1 38 51 80 00       	mov    0x805138,%eax
  80310c:	8b 55 08             	mov    0x8(%ebp),%edx
  80310f:	89 50 04             	mov    %edx,0x4(%eax)
  803112:	eb 08                	jmp    80311c <insert_sorted_with_merge_freeList+0x216>
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80311c:	8b 45 08             	mov    0x8(%ebp),%eax
  80311f:	a3 38 51 80 00       	mov    %eax,0x805138
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80312e:	a1 44 51 80 00       	mov    0x805144,%eax
  803133:	40                   	inc    %eax
  803134:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803139:	e9 0e 05 00 00       	jmp    80364c <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  80313e:	8b 45 08             	mov    0x8(%ebp),%eax
  803141:	8b 50 08             	mov    0x8(%eax),%edx
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	8b 40 0c             	mov    0xc(%eax),%eax
  80314a:	01 c2                	add    %eax,%edx
  80314c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80314f:	8b 40 08             	mov    0x8(%eax),%eax
  803152:	39 c2                	cmp    %eax,%edx
  803154:	0f 85 9c 00 00 00    	jne    8031f6 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  80315a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315d:	8b 50 0c             	mov    0xc(%eax),%edx
  803160:	8b 45 08             	mov    0x8(%ebp),%eax
  803163:	8b 40 0c             	mov    0xc(%eax),%eax
  803166:	01 c2                	add    %eax,%edx
  803168:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316b:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  80316e:	8b 45 08             	mov    0x8(%ebp),%eax
  803171:	8b 50 08             	mov    0x8(%eax),%edx
  803174:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803177:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  803184:	8b 45 08             	mov    0x8(%ebp),%eax
  803187:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80318e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803192:	75 17                	jne    8031ab <insert_sorted_with_merge_freeList+0x2a5>
  803194:	83 ec 04             	sub    $0x4,%esp
  803197:	68 88 41 80 00       	push   $0x804188
  80319c:	68 4d 01 00 00       	push   $0x14d
  8031a1:	68 ab 41 80 00       	push   $0x8041ab
  8031a6:	e8 7b d5 ff ff       	call   800726 <_panic>
  8031ab:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	89 10                	mov    %edx,(%eax)
  8031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b9:	8b 00                	mov    (%eax),%eax
  8031bb:	85 c0                	test   %eax,%eax
  8031bd:	74 0d                	je     8031cc <insert_sorted_with_merge_freeList+0x2c6>
  8031bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8031c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c7:	89 50 04             	mov    %edx,0x4(%eax)
  8031ca:	eb 08                	jmp    8031d4 <insert_sorted_with_merge_freeList+0x2ce>
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8031eb:	40                   	inc    %eax
  8031ec:	a3 54 51 80 00       	mov    %eax,0x805154





}
  8031f1:	e9 56 04 00 00       	jmp    80364c <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8031f6:	a1 38 51 80 00       	mov    0x805138,%eax
  8031fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031fe:	e9 19 04 00 00       	jmp    80361c <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  80320b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320e:	8b 50 08             	mov    0x8(%eax),%edx
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	8b 40 0c             	mov    0xc(%eax),%eax
  803217:	01 c2                	add    %eax,%edx
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	8b 40 08             	mov    0x8(%eax),%eax
  80321f:	39 c2                	cmp    %eax,%edx
  803221:	0f 85 ad 01 00 00    	jne    8033d4 <insert_sorted_with_merge_freeList+0x4ce>
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	8b 50 08             	mov    0x8(%eax),%edx
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	8b 40 0c             	mov    0xc(%eax),%eax
  803233:	01 c2                	add    %eax,%edx
  803235:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803238:	8b 40 08             	mov    0x8(%eax),%eax
  80323b:	39 c2                	cmp    %eax,%edx
  80323d:	0f 85 91 01 00 00    	jne    8033d4 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  803243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803246:	8b 50 0c             	mov    0xc(%eax),%edx
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	8b 48 0c             	mov    0xc(%eax),%ecx
  80324f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803252:	8b 40 0c             	mov    0xc(%eax),%eax
  803255:	01 c8                	add    %ecx,%eax
  803257:	01 c2                	add    %eax,%edx
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803269:	8b 45 08             	mov    0x8(%ebp),%eax
  80326c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  803273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803276:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  80327d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803280:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  803287:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80328b:	75 17                	jne    8032a4 <insert_sorted_with_merge_freeList+0x39e>
  80328d:	83 ec 04             	sub    $0x4,%esp
  803290:	68 1c 42 80 00       	push   $0x80421c
  803295:	68 5b 01 00 00       	push   $0x15b
  80329a:	68 ab 41 80 00       	push   $0x8041ab
  80329f:	e8 82 d4 ff ff       	call   800726 <_panic>
  8032a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a7:	8b 00                	mov    (%eax),%eax
  8032a9:	85 c0                	test   %eax,%eax
  8032ab:	74 10                	je     8032bd <insert_sorted_with_merge_freeList+0x3b7>
  8032ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b0:	8b 00                	mov    (%eax),%eax
  8032b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032b5:	8b 52 04             	mov    0x4(%edx),%edx
  8032b8:	89 50 04             	mov    %edx,0x4(%eax)
  8032bb:	eb 0b                	jmp    8032c8 <insert_sorted_with_merge_freeList+0x3c2>
  8032bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c0:	8b 40 04             	mov    0x4(%eax),%eax
  8032c3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032cb:	8b 40 04             	mov    0x4(%eax),%eax
  8032ce:	85 c0                	test   %eax,%eax
  8032d0:	74 0f                	je     8032e1 <insert_sorted_with_merge_freeList+0x3db>
  8032d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032d5:	8b 40 04             	mov    0x4(%eax),%eax
  8032d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032db:	8b 12                	mov    (%edx),%edx
  8032dd:	89 10                	mov    %edx,(%eax)
  8032df:	eb 0a                	jmp    8032eb <insert_sorted_with_merge_freeList+0x3e5>
  8032e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032e4:	8b 00                	mov    (%eax),%eax
  8032e6:	a3 38 51 80 00       	mov    %eax,0x805138
  8032eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032fe:	a1 44 51 80 00       	mov    0x805144,%eax
  803303:	48                   	dec    %eax
  803304:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803309:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80330d:	75 17                	jne    803326 <insert_sorted_with_merge_freeList+0x420>
  80330f:	83 ec 04             	sub    $0x4,%esp
  803312:	68 88 41 80 00       	push   $0x804188
  803317:	68 5c 01 00 00       	push   $0x15c
  80331c:	68 ab 41 80 00       	push   $0x8041ab
  803321:	e8 00 d4 ff ff       	call   800726 <_panic>
  803326:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80332c:	8b 45 08             	mov    0x8(%ebp),%eax
  80332f:	89 10                	mov    %edx,(%eax)
  803331:	8b 45 08             	mov    0x8(%ebp),%eax
  803334:	8b 00                	mov    (%eax),%eax
  803336:	85 c0                	test   %eax,%eax
  803338:	74 0d                	je     803347 <insert_sorted_with_merge_freeList+0x441>
  80333a:	a1 48 51 80 00       	mov    0x805148,%eax
  80333f:	8b 55 08             	mov    0x8(%ebp),%edx
  803342:	89 50 04             	mov    %edx,0x4(%eax)
  803345:	eb 08                	jmp    80334f <insert_sorted_with_merge_freeList+0x449>
  803347:	8b 45 08             	mov    0x8(%ebp),%eax
  80334a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80334f:	8b 45 08             	mov    0x8(%ebp),%eax
  803352:	a3 48 51 80 00       	mov    %eax,0x805148
  803357:	8b 45 08             	mov    0x8(%ebp),%eax
  80335a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803361:	a1 54 51 80 00       	mov    0x805154,%eax
  803366:	40                   	inc    %eax
  803367:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  80336c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803370:	75 17                	jne    803389 <insert_sorted_with_merge_freeList+0x483>
  803372:	83 ec 04             	sub    $0x4,%esp
  803375:	68 88 41 80 00       	push   $0x804188
  80337a:	68 5d 01 00 00       	push   $0x15d
  80337f:	68 ab 41 80 00       	push   $0x8041ab
  803384:	e8 9d d3 ff ff       	call   800726 <_panic>
  803389:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80338f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803392:	89 10                	mov    %edx,(%eax)
  803394:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803397:	8b 00                	mov    (%eax),%eax
  803399:	85 c0                	test   %eax,%eax
  80339b:	74 0d                	je     8033aa <insert_sorted_with_merge_freeList+0x4a4>
  80339d:	a1 48 51 80 00       	mov    0x805148,%eax
  8033a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033a5:	89 50 04             	mov    %edx,0x4(%eax)
  8033a8:	eb 08                	jmp    8033b2 <insert_sorted_with_merge_freeList+0x4ac>
  8033aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b5:	a3 48 51 80 00       	mov    %eax,0x805148
  8033ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c4:	a1 54 51 80 00       	mov    0x805154,%eax
  8033c9:	40                   	inc    %eax
  8033ca:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  8033cf:	e9 78 02 00 00       	jmp    80364c <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  8033d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d7:	8b 50 08             	mov    0x8(%eax),%edx
  8033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e0:	01 c2                	add    %eax,%edx
  8033e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e5:	8b 40 08             	mov    0x8(%eax),%eax
  8033e8:	39 c2                	cmp    %eax,%edx
  8033ea:	0f 83 b8 00 00 00    	jae    8034a8 <insert_sorted_with_merge_freeList+0x5a2>
  8033f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f3:	8b 50 08             	mov    0x8(%eax),%edx
  8033f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8033fc:	01 c2                	add    %eax,%edx
  8033fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803401:	8b 40 08             	mov    0x8(%eax),%eax
  803404:	39 c2                	cmp    %eax,%edx
  803406:	0f 85 9c 00 00 00    	jne    8034a8 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  80340c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340f:	8b 50 0c             	mov    0xc(%eax),%edx
  803412:	8b 45 08             	mov    0x8(%ebp),%eax
  803415:	8b 40 0c             	mov    0xc(%eax),%eax
  803418:	01 c2                	add    %eax,%edx
  80341a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341d:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  803420:	8b 45 08             	mov    0x8(%ebp),%eax
  803423:	8b 50 08             	mov    0x8(%eax),%edx
  803426:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803429:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803436:	8b 45 08             	mov    0x8(%ebp),%eax
  803439:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803440:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803444:	75 17                	jne    80345d <insert_sorted_with_merge_freeList+0x557>
  803446:	83 ec 04             	sub    $0x4,%esp
  803449:	68 88 41 80 00       	push   $0x804188
  80344e:	68 67 01 00 00       	push   $0x167
  803453:	68 ab 41 80 00       	push   $0x8041ab
  803458:	e8 c9 d2 ff ff       	call   800726 <_panic>
  80345d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803463:	8b 45 08             	mov    0x8(%ebp),%eax
  803466:	89 10                	mov    %edx,(%eax)
  803468:	8b 45 08             	mov    0x8(%ebp),%eax
  80346b:	8b 00                	mov    (%eax),%eax
  80346d:	85 c0                	test   %eax,%eax
  80346f:	74 0d                	je     80347e <insert_sorted_with_merge_freeList+0x578>
  803471:	a1 48 51 80 00       	mov    0x805148,%eax
  803476:	8b 55 08             	mov    0x8(%ebp),%edx
  803479:	89 50 04             	mov    %edx,0x4(%eax)
  80347c:	eb 08                	jmp    803486 <insert_sorted_with_merge_freeList+0x580>
  80347e:	8b 45 08             	mov    0x8(%ebp),%eax
  803481:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	a3 48 51 80 00       	mov    %eax,0x805148
  80348e:	8b 45 08             	mov    0x8(%ebp),%eax
  803491:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803498:	a1 54 51 80 00       	mov    0x805154,%eax
  80349d:	40                   	inc    %eax
  80349e:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  8034a3:	e9 a4 01 00 00       	jmp    80364c <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8034a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ab:	8b 50 08             	mov    0x8(%eax),%edx
  8034ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b4:	01 c2                	add    %eax,%edx
  8034b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b9:	8b 40 08             	mov    0x8(%eax),%eax
  8034bc:	39 c2                	cmp    %eax,%edx
  8034be:	0f 85 ac 00 00 00    	jne    803570 <insert_sorted_with_merge_freeList+0x66a>
  8034c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c7:	8b 50 08             	mov    0x8(%eax),%edx
  8034ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d0:	01 c2                	add    %eax,%edx
  8034d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d5:	8b 40 08             	mov    0x8(%eax),%eax
  8034d8:	39 c2                	cmp    %eax,%edx
  8034da:	0f 83 90 00 00 00    	jae    803570 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  8034e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e3:	8b 50 0c             	mov    0xc(%eax),%edx
  8034e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ec:	01 c2                	add    %eax,%edx
  8034ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f1:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  8034fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803501:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803508:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80350c:	75 17                	jne    803525 <insert_sorted_with_merge_freeList+0x61f>
  80350e:	83 ec 04             	sub    $0x4,%esp
  803511:	68 88 41 80 00       	push   $0x804188
  803516:	68 70 01 00 00       	push   $0x170
  80351b:	68 ab 41 80 00       	push   $0x8041ab
  803520:	e8 01 d2 ff ff       	call   800726 <_panic>
  803525:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80352b:	8b 45 08             	mov    0x8(%ebp),%eax
  80352e:	89 10                	mov    %edx,(%eax)
  803530:	8b 45 08             	mov    0x8(%ebp),%eax
  803533:	8b 00                	mov    (%eax),%eax
  803535:	85 c0                	test   %eax,%eax
  803537:	74 0d                	je     803546 <insert_sorted_with_merge_freeList+0x640>
  803539:	a1 48 51 80 00       	mov    0x805148,%eax
  80353e:	8b 55 08             	mov    0x8(%ebp),%edx
  803541:	89 50 04             	mov    %edx,0x4(%eax)
  803544:	eb 08                	jmp    80354e <insert_sorted_with_merge_freeList+0x648>
  803546:	8b 45 08             	mov    0x8(%ebp),%eax
  803549:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80354e:	8b 45 08             	mov    0x8(%ebp),%eax
  803551:	a3 48 51 80 00       	mov    %eax,0x805148
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803560:	a1 54 51 80 00       	mov    0x805154,%eax
  803565:	40                   	inc    %eax
  803566:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  80356b:	e9 dc 00 00 00       	jmp    80364c <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803573:	8b 50 08             	mov    0x8(%eax),%edx
  803576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803579:	8b 40 0c             	mov    0xc(%eax),%eax
  80357c:	01 c2                	add    %eax,%edx
  80357e:	8b 45 08             	mov    0x8(%ebp),%eax
  803581:	8b 40 08             	mov    0x8(%eax),%eax
  803584:	39 c2                	cmp    %eax,%edx
  803586:	0f 83 88 00 00 00    	jae    803614 <insert_sorted_with_merge_freeList+0x70e>
  80358c:	8b 45 08             	mov    0x8(%ebp),%eax
  80358f:	8b 50 08             	mov    0x8(%eax),%edx
  803592:	8b 45 08             	mov    0x8(%ebp),%eax
  803595:	8b 40 0c             	mov    0xc(%eax),%eax
  803598:	01 c2                	add    %eax,%edx
  80359a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80359d:	8b 40 08             	mov    0x8(%eax),%eax
  8035a0:	39 c2                	cmp    %eax,%edx
  8035a2:	73 70                	jae    803614 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  8035a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035a8:	74 06                	je     8035b0 <insert_sorted_with_merge_freeList+0x6aa>
  8035aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ae:	75 17                	jne    8035c7 <insert_sorted_with_merge_freeList+0x6c1>
  8035b0:	83 ec 04             	sub    $0x4,%esp
  8035b3:	68 e8 41 80 00       	push   $0x8041e8
  8035b8:	68 75 01 00 00       	push   $0x175
  8035bd:	68 ab 41 80 00       	push   $0x8041ab
  8035c2:	e8 5f d1 ff ff       	call   800726 <_panic>
  8035c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ca:	8b 10                	mov    (%eax),%edx
  8035cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cf:	89 10                	mov    %edx,(%eax)
  8035d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d4:	8b 00                	mov    (%eax),%eax
  8035d6:	85 c0                	test   %eax,%eax
  8035d8:	74 0b                	je     8035e5 <insert_sorted_with_merge_freeList+0x6df>
  8035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dd:	8b 00                	mov    (%eax),%eax
  8035df:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e2:	89 50 04             	mov    %edx,0x4(%eax)
  8035e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8035eb:	89 10                	mov    %edx,(%eax)
  8035ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035f3:	89 50 04             	mov    %edx,0x4(%eax)
  8035f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f9:	8b 00                	mov    (%eax),%eax
  8035fb:	85 c0                	test   %eax,%eax
  8035fd:	75 08                	jne    803607 <insert_sorted_with_merge_freeList+0x701>
  8035ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803602:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803607:	a1 44 51 80 00       	mov    0x805144,%eax
  80360c:	40                   	inc    %eax
  80360d:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  803612:	eb 38                	jmp    80364c <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803614:	a1 40 51 80 00       	mov    0x805140,%eax
  803619:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80361c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803620:	74 07                	je     803629 <insert_sorted_with_merge_freeList+0x723>
  803622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803625:	8b 00                	mov    (%eax),%eax
  803627:	eb 05                	jmp    80362e <insert_sorted_with_merge_freeList+0x728>
  803629:	b8 00 00 00 00       	mov    $0x0,%eax
  80362e:	a3 40 51 80 00       	mov    %eax,0x805140
  803633:	a1 40 51 80 00       	mov    0x805140,%eax
  803638:	85 c0                	test   %eax,%eax
  80363a:	0f 85 c3 fb ff ff    	jne    803203 <insert_sorted_with_merge_freeList+0x2fd>
  803640:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803644:	0f 85 b9 fb ff ff    	jne    803203 <insert_sorted_with_merge_freeList+0x2fd>





}
  80364a:	eb 00                	jmp    80364c <insert_sorted_with_merge_freeList+0x746>
  80364c:	90                   	nop
  80364d:	c9                   	leave  
  80364e:	c3                   	ret    
  80364f:	90                   	nop

00803650 <__udivdi3>:
  803650:	55                   	push   %ebp
  803651:	57                   	push   %edi
  803652:	56                   	push   %esi
  803653:	53                   	push   %ebx
  803654:	83 ec 1c             	sub    $0x1c,%esp
  803657:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80365b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80365f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803663:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803667:	89 ca                	mov    %ecx,%edx
  803669:	89 f8                	mov    %edi,%eax
  80366b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80366f:	85 f6                	test   %esi,%esi
  803671:	75 2d                	jne    8036a0 <__udivdi3+0x50>
  803673:	39 cf                	cmp    %ecx,%edi
  803675:	77 65                	ja     8036dc <__udivdi3+0x8c>
  803677:	89 fd                	mov    %edi,%ebp
  803679:	85 ff                	test   %edi,%edi
  80367b:	75 0b                	jne    803688 <__udivdi3+0x38>
  80367d:	b8 01 00 00 00       	mov    $0x1,%eax
  803682:	31 d2                	xor    %edx,%edx
  803684:	f7 f7                	div    %edi
  803686:	89 c5                	mov    %eax,%ebp
  803688:	31 d2                	xor    %edx,%edx
  80368a:	89 c8                	mov    %ecx,%eax
  80368c:	f7 f5                	div    %ebp
  80368e:	89 c1                	mov    %eax,%ecx
  803690:	89 d8                	mov    %ebx,%eax
  803692:	f7 f5                	div    %ebp
  803694:	89 cf                	mov    %ecx,%edi
  803696:	89 fa                	mov    %edi,%edx
  803698:	83 c4 1c             	add    $0x1c,%esp
  80369b:	5b                   	pop    %ebx
  80369c:	5e                   	pop    %esi
  80369d:	5f                   	pop    %edi
  80369e:	5d                   	pop    %ebp
  80369f:	c3                   	ret    
  8036a0:	39 ce                	cmp    %ecx,%esi
  8036a2:	77 28                	ja     8036cc <__udivdi3+0x7c>
  8036a4:	0f bd fe             	bsr    %esi,%edi
  8036a7:	83 f7 1f             	xor    $0x1f,%edi
  8036aa:	75 40                	jne    8036ec <__udivdi3+0x9c>
  8036ac:	39 ce                	cmp    %ecx,%esi
  8036ae:	72 0a                	jb     8036ba <__udivdi3+0x6a>
  8036b0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8036b4:	0f 87 9e 00 00 00    	ja     803758 <__udivdi3+0x108>
  8036ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8036bf:	89 fa                	mov    %edi,%edx
  8036c1:	83 c4 1c             	add    $0x1c,%esp
  8036c4:	5b                   	pop    %ebx
  8036c5:	5e                   	pop    %esi
  8036c6:	5f                   	pop    %edi
  8036c7:	5d                   	pop    %ebp
  8036c8:	c3                   	ret    
  8036c9:	8d 76 00             	lea    0x0(%esi),%esi
  8036cc:	31 ff                	xor    %edi,%edi
  8036ce:	31 c0                	xor    %eax,%eax
  8036d0:	89 fa                	mov    %edi,%edx
  8036d2:	83 c4 1c             	add    $0x1c,%esp
  8036d5:	5b                   	pop    %ebx
  8036d6:	5e                   	pop    %esi
  8036d7:	5f                   	pop    %edi
  8036d8:	5d                   	pop    %ebp
  8036d9:	c3                   	ret    
  8036da:	66 90                	xchg   %ax,%ax
  8036dc:	89 d8                	mov    %ebx,%eax
  8036de:	f7 f7                	div    %edi
  8036e0:	31 ff                	xor    %edi,%edi
  8036e2:	89 fa                	mov    %edi,%edx
  8036e4:	83 c4 1c             	add    $0x1c,%esp
  8036e7:	5b                   	pop    %ebx
  8036e8:	5e                   	pop    %esi
  8036e9:	5f                   	pop    %edi
  8036ea:	5d                   	pop    %ebp
  8036eb:	c3                   	ret    
  8036ec:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036f1:	89 eb                	mov    %ebp,%ebx
  8036f3:	29 fb                	sub    %edi,%ebx
  8036f5:	89 f9                	mov    %edi,%ecx
  8036f7:	d3 e6                	shl    %cl,%esi
  8036f9:	89 c5                	mov    %eax,%ebp
  8036fb:	88 d9                	mov    %bl,%cl
  8036fd:	d3 ed                	shr    %cl,%ebp
  8036ff:	89 e9                	mov    %ebp,%ecx
  803701:	09 f1                	or     %esi,%ecx
  803703:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803707:	89 f9                	mov    %edi,%ecx
  803709:	d3 e0                	shl    %cl,%eax
  80370b:	89 c5                	mov    %eax,%ebp
  80370d:	89 d6                	mov    %edx,%esi
  80370f:	88 d9                	mov    %bl,%cl
  803711:	d3 ee                	shr    %cl,%esi
  803713:	89 f9                	mov    %edi,%ecx
  803715:	d3 e2                	shl    %cl,%edx
  803717:	8b 44 24 08          	mov    0x8(%esp),%eax
  80371b:	88 d9                	mov    %bl,%cl
  80371d:	d3 e8                	shr    %cl,%eax
  80371f:	09 c2                	or     %eax,%edx
  803721:	89 d0                	mov    %edx,%eax
  803723:	89 f2                	mov    %esi,%edx
  803725:	f7 74 24 0c          	divl   0xc(%esp)
  803729:	89 d6                	mov    %edx,%esi
  80372b:	89 c3                	mov    %eax,%ebx
  80372d:	f7 e5                	mul    %ebp
  80372f:	39 d6                	cmp    %edx,%esi
  803731:	72 19                	jb     80374c <__udivdi3+0xfc>
  803733:	74 0b                	je     803740 <__udivdi3+0xf0>
  803735:	89 d8                	mov    %ebx,%eax
  803737:	31 ff                	xor    %edi,%edi
  803739:	e9 58 ff ff ff       	jmp    803696 <__udivdi3+0x46>
  80373e:	66 90                	xchg   %ax,%ax
  803740:	8b 54 24 08          	mov    0x8(%esp),%edx
  803744:	89 f9                	mov    %edi,%ecx
  803746:	d3 e2                	shl    %cl,%edx
  803748:	39 c2                	cmp    %eax,%edx
  80374a:	73 e9                	jae    803735 <__udivdi3+0xe5>
  80374c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80374f:	31 ff                	xor    %edi,%edi
  803751:	e9 40 ff ff ff       	jmp    803696 <__udivdi3+0x46>
  803756:	66 90                	xchg   %ax,%ax
  803758:	31 c0                	xor    %eax,%eax
  80375a:	e9 37 ff ff ff       	jmp    803696 <__udivdi3+0x46>
  80375f:	90                   	nop

00803760 <__umoddi3>:
  803760:	55                   	push   %ebp
  803761:	57                   	push   %edi
  803762:	56                   	push   %esi
  803763:	53                   	push   %ebx
  803764:	83 ec 1c             	sub    $0x1c,%esp
  803767:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80376b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80376f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803773:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803777:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80377b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80377f:	89 f3                	mov    %esi,%ebx
  803781:	89 fa                	mov    %edi,%edx
  803783:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803787:	89 34 24             	mov    %esi,(%esp)
  80378a:	85 c0                	test   %eax,%eax
  80378c:	75 1a                	jne    8037a8 <__umoddi3+0x48>
  80378e:	39 f7                	cmp    %esi,%edi
  803790:	0f 86 a2 00 00 00    	jbe    803838 <__umoddi3+0xd8>
  803796:	89 c8                	mov    %ecx,%eax
  803798:	89 f2                	mov    %esi,%edx
  80379a:	f7 f7                	div    %edi
  80379c:	89 d0                	mov    %edx,%eax
  80379e:	31 d2                	xor    %edx,%edx
  8037a0:	83 c4 1c             	add    $0x1c,%esp
  8037a3:	5b                   	pop    %ebx
  8037a4:	5e                   	pop    %esi
  8037a5:	5f                   	pop    %edi
  8037a6:	5d                   	pop    %ebp
  8037a7:	c3                   	ret    
  8037a8:	39 f0                	cmp    %esi,%eax
  8037aa:	0f 87 ac 00 00 00    	ja     80385c <__umoddi3+0xfc>
  8037b0:	0f bd e8             	bsr    %eax,%ebp
  8037b3:	83 f5 1f             	xor    $0x1f,%ebp
  8037b6:	0f 84 ac 00 00 00    	je     803868 <__umoddi3+0x108>
  8037bc:	bf 20 00 00 00       	mov    $0x20,%edi
  8037c1:	29 ef                	sub    %ebp,%edi
  8037c3:	89 fe                	mov    %edi,%esi
  8037c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037c9:	89 e9                	mov    %ebp,%ecx
  8037cb:	d3 e0                	shl    %cl,%eax
  8037cd:	89 d7                	mov    %edx,%edi
  8037cf:	89 f1                	mov    %esi,%ecx
  8037d1:	d3 ef                	shr    %cl,%edi
  8037d3:	09 c7                	or     %eax,%edi
  8037d5:	89 e9                	mov    %ebp,%ecx
  8037d7:	d3 e2                	shl    %cl,%edx
  8037d9:	89 14 24             	mov    %edx,(%esp)
  8037dc:	89 d8                	mov    %ebx,%eax
  8037de:	d3 e0                	shl    %cl,%eax
  8037e0:	89 c2                	mov    %eax,%edx
  8037e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037e6:	d3 e0                	shl    %cl,%eax
  8037e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037f0:	89 f1                	mov    %esi,%ecx
  8037f2:	d3 e8                	shr    %cl,%eax
  8037f4:	09 d0                	or     %edx,%eax
  8037f6:	d3 eb                	shr    %cl,%ebx
  8037f8:	89 da                	mov    %ebx,%edx
  8037fa:	f7 f7                	div    %edi
  8037fc:	89 d3                	mov    %edx,%ebx
  8037fe:	f7 24 24             	mull   (%esp)
  803801:	89 c6                	mov    %eax,%esi
  803803:	89 d1                	mov    %edx,%ecx
  803805:	39 d3                	cmp    %edx,%ebx
  803807:	0f 82 87 00 00 00    	jb     803894 <__umoddi3+0x134>
  80380d:	0f 84 91 00 00 00    	je     8038a4 <__umoddi3+0x144>
  803813:	8b 54 24 04          	mov    0x4(%esp),%edx
  803817:	29 f2                	sub    %esi,%edx
  803819:	19 cb                	sbb    %ecx,%ebx
  80381b:	89 d8                	mov    %ebx,%eax
  80381d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803821:	d3 e0                	shl    %cl,%eax
  803823:	89 e9                	mov    %ebp,%ecx
  803825:	d3 ea                	shr    %cl,%edx
  803827:	09 d0                	or     %edx,%eax
  803829:	89 e9                	mov    %ebp,%ecx
  80382b:	d3 eb                	shr    %cl,%ebx
  80382d:	89 da                	mov    %ebx,%edx
  80382f:	83 c4 1c             	add    $0x1c,%esp
  803832:	5b                   	pop    %ebx
  803833:	5e                   	pop    %esi
  803834:	5f                   	pop    %edi
  803835:	5d                   	pop    %ebp
  803836:	c3                   	ret    
  803837:	90                   	nop
  803838:	89 fd                	mov    %edi,%ebp
  80383a:	85 ff                	test   %edi,%edi
  80383c:	75 0b                	jne    803849 <__umoddi3+0xe9>
  80383e:	b8 01 00 00 00       	mov    $0x1,%eax
  803843:	31 d2                	xor    %edx,%edx
  803845:	f7 f7                	div    %edi
  803847:	89 c5                	mov    %eax,%ebp
  803849:	89 f0                	mov    %esi,%eax
  80384b:	31 d2                	xor    %edx,%edx
  80384d:	f7 f5                	div    %ebp
  80384f:	89 c8                	mov    %ecx,%eax
  803851:	f7 f5                	div    %ebp
  803853:	89 d0                	mov    %edx,%eax
  803855:	e9 44 ff ff ff       	jmp    80379e <__umoddi3+0x3e>
  80385a:	66 90                	xchg   %ax,%ax
  80385c:	89 c8                	mov    %ecx,%eax
  80385e:	89 f2                	mov    %esi,%edx
  803860:	83 c4 1c             	add    $0x1c,%esp
  803863:	5b                   	pop    %ebx
  803864:	5e                   	pop    %esi
  803865:	5f                   	pop    %edi
  803866:	5d                   	pop    %ebp
  803867:	c3                   	ret    
  803868:	3b 04 24             	cmp    (%esp),%eax
  80386b:	72 06                	jb     803873 <__umoddi3+0x113>
  80386d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803871:	77 0f                	ja     803882 <__umoddi3+0x122>
  803873:	89 f2                	mov    %esi,%edx
  803875:	29 f9                	sub    %edi,%ecx
  803877:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80387b:	89 14 24             	mov    %edx,(%esp)
  80387e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803882:	8b 44 24 04          	mov    0x4(%esp),%eax
  803886:	8b 14 24             	mov    (%esp),%edx
  803889:	83 c4 1c             	add    $0x1c,%esp
  80388c:	5b                   	pop    %ebx
  80388d:	5e                   	pop    %esi
  80388e:	5f                   	pop    %edi
  80388f:	5d                   	pop    %ebp
  803890:	c3                   	ret    
  803891:	8d 76 00             	lea    0x0(%esi),%esi
  803894:	2b 04 24             	sub    (%esp),%eax
  803897:	19 fa                	sbb    %edi,%edx
  803899:	89 d1                	mov    %edx,%ecx
  80389b:	89 c6                	mov    %eax,%esi
  80389d:	e9 71 ff ff ff       	jmp    803813 <__umoddi3+0xb3>
  8038a2:	66 90                	xchg   %ax,%ax
  8038a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8038a8:	72 ea                	jb     803894 <__umoddi3+0x134>
  8038aa:	89 d9                	mov    %ebx,%ecx
  8038ac:	e9 62 ff ff ff       	jmp    803813 <__umoddi3+0xb3>
