
obj/user/tst_quicksort_freeHeap:     file format elf32-i386


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
  800031:	e8 30 08 00 00       	call   800866 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 44 01 00 00    	sub    $0x144,%esp


	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{

		Iteration++ ;
  800049:	ff 45 f0             	incl   -0x10(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_disable_interrupt();
  80004c:	e8 b0 22 00 00       	call   802301 <sys_disable_interrupt>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 40 3b 80 00       	push   $0x803b40
  800060:	e8 73 12 00 00       	call   8012d8 <readline>
  800065:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 0a                	push   $0xa
  80006d:	6a 00                	push   $0x0
  80006f:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800075:	50                   	push   %eax
  800076:	e8 c3 17 00 00       	call   80183e <strtol>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 45 1d 00 00       	call   801dd5 <malloc>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)
		uint32 num_disk_tables = 1;  //Since it is created with the first array, so it will be decremented in the 1st case only
  800096:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  80009d:	a1 24 50 80 00       	mov    0x805024,%eax
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	50                   	push   %eax
  8000a6:	e8 88 03 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  8000b1:	e8 5e 21 00 00       	call   802214 <sys_calculate_free_frames>
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	e8 70 21 00 00       	call   80222d <sys_calculate_modified_frames>
  8000bd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000c3:	29 c2                	sub    %eax,%edx
  8000c5:	89 d0                	mov    %edx,%eax
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		Elements[NumOfElements] = 10 ;
  8000ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 60 3b 80 00       	push   $0x803b60
  8000e7:	e8 6a 0b 00 00       	call   800c56 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 83 3b 80 00       	push   $0x803b83
  8000f7:	e8 5a 0b 00 00       	call   800c56 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 91 3b 80 00       	push   $0x803b91
  800107:	e8 4a 0b 00 00       	call   800c56 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 a0 3b 80 00       	push   $0x803ba0
  800117:	e8 3a 0b 00 00       	call   800c56 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 b0 3b 80 00       	push   $0x803bb0
  800127:	e8 2a 0b 00 00       	call   800c56 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012f:	e8 da 06 00 00       	call   80080e <getchar>
  800134:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800137:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 82 06 00 00       	call   8007c6 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 75 06 00 00       	call   8007c6 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>
	sys_enable_interrupt();
  800166:	e8 b0 21 00 00       	call   80231b <sys_enable_interrupt>
		int  i ;
		switch (Chose)
  80016b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016f:	83 f8 62             	cmp    $0x62,%eax
  800172:	74 1d                	je     800191 <_main+0x159>
  800174:	83 f8 63             	cmp    $0x63,%eax
  800177:	74 2b                	je     8001a4 <_main+0x16c>
  800179:	83 f8 61             	cmp    $0x61,%eax
  80017c:	75 39                	jne    8001b7 <_main+0x17f>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	ff 75 ec             	pushl  -0x14(%ebp)
  800184:	ff 75 e8             	pushl  -0x18(%ebp)
  800187:	e8 02 05 00 00       	call   80068e <InitializeAscending>
  80018c:	83 c4 10             	add    $0x10,%esp
			break ;
  80018f:	eb 37                	jmp    8001c8 <_main+0x190>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	ff 75 ec             	pushl  -0x14(%ebp)
  800197:	ff 75 e8             	pushl  -0x18(%ebp)
  80019a:	e8 20 05 00 00       	call   8006bf <InitializeDescending>
  80019f:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a2:	eb 24                	jmp    8001c8 <_main+0x190>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ad:	e8 42 05 00 00       	call   8006f4 <InitializeSemiRandom>
  8001b2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b5:	eb 11                	jmp    8001c8 <_main+0x190>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c0:	e8 2f 05 00 00       	call   8006f4 <InitializeSemiRandom>
  8001c5:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d1:	e8 fd 02 00 00       	call   8004d3 <QuickSort>
  8001d6:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e2:	e8 fd 03 00 00       	call   8005e4 <CheckSorted>
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	89 45 d8             	mov    %eax,-0x28(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8001f1:	75 14                	jne    800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 bc 3b 80 00       	push   $0x803bbc
  8001fb:	6a 57                	push   $0x57
  8001fd:	68 de 3b 80 00       	push   $0x803bde
  800202:	e8 9b 07 00 00       	call   8009a2 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 fc 3b 80 00       	push   $0x803bfc
  80020f:	e8 42 0a 00 00       	call   800c56 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	68 30 3c 80 00       	push   $0x803c30
  80021f:	e8 32 0a 00 00       	call   800c56 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 64 3c 80 00       	push   $0x803c64
  80022f:	e8 22 0a 00 00       	call   800c56 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 96 3c 80 00       	push   $0x803c96
  80023f:	e8 12 0a 00 00       	call   800c56 <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 e8             	pushl  -0x18(%ebp)
  80024d:	e8 1a 1c 00 00       	call   801e6c <free>
  800252:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1)
  800255:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800259:	75 7b                	jne    8002d6 <_main+0x29e>
		{
			InitFreeFrames -= num_disk_tables;
  80025b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800261:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (!(NumOfElements == 1000 && Chose == 'a'))
  800264:	81 7d ec e8 03 00 00 	cmpl   $0x3e8,-0x14(%ebp)
  80026b:	75 06                	jne    800273 <_main+0x23b>
  80026d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800271:	74 14                	je     800287 <_main+0x24f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 ac 3c 80 00       	push   $0x803cac
  80027b:	6a 6a                	push   $0x6a
  80027d:	68 de 3b 80 00       	push   $0x803bde
  800282:	e8 1b 07 00 00       	call   8009a2 <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800287:	a1 24 50 80 00       	mov    0x805024,%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 9e 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80029b:	e8 74 1f 00 00       	call   802214 <sys_calculate_free_frames>
  8002a0:	89 c3                	mov    %eax,%ebx
  8002a2:	e8 86 1f 00 00       	call   80222d <sys_calculate_modified_frames>
  8002a7:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8002aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ad:	29 c2                	sub    %eax,%edx
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002b7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002ba:	0f 84 05 01 00 00    	je     8003c5 <_main+0x38d>
  8002c0:	68 fc 3c 80 00       	push   $0x803cfc
  8002c5:	68 21 3d 80 00       	push   $0x803d21
  8002ca:	6a 6e                	push   $0x6e
  8002cc:	68 de 3b 80 00       	push   $0x803bde
  8002d1:	e8 cc 06 00 00       	call   8009a2 <_panic>
		}
		else if (Iteration == 2 )
  8002d6:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002da:	75 72                	jne    80034e <_main+0x316>
		{
			if (!(NumOfElements == 5000 && Chose == 'b'))
  8002dc:	81 7d ec 88 13 00 00 	cmpl   $0x1388,-0x14(%ebp)
  8002e3:	75 06                	jne    8002eb <_main+0x2b3>
  8002e5:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
				panic("Please ensure the number of elements and the initialization method of this test");
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 ac 3c 80 00       	push   $0x803cac
  8002f3:	6a 73                	push   $0x73
  8002f5:	68 de 3b 80 00       	push   $0x803bde
  8002fa:	e8 a3 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ff:	a1 24 50 80 00       	mov    0x805024,%eax
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	e8 26 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  80030d:	83 c4 10             	add    $0x10,%esp
  800310:	89 45 d0             	mov    %eax,-0x30(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800313:	e8 fc 1e 00 00       	call   802214 <sys_calculate_free_frames>
  800318:	89 c3                	mov    %eax,%ebx
  80031a:	e8 0e 1f 00 00       	call   80222d <sys_calculate_modified_frames>
  80031f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800322:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800325:	29 c2                	sub    %eax,%edx
  800327:	89 d0                	mov    %edx,%eax
  800329:	89 45 cc             	mov    %eax,-0x34(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80032c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	0f 84 8d 00 00 00    	je     8003c5 <_main+0x38d>
  800338:	68 fc 3c 80 00       	push   $0x803cfc
  80033d:	68 21 3d 80 00       	push   $0x803d21
  800342:	6a 77                	push   $0x77
  800344:	68 de 3b 80 00       	push   $0x803bde
  800349:	e8 54 06 00 00       	call   8009a2 <_panic>
		}
		else if (Iteration == 3 )
  80034e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800352:	75 71                	jne    8003c5 <_main+0x38d>
		{
			if (!(NumOfElements == 300000 && Chose == 'c'))
  800354:	81 7d ec e0 93 04 00 	cmpl   $0x493e0,-0x14(%ebp)
  80035b:	75 06                	jne    800363 <_main+0x32b>
  80035d:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800361:	74 14                	je     800377 <_main+0x33f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 ac 3c 80 00       	push   $0x803cac
  80036b:	6a 7c                	push   $0x7c
  80036d:	68 de 3b 80 00       	push   $0x803bde
  800372:	e8 2b 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800377:	a1 24 50 80 00       	mov    0x805024,%eax
  80037c:	83 ec 0c             	sub    $0xc,%esp
  80037f:	50                   	push   %eax
  800380:	e8 ae 00 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 c8             	mov    %eax,-0x38(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80038b:	e8 84 1e 00 00       	call   802214 <sys_calculate_free_frames>
  800390:	89 c3                	mov    %eax,%ebx
  800392:	e8 96 1e 00 00       	call   80222d <sys_calculate_modified_frames>
  800397:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80039a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80039d:	29 c2                	sub    %eax,%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			//cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8003a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003aa:	74 19                	je     8003c5 <_main+0x38d>
  8003ac:	68 fc 3c 80 00       	push   $0x803cfc
  8003b1:	68 21 3d 80 00       	push   $0x803d21
  8003b6:	68 81 00 00 00       	push   $0x81
  8003bb:	68 de 3b 80 00       	push   $0x803bde
  8003c0:	e8 dd 05 00 00       	call   8009a2 <_panic>
		}
		///========================================================================
	sys_disable_interrupt();
  8003c5:	e8 37 1f 00 00       	call   802301 <sys_disable_interrupt>
		Chose = 0 ;
  8003ca:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003ce:	eb 42                	jmp    800412 <_main+0x3da>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	68 36 3d 80 00       	push   $0x803d36
  8003d8:	e8 79 08 00 00       	call   800c56 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8003e0:	e8 29 04 00 00       	call   80080e <getchar>
  8003e5:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  8003e8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8003ec:	83 ec 0c             	sub    $0xc,%esp
  8003ef:	50                   	push   %eax
  8003f0:	e8 d1 03 00 00       	call   8007c6 <cputchar>
  8003f5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	6a 0a                	push   $0xa
  8003fd:	e8 c4 03 00 00       	call   8007c6 <cputchar>
  800402:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	6a 0a                	push   $0xa
  80040a:	e8 b7 03 00 00       	call   8007c6 <cputchar>
  80040f:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800412:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800416:	74 06                	je     80041e <_main+0x3e6>
  800418:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80041c:	75 b2                	jne    8003d0 <_main+0x398>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
	sys_enable_interrupt();
  80041e:	e8 f8 1e 00 00       	call   80231b <sys_enable_interrupt>

	} while (Chose == 'y');
  800423:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800427:	0f 84 1c fc ff ff    	je     800049 <_main+0x11>
}
  80042d:	90                   	nop
  80042e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	83 ec 18             	sub    $0x18,%esp
	int numOFEmptyLocInWS = 0, i;
  800439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  800440:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800447:	eb 74                	jmp    8004bd <CheckAndCountEmptyLocInWS+0x8a>
	{
		if (myEnv->__uptr_pws[i].empty)
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800452:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800455:	89 d0                	mov    %edx,%eax
  800457:	01 c0                	add    %eax,%eax
  800459:	01 d0                	add    %edx,%eax
  80045b:	c1 e0 03             	shl    $0x3,%eax
  80045e:	01 c8                	add    %ecx,%eax
  800460:	8a 40 04             	mov    0x4(%eax),%al
  800463:	84 c0                	test   %al,%al
  800465:	74 05                	je     80046c <CheckAndCountEmptyLocInWS+0x39>
		{
			numOFEmptyLocInWS++;
  800467:	ff 45 f4             	incl   -0xc(%ebp)
  80046a:	eb 4e                	jmp    8004ba <CheckAndCountEmptyLocInWS+0x87>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800475:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800478:	89 d0                	mov    %edx,%eax
  80047a:	01 c0                	add    %eax,%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	c1 e0 03             	shl    $0x3,%eax
  800481:	01 c8                	add    %ecx,%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800488:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800490:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  800493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	79 20                	jns    8004ba <CheckAndCountEmptyLocInWS+0x87>
  80049a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8004a1:	77 17                	ja     8004ba <CheckAndCountEmptyLocInWS+0x87>
				panic("freeMem didn't remove its page(s) from the WS");
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 54 3d 80 00       	push   $0x803d54
  8004ab:	68 a0 00 00 00       	push   $0xa0
  8004b0:	68 de 3b 80 00       	push   $0x803bde
  8004b5:	e8 e8 04 00 00       	call   8009a2 <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  8004ba:	ff 45 f0             	incl   -0x10(%ebp)
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	8b 50 74             	mov    0x74(%eax),%edx
  8004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c6:	39 c2                	cmp    %eax,%edx
  8004c8:	0f 87 7b ff ff ff    	ja     800449 <CheckAndCountEmptyLocInWS+0x16>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  8004ce:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  8004d1:	c9                   	leave  
  8004d2:	c3                   	ret    

008004d3 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8004d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dc:	48                   	dec    %eax
  8004dd:	50                   	push   %eax
  8004de:	6a 00                	push   $0x0
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	ff 75 08             	pushl  0x8(%ebp)
  8004e6:	e8 06 00 00 00       	call   8004f1 <QSort>
  8004eb:	83 c4 10             	add    $0x10,%esp
}
  8004ee:	90                   	nop
  8004ef:	c9                   	leave  
  8004f0:	c3                   	ret    

008004f1 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004fd:	0f 8d de 00 00 00    	jge    8005e1 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	40                   	inc    %eax
  800507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800510:	e9 80 00 00 00       	jmp    800595 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800515:	ff 45 f4             	incl   -0xc(%ebp)
  800518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80051e:	7f 2b                	jg     80054b <QSort+0x5a>
  800520:	8b 45 10             	mov    0x10(%ebp),%eax
  800523:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	01 d0                	add    %edx,%eax
  80052f:	8b 10                	mov    (%eax),%edx
  800531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800534:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	01 c8                	add    %ecx,%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	39 c2                	cmp    %eax,%edx
  800544:	7d cf                	jge    800515 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800546:	eb 03                	jmp    80054b <QSort+0x5a>
  800548:	ff 4d f0             	decl   -0x10(%ebp)
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800551:	7e 26                	jle    800579 <QSort+0x88>
  800553:	8b 45 10             	mov    0x10(%ebp),%eax
  800556:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	01 d0                	add    %edx,%eax
  800562:	8b 10                	mov    (%eax),%edx
  800564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800567:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	01 c8                	add    %ecx,%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	39 c2                	cmp    %eax,%edx
  800577:	7e cf                	jle    800548 <QSort+0x57>

		if (i <= j)
  800579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80057f:	7f 14                	jg     800595 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800581:	83 ec 04             	sub    $0x4,%esp
  800584:	ff 75 f0             	pushl  -0x10(%ebp)
  800587:	ff 75 f4             	pushl  -0xc(%ebp)
  80058a:	ff 75 08             	pushl  0x8(%ebp)
  80058d:	e8 a9 00 00 00       	call   80063b <Swap>
  800592:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800598:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80059b:	0f 8e 77 ff ff ff    	jle    800518 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005a7:	ff 75 10             	pushl  0x10(%ebp)
  8005aa:	ff 75 08             	pushl  0x8(%ebp)
  8005ad:	e8 89 00 00 00       	call   80063b <Swap>
  8005b2:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8005b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b8:	48                   	dec    %eax
  8005b9:	50                   	push   %eax
  8005ba:	ff 75 10             	pushl  0x10(%ebp)
  8005bd:	ff 75 0c             	pushl  0xc(%ebp)
  8005c0:	ff 75 08             	pushl  0x8(%ebp)
  8005c3:	e8 29 ff ff ff       	call   8004f1 <QSort>
  8005c8:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8005cb:	ff 75 14             	pushl  0x14(%ebp)
  8005ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d1:	ff 75 0c             	pushl  0xc(%ebp)
  8005d4:	ff 75 08             	pushl  0x8(%ebp)
  8005d7:	e8 15 ff ff ff       	call   8004f1 <QSort>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	eb 01                	jmp    8005e2 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8005e1:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8005e2:	c9                   	leave  
  8005e3:	c3                   	ret    

008005e4 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8005e4:	55                   	push   %ebp
  8005e5:	89 e5                	mov    %esp,%ebp
  8005e7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8005ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005f8:	eb 33                	jmp    80062d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8005fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80060e:	40                   	inc    %eax
  80060f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	01 c8                	add    %ecx,%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	7e 09                	jle    80062a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800621:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800628:	eb 0c                	jmp    800636 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80062a:	ff 45 f8             	incl   -0x8(%ebp)
  80062d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800630:	48                   	dec    %eax
  800631:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800634:	7f c4                	jg     8005fa <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800636:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800639:	c9                   	leave  
  80063a:	c3                   	ret    

0080063b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800641:	8b 45 0c             	mov    0xc(%ebp),%eax
  800644:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	8b 00                	mov    (%eax),%eax
  800652:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800655:	8b 45 0c             	mov    0xc(%ebp),%eax
  800658:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	01 c2                	add    %eax,%edx
  800664:	8b 45 10             	mov    0x10(%ebp),%eax
  800667:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	01 c8                	add    %ecx,%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800677:	8b 45 10             	mov    0x10(%ebp),%eax
  80067a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	01 c2                	add    %eax,%edx
  800686:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800689:	89 02                	mov    %eax,(%edx)
}
  80068b:	90                   	nop
  80068c:	c9                   	leave  
  80068d:	c3                   	ret    

0080068e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800694:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80069b:	eb 17                	jmp    8006b4 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80069d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	01 c2                	add    %eax,%edx
  8006ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006af:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006b1:	ff 45 fc             	incl   -0x4(%ebp)
  8006b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ba:	7c e1                	jl     80069d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006bc:	90                   	nop
  8006bd:	c9                   	leave  
  8006be:	c3                   	ret    

008006bf <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006cc:	eb 1b                	jmp    8006e9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	01 c2                	add    %eax,%edx
  8006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8006e3:	48                   	dec    %eax
  8006e4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006e6:	ff 45 fc             	incl   -0x4(%ebp)
  8006e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ef:	7c dd                	jl     8006ce <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8006f1:	90                   	nop
  8006f2:	c9                   	leave  
  8006f3:	c3                   	ret    

008006f4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8006f4:	55                   	push   %ebp
  8006f5:	89 e5                	mov    %esp,%ebp
  8006f7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8006fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006fd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800702:	f7 e9                	imul   %ecx
  800704:	c1 f9 1f             	sar    $0x1f,%ecx
  800707:	89 d0                	mov    %edx,%eax
  800709:	29 c8                	sub    %ecx,%eax
  80070b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80070e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800715:	eb 1e                	jmp    800735 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800717:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80071a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80072a:	99                   	cltd   
  80072b:	f7 7d f8             	idivl  -0x8(%ebp)
  80072e:	89 d0                	mov    %edx,%eax
  800730:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800732:	ff 45 fc             	incl   -0x4(%ebp)
  800735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800738:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80073b:	7c da                	jl     800717 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  80073d:	90                   	nop
  80073e:	c9                   	leave  
  80073f:	c3                   	ret    

00800740 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800746:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80074d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800754:	eb 42                	jmp    800798 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800759:	99                   	cltd   
  80075a:	f7 7d f0             	idivl  -0x10(%ebp)
  80075d:	89 d0                	mov    %edx,%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	75 10                	jne    800773 <PrintElements+0x33>
			cprintf("\n");
  800763:	83 ec 0c             	sub    $0xc,%esp
  800766:	68 82 3d 80 00       	push   $0x803d82
  80076b:	e8 e6 04 00 00       	call   800c56 <cprintf>
  800770:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800776:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	01 d0                	add    %edx,%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	50                   	push   %eax
  800788:	68 84 3d 80 00       	push   $0x803d84
  80078d:	e8 c4 04 00 00       	call   800c56 <cprintf>
  800792:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800795:	ff 45 f4             	incl   -0xc(%ebp)
  800798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079b:	48                   	dec    %eax
  80079c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80079f:	7f b5                	jg     800756 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8007a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	01 d0                	add    %edx,%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	50                   	push   %eax
  8007b6:	68 89 3d 80 00       	push   $0x803d89
  8007bb:	e8 96 04 00 00       	call   800c56 <cprintf>
  8007c0:	83 c4 10             	add    $0x10,%esp

}
  8007c3:	90                   	nop
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007d2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007d6:	83 ec 0c             	sub    $0xc,%esp
  8007d9:	50                   	push   %eax
  8007da:	e8 56 1b 00 00       	call   802335 <sys_cputc>
  8007df:	83 c4 10             	add    $0x10,%esp
}
  8007e2:	90                   	nop
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    

008007e5 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007eb:	e8 11 1b 00 00       	call   802301 <sys_disable_interrupt>
	char c = ch;
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007f6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007fa:	83 ec 0c             	sub    $0xc,%esp
  8007fd:	50                   	push   %eax
  8007fe:	e8 32 1b 00 00       	call   802335 <sys_cputc>
  800803:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800806:	e8 10 1b 00 00       	call   80231b <sys_enable_interrupt>
}
  80080b:	90                   	nop
  80080c:	c9                   	leave  
  80080d:	c3                   	ret    

0080080e <getchar>:

int
getchar(void)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800814:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80081b:	eb 08                	jmp    800825 <getchar+0x17>
	{
		c = sys_cgetc();
  80081d:	e8 5a 19 00 00       	call   80217c <sys_cgetc>
  800822:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800825:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800829:	74 f2                	je     80081d <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80082b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80082e:	c9                   	leave  
  80082f:	c3                   	ret    

00800830 <atomic_getchar>:

int
atomic_getchar(void)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800836:	e8 c6 1a 00 00       	call   802301 <sys_disable_interrupt>
	int c=0;
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800842:	eb 08                	jmp    80084c <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800844:	e8 33 19 00 00       	call   80217c <sys_cgetc>
  800849:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80084c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800850:	74 f2                	je     800844 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800852:	e8 c4 1a 00 00       	call   80231b <sys_enable_interrupt>
	return c;
  800857:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80085a:	c9                   	leave  
  80085b:	c3                   	ret    

0080085c <iscons>:

int iscons(int fdnum)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80085f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80086c:	e8 83 1c 00 00       	call   8024f4 <sys_getenvindex>
  800871:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800874:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800877:	89 d0                	mov    %edx,%eax
  800879:	c1 e0 03             	shl    $0x3,%eax
  80087c:	01 d0                	add    %edx,%eax
  80087e:	01 c0                	add    %eax,%eax
  800880:	01 d0                	add    %edx,%eax
  800882:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800889:	01 d0                	add    %edx,%eax
  80088b:	c1 e0 04             	shl    $0x4,%eax
  80088e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800893:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800898:	a1 24 50 80 00       	mov    0x805024,%eax
  80089d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8008a3:	84 c0                	test   %al,%al
  8008a5:	74 0f                	je     8008b6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8008a7:	a1 24 50 80 00       	mov    0x805024,%eax
  8008ac:	05 5c 05 00 00       	add    $0x55c,%eax
  8008b1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008ba:	7e 0a                	jle    8008c6 <libmain+0x60>
		binaryname = argv[0];
  8008bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	ff 75 08             	pushl  0x8(%ebp)
  8008cf:	e8 64 f7 ff ff       	call   800038 <_main>
  8008d4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8008d7:	e8 25 1a 00 00       	call   802301 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8008dc:	83 ec 0c             	sub    $0xc,%esp
  8008df:	68 a8 3d 80 00       	push   $0x803da8
  8008e4:	e8 6d 03 00 00       	call   800c56 <cprintf>
  8008e9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008ec:	a1 24 50 80 00       	mov    0x805024,%eax
  8008f1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8008f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8008fc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800902:	83 ec 04             	sub    $0x4,%esp
  800905:	52                   	push   %edx
  800906:	50                   	push   %eax
  800907:	68 d0 3d 80 00       	push   $0x803dd0
  80090c:	e8 45 03 00 00       	call   800c56 <cprintf>
  800911:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800914:	a1 24 50 80 00       	mov    0x805024,%eax
  800919:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80091f:	a1 24 50 80 00       	mov    0x805024,%eax
  800924:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80092a:	a1 24 50 80 00       	mov    0x805024,%eax
  80092f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800935:	51                   	push   %ecx
  800936:	52                   	push   %edx
  800937:	50                   	push   %eax
  800938:	68 f8 3d 80 00       	push   $0x803df8
  80093d:	e8 14 03 00 00       	call   800c56 <cprintf>
  800942:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800945:	a1 24 50 80 00       	mov    0x805024,%eax
  80094a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	50                   	push   %eax
  800954:	68 50 3e 80 00       	push   $0x803e50
  800959:	e8 f8 02 00 00       	call   800c56 <cprintf>
  80095e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 a8 3d 80 00       	push   $0x803da8
  800969:	e8 e8 02 00 00       	call   800c56 <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800971:	e8 a5 19 00 00       	call   80231b <sys_enable_interrupt>

	// exit gracefully
	exit();
  800976:	e8 19 00 00 00       	call   800994 <exit>
}
  80097b:	90                   	nop
  80097c:	c9                   	leave  
  80097d:	c3                   	ret    

0080097e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	6a 00                	push   $0x0
  800989:	e8 32 1b 00 00       	call   8024c0 <sys_destroy_env>
  80098e:	83 c4 10             	add    $0x10,%esp
}
  800991:	90                   	nop
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <exit>:

void
exit(void)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80099a:	e8 87 1b 00 00       	call   802526 <sys_exit_env>
}
  80099f:	90                   	nop
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009a8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009ab:	83 c0 04             	add    $0x4,%eax
  8009ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009b1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8009b6:	85 c0                	test   %eax,%eax
  8009b8:	74 16                	je     8009d0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009ba:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	50                   	push   %eax
  8009c3:	68 64 3e 80 00       	push   $0x803e64
  8009c8:	e8 89 02 00 00       	call   800c56 <cprintf>
  8009cd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8009d0:	a1 00 50 80 00       	mov    0x805000,%eax
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	ff 75 08             	pushl  0x8(%ebp)
  8009db:	50                   	push   %eax
  8009dc:	68 69 3e 80 00       	push   $0x803e69
  8009e1:	e8 70 02 00 00       	call   800c56 <cprintf>
  8009e6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f2:	50                   	push   %eax
  8009f3:	e8 f3 01 00 00       	call   800beb <vcprintf>
  8009f8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	6a 00                	push   $0x0
  800a00:	68 85 3e 80 00       	push   $0x803e85
  800a05:	e8 e1 01 00 00       	call   800beb <vcprintf>
  800a0a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a0d:	e8 82 ff ff ff       	call   800994 <exit>

	// should not return here
	while (1) ;
  800a12:	eb fe                	jmp    800a12 <_panic+0x70>

00800a14 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a1a:	a1 24 50 80 00       	mov    0x805024,%eax
  800a1f:	8b 50 74             	mov    0x74(%eax),%edx
  800a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a25:	39 c2                	cmp    %eax,%edx
  800a27:	74 14                	je     800a3d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a29:	83 ec 04             	sub    $0x4,%esp
  800a2c:	68 88 3e 80 00       	push   $0x803e88
  800a31:	6a 26                	push   $0x26
  800a33:	68 d4 3e 80 00       	push   $0x803ed4
  800a38:	e8 65 ff ff ff       	call   8009a2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a44:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a4b:	e9 c2 00 00 00       	jmp    800b12 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a53:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	01 d0                	add    %edx,%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	85 c0                	test   %eax,%eax
  800a63:	75 08                	jne    800a6d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800a65:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a68:	e9 a2 00 00 00       	jmp    800b0f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800a6d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a7b:	eb 69                	jmp    800ae6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a7d:	a1 24 50 80 00       	mov    0x805024,%eax
  800a82:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a88:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a8b:	89 d0                	mov    %edx,%eax
  800a8d:	01 c0                	add    %eax,%eax
  800a8f:	01 d0                	add    %edx,%eax
  800a91:	c1 e0 03             	shl    $0x3,%eax
  800a94:	01 c8                	add    %ecx,%eax
  800a96:	8a 40 04             	mov    0x4(%eax),%al
  800a99:	84 c0                	test   %al,%al
  800a9b:	75 46                	jne    800ae3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a9d:	a1 24 50 80 00       	mov    0x805024,%eax
  800aa2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800aa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800aab:	89 d0                	mov    %edx,%eax
  800aad:	01 c0                	add    %eax,%eax
  800aaf:	01 d0                	add    %edx,%eax
  800ab1:	c1 e0 03             	shl    $0x3,%eax
  800ab4:	01 c8                	add    %ecx,%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800abb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800abe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ac3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	01 c8                	add    %ecx,%eax
  800ad4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ad6:	39 c2                	cmp    %eax,%edx
  800ad8:	75 09                	jne    800ae3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800ada:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800ae1:	eb 12                	jmp    800af5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ae3:	ff 45 e8             	incl   -0x18(%ebp)
  800ae6:	a1 24 50 80 00       	mov    0x805024,%eax
  800aeb:	8b 50 74             	mov    0x74(%eax),%edx
  800aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af1:	39 c2                	cmp    %eax,%edx
  800af3:	77 88                	ja     800a7d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800af5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800af9:	75 14                	jne    800b0f <CheckWSWithoutLastIndex+0xfb>
			panic(
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	68 e0 3e 80 00       	push   $0x803ee0
  800b03:	6a 3a                	push   $0x3a
  800b05:	68 d4 3e 80 00       	push   $0x803ed4
  800b0a:	e8 93 fe ff ff       	call   8009a2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b0f:	ff 45 f0             	incl   -0x10(%ebp)
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b18:	0f 8c 32 ff ff ff    	jl     800a50 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b1e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b2c:	eb 26                	jmp    800b54 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b2e:	a1 24 50 80 00       	mov    0x805024,%eax
  800b33:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b39:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b3c:	89 d0                	mov    %edx,%eax
  800b3e:	01 c0                	add    %eax,%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	c1 e0 03             	shl    $0x3,%eax
  800b45:	01 c8                	add    %ecx,%eax
  800b47:	8a 40 04             	mov    0x4(%eax),%al
  800b4a:	3c 01                	cmp    $0x1,%al
  800b4c:	75 03                	jne    800b51 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800b4e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b51:	ff 45 e0             	incl   -0x20(%ebp)
  800b54:	a1 24 50 80 00       	mov    0x805024,%eax
  800b59:	8b 50 74             	mov    0x74(%eax),%edx
  800b5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b5f:	39 c2                	cmp    %eax,%edx
  800b61:	77 cb                	ja     800b2e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b66:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b69:	74 14                	je     800b7f <CheckWSWithoutLastIndex+0x16b>
		panic(
  800b6b:	83 ec 04             	sub    $0x4,%esp
  800b6e:	68 34 3f 80 00       	push   $0x803f34
  800b73:	6a 44                	push   $0x44
  800b75:	68 d4 3e 80 00       	push   $0x803ed4
  800b7a:	e8 23 fe ff ff       	call   8009a2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b7f:	90                   	nop
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 0a                	mov    %ecx,(%edx)
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	88 d1                	mov    %dl,%cl
  800b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bab:	75 2c                	jne    800bd9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800bad:	a0 28 50 80 00       	mov    0x805028,%al
  800bb2:	0f b6 c0             	movzbl %al,%eax
  800bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb8:	8b 12                	mov    (%edx),%edx
  800bba:	89 d1                	mov    %edx,%ecx
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	83 c2 08             	add    $0x8,%edx
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	50                   	push   %eax
  800bc6:	51                   	push   %ecx
  800bc7:	52                   	push   %edx
  800bc8:	e8 86 15 00 00       	call   802153 <sys_cputs>
  800bcd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	8b 40 04             	mov    0x4(%eax),%eax
  800bdf:	8d 50 01             	lea    0x1(%eax),%edx
  800be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be5:	89 50 04             	mov    %edx,0x4(%eax)
}
  800be8:	90                   	nop
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bf4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bfb:	00 00 00 
	b.cnt = 0;
  800bfe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c05:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	ff 75 08             	pushl  0x8(%ebp)
  800c0e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	68 82 0b 80 00       	push   $0x800b82
  800c1a:	e8 11 02 00 00       	call   800e30 <vprintfmt>
  800c1f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800c22:	a0 28 50 80 00       	mov    0x805028,%al
  800c27:	0f b6 c0             	movzbl %al,%eax
  800c2a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	50                   	push   %eax
  800c34:	52                   	push   %edx
  800c35:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c3b:	83 c0 08             	add    $0x8,%eax
  800c3e:	50                   	push   %eax
  800c3f:	e8 0f 15 00 00       	call   802153 <sys_cputs>
  800c44:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c47:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800c4e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <cprintf>:

int cprintf(const char *fmt, ...) {
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c5c:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800c63:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	83 ec 08             	sub    $0x8,%esp
  800c6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c72:	50                   	push   %eax
  800c73:	e8 73 ff ff ff       	call   800beb <vcprintf>
  800c78:	83 c4 10             	add    $0x10,%esp
  800c7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800c89:	e8 73 16 00 00       	call   802301 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c8e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	50                   	push   %eax
  800c9e:	e8 48 ff ff ff       	call   800beb <vcprintf>
  800ca3:	83 c4 10             	add    $0x10,%esp
  800ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ca9:	e8 6d 16 00 00       	call   80231b <sys_enable_interrupt>
	return cnt;
  800cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 14             	sub    $0x14,%esp
  800cba:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cc6:	8b 45 18             	mov    0x18(%ebp),%eax
  800cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd1:	77 55                	ja     800d28 <printnum+0x75>
  800cd3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd6:	72 05                	jb     800cdd <printnum+0x2a>
  800cd8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cdb:	77 4b                	ja     800d28 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cdd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ce0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ce3:	8b 45 18             	mov    0x18(%ebp),%eax
  800ce6:	ba 00 00 00 00       	mov    $0x0,%edx
  800ceb:	52                   	push   %edx
  800cec:	50                   	push   %eax
  800ced:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf0:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf3:	e8 d4 2b 00 00       	call   8038cc <__udivdi3>
  800cf8:	83 c4 10             	add    $0x10,%esp
  800cfb:	83 ec 04             	sub    $0x4,%esp
  800cfe:	ff 75 20             	pushl  0x20(%ebp)
  800d01:	53                   	push   %ebx
  800d02:	ff 75 18             	pushl  0x18(%ebp)
  800d05:	52                   	push   %edx
  800d06:	50                   	push   %eax
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	ff 75 08             	pushl  0x8(%ebp)
  800d0d:	e8 a1 ff ff ff       	call   800cb3 <printnum>
  800d12:	83 c4 20             	add    $0x20,%esp
  800d15:	eb 1a                	jmp    800d31 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 20             	pushl  0x20(%ebp)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d28:	ff 4d 1c             	decl   0x1c(%ebp)
  800d2b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d2f:	7f e6                	jg     800d17 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d31:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d3f:	53                   	push   %ebx
  800d40:	51                   	push   %ecx
  800d41:	52                   	push   %edx
  800d42:	50                   	push   %eax
  800d43:	e8 94 2c 00 00       	call   8039dc <__umoddi3>
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	05 94 41 80 00       	add    $0x804194,%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f be c0             	movsbl %al,%eax
  800d55:	83 ec 08             	sub    $0x8,%esp
  800d58:	ff 75 0c             	pushl  0xc(%ebp)
  800d5b:	50                   	push   %eax
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	ff d0                	call   *%eax
  800d61:	83 c4 10             	add    $0x10,%esp
}
  800d64:	90                   	nop
  800d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d6d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d71:	7e 1c                	jle    800d8f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	8d 50 08             	lea    0x8(%eax),%edx
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	89 10                	mov    %edx,(%eax)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	83 e8 08             	sub    $0x8,%eax
  800d88:	8b 50 04             	mov    0x4(%eax),%edx
  800d8b:	8b 00                	mov    (%eax),%eax
  800d8d:	eb 40                	jmp    800dcf <getuint+0x65>
	else if (lflag)
  800d8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d93:	74 1e                	je     800db3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8b 00                	mov    (%eax),%eax
  800d9a:	8d 50 04             	lea    0x4(%eax),%edx
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 10                	mov    %edx,(%eax)
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8b 00                	mov    (%eax),%eax
  800da7:	83 e8 04             	sub    $0x4,%eax
  800daa:	8b 00                	mov    (%eax),%eax
  800dac:	ba 00 00 00 00       	mov    $0x0,%edx
  800db1:	eb 1c                	jmp    800dcf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	8d 50 04             	lea    0x4(%eax),%edx
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 10                	mov    %edx,(%eax)
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	83 e8 04             	sub    $0x4,%eax
  800dc8:	8b 00                	mov    (%eax),%eax
  800dca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    

00800dd1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dd4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dd8:	7e 1c                	jle    800df6 <getint+0x25>
		return va_arg(*ap, long long);
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8b 00                	mov    (%eax),%eax
  800ddf:	8d 50 08             	lea    0x8(%eax),%edx
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 10                	mov    %edx,(%eax)
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	83 e8 08             	sub    $0x8,%eax
  800def:	8b 50 04             	mov    0x4(%eax),%edx
  800df2:	8b 00                	mov    (%eax),%eax
  800df4:	eb 38                	jmp    800e2e <getint+0x5d>
	else if (lflag)
  800df6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfa:	74 1a                	je     800e16 <getint+0x45>
		return va_arg(*ap, long);
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8b 00                	mov    (%eax),%eax
  800e01:	8d 50 04             	lea    0x4(%eax),%edx
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 10                	mov    %edx,(%eax)
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8b 00                	mov    (%eax),%eax
  800e0e:	83 e8 04             	sub    $0x4,%eax
  800e11:	8b 00                	mov    (%eax),%eax
  800e13:	99                   	cltd   
  800e14:	eb 18                	jmp    800e2e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8b 00                	mov    (%eax),%eax
  800e1b:	8d 50 04             	lea    0x4(%eax),%edx
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 10                	mov    %edx,(%eax)
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8b 00                	mov    (%eax),%eax
  800e28:	83 e8 04             	sub    $0x4,%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	99                   	cltd   
}
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
  800e35:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e38:	eb 17                	jmp    800e51 <vprintfmt+0x21>
			if (ch == '\0')
  800e3a:	85 db                	test   %ebx,%ebx
  800e3c:	0f 84 af 03 00 00    	je     8011f1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800e42:	83 ec 08             	sub    $0x8,%esp
  800e45:	ff 75 0c             	pushl  0xc(%ebp)
  800e48:	53                   	push   %ebx
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e51:	8b 45 10             	mov    0x10(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f b6 d8             	movzbl %al,%ebx
  800e5f:	83 fb 25             	cmp    $0x25,%ebx
  800e62:	75 d6                	jne    800e3a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e64:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e68:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e7d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e84:	8b 45 10             	mov    0x10(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	0f b6 d8             	movzbl %al,%ebx
  800e92:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e95:	83 f8 55             	cmp    $0x55,%eax
  800e98:	0f 87 2b 03 00 00    	ja     8011c9 <vprintfmt+0x399>
  800e9e:	8b 04 85 b8 41 80 00 	mov    0x8041b8(,%eax,4),%eax
  800ea5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ea7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800eab:	eb d7                	jmp    800e84 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ead:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800eb1:	eb d1                	jmp    800e84 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800eba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ebd:	89 d0                	mov    %edx,%eax
  800ebf:	c1 e0 02             	shl    $0x2,%eax
  800ec2:	01 d0                	add    %edx,%eax
  800ec4:	01 c0                	add    %eax,%eax
  800ec6:	01 d8                	add    %ebx,%eax
  800ec8:	83 e8 30             	sub    $0x30,%eax
  800ecb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ece:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ed6:	83 fb 2f             	cmp    $0x2f,%ebx
  800ed9:	7e 3e                	jle    800f19 <vprintfmt+0xe9>
  800edb:	83 fb 39             	cmp    $0x39,%ebx
  800ede:	7f 39                	jg     800f19 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ee0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ee3:	eb d5                	jmp    800eba <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ee5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee8:	83 c0 04             	add    $0x4,%eax
  800eeb:	89 45 14             	mov    %eax,0x14(%ebp)
  800eee:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef1:	83 e8 04             	sub    $0x4,%eax
  800ef4:	8b 00                	mov    (%eax),%eax
  800ef6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ef9:	eb 1f                	jmp    800f1a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800efb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eff:	79 83                	jns    800e84 <vprintfmt+0x54>
				width = 0;
  800f01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f08:	e9 77 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f0d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f14:	e9 6b ff ff ff       	jmp    800e84 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f19:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1e:	0f 89 60 ff ff ff    	jns    800e84 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f2a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f31:	e9 4e ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f36:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f39:	e9 46 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 14             	mov    %eax,0x14(%ebp)
  800f47:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4a:	83 e8 04             	sub    $0x4,%eax
  800f4d:	8b 00                	mov    (%eax),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	50                   	push   %eax
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	ff d0                	call   *%eax
  800f5b:	83 c4 10             	add    $0x10,%esp
			break;
  800f5e:	e9 89 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f63:	8b 45 14             	mov    0x14(%ebp),%eax
  800f66:	83 c0 04             	add    $0x4,%eax
  800f69:	89 45 14             	mov    %eax,0x14(%ebp)
  800f6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6f:	83 e8 04             	sub    $0x4,%eax
  800f72:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f74:	85 db                	test   %ebx,%ebx
  800f76:	79 02                	jns    800f7a <vprintfmt+0x14a>
				err = -err;
  800f78:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f7a:	83 fb 64             	cmp    $0x64,%ebx
  800f7d:	7f 0b                	jg     800f8a <vprintfmt+0x15a>
  800f7f:	8b 34 9d 00 40 80 00 	mov    0x804000(,%ebx,4),%esi
  800f86:	85 f6                	test   %esi,%esi
  800f88:	75 19                	jne    800fa3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f8a:	53                   	push   %ebx
  800f8b:	68 a5 41 80 00       	push   $0x8041a5
  800f90:	ff 75 0c             	pushl  0xc(%ebp)
  800f93:	ff 75 08             	pushl  0x8(%ebp)
  800f96:	e8 5e 02 00 00       	call   8011f9 <printfmt>
  800f9b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f9e:	e9 49 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fa3:	56                   	push   %esi
  800fa4:	68 ae 41 80 00       	push   $0x8041ae
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 45 02 00 00       	call   8011f9 <printfmt>
  800fb4:	83 c4 10             	add    $0x10,%esp
			break;
  800fb7:	e9 30 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbf:	83 c0 04             	add    $0x4,%eax
  800fc2:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc8:	83 e8 04             	sub    $0x4,%eax
  800fcb:	8b 30                	mov    (%eax),%esi
  800fcd:	85 f6                	test   %esi,%esi
  800fcf:	75 05                	jne    800fd6 <vprintfmt+0x1a6>
				p = "(null)";
  800fd1:	be b1 41 80 00       	mov    $0x8041b1,%esi
			if (width > 0 && padc != '-')
  800fd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fda:	7e 6d                	jle    801049 <vprintfmt+0x219>
  800fdc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fe0:	74 67                	je     801049 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	50                   	push   %eax
  800fe9:	56                   	push   %esi
  800fea:	e8 12 05 00 00       	call   801501 <strnlen>
  800fef:	83 c4 10             	add    $0x10,%esp
  800ff2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ff5:	eb 16                	jmp    80100d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ff7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ffb:	83 ec 08             	sub    $0x8,%esp
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	50                   	push   %eax
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	ff d0                	call   *%eax
  801007:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80100a:	ff 4d e4             	decl   -0x1c(%ebp)
  80100d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801011:	7f e4                	jg     800ff7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801013:	eb 34                	jmp    801049 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801015:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801019:	74 1c                	je     801037 <vprintfmt+0x207>
  80101b:	83 fb 1f             	cmp    $0x1f,%ebx
  80101e:	7e 05                	jle    801025 <vprintfmt+0x1f5>
  801020:	83 fb 7e             	cmp    $0x7e,%ebx
  801023:	7e 12                	jle    801037 <vprintfmt+0x207>
					putch('?', putdat);
  801025:	83 ec 08             	sub    $0x8,%esp
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	6a 3f                	push   $0x3f
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	ff d0                	call   *%eax
  801032:	83 c4 10             	add    $0x10,%esp
  801035:	eb 0f                	jmp    801046 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801037:	83 ec 08             	sub    $0x8,%esp
  80103a:	ff 75 0c             	pushl  0xc(%ebp)
  80103d:	53                   	push   %ebx
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	ff d0                	call   *%eax
  801043:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801046:	ff 4d e4             	decl   -0x1c(%ebp)
  801049:	89 f0                	mov    %esi,%eax
  80104b:	8d 70 01             	lea    0x1(%eax),%esi
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f be d8             	movsbl %al,%ebx
  801053:	85 db                	test   %ebx,%ebx
  801055:	74 24                	je     80107b <vprintfmt+0x24b>
  801057:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80105b:	78 b8                	js     801015 <vprintfmt+0x1e5>
  80105d:	ff 4d e0             	decl   -0x20(%ebp)
  801060:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801064:	79 af                	jns    801015 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801066:	eb 13                	jmp    80107b <vprintfmt+0x24b>
				putch(' ', putdat);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	ff 75 0c             	pushl  0xc(%ebp)
  80106e:	6a 20                	push   $0x20
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	ff d0                	call   *%eax
  801075:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801078:	ff 4d e4             	decl   -0x1c(%ebp)
  80107b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80107f:	7f e7                	jg     801068 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801081:	e9 66 01 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801086:	83 ec 08             	sub    $0x8,%esp
  801089:	ff 75 e8             	pushl  -0x18(%ebp)
  80108c:	8d 45 14             	lea    0x14(%ebp),%eax
  80108f:	50                   	push   %eax
  801090:	e8 3c fd ff ff       	call   800dd1 <getint>
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80109e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a4:	85 d2                	test   %edx,%edx
  8010a6:	79 23                	jns    8010cb <vprintfmt+0x29b>
				putch('-', putdat);
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	ff 75 0c             	pushl  0xc(%ebp)
  8010ae:	6a 2d                	push   $0x2d
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	ff d0                	call   *%eax
  8010b5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010be:	f7 d8                	neg    %eax
  8010c0:	83 d2 00             	adc    $0x0,%edx
  8010c3:	f7 da                	neg    %edx
  8010c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010d2:	e9 bc 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010d7:	83 ec 08             	sub    $0x8,%esp
  8010da:	ff 75 e8             	pushl  -0x18(%ebp)
  8010dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e0:	50                   	push   %eax
  8010e1:	e8 84 fc ff ff       	call   800d6a <getuint>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010ef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010f6:	e9 98 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	6a 58                	push   $0x58
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	ff d0                	call   *%eax
  801108:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 0c             	pushl  0xc(%ebp)
  801111:	6a 58                	push   $0x58
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	ff d0                	call   *%eax
  801118:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	6a 58                	push   $0x58
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	ff d0                	call   *%eax
  801128:	83 c4 10             	add    $0x10,%esp
			break;
  80112b:	e9 bc 00 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	ff 75 0c             	pushl  0xc(%ebp)
  801136:	6a 30                	push   $0x30
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	ff d0                	call   *%eax
  80113d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	6a 78                	push   $0x78
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	ff d0                	call   *%eax
  80114d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801150:	8b 45 14             	mov    0x14(%ebp),%eax
  801153:	83 c0 04             	add    $0x4,%eax
  801156:	89 45 14             	mov    %eax,0x14(%ebp)
  801159:	8b 45 14             	mov    0x14(%ebp),%eax
  80115c:	83 e8 04             	sub    $0x4,%eax
  80115f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801164:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80116b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801172:	eb 1f                	jmp    801193 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801174:	83 ec 08             	sub    $0x8,%esp
  801177:	ff 75 e8             	pushl  -0x18(%ebp)
  80117a:	8d 45 14             	lea    0x14(%ebp),%eax
  80117d:	50                   	push   %eax
  80117e:	e8 e7 fb ff ff       	call   800d6a <getuint>
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801189:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80118c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801193:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	52                   	push   %edx
  80119e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011a1:	50                   	push   %eax
  8011a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 00 fb ff ff       	call   800cb3 <printnum>
  8011b3:	83 c4 20             	add    $0x20,%esp
			break;
  8011b6:	eb 34                	jmp    8011ec <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011b8:	83 ec 08             	sub    $0x8,%esp
  8011bb:	ff 75 0c             	pushl  0xc(%ebp)
  8011be:	53                   	push   %ebx
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	ff d0                	call   *%eax
  8011c4:	83 c4 10             	add    $0x10,%esp
			break;
  8011c7:	eb 23                	jmp    8011ec <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011c9:	83 ec 08             	sub    $0x8,%esp
  8011cc:	ff 75 0c             	pushl  0xc(%ebp)
  8011cf:	6a 25                	push   $0x25
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	ff d0                	call   *%eax
  8011d6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011d9:	ff 4d 10             	decl   0x10(%ebp)
  8011dc:	eb 03                	jmp    8011e1 <vprintfmt+0x3b1>
  8011de:	ff 4d 10             	decl   0x10(%ebp)
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	48                   	dec    %eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	3c 25                	cmp    $0x25,%al
  8011e9:	75 f3                	jne    8011de <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8011eb:	90                   	nop
		}
	}
  8011ec:	e9 47 fc ff ff       	jmp    800e38 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011f1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    

008011f9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011ff:	8d 45 10             	lea    0x10(%ebp),%eax
  801202:	83 c0 04             	add    $0x4,%eax
  801205:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801208:	8b 45 10             	mov    0x10(%ebp),%eax
  80120b:	ff 75 f4             	pushl  -0xc(%ebp)
  80120e:	50                   	push   %eax
  80120f:	ff 75 0c             	pushl  0xc(%ebp)
  801212:	ff 75 08             	pushl  0x8(%ebp)
  801215:	e8 16 fc ff ff       	call   800e30 <vprintfmt>
  80121a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801223:	8b 45 0c             	mov    0xc(%ebp),%eax
  801226:	8b 40 08             	mov    0x8(%eax),%eax
  801229:	8d 50 01             	lea    0x1(%eax),%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	8b 10                	mov    (%eax),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8b 40 04             	mov    0x4(%eax),%eax
  80123d:	39 c2                	cmp    %eax,%edx
  80123f:	73 12                	jae    801253 <sprintputch+0x33>
		*b->buf++ = ch;
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	8b 00                	mov    (%eax),%eax
  801246:	8d 48 01             	lea    0x1(%eax),%ecx
  801249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124c:	89 0a                	mov    %ecx,(%edx)
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	88 10                	mov    %dl,(%eax)
}
  801253:	90                   	nop
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	8d 50 ff             	lea    -0x1(%eax),%edx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	01 d0                	add    %edx,%eax
  80126d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801270:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801277:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127b:	74 06                	je     801283 <vsnprintf+0x2d>
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	7f 07                	jg     80128a <vsnprintf+0x34>
		return -E_INVAL;
  801283:	b8 03 00 00 00       	mov    $0x3,%eax
  801288:	eb 20                	jmp    8012aa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80128a:	ff 75 14             	pushl  0x14(%ebp)
  80128d:	ff 75 10             	pushl  0x10(%ebp)
  801290:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801293:	50                   	push   %eax
  801294:	68 20 12 80 00       	push   $0x801220
  801299:	e8 92 fb ff ff       	call   800e30 <vprintfmt>
  80129e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012b2:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b5:	83 c0 04             	add    $0x4,%eax
  8012b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c1:	50                   	push   %eax
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	ff 75 08             	pushl  0x8(%ebp)
  8012c8:	e8 89 ff ff ff       	call   801256 <vsnprintf>
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8012de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e2:	74 13                	je     8012f7 <readline+0x1f>
		cprintf("%s", prompt);
  8012e4:	83 ec 08             	sub    $0x8,%esp
  8012e7:	ff 75 08             	pushl  0x8(%ebp)
  8012ea:	68 10 43 80 00       	push   $0x804310
  8012ef:	e8 62 f9 ff ff       	call   800c56 <cprintf>
  8012f4:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012fe:	83 ec 0c             	sub    $0xc,%esp
  801301:	6a 00                	push   $0x0
  801303:	e8 54 f5 ff ff       	call   80085c <iscons>
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80130e:	e8 fb f4 ff ff       	call   80080e <getchar>
  801313:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801316:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80131a:	79 22                	jns    80133e <readline+0x66>
			if (c != -E_EOF)
  80131c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801320:	0f 84 ad 00 00 00    	je     8013d3 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801326:	83 ec 08             	sub    $0x8,%esp
  801329:	ff 75 ec             	pushl  -0x14(%ebp)
  80132c:	68 13 43 80 00       	push   $0x804313
  801331:	e8 20 f9 ff ff       	call   800c56 <cprintf>
  801336:	83 c4 10             	add    $0x10,%esp
			return;
  801339:	e9 95 00 00 00       	jmp    8013d3 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80133e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801342:	7e 34                	jle    801378 <readline+0xa0>
  801344:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134b:	7f 2b                	jg     801378 <readline+0xa0>
			if (echoing)
  80134d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801351:	74 0e                	je     801361 <readline+0x89>
				cputchar(c);
  801353:	83 ec 0c             	sub    $0xc,%esp
  801356:	ff 75 ec             	pushl  -0x14(%ebp)
  801359:	e8 68 f4 ff ff       	call   8007c6 <cputchar>
  80135e:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801374:	88 10                	mov    %dl,(%eax)
  801376:	eb 56                	jmp    8013ce <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801378:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137c:	75 1f                	jne    80139d <readline+0xc5>
  80137e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801382:	7e 19                	jle    80139d <readline+0xc5>
			if (echoing)
  801384:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801388:	74 0e                	je     801398 <readline+0xc0>
				cputchar(c);
  80138a:	83 ec 0c             	sub    $0xc,%esp
  80138d:	ff 75 ec             	pushl  -0x14(%ebp)
  801390:	e8 31 f4 ff ff       	call   8007c6 <cputchar>
  801395:	83 c4 10             	add    $0x10,%esp

			i--;
  801398:	ff 4d f4             	decl   -0xc(%ebp)
  80139b:	eb 31                	jmp    8013ce <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80139d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a1:	74 0a                	je     8013ad <readline+0xd5>
  8013a3:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a7:	0f 85 61 ff ff ff    	jne    80130e <readline+0x36>
			if (echoing)
  8013ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b1:	74 0e                	je     8013c1 <readline+0xe9>
				cputchar(c);
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b9:	e8 08 f4 ff ff       	call   8007c6 <cputchar>
  8013be:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8013c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8013cc:	eb 06                	jmp    8013d4 <readline+0xfc>
		}
	}
  8013ce:	e9 3b ff ff ff       	jmp    80130e <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8013d3:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8013dc:	e8 20 0f 00 00       	call   802301 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8013e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e5:	74 13                	je     8013fa <atomic_readline+0x24>
		cprintf("%s", prompt);
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	ff 75 08             	pushl  0x8(%ebp)
  8013ed:	68 10 43 80 00       	push   $0x804310
  8013f2:	e8 5f f8 ff ff       	call   800c56 <cprintf>
  8013f7:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8013fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	6a 00                	push   $0x0
  801406:	e8 51 f4 ff ff       	call   80085c <iscons>
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801411:	e8 f8 f3 ff ff       	call   80080e <getchar>
  801416:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801419:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80141d:	79 23                	jns    801442 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80141f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801423:	74 13                	je     801438 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	ff 75 ec             	pushl  -0x14(%ebp)
  80142b:	68 13 43 80 00       	push   $0x804313
  801430:	e8 21 f8 ff ff       	call   800c56 <cprintf>
  801435:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801438:	e8 de 0e 00 00       	call   80231b <sys_enable_interrupt>
			return;
  80143d:	e9 9a 00 00 00       	jmp    8014dc <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801442:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801446:	7e 34                	jle    80147c <atomic_readline+0xa6>
  801448:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80144f:	7f 2b                	jg     80147c <atomic_readline+0xa6>
			if (echoing)
  801451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801455:	74 0e                	je     801465 <atomic_readline+0x8f>
				cputchar(c);
  801457:	83 ec 0c             	sub    $0xc,%esp
  80145a:	ff 75 ec             	pushl  -0x14(%ebp)
  80145d:	e8 64 f3 ff ff       	call   8007c6 <cputchar>
  801462:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80146e:	89 c2                	mov    %eax,%edx
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	01 d0                	add    %edx,%eax
  801475:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801478:	88 10                	mov    %dl,(%eax)
  80147a:	eb 5b                	jmp    8014d7 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80147c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801480:	75 1f                	jne    8014a1 <atomic_readline+0xcb>
  801482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801486:	7e 19                	jle    8014a1 <atomic_readline+0xcb>
			if (echoing)
  801488:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80148c:	74 0e                	je     80149c <atomic_readline+0xc6>
				cputchar(c);
  80148e:	83 ec 0c             	sub    $0xc,%esp
  801491:	ff 75 ec             	pushl  -0x14(%ebp)
  801494:	e8 2d f3 ff ff       	call   8007c6 <cputchar>
  801499:	83 c4 10             	add    $0x10,%esp
			i--;
  80149c:	ff 4d f4             	decl   -0xc(%ebp)
  80149f:	eb 36                	jmp    8014d7 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8014a1:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8014a5:	74 0a                	je     8014b1 <atomic_readline+0xdb>
  8014a7:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8014ab:	0f 85 60 ff ff ff    	jne    801411 <atomic_readline+0x3b>
			if (echoing)
  8014b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014b5:	74 0e                	je     8014c5 <atomic_readline+0xef>
				cputchar(c);
  8014b7:	83 ec 0c             	sub    $0xc,%esp
  8014ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8014bd:	e8 04 f3 ff ff       	call   8007c6 <cputchar>
  8014c2:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8014c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cb:	01 d0                	add    %edx,%eax
  8014cd:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8014d0:	e8 46 0e 00 00       	call   80231b <sys_enable_interrupt>
			return;
  8014d5:	eb 05                	jmp    8014dc <atomic_readline+0x106>
		}
	}
  8014d7:	e9 35 ff ff ff       	jmp    801411 <atomic_readline+0x3b>
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014eb:	eb 06                	jmp    8014f3 <strlen+0x15>
		n++;
  8014ed:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014f0:	ff 45 08             	incl   0x8(%ebp)
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	84 c0                	test   %al,%al
  8014fa:	75 f1                	jne    8014ed <strlen+0xf>
		n++;
	return n;
  8014fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801507:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80150e:	eb 09                	jmp    801519 <strnlen+0x18>
		n++;
  801510:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801513:	ff 45 08             	incl   0x8(%ebp)
  801516:	ff 4d 0c             	decl   0xc(%ebp)
  801519:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80151d:	74 09                	je     801528 <strnlen+0x27>
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8a 00                	mov    (%eax),%al
  801524:	84 c0                	test   %al,%al
  801526:	75 e8                	jne    801510 <strnlen+0xf>
		n++;
	return n;
  801528:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801539:	90                   	nop
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8d 50 01             	lea    0x1(%eax),%edx
  801540:	89 55 08             	mov    %edx,0x8(%ebp)
  801543:	8b 55 0c             	mov    0xc(%ebp),%edx
  801546:	8d 4a 01             	lea    0x1(%edx),%ecx
  801549:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80154c:	8a 12                	mov    (%edx),%dl
  80154e:	88 10                	mov    %dl,(%eax)
  801550:	8a 00                	mov    (%eax),%al
  801552:	84 c0                	test   %al,%al
  801554:	75 e4                	jne    80153a <strcpy+0xd>
		/* do nothing */;
	return ret;
  801556:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801567:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80156e:	eb 1f                	jmp    80158f <strncpy+0x34>
		*dst++ = *src;
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 08             	mov    %edx,0x8(%ebp)
  801579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157c:	8a 12                	mov    (%edx),%dl
  80157e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801580:	8b 45 0c             	mov    0xc(%ebp),%eax
  801583:	8a 00                	mov    (%eax),%al
  801585:	84 c0                	test   %al,%al
  801587:	74 03                	je     80158c <strncpy+0x31>
			src++;
  801589:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80158c:	ff 45 fc             	incl   -0x4(%ebp)
  80158f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801592:	3b 45 10             	cmp    0x10(%ebp),%eax
  801595:	72 d9                	jb     801570 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801597:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8015a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ac:	74 30                	je     8015de <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8015ae:	eb 16                	jmp    8015c6 <strlcpy+0x2a>
			*dst++ = *src++;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8d 50 01             	lea    0x1(%eax),%edx
  8015b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8015b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015c2:	8a 12                	mov    (%edx),%dl
  8015c4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015c6:	ff 4d 10             	decl   0x10(%ebp)
  8015c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015cd:	74 09                	je     8015d8 <strlcpy+0x3c>
  8015cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	84 c0                	test   %al,%al
  8015d6:	75 d8                	jne    8015b0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015de:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e4:	29 c2                	sub    %eax,%edx
  8015e6:	89 d0                	mov    %edx,%eax
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015ed:	eb 06                	jmp    8015f5 <strcmp+0xb>
		p++, q++;
  8015ef:	ff 45 08             	incl   0x8(%ebp)
  8015f2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	74 0e                	je     80160c <strcmp+0x22>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 10                	mov    (%eax),%dl
  801603:	8b 45 0c             	mov    0xc(%ebp),%eax
  801606:	8a 00                	mov    (%eax),%al
  801608:	38 c2                	cmp    %al,%dl
  80160a:	74 e3                	je     8015ef <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8a 00                	mov    (%eax),%al
  801611:	0f b6 d0             	movzbl %al,%edx
  801614:	8b 45 0c             	mov    0xc(%ebp),%eax
  801617:	8a 00                	mov    (%eax),%al
  801619:	0f b6 c0             	movzbl %al,%eax
  80161c:	29 c2                	sub    %eax,%edx
  80161e:	89 d0                	mov    %edx,%eax
}
  801620:	5d                   	pop    %ebp
  801621:	c3                   	ret    

00801622 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801625:	eb 09                	jmp    801630 <strncmp+0xe>
		n--, p++, q++;
  801627:	ff 4d 10             	decl   0x10(%ebp)
  80162a:	ff 45 08             	incl   0x8(%ebp)
  80162d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801630:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801634:	74 17                	je     80164d <strncmp+0x2b>
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8a 00                	mov    (%eax),%al
  80163b:	84 c0                	test   %al,%al
  80163d:	74 0e                	je     80164d <strncmp+0x2b>
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8a 10                	mov    (%eax),%dl
  801644:	8b 45 0c             	mov    0xc(%ebp),%eax
  801647:	8a 00                	mov    (%eax),%al
  801649:	38 c2                	cmp    %al,%dl
  80164b:	74 da                	je     801627 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80164d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801651:	75 07                	jne    80165a <strncmp+0x38>
		return 0;
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
  801658:	eb 14                	jmp    80166e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	8a 00                	mov    (%eax),%al
  80165f:	0f b6 d0             	movzbl %al,%edx
  801662:	8b 45 0c             	mov    0xc(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	0f b6 c0             	movzbl %al,%eax
  80166a:	29 c2                	sub    %eax,%edx
  80166c:	89 d0                	mov    %edx,%eax
}
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    

00801670 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80167c:	eb 12                	jmp    801690 <strchr+0x20>
		if (*s == c)
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801686:	75 05                	jne    80168d <strchr+0x1d>
			return (char *) s;
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	eb 11                	jmp    80169e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80168d:	ff 45 08             	incl   0x8(%ebp)
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	84 c0                	test   %al,%al
  801697:	75 e5                	jne    80167e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8016ac:	eb 0d                	jmp    8016bb <strfind+0x1b>
		if (*s == c)
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8016b6:	74 0e                	je     8016c6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016b8:	ff 45 08             	incl   0x8(%ebp)
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	84 c0                	test   %al,%al
  8016c2:	75 ea                	jne    8016ae <strfind+0xe>
  8016c4:	eb 01                	jmp    8016c7 <strfind+0x27>
		if (*s == c)
			break;
  8016c6:	90                   	nop
	return (char *) s;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016de:	eb 0e                	jmp    8016ee <memset+0x22>
		*p++ = c;
  8016e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e3:	8d 50 01             	lea    0x1(%eax),%edx
  8016e6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ec:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016ee:	ff 4d f8             	decl   -0x8(%ebp)
  8016f1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016f5:	79 e9                	jns    8016e0 <memset+0x14>
		*p++ = c;

	return v;
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801702:	8b 45 0c             	mov    0xc(%ebp),%eax
  801705:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80170e:	eb 16                	jmp    801726 <memcpy+0x2a>
		*d++ = *s++;
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	8d 50 01             	lea    0x1(%eax),%edx
  801716:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801719:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80171f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801722:	8a 12                	mov    (%edx),%dl
  801724:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801726:	8b 45 10             	mov    0x10(%ebp),%eax
  801729:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172c:	89 55 10             	mov    %edx,0x10(%ebp)
  80172f:	85 c0                	test   %eax,%eax
  801731:	75 dd                	jne    801710 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80173e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801741:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80174a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80174d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801750:	73 50                	jae    8017a2 <memmove+0x6a>
  801752:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801755:	8b 45 10             	mov    0x10(%ebp),%eax
  801758:	01 d0                	add    %edx,%eax
  80175a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80175d:	76 43                	jbe    8017a2 <memmove+0x6a>
		s += n;
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801765:	8b 45 10             	mov    0x10(%ebp),%eax
  801768:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80176b:	eb 10                	jmp    80177d <memmove+0x45>
			*--d = *--s;
  80176d:	ff 4d f8             	decl   -0x8(%ebp)
  801770:	ff 4d fc             	decl   -0x4(%ebp)
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801776:	8a 10                	mov    (%eax),%dl
  801778:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80177d:	8b 45 10             	mov    0x10(%ebp),%eax
  801780:	8d 50 ff             	lea    -0x1(%eax),%edx
  801783:	89 55 10             	mov    %edx,0x10(%ebp)
  801786:	85 c0                	test   %eax,%eax
  801788:	75 e3                	jne    80176d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80178a:	eb 23                	jmp    8017af <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80178c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801795:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801798:	8d 4a 01             	lea    0x1(%edx),%ecx
  80179b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80179e:	8a 12                	mov    (%edx),%dl
  8017a0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8017a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	75 dd                	jne    80178c <memmove+0x54>
			*d++ = *s++;

	return dst;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8017c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8017c6:	eb 2a                	jmp    8017f2 <memcmp+0x3e>
		if (*s1 != *s2)
  8017c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017cb:	8a 10                	mov    (%eax),%dl
  8017cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	38 c2                	cmp    %al,%dl
  8017d4:	74 16                	je     8017ec <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8017d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	0f b6 d0             	movzbl %al,%edx
  8017de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	0f b6 c0             	movzbl %al,%eax
  8017e6:	29 c2                	sub    %eax,%edx
  8017e8:	89 d0                	mov    %edx,%eax
  8017ea:	eb 18                	jmp    801804 <memcmp+0x50>
		s1++, s2++;
  8017ec:	ff 45 fc             	incl   -0x4(%ebp)
  8017ef:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017f8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	75 c9                	jne    8017c8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80180c:	8b 55 08             	mov    0x8(%ebp),%edx
  80180f:	8b 45 10             	mov    0x10(%ebp),%eax
  801812:	01 d0                	add    %edx,%eax
  801814:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801817:	eb 15                	jmp    80182e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	8a 00                	mov    (%eax),%al
  80181e:	0f b6 d0             	movzbl %al,%edx
  801821:	8b 45 0c             	mov    0xc(%ebp),%eax
  801824:	0f b6 c0             	movzbl %al,%eax
  801827:	39 c2                	cmp    %eax,%edx
  801829:	74 0d                	je     801838 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80182b:	ff 45 08             	incl   0x8(%ebp)
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801834:	72 e3                	jb     801819 <memfind+0x13>
  801836:	eb 01                	jmp    801839 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801838:	90                   	nop
	return (void *) s;
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801844:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80184b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801852:	eb 03                	jmp    801857 <strtol+0x19>
		s++;
  801854:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 20                	cmp    $0x20,%al
  80185e:	74 f4                	je     801854 <strtol+0x16>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	3c 09                	cmp    $0x9,%al
  801867:	74 eb                	je     801854 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	3c 2b                	cmp    $0x2b,%al
  801870:	75 05                	jne    801877 <strtol+0x39>
		s++;
  801872:	ff 45 08             	incl   0x8(%ebp)
  801875:	eb 13                	jmp    80188a <strtol+0x4c>
	else if (*s == '-')
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	8a 00                	mov    (%eax),%al
  80187c:	3c 2d                	cmp    $0x2d,%al
  80187e:	75 0a                	jne    80188a <strtol+0x4c>
		s++, neg = 1;
  801880:	ff 45 08             	incl   0x8(%ebp)
  801883:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80188a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80188e:	74 06                	je     801896 <strtol+0x58>
  801890:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801894:	75 20                	jne    8018b6 <strtol+0x78>
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	8a 00                	mov    (%eax),%al
  80189b:	3c 30                	cmp    $0x30,%al
  80189d:	75 17                	jne    8018b6 <strtol+0x78>
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	40                   	inc    %eax
  8018a3:	8a 00                	mov    (%eax),%al
  8018a5:	3c 78                	cmp    $0x78,%al
  8018a7:	75 0d                	jne    8018b6 <strtol+0x78>
		s += 2, base = 16;
  8018a9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8018ad:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8018b4:	eb 28                	jmp    8018de <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8018b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018ba:	75 15                	jne    8018d1 <strtol+0x93>
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	8a 00                	mov    (%eax),%al
  8018c1:	3c 30                	cmp    $0x30,%al
  8018c3:	75 0c                	jne    8018d1 <strtol+0x93>
		s++, base = 8;
  8018c5:	ff 45 08             	incl   0x8(%ebp)
  8018c8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8018cf:	eb 0d                	jmp    8018de <strtol+0xa0>
	else if (base == 0)
  8018d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018d5:	75 07                	jne    8018de <strtol+0xa0>
		base = 10;
  8018d7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	3c 2f                	cmp    $0x2f,%al
  8018e5:	7e 19                	jle    801900 <strtol+0xc2>
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	8a 00                	mov    (%eax),%al
  8018ec:	3c 39                	cmp    $0x39,%al
  8018ee:	7f 10                	jg     801900 <strtol+0xc2>
			dig = *s - '0';
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	0f be c0             	movsbl %al,%eax
  8018f8:	83 e8 30             	sub    $0x30,%eax
  8018fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018fe:	eb 42                	jmp    801942 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	8a 00                	mov    (%eax),%al
  801905:	3c 60                	cmp    $0x60,%al
  801907:	7e 19                	jle    801922 <strtol+0xe4>
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	8a 00                	mov    (%eax),%al
  80190e:	3c 7a                	cmp    $0x7a,%al
  801910:	7f 10                	jg     801922 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	8a 00                	mov    (%eax),%al
  801917:	0f be c0             	movsbl %al,%eax
  80191a:	83 e8 57             	sub    $0x57,%eax
  80191d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801920:	eb 20                	jmp    801942 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	8a 00                	mov    (%eax),%al
  801927:	3c 40                	cmp    $0x40,%al
  801929:	7e 39                	jle    801964 <strtol+0x126>
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	8a 00                	mov    (%eax),%al
  801930:	3c 5a                	cmp    $0x5a,%al
  801932:	7f 30                	jg     801964 <strtol+0x126>
			dig = *s - 'A' + 10;
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8a 00                	mov    (%eax),%al
  801939:	0f be c0             	movsbl %al,%eax
  80193c:	83 e8 37             	sub    $0x37,%eax
  80193f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801945:	3b 45 10             	cmp    0x10(%ebp),%eax
  801948:	7d 19                	jge    801963 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80194a:	ff 45 08             	incl   0x8(%ebp)
  80194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801950:	0f af 45 10          	imul   0x10(%ebp),%eax
  801954:	89 c2                	mov    %eax,%edx
  801956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801959:	01 d0                	add    %edx,%eax
  80195b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80195e:	e9 7b ff ff ff       	jmp    8018de <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801963:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801964:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801968:	74 08                	je     801972 <strtol+0x134>
		*endptr = (char *) s;
  80196a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196d:	8b 55 08             	mov    0x8(%ebp),%edx
  801970:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801972:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801976:	74 07                	je     80197f <strtol+0x141>
  801978:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197b:	f7 d8                	neg    %eax
  80197d:	eb 03                	jmp    801982 <strtol+0x144>
  80197f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <ltostr>:

void
ltostr(long value, char *str)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80198a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801991:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801998:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80199c:	79 13                	jns    8019b1 <ltostr+0x2d>
	{
		neg = 1;
  80199e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8019a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8019ab:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8019ae:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8019b9:	99                   	cltd   
  8019ba:	f7 f9                	idiv   %ecx
  8019bc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8019bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c2:	8d 50 01             	lea    0x1(%eax),%edx
  8019c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019c8:	89 c2                	mov    %eax,%edx
  8019ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cd:	01 d0                	add    %edx,%eax
  8019cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019d2:	83 c2 30             	add    $0x30,%edx
  8019d5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019da:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019df:	f7 e9                	imul   %ecx
  8019e1:	c1 fa 02             	sar    $0x2,%edx
  8019e4:	89 c8                	mov    %ecx,%eax
  8019e6:	c1 f8 1f             	sar    $0x1f,%eax
  8019e9:	29 c2                	sub    %eax,%edx
  8019eb:	89 d0                	mov    %edx,%eax
  8019ed:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8019f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019f3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019f8:	f7 e9                	imul   %ecx
  8019fa:	c1 fa 02             	sar    $0x2,%edx
  8019fd:	89 c8                	mov    %ecx,%eax
  8019ff:	c1 f8 1f             	sar    $0x1f,%eax
  801a02:	29 c2                	sub    %eax,%edx
  801a04:	89 d0                	mov    %edx,%eax
  801a06:	c1 e0 02             	shl    $0x2,%eax
  801a09:	01 d0                	add    %edx,%eax
  801a0b:	01 c0                	add    %eax,%eax
  801a0d:	29 c1                	sub    %eax,%ecx
  801a0f:	89 ca                	mov    %ecx,%edx
  801a11:	85 d2                	test   %edx,%edx
  801a13:	75 9c                	jne    8019b1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1f:	48                   	dec    %eax
  801a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a23:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a27:	74 3d                	je     801a66 <ltostr+0xe2>
		start = 1 ;
  801a29:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a30:	eb 34                	jmp    801a66 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	8a 00                	mov    (%eax),%al
  801a3c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a45:	01 c2                	add    %eax,%edx
  801a47:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4d:	01 c8                	add    %ecx,%eax
  801a4f:	8a 00                	mov    (%eax),%al
  801a51:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a59:	01 c2                	add    %eax,%edx
  801a5b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a5e:	88 02                	mov    %al,(%edx)
		start++ ;
  801a60:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a63:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a6c:	7c c4                	jl     801a32 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a6e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a74:	01 d0                	add    %edx,%eax
  801a76:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a79:	90                   	nop
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a82:	ff 75 08             	pushl  0x8(%ebp)
  801a85:	e8 54 fa ff ff       	call   8014de <strlen>
  801a8a:	83 c4 04             	add    $0x4,%esp
  801a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	e8 46 fa ff ff       	call   8014de <strlen>
  801a98:	83 c4 04             	add    $0x4,%esp
  801a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801aa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801aac:	eb 17                	jmp    801ac5 <strcconcat+0x49>
		final[s] = str1[s] ;
  801aae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab4:	01 c2                	add    %eax,%edx
  801ab6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	01 c8                	add    %ecx,%eax
  801abe:	8a 00                	mov    (%eax),%al
  801ac0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ac2:	ff 45 fc             	incl   -0x4(%ebp)
  801ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ac8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801acb:	7c e1                	jl     801aae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801acd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ad4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801adb:	eb 1f                	jmp    801afc <strcconcat+0x80>
		final[s++] = str2[i] ;
  801add:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae0:	8d 50 01             	lea    0x1(%eax),%edx
  801ae3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ae6:	89 c2                	mov    %eax,%edx
  801ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  801aeb:	01 c2                	add    %eax,%edx
  801aed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af3:	01 c8                	add    %ecx,%eax
  801af5:	8a 00                	mov    (%eax),%al
  801af7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801af9:	ff 45 f8             	incl   -0x8(%ebp)
  801afc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b02:	7c d9                	jl     801add <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b07:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0a:	01 d0                	add    %edx,%eax
  801b0c:	c6 00 00             	movb   $0x0,(%eax)
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b15:	8b 45 14             	mov    0x14(%ebp),%eax
  801b18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b21:	8b 00                	mov    (%eax),%eax
  801b23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2d:	01 d0                	add    %edx,%eax
  801b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b35:	eb 0c                	jmp    801b43 <strsplit+0x31>
			*string++ = 0;
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	8d 50 01             	lea    0x1(%eax),%edx
  801b3d:	89 55 08             	mov    %edx,0x8(%ebp)
  801b40:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	8a 00                	mov    (%eax),%al
  801b48:	84 c0                	test   %al,%al
  801b4a:	74 18                	je     801b64 <strsplit+0x52>
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	8a 00                	mov    (%eax),%al
  801b51:	0f be c0             	movsbl %al,%eax
  801b54:	50                   	push   %eax
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	e8 13 fb ff ff       	call   801670 <strchr>
  801b5d:	83 c4 08             	add    $0x8,%esp
  801b60:	85 c0                	test   %eax,%eax
  801b62:	75 d3                	jne    801b37 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	8a 00                	mov    (%eax),%al
  801b69:	84 c0                	test   %al,%al
  801b6b:	74 5a                	je     801bc7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b70:	8b 00                	mov    (%eax),%eax
  801b72:	83 f8 0f             	cmp    $0xf,%eax
  801b75:	75 07                	jne    801b7e <strsplit+0x6c>
		{
			return 0;
  801b77:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7c:	eb 66                	jmp    801be4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b81:	8b 00                	mov    (%eax),%eax
  801b83:	8d 48 01             	lea    0x1(%eax),%ecx
  801b86:	8b 55 14             	mov    0x14(%ebp),%edx
  801b89:	89 0a                	mov    %ecx,(%edx)
  801b8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b92:	8b 45 10             	mov    0x10(%ebp),%eax
  801b95:	01 c2                	add    %eax,%edx
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b9c:	eb 03                	jmp    801ba1 <strsplit+0x8f>
			string++;
  801b9e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	8a 00                	mov    (%eax),%al
  801ba6:	84 c0                	test   %al,%al
  801ba8:	74 8b                	je     801b35 <strsplit+0x23>
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	8a 00                	mov    (%eax),%al
  801baf:	0f be c0             	movsbl %al,%eax
  801bb2:	50                   	push   %eax
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	e8 b5 fa ff ff       	call   801670 <strchr>
  801bbb:	83 c4 08             	add    $0x8,%esp
  801bbe:	85 c0                	test   %eax,%eax
  801bc0:	74 dc                	je     801b9e <strsplit+0x8c>
			string++;
	}
  801bc2:	e9 6e ff ff ff       	jmp    801b35 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801bc7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcb:	8b 00                	mov    (%eax),%eax
  801bcd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd7:	01 d0                	add    %edx,%eax
  801bd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801bdf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801bec:	a1 04 50 80 00       	mov    0x805004,%eax
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	74 1f                	je     801c14 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801bf5:	e8 1d 00 00 00       	call   801c17 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801bfa:	83 ec 0c             	sub    $0xc,%esp
  801bfd:	68 24 43 80 00       	push   $0x804324
  801c02:	e8 4f f0 ff ff       	call   800c56 <cprintf>
  801c07:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801c0a:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801c11:	00 00 00 
	}
}
  801c14:	90                   	nop
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801c1d:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801c24:	00 00 00 
  801c27:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801c2e:	00 00 00 
  801c31:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801c38:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801c3b:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801c42:	00 00 00 
  801c45:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801c4c:	00 00 00 
  801c4f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801c56:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801c59:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c68:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c6d:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801c72:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801c79:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801c7c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c86:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801c8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c91:	ba 00 00 00 00       	mov    $0x0,%edx
  801c96:	f7 75 f0             	divl   -0x10(%ebp)
  801c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c9c:	29 d0                	sub    %edx,%eax
  801c9e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801ca1:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801cb0:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cb5:	83 ec 04             	sub    $0x4,%esp
  801cb8:	6a 06                	push   $0x6
  801cba:	ff 75 e8             	pushl  -0x18(%ebp)
  801cbd:	50                   	push   %eax
  801cbe:	e8 d4 05 00 00       	call   802297 <sys_allocate_chunk>
  801cc3:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801cc6:	a1 20 51 80 00       	mov    0x805120,%eax
  801ccb:	83 ec 0c             	sub    $0xc,%esp
  801cce:	50                   	push   %eax
  801ccf:	e8 49 0c 00 00       	call   80291d <initialize_MemBlocksList>
  801cd4:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801cd7:	a1 48 51 80 00       	mov    0x805148,%eax
  801cdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801cdf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ce3:	75 14                	jne    801cf9 <initialize_dyn_block_system+0xe2>
  801ce5:	83 ec 04             	sub    $0x4,%esp
  801ce8:	68 49 43 80 00       	push   $0x804349
  801ced:	6a 39                	push   $0x39
  801cef:	68 67 43 80 00       	push   $0x804367
  801cf4:	e8 a9 ec ff ff       	call   8009a2 <_panic>
  801cf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cfc:	8b 00                	mov    (%eax),%eax
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	74 10                	je     801d12 <initialize_dyn_block_system+0xfb>
  801d02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d05:	8b 00                	mov    (%eax),%eax
  801d07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d0a:	8b 52 04             	mov    0x4(%edx),%edx
  801d0d:	89 50 04             	mov    %edx,0x4(%eax)
  801d10:	eb 0b                	jmp    801d1d <initialize_dyn_block_system+0x106>
  801d12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d15:	8b 40 04             	mov    0x4(%eax),%eax
  801d18:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d20:	8b 40 04             	mov    0x4(%eax),%eax
  801d23:	85 c0                	test   %eax,%eax
  801d25:	74 0f                	je     801d36 <initialize_dyn_block_system+0x11f>
  801d27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d2a:	8b 40 04             	mov    0x4(%eax),%eax
  801d2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d30:	8b 12                	mov    (%edx),%edx
  801d32:	89 10                	mov    %edx,(%eax)
  801d34:	eb 0a                	jmp    801d40 <initialize_dyn_block_system+0x129>
  801d36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d39:	8b 00                	mov    (%eax),%eax
  801d3b:	a3 48 51 80 00       	mov    %eax,0x805148
  801d40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d53:	a1 54 51 80 00       	mov    0x805154,%eax
  801d58:	48                   	dec    %eax
  801d59:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d61:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801d68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d6b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801d72:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801d76:	75 14                	jne    801d8c <initialize_dyn_block_system+0x175>
  801d78:	83 ec 04             	sub    $0x4,%esp
  801d7b:	68 74 43 80 00       	push   $0x804374
  801d80:	6a 3f                	push   $0x3f
  801d82:	68 67 43 80 00       	push   $0x804367
  801d87:	e8 16 ec ff ff       	call   8009a2 <_panic>
  801d8c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801d92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d95:	89 10                	mov    %edx,(%eax)
  801d97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d9a:	8b 00                	mov    (%eax),%eax
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	74 0d                	je     801dad <initialize_dyn_block_system+0x196>
  801da0:	a1 38 51 80 00       	mov    0x805138,%eax
  801da5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801da8:	89 50 04             	mov    %edx,0x4(%eax)
  801dab:	eb 08                	jmp    801db5 <initialize_dyn_block_system+0x19e>
  801dad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801db0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801db5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801db8:	a3 38 51 80 00       	mov    %eax,0x805138
  801dbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801dc7:	a1 44 51 80 00       	mov    0x805144,%eax
  801dcc:	40                   	inc    %eax
  801dcd:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801dd2:	90                   	nop
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ddb:	e8 06 fe ff ff       	call   801be6 <InitializeUHeap>
	if (size == 0) return NULL ;
  801de0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801de4:	75 07                	jne    801ded <malloc+0x18>
  801de6:	b8 00 00 00 00       	mov    $0x0,%eax
  801deb:	eb 7d                	jmp    801e6a <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801ded:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801df4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  801dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e01:	01 d0                	add    %edx,%eax
  801e03:	48                   	dec    %eax
  801e04:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0f:	f7 75 f0             	divl   -0x10(%ebp)
  801e12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e15:	29 d0                	sub    %edx,%eax
  801e17:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801e1a:	e8 46 08 00 00       	call   802665 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e1f:	83 f8 01             	cmp    $0x1,%eax
  801e22:	75 07                	jne    801e2b <malloc+0x56>
  801e24:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801e2b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801e2f:	75 34                	jne    801e65 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801e31:	83 ec 0c             	sub    $0xc,%esp
  801e34:	ff 75 e8             	pushl  -0x18(%ebp)
  801e37:	e8 73 0e 00 00       	call   802caf <alloc_block_FF>
  801e3c:	83 c4 10             	add    $0x10,%esp
  801e3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801e42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e46:	74 16                	je     801e5e <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801e48:	83 ec 0c             	sub    $0xc,%esp
  801e4b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e4e:	e8 ff 0b 00 00       	call   802a52 <insert_sorted_allocList>
  801e53:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801e56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e59:	8b 40 08             	mov    0x8(%eax),%eax
  801e5c:	eb 0c                	jmp    801e6a <malloc+0x95>
	             }
	             else
	             	return NULL;
  801e5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e63:	eb 05                	jmp    801e6a <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801e65:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e81:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e86:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801e89:	83 ec 08             	sub    $0x8,%esp
  801e8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8f:	68 40 50 80 00       	push   $0x805040
  801e94:	e8 61 0b 00 00       	call   8029fa <find_block>
  801e99:	83 c4 10             	add    $0x10,%esp
  801e9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801e9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ea3:	0f 84 a5 00 00 00    	je     801f4e <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eac:	8b 40 0c             	mov    0xc(%eax),%eax
  801eaf:	83 ec 08             	sub    $0x8,%esp
  801eb2:	50                   	push   %eax
  801eb3:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb6:	e8 a4 03 00 00       	call   80225f <sys_free_user_mem>
  801ebb:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801ebe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ec2:	75 17                	jne    801edb <free+0x6f>
  801ec4:	83 ec 04             	sub    $0x4,%esp
  801ec7:	68 49 43 80 00       	push   $0x804349
  801ecc:	68 87 00 00 00       	push   $0x87
  801ed1:	68 67 43 80 00       	push   $0x804367
  801ed6:	e8 c7 ea ff ff       	call   8009a2 <_panic>
  801edb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ede:	8b 00                	mov    (%eax),%eax
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	74 10                	je     801ef4 <free+0x88>
  801ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee7:	8b 00                	mov    (%eax),%eax
  801ee9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801eec:	8b 52 04             	mov    0x4(%edx),%edx
  801eef:	89 50 04             	mov    %edx,0x4(%eax)
  801ef2:	eb 0b                	jmp    801eff <free+0x93>
  801ef4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef7:	8b 40 04             	mov    0x4(%eax),%eax
  801efa:	a3 44 50 80 00       	mov    %eax,0x805044
  801eff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f02:	8b 40 04             	mov    0x4(%eax),%eax
  801f05:	85 c0                	test   %eax,%eax
  801f07:	74 0f                	je     801f18 <free+0xac>
  801f09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0c:	8b 40 04             	mov    0x4(%eax),%eax
  801f0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801f12:	8b 12                	mov    (%edx),%edx
  801f14:	89 10                	mov    %edx,(%eax)
  801f16:	eb 0a                	jmp    801f22 <free+0xb6>
  801f18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1b:	8b 00                	mov    (%eax),%eax
  801f1d:	a3 40 50 80 00       	mov    %eax,0x805040
  801f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f35:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801f3a:	48                   	dec    %eax
  801f3b:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801f40:	83 ec 0c             	sub    $0xc,%esp
  801f43:	ff 75 ec             	pushl  -0x14(%ebp)
  801f46:	e8 37 12 00 00       	call   803182 <insert_sorted_with_merge_freeList>
  801f4b:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801f4e:	90                   	nop
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	83 ec 38             	sub    $0x38,%esp
  801f57:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f5d:	e8 84 fc ff ff       	call   801be6 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f66:	75 07                	jne    801f6f <smalloc+0x1e>
  801f68:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6d:	eb 7e                	jmp    801fed <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801f6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801f76:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f83:	01 d0                	add    %edx,%eax
  801f85:	48                   	dec    %eax
  801f86:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f91:	f7 75 f0             	divl   -0x10(%ebp)
  801f94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f97:	29 d0                	sub    %edx,%eax
  801f99:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801f9c:	e8 c4 06 00 00       	call   802665 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fa1:	83 f8 01             	cmp    $0x1,%eax
  801fa4:	75 42                	jne    801fe8 <smalloc+0x97>

		  va = malloc(newsize) ;
  801fa6:	83 ec 0c             	sub    $0xc,%esp
  801fa9:	ff 75 e8             	pushl  -0x18(%ebp)
  801fac:	e8 24 fe ff ff       	call   801dd5 <malloc>
  801fb1:	83 c4 10             	add    $0x10,%esp
  801fb4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801fb7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801fbb:	74 24                	je     801fe1 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801fbd:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801fc1:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fc4:	50                   	push   %eax
  801fc5:	ff 75 e8             	pushl  -0x18(%ebp)
  801fc8:	ff 75 08             	pushl  0x8(%ebp)
  801fcb:	e8 1a 04 00 00       	call   8023ea <sys_createSharedObject>
  801fd0:	83 c4 10             	add    $0x10,%esp
  801fd3:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801fd6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fda:	78 0c                	js     801fe8 <smalloc+0x97>
					  return va ;
  801fdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fdf:	eb 0c                	jmp    801fed <smalloc+0x9c>
				 }
				 else
					return NULL;
  801fe1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe6:	eb 05                	jmp    801fed <smalloc+0x9c>
	  }
		  return NULL ;
  801fe8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ff5:	e8 ec fb ff ff       	call   801be6 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801ffa:	83 ec 08             	sub    $0x8,%esp
  801ffd:	ff 75 0c             	pushl  0xc(%ebp)
  802000:	ff 75 08             	pushl  0x8(%ebp)
  802003:	e8 0c 04 00 00       	call   802414 <sys_getSizeOfSharedObject>
  802008:	83 c4 10             	add    $0x10,%esp
  80200b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  80200e:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  802012:	75 07                	jne    80201b <sget+0x2c>
  802014:	b8 00 00 00 00       	mov    $0x0,%eax
  802019:	eb 75                	jmp    802090 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80201b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802022:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802025:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802028:	01 d0                	add    %edx,%eax
  80202a:	48                   	dec    %eax
  80202b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80202e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802031:	ba 00 00 00 00       	mov    $0x0,%edx
  802036:	f7 75 f0             	divl   -0x10(%ebp)
  802039:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203c:	29 d0                	sub    %edx,%eax
  80203e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  802041:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  802048:	e8 18 06 00 00       	call   802665 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80204d:	83 f8 01             	cmp    $0x1,%eax
  802050:	75 39                	jne    80208b <sget+0x9c>

		  va = malloc(newsize) ;
  802052:	83 ec 0c             	sub    $0xc,%esp
  802055:	ff 75 e8             	pushl  -0x18(%ebp)
  802058:	e8 78 fd ff ff       	call   801dd5 <malloc>
  80205d:	83 c4 10             	add    $0x10,%esp
  802060:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  802063:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802067:	74 22                	je     80208b <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  802069:	83 ec 04             	sub    $0x4,%esp
  80206c:	ff 75 e0             	pushl  -0x20(%ebp)
  80206f:	ff 75 0c             	pushl  0xc(%ebp)
  802072:	ff 75 08             	pushl  0x8(%ebp)
  802075:	e8 b7 03 00 00       	call   802431 <sys_getSharedObject>
  80207a:	83 c4 10             	add    $0x10,%esp
  80207d:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  802080:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802084:	78 05                	js     80208b <sget+0x9c>
					  return va;
  802086:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802089:	eb 05                	jmp    802090 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  80208b:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802098:	e8 49 fb ff ff       	call   801be6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80209d:	83 ec 04             	sub    $0x4,%esp
  8020a0:	68 98 43 80 00       	push   $0x804398
  8020a5:	68 1e 01 00 00       	push   $0x11e
  8020aa:	68 67 43 80 00       	push   $0x804367
  8020af:	e8 ee e8 ff ff       	call   8009a2 <_panic>

008020b4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8020ba:	83 ec 04             	sub    $0x4,%esp
  8020bd:	68 c0 43 80 00       	push   $0x8043c0
  8020c2:	68 32 01 00 00       	push   $0x132
  8020c7:	68 67 43 80 00       	push   $0x804367
  8020cc:	e8 d1 e8 ff ff       	call   8009a2 <_panic>

008020d1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020d7:	83 ec 04             	sub    $0x4,%esp
  8020da:	68 e4 43 80 00       	push   $0x8043e4
  8020df:	68 3d 01 00 00       	push   $0x13d
  8020e4:	68 67 43 80 00       	push   $0x804367
  8020e9:	e8 b4 e8 ff ff       	call   8009a2 <_panic>

008020ee <shrink>:

}
void shrink(uint32 newSize)
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020f4:	83 ec 04             	sub    $0x4,%esp
  8020f7:	68 e4 43 80 00       	push   $0x8043e4
  8020fc:	68 42 01 00 00       	push   $0x142
  802101:	68 67 43 80 00       	push   $0x804367
  802106:	e8 97 e8 ff ff       	call   8009a2 <_panic>

0080210b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802111:	83 ec 04             	sub    $0x4,%esp
  802114:	68 e4 43 80 00       	push   $0x8043e4
  802119:	68 47 01 00 00       	push   $0x147
  80211e:	68 67 43 80 00       	push   $0x804367
  802123:	e8 7a e8 ff ff       	call   8009a2 <_panic>

00802128 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	57                   	push   %edi
  80212c:	56                   	push   %esi
  80212d:	53                   	push   %ebx
  80212e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	8b 55 0c             	mov    0xc(%ebp),%edx
  802137:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80213a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80213d:	8b 7d 18             	mov    0x18(%ebp),%edi
  802140:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802143:	cd 30                	int    $0x30
  802145:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802148:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80214b:	83 c4 10             	add    $0x10,%esp
  80214e:	5b                   	pop    %ebx
  80214f:	5e                   	pop    %esi
  802150:	5f                   	pop    %edi
  802151:	5d                   	pop    %ebp
  802152:	c3                   	ret    

00802153 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	83 ec 04             	sub    $0x4,%esp
  802159:	8b 45 10             	mov    0x10(%ebp),%eax
  80215c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80215f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	52                   	push   %edx
  80216b:	ff 75 0c             	pushl  0xc(%ebp)
  80216e:	50                   	push   %eax
  80216f:	6a 00                	push   $0x0
  802171:	e8 b2 ff ff ff       	call   802128 <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
}
  802179:	90                   	nop
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <sys_cgetc>:

int
sys_cgetc(void)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 01                	push   $0x1
  80218b:	e8 98 ff ff ff       	call   802128 <syscall>
  802190:	83 c4 18             	add    $0x18,%esp
}
  802193:	c9                   	leave  
  802194:	c3                   	ret    

00802195 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802195:	55                   	push   %ebp
  802196:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802198:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	52                   	push   %edx
  8021a5:	50                   	push   %eax
  8021a6:	6a 05                	push   $0x5
  8021a8:	e8 7b ff ff ff       	call   802128 <syscall>
  8021ad:	83 c4 18             	add    $0x18,%esp
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	56                   	push   %esi
  8021b6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8021ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	56                   	push   %esi
  8021c7:	53                   	push   %ebx
  8021c8:	51                   	push   %ecx
  8021c9:	52                   	push   %edx
  8021ca:	50                   	push   %eax
  8021cb:	6a 06                	push   $0x6
  8021cd:	e8 56 ff ff ff       	call   802128 <syscall>
  8021d2:	83 c4 18             	add    $0x18,%esp
}
  8021d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021d8:	5b                   	pop    %ebx
  8021d9:	5e                   	pop    %esi
  8021da:	5d                   	pop    %ebp
  8021db:	c3                   	ret    

008021dc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	52                   	push   %edx
  8021ec:	50                   	push   %eax
  8021ed:	6a 07                	push   $0x7
  8021ef:	e8 34 ff ff ff       	call   802128 <syscall>
  8021f4:	83 c4 18             	add    $0x18,%esp
}
  8021f7:	c9                   	leave  
  8021f8:	c3                   	ret    

008021f9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	ff 75 0c             	pushl  0xc(%ebp)
  802205:	ff 75 08             	pushl  0x8(%ebp)
  802208:	6a 08                	push   $0x8
  80220a:	e8 19 ff ff ff       	call   802128 <syscall>
  80220f:	83 c4 18             	add    $0x18,%esp
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 09                	push   $0x9
  802223:	e8 00 ff ff ff       	call   802128 <syscall>
  802228:	83 c4 18             	add    $0x18,%esp
}
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 0a                	push   $0xa
  80223c:	e8 e7 fe ff ff       	call   802128 <syscall>
  802241:	83 c4 18             	add    $0x18,%esp
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 0b                	push   $0xb
  802255:	e8 ce fe ff ff       	call   802128 <syscall>
  80225a:	83 c4 18             	add    $0x18,%esp
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	ff 75 0c             	pushl  0xc(%ebp)
  80226b:	ff 75 08             	pushl  0x8(%ebp)
  80226e:	6a 0f                	push   $0xf
  802270:	e8 b3 fe ff ff       	call   802128 <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
	return;
  802278:	90                   	nop
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	ff 75 0c             	pushl  0xc(%ebp)
  802287:	ff 75 08             	pushl  0x8(%ebp)
  80228a:	6a 10                	push   $0x10
  80228c:	e8 97 fe ff ff       	call   802128 <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
	return ;
  802294:	90                   	nop
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	ff 75 10             	pushl  0x10(%ebp)
  8022a1:	ff 75 0c             	pushl  0xc(%ebp)
  8022a4:	ff 75 08             	pushl  0x8(%ebp)
  8022a7:	6a 11                	push   $0x11
  8022a9:	e8 7a fe ff ff       	call   802128 <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b1:	90                   	nop
}
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 0c                	push   $0xc
  8022c3:	e8 60 fe ff ff       	call   802128 <syscall>
  8022c8:	83 c4 18             	add    $0x18,%esp
}
  8022cb:	c9                   	leave  
  8022cc:	c3                   	ret    

008022cd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022cd:	55                   	push   %ebp
  8022ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	ff 75 08             	pushl  0x8(%ebp)
  8022db:	6a 0d                	push   $0xd
  8022dd:	e8 46 fe ff ff       	call   802128 <syscall>
  8022e2:	83 c4 18             	add    $0x18,%esp
}
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 0e                	push   $0xe
  8022f6:	e8 2d fe ff ff       	call   802128 <syscall>
  8022fb:	83 c4 18             	add    $0x18,%esp
}
  8022fe:	90                   	nop
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 13                	push   $0x13
  802310:	e8 13 fe ff ff       	call   802128 <syscall>
  802315:	83 c4 18             	add    $0x18,%esp
}
  802318:	90                   	nop
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 14                	push   $0x14
  80232a:	e8 f9 fd ff ff       	call   802128 <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
}
  802332:	90                   	nop
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <sys_cputc>:


void
sys_cputc(const char c)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	83 ec 04             	sub    $0x4,%esp
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802341:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	50                   	push   %eax
  80234e:	6a 15                	push   $0x15
  802350:	e8 d3 fd ff ff       	call   802128 <syscall>
  802355:	83 c4 18             	add    $0x18,%esp
}
  802358:	90                   	nop
  802359:	c9                   	leave  
  80235a:	c3                   	ret    

0080235b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 16                	push   $0x16
  80236a:	e8 b9 fd ff ff       	call   802128 <syscall>
  80236f:	83 c4 18             	add    $0x18,%esp
}
  802372:	90                   	nop
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	ff 75 0c             	pushl  0xc(%ebp)
  802384:	50                   	push   %eax
  802385:	6a 17                	push   $0x17
  802387:	e8 9c fd ff ff       	call   802128 <syscall>
  80238c:	83 c4 18             	add    $0x18,%esp
}
  80238f:	c9                   	leave  
  802390:	c3                   	ret    

00802391 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802394:	8b 55 0c             	mov    0xc(%ebp),%edx
  802397:	8b 45 08             	mov    0x8(%ebp),%eax
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	52                   	push   %edx
  8023a1:	50                   	push   %eax
  8023a2:	6a 1a                	push   $0x1a
  8023a4:	e8 7f fd ff ff       	call   802128 <syscall>
  8023a9:	83 c4 18             	add    $0x18,%esp
}
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	52                   	push   %edx
  8023be:	50                   	push   %eax
  8023bf:	6a 18                	push   $0x18
  8023c1:	e8 62 fd ff ff       	call   802128 <syscall>
  8023c6:	83 c4 18             	add    $0x18,%esp
}
  8023c9:	90                   	nop
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	52                   	push   %edx
  8023dc:	50                   	push   %eax
  8023dd:	6a 19                	push   $0x19
  8023df:	e8 44 fd ff ff       	call   802128 <syscall>
  8023e4:	83 c4 18             	add    $0x18,%esp
}
  8023e7:	90                   	nop
  8023e8:	c9                   	leave  
  8023e9:	c3                   	ret    

008023ea <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
  8023ed:	83 ec 04             	sub    $0x4,%esp
  8023f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023f6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023f9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802400:	6a 00                	push   $0x0
  802402:	51                   	push   %ecx
  802403:	52                   	push   %edx
  802404:	ff 75 0c             	pushl  0xc(%ebp)
  802407:	50                   	push   %eax
  802408:	6a 1b                	push   $0x1b
  80240a:	e8 19 fd ff ff       	call   802128 <syscall>
  80240f:	83 c4 18             	add    $0x18,%esp
}
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802417:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	52                   	push   %edx
  802424:	50                   	push   %eax
  802425:	6a 1c                	push   $0x1c
  802427:	e8 fc fc ff ff       	call   802128 <syscall>
  80242c:	83 c4 18             	add    $0x18,%esp
}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802434:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802437:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	51                   	push   %ecx
  802442:	52                   	push   %edx
  802443:	50                   	push   %eax
  802444:	6a 1d                	push   $0x1d
  802446:	e8 dd fc ff ff       	call   802128 <syscall>
  80244b:	83 c4 18             	add    $0x18,%esp
}
  80244e:	c9                   	leave  
  80244f:	c3                   	ret    

00802450 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802453:	8b 55 0c             	mov    0xc(%ebp),%edx
  802456:	8b 45 08             	mov    0x8(%ebp),%eax
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	52                   	push   %edx
  802460:	50                   	push   %eax
  802461:	6a 1e                	push   $0x1e
  802463:	e8 c0 fc ff ff       	call   802128 <syscall>
  802468:	83 c4 18             	add    $0x18,%esp
}
  80246b:	c9                   	leave  
  80246c:	c3                   	ret    

0080246d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 1f                	push   $0x1f
  80247c:	e8 a7 fc ff ff       	call   802128 <syscall>
  802481:	83 c4 18             	add    $0x18,%esp
}
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	6a 00                	push   $0x0
  80248e:	ff 75 14             	pushl  0x14(%ebp)
  802491:	ff 75 10             	pushl  0x10(%ebp)
  802494:	ff 75 0c             	pushl  0xc(%ebp)
  802497:	50                   	push   %eax
  802498:	6a 20                	push   $0x20
  80249a:	e8 89 fc ff ff       	call   802128 <syscall>
  80249f:	83 c4 18             	add    $0x18,%esp
}
  8024a2:	c9                   	leave  
  8024a3:	c3                   	ret    

008024a4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	50                   	push   %eax
  8024b3:	6a 21                	push   $0x21
  8024b5:	e8 6e fc ff ff       	call   802128 <syscall>
  8024ba:	83 c4 18             	add    $0x18,%esp
}
  8024bd:	90                   	nop
  8024be:	c9                   	leave  
  8024bf:	c3                   	ret    

008024c0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	50                   	push   %eax
  8024cf:	6a 22                	push   $0x22
  8024d1:	e8 52 fc ff ff       	call   802128 <syscall>
  8024d6:	83 c4 18             	add    $0x18,%esp
}
  8024d9:	c9                   	leave  
  8024da:	c3                   	ret    

008024db <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 02                	push   $0x2
  8024ea:	e8 39 fc ff ff       	call   802128 <syscall>
  8024ef:	83 c4 18             	add    $0x18,%esp
}
  8024f2:	c9                   	leave  
  8024f3:	c3                   	ret    

008024f4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 03                	push   $0x3
  802503:	e8 20 fc ff ff       	call   802128 <syscall>
  802508:	83 c4 18             	add    $0x18,%esp
}
  80250b:	c9                   	leave  
  80250c:	c3                   	ret    

0080250d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80250d:	55                   	push   %ebp
  80250e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 04                	push   $0x4
  80251c:	e8 07 fc ff ff       	call   802128 <syscall>
  802521:	83 c4 18             	add    $0x18,%esp
}
  802524:	c9                   	leave  
  802525:	c3                   	ret    

00802526 <sys_exit_env>:


void sys_exit_env(void)
{
  802526:	55                   	push   %ebp
  802527:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	6a 23                	push   $0x23
  802535:	e8 ee fb ff ff       	call   802128 <syscall>
  80253a:	83 c4 18             	add    $0x18,%esp
}
  80253d:	90                   	nop
  80253e:	c9                   	leave  
  80253f:	c3                   	ret    

00802540 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
  802543:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802546:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802549:	8d 50 04             	lea    0x4(%eax),%edx
  80254c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	52                   	push   %edx
  802556:	50                   	push   %eax
  802557:	6a 24                	push   $0x24
  802559:	e8 ca fb ff ff       	call   802128 <syscall>
  80255e:	83 c4 18             	add    $0x18,%esp
	return result;
  802561:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802564:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802567:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80256a:	89 01                	mov    %eax,(%ecx)
  80256c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80256f:	8b 45 08             	mov    0x8(%ebp),%eax
  802572:	c9                   	leave  
  802573:	c2 04 00             	ret    $0x4

00802576 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	ff 75 10             	pushl  0x10(%ebp)
  802580:	ff 75 0c             	pushl  0xc(%ebp)
  802583:	ff 75 08             	pushl  0x8(%ebp)
  802586:	6a 12                	push   $0x12
  802588:	e8 9b fb ff ff       	call   802128 <syscall>
  80258d:	83 c4 18             	add    $0x18,%esp
	return ;
  802590:	90                   	nop
}
  802591:	c9                   	leave  
  802592:	c3                   	ret    

00802593 <sys_rcr2>:
uint32 sys_rcr2()
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 25                	push   $0x25
  8025a2:	e8 81 fb ff ff       	call   802128 <syscall>
  8025a7:	83 c4 18             	add    $0x18,%esp
}
  8025aa:	c9                   	leave  
  8025ab:	c3                   	ret    

008025ac <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8025ac:	55                   	push   %ebp
  8025ad:	89 e5                	mov    %esp,%ebp
  8025af:	83 ec 04             	sub    $0x4,%esp
  8025b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025b8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	50                   	push   %eax
  8025c5:	6a 26                	push   $0x26
  8025c7:	e8 5c fb ff ff       	call   802128 <syscall>
  8025cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8025cf:	90                   	nop
}
  8025d0:	c9                   	leave  
  8025d1:	c3                   	ret    

008025d2 <rsttst>:
void rsttst()
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 28                	push   $0x28
  8025e1:	e8 42 fb ff ff       	call   802128 <syscall>
  8025e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8025e9:	90                   	nop
}
  8025ea:	c9                   	leave  
  8025eb:	c3                   	ret    

008025ec <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
  8025ef:	83 ec 04             	sub    $0x4,%esp
  8025f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8025f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025f8:	8b 55 18             	mov    0x18(%ebp),%edx
  8025fb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025ff:	52                   	push   %edx
  802600:	50                   	push   %eax
  802601:	ff 75 10             	pushl  0x10(%ebp)
  802604:	ff 75 0c             	pushl  0xc(%ebp)
  802607:	ff 75 08             	pushl  0x8(%ebp)
  80260a:	6a 27                	push   $0x27
  80260c:	e8 17 fb ff ff       	call   802128 <syscall>
  802611:	83 c4 18             	add    $0x18,%esp
	return ;
  802614:	90                   	nop
}
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <chktst>:
void chktst(uint32 n)
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	ff 75 08             	pushl  0x8(%ebp)
  802625:	6a 29                	push   $0x29
  802627:	e8 fc fa ff ff       	call   802128 <syscall>
  80262c:	83 c4 18             	add    $0x18,%esp
	return ;
  80262f:	90                   	nop
}
  802630:	c9                   	leave  
  802631:	c3                   	ret    

00802632 <inctst>:

void inctst()
{
  802632:	55                   	push   %ebp
  802633:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 00                	push   $0x0
  80263f:	6a 2a                	push   $0x2a
  802641:	e8 e2 fa ff ff       	call   802128 <syscall>
  802646:	83 c4 18             	add    $0x18,%esp
	return ;
  802649:	90                   	nop
}
  80264a:	c9                   	leave  
  80264b:	c3                   	ret    

0080264c <gettst>:
uint32 gettst()
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80264f:	6a 00                	push   $0x0
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 2b                	push   $0x2b
  80265b:	e8 c8 fa ff ff       	call   802128 <syscall>
  802660:	83 c4 18             	add    $0x18,%esp
}
  802663:	c9                   	leave  
  802664:	c3                   	ret    

00802665 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80266b:	6a 00                	push   $0x0
  80266d:	6a 00                	push   $0x0
  80266f:	6a 00                	push   $0x0
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	6a 2c                	push   $0x2c
  802677:	e8 ac fa ff ff       	call   802128 <syscall>
  80267c:	83 c4 18             	add    $0x18,%esp
  80267f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802682:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802686:	75 07                	jne    80268f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802688:	b8 01 00 00 00       	mov    $0x1,%eax
  80268d:	eb 05                	jmp    802694 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80268f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802694:	c9                   	leave  
  802695:	c3                   	ret    

00802696 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802696:	55                   	push   %ebp
  802697:	89 e5                	mov    %esp,%ebp
  802699:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 00                	push   $0x0
  8026a4:	6a 00                	push   $0x0
  8026a6:	6a 2c                	push   $0x2c
  8026a8:	e8 7b fa ff ff       	call   802128 <syscall>
  8026ad:	83 c4 18             	add    $0x18,%esp
  8026b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026b3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026b7:	75 07                	jne    8026c0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8026be:	eb 05                	jmp    8026c5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c5:	c9                   	leave  
  8026c6:	c3                   	ret    

008026c7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026c7:	55                   	push   %ebp
  8026c8:	89 e5                	mov    %esp,%ebp
  8026ca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 00                	push   $0x0
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 2c                	push   $0x2c
  8026d9:	e8 4a fa ff ff       	call   802128 <syscall>
  8026de:	83 c4 18             	add    $0x18,%esp
  8026e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026e4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026e8:	75 07                	jne    8026f1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ef:	eb 05                	jmp    8026f6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f6:	c9                   	leave  
  8026f7:	c3                   	ret    

008026f8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8026f8:	55                   	push   %ebp
  8026f9:	89 e5                	mov    %esp,%ebp
  8026fb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	6a 2c                	push   $0x2c
  80270a:	e8 19 fa ff ff       	call   802128 <syscall>
  80270f:	83 c4 18             	add    $0x18,%esp
  802712:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802715:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802719:	75 07                	jne    802722 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80271b:	b8 01 00 00 00       	mov    $0x1,%eax
  802720:	eb 05                	jmp    802727 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802722:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802727:	c9                   	leave  
  802728:	c3                   	ret    

00802729 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802729:	55                   	push   %ebp
  80272a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	ff 75 08             	pushl  0x8(%ebp)
  802737:	6a 2d                	push   $0x2d
  802739:	e8 ea f9 ff ff       	call   802128 <syscall>
  80273e:	83 c4 18             	add    $0x18,%esp
	return ;
  802741:	90                   	nop
}
  802742:	c9                   	leave  
  802743:	c3                   	ret    

00802744 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802744:	55                   	push   %ebp
  802745:	89 e5                	mov    %esp,%ebp
  802747:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802748:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80274b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80274e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802751:	8b 45 08             	mov    0x8(%ebp),%eax
  802754:	6a 00                	push   $0x0
  802756:	53                   	push   %ebx
  802757:	51                   	push   %ecx
  802758:	52                   	push   %edx
  802759:	50                   	push   %eax
  80275a:	6a 2e                	push   $0x2e
  80275c:	e8 c7 f9 ff ff       	call   802128 <syscall>
  802761:	83 c4 18             	add    $0x18,%esp
}
  802764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802767:	c9                   	leave  
  802768:	c3                   	ret    

00802769 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802769:	55                   	push   %ebp
  80276a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80276c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276f:	8b 45 08             	mov    0x8(%ebp),%eax
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	52                   	push   %edx
  802779:	50                   	push   %eax
  80277a:	6a 2f                	push   $0x2f
  80277c:	e8 a7 f9 ff ff       	call   802128 <syscall>
  802781:	83 c4 18             	add    $0x18,%esp
}
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
  802789:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80278c:	83 ec 0c             	sub    $0xc,%esp
  80278f:	68 f4 43 80 00       	push   $0x8043f4
  802794:	e8 bd e4 ff ff       	call   800c56 <cprintf>
  802799:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80279c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8027a3:	83 ec 0c             	sub    $0xc,%esp
  8027a6:	68 20 44 80 00       	push   $0x804420
  8027ab:	e8 a6 e4 ff ff       	call   800c56 <cprintf>
  8027b0:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8027b3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027b7:	a1 38 51 80 00       	mov    0x805138,%eax
  8027bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027bf:	eb 56                	jmp    802817 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027c5:	74 1c                	je     8027e3 <print_mem_block_lists+0x5d>
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 50 08             	mov    0x8(%eax),%edx
  8027cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d0:	8b 48 08             	mov    0x8(%eax),%ecx
  8027d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d9:	01 c8                	add    %ecx,%eax
  8027db:	39 c2                	cmp    %eax,%edx
  8027dd:	73 04                	jae    8027e3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8027df:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 50 08             	mov    0x8(%eax),%edx
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ef:	01 c2                	add    %eax,%edx
  8027f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f4:	8b 40 08             	mov    0x8(%eax),%eax
  8027f7:	83 ec 04             	sub    $0x4,%esp
  8027fa:	52                   	push   %edx
  8027fb:	50                   	push   %eax
  8027fc:	68 35 44 80 00       	push   $0x804435
  802801:	e8 50 e4 ff ff       	call   800c56 <cprintf>
  802806:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80280f:	a1 40 51 80 00       	mov    0x805140,%eax
  802814:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802817:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281b:	74 07                	je     802824 <print_mem_block_lists+0x9e>
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 00                	mov    (%eax),%eax
  802822:	eb 05                	jmp    802829 <print_mem_block_lists+0xa3>
  802824:	b8 00 00 00 00       	mov    $0x0,%eax
  802829:	a3 40 51 80 00       	mov    %eax,0x805140
  80282e:	a1 40 51 80 00       	mov    0x805140,%eax
  802833:	85 c0                	test   %eax,%eax
  802835:	75 8a                	jne    8027c1 <print_mem_block_lists+0x3b>
  802837:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283b:	75 84                	jne    8027c1 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80283d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802841:	75 10                	jne    802853 <print_mem_block_lists+0xcd>
  802843:	83 ec 0c             	sub    $0xc,%esp
  802846:	68 44 44 80 00       	push   $0x804444
  80284b:	e8 06 e4 ff ff       	call   800c56 <cprintf>
  802850:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802853:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80285a:	83 ec 0c             	sub    $0xc,%esp
  80285d:	68 68 44 80 00       	push   $0x804468
  802862:	e8 ef e3 ff ff       	call   800c56 <cprintf>
  802867:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80286a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80286e:	a1 40 50 80 00       	mov    0x805040,%eax
  802873:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802876:	eb 56                	jmp    8028ce <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802878:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80287c:	74 1c                	je     80289a <print_mem_block_lists+0x114>
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 50 08             	mov    0x8(%eax),%edx
  802884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802887:	8b 48 08             	mov    0x8(%eax),%ecx
  80288a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288d:	8b 40 0c             	mov    0xc(%eax),%eax
  802890:	01 c8                	add    %ecx,%eax
  802892:	39 c2                	cmp    %eax,%edx
  802894:	73 04                	jae    80289a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802896:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	8b 50 08             	mov    0x8(%eax),%edx
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a6:	01 c2                	add    %eax,%edx
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 40 08             	mov    0x8(%eax),%eax
  8028ae:	83 ec 04             	sub    $0x4,%esp
  8028b1:	52                   	push   %edx
  8028b2:	50                   	push   %eax
  8028b3:	68 35 44 80 00       	push   $0x804435
  8028b8:	e8 99 e3 ff ff       	call   800c56 <cprintf>
  8028bd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028c6:	a1 48 50 80 00       	mov    0x805048,%eax
  8028cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d2:	74 07                	je     8028db <print_mem_block_lists+0x155>
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	eb 05                	jmp    8028e0 <print_mem_block_lists+0x15a>
  8028db:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e0:	a3 48 50 80 00       	mov    %eax,0x805048
  8028e5:	a1 48 50 80 00       	mov    0x805048,%eax
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	75 8a                	jne    802878 <print_mem_block_lists+0xf2>
  8028ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f2:	75 84                	jne    802878 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8028f4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028f8:	75 10                	jne    80290a <print_mem_block_lists+0x184>
  8028fa:	83 ec 0c             	sub    $0xc,%esp
  8028fd:	68 80 44 80 00       	push   $0x804480
  802902:	e8 4f e3 ff ff       	call   800c56 <cprintf>
  802907:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80290a:	83 ec 0c             	sub    $0xc,%esp
  80290d:	68 f4 43 80 00       	push   $0x8043f4
  802912:	e8 3f e3 ff ff       	call   800c56 <cprintf>
  802917:	83 c4 10             	add    $0x10,%esp

}
  80291a:	90                   	nop
  80291b:	c9                   	leave  
  80291c:	c3                   	ret    

0080291d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80291d:	55                   	push   %ebp
  80291e:	89 e5                	mov    %esp,%ebp
  802920:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802923:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80292a:	00 00 00 
  80292d:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802934:	00 00 00 
  802937:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80293e:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802941:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802948:	e9 9e 00 00 00       	jmp    8029eb <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80294d:	a1 50 50 80 00       	mov    0x805050,%eax
  802952:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802955:	c1 e2 04             	shl    $0x4,%edx
  802958:	01 d0                	add    %edx,%eax
  80295a:	85 c0                	test   %eax,%eax
  80295c:	75 14                	jne    802972 <initialize_MemBlocksList+0x55>
  80295e:	83 ec 04             	sub    $0x4,%esp
  802961:	68 a8 44 80 00       	push   $0x8044a8
  802966:	6a 47                	push   $0x47
  802968:	68 cb 44 80 00       	push   $0x8044cb
  80296d:	e8 30 e0 ff ff       	call   8009a2 <_panic>
  802972:	a1 50 50 80 00       	mov    0x805050,%eax
  802977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80297a:	c1 e2 04             	shl    $0x4,%edx
  80297d:	01 d0                	add    %edx,%eax
  80297f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802985:	89 10                	mov    %edx,(%eax)
  802987:	8b 00                	mov    (%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	74 18                	je     8029a5 <initialize_MemBlocksList+0x88>
  80298d:	a1 48 51 80 00       	mov    0x805148,%eax
  802992:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802998:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80299b:	c1 e1 04             	shl    $0x4,%ecx
  80299e:	01 ca                	add    %ecx,%edx
  8029a0:	89 50 04             	mov    %edx,0x4(%eax)
  8029a3:	eb 12                	jmp    8029b7 <initialize_MemBlocksList+0x9a>
  8029a5:	a1 50 50 80 00       	mov    0x805050,%eax
  8029aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ad:	c1 e2 04             	shl    $0x4,%edx
  8029b0:	01 d0                	add    %edx,%eax
  8029b2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029b7:	a1 50 50 80 00       	mov    0x805050,%eax
  8029bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029bf:	c1 e2 04             	shl    $0x4,%edx
  8029c2:	01 d0                	add    %edx,%eax
  8029c4:	a3 48 51 80 00       	mov    %eax,0x805148
  8029c9:	a1 50 50 80 00       	mov    0x805050,%eax
  8029ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d1:	c1 e2 04             	shl    $0x4,%edx
  8029d4:	01 d0                	add    %edx,%eax
  8029d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029dd:	a1 54 51 80 00       	mov    0x805154,%eax
  8029e2:	40                   	inc    %eax
  8029e3:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8029e8:	ff 45 f4             	incl   -0xc(%ebp)
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f1:	0f 82 56 ff ff ff    	jb     80294d <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8029f7:	90                   	nop
  8029f8:	c9                   	leave  
  8029f9:	c3                   	ret    

008029fa <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8029fa:	55                   	push   %ebp
  8029fb:	89 e5                	mov    %esp,%ebp
  8029fd:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a08:	eb 19                	jmp    802a23 <find_block+0x29>
	{
		if(element->sva == va){
  802a0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a0d:	8b 40 08             	mov    0x8(%eax),%eax
  802a10:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a13:	75 05                	jne    802a1a <find_block+0x20>
			 		return element;
  802a15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a18:	eb 36                	jmp    802a50 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	8b 40 08             	mov    0x8(%eax),%eax
  802a20:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a23:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a27:	74 07                	je     802a30 <find_block+0x36>
  802a29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a2c:	8b 00                	mov    (%eax),%eax
  802a2e:	eb 05                	jmp    802a35 <find_block+0x3b>
  802a30:	b8 00 00 00 00       	mov    $0x0,%eax
  802a35:	8b 55 08             	mov    0x8(%ebp),%edx
  802a38:	89 42 08             	mov    %eax,0x8(%edx)
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	8b 40 08             	mov    0x8(%eax),%eax
  802a41:	85 c0                	test   %eax,%eax
  802a43:	75 c5                	jne    802a0a <find_block+0x10>
  802a45:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a49:	75 bf                	jne    802a0a <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802a4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a50:	c9                   	leave  
  802a51:	c3                   	ret    

00802a52 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802a52:	55                   	push   %ebp
  802a53:	89 e5                	mov    %esp,%ebp
  802a55:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802a58:	a1 44 50 80 00       	mov    0x805044,%eax
  802a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802a60:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a65:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802a68:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a6c:	74 0a                	je     802a78 <insert_sorted_allocList+0x26>
  802a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a71:	8b 40 08             	mov    0x8(%eax),%eax
  802a74:	85 c0                	test   %eax,%eax
  802a76:	75 65                	jne    802add <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802a78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a7c:	75 14                	jne    802a92 <insert_sorted_allocList+0x40>
  802a7e:	83 ec 04             	sub    $0x4,%esp
  802a81:	68 a8 44 80 00       	push   $0x8044a8
  802a86:	6a 6e                	push   $0x6e
  802a88:	68 cb 44 80 00       	push   $0x8044cb
  802a8d:	e8 10 df ff ff       	call   8009a2 <_panic>
  802a92:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a98:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9b:	89 10                	mov    %edx,(%eax)
  802a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa0:	8b 00                	mov    (%eax),%eax
  802aa2:	85 c0                	test   %eax,%eax
  802aa4:	74 0d                	je     802ab3 <insert_sorted_allocList+0x61>
  802aa6:	a1 40 50 80 00       	mov    0x805040,%eax
  802aab:	8b 55 08             	mov    0x8(%ebp),%edx
  802aae:	89 50 04             	mov    %edx,0x4(%eax)
  802ab1:	eb 08                	jmp    802abb <insert_sorted_allocList+0x69>
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	a3 44 50 80 00       	mov    %eax,0x805044
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	a3 40 50 80 00       	mov    %eax,0x805040
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ad2:	40                   	inc    %eax
  802ad3:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802ad8:	e9 cf 01 00 00       	jmp    802cac <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae0:	8b 50 08             	mov    0x8(%eax),%edx
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	8b 40 08             	mov    0x8(%eax),%eax
  802ae9:	39 c2                	cmp    %eax,%edx
  802aeb:	73 65                	jae    802b52 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802aed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802af1:	75 14                	jne    802b07 <insert_sorted_allocList+0xb5>
  802af3:	83 ec 04             	sub    $0x4,%esp
  802af6:	68 e4 44 80 00       	push   $0x8044e4
  802afb:	6a 72                	push   $0x72
  802afd:	68 cb 44 80 00       	push   $0x8044cb
  802b02:	e8 9b de ff ff       	call   8009a2 <_panic>
  802b07:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b10:	89 50 04             	mov    %edx,0x4(%eax)
  802b13:	8b 45 08             	mov    0x8(%ebp),%eax
  802b16:	8b 40 04             	mov    0x4(%eax),%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	74 0c                	je     802b29 <insert_sorted_allocList+0xd7>
  802b1d:	a1 44 50 80 00       	mov    0x805044,%eax
  802b22:	8b 55 08             	mov    0x8(%ebp),%edx
  802b25:	89 10                	mov    %edx,(%eax)
  802b27:	eb 08                	jmp    802b31 <insert_sorted_allocList+0xdf>
  802b29:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2c:	a3 40 50 80 00       	mov    %eax,0x805040
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
  802b34:	a3 44 50 80 00       	mov    %eax,0x805044
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b42:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b47:	40                   	inc    %eax
  802b48:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802b4d:	e9 5a 01 00 00       	jmp    802cac <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b55:	8b 50 08             	mov    0x8(%eax),%edx
  802b58:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5b:	8b 40 08             	mov    0x8(%eax),%eax
  802b5e:	39 c2                	cmp    %eax,%edx
  802b60:	75 70                	jne    802bd2 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802b62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b66:	74 06                	je     802b6e <insert_sorted_allocList+0x11c>
  802b68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b6c:	75 14                	jne    802b82 <insert_sorted_allocList+0x130>
  802b6e:	83 ec 04             	sub    $0x4,%esp
  802b71:	68 08 45 80 00       	push   $0x804508
  802b76:	6a 75                	push   $0x75
  802b78:	68 cb 44 80 00       	push   $0x8044cb
  802b7d:	e8 20 de ff ff       	call   8009a2 <_panic>
  802b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b85:	8b 10                	mov    (%eax),%edx
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	89 10                	mov    %edx,(%eax)
  802b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8f:	8b 00                	mov    (%eax),%eax
  802b91:	85 c0                	test   %eax,%eax
  802b93:	74 0b                	je     802ba0 <insert_sorted_allocList+0x14e>
  802b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b98:	8b 00                	mov    (%eax),%eax
  802b9a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9d:	89 50 04             	mov    %edx,0x4(%eax)
  802ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba6:	89 10                	mov    %edx,(%eax)
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bae:	89 50 04             	mov    %edx,0x4(%eax)
  802bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb4:	8b 00                	mov    (%eax),%eax
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	75 08                	jne    802bc2 <insert_sorted_allocList+0x170>
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	a3 44 50 80 00       	mov    %eax,0x805044
  802bc2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bc7:	40                   	inc    %eax
  802bc8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802bcd:	e9 da 00 00 00       	jmp    802cac <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802bd2:	a1 40 50 80 00       	mov    0x805040,%eax
  802bd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bda:	e9 9d 00 00 00       	jmp    802c7c <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	8b 00                	mov    (%eax),%eax
  802be4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802be7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bea:	8b 50 08             	mov    0x8(%eax),%edx
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 40 08             	mov    0x8(%eax),%eax
  802bf3:	39 c2                	cmp    %eax,%edx
  802bf5:	76 7d                	jbe    802c74 <insert_sorted_allocList+0x222>
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	8b 50 08             	mov    0x8(%eax),%edx
  802bfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c00:	8b 40 08             	mov    0x8(%eax),%eax
  802c03:	39 c2                	cmp    %eax,%edx
  802c05:	73 6d                	jae    802c74 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802c07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0b:	74 06                	je     802c13 <insert_sorted_allocList+0x1c1>
  802c0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c11:	75 14                	jne    802c27 <insert_sorted_allocList+0x1d5>
  802c13:	83 ec 04             	sub    $0x4,%esp
  802c16:	68 08 45 80 00       	push   $0x804508
  802c1b:	6a 7c                	push   $0x7c
  802c1d:	68 cb 44 80 00       	push   $0x8044cb
  802c22:	e8 7b dd ff ff       	call   8009a2 <_panic>
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	8b 10                	mov    (%eax),%edx
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	89 10                	mov    %edx,(%eax)
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	85 c0                	test   %eax,%eax
  802c38:	74 0b                	je     802c45 <insert_sorted_allocList+0x1f3>
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	8b 00                	mov    (%eax),%eax
  802c3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c42:	89 50 04             	mov    %edx,0x4(%eax)
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4b:	89 10                	mov    %edx,(%eax)
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c53:	89 50 04             	mov    %edx,0x4(%eax)
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	8b 00                	mov    (%eax),%eax
  802c5b:	85 c0                	test   %eax,%eax
  802c5d:	75 08                	jne    802c67 <insert_sorted_allocList+0x215>
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	a3 44 50 80 00       	mov    %eax,0x805044
  802c67:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c6c:	40                   	inc    %eax
  802c6d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802c72:	eb 38                	jmp    802cac <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802c74:	a1 48 50 80 00       	mov    0x805048,%eax
  802c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c80:	74 07                	je     802c89 <insert_sorted_allocList+0x237>
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	8b 00                	mov    (%eax),%eax
  802c87:	eb 05                	jmp    802c8e <insert_sorted_allocList+0x23c>
  802c89:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8e:	a3 48 50 80 00       	mov    %eax,0x805048
  802c93:	a1 48 50 80 00       	mov    0x805048,%eax
  802c98:	85 c0                	test   %eax,%eax
  802c9a:	0f 85 3f ff ff ff    	jne    802bdf <insert_sorted_allocList+0x18d>
  802ca0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca4:	0f 85 35 ff ff ff    	jne    802bdf <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802caa:	eb 00                	jmp    802cac <insert_sorted_allocList+0x25a>
  802cac:	90                   	nop
  802cad:	c9                   	leave  
  802cae:	c3                   	ret    

00802caf <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802caf:	55                   	push   %ebp
  802cb0:	89 e5                	mov    %esp,%ebp
  802cb2:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802cb5:	a1 38 51 80 00       	mov    0x805138,%eax
  802cba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cbd:	e9 6b 02 00 00       	jmp    802f2d <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ccb:	0f 85 90 00 00 00    	jne    802d61 <alloc_block_FF+0xb2>
			  temp=element;
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802cd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cdb:	75 17                	jne    802cf4 <alloc_block_FF+0x45>
  802cdd:	83 ec 04             	sub    $0x4,%esp
  802ce0:	68 3c 45 80 00       	push   $0x80453c
  802ce5:	68 92 00 00 00       	push   $0x92
  802cea:	68 cb 44 80 00       	push   $0x8044cb
  802cef:	e8 ae dc ff ff       	call   8009a2 <_panic>
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf7:	8b 00                	mov    (%eax),%eax
  802cf9:	85 c0                	test   %eax,%eax
  802cfb:	74 10                	je     802d0d <alloc_block_FF+0x5e>
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	8b 00                	mov    (%eax),%eax
  802d02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d05:	8b 52 04             	mov    0x4(%edx),%edx
  802d08:	89 50 04             	mov    %edx,0x4(%eax)
  802d0b:	eb 0b                	jmp    802d18 <alloc_block_FF+0x69>
  802d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d10:	8b 40 04             	mov    0x4(%eax),%eax
  802d13:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	8b 40 04             	mov    0x4(%eax),%eax
  802d1e:	85 c0                	test   %eax,%eax
  802d20:	74 0f                	je     802d31 <alloc_block_FF+0x82>
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 40 04             	mov    0x4(%eax),%eax
  802d28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2b:	8b 12                	mov    (%edx),%edx
  802d2d:	89 10                	mov    %edx,(%eax)
  802d2f:	eb 0a                	jmp    802d3b <alloc_block_FF+0x8c>
  802d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d34:	8b 00                	mov    (%eax),%eax
  802d36:	a3 38 51 80 00       	mov    %eax,0x805138
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4e:	a1 44 51 80 00       	mov    0x805144,%eax
  802d53:	48                   	dec    %eax
  802d54:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802d59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5c:	e9 ff 01 00 00       	jmp    802f60 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 40 0c             	mov    0xc(%eax),%eax
  802d67:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d6a:	0f 86 b5 01 00 00    	jbe    802f25 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	8b 40 0c             	mov    0xc(%eax),%eax
  802d76:	2b 45 08             	sub    0x8(%ebp),%eax
  802d79:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802d7c:	a1 48 51 80 00       	mov    0x805148,%eax
  802d81:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802d84:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d88:	75 17                	jne    802da1 <alloc_block_FF+0xf2>
  802d8a:	83 ec 04             	sub    $0x4,%esp
  802d8d:	68 3c 45 80 00       	push   $0x80453c
  802d92:	68 99 00 00 00       	push   $0x99
  802d97:	68 cb 44 80 00       	push   $0x8044cb
  802d9c:	e8 01 dc ff ff       	call   8009a2 <_panic>
  802da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da4:	8b 00                	mov    (%eax),%eax
  802da6:	85 c0                	test   %eax,%eax
  802da8:	74 10                	je     802dba <alloc_block_FF+0x10b>
  802daa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802db2:	8b 52 04             	mov    0x4(%edx),%edx
  802db5:	89 50 04             	mov    %edx,0x4(%eax)
  802db8:	eb 0b                	jmp    802dc5 <alloc_block_FF+0x116>
  802dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbd:	8b 40 04             	mov    0x4(%eax),%eax
  802dc0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc8:	8b 40 04             	mov    0x4(%eax),%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	74 0f                	je     802dde <alloc_block_FF+0x12f>
  802dcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dd8:	8b 12                	mov    (%edx),%edx
  802dda:	89 10                	mov    %edx,(%eax)
  802ddc:	eb 0a                	jmp    802de8 <alloc_block_FF+0x139>
  802dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	a3 48 51 80 00       	mov    %eax,0x805148
  802de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802deb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfb:	a1 54 51 80 00       	mov    0x805154,%eax
  802e00:	48                   	dec    %eax
  802e01:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802e06:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e0a:	75 17                	jne    802e23 <alloc_block_FF+0x174>
  802e0c:	83 ec 04             	sub    $0x4,%esp
  802e0f:	68 e4 44 80 00       	push   $0x8044e4
  802e14:	68 9a 00 00 00       	push   $0x9a
  802e19:	68 cb 44 80 00       	push   $0x8044cb
  802e1e:	e8 7f db ff ff       	call   8009a2 <_panic>
  802e23:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2c:	89 50 04             	mov    %edx,0x4(%eax)
  802e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e32:	8b 40 04             	mov    0x4(%eax),%eax
  802e35:	85 c0                	test   %eax,%eax
  802e37:	74 0c                	je     802e45 <alloc_block_FF+0x196>
  802e39:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e3e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e41:	89 10                	mov    %edx,(%eax)
  802e43:	eb 08                	jmp    802e4d <alloc_block_FF+0x19e>
  802e45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e48:	a3 38 51 80 00       	mov    %eax,0x805138
  802e4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e50:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e5e:	a1 44 51 80 00       	mov    0x805144,%eax
  802e63:	40                   	inc    %eax
  802e64:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802e69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e6f:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	8b 50 08             	mov    0x8(%eax),%edx
  802e78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7b:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e84:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 50 08             	mov    0x8(%eax),%edx
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	01 c2                	add    %eax,%edx
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802e98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802e9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ea2:	75 17                	jne    802ebb <alloc_block_FF+0x20c>
  802ea4:	83 ec 04             	sub    $0x4,%esp
  802ea7:	68 3c 45 80 00       	push   $0x80453c
  802eac:	68 a2 00 00 00       	push   $0xa2
  802eb1:	68 cb 44 80 00       	push   $0x8044cb
  802eb6:	e8 e7 da ff ff       	call   8009a2 <_panic>
  802ebb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebe:	8b 00                	mov    (%eax),%eax
  802ec0:	85 c0                	test   %eax,%eax
  802ec2:	74 10                	je     802ed4 <alloc_block_FF+0x225>
  802ec4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec7:	8b 00                	mov    (%eax),%eax
  802ec9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ecc:	8b 52 04             	mov    0x4(%edx),%edx
  802ecf:	89 50 04             	mov    %edx,0x4(%eax)
  802ed2:	eb 0b                	jmp    802edf <alloc_block_FF+0x230>
  802ed4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed7:	8b 40 04             	mov    0x4(%eax),%eax
  802eda:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802edf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee2:	8b 40 04             	mov    0x4(%eax),%eax
  802ee5:	85 c0                	test   %eax,%eax
  802ee7:	74 0f                	je     802ef8 <alloc_block_FF+0x249>
  802ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eec:	8b 40 04             	mov    0x4(%eax),%eax
  802eef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ef2:	8b 12                	mov    (%edx),%edx
  802ef4:	89 10                	mov    %edx,(%eax)
  802ef6:	eb 0a                	jmp    802f02 <alloc_block_FF+0x253>
  802ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efb:	8b 00                	mov    (%eax),%eax
  802efd:	a3 38 51 80 00       	mov    %eax,0x805138
  802f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f15:	a1 44 51 80 00       	mov    0x805144,%eax
  802f1a:	48                   	dec    %eax
  802f1b:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802f20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f23:	eb 3b                	jmp    802f60 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802f25:	a1 40 51 80 00       	mov    0x805140,%eax
  802f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f31:	74 07                	je     802f3a <alloc_block_FF+0x28b>
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	eb 05                	jmp    802f3f <alloc_block_FF+0x290>
  802f3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3f:	a3 40 51 80 00       	mov    %eax,0x805140
  802f44:	a1 40 51 80 00       	mov    0x805140,%eax
  802f49:	85 c0                	test   %eax,%eax
  802f4b:	0f 85 71 fd ff ff    	jne    802cc2 <alloc_block_FF+0x13>
  802f51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f55:	0f 85 67 fd ff ff    	jne    802cc2 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802f5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f60:	c9                   	leave  
  802f61:	c3                   	ret    

00802f62 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802f62:	55                   	push   %ebp
  802f63:	89 e5                	mov    %esp,%ebp
  802f65:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802f68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802f6f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802f76:	a1 38 51 80 00       	mov    0x805138,%eax
  802f7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802f7e:	e9 d3 00 00 00       	jmp    803056 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802f83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f86:	8b 40 0c             	mov    0xc(%eax),%eax
  802f89:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f8c:	0f 85 90 00 00 00    	jne    803022 <alloc_block_BF+0xc0>
	   temp = element;
  802f92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f95:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802f98:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f9c:	75 17                	jne    802fb5 <alloc_block_BF+0x53>
  802f9e:	83 ec 04             	sub    $0x4,%esp
  802fa1:	68 3c 45 80 00       	push   $0x80453c
  802fa6:	68 bd 00 00 00       	push   $0xbd
  802fab:	68 cb 44 80 00       	push   $0x8044cb
  802fb0:	e8 ed d9 ff ff       	call   8009a2 <_panic>
  802fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb8:	8b 00                	mov    (%eax),%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	74 10                	je     802fce <alloc_block_BF+0x6c>
  802fbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fc6:	8b 52 04             	mov    0x4(%edx),%edx
  802fc9:	89 50 04             	mov    %edx,0x4(%eax)
  802fcc:	eb 0b                	jmp    802fd9 <alloc_block_BF+0x77>
  802fce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd1:	8b 40 04             	mov    0x4(%eax),%eax
  802fd4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdc:	8b 40 04             	mov    0x4(%eax),%eax
  802fdf:	85 c0                	test   %eax,%eax
  802fe1:	74 0f                	je     802ff2 <alloc_block_BF+0x90>
  802fe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe6:	8b 40 04             	mov    0x4(%eax),%eax
  802fe9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fec:	8b 12                	mov    (%edx),%edx
  802fee:	89 10                	mov    %edx,(%eax)
  802ff0:	eb 0a                	jmp    802ffc <alloc_block_BF+0x9a>
  802ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff5:	8b 00                	mov    (%eax),%eax
  802ff7:	a3 38 51 80 00       	mov    %eax,0x805138
  802ffc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803005:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803008:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300f:	a1 44 51 80 00       	mov    0x805144,%eax
  803014:	48                   	dec    %eax
  803015:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  80301a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80301d:	e9 41 01 00 00       	jmp    803163 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  803022:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803025:	8b 40 0c             	mov    0xc(%eax),%eax
  803028:	3b 45 08             	cmp    0x8(%ebp),%eax
  80302b:	76 21                	jbe    80304e <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  80302d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803030:	8b 40 0c             	mov    0xc(%eax),%eax
  803033:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803036:	73 16                	jae    80304e <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  803038:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303b:	8b 40 0c             	mov    0xc(%eax),%eax
  80303e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  803041:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803044:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  803047:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80304e:	a1 40 51 80 00       	mov    0x805140,%eax
  803053:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803056:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80305a:	74 07                	je     803063 <alloc_block_BF+0x101>
  80305c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305f:	8b 00                	mov    (%eax),%eax
  803061:	eb 05                	jmp    803068 <alloc_block_BF+0x106>
  803063:	b8 00 00 00 00       	mov    $0x0,%eax
  803068:	a3 40 51 80 00       	mov    %eax,0x805140
  80306d:	a1 40 51 80 00       	mov    0x805140,%eax
  803072:	85 c0                	test   %eax,%eax
  803074:	0f 85 09 ff ff ff    	jne    802f83 <alloc_block_BF+0x21>
  80307a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80307e:	0f 85 ff fe ff ff    	jne    802f83 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  803084:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  803088:	0f 85 d0 00 00 00    	jne    80315e <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80308e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803091:	8b 40 0c             	mov    0xc(%eax),%eax
  803094:	2b 45 08             	sub    0x8(%ebp),%eax
  803097:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  80309a:	a1 48 51 80 00       	mov    0x805148,%eax
  80309f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8030a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030a6:	75 17                	jne    8030bf <alloc_block_BF+0x15d>
  8030a8:	83 ec 04             	sub    $0x4,%esp
  8030ab:	68 3c 45 80 00       	push   $0x80453c
  8030b0:	68 d1 00 00 00       	push   $0xd1
  8030b5:	68 cb 44 80 00       	push   $0x8044cb
  8030ba:	e8 e3 d8 ff ff       	call   8009a2 <_panic>
  8030bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c2:	8b 00                	mov    (%eax),%eax
  8030c4:	85 c0                	test   %eax,%eax
  8030c6:	74 10                	je     8030d8 <alloc_block_BF+0x176>
  8030c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030cb:	8b 00                	mov    (%eax),%eax
  8030cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030d0:	8b 52 04             	mov    0x4(%edx),%edx
  8030d3:	89 50 04             	mov    %edx,0x4(%eax)
  8030d6:	eb 0b                	jmp    8030e3 <alloc_block_BF+0x181>
  8030d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030db:	8b 40 04             	mov    0x4(%eax),%eax
  8030de:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e6:	8b 40 04             	mov    0x4(%eax),%eax
  8030e9:	85 c0                	test   %eax,%eax
  8030eb:	74 0f                	je     8030fc <alloc_block_BF+0x19a>
  8030ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f0:	8b 40 04             	mov    0x4(%eax),%eax
  8030f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030f6:	8b 12                	mov    (%edx),%edx
  8030f8:	89 10                	mov    %edx,(%eax)
  8030fa:	eb 0a                	jmp    803106 <alloc_block_BF+0x1a4>
  8030fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ff:	8b 00                	mov    (%eax),%eax
  803101:	a3 48 51 80 00       	mov    %eax,0x805148
  803106:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803109:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80310f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803112:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803119:	a1 54 51 80 00       	mov    0x805154,%eax
  80311e:	48                   	dec    %eax
  80311f:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  803124:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803127:	8b 55 08             	mov    0x8(%ebp),%edx
  80312a:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  80312d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803130:	8b 50 08             	mov    0x8(%eax),%edx
  803133:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803136:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  803139:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80313f:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  803142:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803145:	8b 50 08             	mov    0x8(%eax),%edx
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	01 c2                	add    %eax,%edx
  80314d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803150:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  803153:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803156:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  803159:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315c:	eb 05                	jmp    803163 <alloc_block_BF+0x201>
	 }
	 return NULL;
  80315e:	b8 00 00 00 00       	mov    $0x0,%eax


}
  803163:	c9                   	leave  
  803164:	c3                   	ret    

00803165 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803165:	55                   	push   %ebp
  803166:	89 e5                	mov    %esp,%ebp
  803168:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80316b:	83 ec 04             	sub    $0x4,%esp
  80316e:	68 5c 45 80 00       	push   $0x80455c
  803173:	68 e8 00 00 00       	push   $0xe8
  803178:	68 cb 44 80 00       	push   $0x8044cb
  80317d:	e8 20 d8 ff ff       	call   8009a2 <_panic>

00803182 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803182:	55                   	push   %ebp
  803183:	89 e5                	mov    %esp,%ebp
  803185:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  803188:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80318d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  803190:	a1 38 51 80 00       	mov    0x805138,%eax
  803195:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  803198:	a1 44 51 80 00       	mov    0x805144,%eax
  80319d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8031a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031a4:	75 68                	jne    80320e <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8031a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031aa:	75 17                	jne    8031c3 <insert_sorted_with_merge_freeList+0x41>
  8031ac:	83 ec 04             	sub    $0x4,%esp
  8031af:	68 a8 44 80 00       	push   $0x8044a8
  8031b4:	68 36 01 00 00       	push   $0x136
  8031b9:	68 cb 44 80 00       	push   $0x8044cb
  8031be:	e8 df d7 ff ff       	call   8009a2 <_panic>
  8031c3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cc:	89 10                	mov    %edx,(%eax)
  8031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d1:	8b 00                	mov    (%eax),%eax
  8031d3:	85 c0                	test   %eax,%eax
  8031d5:	74 0d                	je     8031e4 <insert_sorted_with_merge_freeList+0x62>
  8031d7:	a1 38 51 80 00       	mov    0x805138,%eax
  8031dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8031df:	89 50 04             	mov    %edx,0x4(%eax)
  8031e2:	eb 08                	jmp    8031ec <insert_sorted_with_merge_freeList+0x6a>
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ef:	a3 38 51 80 00       	mov    %eax,0x805138
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fe:	a1 44 51 80 00       	mov    0x805144,%eax
  803203:	40                   	inc    %eax
  803204:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803209:	e9 ba 06 00 00       	jmp    8038c8 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  80320e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803211:	8b 50 08             	mov    0x8(%eax),%edx
  803214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803217:	8b 40 0c             	mov    0xc(%eax),%eax
  80321a:	01 c2                	add    %eax,%edx
  80321c:	8b 45 08             	mov    0x8(%ebp),%eax
  80321f:	8b 40 08             	mov    0x8(%eax),%eax
  803222:	39 c2                	cmp    %eax,%edx
  803224:	73 68                	jae    80328e <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803226:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80322a:	75 17                	jne    803243 <insert_sorted_with_merge_freeList+0xc1>
  80322c:	83 ec 04             	sub    $0x4,%esp
  80322f:	68 e4 44 80 00       	push   $0x8044e4
  803234:	68 3a 01 00 00       	push   $0x13a
  803239:	68 cb 44 80 00       	push   $0x8044cb
  80323e:	e8 5f d7 ff ff       	call   8009a2 <_panic>
  803243:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	89 50 04             	mov    %edx,0x4(%eax)
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	8b 40 04             	mov    0x4(%eax),%eax
  803255:	85 c0                	test   %eax,%eax
  803257:	74 0c                	je     803265 <insert_sorted_with_merge_freeList+0xe3>
  803259:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80325e:	8b 55 08             	mov    0x8(%ebp),%edx
  803261:	89 10                	mov    %edx,(%eax)
  803263:	eb 08                	jmp    80326d <insert_sorted_with_merge_freeList+0xeb>
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	a3 38 51 80 00       	mov    %eax,0x805138
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327e:	a1 44 51 80 00       	mov    0x805144,%eax
  803283:	40                   	inc    %eax
  803284:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803289:	e9 3a 06 00 00       	jmp    8038c8 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  80328e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803291:	8b 50 08             	mov    0x8(%eax),%edx
  803294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803297:	8b 40 0c             	mov    0xc(%eax),%eax
  80329a:	01 c2                	add    %eax,%edx
  80329c:	8b 45 08             	mov    0x8(%ebp),%eax
  80329f:	8b 40 08             	mov    0x8(%eax),%eax
  8032a2:	39 c2                	cmp    %eax,%edx
  8032a4:	0f 85 90 00 00 00    	jne    80333a <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8032aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ad:	8b 50 0c             	mov    0xc(%eax),%edx
  8032b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b6:	01 c2                	add    %eax,%edx
  8032b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032bb:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8032be:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d6:	75 17                	jne    8032ef <insert_sorted_with_merge_freeList+0x16d>
  8032d8:	83 ec 04             	sub    $0x4,%esp
  8032db:	68 a8 44 80 00       	push   $0x8044a8
  8032e0:	68 41 01 00 00       	push   $0x141
  8032e5:	68 cb 44 80 00       	push   $0x8044cb
  8032ea:	e8 b3 d6 ff ff       	call   8009a2 <_panic>
  8032ef:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	89 10                	mov    %edx,(%eax)
  8032fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fd:	8b 00                	mov    (%eax),%eax
  8032ff:	85 c0                	test   %eax,%eax
  803301:	74 0d                	je     803310 <insert_sorted_with_merge_freeList+0x18e>
  803303:	a1 48 51 80 00       	mov    0x805148,%eax
  803308:	8b 55 08             	mov    0x8(%ebp),%edx
  80330b:	89 50 04             	mov    %edx,0x4(%eax)
  80330e:	eb 08                	jmp    803318 <insert_sorted_with_merge_freeList+0x196>
  803310:	8b 45 08             	mov    0x8(%ebp),%eax
  803313:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	a3 48 51 80 00       	mov    %eax,0x805148
  803320:	8b 45 08             	mov    0x8(%ebp),%eax
  803323:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80332a:	a1 54 51 80 00       	mov    0x805154,%eax
  80332f:	40                   	inc    %eax
  803330:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803335:	e9 8e 05 00 00       	jmp    8038c8 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  80333a:	8b 45 08             	mov    0x8(%ebp),%eax
  80333d:	8b 50 08             	mov    0x8(%eax),%edx
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	8b 40 0c             	mov    0xc(%eax),%eax
  803346:	01 c2                	add    %eax,%edx
  803348:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334b:	8b 40 08             	mov    0x8(%eax),%eax
  80334e:	39 c2                	cmp    %eax,%edx
  803350:	73 68                	jae    8033ba <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803352:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803356:	75 17                	jne    80336f <insert_sorted_with_merge_freeList+0x1ed>
  803358:	83 ec 04             	sub    $0x4,%esp
  80335b:	68 a8 44 80 00       	push   $0x8044a8
  803360:	68 45 01 00 00       	push   $0x145
  803365:	68 cb 44 80 00       	push   $0x8044cb
  80336a:	e8 33 d6 ff ff       	call   8009a2 <_panic>
  80336f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	89 10                	mov    %edx,(%eax)
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	8b 00                	mov    (%eax),%eax
  80337f:	85 c0                	test   %eax,%eax
  803381:	74 0d                	je     803390 <insert_sorted_with_merge_freeList+0x20e>
  803383:	a1 38 51 80 00       	mov    0x805138,%eax
  803388:	8b 55 08             	mov    0x8(%ebp),%edx
  80338b:	89 50 04             	mov    %edx,0x4(%eax)
  80338e:	eb 08                	jmp    803398 <insert_sorted_with_merge_freeList+0x216>
  803390:	8b 45 08             	mov    0x8(%ebp),%eax
  803393:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803398:	8b 45 08             	mov    0x8(%ebp),%eax
  80339b:	a3 38 51 80 00       	mov    %eax,0x805138
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033aa:	a1 44 51 80 00       	mov    0x805144,%eax
  8033af:	40                   	inc    %eax
  8033b0:	a3 44 51 80 00       	mov    %eax,0x805144





}
  8033b5:	e9 0e 05 00 00       	jmp    8038c8 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  8033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bd:	8b 50 08             	mov    0x8(%eax),%edx
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c6:	01 c2                	add    %eax,%edx
  8033c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033cb:	8b 40 08             	mov    0x8(%eax),%eax
  8033ce:	39 c2                	cmp    %eax,%edx
  8033d0:	0f 85 9c 00 00 00    	jne    803472 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  8033d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d9:	8b 50 0c             	mov    0xc(%eax),%edx
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e2:	01 c2                	add    %eax,%edx
  8033e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e7:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  8033ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ed:	8b 50 08             	mov    0x8(%eax),%edx
  8033f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f3:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  8033f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  803400:	8b 45 08             	mov    0x8(%ebp),%eax
  803403:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80340a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80340e:	75 17                	jne    803427 <insert_sorted_with_merge_freeList+0x2a5>
  803410:	83 ec 04             	sub    $0x4,%esp
  803413:	68 a8 44 80 00       	push   $0x8044a8
  803418:	68 4d 01 00 00       	push   $0x14d
  80341d:	68 cb 44 80 00       	push   $0x8044cb
  803422:	e8 7b d5 ff ff       	call   8009a2 <_panic>
  803427:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	89 10                	mov    %edx,(%eax)
  803432:	8b 45 08             	mov    0x8(%ebp),%eax
  803435:	8b 00                	mov    (%eax),%eax
  803437:	85 c0                	test   %eax,%eax
  803439:	74 0d                	je     803448 <insert_sorted_with_merge_freeList+0x2c6>
  80343b:	a1 48 51 80 00       	mov    0x805148,%eax
  803440:	8b 55 08             	mov    0x8(%ebp),%edx
  803443:	89 50 04             	mov    %edx,0x4(%eax)
  803446:	eb 08                	jmp    803450 <insert_sorted_with_merge_freeList+0x2ce>
  803448:	8b 45 08             	mov    0x8(%ebp),%eax
  80344b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803450:	8b 45 08             	mov    0x8(%ebp),%eax
  803453:	a3 48 51 80 00       	mov    %eax,0x805148
  803458:	8b 45 08             	mov    0x8(%ebp),%eax
  80345b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803462:	a1 54 51 80 00       	mov    0x805154,%eax
  803467:	40                   	inc    %eax
  803468:	a3 54 51 80 00       	mov    %eax,0x805154





}
  80346d:	e9 56 04 00 00       	jmp    8038c8 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803472:	a1 38 51 80 00       	mov    0x805138,%eax
  803477:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80347a:	e9 19 04 00 00       	jmp    803898 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  80347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803482:	8b 00                	mov    (%eax),%eax
  803484:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348a:	8b 50 08             	mov    0x8(%eax),%edx
  80348d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803490:	8b 40 0c             	mov    0xc(%eax),%eax
  803493:	01 c2                	add    %eax,%edx
  803495:	8b 45 08             	mov    0x8(%ebp),%eax
  803498:	8b 40 08             	mov    0x8(%eax),%eax
  80349b:	39 c2                	cmp    %eax,%edx
  80349d:	0f 85 ad 01 00 00    	jne    803650 <insert_sorted_with_merge_freeList+0x4ce>
  8034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a6:	8b 50 08             	mov    0x8(%eax),%edx
  8034a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8034af:	01 c2                	add    %eax,%edx
  8034b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b4:	8b 40 08             	mov    0x8(%eax),%eax
  8034b7:	39 c2                	cmp    %eax,%edx
  8034b9:	0f 85 91 01 00 00    	jne    803650 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  8034bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c2:	8b 50 0c             	mov    0xc(%eax),%edx
  8034c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c8:	8b 48 0c             	mov    0xc(%eax),%ecx
  8034cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d1:	01 c8                	add    %ecx,%eax
  8034d3:	01 c2                	add    %eax,%edx
  8034d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d8:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  8034db:	8b 45 08             	mov    0x8(%ebp),%eax
  8034de:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8034e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  8034ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  8034f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  803503:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803507:	75 17                	jne    803520 <insert_sorted_with_merge_freeList+0x39e>
  803509:	83 ec 04             	sub    $0x4,%esp
  80350c:	68 3c 45 80 00       	push   $0x80453c
  803511:	68 5b 01 00 00       	push   $0x15b
  803516:	68 cb 44 80 00       	push   $0x8044cb
  80351b:	e8 82 d4 ff ff       	call   8009a2 <_panic>
  803520:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803523:	8b 00                	mov    (%eax),%eax
  803525:	85 c0                	test   %eax,%eax
  803527:	74 10                	je     803539 <insert_sorted_with_merge_freeList+0x3b7>
  803529:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80352c:	8b 00                	mov    (%eax),%eax
  80352e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803531:	8b 52 04             	mov    0x4(%edx),%edx
  803534:	89 50 04             	mov    %edx,0x4(%eax)
  803537:	eb 0b                	jmp    803544 <insert_sorted_with_merge_freeList+0x3c2>
  803539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80353c:	8b 40 04             	mov    0x4(%eax),%eax
  80353f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803547:	8b 40 04             	mov    0x4(%eax),%eax
  80354a:	85 c0                	test   %eax,%eax
  80354c:	74 0f                	je     80355d <insert_sorted_with_merge_freeList+0x3db>
  80354e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803551:	8b 40 04             	mov    0x4(%eax),%eax
  803554:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803557:	8b 12                	mov    (%edx),%edx
  803559:	89 10                	mov    %edx,(%eax)
  80355b:	eb 0a                	jmp    803567 <insert_sorted_with_merge_freeList+0x3e5>
  80355d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803560:	8b 00                	mov    (%eax),%eax
  803562:	a3 38 51 80 00       	mov    %eax,0x805138
  803567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80356a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803570:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803573:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80357a:	a1 44 51 80 00       	mov    0x805144,%eax
  80357f:	48                   	dec    %eax
  803580:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803585:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803589:	75 17                	jne    8035a2 <insert_sorted_with_merge_freeList+0x420>
  80358b:	83 ec 04             	sub    $0x4,%esp
  80358e:	68 a8 44 80 00       	push   $0x8044a8
  803593:	68 5c 01 00 00       	push   $0x15c
  803598:	68 cb 44 80 00       	push   $0x8044cb
  80359d:	e8 00 d4 ff ff       	call   8009a2 <_panic>
  8035a2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ab:	89 10                	mov    %edx,(%eax)
  8035ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b0:	8b 00                	mov    (%eax),%eax
  8035b2:	85 c0                	test   %eax,%eax
  8035b4:	74 0d                	je     8035c3 <insert_sorted_with_merge_freeList+0x441>
  8035b6:	a1 48 51 80 00       	mov    0x805148,%eax
  8035bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8035be:	89 50 04             	mov    %edx,0x4(%eax)
  8035c1:	eb 08                	jmp    8035cb <insert_sorted_with_merge_freeList+0x449>
  8035c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ce:	a3 48 51 80 00       	mov    %eax,0x805148
  8035d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035dd:	a1 54 51 80 00       	mov    0x805154,%eax
  8035e2:	40                   	inc    %eax
  8035e3:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  8035e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035ec:	75 17                	jne    803605 <insert_sorted_with_merge_freeList+0x483>
  8035ee:	83 ec 04             	sub    $0x4,%esp
  8035f1:	68 a8 44 80 00       	push   $0x8044a8
  8035f6:	68 5d 01 00 00       	push   $0x15d
  8035fb:	68 cb 44 80 00       	push   $0x8044cb
  803600:	e8 9d d3 ff ff       	call   8009a2 <_panic>
  803605:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80360b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360e:	89 10                	mov    %edx,(%eax)
  803610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803613:	8b 00                	mov    (%eax),%eax
  803615:	85 c0                	test   %eax,%eax
  803617:	74 0d                	je     803626 <insert_sorted_with_merge_freeList+0x4a4>
  803619:	a1 48 51 80 00       	mov    0x805148,%eax
  80361e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803621:	89 50 04             	mov    %edx,0x4(%eax)
  803624:	eb 08                	jmp    80362e <insert_sorted_with_merge_freeList+0x4ac>
  803626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803629:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80362e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803631:	a3 48 51 80 00       	mov    %eax,0x805148
  803636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803639:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803640:	a1 54 51 80 00       	mov    0x805154,%eax
  803645:	40                   	inc    %eax
  803646:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80364b:	e9 78 02 00 00       	jmp    8038c8 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803653:	8b 50 08             	mov    0x8(%eax),%edx
  803656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803659:	8b 40 0c             	mov    0xc(%eax),%eax
  80365c:	01 c2                	add    %eax,%edx
  80365e:	8b 45 08             	mov    0x8(%ebp),%eax
  803661:	8b 40 08             	mov    0x8(%eax),%eax
  803664:	39 c2                	cmp    %eax,%edx
  803666:	0f 83 b8 00 00 00    	jae    803724 <insert_sorted_with_merge_freeList+0x5a2>
  80366c:	8b 45 08             	mov    0x8(%ebp),%eax
  80366f:	8b 50 08             	mov    0x8(%eax),%edx
  803672:	8b 45 08             	mov    0x8(%ebp),%eax
  803675:	8b 40 0c             	mov    0xc(%eax),%eax
  803678:	01 c2                	add    %eax,%edx
  80367a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367d:	8b 40 08             	mov    0x8(%eax),%eax
  803680:	39 c2                	cmp    %eax,%edx
  803682:	0f 85 9c 00 00 00    	jne    803724 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  803688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368b:	8b 50 0c             	mov    0xc(%eax),%edx
  80368e:	8b 45 08             	mov    0x8(%ebp),%eax
  803691:	8b 40 0c             	mov    0xc(%eax),%eax
  803694:	01 c2                	add    %eax,%edx
  803696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803699:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  80369c:	8b 45 08             	mov    0x8(%ebp),%eax
  80369f:	8b 50 08             	mov    0x8(%eax),%edx
  8036a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036a5:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  8036a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8036bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036c0:	75 17                	jne    8036d9 <insert_sorted_with_merge_freeList+0x557>
  8036c2:	83 ec 04             	sub    $0x4,%esp
  8036c5:	68 a8 44 80 00       	push   $0x8044a8
  8036ca:	68 67 01 00 00       	push   $0x167
  8036cf:	68 cb 44 80 00       	push   $0x8044cb
  8036d4:	e8 c9 d2 ff ff       	call   8009a2 <_panic>
  8036d9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036df:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e2:	89 10                	mov    %edx,(%eax)
  8036e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e7:	8b 00                	mov    (%eax),%eax
  8036e9:	85 c0                	test   %eax,%eax
  8036eb:	74 0d                	je     8036fa <insert_sorted_with_merge_freeList+0x578>
  8036ed:	a1 48 51 80 00       	mov    0x805148,%eax
  8036f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f5:	89 50 04             	mov    %edx,0x4(%eax)
  8036f8:	eb 08                	jmp    803702 <insert_sorted_with_merge_freeList+0x580>
  8036fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803702:	8b 45 08             	mov    0x8(%ebp),%eax
  803705:	a3 48 51 80 00       	mov    %eax,0x805148
  80370a:	8b 45 08             	mov    0x8(%ebp),%eax
  80370d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803714:	a1 54 51 80 00       	mov    0x805154,%eax
  803719:	40                   	inc    %eax
  80371a:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80371f:	e9 a4 01 00 00       	jmp    8038c8 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803727:	8b 50 08             	mov    0x8(%eax),%edx
  80372a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372d:	8b 40 0c             	mov    0xc(%eax),%eax
  803730:	01 c2                	add    %eax,%edx
  803732:	8b 45 08             	mov    0x8(%ebp),%eax
  803735:	8b 40 08             	mov    0x8(%eax),%eax
  803738:	39 c2                	cmp    %eax,%edx
  80373a:	0f 85 ac 00 00 00    	jne    8037ec <insert_sorted_with_merge_freeList+0x66a>
  803740:	8b 45 08             	mov    0x8(%ebp),%eax
  803743:	8b 50 08             	mov    0x8(%eax),%edx
  803746:	8b 45 08             	mov    0x8(%ebp),%eax
  803749:	8b 40 0c             	mov    0xc(%eax),%eax
  80374c:	01 c2                	add    %eax,%edx
  80374e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803751:	8b 40 08             	mov    0x8(%eax),%eax
  803754:	39 c2                	cmp    %eax,%edx
  803756:	0f 83 90 00 00 00    	jae    8037ec <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  80375c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375f:	8b 50 0c             	mov    0xc(%eax),%edx
  803762:	8b 45 08             	mov    0x8(%ebp),%eax
  803765:	8b 40 0c             	mov    0xc(%eax),%eax
  803768:	01 c2                	add    %eax,%edx
  80376a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376d:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  803770:	8b 45 08             	mov    0x8(%ebp),%eax
  803773:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803784:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803788:	75 17                	jne    8037a1 <insert_sorted_with_merge_freeList+0x61f>
  80378a:	83 ec 04             	sub    $0x4,%esp
  80378d:	68 a8 44 80 00       	push   $0x8044a8
  803792:	68 70 01 00 00       	push   $0x170
  803797:	68 cb 44 80 00       	push   $0x8044cb
  80379c:	e8 01 d2 ff ff       	call   8009a2 <_panic>
  8037a1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037aa:	89 10                	mov    %edx,(%eax)
  8037ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8037af:	8b 00                	mov    (%eax),%eax
  8037b1:	85 c0                	test   %eax,%eax
  8037b3:	74 0d                	je     8037c2 <insert_sorted_with_merge_freeList+0x640>
  8037b5:	a1 48 51 80 00       	mov    0x805148,%eax
  8037ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8037bd:	89 50 04             	mov    %edx,0x4(%eax)
  8037c0:	eb 08                	jmp    8037ca <insert_sorted_with_merge_freeList+0x648>
  8037c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cd:	a3 48 51 80 00       	mov    %eax,0x805148
  8037d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037dc:	a1 54 51 80 00       	mov    0x805154,%eax
  8037e1:	40                   	inc    %eax
  8037e2:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  8037e7:	e9 dc 00 00 00       	jmp    8038c8 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8037ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ef:	8b 50 08             	mov    0x8(%eax),%edx
  8037f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f8:	01 c2                	add    %eax,%edx
  8037fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fd:	8b 40 08             	mov    0x8(%eax),%eax
  803800:	39 c2                	cmp    %eax,%edx
  803802:	0f 83 88 00 00 00    	jae    803890 <insert_sorted_with_merge_freeList+0x70e>
  803808:	8b 45 08             	mov    0x8(%ebp),%eax
  80380b:	8b 50 08             	mov    0x8(%eax),%edx
  80380e:	8b 45 08             	mov    0x8(%ebp),%eax
  803811:	8b 40 0c             	mov    0xc(%eax),%eax
  803814:	01 c2                	add    %eax,%edx
  803816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803819:	8b 40 08             	mov    0x8(%eax),%eax
  80381c:	39 c2                	cmp    %eax,%edx
  80381e:	73 70                	jae    803890 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803820:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803824:	74 06                	je     80382c <insert_sorted_with_merge_freeList+0x6aa>
  803826:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80382a:	75 17                	jne    803843 <insert_sorted_with_merge_freeList+0x6c1>
  80382c:	83 ec 04             	sub    $0x4,%esp
  80382f:	68 08 45 80 00       	push   $0x804508
  803834:	68 75 01 00 00       	push   $0x175
  803839:	68 cb 44 80 00       	push   $0x8044cb
  80383e:	e8 5f d1 ff ff       	call   8009a2 <_panic>
  803843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803846:	8b 10                	mov    (%eax),%edx
  803848:	8b 45 08             	mov    0x8(%ebp),%eax
  80384b:	89 10                	mov    %edx,(%eax)
  80384d:	8b 45 08             	mov    0x8(%ebp),%eax
  803850:	8b 00                	mov    (%eax),%eax
  803852:	85 c0                	test   %eax,%eax
  803854:	74 0b                	je     803861 <insert_sorted_with_merge_freeList+0x6df>
  803856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803859:	8b 00                	mov    (%eax),%eax
  80385b:	8b 55 08             	mov    0x8(%ebp),%edx
  80385e:	89 50 04             	mov    %edx,0x4(%eax)
  803861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803864:	8b 55 08             	mov    0x8(%ebp),%edx
  803867:	89 10                	mov    %edx,(%eax)
  803869:	8b 45 08             	mov    0x8(%ebp),%eax
  80386c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80386f:	89 50 04             	mov    %edx,0x4(%eax)
  803872:	8b 45 08             	mov    0x8(%ebp),%eax
  803875:	8b 00                	mov    (%eax),%eax
  803877:	85 c0                	test   %eax,%eax
  803879:	75 08                	jne    803883 <insert_sorted_with_merge_freeList+0x701>
  80387b:	8b 45 08             	mov    0x8(%ebp),%eax
  80387e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803883:	a1 44 51 80 00       	mov    0x805144,%eax
  803888:	40                   	inc    %eax
  803889:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  80388e:	eb 38                	jmp    8038c8 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803890:	a1 40 51 80 00       	mov    0x805140,%eax
  803895:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803898:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80389c:	74 07                	je     8038a5 <insert_sorted_with_merge_freeList+0x723>
  80389e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a1:	8b 00                	mov    (%eax),%eax
  8038a3:	eb 05                	jmp    8038aa <insert_sorted_with_merge_freeList+0x728>
  8038a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8038aa:	a3 40 51 80 00       	mov    %eax,0x805140
  8038af:	a1 40 51 80 00       	mov    0x805140,%eax
  8038b4:	85 c0                	test   %eax,%eax
  8038b6:	0f 85 c3 fb ff ff    	jne    80347f <insert_sorted_with_merge_freeList+0x2fd>
  8038bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038c0:	0f 85 b9 fb ff ff    	jne    80347f <insert_sorted_with_merge_freeList+0x2fd>





}
  8038c6:	eb 00                	jmp    8038c8 <insert_sorted_with_merge_freeList+0x746>
  8038c8:	90                   	nop
  8038c9:	c9                   	leave  
  8038ca:	c3                   	ret    
  8038cb:	90                   	nop

008038cc <__udivdi3>:
  8038cc:	55                   	push   %ebp
  8038cd:	57                   	push   %edi
  8038ce:	56                   	push   %esi
  8038cf:	53                   	push   %ebx
  8038d0:	83 ec 1c             	sub    $0x1c,%esp
  8038d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038e3:	89 ca                	mov    %ecx,%edx
  8038e5:	89 f8                	mov    %edi,%eax
  8038e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038eb:	85 f6                	test   %esi,%esi
  8038ed:	75 2d                	jne    80391c <__udivdi3+0x50>
  8038ef:	39 cf                	cmp    %ecx,%edi
  8038f1:	77 65                	ja     803958 <__udivdi3+0x8c>
  8038f3:	89 fd                	mov    %edi,%ebp
  8038f5:	85 ff                	test   %edi,%edi
  8038f7:	75 0b                	jne    803904 <__udivdi3+0x38>
  8038f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8038fe:	31 d2                	xor    %edx,%edx
  803900:	f7 f7                	div    %edi
  803902:	89 c5                	mov    %eax,%ebp
  803904:	31 d2                	xor    %edx,%edx
  803906:	89 c8                	mov    %ecx,%eax
  803908:	f7 f5                	div    %ebp
  80390a:	89 c1                	mov    %eax,%ecx
  80390c:	89 d8                	mov    %ebx,%eax
  80390e:	f7 f5                	div    %ebp
  803910:	89 cf                	mov    %ecx,%edi
  803912:	89 fa                	mov    %edi,%edx
  803914:	83 c4 1c             	add    $0x1c,%esp
  803917:	5b                   	pop    %ebx
  803918:	5e                   	pop    %esi
  803919:	5f                   	pop    %edi
  80391a:	5d                   	pop    %ebp
  80391b:	c3                   	ret    
  80391c:	39 ce                	cmp    %ecx,%esi
  80391e:	77 28                	ja     803948 <__udivdi3+0x7c>
  803920:	0f bd fe             	bsr    %esi,%edi
  803923:	83 f7 1f             	xor    $0x1f,%edi
  803926:	75 40                	jne    803968 <__udivdi3+0x9c>
  803928:	39 ce                	cmp    %ecx,%esi
  80392a:	72 0a                	jb     803936 <__udivdi3+0x6a>
  80392c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803930:	0f 87 9e 00 00 00    	ja     8039d4 <__udivdi3+0x108>
  803936:	b8 01 00 00 00       	mov    $0x1,%eax
  80393b:	89 fa                	mov    %edi,%edx
  80393d:	83 c4 1c             	add    $0x1c,%esp
  803940:	5b                   	pop    %ebx
  803941:	5e                   	pop    %esi
  803942:	5f                   	pop    %edi
  803943:	5d                   	pop    %ebp
  803944:	c3                   	ret    
  803945:	8d 76 00             	lea    0x0(%esi),%esi
  803948:	31 ff                	xor    %edi,%edi
  80394a:	31 c0                	xor    %eax,%eax
  80394c:	89 fa                	mov    %edi,%edx
  80394e:	83 c4 1c             	add    $0x1c,%esp
  803951:	5b                   	pop    %ebx
  803952:	5e                   	pop    %esi
  803953:	5f                   	pop    %edi
  803954:	5d                   	pop    %ebp
  803955:	c3                   	ret    
  803956:	66 90                	xchg   %ax,%ax
  803958:	89 d8                	mov    %ebx,%eax
  80395a:	f7 f7                	div    %edi
  80395c:	31 ff                	xor    %edi,%edi
  80395e:	89 fa                	mov    %edi,%edx
  803960:	83 c4 1c             	add    $0x1c,%esp
  803963:	5b                   	pop    %ebx
  803964:	5e                   	pop    %esi
  803965:	5f                   	pop    %edi
  803966:	5d                   	pop    %ebp
  803967:	c3                   	ret    
  803968:	bd 20 00 00 00       	mov    $0x20,%ebp
  80396d:	89 eb                	mov    %ebp,%ebx
  80396f:	29 fb                	sub    %edi,%ebx
  803971:	89 f9                	mov    %edi,%ecx
  803973:	d3 e6                	shl    %cl,%esi
  803975:	89 c5                	mov    %eax,%ebp
  803977:	88 d9                	mov    %bl,%cl
  803979:	d3 ed                	shr    %cl,%ebp
  80397b:	89 e9                	mov    %ebp,%ecx
  80397d:	09 f1                	or     %esi,%ecx
  80397f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803983:	89 f9                	mov    %edi,%ecx
  803985:	d3 e0                	shl    %cl,%eax
  803987:	89 c5                	mov    %eax,%ebp
  803989:	89 d6                	mov    %edx,%esi
  80398b:	88 d9                	mov    %bl,%cl
  80398d:	d3 ee                	shr    %cl,%esi
  80398f:	89 f9                	mov    %edi,%ecx
  803991:	d3 e2                	shl    %cl,%edx
  803993:	8b 44 24 08          	mov    0x8(%esp),%eax
  803997:	88 d9                	mov    %bl,%cl
  803999:	d3 e8                	shr    %cl,%eax
  80399b:	09 c2                	or     %eax,%edx
  80399d:	89 d0                	mov    %edx,%eax
  80399f:	89 f2                	mov    %esi,%edx
  8039a1:	f7 74 24 0c          	divl   0xc(%esp)
  8039a5:	89 d6                	mov    %edx,%esi
  8039a7:	89 c3                	mov    %eax,%ebx
  8039a9:	f7 e5                	mul    %ebp
  8039ab:	39 d6                	cmp    %edx,%esi
  8039ad:	72 19                	jb     8039c8 <__udivdi3+0xfc>
  8039af:	74 0b                	je     8039bc <__udivdi3+0xf0>
  8039b1:	89 d8                	mov    %ebx,%eax
  8039b3:	31 ff                	xor    %edi,%edi
  8039b5:	e9 58 ff ff ff       	jmp    803912 <__udivdi3+0x46>
  8039ba:	66 90                	xchg   %ax,%ax
  8039bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039c0:	89 f9                	mov    %edi,%ecx
  8039c2:	d3 e2                	shl    %cl,%edx
  8039c4:	39 c2                	cmp    %eax,%edx
  8039c6:	73 e9                	jae    8039b1 <__udivdi3+0xe5>
  8039c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039cb:	31 ff                	xor    %edi,%edi
  8039cd:	e9 40 ff ff ff       	jmp    803912 <__udivdi3+0x46>
  8039d2:	66 90                	xchg   %ax,%ax
  8039d4:	31 c0                	xor    %eax,%eax
  8039d6:	e9 37 ff ff ff       	jmp    803912 <__udivdi3+0x46>
  8039db:	90                   	nop

008039dc <__umoddi3>:
  8039dc:	55                   	push   %ebp
  8039dd:	57                   	push   %edi
  8039de:	56                   	push   %esi
  8039df:	53                   	push   %ebx
  8039e0:	83 ec 1c             	sub    $0x1c,%esp
  8039e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039fb:	89 f3                	mov    %esi,%ebx
  8039fd:	89 fa                	mov    %edi,%edx
  8039ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a03:	89 34 24             	mov    %esi,(%esp)
  803a06:	85 c0                	test   %eax,%eax
  803a08:	75 1a                	jne    803a24 <__umoddi3+0x48>
  803a0a:	39 f7                	cmp    %esi,%edi
  803a0c:	0f 86 a2 00 00 00    	jbe    803ab4 <__umoddi3+0xd8>
  803a12:	89 c8                	mov    %ecx,%eax
  803a14:	89 f2                	mov    %esi,%edx
  803a16:	f7 f7                	div    %edi
  803a18:	89 d0                	mov    %edx,%eax
  803a1a:	31 d2                	xor    %edx,%edx
  803a1c:	83 c4 1c             	add    $0x1c,%esp
  803a1f:	5b                   	pop    %ebx
  803a20:	5e                   	pop    %esi
  803a21:	5f                   	pop    %edi
  803a22:	5d                   	pop    %ebp
  803a23:	c3                   	ret    
  803a24:	39 f0                	cmp    %esi,%eax
  803a26:	0f 87 ac 00 00 00    	ja     803ad8 <__umoddi3+0xfc>
  803a2c:	0f bd e8             	bsr    %eax,%ebp
  803a2f:	83 f5 1f             	xor    $0x1f,%ebp
  803a32:	0f 84 ac 00 00 00    	je     803ae4 <__umoddi3+0x108>
  803a38:	bf 20 00 00 00       	mov    $0x20,%edi
  803a3d:	29 ef                	sub    %ebp,%edi
  803a3f:	89 fe                	mov    %edi,%esi
  803a41:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a45:	89 e9                	mov    %ebp,%ecx
  803a47:	d3 e0                	shl    %cl,%eax
  803a49:	89 d7                	mov    %edx,%edi
  803a4b:	89 f1                	mov    %esi,%ecx
  803a4d:	d3 ef                	shr    %cl,%edi
  803a4f:	09 c7                	or     %eax,%edi
  803a51:	89 e9                	mov    %ebp,%ecx
  803a53:	d3 e2                	shl    %cl,%edx
  803a55:	89 14 24             	mov    %edx,(%esp)
  803a58:	89 d8                	mov    %ebx,%eax
  803a5a:	d3 e0                	shl    %cl,%eax
  803a5c:	89 c2                	mov    %eax,%edx
  803a5e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a62:	d3 e0                	shl    %cl,%eax
  803a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a68:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a6c:	89 f1                	mov    %esi,%ecx
  803a6e:	d3 e8                	shr    %cl,%eax
  803a70:	09 d0                	or     %edx,%eax
  803a72:	d3 eb                	shr    %cl,%ebx
  803a74:	89 da                	mov    %ebx,%edx
  803a76:	f7 f7                	div    %edi
  803a78:	89 d3                	mov    %edx,%ebx
  803a7a:	f7 24 24             	mull   (%esp)
  803a7d:	89 c6                	mov    %eax,%esi
  803a7f:	89 d1                	mov    %edx,%ecx
  803a81:	39 d3                	cmp    %edx,%ebx
  803a83:	0f 82 87 00 00 00    	jb     803b10 <__umoddi3+0x134>
  803a89:	0f 84 91 00 00 00    	je     803b20 <__umoddi3+0x144>
  803a8f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a93:	29 f2                	sub    %esi,%edx
  803a95:	19 cb                	sbb    %ecx,%ebx
  803a97:	89 d8                	mov    %ebx,%eax
  803a99:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a9d:	d3 e0                	shl    %cl,%eax
  803a9f:	89 e9                	mov    %ebp,%ecx
  803aa1:	d3 ea                	shr    %cl,%edx
  803aa3:	09 d0                	or     %edx,%eax
  803aa5:	89 e9                	mov    %ebp,%ecx
  803aa7:	d3 eb                	shr    %cl,%ebx
  803aa9:	89 da                	mov    %ebx,%edx
  803aab:	83 c4 1c             	add    $0x1c,%esp
  803aae:	5b                   	pop    %ebx
  803aaf:	5e                   	pop    %esi
  803ab0:	5f                   	pop    %edi
  803ab1:	5d                   	pop    %ebp
  803ab2:	c3                   	ret    
  803ab3:	90                   	nop
  803ab4:	89 fd                	mov    %edi,%ebp
  803ab6:	85 ff                	test   %edi,%edi
  803ab8:	75 0b                	jne    803ac5 <__umoddi3+0xe9>
  803aba:	b8 01 00 00 00       	mov    $0x1,%eax
  803abf:	31 d2                	xor    %edx,%edx
  803ac1:	f7 f7                	div    %edi
  803ac3:	89 c5                	mov    %eax,%ebp
  803ac5:	89 f0                	mov    %esi,%eax
  803ac7:	31 d2                	xor    %edx,%edx
  803ac9:	f7 f5                	div    %ebp
  803acb:	89 c8                	mov    %ecx,%eax
  803acd:	f7 f5                	div    %ebp
  803acf:	89 d0                	mov    %edx,%eax
  803ad1:	e9 44 ff ff ff       	jmp    803a1a <__umoddi3+0x3e>
  803ad6:	66 90                	xchg   %ax,%ax
  803ad8:	89 c8                	mov    %ecx,%eax
  803ada:	89 f2                	mov    %esi,%edx
  803adc:	83 c4 1c             	add    $0x1c,%esp
  803adf:	5b                   	pop    %ebx
  803ae0:	5e                   	pop    %esi
  803ae1:	5f                   	pop    %edi
  803ae2:	5d                   	pop    %ebp
  803ae3:	c3                   	ret    
  803ae4:	3b 04 24             	cmp    (%esp),%eax
  803ae7:	72 06                	jb     803aef <__umoddi3+0x113>
  803ae9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803aed:	77 0f                	ja     803afe <__umoddi3+0x122>
  803aef:	89 f2                	mov    %esi,%edx
  803af1:	29 f9                	sub    %edi,%ecx
  803af3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803af7:	89 14 24             	mov    %edx,(%esp)
  803afa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803afe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b02:	8b 14 24             	mov    (%esp),%edx
  803b05:	83 c4 1c             	add    $0x1c,%esp
  803b08:	5b                   	pop    %ebx
  803b09:	5e                   	pop    %esi
  803b0a:	5f                   	pop    %edi
  803b0b:	5d                   	pop    %ebp
  803b0c:	c3                   	ret    
  803b0d:	8d 76 00             	lea    0x0(%esi),%esi
  803b10:	2b 04 24             	sub    (%esp),%eax
  803b13:	19 fa                	sbb    %edi,%edx
  803b15:	89 d1                	mov    %edx,%ecx
  803b17:	89 c6                	mov    %eax,%esi
  803b19:	e9 71 ff ff ff       	jmp    803a8f <__umoddi3+0xb3>
  803b1e:	66 90                	xchg   %ax,%ax
  803b20:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b24:	72 ea                	jb     803b10 <__umoddi3+0x134>
  803b26:	89 d9                	mov    %ebx,%ecx
  803b28:	e9 62 ff ff ff       	jmp    803a8f <__umoddi3+0xb3>
