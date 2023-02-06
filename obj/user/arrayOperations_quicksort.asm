
obj/user/arrayOperations_quicksort:     file format elf32-i386


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
  800031:	e8 20 03 00 00       	call   800356 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 a2 1b 00 00       	call   801be5 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 cc 1b 00 00       	call   801c17 <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80004e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800055:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 20 34 80 00       	push   $0x803420
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 8d 16 00 00       	call   8016f9 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 24 34 80 00       	push   $0x803424
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 77 16 00 00       	call   8016f9 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 2c 34 80 00       	push   $0x80342c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 5a 16 00 00       	call   8016f9 <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 3a 34 80 00       	push   $0x80343a
  8000b8:	e8 9e 15 00 00       	call   80165b <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		sortedArray[i] = sharedArray[i];
  8000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	01 c2                	add    %eax,%edx
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e8:	01 c8                	add    %ecx,%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	89 02                	mov    %eax,(%edx)
	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		sortedArray[i] = sharedArray[i];
	}
	QuickSort(sortedArray, *numOfElements);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	ff 75 dc             	pushl  -0x24(%ebp)
  800107:	e8 23 00 00 00       	call   80012f <QuickSort>
  80010c:	83 c4 10             	add    $0x10,%esp
	cprintf("Quick sort is Finished!!!!\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 49 34 80 00       	push   $0x803449
  800117:	e8 4a 04 00 00       	call   800566 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  80011f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800122:	8b 00                	mov    (%eax),%eax
  800124:	8d 50 01             	lea    0x1(%eax),%edx
  800127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012a:	89 10                	mov    %edx,(%eax)

}
  80012c:	90                   	nop
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800135:	8b 45 0c             	mov    0xc(%ebp),%eax
  800138:	48                   	dec    %eax
  800139:	50                   	push   %eax
  80013a:	6a 00                	push   $0x0
  80013c:	ff 75 0c             	pushl  0xc(%ebp)
  80013f:	ff 75 08             	pushl  0x8(%ebp)
  800142:	e8 06 00 00 00       	call   80014d <QSort>
  800147:	83 c4 10             	add    $0x10,%esp
}
  80014a:	90                   	nop
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return;
  800153:	8b 45 10             	mov    0x10(%ebp),%eax
  800156:	3b 45 14             	cmp    0x14(%ebp),%eax
  800159:	0f 8d 1b 01 00 00    	jge    80027a <QSort+0x12d>
	int pvtIndex = RAND(startIndex, finalIndex) ;
  80015f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	50                   	push   %eax
  800166:	e8 df 1a 00 00       	call   801c4a <sys_get_virtual_time>
  80016b:	83 c4 0c             	add    $0xc,%esp
  80016e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800171:	8b 55 14             	mov    0x14(%ebp),%edx
  800174:	2b 55 10             	sub    0x10(%ebp),%edx
  800177:	89 d1                	mov    %edx,%ecx
  800179:	ba 00 00 00 00       	mov    $0x0,%edx
  80017e:	f7 f1                	div    %ecx
  800180:	8b 45 10             	mov    0x10(%ebp),%eax
  800183:	01 d0                	add    %edx,%eax
  800185:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800188:	83 ec 04             	sub    $0x4,%esp
  80018b:	ff 75 ec             	pushl  -0x14(%ebp)
  80018e:	ff 75 10             	pushl  0x10(%ebp)
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 e4 00 00 00       	call   80027d <Swap>
  800199:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  80019c:	8b 45 10             	mov    0x10(%ebp),%eax
  80019f:	40                   	inc    %eax
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8001a9:	e9 80 00 00 00       	jmp    80022e <QSort+0xe1>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8001ae:	ff 45 f4             	incl   -0xc(%ebp)
  8001b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b4:	3b 45 14             	cmp    0x14(%ebp),%eax
  8001b7:	7f 2b                	jg     8001e4 <QSort+0x97>
  8001b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	8b 10                	mov    (%eax),%edx
  8001ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	01 c8                	add    %ecx,%eax
  8001d9:	8b 00                	mov    (%eax),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	7d cf                	jge    8001ae <QSort+0x61>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8001df:	eb 03                	jmp    8001e4 <QSort+0x97>
  8001e1:	ff 4d f0             	decl   -0x10(%ebp)
  8001e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8001ea:	7e 26                	jle    800212 <QSort+0xc5>
  8001ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f9:	01 d0                	add    %edx,%eax
  8001fb:	8b 10                	mov    (%eax),%edx
  8001fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800200:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800207:	8b 45 08             	mov    0x8(%ebp),%eax
  80020a:	01 c8                	add    %ecx,%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	39 c2                	cmp    %eax,%edx
  800210:	7e cf                	jle    8001e1 <QSort+0x94>

		if (i <= j)
  800212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800215:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800218:	7f 14                	jg     80022e <QSort+0xe1>
		{
			Swap(Elements, i, j);
  80021a:	83 ec 04             	sub    $0x4,%esp
  80021d:	ff 75 f0             	pushl  -0x10(%ebp)
  800220:	ff 75 f4             	pushl  -0xc(%ebp)
  800223:	ff 75 08             	pushl  0x8(%ebp)
  800226:	e8 52 00 00 00       	call   80027d <Swap>
  80022b:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  80022e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800231:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800234:	0f 8e 77 ff ff ff    	jle    8001b1 <QSort+0x64>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	ff 75 f0             	pushl  -0x10(%ebp)
  800240:	ff 75 10             	pushl  0x10(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 32 00 00 00       	call   80027d <Swap>
  80024b:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  80024e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800251:	48                   	dec    %eax
  800252:	50                   	push   %eax
  800253:	ff 75 10             	pushl  0x10(%ebp)
  800256:	ff 75 0c             	pushl  0xc(%ebp)
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	e8 ec fe ff ff       	call   80014d <QSort>
  800261:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800264:	ff 75 14             	pushl  0x14(%ebp)
  800267:	ff 75 f4             	pushl  -0xc(%ebp)
  80026a:	ff 75 0c             	pushl  0xc(%ebp)
  80026d:	ff 75 08             	pushl  0x8(%ebp)
  800270:	e8 d8 fe ff ff       	call   80014d <QSort>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	eb 01                	jmp    80027b <QSort+0x12e>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80027a:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800283:	8b 45 0c             	mov    0xc(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a4:	01 c2                	add    %eax,%edx
  8002a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b3:	01 c8                	add    %ecx,%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8002b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	01 c2                	add    %eax,%edx
  8002c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8002cb:	89 02                	mov    %eax,(%edx)
}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8002d6:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8002dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8002e4:	eb 42                	jmp    800328 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8002e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e9:	99                   	cltd   
  8002ea:	f7 7d f0             	idivl  -0x10(%ebp)
  8002ed:	89 d0                	mov    %edx,%eax
  8002ef:	85 c0                	test   %eax,%eax
  8002f1:	75 10                	jne    800303 <PrintElements+0x33>
			cprintf("\n");
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	68 65 34 80 00       	push   $0x803465
  8002fb:	e8 66 02 00 00       	call   800566 <cprintf>
  800300:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800306:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030d:	8b 45 08             	mov    0x8(%ebp),%eax
  800310:	01 d0                	add    %edx,%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	50                   	push   %eax
  800318:	68 67 34 80 00       	push   $0x803467
  80031d:	e8 44 02 00 00       	call   800566 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800325:	ff 45 f4             	incl   -0xc(%ebp)
  800328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032b:	48                   	dec    %eax
  80032c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80032f:	7f b5                	jg     8002e6 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 00                	mov    (%eax),%eax
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	50                   	push   %eax
  800346:	68 6c 34 80 00       	push   $0x80346c
  80034b:	e8 16 02 00 00       	call   800566 <cprintf>
  800350:	83 c4 10             	add    $0x10,%esp

}
  800353:	90                   	nop
  800354:	c9                   	leave  
  800355:	c3                   	ret    

00800356 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80035c:	e8 9d 18 00 00       	call   801bfe <sys_getenvindex>
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800367:	89 d0                	mov    %edx,%eax
  800369:	c1 e0 03             	shl    $0x3,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	01 c0                	add    %eax,%eax
  800370:	01 d0                	add    %edx,%eax
  800372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800379:	01 d0                	add    %edx,%eax
  80037b:	c1 e0 04             	shl    $0x4,%eax
  80037e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800383:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800388:	a1 20 40 80 00       	mov    0x804020,%eax
  80038d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800393:	84 c0                	test   %al,%al
  800395:	74 0f                	je     8003a6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800397:	a1 20 40 80 00       	mov    0x804020,%eax
  80039c:	05 5c 05 00 00       	add    $0x55c,%eax
  8003a1:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003aa:	7e 0a                	jle    8003b6 <libmain+0x60>
		binaryname = argv[0];
  8003ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	ff 75 0c             	pushl  0xc(%ebp)
  8003bc:	ff 75 08             	pushl  0x8(%ebp)
  8003bf:	e8 74 fc ff ff       	call   800038 <_main>
  8003c4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003c7:	e8 3f 16 00 00       	call   801a0b <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	68 88 34 80 00       	push   $0x803488
  8003d4:	e8 8d 01 00 00       	call   800566 <cprintf>
  8003d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ec:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003f2:	83 ec 04             	sub    $0x4,%esp
  8003f5:	52                   	push   %edx
  8003f6:	50                   	push   %eax
  8003f7:	68 b0 34 80 00       	push   $0x8034b0
  8003fc:	e8 65 01 00 00       	call   800566 <cprintf>
  800401:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800404:	a1 20 40 80 00       	mov    0x804020,%eax
  800409:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80040f:	a1 20 40 80 00       	mov    0x804020,%eax
  800414:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80041a:	a1 20 40 80 00       	mov    0x804020,%eax
  80041f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800425:	51                   	push   %ecx
  800426:	52                   	push   %edx
  800427:	50                   	push   %eax
  800428:	68 d8 34 80 00       	push   $0x8034d8
  80042d:	e8 34 01 00 00       	call   800566 <cprintf>
  800432:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800435:	a1 20 40 80 00       	mov    0x804020,%eax
  80043a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	50                   	push   %eax
  800444:	68 30 35 80 00       	push   $0x803530
  800449:	e8 18 01 00 00       	call   800566 <cprintf>
  80044e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 88 34 80 00       	push   $0x803488
  800459:	e8 08 01 00 00       	call   800566 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800461:	e8 bf 15 00 00       	call   801a25 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800466:	e8 19 00 00 00       	call   800484 <exit>
}
  80046b:	90                   	nop
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	6a 00                	push   $0x0
  800479:	e8 4c 17 00 00       	call   801bca <sys_destroy_env>
  80047e:	83 c4 10             	add    $0x10,%esp
}
  800481:	90                   	nop
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <exit>:

void
exit(void)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80048a:	e8 a1 17 00 00       	call   801c30 <sys_exit_env>
}
  80048f:	90                   	nop
  800490:	c9                   	leave  
  800491:	c3                   	ret    

00800492 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800492:	55                   	push   %ebp
  800493:	89 e5                	mov    %esp,%ebp
  800495:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a3:	89 0a                	mov    %ecx,(%edx)
  8004a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a8:	88 d1                	mov    %dl,%cl
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bb:	75 2c                	jne    8004e9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004bd:	a0 24 40 80 00       	mov    0x804024,%al
  8004c2:	0f b6 c0             	movzbl %al,%eax
  8004c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c8:	8b 12                	mov    (%edx),%edx
  8004ca:	89 d1                	mov    %edx,%ecx
  8004cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cf:	83 c2 08             	add    $0x8,%edx
  8004d2:	83 ec 04             	sub    $0x4,%esp
  8004d5:	50                   	push   %eax
  8004d6:	51                   	push   %ecx
  8004d7:	52                   	push   %edx
  8004d8:	e8 80 13 00 00       	call   80185d <sys_cputs>
  8004dd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ec:	8b 40 04             	mov    0x4(%eax),%eax
  8004ef:	8d 50 01             	lea    0x1(%eax),%edx
  8004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004f8:	90                   	nop
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800504:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050b:	00 00 00 
	b.cnt = 0;
  80050e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800515:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800518:	ff 75 0c             	pushl  0xc(%ebp)
  80051b:	ff 75 08             	pushl  0x8(%ebp)
  80051e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800524:	50                   	push   %eax
  800525:	68 92 04 80 00       	push   $0x800492
  80052a:	e8 11 02 00 00       	call   800740 <vprintfmt>
  80052f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800532:	a0 24 40 80 00       	mov    0x804024,%al
  800537:	0f b6 c0             	movzbl %al,%eax
  80053a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800540:	83 ec 04             	sub    $0x4,%esp
  800543:	50                   	push   %eax
  800544:	52                   	push   %edx
  800545:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054b:	83 c0 08             	add    $0x8,%eax
  80054e:	50                   	push   %eax
  80054f:	e8 09 13 00 00       	call   80185d <sys_cputs>
  800554:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800557:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80055e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <cprintf>:

int cprintf(const char *fmt, ...) {
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80056c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800573:	8d 45 0c             	lea    0xc(%ebp),%eax
  800576:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	ff 75 f4             	pushl  -0xc(%ebp)
  800582:	50                   	push   %eax
  800583:	e8 73 ff ff ff       	call   8004fb <vcprintf>
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800599:	e8 6d 14 00 00       	call   801a0b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80059e:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ad:	50                   	push   %eax
  8005ae:	e8 48 ff ff ff       	call   8004fb <vcprintf>
  8005b3:	83 c4 10             	add    $0x10,%esp
  8005b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005b9:	e8 67 14 00 00       	call   801a25 <sys_enable_interrupt>
	return cnt;
  8005be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	53                   	push   %ebx
  8005c7:	83 ec 14             	sub    $0x14,%esp
  8005ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005de:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e1:	77 55                	ja     800638 <printnum+0x75>
  8005e3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e6:	72 05                	jb     8005ed <printnum+0x2a>
  8005e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005eb:	77 4b                	ja     800638 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ed:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fb:	52                   	push   %edx
  8005fc:	50                   	push   %eax
  8005fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800600:	ff 75 f0             	pushl  -0x10(%ebp)
  800603:	e8 b0 2b 00 00       	call   8031b8 <__udivdi3>
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	83 ec 04             	sub    $0x4,%esp
  80060e:	ff 75 20             	pushl  0x20(%ebp)
  800611:	53                   	push   %ebx
  800612:	ff 75 18             	pushl  0x18(%ebp)
  800615:	52                   	push   %edx
  800616:	50                   	push   %eax
  800617:	ff 75 0c             	pushl  0xc(%ebp)
  80061a:	ff 75 08             	pushl  0x8(%ebp)
  80061d:	e8 a1 ff ff ff       	call   8005c3 <printnum>
  800622:	83 c4 20             	add    $0x20,%esp
  800625:	eb 1a                	jmp    800641 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	ff 75 0c             	pushl  0xc(%ebp)
  80062d:	ff 75 20             	pushl  0x20(%ebp)
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	ff d0                	call   *%eax
  800635:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800638:	ff 4d 1c             	decl   0x1c(%ebp)
  80063b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80063f:	7f e6                	jg     800627 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800641:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800644:	bb 00 00 00 00       	mov    $0x0,%ebx
  800649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80064f:	53                   	push   %ebx
  800650:	51                   	push   %ecx
  800651:	52                   	push   %edx
  800652:	50                   	push   %eax
  800653:	e8 70 2c 00 00       	call   8032c8 <__umoddi3>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	05 74 37 80 00       	add    $0x803774,%eax
  800660:	8a 00                	mov    (%eax),%al
  800662:	0f be c0             	movsbl %al,%eax
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	ff 75 0c             	pushl  0xc(%ebp)
  80066b:	50                   	push   %eax
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	ff d0                	call   *%eax
  800671:	83 c4 10             	add    $0x10,%esp
}
  800674:	90                   	nop
  800675:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800678:	c9                   	leave  
  800679:	c3                   	ret    

0080067a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800681:	7e 1c                	jle    80069f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 50 08             	lea    0x8(%eax),%edx
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	83 e8 08             	sub    $0x8,%eax
  800698:	8b 50 04             	mov    0x4(%eax),%edx
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	eb 40                	jmp    8006df <getuint+0x65>
	else if (lflag)
  80069f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a3:	74 1e                	je     8006c3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	8d 50 04             	lea    0x4(%eax),%edx
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	89 10                	mov    %edx,(%eax)
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	83 e8 04             	sub    $0x4,%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c1:	eb 1c                	jmp    8006df <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	8d 50 04             	lea    0x4(%eax),%edx
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	89 10                	mov    %edx,(%eax)
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	83 e8 04             	sub    $0x4,%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006df:	5d                   	pop    %ebp
  8006e0:	c3                   	ret    

008006e1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e8:	7e 1c                	jle    800706 <getint+0x25>
		return va_arg(*ap, long long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 08             	lea    0x8(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 08             	sub    $0x8,%eax
  8006ff:	8b 50 04             	mov    0x4(%eax),%edx
  800702:	8b 00                	mov    (%eax),%eax
  800704:	eb 38                	jmp    80073e <getint+0x5d>
	else if (lflag)
  800706:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070a:	74 1a                	je     800726 <getint+0x45>
		return va_arg(*ap, long);
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	8d 50 04             	lea    0x4(%eax),%edx
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	89 10                	mov    %edx,(%eax)
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	83 e8 04             	sub    $0x4,%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	99                   	cltd   
  800724:	eb 18                	jmp    80073e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	99                   	cltd   
}
  80073e:	5d                   	pop    %ebp
  80073f:	c3                   	ret    

00800740 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	56                   	push   %esi
  800744:	53                   	push   %ebx
  800745:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800748:	eb 17                	jmp    800761 <vprintfmt+0x21>
			if (ch == '\0')
  80074a:	85 db                	test   %ebx,%ebx
  80074c:	0f 84 af 03 00 00    	je     800b01 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	ff 75 0c             	pushl  0xc(%ebp)
  800758:	53                   	push   %ebx
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	ff d0                	call   *%eax
  80075e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800761:	8b 45 10             	mov    0x10(%ebp),%eax
  800764:	8d 50 01             	lea    0x1(%eax),%edx
  800767:	89 55 10             	mov    %edx,0x10(%ebp)
  80076a:	8a 00                	mov    (%eax),%al
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	83 fb 25             	cmp    $0x25,%ebx
  800772:	75 d6                	jne    80074a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800774:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800778:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80077f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800786:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80078d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800794:	8b 45 10             	mov    0x10(%ebp),%eax
  800797:	8d 50 01             	lea    0x1(%eax),%edx
  80079a:	89 55 10             	mov    %edx,0x10(%ebp)
  80079d:	8a 00                	mov    (%eax),%al
  80079f:	0f b6 d8             	movzbl %al,%ebx
  8007a2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a5:	83 f8 55             	cmp    $0x55,%eax
  8007a8:	0f 87 2b 03 00 00    	ja     800ad9 <vprintfmt+0x399>
  8007ae:	8b 04 85 98 37 80 00 	mov    0x803798(,%eax,4),%eax
  8007b5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bb:	eb d7                	jmp    800794 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c1:	eb d1                	jmp    800794 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007cd:	89 d0                	mov    %edx,%eax
  8007cf:	c1 e0 02             	shl    $0x2,%eax
  8007d2:	01 d0                	add    %edx,%eax
  8007d4:	01 c0                	add    %eax,%eax
  8007d6:	01 d8                	add    %ebx,%eax
  8007d8:	83 e8 30             	sub    $0x30,%eax
  8007db:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007de:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e1:	8a 00                	mov    (%eax),%al
  8007e3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e9:	7e 3e                	jle    800829 <vprintfmt+0xe9>
  8007eb:	83 fb 39             	cmp    $0x39,%ebx
  8007ee:	7f 39                	jg     800829 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f3:	eb d5                	jmp    8007ca <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	83 c0 04             	add    $0x4,%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800809:	eb 1f                	jmp    80082a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080f:	79 83                	jns    800794 <vprintfmt+0x54>
				width = 0;
  800811:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800818:	e9 77 ff ff ff       	jmp    800794 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80081d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800824:	e9 6b ff ff ff       	jmp    800794 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800829:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	0f 89 60 ff ff ff    	jns    800794 <vprintfmt+0x54>
				width = precision, precision = -1;
  800834:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800837:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800841:	e9 4e ff ff ff       	jmp    800794 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800846:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800849:	e9 46 ff ff ff       	jmp    800794 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	83 c0 04             	add    $0x4,%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	83 e8 04             	sub    $0x4,%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	50                   	push   %eax
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
			break;
  80086e:	e9 89 02 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 c0 04             	add    $0x4,%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	83 e8 04             	sub    $0x4,%eax
  800882:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800884:	85 db                	test   %ebx,%ebx
  800886:	79 02                	jns    80088a <vprintfmt+0x14a>
				err = -err;
  800888:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088a:	83 fb 64             	cmp    $0x64,%ebx
  80088d:	7f 0b                	jg     80089a <vprintfmt+0x15a>
  80088f:	8b 34 9d e0 35 80 00 	mov    0x8035e0(,%ebx,4),%esi
  800896:	85 f6                	test   %esi,%esi
  800898:	75 19                	jne    8008b3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089a:	53                   	push   %ebx
  80089b:	68 85 37 80 00       	push   $0x803785
  8008a0:	ff 75 0c             	pushl  0xc(%ebp)
  8008a3:	ff 75 08             	pushl  0x8(%ebp)
  8008a6:	e8 5e 02 00 00       	call   800b09 <printfmt>
  8008ab:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ae:	e9 49 02 00 00       	jmp    800afc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b3:	56                   	push   %esi
  8008b4:	68 8e 37 80 00       	push   $0x80378e
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	ff 75 08             	pushl  0x8(%ebp)
  8008bf:	e8 45 02 00 00       	call   800b09 <printfmt>
  8008c4:	83 c4 10             	add    $0x10,%esp
			break;
  8008c7:	e9 30 02 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	83 c0 04             	add    $0x4,%eax
  8008d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d8:	83 e8 04             	sub    $0x4,%eax
  8008db:	8b 30                	mov    (%eax),%esi
  8008dd:	85 f6                	test   %esi,%esi
  8008df:	75 05                	jne    8008e6 <vprintfmt+0x1a6>
				p = "(null)";
  8008e1:	be 91 37 80 00       	mov    $0x803791,%esi
			if (width > 0 && padc != '-')
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	7e 6d                	jle    800959 <vprintfmt+0x219>
  8008ec:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f0:	74 67                	je     800959 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	50                   	push   %eax
  8008f9:	56                   	push   %esi
  8008fa:	e8 0c 03 00 00       	call   800c0b <strnlen>
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800905:	eb 16                	jmp    80091d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800907:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	ff 75 0c             	pushl  0xc(%ebp)
  800911:	50                   	push   %eax
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	ff d0                	call   *%eax
  800917:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091a:	ff 4d e4             	decl   -0x1c(%ebp)
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7f e4                	jg     800907 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	eb 34                	jmp    800959 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800925:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800929:	74 1c                	je     800947 <vprintfmt+0x207>
  80092b:	83 fb 1f             	cmp    $0x1f,%ebx
  80092e:	7e 05                	jle    800935 <vprintfmt+0x1f5>
  800930:	83 fb 7e             	cmp    $0x7e,%ebx
  800933:	7e 12                	jle    800947 <vprintfmt+0x207>
					putch('?', putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	6a 3f                	push   $0x3f
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
  800945:	eb 0f                	jmp    800956 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800956:	ff 4d e4             	decl   -0x1c(%ebp)
  800959:	89 f0                	mov    %esi,%eax
  80095b:	8d 70 01             	lea    0x1(%eax),%esi
  80095e:	8a 00                	mov    (%eax),%al
  800960:	0f be d8             	movsbl %al,%ebx
  800963:	85 db                	test   %ebx,%ebx
  800965:	74 24                	je     80098b <vprintfmt+0x24b>
  800967:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096b:	78 b8                	js     800925 <vprintfmt+0x1e5>
  80096d:	ff 4d e0             	decl   -0x20(%ebp)
  800970:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800974:	79 af                	jns    800925 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800976:	eb 13                	jmp    80098b <vprintfmt+0x24b>
				putch(' ', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	6a 20                	push   $0x20
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	ff d0                	call   *%eax
  800985:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800988:	ff 4d e4             	decl   -0x1c(%ebp)
  80098b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098f:	7f e7                	jg     800978 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800991:	e9 66 01 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 e8             	pushl  -0x18(%ebp)
  80099c:	8d 45 14             	lea    0x14(%ebp),%eax
  80099f:	50                   	push   %eax
  8009a0:	e8 3c fd ff ff       	call   8006e1 <getint>
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b4:	85 d2                	test   %edx,%edx
  8009b6:	79 23                	jns    8009db <vprintfmt+0x29b>
				putch('-', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 2d                	push   $0x2d
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ce:	f7 d8                	neg    %eax
  8009d0:	83 d2 00             	adc    $0x0,%edx
  8009d3:	f7 da                	neg    %edx
  8009d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e2:	e9 bc 00 00 00       	jmp    800aa3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ed:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f0:	50                   	push   %eax
  8009f1:	e8 84 fc ff ff       	call   80067a <getuint>
  8009f6:	83 c4 10             	add    $0x10,%esp
  8009f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a06:	e9 98 00 00 00       	jmp    800aa3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	6a 58                	push   $0x58
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	ff d0                	call   *%eax
  800a18:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 58                	push   $0x58
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	6a 58                	push   $0x58
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	ff d0                	call   *%eax
  800a38:	83 c4 10             	add    $0x10,%esp
			break;
  800a3b:	e9 bc 00 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	ff 75 0c             	pushl  0xc(%ebp)
  800a46:	6a 30                	push   $0x30
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	ff d0                	call   *%eax
  800a4d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	ff 75 0c             	pushl  0xc(%ebp)
  800a56:	6a 78                	push   $0x78
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	ff d0                	call   *%eax
  800a5d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 c0 04             	add    $0x4,%eax
  800a66:	89 45 14             	mov    %eax,0x14(%ebp)
  800a69:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6c:	83 e8 04             	sub    $0x4,%eax
  800a6f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a82:	eb 1f                	jmp    800aa3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8d:	50                   	push   %eax
  800a8e:	e8 e7 fb ff ff       	call   80067a <getuint>
  800a93:	83 c4 10             	add    $0x10,%esp
  800a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aaa:	83 ec 04             	sub    $0x4,%esp
  800aad:	52                   	push   %edx
  800aae:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab1:	50                   	push   %eax
  800ab2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	ff 75 08             	pushl  0x8(%ebp)
  800abe:	e8 00 fb ff ff       	call   8005c3 <printnum>
  800ac3:	83 c4 20             	add    $0x20,%esp
			break;
  800ac6:	eb 34                	jmp    800afc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	53                   	push   %ebx
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			break;
  800ad7:	eb 23                	jmp    800afc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	6a 25                	push   $0x25
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	ff d0                	call   *%eax
  800ae6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae9:	ff 4d 10             	decl   0x10(%ebp)
  800aec:	eb 03                	jmp    800af1 <vprintfmt+0x3b1>
  800aee:	ff 4d 10             	decl   0x10(%ebp)
  800af1:	8b 45 10             	mov    0x10(%ebp),%eax
  800af4:	48                   	dec    %eax
  800af5:	8a 00                	mov    (%eax),%al
  800af7:	3c 25                	cmp    $0x25,%al
  800af9:	75 f3                	jne    800aee <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800afb:	90                   	nop
		}
	}
  800afc:	e9 47 fc ff ff       	jmp    800748 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b01:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b05:	5b                   	pop    %ebx
  800b06:	5e                   	pop    %esi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b0f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b12:	83 c0 04             	add    $0x4,%eax
  800b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b18:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1e:	50                   	push   %eax
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	ff 75 08             	pushl  0x8(%ebp)
  800b25:	e8 16 fc ff ff       	call   800740 <vprintfmt>
  800b2a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b2d:	90                   	nop
  800b2e:	c9                   	leave  
  800b2f:	c3                   	ret    

00800b30 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8b 40 08             	mov    0x8(%eax),%eax
  800b39:	8d 50 01             	lea    0x1(%eax),%edx
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8b 10                	mov    (%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8b 40 04             	mov    0x4(%eax),%eax
  800b4d:	39 c2                	cmp    %eax,%edx
  800b4f:	73 12                	jae    800b63 <sprintputch+0x33>
		*b->buf++ = ch;
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	8d 48 01             	lea    0x1(%eax),%ecx
  800b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5c:	89 0a                	mov    %ecx,(%edx)
  800b5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b61:	88 10                	mov    %dl,(%eax)
}
  800b63:	90                   	nop
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	01 d0                	add    %edx,%eax
  800b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8b:	74 06                	je     800b93 <vsnprintf+0x2d>
  800b8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b91:	7f 07                	jg     800b9a <vsnprintf+0x34>
		return -E_INVAL;
  800b93:	b8 03 00 00 00       	mov    $0x3,%eax
  800b98:	eb 20                	jmp    800bba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9a:	ff 75 14             	pushl  0x14(%ebp)
  800b9d:	ff 75 10             	pushl  0x10(%ebp)
  800ba0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba3:	50                   	push   %eax
  800ba4:	68 30 0b 80 00       	push   $0x800b30
  800ba9:	e8 92 fb ff ff       	call   800740 <vprintfmt>
  800bae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc2:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc5:	83 c0 04             	add    $0x4,%eax
  800bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	ff 75 08             	pushl  0x8(%ebp)
  800bd8:	e8 89 ff ff ff       	call   800b66 <vsnprintf>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf5:	eb 06                	jmp    800bfd <strlen+0x15>
		n++;
  800bf7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfa:	ff 45 08             	incl   0x8(%ebp)
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	84 c0                	test   %al,%al
  800c04:	75 f1                	jne    800bf7 <strlen+0xf>
		n++;
	return n;
  800c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c18:	eb 09                	jmp    800c23 <strnlen+0x18>
		n++;
  800c1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1d:	ff 45 08             	incl   0x8(%ebp)
  800c20:	ff 4d 0c             	decl   0xc(%ebp)
  800c23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c27:	74 09                	je     800c32 <strnlen+0x27>
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8a 00                	mov    (%eax),%al
  800c2e:	84 c0                	test   %al,%al
  800c30:	75 e8                	jne    800c1a <strnlen+0xf>
		n++;
	return n;
  800c32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c43:	90                   	nop
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8d 50 01             	lea    0x1(%eax),%edx
  800c4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	75 e4                	jne    800c44 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c78:	eb 1f                	jmp    800c99 <strncpy+0x34>
		*dst++ = *src;
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8d 50 01             	lea    0x1(%eax),%edx
  800c80:	89 55 08             	mov    %edx,0x8(%ebp)
  800c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c86:	8a 12                	mov    (%edx),%dl
  800c88:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8d:	8a 00                	mov    (%eax),%al
  800c8f:	84 c0                	test   %al,%al
  800c91:	74 03                	je     800c96 <strncpy+0x31>
			src++;
  800c93:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c96:	ff 45 fc             	incl   -0x4(%ebp)
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c9f:	72 d9                	jb     800c7a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca4:	c9                   	leave  
  800ca5:	c3                   	ret    

00800ca6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb6:	74 30                	je     800ce8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cb8:	eb 16                	jmp    800cd0 <strlcpy+0x2a>
			*dst++ = *src++;
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8d 50 01             	lea    0x1(%eax),%edx
  800cc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ccc:	8a 12                	mov    (%edx),%dl
  800cce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd0:	ff 4d 10             	decl   0x10(%ebp)
  800cd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd7:	74 09                	je     800ce2 <strlcpy+0x3c>
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	84 c0                	test   %al,%al
  800ce0:	75 d8                	jne    800cba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cee:	29 c2                	sub    %eax,%edx
  800cf0:	89 d0                	mov    %edx,%eax
}
  800cf2:	c9                   	leave  
  800cf3:	c3                   	ret    

00800cf4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cf7:	eb 06                	jmp    800cff <strcmp+0xb>
		p++, q++;
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	74 0e                	je     800d16 <strcmp+0x22>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 10                	mov    (%eax),%dl
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	38 c2                	cmp    %al,%dl
  800d14:	74 e3                	je     800cf9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	0f b6 d0             	movzbl %al,%edx
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	0f b6 c0             	movzbl %al,%eax
  800d26:	29 c2                	sub    %eax,%edx
  800d28:	89 d0                	mov    %edx,%eax
}
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d2f:	eb 09                	jmp    800d3a <strncmp+0xe>
		n--, p++, q++;
  800d31:	ff 4d 10             	decl   0x10(%ebp)
  800d34:	ff 45 08             	incl   0x8(%ebp)
  800d37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3e:	74 17                	je     800d57 <strncmp+0x2b>
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	84 c0                	test   %al,%al
  800d47:	74 0e                	je     800d57 <strncmp+0x2b>
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 10                	mov    (%eax),%dl
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	38 c2                	cmp    %al,%dl
  800d55:	74 da                	je     800d31 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5b:	75 07                	jne    800d64 <strncmp+0x38>
		return 0;
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d62:	eb 14                	jmp    800d78 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	0f b6 d0             	movzbl %al,%edx
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	0f b6 c0             	movzbl %al,%eax
  800d74:	29 c2                	sub    %eax,%edx
  800d76:	89 d0                	mov    %edx,%eax
}
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 12                	jmp    800d9a <strchr+0x20>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	75 05                	jne    800d97 <strchr+0x1d>
			return (char *) s;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	eb 11                	jmp    800da8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d97:	ff 45 08             	incl   0x8(%ebp)
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	84 c0                	test   %al,%al
  800da1:	75 e5                	jne    800d88 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 04             	sub    $0x4,%esp
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db6:	eb 0d                	jmp    800dc5 <strfind+0x1b>
		if (*s == c)
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc0:	74 0e                	je     800dd0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc2:	ff 45 08             	incl   0x8(%ebp)
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	84 c0                	test   %al,%al
  800dcc:	75 ea                	jne    800db8 <strfind+0xe>
  800dce:	eb 01                	jmp    800dd1 <strfind+0x27>
		if (*s == c)
			break;
  800dd0:	90                   	nop
	return (char *) s;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de2:	8b 45 10             	mov    0x10(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800de8:	eb 0e                	jmp    800df8 <memset+0x22>
		*p++ = c;
  800dea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800df8:	ff 4d f8             	decl   -0x8(%ebp)
  800dfb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dff:	79 e9                	jns    800dea <memset+0x14>
		*p++ = c;

	return v;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e18:	eb 16                	jmp    800e30 <memcpy+0x2a>
		*d++ = *s++;
  800e1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1d:	8d 50 01             	lea    0x1(%eax),%edx
  800e20:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e29:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e2c:	8a 12                	mov    (%edx),%dl
  800e2e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e36:	89 55 10             	mov    %edx,0x10(%ebp)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	75 dd                	jne    800e1a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e57:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5a:	73 50                	jae    800eac <memmove+0x6a>
  800e5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e62:	01 d0                	add    %edx,%eax
  800e64:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e67:	76 43                	jbe    800eac <memmove+0x6a>
		s += n;
  800e69:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e72:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e75:	eb 10                	jmp    800e87 <memmove+0x45>
			*--d = *--s;
  800e77:	ff 4d f8             	decl   -0x8(%ebp)
  800e7a:	ff 4d fc             	decl   -0x4(%ebp)
  800e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e80:	8a 10                	mov    (%eax),%dl
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e90:	85 c0                	test   %eax,%eax
  800e92:	75 e3                	jne    800e77 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e94:	eb 23                	jmp    800eb9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	8d 50 01             	lea    0x1(%eax),%edx
  800e9c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea8:	8a 12                	mov    (%edx),%dl
  800eaa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eac:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	75 dd                	jne    800e96 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed0:	eb 2a                	jmp    800efc <memcmp+0x3e>
		if (*s1 != *s2)
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	8a 10                	mov    (%eax),%dl
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	38 c2                	cmp    %al,%dl
  800ede:	74 16                	je     800ef6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	0f b6 d0             	movzbl %al,%edx
  800ee8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f b6 c0             	movzbl %al,%eax
  800ef0:	29 c2                	sub    %eax,%edx
  800ef2:	89 d0                	mov    %edx,%eax
  800ef4:	eb 18                	jmp    800f0e <memcmp+0x50>
		s1++, s2++;
  800ef6:	ff 45 fc             	incl   -0x4(%ebp)
  800ef9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f02:	89 55 10             	mov    %edx,0x10(%ebp)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 c9                	jne    800ed2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0e:	c9                   	leave  
  800f0f:	c3                   	ret    

00800f10 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	01 d0                	add    %edx,%eax
  800f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f21:	eb 15                	jmp    800f38 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	0f b6 d0             	movzbl %al,%edx
  800f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2e:	0f b6 c0             	movzbl %al,%eax
  800f31:	39 c2                	cmp    %eax,%edx
  800f33:	74 0d                	je     800f42 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f35:	ff 45 08             	incl   0x8(%ebp)
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f3e:	72 e3                	jb     800f23 <memfind+0x13>
  800f40:	eb 01                	jmp    800f43 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f42:	90                   	nop
	return (void *) s;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f55:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f5c:	eb 03                	jmp    800f61 <strtol+0x19>
		s++;
  800f5e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	3c 20                	cmp    $0x20,%al
  800f68:	74 f4                	je     800f5e <strtol+0x16>
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	3c 09                	cmp    $0x9,%al
  800f71:	74 eb                	je     800f5e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	3c 2b                	cmp    $0x2b,%al
  800f7a:	75 05                	jne    800f81 <strtol+0x39>
		s++;
  800f7c:	ff 45 08             	incl   0x8(%ebp)
  800f7f:	eb 13                	jmp    800f94 <strtol+0x4c>
	else if (*s == '-')
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	3c 2d                	cmp    $0x2d,%al
  800f88:	75 0a                	jne    800f94 <strtol+0x4c>
		s++, neg = 1;
  800f8a:	ff 45 08             	incl   0x8(%ebp)
  800f8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	74 06                	je     800fa0 <strtol+0x58>
  800f9a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f9e:	75 20                	jne    800fc0 <strtol+0x78>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 30                	cmp    $0x30,%al
  800fa7:	75 17                	jne    800fc0 <strtol+0x78>
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	40                   	inc    %eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 78                	cmp    $0x78,%al
  800fb1:	75 0d                	jne    800fc0 <strtol+0x78>
		s += 2, base = 16;
  800fb3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fb7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fbe:	eb 28                	jmp    800fe8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc4:	75 15                	jne    800fdb <strtol+0x93>
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 30                	cmp    $0x30,%al
  800fcd:	75 0c                	jne    800fdb <strtol+0x93>
		s++, base = 8;
  800fcf:	ff 45 08             	incl   0x8(%ebp)
  800fd2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fd9:	eb 0d                	jmp    800fe8 <strtol+0xa0>
	else if (base == 0)
  800fdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdf:	75 07                	jne    800fe8 <strtol+0xa0>
		base = 10;
  800fe1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 2f                	cmp    $0x2f,%al
  800fef:	7e 19                	jle    80100a <strtol+0xc2>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 39                	cmp    $0x39,%al
  800ff8:	7f 10                	jg     80100a <strtol+0xc2>
			dig = *s - '0';
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 30             	sub    $0x30,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 42                	jmp    80104c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 60                	cmp    $0x60,%al
  801011:	7e 19                	jle    80102c <strtol+0xe4>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 7a                	cmp    $0x7a,%al
  80101a:	7f 10                	jg     80102c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be c0             	movsbl %al,%eax
  801024:	83 e8 57             	sub    $0x57,%eax
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102a:	eb 20                	jmp    80104c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	3c 40                	cmp    $0x40,%al
  801033:	7e 39                	jle    80106e <strtol+0x126>
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	3c 5a                	cmp    $0x5a,%al
  80103c:	7f 30                	jg     80106e <strtol+0x126>
			dig = *s - 'A' + 10;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	0f be c0             	movsbl %al,%eax
  801046:	83 e8 37             	sub    $0x37,%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80104c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80104f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801052:	7d 19                	jge    80106d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801054:	ff 45 08             	incl   0x8(%ebp)
  801057:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80105e:	89 c2                	mov    %eax,%edx
  801060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801063:	01 d0                	add    %edx,%eax
  801065:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801068:	e9 7b ff ff ff       	jmp    800fe8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80106d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80106e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801072:	74 08                	je     80107c <strtol+0x134>
		*endptr = (char *) s;
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	8b 55 08             	mov    0x8(%ebp),%edx
  80107a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80107c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801080:	74 07                	je     801089 <strtol+0x141>
  801082:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801085:	f7 d8                	neg    %eax
  801087:	eb 03                	jmp    80108c <strtol+0x144>
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <ltostr>:

void
ltostr(long value, char *str)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801094:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a6:	79 13                	jns    8010bb <ltostr+0x2d>
	{
		neg = 1;
  8010a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010b8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c3:	99                   	cltd   
  8010c4:	f7 f9                	idiv   %ecx
  8010c6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cc:	8d 50 01             	lea    0x1(%eax),%edx
  8010cf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010dc:	83 c2 30             	add    $0x30,%edx
  8010df:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e9:	f7 e9                	imul   %ecx
  8010eb:	c1 fa 02             	sar    $0x2,%edx
  8010ee:	89 c8                	mov    %ecx,%eax
  8010f0:	c1 f8 1f             	sar    $0x1f,%eax
  8010f3:	29 c2                	sub    %eax,%edx
  8010f5:	89 d0                	mov    %edx,%eax
  8010f7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010fd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801102:	f7 e9                	imul   %ecx
  801104:	c1 fa 02             	sar    $0x2,%edx
  801107:	89 c8                	mov    %ecx,%eax
  801109:	c1 f8 1f             	sar    $0x1f,%eax
  80110c:	29 c2                	sub    %eax,%edx
  80110e:	89 d0                	mov    %edx,%eax
  801110:	c1 e0 02             	shl    $0x2,%eax
  801113:	01 d0                	add    %edx,%eax
  801115:	01 c0                	add    %eax,%eax
  801117:	29 c1                	sub    %eax,%ecx
  801119:	89 ca                	mov    %ecx,%edx
  80111b:	85 d2                	test   %edx,%edx
  80111d:	75 9c                	jne    8010bb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80111f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801126:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801129:	48                   	dec    %eax
  80112a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80112d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801131:	74 3d                	je     801170 <ltostr+0xe2>
		start = 1 ;
  801133:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113a:	eb 34                	jmp    801170 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80113c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	01 d0                	add    %edx,%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	01 c2                	add    %eax,%edx
  801151:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	01 c8                	add    %ecx,%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80115d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801160:	8b 45 0c             	mov    0xc(%ebp),%eax
  801163:	01 c2                	add    %eax,%edx
  801165:	8a 45 eb             	mov    -0x15(%ebp),%al
  801168:	88 02                	mov    %al,(%edx)
		start++ ;
  80116a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80116d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801173:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801176:	7c c4                	jl     80113c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801178:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801183:	90                   	nop
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80118c:	ff 75 08             	pushl  0x8(%ebp)
  80118f:	e8 54 fa ff ff       	call   800be8 <strlen>
  801194:	83 c4 04             	add    $0x4,%esp
  801197:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119a:	ff 75 0c             	pushl  0xc(%ebp)
  80119d:	e8 46 fa ff ff       	call   800be8 <strlen>
  8011a2:	83 c4 04             	add    $0x4,%esp
  8011a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b6:	eb 17                	jmp    8011cf <strcconcat+0x49>
		final[s] = str1[s] ;
  8011b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011be:	01 c2                	add    %eax,%edx
  8011c0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	01 c8                	add    %ecx,%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011cc:	ff 45 fc             	incl   -0x4(%ebp)
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d5:	7c e1                	jl     8011b8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e5:	eb 1f                	jmp    801206 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ea:	8d 50 01             	lea    0x1(%eax),%edx
  8011ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f0:	89 c2                	mov    %eax,%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801203:	ff 45 f8             	incl   -0x8(%ebp)
  801206:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801209:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120c:	7c d9                	jl     8011e7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80120e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 d0                	add    %edx,%eax
  801216:	c6 00 00             	movb   $0x0,(%eax)
}
  801219:	90                   	nop
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80121f:	8b 45 14             	mov    0x14(%ebp),%eax
  801222:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801228:	8b 45 14             	mov    0x14(%ebp),%eax
  80122b:	8b 00                	mov    (%eax),%eax
  80122d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801234:	8b 45 10             	mov    0x10(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80123f:	eb 0c                	jmp    80124d <strsplit+0x31>
			*string++ = 0;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8d 50 01             	lea    0x1(%eax),%edx
  801247:	89 55 08             	mov    %edx,0x8(%ebp)
  80124a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	84 c0                	test   %al,%al
  801254:	74 18                	je     80126e <strsplit+0x52>
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	0f be c0             	movsbl %al,%eax
  80125e:	50                   	push   %eax
  80125f:	ff 75 0c             	pushl  0xc(%ebp)
  801262:	e8 13 fb ff ff       	call   800d7a <strchr>
  801267:	83 c4 08             	add    $0x8,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	75 d3                	jne    801241 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	84 c0                	test   %al,%al
  801275:	74 5a                	je     8012d1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801277:	8b 45 14             	mov    0x14(%ebp),%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	83 f8 0f             	cmp    $0xf,%eax
  80127f:	75 07                	jne    801288 <strsplit+0x6c>
		{
			return 0;
  801281:	b8 00 00 00 00       	mov    $0x0,%eax
  801286:	eb 66                	jmp    8012ee <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801288:	8b 45 14             	mov    0x14(%ebp),%eax
  80128b:	8b 00                	mov    (%eax),%eax
  80128d:	8d 48 01             	lea    0x1(%eax),%ecx
  801290:	8b 55 14             	mov    0x14(%ebp),%edx
  801293:	89 0a                	mov    %ecx,(%edx)
  801295:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	01 c2                	add    %eax,%edx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012a6:	eb 03                	jmp    8012ab <strsplit+0x8f>
			string++;
  8012a8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	84 c0                	test   %al,%al
  8012b2:	74 8b                	je     80123f <strsplit+0x23>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f be c0             	movsbl %al,%eax
  8012bc:	50                   	push   %eax
  8012bd:	ff 75 0c             	pushl  0xc(%ebp)
  8012c0:	e8 b5 fa ff ff       	call   800d7a <strchr>
  8012c5:	83 c4 08             	add    $0x8,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 dc                	je     8012a8 <strsplit+0x8c>
			string++;
	}
  8012cc:	e9 6e ff ff ff       	jmp    80123f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d5:	8b 00                	mov    (%eax),%eax
  8012d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	01 d0                	add    %edx,%eax
  8012e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012f6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	74 1f                	je     80131e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012ff:	e8 1d 00 00 00       	call   801321 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801304:	83 ec 0c             	sub    $0xc,%esp
  801307:	68 f0 38 80 00       	push   $0x8038f0
  80130c:	e8 55 f2 ff ff       	call   800566 <cprintf>
  801311:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801314:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80131b:	00 00 00 
	}
}
  80131e:	90                   	nop
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801327:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80132e:	00 00 00 
  801331:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801338:	00 00 00 
  80133b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801342:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801345:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80134c:	00 00 00 
  80134f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801356:	00 00 00 
  801359:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801360:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801363:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80136a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801372:	2d 00 10 00 00       	sub    $0x1000,%eax
  801377:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80137c:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801383:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801386:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80138d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801390:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801395:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801398:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80139b:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a0:	f7 75 f0             	divl   -0x10(%ebp)
  8013a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a6:	29 d0                	sub    %edx,%eax
  8013a8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8013ab:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ba:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013bf:	83 ec 04             	sub    $0x4,%esp
  8013c2:	6a 06                	push   $0x6
  8013c4:	ff 75 e8             	pushl  -0x18(%ebp)
  8013c7:	50                   	push   %eax
  8013c8:	e8 d4 05 00 00       	call   8019a1 <sys_allocate_chunk>
  8013cd:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013d0:	a1 20 41 80 00       	mov    0x804120,%eax
  8013d5:	83 ec 0c             	sub    $0xc,%esp
  8013d8:	50                   	push   %eax
  8013d9:	e8 49 0c 00 00       	call   802027 <initialize_MemBlocksList>
  8013de:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8013e1:	a1 48 41 80 00       	mov    0x804148,%eax
  8013e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8013e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013ed:	75 14                	jne    801403 <initialize_dyn_block_system+0xe2>
  8013ef:	83 ec 04             	sub    $0x4,%esp
  8013f2:	68 15 39 80 00       	push   $0x803915
  8013f7:	6a 39                	push   $0x39
  8013f9:	68 33 39 80 00       	push   $0x803933
  8013fe:	e8 d2 1b 00 00       	call   802fd5 <_panic>
  801403:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801406:	8b 00                	mov    (%eax),%eax
  801408:	85 c0                	test   %eax,%eax
  80140a:	74 10                	je     80141c <initialize_dyn_block_system+0xfb>
  80140c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80140f:	8b 00                	mov    (%eax),%eax
  801411:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801414:	8b 52 04             	mov    0x4(%edx),%edx
  801417:	89 50 04             	mov    %edx,0x4(%eax)
  80141a:	eb 0b                	jmp    801427 <initialize_dyn_block_system+0x106>
  80141c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141f:	8b 40 04             	mov    0x4(%eax),%eax
  801422:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801427:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142a:	8b 40 04             	mov    0x4(%eax),%eax
  80142d:	85 c0                	test   %eax,%eax
  80142f:	74 0f                	je     801440 <initialize_dyn_block_system+0x11f>
  801431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801434:	8b 40 04             	mov    0x4(%eax),%eax
  801437:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80143a:	8b 12                	mov    (%edx),%edx
  80143c:	89 10                	mov    %edx,(%eax)
  80143e:	eb 0a                	jmp    80144a <initialize_dyn_block_system+0x129>
  801440:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801443:	8b 00                	mov    (%eax),%eax
  801445:	a3 48 41 80 00       	mov    %eax,0x804148
  80144a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801453:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801456:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80145d:	a1 54 41 80 00       	mov    0x804154,%eax
  801462:	48                   	dec    %eax
  801463:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801468:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146b:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801472:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801475:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  80147c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801480:	75 14                	jne    801496 <initialize_dyn_block_system+0x175>
  801482:	83 ec 04             	sub    $0x4,%esp
  801485:	68 40 39 80 00       	push   $0x803940
  80148a:	6a 3f                	push   $0x3f
  80148c:	68 33 39 80 00       	push   $0x803933
  801491:	e8 3f 1b 00 00       	call   802fd5 <_panic>
  801496:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80149c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149f:	89 10                	mov    %edx,(%eax)
  8014a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a4:	8b 00                	mov    (%eax),%eax
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	74 0d                	je     8014b7 <initialize_dyn_block_system+0x196>
  8014aa:	a1 38 41 80 00       	mov    0x804138,%eax
  8014af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014b2:	89 50 04             	mov    %edx,0x4(%eax)
  8014b5:	eb 08                	jmp    8014bf <initialize_dyn_block_system+0x19e>
  8014b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ba:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c2:	a3 38 41 80 00       	mov    %eax,0x804138
  8014c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014d1:	a1 44 41 80 00       	mov    0x804144,%eax
  8014d6:	40                   	inc    %eax
  8014d7:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8014dc:	90                   	nop
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014e5:	e8 06 fe ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014ee:	75 07                	jne    8014f7 <malloc+0x18>
  8014f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f5:	eb 7d                	jmp    801574 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8014f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8014fe:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801505:	8b 55 08             	mov    0x8(%ebp),%edx
  801508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150b:	01 d0                	add    %edx,%eax
  80150d:	48                   	dec    %eax
  80150e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801511:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801514:	ba 00 00 00 00       	mov    $0x0,%edx
  801519:	f7 75 f0             	divl   -0x10(%ebp)
  80151c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80151f:	29 d0                	sub    %edx,%eax
  801521:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801524:	e8 46 08 00 00       	call   801d6f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801529:	83 f8 01             	cmp    $0x1,%eax
  80152c:	75 07                	jne    801535 <malloc+0x56>
  80152e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801535:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801539:	75 34                	jne    80156f <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  80153b:	83 ec 0c             	sub    $0xc,%esp
  80153e:	ff 75 e8             	pushl  -0x18(%ebp)
  801541:	e8 73 0e 00 00       	call   8023b9 <alloc_block_FF>
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  80154c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801550:	74 16                	je     801568 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801552:	83 ec 0c             	sub    $0xc,%esp
  801555:	ff 75 e4             	pushl  -0x1c(%ebp)
  801558:	e8 ff 0b 00 00       	call   80215c <insert_sorted_allocList>
  80155d:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801560:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801563:	8b 40 08             	mov    0x8(%eax),%eax
  801566:	eb 0c                	jmp    801574 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801568:	b8 00 00 00 00       	mov    $0x0,%eax
  80156d:	eb 05                	jmp    801574 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80156f:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801585:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801590:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801593:	83 ec 08             	sub    $0x8,%esp
  801596:	ff 75 f4             	pushl  -0xc(%ebp)
  801599:	68 40 40 80 00       	push   $0x804040
  80159e:	e8 61 0b 00 00       	call   802104 <find_block>
  8015a3:	83 c4 10             	add    $0x10,%esp
  8015a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8015a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015ad:	0f 84 a5 00 00 00    	je     801658 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8015b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8015b9:	83 ec 08             	sub    $0x8,%esp
  8015bc:	50                   	push   %eax
  8015bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c0:	e8 a4 03 00 00       	call   801969 <sys_free_user_mem>
  8015c5:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8015c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015cc:	75 17                	jne    8015e5 <free+0x6f>
  8015ce:	83 ec 04             	sub    $0x4,%esp
  8015d1:	68 15 39 80 00       	push   $0x803915
  8015d6:	68 87 00 00 00       	push   $0x87
  8015db:	68 33 39 80 00       	push   $0x803933
  8015e0:	e8 f0 19 00 00       	call   802fd5 <_panic>
  8015e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e8:	8b 00                	mov    (%eax),%eax
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	74 10                	je     8015fe <free+0x88>
  8015ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f1:	8b 00                	mov    (%eax),%eax
  8015f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015f6:	8b 52 04             	mov    0x4(%edx),%edx
  8015f9:	89 50 04             	mov    %edx,0x4(%eax)
  8015fc:	eb 0b                	jmp    801609 <free+0x93>
  8015fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801601:	8b 40 04             	mov    0x4(%eax),%eax
  801604:	a3 44 40 80 00       	mov    %eax,0x804044
  801609:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80160c:	8b 40 04             	mov    0x4(%eax),%eax
  80160f:	85 c0                	test   %eax,%eax
  801611:	74 0f                	je     801622 <free+0xac>
  801613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801616:	8b 40 04             	mov    0x4(%eax),%eax
  801619:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80161c:	8b 12                	mov    (%edx),%edx
  80161e:	89 10                	mov    %edx,(%eax)
  801620:	eb 0a                	jmp    80162c <free+0xb6>
  801622:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801625:	8b 00                	mov    (%eax),%eax
  801627:	a3 40 40 80 00       	mov    %eax,0x804040
  80162c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801638:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80163f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801644:	48                   	dec    %eax
  801645:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  80164a:	83 ec 0c             	sub    $0xc,%esp
  80164d:	ff 75 ec             	pushl  -0x14(%ebp)
  801650:	e8 37 12 00 00       	call   80288c <insert_sorted_with_merge_freeList>
  801655:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801658:	90                   	nop
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 38             	sub    $0x38,%esp
  801661:	8b 45 10             	mov    0x10(%ebp),%eax
  801664:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801667:	e8 84 fc ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  80166c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801670:	75 07                	jne    801679 <smalloc+0x1e>
  801672:	b8 00 00 00 00       	mov    $0x0,%eax
  801677:	eb 7e                	jmp    8016f7 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801679:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801680:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801687:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168d:	01 d0                	add    %edx,%eax
  80168f:	48                   	dec    %eax
  801690:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801693:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801696:	ba 00 00 00 00       	mov    $0x0,%edx
  80169b:	f7 75 f0             	divl   -0x10(%ebp)
  80169e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a1:	29 d0                	sub    %edx,%eax
  8016a3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8016a6:	e8 c4 06 00 00       	call   801d6f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ab:	83 f8 01             	cmp    $0x1,%eax
  8016ae:	75 42                	jne    8016f2 <smalloc+0x97>

		  va = malloc(newsize) ;
  8016b0:	83 ec 0c             	sub    $0xc,%esp
  8016b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8016b6:	e8 24 fe ff ff       	call   8014df <malloc>
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8016c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016c5:	74 24                	je     8016eb <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8016c7:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016ce:	50                   	push   %eax
  8016cf:	ff 75 e8             	pushl  -0x18(%ebp)
  8016d2:	ff 75 08             	pushl  0x8(%ebp)
  8016d5:	e8 1a 04 00 00       	call   801af4 <sys_createSharedObject>
  8016da:	83 c4 10             	add    $0x10,%esp
  8016dd:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8016e0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016e4:	78 0c                	js     8016f2 <smalloc+0x97>
					  return va ;
  8016e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016e9:	eb 0c                	jmp    8016f7 <smalloc+0x9c>
				 }
				 else
					return NULL;
  8016eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f0:	eb 05                	jmp    8016f7 <smalloc+0x9c>
	  }
		  return NULL ;
  8016f2:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ff:	e8 ec fb ff ff       	call   8012f0 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801704:	83 ec 08             	sub    $0x8,%esp
  801707:	ff 75 0c             	pushl  0xc(%ebp)
  80170a:	ff 75 08             	pushl  0x8(%ebp)
  80170d:	e8 0c 04 00 00       	call   801b1e <sys_getSizeOfSharedObject>
  801712:	83 c4 10             	add    $0x10,%esp
  801715:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801718:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80171c:	75 07                	jne    801725 <sget+0x2c>
  80171e:	b8 00 00 00 00       	mov    $0x0,%eax
  801723:	eb 75                	jmp    80179a <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801725:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80172c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80172f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801732:	01 d0                	add    %edx,%eax
  801734:	48                   	dec    %eax
  801735:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173b:	ba 00 00 00 00       	mov    $0x0,%edx
  801740:	f7 75 f0             	divl   -0x10(%ebp)
  801743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801746:	29 d0                	sub    %edx,%eax
  801748:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  80174b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801752:	e8 18 06 00 00       	call   801d6f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801757:	83 f8 01             	cmp    $0x1,%eax
  80175a:	75 39                	jne    801795 <sget+0x9c>

		  va = malloc(newsize) ;
  80175c:	83 ec 0c             	sub    $0xc,%esp
  80175f:	ff 75 e8             	pushl  -0x18(%ebp)
  801762:	e8 78 fd ff ff       	call   8014df <malloc>
  801767:	83 c4 10             	add    $0x10,%esp
  80176a:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  80176d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801771:	74 22                	je     801795 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801773:	83 ec 04             	sub    $0x4,%esp
  801776:	ff 75 e0             	pushl  -0x20(%ebp)
  801779:	ff 75 0c             	pushl  0xc(%ebp)
  80177c:	ff 75 08             	pushl  0x8(%ebp)
  80177f:	e8 b7 03 00 00       	call   801b3b <sys_getSharedObject>
  801784:	83 c4 10             	add    $0x10,%esp
  801787:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  80178a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80178e:	78 05                	js     801795 <sget+0x9c>
					  return va;
  801790:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801793:	eb 05                	jmp    80179a <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017a2:	e8 49 fb ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	68 64 39 80 00       	push   $0x803964
  8017af:	68 1e 01 00 00       	push   $0x11e
  8017b4:	68 33 39 80 00       	push   $0x803933
  8017b9:	e8 17 18 00 00       	call   802fd5 <_panic>

008017be <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	68 8c 39 80 00       	push   $0x80398c
  8017cc:	68 32 01 00 00       	push   $0x132
  8017d1:	68 33 39 80 00       	push   $0x803933
  8017d6:	e8 fa 17 00 00       	call   802fd5 <_panic>

008017db <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	68 b0 39 80 00       	push   $0x8039b0
  8017e9:	68 3d 01 00 00       	push   $0x13d
  8017ee:	68 33 39 80 00       	push   $0x803933
  8017f3:	e8 dd 17 00 00       	call   802fd5 <_panic>

008017f8 <shrink>:

}
void shrink(uint32 newSize)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017fe:	83 ec 04             	sub    $0x4,%esp
  801801:	68 b0 39 80 00       	push   $0x8039b0
  801806:	68 42 01 00 00       	push   $0x142
  80180b:	68 33 39 80 00       	push   $0x803933
  801810:	e8 c0 17 00 00       	call   802fd5 <_panic>

00801815 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80181b:	83 ec 04             	sub    $0x4,%esp
  80181e:	68 b0 39 80 00       	push   $0x8039b0
  801823:	68 47 01 00 00       	push   $0x147
  801828:	68 33 39 80 00       	push   $0x803933
  80182d:	e8 a3 17 00 00       	call   802fd5 <_panic>

00801832 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	57                   	push   %edi
  801836:	56                   	push   %esi
  801837:	53                   	push   %ebx
  801838:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801841:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801844:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801847:	8b 7d 18             	mov    0x18(%ebp),%edi
  80184a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80184d:	cd 30                	int    $0x30
  80184f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801852:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	5b                   	pop    %ebx
  801859:	5e                   	pop    %esi
  80185a:	5f                   	pop    %edi
  80185b:	5d                   	pop    %ebp
  80185c:	c3                   	ret    

0080185d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 04             	sub    $0x4,%esp
  801863:	8b 45 10             	mov    0x10(%ebp),%eax
  801866:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801869:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	52                   	push   %edx
  801875:	ff 75 0c             	pushl  0xc(%ebp)
  801878:	50                   	push   %eax
  801879:	6a 00                	push   $0x0
  80187b:	e8 b2 ff ff ff       	call   801832 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
}
  801883:	90                   	nop
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_cgetc>:

int
sys_cgetc(void)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 01                	push   $0x1
  801895:	e8 98 ff ff ff       	call   801832 <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	52                   	push   %edx
  8018af:	50                   	push   %eax
  8018b0:	6a 05                	push   $0x5
  8018b2:	e8 7b ff ff ff       	call   801832 <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	56                   	push   %esi
  8018c0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c1:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	56                   	push   %esi
  8018d1:	53                   	push   %ebx
  8018d2:	51                   	push   %ecx
  8018d3:	52                   	push   %edx
  8018d4:	50                   	push   %eax
  8018d5:	6a 06                	push   $0x6
  8018d7:	e8 56 ff ff ff       	call   801832 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    

008018e6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	52                   	push   %edx
  8018f6:	50                   	push   %eax
  8018f7:	6a 07                	push   $0x7
  8018f9:	e8 34 ff ff ff       	call   801832 <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	ff 75 0c             	pushl  0xc(%ebp)
  80190f:	ff 75 08             	pushl  0x8(%ebp)
  801912:	6a 08                	push   $0x8
  801914:	e8 19 ff ff ff       	call   801832 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 09                	push   $0x9
  80192d:	e8 00 ff ff ff       	call   801832 <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 0a                	push   $0xa
  801946:	e8 e7 fe ff ff       	call   801832 <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 0b                	push   $0xb
  80195f:	e8 ce fe ff ff       	call   801832 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	ff 75 08             	pushl  0x8(%ebp)
  801978:	6a 0f                	push   $0xf
  80197a:	e8 b3 fe ff ff       	call   801832 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
	return;
  801982:	90                   	nop
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	ff 75 08             	pushl  0x8(%ebp)
  801994:	6a 10                	push   $0x10
  801996:	e8 97 fe ff ff       	call   801832 <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
	return ;
  80199e:	90                   	nop
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	ff 75 10             	pushl  0x10(%ebp)
  8019ab:	ff 75 0c             	pushl  0xc(%ebp)
  8019ae:	ff 75 08             	pushl  0x8(%ebp)
  8019b1:	6a 11                	push   $0x11
  8019b3:	e8 7a fe ff ff       	call   801832 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bb:	90                   	nop
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 0c                	push   $0xc
  8019cd:	e8 60 fe ff ff       	call   801832 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	ff 75 08             	pushl  0x8(%ebp)
  8019e5:	6a 0d                	push   $0xd
  8019e7:	e8 46 fe ff ff       	call   801832 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 0e                	push   $0xe
  801a00:	e8 2d fe ff ff       	call   801832 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	90                   	nop
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 13                	push   $0x13
  801a1a:	e8 13 fe ff ff       	call   801832 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	90                   	nop
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 14                	push   $0x14
  801a34:	e8 f9 fd ff ff       	call   801832 <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	90                   	nop
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_cputc>:


void
sys_cputc(const char c)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a4b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	50                   	push   %eax
  801a58:	6a 15                	push   $0x15
  801a5a:	e8 d3 fd ff ff       	call   801832 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	90                   	nop
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 16                	push   $0x16
  801a74:	e8 b9 fd ff ff       	call   801832 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	90                   	nop
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	50                   	push   %eax
  801a8f:	6a 17                	push   $0x17
  801a91:	e8 9c fd ff ff       	call   801832 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	52                   	push   %edx
  801aab:	50                   	push   %eax
  801aac:	6a 1a                	push   $0x1a
  801aae:	e8 7f fd ff ff       	call   801832 <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	52                   	push   %edx
  801ac8:	50                   	push   %eax
  801ac9:	6a 18                	push   $0x18
  801acb:	e8 62 fd ff ff       	call   801832 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	90                   	nop
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	52                   	push   %edx
  801ae6:	50                   	push   %eax
  801ae7:	6a 19                	push   $0x19
  801ae9:	e8 44 fd ff ff       	call   801832 <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
}
  801af1:	90                   	nop
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	83 ec 04             	sub    $0x4,%esp
  801afa:	8b 45 10             	mov    0x10(%ebp),%eax
  801afd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b00:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b03:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	6a 00                	push   $0x0
  801b0c:	51                   	push   %ecx
  801b0d:	52                   	push   %edx
  801b0e:	ff 75 0c             	pushl  0xc(%ebp)
  801b11:	50                   	push   %eax
  801b12:	6a 1b                	push   $0x1b
  801b14:	e8 19 fd ff ff       	call   801832 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	52                   	push   %edx
  801b2e:	50                   	push   %eax
  801b2f:	6a 1c                	push   $0x1c
  801b31:	e8 fc fc ff ff       	call   801832 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	51                   	push   %ecx
  801b4c:	52                   	push   %edx
  801b4d:	50                   	push   %eax
  801b4e:	6a 1d                	push   $0x1d
  801b50:	e8 dd fc ff ff       	call   801832 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	52                   	push   %edx
  801b6a:	50                   	push   %eax
  801b6b:	6a 1e                	push   $0x1e
  801b6d:	e8 c0 fc ff ff       	call   801832 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 1f                	push   $0x1f
  801b86:	e8 a7 fc ff ff       	call   801832 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	6a 00                	push   $0x0
  801b98:	ff 75 14             	pushl  0x14(%ebp)
  801b9b:	ff 75 10             	pushl  0x10(%ebp)
  801b9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ba1:	50                   	push   %eax
  801ba2:	6a 20                	push   $0x20
  801ba4:	e8 89 fc ff ff       	call   801832 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	50                   	push   %eax
  801bbd:	6a 21                	push   $0x21
  801bbf:	e8 6e fc ff ff       	call   801832 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	90                   	nop
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	50                   	push   %eax
  801bd9:	6a 22                	push   $0x22
  801bdb:	e8 52 fc ff ff       	call   801832 <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 02                	push   $0x2
  801bf4:	e8 39 fc ff ff       	call   801832 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 03                	push   $0x3
  801c0d:	e8 20 fc ff ff       	call   801832 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 04                	push   $0x4
  801c26:	e8 07 fc ff ff       	call   801832 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_exit_env>:


void sys_exit_env(void)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 23                	push   $0x23
  801c3f:	e8 ee fb ff ff       	call   801832 <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	90                   	nop
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c50:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c53:	8d 50 04             	lea    0x4(%eax),%edx
  801c56:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	52                   	push   %edx
  801c60:	50                   	push   %eax
  801c61:	6a 24                	push   $0x24
  801c63:	e8 ca fb ff ff       	call   801832 <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
	return result;
  801c6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c74:	89 01                	mov    %eax,(%ecx)
  801c76:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	c9                   	leave  
  801c7d:	c2 04 00             	ret    $0x4

00801c80 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	ff 75 10             	pushl  0x10(%ebp)
  801c8a:	ff 75 0c             	pushl  0xc(%ebp)
  801c8d:	ff 75 08             	pushl  0x8(%ebp)
  801c90:	6a 12                	push   $0x12
  801c92:	e8 9b fb ff ff       	call   801832 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9a:	90                   	nop
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_rcr2>:
uint32 sys_rcr2()
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 25                	push   $0x25
  801cac:	e8 81 fb ff ff       	call   801832 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 04             	sub    $0x4,%esp
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cc2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	50                   	push   %eax
  801ccf:	6a 26                	push   $0x26
  801cd1:	e8 5c fb ff ff       	call   801832 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd9:	90                   	nop
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <rsttst>:
void rsttst()
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 28                	push   $0x28
  801ceb:	e8 42 fb ff ff       	call   801832 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf3:	90                   	nop
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 04             	sub    $0x4,%esp
  801cfc:	8b 45 14             	mov    0x14(%ebp),%eax
  801cff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d02:	8b 55 18             	mov    0x18(%ebp),%edx
  801d05:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d09:	52                   	push   %edx
  801d0a:	50                   	push   %eax
  801d0b:	ff 75 10             	pushl  0x10(%ebp)
  801d0e:	ff 75 0c             	pushl  0xc(%ebp)
  801d11:	ff 75 08             	pushl  0x8(%ebp)
  801d14:	6a 27                	push   $0x27
  801d16:	e8 17 fb ff ff       	call   801832 <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1e:	90                   	nop
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <chktst>:
void chktst(uint32 n)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	ff 75 08             	pushl  0x8(%ebp)
  801d2f:	6a 29                	push   $0x29
  801d31:	e8 fc fa ff ff       	call   801832 <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
	return ;
  801d39:	90                   	nop
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <inctst>:

void inctst()
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 2a                	push   $0x2a
  801d4b:	e8 e2 fa ff ff       	call   801832 <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
	return ;
  801d53:	90                   	nop
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <gettst>:
uint32 gettst()
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 2b                	push   $0x2b
  801d65:	e8 c8 fa ff ff       	call   801832 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
  801d72:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 2c                	push   $0x2c
  801d81:	e8 ac fa ff ff       	call   801832 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
  801d89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d8c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d90:	75 07                	jne    801d99 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d92:	b8 01 00 00 00       	mov    $0x1,%eax
  801d97:	eb 05                	jmp    801d9e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 2c                	push   $0x2c
  801db2:	e8 7b fa ff ff       	call   801832 <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
  801dba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dbd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dc1:	75 07                	jne    801dca <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dc3:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc8:	eb 05                	jmp    801dcf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 2c                	push   $0x2c
  801de3:	e8 4a fa ff ff       	call   801832 <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
  801deb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dee:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801df2:	75 07                	jne    801dfb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801df4:	b8 01 00 00 00       	mov    $0x1,%eax
  801df9:	eb 05                	jmp    801e00 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 2c                	push   $0x2c
  801e14:	e8 19 fa ff ff       	call   801832 <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
  801e1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e1f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e23:	75 07                	jne    801e2c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e25:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2a:	eb 05                	jmp    801e31 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	ff 75 08             	pushl  0x8(%ebp)
  801e41:	6a 2d                	push   $0x2d
  801e43:	e8 ea f9 ff ff       	call   801832 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4b:	90                   	nop
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e52:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e55:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	6a 00                	push   $0x0
  801e60:	53                   	push   %ebx
  801e61:	51                   	push   %ecx
  801e62:	52                   	push   %edx
  801e63:	50                   	push   %eax
  801e64:	6a 2e                	push   $0x2e
  801e66:	e8 c7 f9 ff ff       	call   801832 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
}
  801e6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	52                   	push   %edx
  801e83:	50                   	push   %eax
  801e84:	6a 2f                	push   $0x2f
  801e86:	e8 a7 f9 ff ff       	call   801832 <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	68 c0 39 80 00       	push   $0x8039c0
  801e9e:	e8 c3 e6 ff ff       	call   800566 <cprintf>
  801ea3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ea6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ead:	83 ec 0c             	sub    $0xc,%esp
  801eb0:	68 ec 39 80 00       	push   $0x8039ec
  801eb5:	e8 ac e6 ff ff       	call   800566 <cprintf>
  801eba:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ebd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec1:	a1 38 41 80 00       	mov    0x804138,%eax
  801ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec9:	eb 56                	jmp    801f21 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ecb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ecf:	74 1c                	je     801eed <print_mem_block_lists+0x5d>
  801ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed4:	8b 50 08             	mov    0x8(%eax),%edx
  801ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eda:	8b 48 08             	mov    0x8(%eax),%ecx
  801edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee3:	01 c8                	add    %ecx,%eax
  801ee5:	39 c2                	cmp    %eax,%edx
  801ee7:	73 04                	jae    801eed <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ee9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef0:	8b 50 08             	mov    0x8(%eax),%edx
  801ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef9:	01 c2                	add    %eax,%edx
  801efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efe:	8b 40 08             	mov    0x8(%eax),%eax
  801f01:	83 ec 04             	sub    $0x4,%esp
  801f04:	52                   	push   %edx
  801f05:	50                   	push   %eax
  801f06:	68 01 3a 80 00       	push   $0x803a01
  801f0b:	e8 56 e6 ff ff       	call   800566 <cprintf>
  801f10:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f19:	a1 40 41 80 00       	mov    0x804140,%eax
  801f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f25:	74 07                	je     801f2e <print_mem_block_lists+0x9e>
  801f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2a:	8b 00                	mov    (%eax),%eax
  801f2c:	eb 05                	jmp    801f33 <print_mem_block_lists+0xa3>
  801f2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f33:	a3 40 41 80 00       	mov    %eax,0x804140
  801f38:	a1 40 41 80 00       	mov    0x804140,%eax
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	75 8a                	jne    801ecb <print_mem_block_lists+0x3b>
  801f41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f45:	75 84                	jne    801ecb <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f47:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f4b:	75 10                	jne    801f5d <print_mem_block_lists+0xcd>
  801f4d:	83 ec 0c             	sub    $0xc,%esp
  801f50:	68 10 3a 80 00       	push   $0x803a10
  801f55:	e8 0c e6 ff ff       	call   800566 <cprintf>
  801f5a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f5d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f64:	83 ec 0c             	sub    $0xc,%esp
  801f67:	68 34 3a 80 00       	push   $0x803a34
  801f6c:	e8 f5 e5 ff ff       	call   800566 <cprintf>
  801f71:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f74:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f78:	a1 40 40 80 00       	mov    0x804040,%eax
  801f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f80:	eb 56                	jmp    801fd8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f86:	74 1c                	je     801fa4 <print_mem_block_lists+0x114>
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	8b 50 08             	mov    0x8(%eax),%edx
  801f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f91:	8b 48 08             	mov    0x8(%eax),%ecx
  801f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f97:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9a:	01 c8                	add    %ecx,%eax
  801f9c:	39 c2                	cmp    %eax,%edx
  801f9e:	73 04                	jae    801fa4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fa0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa7:	8b 50 08             	mov    0x8(%eax),%edx
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb0:	01 c2                	add    %eax,%edx
  801fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb5:	8b 40 08             	mov    0x8(%eax),%eax
  801fb8:	83 ec 04             	sub    $0x4,%esp
  801fbb:	52                   	push   %edx
  801fbc:	50                   	push   %eax
  801fbd:	68 01 3a 80 00       	push   $0x803a01
  801fc2:	e8 9f e5 ff ff       	call   800566 <cprintf>
  801fc7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd0:	a1 48 40 80 00       	mov    0x804048,%eax
  801fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fdc:	74 07                	je     801fe5 <print_mem_block_lists+0x155>
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	8b 00                	mov    (%eax),%eax
  801fe3:	eb 05                	jmp    801fea <print_mem_block_lists+0x15a>
  801fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fea:	a3 48 40 80 00       	mov    %eax,0x804048
  801fef:	a1 48 40 80 00       	mov    0x804048,%eax
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	75 8a                	jne    801f82 <print_mem_block_lists+0xf2>
  801ff8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ffc:	75 84                	jne    801f82 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ffe:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802002:	75 10                	jne    802014 <print_mem_block_lists+0x184>
  802004:	83 ec 0c             	sub    $0xc,%esp
  802007:	68 4c 3a 80 00       	push   $0x803a4c
  80200c:	e8 55 e5 ff ff       	call   800566 <cprintf>
  802011:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802014:	83 ec 0c             	sub    $0xc,%esp
  802017:	68 c0 39 80 00       	push   $0x8039c0
  80201c:	e8 45 e5 ff ff       	call   800566 <cprintf>
  802021:	83 c4 10             	add    $0x10,%esp

}
  802024:	90                   	nop
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  80202d:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802034:	00 00 00 
  802037:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80203e:	00 00 00 
  802041:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802048:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80204b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802052:	e9 9e 00 00 00       	jmp    8020f5 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802057:	a1 50 40 80 00       	mov    0x804050,%eax
  80205c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80205f:	c1 e2 04             	shl    $0x4,%edx
  802062:	01 d0                	add    %edx,%eax
  802064:	85 c0                	test   %eax,%eax
  802066:	75 14                	jne    80207c <initialize_MemBlocksList+0x55>
  802068:	83 ec 04             	sub    $0x4,%esp
  80206b:	68 74 3a 80 00       	push   $0x803a74
  802070:	6a 47                	push   $0x47
  802072:	68 97 3a 80 00       	push   $0x803a97
  802077:	e8 59 0f 00 00       	call   802fd5 <_panic>
  80207c:	a1 50 40 80 00       	mov    0x804050,%eax
  802081:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802084:	c1 e2 04             	shl    $0x4,%edx
  802087:	01 d0                	add    %edx,%eax
  802089:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80208f:	89 10                	mov    %edx,(%eax)
  802091:	8b 00                	mov    (%eax),%eax
  802093:	85 c0                	test   %eax,%eax
  802095:	74 18                	je     8020af <initialize_MemBlocksList+0x88>
  802097:	a1 48 41 80 00       	mov    0x804148,%eax
  80209c:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020a2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020a5:	c1 e1 04             	shl    $0x4,%ecx
  8020a8:	01 ca                	add    %ecx,%edx
  8020aa:	89 50 04             	mov    %edx,0x4(%eax)
  8020ad:	eb 12                	jmp    8020c1 <initialize_MemBlocksList+0x9a>
  8020af:	a1 50 40 80 00       	mov    0x804050,%eax
  8020b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b7:	c1 e2 04             	shl    $0x4,%edx
  8020ba:	01 d0                	add    %edx,%eax
  8020bc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020c1:	a1 50 40 80 00       	mov    0x804050,%eax
  8020c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c9:	c1 e2 04             	shl    $0x4,%edx
  8020cc:	01 d0                	add    %edx,%eax
  8020ce:	a3 48 41 80 00       	mov    %eax,0x804148
  8020d3:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020db:	c1 e2 04             	shl    $0x4,%edx
  8020de:	01 d0                	add    %edx,%eax
  8020e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020e7:	a1 54 41 80 00       	mov    0x804154,%eax
  8020ec:	40                   	inc    %eax
  8020ed:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8020f2:	ff 45 f4             	incl   -0xc(%ebp)
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020fb:	0f 82 56 ff ff ff    	jb     802057 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802101:	90                   	nop
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	8b 00                	mov    (%eax),%eax
  80210f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802112:	eb 19                	jmp    80212d <find_block+0x29>
	{
		if(element->sva == va){
  802114:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802117:	8b 40 08             	mov    0x8(%eax),%eax
  80211a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80211d:	75 05                	jne    802124 <find_block+0x20>
			 		return element;
  80211f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802122:	eb 36                	jmp    80215a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	8b 40 08             	mov    0x8(%eax),%eax
  80212a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80212d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802131:	74 07                	je     80213a <find_block+0x36>
  802133:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802136:	8b 00                	mov    (%eax),%eax
  802138:	eb 05                	jmp    80213f <find_block+0x3b>
  80213a:	b8 00 00 00 00       	mov    $0x0,%eax
  80213f:	8b 55 08             	mov    0x8(%ebp),%edx
  802142:	89 42 08             	mov    %eax,0x8(%edx)
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	8b 40 08             	mov    0x8(%eax),%eax
  80214b:	85 c0                	test   %eax,%eax
  80214d:	75 c5                	jne    802114 <find_block+0x10>
  80214f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802153:	75 bf                	jne    802114 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802155:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802162:	a1 44 40 80 00       	mov    0x804044,%eax
  802167:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  80216a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80216f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802172:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802176:	74 0a                	je     802182 <insert_sorted_allocList+0x26>
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	8b 40 08             	mov    0x8(%eax),%eax
  80217e:	85 c0                	test   %eax,%eax
  802180:	75 65                	jne    8021e7 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802182:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802186:	75 14                	jne    80219c <insert_sorted_allocList+0x40>
  802188:	83 ec 04             	sub    $0x4,%esp
  80218b:	68 74 3a 80 00       	push   $0x803a74
  802190:	6a 6e                	push   $0x6e
  802192:	68 97 3a 80 00       	push   $0x803a97
  802197:	e8 39 0e 00 00       	call   802fd5 <_panic>
  80219c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	89 10                	mov    %edx,(%eax)
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	8b 00                	mov    (%eax),%eax
  8021ac:	85 c0                	test   %eax,%eax
  8021ae:	74 0d                	je     8021bd <insert_sorted_allocList+0x61>
  8021b0:	a1 40 40 80 00       	mov    0x804040,%eax
  8021b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b8:	89 50 04             	mov    %edx,0x4(%eax)
  8021bb:	eb 08                	jmp    8021c5 <insert_sorted_allocList+0x69>
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	a3 44 40 80 00       	mov    %eax,0x804044
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	a3 40 40 80 00       	mov    %eax,0x804040
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021dc:	40                   	inc    %eax
  8021dd:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021e2:	e9 cf 01 00 00       	jmp    8023b6 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8021e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ea:	8b 50 08             	mov    0x8(%eax),%edx
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	8b 40 08             	mov    0x8(%eax),%eax
  8021f3:	39 c2                	cmp    %eax,%edx
  8021f5:	73 65                	jae    80225c <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021fb:	75 14                	jne    802211 <insert_sorted_allocList+0xb5>
  8021fd:	83 ec 04             	sub    $0x4,%esp
  802200:	68 b0 3a 80 00       	push   $0x803ab0
  802205:	6a 72                	push   $0x72
  802207:	68 97 3a 80 00       	push   $0x803a97
  80220c:	e8 c4 0d 00 00       	call   802fd5 <_panic>
  802211:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	89 50 04             	mov    %edx,0x4(%eax)
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	8b 40 04             	mov    0x4(%eax),%eax
  802223:	85 c0                	test   %eax,%eax
  802225:	74 0c                	je     802233 <insert_sorted_allocList+0xd7>
  802227:	a1 44 40 80 00       	mov    0x804044,%eax
  80222c:	8b 55 08             	mov    0x8(%ebp),%edx
  80222f:	89 10                	mov    %edx,(%eax)
  802231:	eb 08                	jmp    80223b <insert_sorted_allocList+0xdf>
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	a3 40 40 80 00       	mov    %eax,0x804040
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	a3 44 40 80 00       	mov    %eax,0x804044
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80224c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802251:	40                   	inc    %eax
  802252:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802257:	e9 5a 01 00 00       	jmp    8023b6 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  80225c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225f:	8b 50 08             	mov    0x8(%eax),%edx
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	8b 40 08             	mov    0x8(%eax),%eax
  802268:	39 c2                	cmp    %eax,%edx
  80226a:	75 70                	jne    8022dc <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  80226c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802270:	74 06                	je     802278 <insert_sorted_allocList+0x11c>
  802272:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802276:	75 14                	jne    80228c <insert_sorted_allocList+0x130>
  802278:	83 ec 04             	sub    $0x4,%esp
  80227b:	68 d4 3a 80 00       	push   $0x803ad4
  802280:	6a 75                	push   $0x75
  802282:	68 97 3a 80 00       	push   $0x803a97
  802287:	e8 49 0d 00 00       	call   802fd5 <_panic>
  80228c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228f:	8b 10                	mov    (%eax),%edx
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	89 10                	mov    %edx,(%eax)
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	8b 00                	mov    (%eax),%eax
  80229b:	85 c0                	test   %eax,%eax
  80229d:	74 0b                	je     8022aa <insert_sorted_allocList+0x14e>
  80229f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a2:	8b 00                	mov    (%eax),%eax
  8022a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a7:	89 50 04             	mov    %edx,0x4(%eax)
  8022aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b0:	89 10                	mov    %edx,(%eax)
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022b8:	89 50 04             	mov    %edx,0x4(%eax)
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	8b 00                	mov    (%eax),%eax
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	75 08                	jne    8022cc <insert_sorted_allocList+0x170>
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	a3 44 40 80 00       	mov    %eax,0x804044
  8022cc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022d1:	40                   	inc    %eax
  8022d2:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8022d7:	e9 da 00 00 00       	jmp    8023b6 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8022dc:	a1 40 40 80 00       	mov    0x804040,%eax
  8022e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e4:	e9 9d 00 00 00       	jmp    802386 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	8b 00                	mov    (%eax),%eax
  8022ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	8b 50 08             	mov    0x8(%eax),%edx
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	8b 40 08             	mov    0x8(%eax),%eax
  8022fd:	39 c2                	cmp    %eax,%edx
  8022ff:	76 7d                	jbe    80237e <insert_sorted_allocList+0x222>
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	8b 50 08             	mov    0x8(%eax),%edx
  802307:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80230a:	8b 40 08             	mov    0x8(%eax),%eax
  80230d:	39 c2                	cmp    %eax,%edx
  80230f:	73 6d                	jae    80237e <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802311:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802315:	74 06                	je     80231d <insert_sorted_allocList+0x1c1>
  802317:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80231b:	75 14                	jne    802331 <insert_sorted_allocList+0x1d5>
  80231d:	83 ec 04             	sub    $0x4,%esp
  802320:	68 d4 3a 80 00       	push   $0x803ad4
  802325:	6a 7c                	push   $0x7c
  802327:	68 97 3a 80 00       	push   $0x803a97
  80232c:	e8 a4 0c 00 00       	call   802fd5 <_panic>
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	8b 10                	mov    (%eax),%edx
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	89 10                	mov    %edx,(%eax)
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	8b 00                	mov    (%eax),%eax
  802340:	85 c0                	test   %eax,%eax
  802342:	74 0b                	je     80234f <insert_sorted_allocList+0x1f3>
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	8b 55 08             	mov    0x8(%ebp),%edx
  80234c:	89 50 04             	mov    %edx,0x4(%eax)
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 55 08             	mov    0x8(%ebp),%edx
  802355:	89 10                	mov    %edx,(%eax)
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235d:	89 50 04             	mov    %edx,0x4(%eax)
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	85 c0                	test   %eax,%eax
  802367:	75 08                	jne    802371 <insert_sorted_allocList+0x215>
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	a3 44 40 80 00       	mov    %eax,0x804044
  802371:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802376:	40                   	inc    %eax
  802377:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80237c:	eb 38                	jmp    8023b6 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80237e:	a1 48 40 80 00       	mov    0x804048,%eax
  802383:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802386:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238a:	74 07                	je     802393 <insert_sorted_allocList+0x237>
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 00                	mov    (%eax),%eax
  802391:	eb 05                	jmp    802398 <insert_sorted_allocList+0x23c>
  802393:	b8 00 00 00 00       	mov    $0x0,%eax
  802398:	a3 48 40 80 00       	mov    %eax,0x804048
  80239d:	a1 48 40 80 00       	mov    0x804048,%eax
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	0f 85 3f ff ff ff    	jne    8022e9 <insert_sorted_allocList+0x18d>
  8023aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ae:	0f 85 35 ff ff ff    	jne    8022e9 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8023b4:	eb 00                	jmp    8023b6 <insert_sorted_allocList+0x25a>
  8023b6:	90                   	nop
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    

008023b9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8023bf:	a1 38 41 80 00       	mov    0x804138,%eax
  8023c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c7:	e9 6b 02 00 00       	jmp    802637 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d5:	0f 85 90 00 00 00    	jne    80246b <alloc_block_FF+0xb2>
			  temp=element;
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8023e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e5:	75 17                	jne    8023fe <alloc_block_FF+0x45>
  8023e7:	83 ec 04             	sub    $0x4,%esp
  8023ea:	68 08 3b 80 00       	push   $0x803b08
  8023ef:	68 92 00 00 00       	push   $0x92
  8023f4:	68 97 3a 80 00       	push   $0x803a97
  8023f9:	e8 d7 0b 00 00       	call   802fd5 <_panic>
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 00                	mov    (%eax),%eax
  802403:	85 c0                	test   %eax,%eax
  802405:	74 10                	je     802417 <alloc_block_FF+0x5e>
  802407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240a:	8b 00                	mov    (%eax),%eax
  80240c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80240f:	8b 52 04             	mov    0x4(%edx),%edx
  802412:	89 50 04             	mov    %edx,0x4(%eax)
  802415:	eb 0b                	jmp    802422 <alloc_block_FF+0x69>
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 40 04             	mov    0x4(%eax),%eax
  80241d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	8b 40 04             	mov    0x4(%eax),%eax
  802428:	85 c0                	test   %eax,%eax
  80242a:	74 0f                	je     80243b <alloc_block_FF+0x82>
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	8b 40 04             	mov    0x4(%eax),%eax
  802432:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802435:	8b 12                	mov    (%edx),%edx
  802437:	89 10                	mov    %edx,(%eax)
  802439:	eb 0a                	jmp    802445 <alloc_block_FF+0x8c>
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
  802440:	a3 38 41 80 00       	mov    %eax,0x804138
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802458:	a1 44 41 80 00       	mov    0x804144,%eax
  80245d:	48                   	dec    %eax
  80245e:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802463:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802466:	e9 ff 01 00 00       	jmp    80266a <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 40 0c             	mov    0xc(%eax),%eax
  802471:	3b 45 08             	cmp    0x8(%ebp),%eax
  802474:	0f 86 b5 01 00 00    	jbe    80262f <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 40 0c             	mov    0xc(%eax),%eax
  802480:	2b 45 08             	sub    0x8(%ebp),%eax
  802483:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802486:	a1 48 41 80 00       	mov    0x804148,%eax
  80248b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  80248e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802492:	75 17                	jne    8024ab <alloc_block_FF+0xf2>
  802494:	83 ec 04             	sub    $0x4,%esp
  802497:	68 08 3b 80 00       	push   $0x803b08
  80249c:	68 99 00 00 00       	push   $0x99
  8024a1:	68 97 3a 80 00       	push   $0x803a97
  8024a6:	e8 2a 0b 00 00       	call   802fd5 <_panic>
  8024ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ae:	8b 00                	mov    (%eax),%eax
  8024b0:	85 c0                	test   %eax,%eax
  8024b2:	74 10                	je     8024c4 <alloc_block_FF+0x10b>
  8024b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b7:	8b 00                	mov    (%eax),%eax
  8024b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024bc:	8b 52 04             	mov    0x4(%edx),%edx
  8024bf:	89 50 04             	mov    %edx,0x4(%eax)
  8024c2:	eb 0b                	jmp    8024cf <alloc_block_FF+0x116>
  8024c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ca:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d2:	8b 40 04             	mov    0x4(%eax),%eax
  8024d5:	85 c0                	test   %eax,%eax
  8024d7:	74 0f                	je     8024e8 <alloc_block_FF+0x12f>
  8024d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024dc:	8b 40 04             	mov    0x4(%eax),%eax
  8024df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024e2:	8b 12                	mov    (%edx),%edx
  8024e4:	89 10                	mov    %edx,(%eax)
  8024e6:	eb 0a                	jmp    8024f2 <alloc_block_FF+0x139>
  8024e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024eb:	8b 00                	mov    (%eax),%eax
  8024ed:	a3 48 41 80 00       	mov    %eax,0x804148
  8024f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802505:	a1 54 41 80 00       	mov    0x804154,%eax
  80250a:	48                   	dec    %eax
  80250b:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802510:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802514:	75 17                	jne    80252d <alloc_block_FF+0x174>
  802516:	83 ec 04             	sub    $0x4,%esp
  802519:	68 b0 3a 80 00       	push   $0x803ab0
  80251e:	68 9a 00 00 00       	push   $0x9a
  802523:	68 97 3a 80 00       	push   $0x803a97
  802528:	e8 a8 0a 00 00       	call   802fd5 <_panic>
  80252d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802533:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802536:	89 50 04             	mov    %edx,0x4(%eax)
  802539:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253c:	8b 40 04             	mov    0x4(%eax),%eax
  80253f:	85 c0                	test   %eax,%eax
  802541:	74 0c                	je     80254f <alloc_block_FF+0x196>
  802543:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802548:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80254b:	89 10                	mov    %edx,(%eax)
  80254d:	eb 08                	jmp    802557 <alloc_block_FF+0x19e>
  80254f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802552:	a3 38 41 80 00       	mov    %eax,0x804138
  802557:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80255f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802562:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802568:	a1 44 41 80 00       	mov    0x804144,%eax
  80256d:	40                   	inc    %eax
  80256e:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802576:	8b 55 08             	mov    0x8(%ebp),%edx
  802579:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 50 08             	mov    0x8(%eax),%edx
  802582:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802585:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80258e:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 50 08             	mov    0x8(%eax),%edx
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	01 c2                	add    %eax,%edx
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8025a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8025a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025ac:	75 17                	jne    8025c5 <alloc_block_FF+0x20c>
  8025ae:	83 ec 04             	sub    $0x4,%esp
  8025b1:	68 08 3b 80 00       	push   $0x803b08
  8025b6:	68 a2 00 00 00       	push   $0xa2
  8025bb:	68 97 3a 80 00       	push   $0x803a97
  8025c0:	e8 10 0a 00 00       	call   802fd5 <_panic>
  8025c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c8:	8b 00                	mov    (%eax),%eax
  8025ca:	85 c0                	test   %eax,%eax
  8025cc:	74 10                	je     8025de <alloc_block_FF+0x225>
  8025ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d1:	8b 00                	mov    (%eax),%eax
  8025d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025d6:	8b 52 04             	mov    0x4(%edx),%edx
  8025d9:	89 50 04             	mov    %edx,0x4(%eax)
  8025dc:	eb 0b                	jmp    8025e9 <alloc_block_FF+0x230>
  8025de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e1:	8b 40 04             	mov    0x4(%eax),%eax
  8025e4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ec:	8b 40 04             	mov    0x4(%eax),%eax
  8025ef:	85 c0                	test   %eax,%eax
  8025f1:	74 0f                	je     802602 <alloc_block_FF+0x249>
  8025f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f6:	8b 40 04             	mov    0x4(%eax),%eax
  8025f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025fc:	8b 12                	mov    (%edx),%edx
  8025fe:	89 10                	mov    %edx,(%eax)
  802600:	eb 0a                	jmp    80260c <alloc_block_FF+0x253>
  802602:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802605:	8b 00                	mov    (%eax),%eax
  802607:	a3 38 41 80 00       	mov    %eax,0x804138
  80260c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802618:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80261f:	a1 44 41 80 00       	mov    0x804144,%eax
  802624:	48                   	dec    %eax
  802625:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  80262a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80262d:	eb 3b                	jmp    80266a <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80262f:	a1 40 41 80 00       	mov    0x804140,%eax
  802634:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802637:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263b:	74 07                	je     802644 <alloc_block_FF+0x28b>
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	8b 00                	mov    (%eax),%eax
  802642:	eb 05                	jmp    802649 <alloc_block_FF+0x290>
  802644:	b8 00 00 00 00       	mov    $0x0,%eax
  802649:	a3 40 41 80 00       	mov    %eax,0x804140
  80264e:	a1 40 41 80 00       	mov    0x804140,%eax
  802653:	85 c0                	test   %eax,%eax
  802655:	0f 85 71 fd ff ff    	jne    8023cc <alloc_block_FF+0x13>
  80265b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265f:	0f 85 67 fd ff ff    	jne    8023cc <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802665:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    

0080266c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802672:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802679:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802680:	a1 38 41 80 00       	mov    0x804138,%eax
  802685:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802688:	e9 d3 00 00 00       	jmp    802760 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  80268d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802690:	8b 40 0c             	mov    0xc(%eax),%eax
  802693:	3b 45 08             	cmp    0x8(%ebp),%eax
  802696:	0f 85 90 00 00 00    	jne    80272c <alloc_block_BF+0xc0>
	   temp = element;
  80269c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80269f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8026a2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026a6:	75 17                	jne    8026bf <alloc_block_BF+0x53>
  8026a8:	83 ec 04             	sub    $0x4,%esp
  8026ab:	68 08 3b 80 00       	push   $0x803b08
  8026b0:	68 bd 00 00 00       	push   $0xbd
  8026b5:	68 97 3a 80 00       	push   $0x803a97
  8026ba:	e8 16 09 00 00       	call   802fd5 <_panic>
  8026bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c2:	8b 00                	mov    (%eax),%eax
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	74 10                	je     8026d8 <alloc_block_BF+0x6c>
  8026c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026cb:	8b 00                	mov    (%eax),%eax
  8026cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026d0:	8b 52 04             	mov    0x4(%edx),%edx
  8026d3:	89 50 04             	mov    %edx,0x4(%eax)
  8026d6:	eb 0b                	jmp    8026e3 <alloc_block_BF+0x77>
  8026d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026db:	8b 40 04             	mov    0x4(%eax),%eax
  8026de:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e6:	8b 40 04             	mov    0x4(%eax),%eax
  8026e9:	85 c0                	test   %eax,%eax
  8026eb:	74 0f                	je     8026fc <alloc_block_BF+0x90>
  8026ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f0:	8b 40 04             	mov    0x4(%eax),%eax
  8026f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026f6:	8b 12                	mov    (%edx),%edx
  8026f8:	89 10                	mov    %edx,(%eax)
  8026fa:	eb 0a                	jmp    802706 <alloc_block_BF+0x9a>
  8026fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ff:	8b 00                	mov    (%eax),%eax
  802701:	a3 38 41 80 00       	mov    %eax,0x804138
  802706:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802709:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802712:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802719:	a1 44 41 80 00       	mov    0x804144,%eax
  80271e:	48                   	dec    %eax
  80271f:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802724:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802727:	e9 41 01 00 00       	jmp    80286d <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  80272c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80272f:	8b 40 0c             	mov    0xc(%eax),%eax
  802732:	3b 45 08             	cmp    0x8(%ebp),%eax
  802735:	76 21                	jbe    802758 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802737:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80273a:	8b 40 0c             	mov    0xc(%eax),%eax
  80273d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802740:	73 16                	jae    802758 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802742:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802745:	8b 40 0c             	mov    0xc(%eax),%eax
  802748:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  80274b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802751:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802758:	a1 40 41 80 00       	mov    0x804140,%eax
  80275d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802760:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802764:	74 07                	je     80276d <alloc_block_BF+0x101>
  802766:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802769:	8b 00                	mov    (%eax),%eax
  80276b:	eb 05                	jmp    802772 <alloc_block_BF+0x106>
  80276d:	b8 00 00 00 00       	mov    $0x0,%eax
  802772:	a3 40 41 80 00       	mov    %eax,0x804140
  802777:	a1 40 41 80 00       	mov    0x804140,%eax
  80277c:	85 c0                	test   %eax,%eax
  80277e:	0f 85 09 ff ff ff    	jne    80268d <alloc_block_BF+0x21>
  802784:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802788:	0f 85 ff fe ff ff    	jne    80268d <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  80278e:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802792:	0f 85 d0 00 00 00    	jne    802868 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802798:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279b:	8b 40 0c             	mov    0xc(%eax),%eax
  80279e:	2b 45 08             	sub    0x8(%ebp),%eax
  8027a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8027a4:	a1 48 41 80 00       	mov    0x804148,%eax
  8027a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8027ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8027b0:	75 17                	jne    8027c9 <alloc_block_BF+0x15d>
  8027b2:	83 ec 04             	sub    $0x4,%esp
  8027b5:	68 08 3b 80 00       	push   $0x803b08
  8027ba:	68 d1 00 00 00       	push   $0xd1
  8027bf:	68 97 3a 80 00       	push   $0x803a97
  8027c4:	e8 0c 08 00 00       	call   802fd5 <_panic>
  8027c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027cc:	8b 00                	mov    (%eax),%eax
  8027ce:	85 c0                	test   %eax,%eax
  8027d0:	74 10                	je     8027e2 <alloc_block_BF+0x176>
  8027d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027da:	8b 52 04             	mov    0x4(%edx),%edx
  8027dd:	89 50 04             	mov    %edx,0x4(%eax)
  8027e0:	eb 0b                	jmp    8027ed <alloc_block_BF+0x181>
  8027e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e5:	8b 40 04             	mov    0x4(%eax),%eax
  8027e8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f0:	8b 40 04             	mov    0x4(%eax),%eax
  8027f3:	85 c0                	test   %eax,%eax
  8027f5:	74 0f                	je     802806 <alloc_block_BF+0x19a>
  8027f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fa:	8b 40 04             	mov    0x4(%eax),%eax
  8027fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802800:	8b 12                	mov    (%edx),%edx
  802802:	89 10                	mov    %edx,(%eax)
  802804:	eb 0a                	jmp    802810 <alloc_block_BF+0x1a4>
  802806:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802809:	8b 00                	mov    (%eax),%eax
  80280b:	a3 48 41 80 00       	mov    %eax,0x804148
  802810:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802813:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802819:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80281c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802823:	a1 54 41 80 00       	mov    0x804154,%eax
  802828:	48                   	dec    %eax
  802829:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  80282e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802831:	8b 55 08             	mov    0x8(%ebp),%edx
  802834:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802837:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283a:	8b 50 08             	mov    0x8(%eax),%edx
  80283d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802840:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802843:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802846:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802849:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  80284c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284f:	8b 50 08             	mov    0x8(%eax),%edx
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	01 c2                	add    %eax,%edx
  802857:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285a:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  80285d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802860:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802863:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802866:	eb 05                	jmp    80286d <alloc_block_BF+0x201>
	 }
	 return NULL;
  802868:	b8 00 00 00 00       	mov    $0x0,%eax


}
  80286d:	c9                   	leave  
  80286e:	c3                   	ret    

0080286f <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80286f:	55                   	push   %ebp
  802870:	89 e5                	mov    %esp,%ebp
  802872:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802875:	83 ec 04             	sub    $0x4,%esp
  802878:	68 28 3b 80 00       	push   $0x803b28
  80287d:	68 e8 00 00 00       	push   $0xe8
  802882:	68 97 3a 80 00       	push   $0x803a97
  802887:	e8 49 07 00 00       	call   802fd5 <_panic>

0080288c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80288c:	55                   	push   %ebp
  80288d:	89 e5                	mov    %esp,%ebp
  80288f:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802892:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802897:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  80289a:	a1 38 41 80 00       	mov    0x804138,%eax
  80289f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8028a2:	a1 44 41 80 00       	mov    0x804144,%eax
  8028a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8028aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028ae:	75 68                	jne    802918 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8028b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028b4:	75 17                	jne    8028cd <insert_sorted_with_merge_freeList+0x41>
  8028b6:	83 ec 04             	sub    $0x4,%esp
  8028b9:	68 74 3a 80 00       	push   $0x803a74
  8028be:	68 36 01 00 00       	push   $0x136
  8028c3:	68 97 3a 80 00       	push   $0x803a97
  8028c8:	e8 08 07 00 00       	call   802fd5 <_panic>
  8028cd:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	89 10                	mov    %edx,(%eax)
  8028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028db:	8b 00                	mov    (%eax),%eax
  8028dd:	85 c0                	test   %eax,%eax
  8028df:	74 0d                	je     8028ee <insert_sorted_with_merge_freeList+0x62>
  8028e1:	a1 38 41 80 00       	mov    0x804138,%eax
  8028e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e9:	89 50 04             	mov    %edx,0x4(%eax)
  8028ec:	eb 08                	jmp    8028f6 <insert_sorted_with_merge_freeList+0x6a>
  8028ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f9:	a3 38 41 80 00       	mov    %eax,0x804138
  8028fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802901:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802908:	a1 44 41 80 00       	mov    0x804144,%eax
  80290d:	40                   	inc    %eax
  80290e:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802913:	e9 ba 06 00 00       	jmp    802fd2 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291b:	8b 50 08             	mov    0x8(%eax),%edx
  80291e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802921:	8b 40 0c             	mov    0xc(%eax),%eax
  802924:	01 c2                	add    %eax,%edx
  802926:	8b 45 08             	mov    0x8(%ebp),%eax
  802929:	8b 40 08             	mov    0x8(%eax),%eax
  80292c:	39 c2                	cmp    %eax,%edx
  80292e:	73 68                	jae    802998 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802930:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802934:	75 17                	jne    80294d <insert_sorted_with_merge_freeList+0xc1>
  802936:	83 ec 04             	sub    $0x4,%esp
  802939:	68 b0 3a 80 00       	push   $0x803ab0
  80293e:	68 3a 01 00 00       	push   $0x13a
  802943:	68 97 3a 80 00       	push   $0x803a97
  802948:	e8 88 06 00 00       	call   802fd5 <_panic>
  80294d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802953:	8b 45 08             	mov    0x8(%ebp),%eax
  802956:	89 50 04             	mov    %edx,0x4(%eax)
  802959:	8b 45 08             	mov    0x8(%ebp),%eax
  80295c:	8b 40 04             	mov    0x4(%eax),%eax
  80295f:	85 c0                	test   %eax,%eax
  802961:	74 0c                	je     80296f <insert_sorted_with_merge_freeList+0xe3>
  802963:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802968:	8b 55 08             	mov    0x8(%ebp),%edx
  80296b:	89 10                	mov    %edx,(%eax)
  80296d:	eb 08                	jmp    802977 <insert_sorted_with_merge_freeList+0xeb>
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	a3 38 41 80 00       	mov    %eax,0x804138
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802988:	a1 44 41 80 00       	mov    0x804144,%eax
  80298d:	40                   	inc    %eax
  80298e:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802993:	e9 3a 06 00 00       	jmp    802fd2 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299b:	8b 50 08             	mov    0x8(%eax),%edx
  80299e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a4:	01 c2                	add    %eax,%edx
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	8b 40 08             	mov    0x8(%eax),%eax
  8029ac:	39 c2                	cmp    %eax,%edx
  8029ae:	0f 85 90 00 00 00    	jne    802a44 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8029b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b7:	8b 50 0c             	mov    0xc(%eax),%edx
  8029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c0:	01 c2                	add    %eax,%edx
  8029c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c5:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8029dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029e0:	75 17                	jne    8029f9 <insert_sorted_with_merge_freeList+0x16d>
  8029e2:	83 ec 04             	sub    $0x4,%esp
  8029e5:	68 74 3a 80 00       	push   $0x803a74
  8029ea:	68 41 01 00 00       	push   $0x141
  8029ef:	68 97 3a 80 00       	push   $0x803a97
  8029f4:	e8 dc 05 00 00       	call   802fd5 <_panic>
  8029f9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802a02:	89 10                	mov    %edx,(%eax)
  802a04:	8b 45 08             	mov    0x8(%ebp),%eax
  802a07:	8b 00                	mov    (%eax),%eax
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	74 0d                	je     802a1a <insert_sorted_with_merge_freeList+0x18e>
  802a0d:	a1 48 41 80 00       	mov    0x804148,%eax
  802a12:	8b 55 08             	mov    0x8(%ebp),%edx
  802a15:	89 50 04             	mov    %edx,0x4(%eax)
  802a18:	eb 08                	jmp    802a22 <insert_sorted_with_merge_freeList+0x196>
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a22:	8b 45 08             	mov    0x8(%ebp),%eax
  802a25:	a3 48 41 80 00       	mov    %eax,0x804148
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a34:	a1 54 41 80 00       	mov    0x804154,%eax
  802a39:	40                   	inc    %eax
  802a3a:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802a3f:	e9 8e 05 00 00       	jmp    802fd2 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802a44:	8b 45 08             	mov    0x8(%ebp),%eax
  802a47:	8b 50 08             	mov    0x8(%eax),%edx
  802a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a50:	01 c2                	add    %eax,%edx
  802a52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a55:	8b 40 08             	mov    0x8(%eax),%eax
  802a58:	39 c2                	cmp    %eax,%edx
  802a5a:	73 68                	jae    802ac4 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a60:	75 17                	jne    802a79 <insert_sorted_with_merge_freeList+0x1ed>
  802a62:	83 ec 04             	sub    $0x4,%esp
  802a65:	68 74 3a 80 00       	push   $0x803a74
  802a6a:	68 45 01 00 00       	push   $0x145
  802a6f:	68 97 3a 80 00       	push   $0x803a97
  802a74:	e8 5c 05 00 00       	call   802fd5 <_panic>
  802a79:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	89 10                	mov    %edx,(%eax)
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	8b 00                	mov    (%eax),%eax
  802a89:	85 c0                	test   %eax,%eax
  802a8b:	74 0d                	je     802a9a <insert_sorted_with_merge_freeList+0x20e>
  802a8d:	a1 38 41 80 00       	mov    0x804138,%eax
  802a92:	8b 55 08             	mov    0x8(%ebp),%edx
  802a95:	89 50 04             	mov    %edx,0x4(%eax)
  802a98:	eb 08                	jmp    802aa2 <insert_sorted_with_merge_freeList+0x216>
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa5:	a3 38 41 80 00       	mov    %eax,0x804138
  802aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802aad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab4:	a1 44 41 80 00       	mov    0x804144,%eax
  802ab9:	40                   	inc    %eax
  802aba:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802abf:	e9 0e 05 00 00       	jmp    802fd2 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	8b 50 08             	mov    0x8(%eax),%edx
  802aca:	8b 45 08             	mov    0x8(%ebp),%eax
  802acd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad0:	01 c2                	add    %eax,%edx
  802ad2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad5:	8b 40 08             	mov    0x8(%eax),%eax
  802ad8:	39 c2                	cmp    %eax,%edx
  802ada:	0f 85 9c 00 00 00    	jne    802b7c <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802ae0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	8b 40 0c             	mov    0xc(%eax),%eax
  802aec:	01 c2                	add    %eax,%edx
  802aee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af1:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	8b 50 08             	mov    0x8(%eax),%edx
  802afa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afd:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802b00:	8b 45 08             	mov    0x8(%ebp),%eax
  802b03:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802b14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b18:	75 17                	jne    802b31 <insert_sorted_with_merge_freeList+0x2a5>
  802b1a:	83 ec 04             	sub    $0x4,%esp
  802b1d:	68 74 3a 80 00       	push   $0x803a74
  802b22:	68 4d 01 00 00       	push   $0x14d
  802b27:	68 97 3a 80 00       	push   $0x803a97
  802b2c:	e8 a4 04 00 00       	call   802fd5 <_panic>
  802b31:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	89 10                	mov    %edx,(%eax)
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	8b 00                	mov    (%eax),%eax
  802b41:	85 c0                	test   %eax,%eax
  802b43:	74 0d                	je     802b52 <insert_sorted_with_merge_freeList+0x2c6>
  802b45:	a1 48 41 80 00       	mov    0x804148,%eax
  802b4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4d:	89 50 04             	mov    %edx,0x4(%eax)
  802b50:	eb 08                	jmp    802b5a <insert_sorted_with_merge_freeList+0x2ce>
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	a3 48 41 80 00       	mov    %eax,0x804148
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6c:	a1 54 41 80 00       	mov    0x804154,%eax
  802b71:	40                   	inc    %eax
  802b72:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b77:	e9 56 04 00 00       	jmp    802fd2 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802b7c:	a1 38 41 80 00       	mov    0x804138,%eax
  802b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b84:	e9 19 04 00 00       	jmp    802fa2 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 00                	mov    (%eax),%eax
  802b8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 50 08             	mov    0x8(%eax),%edx
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9d:	01 c2                	add    %eax,%edx
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	8b 40 08             	mov    0x8(%eax),%eax
  802ba5:	39 c2                	cmp    %eax,%edx
  802ba7:	0f 85 ad 01 00 00    	jne    802d5a <insert_sorted_with_merge_freeList+0x4ce>
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	8b 50 08             	mov    0x8(%eax),%edx
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb9:	01 c2                	add    %eax,%edx
  802bbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bbe:	8b 40 08             	mov    0x8(%eax),%eax
  802bc1:	39 c2                	cmp    %eax,%edx
  802bc3:	0f 85 91 01 00 00    	jne    802d5a <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 50 0c             	mov    0xc(%eax),%edx
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	8b 48 0c             	mov    0xc(%eax),%ecx
  802bd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdb:	01 c8                	add    %ecx,%eax
  802bdd:	01 c2                	add    %eax,%edx
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802be5:	8b 45 08             	mov    0x8(%ebp),%eax
  802be8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802bf9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bfc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802c03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802c0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c11:	75 17                	jne    802c2a <insert_sorted_with_merge_freeList+0x39e>
  802c13:	83 ec 04             	sub    $0x4,%esp
  802c16:	68 08 3b 80 00       	push   $0x803b08
  802c1b:	68 5b 01 00 00       	push   $0x15b
  802c20:	68 97 3a 80 00       	push   $0x803a97
  802c25:	e8 ab 03 00 00       	call   802fd5 <_panic>
  802c2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c2d:	8b 00                	mov    (%eax),%eax
  802c2f:	85 c0                	test   %eax,%eax
  802c31:	74 10                	je     802c43 <insert_sorted_with_merge_freeList+0x3b7>
  802c33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c36:	8b 00                	mov    (%eax),%eax
  802c38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c3b:	8b 52 04             	mov    0x4(%edx),%edx
  802c3e:	89 50 04             	mov    %edx,0x4(%eax)
  802c41:	eb 0b                	jmp    802c4e <insert_sorted_with_merge_freeList+0x3c2>
  802c43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c46:	8b 40 04             	mov    0x4(%eax),%eax
  802c49:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c51:	8b 40 04             	mov    0x4(%eax),%eax
  802c54:	85 c0                	test   %eax,%eax
  802c56:	74 0f                	je     802c67 <insert_sorted_with_merge_freeList+0x3db>
  802c58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c5b:	8b 40 04             	mov    0x4(%eax),%eax
  802c5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c61:	8b 12                	mov    (%edx),%edx
  802c63:	89 10                	mov    %edx,(%eax)
  802c65:	eb 0a                	jmp    802c71 <insert_sorted_with_merge_freeList+0x3e5>
  802c67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c6a:	8b 00                	mov    (%eax),%eax
  802c6c:	a3 38 41 80 00       	mov    %eax,0x804138
  802c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c84:	a1 44 41 80 00       	mov    0x804144,%eax
  802c89:	48                   	dec    %eax
  802c8a:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c93:	75 17                	jne    802cac <insert_sorted_with_merge_freeList+0x420>
  802c95:	83 ec 04             	sub    $0x4,%esp
  802c98:	68 74 3a 80 00       	push   $0x803a74
  802c9d:	68 5c 01 00 00       	push   $0x15c
  802ca2:	68 97 3a 80 00       	push   $0x803a97
  802ca7:	e8 29 03 00 00       	call   802fd5 <_panic>
  802cac:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb5:	89 10                	mov    %edx,(%eax)
  802cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cba:	8b 00                	mov    (%eax),%eax
  802cbc:	85 c0                	test   %eax,%eax
  802cbe:	74 0d                	je     802ccd <insert_sorted_with_merge_freeList+0x441>
  802cc0:	a1 48 41 80 00       	mov    0x804148,%eax
  802cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc8:	89 50 04             	mov    %edx,0x4(%eax)
  802ccb:	eb 08                	jmp    802cd5 <insert_sorted_with_merge_freeList+0x449>
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd8:	a3 48 41 80 00       	mov    %eax,0x804148
  802cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce7:	a1 54 41 80 00       	mov    0x804154,%eax
  802cec:	40                   	inc    %eax
  802ced:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802cf2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cf6:	75 17                	jne    802d0f <insert_sorted_with_merge_freeList+0x483>
  802cf8:	83 ec 04             	sub    $0x4,%esp
  802cfb:	68 74 3a 80 00       	push   $0x803a74
  802d00:	68 5d 01 00 00       	push   $0x15d
  802d05:	68 97 3a 80 00       	push   $0x803a97
  802d0a:	e8 c6 02 00 00       	call   802fd5 <_panic>
  802d0f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d18:	89 10                	mov    %edx,(%eax)
  802d1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	74 0d                	je     802d30 <insert_sorted_with_merge_freeList+0x4a4>
  802d23:	a1 48 41 80 00       	mov    0x804148,%eax
  802d28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d2b:	89 50 04             	mov    %edx,0x4(%eax)
  802d2e:	eb 08                	jmp    802d38 <insert_sorted_with_merge_freeList+0x4ac>
  802d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d33:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3b:	a3 48 41 80 00       	mov    %eax,0x804148
  802d40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4a:	a1 54 41 80 00       	mov    0x804154,%eax
  802d4f:	40                   	inc    %eax
  802d50:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802d55:	e9 78 02 00 00       	jmp    802fd2 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	8b 50 08             	mov    0x8(%eax),%edx
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	8b 40 0c             	mov    0xc(%eax),%eax
  802d66:	01 c2                	add    %eax,%edx
  802d68:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6b:	8b 40 08             	mov    0x8(%eax),%eax
  802d6e:	39 c2                	cmp    %eax,%edx
  802d70:	0f 83 b8 00 00 00    	jae    802e2e <insert_sorted_with_merge_freeList+0x5a2>
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	8b 50 08             	mov    0x8(%eax),%edx
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d82:	01 c2                	add    %eax,%edx
  802d84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d87:	8b 40 08             	mov    0x8(%eax),%eax
  802d8a:	39 c2                	cmp    %eax,%edx
  802d8c:	0f 85 9c 00 00 00    	jne    802e2e <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802d92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d95:	8b 50 0c             	mov    0xc(%eax),%edx
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9e:	01 c2                	add    %eax,%edx
  802da0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da3:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	8b 50 08             	mov    0x8(%eax),%edx
  802dac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802daf:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dca:	75 17                	jne    802de3 <insert_sorted_with_merge_freeList+0x557>
  802dcc:	83 ec 04             	sub    $0x4,%esp
  802dcf:	68 74 3a 80 00       	push   $0x803a74
  802dd4:	68 67 01 00 00       	push   $0x167
  802dd9:	68 97 3a 80 00       	push   $0x803a97
  802dde:	e8 f2 01 00 00       	call   802fd5 <_panic>
  802de3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	89 10                	mov    %edx,(%eax)
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	8b 00                	mov    (%eax),%eax
  802df3:	85 c0                	test   %eax,%eax
  802df5:	74 0d                	je     802e04 <insert_sorted_with_merge_freeList+0x578>
  802df7:	a1 48 41 80 00       	mov    0x804148,%eax
  802dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  802dff:	89 50 04             	mov    %edx,0x4(%eax)
  802e02:	eb 08                	jmp    802e0c <insert_sorted_with_merge_freeList+0x580>
  802e04:	8b 45 08             	mov    0x8(%ebp),%eax
  802e07:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	a3 48 41 80 00       	mov    %eax,0x804148
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1e:	a1 54 41 80 00       	mov    0x804154,%eax
  802e23:	40                   	inc    %eax
  802e24:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e29:	e9 a4 01 00 00       	jmp    802fd2 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 50 08             	mov    0x8(%eax),%edx
  802e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e37:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3a:	01 c2                	add    %eax,%edx
  802e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3f:	8b 40 08             	mov    0x8(%eax),%eax
  802e42:	39 c2                	cmp    %eax,%edx
  802e44:	0f 85 ac 00 00 00    	jne    802ef6 <insert_sorted_with_merge_freeList+0x66a>
  802e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4d:	8b 50 08             	mov    0x8(%eax),%edx
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	8b 40 0c             	mov    0xc(%eax),%eax
  802e56:	01 c2                	add    %eax,%edx
  802e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5b:	8b 40 08             	mov    0x8(%eax),%eax
  802e5e:	39 c2                	cmp    %eax,%edx
  802e60:	0f 83 90 00 00 00    	jae    802ef6 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 50 0c             	mov    0xc(%eax),%edx
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e72:	01 c2                	add    %eax,%edx
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802e84:	8b 45 08             	mov    0x8(%ebp),%eax
  802e87:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e92:	75 17                	jne    802eab <insert_sorted_with_merge_freeList+0x61f>
  802e94:	83 ec 04             	sub    $0x4,%esp
  802e97:	68 74 3a 80 00       	push   $0x803a74
  802e9c:	68 70 01 00 00       	push   $0x170
  802ea1:	68 97 3a 80 00       	push   $0x803a97
  802ea6:	e8 2a 01 00 00       	call   802fd5 <_panic>
  802eab:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	89 10                	mov    %edx,(%eax)
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	8b 00                	mov    (%eax),%eax
  802ebb:	85 c0                	test   %eax,%eax
  802ebd:	74 0d                	je     802ecc <insert_sorted_with_merge_freeList+0x640>
  802ebf:	a1 48 41 80 00       	mov    0x804148,%eax
  802ec4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec7:	89 50 04             	mov    %edx,0x4(%eax)
  802eca:	eb 08                	jmp    802ed4 <insert_sorted_with_merge_freeList+0x648>
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	a3 48 41 80 00       	mov    %eax,0x804148
  802edc:	8b 45 08             	mov    0x8(%ebp),%eax
  802edf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee6:	a1 54 41 80 00       	mov    0x804154,%eax
  802eeb:	40                   	inc    %eax
  802eec:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802ef1:	e9 dc 00 00 00       	jmp    802fd2 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	8b 50 08             	mov    0x8(%eax),%edx
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	8b 40 0c             	mov    0xc(%eax),%eax
  802f02:	01 c2                	add    %eax,%edx
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	8b 40 08             	mov    0x8(%eax),%eax
  802f0a:	39 c2                	cmp    %eax,%edx
  802f0c:	0f 83 88 00 00 00    	jae    802f9a <insert_sorted_with_merge_freeList+0x70e>
  802f12:	8b 45 08             	mov    0x8(%ebp),%eax
  802f15:	8b 50 08             	mov    0x8(%eax),%edx
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1e:	01 c2                	add    %eax,%edx
  802f20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f23:	8b 40 08             	mov    0x8(%eax),%eax
  802f26:	39 c2                	cmp    %eax,%edx
  802f28:	73 70                	jae    802f9a <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802f2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f2e:	74 06                	je     802f36 <insert_sorted_with_merge_freeList+0x6aa>
  802f30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f34:	75 17                	jne    802f4d <insert_sorted_with_merge_freeList+0x6c1>
  802f36:	83 ec 04             	sub    $0x4,%esp
  802f39:	68 d4 3a 80 00       	push   $0x803ad4
  802f3e:	68 75 01 00 00       	push   $0x175
  802f43:	68 97 3a 80 00       	push   $0x803a97
  802f48:	e8 88 00 00 00       	call   802fd5 <_panic>
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	8b 10                	mov    (%eax),%edx
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	89 10                	mov    %edx,(%eax)
  802f57:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5a:	8b 00                	mov    (%eax),%eax
  802f5c:	85 c0                	test   %eax,%eax
  802f5e:	74 0b                	je     802f6b <insert_sorted_with_merge_freeList+0x6df>
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 00                	mov    (%eax),%eax
  802f65:	8b 55 08             	mov    0x8(%ebp),%edx
  802f68:	89 50 04             	mov    %edx,0x4(%eax)
  802f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f71:	89 10                	mov    %edx,(%eax)
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f79:	89 50 04             	mov    %edx,0x4(%eax)
  802f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7f:	8b 00                	mov    (%eax),%eax
  802f81:	85 c0                	test   %eax,%eax
  802f83:	75 08                	jne    802f8d <insert_sorted_with_merge_freeList+0x701>
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f8d:	a1 44 41 80 00       	mov    0x804144,%eax
  802f92:	40                   	inc    %eax
  802f93:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802f98:	eb 38                	jmp    802fd2 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802f9a:	a1 40 41 80 00       	mov    0x804140,%eax
  802f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa6:	74 07                	je     802faf <insert_sorted_with_merge_freeList+0x723>
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 00                	mov    (%eax),%eax
  802fad:	eb 05                	jmp    802fb4 <insert_sorted_with_merge_freeList+0x728>
  802faf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb4:	a3 40 41 80 00       	mov    %eax,0x804140
  802fb9:	a1 40 41 80 00       	mov    0x804140,%eax
  802fbe:	85 c0                	test   %eax,%eax
  802fc0:	0f 85 c3 fb ff ff    	jne    802b89 <insert_sorted_with_merge_freeList+0x2fd>
  802fc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fca:	0f 85 b9 fb ff ff    	jne    802b89 <insert_sorted_with_merge_freeList+0x2fd>





}
  802fd0:	eb 00                	jmp    802fd2 <insert_sorted_with_merge_freeList+0x746>
  802fd2:	90                   	nop
  802fd3:	c9                   	leave  
  802fd4:	c3                   	ret    

00802fd5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802fd5:	55                   	push   %ebp
  802fd6:	89 e5                	mov    %esp,%ebp
  802fd8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802fdb:	8d 45 10             	lea    0x10(%ebp),%eax
  802fde:	83 c0 04             	add    $0x4,%eax
  802fe1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802fe4:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802fe9:	85 c0                	test   %eax,%eax
  802feb:	74 16                	je     803003 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802fed:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802ff2:	83 ec 08             	sub    $0x8,%esp
  802ff5:	50                   	push   %eax
  802ff6:	68 58 3b 80 00       	push   $0x803b58
  802ffb:	e8 66 d5 ff ff       	call   800566 <cprintf>
  803000:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803003:	a1 00 40 80 00       	mov    0x804000,%eax
  803008:	ff 75 0c             	pushl  0xc(%ebp)
  80300b:	ff 75 08             	pushl  0x8(%ebp)
  80300e:	50                   	push   %eax
  80300f:	68 5d 3b 80 00       	push   $0x803b5d
  803014:	e8 4d d5 ff ff       	call   800566 <cprintf>
  803019:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80301c:	8b 45 10             	mov    0x10(%ebp),%eax
  80301f:	83 ec 08             	sub    $0x8,%esp
  803022:	ff 75 f4             	pushl  -0xc(%ebp)
  803025:	50                   	push   %eax
  803026:	e8 d0 d4 ff ff       	call   8004fb <vcprintf>
  80302b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80302e:	83 ec 08             	sub    $0x8,%esp
  803031:	6a 00                	push   $0x0
  803033:	68 79 3b 80 00       	push   $0x803b79
  803038:	e8 be d4 ff ff       	call   8004fb <vcprintf>
  80303d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803040:	e8 3f d4 ff ff       	call   800484 <exit>

	// should not return here
	while (1) ;
  803045:	eb fe                	jmp    803045 <_panic+0x70>

00803047 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803047:	55                   	push   %ebp
  803048:	89 e5                	mov    %esp,%ebp
  80304a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80304d:	a1 20 40 80 00       	mov    0x804020,%eax
  803052:	8b 50 74             	mov    0x74(%eax),%edx
  803055:	8b 45 0c             	mov    0xc(%ebp),%eax
  803058:	39 c2                	cmp    %eax,%edx
  80305a:	74 14                	je     803070 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80305c:	83 ec 04             	sub    $0x4,%esp
  80305f:	68 7c 3b 80 00       	push   $0x803b7c
  803064:	6a 26                	push   $0x26
  803066:	68 c8 3b 80 00       	push   $0x803bc8
  80306b:	e8 65 ff ff ff       	call   802fd5 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803070:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803077:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80307e:	e9 c2 00 00 00       	jmp    803145 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803083:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803086:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	01 d0                	add    %edx,%eax
  803092:	8b 00                	mov    (%eax),%eax
  803094:	85 c0                	test   %eax,%eax
  803096:	75 08                	jne    8030a0 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803098:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80309b:	e9 a2 00 00 00       	jmp    803142 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8030a0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030a7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8030ae:	eb 69                	jmp    803119 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8030b0:	a1 20 40 80 00       	mov    0x804020,%eax
  8030b5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8030bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030be:	89 d0                	mov    %edx,%eax
  8030c0:	01 c0                	add    %eax,%eax
  8030c2:	01 d0                	add    %edx,%eax
  8030c4:	c1 e0 03             	shl    $0x3,%eax
  8030c7:	01 c8                	add    %ecx,%eax
  8030c9:	8a 40 04             	mov    0x4(%eax),%al
  8030cc:	84 c0                	test   %al,%al
  8030ce:	75 46                	jne    803116 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8030d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8030d5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8030db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030de:	89 d0                	mov    %edx,%eax
  8030e0:	01 c0                	add    %eax,%eax
  8030e2:	01 d0                	add    %edx,%eax
  8030e4:	c1 e0 03             	shl    $0x3,%eax
  8030e7:	01 c8                	add    %ecx,%eax
  8030e9:	8b 00                	mov    (%eax),%eax
  8030eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8030ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8030f6:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8030f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803102:	8b 45 08             	mov    0x8(%ebp),%eax
  803105:	01 c8                	add    %ecx,%eax
  803107:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803109:	39 c2                	cmp    %eax,%edx
  80310b:	75 09                	jne    803116 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80310d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803114:	eb 12                	jmp    803128 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803116:	ff 45 e8             	incl   -0x18(%ebp)
  803119:	a1 20 40 80 00       	mov    0x804020,%eax
  80311e:	8b 50 74             	mov    0x74(%eax),%edx
  803121:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803124:	39 c2                	cmp    %eax,%edx
  803126:	77 88                	ja     8030b0 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803128:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80312c:	75 14                	jne    803142 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80312e:	83 ec 04             	sub    $0x4,%esp
  803131:	68 d4 3b 80 00       	push   $0x803bd4
  803136:	6a 3a                	push   $0x3a
  803138:	68 c8 3b 80 00       	push   $0x803bc8
  80313d:	e8 93 fe ff ff       	call   802fd5 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803142:	ff 45 f0             	incl   -0x10(%ebp)
  803145:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803148:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80314b:	0f 8c 32 ff ff ff    	jl     803083 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803151:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803158:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80315f:	eb 26                	jmp    803187 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803161:	a1 20 40 80 00       	mov    0x804020,%eax
  803166:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80316c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80316f:	89 d0                	mov    %edx,%eax
  803171:	01 c0                	add    %eax,%eax
  803173:	01 d0                	add    %edx,%eax
  803175:	c1 e0 03             	shl    $0x3,%eax
  803178:	01 c8                	add    %ecx,%eax
  80317a:	8a 40 04             	mov    0x4(%eax),%al
  80317d:	3c 01                	cmp    $0x1,%al
  80317f:	75 03                	jne    803184 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803181:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803184:	ff 45 e0             	incl   -0x20(%ebp)
  803187:	a1 20 40 80 00       	mov    0x804020,%eax
  80318c:	8b 50 74             	mov    0x74(%eax),%edx
  80318f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803192:	39 c2                	cmp    %eax,%edx
  803194:	77 cb                	ja     803161 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803199:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80319c:	74 14                	je     8031b2 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80319e:	83 ec 04             	sub    $0x4,%esp
  8031a1:	68 28 3c 80 00       	push   $0x803c28
  8031a6:	6a 44                	push   $0x44
  8031a8:	68 c8 3b 80 00       	push   $0x803bc8
  8031ad:	e8 23 fe ff ff       	call   802fd5 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8031b2:	90                   	nop
  8031b3:	c9                   	leave  
  8031b4:	c3                   	ret    
  8031b5:	66 90                	xchg   %ax,%ax
  8031b7:	90                   	nop

008031b8 <__udivdi3>:
  8031b8:	55                   	push   %ebp
  8031b9:	57                   	push   %edi
  8031ba:	56                   	push   %esi
  8031bb:	53                   	push   %ebx
  8031bc:	83 ec 1c             	sub    $0x1c,%esp
  8031bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031cf:	89 ca                	mov    %ecx,%edx
  8031d1:	89 f8                	mov    %edi,%eax
  8031d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031d7:	85 f6                	test   %esi,%esi
  8031d9:	75 2d                	jne    803208 <__udivdi3+0x50>
  8031db:	39 cf                	cmp    %ecx,%edi
  8031dd:	77 65                	ja     803244 <__udivdi3+0x8c>
  8031df:	89 fd                	mov    %edi,%ebp
  8031e1:	85 ff                	test   %edi,%edi
  8031e3:	75 0b                	jne    8031f0 <__udivdi3+0x38>
  8031e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8031ea:	31 d2                	xor    %edx,%edx
  8031ec:	f7 f7                	div    %edi
  8031ee:	89 c5                	mov    %eax,%ebp
  8031f0:	31 d2                	xor    %edx,%edx
  8031f2:	89 c8                	mov    %ecx,%eax
  8031f4:	f7 f5                	div    %ebp
  8031f6:	89 c1                	mov    %eax,%ecx
  8031f8:	89 d8                	mov    %ebx,%eax
  8031fa:	f7 f5                	div    %ebp
  8031fc:	89 cf                	mov    %ecx,%edi
  8031fe:	89 fa                	mov    %edi,%edx
  803200:	83 c4 1c             	add    $0x1c,%esp
  803203:	5b                   	pop    %ebx
  803204:	5e                   	pop    %esi
  803205:	5f                   	pop    %edi
  803206:	5d                   	pop    %ebp
  803207:	c3                   	ret    
  803208:	39 ce                	cmp    %ecx,%esi
  80320a:	77 28                	ja     803234 <__udivdi3+0x7c>
  80320c:	0f bd fe             	bsr    %esi,%edi
  80320f:	83 f7 1f             	xor    $0x1f,%edi
  803212:	75 40                	jne    803254 <__udivdi3+0x9c>
  803214:	39 ce                	cmp    %ecx,%esi
  803216:	72 0a                	jb     803222 <__udivdi3+0x6a>
  803218:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80321c:	0f 87 9e 00 00 00    	ja     8032c0 <__udivdi3+0x108>
  803222:	b8 01 00 00 00       	mov    $0x1,%eax
  803227:	89 fa                	mov    %edi,%edx
  803229:	83 c4 1c             	add    $0x1c,%esp
  80322c:	5b                   	pop    %ebx
  80322d:	5e                   	pop    %esi
  80322e:	5f                   	pop    %edi
  80322f:	5d                   	pop    %ebp
  803230:	c3                   	ret    
  803231:	8d 76 00             	lea    0x0(%esi),%esi
  803234:	31 ff                	xor    %edi,%edi
  803236:	31 c0                	xor    %eax,%eax
  803238:	89 fa                	mov    %edi,%edx
  80323a:	83 c4 1c             	add    $0x1c,%esp
  80323d:	5b                   	pop    %ebx
  80323e:	5e                   	pop    %esi
  80323f:	5f                   	pop    %edi
  803240:	5d                   	pop    %ebp
  803241:	c3                   	ret    
  803242:	66 90                	xchg   %ax,%ax
  803244:	89 d8                	mov    %ebx,%eax
  803246:	f7 f7                	div    %edi
  803248:	31 ff                	xor    %edi,%edi
  80324a:	89 fa                	mov    %edi,%edx
  80324c:	83 c4 1c             	add    $0x1c,%esp
  80324f:	5b                   	pop    %ebx
  803250:	5e                   	pop    %esi
  803251:	5f                   	pop    %edi
  803252:	5d                   	pop    %ebp
  803253:	c3                   	ret    
  803254:	bd 20 00 00 00       	mov    $0x20,%ebp
  803259:	89 eb                	mov    %ebp,%ebx
  80325b:	29 fb                	sub    %edi,%ebx
  80325d:	89 f9                	mov    %edi,%ecx
  80325f:	d3 e6                	shl    %cl,%esi
  803261:	89 c5                	mov    %eax,%ebp
  803263:	88 d9                	mov    %bl,%cl
  803265:	d3 ed                	shr    %cl,%ebp
  803267:	89 e9                	mov    %ebp,%ecx
  803269:	09 f1                	or     %esi,%ecx
  80326b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80326f:	89 f9                	mov    %edi,%ecx
  803271:	d3 e0                	shl    %cl,%eax
  803273:	89 c5                	mov    %eax,%ebp
  803275:	89 d6                	mov    %edx,%esi
  803277:	88 d9                	mov    %bl,%cl
  803279:	d3 ee                	shr    %cl,%esi
  80327b:	89 f9                	mov    %edi,%ecx
  80327d:	d3 e2                	shl    %cl,%edx
  80327f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803283:	88 d9                	mov    %bl,%cl
  803285:	d3 e8                	shr    %cl,%eax
  803287:	09 c2                	or     %eax,%edx
  803289:	89 d0                	mov    %edx,%eax
  80328b:	89 f2                	mov    %esi,%edx
  80328d:	f7 74 24 0c          	divl   0xc(%esp)
  803291:	89 d6                	mov    %edx,%esi
  803293:	89 c3                	mov    %eax,%ebx
  803295:	f7 e5                	mul    %ebp
  803297:	39 d6                	cmp    %edx,%esi
  803299:	72 19                	jb     8032b4 <__udivdi3+0xfc>
  80329b:	74 0b                	je     8032a8 <__udivdi3+0xf0>
  80329d:	89 d8                	mov    %ebx,%eax
  80329f:	31 ff                	xor    %edi,%edi
  8032a1:	e9 58 ff ff ff       	jmp    8031fe <__udivdi3+0x46>
  8032a6:	66 90                	xchg   %ax,%ax
  8032a8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032ac:	89 f9                	mov    %edi,%ecx
  8032ae:	d3 e2                	shl    %cl,%edx
  8032b0:	39 c2                	cmp    %eax,%edx
  8032b2:	73 e9                	jae    80329d <__udivdi3+0xe5>
  8032b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032b7:	31 ff                	xor    %edi,%edi
  8032b9:	e9 40 ff ff ff       	jmp    8031fe <__udivdi3+0x46>
  8032be:	66 90                	xchg   %ax,%ax
  8032c0:	31 c0                	xor    %eax,%eax
  8032c2:	e9 37 ff ff ff       	jmp    8031fe <__udivdi3+0x46>
  8032c7:	90                   	nop

008032c8 <__umoddi3>:
  8032c8:	55                   	push   %ebp
  8032c9:	57                   	push   %edi
  8032ca:	56                   	push   %esi
  8032cb:	53                   	push   %ebx
  8032cc:	83 ec 1c             	sub    $0x1c,%esp
  8032cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032e7:	89 f3                	mov    %esi,%ebx
  8032e9:	89 fa                	mov    %edi,%edx
  8032eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032ef:	89 34 24             	mov    %esi,(%esp)
  8032f2:	85 c0                	test   %eax,%eax
  8032f4:	75 1a                	jne    803310 <__umoddi3+0x48>
  8032f6:	39 f7                	cmp    %esi,%edi
  8032f8:	0f 86 a2 00 00 00    	jbe    8033a0 <__umoddi3+0xd8>
  8032fe:	89 c8                	mov    %ecx,%eax
  803300:	89 f2                	mov    %esi,%edx
  803302:	f7 f7                	div    %edi
  803304:	89 d0                	mov    %edx,%eax
  803306:	31 d2                	xor    %edx,%edx
  803308:	83 c4 1c             	add    $0x1c,%esp
  80330b:	5b                   	pop    %ebx
  80330c:	5e                   	pop    %esi
  80330d:	5f                   	pop    %edi
  80330e:	5d                   	pop    %ebp
  80330f:	c3                   	ret    
  803310:	39 f0                	cmp    %esi,%eax
  803312:	0f 87 ac 00 00 00    	ja     8033c4 <__umoddi3+0xfc>
  803318:	0f bd e8             	bsr    %eax,%ebp
  80331b:	83 f5 1f             	xor    $0x1f,%ebp
  80331e:	0f 84 ac 00 00 00    	je     8033d0 <__umoddi3+0x108>
  803324:	bf 20 00 00 00       	mov    $0x20,%edi
  803329:	29 ef                	sub    %ebp,%edi
  80332b:	89 fe                	mov    %edi,%esi
  80332d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803331:	89 e9                	mov    %ebp,%ecx
  803333:	d3 e0                	shl    %cl,%eax
  803335:	89 d7                	mov    %edx,%edi
  803337:	89 f1                	mov    %esi,%ecx
  803339:	d3 ef                	shr    %cl,%edi
  80333b:	09 c7                	or     %eax,%edi
  80333d:	89 e9                	mov    %ebp,%ecx
  80333f:	d3 e2                	shl    %cl,%edx
  803341:	89 14 24             	mov    %edx,(%esp)
  803344:	89 d8                	mov    %ebx,%eax
  803346:	d3 e0                	shl    %cl,%eax
  803348:	89 c2                	mov    %eax,%edx
  80334a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80334e:	d3 e0                	shl    %cl,%eax
  803350:	89 44 24 04          	mov    %eax,0x4(%esp)
  803354:	8b 44 24 08          	mov    0x8(%esp),%eax
  803358:	89 f1                	mov    %esi,%ecx
  80335a:	d3 e8                	shr    %cl,%eax
  80335c:	09 d0                	or     %edx,%eax
  80335e:	d3 eb                	shr    %cl,%ebx
  803360:	89 da                	mov    %ebx,%edx
  803362:	f7 f7                	div    %edi
  803364:	89 d3                	mov    %edx,%ebx
  803366:	f7 24 24             	mull   (%esp)
  803369:	89 c6                	mov    %eax,%esi
  80336b:	89 d1                	mov    %edx,%ecx
  80336d:	39 d3                	cmp    %edx,%ebx
  80336f:	0f 82 87 00 00 00    	jb     8033fc <__umoddi3+0x134>
  803375:	0f 84 91 00 00 00    	je     80340c <__umoddi3+0x144>
  80337b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80337f:	29 f2                	sub    %esi,%edx
  803381:	19 cb                	sbb    %ecx,%ebx
  803383:	89 d8                	mov    %ebx,%eax
  803385:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803389:	d3 e0                	shl    %cl,%eax
  80338b:	89 e9                	mov    %ebp,%ecx
  80338d:	d3 ea                	shr    %cl,%edx
  80338f:	09 d0                	or     %edx,%eax
  803391:	89 e9                	mov    %ebp,%ecx
  803393:	d3 eb                	shr    %cl,%ebx
  803395:	89 da                	mov    %ebx,%edx
  803397:	83 c4 1c             	add    $0x1c,%esp
  80339a:	5b                   	pop    %ebx
  80339b:	5e                   	pop    %esi
  80339c:	5f                   	pop    %edi
  80339d:	5d                   	pop    %ebp
  80339e:	c3                   	ret    
  80339f:	90                   	nop
  8033a0:	89 fd                	mov    %edi,%ebp
  8033a2:	85 ff                	test   %edi,%edi
  8033a4:	75 0b                	jne    8033b1 <__umoddi3+0xe9>
  8033a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ab:	31 d2                	xor    %edx,%edx
  8033ad:	f7 f7                	div    %edi
  8033af:	89 c5                	mov    %eax,%ebp
  8033b1:	89 f0                	mov    %esi,%eax
  8033b3:	31 d2                	xor    %edx,%edx
  8033b5:	f7 f5                	div    %ebp
  8033b7:	89 c8                	mov    %ecx,%eax
  8033b9:	f7 f5                	div    %ebp
  8033bb:	89 d0                	mov    %edx,%eax
  8033bd:	e9 44 ff ff ff       	jmp    803306 <__umoddi3+0x3e>
  8033c2:	66 90                	xchg   %ax,%ax
  8033c4:	89 c8                	mov    %ecx,%eax
  8033c6:	89 f2                	mov    %esi,%edx
  8033c8:	83 c4 1c             	add    $0x1c,%esp
  8033cb:	5b                   	pop    %ebx
  8033cc:	5e                   	pop    %esi
  8033cd:	5f                   	pop    %edi
  8033ce:	5d                   	pop    %ebp
  8033cf:	c3                   	ret    
  8033d0:	3b 04 24             	cmp    (%esp),%eax
  8033d3:	72 06                	jb     8033db <__umoddi3+0x113>
  8033d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033d9:	77 0f                	ja     8033ea <__umoddi3+0x122>
  8033db:	89 f2                	mov    %esi,%edx
  8033dd:	29 f9                	sub    %edi,%ecx
  8033df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033e3:	89 14 24             	mov    %edx,(%esp)
  8033e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033ee:	8b 14 24             	mov    (%esp),%edx
  8033f1:	83 c4 1c             	add    $0x1c,%esp
  8033f4:	5b                   	pop    %ebx
  8033f5:	5e                   	pop    %esi
  8033f6:	5f                   	pop    %edi
  8033f7:	5d                   	pop    %ebp
  8033f8:	c3                   	ret    
  8033f9:	8d 76 00             	lea    0x0(%esi),%esi
  8033fc:	2b 04 24             	sub    (%esp),%eax
  8033ff:	19 fa                	sbb    %edi,%edx
  803401:	89 d1                	mov    %edx,%ecx
  803403:	89 c6                	mov    %eax,%esi
  803405:	e9 71 ff ff ff       	jmp    80337b <__umoddi3+0xb3>
  80340a:	66 90                	xchg   %ax,%ax
  80340c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803410:	72 ea                	jb     8033fc <__umoddi3+0x134>
  803412:	89 d9                	mov    %ebx,%ecx
  803414:	e9 62 ff ff ff       	jmp    80337b <__umoddi3+0xb3>
