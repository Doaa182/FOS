
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 65 07 00 00       	call   80079b <libmain>
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
  800041:	e8 f0 21 00 00       	call   802236 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 80 3a 80 00       	push   $0x803a80
  80004e:	e8 38 0b 00 00       	call   800b8b <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 82 3a 80 00       	push   $0x803a82
  80005e:	e8 28 0b 00 00       	call   800b8b <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 98 3a 80 00       	push   $0x803a98
  80006e:	e8 18 0b 00 00       	call   800b8b <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 82 3a 80 00       	push   $0x803a82
  80007e:	e8 08 0b 00 00       	call   800b8b <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 80 3a 80 00       	push   $0x803a80
  80008e:	e8 f8 0a 00 00       	call   800b8b <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 b0 3a 80 00       	push   $0x803ab0
  8000a5:	e8 63 11 00 00       	call   80120d <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 b3 16 00 00       	call   801773 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 35 1c 00 00       	call   801d0a <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 d0 3a 80 00       	push   $0x803ad0
  8000e3:	e8 a3 0a 00 00       	call   800b8b <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 f2 3a 80 00       	push   $0x803af2
  8000f3:	e8 93 0a 00 00       	call   800b8b <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 00 3b 80 00       	push   $0x803b00
  800103:	e8 83 0a 00 00       	call   800b8b <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 0f 3b 80 00       	push   $0x803b0f
  800113:	e8 73 0a 00 00       	call   800b8b <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 1f 3b 80 00       	push   $0x803b1f
  800123:	e8 63 0a 00 00       	call   800b8b <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 13 06 00 00       	call   800743 <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
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
  800162:	e8 e9 20 00 00       	call   802250 <sys_enable_interrupt>

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 5a 20 00 00       	call   802236 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 28 3b 80 00       	push   $0x803b28
  8001e4:	e8 a2 09 00 00       	call   800b8b <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 5f 20 00 00       	call   802250 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 5c 3b 80 00       	push   $0x803b5c
  800213:	6a 4a                	push   $0x4a
  800215:	68 7e 3b 80 00       	push   $0x803b7e
  80021a:	e8 b8 06 00 00       	call   8008d7 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 12 20 00 00       	call   802236 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 98 3b 80 00       	push   $0x803b98
  80022c:	e8 5a 09 00 00       	call   800b8b <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 cc 3b 80 00       	push   $0x803bcc
  80023c:	e8 4a 09 00 00       	call   800b8b <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 00 3c 80 00       	push   $0x803c00
  80024c:	e8 3a 09 00 00       	call   800b8b <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 f7 1f 00 00       	call   802250 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800259:	e8 d8 1f 00 00       	call   802236 <sys_disable_interrupt>
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 32 3c 80 00       	push   $0x803c32
  80026c:	e8 1a 09 00 00       	call   800b8b <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 ca 04 00 00       	call   800743 <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 99 1f 00 00       	call   802250 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 80 3a 80 00       	push   $0x803a80
  80044b:	e8 3b 07 00 00       	call   800b8b <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 50 3c 80 00       	push   $0x803c50
  80046d:	e8 19 07 00 00       	call   800b8b <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 55 3c 80 00       	push   $0x803c55
  80049b:	e8 eb 06 00 00       	call   800b8b <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 c9 17 00 00       	call   801d0a <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 b4 17 00 00       	call   801d0a <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 56 1b 00 00       	call   80226a <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800720:	e8 11 1b 00 00       	call   802236 <sys_disable_interrupt>
	char c = ch;
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80072b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	50                   	push   %eax
  800733:	e8 32 1b 00 00       	call   80226a <sys_cputc>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80073b:	e8 10 1b 00 00       	call   802250 <sys_enable_interrupt>
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <getchar>:

int
getchar(void)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800750:	eb 08                	jmp    80075a <getchar+0x17>
	{
		c = sys_cgetc();
  800752:	e8 5a 19 00 00       	call   8020b1 <sys_cgetc>
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80075a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80075e:	74 f2                	je     800752 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800760:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <atomic_getchar>:

int
atomic_getchar(void)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80076b:	e8 c6 1a 00 00       	call   802236 <sys_disable_interrupt>
	int c=0;
  800770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800777:	eb 08                	jmp    800781 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800779:	e8 33 19 00 00       	call   8020b1 <sys_cgetc>
  80077e:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800785:	74 f2                	je     800779 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800787:	e8 c4 1a 00 00       	call   802250 <sys_enable_interrupt>
	return c;
  80078c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <iscons>:

int iscons(int fdnum)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800794:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007a1:	e8 83 1c 00 00       	call   802429 <sys_getenvindex>
  8007a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ac:	89 d0                	mov    %edx,%eax
  8007ae:	c1 e0 03             	shl    $0x3,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	01 c0                	add    %eax,%eax
  8007b5:	01 d0                	add    %edx,%eax
  8007b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007be:	01 d0                	add    %edx,%eax
  8007c0:	c1 e0 04             	shl    $0x4,%eax
  8007c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007c8:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007cd:	a1 24 50 80 00       	mov    0x805024,%eax
  8007d2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8007d8:	84 c0                	test   %al,%al
  8007da:	74 0f                	je     8007eb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007dc:	a1 24 50 80 00       	mov    0x805024,%eax
  8007e1:	05 5c 05 00 00       	add    $0x55c,%eax
  8007e6:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007ef:	7e 0a                	jle    8007fb <libmain+0x60>
		binaryname = argv[0];
  8007f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 2f f8 ff ff       	call   800038 <_main>
  800809:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80080c:	e8 25 1a 00 00       	call   802236 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800811:	83 ec 0c             	sub    $0xc,%esp
  800814:	68 74 3c 80 00       	push   $0x803c74
  800819:	e8 6d 03 00 00       	call   800b8b <cprintf>
  80081e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800821:	a1 24 50 80 00       	mov    0x805024,%eax
  800826:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80082c:	a1 24 50 80 00       	mov    0x805024,%eax
  800831:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800837:	83 ec 04             	sub    $0x4,%esp
  80083a:	52                   	push   %edx
  80083b:	50                   	push   %eax
  80083c:	68 9c 3c 80 00       	push   $0x803c9c
  800841:	e8 45 03 00 00       	call   800b8b <cprintf>
  800846:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800849:	a1 24 50 80 00       	mov    0x805024,%eax
  80084e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800854:	a1 24 50 80 00       	mov    0x805024,%eax
  800859:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80085f:	a1 24 50 80 00       	mov    0x805024,%eax
  800864:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80086a:	51                   	push   %ecx
  80086b:	52                   	push   %edx
  80086c:	50                   	push   %eax
  80086d:	68 c4 3c 80 00       	push   $0x803cc4
  800872:	e8 14 03 00 00       	call   800b8b <cprintf>
  800877:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80087a:	a1 24 50 80 00       	mov    0x805024,%eax
  80087f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	50                   	push   %eax
  800889:	68 1c 3d 80 00       	push   $0x803d1c
  80088e:	e8 f8 02 00 00       	call   800b8b <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	68 74 3c 80 00       	push   $0x803c74
  80089e:	e8 e8 02 00 00       	call   800b8b <cprintf>
  8008a3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008a6:	e8 a5 19 00 00       	call   802250 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008ab:	e8 19 00 00 00       	call   8008c9 <exit>
}
  8008b0:	90                   	nop
  8008b1:	c9                   	leave  
  8008b2:	c3                   	ret    

008008b3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008b9:	83 ec 0c             	sub    $0xc,%esp
  8008bc:	6a 00                	push   $0x0
  8008be:	e8 32 1b 00 00       	call   8023f5 <sys_destroy_env>
  8008c3:	83 c4 10             	add    $0x10,%esp
}
  8008c6:	90                   	nop
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <exit>:

void
exit(void)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008cf:	e8 87 1b 00 00       	call   80245b <sys_exit_env>
}
  8008d4:	90                   	nop
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    

008008d7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008dd:	8d 45 10             	lea    0x10(%ebp),%eax
  8008e0:	83 c0 04             	add    $0x4,%eax
  8008e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008e6:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008eb:	85 c0                	test   %eax,%eax
  8008ed:	74 16                	je     800905 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008ef:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	50                   	push   %eax
  8008f8:	68 30 3d 80 00       	push   $0x803d30
  8008fd:	e8 89 02 00 00       	call   800b8b <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800905:	a1 00 50 80 00       	mov    0x805000,%eax
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	50                   	push   %eax
  800911:	68 35 3d 80 00       	push   $0x803d35
  800916:	e8 70 02 00 00       	call   800b8b <cprintf>
  80091b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80091e:	8b 45 10             	mov    0x10(%ebp),%eax
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 f4             	pushl  -0xc(%ebp)
  800927:	50                   	push   %eax
  800928:	e8 f3 01 00 00       	call   800b20 <vcprintf>
  80092d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	6a 00                	push   $0x0
  800935:	68 51 3d 80 00       	push   $0x803d51
  80093a:	e8 e1 01 00 00       	call   800b20 <vcprintf>
  80093f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800942:	e8 82 ff ff ff       	call   8008c9 <exit>

	// should not return here
	while (1) ;
  800947:	eb fe                	jmp    800947 <_panic+0x70>

00800949 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80094f:	a1 24 50 80 00       	mov    0x805024,%eax
  800954:	8b 50 74             	mov    0x74(%eax),%edx
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	39 c2                	cmp    %eax,%edx
  80095c:	74 14                	je     800972 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	68 54 3d 80 00       	push   $0x803d54
  800966:	6a 26                	push   $0x26
  800968:	68 a0 3d 80 00       	push   $0x803da0
  80096d:	e8 65 ff ff ff       	call   8008d7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800972:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800979:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800980:	e9 c2 00 00 00       	jmp    800a47 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800988:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	01 d0                	add    %edx,%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	85 c0                	test   %eax,%eax
  800998:	75 08                	jne    8009a2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80099a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80099d:	e9 a2 00 00 00       	jmp    800a44 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009b0:	eb 69                	jmp    800a1b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8009b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009c0:	89 d0                	mov    %edx,%eax
  8009c2:	01 c0                	add    %eax,%eax
  8009c4:	01 d0                	add    %edx,%eax
  8009c6:	c1 e0 03             	shl    $0x3,%eax
  8009c9:	01 c8                	add    %ecx,%eax
  8009cb:	8a 40 04             	mov    0x4(%eax),%al
  8009ce:	84 c0                	test   %al,%al
  8009d0:	75 46                	jne    800a18 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d2:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009e0:	89 d0                	mov    %edx,%eax
  8009e2:	01 c0                	add    %eax,%eax
  8009e4:	01 d0                	add    %edx,%eax
  8009e6:	c1 e0 03             	shl    $0x3,%eax
  8009e9:	01 c8                	add    %ecx,%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009f8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	01 c8                	add    %ecx,%eax
  800a09:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a0b:	39 c2                	cmp    %eax,%edx
  800a0d:	75 09                	jne    800a18 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a0f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a16:	eb 12                	jmp    800a2a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a18:	ff 45 e8             	incl   -0x18(%ebp)
  800a1b:	a1 24 50 80 00       	mov    0x805024,%eax
  800a20:	8b 50 74             	mov    0x74(%eax),%edx
  800a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a26:	39 c2                	cmp    %eax,%edx
  800a28:	77 88                	ja     8009b2 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a2e:	75 14                	jne    800a44 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a30:	83 ec 04             	sub    $0x4,%esp
  800a33:	68 ac 3d 80 00       	push   $0x803dac
  800a38:	6a 3a                	push   $0x3a
  800a3a:	68 a0 3d 80 00       	push   $0x803da0
  800a3f:	e8 93 fe ff ff       	call   8008d7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a44:	ff 45 f0             	incl   -0x10(%ebp)
  800a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a4d:	0f 8c 32 ff ff ff    	jl     800985 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a5a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a61:	eb 26                	jmp    800a89 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a63:	a1 24 50 80 00       	mov    0x805024,%eax
  800a68:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a71:	89 d0                	mov    %edx,%eax
  800a73:	01 c0                	add    %eax,%eax
  800a75:	01 d0                	add    %edx,%eax
  800a77:	c1 e0 03             	shl    $0x3,%eax
  800a7a:	01 c8                	add    %ecx,%eax
  800a7c:	8a 40 04             	mov    0x4(%eax),%al
  800a7f:	3c 01                	cmp    $0x1,%al
  800a81:	75 03                	jne    800a86 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a83:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a86:	ff 45 e0             	incl   -0x20(%ebp)
  800a89:	a1 24 50 80 00       	mov    0x805024,%eax
  800a8e:	8b 50 74             	mov    0x74(%eax),%edx
  800a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a94:	39 c2                	cmp    %eax,%edx
  800a96:	77 cb                	ja     800a63 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a9b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a9e:	74 14                	je     800ab4 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 00 3e 80 00       	push   $0x803e00
  800aa8:	6a 44                	push   $0x44
  800aaa:	68 a0 3d 80 00       	push   $0x803da0
  800aaf:	e8 23 fe ff ff       	call   8008d7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ab4:	90                   	nop
  800ab5:	c9                   	leave  
  800ab6:	c3                   	ret    

00800ab7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac0:	8b 00                	mov    (%eax),%eax
  800ac2:	8d 48 01             	lea    0x1(%eax),%ecx
  800ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac8:	89 0a                	mov    %ecx,(%edx)
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	88 d1                	mov    %dl,%cl
  800acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ae0:	75 2c                	jne    800b0e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ae2:	a0 28 50 80 00       	mov    0x805028,%al
  800ae7:	0f b6 c0             	movzbl %al,%eax
  800aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aed:	8b 12                	mov    (%edx),%edx
  800aef:	89 d1                	mov    %edx,%ecx
  800af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af4:	83 c2 08             	add    $0x8,%edx
  800af7:	83 ec 04             	sub    $0x4,%esp
  800afa:	50                   	push   %eax
  800afb:	51                   	push   %ecx
  800afc:	52                   	push   %edx
  800afd:	e8 86 15 00 00       	call   802088 <sys_cputs>
  800b02:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b11:	8b 40 04             	mov    0x4(%eax),%eax
  800b14:	8d 50 01             	lea    0x1(%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b1d:	90                   	nop
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    

00800b20 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b29:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b30:	00 00 00 
	b.cnt = 0;
  800b33:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b3a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	ff 75 08             	pushl  0x8(%ebp)
  800b43:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	68 b7 0a 80 00       	push   $0x800ab7
  800b4f:	e8 11 02 00 00       	call   800d65 <vprintfmt>
  800b54:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b57:	a0 28 50 80 00       	mov    0x805028,%al
  800b5c:	0f b6 c0             	movzbl %al,%eax
  800b5f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b65:	83 ec 04             	sub    $0x4,%esp
  800b68:	50                   	push   %eax
  800b69:	52                   	push   %edx
  800b6a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b70:	83 c0 08             	add    $0x8,%eax
  800b73:	50                   	push   %eax
  800b74:	e8 0f 15 00 00       	call   802088 <sys_cputs>
  800b79:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b7c:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800b83:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b89:	c9                   	leave  
  800b8a:	c3                   	ret    

00800b8b <cprintf>:

int cprintf(const char *fmt, ...) {
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b91:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800b98:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba7:	50                   	push   %eax
  800ba8:	e8 73 ff ff ff       	call   800b20 <vcprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bbe:	e8 73 16 00 00       	call   802236 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bc3:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	50                   	push   %eax
  800bd3:	e8 48 ff ff ff       	call   800b20 <vcprintf>
  800bd8:	83 c4 10             	add    $0x10,%esp
  800bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bde:	e8 6d 16 00 00       	call   802250 <sys_enable_interrupt>
	return cnt;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	53                   	push   %ebx
  800bec:	83 ec 14             	sub    $0x14,%esp
  800bef:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bfb:	8b 45 18             	mov    0x18(%ebp),%eax
  800bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800c03:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c06:	77 55                	ja     800c5d <printnum+0x75>
  800c08:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c0b:	72 05                	jb     800c12 <printnum+0x2a>
  800c0d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c10:	77 4b                	ja     800c5d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c12:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c15:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c18:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c20:	52                   	push   %edx
  800c21:	50                   	push   %eax
  800c22:	ff 75 f4             	pushl  -0xc(%ebp)
  800c25:	ff 75 f0             	pushl  -0x10(%ebp)
  800c28:	e8 d3 2b 00 00       	call   803800 <__udivdi3>
  800c2d:	83 c4 10             	add    $0x10,%esp
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	ff 75 20             	pushl  0x20(%ebp)
  800c36:	53                   	push   %ebx
  800c37:	ff 75 18             	pushl  0x18(%ebp)
  800c3a:	52                   	push   %edx
  800c3b:	50                   	push   %eax
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	ff 75 08             	pushl  0x8(%ebp)
  800c42:	e8 a1 ff ff ff       	call   800be8 <printnum>
  800c47:	83 c4 20             	add    $0x20,%esp
  800c4a:	eb 1a                	jmp    800c66 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 20             	pushl  0x20(%ebp)
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	ff d0                	call   *%eax
  800c5a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c5d:	ff 4d 1c             	decl   0x1c(%ebp)
  800c60:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c64:	7f e6                	jg     800c4c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c66:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c74:	53                   	push   %ebx
  800c75:	51                   	push   %ecx
  800c76:	52                   	push   %edx
  800c77:	50                   	push   %eax
  800c78:	e8 93 2c 00 00       	call   803910 <__umoddi3>
  800c7d:	83 c4 10             	add    $0x10,%esp
  800c80:	05 74 40 80 00       	add    $0x804074,%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	0f be c0             	movsbl %al,%eax
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	50                   	push   %eax
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	ff d0                	call   *%eax
  800c96:	83 c4 10             	add    $0x10,%esp
}
  800c99:	90                   	nop
  800c9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ca2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ca6:	7e 1c                	jle    800cc4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	8d 50 08             	lea    0x8(%eax),%edx
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 10                	mov    %edx,(%eax)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8b 00                	mov    (%eax),%eax
  800cba:	83 e8 08             	sub    $0x8,%eax
  800cbd:	8b 50 04             	mov    0x4(%eax),%edx
  800cc0:	8b 00                	mov    (%eax),%eax
  800cc2:	eb 40                	jmp    800d04 <getuint+0x65>
	else if (lflag)
  800cc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc8:	74 1e                	je     800ce8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8b 00                	mov    (%eax),%eax
  800ccf:	8d 50 04             	lea    0x4(%eax),%edx
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	89 10                	mov    %edx,(%eax)
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8b 00                	mov    (%eax),%eax
  800cdc:	83 e8 04             	sub    $0x4,%eax
  800cdf:	8b 00                	mov    (%eax),%eax
  800ce1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce6:	eb 1c                	jmp    800d04 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8b 00                	mov    (%eax),%eax
  800ced:	8d 50 04             	lea    0x4(%eax),%edx
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	89 10                	mov    %edx,(%eax)
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8b 00                	mov    (%eax),%eax
  800cfa:	83 e8 04             	sub    $0x4,%eax
  800cfd:	8b 00                	mov    (%eax),%eax
  800cff:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d09:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d0d:	7e 1c                	jle    800d2b <getint+0x25>
		return va_arg(*ap, long long);
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	8b 00                	mov    (%eax),%eax
  800d14:	8d 50 08             	lea    0x8(%eax),%edx
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	89 10                	mov    %edx,(%eax)
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8b 00                	mov    (%eax),%eax
  800d21:	83 e8 08             	sub    $0x8,%eax
  800d24:	8b 50 04             	mov    0x4(%eax),%edx
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	eb 38                	jmp    800d63 <getint+0x5d>
	else if (lflag)
  800d2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2f:	74 1a                	je     800d4b <getint+0x45>
		return va_arg(*ap, long);
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8b 00                	mov    (%eax),%eax
  800d36:	8d 50 04             	lea    0x4(%eax),%edx
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	89 10                	mov    %edx,(%eax)
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8b 00                	mov    (%eax),%eax
  800d43:	83 e8 04             	sub    $0x4,%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	99                   	cltd   
  800d49:	eb 18                	jmp    800d63 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8b 00                	mov    (%eax),%eax
  800d50:	8d 50 04             	lea    0x4(%eax),%edx
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 10                	mov    %edx,(%eax)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8b 00                	mov    (%eax),%eax
  800d5d:	83 e8 04             	sub    $0x4,%eax
  800d60:	8b 00                	mov    (%eax),%eax
  800d62:	99                   	cltd   
}
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
  800d6a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d6d:	eb 17                	jmp    800d86 <vprintfmt+0x21>
			if (ch == '\0')
  800d6f:	85 db                	test   %ebx,%ebx
  800d71:	0f 84 af 03 00 00    	je     801126 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	53                   	push   %ebx
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	0f b6 d8             	movzbl %al,%ebx
  800d94:	83 fb 25             	cmp    $0x25,%ebx
  800d97:	75 d6                	jne    800d6f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d99:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d9d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800da4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800db2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	8d 50 01             	lea    0x1(%eax),%edx
  800dbf:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	0f b6 d8             	movzbl %al,%ebx
  800dc7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dca:	83 f8 55             	cmp    $0x55,%eax
  800dcd:	0f 87 2b 03 00 00    	ja     8010fe <vprintfmt+0x399>
  800dd3:	8b 04 85 98 40 80 00 	mov    0x804098(,%eax,4),%eax
  800dda:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ddc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800de0:	eb d7                	jmp    800db9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800de2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800de6:	eb d1                	jmp    800db9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800de8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800def:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800df2:	89 d0                	mov    %edx,%eax
  800df4:	c1 e0 02             	shl    $0x2,%eax
  800df7:	01 d0                	add    %edx,%eax
  800df9:	01 c0                	add    %eax,%eax
  800dfb:	01 d8                	add    %ebx,%eax
  800dfd:	83 e8 30             	sub    $0x30,%eax
  800e00:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e0b:	83 fb 2f             	cmp    $0x2f,%ebx
  800e0e:	7e 3e                	jle    800e4e <vprintfmt+0xe9>
  800e10:	83 fb 39             	cmp    $0x39,%ebx
  800e13:	7f 39                	jg     800e4e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e15:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e18:	eb d5                	jmp    800def <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1d:	83 c0 04             	add    $0x4,%eax
  800e20:	89 45 14             	mov    %eax,0x14(%ebp)
  800e23:	8b 45 14             	mov    0x14(%ebp),%eax
  800e26:	83 e8 04             	sub    $0x4,%eax
  800e29:	8b 00                	mov    (%eax),%eax
  800e2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e2e:	eb 1f                	jmp    800e4f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e34:	79 83                	jns    800db9 <vprintfmt+0x54>
				width = 0;
  800e36:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e3d:	e9 77 ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e42:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e49:	e9 6b ff ff ff       	jmp    800db9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e4e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e53:	0f 89 60 ff ff ff    	jns    800db9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e5f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e66:	e9 4e ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e6b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e6e:	e9 46 ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e73:	8b 45 14             	mov    0x14(%ebp),%eax
  800e76:	83 c0 04             	add    $0x4,%eax
  800e79:	89 45 14             	mov    %eax,0x14(%ebp)
  800e7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7f:	83 e8 04             	sub    $0x4,%eax
  800e82:	8b 00                	mov    (%eax),%eax
  800e84:	83 ec 08             	sub    $0x8,%esp
  800e87:	ff 75 0c             	pushl  0xc(%ebp)
  800e8a:	50                   	push   %eax
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	ff d0                	call   *%eax
  800e90:	83 c4 10             	add    $0x10,%esp
			break;
  800e93:	e9 89 02 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 c0 04             	add    $0x4,%eax
  800e9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea4:	83 e8 04             	sub    $0x4,%eax
  800ea7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ea9:	85 db                	test   %ebx,%ebx
  800eab:	79 02                	jns    800eaf <vprintfmt+0x14a>
				err = -err;
  800ead:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800eaf:	83 fb 64             	cmp    $0x64,%ebx
  800eb2:	7f 0b                	jg     800ebf <vprintfmt+0x15a>
  800eb4:	8b 34 9d e0 3e 80 00 	mov    0x803ee0(,%ebx,4),%esi
  800ebb:	85 f6                	test   %esi,%esi
  800ebd:	75 19                	jne    800ed8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ebf:	53                   	push   %ebx
  800ec0:	68 85 40 80 00       	push   $0x804085
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	ff 75 08             	pushl  0x8(%ebp)
  800ecb:	e8 5e 02 00 00       	call   80112e <printfmt>
  800ed0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ed3:	e9 49 02 00 00       	jmp    801121 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ed8:	56                   	push   %esi
  800ed9:	68 8e 40 80 00       	push   $0x80408e
  800ede:	ff 75 0c             	pushl  0xc(%ebp)
  800ee1:	ff 75 08             	pushl  0x8(%ebp)
  800ee4:	e8 45 02 00 00       	call   80112e <printfmt>
  800ee9:	83 c4 10             	add    $0x10,%esp
			break;
  800eec:	e9 30 02 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ef1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef4:	83 c0 04             	add    $0x4,%eax
  800ef7:	89 45 14             	mov    %eax,0x14(%ebp)
  800efa:	8b 45 14             	mov    0x14(%ebp),%eax
  800efd:	83 e8 04             	sub    $0x4,%eax
  800f00:	8b 30                	mov    (%eax),%esi
  800f02:	85 f6                	test   %esi,%esi
  800f04:	75 05                	jne    800f0b <vprintfmt+0x1a6>
				p = "(null)";
  800f06:	be 91 40 80 00       	mov    $0x804091,%esi
			if (width > 0 && padc != '-')
  800f0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0f:	7e 6d                	jle    800f7e <vprintfmt+0x219>
  800f11:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f15:	74 67                	je     800f7e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f1a:	83 ec 08             	sub    $0x8,%esp
  800f1d:	50                   	push   %eax
  800f1e:	56                   	push   %esi
  800f1f:	e8 12 05 00 00       	call   801436 <strnlen>
  800f24:	83 c4 10             	add    $0x10,%esp
  800f27:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f2a:	eb 16                	jmp    800f42 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f2c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	ff 75 0c             	pushl  0xc(%ebp)
  800f36:	50                   	push   %eax
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	ff d0                	call   *%eax
  800f3c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f3f:	ff 4d e4             	decl   -0x1c(%ebp)
  800f42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f46:	7f e4                	jg     800f2c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f48:	eb 34                	jmp    800f7e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f4a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f4e:	74 1c                	je     800f6c <vprintfmt+0x207>
  800f50:	83 fb 1f             	cmp    $0x1f,%ebx
  800f53:	7e 05                	jle    800f5a <vprintfmt+0x1f5>
  800f55:	83 fb 7e             	cmp    $0x7e,%ebx
  800f58:	7e 12                	jle    800f6c <vprintfmt+0x207>
					putch('?', putdat);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	6a 3f                	push   $0x3f
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff d0                	call   *%eax
  800f67:	83 c4 10             	add    $0x10,%esp
  800f6a:	eb 0f                	jmp    800f7b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f6c:	83 ec 08             	sub    $0x8,%esp
  800f6f:	ff 75 0c             	pushl  0xc(%ebp)
  800f72:	53                   	push   %ebx
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	ff d0                	call   *%eax
  800f78:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f7e:	89 f0                	mov    %esi,%eax
  800f80:	8d 70 01             	lea    0x1(%eax),%esi
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	0f be d8             	movsbl %al,%ebx
  800f88:	85 db                	test   %ebx,%ebx
  800f8a:	74 24                	je     800fb0 <vprintfmt+0x24b>
  800f8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f90:	78 b8                	js     800f4a <vprintfmt+0x1e5>
  800f92:	ff 4d e0             	decl   -0x20(%ebp)
  800f95:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f99:	79 af                	jns    800f4a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f9b:	eb 13                	jmp    800fb0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	ff 75 0c             	pushl  0xc(%ebp)
  800fa3:	6a 20                	push   $0x20
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	ff d0                	call   *%eax
  800faa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fad:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb4:	7f e7                	jg     800f9d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fb6:	e9 66 01 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fbb:	83 ec 08             	sub    $0x8,%esp
  800fbe:	ff 75 e8             	pushl  -0x18(%ebp)
  800fc1:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 3c fd ff ff       	call   800d06 <getint>
  800fca:	83 c4 10             	add    $0x10,%esp
  800fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd9:	85 d2                	test   %edx,%edx
  800fdb:	79 23                	jns    801000 <vprintfmt+0x29b>
				putch('-', putdat);
  800fdd:	83 ec 08             	sub    $0x8,%esp
  800fe0:	ff 75 0c             	pushl  0xc(%ebp)
  800fe3:	6a 2d                	push   $0x2d
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	ff d0                	call   *%eax
  800fea:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff3:	f7 d8                	neg    %eax
  800ff5:	83 d2 00             	adc    $0x0,%edx
  800ff8:	f7 da                	neg    %edx
  800ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801000:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801007:	e9 bc 00 00 00       	jmp    8010c8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	ff 75 e8             	pushl  -0x18(%ebp)
  801012:	8d 45 14             	lea    0x14(%ebp),%eax
  801015:	50                   	push   %eax
  801016:	e8 84 fc ff ff       	call   800c9f <getuint>
  80101b:	83 c4 10             	add    $0x10,%esp
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801021:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801024:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80102b:	e9 98 00 00 00       	jmp    8010c8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801030:	83 ec 08             	sub    $0x8,%esp
  801033:	ff 75 0c             	pushl  0xc(%ebp)
  801036:	6a 58                	push   $0x58
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	ff d0                	call   *%eax
  80103d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801040:	83 ec 08             	sub    $0x8,%esp
  801043:	ff 75 0c             	pushl  0xc(%ebp)
  801046:	6a 58                	push   $0x58
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	ff d0                	call   *%eax
  80104d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801050:	83 ec 08             	sub    $0x8,%esp
  801053:	ff 75 0c             	pushl  0xc(%ebp)
  801056:	6a 58                	push   $0x58
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	ff d0                	call   *%eax
  80105d:	83 c4 10             	add    $0x10,%esp
			break;
  801060:	e9 bc 00 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	6a 30                	push   $0x30
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	ff d0                	call   *%eax
  801072:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	6a 78                	push   $0x78
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801085:	8b 45 14             	mov    0x14(%ebp),%eax
  801088:	83 c0 04             	add    $0x4,%eax
  80108b:	89 45 14             	mov    %eax,0x14(%ebp)
  80108e:	8b 45 14             	mov    0x14(%ebp),%eax
  801091:	83 e8 04             	sub    $0x4,%eax
  801094:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801096:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010a0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010a7:	eb 1f                	jmp    8010c8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8010af:	8d 45 14             	lea    0x14(%ebp),%eax
  8010b2:	50                   	push   %eax
  8010b3:	e8 e7 fb ff ff       	call   800c9f <getuint>
  8010b8:	83 c4 10             	add    $0x10,%esp
  8010bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010c1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010c8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010cf:	83 ec 04             	sub    $0x4,%esp
  8010d2:	52                   	push   %edx
  8010d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010d6:	50                   	push   %eax
  8010d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010da:	ff 75 f0             	pushl  -0x10(%ebp)
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	ff 75 08             	pushl  0x8(%ebp)
  8010e3:	e8 00 fb ff ff       	call   800be8 <printnum>
  8010e8:	83 c4 20             	add    $0x20,%esp
			break;
  8010eb:	eb 34                	jmp    801121 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	53                   	push   %ebx
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	ff d0                	call   *%eax
  8010f9:	83 c4 10             	add    $0x10,%esp
			break;
  8010fc:	eb 23                	jmp    801121 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010fe:	83 ec 08             	sub    $0x8,%esp
  801101:	ff 75 0c             	pushl  0xc(%ebp)
  801104:	6a 25                	push   $0x25
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	ff d0                	call   *%eax
  80110b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80110e:	ff 4d 10             	decl   0x10(%ebp)
  801111:	eb 03                	jmp    801116 <vprintfmt+0x3b1>
  801113:	ff 4d 10             	decl   0x10(%ebp)
  801116:	8b 45 10             	mov    0x10(%ebp),%eax
  801119:	48                   	dec    %eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 25                	cmp    $0x25,%al
  80111e:	75 f3                	jne    801113 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801120:	90                   	nop
		}
	}
  801121:	e9 47 fc ff ff       	jmp    800d6d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801126:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80112a:	5b                   	pop    %ebx
  80112b:	5e                   	pop    %esi
  80112c:	5d                   	pop    %ebp
  80112d:	c3                   	ret    

0080112e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801134:	8d 45 10             	lea    0x10(%ebp),%eax
  801137:	83 c0 04             	add    $0x4,%eax
  80113a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	ff 75 f4             	pushl  -0xc(%ebp)
  801143:	50                   	push   %eax
  801144:	ff 75 0c             	pushl  0xc(%ebp)
  801147:	ff 75 08             	pushl  0x8(%ebp)
  80114a:	e8 16 fc ff ff       	call   800d65 <vprintfmt>
  80114f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801152:	90                   	nop
  801153:	c9                   	leave  
  801154:	c3                   	ret    

00801155 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	8b 40 08             	mov    0x8(%eax),%eax
  80115e:	8d 50 01             	lea    0x1(%eax),%edx
  801161:	8b 45 0c             	mov    0xc(%ebp),%eax
  801164:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 10                	mov    (%eax),%edx
  80116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116f:	8b 40 04             	mov    0x4(%eax),%eax
  801172:	39 c2                	cmp    %eax,%edx
  801174:	73 12                	jae    801188 <sprintputch+0x33>
		*b->buf++ = ch;
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	8b 00                	mov    (%eax),%eax
  80117b:	8d 48 01             	lea    0x1(%eax),%ecx
  80117e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801181:	89 0a                	mov    %ecx,(%edx)
  801183:	8b 55 08             	mov    0x8(%ebp),%edx
  801186:	88 10                	mov    %dl,(%eax)
}
  801188:	90                   	nop
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    

0080118b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	01 d0                	add    %edx,%eax
  8011a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b0:	74 06                	je     8011b8 <vsnprintf+0x2d>
  8011b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b6:	7f 07                	jg     8011bf <vsnprintf+0x34>
		return -E_INVAL;
  8011b8:	b8 03 00 00 00       	mov    $0x3,%eax
  8011bd:	eb 20                	jmp    8011df <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011bf:	ff 75 14             	pushl  0x14(%ebp)
  8011c2:	ff 75 10             	pushl  0x10(%ebp)
  8011c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011c8:	50                   	push   %eax
  8011c9:	68 55 11 80 00       	push   $0x801155
  8011ce:	e8 92 fb ff ff       	call   800d65 <vprintfmt>
  8011d3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011d9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ea:	83 c0 04             	add    $0x4,%eax
  8011ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f6:	50                   	push   %eax
  8011f7:	ff 75 0c             	pushl  0xc(%ebp)
  8011fa:	ff 75 08             	pushl  0x8(%ebp)
  8011fd:	e8 89 ff ff ff       	call   80118b <vsnprintf>
  801202:	83 c4 10             	add    $0x10,%esp
  801205:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801208:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801217:	74 13                	je     80122c <readline+0x1f>
		cprintf("%s", prompt);
  801219:	83 ec 08             	sub    $0x8,%esp
  80121c:	ff 75 08             	pushl  0x8(%ebp)
  80121f:	68 f0 41 80 00       	push   $0x8041f0
  801224:	e8 62 f9 ff ff       	call   800b8b <cprintf>
  801229:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80122c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	6a 00                	push   $0x0
  801238:	e8 54 f5 ff ff       	call   800791 <iscons>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801243:	e8 fb f4 ff ff       	call   800743 <getchar>
  801248:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80124b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80124f:	79 22                	jns    801273 <readline+0x66>
			if (c != -E_EOF)
  801251:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801255:	0f 84 ad 00 00 00    	je     801308 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80125b:	83 ec 08             	sub    $0x8,%esp
  80125e:	ff 75 ec             	pushl  -0x14(%ebp)
  801261:	68 f3 41 80 00       	push   $0x8041f3
  801266:	e8 20 f9 ff ff       	call   800b8b <cprintf>
  80126b:	83 c4 10             	add    $0x10,%esp
			return;
  80126e:	e9 95 00 00 00       	jmp    801308 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801273:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801277:	7e 34                	jle    8012ad <readline+0xa0>
  801279:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801280:	7f 2b                	jg     8012ad <readline+0xa0>
			if (echoing)
  801282:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801286:	74 0e                	je     801296 <readline+0x89>
				cputchar(c);
  801288:	83 ec 0c             	sub    $0xc,%esp
  80128b:	ff 75 ec             	pushl  -0x14(%ebp)
  80128e:	e8 68 f4 ff ff       	call   8006fb <cputchar>
  801293:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801299:	8d 50 01             	lea    0x1(%eax),%edx
  80129c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80129f:	89 c2                	mov    %eax,%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 d0                	add    %edx,%eax
  8012a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012a9:	88 10                	mov    %dl,(%eax)
  8012ab:	eb 56                	jmp    801303 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012ad:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012b1:	75 1f                	jne    8012d2 <readline+0xc5>
  8012b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012b7:	7e 19                	jle    8012d2 <readline+0xc5>
			if (echoing)
  8012b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012bd:	74 0e                	je     8012cd <readline+0xc0>
				cputchar(c);
  8012bf:	83 ec 0c             	sub    $0xc,%esp
  8012c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c5:	e8 31 f4 ff ff       	call   8006fb <cputchar>
  8012ca:	83 c4 10             	add    $0x10,%esp

			i--;
  8012cd:	ff 4d f4             	decl   -0xc(%ebp)
  8012d0:	eb 31                	jmp    801303 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012d2:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012d6:	74 0a                	je     8012e2 <readline+0xd5>
  8012d8:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012dc:	0f 85 61 ff ff ff    	jne    801243 <readline+0x36>
			if (echoing)
  8012e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e6:	74 0e                	je     8012f6 <readline+0xe9>
				cputchar(c);
  8012e8:	83 ec 0c             	sub    $0xc,%esp
  8012eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ee:	e8 08 f4 ff ff       	call   8006fb <cputchar>
  8012f3:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	01 d0                	add    %edx,%eax
  8012fe:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801301:	eb 06                	jmp    801309 <readline+0xfc>
		}
	}
  801303:	e9 3b ff ff ff       	jmp    801243 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801308:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801311:	e8 20 0f 00 00       	call   802236 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801316:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131a:	74 13                	je     80132f <atomic_readline+0x24>
		cprintf("%s", prompt);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 08             	pushl  0x8(%ebp)
  801322:	68 f0 41 80 00       	push   $0x8041f0
  801327:	e8 5f f8 ff ff       	call   800b8b <cprintf>
  80132c:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80132f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801336:	83 ec 0c             	sub    $0xc,%esp
  801339:	6a 00                	push   $0x0
  80133b:	e8 51 f4 ff ff       	call   800791 <iscons>
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801346:	e8 f8 f3 ff ff       	call   800743 <getchar>
  80134b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80134e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801352:	79 23                	jns    801377 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801354:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801358:	74 13                	je     80136d <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  80135a:	83 ec 08             	sub    $0x8,%esp
  80135d:	ff 75 ec             	pushl  -0x14(%ebp)
  801360:	68 f3 41 80 00       	push   $0x8041f3
  801365:	e8 21 f8 ff ff       	call   800b8b <cprintf>
  80136a:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80136d:	e8 de 0e 00 00       	call   802250 <sys_enable_interrupt>
			return;
  801372:	e9 9a 00 00 00       	jmp    801411 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801377:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80137b:	7e 34                	jle    8013b1 <atomic_readline+0xa6>
  80137d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801384:	7f 2b                	jg     8013b1 <atomic_readline+0xa6>
			if (echoing)
  801386:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80138a:	74 0e                	je     80139a <atomic_readline+0x8f>
				cputchar(c);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	ff 75 ec             	pushl  -0x14(%ebp)
  801392:	e8 64 f3 ff ff       	call   8006fb <cputchar>
  801397:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80139a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80139d:	8d 50 01             	lea    0x1(%eax),%edx
  8013a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013a3:	89 c2                	mov    %eax,%edx
  8013a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a8:	01 d0                	add    %edx,%eax
  8013aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ad:	88 10                	mov    %dl,(%eax)
  8013af:	eb 5b                	jmp    80140c <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013b1:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013b5:	75 1f                	jne    8013d6 <atomic_readline+0xcb>
  8013b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013bb:	7e 19                	jle    8013d6 <atomic_readline+0xcb>
			if (echoing)
  8013bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013c1:	74 0e                	je     8013d1 <atomic_readline+0xc6>
				cputchar(c);
  8013c3:	83 ec 0c             	sub    $0xc,%esp
  8013c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013c9:	e8 2d f3 ff ff       	call   8006fb <cputchar>
  8013ce:	83 c4 10             	add    $0x10,%esp
			i--;
  8013d1:	ff 4d f4             	decl   -0xc(%ebp)
  8013d4:	eb 36                	jmp    80140c <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8013d6:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013da:	74 0a                	je     8013e6 <atomic_readline+0xdb>
  8013dc:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013e0:	0f 85 60 ff ff ff    	jne    801346 <atomic_readline+0x3b>
			if (echoing)
  8013e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013ea:	74 0e                	je     8013fa <atomic_readline+0xef>
				cputchar(c);
  8013ec:	83 ec 0c             	sub    $0xc,%esp
  8013ef:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f2:	e8 04 f3 ff ff       	call   8006fb <cputchar>
  8013f7:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801400:	01 d0                	add    %edx,%eax
  801402:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801405:	e8 46 0e 00 00       	call   802250 <sys_enable_interrupt>
			return;
  80140a:	eb 05                	jmp    801411 <atomic_readline+0x106>
		}
	}
  80140c:	e9 35 ff ff ff       	jmp    801346 <atomic_readline+0x3b>
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801419:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801420:	eb 06                	jmp    801428 <strlen+0x15>
		n++;
  801422:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801425:	ff 45 08             	incl   0x8(%ebp)
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	84 c0                	test   %al,%al
  80142f:	75 f1                	jne    801422 <strlen+0xf>
		n++;
	return n;
  801431:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80143c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801443:	eb 09                	jmp    80144e <strnlen+0x18>
		n++;
  801445:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801448:	ff 45 08             	incl   0x8(%ebp)
  80144b:	ff 4d 0c             	decl   0xc(%ebp)
  80144e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801452:	74 09                	je     80145d <strnlen+0x27>
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	84 c0                	test   %al,%al
  80145b:	75 e8                	jne    801445 <strnlen+0xf>
		n++;
	return n;
  80145d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80146e:	90                   	nop
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8d 50 01             	lea    0x1(%eax),%edx
  801475:	89 55 08             	mov    %edx,0x8(%ebp)
  801478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80147e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801481:	8a 12                	mov    (%edx),%dl
  801483:	88 10                	mov    %dl,(%eax)
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	75 e4                	jne    80146f <strcpy+0xd>
		/* do nothing */;
	return ret;
  80148b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80149c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a3:	eb 1f                	jmp    8014c4 <strncpy+0x34>
		*dst++ = *src;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8d 50 01             	lea    0x1(%eax),%edx
  8014ab:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b1:	8a 12                	mov    (%edx),%dl
  8014b3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 03                	je     8014c1 <strncpy+0x31>
			src++;
  8014be:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014c1:	ff 45 fc             	incl   -0x4(%ebp)
  8014c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014ca:	72 d9                	jb     8014a5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e1:	74 30                	je     801513 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014e3:	eb 16                	jmp    8014fb <strlcpy+0x2a>
			*dst++ = *src++;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8d 50 01             	lea    0x1(%eax),%edx
  8014eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014f4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014f7:	8a 12                	mov    (%edx),%dl
  8014f9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014fb:	ff 4d 10             	decl   0x10(%ebp)
  8014fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801502:	74 09                	je     80150d <strlcpy+0x3c>
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	84 c0                	test   %al,%al
  80150b:	75 d8                	jne    8014e5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801513:	8b 55 08             	mov    0x8(%ebp),%edx
  801516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801519:	29 c2                	sub    %eax,%edx
  80151b:	89 d0                	mov    %edx,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801522:	eb 06                	jmp    80152a <strcmp+0xb>
		p++, q++;
  801524:	ff 45 08             	incl   0x8(%ebp)
  801527:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	8a 00                	mov    (%eax),%al
  80152f:	84 c0                	test   %al,%al
  801531:	74 0e                	je     801541 <strcmp+0x22>
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	8a 10                	mov    (%eax),%dl
  801538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	38 c2                	cmp    %al,%dl
  80153f:	74 e3                	je     801524 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	0f b6 d0             	movzbl %al,%edx
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8a 00                	mov    (%eax),%al
  80154e:	0f b6 c0             	movzbl %al,%eax
  801551:	29 c2                	sub    %eax,%edx
  801553:	89 d0                	mov    %edx,%eax
}
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    

00801557 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80155a:	eb 09                	jmp    801565 <strncmp+0xe>
		n--, p++, q++;
  80155c:	ff 4d 10             	decl   0x10(%ebp)
  80155f:	ff 45 08             	incl   0x8(%ebp)
  801562:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801565:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801569:	74 17                	je     801582 <strncmp+0x2b>
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 0e                	je     801582 <strncmp+0x2b>
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	8a 10                	mov    (%eax),%dl
  801579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	38 c2                	cmp    %al,%dl
  801580:	74 da                	je     80155c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801582:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801586:	75 07                	jne    80158f <strncmp+0x38>
		return 0;
  801588:	b8 00 00 00 00       	mov    $0x0,%eax
  80158d:	eb 14                	jmp    8015a3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	0f b6 d0             	movzbl %al,%edx
  801597:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	0f b6 c0             	movzbl %al,%eax
  80159f:	29 c2                	sub    %eax,%edx
  8015a1:	89 d0                	mov    %edx,%eax
}
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b1:	eb 12                	jmp    8015c5 <strchr+0x20>
		if (*s == c)
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	8a 00                	mov    (%eax),%al
  8015b8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015bb:	75 05                	jne    8015c2 <strchr+0x1d>
			return (char *) s;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	eb 11                	jmp    8015d3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015c2:	ff 45 08             	incl   0x8(%ebp)
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	84 c0                	test   %al,%al
  8015cc:	75 e5                	jne    8015b3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015de:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015e1:	eb 0d                	jmp    8015f0 <strfind+0x1b>
		if (*s == c)
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	8a 00                	mov    (%eax),%al
  8015e8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015eb:	74 0e                	je     8015fb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015ed:	ff 45 08             	incl   0x8(%ebp)
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	8a 00                	mov    (%eax),%al
  8015f5:	84 c0                	test   %al,%al
  8015f7:	75 ea                	jne    8015e3 <strfind+0xe>
  8015f9:	eb 01                	jmp    8015fc <strfind+0x27>
		if (*s == c)
			break;
  8015fb:	90                   	nop
	return (char *) s;
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80160d:	8b 45 10             	mov    0x10(%ebp),%eax
  801610:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801613:	eb 0e                	jmp    801623 <memset+0x22>
		*p++ = c;
  801615:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801618:	8d 50 01             	lea    0x1(%eax),%edx
  80161b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801621:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801623:	ff 4d f8             	decl   -0x8(%ebp)
  801626:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80162a:	79 e9                	jns    801615 <memset+0x14>
		*p++ = c;

	return v;
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801643:	eb 16                	jmp    80165b <memcpy+0x2a>
		*d++ = *s++;
  801645:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801648:	8d 50 01             	lea    0x1(%eax),%edx
  80164b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80164e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801651:	8d 4a 01             	lea    0x1(%edx),%ecx
  801654:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801657:	8a 12                	mov    (%edx),%dl
  801659:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80165b:	8b 45 10             	mov    0x10(%ebp),%eax
  80165e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801661:	89 55 10             	mov    %edx,0x10(%ebp)
  801664:	85 c0                	test   %eax,%eax
  801666:	75 dd                	jne    801645 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801673:	8b 45 0c             	mov    0xc(%ebp),%eax
  801676:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80167f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801682:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801685:	73 50                	jae    8016d7 <memmove+0x6a>
  801687:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	01 d0                	add    %edx,%eax
  80168f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801692:	76 43                	jbe    8016d7 <memmove+0x6a>
		s += n;
  801694:	8b 45 10             	mov    0x10(%ebp),%eax
  801697:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80169a:	8b 45 10             	mov    0x10(%ebp),%eax
  80169d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016a0:	eb 10                	jmp    8016b2 <memmove+0x45>
			*--d = *--s;
  8016a2:	ff 4d f8             	decl   -0x8(%ebp)
  8016a5:	ff 4d fc             	decl   -0x4(%ebp)
  8016a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ab:	8a 10                	mov    (%eax),%dl
  8016ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	75 e3                	jne    8016a2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016bf:	eb 23                	jmp    8016e4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c4:	8d 50 01             	lea    0x1(%eax),%edx
  8016c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016d3:	8a 12                	mov    (%edx),%dl
  8016d5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	75 dd                	jne    8016c1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016fb:	eb 2a                	jmp    801727 <memcmp+0x3e>
		if (*s1 != *s2)
  8016fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801700:	8a 10                	mov    (%eax),%dl
  801702:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	38 c2                	cmp    %al,%dl
  801709:	74 16                	je     801721 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80170b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80170e:	8a 00                	mov    (%eax),%al
  801710:	0f b6 d0             	movzbl %al,%edx
  801713:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801716:	8a 00                	mov    (%eax),%al
  801718:	0f b6 c0             	movzbl %al,%eax
  80171b:	29 c2                	sub    %eax,%edx
  80171d:	89 d0                	mov    %edx,%eax
  80171f:	eb 18                	jmp    801739 <memcmp+0x50>
		s1++, s2++;
  801721:	ff 45 fc             	incl   -0x4(%ebp)
  801724:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801727:	8b 45 10             	mov    0x10(%ebp),%eax
  80172a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172d:	89 55 10             	mov    %edx,0x10(%ebp)
  801730:	85 c0                	test   %eax,%eax
  801732:	75 c9                	jne    8016fd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801741:	8b 55 08             	mov    0x8(%ebp),%edx
  801744:	8b 45 10             	mov    0x10(%ebp),%eax
  801747:	01 d0                	add    %edx,%eax
  801749:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80174c:	eb 15                	jmp    801763 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8a 00                	mov    (%eax),%al
  801753:	0f b6 d0             	movzbl %al,%edx
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
  801759:	0f b6 c0             	movzbl %al,%eax
  80175c:	39 c2                	cmp    %eax,%edx
  80175e:	74 0d                	je     80176d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801760:	ff 45 08             	incl   0x8(%ebp)
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801769:	72 e3                	jb     80174e <memfind+0x13>
  80176b:	eb 01                	jmp    80176e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80176d:	90                   	nop
	return (void *) s;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801779:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801780:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801787:	eb 03                	jmp    80178c <strtol+0x19>
		s++;
  801789:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	3c 20                	cmp    $0x20,%al
  801793:	74 f4                	je     801789 <strtol+0x16>
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	8a 00                	mov    (%eax),%al
  80179a:	3c 09                	cmp    $0x9,%al
  80179c:	74 eb                	je     801789 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	8a 00                	mov    (%eax),%al
  8017a3:	3c 2b                	cmp    $0x2b,%al
  8017a5:	75 05                	jne    8017ac <strtol+0x39>
		s++;
  8017a7:	ff 45 08             	incl   0x8(%ebp)
  8017aa:	eb 13                	jmp    8017bf <strtol+0x4c>
	else if (*s == '-')
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8a 00                	mov    (%eax),%al
  8017b1:	3c 2d                	cmp    $0x2d,%al
  8017b3:	75 0a                	jne    8017bf <strtol+0x4c>
		s++, neg = 1;
  8017b5:	ff 45 08             	incl   0x8(%ebp)
  8017b8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c3:	74 06                	je     8017cb <strtol+0x58>
  8017c5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017c9:	75 20                	jne    8017eb <strtol+0x78>
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	3c 30                	cmp    $0x30,%al
  8017d2:	75 17                	jne    8017eb <strtol+0x78>
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	40                   	inc    %eax
  8017d8:	8a 00                	mov    (%eax),%al
  8017da:	3c 78                	cmp    $0x78,%al
  8017dc:	75 0d                	jne    8017eb <strtol+0x78>
		s += 2, base = 16;
  8017de:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017e2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017e9:	eb 28                	jmp    801813 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ef:	75 15                	jne    801806 <strtol+0x93>
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	8a 00                	mov    (%eax),%al
  8017f6:	3c 30                	cmp    $0x30,%al
  8017f8:	75 0c                	jne    801806 <strtol+0x93>
		s++, base = 8;
  8017fa:	ff 45 08             	incl   0x8(%ebp)
  8017fd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801804:	eb 0d                	jmp    801813 <strtol+0xa0>
	else if (base == 0)
  801806:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80180a:	75 07                	jne    801813 <strtol+0xa0>
		base = 10;
  80180c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8a 00                	mov    (%eax),%al
  801818:	3c 2f                	cmp    $0x2f,%al
  80181a:	7e 19                	jle    801835 <strtol+0xc2>
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8a 00                	mov    (%eax),%al
  801821:	3c 39                	cmp    $0x39,%al
  801823:	7f 10                	jg     801835 <strtol+0xc2>
			dig = *s - '0';
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8a 00                	mov    (%eax),%al
  80182a:	0f be c0             	movsbl %al,%eax
  80182d:	83 e8 30             	sub    $0x30,%eax
  801830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801833:	eb 42                	jmp    801877 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	8a 00                	mov    (%eax),%al
  80183a:	3c 60                	cmp    $0x60,%al
  80183c:	7e 19                	jle    801857 <strtol+0xe4>
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8a 00                	mov    (%eax),%al
  801843:	3c 7a                	cmp    $0x7a,%al
  801845:	7f 10                	jg     801857 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8a 00                	mov    (%eax),%al
  80184c:	0f be c0             	movsbl %al,%eax
  80184f:	83 e8 57             	sub    $0x57,%eax
  801852:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801855:	eb 20                	jmp    801877 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 40                	cmp    $0x40,%al
  80185e:	7e 39                	jle    801899 <strtol+0x126>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	3c 5a                	cmp    $0x5a,%al
  801867:	7f 30                	jg     801899 <strtol+0x126>
			dig = *s - 'A' + 10;
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	0f be c0             	movsbl %al,%eax
  801871:	83 e8 37             	sub    $0x37,%eax
  801874:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80187d:	7d 19                	jge    801898 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80187f:	ff 45 08             	incl   0x8(%ebp)
  801882:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801885:	0f af 45 10          	imul   0x10(%ebp),%eax
  801889:	89 c2                	mov    %eax,%edx
  80188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801893:	e9 7b ff ff ff       	jmp    801813 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801898:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801899:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80189d:	74 08                	je     8018a7 <strtol+0x134>
		*endptr = (char *) s;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ab:	74 07                	je     8018b4 <strtol+0x141>
  8018ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b0:	f7 d8                	neg    %eax
  8018b2:	eb 03                	jmp    8018b7 <strtol+0x144>
  8018b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <ltostr>:

void
ltostr(long value, char *str)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d1:	79 13                	jns    8018e6 <ltostr+0x2d>
	{
		neg = 1;
  8018d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018e0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018e3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018ee:	99                   	cltd   
  8018ef:	f7 f9                	idiv   %ecx
  8018f1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f7:	8d 50 01             	lea    0x1(%eax),%edx
  8018fa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018fd:	89 c2                	mov    %eax,%edx
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	01 d0                	add    %edx,%eax
  801904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801907:	83 c2 30             	add    $0x30,%edx
  80190a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80190c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80190f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801914:	f7 e9                	imul   %ecx
  801916:	c1 fa 02             	sar    $0x2,%edx
  801919:	89 c8                	mov    %ecx,%eax
  80191b:	c1 f8 1f             	sar    $0x1f,%eax
  80191e:	29 c2                	sub    %eax,%edx
  801920:	89 d0                	mov    %edx,%eax
  801922:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801925:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801928:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80192d:	f7 e9                	imul   %ecx
  80192f:	c1 fa 02             	sar    $0x2,%edx
  801932:	89 c8                	mov    %ecx,%eax
  801934:	c1 f8 1f             	sar    $0x1f,%eax
  801937:	29 c2                	sub    %eax,%edx
  801939:	89 d0                	mov    %edx,%eax
  80193b:	c1 e0 02             	shl    $0x2,%eax
  80193e:	01 d0                	add    %edx,%eax
  801940:	01 c0                	add    %eax,%eax
  801942:	29 c1                	sub    %eax,%ecx
  801944:	89 ca                	mov    %ecx,%edx
  801946:	85 d2                	test   %edx,%edx
  801948:	75 9c                	jne    8018e6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80194a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801951:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801954:	48                   	dec    %eax
  801955:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801958:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80195c:	74 3d                	je     80199b <ltostr+0xe2>
		start = 1 ;
  80195e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801965:	eb 34                	jmp    80199b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196d:	01 d0                	add    %edx,%eax
  80196f:	8a 00                	mov    (%eax),%al
  801971:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197a:	01 c2                	add    %eax,%edx
  80197c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80197f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801982:	01 c8                	add    %ecx,%eax
  801984:	8a 00                	mov    (%eax),%al
  801986:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801988:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80198b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198e:	01 c2                	add    %eax,%edx
  801990:	8a 45 eb             	mov    -0x15(%ebp),%al
  801993:	88 02                	mov    %al,(%edx)
		start++ ;
  801995:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801998:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80199b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a1:	7c c4                	jl     801967 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a9:	01 d0                	add    %edx,%eax
  8019ab:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019ae:	90                   	nop
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019b7:	ff 75 08             	pushl  0x8(%ebp)
  8019ba:	e8 54 fa ff ff       	call   801413 <strlen>
  8019bf:	83 c4 04             	add    $0x4,%esp
  8019c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	e8 46 fa ff ff       	call   801413 <strlen>
  8019cd:	83 c4 04             	add    $0x4,%esp
  8019d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019e1:	eb 17                	jmp    8019fa <strcconcat+0x49>
		final[s] = str1[s] ;
  8019e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e9:	01 c2                	add    %eax,%edx
  8019eb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	01 c8                	add    %ecx,%eax
  8019f3:	8a 00                	mov    (%eax),%al
  8019f5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019f7:	ff 45 fc             	incl   -0x4(%ebp)
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a00:	7c e1                	jl     8019e3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a02:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a10:	eb 1f                	jmp    801a31 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a15:	8d 50 01             	lea    0x1(%eax),%edx
  801a18:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a1b:	89 c2                	mov    %eax,%edx
  801a1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a20:	01 c2                	add    %eax,%edx
  801a22:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a28:	01 c8                	add    %ecx,%eax
  801a2a:	8a 00                	mov    (%eax),%al
  801a2c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a2e:	ff 45 f8             	incl   -0x8(%ebp)
  801a31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a34:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a37:	7c d9                	jl     801a12 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3f:	01 d0                	add    %edx,%eax
  801a41:	c6 00 00             	movb   $0x0,(%eax)
}
  801a44:	90                   	nop
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a53:	8b 45 14             	mov    0x14(%ebp),%eax
  801a56:	8b 00                	mov    (%eax),%eax
  801a58:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a62:	01 d0                	add    %edx,%eax
  801a64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a6a:	eb 0c                	jmp    801a78 <strsplit+0x31>
			*string++ = 0;
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	8d 50 01             	lea    0x1(%eax),%edx
  801a72:	89 55 08             	mov    %edx,0x8(%ebp)
  801a75:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	8a 00                	mov    (%eax),%al
  801a7d:	84 c0                	test   %al,%al
  801a7f:	74 18                	je     801a99 <strsplit+0x52>
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	0f be c0             	movsbl %al,%eax
  801a89:	50                   	push   %eax
  801a8a:	ff 75 0c             	pushl  0xc(%ebp)
  801a8d:	e8 13 fb ff ff       	call   8015a5 <strchr>
  801a92:	83 c4 08             	add    $0x8,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	75 d3                	jne    801a6c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	8a 00                	mov    (%eax),%al
  801a9e:	84 c0                	test   %al,%al
  801aa0:	74 5a                	je     801afc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa5:	8b 00                	mov    (%eax),%eax
  801aa7:	83 f8 0f             	cmp    $0xf,%eax
  801aaa:	75 07                	jne    801ab3 <strsplit+0x6c>
		{
			return 0;
  801aac:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab1:	eb 66                	jmp    801b19 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab6:	8b 00                	mov    (%eax),%eax
  801ab8:	8d 48 01             	lea    0x1(%eax),%ecx
  801abb:	8b 55 14             	mov    0x14(%ebp),%edx
  801abe:	89 0a                	mov    %ecx,(%edx)
  801ac0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aca:	01 c2                	add    %eax,%edx
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad1:	eb 03                	jmp    801ad6 <strsplit+0x8f>
			string++;
  801ad3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	8a 00                	mov    (%eax),%al
  801adb:	84 c0                	test   %al,%al
  801add:	74 8b                	je     801a6a <strsplit+0x23>
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	8a 00                	mov    (%eax),%al
  801ae4:	0f be c0             	movsbl %al,%eax
  801ae7:	50                   	push   %eax
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	e8 b5 fa ff ff       	call   8015a5 <strchr>
  801af0:	83 c4 08             	add    $0x8,%esp
  801af3:	85 c0                	test   %eax,%eax
  801af5:	74 dc                	je     801ad3 <strsplit+0x8c>
			string++;
	}
  801af7:	e9 6e ff ff ff       	jmp    801a6a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801afc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801afd:	8b 45 14             	mov    0x14(%ebp),%eax
  801b00:	8b 00                	mov    (%eax),%eax
  801b02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b09:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0c:	01 d0                	add    %edx,%eax
  801b0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b14:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801b21:	a1 04 50 80 00       	mov    0x805004,%eax
  801b26:	85 c0                	test   %eax,%eax
  801b28:	74 1f                	je     801b49 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b2a:	e8 1d 00 00 00       	call   801b4c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b2f:	83 ec 0c             	sub    $0xc,%esp
  801b32:	68 04 42 80 00       	push   $0x804204
  801b37:	e8 4f f0 ff ff       	call   800b8b <cprintf>
  801b3c:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b3f:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b46:	00 00 00 
	}
}
  801b49:	90                   	nop
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801b52:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b59:	00 00 00 
  801b5c:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b63:	00 00 00 
  801b66:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b6d:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801b70:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b77:	00 00 00 
  801b7a:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b81:	00 00 00 
  801b84:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b8b:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801b8e:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b98:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b9d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ba2:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801ba7:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801bae:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801bb1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bbb:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801bc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  801bcb:	f7 75 f0             	divl   -0x10(%ebp)
  801bce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd1:	29 d0                	sub    %edx,%eax
  801bd3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801bd6:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801bdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801be0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801be5:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bea:	83 ec 04             	sub    $0x4,%esp
  801bed:	6a 06                	push   $0x6
  801bef:	ff 75 e8             	pushl  -0x18(%ebp)
  801bf2:	50                   	push   %eax
  801bf3:	e8 d4 05 00 00       	call   8021cc <sys_allocate_chunk>
  801bf8:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bfb:	a1 20 51 80 00       	mov    0x805120,%eax
  801c00:	83 ec 0c             	sub    $0xc,%esp
  801c03:	50                   	push   %eax
  801c04:	e8 49 0c 00 00       	call   802852 <initialize_MemBlocksList>
  801c09:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801c0c:	a1 48 51 80 00       	mov    0x805148,%eax
  801c11:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801c14:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c18:	75 14                	jne    801c2e <initialize_dyn_block_system+0xe2>
  801c1a:	83 ec 04             	sub    $0x4,%esp
  801c1d:	68 29 42 80 00       	push   $0x804229
  801c22:	6a 39                	push   $0x39
  801c24:	68 47 42 80 00       	push   $0x804247
  801c29:	e8 a9 ec ff ff       	call   8008d7 <_panic>
  801c2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c31:	8b 00                	mov    (%eax),%eax
  801c33:	85 c0                	test   %eax,%eax
  801c35:	74 10                	je     801c47 <initialize_dyn_block_system+0xfb>
  801c37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c3a:	8b 00                	mov    (%eax),%eax
  801c3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c3f:	8b 52 04             	mov    0x4(%edx),%edx
  801c42:	89 50 04             	mov    %edx,0x4(%eax)
  801c45:	eb 0b                	jmp    801c52 <initialize_dyn_block_system+0x106>
  801c47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c4a:	8b 40 04             	mov    0x4(%eax),%eax
  801c4d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c55:	8b 40 04             	mov    0x4(%eax),%eax
  801c58:	85 c0                	test   %eax,%eax
  801c5a:	74 0f                	je     801c6b <initialize_dyn_block_system+0x11f>
  801c5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c5f:	8b 40 04             	mov    0x4(%eax),%eax
  801c62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c65:	8b 12                	mov    (%edx),%edx
  801c67:	89 10                	mov    %edx,(%eax)
  801c69:	eb 0a                	jmp    801c75 <initialize_dyn_block_system+0x129>
  801c6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c6e:	8b 00                	mov    (%eax),%eax
  801c70:	a3 48 51 80 00       	mov    %eax,0x805148
  801c75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c88:	a1 54 51 80 00       	mov    0x805154,%eax
  801c8d:	48                   	dec    %eax
  801c8e:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801c93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c96:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801c9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca0:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801ca7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cab:	75 14                	jne    801cc1 <initialize_dyn_block_system+0x175>
  801cad:	83 ec 04             	sub    $0x4,%esp
  801cb0:	68 54 42 80 00       	push   $0x804254
  801cb5:	6a 3f                	push   $0x3f
  801cb7:	68 47 42 80 00       	push   $0x804247
  801cbc:	e8 16 ec ff ff       	call   8008d7 <_panic>
  801cc1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cca:	89 10                	mov    %edx,(%eax)
  801ccc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ccf:	8b 00                	mov    (%eax),%eax
  801cd1:	85 c0                	test   %eax,%eax
  801cd3:	74 0d                	je     801ce2 <initialize_dyn_block_system+0x196>
  801cd5:	a1 38 51 80 00       	mov    0x805138,%eax
  801cda:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801cdd:	89 50 04             	mov    %edx,0x4(%eax)
  801ce0:	eb 08                	jmp    801cea <initialize_dyn_block_system+0x19e>
  801ce2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ce5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801cea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ced:	a3 38 51 80 00       	mov    %eax,0x805138
  801cf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cf5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cfc:	a1 44 51 80 00       	mov    0x805144,%eax
  801d01:	40                   	inc    %eax
  801d02:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801d07:	90                   	nop
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d10:	e8 06 fe ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801d15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d19:	75 07                	jne    801d22 <malloc+0x18>
  801d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d20:	eb 7d                	jmp    801d9f <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801d22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801d29:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d30:	8b 55 08             	mov    0x8(%ebp),%edx
  801d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d36:	01 d0                	add    %edx,%eax
  801d38:	48                   	dec    %eax
  801d39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d44:	f7 75 f0             	divl   -0x10(%ebp)
  801d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d4a:	29 d0                	sub    %edx,%eax
  801d4c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801d4f:	e8 46 08 00 00       	call   80259a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d54:	83 f8 01             	cmp    $0x1,%eax
  801d57:	75 07                	jne    801d60 <malloc+0x56>
  801d59:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801d60:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801d64:	75 34                	jne    801d9a <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801d66:	83 ec 0c             	sub    $0xc,%esp
  801d69:	ff 75 e8             	pushl  -0x18(%ebp)
  801d6c:	e8 73 0e 00 00       	call   802be4 <alloc_block_FF>
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801d77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d7b:	74 16                	je     801d93 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801d7d:	83 ec 0c             	sub    $0xc,%esp
  801d80:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d83:	e8 ff 0b 00 00       	call   802987 <insert_sorted_allocList>
  801d88:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801d8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d8e:	8b 40 08             	mov    0x8(%eax),%eax
  801d91:	eb 0c                	jmp    801d9f <malloc+0x95>
	             }
	             else
	             	return NULL;
  801d93:	b8 00 00 00 00       	mov    $0x0,%eax
  801d98:	eb 05                	jmp    801d9f <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801d9a:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801da7:	8b 45 08             	mov    0x8(%ebp),%eax
  801daa:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dbb:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801dbe:	83 ec 08             	sub    $0x8,%esp
  801dc1:	ff 75 f4             	pushl  -0xc(%ebp)
  801dc4:	68 40 50 80 00       	push   $0x805040
  801dc9:	e8 61 0b 00 00       	call   80292f <find_block>
  801dce:	83 c4 10             	add    $0x10,%esp
  801dd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801dd4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801dd8:	0f 84 a5 00 00 00    	je     801e83 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de1:	8b 40 0c             	mov    0xc(%eax),%eax
  801de4:	83 ec 08             	sub    $0x8,%esp
  801de7:	50                   	push   %eax
  801de8:	ff 75 f4             	pushl  -0xc(%ebp)
  801deb:	e8 a4 03 00 00       	call   802194 <sys_free_user_mem>
  801df0:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801df3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801df7:	75 17                	jne    801e10 <free+0x6f>
  801df9:	83 ec 04             	sub    $0x4,%esp
  801dfc:	68 29 42 80 00       	push   $0x804229
  801e01:	68 87 00 00 00       	push   $0x87
  801e06:	68 47 42 80 00       	push   $0x804247
  801e0b:	e8 c7 ea ff ff       	call   8008d7 <_panic>
  801e10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e13:	8b 00                	mov    (%eax),%eax
  801e15:	85 c0                	test   %eax,%eax
  801e17:	74 10                	je     801e29 <free+0x88>
  801e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e1c:	8b 00                	mov    (%eax),%eax
  801e1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e21:	8b 52 04             	mov    0x4(%edx),%edx
  801e24:	89 50 04             	mov    %edx,0x4(%eax)
  801e27:	eb 0b                	jmp    801e34 <free+0x93>
  801e29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e2c:	8b 40 04             	mov    0x4(%eax),%eax
  801e2f:	a3 44 50 80 00       	mov    %eax,0x805044
  801e34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e37:	8b 40 04             	mov    0x4(%eax),%eax
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	74 0f                	je     801e4d <free+0xac>
  801e3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e41:	8b 40 04             	mov    0x4(%eax),%eax
  801e44:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e47:	8b 12                	mov    (%edx),%edx
  801e49:	89 10                	mov    %edx,(%eax)
  801e4b:	eb 0a                	jmp    801e57 <free+0xb6>
  801e4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e50:	8b 00                	mov    (%eax),%eax
  801e52:	a3 40 50 80 00       	mov    %eax,0x805040
  801e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e6a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e6f:	48                   	dec    %eax
  801e70:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801e75:	83 ec 0c             	sub    $0xc,%esp
  801e78:	ff 75 ec             	pushl  -0x14(%ebp)
  801e7b:	e8 37 12 00 00       	call   8030b7 <insert_sorted_with_merge_freeList>
  801e80:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801e83:	90                   	nop
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
  801e89:	83 ec 38             	sub    $0x38,%esp
  801e8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e92:	e8 84 fc ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801e97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e9b:	75 07                	jne    801ea4 <smalloc+0x1e>
  801e9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea2:	eb 7e                	jmp    801f22 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801ea4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801eab:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801eb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb8:	01 d0                	add    %edx,%eax
  801eba:	48                   	dec    %eax
  801ebb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec1:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec6:	f7 75 f0             	divl   -0x10(%ebp)
  801ec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ecc:	29 d0                	sub    %edx,%eax
  801ece:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801ed1:	e8 c4 06 00 00       	call   80259a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ed6:	83 f8 01             	cmp    $0x1,%eax
  801ed9:	75 42                	jne    801f1d <smalloc+0x97>

		  va = malloc(newsize) ;
  801edb:	83 ec 0c             	sub    $0xc,%esp
  801ede:	ff 75 e8             	pushl  -0x18(%ebp)
  801ee1:	e8 24 fe ff ff       	call   801d0a <malloc>
  801ee6:	83 c4 10             	add    $0x10,%esp
  801ee9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801eec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ef0:	74 24                	je     801f16 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801ef2:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ef6:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ef9:	50                   	push   %eax
  801efa:	ff 75 e8             	pushl  -0x18(%ebp)
  801efd:	ff 75 08             	pushl  0x8(%ebp)
  801f00:	e8 1a 04 00 00       	call   80231f <sys_createSharedObject>
  801f05:	83 c4 10             	add    $0x10,%esp
  801f08:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801f0b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f0f:	78 0c                	js     801f1d <smalloc+0x97>
					  return va ;
  801f11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f14:	eb 0c                	jmp    801f22 <smalloc+0x9c>
				 }
				 else
					return NULL;
  801f16:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1b:	eb 05                	jmp    801f22 <smalloc+0x9c>
	  }
		  return NULL ;
  801f1d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f2a:	e8 ec fb ff ff       	call   801b1b <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801f2f:	83 ec 08             	sub    $0x8,%esp
  801f32:	ff 75 0c             	pushl  0xc(%ebp)
  801f35:	ff 75 08             	pushl  0x8(%ebp)
  801f38:	e8 0c 04 00 00       	call   802349 <sys_getSizeOfSharedObject>
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801f43:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801f47:	75 07                	jne    801f50 <sget+0x2c>
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4e:	eb 75                	jmp    801fc5 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801f50:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5d:	01 d0                	add    %edx,%eax
  801f5f:	48                   	dec    %eax
  801f60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f66:	ba 00 00 00 00       	mov    $0x0,%edx
  801f6b:	f7 75 f0             	divl   -0x10(%ebp)
  801f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f71:	29 d0                	sub    %edx,%eax
  801f73:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801f76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801f7d:	e8 18 06 00 00       	call   80259a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f82:	83 f8 01             	cmp    $0x1,%eax
  801f85:	75 39                	jne    801fc0 <sget+0x9c>

		  va = malloc(newsize) ;
  801f87:	83 ec 0c             	sub    $0xc,%esp
  801f8a:	ff 75 e8             	pushl  -0x18(%ebp)
  801f8d:	e8 78 fd ff ff       	call   801d0a <malloc>
  801f92:	83 c4 10             	add    $0x10,%esp
  801f95:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801f98:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f9c:	74 22                	je     801fc0 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801f9e:	83 ec 04             	sub    $0x4,%esp
  801fa1:	ff 75 e0             	pushl  -0x20(%ebp)
  801fa4:	ff 75 0c             	pushl  0xc(%ebp)
  801fa7:	ff 75 08             	pushl  0x8(%ebp)
  801faa:	e8 b7 03 00 00       	call   802366 <sys_getSharedObject>
  801faf:	83 c4 10             	add    $0x10,%esp
  801fb2:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801fb5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801fb9:	78 05                	js     801fc0 <sget+0x9c>
					  return va;
  801fbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fbe:	eb 05                	jmp    801fc5 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801fc0:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fcd:	e8 49 fb ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fd2:	83 ec 04             	sub    $0x4,%esp
  801fd5:	68 78 42 80 00       	push   $0x804278
  801fda:	68 1e 01 00 00       	push   $0x11e
  801fdf:	68 47 42 80 00       	push   $0x804247
  801fe4:	e8 ee e8 ff ff       	call   8008d7 <_panic>

00801fe9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fef:	83 ec 04             	sub    $0x4,%esp
  801ff2:	68 a0 42 80 00       	push   $0x8042a0
  801ff7:	68 32 01 00 00       	push   $0x132
  801ffc:	68 47 42 80 00       	push   $0x804247
  802001:	e8 d1 e8 ff ff       	call   8008d7 <_panic>

00802006 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
  802009:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80200c:	83 ec 04             	sub    $0x4,%esp
  80200f:	68 c4 42 80 00       	push   $0x8042c4
  802014:	68 3d 01 00 00       	push   $0x13d
  802019:	68 47 42 80 00       	push   $0x804247
  80201e:	e8 b4 e8 ff ff       	call   8008d7 <_panic>

00802023 <shrink>:

}
void shrink(uint32 newSize)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802029:	83 ec 04             	sub    $0x4,%esp
  80202c:	68 c4 42 80 00       	push   $0x8042c4
  802031:	68 42 01 00 00       	push   $0x142
  802036:	68 47 42 80 00       	push   $0x804247
  80203b:	e8 97 e8 ff ff       	call   8008d7 <_panic>

00802040 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802046:	83 ec 04             	sub    $0x4,%esp
  802049:	68 c4 42 80 00       	push   $0x8042c4
  80204e:	68 47 01 00 00       	push   $0x147
  802053:	68 47 42 80 00       	push   $0x804247
  802058:	e8 7a e8 ff ff       	call   8008d7 <_panic>

0080205d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	57                   	push   %edi
  802061:	56                   	push   %esi
  802062:	53                   	push   %ebx
  802063:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80206f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802072:	8b 7d 18             	mov    0x18(%ebp),%edi
  802075:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802078:	cd 30                	int    $0x30
  80207a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80207d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802080:	83 c4 10             	add    $0x10,%esp
  802083:	5b                   	pop    %ebx
  802084:	5e                   	pop    %esi
  802085:	5f                   	pop    %edi
  802086:	5d                   	pop    %ebp
  802087:	c3                   	ret    

00802088 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	83 ec 04             	sub    $0x4,%esp
  80208e:	8b 45 10             	mov    0x10(%ebp),%eax
  802091:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802094:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	52                   	push   %edx
  8020a0:	ff 75 0c             	pushl  0xc(%ebp)
  8020a3:	50                   	push   %eax
  8020a4:	6a 00                	push   $0x0
  8020a6:	e8 b2 ff ff ff       	call   80205d <syscall>
  8020ab:	83 c4 18             	add    $0x18,%esp
}
  8020ae:	90                   	nop
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 01                	push   $0x1
  8020c0:	e8 98 ff ff ff       	call   80205d <syscall>
  8020c5:	83 c4 18             	add    $0x18,%esp
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	52                   	push   %edx
  8020da:	50                   	push   %eax
  8020db:	6a 05                	push   $0x5
  8020dd:	e8 7b ff ff ff       	call   80205d <syscall>
  8020e2:	83 c4 18             	add    $0x18,%esp
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	56                   	push   %esi
  8020eb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020ec:	8b 75 18             	mov    0x18(%ebp),%esi
  8020ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	56                   	push   %esi
  8020fc:	53                   	push   %ebx
  8020fd:	51                   	push   %ecx
  8020fe:	52                   	push   %edx
  8020ff:	50                   	push   %eax
  802100:	6a 06                	push   $0x6
  802102:	e8 56 ff ff ff       	call   80205d <syscall>
  802107:	83 c4 18             	add    $0x18,%esp
}
  80210a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80210d:	5b                   	pop    %ebx
  80210e:	5e                   	pop    %esi
  80210f:	5d                   	pop    %ebp
  802110:	c3                   	ret    

00802111 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802114:	8b 55 0c             	mov    0xc(%ebp),%edx
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	52                   	push   %edx
  802121:	50                   	push   %eax
  802122:	6a 07                	push   $0x7
  802124:	e8 34 ff ff ff       	call   80205d <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	ff 75 0c             	pushl  0xc(%ebp)
  80213a:	ff 75 08             	pushl  0x8(%ebp)
  80213d:	6a 08                	push   $0x8
  80213f:	e8 19 ff ff ff       	call   80205d <syscall>
  802144:	83 c4 18             	add    $0x18,%esp
}
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	6a 09                	push   $0x9
  802158:	e8 00 ff ff ff       	call   80205d <syscall>
  80215d:	83 c4 18             	add    $0x18,%esp
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 0a                	push   $0xa
  802171:	e8 e7 fe ff ff       	call   80205d <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
}
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 0b                	push   $0xb
  80218a:	e8 ce fe ff ff       	call   80205d <syscall>
  80218f:	83 c4 18             	add    $0x18,%esp
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	ff 75 0c             	pushl  0xc(%ebp)
  8021a0:	ff 75 08             	pushl  0x8(%ebp)
  8021a3:	6a 0f                	push   $0xf
  8021a5:	e8 b3 fe ff ff       	call   80205d <syscall>
  8021aa:	83 c4 18             	add    $0x18,%esp
	return;
  8021ad:	90                   	nop
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	ff 75 0c             	pushl  0xc(%ebp)
  8021bc:	ff 75 08             	pushl  0x8(%ebp)
  8021bf:	6a 10                	push   $0x10
  8021c1:	e8 97 fe ff ff       	call   80205d <syscall>
  8021c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c9:	90                   	nop
}
  8021ca:	c9                   	leave  
  8021cb:	c3                   	ret    

008021cc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	ff 75 10             	pushl  0x10(%ebp)
  8021d6:	ff 75 0c             	pushl  0xc(%ebp)
  8021d9:	ff 75 08             	pushl  0x8(%ebp)
  8021dc:	6a 11                	push   $0x11
  8021de:	e8 7a fe ff ff       	call   80205d <syscall>
  8021e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e6:	90                   	nop
}
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    

008021e9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 0c                	push   $0xc
  8021f8:	e8 60 fe ff ff       	call   80205d <syscall>
  8021fd:	83 c4 18             	add    $0x18,%esp
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	ff 75 08             	pushl  0x8(%ebp)
  802210:	6a 0d                	push   $0xd
  802212:	e8 46 fe ff ff       	call   80205d <syscall>
  802217:	83 c4 18             	add    $0x18,%esp
}
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 0e                	push   $0xe
  80222b:	e8 2d fe ff ff       	call   80205d <syscall>
  802230:	83 c4 18             	add    $0x18,%esp
}
  802233:	90                   	nop
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 13                	push   $0x13
  802245:	e8 13 fe ff ff       	call   80205d <syscall>
  80224a:	83 c4 18             	add    $0x18,%esp
}
  80224d:	90                   	nop
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 14                	push   $0x14
  80225f:	e8 f9 fd ff ff       	call   80205d <syscall>
  802264:	83 c4 18             	add    $0x18,%esp
}
  802267:	90                   	nop
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <sys_cputc>:


void
sys_cputc(const char c)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	83 ec 04             	sub    $0x4,%esp
  802270:	8b 45 08             	mov    0x8(%ebp),%eax
  802273:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802276:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	50                   	push   %eax
  802283:	6a 15                	push   $0x15
  802285:	e8 d3 fd ff ff       	call   80205d <syscall>
  80228a:	83 c4 18             	add    $0x18,%esp
}
  80228d:	90                   	nop
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 16                	push   $0x16
  80229f:	e8 b9 fd ff ff       	call   80205d <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
}
  8022a7:	90                   	nop
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	ff 75 0c             	pushl  0xc(%ebp)
  8022b9:	50                   	push   %eax
  8022ba:	6a 17                	push   $0x17
  8022bc:	e8 9c fd ff ff       	call   80205d <syscall>
  8022c1:	83 c4 18             	add    $0x18,%esp
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	52                   	push   %edx
  8022d6:	50                   	push   %eax
  8022d7:	6a 1a                	push   $0x1a
  8022d9:	e8 7f fd ff ff       	call   80205d <syscall>
  8022de:	83 c4 18             	add    $0x18,%esp
}
  8022e1:	c9                   	leave  
  8022e2:	c3                   	ret    

008022e3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	52                   	push   %edx
  8022f3:	50                   	push   %eax
  8022f4:	6a 18                	push   $0x18
  8022f6:	e8 62 fd ff ff       	call   80205d <syscall>
  8022fb:	83 c4 18             	add    $0x18,%esp
}
  8022fe:	90                   	nop
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802304:	8b 55 0c             	mov    0xc(%ebp),%edx
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	52                   	push   %edx
  802311:	50                   	push   %eax
  802312:	6a 19                	push   $0x19
  802314:	e8 44 fd ff ff       	call   80205d <syscall>
  802319:	83 c4 18             	add    $0x18,%esp
}
  80231c:	90                   	nop
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    

0080231f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
  802322:	83 ec 04             	sub    $0x4,%esp
  802325:	8b 45 10             	mov    0x10(%ebp),%eax
  802328:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80232b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80232e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	6a 00                	push   $0x0
  802337:	51                   	push   %ecx
  802338:	52                   	push   %edx
  802339:	ff 75 0c             	pushl  0xc(%ebp)
  80233c:	50                   	push   %eax
  80233d:	6a 1b                	push   $0x1b
  80233f:	e8 19 fd ff ff       	call   80205d <syscall>
  802344:	83 c4 18             	add    $0x18,%esp
}
  802347:	c9                   	leave  
  802348:	c3                   	ret    

00802349 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80234c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	52                   	push   %edx
  802359:	50                   	push   %eax
  80235a:	6a 1c                	push   $0x1c
  80235c:	e8 fc fc ff ff       	call   80205d <syscall>
  802361:	83 c4 18             	add    $0x18,%esp
}
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802369:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80236c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	51                   	push   %ecx
  802377:	52                   	push   %edx
  802378:	50                   	push   %eax
  802379:	6a 1d                	push   $0x1d
  80237b:	e8 dd fc ff ff       	call   80205d <syscall>
  802380:	83 c4 18             	add    $0x18,%esp
}
  802383:	c9                   	leave  
  802384:	c3                   	ret    

00802385 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802388:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238b:	8b 45 08             	mov    0x8(%ebp),%eax
  80238e:	6a 00                	push   $0x0
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	52                   	push   %edx
  802395:	50                   	push   %eax
  802396:	6a 1e                	push   $0x1e
  802398:	e8 c0 fc ff ff       	call   80205d <syscall>
  80239d:	83 c4 18             	add    $0x18,%esp
}
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 1f                	push   $0x1f
  8023b1:	e8 a7 fc ff ff       	call   80205d <syscall>
  8023b6:	83 c4 18             	add    $0x18,%esp
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	6a 00                	push   $0x0
  8023c3:	ff 75 14             	pushl  0x14(%ebp)
  8023c6:	ff 75 10             	pushl  0x10(%ebp)
  8023c9:	ff 75 0c             	pushl  0xc(%ebp)
  8023cc:	50                   	push   %eax
  8023cd:	6a 20                	push   $0x20
  8023cf:	e8 89 fc ff ff       	call   80205d <syscall>
  8023d4:	83 c4 18             	add    $0x18,%esp
}
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	50                   	push   %eax
  8023e8:	6a 21                	push   $0x21
  8023ea:	e8 6e fc ff ff       	call   80205d <syscall>
  8023ef:	83 c4 18             	add    $0x18,%esp
}
  8023f2:	90                   	nop
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	50                   	push   %eax
  802404:	6a 22                	push   $0x22
  802406:	e8 52 fc ff ff       	call   80205d <syscall>
  80240b:	83 c4 18             	add    $0x18,%esp
}
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 02                	push   $0x2
  80241f:	e8 39 fc ff ff       	call   80205d <syscall>
  802424:	83 c4 18             	add    $0x18,%esp
}
  802427:	c9                   	leave  
  802428:	c3                   	ret    

00802429 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 03                	push   $0x3
  802438:	e8 20 fc ff ff       	call   80205d <syscall>
  80243d:	83 c4 18             	add    $0x18,%esp
}
  802440:	c9                   	leave  
  802441:	c3                   	ret    

00802442 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 04                	push   $0x4
  802451:	e8 07 fc ff ff       	call   80205d <syscall>
  802456:	83 c4 18             	add    $0x18,%esp
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <sys_exit_env>:


void sys_exit_env(void)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 23                	push   $0x23
  80246a:	e8 ee fb ff ff       	call   80205d <syscall>
  80246f:	83 c4 18             	add    $0x18,%esp
}
  802472:	90                   	nop
  802473:	c9                   	leave  
  802474:	c3                   	ret    

00802475 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80247b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80247e:	8d 50 04             	lea    0x4(%eax),%edx
  802481:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	52                   	push   %edx
  80248b:	50                   	push   %eax
  80248c:	6a 24                	push   $0x24
  80248e:	e8 ca fb ff ff       	call   80205d <syscall>
  802493:	83 c4 18             	add    $0x18,%esp
	return result;
  802496:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802499:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80249c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80249f:	89 01                	mov    %eax,(%ecx)
  8024a1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	c9                   	leave  
  8024a8:	c2 04 00             	ret    $0x4

008024ab <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	ff 75 10             	pushl  0x10(%ebp)
  8024b5:	ff 75 0c             	pushl  0xc(%ebp)
  8024b8:	ff 75 08             	pushl  0x8(%ebp)
  8024bb:	6a 12                	push   $0x12
  8024bd:	e8 9b fb ff ff       	call   80205d <syscall>
  8024c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c5:	90                   	nop
}
  8024c6:	c9                   	leave  
  8024c7:	c3                   	ret    

008024c8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 25                	push   $0x25
  8024d7:	e8 81 fb ff ff       	call   80205d <syscall>
  8024dc:	83 c4 18             	add    $0x18,%esp
}
  8024df:	c9                   	leave  
  8024e0:	c3                   	ret    

008024e1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
  8024e4:	83 ec 04             	sub    $0x4,%esp
  8024e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024ed:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	50                   	push   %eax
  8024fa:	6a 26                	push   $0x26
  8024fc:	e8 5c fb ff ff       	call   80205d <syscall>
  802501:	83 c4 18             	add    $0x18,%esp
	return ;
  802504:	90                   	nop
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <rsttst>:
void rsttst()
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 28                	push   $0x28
  802516:	e8 42 fb ff ff       	call   80205d <syscall>
  80251b:	83 c4 18             	add    $0x18,%esp
	return ;
  80251e:	90                   	nop
}
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
  802524:	83 ec 04             	sub    $0x4,%esp
  802527:	8b 45 14             	mov    0x14(%ebp),%eax
  80252a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80252d:	8b 55 18             	mov    0x18(%ebp),%edx
  802530:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802534:	52                   	push   %edx
  802535:	50                   	push   %eax
  802536:	ff 75 10             	pushl  0x10(%ebp)
  802539:	ff 75 0c             	pushl  0xc(%ebp)
  80253c:	ff 75 08             	pushl  0x8(%ebp)
  80253f:	6a 27                	push   $0x27
  802541:	e8 17 fb ff ff       	call   80205d <syscall>
  802546:	83 c4 18             	add    $0x18,%esp
	return ;
  802549:	90                   	nop
}
  80254a:	c9                   	leave  
  80254b:	c3                   	ret    

0080254c <chktst>:
void chktst(uint32 n)
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	ff 75 08             	pushl  0x8(%ebp)
  80255a:	6a 29                	push   $0x29
  80255c:	e8 fc fa ff ff       	call   80205d <syscall>
  802561:	83 c4 18             	add    $0x18,%esp
	return ;
  802564:	90                   	nop
}
  802565:	c9                   	leave  
  802566:	c3                   	ret    

00802567 <inctst>:

void inctst()
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 2a                	push   $0x2a
  802576:	e8 e2 fa ff ff       	call   80205d <syscall>
  80257b:	83 c4 18             	add    $0x18,%esp
	return ;
  80257e:	90                   	nop
}
  80257f:	c9                   	leave  
  802580:	c3                   	ret    

00802581 <gettst>:
uint32 gettst()
{
  802581:	55                   	push   %ebp
  802582:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802584:	6a 00                	push   $0x0
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 2b                	push   $0x2b
  802590:	e8 c8 fa ff ff       	call   80205d <syscall>
  802595:	83 c4 18             	add    $0x18,%esp
}
  802598:	c9                   	leave  
  802599:	c3                   	ret    

0080259a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
  80259d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 2c                	push   $0x2c
  8025ac:	e8 ac fa ff ff       	call   80205d <syscall>
  8025b1:	83 c4 18             	add    $0x18,%esp
  8025b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025b7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025bb:	75 07                	jne    8025c4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c2:	eb 05                	jmp    8025c9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c9:	c9                   	leave  
  8025ca:	c3                   	ret    

008025cb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
  8025ce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 2c                	push   $0x2c
  8025dd:	e8 7b fa ff ff       	call   80205d <syscall>
  8025e2:	83 c4 18             	add    $0x18,%esp
  8025e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025e8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025ec:	75 07                	jne    8025f5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f3:	eb 05                	jmp    8025fa <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025fa:	c9                   	leave  
  8025fb:	c3                   	ret    

008025fc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 2c                	push   $0x2c
  80260e:	e8 4a fa ff ff       	call   80205d <syscall>
  802613:	83 c4 18             	add    $0x18,%esp
  802616:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802619:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80261d:	75 07                	jne    802626 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80261f:	b8 01 00 00 00       	mov    $0x1,%eax
  802624:	eb 05                	jmp    80262b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802626:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262b:	c9                   	leave  
  80262c:	c3                   	ret    

0080262d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80262d:	55                   	push   %ebp
  80262e:	89 e5                	mov    %esp,%ebp
  802630:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802633:	6a 00                	push   $0x0
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 2c                	push   $0x2c
  80263f:	e8 19 fa ff ff       	call   80205d <syscall>
  802644:	83 c4 18             	add    $0x18,%esp
  802647:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80264a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80264e:	75 07                	jne    802657 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802650:	b8 01 00 00 00       	mov    $0x1,%eax
  802655:	eb 05                	jmp    80265c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802657:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80265c:	c9                   	leave  
  80265d:	c3                   	ret    

0080265e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80265e:	55                   	push   %ebp
  80265f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	6a 00                	push   $0x0
  802669:	ff 75 08             	pushl  0x8(%ebp)
  80266c:	6a 2d                	push   $0x2d
  80266e:	e8 ea f9 ff ff       	call   80205d <syscall>
  802673:	83 c4 18             	add    $0x18,%esp
	return ;
  802676:	90                   	nop
}
  802677:	c9                   	leave  
  802678:	c3                   	ret    

00802679 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802679:	55                   	push   %ebp
  80267a:	89 e5                	mov    %esp,%ebp
  80267c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80267d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802680:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802683:	8b 55 0c             	mov    0xc(%ebp),%edx
  802686:	8b 45 08             	mov    0x8(%ebp),%eax
  802689:	6a 00                	push   $0x0
  80268b:	53                   	push   %ebx
  80268c:	51                   	push   %ecx
  80268d:	52                   	push   %edx
  80268e:	50                   	push   %eax
  80268f:	6a 2e                	push   $0x2e
  802691:	e8 c7 f9 ff ff       	call   80205d <syscall>
  802696:	83 c4 18             	add    $0x18,%esp
}
  802699:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80269c:	c9                   	leave  
  80269d:	c3                   	ret    

0080269e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80269e:	55                   	push   %ebp
  80269f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	52                   	push   %edx
  8026ae:	50                   	push   %eax
  8026af:	6a 2f                	push   $0x2f
  8026b1:	e8 a7 f9 ff ff       	call   80205d <syscall>
  8026b6:	83 c4 18             	add    $0x18,%esp
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    

008026bb <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
  8026be:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026c1:	83 ec 0c             	sub    $0xc,%esp
  8026c4:	68 d4 42 80 00       	push   $0x8042d4
  8026c9:	e8 bd e4 ff ff       	call   800b8b <cprintf>
  8026ce:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026d8:	83 ec 0c             	sub    $0xc,%esp
  8026db:	68 00 43 80 00       	push   $0x804300
  8026e0:	e8 a6 e4 ff ff       	call   800b8b <cprintf>
  8026e5:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026e8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026ec:	a1 38 51 80 00       	mov    0x805138,%eax
  8026f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f4:	eb 56                	jmp    80274c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026fa:	74 1c                	je     802718 <print_mem_block_lists+0x5d>
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 50 08             	mov    0x8(%eax),%edx
  802702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802705:	8b 48 08             	mov    0x8(%eax),%ecx
  802708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270b:	8b 40 0c             	mov    0xc(%eax),%eax
  80270e:	01 c8                	add    %ecx,%eax
  802710:	39 c2                	cmp    %eax,%edx
  802712:	73 04                	jae    802718 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802714:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 50 08             	mov    0x8(%eax),%edx
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 40 0c             	mov    0xc(%eax),%eax
  802724:	01 c2                	add    %eax,%edx
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 40 08             	mov    0x8(%eax),%eax
  80272c:	83 ec 04             	sub    $0x4,%esp
  80272f:	52                   	push   %edx
  802730:	50                   	push   %eax
  802731:	68 15 43 80 00       	push   $0x804315
  802736:	e8 50 e4 ff ff       	call   800b8b <cprintf>
  80273b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802744:	a1 40 51 80 00       	mov    0x805140,%eax
  802749:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802750:	74 07                	je     802759 <print_mem_block_lists+0x9e>
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 00                	mov    (%eax),%eax
  802757:	eb 05                	jmp    80275e <print_mem_block_lists+0xa3>
  802759:	b8 00 00 00 00       	mov    $0x0,%eax
  80275e:	a3 40 51 80 00       	mov    %eax,0x805140
  802763:	a1 40 51 80 00       	mov    0x805140,%eax
  802768:	85 c0                	test   %eax,%eax
  80276a:	75 8a                	jne    8026f6 <print_mem_block_lists+0x3b>
  80276c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802770:	75 84                	jne    8026f6 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802772:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802776:	75 10                	jne    802788 <print_mem_block_lists+0xcd>
  802778:	83 ec 0c             	sub    $0xc,%esp
  80277b:	68 24 43 80 00       	push   $0x804324
  802780:	e8 06 e4 ff ff       	call   800b8b <cprintf>
  802785:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802788:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80278f:	83 ec 0c             	sub    $0xc,%esp
  802792:	68 48 43 80 00       	push   $0x804348
  802797:	e8 ef e3 ff ff       	call   800b8b <cprintf>
  80279c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80279f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027a3:	a1 40 50 80 00       	mov    0x805040,%eax
  8027a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ab:	eb 56                	jmp    802803 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027b1:	74 1c                	je     8027cf <print_mem_block_lists+0x114>
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 50 08             	mov    0x8(%eax),%edx
  8027b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bc:	8b 48 08             	mov    0x8(%eax),%ecx
  8027bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c5:	01 c8                	add    %ecx,%eax
  8027c7:	39 c2                	cmp    %eax,%edx
  8027c9:	73 04                	jae    8027cf <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027cb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	8b 50 08             	mov    0x8(%eax),%edx
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027db:	01 c2                	add    %eax,%edx
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 40 08             	mov    0x8(%eax),%eax
  8027e3:	83 ec 04             	sub    $0x4,%esp
  8027e6:	52                   	push   %edx
  8027e7:	50                   	push   %eax
  8027e8:	68 15 43 80 00       	push   $0x804315
  8027ed:	e8 99 e3 ff ff       	call   800b8b <cprintf>
  8027f2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027fb:	a1 48 50 80 00       	mov    0x805048,%eax
  802800:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802803:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802807:	74 07                	je     802810 <print_mem_block_lists+0x155>
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	8b 00                	mov    (%eax),%eax
  80280e:	eb 05                	jmp    802815 <print_mem_block_lists+0x15a>
  802810:	b8 00 00 00 00       	mov    $0x0,%eax
  802815:	a3 48 50 80 00       	mov    %eax,0x805048
  80281a:	a1 48 50 80 00       	mov    0x805048,%eax
  80281f:	85 c0                	test   %eax,%eax
  802821:	75 8a                	jne    8027ad <print_mem_block_lists+0xf2>
  802823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802827:	75 84                	jne    8027ad <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802829:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80282d:	75 10                	jne    80283f <print_mem_block_lists+0x184>
  80282f:	83 ec 0c             	sub    $0xc,%esp
  802832:	68 60 43 80 00       	push   $0x804360
  802837:	e8 4f e3 ff ff       	call   800b8b <cprintf>
  80283c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80283f:	83 ec 0c             	sub    $0xc,%esp
  802842:	68 d4 42 80 00       	push   $0x8042d4
  802847:	e8 3f e3 ff ff       	call   800b8b <cprintf>
  80284c:	83 c4 10             	add    $0x10,%esp

}
  80284f:	90                   	nop
  802850:	c9                   	leave  
  802851:	c3                   	ret    

00802852 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802852:	55                   	push   %ebp
  802853:	89 e5                	mov    %esp,%ebp
  802855:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802858:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80285f:	00 00 00 
  802862:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802869:	00 00 00 
  80286c:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802873:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802876:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80287d:	e9 9e 00 00 00       	jmp    802920 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802882:	a1 50 50 80 00       	mov    0x805050,%eax
  802887:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288a:	c1 e2 04             	shl    $0x4,%edx
  80288d:	01 d0                	add    %edx,%eax
  80288f:	85 c0                	test   %eax,%eax
  802891:	75 14                	jne    8028a7 <initialize_MemBlocksList+0x55>
  802893:	83 ec 04             	sub    $0x4,%esp
  802896:	68 88 43 80 00       	push   $0x804388
  80289b:	6a 47                	push   $0x47
  80289d:	68 ab 43 80 00       	push   $0x8043ab
  8028a2:	e8 30 e0 ff ff       	call   8008d7 <_panic>
  8028a7:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028af:	c1 e2 04             	shl    $0x4,%edx
  8028b2:	01 d0                	add    %edx,%eax
  8028b4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8028ba:	89 10                	mov    %edx,(%eax)
  8028bc:	8b 00                	mov    (%eax),%eax
  8028be:	85 c0                	test   %eax,%eax
  8028c0:	74 18                	je     8028da <initialize_MemBlocksList+0x88>
  8028c2:	a1 48 51 80 00       	mov    0x805148,%eax
  8028c7:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028cd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028d0:	c1 e1 04             	shl    $0x4,%ecx
  8028d3:	01 ca                	add    %ecx,%edx
  8028d5:	89 50 04             	mov    %edx,0x4(%eax)
  8028d8:	eb 12                	jmp    8028ec <initialize_MemBlocksList+0x9a>
  8028da:	a1 50 50 80 00       	mov    0x805050,%eax
  8028df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e2:	c1 e2 04             	shl    $0x4,%edx
  8028e5:	01 d0                	add    %edx,%eax
  8028e7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028ec:	a1 50 50 80 00       	mov    0x805050,%eax
  8028f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f4:	c1 e2 04             	shl    $0x4,%edx
  8028f7:	01 d0                	add    %edx,%eax
  8028f9:	a3 48 51 80 00       	mov    %eax,0x805148
  8028fe:	a1 50 50 80 00       	mov    0x805050,%eax
  802903:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802906:	c1 e2 04             	shl    $0x4,%edx
  802909:	01 d0                	add    %edx,%eax
  80290b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802912:	a1 54 51 80 00       	mov    0x805154,%eax
  802917:	40                   	inc    %eax
  802918:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80291d:	ff 45 f4             	incl   -0xc(%ebp)
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	3b 45 08             	cmp    0x8(%ebp),%eax
  802926:	0f 82 56 ff ff ff    	jb     802882 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  80292c:	90                   	nop
  80292d:	c9                   	leave  
  80292e:	c3                   	ret    

0080292f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80292f:	55                   	push   %ebp
  802930:	89 e5                	mov    %esp,%ebp
  802932:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802935:	8b 45 08             	mov    0x8(%ebp),%eax
  802938:	8b 00                	mov    (%eax),%eax
  80293a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80293d:	eb 19                	jmp    802958 <find_block+0x29>
	{
		if(element->sva == va){
  80293f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802942:	8b 40 08             	mov    0x8(%eax),%eax
  802945:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802948:	75 05                	jne    80294f <find_block+0x20>
			 		return element;
  80294a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80294d:	eb 36                	jmp    802985 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	8b 40 08             	mov    0x8(%eax),%eax
  802955:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802958:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80295c:	74 07                	je     802965 <find_block+0x36>
  80295e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802961:	8b 00                	mov    (%eax),%eax
  802963:	eb 05                	jmp    80296a <find_block+0x3b>
  802965:	b8 00 00 00 00       	mov    $0x0,%eax
  80296a:	8b 55 08             	mov    0x8(%ebp),%edx
  80296d:	89 42 08             	mov    %eax,0x8(%edx)
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	8b 40 08             	mov    0x8(%eax),%eax
  802976:	85 c0                	test   %eax,%eax
  802978:	75 c5                	jne    80293f <find_block+0x10>
  80297a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80297e:	75 bf                	jne    80293f <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802980:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802985:	c9                   	leave  
  802986:	c3                   	ret    

00802987 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802987:	55                   	push   %ebp
  802988:	89 e5                	mov    %esp,%ebp
  80298a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80298d:	a1 44 50 80 00       	mov    0x805044,%eax
  802992:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802995:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80299a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80299d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029a1:	74 0a                	je     8029ad <insert_sorted_allocList+0x26>
  8029a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a6:	8b 40 08             	mov    0x8(%eax),%eax
  8029a9:	85 c0                	test   %eax,%eax
  8029ab:	75 65                	jne    802a12 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8029ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b1:	75 14                	jne    8029c7 <insert_sorted_allocList+0x40>
  8029b3:	83 ec 04             	sub    $0x4,%esp
  8029b6:	68 88 43 80 00       	push   $0x804388
  8029bb:	6a 6e                	push   $0x6e
  8029bd:	68 ab 43 80 00       	push   $0x8043ab
  8029c2:	e8 10 df ff ff       	call   8008d7 <_panic>
  8029c7:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	89 10                	mov    %edx,(%eax)
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	8b 00                	mov    (%eax),%eax
  8029d7:	85 c0                	test   %eax,%eax
  8029d9:	74 0d                	je     8029e8 <insert_sorted_allocList+0x61>
  8029db:	a1 40 50 80 00       	mov    0x805040,%eax
  8029e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e3:	89 50 04             	mov    %edx,0x4(%eax)
  8029e6:	eb 08                	jmp    8029f0 <insert_sorted_allocList+0x69>
  8029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029eb:	a3 44 50 80 00       	mov    %eax,0x805044
  8029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f3:	a3 40 50 80 00       	mov    %eax,0x805040
  8029f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a02:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a07:	40                   	inc    %eax
  802a08:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802a0d:	e9 cf 01 00 00       	jmp    802be1 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a15:	8b 50 08             	mov    0x8(%eax),%edx
  802a18:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1b:	8b 40 08             	mov    0x8(%eax),%eax
  802a1e:	39 c2                	cmp    %eax,%edx
  802a20:	73 65                	jae    802a87 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802a22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a26:	75 14                	jne    802a3c <insert_sorted_allocList+0xb5>
  802a28:	83 ec 04             	sub    $0x4,%esp
  802a2b:	68 c4 43 80 00       	push   $0x8043c4
  802a30:	6a 72                	push   $0x72
  802a32:	68 ab 43 80 00       	push   $0x8043ab
  802a37:	e8 9b de ff ff       	call   8008d7 <_panic>
  802a3c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a42:	8b 45 08             	mov    0x8(%ebp),%eax
  802a45:	89 50 04             	mov    %edx,0x4(%eax)
  802a48:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4b:	8b 40 04             	mov    0x4(%eax),%eax
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	74 0c                	je     802a5e <insert_sorted_allocList+0xd7>
  802a52:	a1 44 50 80 00       	mov    0x805044,%eax
  802a57:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5a:	89 10                	mov    %edx,(%eax)
  802a5c:	eb 08                	jmp    802a66 <insert_sorted_allocList+0xdf>
  802a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a61:	a3 40 50 80 00       	mov    %eax,0x805040
  802a66:	8b 45 08             	mov    0x8(%ebp),%eax
  802a69:	a3 44 50 80 00       	mov    %eax,0x805044
  802a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a77:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a7c:	40                   	inc    %eax
  802a7d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802a82:	e9 5a 01 00 00       	jmp    802be1 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8a:	8b 50 08             	mov    0x8(%eax),%edx
  802a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a90:	8b 40 08             	mov    0x8(%eax),%eax
  802a93:	39 c2                	cmp    %eax,%edx
  802a95:	75 70                	jne    802b07 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802a97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a9b:	74 06                	je     802aa3 <insert_sorted_allocList+0x11c>
  802a9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa1:	75 14                	jne    802ab7 <insert_sorted_allocList+0x130>
  802aa3:	83 ec 04             	sub    $0x4,%esp
  802aa6:	68 e8 43 80 00       	push   $0x8043e8
  802aab:	6a 75                	push   $0x75
  802aad:	68 ab 43 80 00       	push   $0x8043ab
  802ab2:	e8 20 de ff ff       	call   8008d7 <_panic>
  802ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aba:	8b 10                	mov    (%eax),%edx
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	89 10                	mov    %edx,(%eax)
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	74 0b                	je     802ad5 <insert_sorted_allocList+0x14e>
  802aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acd:	8b 00                	mov    (%eax),%eax
  802acf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad2:	89 50 04             	mov    %edx,0x4(%eax)
  802ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad8:	8b 55 08             	mov    0x8(%ebp),%edx
  802adb:	89 10                	mov    %edx,(%eax)
  802add:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ae3:	89 50 04             	mov    %edx,0x4(%eax)
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	75 08                	jne    802af7 <insert_sorted_allocList+0x170>
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	a3 44 50 80 00       	mov    %eax,0x805044
  802af7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802afc:	40                   	inc    %eax
  802afd:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802b02:	e9 da 00 00 00       	jmp    802be1 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802b07:	a1 40 50 80 00       	mov    0x805040,%eax
  802b0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b0f:	e9 9d 00 00 00       	jmp    802bb1 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	8b 50 08             	mov    0x8(%eax),%edx
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 40 08             	mov    0x8(%eax),%eax
  802b28:	39 c2                	cmp    %eax,%edx
  802b2a:	76 7d                	jbe    802ba9 <insert_sorted_allocList+0x222>
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	8b 50 08             	mov    0x8(%eax),%edx
  802b32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b35:	8b 40 08             	mov    0x8(%eax),%eax
  802b38:	39 c2                	cmp    %eax,%edx
  802b3a:	73 6d                	jae    802ba9 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802b3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b40:	74 06                	je     802b48 <insert_sorted_allocList+0x1c1>
  802b42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b46:	75 14                	jne    802b5c <insert_sorted_allocList+0x1d5>
  802b48:	83 ec 04             	sub    $0x4,%esp
  802b4b:	68 e8 43 80 00       	push   $0x8043e8
  802b50:	6a 7c                	push   $0x7c
  802b52:	68 ab 43 80 00       	push   $0x8043ab
  802b57:	e8 7b dd ff ff       	call   8008d7 <_panic>
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 10                	mov    (%eax),%edx
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	89 10                	mov    %edx,(%eax)
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	8b 00                	mov    (%eax),%eax
  802b6b:	85 c0                	test   %eax,%eax
  802b6d:	74 0b                	je     802b7a <insert_sorted_allocList+0x1f3>
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 00                	mov    (%eax),%eax
  802b74:	8b 55 08             	mov    0x8(%ebp),%edx
  802b77:	89 50 04             	mov    %edx,0x4(%eax)
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b80:	89 10                	mov    %edx,(%eax)
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b88:	89 50 04             	mov    %edx,0x4(%eax)
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	85 c0                	test   %eax,%eax
  802b92:	75 08                	jne    802b9c <insert_sorted_allocList+0x215>
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	a3 44 50 80 00       	mov    %eax,0x805044
  802b9c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ba1:	40                   	inc    %eax
  802ba2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802ba7:	eb 38                	jmp    802be1 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802ba9:	a1 48 50 80 00       	mov    0x805048,%eax
  802bae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb5:	74 07                	je     802bbe <insert_sorted_allocList+0x237>
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	8b 00                	mov    (%eax),%eax
  802bbc:	eb 05                	jmp    802bc3 <insert_sorted_allocList+0x23c>
  802bbe:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc3:	a3 48 50 80 00       	mov    %eax,0x805048
  802bc8:	a1 48 50 80 00       	mov    0x805048,%eax
  802bcd:	85 c0                	test   %eax,%eax
  802bcf:	0f 85 3f ff ff ff    	jne    802b14 <insert_sorted_allocList+0x18d>
  802bd5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd9:	0f 85 35 ff ff ff    	jne    802b14 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802bdf:	eb 00                	jmp    802be1 <insert_sorted_allocList+0x25a>
  802be1:	90                   	nop
  802be2:	c9                   	leave  
  802be3:	c3                   	ret    

00802be4 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802be4:	55                   	push   %ebp
  802be5:	89 e5                	mov    %esp,%ebp
  802be7:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802bea:	a1 38 51 80 00       	mov    0x805138,%eax
  802bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf2:	e9 6b 02 00 00       	jmp    802e62 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c00:	0f 85 90 00 00 00    	jne    802c96 <alloc_block_FF+0xb2>
			  temp=element;
  802c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c09:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802c0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c10:	75 17                	jne    802c29 <alloc_block_FF+0x45>
  802c12:	83 ec 04             	sub    $0x4,%esp
  802c15:	68 1c 44 80 00       	push   $0x80441c
  802c1a:	68 92 00 00 00       	push   $0x92
  802c1f:	68 ab 43 80 00       	push   $0x8043ab
  802c24:	e8 ae dc ff ff       	call   8008d7 <_panic>
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	85 c0                	test   %eax,%eax
  802c30:	74 10                	je     802c42 <alloc_block_FF+0x5e>
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	8b 00                	mov    (%eax),%eax
  802c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c3a:	8b 52 04             	mov    0x4(%edx),%edx
  802c3d:	89 50 04             	mov    %edx,0x4(%eax)
  802c40:	eb 0b                	jmp    802c4d <alloc_block_FF+0x69>
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	8b 40 04             	mov    0x4(%eax),%eax
  802c48:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 40 04             	mov    0x4(%eax),%eax
  802c53:	85 c0                	test   %eax,%eax
  802c55:	74 0f                	je     802c66 <alloc_block_FF+0x82>
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 40 04             	mov    0x4(%eax),%eax
  802c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c60:	8b 12                	mov    (%edx),%edx
  802c62:	89 10                	mov    %edx,(%eax)
  802c64:	eb 0a                	jmp    802c70 <alloc_block_FF+0x8c>
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 00                	mov    (%eax),%eax
  802c6b:	a3 38 51 80 00       	mov    %eax,0x805138
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c83:	a1 44 51 80 00       	mov    0x805144,%eax
  802c88:	48                   	dec    %eax
  802c89:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802c8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c91:	e9 ff 01 00 00       	jmp    802e95 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c9f:	0f 86 b5 01 00 00    	jbe    802e5a <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cab:	2b 45 08             	sub    0x8(%ebp),%eax
  802cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802cb1:	a1 48 51 80 00       	mov    0x805148,%eax
  802cb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802cb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cbd:	75 17                	jne    802cd6 <alloc_block_FF+0xf2>
  802cbf:	83 ec 04             	sub    $0x4,%esp
  802cc2:	68 1c 44 80 00       	push   $0x80441c
  802cc7:	68 99 00 00 00       	push   $0x99
  802ccc:	68 ab 43 80 00       	push   $0x8043ab
  802cd1:	e8 01 dc ff ff       	call   8008d7 <_panic>
  802cd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd9:	8b 00                	mov    (%eax),%eax
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	74 10                	je     802cef <alloc_block_FF+0x10b>
  802cdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce2:	8b 00                	mov    (%eax),%eax
  802ce4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce7:	8b 52 04             	mov    0x4(%edx),%edx
  802cea:	89 50 04             	mov    %edx,0x4(%eax)
  802ced:	eb 0b                	jmp    802cfa <alloc_block_FF+0x116>
  802cef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf2:	8b 40 04             	mov    0x4(%eax),%eax
  802cf5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfd:	8b 40 04             	mov    0x4(%eax),%eax
  802d00:	85 c0                	test   %eax,%eax
  802d02:	74 0f                	je     802d13 <alloc_block_FF+0x12f>
  802d04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d07:	8b 40 04             	mov    0x4(%eax),%eax
  802d0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d0d:	8b 12                	mov    (%edx),%edx
  802d0f:	89 10                	mov    %edx,(%eax)
  802d11:	eb 0a                	jmp    802d1d <alloc_block_FF+0x139>
  802d13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d16:	8b 00                	mov    (%eax),%eax
  802d18:	a3 48 51 80 00       	mov    %eax,0x805148
  802d1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d30:	a1 54 51 80 00       	mov    0x805154,%eax
  802d35:	48                   	dec    %eax
  802d36:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802d3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d3f:	75 17                	jne    802d58 <alloc_block_FF+0x174>
  802d41:	83 ec 04             	sub    $0x4,%esp
  802d44:	68 c4 43 80 00       	push   $0x8043c4
  802d49:	68 9a 00 00 00       	push   $0x9a
  802d4e:	68 ab 43 80 00       	push   $0x8043ab
  802d53:	e8 7f db ff ff       	call   8008d7 <_panic>
  802d58:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d61:	89 50 04             	mov    %edx,0x4(%eax)
  802d64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d67:	8b 40 04             	mov    0x4(%eax),%eax
  802d6a:	85 c0                	test   %eax,%eax
  802d6c:	74 0c                	je     802d7a <alloc_block_FF+0x196>
  802d6e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d76:	89 10                	mov    %edx,(%eax)
  802d78:	eb 08                	jmp    802d82 <alloc_block_FF+0x19e>
  802d7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7d:	a3 38 51 80 00       	mov    %eax,0x805138
  802d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d85:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d93:	a1 44 51 80 00       	mov    0x805144,%eax
  802d98:	40                   	inc    %eax
  802d99:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802d9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da1:	8b 55 08             	mov    0x8(%ebp),%edx
  802da4:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daa:	8b 50 08             	mov    0x8(%eax),%edx
  802dad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db0:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db9:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	8b 50 08             	mov    0x8(%eax),%edx
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	01 c2                	add    %eax,%edx
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802dcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802dd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dd7:	75 17                	jne    802df0 <alloc_block_FF+0x20c>
  802dd9:	83 ec 04             	sub    $0x4,%esp
  802ddc:	68 1c 44 80 00       	push   $0x80441c
  802de1:	68 a2 00 00 00       	push   $0xa2
  802de6:	68 ab 43 80 00       	push   $0x8043ab
  802deb:	e8 e7 da ff ff       	call   8008d7 <_panic>
  802df0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df3:	8b 00                	mov    (%eax),%eax
  802df5:	85 c0                	test   %eax,%eax
  802df7:	74 10                	je     802e09 <alloc_block_FF+0x225>
  802df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfc:	8b 00                	mov    (%eax),%eax
  802dfe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e01:	8b 52 04             	mov    0x4(%edx),%edx
  802e04:	89 50 04             	mov    %edx,0x4(%eax)
  802e07:	eb 0b                	jmp    802e14 <alloc_block_FF+0x230>
  802e09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0c:	8b 40 04             	mov    0x4(%eax),%eax
  802e0f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e17:	8b 40 04             	mov    0x4(%eax),%eax
  802e1a:	85 c0                	test   %eax,%eax
  802e1c:	74 0f                	je     802e2d <alloc_block_FF+0x249>
  802e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e21:	8b 40 04             	mov    0x4(%eax),%eax
  802e24:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e27:	8b 12                	mov    (%edx),%edx
  802e29:	89 10                	mov    %edx,(%eax)
  802e2b:	eb 0a                	jmp    802e37 <alloc_block_FF+0x253>
  802e2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e30:	8b 00                	mov    (%eax),%eax
  802e32:	a3 38 51 80 00       	mov    %eax,0x805138
  802e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4a:	a1 44 51 80 00       	mov    0x805144,%eax
  802e4f:	48                   	dec    %eax
  802e50:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802e55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e58:	eb 3b                	jmp    802e95 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802e5a:	a1 40 51 80 00       	mov    0x805140,%eax
  802e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e66:	74 07                	je     802e6f <alloc_block_FF+0x28b>
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 00                	mov    (%eax),%eax
  802e6d:	eb 05                	jmp    802e74 <alloc_block_FF+0x290>
  802e6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e74:	a3 40 51 80 00       	mov    %eax,0x805140
  802e79:	a1 40 51 80 00       	mov    0x805140,%eax
  802e7e:	85 c0                	test   %eax,%eax
  802e80:	0f 85 71 fd ff ff    	jne    802bf7 <alloc_block_FF+0x13>
  802e86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8a:	0f 85 67 fd ff ff    	jne    802bf7 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802e90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e95:	c9                   	leave  
  802e96:	c3                   	ret    

00802e97 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e97:	55                   	push   %ebp
  802e98:	89 e5                	mov    %esp,%ebp
  802e9a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802e9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802ea4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802eab:	a1 38 51 80 00       	mov    0x805138,%eax
  802eb0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802eb3:	e9 d3 00 00 00       	jmp    802f8b <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802eb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec1:	0f 85 90 00 00 00    	jne    802f57 <alloc_block_BF+0xc0>
	   temp = element;
  802ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eca:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802ecd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ed1:	75 17                	jne    802eea <alloc_block_BF+0x53>
  802ed3:	83 ec 04             	sub    $0x4,%esp
  802ed6:	68 1c 44 80 00       	push   $0x80441c
  802edb:	68 bd 00 00 00       	push   $0xbd
  802ee0:	68 ab 43 80 00       	push   $0x8043ab
  802ee5:	e8 ed d9 ff ff       	call   8008d7 <_panic>
  802eea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	85 c0                	test   %eax,%eax
  802ef1:	74 10                	je     802f03 <alloc_block_BF+0x6c>
  802ef3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef6:	8b 00                	mov    (%eax),%eax
  802ef8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802efb:	8b 52 04             	mov    0x4(%edx),%edx
  802efe:	89 50 04             	mov    %edx,0x4(%eax)
  802f01:	eb 0b                	jmp    802f0e <alloc_block_BF+0x77>
  802f03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f06:	8b 40 04             	mov    0x4(%eax),%eax
  802f09:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f11:	8b 40 04             	mov    0x4(%eax),%eax
  802f14:	85 c0                	test   %eax,%eax
  802f16:	74 0f                	je     802f27 <alloc_block_BF+0x90>
  802f18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1b:	8b 40 04             	mov    0x4(%eax),%eax
  802f1e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f21:	8b 12                	mov    (%edx),%edx
  802f23:	89 10                	mov    %edx,(%eax)
  802f25:	eb 0a                	jmp    802f31 <alloc_block_BF+0x9a>
  802f27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2a:	8b 00                	mov    (%eax),%eax
  802f2c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f44:	a1 44 51 80 00       	mov    0x805144,%eax
  802f49:	48                   	dec    %eax
  802f4a:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802f4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f52:	e9 41 01 00 00       	jmp    803098 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802f57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f60:	76 21                	jbe    802f83 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802f62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f65:	8b 40 0c             	mov    0xc(%eax),%eax
  802f68:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f6b:	73 16                	jae    802f83 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802f6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f70:	8b 40 0c             	mov    0xc(%eax),%eax
  802f73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802f76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f79:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802f7c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802f83:	a1 40 51 80 00       	mov    0x805140,%eax
  802f88:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802f8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f8f:	74 07                	je     802f98 <alloc_block_BF+0x101>
  802f91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f94:	8b 00                	mov    (%eax),%eax
  802f96:	eb 05                	jmp    802f9d <alloc_block_BF+0x106>
  802f98:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9d:	a3 40 51 80 00       	mov    %eax,0x805140
  802fa2:	a1 40 51 80 00       	mov    0x805140,%eax
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	0f 85 09 ff ff ff    	jne    802eb8 <alloc_block_BF+0x21>
  802faf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fb3:	0f 85 ff fe ff ff    	jne    802eb8 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802fb9:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802fbd:	0f 85 d0 00 00 00    	jne    803093 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802fc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc9:	2b 45 08             	sub    0x8(%ebp),%eax
  802fcc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802fcf:	a1 48 51 80 00       	mov    0x805148,%eax
  802fd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802fd7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802fdb:	75 17                	jne    802ff4 <alloc_block_BF+0x15d>
  802fdd:	83 ec 04             	sub    $0x4,%esp
  802fe0:	68 1c 44 80 00       	push   $0x80441c
  802fe5:	68 d1 00 00 00       	push   $0xd1
  802fea:	68 ab 43 80 00       	push   $0x8043ab
  802fef:	e8 e3 d8 ff ff       	call   8008d7 <_panic>
  802ff4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff7:	8b 00                	mov    (%eax),%eax
  802ff9:	85 c0                	test   %eax,%eax
  802ffb:	74 10                	je     80300d <alloc_block_BF+0x176>
  802ffd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803000:	8b 00                	mov    (%eax),%eax
  803002:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803005:	8b 52 04             	mov    0x4(%edx),%edx
  803008:	89 50 04             	mov    %edx,0x4(%eax)
  80300b:	eb 0b                	jmp    803018 <alloc_block_BF+0x181>
  80300d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803010:	8b 40 04             	mov    0x4(%eax),%eax
  803013:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803018:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301b:	8b 40 04             	mov    0x4(%eax),%eax
  80301e:	85 c0                	test   %eax,%eax
  803020:	74 0f                	je     803031 <alloc_block_BF+0x19a>
  803022:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803025:	8b 40 04             	mov    0x4(%eax),%eax
  803028:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80302b:	8b 12                	mov    (%edx),%edx
  80302d:	89 10                	mov    %edx,(%eax)
  80302f:	eb 0a                	jmp    80303b <alloc_block_BF+0x1a4>
  803031:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803034:	8b 00                	mov    (%eax),%eax
  803036:	a3 48 51 80 00       	mov    %eax,0x805148
  80303b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80303e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803044:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803047:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304e:	a1 54 51 80 00       	mov    0x805154,%eax
  803053:	48                   	dec    %eax
  803054:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  803059:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80305c:	8b 55 08             	mov    0x8(%ebp),%edx
  80305f:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  803062:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803065:	8b 50 08             	mov    0x8(%eax),%edx
  803068:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80306b:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  80306e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803071:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803074:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  803077:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307a:	8b 50 08             	mov    0x8(%eax),%edx
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	01 c2                	add    %eax,%edx
  803082:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803085:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  803088:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80308b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  80308e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803091:	eb 05                	jmp    803098 <alloc_block_BF+0x201>
	 }
	 return NULL;
  803093:	b8 00 00 00 00       	mov    $0x0,%eax


}
  803098:	c9                   	leave  
  803099:	c3                   	ret    

0080309a <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80309a:	55                   	push   %ebp
  80309b:	89 e5                	mov    %esp,%ebp
  80309d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8030a0:	83 ec 04             	sub    $0x4,%esp
  8030a3:	68 3c 44 80 00       	push   $0x80443c
  8030a8:	68 e8 00 00 00       	push   $0xe8
  8030ad:	68 ab 43 80 00       	push   $0x8043ab
  8030b2:	e8 20 d8 ff ff       	call   8008d7 <_panic>

008030b7 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8030b7:	55                   	push   %ebp
  8030b8:	89 e5                	mov    %esp,%ebp
  8030ba:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  8030bd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  8030c5:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8030cd:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8030d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d9:	75 68                	jne    803143 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8030db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030df:	75 17                	jne    8030f8 <insert_sorted_with_merge_freeList+0x41>
  8030e1:	83 ec 04             	sub    $0x4,%esp
  8030e4:	68 88 43 80 00       	push   $0x804388
  8030e9:	68 36 01 00 00       	push   $0x136
  8030ee:	68 ab 43 80 00       	push   $0x8043ab
  8030f3:	e8 df d7 ff ff       	call   8008d7 <_panic>
  8030f8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	89 10                	mov    %edx,(%eax)
  803103:	8b 45 08             	mov    0x8(%ebp),%eax
  803106:	8b 00                	mov    (%eax),%eax
  803108:	85 c0                	test   %eax,%eax
  80310a:	74 0d                	je     803119 <insert_sorted_with_merge_freeList+0x62>
  80310c:	a1 38 51 80 00       	mov    0x805138,%eax
  803111:	8b 55 08             	mov    0x8(%ebp),%edx
  803114:	89 50 04             	mov    %edx,0x4(%eax)
  803117:	eb 08                	jmp    803121 <insert_sorted_with_merge_freeList+0x6a>
  803119:	8b 45 08             	mov    0x8(%ebp),%eax
  80311c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803121:	8b 45 08             	mov    0x8(%ebp),%eax
  803124:	a3 38 51 80 00       	mov    %eax,0x805138
  803129:	8b 45 08             	mov    0x8(%ebp),%eax
  80312c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803133:	a1 44 51 80 00       	mov    0x805144,%eax
  803138:	40                   	inc    %eax
  803139:	a3 44 51 80 00       	mov    %eax,0x805144





}
  80313e:	e9 ba 06 00 00       	jmp    8037fd <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  803143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803146:	8b 50 08             	mov    0x8(%eax),%edx
  803149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314c:	8b 40 0c             	mov    0xc(%eax),%eax
  80314f:	01 c2                	add    %eax,%edx
  803151:	8b 45 08             	mov    0x8(%ebp),%eax
  803154:	8b 40 08             	mov    0x8(%eax),%eax
  803157:	39 c2                	cmp    %eax,%edx
  803159:	73 68                	jae    8031c3 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80315b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80315f:	75 17                	jne    803178 <insert_sorted_with_merge_freeList+0xc1>
  803161:	83 ec 04             	sub    $0x4,%esp
  803164:	68 c4 43 80 00       	push   $0x8043c4
  803169:	68 3a 01 00 00       	push   $0x13a
  80316e:	68 ab 43 80 00       	push   $0x8043ab
  803173:	e8 5f d7 ff ff       	call   8008d7 <_panic>
  803178:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	89 50 04             	mov    %edx,0x4(%eax)
  803184:	8b 45 08             	mov    0x8(%ebp),%eax
  803187:	8b 40 04             	mov    0x4(%eax),%eax
  80318a:	85 c0                	test   %eax,%eax
  80318c:	74 0c                	je     80319a <insert_sorted_with_merge_freeList+0xe3>
  80318e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803193:	8b 55 08             	mov    0x8(%ebp),%edx
  803196:	89 10                	mov    %edx,(%eax)
  803198:	eb 08                	jmp    8031a2 <insert_sorted_with_merge_freeList+0xeb>
  80319a:	8b 45 08             	mov    0x8(%ebp),%eax
  80319d:	a3 38 51 80 00       	mov    %eax,0x805138
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b3:	a1 44 51 80 00       	mov    0x805144,%eax
  8031b8:	40                   	inc    %eax
  8031b9:	a3 44 51 80 00       	mov    %eax,0x805144





}
  8031be:	e9 3a 06 00 00       	jmp    8037fd <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  8031c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c6:	8b 50 08             	mov    0x8(%eax),%edx
  8031c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031cf:	01 c2                	add    %eax,%edx
  8031d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d4:	8b 40 08             	mov    0x8(%eax),%eax
  8031d7:	39 c2                	cmp    %eax,%edx
  8031d9:	0f 85 90 00 00 00    	jne    80326f <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8031df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e2:	8b 50 0c             	mov    0xc(%eax),%edx
  8031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031eb:	01 c2                	add    %eax,%edx
  8031ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f0:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803200:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803207:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80320b:	75 17                	jne    803224 <insert_sorted_with_merge_freeList+0x16d>
  80320d:	83 ec 04             	sub    $0x4,%esp
  803210:	68 88 43 80 00       	push   $0x804388
  803215:	68 41 01 00 00       	push   $0x141
  80321a:	68 ab 43 80 00       	push   $0x8043ab
  80321f:	e8 b3 d6 ff ff       	call   8008d7 <_panic>
  803224:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	89 10                	mov    %edx,(%eax)
  80322f:	8b 45 08             	mov    0x8(%ebp),%eax
  803232:	8b 00                	mov    (%eax),%eax
  803234:	85 c0                	test   %eax,%eax
  803236:	74 0d                	je     803245 <insert_sorted_with_merge_freeList+0x18e>
  803238:	a1 48 51 80 00       	mov    0x805148,%eax
  80323d:	8b 55 08             	mov    0x8(%ebp),%edx
  803240:	89 50 04             	mov    %edx,0x4(%eax)
  803243:	eb 08                	jmp    80324d <insert_sorted_with_merge_freeList+0x196>
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
  803248:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80324d:	8b 45 08             	mov    0x8(%ebp),%eax
  803250:	a3 48 51 80 00       	mov    %eax,0x805148
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325f:	a1 54 51 80 00       	mov    0x805154,%eax
  803264:	40                   	inc    %eax
  803265:	a3 54 51 80 00       	mov    %eax,0x805154





}
  80326a:	e9 8e 05 00 00       	jmp    8037fd <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  80326f:	8b 45 08             	mov    0x8(%ebp),%eax
  803272:	8b 50 08             	mov    0x8(%eax),%edx
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	8b 40 0c             	mov    0xc(%eax),%eax
  80327b:	01 c2                	add    %eax,%edx
  80327d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803280:	8b 40 08             	mov    0x8(%eax),%eax
  803283:	39 c2                	cmp    %eax,%edx
  803285:	73 68                	jae    8032ef <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803287:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80328b:	75 17                	jne    8032a4 <insert_sorted_with_merge_freeList+0x1ed>
  80328d:	83 ec 04             	sub    $0x4,%esp
  803290:	68 88 43 80 00       	push   $0x804388
  803295:	68 45 01 00 00       	push   $0x145
  80329a:	68 ab 43 80 00       	push   $0x8043ab
  80329f:	e8 33 d6 ff ff       	call   8008d7 <_panic>
  8032a4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ad:	89 10                	mov    %edx,(%eax)
  8032af:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b2:	8b 00                	mov    (%eax),%eax
  8032b4:	85 c0                	test   %eax,%eax
  8032b6:	74 0d                	je     8032c5 <insert_sorted_with_merge_freeList+0x20e>
  8032b8:	a1 38 51 80 00       	mov    0x805138,%eax
  8032bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c0:	89 50 04             	mov    %edx,0x4(%eax)
  8032c3:	eb 08                	jmp    8032cd <insert_sorted_with_merge_freeList+0x216>
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032df:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e4:	40                   	inc    %eax
  8032e5:	a3 44 51 80 00       	mov    %eax,0x805144





}
  8032ea:	e9 0e 05 00 00       	jmp    8037fd <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  8032ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f2:	8b 50 08             	mov    0x8(%eax),%edx
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fb:	01 c2                	add    %eax,%edx
  8032fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803300:	8b 40 08             	mov    0x8(%eax),%eax
  803303:	39 c2                	cmp    %eax,%edx
  803305:	0f 85 9c 00 00 00    	jne    8033a7 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  80330b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330e:	8b 50 0c             	mov    0xc(%eax),%edx
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	8b 40 0c             	mov    0xc(%eax),%eax
  803317:	01 c2                	add    %eax,%edx
  803319:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331c:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	8b 50 08             	mov    0x8(%eax),%edx
  803325:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803328:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80333f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803343:	75 17                	jne    80335c <insert_sorted_with_merge_freeList+0x2a5>
  803345:	83 ec 04             	sub    $0x4,%esp
  803348:	68 88 43 80 00       	push   $0x804388
  80334d:	68 4d 01 00 00       	push   $0x14d
  803352:	68 ab 43 80 00       	push   $0x8043ab
  803357:	e8 7b d5 ff ff       	call   8008d7 <_panic>
  80335c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803362:	8b 45 08             	mov    0x8(%ebp),%eax
  803365:	89 10                	mov    %edx,(%eax)
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	8b 00                	mov    (%eax),%eax
  80336c:	85 c0                	test   %eax,%eax
  80336e:	74 0d                	je     80337d <insert_sorted_with_merge_freeList+0x2c6>
  803370:	a1 48 51 80 00       	mov    0x805148,%eax
  803375:	8b 55 08             	mov    0x8(%ebp),%edx
  803378:	89 50 04             	mov    %edx,0x4(%eax)
  80337b:	eb 08                	jmp    803385 <insert_sorted_with_merge_freeList+0x2ce>
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	a3 48 51 80 00       	mov    %eax,0x805148
  80338d:	8b 45 08             	mov    0x8(%ebp),%eax
  803390:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803397:	a1 54 51 80 00       	mov    0x805154,%eax
  80339c:	40                   	inc    %eax
  80339d:	a3 54 51 80 00       	mov    %eax,0x805154





}
  8033a2:	e9 56 04 00 00       	jmp    8037fd <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8033a7:	a1 38 51 80 00       	mov    0x805138,%eax
  8033ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033af:	e9 19 04 00 00       	jmp    8037cd <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  8033b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b7:	8b 00                	mov    (%eax),%eax
  8033b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  8033bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bf:	8b 50 08             	mov    0x8(%eax),%edx
  8033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c8:	01 c2                	add    %eax,%edx
  8033ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cd:	8b 40 08             	mov    0x8(%eax),%eax
  8033d0:	39 c2                	cmp    %eax,%edx
  8033d2:	0f 85 ad 01 00 00    	jne    803585 <insert_sorted_with_merge_freeList+0x4ce>
  8033d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033db:	8b 50 08             	mov    0x8(%eax),%edx
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e4:	01 c2                	add    %eax,%edx
  8033e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e9:	8b 40 08             	mov    0x8(%eax),%eax
  8033ec:	39 c2                	cmp    %eax,%edx
  8033ee:	0f 85 91 01 00 00    	jne    803585 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  8033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f7:	8b 50 0c             	mov    0xc(%eax),%edx
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	8b 48 0c             	mov    0xc(%eax),%ecx
  803400:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803403:	8b 40 0c             	mov    0xc(%eax),%eax
  803406:	01 c8                	add    %ecx,%eax
  803408:	01 c2                	add    %eax,%edx
  80340a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340d:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  803410:	8b 45 08             	mov    0x8(%ebp),%eax
  803413:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  80341a:	8b 45 08             	mov    0x8(%ebp),%eax
  80341d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  803424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803427:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  80342e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803431:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  803438:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80343c:	75 17                	jne    803455 <insert_sorted_with_merge_freeList+0x39e>
  80343e:	83 ec 04             	sub    $0x4,%esp
  803441:	68 1c 44 80 00       	push   $0x80441c
  803446:	68 5b 01 00 00       	push   $0x15b
  80344b:	68 ab 43 80 00       	push   $0x8043ab
  803450:	e8 82 d4 ff ff       	call   8008d7 <_panic>
  803455:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803458:	8b 00                	mov    (%eax),%eax
  80345a:	85 c0                	test   %eax,%eax
  80345c:	74 10                	je     80346e <insert_sorted_with_merge_freeList+0x3b7>
  80345e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803461:	8b 00                	mov    (%eax),%eax
  803463:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803466:	8b 52 04             	mov    0x4(%edx),%edx
  803469:	89 50 04             	mov    %edx,0x4(%eax)
  80346c:	eb 0b                	jmp    803479 <insert_sorted_with_merge_freeList+0x3c2>
  80346e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803471:	8b 40 04             	mov    0x4(%eax),%eax
  803474:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347c:	8b 40 04             	mov    0x4(%eax),%eax
  80347f:	85 c0                	test   %eax,%eax
  803481:	74 0f                	je     803492 <insert_sorted_with_merge_freeList+0x3db>
  803483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803486:	8b 40 04             	mov    0x4(%eax),%eax
  803489:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80348c:	8b 12                	mov    (%edx),%edx
  80348e:	89 10                	mov    %edx,(%eax)
  803490:	eb 0a                	jmp    80349c <insert_sorted_with_merge_freeList+0x3e5>
  803492:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803495:	8b 00                	mov    (%eax),%eax
  803497:	a3 38 51 80 00       	mov    %eax,0x805138
  80349c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80349f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034af:	a1 44 51 80 00       	mov    0x805144,%eax
  8034b4:	48                   	dec    %eax
  8034b5:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034be:	75 17                	jne    8034d7 <insert_sorted_with_merge_freeList+0x420>
  8034c0:	83 ec 04             	sub    $0x4,%esp
  8034c3:	68 88 43 80 00       	push   $0x804388
  8034c8:	68 5c 01 00 00       	push   $0x15c
  8034cd:	68 ab 43 80 00       	push   $0x8043ab
  8034d2:	e8 00 d4 ff ff       	call   8008d7 <_panic>
  8034d7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e0:	89 10                	mov    %edx,(%eax)
  8034e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e5:	8b 00                	mov    (%eax),%eax
  8034e7:	85 c0                	test   %eax,%eax
  8034e9:	74 0d                	je     8034f8 <insert_sorted_with_merge_freeList+0x441>
  8034eb:	a1 48 51 80 00       	mov    0x805148,%eax
  8034f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f3:	89 50 04             	mov    %edx,0x4(%eax)
  8034f6:	eb 08                	jmp    803500 <insert_sorted_with_merge_freeList+0x449>
  8034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803500:	8b 45 08             	mov    0x8(%ebp),%eax
  803503:	a3 48 51 80 00       	mov    %eax,0x805148
  803508:	8b 45 08             	mov    0x8(%ebp),%eax
  80350b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803512:	a1 54 51 80 00       	mov    0x805154,%eax
  803517:	40                   	inc    %eax
  803518:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  80351d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803521:	75 17                	jne    80353a <insert_sorted_with_merge_freeList+0x483>
  803523:	83 ec 04             	sub    $0x4,%esp
  803526:	68 88 43 80 00       	push   $0x804388
  80352b:	68 5d 01 00 00       	push   $0x15d
  803530:	68 ab 43 80 00       	push   $0x8043ab
  803535:	e8 9d d3 ff ff       	call   8008d7 <_panic>
  80353a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803543:	89 10                	mov    %edx,(%eax)
  803545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803548:	8b 00                	mov    (%eax),%eax
  80354a:	85 c0                	test   %eax,%eax
  80354c:	74 0d                	je     80355b <insert_sorted_with_merge_freeList+0x4a4>
  80354e:	a1 48 51 80 00       	mov    0x805148,%eax
  803553:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803556:	89 50 04             	mov    %edx,0x4(%eax)
  803559:	eb 08                	jmp    803563 <insert_sorted_with_merge_freeList+0x4ac>
  80355b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80355e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803566:	a3 48 51 80 00       	mov    %eax,0x805148
  80356b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803575:	a1 54 51 80 00       	mov    0x805154,%eax
  80357a:	40                   	inc    %eax
  80357b:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803580:	e9 78 02 00 00       	jmp    8037fd <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803588:	8b 50 08             	mov    0x8(%eax),%edx
  80358b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358e:	8b 40 0c             	mov    0xc(%eax),%eax
  803591:	01 c2                	add    %eax,%edx
  803593:	8b 45 08             	mov    0x8(%ebp),%eax
  803596:	8b 40 08             	mov    0x8(%eax),%eax
  803599:	39 c2                	cmp    %eax,%edx
  80359b:	0f 83 b8 00 00 00    	jae    803659 <insert_sorted_with_merge_freeList+0x5a2>
  8035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a4:	8b 50 08             	mov    0x8(%eax),%edx
  8035a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ad:	01 c2                	add    %eax,%edx
  8035af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b2:	8b 40 08             	mov    0x8(%eax),%eax
  8035b5:	39 c2                	cmp    %eax,%edx
  8035b7:	0f 85 9c 00 00 00    	jne    803659 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  8035bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c0:	8b 50 0c             	mov    0xc(%eax),%edx
  8035c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c9:	01 c2                	add    %eax,%edx
  8035cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ce:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  8035d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d4:	8b 50 08             	mov    0x8(%eax),%edx
  8035d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035da:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  8035dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8035e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8035f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f5:	75 17                	jne    80360e <insert_sorted_with_merge_freeList+0x557>
  8035f7:	83 ec 04             	sub    $0x4,%esp
  8035fa:	68 88 43 80 00       	push   $0x804388
  8035ff:	68 67 01 00 00       	push   $0x167
  803604:	68 ab 43 80 00       	push   $0x8043ab
  803609:	e8 c9 d2 ff ff       	call   8008d7 <_panic>
  80360e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803614:	8b 45 08             	mov    0x8(%ebp),%eax
  803617:	89 10                	mov    %edx,(%eax)
  803619:	8b 45 08             	mov    0x8(%ebp),%eax
  80361c:	8b 00                	mov    (%eax),%eax
  80361e:	85 c0                	test   %eax,%eax
  803620:	74 0d                	je     80362f <insert_sorted_with_merge_freeList+0x578>
  803622:	a1 48 51 80 00       	mov    0x805148,%eax
  803627:	8b 55 08             	mov    0x8(%ebp),%edx
  80362a:	89 50 04             	mov    %edx,0x4(%eax)
  80362d:	eb 08                	jmp    803637 <insert_sorted_with_merge_freeList+0x580>
  80362f:	8b 45 08             	mov    0x8(%ebp),%eax
  803632:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803637:	8b 45 08             	mov    0x8(%ebp),%eax
  80363a:	a3 48 51 80 00       	mov    %eax,0x805148
  80363f:	8b 45 08             	mov    0x8(%ebp),%eax
  803642:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803649:	a1 54 51 80 00       	mov    0x805154,%eax
  80364e:	40                   	inc    %eax
  80364f:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803654:	e9 a4 01 00 00       	jmp    8037fd <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365c:	8b 50 08             	mov    0x8(%eax),%edx
  80365f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803662:	8b 40 0c             	mov    0xc(%eax),%eax
  803665:	01 c2                	add    %eax,%edx
  803667:	8b 45 08             	mov    0x8(%ebp),%eax
  80366a:	8b 40 08             	mov    0x8(%eax),%eax
  80366d:	39 c2                	cmp    %eax,%edx
  80366f:	0f 85 ac 00 00 00    	jne    803721 <insert_sorted_with_merge_freeList+0x66a>
  803675:	8b 45 08             	mov    0x8(%ebp),%eax
  803678:	8b 50 08             	mov    0x8(%eax),%edx
  80367b:	8b 45 08             	mov    0x8(%ebp),%eax
  80367e:	8b 40 0c             	mov    0xc(%eax),%eax
  803681:	01 c2                	add    %eax,%edx
  803683:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803686:	8b 40 08             	mov    0x8(%eax),%eax
  803689:	39 c2                	cmp    %eax,%edx
  80368b:	0f 83 90 00 00 00    	jae    803721 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  803691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803694:	8b 50 0c             	mov    0xc(%eax),%edx
  803697:	8b 45 08             	mov    0x8(%ebp),%eax
  80369a:	8b 40 0c             	mov    0xc(%eax),%eax
  80369d:	01 c2                	add    %eax,%edx
  80369f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a2:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  8036a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  8036af:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8036b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036bd:	75 17                	jne    8036d6 <insert_sorted_with_merge_freeList+0x61f>
  8036bf:	83 ec 04             	sub    $0x4,%esp
  8036c2:	68 88 43 80 00       	push   $0x804388
  8036c7:	68 70 01 00 00       	push   $0x170
  8036cc:	68 ab 43 80 00       	push   $0x8043ab
  8036d1:	e8 01 d2 ff ff       	call   8008d7 <_panic>
  8036d6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036df:	89 10                	mov    %edx,(%eax)
  8036e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e4:	8b 00                	mov    (%eax),%eax
  8036e6:	85 c0                	test   %eax,%eax
  8036e8:	74 0d                	je     8036f7 <insert_sorted_with_merge_freeList+0x640>
  8036ea:	a1 48 51 80 00       	mov    0x805148,%eax
  8036ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f2:	89 50 04             	mov    %edx,0x4(%eax)
  8036f5:	eb 08                	jmp    8036ff <insert_sorted_with_merge_freeList+0x648>
  8036f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803702:	a3 48 51 80 00       	mov    %eax,0x805148
  803707:	8b 45 08             	mov    0x8(%ebp),%eax
  80370a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803711:	a1 54 51 80 00       	mov    0x805154,%eax
  803716:	40                   	inc    %eax
  803717:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  80371c:	e9 dc 00 00 00       	jmp    8037fd <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803724:	8b 50 08             	mov    0x8(%eax),%edx
  803727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372a:	8b 40 0c             	mov    0xc(%eax),%eax
  80372d:	01 c2                	add    %eax,%edx
  80372f:	8b 45 08             	mov    0x8(%ebp),%eax
  803732:	8b 40 08             	mov    0x8(%eax),%eax
  803735:	39 c2                	cmp    %eax,%edx
  803737:	0f 83 88 00 00 00    	jae    8037c5 <insert_sorted_with_merge_freeList+0x70e>
  80373d:	8b 45 08             	mov    0x8(%ebp),%eax
  803740:	8b 50 08             	mov    0x8(%eax),%edx
  803743:	8b 45 08             	mov    0x8(%ebp),%eax
  803746:	8b 40 0c             	mov    0xc(%eax),%eax
  803749:	01 c2                	add    %eax,%edx
  80374b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80374e:	8b 40 08             	mov    0x8(%eax),%eax
  803751:	39 c2                	cmp    %eax,%edx
  803753:	73 70                	jae    8037c5 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803755:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803759:	74 06                	je     803761 <insert_sorted_with_merge_freeList+0x6aa>
  80375b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80375f:	75 17                	jne    803778 <insert_sorted_with_merge_freeList+0x6c1>
  803761:	83 ec 04             	sub    $0x4,%esp
  803764:	68 e8 43 80 00       	push   $0x8043e8
  803769:	68 75 01 00 00       	push   $0x175
  80376e:	68 ab 43 80 00       	push   $0x8043ab
  803773:	e8 5f d1 ff ff       	call   8008d7 <_panic>
  803778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377b:	8b 10                	mov    (%eax),%edx
  80377d:	8b 45 08             	mov    0x8(%ebp),%eax
  803780:	89 10                	mov    %edx,(%eax)
  803782:	8b 45 08             	mov    0x8(%ebp),%eax
  803785:	8b 00                	mov    (%eax),%eax
  803787:	85 c0                	test   %eax,%eax
  803789:	74 0b                	je     803796 <insert_sorted_with_merge_freeList+0x6df>
  80378b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378e:	8b 00                	mov    (%eax),%eax
  803790:	8b 55 08             	mov    0x8(%ebp),%edx
  803793:	89 50 04             	mov    %edx,0x4(%eax)
  803796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803799:	8b 55 08             	mov    0x8(%ebp),%edx
  80379c:	89 10                	mov    %edx,(%eax)
  80379e:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037a4:	89 50 04             	mov    %edx,0x4(%eax)
  8037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037aa:	8b 00                	mov    (%eax),%eax
  8037ac:	85 c0                	test   %eax,%eax
  8037ae:	75 08                	jne    8037b8 <insert_sorted_with_merge_freeList+0x701>
  8037b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037b8:	a1 44 51 80 00       	mov    0x805144,%eax
  8037bd:	40                   	inc    %eax
  8037be:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  8037c3:	eb 38                	jmp    8037fd <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8037c5:	a1 40 51 80 00       	mov    0x805140,%eax
  8037ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037d1:	74 07                	je     8037da <insert_sorted_with_merge_freeList+0x723>
  8037d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d6:	8b 00                	mov    (%eax),%eax
  8037d8:	eb 05                	jmp    8037df <insert_sorted_with_merge_freeList+0x728>
  8037da:	b8 00 00 00 00       	mov    $0x0,%eax
  8037df:	a3 40 51 80 00       	mov    %eax,0x805140
  8037e4:	a1 40 51 80 00       	mov    0x805140,%eax
  8037e9:	85 c0                	test   %eax,%eax
  8037eb:	0f 85 c3 fb ff ff    	jne    8033b4 <insert_sorted_with_merge_freeList+0x2fd>
  8037f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037f5:	0f 85 b9 fb ff ff    	jne    8033b4 <insert_sorted_with_merge_freeList+0x2fd>





}
  8037fb:	eb 00                	jmp    8037fd <insert_sorted_with_merge_freeList+0x746>
  8037fd:	90                   	nop
  8037fe:	c9                   	leave  
  8037ff:	c3                   	ret    

00803800 <__udivdi3>:
  803800:	55                   	push   %ebp
  803801:	57                   	push   %edi
  803802:	56                   	push   %esi
  803803:	53                   	push   %ebx
  803804:	83 ec 1c             	sub    $0x1c,%esp
  803807:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80380b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80380f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803813:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803817:	89 ca                	mov    %ecx,%edx
  803819:	89 f8                	mov    %edi,%eax
  80381b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80381f:	85 f6                	test   %esi,%esi
  803821:	75 2d                	jne    803850 <__udivdi3+0x50>
  803823:	39 cf                	cmp    %ecx,%edi
  803825:	77 65                	ja     80388c <__udivdi3+0x8c>
  803827:	89 fd                	mov    %edi,%ebp
  803829:	85 ff                	test   %edi,%edi
  80382b:	75 0b                	jne    803838 <__udivdi3+0x38>
  80382d:	b8 01 00 00 00       	mov    $0x1,%eax
  803832:	31 d2                	xor    %edx,%edx
  803834:	f7 f7                	div    %edi
  803836:	89 c5                	mov    %eax,%ebp
  803838:	31 d2                	xor    %edx,%edx
  80383a:	89 c8                	mov    %ecx,%eax
  80383c:	f7 f5                	div    %ebp
  80383e:	89 c1                	mov    %eax,%ecx
  803840:	89 d8                	mov    %ebx,%eax
  803842:	f7 f5                	div    %ebp
  803844:	89 cf                	mov    %ecx,%edi
  803846:	89 fa                	mov    %edi,%edx
  803848:	83 c4 1c             	add    $0x1c,%esp
  80384b:	5b                   	pop    %ebx
  80384c:	5e                   	pop    %esi
  80384d:	5f                   	pop    %edi
  80384e:	5d                   	pop    %ebp
  80384f:	c3                   	ret    
  803850:	39 ce                	cmp    %ecx,%esi
  803852:	77 28                	ja     80387c <__udivdi3+0x7c>
  803854:	0f bd fe             	bsr    %esi,%edi
  803857:	83 f7 1f             	xor    $0x1f,%edi
  80385a:	75 40                	jne    80389c <__udivdi3+0x9c>
  80385c:	39 ce                	cmp    %ecx,%esi
  80385e:	72 0a                	jb     80386a <__udivdi3+0x6a>
  803860:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803864:	0f 87 9e 00 00 00    	ja     803908 <__udivdi3+0x108>
  80386a:	b8 01 00 00 00       	mov    $0x1,%eax
  80386f:	89 fa                	mov    %edi,%edx
  803871:	83 c4 1c             	add    $0x1c,%esp
  803874:	5b                   	pop    %ebx
  803875:	5e                   	pop    %esi
  803876:	5f                   	pop    %edi
  803877:	5d                   	pop    %ebp
  803878:	c3                   	ret    
  803879:	8d 76 00             	lea    0x0(%esi),%esi
  80387c:	31 ff                	xor    %edi,%edi
  80387e:	31 c0                	xor    %eax,%eax
  803880:	89 fa                	mov    %edi,%edx
  803882:	83 c4 1c             	add    $0x1c,%esp
  803885:	5b                   	pop    %ebx
  803886:	5e                   	pop    %esi
  803887:	5f                   	pop    %edi
  803888:	5d                   	pop    %ebp
  803889:	c3                   	ret    
  80388a:	66 90                	xchg   %ax,%ax
  80388c:	89 d8                	mov    %ebx,%eax
  80388e:	f7 f7                	div    %edi
  803890:	31 ff                	xor    %edi,%edi
  803892:	89 fa                	mov    %edi,%edx
  803894:	83 c4 1c             	add    $0x1c,%esp
  803897:	5b                   	pop    %ebx
  803898:	5e                   	pop    %esi
  803899:	5f                   	pop    %edi
  80389a:	5d                   	pop    %ebp
  80389b:	c3                   	ret    
  80389c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038a1:	89 eb                	mov    %ebp,%ebx
  8038a3:	29 fb                	sub    %edi,%ebx
  8038a5:	89 f9                	mov    %edi,%ecx
  8038a7:	d3 e6                	shl    %cl,%esi
  8038a9:	89 c5                	mov    %eax,%ebp
  8038ab:	88 d9                	mov    %bl,%cl
  8038ad:	d3 ed                	shr    %cl,%ebp
  8038af:	89 e9                	mov    %ebp,%ecx
  8038b1:	09 f1                	or     %esi,%ecx
  8038b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038b7:	89 f9                	mov    %edi,%ecx
  8038b9:	d3 e0                	shl    %cl,%eax
  8038bb:	89 c5                	mov    %eax,%ebp
  8038bd:	89 d6                	mov    %edx,%esi
  8038bf:	88 d9                	mov    %bl,%cl
  8038c1:	d3 ee                	shr    %cl,%esi
  8038c3:	89 f9                	mov    %edi,%ecx
  8038c5:	d3 e2                	shl    %cl,%edx
  8038c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038cb:	88 d9                	mov    %bl,%cl
  8038cd:	d3 e8                	shr    %cl,%eax
  8038cf:	09 c2                	or     %eax,%edx
  8038d1:	89 d0                	mov    %edx,%eax
  8038d3:	89 f2                	mov    %esi,%edx
  8038d5:	f7 74 24 0c          	divl   0xc(%esp)
  8038d9:	89 d6                	mov    %edx,%esi
  8038db:	89 c3                	mov    %eax,%ebx
  8038dd:	f7 e5                	mul    %ebp
  8038df:	39 d6                	cmp    %edx,%esi
  8038e1:	72 19                	jb     8038fc <__udivdi3+0xfc>
  8038e3:	74 0b                	je     8038f0 <__udivdi3+0xf0>
  8038e5:	89 d8                	mov    %ebx,%eax
  8038e7:	31 ff                	xor    %edi,%edi
  8038e9:	e9 58 ff ff ff       	jmp    803846 <__udivdi3+0x46>
  8038ee:	66 90                	xchg   %ax,%ax
  8038f0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038f4:	89 f9                	mov    %edi,%ecx
  8038f6:	d3 e2                	shl    %cl,%edx
  8038f8:	39 c2                	cmp    %eax,%edx
  8038fa:	73 e9                	jae    8038e5 <__udivdi3+0xe5>
  8038fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038ff:	31 ff                	xor    %edi,%edi
  803901:	e9 40 ff ff ff       	jmp    803846 <__udivdi3+0x46>
  803906:	66 90                	xchg   %ax,%ax
  803908:	31 c0                	xor    %eax,%eax
  80390a:	e9 37 ff ff ff       	jmp    803846 <__udivdi3+0x46>
  80390f:	90                   	nop

00803910 <__umoddi3>:
  803910:	55                   	push   %ebp
  803911:	57                   	push   %edi
  803912:	56                   	push   %esi
  803913:	53                   	push   %ebx
  803914:	83 ec 1c             	sub    $0x1c,%esp
  803917:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80391b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80391f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803923:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803927:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80392b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80392f:	89 f3                	mov    %esi,%ebx
  803931:	89 fa                	mov    %edi,%edx
  803933:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803937:	89 34 24             	mov    %esi,(%esp)
  80393a:	85 c0                	test   %eax,%eax
  80393c:	75 1a                	jne    803958 <__umoddi3+0x48>
  80393e:	39 f7                	cmp    %esi,%edi
  803940:	0f 86 a2 00 00 00    	jbe    8039e8 <__umoddi3+0xd8>
  803946:	89 c8                	mov    %ecx,%eax
  803948:	89 f2                	mov    %esi,%edx
  80394a:	f7 f7                	div    %edi
  80394c:	89 d0                	mov    %edx,%eax
  80394e:	31 d2                	xor    %edx,%edx
  803950:	83 c4 1c             	add    $0x1c,%esp
  803953:	5b                   	pop    %ebx
  803954:	5e                   	pop    %esi
  803955:	5f                   	pop    %edi
  803956:	5d                   	pop    %ebp
  803957:	c3                   	ret    
  803958:	39 f0                	cmp    %esi,%eax
  80395a:	0f 87 ac 00 00 00    	ja     803a0c <__umoddi3+0xfc>
  803960:	0f bd e8             	bsr    %eax,%ebp
  803963:	83 f5 1f             	xor    $0x1f,%ebp
  803966:	0f 84 ac 00 00 00    	je     803a18 <__umoddi3+0x108>
  80396c:	bf 20 00 00 00       	mov    $0x20,%edi
  803971:	29 ef                	sub    %ebp,%edi
  803973:	89 fe                	mov    %edi,%esi
  803975:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803979:	89 e9                	mov    %ebp,%ecx
  80397b:	d3 e0                	shl    %cl,%eax
  80397d:	89 d7                	mov    %edx,%edi
  80397f:	89 f1                	mov    %esi,%ecx
  803981:	d3 ef                	shr    %cl,%edi
  803983:	09 c7                	or     %eax,%edi
  803985:	89 e9                	mov    %ebp,%ecx
  803987:	d3 e2                	shl    %cl,%edx
  803989:	89 14 24             	mov    %edx,(%esp)
  80398c:	89 d8                	mov    %ebx,%eax
  80398e:	d3 e0                	shl    %cl,%eax
  803990:	89 c2                	mov    %eax,%edx
  803992:	8b 44 24 08          	mov    0x8(%esp),%eax
  803996:	d3 e0                	shl    %cl,%eax
  803998:	89 44 24 04          	mov    %eax,0x4(%esp)
  80399c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039a0:	89 f1                	mov    %esi,%ecx
  8039a2:	d3 e8                	shr    %cl,%eax
  8039a4:	09 d0                	or     %edx,%eax
  8039a6:	d3 eb                	shr    %cl,%ebx
  8039a8:	89 da                	mov    %ebx,%edx
  8039aa:	f7 f7                	div    %edi
  8039ac:	89 d3                	mov    %edx,%ebx
  8039ae:	f7 24 24             	mull   (%esp)
  8039b1:	89 c6                	mov    %eax,%esi
  8039b3:	89 d1                	mov    %edx,%ecx
  8039b5:	39 d3                	cmp    %edx,%ebx
  8039b7:	0f 82 87 00 00 00    	jb     803a44 <__umoddi3+0x134>
  8039bd:	0f 84 91 00 00 00    	je     803a54 <__umoddi3+0x144>
  8039c3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039c7:	29 f2                	sub    %esi,%edx
  8039c9:	19 cb                	sbb    %ecx,%ebx
  8039cb:	89 d8                	mov    %ebx,%eax
  8039cd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039d1:	d3 e0                	shl    %cl,%eax
  8039d3:	89 e9                	mov    %ebp,%ecx
  8039d5:	d3 ea                	shr    %cl,%edx
  8039d7:	09 d0                	or     %edx,%eax
  8039d9:	89 e9                	mov    %ebp,%ecx
  8039db:	d3 eb                	shr    %cl,%ebx
  8039dd:	89 da                	mov    %ebx,%edx
  8039df:	83 c4 1c             	add    $0x1c,%esp
  8039e2:	5b                   	pop    %ebx
  8039e3:	5e                   	pop    %esi
  8039e4:	5f                   	pop    %edi
  8039e5:	5d                   	pop    %ebp
  8039e6:	c3                   	ret    
  8039e7:	90                   	nop
  8039e8:	89 fd                	mov    %edi,%ebp
  8039ea:	85 ff                	test   %edi,%edi
  8039ec:	75 0b                	jne    8039f9 <__umoddi3+0xe9>
  8039ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8039f3:	31 d2                	xor    %edx,%edx
  8039f5:	f7 f7                	div    %edi
  8039f7:	89 c5                	mov    %eax,%ebp
  8039f9:	89 f0                	mov    %esi,%eax
  8039fb:	31 d2                	xor    %edx,%edx
  8039fd:	f7 f5                	div    %ebp
  8039ff:	89 c8                	mov    %ecx,%eax
  803a01:	f7 f5                	div    %ebp
  803a03:	89 d0                	mov    %edx,%eax
  803a05:	e9 44 ff ff ff       	jmp    80394e <__umoddi3+0x3e>
  803a0a:	66 90                	xchg   %ax,%ax
  803a0c:	89 c8                	mov    %ecx,%eax
  803a0e:	89 f2                	mov    %esi,%edx
  803a10:	83 c4 1c             	add    $0x1c,%esp
  803a13:	5b                   	pop    %ebx
  803a14:	5e                   	pop    %esi
  803a15:	5f                   	pop    %edi
  803a16:	5d                   	pop    %ebp
  803a17:	c3                   	ret    
  803a18:	3b 04 24             	cmp    (%esp),%eax
  803a1b:	72 06                	jb     803a23 <__umoddi3+0x113>
  803a1d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a21:	77 0f                	ja     803a32 <__umoddi3+0x122>
  803a23:	89 f2                	mov    %esi,%edx
  803a25:	29 f9                	sub    %edi,%ecx
  803a27:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a2b:	89 14 24             	mov    %edx,(%esp)
  803a2e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a32:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a36:	8b 14 24             	mov    (%esp),%edx
  803a39:	83 c4 1c             	add    $0x1c,%esp
  803a3c:	5b                   	pop    %ebx
  803a3d:	5e                   	pop    %esi
  803a3e:	5f                   	pop    %edi
  803a3f:	5d                   	pop    %ebp
  803a40:	c3                   	ret    
  803a41:	8d 76 00             	lea    0x0(%esi),%esi
  803a44:	2b 04 24             	sub    (%esp),%eax
  803a47:	19 fa                	sbb    %edi,%edx
  803a49:	89 d1                	mov    %edx,%ecx
  803a4b:	89 c6                	mov    %eax,%esi
  803a4d:	e9 71 ff ff ff       	jmp    8039c3 <__umoddi3+0xb3>
  803a52:	66 90                	xchg   %ax,%ax
  803a54:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a58:	72 ea                	jb     803a44 <__umoddi3+0x134>
  803a5a:	89 d9                	mov    %ebx,%ecx
  803a5c:	e9 62 ff ff ff       	jmp    8039c3 <__umoddi3+0xb3>
