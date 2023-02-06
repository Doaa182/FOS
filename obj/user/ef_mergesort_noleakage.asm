
obj/user/ef_mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 81 07 00 00       	call   8007b7 <libmain>
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
  800041:	e8 06 20 00 00       	call   80204c <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 80 38 80 00       	push   $0x803880
  80004e:	e8 54 0b 00 00       	call   800ba7 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 82 38 80 00       	push   $0x803882
  80005e:	e8 44 0b 00 00       	call   800ba7 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 98 38 80 00       	push   $0x803898
  80006e:	e8 34 0b 00 00       	call   800ba7 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 82 38 80 00       	push   $0x803882
  80007e:	e8 24 0b 00 00       	call   800ba7 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 80 38 80 00       	push   $0x803880
  80008e:	e8 14 0b 00 00       	call   800ba7 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 b0 38 80 00       	push   $0x8038b0
  80009e:	e8 04 0b 00 00       	call   800ba7 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 cf 38 80 00       	push   $0x8038cf
  8000b8:	e8 ea 0a 00 00       	call   800ba7 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c3:	c1 e0 02             	shl    $0x2,%eax
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	50                   	push   %eax
  8000ca:	e8 51 1a 00 00       	call   801b20 <malloc>
  8000cf:	83 c4 10             	add    $0x10,%esp
  8000d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 d4 38 80 00       	push   $0x8038d4
  8000dd:	e8 c5 0a 00 00       	call   800ba7 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 f6 38 80 00       	push   $0x8038f6
  8000ed:	e8 b5 0a 00 00       	call   800ba7 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 04 39 80 00       	push   $0x803904
  8000fd:	e8 a5 0a 00 00       	call   800ba7 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 13 39 80 00       	push   $0x803913
  80010d:	e8 95 0a 00 00       	call   800ba7 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 23 39 80 00       	push   $0x803923
  80011d:	e8 85 0a 00 00       	call   800ba7 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
			//Chose = getchar() ;
			Chose = 'a';
  800125:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
			cputchar(Chose);
  800129:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	50                   	push   %eax
  800131:	e8 e1 05 00 00       	call   800717 <cputchar>
  800136:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	e8 d4 05 00 00       	call   800717 <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800146:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80014a:	74 0c                	je     800158 <_main+0x120>
  80014c:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800150:	74 06                	je     800158 <_main+0x120>
  800152:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800156:	75 bd                	jne    800115 <_main+0xdd>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800158:	e8 09 1f 00 00       	call   802066 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80015d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800161:	83 f8 62             	cmp    $0x62,%eax
  800164:	74 1d                	je     800183 <_main+0x14b>
  800166:	83 f8 63             	cmp    $0x63,%eax
  800169:	74 2b                	je     800196 <_main+0x15e>
  80016b:	83 f8 61             	cmp    $0x61,%eax
  80016e:	75 39                	jne    8001a9 <_main+0x171>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	ff 75 f0             	pushl  -0x10(%ebp)
  800176:	ff 75 ec             	pushl  -0x14(%ebp)
  800179:	e8 f0 01 00 00       	call   80036e <InitializeAscending>
  80017e:	83 c4 10             	add    $0x10,%esp
			break ;
  800181:	eb 37                	jmp    8001ba <_main+0x182>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 f0             	pushl  -0x10(%ebp)
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	e8 0e 02 00 00       	call   80039f <InitializeDescending>
  800191:	83 c4 10             	add    $0x10,%esp
			break ;
  800194:	eb 24                	jmp    8001ba <_main+0x182>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	ff 75 f0             	pushl  -0x10(%ebp)
  80019c:	ff 75 ec             	pushl  -0x14(%ebp)
  80019f:	e8 30 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001a4:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a7:	eb 11                	jmp    8001ba <_main+0x182>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8001af:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b2:	e8 1d 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001b7:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8001c0:	6a 01                	push   $0x1
  8001c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c5:	e8 dc 02 00 00       	call   8004a6 <MSort>
  8001ca:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001cd:	e8 7a 1e 00 00       	call   80204c <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 2c 39 80 00       	push   $0x80392c
  8001da:	e8 c8 09 00 00       	call   800ba7 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001e2:	e8 7f 1e 00 00       	call   802066 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 cf 00 00 00       	call   8002c4 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 60 39 80 00       	push   $0x803960
  800209:	6a 4e                	push   $0x4e
  80020b:	68 82 39 80 00       	push   $0x803982
  800210:	e8 de 06 00 00       	call   8008f3 <_panic>
		else
		{
			sys_disable_interrupt();
  800215:	e8 32 1e 00 00       	call   80204c <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 a0 39 80 00       	push   $0x8039a0
  800222:	e8 80 09 00 00       	call   800ba7 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 d4 39 80 00       	push   $0x8039d4
  800232:	e8 70 09 00 00       	call   800ba7 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 08 3a 80 00       	push   $0x803a08
  800242:	e8 60 09 00 00       	call   800ba7 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80024a:	e8 17 1e 00 00       	call   802066 <sys_enable_interrupt>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 5d 19 00 00       	call   801bb7 <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  80025d:	e8 ea 1d 00 00       	call   80204c <sys_disable_interrupt>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 3a 3a 80 00       	push   $0x803a3a
  800270:	e8 32 09 00 00       	call   800ba7 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = 'n' ;
  800278:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 8e 04 00 00       	call   800717 <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 81 04 00 00       	call   800717 <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 74 04 00 00       	call   800717 <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b6                	jne    800268 <_main+0x230>
				Chose = 'n' ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 af 1d 00 00       	call   802066 <sys_enable_interrupt>

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
  800446:	68 80 38 80 00       	push   $0x803880
  80044b:	e8 57 07 00 00       	call   800ba7 <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 58 3a 80 00       	push   $0x803a58
  80046d:	e8 35 07 00 00       	call   800ba7 <cprintf>
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
  800496:	68 cf 38 80 00       	push   $0x8038cf
  80049b:	e8 07 07 00 00       	call   800ba7 <cprintf>
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
  80053c:	e8 df 15 00 00       	call   801b20 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 ca 15 00 00       	call   801b20 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

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
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

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

	free(Left);
  8006f8:	83 ec 0c             	sub    $0xc,%esp
  8006fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fe:	e8 b4 14 00 00       	call   801bb7 <free>
  800703:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d4             	pushl  -0x2c(%ebp)
  80070c:	e8 a6 14 00 00       	call   801bb7 <free>
  800711:	83 c4 10             	add    $0x10,%esp

}
  800714:	90                   	nop
  800715:	c9                   	leave  
  800716:	c3                   	ret    

00800717 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800723:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	50                   	push   %eax
  80072b:	e8 50 19 00 00       	call   802080 <sys_cputc>
  800730:	83 c4 10             	add    $0x10,%esp
}
  800733:	90                   	nop
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
  800739:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80073c:	e8 0b 19 00 00       	call   80204c <sys_disable_interrupt>
	char c = ch;
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800747:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80074b:	83 ec 0c             	sub    $0xc,%esp
  80074e:	50                   	push   %eax
  80074f:	e8 2c 19 00 00       	call   802080 <sys_cputc>
  800754:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800757:	e8 0a 19 00 00       	call   802066 <sys_enable_interrupt>
}
  80075c:	90                   	nop
  80075d:	c9                   	leave  
  80075e:	c3                   	ret    

0080075f <getchar>:

int
getchar(void)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800765:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80076c:	eb 08                	jmp    800776 <getchar+0x17>
	{
		c = sys_cgetc();
  80076e:	e8 54 17 00 00       	call   801ec7 <sys_cgetc>
  800773:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80077a:	74 f2                	je     80076e <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80077f:	c9                   	leave  
  800780:	c3                   	ret    

00800781 <atomic_getchar>:

int
atomic_getchar(void)
{
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800787:	e8 c0 18 00 00       	call   80204c <sys_disable_interrupt>
	int c=0;
  80078c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800793:	eb 08                	jmp    80079d <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800795:	e8 2d 17 00 00       	call   801ec7 <sys_cgetc>
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80079d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007a1:	74 f2                	je     800795 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007a3:	e8 be 18 00 00       	call   802066 <sys_enable_interrupt>
	return c;
  8007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007ab:	c9                   	leave  
  8007ac:	c3                   	ret    

008007ad <iscons>:

int iscons(int fdnum)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007b0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007bd:	e8 7d 1a 00 00       	call   80223f <sys_getenvindex>
  8007c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c8:	89 d0                	mov    %edx,%eax
  8007ca:	c1 e0 03             	shl    $0x3,%eax
  8007cd:	01 d0                	add    %edx,%eax
  8007cf:	01 c0                	add    %eax,%eax
  8007d1:	01 d0                	add    %edx,%eax
  8007d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007da:	01 d0                	add    %edx,%eax
  8007dc:	c1 e0 04             	shl    $0x4,%eax
  8007df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007e4:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007e9:	a1 24 50 80 00       	mov    0x805024,%eax
  8007ee:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8007f4:	84 c0                	test   %al,%al
  8007f6:	74 0f                	je     800807 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fd:	05 5c 05 00 00       	add    $0x55c,%eax
  800802:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800807:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80080b:	7e 0a                	jle    800817 <libmain+0x60>
		binaryname = argv[0];
  80080d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	ff 75 08             	pushl  0x8(%ebp)
  800820:	e8 13 f8 ff ff       	call   800038 <_main>
  800825:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800828:	e8 1f 18 00 00       	call   80204c <sys_disable_interrupt>
	cprintf("**************************************\n");
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	68 78 3a 80 00       	push   $0x803a78
  800835:	e8 6d 03 00 00       	call   800ba7 <cprintf>
  80083a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80083d:	a1 24 50 80 00       	mov    0x805024,%eax
  800842:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800848:	a1 24 50 80 00       	mov    0x805024,%eax
  80084d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800853:	83 ec 04             	sub    $0x4,%esp
  800856:	52                   	push   %edx
  800857:	50                   	push   %eax
  800858:	68 a0 3a 80 00       	push   $0x803aa0
  80085d:	e8 45 03 00 00       	call   800ba7 <cprintf>
  800862:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800865:	a1 24 50 80 00       	mov    0x805024,%eax
  80086a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800870:	a1 24 50 80 00       	mov    0x805024,%eax
  800875:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80087b:	a1 24 50 80 00       	mov    0x805024,%eax
  800880:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800886:	51                   	push   %ecx
  800887:	52                   	push   %edx
  800888:	50                   	push   %eax
  800889:	68 c8 3a 80 00       	push   $0x803ac8
  80088e:	e8 14 03 00 00       	call   800ba7 <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800896:	a1 24 50 80 00       	mov    0x805024,%eax
  80089b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	50                   	push   %eax
  8008a5:	68 20 3b 80 00       	push   $0x803b20
  8008aa:	e8 f8 02 00 00       	call   800ba7 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	68 78 3a 80 00       	push   $0x803a78
  8008ba:	e8 e8 02 00 00       	call   800ba7 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008c2:	e8 9f 17 00 00       	call   802066 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008c7:	e8 19 00 00 00       	call   8008e5 <exit>
}
  8008cc:	90                   	nop
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    

008008cf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008d5:	83 ec 0c             	sub    $0xc,%esp
  8008d8:	6a 00                	push   $0x0
  8008da:	e8 2c 19 00 00       	call   80220b <sys_destroy_env>
  8008df:	83 c4 10             	add    $0x10,%esp
}
  8008e2:	90                   	nop
  8008e3:	c9                   	leave  
  8008e4:	c3                   	ret    

008008e5 <exit>:

void
exit(void)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008eb:	e8 81 19 00 00       	call   802271 <sys_exit_env>
}
  8008f0:	90                   	nop
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8008fc:	83 c0 04             	add    $0x4,%eax
  8008ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800902:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800907:	85 c0                	test   %eax,%eax
  800909:	74 16                	je     800921 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80090b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	50                   	push   %eax
  800914:	68 34 3b 80 00       	push   $0x803b34
  800919:	e8 89 02 00 00       	call   800ba7 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800921:	a1 00 50 80 00       	mov    0x805000,%eax
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	50                   	push   %eax
  80092d:	68 39 3b 80 00       	push   $0x803b39
  800932:	e8 70 02 00 00       	call   800ba7 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80093a:	8b 45 10             	mov    0x10(%ebp),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 f4             	pushl  -0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	e8 f3 01 00 00       	call   800b3c <vcprintf>
  800949:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	6a 00                	push   $0x0
  800951:	68 55 3b 80 00       	push   $0x803b55
  800956:	e8 e1 01 00 00       	call   800b3c <vcprintf>
  80095b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80095e:	e8 82 ff ff ff       	call   8008e5 <exit>

	// should not return here
	while (1) ;
  800963:	eb fe                	jmp    800963 <_panic+0x70>

00800965 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80096b:	a1 24 50 80 00       	mov    0x805024,%eax
  800970:	8b 50 74             	mov    0x74(%eax),%edx
  800973:	8b 45 0c             	mov    0xc(%ebp),%eax
  800976:	39 c2                	cmp    %eax,%edx
  800978:	74 14                	je     80098e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80097a:	83 ec 04             	sub    $0x4,%esp
  80097d:	68 58 3b 80 00       	push   $0x803b58
  800982:	6a 26                	push   $0x26
  800984:	68 a4 3b 80 00       	push   $0x803ba4
  800989:	e8 65 ff ff ff       	call   8008f3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80098e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800995:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80099c:	e9 c2 00 00 00       	jmp    800a63 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	85 c0                	test   %eax,%eax
  8009b4:	75 08                	jne    8009be <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009b6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009b9:	e9 a2 00 00 00       	jmp    800a60 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009cc:	eb 69                	jmp    800a37 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009ce:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	01 c0                	add    %eax,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	c1 e0 03             	shl    $0x3,%eax
  8009e5:	01 c8                	add    %ecx,%eax
  8009e7:	8a 40 04             	mov    0x4(%eax),%al
  8009ea:	84 c0                	test   %al,%al
  8009ec:	75 46                	jne    800a34 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8009f3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009fc:	89 d0                	mov    %edx,%eax
  8009fe:	01 c0                	add    %eax,%eax
  800a00:	01 d0                	add    %edx,%eax
  800a02:	c1 e0 03             	shl    $0x3,%eax
  800a05:	01 c8                	add    %ecx,%eax
  800a07:	8b 00                	mov    (%eax),%eax
  800a09:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a14:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a19:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	01 c8                	add    %ecx,%eax
  800a25:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a27:	39 c2                	cmp    %eax,%edx
  800a29:	75 09                	jne    800a34 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a2b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a32:	eb 12                	jmp    800a46 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a34:	ff 45 e8             	incl   -0x18(%ebp)
  800a37:	a1 24 50 80 00       	mov    0x805024,%eax
  800a3c:	8b 50 74             	mov    0x74(%eax),%edx
  800a3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a42:	39 c2                	cmp    %eax,%edx
  800a44:	77 88                	ja     8009ce <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a4a:	75 14                	jne    800a60 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a4c:	83 ec 04             	sub    $0x4,%esp
  800a4f:	68 b0 3b 80 00       	push   $0x803bb0
  800a54:	6a 3a                	push   $0x3a
  800a56:	68 a4 3b 80 00       	push   $0x803ba4
  800a5b:	e8 93 fe ff ff       	call   8008f3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a60:	ff 45 f0             	incl   -0x10(%ebp)
  800a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a69:	0f 8c 32 ff ff ff    	jl     8009a1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a76:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a7d:	eb 26                	jmp    800aa5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a7f:	a1 24 50 80 00       	mov    0x805024,%eax
  800a84:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a8d:	89 d0                	mov    %edx,%eax
  800a8f:	01 c0                	add    %eax,%eax
  800a91:	01 d0                	add    %edx,%eax
  800a93:	c1 e0 03             	shl    $0x3,%eax
  800a96:	01 c8                	add    %ecx,%eax
  800a98:	8a 40 04             	mov    0x4(%eax),%al
  800a9b:	3c 01                	cmp    $0x1,%al
  800a9d:	75 03                	jne    800aa2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a9f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa2:	ff 45 e0             	incl   -0x20(%ebp)
  800aa5:	a1 24 50 80 00       	mov    0x805024,%eax
  800aaa:	8b 50 74             	mov    0x74(%eax),%edx
  800aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab0:	39 c2                	cmp    %eax,%edx
  800ab2:	77 cb                	ja     800a7f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ab7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800aba:	74 14                	je     800ad0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800abc:	83 ec 04             	sub    $0x4,%esp
  800abf:	68 04 3c 80 00       	push   $0x803c04
  800ac4:	6a 44                	push   $0x44
  800ac6:	68 a4 3b 80 00       	push   $0x803ba4
  800acb:	e8 23 fe ff ff       	call   8008f3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ad0:	90                   	nop
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    

00800ad3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	8d 48 01             	lea    0x1(%eax),%ecx
  800ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae4:	89 0a                	mov    %ecx,(%edx)
  800ae6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae9:	88 d1                	mov    %dl,%cl
  800aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aee:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	3d ff 00 00 00       	cmp    $0xff,%eax
  800afc:	75 2c                	jne    800b2a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800afe:	a0 28 50 80 00       	mov    0x805028,%al
  800b03:	0f b6 c0             	movzbl %al,%eax
  800b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b09:	8b 12                	mov    (%edx),%edx
  800b0b:	89 d1                	mov    %edx,%ecx
  800b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b10:	83 c2 08             	add    $0x8,%edx
  800b13:	83 ec 04             	sub    $0x4,%esp
  800b16:	50                   	push   %eax
  800b17:	51                   	push   %ecx
  800b18:	52                   	push   %edx
  800b19:	e8 80 13 00 00       	call   801e9e <sys_cputs>
  800b1e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	8b 40 04             	mov    0x4(%eax),%eax
  800b30:	8d 50 01             	lea    0x1(%eax),%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b39:	90                   	nop
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b45:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b4c:	00 00 00 
	b.cnt = 0;
  800b4f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b56:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	ff 75 08             	pushl  0x8(%ebp)
  800b5f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b65:	50                   	push   %eax
  800b66:	68 d3 0a 80 00       	push   $0x800ad3
  800b6b:	e8 11 02 00 00       	call   800d81 <vprintfmt>
  800b70:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b73:	a0 28 50 80 00       	mov    0x805028,%al
  800b78:	0f b6 c0             	movzbl %al,%eax
  800b7b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b81:	83 ec 04             	sub    $0x4,%esp
  800b84:	50                   	push   %eax
  800b85:	52                   	push   %edx
  800b86:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b8c:	83 c0 08             	add    $0x8,%eax
  800b8f:	50                   	push   %eax
  800b90:	e8 09 13 00 00       	call   801e9e <sys_cputs>
  800b95:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b98:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800b9f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bad:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bb4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc3:	50                   	push   %eax
  800bc4:	e8 73 ff ff ff       	call   800b3c <vcprintf>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bda:	e8 6d 14 00 00       	call   80204c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bdf:	8d 45 0c             	lea    0xc(%ebp),%eax
  800be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	83 ec 08             	sub    $0x8,%esp
  800beb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bee:	50                   	push   %eax
  800bef:	e8 48 ff ff ff       	call   800b3c <vcprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
  800bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bfa:	e8 67 14 00 00       	call   802066 <sys_enable_interrupt>
	return cnt;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	53                   	push   %ebx
  800c08:	83 ec 14             	sub    $0x14,%esp
  800c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c11:	8b 45 14             	mov    0x14(%ebp),%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c17:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c22:	77 55                	ja     800c79 <printnum+0x75>
  800c24:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c27:	72 05                	jb     800c2e <printnum+0x2a>
  800c29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c2c:	77 4b                	ja     800c79 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c2e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c34:	8b 45 18             	mov    0x18(%ebp),%eax
  800c37:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3c:	52                   	push   %edx
  800c3d:	50                   	push   %eax
  800c3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c41:	ff 75 f0             	pushl  -0x10(%ebp)
  800c44:	e8 cf 29 00 00       	call   803618 <__udivdi3>
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	83 ec 04             	sub    $0x4,%esp
  800c4f:	ff 75 20             	pushl  0x20(%ebp)
  800c52:	53                   	push   %ebx
  800c53:	ff 75 18             	pushl  0x18(%ebp)
  800c56:	52                   	push   %edx
  800c57:	50                   	push   %eax
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	ff 75 08             	pushl  0x8(%ebp)
  800c5e:	e8 a1 ff ff ff       	call   800c04 <printnum>
  800c63:	83 c4 20             	add    $0x20,%esp
  800c66:	eb 1a                	jmp    800c82 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c68:	83 ec 08             	sub    $0x8,%esp
  800c6b:	ff 75 0c             	pushl  0xc(%ebp)
  800c6e:	ff 75 20             	pushl  0x20(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	ff d0                	call   *%eax
  800c76:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c79:	ff 4d 1c             	decl   0x1c(%ebp)
  800c7c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c80:	7f e6                	jg     800c68 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c82:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c90:	53                   	push   %ebx
  800c91:	51                   	push   %ecx
  800c92:	52                   	push   %edx
  800c93:	50                   	push   %eax
  800c94:	e8 8f 2a 00 00       	call   803728 <__umoddi3>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	05 74 3e 80 00       	add    $0x803e74,%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	0f be c0             	movsbl %al,%eax
  800ca6:	83 ec 08             	sub    $0x8,%esp
  800ca9:	ff 75 0c             	pushl  0xc(%ebp)
  800cac:	50                   	push   %eax
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	ff d0                	call   *%eax
  800cb2:	83 c4 10             	add    $0x10,%esp
}
  800cb5:	90                   	nop
  800cb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cbe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cc2:	7e 1c                	jle    800ce0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8b 00                	mov    (%eax),%eax
  800cc9:	8d 50 08             	lea    0x8(%eax),%edx
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	89 10                	mov    %edx,(%eax)
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8b 00                	mov    (%eax),%eax
  800cd6:	83 e8 08             	sub    $0x8,%eax
  800cd9:	8b 50 04             	mov    0x4(%eax),%edx
  800cdc:	8b 00                	mov    (%eax),%eax
  800cde:	eb 40                	jmp    800d20 <getuint+0x65>
	else if (lflag)
  800ce0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce4:	74 1e                	je     800d04 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8b 00                	mov    (%eax),%eax
  800ceb:	8d 50 04             	lea    0x4(%eax),%edx
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 10                	mov    %edx,(%eax)
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8b 00                	mov    (%eax),%eax
  800cf8:	83 e8 04             	sub    $0x4,%eax
  800cfb:	8b 00                	mov    (%eax),%eax
  800cfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800d02:	eb 1c                	jmp    800d20 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	8d 50 04             	lea    0x4(%eax),%edx
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	89 10                	mov    %edx,(%eax)
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	83 e8 04             	sub    $0x4,%eax
  800d19:	8b 00                	mov    (%eax),%eax
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d25:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d29:	7e 1c                	jle    800d47 <getint+0x25>
		return va_arg(*ap, long long);
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8b 00                	mov    (%eax),%eax
  800d30:	8d 50 08             	lea    0x8(%eax),%edx
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	89 10                	mov    %edx,(%eax)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	83 e8 08             	sub    $0x8,%eax
  800d40:	8b 50 04             	mov    0x4(%eax),%edx
  800d43:	8b 00                	mov    (%eax),%eax
  800d45:	eb 38                	jmp    800d7f <getint+0x5d>
	else if (lflag)
  800d47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4b:	74 1a                	je     800d67 <getint+0x45>
		return va_arg(*ap, long);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8b 00                	mov    (%eax),%eax
  800d52:	8d 50 04             	lea    0x4(%eax),%edx
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	89 10                	mov    %edx,(%eax)
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	83 e8 04             	sub    $0x4,%eax
  800d62:	8b 00                	mov    (%eax),%eax
  800d64:	99                   	cltd   
  800d65:	eb 18                	jmp    800d7f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8b 00                	mov    (%eax),%eax
  800d6c:	8d 50 04             	lea    0x4(%eax),%edx
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	89 10                	mov    %edx,(%eax)
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8b 00                	mov    (%eax),%eax
  800d79:	83 e8 04             	sub    $0x4,%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	99                   	cltd   
}
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d89:	eb 17                	jmp    800da2 <vprintfmt+0x21>
			if (ch == '\0')
  800d8b:	85 db                	test   %ebx,%ebx
  800d8d:	0f 84 af 03 00 00    	je     801142 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	53                   	push   %ebx
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	ff d0                	call   *%eax
  800d9f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	8d 50 01             	lea    0x1(%eax),%edx
  800da8:	89 55 10             	mov    %edx,0x10(%ebp)
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	0f b6 d8             	movzbl %al,%ebx
  800db0:	83 fb 25             	cmp    $0x25,%ebx
  800db3:	75 d6                	jne    800d8b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800db5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800db9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dc0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dc7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800dce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd8:	8d 50 01             	lea    0x1(%eax),%edx
  800ddb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	0f b6 d8             	movzbl %al,%ebx
  800de3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800de6:	83 f8 55             	cmp    $0x55,%eax
  800de9:	0f 87 2b 03 00 00    	ja     80111a <vprintfmt+0x399>
  800def:	8b 04 85 98 3e 80 00 	mov    0x803e98(,%eax,4),%eax
  800df6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800df8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800dfc:	eb d7                	jmp    800dd5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800dfe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e02:	eb d1                	jmp    800dd5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e04:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e0e:	89 d0                	mov    %edx,%eax
  800e10:	c1 e0 02             	shl    $0x2,%eax
  800e13:	01 d0                	add    %edx,%eax
  800e15:	01 c0                	add    %eax,%eax
  800e17:	01 d8                	add    %ebx,%eax
  800e19:	83 e8 30             	sub    $0x30,%eax
  800e1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e27:	83 fb 2f             	cmp    $0x2f,%ebx
  800e2a:	7e 3e                	jle    800e6a <vprintfmt+0xe9>
  800e2c:	83 fb 39             	cmp    $0x39,%ebx
  800e2f:	7f 39                	jg     800e6a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e31:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e34:	eb d5                	jmp    800e0b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e36:	8b 45 14             	mov    0x14(%ebp),%eax
  800e39:	83 c0 04             	add    $0x4,%eax
  800e3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e42:	83 e8 04             	sub    $0x4,%eax
  800e45:	8b 00                	mov    (%eax),%eax
  800e47:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e4a:	eb 1f                	jmp    800e6b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e50:	79 83                	jns    800dd5 <vprintfmt+0x54>
				width = 0;
  800e52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e59:	e9 77 ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e5e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e65:	e9 6b ff ff ff       	jmp    800dd5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e6a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6f:	0f 89 60 ff ff ff    	jns    800dd5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e7b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e82:	e9 4e ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e87:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e8a:	e9 46 ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 c0 04             	add    $0x4,%eax
  800e95:	89 45 14             	mov    %eax,0x14(%ebp)
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 0c             	pushl  0xc(%ebp)
  800ea6:	50                   	push   %eax
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			break;
  800eaf:	e9 89 02 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800eb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb7:	83 c0 04             	add    $0x4,%eax
  800eba:	89 45 14             	mov    %eax,0x14(%ebp)
  800ebd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec0:	83 e8 04             	sub    $0x4,%eax
  800ec3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ec5:	85 db                	test   %ebx,%ebx
  800ec7:	79 02                	jns    800ecb <vprintfmt+0x14a>
				err = -err;
  800ec9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ecb:	83 fb 64             	cmp    $0x64,%ebx
  800ece:	7f 0b                	jg     800edb <vprintfmt+0x15a>
  800ed0:	8b 34 9d e0 3c 80 00 	mov    0x803ce0(,%ebx,4),%esi
  800ed7:	85 f6                	test   %esi,%esi
  800ed9:	75 19                	jne    800ef4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800edb:	53                   	push   %ebx
  800edc:	68 85 3e 80 00       	push   $0x803e85
  800ee1:	ff 75 0c             	pushl  0xc(%ebp)
  800ee4:	ff 75 08             	pushl  0x8(%ebp)
  800ee7:	e8 5e 02 00 00       	call   80114a <printfmt>
  800eec:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800eef:	e9 49 02 00 00       	jmp    80113d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ef4:	56                   	push   %esi
  800ef5:	68 8e 3e 80 00       	push   $0x803e8e
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	ff 75 08             	pushl  0x8(%ebp)
  800f00:	e8 45 02 00 00       	call   80114a <printfmt>
  800f05:	83 c4 10             	add    $0x10,%esp
			break;
  800f08:	e9 30 02 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f10:	83 c0 04             	add    $0x4,%eax
  800f13:	89 45 14             	mov    %eax,0x14(%ebp)
  800f16:	8b 45 14             	mov    0x14(%ebp),%eax
  800f19:	83 e8 04             	sub    $0x4,%eax
  800f1c:	8b 30                	mov    (%eax),%esi
  800f1e:	85 f6                	test   %esi,%esi
  800f20:	75 05                	jne    800f27 <vprintfmt+0x1a6>
				p = "(null)";
  800f22:	be 91 3e 80 00       	mov    $0x803e91,%esi
			if (width > 0 && padc != '-')
  800f27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f2b:	7e 6d                	jle    800f9a <vprintfmt+0x219>
  800f2d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f31:	74 67                	je     800f9a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	50                   	push   %eax
  800f3a:	56                   	push   %esi
  800f3b:	e8 0c 03 00 00       	call   80124c <strnlen>
  800f40:	83 c4 10             	add    $0x10,%esp
  800f43:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f46:	eb 16                	jmp    800f5e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f48:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f4c:	83 ec 08             	sub    $0x8,%esp
  800f4f:	ff 75 0c             	pushl  0xc(%ebp)
  800f52:	50                   	push   %eax
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	ff d0                	call   *%eax
  800f58:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f5b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f62:	7f e4                	jg     800f48 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f64:	eb 34                	jmp    800f9a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f66:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f6a:	74 1c                	je     800f88 <vprintfmt+0x207>
  800f6c:	83 fb 1f             	cmp    $0x1f,%ebx
  800f6f:	7e 05                	jle    800f76 <vprintfmt+0x1f5>
  800f71:	83 fb 7e             	cmp    $0x7e,%ebx
  800f74:	7e 12                	jle    800f88 <vprintfmt+0x207>
					putch('?', putdat);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 0c             	pushl  0xc(%ebp)
  800f7c:	6a 3f                	push   $0x3f
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	ff d0                	call   *%eax
  800f83:	83 c4 10             	add    $0x10,%esp
  800f86:	eb 0f                	jmp    800f97 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f88:	83 ec 08             	sub    $0x8,%esp
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	53                   	push   %ebx
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	ff d0                	call   *%eax
  800f94:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f97:	ff 4d e4             	decl   -0x1c(%ebp)
  800f9a:	89 f0                	mov    %esi,%eax
  800f9c:	8d 70 01             	lea    0x1(%eax),%esi
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f be d8             	movsbl %al,%ebx
  800fa4:	85 db                	test   %ebx,%ebx
  800fa6:	74 24                	je     800fcc <vprintfmt+0x24b>
  800fa8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fac:	78 b8                	js     800f66 <vprintfmt+0x1e5>
  800fae:	ff 4d e0             	decl   -0x20(%ebp)
  800fb1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fb5:	79 af                	jns    800f66 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fb7:	eb 13                	jmp    800fcc <vprintfmt+0x24b>
				putch(' ', putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	6a 20                	push   $0x20
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	ff d0                	call   *%eax
  800fc6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc9:	ff 4d e4             	decl   -0x1c(%ebp)
  800fcc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd0:	7f e7                	jg     800fb9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fd2:	e9 66 01 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fd7:	83 ec 08             	sub    $0x8,%esp
  800fda:	ff 75 e8             	pushl  -0x18(%ebp)
  800fdd:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe0:	50                   	push   %eax
  800fe1:	e8 3c fd ff ff       	call   800d22 <getint>
  800fe6:	83 c4 10             	add    $0x10,%esp
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff5:	85 d2                	test   %edx,%edx
  800ff7:	79 23                	jns    80101c <vprintfmt+0x29b>
				putch('-', putdat);
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	ff 75 0c             	pushl  0xc(%ebp)
  800fff:	6a 2d                	push   $0x2d
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	ff d0                	call   *%eax
  801006:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100f:	f7 d8                	neg    %eax
  801011:	83 d2 00             	adc    $0x0,%edx
  801014:	f7 da                	neg    %edx
  801016:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801019:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80101c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801023:	e9 bc 00 00 00       	jmp    8010e4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801028:	83 ec 08             	sub    $0x8,%esp
  80102b:	ff 75 e8             	pushl  -0x18(%ebp)
  80102e:	8d 45 14             	lea    0x14(%ebp),%eax
  801031:	50                   	push   %eax
  801032:	e8 84 fc ff ff       	call   800cbb <getuint>
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801040:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801047:	e9 98 00 00 00       	jmp    8010e4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80104c:	83 ec 08             	sub    $0x8,%esp
  80104f:	ff 75 0c             	pushl  0xc(%ebp)
  801052:	6a 58                	push   $0x58
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	ff d0                	call   *%eax
  801059:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80105c:	83 ec 08             	sub    $0x8,%esp
  80105f:	ff 75 0c             	pushl  0xc(%ebp)
  801062:	6a 58                	push   $0x58
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106c:	83 ec 08             	sub    $0x8,%esp
  80106f:	ff 75 0c             	pushl  0xc(%ebp)
  801072:	6a 58                	push   $0x58
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	ff d0                	call   *%eax
  801079:	83 c4 10             	add    $0x10,%esp
			break;
  80107c:	e9 bc 00 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801081:	83 ec 08             	sub    $0x8,%esp
  801084:	ff 75 0c             	pushl  0xc(%ebp)
  801087:	6a 30                	push   $0x30
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	ff d0                	call   *%eax
  80108e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	ff 75 0c             	pushl  0xc(%ebp)
  801097:	6a 78                	push   $0x78
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	ff d0                	call   *%eax
  80109e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8010aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ad:	83 e8 04             	sub    $0x4,%eax
  8010b0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010c3:	eb 1f                	jmp    8010e4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010c5:	83 ec 08             	sub    $0x8,%esp
  8010c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8010cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8010ce:	50                   	push   %eax
  8010cf:	e8 e7 fb ff ff       	call   800cbb <getuint>
  8010d4:	83 c4 10             	add    $0x10,%esp
  8010d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010e4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010eb:	83 ec 04             	sub    $0x4,%esp
  8010ee:	52                   	push   %edx
  8010ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010f2:	50                   	push   %eax
  8010f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8010f9:	ff 75 0c             	pushl  0xc(%ebp)
  8010fc:	ff 75 08             	pushl  0x8(%ebp)
  8010ff:	e8 00 fb ff ff       	call   800c04 <printnum>
  801104:	83 c4 20             	add    $0x20,%esp
			break;
  801107:	eb 34                	jmp    80113d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801109:	83 ec 08             	sub    $0x8,%esp
  80110c:	ff 75 0c             	pushl  0xc(%ebp)
  80110f:	53                   	push   %ebx
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	ff d0                	call   *%eax
  801115:	83 c4 10             	add    $0x10,%esp
			break;
  801118:	eb 23                	jmp    80113d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80111a:	83 ec 08             	sub    $0x8,%esp
  80111d:	ff 75 0c             	pushl  0xc(%ebp)
  801120:	6a 25                	push   $0x25
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	ff d0                	call   *%eax
  801127:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80112a:	ff 4d 10             	decl   0x10(%ebp)
  80112d:	eb 03                	jmp    801132 <vprintfmt+0x3b1>
  80112f:	ff 4d 10             	decl   0x10(%ebp)
  801132:	8b 45 10             	mov    0x10(%ebp),%eax
  801135:	48                   	dec    %eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 25                	cmp    $0x25,%al
  80113a:	75 f3                	jne    80112f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80113c:	90                   	nop
		}
	}
  80113d:	e9 47 fc ff ff       	jmp    800d89 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801142:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801143:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801150:	8d 45 10             	lea    0x10(%ebp),%eax
  801153:	83 c0 04             	add    $0x4,%eax
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	ff 75 f4             	pushl  -0xc(%ebp)
  80115f:	50                   	push   %eax
  801160:	ff 75 0c             	pushl  0xc(%ebp)
  801163:	ff 75 08             	pushl  0x8(%ebp)
  801166:	e8 16 fc ff ff       	call   800d81 <vprintfmt>
  80116b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80116e:	90                   	nop
  80116f:	c9                   	leave  
  801170:	c3                   	ret    

00801171 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	8b 40 08             	mov    0x8(%eax),%eax
  80117a:	8d 50 01             	lea    0x1(%eax),%edx
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	8b 10                	mov    (%eax),%edx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	8b 40 04             	mov    0x4(%eax),%eax
  80118e:	39 c2                	cmp    %eax,%edx
  801190:	73 12                	jae    8011a4 <sprintputch+0x33>
		*b->buf++ = ch;
  801192:	8b 45 0c             	mov    0xc(%ebp),%eax
  801195:	8b 00                	mov    (%eax),%eax
  801197:	8d 48 01             	lea    0x1(%eax),%ecx
  80119a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80119d:	89 0a                	mov    %ecx,(%edx)
  80119f:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a2:	88 10                	mov    %dl,(%eax)
}
  8011a4:	90                   	nop
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	01 d0                	add    %edx,%eax
  8011be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011cc:	74 06                	je     8011d4 <vsnprintf+0x2d>
  8011ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d2:	7f 07                	jg     8011db <vsnprintf+0x34>
		return -E_INVAL;
  8011d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8011d9:	eb 20                	jmp    8011fb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011db:	ff 75 14             	pushl  0x14(%ebp)
  8011de:	ff 75 10             	pushl  0x10(%ebp)
  8011e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011e4:	50                   	push   %eax
  8011e5:	68 71 11 80 00       	push   $0x801171
  8011ea:	e8 92 fb ff ff       	call   800d81 <vprintfmt>
  8011ef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

008011fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801203:	8d 45 10             	lea    0x10(%ebp),%eax
  801206:	83 c0 04             	add    $0x4,%eax
  801209:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	ff 75 f4             	pushl  -0xc(%ebp)
  801212:	50                   	push   %eax
  801213:	ff 75 0c             	pushl  0xc(%ebp)
  801216:	ff 75 08             	pushl  0x8(%ebp)
  801219:	e8 89 ff ff ff       	call   8011a7 <vsnprintf>
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801224:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80122f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801236:	eb 06                	jmp    80123e <strlen+0x15>
		n++;
  801238:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80123b:	ff 45 08             	incl   0x8(%ebp)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	75 f1                	jne    801238 <strlen+0xf>
		n++;
	return n;
  801247:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801252:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801259:	eb 09                	jmp    801264 <strnlen+0x18>
		n++;
  80125b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80125e:	ff 45 08             	incl   0x8(%ebp)
  801261:	ff 4d 0c             	decl   0xc(%ebp)
  801264:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801268:	74 09                	je     801273 <strnlen+0x27>
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	75 e8                	jne    80125b <strnlen+0xf>
		n++;
	return n;
  801273:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801284:	90                   	nop
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	8d 50 01             	lea    0x1(%eax),%edx
  80128b:	89 55 08             	mov    %edx,0x8(%ebp)
  80128e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801291:	8d 4a 01             	lea    0x1(%edx),%ecx
  801294:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801297:	8a 12                	mov    (%edx),%dl
  801299:	88 10                	mov    %dl,(%eax)
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	84 c0                	test   %al,%al
  80129f:	75 e4                	jne    801285 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b9:	eb 1f                	jmp    8012da <strncpy+0x34>
		*dst++ = *src;
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	8d 50 01             	lea    0x1(%eax),%edx
  8012c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c7:	8a 12                	mov    (%edx),%dl
  8012c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	84 c0                	test   %al,%al
  8012d2:	74 03                	je     8012d7 <strncpy+0x31>
			src++;
  8012d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012d7:	ff 45 fc             	incl   -0x4(%ebp)
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012e0:	72 d9                	jb     8012bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f7:	74 30                	je     801329 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012f9:	eb 16                	jmp    801311 <strlcpy+0x2a>
			*dst++ = *src++;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8d 50 01             	lea    0x1(%eax),%edx
  801301:	89 55 08             	mov    %edx,0x8(%ebp)
  801304:	8b 55 0c             	mov    0xc(%ebp),%edx
  801307:	8d 4a 01             	lea    0x1(%edx),%ecx
  80130a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80130d:	8a 12                	mov    (%edx),%dl
  80130f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801311:	ff 4d 10             	decl   0x10(%ebp)
  801314:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801318:	74 09                	je     801323 <strlcpy+0x3c>
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	84 c0                	test   %al,%al
  801321:	75 d8                	jne    8012fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801329:	8b 55 08             	mov    0x8(%ebp),%edx
  80132c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132f:	29 c2                	sub    %eax,%edx
  801331:	89 d0                	mov    %edx,%eax
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801338:	eb 06                	jmp    801340 <strcmp+0xb>
		p++, q++;
  80133a:	ff 45 08             	incl   0x8(%ebp)
  80133d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	84 c0                	test   %al,%al
  801347:	74 0e                	je     801357 <strcmp+0x22>
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 10                	mov    (%eax),%dl
  80134e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	38 c2                	cmp    %al,%dl
  801355:	74 e3                	je     80133a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	0f b6 d0             	movzbl %al,%edx
  80135f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	0f b6 c0             	movzbl %al,%eax
  801367:	29 c2                	sub    %eax,%edx
  801369:	89 d0                	mov    %edx,%eax
}
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801370:	eb 09                	jmp    80137b <strncmp+0xe>
		n--, p++, q++;
  801372:	ff 4d 10             	decl   0x10(%ebp)
  801375:	ff 45 08             	incl   0x8(%ebp)
  801378:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80137b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80137f:	74 17                	je     801398 <strncmp+0x2b>
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	84 c0                	test   %al,%al
  801388:	74 0e                	je     801398 <strncmp+0x2b>
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	8a 10                	mov    (%eax),%dl
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	38 c2                	cmp    %al,%dl
  801396:	74 da                	je     801372 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801398:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139c:	75 07                	jne    8013a5 <strncmp+0x38>
		return 0;
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	eb 14                	jmp    8013b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	0f b6 d0             	movzbl %al,%edx
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	0f b6 c0             	movzbl %al,%eax
  8013b5:	29 c2                	sub    %eax,%edx
  8013b7:	89 d0                	mov    %edx,%eax
}
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013c7:	eb 12                	jmp    8013db <strchr+0x20>
		if (*s == c)
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013d1:	75 05                	jne    8013d8 <strchr+0x1d>
			return (char *) s;
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	eb 11                	jmp    8013e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013d8:	ff 45 08             	incl   0x8(%ebp)
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	84 c0                	test   %al,%al
  8013e2:	75 e5                	jne    8013c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013f7:	eb 0d                	jmp    801406 <strfind+0x1b>
		if (*s == c)
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	8a 00                	mov    (%eax),%al
  8013fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801401:	74 0e                	je     801411 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801403:	ff 45 08             	incl   0x8(%ebp)
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	84 c0                	test   %al,%al
  80140d:	75 ea                	jne    8013f9 <strfind+0xe>
  80140f:	eb 01                	jmp    801412 <strfind+0x27>
		if (*s == c)
			break;
  801411:	90                   	nop
	return (char *) s;
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801429:	eb 0e                	jmp    801439 <memset+0x22>
		*p++ = c;
  80142b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142e:	8d 50 01             	lea    0x1(%eax),%edx
  801431:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801434:	8b 55 0c             	mov    0xc(%ebp),%edx
  801437:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801439:	ff 4d f8             	decl   -0x8(%ebp)
  80143c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801440:	79 e9                	jns    80142b <memset+0x14>
		*p++ = c;

	return v;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801459:	eb 16                	jmp    801471 <memcpy+0x2a>
		*d++ = *s++;
  80145b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145e:	8d 50 01             	lea    0x1(%eax),%edx
  801461:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801464:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801467:	8d 4a 01             	lea    0x1(%edx),%ecx
  80146a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80146d:	8a 12                	mov    (%edx),%dl
  80146f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801471:	8b 45 10             	mov    0x10(%ebp),%eax
  801474:	8d 50 ff             	lea    -0x1(%eax),%edx
  801477:	89 55 10             	mov    %edx,0x10(%ebp)
  80147a:	85 c0                	test   %eax,%eax
  80147c:	75 dd                	jne    80145b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801495:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801498:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80149b:	73 50                	jae    8014ed <memmove+0x6a>
  80149d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a3:	01 d0                	add    %edx,%eax
  8014a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014a8:	76 43                	jbe    8014ed <memmove+0x6a>
		s += n;
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014b6:	eb 10                	jmp    8014c8 <memmove+0x45>
			*--d = *--s;
  8014b8:	ff 4d f8             	decl   -0x8(%ebp)
  8014bb:	ff 4d fc             	decl   -0x4(%ebp)
  8014be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	75 e3                	jne    8014b8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014d5:	eb 23                	jmp    8014fa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014da:	8d 50 01             	lea    0x1(%eax),%edx
  8014dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014e6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014e9:	8a 12                	mov    (%edx),%dl
  8014eb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	75 dd                	jne    8014d7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801511:	eb 2a                	jmp    80153d <memcmp+0x3e>
		if (*s1 != *s2)
  801513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801516:	8a 10                	mov    (%eax),%dl
  801518:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151b:	8a 00                	mov    (%eax),%al
  80151d:	38 c2                	cmp    %al,%dl
  80151f:	74 16                	je     801537 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	0f b6 d0             	movzbl %al,%edx
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	0f b6 c0             	movzbl %al,%eax
  801531:	29 c2                	sub    %eax,%edx
  801533:	89 d0                	mov    %edx,%eax
  801535:	eb 18                	jmp    80154f <memcmp+0x50>
		s1++, s2++;
  801537:	ff 45 fc             	incl   -0x4(%ebp)
  80153a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80153d:	8b 45 10             	mov    0x10(%ebp),%eax
  801540:	8d 50 ff             	lea    -0x1(%eax),%edx
  801543:	89 55 10             	mov    %edx,0x10(%ebp)
  801546:	85 c0                	test   %eax,%eax
  801548:	75 c9                	jne    801513 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801557:	8b 55 08             	mov    0x8(%ebp),%edx
  80155a:	8b 45 10             	mov    0x10(%ebp),%eax
  80155d:	01 d0                	add    %edx,%eax
  80155f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801562:	eb 15                	jmp    801579 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	0f b6 d0             	movzbl %al,%edx
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	0f b6 c0             	movzbl %al,%eax
  801572:	39 c2                	cmp    %eax,%edx
  801574:	74 0d                	je     801583 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801576:	ff 45 08             	incl   0x8(%ebp)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80157f:	72 e3                	jb     801564 <memfind+0x13>
  801581:	eb 01                	jmp    801584 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801583:	90                   	nop
	return (void *) s;
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80158f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801596:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80159d:	eb 03                	jmp    8015a2 <strtol+0x19>
		s++;
  80159f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	3c 20                	cmp    $0x20,%al
  8015a9:	74 f4                	je     80159f <strtol+0x16>
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	3c 09                	cmp    $0x9,%al
  8015b2:	74 eb                	je     80159f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	3c 2b                	cmp    $0x2b,%al
  8015bb:	75 05                	jne    8015c2 <strtol+0x39>
		s++;
  8015bd:	ff 45 08             	incl   0x8(%ebp)
  8015c0:	eb 13                	jmp    8015d5 <strtol+0x4c>
	else if (*s == '-')
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	3c 2d                	cmp    $0x2d,%al
  8015c9:	75 0a                	jne    8015d5 <strtol+0x4c>
		s++, neg = 1;
  8015cb:	ff 45 08             	incl   0x8(%ebp)
  8015ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d9:	74 06                	je     8015e1 <strtol+0x58>
  8015db:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015df:	75 20                	jne    801601 <strtol+0x78>
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8a 00                	mov    (%eax),%al
  8015e6:	3c 30                	cmp    $0x30,%al
  8015e8:	75 17                	jne    801601 <strtol+0x78>
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	40                   	inc    %eax
  8015ee:	8a 00                	mov    (%eax),%al
  8015f0:	3c 78                	cmp    $0x78,%al
  8015f2:	75 0d                	jne    801601 <strtol+0x78>
		s += 2, base = 16;
  8015f4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015f8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015ff:	eb 28                	jmp    801629 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801601:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801605:	75 15                	jne    80161c <strtol+0x93>
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8a 00                	mov    (%eax),%al
  80160c:	3c 30                	cmp    $0x30,%al
  80160e:	75 0c                	jne    80161c <strtol+0x93>
		s++, base = 8;
  801610:	ff 45 08             	incl   0x8(%ebp)
  801613:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80161a:	eb 0d                	jmp    801629 <strtol+0xa0>
	else if (base == 0)
  80161c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801620:	75 07                	jne    801629 <strtol+0xa0>
		base = 10;
  801622:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	8a 00                	mov    (%eax),%al
  80162e:	3c 2f                	cmp    $0x2f,%al
  801630:	7e 19                	jle    80164b <strtol+0xc2>
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8a 00                	mov    (%eax),%al
  801637:	3c 39                	cmp    $0x39,%al
  801639:	7f 10                	jg     80164b <strtol+0xc2>
			dig = *s - '0';
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	8a 00                	mov    (%eax),%al
  801640:	0f be c0             	movsbl %al,%eax
  801643:	83 e8 30             	sub    $0x30,%eax
  801646:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801649:	eb 42                	jmp    80168d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 60                	cmp    $0x60,%al
  801652:	7e 19                	jle    80166d <strtol+0xe4>
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	3c 7a                	cmp    $0x7a,%al
  80165b:	7f 10                	jg     80166d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f be c0             	movsbl %al,%eax
  801665:	83 e8 57             	sub    $0x57,%eax
  801668:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80166b:	eb 20                	jmp    80168d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 40                	cmp    $0x40,%al
  801674:	7e 39                	jle    8016af <strtol+0x126>
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	3c 5a                	cmp    $0x5a,%al
  80167d:	7f 30                	jg     8016af <strtol+0x126>
			dig = *s - 'A' + 10;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8a 00                	mov    (%eax),%al
  801684:	0f be c0             	movsbl %al,%eax
  801687:	83 e8 37             	sub    $0x37,%eax
  80168a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801690:	3b 45 10             	cmp    0x10(%ebp),%eax
  801693:	7d 19                	jge    8016ae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801695:	ff 45 08             	incl   0x8(%ebp)
  801698:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80169f:	89 c2                	mov    %eax,%edx
  8016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a4:	01 d0                	add    %edx,%eax
  8016a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016a9:	e9 7b ff ff ff       	jmp    801629 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016ae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b3:	74 08                	je     8016bd <strtol+0x134>
		*endptr = (char *) s;
  8016b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016c1:	74 07                	je     8016ca <strtol+0x141>
  8016c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c6:	f7 d8                	neg    %eax
  8016c8:	eb 03                	jmp    8016cd <strtol+0x144>
  8016ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <ltostr>:

void
ltostr(long value, char *str)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016e7:	79 13                	jns    8016fc <ltostr+0x2d>
	{
		neg = 1;
  8016e9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016f6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016f9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801704:	99                   	cltd   
  801705:	f7 f9                	idiv   %ecx
  801707:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80170a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170d:	8d 50 01             	lea    0x1(%eax),%edx
  801710:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801713:	89 c2                	mov    %eax,%edx
  801715:	8b 45 0c             	mov    0xc(%ebp),%eax
  801718:	01 d0                	add    %edx,%eax
  80171a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80171d:	83 c2 30             	add    $0x30,%edx
  801720:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801722:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801725:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80172a:	f7 e9                	imul   %ecx
  80172c:	c1 fa 02             	sar    $0x2,%edx
  80172f:	89 c8                	mov    %ecx,%eax
  801731:	c1 f8 1f             	sar    $0x1f,%eax
  801734:	29 c2                	sub    %eax,%edx
  801736:	89 d0                	mov    %edx,%eax
  801738:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80173b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801743:	f7 e9                	imul   %ecx
  801745:	c1 fa 02             	sar    $0x2,%edx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	c1 f8 1f             	sar    $0x1f,%eax
  80174d:	29 c2                	sub    %eax,%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	c1 e0 02             	shl    $0x2,%eax
  801754:	01 d0                	add    %edx,%eax
  801756:	01 c0                	add    %eax,%eax
  801758:	29 c1                	sub    %eax,%ecx
  80175a:	89 ca                	mov    %ecx,%edx
  80175c:	85 d2                	test   %edx,%edx
  80175e:	75 9c                	jne    8016fc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801760:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801767:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176a:	48                   	dec    %eax
  80176b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80176e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801772:	74 3d                	je     8017b1 <ltostr+0xe2>
		start = 1 ;
  801774:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80177b:	eb 34                	jmp    8017b1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80177d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	01 d0                	add    %edx,%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80178a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801790:	01 c2                	add    %eax,%edx
  801792:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801795:	8b 45 0c             	mov    0xc(%ebp),%eax
  801798:	01 c8                	add    %ecx,%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80179e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a4:	01 c2                	add    %eax,%edx
  8017a6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017a9:	88 02                	mov    %al,(%edx)
		start++ ;
  8017ab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017ae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017b7:	7c c4                	jl     80177d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bf:	01 d0                	add    %edx,%eax
  8017c1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017c4:	90                   	nop
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	e8 54 fa ff ff       	call   801229 <strlen>
  8017d5:	83 c4 04             	add    $0x4,%esp
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	e8 46 fa ff ff       	call   801229 <strlen>
  8017e3:	83 c4 04             	add    $0x4,%esp
  8017e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017f7:	eb 17                	jmp    801810 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	01 c2                	add    %eax,%edx
  801801:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	01 c8                	add    %ecx,%eax
  801809:	8a 00                	mov    (%eax),%al
  80180b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80180d:	ff 45 fc             	incl   -0x4(%ebp)
  801810:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801813:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801816:	7c e1                	jl     8017f9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801818:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80181f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801826:	eb 1f                	jmp    801847 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801828:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801831:	89 c2                	mov    %eax,%edx
  801833:	8b 45 10             	mov    0x10(%ebp),%eax
  801836:	01 c2                	add    %eax,%edx
  801838:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80183b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183e:	01 c8                	add    %ecx,%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801844:	ff 45 f8             	incl   -0x8(%ebp)
  801847:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184d:	7c d9                	jl     801828 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80184f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801852:	8b 45 10             	mov    0x10(%ebp),%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	c6 00 00             	movb   $0x0,(%eax)
}
  80185a:	90                   	nop
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801860:	8b 45 14             	mov    0x14(%ebp),%eax
  801863:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801869:	8b 45 14             	mov    0x14(%ebp),%eax
  80186c:	8b 00                	mov    (%eax),%eax
  80186e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801875:	8b 45 10             	mov    0x10(%ebp),%eax
  801878:	01 d0                	add    %edx,%eax
  80187a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801880:	eb 0c                	jmp    80188e <strsplit+0x31>
			*string++ = 0;
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	8d 50 01             	lea    0x1(%eax),%edx
  801888:	89 55 08             	mov    %edx,0x8(%ebp)
  80188b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	8a 00                	mov    (%eax),%al
  801893:	84 c0                	test   %al,%al
  801895:	74 18                	je     8018af <strsplit+0x52>
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	8a 00                	mov    (%eax),%al
  80189c:	0f be c0             	movsbl %al,%eax
  80189f:	50                   	push   %eax
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	e8 13 fb ff ff       	call   8013bb <strchr>
  8018a8:	83 c4 08             	add    $0x8,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	75 d3                	jne    801882 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	8a 00                	mov    (%eax),%al
  8018b4:	84 c0                	test   %al,%al
  8018b6:	74 5a                	je     801912 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bb:	8b 00                	mov    (%eax),%eax
  8018bd:	83 f8 0f             	cmp    $0xf,%eax
  8018c0:	75 07                	jne    8018c9 <strsplit+0x6c>
		{
			return 0;
  8018c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c7:	eb 66                	jmp    80192f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018cc:	8b 00                	mov    (%eax),%eax
  8018ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8018d1:	8b 55 14             	mov    0x14(%ebp),%edx
  8018d4:	89 0a                	mov    %ecx,(%edx)
  8018d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e0:	01 c2                	add    %eax,%edx
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018e7:	eb 03                	jmp    8018ec <strsplit+0x8f>
			string++;
  8018e9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	8a 00                	mov    (%eax),%al
  8018f1:	84 c0                	test   %al,%al
  8018f3:	74 8b                	je     801880 <strsplit+0x23>
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	8a 00                	mov    (%eax),%al
  8018fa:	0f be c0             	movsbl %al,%eax
  8018fd:	50                   	push   %eax
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	e8 b5 fa ff ff       	call   8013bb <strchr>
  801906:	83 c4 08             	add    $0x8,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	74 dc                	je     8018e9 <strsplit+0x8c>
			string++;
	}
  80190d:	e9 6e ff ff ff       	jmp    801880 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801912:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801913:	8b 45 14             	mov    0x14(%ebp),%eax
  801916:	8b 00                	mov    (%eax),%eax
  801918:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80191f:	8b 45 10             	mov    0x10(%ebp),%eax
  801922:	01 d0                	add    %edx,%eax
  801924:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80192a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801937:	a1 04 50 80 00       	mov    0x805004,%eax
  80193c:	85 c0                	test   %eax,%eax
  80193e:	74 1f                	je     80195f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801940:	e8 1d 00 00 00       	call   801962 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801945:	83 ec 0c             	sub    $0xc,%esp
  801948:	68 f0 3f 80 00       	push   $0x803ff0
  80194d:	e8 55 f2 ff ff       	call   800ba7 <cprintf>
  801952:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801955:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80195c:	00 00 00 
	}
}
  80195f:	90                   	nop
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801968:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80196f:	00 00 00 
  801972:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801979:	00 00 00 
  80197c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801983:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801986:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80198d:	00 00 00 
  801990:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801997:	00 00 00 
  80199a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8019a1:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  8019a4:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8019ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019b3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019b8:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8019bd:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019c4:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8019c7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d1:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8019d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e1:	f7 75 f0             	divl   -0x10(%ebp)
  8019e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e7:	29 d0                	sub    %edx,%eax
  8019e9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8019ec:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8019f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019fb:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	6a 06                	push   $0x6
  801a05:	ff 75 e8             	pushl  -0x18(%ebp)
  801a08:	50                   	push   %eax
  801a09:	e8 d4 05 00 00       	call   801fe2 <sys_allocate_chunk>
  801a0e:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a11:	a1 20 51 80 00       	mov    0x805120,%eax
  801a16:	83 ec 0c             	sub    $0xc,%esp
  801a19:	50                   	push   %eax
  801a1a:	e8 49 0c 00 00       	call   802668 <initialize_MemBlocksList>
  801a1f:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801a22:	a1 48 51 80 00       	mov    0x805148,%eax
  801a27:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801a2a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a2e:	75 14                	jne    801a44 <initialize_dyn_block_system+0xe2>
  801a30:	83 ec 04             	sub    $0x4,%esp
  801a33:	68 15 40 80 00       	push   $0x804015
  801a38:	6a 39                	push   $0x39
  801a3a:	68 33 40 80 00       	push   $0x804033
  801a3f:	e8 af ee ff ff       	call   8008f3 <_panic>
  801a44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a47:	8b 00                	mov    (%eax),%eax
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	74 10                	je     801a5d <initialize_dyn_block_system+0xfb>
  801a4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a50:	8b 00                	mov    (%eax),%eax
  801a52:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a55:	8b 52 04             	mov    0x4(%edx),%edx
  801a58:	89 50 04             	mov    %edx,0x4(%eax)
  801a5b:	eb 0b                	jmp    801a68 <initialize_dyn_block_system+0x106>
  801a5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a60:	8b 40 04             	mov    0x4(%eax),%eax
  801a63:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801a68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a6b:	8b 40 04             	mov    0x4(%eax),%eax
  801a6e:	85 c0                	test   %eax,%eax
  801a70:	74 0f                	je     801a81 <initialize_dyn_block_system+0x11f>
  801a72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a75:	8b 40 04             	mov    0x4(%eax),%eax
  801a78:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a7b:	8b 12                	mov    (%edx),%edx
  801a7d:	89 10                	mov    %edx,(%eax)
  801a7f:	eb 0a                	jmp    801a8b <initialize_dyn_block_system+0x129>
  801a81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a84:	8b 00                	mov    (%eax),%eax
  801a86:	a3 48 51 80 00       	mov    %eax,0x805148
  801a8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a9e:	a1 54 51 80 00       	mov    0x805154,%eax
  801aa3:	48                   	dec    %eax
  801aa4:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801aa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aac:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801ab3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ab6:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801abd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ac1:	75 14                	jne    801ad7 <initialize_dyn_block_system+0x175>
  801ac3:	83 ec 04             	sub    $0x4,%esp
  801ac6:	68 40 40 80 00       	push   $0x804040
  801acb:	6a 3f                	push   $0x3f
  801acd:	68 33 40 80 00       	push   $0x804033
  801ad2:	e8 1c ee ff ff       	call   8008f3 <_panic>
  801ad7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801add:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ae0:	89 10                	mov    %edx,(%eax)
  801ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ae5:	8b 00                	mov    (%eax),%eax
  801ae7:	85 c0                	test   %eax,%eax
  801ae9:	74 0d                	je     801af8 <initialize_dyn_block_system+0x196>
  801aeb:	a1 38 51 80 00       	mov    0x805138,%eax
  801af0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801af3:	89 50 04             	mov    %edx,0x4(%eax)
  801af6:	eb 08                	jmp    801b00 <initialize_dyn_block_system+0x19e>
  801af8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801afb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801b00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b03:	a3 38 51 80 00       	mov    %eax,0x805138
  801b08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b12:	a1 44 51 80 00       	mov    0x805144,%eax
  801b17:	40                   	inc    %eax
  801b18:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801b1d:	90                   	nop
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b26:	e8 06 fe ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b2f:	75 07                	jne    801b38 <malloc+0x18>
  801b31:	b8 00 00 00 00       	mov    $0x0,%eax
  801b36:	eb 7d                	jmp    801bb5 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801b38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801b3f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b46:	8b 55 08             	mov    0x8(%ebp),%edx
  801b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4c:	01 d0                	add    %edx,%eax
  801b4e:	48                   	dec    %eax
  801b4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b55:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5a:	f7 75 f0             	divl   -0x10(%ebp)
  801b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b60:	29 d0                	sub    %edx,%eax
  801b62:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801b65:	e8 46 08 00 00       	call   8023b0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b6a:	83 f8 01             	cmp    $0x1,%eax
  801b6d:	75 07                	jne    801b76 <malloc+0x56>
  801b6f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801b76:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801b7a:	75 34                	jne    801bb0 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801b7c:	83 ec 0c             	sub    $0xc,%esp
  801b7f:	ff 75 e8             	pushl  -0x18(%ebp)
  801b82:	e8 73 0e 00 00       	call   8029fa <alloc_block_FF>
  801b87:	83 c4 10             	add    $0x10,%esp
  801b8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801b8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b91:	74 16                	je     801ba9 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801b93:	83 ec 0c             	sub    $0xc,%esp
  801b96:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b99:	e8 ff 0b 00 00       	call   80279d <insert_sorted_allocList>
  801b9e:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801ba1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ba4:	8b 40 08             	mov    0x8(%eax),%eax
  801ba7:	eb 0c                	jmp    801bb5 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801ba9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bae:	eb 05                	jmp    801bb5 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801bb0:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801bd4:	83 ec 08             	sub    $0x8,%esp
  801bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  801bda:	68 40 50 80 00       	push   $0x805040
  801bdf:	e8 61 0b 00 00       	call   802745 <find_block>
  801be4:	83 c4 10             	add    $0x10,%esp
  801be7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801bea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bee:	0f 84 a5 00 00 00    	je     801c99 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801bf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf7:	8b 40 0c             	mov    0xc(%eax),%eax
  801bfa:	83 ec 08             	sub    $0x8,%esp
  801bfd:	50                   	push   %eax
  801bfe:	ff 75 f4             	pushl  -0xc(%ebp)
  801c01:	e8 a4 03 00 00       	call   801faa <sys_free_user_mem>
  801c06:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801c09:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c0d:	75 17                	jne    801c26 <free+0x6f>
  801c0f:	83 ec 04             	sub    $0x4,%esp
  801c12:	68 15 40 80 00       	push   $0x804015
  801c17:	68 87 00 00 00       	push   $0x87
  801c1c:	68 33 40 80 00       	push   $0x804033
  801c21:	e8 cd ec ff ff       	call   8008f3 <_panic>
  801c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c29:	8b 00                	mov    (%eax),%eax
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	74 10                	je     801c3f <free+0x88>
  801c2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c32:	8b 00                	mov    (%eax),%eax
  801c34:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c37:	8b 52 04             	mov    0x4(%edx),%edx
  801c3a:	89 50 04             	mov    %edx,0x4(%eax)
  801c3d:	eb 0b                	jmp    801c4a <free+0x93>
  801c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c42:	8b 40 04             	mov    0x4(%eax),%eax
  801c45:	a3 44 50 80 00       	mov    %eax,0x805044
  801c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c4d:	8b 40 04             	mov    0x4(%eax),%eax
  801c50:	85 c0                	test   %eax,%eax
  801c52:	74 0f                	je     801c63 <free+0xac>
  801c54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c57:	8b 40 04             	mov    0x4(%eax),%eax
  801c5a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c5d:	8b 12                	mov    (%edx),%edx
  801c5f:	89 10                	mov    %edx,(%eax)
  801c61:	eb 0a                	jmp    801c6d <free+0xb6>
  801c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c66:	8b 00                	mov    (%eax),%eax
  801c68:	a3 40 50 80 00       	mov    %eax,0x805040
  801c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c80:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c85:	48                   	dec    %eax
  801c86:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801c8b:	83 ec 0c             	sub    $0xc,%esp
  801c8e:	ff 75 ec             	pushl  -0x14(%ebp)
  801c91:	e8 37 12 00 00       	call   802ecd <insert_sorted_with_merge_freeList>
  801c96:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801c99:	90                   	nop
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 38             	sub    $0x38,%esp
  801ca2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca5:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ca8:	e8 84 fc ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cb1:	75 07                	jne    801cba <smalloc+0x1e>
  801cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb8:	eb 7e                	jmp    801d38 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801cba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801cc1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801cc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cce:	01 d0                	add    %edx,%eax
  801cd0:	48                   	dec    %eax
  801cd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cdc:	f7 75 f0             	divl   -0x10(%ebp)
  801cdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ce2:	29 d0                	sub    %edx,%eax
  801ce4:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801ce7:	e8 c4 06 00 00       	call   8023b0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cec:	83 f8 01             	cmp    $0x1,%eax
  801cef:	75 42                	jne    801d33 <smalloc+0x97>

		  va = malloc(newsize) ;
  801cf1:	83 ec 0c             	sub    $0xc,%esp
  801cf4:	ff 75 e8             	pushl  -0x18(%ebp)
  801cf7:	e8 24 fe ff ff       	call   801b20 <malloc>
  801cfc:	83 c4 10             	add    $0x10,%esp
  801cff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801d02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d06:	74 24                	je     801d2c <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801d08:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d0c:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d0f:	50                   	push   %eax
  801d10:	ff 75 e8             	pushl  -0x18(%ebp)
  801d13:	ff 75 08             	pushl  0x8(%ebp)
  801d16:	e8 1a 04 00 00       	call   802135 <sys_createSharedObject>
  801d1b:	83 c4 10             	add    $0x10,%esp
  801d1e:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801d21:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d25:	78 0c                	js     801d33 <smalloc+0x97>
					  return va ;
  801d27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d2a:	eb 0c                	jmp    801d38 <smalloc+0x9c>
				 }
				 else
					return NULL;
  801d2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d31:	eb 05                	jmp    801d38 <smalloc+0x9c>
	  }
		  return NULL ;
  801d33:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d40:	e8 ec fb ff ff       	call   801931 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801d45:	83 ec 08             	sub    $0x8,%esp
  801d48:	ff 75 0c             	pushl  0xc(%ebp)
  801d4b:	ff 75 08             	pushl  0x8(%ebp)
  801d4e:	e8 0c 04 00 00       	call   80215f <sys_getSizeOfSharedObject>
  801d53:	83 c4 10             	add    $0x10,%esp
  801d56:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801d59:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801d5d:	75 07                	jne    801d66 <sget+0x2c>
  801d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d64:	eb 75                	jmp    801ddb <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801d66:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d73:	01 d0                	add    %edx,%eax
  801d75:	48                   	dec    %eax
  801d76:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d81:	f7 75 f0             	divl   -0x10(%ebp)
  801d84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d87:	29 d0                	sub    %edx,%eax
  801d89:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801d8c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801d93:	e8 18 06 00 00       	call   8023b0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d98:	83 f8 01             	cmp    $0x1,%eax
  801d9b:	75 39                	jne    801dd6 <sget+0x9c>

		  va = malloc(newsize) ;
  801d9d:	83 ec 0c             	sub    $0xc,%esp
  801da0:	ff 75 e8             	pushl  -0x18(%ebp)
  801da3:	e8 78 fd ff ff       	call   801b20 <malloc>
  801da8:	83 c4 10             	add    $0x10,%esp
  801dab:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801dae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801db2:	74 22                	je     801dd6 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801db4:	83 ec 04             	sub    $0x4,%esp
  801db7:	ff 75 e0             	pushl  -0x20(%ebp)
  801dba:	ff 75 0c             	pushl  0xc(%ebp)
  801dbd:	ff 75 08             	pushl  0x8(%ebp)
  801dc0:	e8 b7 03 00 00       	call   80217c <sys_getSharedObject>
  801dc5:	83 c4 10             	add    $0x10,%esp
  801dc8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801dcb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801dcf:	78 05                	js     801dd6 <sget+0x9c>
					  return va;
  801dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dd4:	eb 05                	jmp    801ddb <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801dd6:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801de3:	e8 49 fb ff ff       	call   801931 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801de8:	83 ec 04             	sub    $0x4,%esp
  801deb:	68 64 40 80 00       	push   $0x804064
  801df0:	68 1e 01 00 00       	push   $0x11e
  801df5:	68 33 40 80 00       	push   $0x804033
  801dfa:	e8 f4 ea ff ff       	call   8008f3 <_panic>

00801dff <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e05:	83 ec 04             	sub    $0x4,%esp
  801e08:	68 8c 40 80 00       	push   $0x80408c
  801e0d:	68 32 01 00 00       	push   $0x132
  801e12:	68 33 40 80 00       	push   $0x804033
  801e17:	e8 d7 ea ff ff       	call   8008f3 <_panic>

00801e1c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e22:	83 ec 04             	sub    $0x4,%esp
  801e25:	68 b0 40 80 00       	push   $0x8040b0
  801e2a:	68 3d 01 00 00       	push   $0x13d
  801e2f:	68 33 40 80 00       	push   $0x804033
  801e34:	e8 ba ea ff ff       	call   8008f3 <_panic>

00801e39 <shrink>:

}
void shrink(uint32 newSize)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e3f:	83 ec 04             	sub    $0x4,%esp
  801e42:	68 b0 40 80 00       	push   $0x8040b0
  801e47:	68 42 01 00 00       	push   $0x142
  801e4c:	68 33 40 80 00       	push   $0x804033
  801e51:	e8 9d ea ff ff       	call   8008f3 <_panic>

00801e56 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e5c:	83 ec 04             	sub    $0x4,%esp
  801e5f:	68 b0 40 80 00       	push   $0x8040b0
  801e64:	68 47 01 00 00       	push   $0x147
  801e69:	68 33 40 80 00       	push   $0x804033
  801e6e:	e8 80 ea ff ff       	call   8008f3 <_panic>

00801e73 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	57                   	push   %edi
  801e77:	56                   	push   %esi
  801e78:	53                   	push   %ebx
  801e79:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e82:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e85:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e88:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e8b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e8e:	cd 30                	int    $0x30
  801e90:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e96:	83 c4 10             	add    $0x10,%esp
  801e99:	5b                   	pop    %ebx
  801e9a:	5e                   	pop    %esi
  801e9b:	5f                   	pop    %edi
  801e9c:	5d                   	pop    %ebp
  801e9d:	c3                   	ret    

00801e9e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	83 ec 04             	sub    $0x4,%esp
  801ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801eaa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	52                   	push   %edx
  801eb6:	ff 75 0c             	pushl  0xc(%ebp)
  801eb9:	50                   	push   %eax
  801eba:	6a 00                	push   $0x0
  801ebc:	e8 b2 ff ff ff       	call   801e73 <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
}
  801ec4:	90                   	nop
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 01                	push   $0x1
  801ed6:	e8 98 ff ff ff       	call   801e73 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	52                   	push   %edx
  801ef0:	50                   	push   %eax
  801ef1:	6a 05                	push   $0x5
  801ef3:	e8 7b ff ff ff       	call   801e73 <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	56                   	push   %esi
  801f01:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f02:	8b 75 18             	mov    0x18(%ebp),%esi
  801f05:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	56                   	push   %esi
  801f12:	53                   	push   %ebx
  801f13:	51                   	push   %ecx
  801f14:	52                   	push   %edx
  801f15:	50                   	push   %eax
  801f16:	6a 06                	push   $0x6
  801f18:	e8 56 ff ff ff       	call   801e73 <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
}
  801f20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f23:	5b                   	pop    %ebx
  801f24:	5e                   	pop    %esi
  801f25:	5d                   	pop    %ebp
  801f26:	c3                   	ret    

00801f27 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	52                   	push   %edx
  801f37:	50                   	push   %eax
  801f38:	6a 07                	push   $0x7
  801f3a:	e8 34 ff ff ff       	call   801e73 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	ff 75 0c             	pushl  0xc(%ebp)
  801f50:	ff 75 08             	pushl  0x8(%ebp)
  801f53:	6a 08                	push   $0x8
  801f55:	e8 19 ff ff ff       	call   801e73 <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 09                	push   $0x9
  801f6e:	e8 00 ff ff ff       	call   801e73 <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 0a                	push   $0xa
  801f87:	e8 e7 fe ff ff       	call   801e73 <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 0b                	push   $0xb
  801fa0:	e8 ce fe ff ff       	call   801e73 <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	ff 75 0c             	pushl  0xc(%ebp)
  801fb6:	ff 75 08             	pushl  0x8(%ebp)
  801fb9:	6a 0f                	push   $0xf
  801fbb:	e8 b3 fe ff ff       	call   801e73 <syscall>
  801fc0:	83 c4 18             	add    $0x18,%esp
	return;
  801fc3:	90                   	nop
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	ff 75 0c             	pushl  0xc(%ebp)
  801fd2:	ff 75 08             	pushl  0x8(%ebp)
  801fd5:	6a 10                	push   $0x10
  801fd7:	e8 97 fe ff ff       	call   801e73 <syscall>
  801fdc:	83 c4 18             	add    $0x18,%esp
	return ;
  801fdf:	90                   	nop
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	ff 75 10             	pushl  0x10(%ebp)
  801fec:	ff 75 0c             	pushl  0xc(%ebp)
  801fef:	ff 75 08             	pushl  0x8(%ebp)
  801ff2:	6a 11                	push   $0x11
  801ff4:	e8 7a fe ff ff       	call   801e73 <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffc:	90                   	nop
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 0c                	push   $0xc
  80200e:	e8 60 fe ff ff       	call   801e73 <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	ff 75 08             	pushl  0x8(%ebp)
  802026:	6a 0d                	push   $0xd
  802028:	e8 46 fe ff ff       	call   801e73 <syscall>
  80202d:	83 c4 18             	add    $0x18,%esp
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 0e                	push   $0xe
  802041:	e8 2d fe ff ff       	call   801e73 <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
}
  802049:	90                   	nop
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 13                	push   $0x13
  80205b:	e8 13 fe ff ff       	call   801e73 <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
}
  802063:	90                   	nop
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 14                	push   $0x14
  802075:	e8 f9 fd ff ff       	call   801e73 <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
}
  80207d:	90                   	nop
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_cputc>:


void
sys_cputc(const char c)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 04             	sub    $0x4,%esp
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80208c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	50                   	push   %eax
  802099:	6a 15                	push   $0x15
  80209b:	e8 d3 fd ff ff       	call   801e73 <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
}
  8020a3:	90                   	nop
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 16                	push   $0x16
  8020b5:	e8 b9 fd ff ff       	call   801e73 <syscall>
  8020ba:	83 c4 18             	add    $0x18,%esp
}
  8020bd:	90                   	nop
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	ff 75 0c             	pushl  0xc(%ebp)
  8020cf:	50                   	push   %eax
  8020d0:	6a 17                	push   $0x17
  8020d2:	e8 9c fd ff ff       	call   801e73 <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	52                   	push   %edx
  8020ec:	50                   	push   %eax
  8020ed:	6a 1a                	push   $0x1a
  8020ef:	e8 7f fd ff ff       	call   801e73 <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	52                   	push   %edx
  802109:	50                   	push   %eax
  80210a:	6a 18                	push   $0x18
  80210c:	e8 62 fd ff ff       	call   801e73 <syscall>
  802111:	83 c4 18             	add    $0x18,%esp
}
  802114:	90                   	nop
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80211a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	52                   	push   %edx
  802127:	50                   	push   %eax
  802128:	6a 19                	push   $0x19
  80212a:	e8 44 fd ff ff       	call   801e73 <syscall>
  80212f:	83 c4 18             	add    $0x18,%esp
}
  802132:	90                   	nop
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 04             	sub    $0x4,%esp
  80213b:	8b 45 10             	mov    0x10(%ebp),%eax
  80213e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802141:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802144:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	6a 00                	push   $0x0
  80214d:	51                   	push   %ecx
  80214e:	52                   	push   %edx
  80214f:	ff 75 0c             	pushl  0xc(%ebp)
  802152:	50                   	push   %eax
  802153:	6a 1b                	push   $0x1b
  802155:	e8 19 fd ff ff       	call   801e73 <syscall>
  80215a:	83 c4 18             	add    $0x18,%esp
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802162:	8b 55 0c             	mov    0xc(%ebp),%edx
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	52                   	push   %edx
  80216f:	50                   	push   %eax
  802170:	6a 1c                	push   $0x1c
  802172:	e8 fc fc ff ff       	call   801e73 <syscall>
  802177:	83 c4 18             	add    $0x18,%esp
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80217f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802182:	8b 55 0c             	mov    0xc(%ebp),%edx
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	51                   	push   %ecx
  80218d:	52                   	push   %edx
  80218e:	50                   	push   %eax
  80218f:	6a 1d                	push   $0x1d
  802191:	e8 dd fc ff ff       	call   801e73 <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80219e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	52                   	push   %edx
  8021ab:	50                   	push   %eax
  8021ac:	6a 1e                	push   $0x1e
  8021ae:	e8 c0 fc ff ff       	call   801e73 <syscall>
  8021b3:	83 c4 18             	add    $0x18,%esp
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 1f                	push   $0x1f
  8021c7:	e8 a7 fc ff ff       	call   801e73 <syscall>
  8021cc:	83 c4 18             	add    $0x18,%esp
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	6a 00                	push   $0x0
  8021d9:	ff 75 14             	pushl  0x14(%ebp)
  8021dc:	ff 75 10             	pushl  0x10(%ebp)
  8021df:	ff 75 0c             	pushl  0xc(%ebp)
  8021e2:	50                   	push   %eax
  8021e3:	6a 20                	push   $0x20
  8021e5:	e8 89 fc ff ff       	call   801e73 <syscall>
  8021ea:	83 c4 18             	add    $0x18,%esp
}
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    

008021ef <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	50                   	push   %eax
  8021fe:	6a 21                	push   $0x21
  802200:	e8 6e fc ff ff       	call   801e73 <syscall>
  802205:	83 c4 18             	add    $0x18,%esp
}
  802208:	90                   	nop
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	50                   	push   %eax
  80221a:	6a 22                	push   $0x22
  80221c:	e8 52 fc ff ff       	call   801e73 <syscall>
  802221:	83 c4 18             	add    $0x18,%esp
}
  802224:	c9                   	leave  
  802225:	c3                   	ret    

00802226 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 02                	push   $0x2
  802235:	e8 39 fc ff ff       	call   801e73 <syscall>
  80223a:	83 c4 18             	add    $0x18,%esp
}
  80223d:	c9                   	leave  
  80223e:	c3                   	ret    

0080223f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 03                	push   $0x3
  80224e:	e8 20 fc ff ff       	call   801e73 <syscall>
  802253:	83 c4 18             	add    $0x18,%esp
}
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 04                	push   $0x4
  802267:	e8 07 fc ff ff       	call   801e73 <syscall>
  80226c:	83 c4 18             	add    $0x18,%esp
}
  80226f:	c9                   	leave  
  802270:	c3                   	ret    

00802271 <sys_exit_env>:


void sys_exit_env(void)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 23                	push   $0x23
  802280:	e8 ee fb ff ff       	call   801e73 <syscall>
  802285:	83 c4 18             	add    $0x18,%esp
}
  802288:	90                   	nop
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802291:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802294:	8d 50 04             	lea    0x4(%eax),%edx
  802297:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	52                   	push   %edx
  8022a1:	50                   	push   %eax
  8022a2:	6a 24                	push   $0x24
  8022a4:	e8 ca fb ff ff       	call   801e73 <syscall>
  8022a9:	83 c4 18             	add    $0x18,%esp
	return result;
  8022ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022b5:	89 01                	mov    %eax,(%ecx)
  8022b7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	c9                   	leave  
  8022be:	c2 04 00             	ret    $0x4

008022c1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	ff 75 10             	pushl  0x10(%ebp)
  8022cb:	ff 75 0c             	pushl  0xc(%ebp)
  8022ce:	ff 75 08             	pushl  0x8(%ebp)
  8022d1:	6a 12                	push   $0x12
  8022d3:	e8 9b fb ff ff       	call   801e73 <syscall>
  8022d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8022db:	90                   	nop
}
  8022dc:	c9                   	leave  
  8022dd:	c3                   	ret    

008022de <sys_rcr2>:
uint32 sys_rcr2()
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 25                	push   $0x25
  8022ed:	e8 81 fb ff ff       	call   801e73 <syscall>
  8022f2:	83 c4 18             	add    $0x18,%esp
}
  8022f5:	c9                   	leave  
  8022f6:	c3                   	ret    

008022f7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022f7:	55                   	push   %ebp
  8022f8:	89 e5                	mov    %esp,%ebp
  8022fa:	83 ec 04             	sub    $0x4,%esp
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802303:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	50                   	push   %eax
  802310:	6a 26                	push   $0x26
  802312:	e8 5c fb ff ff       	call   801e73 <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
	return ;
  80231a:	90                   	nop
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <rsttst>:
void rsttst()
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 28                	push   $0x28
  80232c:	e8 42 fb ff ff       	call   801e73 <syscall>
  802331:	83 c4 18             	add    $0x18,%esp
	return ;
  802334:	90                   	nop
}
  802335:	c9                   	leave  
  802336:	c3                   	ret    

00802337 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
  80233a:	83 ec 04             	sub    $0x4,%esp
  80233d:	8b 45 14             	mov    0x14(%ebp),%eax
  802340:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802343:	8b 55 18             	mov    0x18(%ebp),%edx
  802346:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80234a:	52                   	push   %edx
  80234b:	50                   	push   %eax
  80234c:	ff 75 10             	pushl  0x10(%ebp)
  80234f:	ff 75 0c             	pushl  0xc(%ebp)
  802352:	ff 75 08             	pushl  0x8(%ebp)
  802355:	6a 27                	push   $0x27
  802357:	e8 17 fb ff ff       	call   801e73 <syscall>
  80235c:	83 c4 18             	add    $0x18,%esp
	return ;
  80235f:	90                   	nop
}
  802360:	c9                   	leave  
  802361:	c3                   	ret    

00802362 <chktst>:
void chktst(uint32 n)
{
  802362:	55                   	push   %ebp
  802363:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	ff 75 08             	pushl  0x8(%ebp)
  802370:	6a 29                	push   $0x29
  802372:	e8 fc fa ff ff       	call   801e73 <syscall>
  802377:	83 c4 18             	add    $0x18,%esp
	return ;
  80237a:	90                   	nop
}
  80237b:	c9                   	leave  
  80237c:	c3                   	ret    

0080237d <inctst>:

void inctst()
{
  80237d:	55                   	push   %ebp
  80237e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 2a                	push   $0x2a
  80238c:	e8 e2 fa ff ff       	call   801e73 <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
	return ;
  802394:	90                   	nop
}
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <gettst>:
uint32 gettst()
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 2b                	push   $0x2b
  8023a6:	e8 c8 fa ff ff       	call   801e73 <syscall>
  8023ab:	83 c4 18             	add    $0x18,%esp
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 2c                	push   $0x2c
  8023c2:	e8 ac fa ff ff       	call   801e73 <syscall>
  8023c7:	83 c4 18             	add    $0x18,%esp
  8023ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023cd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023d1:	75 07                	jne    8023da <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d8:	eb 05                	jmp    8023df <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
  8023e4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 2c                	push   $0x2c
  8023f3:	e8 7b fa ff ff       	call   801e73 <syscall>
  8023f8:	83 c4 18             	add    $0x18,%esp
  8023fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023fe:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802402:	75 07                	jne    80240b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802404:	b8 01 00 00 00       	mov    $0x1,%eax
  802409:	eb 05                	jmp    802410 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80240b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 2c                	push   $0x2c
  802424:	e8 4a fa ff ff       	call   801e73 <syscall>
  802429:	83 c4 18             	add    $0x18,%esp
  80242c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80242f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802433:	75 07                	jne    80243c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802435:	b8 01 00 00 00       	mov    $0x1,%eax
  80243a:	eb 05                	jmp    802441 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80243c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802441:	c9                   	leave  
  802442:	c3                   	ret    

00802443 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  802455:	e8 19 fa ff ff       	call   801e73 <syscall>
  80245a:	83 c4 18             	add    $0x18,%esp
  80245d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802460:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802464:	75 07                	jne    80246d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802466:	b8 01 00 00 00       	mov    $0x1,%eax
  80246b:	eb 05                	jmp    802472 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80246d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802472:	c9                   	leave  
  802473:	c3                   	ret    

00802474 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	ff 75 08             	pushl  0x8(%ebp)
  802482:	6a 2d                	push   $0x2d
  802484:	e8 ea f9 ff ff       	call   801e73 <syscall>
  802489:	83 c4 18             	add    $0x18,%esp
	return ;
  80248c:	90                   	nop
}
  80248d:	c9                   	leave  
  80248e:	c3                   	ret    

0080248f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
  802492:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802493:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802496:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249c:	8b 45 08             	mov    0x8(%ebp),%eax
  80249f:	6a 00                	push   $0x0
  8024a1:	53                   	push   %ebx
  8024a2:	51                   	push   %ecx
  8024a3:	52                   	push   %edx
  8024a4:	50                   	push   %eax
  8024a5:	6a 2e                	push   $0x2e
  8024a7:	e8 c7 f9 ff ff       	call   801e73 <syscall>
  8024ac:	83 c4 18             	add    $0x18,%esp
}
  8024af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024b2:	c9                   	leave  
  8024b3:	c3                   	ret    

008024b4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	52                   	push   %edx
  8024c4:	50                   	push   %eax
  8024c5:	6a 2f                	push   $0x2f
  8024c7:	e8 a7 f9 ff ff       	call   801e73 <syscall>
  8024cc:	83 c4 18             	add    $0x18,%esp
}
  8024cf:	c9                   	leave  
  8024d0:	c3                   	ret    

008024d1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
  8024d4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024d7:	83 ec 0c             	sub    $0xc,%esp
  8024da:	68 c0 40 80 00       	push   $0x8040c0
  8024df:	e8 c3 e6 ff ff       	call   800ba7 <cprintf>
  8024e4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024ee:	83 ec 0c             	sub    $0xc,%esp
  8024f1:	68 ec 40 80 00       	push   $0x8040ec
  8024f6:	e8 ac e6 ff ff       	call   800ba7 <cprintf>
  8024fb:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024fe:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802502:	a1 38 51 80 00       	mov    0x805138,%eax
  802507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250a:	eb 56                	jmp    802562 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80250c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802510:	74 1c                	je     80252e <print_mem_block_lists+0x5d>
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 50 08             	mov    0x8(%eax),%edx
  802518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251b:	8b 48 08             	mov    0x8(%eax),%ecx
  80251e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802521:	8b 40 0c             	mov    0xc(%eax),%eax
  802524:	01 c8                	add    %ecx,%eax
  802526:	39 c2                	cmp    %eax,%edx
  802528:	73 04                	jae    80252e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80252a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	8b 50 08             	mov    0x8(%eax),%edx
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 40 0c             	mov    0xc(%eax),%eax
  80253a:	01 c2                	add    %eax,%edx
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 40 08             	mov    0x8(%eax),%eax
  802542:	83 ec 04             	sub    $0x4,%esp
  802545:	52                   	push   %edx
  802546:	50                   	push   %eax
  802547:	68 01 41 80 00       	push   $0x804101
  80254c:	e8 56 e6 ff ff       	call   800ba7 <cprintf>
  802551:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80255a:	a1 40 51 80 00       	mov    0x805140,%eax
  80255f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802566:	74 07                	je     80256f <print_mem_block_lists+0x9e>
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	8b 00                	mov    (%eax),%eax
  80256d:	eb 05                	jmp    802574 <print_mem_block_lists+0xa3>
  80256f:	b8 00 00 00 00       	mov    $0x0,%eax
  802574:	a3 40 51 80 00       	mov    %eax,0x805140
  802579:	a1 40 51 80 00       	mov    0x805140,%eax
  80257e:	85 c0                	test   %eax,%eax
  802580:	75 8a                	jne    80250c <print_mem_block_lists+0x3b>
  802582:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802586:	75 84                	jne    80250c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802588:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80258c:	75 10                	jne    80259e <print_mem_block_lists+0xcd>
  80258e:	83 ec 0c             	sub    $0xc,%esp
  802591:	68 10 41 80 00       	push   $0x804110
  802596:	e8 0c e6 ff ff       	call   800ba7 <cprintf>
  80259b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80259e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025a5:	83 ec 0c             	sub    $0xc,%esp
  8025a8:	68 34 41 80 00       	push   $0x804134
  8025ad:	e8 f5 e5 ff ff       	call   800ba7 <cprintf>
  8025b2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025b5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025b9:	a1 40 50 80 00       	mov    0x805040,%eax
  8025be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c1:	eb 56                	jmp    802619 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c7:	74 1c                	je     8025e5 <print_mem_block_lists+0x114>
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 50 08             	mov    0x8(%eax),%edx
  8025cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d2:	8b 48 08             	mov    0x8(%eax),%ecx
  8025d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025db:	01 c8                	add    %ecx,%eax
  8025dd:	39 c2                	cmp    %eax,%edx
  8025df:	73 04                	jae    8025e5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025e1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	8b 50 08             	mov    0x8(%eax),%edx
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f1:	01 c2                	add    %eax,%edx
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 40 08             	mov    0x8(%eax),%eax
  8025f9:	83 ec 04             	sub    $0x4,%esp
  8025fc:	52                   	push   %edx
  8025fd:	50                   	push   %eax
  8025fe:	68 01 41 80 00       	push   $0x804101
  802603:	e8 9f e5 ff ff       	call   800ba7 <cprintf>
  802608:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802611:	a1 48 50 80 00       	mov    0x805048,%eax
  802616:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261d:	74 07                	je     802626 <print_mem_block_lists+0x155>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 00                	mov    (%eax),%eax
  802624:	eb 05                	jmp    80262b <print_mem_block_lists+0x15a>
  802626:	b8 00 00 00 00       	mov    $0x0,%eax
  80262b:	a3 48 50 80 00       	mov    %eax,0x805048
  802630:	a1 48 50 80 00       	mov    0x805048,%eax
  802635:	85 c0                	test   %eax,%eax
  802637:	75 8a                	jne    8025c3 <print_mem_block_lists+0xf2>
  802639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263d:	75 84                	jne    8025c3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80263f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802643:	75 10                	jne    802655 <print_mem_block_lists+0x184>
  802645:	83 ec 0c             	sub    $0xc,%esp
  802648:	68 4c 41 80 00       	push   $0x80414c
  80264d:	e8 55 e5 ff ff       	call   800ba7 <cprintf>
  802652:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802655:	83 ec 0c             	sub    $0xc,%esp
  802658:	68 c0 40 80 00       	push   $0x8040c0
  80265d:	e8 45 e5 ff ff       	call   800ba7 <cprintf>
  802662:	83 c4 10             	add    $0x10,%esp

}
  802665:	90                   	nop
  802666:	c9                   	leave  
  802667:	c3                   	ret    

00802668 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802668:	55                   	push   %ebp
  802669:	89 e5                	mov    %esp,%ebp
  80266b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  80266e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802675:	00 00 00 
  802678:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80267f:	00 00 00 
  802682:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802689:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80268c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802693:	e9 9e 00 00 00       	jmp    802736 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802698:	a1 50 50 80 00       	mov    0x805050,%eax
  80269d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a0:	c1 e2 04             	shl    $0x4,%edx
  8026a3:	01 d0                	add    %edx,%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	75 14                	jne    8026bd <initialize_MemBlocksList+0x55>
  8026a9:	83 ec 04             	sub    $0x4,%esp
  8026ac:	68 74 41 80 00       	push   $0x804174
  8026b1:	6a 47                	push   $0x47
  8026b3:	68 97 41 80 00       	push   $0x804197
  8026b8:	e8 36 e2 ff ff       	call   8008f3 <_panic>
  8026bd:	a1 50 50 80 00       	mov    0x805050,%eax
  8026c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c5:	c1 e2 04             	shl    $0x4,%edx
  8026c8:	01 d0                	add    %edx,%eax
  8026ca:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026d0:	89 10                	mov    %edx,(%eax)
  8026d2:	8b 00                	mov    (%eax),%eax
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	74 18                	je     8026f0 <initialize_MemBlocksList+0x88>
  8026d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8026dd:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026e3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026e6:	c1 e1 04             	shl    $0x4,%ecx
  8026e9:	01 ca                	add    %ecx,%edx
  8026eb:	89 50 04             	mov    %edx,0x4(%eax)
  8026ee:	eb 12                	jmp    802702 <initialize_MemBlocksList+0x9a>
  8026f0:	a1 50 50 80 00       	mov    0x805050,%eax
  8026f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f8:	c1 e2 04             	shl    $0x4,%edx
  8026fb:	01 d0                	add    %edx,%eax
  8026fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802702:	a1 50 50 80 00       	mov    0x805050,%eax
  802707:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270a:	c1 e2 04             	shl    $0x4,%edx
  80270d:	01 d0                	add    %edx,%eax
  80270f:	a3 48 51 80 00       	mov    %eax,0x805148
  802714:	a1 50 50 80 00       	mov    0x805050,%eax
  802719:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271c:	c1 e2 04             	shl    $0x4,%edx
  80271f:	01 d0                	add    %edx,%eax
  802721:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802728:	a1 54 51 80 00       	mov    0x805154,%eax
  80272d:	40                   	inc    %eax
  80272e:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802733:	ff 45 f4             	incl   -0xc(%ebp)
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273c:	0f 82 56 ff ff ff    	jb     802698 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802742:	90                   	nop
  802743:	c9                   	leave  
  802744:	c3                   	ret    

00802745 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802745:	55                   	push   %ebp
  802746:	89 e5                	mov    %esp,%ebp
  802748:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	8b 00                	mov    (%eax),%eax
  802750:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802753:	eb 19                	jmp    80276e <find_block+0x29>
	{
		if(element->sva == va){
  802755:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802758:	8b 40 08             	mov    0x8(%eax),%eax
  80275b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80275e:	75 05                	jne    802765 <find_block+0x20>
			 		return element;
  802760:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802763:	eb 36                	jmp    80279b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802765:	8b 45 08             	mov    0x8(%ebp),%eax
  802768:	8b 40 08             	mov    0x8(%eax),%eax
  80276b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80276e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802772:	74 07                	je     80277b <find_block+0x36>
  802774:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	eb 05                	jmp    802780 <find_block+0x3b>
  80277b:	b8 00 00 00 00       	mov    $0x0,%eax
  802780:	8b 55 08             	mov    0x8(%ebp),%edx
  802783:	89 42 08             	mov    %eax,0x8(%edx)
  802786:	8b 45 08             	mov    0x8(%ebp),%eax
  802789:	8b 40 08             	mov    0x8(%eax),%eax
  80278c:	85 c0                	test   %eax,%eax
  80278e:	75 c5                	jne    802755 <find_block+0x10>
  802790:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802794:	75 bf                	jne    802755 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802796:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80279b:	c9                   	leave  
  80279c:	c3                   	ret    

0080279d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80279d:	55                   	push   %ebp
  80279e:	89 e5                	mov    %esp,%ebp
  8027a0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  8027a3:	a1 44 50 80 00       	mov    0x805044,%eax
  8027a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  8027ab:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  8027b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027b7:	74 0a                	je     8027c3 <insert_sorted_allocList+0x26>
  8027b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bc:	8b 40 08             	mov    0x8(%eax),%eax
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	75 65                	jne    802828 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8027c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027c7:	75 14                	jne    8027dd <insert_sorted_allocList+0x40>
  8027c9:	83 ec 04             	sub    $0x4,%esp
  8027cc:	68 74 41 80 00       	push   $0x804174
  8027d1:	6a 6e                	push   $0x6e
  8027d3:	68 97 41 80 00       	push   $0x804197
  8027d8:	e8 16 e1 ff ff       	call   8008f3 <_panic>
  8027dd:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e6:	89 10                	mov    %edx,(%eax)
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	74 0d                	je     8027fe <insert_sorted_allocList+0x61>
  8027f1:	a1 40 50 80 00       	mov    0x805040,%eax
  8027f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f9:	89 50 04             	mov    %edx,0x4(%eax)
  8027fc:	eb 08                	jmp    802806 <insert_sorted_allocList+0x69>
  8027fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802801:	a3 44 50 80 00       	mov    %eax,0x805044
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	a3 40 50 80 00       	mov    %eax,0x805040
  80280e:	8b 45 08             	mov    0x8(%ebp),%eax
  802811:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802818:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80281d:	40                   	inc    %eax
  80281e:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802823:	e9 cf 01 00 00       	jmp    8029f7 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282b:	8b 50 08             	mov    0x8(%eax),%edx
  80282e:	8b 45 08             	mov    0x8(%ebp),%eax
  802831:	8b 40 08             	mov    0x8(%eax),%eax
  802834:	39 c2                	cmp    %eax,%edx
  802836:	73 65                	jae    80289d <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802838:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80283c:	75 14                	jne    802852 <insert_sorted_allocList+0xb5>
  80283e:	83 ec 04             	sub    $0x4,%esp
  802841:	68 b0 41 80 00       	push   $0x8041b0
  802846:	6a 72                	push   $0x72
  802848:	68 97 41 80 00       	push   $0x804197
  80284d:	e8 a1 e0 ff ff       	call   8008f3 <_panic>
  802852:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802858:	8b 45 08             	mov    0x8(%ebp),%eax
  80285b:	89 50 04             	mov    %edx,0x4(%eax)
  80285e:	8b 45 08             	mov    0x8(%ebp),%eax
  802861:	8b 40 04             	mov    0x4(%eax),%eax
  802864:	85 c0                	test   %eax,%eax
  802866:	74 0c                	je     802874 <insert_sorted_allocList+0xd7>
  802868:	a1 44 50 80 00       	mov    0x805044,%eax
  80286d:	8b 55 08             	mov    0x8(%ebp),%edx
  802870:	89 10                	mov    %edx,(%eax)
  802872:	eb 08                	jmp    80287c <insert_sorted_allocList+0xdf>
  802874:	8b 45 08             	mov    0x8(%ebp),%eax
  802877:	a3 40 50 80 00       	mov    %eax,0x805040
  80287c:	8b 45 08             	mov    0x8(%ebp),%eax
  80287f:	a3 44 50 80 00       	mov    %eax,0x805044
  802884:	8b 45 08             	mov    0x8(%ebp),%eax
  802887:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802892:	40                   	inc    %eax
  802893:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802898:	e9 5a 01 00 00       	jmp    8029f7 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  80289d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a0:	8b 50 08             	mov    0x8(%eax),%edx
  8028a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a6:	8b 40 08             	mov    0x8(%eax),%eax
  8028a9:	39 c2                	cmp    %eax,%edx
  8028ab:	75 70                	jne    80291d <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  8028ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b1:	74 06                	je     8028b9 <insert_sorted_allocList+0x11c>
  8028b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028b7:	75 14                	jne    8028cd <insert_sorted_allocList+0x130>
  8028b9:	83 ec 04             	sub    $0x4,%esp
  8028bc:	68 d4 41 80 00       	push   $0x8041d4
  8028c1:	6a 75                	push   $0x75
  8028c3:	68 97 41 80 00       	push   $0x804197
  8028c8:	e8 26 e0 ff ff       	call   8008f3 <_panic>
  8028cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d0:	8b 10                	mov    (%eax),%edx
  8028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d5:	89 10                	mov    %edx,(%eax)
  8028d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028da:	8b 00                	mov    (%eax),%eax
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	74 0b                	je     8028eb <insert_sorted_allocList+0x14e>
  8028e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e8:	89 50 04             	mov    %edx,0x4(%eax)
  8028eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f1:	89 10                	mov    %edx,(%eax)
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f9:	89 50 04             	mov    %edx,0x4(%eax)
  8028fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ff:	8b 00                	mov    (%eax),%eax
  802901:	85 c0                	test   %eax,%eax
  802903:	75 08                	jne    80290d <insert_sorted_allocList+0x170>
  802905:	8b 45 08             	mov    0x8(%ebp),%eax
  802908:	a3 44 50 80 00       	mov    %eax,0x805044
  80290d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802912:	40                   	inc    %eax
  802913:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802918:	e9 da 00 00 00       	jmp    8029f7 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80291d:	a1 40 50 80 00       	mov    0x805040,%eax
  802922:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802925:	e9 9d 00 00 00       	jmp    8029c7 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 00                	mov    (%eax),%eax
  80292f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802932:	8b 45 08             	mov    0x8(%ebp),%eax
  802935:	8b 50 08             	mov    0x8(%eax),%edx
  802938:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293b:	8b 40 08             	mov    0x8(%eax),%eax
  80293e:	39 c2                	cmp    %eax,%edx
  802940:	76 7d                	jbe    8029bf <insert_sorted_allocList+0x222>
  802942:	8b 45 08             	mov    0x8(%ebp),%eax
  802945:	8b 50 08             	mov    0x8(%eax),%edx
  802948:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294b:	8b 40 08             	mov    0x8(%eax),%eax
  80294e:	39 c2                	cmp    %eax,%edx
  802950:	73 6d                	jae    8029bf <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802952:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802956:	74 06                	je     80295e <insert_sorted_allocList+0x1c1>
  802958:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80295c:	75 14                	jne    802972 <insert_sorted_allocList+0x1d5>
  80295e:	83 ec 04             	sub    $0x4,%esp
  802961:	68 d4 41 80 00       	push   $0x8041d4
  802966:	6a 7c                	push   $0x7c
  802968:	68 97 41 80 00       	push   $0x804197
  80296d:	e8 81 df ff ff       	call   8008f3 <_panic>
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 10                	mov    (%eax),%edx
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	89 10                	mov    %edx,(%eax)
  80297c:	8b 45 08             	mov    0x8(%ebp),%eax
  80297f:	8b 00                	mov    (%eax),%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	74 0b                	je     802990 <insert_sorted_allocList+0x1f3>
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	8b 00                	mov    (%eax),%eax
  80298a:	8b 55 08             	mov    0x8(%ebp),%edx
  80298d:	89 50 04             	mov    %edx,0x4(%eax)
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	8b 55 08             	mov    0x8(%ebp),%edx
  802996:	89 10                	mov    %edx,(%eax)
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80299e:	89 50 04             	mov    %edx,0x4(%eax)
  8029a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a4:	8b 00                	mov    (%eax),%eax
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	75 08                	jne    8029b2 <insert_sorted_allocList+0x215>
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	a3 44 50 80 00       	mov    %eax,0x805044
  8029b2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029b7:	40                   	inc    %eax
  8029b8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8029bd:	eb 38                	jmp    8029f7 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8029bf:	a1 48 50 80 00       	mov    0x805048,%eax
  8029c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cb:	74 07                	je     8029d4 <insert_sorted_allocList+0x237>
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	eb 05                	jmp    8029d9 <insert_sorted_allocList+0x23c>
  8029d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d9:	a3 48 50 80 00       	mov    %eax,0x805048
  8029de:	a1 48 50 80 00       	mov    0x805048,%eax
  8029e3:	85 c0                	test   %eax,%eax
  8029e5:	0f 85 3f ff ff ff    	jne    80292a <insert_sorted_allocList+0x18d>
  8029eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ef:	0f 85 35 ff ff ff    	jne    80292a <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8029f5:	eb 00                	jmp    8029f7 <insert_sorted_allocList+0x25a>
  8029f7:	90                   	nop
  8029f8:	c9                   	leave  
  8029f9:	c3                   	ret    

008029fa <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8029fa:	55                   	push   %ebp
  8029fb:	89 e5                	mov    %esp,%ebp
  8029fd:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802a00:	a1 38 51 80 00       	mov    0x805138,%eax
  802a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a08:	e9 6b 02 00 00       	jmp    802c78 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 40 0c             	mov    0xc(%eax),%eax
  802a13:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a16:	0f 85 90 00 00 00    	jne    802aac <alloc_block_FF+0xb2>
			  temp=element;
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802a22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a26:	75 17                	jne    802a3f <alloc_block_FF+0x45>
  802a28:	83 ec 04             	sub    $0x4,%esp
  802a2b:	68 08 42 80 00       	push   $0x804208
  802a30:	68 92 00 00 00       	push   $0x92
  802a35:	68 97 41 80 00       	push   $0x804197
  802a3a:	e8 b4 de ff ff       	call   8008f3 <_panic>
  802a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a42:	8b 00                	mov    (%eax),%eax
  802a44:	85 c0                	test   %eax,%eax
  802a46:	74 10                	je     802a58 <alloc_block_FF+0x5e>
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 00                	mov    (%eax),%eax
  802a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a50:	8b 52 04             	mov    0x4(%edx),%edx
  802a53:	89 50 04             	mov    %edx,0x4(%eax)
  802a56:	eb 0b                	jmp    802a63 <alloc_block_FF+0x69>
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	8b 40 04             	mov    0x4(%eax),%eax
  802a5e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 40 04             	mov    0x4(%eax),%eax
  802a69:	85 c0                	test   %eax,%eax
  802a6b:	74 0f                	je     802a7c <alloc_block_FF+0x82>
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 40 04             	mov    0x4(%eax),%eax
  802a73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a76:	8b 12                	mov    (%edx),%edx
  802a78:	89 10                	mov    %edx,(%eax)
  802a7a:	eb 0a                	jmp    802a86 <alloc_block_FF+0x8c>
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 00                	mov    (%eax),%eax
  802a81:	a3 38 51 80 00       	mov    %eax,0x805138
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a99:	a1 44 51 80 00       	mov    0x805144,%eax
  802a9e:	48                   	dec    %eax
  802a9f:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802aa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa7:	e9 ff 01 00 00       	jmp    802cab <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab5:	0f 86 b5 01 00 00    	jbe    802c70 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac1:	2b 45 08             	sub    0x8(%ebp),%eax
  802ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802ac7:	a1 48 51 80 00       	mov    0x805148,%eax
  802acc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802acf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ad3:	75 17                	jne    802aec <alloc_block_FF+0xf2>
  802ad5:	83 ec 04             	sub    $0x4,%esp
  802ad8:	68 08 42 80 00       	push   $0x804208
  802add:	68 99 00 00 00       	push   $0x99
  802ae2:	68 97 41 80 00       	push   $0x804197
  802ae7:	e8 07 de ff ff       	call   8008f3 <_panic>
  802aec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aef:	8b 00                	mov    (%eax),%eax
  802af1:	85 c0                	test   %eax,%eax
  802af3:	74 10                	je     802b05 <alloc_block_FF+0x10b>
  802af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af8:	8b 00                	mov    (%eax),%eax
  802afa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802afd:	8b 52 04             	mov    0x4(%edx),%edx
  802b00:	89 50 04             	mov    %edx,0x4(%eax)
  802b03:	eb 0b                	jmp    802b10 <alloc_block_FF+0x116>
  802b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b08:	8b 40 04             	mov    0x4(%eax),%eax
  802b0b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b13:	8b 40 04             	mov    0x4(%eax),%eax
  802b16:	85 c0                	test   %eax,%eax
  802b18:	74 0f                	je     802b29 <alloc_block_FF+0x12f>
  802b1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1d:	8b 40 04             	mov    0x4(%eax),%eax
  802b20:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b23:	8b 12                	mov    (%edx),%edx
  802b25:	89 10                	mov    %edx,(%eax)
  802b27:	eb 0a                	jmp    802b33 <alloc_block_FF+0x139>
  802b29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2c:	8b 00                	mov    (%eax),%eax
  802b2e:	a3 48 51 80 00       	mov    %eax,0x805148
  802b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b46:	a1 54 51 80 00       	mov    0x805154,%eax
  802b4b:	48                   	dec    %eax
  802b4c:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802b51:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b55:	75 17                	jne    802b6e <alloc_block_FF+0x174>
  802b57:	83 ec 04             	sub    $0x4,%esp
  802b5a:	68 b0 41 80 00       	push   $0x8041b0
  802b5f:	68 9a 00 00 00       	push   $0x9a
  802b64:	68 97 41 80 00       	push   $0x804197
  802b69:	e8 85 dd ff ff       	call   8008f3 <_panic>
  802b6e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b77:	89 50 04             	mov    %edx,0x4(%eax)
  802b7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7d:	8b 40 04             	mov    0x4(%eax),%eax
  802b80:	85 c0                	test   %eax,%eax
  802b82:	74 0c                	je     802b90 <alloc_block_FF+0x196>
  802b84:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b89:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b8c:	89 10                	mov    %edx,(%eax)
  802b8e:	eb 08                	jmp    802b98 <alloc_block_FF+0x19e>
  802b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b93:	a3 38 51 80 00       	mov    %eax,0x805138
  802b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba9:	a1 44 51 80 00       	mov    0x805144,%eax
  802bae:	40                   	inc    %eax
  802baf:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802bb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb7:	8b 55 08             	mov    0x8(%ebp),%edx
  802bba:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	8b 50 08             	mov    0x8(%eax),%edx
  802bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc6:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bcf:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 50 08             	mov    0x8(%eax),%edx
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	01 c2                	add    %eax,%edx
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802be3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802be9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bed:	75 17                	jne    802c06 <alloc_block_FF+0x20c>
  802bef:	83 ec 04             	sub    $0x4,%esp
  802bf2:	68 08 42 80 00       	push   $0x804208
  802bf7:	68 a2 00 00 00       	push   $0xa2
  802bfc:	68 97 41 80 00       	push   $0x804197
  802c01:	e8 ed dc ff ff       	call   8008f3 <_panic>
  802c06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c09:	8b 00                	mov    (%eax),%eax
  802c0b:	85 c0                	test   %eax,%eax
  802c0d:	74 10                	je     802c1f <alloc_block_FF+0x225>
  802c0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c12:	8b 00                	mov    (%eax),%eax
  802c14:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c17:	8b 52 04             	mov    0x4(%edx),%edx
  802c1a:	89 50 04             	mov    %edx,0x4(%eax)
  802c1d:	eb 0b                	jmp    802c2a <alloc_block_FF+0x230>
  802c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c22:	8b 40 04             	mov    0x4(%eax),%eax
  802c25:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2d:	8b 40 04             	mov    0x4(%eax),%eax
  802c30:	85 c0                	test   %eax,%eax
  802c32:	74 0f                	je     802c43 <alloc_block_FF+0x249>
  802c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c37:	8b 40 04             	mov    0x4(%eax),%eax
  802c3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c3d:	8b 12                	mov    (%edx),%edx
  802c3f:	89 10                	mov    %edx,(%eax)
  802c41:	eb 0a                	jmp    802c4d <alloc_block_FF+0x253>
  802c43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c46:	8b 00                	mov    (%eax),%eax
  802c48:	a3 38 51 80 00       	mov    %eax,0x805138
  802c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c60:	a1 44 51 80 00       	mov    0x805144,%eax
  802c65:	48                   	dec    %eax
  802c66:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802c6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c6e:	eb 3b                	jmp    802cab <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802c70:	a1 40 51 80 00       	mov    0x805140,%eax
  802c75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7c:	74 07                	je     802c85 <alloc_block_FF+0x28b>
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	eb 05                	jmp    802c8a <alloc_block_FF+0x290>
  802c85:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8a:	a3 40 51 80 00       	mov    %eax,0x805140
  802c8f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c94:	85 c0                	test   %eax,%eax
  802c96:	0f 85 71 fd ff ff    	jne    802a0d <alloc_block_FF+0x13>
  802c9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca0:	0f 85 67 fd ff ff    	jne    802a0d <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802ca6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cab:	c9                   	leave  
  802cac:	c3                   	ret    

00802cad <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802cad:	55                   	push   %ebp
  802cae:	89 e5                	mov    %esp,%ebp
  802cb0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802cb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802cba:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802cc1:	a1 38 51 80 00       	mov    0x805138,%eax
  802cc6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802cc9:	e9 d3 00 00 00       	jmp    802da1 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802cce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cd7:	0f 85 90 00 00 00    	jne    802d6d <alloc_block_BF+0xc0>
	   temp = element;
  802cdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802ce3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ce7:	75 17                	jne    802d00 <alloc_block_BF+0x53>
  802ce9:	83 ec 04             	sub    $0x4,%esp
  802cec:	68 08 42 80 00       	push   $0x804208
  802cf1:	68 bd 00 00 00       	push   $0xbd
  802cf6:	68 97 41 80 00       	push   $0x804197
  802cfb:	e8 f3 db ff ff       	call   8008f3 <_panic>
  802d00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d03:	8b 00                	mov    (%eax),%eax
  802d05:	85 c0                	test   %eax,%eax
  802d07:	74 10                	je     802d19 <alloc_block_BF+0x6c>
  802d09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0c:	8b 00                	mov    (%eax),%eax
  802d0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d11:	8b 52 04             	mov    0x4(%edx),%edx
  802d14:	89 50 04             	mov    %edx,0x4(%eax)
  802d17:	eb 0b                	jmp    802d24 <alloc_block_BF+0x77>
  802d19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1c:	8b 40 04             	mov    0x4(%eax),%eax
  802d1f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d27:	8b 40 04             	mov    0x4(%eax),%eax
  802d2a:	85 c0                	test   %eax,%eax
  802d2c:	74 0f                	je     802d3d <alloc_block_BF+0x90>
  802d2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d31:	8b 40 04             	mov    0x4(%eax),%eax
  802d34:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d37:	8b 12                	mov    (%edx),%edx
  802d39:	89 10                	mov    %edx,(%eax)
  802d3b:	eb 0a                	jmp    802d47 <alloc_block_BF+0x9a>
  802d3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d40:	8b 00                	mov    (%eax),%eax
  802d42:	a3 38 51 80 00       	mov    %eax,0x805138
  802d47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5a:	a1 44 51 80 00       	mov    0x805144,%eax
  802d5f:	48                   	dec    %eax
  802d60:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802d65:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d68:	e9 41 01 00 00       	jmp    802eae <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802d6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d70:	8b 40 0c             	mov    0xc(%eax),%eax
  802d73:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d76:	76 21                	jbe    802d99 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802d78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802d81:	73 16                	jae    802d99 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802d83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d86:	8b 40 0c             	mov    0xc(%eax),%eax
  802d89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802d8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802d92:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802d99:	a1 40 51 80 00       	mov    0x805140,%eax
  802d9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802da1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802da5:	74 07                	je     802dae <alloc_block_BF+0x101>
  802da7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802daa:	8b 00                	mov    (%eax),%eax
  802dac:	eb 05                	jmp    802db3 <alloc_block_BF+0x106>
  802dae:	b8 00 00 00 00       	mov    $0x0,%eax
  802db3:	a3 40 51 80 00       	mov    %eax,0x805140
  802db8:	a1 40 51 80 00       	mov    0x805140,%eax
  802dbd:	85 c0                	test   %eax,%eax
  802dbf:	0f 85 09 ff ff ff    	jne    802cce <alloc_block_BF+0x21>
  802dc5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802dc9:	0f 85 ff fe ff ff    	jne    802cce <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802dcf:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802dd3:	0f 85 d0 00 00 00    	jne    802ea9 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802dd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddf:	2b 45 08             	sub    0x8(%ebp),%eax
  802de2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802de5:	a1 48 51 80 00       	mov    0x805148,%eax
  802dea:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802ded:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802df1:	75 17                	jne    802e0a <alloc_block_BF+0x15d>
  802df3:	83 ec 04             	sub    $0x4,%esp
  802df6:	68 08 42 80 00       	push   $0x804208
  802dfb:	68 d1 00 00 00       	push   $0xd1
  802e00:	68 97 41 80 00       	push   $0x804197
  802e05:	e8 e9 da ff ff       	call   8008f3 <_panic>
  802e0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0d:	8b 00                	mov    (%eax),%eax
  802e0f:	85 c0                	test   %eax,%eax
  802e11:	74 10                	je     802e23 <alloc_block_BF+0x176>
  802e13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e16:	8b 00                	mov    (%eax),%eax
  802e18:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e1b:	8b 52 04             	mov    0x4(%edx),%edx
  802e1e:	89 50 04             	mov    %edx,0x4(%eax)
  802e21:	eb 0b                	jmp    802e2e <alloc_block_BF+0x181>
  802e23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e26:	8b 40 04             	mov    0x4(%eax),%eax
  802e29:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e31:	8b 40 04             	mov    0x4(%eax),%eax
  802e34:	85 c0                	test   %eax,%eax
  802e36:	74 0f                	je     802e47 <alloc_block_BF+0x19a>
  802e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e3b:	8b 40 04             	mov    0x4(%eax),%eax
  802e3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e41:	8b 12                	mov    (%edx),%edx
  802e43:	89 10                	mov    %edx,(%eax)
  802e45:	eb 0a                	jmp    802e51 <alloc_block_BF+0x1a4>
  802e47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e4a:	8b 00                	mov    (%eax),%eax
  802e4c:	a3 48 51 80 00       	mov    %eax,0x805148
  802e51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e64:	a1 54 51 80 00       	mov    0x805154,%eax
  802e69:	48                   	dec    %eax
  802e6a:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  802e6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e72:	8b 55 08             	mov    0x8(%ebp),%edx
  802e75:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802e78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7b:	8b 50 08             	mov    0x8(%eax),%edx
  802e7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e81:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e8a:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802e8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e90:	8b 50 08             	mov    0x8(%eax),%edx
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	01 c2                	add    %eax,%edx
  802e98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9b:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802e9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802ea4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ea7:	eb 05                	jmp    802eae <alloc_block_BF+0x201>
	 }
	 return NULL;
  802ea9:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802eae:	c9                   	leave  
  802eaf:	c3                   	ret    

00802eb0 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802eb0:	55                   	push   %ebp
  802eb1:	89 e5                	mov    %esp,%ebp
  802eb3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802eb6:	83 ec 04             	sub    $0x4,%esp
  802eb9:	68 28 42 80 00       	push   $0x804228
  802ebe:	68 e8 00 00 00       	push   $0xe8
  802ec3:	68 97 41 80 00       	push   $0x804197
  802ec8:	e8 26 da ff ff       	call   8008f3 <_panic>

00802ecd <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ecd:	55                   	push   %ebp
  802ece:	89 e5                	mov    %esp,%ebp
  802ed0:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802ed3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802edb:	a1 38 51 80 00       	mov    0x805138,%eax
  802ee0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802ee3:	a1 44 51 80 00       	mov    0x805144,%eax
  802ee8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802eeb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802eef:	75 68                	jne    802f59 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ef1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef5:	75 17                	jne    802f0e <insert_sorted_with_merge_freeList+0x41>
  802ef7:	83 ec 04             	sub    $0x4,%esp
  802efa:	68 74 41 80 00       	push   $0x804174
  802eff:	68 36 01 00 00       	push   $0x136
  802f04:	68 97 41 80 00       	push   $0x804197
  802f09:	e8 e5 d9 ff ff       	call   8008f3 <_panic>
  802f0e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	89 10                	mov    %edx,(%eax)
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	8b 00                	mov    (%eax),%eax
  802f1e:	85 c0                	test   %eax,%eax
  802f20:	74 0d                	je     802f2f <insert_sorted_with_merge_freeList+0x62>
  802f22:	a1 38 51 80 00       	mov    0x805138,%eax
  802f27:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2a:	89 50 04             	mov    %edx,0x4(%eax)
  802f2d:	eb 08                	jmp    802f37 <insert_sorted_with_merge_freeList+0x6a>
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f37:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3a:	a3 38 51 80 00       	mov    %eax,0x805138
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f49:	a1 44 51 80 00       	mov    0x805144,%eax
  802f4e:	40                   	inc    %eax
  802f4f:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802f54:	e9 ba 06 00 00       	jmp    803613 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5c:	8b 50 08             	mov    0x8(%eax),%edx
  802f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f62:	8b 40 0c             	mov    0xc(%eax),%eax
  802f65:	01 c2                	add    %eax,%edx
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	8b 40 08             	mov    0x8(%eax),%eax
  802f6d:	39 c2                	cmp    %eax,%edx
  802f6f:	73 68                	jae    802fd9 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f75:	75 17                	jne    802f8e <insert_sorted_with_merge_freeList+0xc1>
  802f77:	83 ec 04             	sub    $0x4,%esp
  802f7a:	68 b0 41 80 00       	push   $0x8041b0
  802f7f:	68 3a 01 00 00       	push   $0x13a
  802f84:	68 97 41 80 00       	push   $0x804197
  802f89:	e8 65 d9 ff ff       	call   8008f3 <_panic>
  802f8e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	89 50 04             	mov    %edx,0x4(%eax)
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	8b 40 04             	mov    0x4(%eax),%eax
  802fa0:	85 c0                	test   %eax,%eax
  802fa2:	74 0c                	je     802fb0 <insert_sorted_with_merge_freeList+0xe3>
  802fa4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fac:	89 10                	mov    %edx,(%eax)
  802fae:	eb 08                	jmp    802fb8 <insert_sorted_with_merge_freeList+0xeb>
  802fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb3:	a3 38 51 80 00       	mov    %eax,0x805138
  802fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc9:	a1 44 51 80 00       	mov    0x805144,%eax
  802fce:	40                   	inc    %eax
  802fcf:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802fd4:	e9 3a 06 00 00       	jmp    803613 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802fd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdc:	8b 50 08             	mov    0x8(%eax),%edx
  802fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe5:	01 c2                	add    %eax,%edx
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	8b 40 08             	mov    0x8(%eax),%eax
  802fed:	39 c2                	cmp    %eax,%edx
  802fef:	0f 85 90 00 00 00    	jne    803085 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff8:	8b 50 0c             	mov    0xc(%eax),%edx
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	8b 40 0c             	mov    0xc(%eax),%eax
  803001:	01 c2                	add    %eax,%edx
  803003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803006:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80301d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803021:	75 17                	jne    80303a <insert_sorted_with_merge_freeList+0x16d>
  803023:	83 ec 04             	sub    $0x4,%esp
  803026:	68 74 41 80 00       	push   $0x804174
  80302b:	68 41 01 00 00       	push   $0x141
  803030:	68 97 41 80 00       	push   $0x804197
  803035:	e8 b9 d8 ff ff       	call   8008f3 <_panic>
  80303a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	89 10                	mov    %edx,(%eax)
  803045:	8b 45 08             	mov    0x8(%ebp),%eax
  803048:	8b 00                	mov    (%eax),%eax
  80304a:	85 c0                	test   %eax,%eax
  80304c:	74 0d                	je     80305b <insert_sorted_with_merge_freeList+0x18e>
  80304e:	a1 48 51 80 00       	mov    0x805148,%eax
  803053:	8b 55 08             	mov    0x8(%ebp),%edx
  803056:	89 50 04             	mov    %edx,0x4(%eax)
  803059:	eb 08                	jmp    803063 <insert_sorted_with_merge_freeList+0x196>
  80305b:	8b 45 08             	mov    0x8(%ebp),%eax
  80305e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803063:	8b 45 08             	mov    0x8(%ebp),%eax
  803066:	a3 48 51 80 00       	mov    %eax,0x805148
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803075:	a1 54 51 80 00       	mov    0x805154,%eax
  80307a:	40                   	inc    %eax
  80307b:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803080:	e9 8e 05 00 00       	jmp    803613 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	8b 50 08             	mov    0x8(%eax),%edx
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	8b 40 0c             	mov    0xc(%eax),%eax
  803091:	01 c2                	add    %eax,%edx
  803093:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803096:	8b 40 08             	mov    0x8(%eax),%eax
  803099:	39 c2                	cmp    %eax,%edx
  80309b:	73 68                	jae    803105 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80309d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a1:	75 17                	jne    8030ba <insert_sorted_with_merge_freeList+0x1ed>
  8030a3:	83 ec 04             	sub    $0x4,%esp
  8030a6:	68 74 41 80 00       	push   $0x804174
  8030ab:	68 45 01 00 00       	push   $0x145
  8030b0:	68 97 41 80 00       	push   $0x804197
  8030b5:	e8 39 d8 ff ff       	call   8008f3 <_panic>
  8030ba:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c3:	89 10                	mov    %edx,(%eax)
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	8b 00                	mov    (%eax),%eax
  8030ca:	85 c0                	test   %eax,%eax
  8030cc:	74 0d                	je     8030db <insert_sorted_with_merge_freeList+0x20e>
  8030ce:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d6:	89 50 04             	mov    %edx,0x4(%eax)
  8030d9:	eb 08                	jmp    8030e3 <insert_sorted_with_merge_freeList+0x216>
  8030db:	8b 45 08             	mov    0x8(%ebp),%eax
  8030de:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	a3 38 51 80 00       	mov    %eax,0x805138
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f5:	a1 44 51 80 00       	mov    0x805144,%eax
  8030fa:	40                   	inc    %eax
  8030fb:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803100:	e9 0e 05 00 00       	jmp    803613 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	8b 50 08             	mov    0x8(%eax),%edx
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	8b 40 0c             	mov    0xc(%eax),%eax
  803111:	01 c2                	add    %eax,%edx
  803113:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803116:	8b 40 08             	mov    0x8(%eax),%eax
  803119:	39 c2                	cmp    %eax,%edx
  80311b:	0f 85 9c 00 00 00    	jne    8031bd <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  803121:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803124:	8b 50 0c             	mov    0xc(%eax),%edx
  803127:	8b 45 08             	mov    0x8(%ebp),%eax
  80312a:	8b 40 0c             	mov    0xc(%eax),%eax
  80312d:	01 c2                	add    %eax,%edx
  80312f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803132:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  803135:	8b 45 08             	mov    0x8(%ebp),%eax
  803138:	8b 50 08             	mov    0x8(%eax),%edx
  80313b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313e:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803155:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803159:	75 17                	jne    803172 <insert_sorted_with_merge_freeList+0x2a5>
  80315b:	83 ec 04             	sub    $0x4,%esp
  80315e:	68 74 41 80 00       	push   $0x804174
  803163:	68 4d 01 00 00       	push   $0x14d
  803168:	68 97 41 80 00       	push   $0x804197
  80316d:	e8 81 d7 ff ff       	call   8008f3 <_panic>
  803172:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803178:	8b 45 08             	mov    0x8(%ebp),%eax
  80317b:	89 10                	mov    %edx,(%eax)
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	8b 00                	mov    (%eax),%eax
  803182:	85 c0                	test   %eax,%eax
  803184:	74 0d                	je     803193 <insert_sorted_with_merge_freeList+0x2c6>
  803186:	a1 48 51 80 00       	mov    0x805148,%eax
  80318b:	8b 55 08             	mov    0x8(%ebp),%edx
  80318e:	89 50 04             	mov    %edx,0x4(%eax)
  803191:	eb 08                	jmp    80319b <insert_sorted_with_merge_freeList+0x2ce>
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	a3 48 51 80 00       	mov    %eax,0x805148
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ad:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b2:	40                   	inc    %eax
  8031b3:	a3 54 51 80 00       	mov    %eax,0x805154





}
  8031b8:	e9 56 04 00 00       	jmp    803613 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8031bd:	a1 38 51 80 00       	mov    0x805138,%eax
  8031c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c5:	e9 19 04 00 00       	jmp    8035e3 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  8031ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cd:	8b 00                	mov    (%eax),%eax
  8031cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  8031d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d5:	8b 50 08             	mov    0x8(%eax),%edx
  8031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031db:	8b 40 0c             	mov    0xc(%eax),%eax
  8031de:	01 c2                	add    %eax,%edx
  8031e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e3:	8b 40 08             	mov    0x8(%eax),%eax
  8031e6:	39 c2                	cmp    %eax,%edx
  8031e8:	0f 85 ad 01 00 00    	jne    80339b <insert_sorted_with_merge_freeList+0x4ce>
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	8b 50 08             	mov    0x8(%eax),%edx
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fa:	01 c2                	add    %eax,%edx
  8031fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ff:	8b 40 08             	mov    0x8(%eax),%eax
  803202:	39 c2                	cmp    %eax,%edx
  803204:	0f 85 91 01 00 00    	jne    80339b <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  80320a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320d:	8b 50 0c             	mov    0xc(%eax),%edx
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	8b 48 0c             	mov    0xc(%eax),%ecx
  803216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803219:	8b 40 0c             	mov    0xc(%eax),%eax
  80321c:	01 c8                	add    %ecx,%eax
  80321e:	01 c2                	add    %eax,%edx
  803220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803223:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  803226:	8b 45 08             	mov    0x8(%ebp),%eax
  803229:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  80323a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  803244:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803247:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  80324e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803252:	75 17                	jne    80326b <insert_sorted_with_merge_freeList+0x39e>
  803254:	83 ec 04             	sub    $0x4,%esp
  803257:	68 08 42 80 00       	push   $0x804208
  80325c:	68 5b 01 00 00       	push   $0x15b
  803261:	68 97 41 80 00       	push   $0x804197
  803266:	e8 88 d6 ff ff       	call   8008f3 <_panic>
  80326b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80326e:	8b 00                	mov    (%eax),%eax
  803270:	85 c0                	test   %eax,%eax
  803272:	74 10                	je     803284 <insert_sorted_with_merge_freeList+0x3b7>
  803274:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803277:	8b 00                	mov    (%eax),%eax
  803279:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80327c:	8b 52 04             	mov    0x4(%edx),%edx
  80327f:	89 50 04             	mov    %edx,0x4(%eax)
  803282:	eb 0b                	jmp    80328f <insert_sorted_with_merge_freeList+0x3c2>
  803284:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803287:	8b 40 04             	mov    0x4(%eax),%eax
  80328a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80328f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803292:	8b 40 04             	mov    0x4(%eax),%eax
  803295:	85 c0                	test   %eax,%eax
  803297:	74 0f                	je     8032a8 <insert_sorted_with_merge_freeList+0x3db>
  803299:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329c:	8b 40 04             	mov    0x4(%eax),%eax
  80329f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032a2:	8b 12                	mov    (%edx),%edx
  8032a4:	89 10                	mov    %edx,(%eax)
  8032a6:	eb 0a                	jmp    8032b2 <insert_sorted_with_merge_freeList+0x3e5>
  8032a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ab:	8b 00                	mov    (%eax),%eax
  8032ad:	a3 38 51 80 00       	mov    %eax,0x805138
  8032b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c5:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ca:	48                   	dec    %eax
  8032cb:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d4:	75 17                	jne    8032ed <insert_sorted_with_merge_freeList+0x420>
  8032d6:	83 ec 04             	sub    $0x4,%esp
  8032d9:	68 74 41 80 00       	push   $0x804174
  8032de:	68 5c 01 00 00       	push   $0x15c
  8032e3:	68 97 41 80 00       	push   $0x804197
  8032e8:	e8 06 d6 ff ff       	call   8008f3 <_panic>
  8032ed:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	89 10                	mov    %edx,(%eax)
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	8b 00                	mov    (%eax),%eax
  8032fd:	85 c0                	test   %eax,%eax
  8032ff:	74 0d                	je     80330e <insert_sorted_with_merge_freeList+0x441>
  803301:	a1 48 51 80 00       	mov    0x805148,%eax
  803306:	8b 55 08             	mov    0x8(%ebp),%edx
  803309:	89 50 04             	mov    %edx,0x4(%eax)
  80330c:	eb 08                	jmp    803316 <insert_sorted_with_merge_freeList+0x449>
  80330e:	8b 45 08             	mov    0x8(%ebp),%eax
  803311:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	a3 48 51 80 00       	mov    %eax,0x805148
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803328:	a1 54 51 80 00       	mov    0x805154,%eax
  80332d:	40                   	inc    %eax
  80332e:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  803333:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803337:	75 17                	jne    803350 <insert_sorted_with_merge_freeList+0x483>
  803339:	83 ec 04             	sub    $0x4,%esp
  80333c:	68 74 41 80 00       	push   $0x804174
  803341:	68 5d 01 00 00       	push   $0x15d
  803346:	68 97 41 80 00       	push   $0x804197
  80334b:	e8 a3 d5 ff ff       	call   8008f3 <_panic>
  803350:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803359:	89 10                	mov    %edx,(%eax)
  80335b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80335e:	8b 00                	mov    (%eax),%eax
  803360:	85 c0                	test   %eax,%eax
  803362:	74 0d                	je     803371 <insert_sorted_with_merge_freeList+0x4a4>
  803364:	a1 48 51 80 00       	mov    0x805148,%eax
  803369:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80336c:	89 50 04             	mov    %edx,0x4(%eax)
  80336f:	eb 08                	jmp    803379 <insert_sorted_with_merge_freeList+0x4ac>
  803371:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803374:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803379:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80337c:	a3 48 51 80 00       	mov    %eax,0x805148
  803381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803384:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80338b:	a1 54 51 80 00       	mov    0x805154,%eax
  803390:	40                   	inc    %eax
  803391:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803396:	e9 78 02 00 00       	jmp    803613 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  80339b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339e:	8b 50 08             	mov    0x8(%eax),%edx
  8033a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a7:	01 c2                	add    %eax,%edx
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	8b 40 08             	mov    0x8(%eax),%eax
  8033af:	39 c2                	cmp    %eax,%edx
  8033b1:	0f 83 b8 00 00 00    	jae    80346f <insert_sorted_with_merge_freeList+0x5a2>
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	8b 50 08             	mov    0x8(%eax),%edx
  8033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c3:	01 c2                	add    %eax,%edx
  8033c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c8:	8b 40 08             	mov    0x8(%eax),%eax
  8033cb:	39 c2                	cmp    %eax,%edx
  8033cd:	0f 85 9c 00 00 00    	jne    80346f <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  8033d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033df:	01 c2                	add    %eax,%edx
  8033e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e4:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  8033e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ea:	8b 50 08             	mov    0x8(%eax),%edx
  8033ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f0:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  8033f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8033fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803400:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803407:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80340b:	75 17                	jne    803424 <insert_sorted_with_merge_freeList+0x557>
  80340d:	83 ec 04             	sub    $0x4,%esp
  803410:	68 74 41 80 00       	push   $0x804174
  803415:	68 67 01 00 00       	push   $0x167
  80341a:	68 97 41 80 00       	push   $0x804197
  80341f:	e8 cf d4 ff ff       	call   8008f3 <_panic>
  803424:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80342a:	8b 45 08             	mov    0x8(%ebp),%eax
  80342d:	89 10                	mov    %edx,(%eax)
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	8b 00                	mov    (%eax),%eax
  803434:	85 c0                	test   %eax,%eax
  803436:	74 0d                	je     803445 <insert_sorted_with_merge_freeList+0x578>
  803438:	a1 48 51 80 00       	mov    0x805148,%eax
  80343d:	8b 55 08             	mov    0x8(%ebp),%edx
  803440:	89 50 04             	mov    %edx,0x4(%eax)
  803443:	eb 08                	jmp    80344d <insert_sorted_with_merge_freeList+0x580>
  803445:	8b 45 08             	mov    0x8(%ebp),%eax
  803448:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80344d:	8b 45 08             	mov    0x8(%ebp),%eax
  803450:	a3 48 51 80 00       	mov    %eax,0x805148
  803455:	8b 45 08             	mov    0x8(%ebp),%eax
  803458:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345f:	a1 54 51 80 00       	mov    0x805154,%eax
  803464:	40                   	inc    %eax
  803465:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80346a:	e9 a4 01 00 00       	jmp    803613 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80346f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803472:	8b 50 08             	mov    0x8(%eax),%edx
  803475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803478:	8b 40 0c             	mov    0xc(%eax),%eax
  80347b:	01 c2                	add    %eax,%edx
  80347d:	8b 45 08             	mov    0x8(%ebp),%eax
  803480:	8b 40 08             	mov    0x8(%eax),%eax
  803483:	39 c2                	cmp    %eax,%edx
  803485:	0f 85 ac 00 00 00    	jne    803537 <insert_sorted_with_merge_freeList+0x66a>
  80348b:	8b 45 08             	mov    0x8(%ebp),%eax
  80348e:	8b 50 08             	mov    0x8(%eax),%edx
  803491:	8b 45 08             	mov    0x8(%ebp),%eax
  803494:	8b 40 0c             	mov    0xc(%eax),%eax
  803497:	01 c2                	add    %eax,%edx
  803499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80349c:	8b 40 08             	mov    0x8(%eax),%eax
  80349f:	39 c2                	cmp    %eax,%edx
  8034a1:	0f 83 90 00 00 00    	jae    803537 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  8034a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034aa:	8b 50 0c             	mov    0xc(%eax),%edx
  8034ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b3:	01 c2                	add    %eax,%edx
  8034b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b8:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  8034c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034d3:	75 17                	jne    8034ec <insert_sorted_with_merge_freeList+0x61f>
  8034d5:	83 ec 04             	sub    $0x4,%esp
  8034d8:	68 74 41 80 00       	push   $0x804174
  8034dd:	68 70 01 00 00       	push   $0x170
  8034e2:	68 97 41 80 00       	push   $0x804197
  8034e7:	e8 07 d4 ff ff       	call   8008f3 <_panic>
  8034ec:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f5:	89 10                	mov    %edx,(%eax)
  8034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fa:	8b 00                	mov    (%eax),%eax
  8034fc:	85 c0                	test   %eax,%eax
  8034fe:	74 0d                	je     80350d <insert_sorted_with_merge_freeList+0x640>
  803500:	a1 48 51 80 00       	mov    0x805148,%eax
  803505:	8b 55 08             	mov    0x8(%ebp),%edx
  803508:	89 50 04             	mov    %edx,0x4(%eax)
  80350b:	eb 08                	jmp    803515 <insert_sorted_with_merge_freeList+0x648>
  80350d:	8b 45 08             	mov    0x8(%ebp),%eax
  803510:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803515:	8b 45 08             	mov    0x8(%ebp),%eax
  803518:	a3 48 51 80 00       	mov    %eax,0x805148
  80351d:	8b 45 08             	mov    0x8(%ebp),%eax
  803520:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803527:	a1 54 51 80 00       	mov    0x805154,%eax
  80352c:	40                   	inc    %eax
  80352d:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  803532:	e9 dc 00 00 00       	jmp    803613 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353a:	8b 50 08             	mov    0x8(%eax),%edx
  80353d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803540:	8b 40 0c             	mov    0xc(%eax),%eax
  803543:	01 c2                	add    %eax,%edx
  803545:	8b 45 08             	mov    0x8(%ebp),%eax
  803548:	8b 40 08             	mov    0x8(%eax),%eax
  80354b:	39 c2                	cmp    %eax,%edx
  80354d:	0f 83 88 00 00 00    	jae    8035db <insert_sorted_with_merge_freeList+0x70e>
  803553:	8b 45 08             	mov    0x8(%ebp),%eax
  803556:	8b 50 08             	mov    0x8(%eax),%edx
  803559:	8b 45 08             	mov    0x8(%ebp),%eax
  80355c:	8b 40 0c             	mov    0xc(%eax),%eax
  80355f:	01 c2                	add    %eax,%edx
  803561:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803564:	8b 40 08             	mov    0x8(%eax),%eax
  803567:	39 c2                	cmp    %eax,%edx
  803569:	73 70                	jae    8035db <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  80356b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80356f:	74 06                	je     803577 <insert_sorted_with_merge_freeList+0x6aa>
  803571:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803575:	75 17                	jne    80358e <insert_sorted_with_merge_freeList+0x6c1>
  803577:	83 ec 04             	sub    $0x4,%esp
  80357a:	68 d4 41 80 00       	push   $0x8041d4
  80357f:	68 75 01 00 00       	push   $0x175
  803584:	68 97 41 80 00       	push   $0x804197
  803589:	e8 65 d3 ff ff       	call   8008f3 <_panic>
  80358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803591:	8b 10                	mov    (%eax),%edx
  803593:	8b 45 08             	mov    0x8(%ebp),%eax
  803596:	89 10                	mov    %edx,(%eax)
  803598:	8b 45 08             	mov    0x8(%ebp),%eax
  80359b:	8b 00                	mov    (%eax),%eax
  80359d:	85 c0                	test   %eax,%eax
  80359f:	74 0b                	je     8035ac <insert_sorted_with_merge_freeList+0x6df>
  8035a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a4:	8b 00                	mov    (%eax),%eax
  8035a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8035a9:	89 50 04             	mov    %edx,0x4(%eax)
  8035ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035af:	8b 55 08             	mov    0x8(%ebp),%edx
  8035b2:	89 10                	mov    %edx,(%eax)
  8035b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035ba:	89 50 04             	mov    %edx,0x4(%eax)
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	8b 00                	mov    (%eax),%eax
  8035c2:	85 c0                	test   %eax,%eax
  8035c4:	75 08                	jne    8035ce <insert_sorted_with_merge_freeList+0x701>
  8035c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035ce:	a1 44 51 80 00       	mov    0x805144,%eax
  8035d3:	40                   	inc    %eax
  8035d4:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  8035d9:	eb 38                	jmp    803613 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8035db:	a1 40 51 80 00       	mov    0x805140,%eax
  8035e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035e7:	74 07                	je     8035f0 <insert_sorted_with_merge_freeList+0x723>
  8035e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ec:	8b 00                	mov    (%eax),%eax
  8035ee:	eb 05                	jmp    8035f5 <insert_sorted_with_merge_freeList+0x728>
  8035f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f5:	a3 40 51 80 00       	mov    %eax,0x805140
  8035fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8035ff:	85 c0                	test   %eax,%eax
  803601:	0f 85 c3 fb ff ff    	jne    8031ca <insert_sorted_with_merge_freeList+0x2fd>
  803607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80360b:	0f 85 b9 fb ff ff    	jne    8031ca <insert_sorted_with_merge_freeList+0x2fd>





}
  803611:	eb 00                	jmp    803613 <insert_sorted_with_merge_freeList+0x746>
  803613:	90                   	nop
  803614:	c9                   	leave  
  803615:	c3                   	ret    
  803616:	66 90                	xchg   %ax,%ax

00803618 <__udivdi3>:
  803618:	55                   	push   %ebp
  803619:	57                   	push   %edi
  80361a:	56                   	push   %esi
  80361b:	53                   	push   %ebx
  80361c:	83 ec 1c             	sub    $0x1c,%esp
  80361f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803623:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803627:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80362b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80362f:	89 ca                	mov    %ecx,%edx
  803631:	89 f8                	mov    %edi,%eax
  803633:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803637:	85 f6                	test   %esi,%esi
  803639:	75 2d                	jne    803668 <__udivdi3+0x50>
  80363b:	39 cf                	cmp    %ecx,%edi
  80363d:	77 65                	ja     8036a4 <__udivdi3+0x8c>
  80363f:	89 fd                	mov    %edi,%ebp
  803641:	85 ff                	test   %edi,%edi
  803643:	75 0b                	jne    803650 <__udivdi3+0x38>
  803645:	b8 01 00 00 00       	mov    $0x1,%eax
  80364a:	31 d2                	xor    %edx,%edx
  80364c:	f7 f7                	div    %edi
  80364e:	89 c5                	mov    %eax,%ebp
  803650:	31 d2                	xor    %edx,%edx
  803652:	89 c8                	mov    %ecx,%eax
  803654:	f7 f5                	div    %ebp
  803656:	89 c1                	mov    %eax,%ecx
  803658:	89 d8                	mov    %ebx,%eax
  80365a:	f7 f5                	div    %ebp
  80365c:	89 cf                	mov    %ecx,%edi
  80365e:	89 fa                	mov    %edi,%edx
  803660:	83 c4 1c             	add    $0x1c,%esp
  803663:	5b                   	pop    %ebx
  803664:	5e                   	pop    %esi
  803665:	5f                   	pop    %edi
  803666:	5d                   	pop    %ebp
  803667:	c3                   	ret    
  803668:	39 ce                	cmp    %ecx,%esi
  80366a:	77 28                	ja     803694 <__udivdi3+0x7c>
  80366c:	0f bd fe             	bsr    %esi,%edi
  80366f:	83 f7 1f             	xor    $0x1f,%edi
  803672:	75 40                	jne    8036b4 <__udivdi3+0x9c>
  803674:	39 ce                	cmp    %ecx,%esi
  803676:	72 0a                	jb     803682 <__udivdi3+0x6a>
  803678:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80367c:	0f 87 9e 00 00 00    	ja     803720 <__udivdi3+0x108>
  803682:	b8 01 00 00 00       	mov    $0x1,%eax
  803687:	89 fa                	mov    %edi,%edx
  803689:	83 c4 1c             	add    $0x1c,%esp
  80368c:	5b                   	pop    %ebx
  80368d:	5e                   	pop    %esi
  80368e:	5f                   	pop    %edi
  80368f:	5d                   	pop    %ebp
  803690:	c3                   	ret    
  803691:	8d 76 00             	lea    0x0(%esi),%esi
  803694:	31 ff                	xor    %edi,%edi
  803696:	31 c0                	xor    %eax,%eax
  803698:	89 fa                	mov    %edi,%edx
  80369a:	83 c4 1c             	add    $0x1c,%esp
  80369d:	5b                   	pop    %ebx
  80369e:	5e                   	pop    %esi
  80369f:	5f                   	pop    %edi
  8036a0:	5d                   	pop    %ebp
  8036a1:	c3                   	ret    
  8036a2:	66 90                	xchg   %ax,%ax
  8036a4:	89 d8                	mov    %ebx,%eax
  8036a6:	f7 f7                	div    %edi
  8036a8:	31 ff                	xor    %edi,%edi
  8036aa:	89 fa                	mov    %edi,%edx
  8036ac:	83 c4 1c             	add    $0x1c,%esp
  8036af:	5b                   	pop    %ebx
  8036b0:	5e                   	pop    %esi
  8036b1:	5f                   	pop    %edi
  8036b2:	5d                   	pop    %ebp
  8036b3:	c3                   	ret    
  8036b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036b9:	89 eb                	mov    %ebp,%ebx
  8036bb:	29 fb                	sub    %edi,%ebx
  8036bd:	89 f9                	mov    %edi,%ecx
  8036bf:	d3 e6                	shl    %cl,%esi
  8036c1:	89 c5                	mov    %eax,%ebp
  8036c3:	88 d9                	mov    %bl,%cl
  8036c5:	d3 ed                	shr    %cl,%ebp
  8036c7:	89 e9                	mov    %ebp,%ecx
  8036c9:	09 f1                	or     %esi,%ecx
  8036cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036cf:	89 f9                	mov    %edi,%ecx
  8036d1:	d3 e0                	shl    %cl,%eax
  8036d3:	89 c5                	mov    %eax,%ebp
  8036d5:	89 d6                	mov    %edx,%esi
  8036d7:	88 d9                	mov    %bl,%cl
  8036d9:	d3 ee                	shr    %cl,%esi
  8036db:	89 f9                	mov    %edi,%ecx
  8036dd:	d3 e2                	shl    %cl,%edx
  8036df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036e3:	88 d9                	mov    %bl,%cl
  8036e5:	d3 e8                	shr    %cl,%eax
  8036e7:	09 c2                	or     %eax,%edx
  8036e9:	89 d0                	mov    %edx,%eax
  8036eb:	89 f2                	mov    %esi,%edx
  8036ed:	f7 74 24 0c          	divl   0xc(%esp)
  8036f1:	89 d6                	mov    %edx,%esi
  8036f3:	89 c3                	mov    %eax,%ebx
  8036f5:	f7 e5                	mul    %ebp
  8036f7:	39 d6                	cmp    %edx,%esi
  8036f9:	72 19                	jb     803714 <__udivdi3+0xfc>
  8036fb:	74 0b                	je     803708 <__udivdi3+0xf0>
  8036fd:	89 d8                	mov    %ebx,%eax
  8036ff:	31 ff                	xor    %edi,%edi
  803701:	e9 58 ff ff ff       	jmp    80365e <__udivdi3+0x46>
  803706:	66 90                	xchg   %ax,%ax
  803708:	8b 54 24 08          	mov    0x8(%esp),%edx
  80370c:	89 f9                	mov    %edi,%ecx
  80370e:	d3 e2                	shl    %cl,%edx
  803710:	39 c2                	cmp    %eax,%edx
  803712:	73 e9                	jae    8036fd <__udivdi3+0xe5>
  803714:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803717:	31 ff                	xor    %edi,%edi
  803719:	e9 40 ff ff ff       	jmp    80365e <__udivdi3+0x46>
  80371e:	66 90                	xchg   %ax,%ax
  803720:	31 c0                	xor    %eax,%eax
  803722:	e9 37 ff ff ff       	jmp    80365e <__udivdi3+0x46>
  803727:	90                   	nop

00803728 <__umoddi3>:
  803728:	55                   	push   %ebp
  803729:	57                   	push   %edi
  80372a:	56                   	push   %esi
  80372b:	53                   	push   %ebx
  80372c:	83 ec 1c             	sub    $0x1c,%esp
  80372f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803733:	8b 74 24 34          	mov    0x34(%esp),%esi
  803737:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80373b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80373f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803743:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803747:	89 f3                	mov    %esi,%ebx
  803749:	89 fa                	mov    %edi,%edx
  80374b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80374f:	89 34 24             	mov    %esi,(%esp)
  803752:	85 c0                	test   %eax,%eax
  803754:	75 1a                	jne    803770 <__umoddi3+0x48>
  803756:	39 f7                	cmp    %esi,%edi
  803758:	0f 86 a2 00 00 00    	jbe    803800 <__umoddi3+0xd8>
  80375e:	89 c8                	mov    %ecx,%eax
  803760:	89 f2                	mov    %esi,%edx
  803762:	f7 f7                	div    %edi
  803764:	89 d0                	mov    %edx,%eax
  803766:	31 d2                	xor    %edx,%edx
  803768:	83 c4 1c             	add    $0x1c,%esp
  80376b:	5b                   	pop    %ebx
  80376c:	5e                   	pop    %esi
  80376d:	5f                   	pop    %edi
  80376e:	5d                   	pop    %ebp
  80376f:	c3                   	ret    
  803770:	39 f0                	cmp    %esi,%eax
  803772:	0f 87 ac 00 00 00    	ja     803824 <__umoddi3+0xfc>
  803778:	0f bd e8             	bsr    %eax,%ebp
  80377b:	83 f5 1f             	xor    $0x1f,%ebp
  80377e:	0f 84 ac 00 00 00    	je     803830 <__umoddi3+0x108>
  803784:	bf 20 00 00 00       	mov    $0x20,%edi
  803789:	29 ef                	sub    %ebp,%edi
  80378b:	89 fe                	mov    %edi,%esi
  80378d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803791:	89 e9                	mov    %ebp,%ecx
  803793:	d3 e0                	shl    %cl,%eax
  803795:	89 d7                	mov    %edx,%edi
  803797:	89 f1                	mov    %esi,%ecx
  803799:	d3 ef                	shr    %cl,%edi
  80379b:	09 c7                	or     %eax,%edi
  80379d:	89 e9                	mov    %ebp,%ecx
  80379f:	d3 e2                	shl    %cl,%edx
  8037a1:	89 14 24             	mov    %edx,(%esp)
  8037a4:	89 d8                	mov    %ebx,%eax
  8037a6:	d3 e0                	shl    %cl,%eax
  8037a8:	89 c2                	mov    %eax,%edx
  8037aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037ae:	d3 e0                	shl    %cl,%eax
  8037b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037b8:	89 f1                	mov    %esi,%ecx
  8037ba:	d3 e8                	shr    %cl,%eax
  8037bc:	09 d0                	or     %edx,%eax
  8037be:	d3 eb                	shr    %cl,%ebx
  8037c0:	89 da                	mov    %ebx,%edx
  8037c2:	f7 f7                	div    %edi
  8037c4:	89 d3                	mov    %edx,%ebx
  8037c6:	f7 24 24             	mull   (%esp)
  8037c9:	89 c6                	mov    %eax,%esi
  8037cb:	89 d1                	mov    %edx,%ecx
  8037cd:	39 d3                	cmp    %edx,%ebx
  8037cf:	0f 82 87 00 00 00    	jb     80385c <__umoddi3+0x134>
  8037d5:	0f 84 91 00 00 00    	je     80386c <__umoddi3+0x144>
  8037db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037df:	29 f2                	sub    %esi,%edx
  8037e1:	19 cb                	sbb    %ecx,%ebx
  8037e3:	89 d8                	mov    %ebx,%eax
  8037e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037e9:	d3 e0                	shl    %cl,%eax
  8037eb:	89 e9                	mov    %ebp,%ecx
  8037ed:	d3 ea                	shr    %cl,%edx
  8037ef:	09 d0                	or     %edx,%eax
  8037f1:	89 e9                	mov    %ebp,%ecx
  8037f3:	d3 eb                	shr    %cl,%ebx
  8037f5:	89 da                	mov    %ebx,%edx
  8037f7:	83 c4 1c             	add    $0x1c,%esp
  8037fa:	5b                   	pop    %ebx
  8037fb:	5e                   	pop    %esi
  8037fc:	5f                   	pop    %edi
  8037fd:	5d                   	pop    %ebp
  8037fe:	c3                   	ret    
  8037ff:	90                   	nop
  803800:	89 fd                	mov    %edi,%ebp
  803802:	85 ff                	test   %edi,%edi
  803804:	75 0b                	jne    803811 <__umoddi3+0xe9>
  803806:	b8 01 00 00 00       	mov    $0x1,%eax
  80380b:	31 d2                	xor    %edx,%edx
  80380d:	f7 f7                	div    %edi
  80380f:	89 c5                	mov    %eax,%ebp
  803811:	89 f0                	mov    %esi,%eax
  803813:	31 d2                	xor    %edx,%edx
  803815:	f7 f5                	div    %ebp
  803817:	89 c8                	mov    %ecx,%eax
  803819:	f7 f5                	div    %ebp
  80381b:	89 d0                	mov    %edx,%eax
  80381d:	e9 44 ff ff ff       	jmp    803766 <__umoddi3+0x3e>
  803822:	66 90                	xchg   %ax,%ax
  803824:	89 c8                	mov    %ecx,%eax
  803826:	89 f2                	mov    %esi,%edx
  803828:	83 c4 1c             	add    $0x1c,%esp
  80382b:	5b                   	pop    %ebx
  80382c:	5e                   	pop    %esi
  80382d:	5f                   	pop    %edi
  80382e:	5d                   	pop    %ebp
  80382f:	c3                   	ret    
  803830:	3b 04 24             	cmp    (%esp),%eax
  803833:	72 06                	jb     80383b <__umoddi3+0x113>
  803835:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803839:	77 0f                	ja     80384a <__umoddi3+0x122>
  80383b:	89 f2                	mov    %esi,%edx
  80383d:	29 f9                	sub    %edi,%ecx
  80383f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803843:	89 14 24             	mov    %edx,(%esp)
  803846:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80384a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80384e:	8b 14 24             	mov    (%esp),%edx
  803851:	83 c4 1c             	add    $0x1c,%esp
  803854:	5b                   	pop    %ebx
  803855:	5e                   	pop    %esi
  803856:	5f                   	pop    %edi
  803857:	5d                   	pop    %ebp
  803858:	c3                   	ret    
  803859:	8d 76 00             	lea    0x0(%esi),%esi
  80385c:	2b 04 24             	sub    (%esp),%eax
  80385f:	19 fa                	sbb    %edi,%edx
  803861:	89 d1                	mov    %edx,%ecx
  803863:	89 c6                	mov    %eax,%esi
  803865:	e9 71 ff ff ff       	jmp    8037db <__umoddi3+0xb3>
  80386a:	66 90                	xchg   %ax,%ax
  80386c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803870:	72 ea                	jb     80385c <__umoddi3+0x134>
  803872:	89 d9                	mov    %ebx,%ecx
  803874:	e9 62 ff ff ff       	jmp    8037db <__umoddi3+0xb3>
