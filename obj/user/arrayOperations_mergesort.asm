
obj/user/arrayOperations_mergesort:     file format elf32-i386


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
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 f1 1c 00 00       	call   801d34 <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  800046:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int *sharedArray = NULL;
  80004d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  800054:	83 ec 08             	sub    $0x8,%esp
  800057:	68 40 35 80 00       	push   $0x803540
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 b2 17 00 00       	call   801816 <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 44 35 80 00       	push   $0x803544
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 9c 17 00 00       	call   801816 <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 4c 35 80 00       	push   $0x80354c
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 7f 17 00 00       	call   801816 <sget>
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  80009d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a0:	8b 00                	mov    (%eax),%eax
  8000a2:	c1 e0 02             	shl    $0x2,%eax
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	50                   	push   %eax
  8000ab:	68 5a 35 80 00       	push   $0x80355a
  8000b0:	e8 c3 16 00 00       	call   801778 <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000c2:	eb 25                	jmp    8000e9 <_main+0xb1>
	{
		sortedArray[i] = sharedArray[i];
  8000c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000d1:	01 c2                	add    %eax,%edx
  8000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e0:	01 c8                	add    %ecx,%eax
  8000e2:	8b 00                	mov    (%eax),%eax
  8000e4:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000e6:	ff 45 f4             	incl   -0xc(%ebp)
  8000e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ec:	8b 00                	mov    (%eax),%eax
  8000ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f1:	7f d1                	jg     8000c4 <_main+0x8c>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  8000f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f6:	8b 00                	mov    (%eax),%eax
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	50                   	push   %eax
  8000fc:	6a 01                	push   $0x1
  8000fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800101:	e8 fc 00 00 00       	call   800202 <MSort>
  800106:	83 c4 10             	add    $0x10,%esp
	cprintf("Merge sort is Finished!!!!\n") ;
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	68 69 35 80 00       	push   $0x803569
  800111:	e8 6d 05 00 00       	call   800683 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  800119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	8d 50 01             	lea    0x1(%eax),%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	89 10                	mov    %edx,(%eax)

}
  800126:	90                   	nop
  800127:	c9                   	leave  
  800128:	c3                   	ret    

00800129 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80012f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800132:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800139:	8b 45 08             	mov    0x8(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8b 00                	mov    (%eax),%eax
  800140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800143:	8b 45 0c             	mov    0xc(%ebp),%eax
  800146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80014d:	8b 45 08             	mov    0x8(%ebp),%eax
  800150:	01 c2                	add    %eax,%edx
  800152:	8b 45 10             	mov    0x10(%ebp),%eax
  800155:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	01 c8                	add    %ecx,%eax
  800161:	8b 00                	mov    (%eax),%eax
  800163:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800165:	8b 45 10             	mov    0x10(%ebp),%eax
  800168:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80016f:	8b 45 08             	mov    0x8(%ebp),%eax
  800172:	01 c2                	add    %eax,%edx
  800174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800177:	89 02                	mov    %eax,(%edx)
}
  800179:	90                   	nop
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    

0080017c <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800182:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800189:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800190:	eb 42                	jmp    8001d4 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800195:	99                   	cltd   
  800196:	f7 7d f0             	idivl  -0x10(%ebp)
  800199:	89 d0                	mov    %edx,%eax
  80019b:	85 c0                	test   %eax,%eax
  80019d:	75 10                	jne    8001af <PrintElements+0x33>
			cprintf("\n");
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	68 85 35 80 00       	push   $0x803585
  8001a7:	e8 d7 04 00 00       	call   800683 <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	8b 00                	mov    (%eax),%eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 87 35 80 00       	push   $0x803587
  8001c9:	e8 b5 04 00 00       	call   800683 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8001d1:	ff 45 f4             	incl   -0xc(%ebp)
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	48                   	dec    %eax
  8001d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8001db:	7f b5                	jg     800192 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8001dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ea:	01 d0                	add    %edx,%eax
  8001ec:	8b 00                	mov    (%eax),%eax
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	50                   	push   %eax
  8001f2:	68 8c 35 80 00       	push   $0x80358c
  8001f7:	e8 87 04 00 00       	call   800683 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp

}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <MSort>:


void MSort(int* A, int p, int r)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80020e:	7d 54                	jge    800264 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  800210:	8b 55 0c             	mov    0xc(%ebp),%edx
  800213:	8b 45 10             	mov    0x10(%ebp),%eax
  800216:	01 d0                	add    %edx,%eax
  800218:	89 c2                	mov    %eax,%edx
  80021a:	c1 ea 1f             	shr    $0x1f,%edx
  80021d:	01 d0                	add    %edx,%eax
  80021f:	d1 f8                	sar    %eax
  800221:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	ff 75 f4             	pushl  -0xc(%ebp)
  80022a:	ff 75 0c             	pushl  0xc(%ebp)
  80022d:	ff 75 08             	pushl  0x8(%ebp)
  800230:	e8 cd ff ff ff       	call   800202 <MSort>
  800235:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  800238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023b:	40                   	inc    %eax
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	ff 75 10             	pushl  0x10(%ebp)
  800242:	50                   	push   %eax
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 b7 ff ff ff       	call   800202 <MSort>
  80024b:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  80024e:	ff 75 10             	pushl  0x10(%ebp)
  800251:	ff 75 f4             	pushl  -0xc(%ebp)
  800254:	ff 75 0c             	pushl  0xc(%ebp)
  800257:	ff 75 08             	pushl  0x8(%ebp)
  80025a:	e8 08 00 00 00       	call   800267 <Merge>
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	eb 01                	jmp    800265 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800264:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80026d:	8b 45 10             	mov    0x10(%ebp),%eax
  800270:	2b 45 0c             	sub    0xc(%ebp),%eax
  800273:	40                   	inc    %eax
  800274:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800277:	8b 45 14             	mov    0x14(%ebp),%eax
  80027a:	2b 45 10             	sub    0x10(%ebp),%eax
  80027d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800287:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  80028e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800291:	c1 e0 02             	shl    $0x2,%eax
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	50                   	push   %eax
  800298:	e8 5f 13 00 00       	call   8015fc <malloc>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  8002a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002a6:	c1 e0 02             	shl    $0x2,%eax
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	50                   	push   %eax
  8002ad:	e8 4a 13 00 00       	call   8015fc <malloc>
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8002bf:	eb 2f                	jmp    8002f0 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8002c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ce:	01 c2                	add    %eax,%edx
  8002d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8002dd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 c8                	add    %ecx,%eax
  8002e9:	8b 00                	mov    (%eax),%eax
  8002eb:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002ed:	ff 45 ec             	incl   -0x14(%ebp)
  8002f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002f6:	7c c9                	jl     8002c1 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8002f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002ff:	eb 2a                	jmp    80032b <Merge+0xc4>
	{
		Right[j] = A[q + j];
  800301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800304:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80030e:	01 c2                	add    %eax,%edx
  800310:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800316:	01 c8                	add    %ecx,%eax
  800318:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031f:	8b 45 08             	mov    0x8(%ebp),%eax
  800322:	01 c8                	add    %ecx,%eax
  800324:	8b 00                	mov    (%eax),%eax
  800326:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800328:	ff 45 e8             	incl   -0x18(%ebp)
  80032b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80032e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800331:	7c ce                	jl     800301 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800339:	e9 0a 01 00 00       	jmp    800448 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  80033e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800341:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800344:	0f 8d 95 00 00 00    	jge    8003df <Merge+0x178>
  80034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	0f 8d 89 00 00 00    	jge    8003df <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 10                	mov    (%eax),%edx
  800367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800371:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8b 00                	mov    (%eax),%eax
  800378:	39 c2                	cmp    %eax,%edx
  80037a:	7d 33                	jge    8003af <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80037c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80037f:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800394:	8d 50 01             	lea    0x1(%eax),%edx
  800397:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003aa:	e9 96 00 00 00       	jmp    800445 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  8003af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c7:	8d 50 01             	lea    0x1(%eax),%edx
  8003ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8003cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d7:	01 d0                	add    %edx,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003dd:	eb 66                	jmp    800445 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8003df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003e5:	7d 30                	jge    800417 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8003e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ea:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ff:	8d 50 01             	lea    0x1(%eax),%edx
  800402:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	89 01                	mov    %eax,(%ecx)
  800415:	eb 2e                	jmp    800445 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80041f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 50 01             	lea    0x1(%eax),%edx
  800432:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800445:	ff 45 e4             	incl   -0x1c(%ebp)
  800448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80044b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80044e:	0f 8e ea fe ff ff    	jle    80033e <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	ff 75 d8             	pushl  -0x28(%ebp)
  80045a:	e8 34 12 00 00       	call   801693 <free>
  80045f:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	ff 75 d4             	pushl  -0x2c(%ebp)
  800468:	e8 26 12 00 00       	call   801693 <free>
  80046d:	83 c4 10             	add    $0x10,%esp

}
  800470:	90                   	nop
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 9d 18 00 00       	call   801d1b <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 03             	shl    $0x3,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	01 c0                	add    %eax,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	01 d0                	add    %edx,%eax
  800498:	c1 e0 04             	shl    $0x4,%eax
  80049b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a0:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8004aa:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8004b0:	84 c0                	test   %al,%al
  8004b2:	74 0f                	je     8004c3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8004b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b9:	05 5c 05 00 00       	add    $0x55c,%eax
  8004be:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c7:	7e 0a                	jle    8004d3 <libmain+0x60>
		binaryname = argv[0];
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <_main>
  8004e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004e4:	e8 3f 16 00 00       	call   801b28 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 a8 35 80 00       	push   $0x8035a8
  8004f1:	e8 8d 01 00 00       	call   800683 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8004fe:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800504:	a1 20 40 80 00       	mov    0x804020,%eax
  800509:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	68 d0 35 80 00       	push   $0x8035d0
  800519:	e8 65 01 00 00       	call   800683 <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800521:	a1 20 40 80 00       	mov    0x804020,%eax
  800526:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80052c:	a1 20 40 80 00       	mov    0x804020,%eax
  800531:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800537:	a1 20 40 80 00       	mov    0x804020,%eax
  80053c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	68 f8 35 80 00       	push   $0x8035f8
  80054a:	e8 34 01 00 00       	call   800683 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 40 80 00       	mov    0x804020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 50 36 80 00       	push   $0x803650
  800566:	e8 18 01 00 00       	call   800683 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 a8 35 80 00       	push   $0x8035a8
  800576:	e8 08 01 00 00       	call   800683 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 bf 15 00 00       	call   801b42 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800583:	e8 19 00 00 00       	call   8005a1 <exit>
}
  800588:	90                   	nop
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	6a 00                	push   $0x0
  800596:	e8 4c 17 00 00       	call   801ce7 <sys_destroy_env>
  80059b:	83 c4 10             	add    $0x10,%esp
}
  80059e:	90                   	nop
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <exit>:

void
exit(void)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005a7:	e8 a1 17 00 00       	call   801d4d <sys_exit_env>
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8005bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c0:	89 0a                	mov    %ecx,(%edx)
  8005c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c5:	88 d1                	mov    %dl,%cl
  8005c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ca:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005d8:	75 2c                	jne    800606 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005da:	a0 24 40 80 00       	mov    0x804024,%al
  8005df:	0f b6 c0             	movzbl %al,%eax
  8005e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e5:	8b 12                	mov    (%edx),%edx
  8005e7:	89 d1                	mov    %edx,%ecx
  8005e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ec:	83 c2 08             	add    $0x8,%edx
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	50                   	push   %eax
  8005f3:	51                   	push   %ecx
  8005f4:	52                   	push   %edx
  8005f5:	e8 80 13 00 00       	call   80197a <sys_cputs>
  8005fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800600:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	8b 40 04             	mov    0x4(%eax),%eax
  80060c:	8d 50 01             	lea    0x1(%eax),%edx
  80060f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800612:	89 50 04             	mov    %edx,0x4(%eax)
}
  800615:	90                   	nop
  800616:	c9                   	leave  
  800617:	c3                   	ret    

00800618 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800618:	55                   	push   %ebp
  800619:	89 e5                	mov    %esp,%ebp
  80061b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800621:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800628:	00 00 00 
	b.cnt = 0;
  80062b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800632:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 08             	pushl  0x8(%ebp)
  80063b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800641:	50                   	push   %eax
  800642:	68 af 05 80 00       	push   $0x8005af
  800647:	e8 11 02 00 00       	call   80085d <vprintfmt>
  80064c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80064f:	a0 24 40 80 00       	mov    0x804024,%al
  800654:	0f b6 c0             	movzbl %al,%eax
  800657:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	50                   	push   %eax
  800661:	52                   	push   %edx
  800662:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800668:	83 c0 08             	add    $0x8,%eax
  80066b:	50                   	push   %eax
  80066c:	e8 09 13 00 00       	call   80197a <sys_cputs>
  800671:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800674:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80067b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800681:	c9                   	leave  
  800682:	c3                   	ret    

00800683 <cprintf>:

int cprintf(const char *fmt, ...) {
  800683:	55                   	push   %ebp
  800684:	89 e5                	mov    %esp,%ebp
  800686:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800689:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800690:	8d 45 0c             	lea    0xc(%ebp),%eax
  800693:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	ff 75 f4             	pushl  -0xc(%ebp)
  80069f:	50                   	push   %eax
  8006a0:	e8 73 ff ff ff       	call   800618 <vcprintf>
  8006a5:	83 c4 10             	add    $0x10,%esp
  8006a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006b6:	e8 6d 14 00 00       	call   801b28 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ca:	50                   	push   %eax
  8006cb:	e8 48 ff ff ff       	call   800618 <vcprintf>
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006d6:	e8 67 14 00 00       	call   801b42 <sys_enable_interrupt>
	return cnt;
  8006db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	53                   	push   %ebx
  8006e4:	83 ec 14             	sub    $0x14,%esp
  8006e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006fe:	77 55                	ja     800755 <printnum+0x75>
  800700:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800703:	72 05                	jb     80070a <printnum+0x2a>
  800705:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800708:	77 4b                	ja     800755 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80070a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80070d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800710:	8b 45 18             	mov    0x18(%ebp),%eax
  800713:	ba 00 00 00 00       	mov    $0x0,%edx
  800718:	52                   	push   %edx
  800719:	50                   	push   %eax
  80071a:	ff 75 f4             	pushl  -0xc(%ebp)
  80071d:	ff 75 f0             	pushl  -0x10(%ebp)
  800720:	e8 af 2b 00 00       	call   8032d4 <__udivdi3>
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	83 ec 04             	sub    $0x4,%esp
  80072b:	ff 75 20             	pushl  0x20(%ebp)
  80072e:	53                   	push   %ebx
  80072f:	ff 75 18             	pushl  0x18(%ebp)
  800732:	52                   	push   %edx
  800733:	50                   	push   %eax
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	ff 75 08             	pushl  0x8(%ebp)
  80073a:	e8 a1 ff ff ff       	call   8006e0 <printnum>
  80073f:	83 c4 20             	add    $0x20,%esp
  800742:	eb 1a                	jmp    80075e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 20             	pushl  0x20(%ebp)
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	ff d0                	call   *%eax
  800752:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800755:	ff 4d 1c             	decl   0x1c(%ebp)
  800758:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80075c:	7f e6                	jg     800744 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80075e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800761:	bb 00 00 00 00       	mov    $0x0,%ebx
  800766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800769:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076c:	53                   	push   %ebx
  80076d:	51                   	push   %ecx
  80076e:	52                   	push   %edx
  80076f:	50                   	push   %eax
  800770:	e8 6f 2c 00 00       	call   8033e4 <__umoddi3>
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	05 94 38 80 00       	add    $0x803894,%eax
  80077d:	8a 00                	mov    (%eax),%al
  80077f:	0f be c0             	movsbl %al,%eax
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 75 0c             	pushl  0xc(%ebp)
  800788:	50                   	push   %eax
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	ff d0                	call   *%eax
  80078e:	83 c4 10             	add    $0x10,%esp
}
  800791:	90                   	nop
  800792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800795:	c9                   	leave  
  800796:	c3                   	ret    

00800797 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80079e:	7e 1c                	jle    8007bc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	8d 50 08             	lea    0x8(%eax),%edx
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	89 10                	mov    %edx,(%eax)
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	83 e8 08             	sub    $0x8,%eax
  8007b5:	8b 50 04             	mov    0x4(%eax),%edx
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	eb 40                	jmp    8007fc <getuint+0x65>
	else if (lflag)
  8007bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c0:	74 1e                	je     8007e0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	89 10                	mov    %edx,(%eax)
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	83 e8 04             	sub    $0x4,%eax
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007de:	eb 1c                	jmp    8007fc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	8d 50 04             	lea    0x4(%eax),%edx
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	89 10                	mov    %edx,(%eax)
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	83 e8 04             	sub    $0x4,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800801:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800805:	7e 1c                	jle    800823 <getint+0x25>
		return va_arg(*ap, long long);
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	8d 50 08             	lea    0x8(%eax),%edx
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	89 10                	mov    %edx,(%eax)
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	83 e8 08             	sub    $0x8,%eax
  80081c:	8b 50 04             	mov    0x4(%eax),%edx
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	eb 38                	jmp    80085b <getint+0x5d>
	else if (lflag)
  800823:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800827:	74 1a                	je     800843 <getint+0x45>
		return va_arg(*ap, long);
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	8d 50 04             	lea    0x4(%eax),%edx
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	89 10                	mov    %edx,(%eax)
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	83 e8 04             	sub    $0x4,%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	99                   	cltd   
  800841:	eb 18                	jmp    80085b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	8b 00                	mov    (%eax),%eax
  800848:	8d 50 04             	lea    0x4(%eax),%edx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	89 10                	mov    %edx,(%eax)
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	83 e8 04             	sub    $0x4,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	99                   	cltd   
}
  80085b:	5d                   	pop    %ebp
  80085c:	c3                   	ret    

0080085d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	56                   	push   %esi
  800861:	53                   	push   %ebx
  800862:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800865:	eb 17                	jmp    80087e <vprintfmt+0x21>
			if (ch == '\0')
  800867:	85 db                	test   %ebx,%ebx
  800869:	0f 84 af 03 00 00    	je     800c1e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	53                   	push   %ebx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087e:	8b 45 10             	mov    0x10(%ebp),%eax
  800881:	8d 50 01             	lea    0x1(%eax),%edx
  800884:	89 55 10             	mov    %edx,0x10(%ebp)
  800887:	8a 00                	mov    (%eax),%al
  800889:	0f b6 d8             	movzbl %al,%ebx
  80088c:	83 fb 25             	cmp    $0x25,%ebx
  80088f:	75 d6                	jne    800867 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800891:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800895:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80089c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b4:	8d 50 01             	lea    0x1(%eax),%edx
  8008b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ba:	8a 00                	mov    (%eax),%al
  8008bc:	0f b6 d8             	movzbl %al,%ebx
  8008bf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008c2:	83 f8 55             	cmp    $0x55,%eax
  8008c5:	0f 87 2b 03 00 00    	ja     800bf6 <vprintfmt+0x399>
  8008cb:	8b 04 85 b8 38 80 00 	mov    0x8038b8(,%eax,4),%eax
  8008d2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008d4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008d8:	eb d7                	jmp    8008b1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008da:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008de:	eb d1                	jmp    8008b1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ea:	89 d0                	mov    %edx,%eax
  8008ec:	c1 e0 02             	shl    $0x2,%eax
  8008ef:	01 d0                	add    %edx,%eax
  8008f1:	01 c0                	add    %eax,%eax
  8008f3:	01 d8                	add    %ebx,%eax
  8008f5:	83 e8 30             	sub    $0x30,%eax
  8008f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fe:	8a 00                	mov    (%eax),%al
  800900:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800903:	83 fb 2f             	cmp    $0x2f,%ebx
  800906:	7e 3e                	jle    800946 <vprintfmt+0xe9>
  800908:	83 fb 39             	cmp    $0x39,%ebx
  80090b:	7f 39                	jg     800946 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800910:	eb d5                	jmp    8008e7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 14             	mov    %eax,0x14(%ebp)
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	83 e8 04             	sub    $0x4,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800926:	eb 1f                	jmp    800947 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	79 83                	jns    8008b1 <vprintfmt+0x54>
				width = 0;
  80092e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800935:	e9 77 ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80093a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800941:	e9 6b ff ff ff       	jmp    8008b1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800946:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800947:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094b:	0f 89 60 ff ff ff    	jns    8008b1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800954:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800957:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80095e:	e9 4e ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800963:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800966:	e9 46 ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	83 c0 04             	add    $0x4,%eax
  800971:	89 45 14             	mov    %eax,0x14(%ebp)
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	83 e8 04             	sub    $0x4,%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	50                   	push   %eax
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	ff d0                	call   *%eax
  800988:	83 c4 10             	add    $0x10,%esp
			break;
  80098b:	e9 89 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 c0 04             	add    $0x4,%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 e8 04             	sub    $0x4,%eax
  80099f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009a1:	85 db                	test   %ebx,%ebx
  8009a3:	79 02                	jns    8009a7 <vprintfmt+0x14a>
				err = -err;
  8009a5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009a7:	83 fb 64             	cmp    $0x64,%ebx
  8009aa:	7f 0b                	jg     8009b7 <vprintfmt+0x15a>
  8009ac:	8b 34 9d 00 37 80 00 	mov    0x803700(,%ebx,4),%esi
  8009b3:	85 f6                	test   %esi,%esi
  8009b5:	75 19                	jne    8009d0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009b7:	53                   	push   %ebx
  8009b8:	68 a5 38 80 00       	push   $0x8038a5
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	ff 75 08             	pushl  0x8(%ebp)
  8009c3:	e8 5e 02 00 00       	call   800c26 <printfmt>
  8009c8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009cb:	e9 49 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009d0:	56                   	push   %esi
  8009d1:	68 ae 38 80 00       	push   $0x8038ae
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	ff 75 08             	pushl  0x8(%ebp)
  8009dc:	e8 45 02 00 00       	call   800c26 <printfmt>
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	e9 30 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	83 c0 04             	add    $0x4,%eax
  8009ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	83 e8 04             	sub    $0x4,%eax
  8009f8:	8b 30                	mov    (%eax),%esi
  8009fa:	85 f6                	test   %esi,%esi
  8009fc:	75 05                	jne    800a03 <vprintfmt+0x1a6>
				p = "(null)";
  8009fe:	be b1 38 80 00       	mov    $0x8038b1,%esi
			if (width > 0 && padc != '-')
  800a03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a07:	7e 6d                	jle    800a76 <vprintfmt+0x219>
  800a09:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a0d:	74 67                	je     800a76 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	50                   	push   %eax
  800a16:	56                   	push   %esi
  800a17:	e8 0c 03 00 00       	call   800d28 <strnlen>
  800a1c:	83 c4 10             	add    $0x10,%esp
  800a1f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a22:	eb 16                	jmp    800a3a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a24:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	50                   	push   %eax
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a37:	ff 4d e4             	decl   -0x1c(%ebp)
  800a3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3e:	7f e4                	jg     800a24 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a40:	eb 34                	jmp    800a76 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a42:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a46:	74 1c                	je     800a64 <vprintfmt+0x207>
  800a48:	83 fb 1f             	cmp    $0x1f,%ebx
  800a4b:	7e 05                	jle    800a52 <vprintfmt+0x1f5>
  800a4d:	83 fb 7e             	cmp    $0x7e,%ebx
  800a50:	7e 12                	jle    800a64 <vprintfmt+0x207>
					putch('?', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 3f                	push   $0x3f
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
  800a62:	eb 0f                	jmp    800a73 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	53                   	push   %ebx
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a73:	ff 4d e4             	decl   -0x1c(%ebp)
  800a76:	89 f0                	mov    %esi,%eax
  800a78:	8d 70 01             	lea    0x1(%eax),%esi
  800a7b:	8a 00                	mov    (%eax),%al
  800a7d:	0f be d8             	movsbl %al,%ebx
  800a80:	85 db                	test   %ebx,%ebx
  800a82:	74 24                	je     800aa8 <vprintfmt+0x24b>
  800a84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a88:	78 b8                	js     800a42 <vprintfmt+0x1e5>
  800a8a:	ff 4d e0             	decl   -0x20(%ebp)
  800a8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a91:	79 af                	jns    800a42 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a93:	eb 13                	jmp    800aa8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	6a 20                	push   $0x20
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	ff d0                	call   *%eax
  800aa2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa5:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aac:	7f e7                	jg     800a95 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800aae:	e9 66 01 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab9:	8d 45 14             	lea    0x14(%ebp),%eax
  800abc:	50                   	push   %eax
  800abd:	e8 3c fd ff ff       	call   8007fe <getint>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad1:	85 d2                	test   %edx,%edx
  800ad3:	79 23                	jns    800af8 <vprintfmt+0x29b>
				putch('-', putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	6a 2d                	push   $0x2d
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	ff d0                	call   *%eax
  800ae2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aeb:	f7 d8                	neg    %eax
  800aed:	83 d2 00             	adc    $0x0,%edx
  800af0:	f7 da                	neg    %edx
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800af8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aff:	e9 bc 00 00 00       	jmp    800bc0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b0d:	50                   	push   %eax
  800b0e:	e8 84 fc ff ff       	call   800797 <getuint>
  800b13:	83 c4 10             	add    $0x10,%esp
  800b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b23:	e9 98 00 00 00       	jmp    800bc0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	6a 58                	push   $0x58
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	ff d0                	call   *%eax
  800b35:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b38:	83 ec 08             	sub    $0x8,%esp
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	6a 58                	push   $0x58
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	ff d0                	call   *%eax
  800b45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	6a 58                	push   $0x58
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
			break;
  800b58:	e9 bc 00 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 30                	push   $0x30
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 78                	push   $0x78
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b80:	83 c0 04             	add    $0x4,%eax
  800b83:	89 45 14             	mov    %eax,0x14(%ebp)
  800b86:	8b 45 14             	mov    0x14(%ebp),%eax
  800b89:	83 e8 04             	sub    $0x4,%eax
  800b8c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b9f:	eb 1f                	jmp    800bc0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba7:	8d 45 14             	lea    0x14(%ebp),%eax
  800baa:	50                   	push   %eax
  800bab:	e8 e7 fb ff ff       	call   800797 <getuint>
  800bb0:	83 c4 10             	add    $0x10,%esp
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bc0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc7:	83 ec 04             	sub    $0x4,%esp
  800bca:	52                   	push   %edx
  800bcb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bce:	50                   	push   %eax
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	ff 75 f0             	pushl  -0x10(%ebp)
  800bd5:	ff 75 0c             	pushl  0xc(%ebp)
  800bd8:	ff 75 08             	pushl  0x8(%ebp)
  800bdb:	e8 00 fb ff ff       	call   8006e0 <printnum>
  800be0:	83 c4 20             	add    $0x20,%esp
			break;
  800be3:	eb 34                	jmp    800c19 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	53                   	push   %ebx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	ff d0                	call   *%eax
  800bf1:	83 c4 10             	add    $0x10,%esp
			break;
  800bf4:	eb 23                	jmp    800c19 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	6a 25                	push   $0x25
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c06:	ff 4d 10             	decl   0x10(%ebp)
  800c09:	eb 03                	jmp    800c0e <vprintfmt+0x3b1>
  800c0b:	ff 4d 10             	decl   0x10(%ebp)
  800c0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c11:	48                   	dec    %eax
  800c12:	8a 00                	mov    (%eax),%al
  800c14:	3c 25                	cmp    $0x25,%al
  800c16:	75 f3                	jne    800c0b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c18:	90                   	nop
		}
	}
  800c19:	e9 47 fc ff ff       	jmp    800865 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c22:	5b                   	pop    %ebx
  800c23:	5e                   	pop    %esi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800c2f:	83 c0 04             	add    $0x4,%eax
  800c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c35:	8b 45 10             	mov    0x10(%ebp),%eax
  800c38:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3b:	50                   	push   %eax
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	ff 75 08             	pushl  0x8(%ebp)
  800c42:	e8 16 fc ff ff       	call   80085d <vprintfmt>
  800c47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c4a:	90                   	nop
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8b 40 08             	mov    0x8(%eax),%eax
  800c56:	8d 50 01             	lea    0x1(%eax),%edx
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	8b 10                	mov    (%eax),%edx
  800c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c67:	8b 40 04             	mov    0x4(%eax),%eax
  800c6a:	39 c2                	cmp    %eax,%edx
  800c6c:	73 12                	jae    800c80 <sprintputch+0x33>
		*b->buf++ = ch;
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	8d 48 01             	lea    0x1(%eax),%ecx
  800c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c79:	89 0a                	mov    %ecx,(%edx)
  800c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7e:	88 10                	mov    %dl,(%eax)
}
  800c80:	90                   	nop
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	01 d0                	add    %edx,%eax
  800c9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ca4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ca8:	74 06                	je     800cb0 <vsnprintf+0x2d>
  800caa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cae:	7f 07                	jg     800cb7 <vsnprintf+0x34>
		return -E_INVAL;
  800cb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb5:	eb 20                	jmp    800cd7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cb7:	ff 75 14             	pushl  0x14(%ebp)
  800cba:	ff 75 10             	pushl  0x10(%ebp)
  800cbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cc0:	50                   	push   %eax
  800cc1:	68 4d 0c 80 00       	push   $0x800c4d
  800cc6:	e8 92 fb ff ff       	call   80085d <vprintfmt>
  800ccb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cdf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cee:	50                   	push   %eax
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	ff 75 08             	pushl  0x8(%ebp)
  800cf5:	e8 89 ff ff ff       	call   800c83 <vsnprintf>
  800cfa:	83 c4 10             	add    $0x10,%esp
  800cfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d03:	c9                   	leave  
  800d04:	c3                   	ret    

00800d05 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d12:	eb 06                	jmp    800d1a <strlen+0x15>
		n++;
  800d14:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	84 c0                	test   %al,%al
  800d21:	75 f1                	jne    800d14 <strlen+0xf>
		n++;
	return n;
  800d23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d35:	eb 09                	jmp    800d40 <strnlen+0x18>
		n++;
  800d37:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d3a:	ff 45 08             	incl   0x8(%ebp)
  800d3d:	ff 4d 0c             	decl   0xc(%ebp)
  800d40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d44:	74 09                	je     800d4f <strnlen+0x27>
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	75 e8                	jne    800d37 <strnlen+0xf>
		n++;
	return n;
  800d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d60:	90                   	nop
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8d 50 01             	lea    0x1(%eax),%edx
  800d67:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d70:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d73:	8a 12                	mov    (%edx),%dl
  800d75:	88 10                	mov    %dl,(%eax)
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	84 c0                	test   %al,%al
  800d7b:	75 e4                	jne    800d61 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d95:	eb 1f                	jmp    800db6 <strncpy+0x34>
		*dst++ = *src;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8d 50 01             	lea    0x1(%eax),%edx
  800d9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da3:	8a 12                	mov    (%edx),%dl
  800da5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	84 c0                	test   %al,%al
  800dae:	74 03                	je     800db3 <strncpy+0x31>
			src++;
  800db0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800db3:	ff 45 fc             	incl   -0x4(%ebp)
  800db6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dbc:	72 d9                	jb     800d97 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dc1:	c9                   	leave  
  800dc2:	c3                   	ret    

00800dc3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd3:	74 30                	je     800e05 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dd5:	eb 16                	jmp    800ded <strlcpy+0x2a>
			*dst++ = *src++;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8d 50 01             	lea    0x1(%eax),%edx
  800ddd:	89 55 08             	mov    %edx,0x8(%ebp)
  800de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800de9:	8a 12                	mov    (%edx),%dl
  800deb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	74 09                	je     800dff <strlcpy+0x3c>
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	84 c0                	test   %al,%al
  800dfd:	75 d8                	jne    800dd7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0b:	29 c2                	sub    %eax,%edx
  800e0d:	89 d0                	mov    %edx,%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e14:	eb 06                	jmp    800e1c <strcmp+0xb>
		p++, q++;
  800e16:	ff 45 08             	incl   0x8(%ebp)
  800e19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	84 c0                	test   %al,%al
  800e23:	74 0e                	je     800e33 <strcmp+0x22>
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 10                	mov    (%eax),%dl
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	38 c2                	cmp    %al,%dl
  800e31:	74 e3                	je     800e16 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	0f b6 d0             	movzbl %al,%edx
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	0f b6 c0             	movzbl %al,%eax
  800e43:	29 c2                	sub    %eax,%edx
  800e45:	89 d0                	mov    %edx,%eax
}
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e4c:	eb 09                	jmp    800e57 <strncmp+0xe>
		n--, p++, q++;
  800e4e:	ff 4d 10             	decl   0x10(%ebp)
  800e51:	ff 45 08             	incl   0x8(%ebp)
  800e54:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5b:	74 17                	je     800e74 <strncmp+0x2b>
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	84 c0                	test   %al,%al
  800e64:	74 0e                	je     800e74 <strncmp+0x2b>
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 10                	mov    (%eax),%dl
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	38 c2                	cmp    %al,%dl
  800e72:	74 da                	je     800e4e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e78:	75 07                	jne    800e81 <strncmp+0x38>
		return 0;
  800e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7f:	eb 14                	jmp    800e95 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	0f b6 d0             	movzbl %al,%edx
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 c0             	movzbl %al,%eax
  800e91:	29 c2                	sub    %eax,%edx
  800e93:	89 d0                	mov    %edx,%eax
}
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 04             	sub    $0x4,%esp
  800e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea3:	eb 12                	jmp    800eb7 <strchr+0x20>
		if (*s == c)
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ead:	75 05                	jne    800eb4 <strchr+0x1d>
			return (char *) s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	eb 11                	jmp    800ec5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eb4:	ff 45 08             	incl   0x8(%ebp)
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	84 c0                	test   %al,%al
  800ebe:	75 e5                	jne    800ea5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ec0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed3:	eb 0d                	jmp    800ee2 <strfind+0x1b>
		if (*s == c)
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800edd:	74 0e                	je     800eed <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800edf:	ff 45 08             	incl   0x8(%ebp)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 ea                	jne    800ed5 <strfind+0xe>
  800eeb:	eb 01                	jmp    800eee <strfind+0x27>
		if (*s == c)
			break;
  800eed:	90                   	nop
	return (char *) s;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f05:	eb 0e                	jmp    800f15 <memset+0x22>
		*p++ = c;
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0a:	8d 50 01             	lea    0x1(%eax),%edx
  800f0d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f13:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f15:	ff 4d f8             	decl   -0x8(%ebp)
  800f18:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f1c:	79 e9                	jns    800f07 <memset+0x14>
		*p++ = c;

	return v;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f21:	c9                   	leave  
  800f22:	c3                   	ret    

00800f23 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f35:	eb 16                	jmp    800f4d <memcpy+0x2a>
		*d++ = *s++;
  800f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f43:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f46:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f49:	8a 12                	mov    (%edx),%dl
  800f4b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f53:	89 55 10             	mov    %edx,0x10(%ebp)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	75 dd                	jne    800f37 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f77:	73 50                	jae    800fc9 <memmove+0x6a>
  800f79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f84:	76 43                	jbe    800fc9 <memmove+0x6a>
		s += n;
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f92:	eb 10                	jmp    800fa4 <memmove+0x45>
			*--d = *--s;
  800f94:	ff 4d f8             	decl   -0x8(%ebp)
  800f97:	ff 4d fc             	decl   -0x4(%ebp)
  800f9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9d:	8a 10                	mov    (%eax),%dl
  800f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800faa:	89 55 10             	mov    %edx,0x10(%ebp)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	75 e3                	jne    800f94 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fb1:	eb 23                	jmp    800fd6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb6:	8d 50 01             	lea    0x1(%eax),%edx
  800fb9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc5:	8a 12                	mov    (%edx),%dl
  800fc7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 dd                	jne    800fb3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd9:	c9                   	leave  
  800fda:	c3                   	ret    

00800fdb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fed:	eb 2a                	jmp    801019 <memcmp+0x3e>
		if (*s1 != *s2)
  800fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff2:	8a 10                	mov    (%eax),%dl
  800ff4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	38 c2                	cmp    %al,%dl
  800ffb:	74 16                	je     801013 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f b6 d0             	movzbl %al,%edx
  801005:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f b6 c0             	movzbl %al,%eax
  80100d:	29 c2                	sub    %eax,%edx
  80100f:	89 d0                	mov    %edx,%eax
  801011:	eb 18                	jmp    80102b <memcmp+0x50>
		s1++, s2++;
  801013:	ff 45 fc             	incl   -0x4(%ebp)
  801016:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801019:	8b 45 10             	mov    0x10(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	89 55 10             	mov    %edx,0x10(%ebp)
  801022:	85 c0                	test   %eax,%eax
  801024:	75 c9                	jne    800fef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801033:	8b 55 08             	mov    0x8(%ebp),%edx
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80103e:	eb 15                	jmp    801055 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f b6 d0             	movzbl %al,%edx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	0f b6 c0             	movzbl %al,%eax
  80104e:	39 c2                	cmp    %eax,%edx
  801050:	74 0d                	je     80105f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80105b:	72 e3                	jb     801040 <memfind+0x13>
  80105d:	eb 01                	jmp    801060 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80105f:	90                   	nop
	return (void *) s;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80106b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801072:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801079:	eb 03                	jmp    80107e <strtol+0x19>
		s++;
  80107b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 20                	cmp    $0x20,%al
  801085:	74 f4                	je     80107b <strtol+0x16>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 09                	cmp    $0x9,%al
  80108e:	74 eb                	je     80107b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	3c 2b                	cmp    $0x2b,%al
  801097:	75 05                	jne    80109e <strtol+0x39>
		s++;
  801099:	ff 45 08             	incl   0x8(%ebp)
  80109c:	eb 13                	jmp    8010b1 <strtol+0x4c>
	else if (*s == '-')
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	3c 2d                	cmp    $0x2d,%al
  8010a5:	75 0a                	jne    8010b1 <strtol+0x4c>
		s++, neg = 1;
  8010a7:	ff 45 08             	incl   0x8(%ebp)
  8010aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b5:	74 06                	je     8010bd <strtol+0x58>
  8010b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010bb:	75 20                	jne    8010dd <strtol+0x78>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 30                	cmp    $0x30,%al
  8010c4:	75 17                	jne    8010dd <strtol+0x78>
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	40                   	inc    %eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	3c 78                	cmp    $0x78,%al
  8010ce:	75 0d                	jne    8010dd <strtol+0x78>
		s += 2, base = 16;
  8010d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010db:	eb 28                	jmp    801105 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e1:	75 15                	jne    8010f8 <strtol+0x93>
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	3c 30                	cmp    $0x30,%al
  8010ea:	75 0c                	jne    8010f8 <strtol+0x93>
		s++, base = 8;
  8010ec:	ff 45 08             	incl   0x8(%ebp)
  8010ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010f6:	eb 0d                	jmp    801105 <strtol+0xa0>
	else if (base == 0)
  8010f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fc:	75 07                	jne    801105 <strtol+0xa0>
		base = 10;
  8010fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 2f                	cmp    $0x2f,%al
  80110c:	7e 19                	jle    801127 <strtol+0xc2>
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 39                	cmp    $0x39,%al
  801115:	7f 10                	jg     801127 <strtol+0xc2>
			dig = *s - '0';
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f be c0             	movsbl %al,%eax
  80111f:	83 e8 30             	sub    $0x30,%eax
  801122:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801125:	eb 42                	jmp    801169 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	3c 60                	cmp    $0x60,%al
  80112e:	7e 19                	jle    801149 <strtol+0xe4>
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 7a                	cmp    $0x7a,%al
  801137:	7f 10                	jg     801149 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	0f be c0             	movsbl %al,%eax
  801141:	83 e8 57             	sub    $0x57,%eax
  801144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801147:	eb 20                	jmp    801169 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 40                	cmp    $0x40,%al
  801150:	7e 39                	jle    80118b <strtol+0x126>
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	3c 5a                	cmp    $0x5a,%al
  801159:	7f 30                	jg     80118b <strtol+0x126>
			dig = *s - 'A' + 10;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	0f be c0             	movsbl %al,%eax
  801163:	83 e8 37             	sub    $0x37,%eax
  801166:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80116f:	7d 19                	jge    80118a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801177:	0f af 45 10          	imul   0x10(%ebp),%eax
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801180:	01 d0                	add    %edx,%eax
  801182:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801185:	e9 7b ff ff ff       	jmp    801105 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80118a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80118b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118f:	74 08                	je     801199 <strtol+0x134>
		*endptr = (char *) s;
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 55 08             	mov    0x8(%ebp),%edx
  801197:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801199:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119d:	74 07                	je     8011a6 <strtol+0x141>
  80119f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a2:	f7 d8                	neg    %eax
  8011a4:	eb 03                	jmp    8011a9 <strtol+0x144>
  8011a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <ltostr>:

void
ltostr(long value, char *str)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	79 13                	jns    8011d8 <ltostr+0x2d>
	{
		neg = 1;
  8011c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011e0:	99                   	cltd   
  8011e1:	f7 f9                	idiv   %ecx
  8011e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ef:	89 c2                	mov    %eax,%edx
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f9:	83 c2 30             	add    $0x30,%edx
  8011fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801201:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801206:	f7 e9                	imul   %ecx
  801208:	c1 fa 02             	sar    $0x2,%edx
  80120b:	89 c8                	mov    %ecx,%eax
  80120d:	c1 f8 1f             	sar    $0x1f,%eax
  801210:	29 c2                	sub    %eax,%edx
  801212:	89 d0                	mov    %edx,%eax
  801214:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801217:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80121f:	f7 e9                	imul   %ecx
  801221:	c1 fa 02             	sar    $0x2,%edx
  801224:	89 c8                	mov    %ecx,%eax
  801226:	c1 f8 1f             	sar    $0x1f,%eax
  801229:	29 c2                	sub    %eax,%edx
  80122b:	89 d0                	mov    %edx,%eax
  80122d:	c1 e0 02             	shl    $0x2,%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	01 c0                	add    %eax,%eax
  801234:	29 c1                	sub    %eax,%ecx
  801236:	89 ca                	mov    %ecx,%edx
  801238:	85 d2                	test   %edx,%edx
  80123a:	75 9c                	jne    8011d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80123c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801243:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801246:	48                   	dec    %eax
  801247:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80124a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80124e:	74 3d                	je     80128d <ltostr+0xe2>
		start = 1 ;
  801250:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801257:	eb 34                	jmp    80128d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801259:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	01 d0                	add    %edx,%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801266:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	01 c8                	add    %ecx,%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80127a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 c2                	add    %eax,%edx
  801282:	8a 45 eb             	mov    -0x15(%ebp),%al
  801285:	88 02                	mov    %al,(%edx)
		start++ ;
  801287:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80128a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80128d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801290:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801293:	7c c4                	jl     801259 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801295:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	01 d0                	add    %edx,%eax
  80129d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012a0:	90                   	nop
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012a9:	ff 75 08             	pushl  0x8(%ebp)
  8012ac:	e8 54 fa ff ff       	call   800d05 <strlen>
  8012b1:	83 c4 04             	add    $0x4,%esp
  8012b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012b7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ba:	e8 46 fa ff ff       	call   800d05 <strlen>
  8012bf:	83 c4 04             	add    $0x4,%esp
  8012c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d3:	eb 17                	jmp    8012ec <strcconcat+0x49>
		final[s] = str1[s] ;
  8012d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	01 c2                	add    %eax,%edx
  8012dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	01 c8                	add    %ecx,%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012e9:	ff 45 fc             	incl   -0x4(%ebp)
  8012ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012f2:	7c e1                	jl     8012d5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801302:	eb 1f                	jmp    801323 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801304:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801307:	8d 50 01             	lea    0x1(%eax),%edx
  80130a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80130d:	89 c2                	mov    %eax,%edx
  80130f:	8b 45 10             	mov    0x10(%ebp),%eax
  801312:	01 c2                	add    %eax,%edx
  801314:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131a:	01 c8                	add    %ecx,%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801320:	ff 45 f8             	incl   -0x8(%ebp)
  801323:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801326:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801329:	7c d9                	jl     801304 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80132b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	01 d0                	add    %edx,%eax
  801333:	c6 00 00             	movb   $0x0,(%eax)
}
  801336:	90                   	nop
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80133c:	8b 45 14             	mov    0x14(%ebp),%eax
  80133f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801345:	8b 45 14             	mov    0x14(%ebp),%eax
  801348:	8b 00                	mov    (%eax),%eax
  80134a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801351:	8b 45 10             	mov    0x10(%ebp),%eax
  801354:	01 d0                	add    %edx,%eax
  801356:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80135c:	eb 0c                	jmp    80136a <strsplit+0x31>
			*string++ = 0;
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8d 50 01             	lea    0x1(%eax),%edx
  801364:	89 55 08             	mov    %edx,0x8(%ebp)
  801367:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	84 c0                	test   %al,%al
  801371:	74 18                	je     80138b <strsplit+0x52>
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	0f be c0             	movsbl %al,%eax
  80137b:	50                   	push   %eax
  80137c:	ff 75 0c             	pushl  0xc(%ebp)
  80137f:	e8 13 fb ff ff       	call   800e97 <strchr>
  801384:	83 c4 08             	add    $0x8,%esp
  801387:	85 c0                	test   %eax,%eax
  801389:	75 d3                	jne    80135e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8a 00                	mov    (%eax),%al
  801390:	84 c0                	test   %al,%al
  801392:	74 5a                	je     8013ee <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801394:	8b 45 14             	mov    0x14(%ebp),%eax
  801397:	8b 00                	mov    (%eax),%eax
  801399:	83 f8 0f             	cmp    $0xf,%eax
  80139c:	75 07                	jne    8013a5 <strsplit+0x6c>
		{
			return 0;
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	eb 66                	jmp    80140b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a8:	8b 00                	mov    (%eax),%eax
  8013aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8013ad:	8b 55 14             	mov    0x14(%ebp),%edx
  8013b0:	89 0a                	mov    %ecx,(%edx)
  8013b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bc:	01 c2                	add    %eax,%edx
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c3:	eb 03                	jmp    8013c8 <strsplit+0x8f>
			string++;
  8013c5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	84 c0                	test   %al,%al
  8013cf:	74 8b                	je     80135c <strsplit+0x23>
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f be c0             	movsbl %al,%eax
  8013d9:	50                   	push   %eax
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 b5 fa ff ff       	call   800e97 <strchr>
  8013e2:	83 c4 08             	add    $0x8,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	74 dc                	je     8013c5 <strsplit+0x8c>
			string++;
	}
  8013e9:	e9 6e ff ff ff       	jmp    80135c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013ee:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f2:	8b 00                	mov    (%eax),%eax
  8013f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 d0                	add    %edx,%eax
  801400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801406:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801413:	a1 04 40 80 00       	mov    0x804004,%eax
  801418:	85 c0                	test   %eax,%eax
  80141a:	74 1f                	je     80143b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80141c:	e8 1d 00 00 00       	call   80143e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801421:	83 ec 0c             	sub    $0xc,%esp
  801424:	68 10 3a 80 00       	push   $0x803a10
  801429:	e8 55 f2 ff ff       	call   800683 <cprintf>
  80142e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801431:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801438:	00 00 00 
	}
}
  80143b:	90                   	nop
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801444:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80144b:	00 00 00 
  80144e:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801455:	00 00 00 
  801458:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80145f:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801462:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801469:	00 00 00 
  80146c:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801473:	00 00 00 
  801476:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80147d:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801480:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80148f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801494:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801499:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8014a0:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8014a3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ad:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8014b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8014bd:	f7 75 f0             	divl   -0x10(%ebp)
  8014c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014c3:	29 d0                	sub    %edx,%eax
  8014c5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8014c8:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8014cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014d7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014dc:	83 ec 04             	sub    $0x4,%esp
  8014df:	6a 06                	push   $0x6
  8014e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8014e4:	50                   	push   %eax
  8014e5:	e8 d4 05 00 00       	call   801abe <sys_allocate_chunk>
  8014ea:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014ed:	a1 20 41 80 00       	mov    0x804120,%eax
  8014f2:	83 ec 0c             	sub    $0xc,%esp
  8014f5:	50                   	push   %eax
  8014f6:	e8 49 0c 00 00       	call   802144 <initialize_MemBlocksList>
  8014fb:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8014fe:	a1 48 41 80 00       	mov    0x804148,%eax
  801503:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801506:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80150a:	75 14                	jne    801520 <initialize_dyn_block_system+0xe2>
  80150c:	83 ec 04             	sub    $0x4,%esp
  80150f:	68 35 3a 80 00       	push   $0x803a35
  801514:	6a 39                	push   $0x39
  801516:	68 53 3a 80 00       	push   $0x803a53
  80151b:	e8 d2 1b 00 00       	call   8030f2 <_panic>
  801520:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801523:	8b 00                	mov    (%eax),%eax
  801525:	85 c0                	test   %eax,%eax
  801527:	74 10                	je     801539 <initialize_dyn_block_system+0xfb>
  801529:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152c:	8b 00                	mov    (%eax),%eax
  80152e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801531:	8b 52 04             	mov    0x4(%edx),%edx
  801534:	89 50 04             	mov    %edx,0x4(%eax)
  801537:	eb 0b                	jmp    801544 <initialize_dyn_block_system+0x106>
  801539:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80153c:	8b 40 04             	mov    0x4(%eax),%eax
  80153f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801544:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801547:	8b 40 04             	mov    0x4(%eax),%eax
  80154a:	85 c0                	test   %eax,%eax
  80154c:	74 0f                	je     80155d <initialize_dyn_block_system+0x11f>
  80154e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801551:	8b 40 04             	mov    0x4(%eax),%eax
  801554:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801557:	8b 12                	mov    (%edx),%edx
  801559:	89 10                	mov    %edx,(%eax)
  80155b:	eb 0a                	jmp    801567 <initialize_dyn_block_system+0x129>
  80155d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801560:	8b 00                	mov    (%eax),%eax
  801562:	a3 48 41 80 00       	mov    %eax,0x804148
  801567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801570:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801573:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80157a:	a1 54 41 80 00       	mov    0x804154,%eax
  80157f:	48                   	dec    %eax
  801580:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801585:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801588:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80158f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801592:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801599:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80159d:	75 14                	jne    8015b3 <initialize_dyn_block_system+0x175>
  80159f:	83 ec 04             	sub    $0x4,%esp
  8015a2:	68 60 3a 80 00       	push   $0x803a60
  8015a7:	6a 3f                	push   $0x3f
  8015a9:	68 53 3a 80 00       	push   $0x803a53
  8015ae:	e8 3f 1b 00 00       	call   8030f2 <_panic>
  8015b3:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8015b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015bc:	89 10                	mov    %edx,(%eax)
  8015be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c1:	8b 00                	mov    (%eax),%eax
  8015c3:	85 c0                	test   %eax,%eax
  8015c5:	74 0d                	je     8015d4 <initialize_dyn_block_system+0x196>
  8015c7:	a1 38 41 80 00       	mov    0x804138,%eax
  8015cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015cf:	89 50 04             	mov    %edx,0x4(%eax)
  8015d2:	eb 08                	jmp    8015dc <initialize_dyn_block_system+0x19e>
  8015d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015d7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8015dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015df:	a3 38 41 80 00       	mov    %eax,0x804138
  8015e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015ee:	a1 44 41 80 00       	mov    0x804144,%eax
  8015f3:	40                   	inc    %eax
  8015f4:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8015f9:	90                   	nop
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801602:	e8 06 fe ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  801607:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80160b:	75 07                	jne    801614 <malloc+0x18>
  80160d:	b8 00 00 00 00       	mov    $0x0,%eax
  801612:	eb 7d                	jmp    801691 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801614:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80161b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801622:	8b 55 08             	mov    0x8(%ebp),%edx
  801625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801628:	01 d0                	add    %edx,%eax
  80162a:	48                   	dec    %eax
  80162b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80162e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801631:	ba 00 00 00 00       	mov    $0x0,%edx
  801636:	f7 75 f0             	divl   -0x10(%ebp)
  801639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163c:	29 d0                	sub    %edx,%eax
  80163e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801641:	e8 46 08 00 00       	call   801e8c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801646:	83 f8 01             	cmp    $0x1,%eax
  801649:	75 07                	jne    801652 <malloc+0x56>
  80164b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801652:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801656:	75 34                	jne    80168c <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801658:	83 ec 0c             	sub    $0xc,%esp
  80165b:	ff 75 e8             	pushl  -0x18(%ebp)
  80165e:	e8 73 0e 00 00       	call   8024d6 <alloc_block_FF>
  801663:	83 c4 10             	add    $0x10,%esp
  801666:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801669:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80166d:	74 16                	je     801685 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  80166f:	83 ec 0c             	sub    $0xc,%esp
  801672:	ff 75 e4             	pushl  -0x1c(%ebp)
  801675:	e8 ff 0b 00 00       	call   802279 <insert_sorted_allocList>
  80167a:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  80167d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801680:	8b 40 08             	mov    0x8(%eax),%eax
  801683:	eb 0c                	jmp    801691 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801685:	b8 00 00 00 00       	mov    $0x0,%eax
  80168a:	eb 05                	jmp    801691 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80168c:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  80169f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016ad:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  8016b0:	83 ec 08             	sub    $0x8,%esp
  8016b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8016b6:	68 40 40 80 00       	push   $0x804040
  8016bb:	e8 61 0b 00 00       	call   802221 <find_block>
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8016c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016ca:	0f 84 a5 00 00 00    	je     801775 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8016d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d6:	83 ec 08             	sub    $0x8,%esp
  8016d9:	50                   	push   %eax
  8016da:	ff 75 f4             	pushl  -0xc(%ebp)
  8016dd:	e8 a4 03 00 00       	call   801a86 <sys_free_user_mem>
  8016e2:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8016e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016e9:	75 17                	jne    801702 <free+0x6f>
  8016eb:	83 ec 04             	sub    $0x4,%esp
  8016ee:	68 35 3a 80 00       	push   $0x803a35
  8016f3:	68 87 00 00 00       	push   $0x87
  8016f8:	68 53 3a 80 00       	push   $0x803a53
  8016fd:	e8 f0 19 00 00       	call   8030f2 <_panic>
  801702:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801705:	8b 00                	mov    (%eax),%eax
  801707:	85 c0                	test   %eax,%eax
  801709:	74 10                	je     80171b <free+0x88>
  80170b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170e:	8b 00                	mov    (%eax),%eax
  801710:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801713:	8b 52 04             	mov    0x4(%edx),%edx
  801716:	89 50 04             	mov    %edx,0x4(%eax)
  801719:	eb 0b                	jmp    801726 <free+0x93>
  80171b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171e:	8b 40 04             	mov    0x4(%eax),%eax
  801721:	a3 44 40 80 00       	mov    %eax,0x804044
  801726:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801729:	8b 40 04             	mov    0x4(%eax),%eax
  80172c:	85 c0                	test   %eax,%eax
  80172e:	74 0f                	je     80173f <free+0xac>
  801730:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801733:	8b 40 04             	mov    0x4(%eax),%eax
  801736:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801739:	8b 12                	mov    (%edx),%edx
  80173b:	89 10                	mov    %edx,(%eax)
  80173d:	eb 0a                	jmp    801749 <free+0xb6>
  80173f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801742:	8b 00                	mov    (%eax),%eax
  801744:	a3 40 40 80 00       	mov    %eax,0x804040
  801749:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801752:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801755:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80175c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801761:	48                   	dec    %eax
  801762:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801767:	83 ec 0c             	sub    $0xc,%esp
  80176a:	ff 75 ec             	pushl  -0x14(%ebp)
  80176d:	e8 37 12 00 00       	call   8029a9 <insert_sorted_with_merge_freeList>
  801772:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801775:	90                   	nop
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 38             	sub    $0x38,%esp
  80177e:	8b 45 10             	mov    0x10(%ebp),%eax
  801781:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801784:	e8 84 fc ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  801789:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80178d:	75 07                	jne    801796 <smalloc+0x1e>
  80178f:	b8 00 00 00 00       	mov    $0x0,%eax
  801794:	eb 7e                	jmp    801814 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801796:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80179d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017aa:	01 d0                	add    %edx,%eax
  8017ac:	48                   	dec    %eax
  8017ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b8:	f7 75 f0             	divl   -0x10(%ebp)
  8017bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017be:	29 d0                	sub    %edx,%eax
  8017c0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8017c3:	e8 c4 06 00 00       	call   801e8c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017c8:	83 f8 01             	cmp    $0x1,%eax
  8017cb:	75 42                	jne    80180f <smalloc+0x97>

		  va = malloc(newsize) ;
  8017cd:	83 ec 0c             	sub    $0xc,%esp
  8017d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d3:	e8 24 fe ff ff       	call   8015fc <malloc>
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8017de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017e2:	74 24                	je     801808 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8017e4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017eb:	50                   	push   %eax
  8017ec:	ff 75 e8             	pushl  -0x18(%ebp)
  8017ef:	ff 75 08             	pushl  0x8(%ebp)
  8017f2:	e8 1a 04 00 00       	call   801c11 <sys_createSharedObject>
  8017f7:	83 c4 10             	add    $0x10,%esp
  8017fa:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8017fd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801801:	78 0c                	js     80180f <smalloc+0x97>
					  return va ;
  801803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801806:	eb 0c                	jmp    801814 <smalloc+0x9c>
				 }
				 else
					return NULL;
  801808:	b8 00 00 00 00       	mov    $0x0,%eax
  80180d:	eb 05                	jmp    801814 <smalloc+0x9c>
	  }
		  return NULL ;
  80180f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80181c:	e8 ec fb ff ff       	call   80140d <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801821:	83 ec 08             	sub    $0x8,%esp
  801824:	ff 75 0c             	pushl  0xc(%ebp)
  801827:	ff 75 08             	pushl  0x8(%ebp)
  80182a:	e8 0c 04 00 00       	call   801c3b <sys_getSizeOfSharedObject>
  80182f:	83 c4 10             	add    $0x10,%esp
  801832:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801835:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801839:	75 07                	jne    801842 <sget+0x2c>
  80183b:	b8 00 00 00 00       	mov    $0x0,%eax
  801840:	eb 75                	jmp    8018b7 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801842:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801849:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184f:	01 d0                	add    %edx,%eax
  801851:	48                   	dec    %eax
  801852:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801855:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801858:	ba 00 00 00 00       	mov    $0x0,%edx
  80185d:	f7 75 f0             	divl   -0x10(%ebp)
  801860:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801863:	29 d0                	sub    %edx,%eax
  801865:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801868:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80186f:	e8 18 06 00 00       	call   801e8c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801874:	83 f8 01             	cmp    $0x1,%eax
  801877:	75 39                	jne    8018b2 <sget+0x9c>

		  va = malloc(newsize) ;
  801879:	83 ec 0c             	sub    $0xc,%esp
  80187c:	ff 75 e8             	pushl  -0x18(%ebp)
  80187f:	e8 78 fd ff ff       	call   8015fc <malloc>
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  80188a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80188e:	74 22                	je     8018b2 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801890:	83 ec 04             	sub    $0x4,%esp
  801893:	ff 75 e0             	pushl  -0x20(%ebp)
  801896:	ff 75 0c             	pushl  0xc(%ebp)
  801899:	ff 75 08             	pushl  0x8(%ebp)
  80189c:	e8 b7 03 00 00       	call   801c58 <sys_getSharedObject>
  8018a1:	83 c4 10             	add    $0x10,%esp
  8018a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  8018a7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018ab:	78 05                	js     8018b2 <sget+0x9c>
					  return va;
  8018ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b0:	eb 05                	jmp    8018b7 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  8018b2:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018bf:	e8 49 fb ff ff       	call   80140d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018c4:	83 ec 04             	sub    $0x4,%esp
  8018c7:	68 84 3a 80 00       	push   $0x803a84
  8018cc:	68 1e 01 00 00       	push   $0x11e
  8018d1:	68 53 3a 80 00       	push   $0x803a53
  8018d6:	e8 17 18 00 00       	call   8030f2 <_panic>

008018db <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018e1:	83 ec 04             	sub    $0x4,%esp
  8018e4:	68 ac 3a 80 00       	push   $0x803aac
  8018e9:	68 32 01 00 00       	push   $0x132
  8018ee:	68 53 3a 80 00       	push   $0x803a53
  8018f3:	e8 fa 17 00 00       	call   8030f2 <_panic>

008018f8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018fe:	83 ec 04             	sub    $0x4,%esp
  801901:	68 d0 3a 80 00       	push   $0x803ad0
  801906:	68 3d 01 00 00       	push   $0x13d
  80190b:	68 53 3a 80 00       	push   $0x803a53
  801910:	e8 dd 17 00 00       	call   8030f2 <_panic>

00801915 <shrink>:

}
void shrink(uint32 newSize)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80191b:	83 ec 04             	sub    $0x4,%esp
  80191e:	68 d0 3a 80 00       	push   $0x803ad0
  801923:	68 42 01 00 00       	push   $0x142
  801928:	68 53 3a 80 00       	push   $0x803a53
  80192d:	e8 c0 17 00 00       	call   8030f2 <_panic>

00801932 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
  801935:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801938:	83 ec 04             	sub    $0x4,%esp
  80193b:	68 d0 3a 80 00       	push   $0x803ad0
  801940:	68 47 01 00 00       	push   $0x147
  801945:	68 53 3a 80 00       	push   $0x803a53
  80194a:	e8 a3 17 00 00       	call   8030f2 <_panic>

0080194f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	57                   	push   %edi
  801953:	56                   	push   %esi
  801954:	53                   	push   %ebx
  801955:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801961:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801964:	8b 7d 18             	mov    0x18(%ebp),%edi
  801967:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80196a:	cd 30                	int    $0x30
  80196c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80196f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801972:	83 c4 10             	add    $0x10,%esp
  801975:	5b                   	pop    %ebx
  801976:	5e                   	pop    %esi
  801977:	5f                   	pop    %edi
  801978:	5d                   	pop    %ebp
  801979:	c3                   	ret    

0080197a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	83 ec 04             	sub    $0x4,%esp
  801980:	8b 45 10             	mov    0x10(%ebp),%eax
  801983:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801986:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	52                   	push   %edx
  801992:	ff 75 0c             	pushl  0xc(%ebp)
  801995:	50                   	push   %eax
  801996:	6a 00                	push   $0x0
  801998:	e8 b2 ff ff ff       	call   80194f <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	90                   	nop
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 01                	push   $0x1
  8019b2:	e8 98 ff ff ff       	call   80194f <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	52                   	push   %edx
  8019cc:	50                   	push   %eax
  8019cd:	6a 05                	push   $0x5
  8019cf:	e8 7b ff ff ff       	call   80194f <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	56                   	push   %esi
  8019dd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019de:	8b 75 18             	mov    0x18(%ebp),%esi
  8019e1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	56                   	push   %esi
  8019ee:	53                   	push   %ebx
  8019ef:	51                   	push   %ecx
  8019f0:	52                   	push   %edx
  8019f1:	50                   	push   %eax
  8019f2:	6a 06                	push   $0x6
  8019f4:	e8 56 ff ff ff       	call   80194f <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ff:	5b                   	pop    %ebx
  801a00:	5e                   	pop    %esi
  801a01:	5d                   	pop    %ebp
  801a02:	c3                   	ret    

00801a03 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	52                   	push   %edx
  801a13:	50                   	push   %eax
  801a14:	6a 07                	push   $0x7
  801a16:	e8 34 ff ff ff       	call   80194f <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	ff 75 0c             	pushl  0xc(%ebp)
  801a2c:	ff 75 08             	pushl  0x8(%ebp)
  801a2f:	6a 08                	push   $0x8
  801a31:	e8 19 ff ff ff       	call   80194f <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 09                	push   $0x9
  801a4a:	e8 00 ff ff ff       	call   80194f <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 0a                	push   $0xa
  801a63:	e8 e7 fe ff ff       	call   80194f <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 0b                	push   $0xb
  801a7c:	e8 ce fe ff ff       	call   80194f <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	ff 75 0c             	pushl  0xc(%ebp)
  801a92:	ff 75 08             	pushl  0x8(%ebp)
  801a95:	6a 0f                	push   $0xf
  801a97:	e8 b3 fe ff ff       	call   80194f <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
	return;
  801a9f:	90                   	nop
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	ff 75 0c             	pushl  0xc(%ebp)
  801aae:	ff 75 08             	pushl  0x8(%ebp)
  801ab1:	6a 10                	push   $0x10
  801ab3:	e8 97 fe ff ff       	call   80194f <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
	return ;
  801abb:	90                   	nop
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	ff 75 10             	pushl  0x10(%ebp)
  801ac8:	ff 75 0c             	pushl  0xc(%ebp)
  801acb:	ff 75 08             	pushl  0x8(%ebp)
  801ace:	6a 11                	push   $0x11
  801ad0:	e8 7a fe ff ff       	call   80194f <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad8:	90                   	nop
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 0c                	push   $0xc
  801aea:	e8 60 fe ff ff       	call   80194f <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	ff 75 08             	pushl  0x8(%ebp)
  801b02:	6a 0d                	push   $0xd
  801b04:	e8 46 fe ff ff       	call   80194f <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 0e                	push   $0xe
  801b1d:	e8 2d fe ff ff       	call   80194f <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	90                   	nop
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 13                	push   $0x13
  801b37:	e8 13 fe ff ff       	call   80194f <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	90                   	nop
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 14                	push   $0x14
  801b51:	e8 f9 fd ff ff       	call   80194f <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	90                   	nop
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_cputc>:


void
sys_cputc(const char c)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	83 ec 04             	sub    $0x4,%esp
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b68:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	50                   	push   %eax
  801b75:	6a 15                	push   $0x15
  801b77:	e8 d3 fd ff ff       	call   80194f <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	90                   	nop
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 16                	push   $0x16
  801b91:	e8 b9 fd ff ff       	call   80194f <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
}
  801b99:	90                   	nop
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	50                   	push   %eax
  801bac:	6a 17                	push   $0x17
  801bae:	e8 9c fd ff ff       	call   80194f <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	52                   	push   %edx
  801bc8:	50                   	push   %eax
  801bc9:	6a 1a                	push   $0x1a
  801bcb:	e8 7f fd ff ff       	call   80194f <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	52                   	push   %edx
  801be5:	50                   	push   %eax
  801be6:	6a 18                	push   $0x18
  801be8:	e8 62 fd ff ff       	call   80194f <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	90                   	nop
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	52                   	push   %edx
  801c03:	50                   	push   %eax
  801c04:	6a 19                	push   $0x19
  801c06:	e8 44 fd ff ff       	call   80194f <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	90                   	nop
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 04             	sub    $0x4,%esp
  801c17:	8b 45 10             	mov    0x10(%ebp),%eax
  801c1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c1d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c20:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	6a 00                	push   $0x0
  801c29:	51                   	push   %ecx
  801c2a:	52                   	push   %edx
  801c2b:	ff 75 0c             	pushl  0xc(%ebp)
  801c2e:	50                   	push   %eax
  801c2f:	6a 1b                	push   $0x1b
  801c31:	e8 19 fd ff ff       	call   80194f <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	52                   	push   %edx
  801c4b:	50                   	push   %eax
  801c4c:	6a 1c                	push   $0x1c
  801c4e:	e8 fc fc ff ff       	call   80194f <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
}
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	51                   	push   %ecx
  801c69:	52                   	push   %edx
  801c6a:	50                   	push   %eax
  801c6b:	6a 1d                	push   $0x1d
  801c6d:	e8 dd fc ff ff       	call   80194f <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	52                   	push   %edx
  801c87:	50                   	push   %eax
  801c88:	6a 1e                	push   $0x1e
  801c8a:	e8 c0 fc ff ff       	call   80194f <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
}
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 1f                	push   $0x1f
  801ca3:	e8 a7 fc ff ff       	call   80194f <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb3:	6a 00                	push   $0x0
  801cb5:	ff 75 14             	pushl  0x14(%ebp)
  801cb8:	ff 75 10             	pushl  0x10(%ebp)
  801cbb:	ff 75 0c             	pushl  0xc(%ebp)
  801cbe:	50                   	push   %eax
  801cbf:	6a 20                	push   $0x20
  801cc1:	e8 89 fc ff ff       	call   80194f <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	50                   	push   %eax
  801cda:	6a 21                	push   $0x21
  801cdc:	e8 6e fc ff ff       	call   80194f <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	90                   	nop
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	50                   	push   %eax
  801cf6:	6a 22                	push   $0x22
  801cf8:	e8 52 fc ff ff       	call   80194f <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 02                	push   $0x2
  801d11:	e8 39 fc ff ff       	call   80194f <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 03                	push   $0x3
  801d2a:	e8 20 fc ff ff       	call   80194f <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 04                	push   $0x4
  801d43:	e8 07 fc ff ff       	call   80194f <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_exit_env>:


void sys_exit_env(void)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 23                	push   $0x23
  801d5c:	e8 ee fb ff ff       	call   80194f <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
}
  801d64:	90                   	nop
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d6d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d70:	8d 50 04             	lea    0x4(%eax),%edx
  801d73:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	52                   	push   %edx
  801d7d:	50                   	push   %eax
  801d7e:	6a 24                	push   $0x24
  801d80:	e8 ca fb ff ff       	call   80194f <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
	return result;
  801d88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d91:	89 01                	mov    %eax,(%ecx)
  801d93:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	c9                   	leave  
  801d9a:	c2 04 00             	ret    $0x4

00801d9d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	ff 75 10             	pushl  0x10(%ebp)
  801da7:	ff 75 0c             	pushl  0xc(%ebp)
  801daa:	ff 75 08             	pushl  0x8(%ebp)
  801dad:	6a 12                	push   $0x12
  801daf:	e8 9b fb ff ff       	call   80194f <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
	return ;
  801db7:	90                   	nop
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <sys_rcr2>:
uint32 sys_rcr2()
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 25                	push   $0x25
  801dc9:	e8 81 fb ff ff       	call   80194f <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 04             	sub    $0x4,%esp
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ddf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	50                   	push   %eax
  801dec:	6a 26                	push   $0x26
  801dee:	e8 5c fb ff ff       	call   80194f <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
	return ;
  801df6:	90                   	nop
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <rsttst>:
void rsttst()
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 28                	push   $0x28
  801e08:	e8 42 fb ff ff       	call   80194f <syscall>
  801e0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e10:	90                   	nop
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	83 ec 04             	sub    $0x4,%esp
  801e19:	8b 45 14             	mov    0x14(%ebp),%eax
  801e1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e1f:	8b 55 18             	mov    0x18(%ebp),%edx
  801e22:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e26:	52                   	push   %edx
  801e27:	50                   	push   %eax
  801e28:	ff 75 10             	pushl  0x10(%ebp)
  801e2b:	ff 75 0c             	pushl  0xc(%ebp)
  801e2e:	ff 75 08             	pushl  0x8(%ebp)
  801e31:	6a 27                	push   $0x27
  801e33:	e8 17 fb ff ff       	call   80194f <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3b:	90                   	nop
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <chktst>:
void chktst(uint32 n)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	ff 75 08             	pushl  0x8(%ebp)
  801e4c:	6a 29                	push   $0x29
  801e4e:	e8 fc fa ff ff       	call   80194f <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
	return ;
  801e56:	90                   	nop
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <inctst>:

void inctst()
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 2a                	push   $0x2a
  801e68:	e8 e2 fa ff ff       	call   80194f <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e70:	90                   	nop
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <gettst>:
uint32 gettst()
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 2b                	push   $0x2b
  801e82:	e8 c8 fa ff ff       	call   80194f <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
  801e8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 2c                	push   $0x2c
  801e9e:	e8 ac fa ff ff       	call   80194f <syscall>
  801ea3:	83 c4 18             	add    $0x18,%esp
  801ea6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ea9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ead:	75 07                	jne    801eb6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801eaf:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb4:	eb 05                	jmp    801ebb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801eb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 2c                	push   $0x2c
  801ecf:	e8 7b fa ff ff       	call   80194f <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
  801ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801eda:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ede:	75 07                	jne    801ee7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ee0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee5:	eb 05                	jmp    801eec <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ee7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 2c                	push   $0x2c
  801f00:	e8 4a fa ff ff       	call   80194f <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
  801f08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f0b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f0f:	75 07                	jne    801f18 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f11:	b8 01 00 00 00       	mov    $0x1,%eax
  801f16:	eb 05                	jmp    801f1d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 2c                	push   $0x2c
  801f31:	e8 19 fa ff ff       	call   80194f <syscall>
  801f36:	83 c4 18             	add    $0x18,%esp
  801f39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f3c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f40:	75 07                	jne    801f49 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f42:	b8 01 00 00 00       	mov    $0x1,%eax
  801f47:	eb 05                	jmp    801f4e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4e:	c9                   	leave  
  801f4f:	c3                   	ret    

00801f50 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	ff 75 08             	pushl  0x8(%ebp)
  801f5e:	6a 2d                	push   $0x2d
  801f60:	e8 ea f9 ff ff       	call   80194f <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
	return ;
  801f68:	90                   	nop
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f6f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f72:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	6a 00                	push   $0x0
  801f7d:	53                   	push   %ebx
  801f7e:	51                   	push   %ecx
  801f7f:	52                   	push   %edx
  801f80:	50                   	push   %eax
  801f81:	6a 2e                	push   $0x2e
  801f83:	e8 c7 f9 ff ff       	call   80194f <syscall>
  801f88:	83 c4 18             	add    $0x18,%esp
}
  801f8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	52                   	push   %edx
  801fa0:	50                   	push   %eax
  801fa1:	6a 2f                	push   $0x2f
  801fa3:	e8 a7 f9 ff ff       	call   80194f <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fb3:	83 ec 0c             	sub    $0xc,%esp
  801fb6:	68 e0 3a 80 00       	push   $0x803ae0
  801fbb:	e8 c3 e6 ff ff       	call   800683 <cprintf>
  801fc0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fc3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fca:	83 ec 0c             	sub    $0xc,%esp
  801fcd:	68 0c 3b 80 00       	push   $0x803b0c
  801fd2:	e8 ac e6 ff ff       	call   800683 <cprintf>
  801fd7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fda:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fde:	a1 38 41 80 00       	mov    0x804138,%eax
  801fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe6:	eb 56                	jmp    80203e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fe8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fec:	74 1c                	je     80200a <print_mem_block_lists+0x5d>
  801fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff1:	8b 50 08             	mov    0x8(%eax),%edx
  801ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff7:	8b 48 08             	mov    0x8(%eax),%ecx
  801ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffd:	8b 40 0c             	mov    0xc(%eax),%eax
  802000:	01 c8                	add    %ecx,%eax
  802002:	39 c2                	cmp    %eax,%edx
  802004:	73 04                	jae    80200a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802006:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80200a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200d:	8b 50 08             	mov    0x8(%eax),%edx
  802010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802013:	8b 40 0c             	mov    0xc(%eax),%eax
  802016:	01 c2                	add    %eax,%edx
  802018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201b:	8b 40 08             	mov    0x8(%eax),%eax
  80201e:	83 ec 04             	sub    $0x4,%esp
  802021:	52                   	push   %edx
  802022:	50                   	push   %eax
  802023:	68 21 3b 80 00       	push   $0x803b21
  802028:	e8 56 e6 ff ff       	call   800683 <cprintf>
  80202d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802033:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802036:	a1 40 41 80 00       	mov    0x804140,%eax
  80203b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802042:	74 07                	je     80204b <print_mem_block_lists+0x9e>
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	8b 00                	mov    (%eax),%eax
  802049:	eb 05                	jmp    802050 <print_mem_block_lists+0xa3>
  80204b:	b8 00 00 00 00       	mov    $0x0,%eax
  802050:	a3 40 41 80 00       	mov    %eax,0x804140
  802055:	a1 40 41 80 00       	mov    0x804140,%eax
  80205a:	85 c0                	test   %eax,%eax
  80205c:	75 8a                	jne    801fe8 <print_mem_block_lists+0x3b>
  80205e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802062:	75 84                	jne    801fe8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802064:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802068:	75 10                	jne    80207a <print_mem_block_lists+0xcd>
  80206a:	83 ec 0c             	sub    $0xc,%esp
  80206d:	68 30 3b 80 00       	push   $0x803b30
  802072:	e8 0c e6 ff ff       	call   800683 <cprintf>
  802077:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80207a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802081:	83 ec 0c             	sub    $0xc,%esp
  802084:	68 54 3b 80 00       	push   $0x803b54
  802089:	e8 f5 e5 ff ff       	call   800683 <cprintf>
  80208e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802091:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802095:	a1 40 40 80 00       	mov    0x804040,%eax
  80209a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80209d:	eb 56                	jmp    8020f5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80209f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020a3:	74 1c                	je     8020c1 <print_mem_block_lists+0x114>
  8020a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a8:	8b 50 08             	mov    0x8(%eax),%edx
  8020ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ae:	8b 48 08             	mov    0x8(%eax),%ecx
  8020b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b7:	01 c8                	add    %ecx,%eax
  8020b9:	39 c2                	cmp    %eax,%edx
  8020bb:	73 04                	jae    8020c1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020bd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c4:	8b 50 08             	mov    0x8(%eax),%edx
  8020c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8020cd:	01 c2                	add    %eax,%edx
  8020cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d2:	8b 40 08             	mov    0x8(%eax),%eax
  8020d5:	83 ec 04             	sub    $0x4,%esp
  8020d8:	52                   	push   %edx
  8020d9:	50                   	push   %eax
  8020da:	68 21 3b 80 00       	push   $0x803b21
  8020df:	e8 9f e5 ff ff       	call   800683 <cprintf>
  8020e4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020ed:	a1 48 40 80 00       	mov    0x804048,%eax
  8020f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f9:	74 07                	je     802102 <print_mem_block_lists+0x155>
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	8b 00                	mov    (%eax),%eax
  802100:	eb 05                	jmp    802107 <print_mem_block_lists+0x15a>
  802102:	b8 00 00 00 00       	mov    $0x0,%eax
  802107:	a3 48 40 80 00       	mov    %eax,0x804048
  80210c:	a1 48 40 80 00       	mov    0x804048,%eax
  802111:	85 c0                	test   %eax,%eax
  802113:	75 8a                	jne    80209f <print_mem_block_lists+0xf2>
  802115:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802119:	75 84                	jne    80209f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80211b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80211f:	75 10                	jne    802131 <print_mem_block_lists+0x184>
  802121:	83 ec 0c             	sub    $0xc,%esp
  802124:	68 6c 3b 80 00       	push   $0x803b6c
  802129:	e8 55 e5 ff ff       	call   800683 <cprintf>
  80212e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802131:	83 ec 0c             	sub    $0xc,%esp
  802134:	68 e0 3a 80 00       	push   $0x803ae0
  802139:	e8 45 e5 ff ff       	call   800683 <cprintf>
  80213e:	83 c4 10             	add    $0x10,%esp

}
  802141:	90                   	nop
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  80214a:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802151:	00 00 00 
  802154:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80215b:	00 00 00 
  80215e:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802165:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802168:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80216f:	e9 9e 00 00 00       	jmp    802212 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802174:	a1 50 40 80 00       	mov    0x804050,%eax
  802179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217c:	c1 e2 04             	shl    $0x4,%edx
  80217f:	01 d0                	add    %edx,%eax
  802181:	85 c0                	test   %eax,%eax
  802183:	75 14                	jne    802199 <initialize_MemBlocksList+0x55>
  802185:	83 ec 04             	sub    $0x4,%esp
  802188:	68 94 3b 80 00       	push   $0x803b94
  80218d:	6a 47                	push   $0x47
  80218f:	68 b7 3b 80 00       	push   $0x803bb7
  802194:	e8 59 0f 00 00       	call   8030f2 <_panic>
  802199:	a1 50 40 80 00       	mov    0x804050,%eax
  80219e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a1:	c1 e2 04             	shl    $0x4,%edx
  8021a4:	01 d0                	add    %edx,%eax
  8021a6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8021ac:	89 10                	mov    %edx,(%eax)
  8021ae:	8b 00                	mov    (%eax),%eax
  8021b0:	85 c0                	test   %eax,%eax
  8021b2:	74 18                	je     8021cc <initialize_MemBlocksList+0x88>
  8021b4:	a1 48 41 80 00       	mov    0x804148,%eax
  8021b9:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8021bf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021c2:	c1 e1 04             	shl    $0x4,%ecx
  8021c5:	01 ca                	add    %ecx,%edx
  8021c7:	89 50 04             	mov    %edx,0x4(%eax)
  8021ca:	eb 12                	jmp    8021de <initialize_MemBlocksList+0x9a>
  8021cc:	a1 50 40 80 00       	mov    0x804050,%eax
  8021d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d4:	c1 e2 04             	shl    $0x4,%edx
  8021d7:	01 d0                	add    %edx,%eax
  8021d9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021de:	a1 50 40 80 00       	mov    0x804050,%eax
  8021e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e6:	c1 e2 04             	shl    $0x4,%edx
  8021e9:	01 d0                	add    %edx,%eax
  8021eb:	a3 48 41 80 00       	mov    %eax,0x804148
  8021f0:	a1 50 40 80 00       	mov    0x804050,%eax
  8021f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f8:	c1 e2 04             	shl    $0x4,%edx
  8021fb:	01 d0                	add    %edx,%eax
  8021fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802204:	a1 54 41 80 00       	mov    0x804154,%eax
  802209:	40                   	inc    %eax
  80220a:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80220f:	ff 45 f4             	incl   -0xc(%ebp)
  802212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802215:	3b 45 08             	cmp    0x8(%ebp),%eax
  802218:	0f 82 56 ff ff ff    	jb     802174 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  80221e:	90                   	nop
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	8b 00                	mov    (%eax),%eax
  80222c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80222f:	eb 19                	jmp    80224a <find_block+0x29>
	{
		if(element->sva == va){
  802231:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802234:	8b 40 08             	mov    0x8(%eax),%eax
  802237:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80223a:	75 05                	jne    802241 <find_block+0x20>
			 		return element;
  80223c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80223f:	eb 36                	jmp    802277 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	8b 40 08             	mov    0x8(%eax),%eax
  802247:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80224a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80224e:	74 07                	je     802257 <find_block+0x36>
  802250:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802253:	8b 00                	mov    (%eax),%eax
  802255:	eb 05                	jmp    80225c <find_block+0x3b>
  802257:	b8 00 00 00 00       	mov    $0x0,%eax
  80225c:	8b 55 08             	mov    0x8(%ebp),%edx
  80225f:	89 42 08             	mov    %eax,0x8(%edx)
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	8b 40 08             	mov    0x8(%eax),%eax
  802268:	85 c0                	test   %eax,%eax
  80226a:	75 c5                	jne    802231 <find_block+0x10>
  80226c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802270:	75 bf                	jne    802231 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802272:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80227f:	a1 44 40 80 00       	mov    0x804044,%eax
  802284:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802287:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80228c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80228f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802293:	74 0a                	je     80229f <insert_sorted_allocList+0x26>
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	8b 40 08             	mov    0x8(%eax),%eax
  80229b:	85 c0                	test   %eax,%eax
  80229d:	75 65                	jne    802304 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80229f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a3:	75 14                	jne    8022b9 <insert_sorted_allocList+0x40>
  8022a5:	83 ec 04             	sub    $0x4,%esp
  8022a8:	68 94 3b 80 00       	push   $0x803b94
  8022ad:	6a 6e                	push   $0x6e
  8022af:	68 b7 3b 80 00       	push   $0x803bb7
  8022b4:	e8 39 0e 00 00       	call   8030f2 <_panic>
  8022b9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	89 10                	mov    %edx,(%eax)
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	8b 00                	mov    (%eax),%eax
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	74 0d                	je     8022da <insert_sorted_allocList+0x61>
  8022cd:	a1 40 40 80 00       	mov    0x804040,%eax
  8022d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d5:	89 50 04             	mov    %edx,0x4(%eax)
  8022d8:	eb 08                	jmp    8022e2 <insert_sorted_allocList+0x69>
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	a3 44 40 80 00       	mov    %eax,0x804044
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	a3 40 40 80 00       	mov    %eax,0x804040
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022f9:	40                   	inc    %eax
  8022fa:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022ff:	e9 cf 01 00 00       	jmp    8024d3 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802304:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802307:	8b 50 08             	mov    0x8(%eax),%edx
  80230a:	8b 45 08             	mov    0x8(%ebp),%eax
  80230d:	8b 40 08             	mov    0x8(%eax),%eax
  802310:	39 c2                	cmp    %eax,%edx
  802312:	73 65                	jae    802379 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802314:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802318:	75 14                	jne    80232e <insert_sorted_allocList+0xb5>
  80231a:	83 ec 04             	sub    $0x4,%esp
  80231d:	68 d0 3b 80 00       	push   $0x803bd0
  802322:	6a 72                	push   $0x72
  802324:	68 b7 3b 80 00       	push   $0x803bb7
  802329:	e8 c4 0d 00 00       	call   8030f2 <_panic>
  80232e:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	89 50 04             	mov    %edx,0x4(%eax)
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	8b 40 04             	mov    0x4(%eax),%eax
  802340:	85 c0                	test   %eax,%eax
  802342:	74 0c                	je     802350 <insert_sorted_allocList+0xd7>
  802344:	a1 44 40 80 00       	mov    0x804044,%eax
  802349:	8b 55 08             	mov    0x8(%ebp),%edx
  80234c:	89 10                	mov    %edx,(%eax)
  80234e:	eb 08                	jmp    802358 <insert_sorted_allocList+0xdf>
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	a3 40 40 80 00       	mov    %eax,0x804040
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	a3 44 40 80 00       	mov    %eax,0x804044
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802369:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80236e:	40                   	inc    %eax
  80236f:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802374:	e9 5a 01 00 00       	jmp    8024d3 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237c:	8b 50 08             	mov    0x8(%eax),%edx
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	8b 40 08             	mov    0x8(%eax),%eax
  802385:	39 c2                	cmp    %eax,%edx
  802387:	75 70                	jne    8023f9 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802389:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80238d:	74 06                	je     802395 <insert_sorted_allocList+0x11c>
  80238f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802393:	75 14                	jne    8023a9 <insert_sorted_allocList+0x130>
  802395:	83 ec 04             	sub    $0x4,%esp
  802398:	68 f4 3b 80 00       	push   $0x803bf4
  80239d:	6a 75                	push   $0x75
  80239f:	68 b7 3b 80 00       	push   $0x803bb7
  8023a4:	e8 49 0d 00 00       	call   8030f2 <_panic>
  8023a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ac:	8b 10                	mov    (%eax),%edx
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	89 10                	mov    %edx,(%eax)
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	8b 00                	mov    (%eax),%eax
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	74 0b                	je     8023c7 <insert_sorted_allocList+0x14e>
  8023bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bf:	8b 00                	mov    (%eax),%eax
  8023c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c4:	89 50 04             	mov    %edx,0x4(%eax)
  8023c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8023cd:	89 10                	mov    %edx,(%eax)
  8023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023d5:	89 50 04             	mov    %edx,0x4(%eax)
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	8b 00                	mov    (%eax),%eax
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	75 08                	jne    8023e9 <insert_sorted_allocList+0x170>
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	a3 44 40 80 00       	mov    %eax,0x804044
  8023e9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023ee:	40                   	inc    %eax
  8023ef:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8023f4:	e9 da 00 00 00       	jmp    8024d3 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8023f9:	a1 40 40 80 00       	mov    0x804040,%eax
  8023fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802401:	e9 9d 00 00 00       	jmp    8024a3 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	8b 00                	mov    (%eax),%eax
  80240b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	8b 50 08             	mov    0x8(%eax),%edx
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	8b 40 08             	mov    0x8(%eax),%eax
  80241a:	39 c2                	cmp    %eax,%edx
  80241c:	76 7d                	jbe    80249b <insert_sorted_allocList+0x222>
  80241e:	8b 45 08             	mov    0x8(%ebp),%eax
  802421:	8b 50 08             	mov    0x8(%eax),%edx
  802424:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802427:	8b 40 08             	mov    0x8(%eax),%eax
  80242a:	39 c2                	cmp    %eax,%edx
  80242c:	73 6d                	jae    80249b <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80242e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802432:	74 06                	je     80243a <insert_sorted_allocList+0x1c1>
  802434:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802438:	75 14                	jne    80244e <insert_sorted_allocList+0x1d5>
  80243a:	83 ec 04             	sub    $0x4,%esp
  80243d:	68 f4 3b 80 00       	push   $0x803bf4
  802442:	6a 7c                	push   $0x7c
  802444:	68 b7 3b 80 00       	push   $0x803bb7
  802449:	e8 a4 0c 00 00       	call   8030f2 <_panic>
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	8b 10                	mov    (%eax),%edx
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	89 10                	mov    %edx,(%eax)
  802458:	8b 45 08             	mov    0x8(%ebp),%eax
  80245b:	8b 00                	mov    (%eax),%eax
  80245d:	85 c0                	test   %eax,%eax
  80245f:	74 0b                	je     80246c <insert_sorted_allocList+0x1f3>
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	8b 00                	mov    (%eax),%eax
  802466:	8b 55 08             	mov    0x8(%ebp),%edx
  802469:	89 50 04             	mov    %edx,0x4(%eax)
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 55 08             	mov    0x8(%ebp),%edx
  802472:	89 10                	mov    %edx,(%eax)
  802474:	8b 45 08             	mov    0x8(%ebp),%eax
  802477:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247a:	89 50 04             	mov    %edx,0x4(%eax)
  80247d:	8b 45 08             	mov    0x8(%ebp),%eax
  802480:	8b 00                	mov    (%eax),%eax
  802482:	85 c0                	test   %eax,%eax
  802484:	75 08                	jne    80248e <insert_sorted_allocList+0x215>
  802486:	8b 45 08             	mov    0x8(%ebp),%eax
  802489:	a3 44 40 80 00       	mov    %eax,0x804044
  80248e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802493:	40                   	inc    %eax
  802494:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802499:	eb 38                	jmp    8024d3 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80249b:	a1 48 40 80 00       	mov    0x804048,%eax
  8024a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a7:	74 07                	je     8024b0 <insert_sorted_allocList+0x237>
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 00                	mov    (%eax),%eax
  8024ae:	eb 05                	jmp    8024b5 <insert_sorted_allocList+0x23c>
  8024b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b5:	a3 48 40 80 00       	mov    %eax,0x804048
  8024ba:	a1 48 40 80 00       	mov    0x804048,%eax
  8024bf:	85 c0                	test   %eax,%eax
  8024c1:	0f 85 3f ff ff ff    	jne    802406 <insert_sorted_allocList+0x18d>
  8024c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cb:	0f 85 35 ff ff ff    	jne    802406 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8024d1:	eb 00                	jmp    8024d3 <insert_sorted_allocList+0x25a>
  8024d3:	90                   	nop
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8024dc:	a1 38 41 80 00       	mov    0x804138,%eax
  8024e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e4:	e9 6b 02 00 00       	jmp    802754 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f2:	0f 85 90 00 00 00    	jne    802588 <alloc_block_FF+0xb2>
			  temp=element;
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8024fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802502:	75 17                	jne    80251b <alloc_block_FF+0x45>
  802504:	83 ec 04             	sub    $0x4,%esp
  802507:	68 28 3c 80 00       	push   $0x803c28
  80250c:	68 92 00 00 00       	push   $0x92
  802511:	68 b7 3b 80 00       	push   $0x803bb7
  802516:	e8 d7 0b 00 00       	call   8030f2 <_panic>
  80251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251e:	8b 00                	mov    (%eax),%eax
  802520:	85 c0                	test   %eax,%eax
  802522:	74 10                	je     802534 <alloc_block_FF+0x5e>
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 00                	mov    (%eax),%eax
  802529:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252c:	8b 52 04             	mov    0x4(%edx),%edx
  80252f:	89 50 04             	mov    %edx,0x4(%eax)
  802532:	eb 0b                	jmp    80253f <alloc_block_FF+0x69>
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 40 04             	mov    0x4(%eax),%eax
  80253a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	8b 40 04             	mov    0x4(%eax),%eax
  802545:	85 c0                	test   %eax,%eax
  802547:	74 0f                	je     802558 <alloc_block_FF+0x82>
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 40 04             	mov    0x4(%eax),%eax
  80254f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802552:	8b 12                	mov    (%edx),%edx
  802554:	89 10                	mov    %edx,(%eax)
  802556:	eb 0a                	jmp    802562 <alloc_block_FF+0x8c>
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 00                	mov    (%eax),%eax
  80255d:	a3 38 41 80 00       	mov    %eax,0x804138
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802575:	a1 44 41 80 00       	mov    0x804144,%eax
  80257a:	48                   	dec    %eax
  80257b:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802580:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802583:	e9 ff 01 00 00       	jmp    802787 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 40 0c             	mov    0xc(%eax),%eax
  80258e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802591:	0f 86 b5 01 00 00    	jbe    80274c <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 40 0c             	mov    0xc(%eax),%eax
  80259d:	2b 45 08             	sub    0x8(%ebp),%eax
  8025a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  8025a3:	a1 48 41 80 00       	mov    0x804148,%eax
  8025a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  8025ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025af:	75 17                	jne    8025c8 <alloc_block_FF+0xf2>
  8025b1:	83 ec 04             	sub    $0x4,%esp
  8025b4:	68 28 3c 80 00       	push   $0x803c28
  8025b9:	68 99 00 00 00       	push   $0x99
  8025be:	68 b7 3b 80 00       	push   $0x803bb7
  8025c3:	e8 2a 0b 00 00       	call   8030f2 <_panic>
  8025c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025cb:	8b 00                	mov    (%eax),%eax
  8025cd:	85 c0                	test   %eax,%eax
  8025cf:	74 10                	je     8025e1 <alloc_block_FF+0x10b>
  8025d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d4:	8b 00                	mov    (%eax),%eax
  8025d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025d9:	8b 52 04             	mov    0x4(%edx),%edx
  8025dc:	89 50 04             	mov    %edx,0x4(%eax)
  8025df:	eb 0b                	jmp    8025ec <alloc_block_FF+0x116>
  8025e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e4:	8b 40 04             	mov    0x4(%eax),%eax
  8025e7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ef:	8b 40 04             	mov    0x4(%eax),%eax
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	74 0f                	je     802605 <alloc_block_FF+0x12f>
  8025f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f9:	8b 40 04             	mov    0x4(%eax),%eax
  8025fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025ff:	8b 12                	mov    (%edx),%edx
  802601:	89 10                	mov    %edx,(%eax)
  802603:	eb 0a                	jmp    80260f <alloc_block_FF+0x139>
  802605:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802608:	8b 00                	mov    (%eax),%eax
  80260a:	a3 48 41 80 00       	mov    %eax,0x804148
  80260f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802612:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802618:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802622:	a1 54 41 80 00       	mov    0x804154,%eax
  802627:	48                   	dec    %eax
  802628:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  80262d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802631:	75 17                	jne    80264a <alloc_block_FF+0x174>
  802633:	83 ec 04             	sub    $0x4,%esp
  802636:	68 d0 3b 80 00       	push   $0x803bd0
  80263b:	68 9a 00 00 00       	push   $0x9a
  802640:	68 b7 3b 80 00       	push   $0x803bb7
  802645:	e8 a8 0a 00 00       	call   8030f2 <_panic>
  80264a:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802650:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802653:	89 50 04             	mov    %edx,0x4(%eax)
  802656:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802659:	8b 40 04             	mov    0x4(%eax),%eax
  80265c:	85 c0                	test   %eax,%eax
  80265e:	74 0c                	je     80266c <alloc_block_FF+0x196>
  802660:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802665:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802668:	89 10                	mov    %edx,(%eax)
  80266a:	eb 08                	jmp    802674 <alloc_block_FF+0x19e>
  80266c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266f:	a3 38 41 80 00       	mov    %eax,0x804138
  802674:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802677:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80267c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802685:	a1 44 41 80 00       	mov    0x804144,%eax
  80268a:	40                   	inc    %eax
  80268b:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802690:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802693:	8b 55 08             	mov    0x8(%ebp),%edx
  802696:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 50 08             	mov    0x8(%eax),%edx
  80269f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a2:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026ab:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 50 08             	mov    0x8(%eax),%edx
  8026b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b7:	01 c2                	add    %eax,%edx
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8026bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8026c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026c9:	75 17                	jne    8026e2 <alloc_block_FF+0x20c>
  8026cb:	83 ec 04             	sub    $0x4,%esp
  8026ce:	68 28 3c 80 00       	push   $0x803c28
  8026d3:	68 a2 00 00 00       	push   $0xa2
  8026d8:	68 b7 3b 80 00       	push   $0x803bb7
  8026dd:	e8 10 0a 00 00       	call   8030f2 <_panic>
  8026e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e5:	8b 00                	mov    (%eax),%eax
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	74 10                	je     8026fb <alloc_block_FF+0x225>
  8026eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ee:	8b 00                	mov    (%eax),%eax
  8026f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026f3:	8b 52 04             	mov    0x4(%edx),%edx
  8026f6:	89 50 04             	mov    %edx,0x4(%eax)
  8026f9:	eb 0b                	jmp    802706 <alloc_block_FF+0x230>
  8026fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fe:	8b 40 04             	mov    0x4(%eax),%eax
  802701:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802706:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802709:	8b 40 04             	mov    0x4(%eax),%eax
  80270c:	85 c0                	test   %eax,%eax
  80270e:	74 0f                	je     80271f <alloc_block_FF+0x249>
  802710:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802713:	8b 40 04             	mov    0x4(%eax),%eax
  802716:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802719:	8b 12                	mov    (%edx),%edx
  80271b:	89 10                	mov    %edx,(%eax)
  80271d:	eb 0a                	jmp    802729 <alloc_block_FF+0x253>
  80271f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802722:	8b 00                	mov    (%eax),%eax
  802724:	a3 38 41 80 00       	mov    %eax,0x804138
  802729:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802732:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802735:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273c:	a1 44 41 80 00       	mov    0x804144,%eax
  802741:	48                   	dec    %eax
  802742:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  802747:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274a:	eb 3b                	jmp    802787 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80274c:	a1 40 41 80 00       	mov    0x804140,%eax
  802751:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802754:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802758:	74 07                	je     802761 <alloc_block_FF+0x28b>
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 00                	mov    (%eax),%eax
  80275f:	eb 05                	jmp    802766 <alloc_block_FF+0x290>
  802761:	b8 00 00 00 00       	mov    $0x0,%eax
  802766:	a3 40 41 80 00       	mov    %eax,0x804140
  80276b:	a1 40 41 80 00       	mov    0x804140,%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	0f 85 71 fd ff ff    	jne    8024e9 <alloc_block_FF+0x13>
  802778:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277c:	0f 85 67 fd ff ff    	jne    8024e9 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802782:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802787:	c9                   	leave  
  802788:	c3                   	ret    

00802789 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802789:	55                   	push   %ebp
  80278a:	89 e5                	mov    %esp,%ebp
  80278c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  80278f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802796:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80279d:	a1 38 41 80 00       	mov    0x804138,%eax
  8027a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8027a5:	e9 d3 00 00 00       	jmp    80287d <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  8027aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b3:	0f 85 90 00 00 00    	jne    802849 <alloc_block_BF+0xc0>
	   temp = element;
  8027b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8027bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027c3:	75 17                	jne    8027dc <alloc_block_BF+0x53>
  8027c5:	83 ec 04             	sub    $0x4,%esp
  8027c8:	68 28 3c 80 00       	push   $0x803c28
  8027cd:	68 bd 00 00 00       	push   $0xbd
  8027d2:	68 b7 3b 80 00       	push   $0x803bb7
  8027d7:	e8 16 09 00 00       	call   8030f2 <_panic>
  8027dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	85 c0                	test   %eax,%eax
  8027e3:	74 10                	je     8027f5 <alloc_block_BF+0x6c>
  8027e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e8:	8b 00                	mov    (%eax),%eax
  8027ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027ed:	8b 52 04             	mov    0x4(%edx),%edx
  8027f0:	89 50 04             	mov    %edx,0x4(%eax)
  8027f3:	eb 0b                	jmp    802800 <alloc_block_BF+0x77>
  8027f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f8:	8b 40 04             	mov    0x4(%eax),%eax
  8027fb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	85 c0                	test   %eax,%eax
  802808:	74 0f                	je     802819 <alloc_block_BF+0x90>
  80280a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280d:	8b 40 04             	mov    0x4(%eax),%eax
  802810:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802813:	8b 12                	mov    (%edx),%edx
  802815:	89 10                	mov    %edx,(%eax)
  802817:	eb 0a                	jmp    802823 <alloc_block_BF+0x9a>
  802819:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80281c:	8b 00                	mov    (%eax),%eax
  80281e:	a3 38 41 80 00       	mov    %eax,0x804138
  802823:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802826:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80282f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802836:	a1 44 41 80 00       	mov    0x804144,%eax
  80283b:	48                   	dec    %eax
  80283c:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802841:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802844:	e9 41 01 00 00       	jmp    80298a <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802849:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80284c:	8b 40 0c             	mov    0xc(%eax),%eax
  80284f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802852:	76 21                	jbe    802875 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802854:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802857:	8b 40 0c             	mov    0xc(%eax),%eax
  80285a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80285d:	73 16                	jae    802875 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  80285f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802862:	8b 40 0c             	mov    0xc(%eax),%eax
  802865:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802868:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80286b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  80286e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802875:	a1 40 41 80 00       	mov    0x804140,%eax
  80287a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80287d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802881:	74 07                	je     80288a <alloc_block_BF+0x101>
  802883:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802886:	8b 00                	mov    (%eax),%eax
  802888:	eb 05                	jmp    80288f <alloc_block_BF+0x106>
  80288a:	b8 00 00 00 00       	mov    $0x0,%eax
  80288f:	a3 40 41 80 00       	mov    %eax,0x804140
  802894:	a1 40 41 80 00       	mov    0x804140,%eax
  802899:	85 c0                	test   %eax,%eax
  80289b:	0f 85 09 ff ff ff    	jne    8027aa <alloc_block_BF+0x21>
  8028a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028a5:	0f 85 ff fe ff ff    	jne    8027aa <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  8028ab:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8028af:	0f 85 d0 00 00 00    	jne    802985 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  8028b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bb:	2b 45 08             	sub    0x8(%ebp),%eax
  8028be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8028c1:	a1 48 41 80 00       	mov    0x804148,%eax
  8028c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8028c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028cd:	75 17                	jne    8028e6 <alloc_block_BF+0x15d>
  8028cf:	83 ec 04             	sub    $0x4,%esp
  8028d2:	68 28 3c 80 00       	push   $0x803c28
  8028d7:	68 d1 00 00 00       	push   $0xd1
  8028dc:	68 b7 3b 80 00       	push   $0x803bb7
  8028e1:	e8 0c 08 00 00       	call   8030f2 <_panic>
  8028e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e9:	8b 00                	mov    (%eax),%eax
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	74 10                	je     8028ff <alloc_block_BF+0x176>
  8028ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f2:	8b 00                	mov    (%eax),%eax
  8028f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028f7:	8b 52 04             	mov    0x4(%edx),%edx
  8028fa:	89 50 04             	mov    %edx,0x4(%eax)
  8028fd:	eb 0b                	jmp    80290a <alloc_block_BF+0x181>
  8028ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802902:	8b 40 04             	mov    0x4(%eax),%eax
  802905:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80290a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290d:	8b 40 04             	mov    0x4(%eax),%eax
  802910:	85 c0                	test   %eax,%eax
  802912:	74 0f                	je     802923 <alloc_block_BF+0x19a>
  802914:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802917:	8b 40 04             	mov    0x4(%eax),%eax
  80291a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80291d:	8b 12                	mov    (%edx),%edx
  80291f:	89 10                	mov    %edx,(%eax)
  802921:	eb 0a                	jmp    80292d <alloc_block_BF+0x1a4>
  802923:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	a3 48 41 80 00       	mov    %eax,0x804148
  80292d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802930:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802936:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802939:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802940:	a1 54 41 80 00       	mov    0x804154,%eax
  802945:	48                   	dec    %eax
  802946:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  80294b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80294e:	8b 55 08             	mov    0x8(%ebp),%edx
  802951:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802954:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802957:	8b 50 08             	mov    0x8(%eax),%edx
  80295a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80295d:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802960:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802963:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802966:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802969:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296c:	8b 50 08             	mov    0x8(%eax),%edx
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	01 c2                	add    %eax,%edx
  802974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802977:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  80297a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80297d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802980:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802983:	eb 05                	jmp    80298a <alloc_block_BF+0x201>
	 }
	 return NULL;
  802985:	b8 00 00 00 00       	mov    $0x0,%eax


}
  80298a:	c9                   	leave  
  80298b:	c3                   	ret    

0080298c <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80298c:	55                   	push   %ebp
  80298d:	89 e5                	mov    %esp,%ebp
  80298f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802992:	83 ec 04             	sub    $0x4,%esp
  802995:	68 48 3c 80 00       	push   $0x803c48
  80299a:	68 e8 00 00 00       	push   $0xe8
  80299f:	68 b7 3b 80 00       	push   $0x803bb7
  8029a4:	e8 49 07 00 00       	call   8030f2 <_panic>

008029a9 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8029a9:	55                   	push   %ebp
  8029aa:	89 e5                	mov    %esp,%ebp
  8029ac:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  8029af:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  8029b7:	a1 38 41 80 00       	mov    0x804138,%eax
  8029bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8029bf:	a1 44 41 80 00       	mov    0x804144,%eax
  8029c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8029c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029cb:	75 68                	jne    802a35 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8029cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d1:	75 17                	jne    8029ea <insert_sorted_with_merge_freeList+0x41>
  8029d3:	83 ec 04             	sub    $0x4,%esp
  8029d6:	68 94 3b 80 00       	push   $0x803b94
  8029db:	68 36 01 00 00       	push   $0x136
  8029e0:	68 b7 3b 80 00       	push   $0x803bb7
  8029e5:	e8 08 07 00 00       	call   8030f2 <_panic>
  8029ea:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f3:	89 10                	mov    %edx,(%eax)
  8029f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f8:	8b 00                	mov    (%eax),%eax
  8029fa:	85 c0                	test   %eax,%eax
  8029fc:	74 0d                	je     802a0b <insert_sorted_with_merge_freeList+0x62>
  8029fe:	a1 38 41 80 00       	mov    0x804138,%eax
  802a03:	8b 55 08             	mov    0x8(%ebp),%edx
  802a06:	89 50 04             	mov    %edx,0x4(%eax)
  802a09:	eb 08                	jmp    802a13 <insert_sorted_with_merge_freeList+0x6a>
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	a3 38 41 80 00       	mov    %eax,0x804138
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a25:	a1 44 41 80 00       	mov    0x804144,%eax
  802a2a:	40                   	inc    %eax
  802a2b:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a30:	e9 ba 06 00 00       	jmp    8030ef <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a38:	8b 50 08             	mov    0x8(%eax),%edx
  802a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a41:	01 c2                	add    %eax,%edx
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	8b 40 08             	mov    0x8(%eax),%eax
  802a49:	39 c2                	cmp    %eax,%edx
  802a4b:	73 68                	jae    802ab5 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802a4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a51:	75 17                	jne    802a6a <insert_sorted_with_merge_freeList+0xc1>
  802a53:	83 ec 04             	sub    $0x4,%esp
  802a56:	68 d0 3b 80 00       	push   $0x803bd0
  802a5b:	68 3a 01 00 00       	push   $0x13a
  802a60:	68 b7 3b 80 00       	push   $0x803bb7
  802a65:	e8 88 06 00 00       	call   8030f2 <_panic>
  802a6a:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a70:	8b 45 08             	mov    0x8(%ebp),%eax
  802a73:	89 50 04             	mov    %edx,0x4(%eax)
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	8b 40 04             	mov    0x4(%eax),%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	74 0c                	je     802a8c <insert_sorted_with_merge_freeList+0xe3>
  802a80:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a85:	8b 55 08             	mov    0x8(%ebp),%edx
  802a88:	89 10                	mov    %edx,(%eax)
  802a8a:	eb 08                	jmp    802a94 <insert_sorted_with_merge_freeList+0xeb>
  802a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8f:	a3 38 41 80 00       	mov    %eax,0x804138
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa5:	a1 44 41 80 00       	mov    0x804144,%eax
  802aaa:	40                   	inc    %eax
  802aab:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802ab0:	e9 3a 06 00 00       	jmp    8030ef <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab8:	8b 50 08             	mov    0x8(%eax),%edx
  802abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abe:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac1:	01 c2                	add    %eax,%edx
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	8b 40 08             	mov    0x8(%eax),%eax
  802ac9:	39 c2                	cmp    %eax,%edx
  802acb:	0f 85 90 00 00 00    	jne    802b61 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad4:	8b 50 0c             	mov    0xc(%eax),%edx
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	8b 40 0c             	mov    0xc(%eax),%eax
  802add:	01 c2                	add    %eax,%edx
  802adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae2:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802af9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802afd:	75 17                	jne    802b16 <insert_sorted_with_merge_freeList+0x16d>
  802aff:	83 ec 04             	sub    $0x4,%esp
  802b02:	68 94 3b 80 00       	push   $0x803b94
  802b07:	68 41 01 00 00       	push   $0x141
  802b0c:	68 b7 3b 80 00       	push   $0x803bb7
  802b11:	e8 dc 05 00 00       	call   8030f2 <_panic>
  802b16:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	89 10                	mov    %edx,(%eax)
  802b21:	8b 45 08             	mov    0x8(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	74 0d                	je     802b37 <insert_sorted_with_merge_freeList+0x18e>
  802b2a:	a1 48 41 80 00       	mov    0x804148,%eax
  802b2f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b32:	89 50 04             	mov    %edx,0x4(%eax)
  802b35:	eb 08                	jmp    802b3f <insert_sorted_with_merge_freeList+0x196>
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b42:	a3 48 41 80 00       	mov    %eax,0x804148
  802b47:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b51:	a1 54 41 80 00       	mov    0x804154,%eax
  802b56:	40                   	inc    %eax
  802b57:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b5c:	e9 8e 05 00 00       	jmp    8030ef <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	8b 50 08             	mov    0x8(%eax),%edx
  802b67:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6d:	01 c2                	add    %eax,%edx
  802b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b72:	8b 40 08             	mov    0x8(%eax),%eax
  802b75:	39 c2                	cmp    %eax,%edx
  802b77:	73 68                	jae    802be1 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b7d:	75 17                	jne    802b96 <insert_sorted_with_merge_freeList+0x1ed>
  802b7f:	83 ec 04             	sub    $0x4,%esp
  802b82:	68 94 3b 80 00       	push   $0x803b94
  802b87:	68 45 01 00 00       	push   $0x145
  802b8c:	68 b7 3b 80 00       	push   $0x803bb7
  802b91:	e8 5c 05 00 00       	call   8030f2 <_panic>
  802b96:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	89 10                	mov    %edx,(%eax)
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	8b 00                	mov    (%eax),%eax
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	74 0d                	je     802bb7 <insert_sorted_with_merge_freeList+0x20e>
  802baa:	a1 38 41 80 00       	mov    0x804138,%eax
  802baf:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb2:	89 50 04             	mov    %edx,0x4(%eax)
  802bb5:	eb 08                	jmp    802bbf <insert_sorted_with_merge_freeList+0x216>
  802bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bba:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	a3 38 41 80 00       	mov    %eax,0x804138
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd1:	a1 44 41 80 00       	mov    0x804144,%eax
  802bd6:	40                   	inc    %eax
  802bd7:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802bdc:	e9 0e 05 00 00       	jmp    8030ef <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	8b 50 08             	mov    0x8(%eax),%edx
  802be7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bea:	8b 40 0c             	mov    0xc(%eax),%eax
  802bed:	01 c2                	add    %eax,%edx
  802bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf2:	8b 40 08             	mov    0x8(%eax),%eax
  802bf5:	39 c2                	cmp    %eax,%edx
  802bf7:	0f 85 9c 00 00 00    	jne    802c99 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c00:	8b 50 0c             	mov    0xc(%eax),%edx
  802c03:	8b 45 08             	mov    0x8(%ebp),%eax
  802c06:	8b 40 0c             	mov    0xc(%eax),%eax
  802c09:	01 c2                	add    %eax,%edx
  802c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0e:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	8b 50 08             	mov    0x8(%eax),%edx
  802c17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1a:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802c27:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c35:	75 17                	jne    802c4e <insert_sorted_with_merge_freeList+0x2a5>
  802c37:	83 ec 04             	sub    $0x4,%esp
  802c3a:	68 94 3b 80 00       	push   $0x803b94
  802c3f:	68 4d 01 00 00       	push   $0x14d
  802c44:	68 b7 3b 80 00       	push   $0x803bb7
  802c49:	e8 a4 04 00 00       	call   8030f2 <_panic>
  802c4e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c54:	8b 45 08             	mov    0x8(%ebp),%eax
  802c57:	89 10                	mov    %edx,(%eax)
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	8b 00                	mov    (%eax),%eax
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	74 0d                	je     802c6f <insert_sorted_with_merge_freeList+0x2c6>
  802c62:	a1 48 41 80 00       	mov    0x804148,%eax
  802c67:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6a:	89 50 04             	mov    %edx,0x4(%eax)
  802c6d:	eb 08                	jmp    802c77 <insert_sorted_with_merge_freeList+0x2ce>
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	a3 48 41 80 00       	mov    %eax,0x804148
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c89:	a1 54 41 80 00       	mov    0x804154,%eax
  802c8e:	40                   	inc    %eax
  802c8f:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802c94:	e9 56 04 00 00       	jmp    8030ef <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802c99:	a1 38 41 80 00       	mov    0x804138,%eax
  802c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca1:	e9 19 04 00 00       	jmp    8030bf <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca9:	8b 00                	mov    (%eax),%eax
  802cab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb1:	8b 50 08             	mov    0x8(%eax),%edx
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cba:	01 c2                	add    %eax,%edx
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	8b 40 08             	mov    0x8(%eax),%eax
  802cc2:	39 c2                	cmp    %eax,%edx
  802cc4:	0f 85 ad 01 00 00    	jne    802e77 <insert_sorted_with_merge_freeList+0x4ce>
  802cca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccd:	8b 50 08             	mov    0x8(%eax),%edx
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd6:	01 c2                	add    %eax,%edx
  802cd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cdb:	8b 40 08             	mov    0x8(%eax),%eax
  802cde:	39 c2                	cmp    %eax,%edx
  802ce0:	0f 85 91 01 00 00    	jne    802e77 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	8b 50 0c             	mov    0xc(%eax),%edx
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	8b 48 0c             	mov    0xc(%eax),%ecx
  802cf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf8:	01 c8                	add    %ecx,%eax
  802cfa:	01 c2                	add    %eax,%edx
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d19:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802d20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802d2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d2e:	75 17                	jne    802d47 <insert_sorted_with_merge_freeList+0x39e>
  802d30:	83 ec 04             	sub    $0x4,%esp
  802d33:	68 28 3c 80 00       	push   $0x803c28
  802d38:	68 5b 01 00 00       	push   $0x15b
  802d3d:	68 b7 3b 80 00       	push   $0x803bb7
  802d42:	e8 ab 03 00 00       	call   8030f2 <_panic>
  802d47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4a:	8b 00                	mov    (%eax),%eax
  802d4c:	85 c0                	test   %eax,%eax
  802d4e:	74 10                	je     802d60 <insert_sorted_with_merge_freeList+0x3b7>
  802d50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d53:	8b 00                	mov    (%eax),%eax
  802d55:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d58:	8b 52 04             	mov    0x4(%edx),%edx
  802d5b:	89 50 04             	mov    %edx,0x4(%eax)
  802d5e:	eb 0b                	jmp    802d6b <insert_sorted_with_merge_freeList+0x3c2>
  802d60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d63:	8b 40 04             	mov    0x4(%eax),%eax
  802d66:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d6e:	8b 40 04             	mov    0x4(%eax),%eax
  802d71:	85 c0                	test   %eax,%eax
  802d73:	74 0f                	je     802d84 <insert_sorted_with_merge_freeList+0x3db>
  802d75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d78:	8b 40 04             	mov    0x4(%eax),%eax
  802d7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d7e:	8b 12                	mov    (%edx),%edx
  802d80:	89 10                	mov    %edx,(%eax)
  802d82:	eb 0a                	jmp    802d8e <insert_sorted_with_merge_freeList+0x3e5>
  802d84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d87:	8b 00                	mov    (%eax),%eax
  802d89:	a3 38 41 80 00       	mov    %eax,0x804138
  802d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da1:	a1 44 41 80 00       	mov    0x804144,%eax
  802da6:	48                   	dec    %eax
  802da7:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db0:	75 17                	jne    802dc9 <insert_sorted_with_merge_freeList+0x420>
  802db2:	83 ec 04             	sub    $0x4,%esp
  802db5:	68 94 3b 80 00       	push   $0x803b94
  802dba:	68 5c 01 00 00       	push   $0x15c
  802dbf:	68 b7 3b 80 00       	push   $0x803bb7
  802dc4:	e8 29 03 00 00       	call   8030f2 <_panic>
  802dc9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	89 10                	mov    %edx,(%eax)
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	8b 00                	mov    (%eax),%eax
  802dd9:	85 c0                	test   %eax,%eax
  802ddb:	74 0d                	je     802dea <insert_sorted_with_merge_freeList+0x441>
  802ddd:	a1 48 41 80 00       	mov    0x804148,%eax
  802de2:	8b 55 08             	mov    0x8(%ebp),%edx
  802de5:	89 50 04             	mov    %edx,0x4(%eax)
  802de8:	eb 08                	jmp    802df2 <insert_sorted_with_merge_freeList+0x449>
  802dea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ded:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	a3 48 41 80 00       	mov    %eax,0x804148
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e04:	a1 54 41 80 00       	mov    0x804154,%eax
  802e09:	40                   	inc    %eax
  802e0a:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802e0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e13:	75 17                	jne    802e2c <insert_sorted_with_merge_freeList+0x483>
  802e15:	83 ec 04             	sub    $0x4,%esp
  802e18:	68 94 3b 80 00       	push   $0x803b94
  802e1d:	68 5d 01 00 00       	push   $0x15d
  802e22:	68 b7 3b 80 00       	push   $0x803bb7
  802e27:	e8 c6 02 00 00       	call   8030f2 <_panic>
  802e2c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e35:	89 10                	mov    %edx,(%eax)
  802e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3a:	8b 00                	mov    (%eax),%eax
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	74 0d                	je     802e4d <insert_sorted_with_merge_freeList+0x4a4>
  802e40:	a1 48 41 80 00       	mov    0x804148,%eax
  802e45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e48:	89 50 04             	mov    %edx,0x4(%eax)
  802e4b:	eb 08                	jmp    802e55 <insert_sorted_with_merge_freeList+0x4ac>
  802e4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e50:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e58:	a3 48 41 80 00       	mov    %eax,0x804148
  802e5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e67:	a1 54 41 80 00       	mov    0x804154,%eax
  802e6c:	40                   	inc    %eax
  802e6d:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e72:	e9 78 02 00 00       	jmp    8030ef <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7a:	8b 50 08             	mov    0x8(%eax),%edx
  802e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e80:	8b 40 0c             	mov    0xc(%eax),%eax
  802e83:	01 c2                	add    %eax,%edx
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	8b 40 08             	mov    0x8(%eax),%eax
  802e8b:	39 c2                	cmp    %eax,%edx
  802e8d:	0f 83 b8 00 00 00    	jae    802f4b <insert_sorted_with_merge_freeList+0x5a2>
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	8b 50 08             	mov    0x8(%eax),%edx
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9f:	01 c2                	add    %eax,%edx
  802ea1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea4:	8b 40 08             	mov    0x8(%eax),%eax
  802ea7:	39 c2                	cmp    %eax,%edx
  802ea9:	0f 85 9c 00 00 00    	jne    802f4b <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802eaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb2:	8b 50 0c             	mov    0xc(%eax),%edx
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebb:	01 c2                	add    %eax,%edx
  802ebd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec0:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec6:	8b 50 08             	mov    0x8(%eax),%edx
  802ec9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ecc:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ee3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee7:	75 17                	jne    802f00 <insert_sorted_with_merge_freeList+0x557>
  802ee9:	83 ec 04             	sub    $0x4,%esp
  802eec:	68 94 3b 80 00       	push   $0x803b94
  802ef1:	68 67 01 00 00       	push   $0x167
  802ef6:	68 b7 3b 80 00       	push   $0x803bb7
  802efb:	e8 f2 01 00 00       	call   8030f2 <_panic>
  802f00:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	89 10                	mov    %edx,(%eax)
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	8b 00                	mov    (%eax),%eax
  802f10:	85 c0                	test   %eax,%eax
  802f12:	74 0d                	je     802f21 <insert_sorted_with_merge_freeList+0x578>
  802f14:	a1 48 41 80 00       	mov    0x804148,%eax
  802f19:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1c:	89 50 04             	mov    %edx,0x4(%eax)
  802f1f:	eb 08                	jmp    802f29 <insert_sorted_with_merge_freeList+0x580>
  802f21:	8b 45 08             	mov    0x8(%ebp),%eax
  802f24:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	a3 48 41 80 00       	mov    %eax,0x804148
  802f31:	8b 45 08             	mov    0x8(%ebp),%eax
  802f34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3b:	a1 54 41 80 00       	mov    0x804154,%eax
  802f40:	40                   	inc    %eax
  802f41:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802f46:	e9 a4 01 00 00       	jmp    8030ef <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	8b 50 08             	mov    0x8(%eax),%edx
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	8b 40 0c             	mov    0xc(%eax),%eax
  802f57:	01 c2                	add    %eax,%edx
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	8b 40 08             	mov    0x8(%eax),%eax
  802f5f:	39 c2                	cmp    %eax,%edx
  802f61:	0f 85 ac 00 00 00    	jne    803013 <insert_sorted_with_merge_freeList+0x66a>
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	8b 50 08             	mov    0x8(%eax),%edx
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	8b 40 0c             	mov    0xc(%eax),%eax
  802f73:	01 c2                	add    %eax,%edx
  802f75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f78:	8b 40 08             	mov    0x8(%eax),%eax
  802f7b:	39 c2                	cmp    %eax,%edx
  802f7d:	0f 83 90 00 00 00    	jae    803013 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f86:	8b 50 0c             	mov    0xc(%eax),%edx
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8f:	01 c2                	add    %eax,%edx
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802f97:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802faf:	75 17                	jne    802fc8 <insert_sorted_with_merge_freeList+0x61f>
  802fb1:	83 ec 04             	sub    $0x4,%esp
  802fb4:	68 94 3b 80 00       	push   $0x803b94
  802fb9:	68 70 01 00 00       	push   $0x170
  802fbe:	68 b7 3b 80 00       	push   $0x803bb7
  802fc3:	e8 2a 01 00 00       	call   8030f2 <_panic>
  802fc8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	89 10                	mov    %edx,(%eax)
  802fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd6:	8b 00                	mov    (%eax),%eax
  802fd8:	85 c0                	test   %eax,%eax
  802fda:	74 0d                	je     802fe9 <insert_sorted_with_merge_freeList+0x640>
  802fdc:	a1 48 41 80 00       	mov    0x804148,%eax
  802fe1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe4:	89 50 04             	mov    %edx,0x4(%eax)
  802fe7:	eb 08                	jmp    802ff1 <insert_sorted_with_merge_freeList+0x648>
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	a3 48 41 80 00       	mov    %eax,0x804148
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803003:	a1 54 41 80 00       	mov    0x804154,%eax
  803008:	40                   	inc    %eax
  803009:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  80300e:	e9 dc 00 00 00       	jmp    8030ef <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	8b 50 08             	mov    0x8(%eax),%edx
  803019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301c:	8b 40 0c             	mov    0xc(%eax),%eax
  80301f:	01 c2                	add    %eax,%edx
  803021:	8b 45 08             	mov    0x8(%ebp),%eax
  803024:	8b 40 08             	mov    0x8(%eax),%eax
  803027:	39 c2                	cmp    %eax,%edx
  803029:	0f 83 88 00 00 00    	jae    8030b7 <insert_sorted_with_merge_freeList+0x70e>
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	8b 50 08             	mov    0x8(%eax),%edx
  803035:	8b 45 08             	mov    0x8(%ebp),%eax
  803038:	8b 40 0c             	mov    0xc(%eax),%eax
  80303b:	01 c2                	add    %eax,%edx
  80303d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803040:	8b 40 08             	mov    0x8(%eax),%eax
  803043:	39 c2                	cmp    %eax,%edx
  803045:	73 70                	jae    8030b7 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803047:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80304b:	74 06                	je     803053 <insert_sorted_with_merge_freeList+0x6aa>
  80304d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803051:	75 17                	jne    80306a <insert_sorted_with_merge_freeList+0x6c1>
  803053:	83 ec 04             	sub    $0x4,%esp
  803056:	68 f4 3b 80 00       	push   $0x803bf4
  80305b:	68 75 01 00 00       	push   $0x175
  803060:	68 b7 3b 80 00       	push   $0x803bb7
  803065:	e8 88 00 00 00       	call   8030f2 <_panic>
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 10                	mov    (%eax),%edx
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	89 10                	mov    %edx,(%eax)
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	8b 00                	mov    (%eax),%eax
  803079:	85 c0                	test   %eax,%eax
  80307b:	74 0b                	je     803088 <insert_sorted_with_merge_freeList+0x6df>
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	8b 00                	mov    (%eax),%eax
  803082:	8b 55 08             	mov    0x8(%ebp),%edx
  803085:	89 50 04             	mov    %edx,0x4(%eax)
  803088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308b:	8b 55 08             	mov    0x8(%ebp),%edx
  80308e:	89 10                	mov    %edx,(%eax)
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803096:	89 50 04             	mov    %edx,0x4(%eax)
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	75 08                	jne    8030aa <insert_sorted_with_merge_freeList+0x701>
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8030aa:	a1 44 41 80 00       	mov    0x804144,%eax
  8030af:	40                   	inc    %eax
  8030b0:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  8030b5:	eb 38                	jmp    8030ef <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8030b7:	a1 40 41 80 00       	mov    0x804140,%eax
  8030bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c3:	74 07                	je     8030cc <insert_sorted_with_merge_freeList+0x723>
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	8b 00                	mov    (%eax),%eax
  8030ca:	eb 05                	jmp    8030d1 <insert_sorted_with_merge_freeList+0x728>
  8030cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8030d1:	a3 40 41 80 00       	mov    %eax,0x804140
  8030d6:	a1 40 41 80 00       	mov    0x804140,%eax
  8030db:	85 c0                	test   %eax,%eax
  8030dd:	0f 85 c3 fb ff ff    	jne    802ca6 <insert_sorted_with_merge_freeList+0x2fd>
  8030e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e7:	0f 85 b9 fb ff ff    	jne    802ca6 <insert_sorted_with_merge_freeList+0x2fd>





}
  8030ed:	eb 00                	jmp    8030ef <insert_sorted_with_merge_freeList+0x746>
  8030ef:	90                   	nop
  8030f0:	c9                   	leave  
  8030f1:	c3                   	ret    

008030f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8030f2:	55                   	push   %ebp
  8030f3:	89 e5                	mov    %esp,%ebp
  8030f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8030f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8030fb:	83 c0 04             	add    $0x4,%eax
  8030fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803101:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803106:	85 c0                	test   %eax,%eax
  803108:	74 16                	je     803120 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80310a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80310f:	83 ec 08             	sub    $0x8,%esp
  803112:	50                   	push   %eax
  803113:	68 78 3c 80 00       	push   $0x803c78
  803118:	e8 66 d5 ff ff       	call   800683 <cprintf>
  80311d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803120:	a1 00 40 80 00       	mov    0x804000,%eax
  803125:	ff 75 0c             	pushl  0xc(%ebp)
  803128:	ff 75 08             	pushl  0x8(%ebp)
  80312b:	50                   	push   %eax
  80312c:	68 7d 3c 80 00       	push   $0x803c7d
  803131:	e8 4d d5 ff ff       	call   800683 <cprintf>
  803136:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803139:	8b 45 10             	mov    0x10(%ebp),%eax
  80313c:	83 ec 08             	sub    $0x8,%esp
  80313f:	ff 75 f4             	pushl  -0xc(%ebp)
  803142:	50                   	push   %eax
  803143:	e8 d0 d4 ff ff       	call   800618 <vcprintf>
  803148:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80314b:	83 ec 08             	sub    $0x8,%esp
  80314e:	6a 00                	push   $0x0
  803150:	68 99 3c 80 00       	push   $0x803c99
  803155:	e8 be d4 ff ff       	call   800618 <vcprintf>
  80315a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80315d:	e8 3f d4 ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  803162:	eb fe                	jmp    803162 <_panic+0x70>

00803164 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803164:	55                   	push   %ebp
  803165:	89 e5                	mov    %esp,%ebp
  803167:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80316a:	a1 20 40 80 00       	mov    0x804020,%eax
  80316f:	8b 50 74             	mov    0x74(%eax),%edx
  803172:	8b 45 0c             	mov    0xc(%ebp),%eax
  803175:	39 c2                	cmp    %eax,%edx
  803177:	74 14                	je     80318d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803179:	83 ec 04             	sub    $0x4,%esp
  80317c:	68 9c 3c 80 00       	push   $0x803c9c
  803181:	6a 26                	push   $0x26
  803183:	68 e8 3c 80 00       	push   $0x803ce8
  803188:	e8 65 ff ff ff       	call   8030f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80318d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803194:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80319b:	e9 c2 00 00 00       	jmp    803262 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8031a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	01 d0                	add    %edx,%eax
  8031af:	8b 00                	mov    (%eax),%eax
  8031b1:	85 c0                	test   %eax,%eax
  8031b3:	75 08                	jne    8031bd <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8031b5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8031b8:	e9 a2 00 00 00       	jmp    80325f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8031bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8031cb:	eb 69                	jmp    803236 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8031cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8031d2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8031d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031db:	89 d0                	mov    %edx,%eax
  8031dd:	01 c0                	add    %eax,%eax
  8031df:	01 d0                	add    %edx,%eax
  8031e1:	c1 e0 03             	shl    $0x3,%eax
  8031e4:	01 c8                	add    %ecx,%eax
  8031e6:	8a 40 04             	mov    0x4(%eax),%al
  8031e9:	84 c0                	test   %al,%al
  8031eb:	75 46                	jne    803233 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8031ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8031f2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8031f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031fb:	89 d0                	mov    %edx,%eax
  8031fd:	01 c0                	add    %eax,%eax
  8031ff:	01 d0                	add    %edx,%eax
  803201:	c1 e0 03             	shl    $0x3,%eax
  803204:	01 c8                	add    %ecx,%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80320b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80320e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803213:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803218:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	01 c8                	add    %ecx,%eax
  803224:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803226:	39 c2                	cmp    %eax,%edx
  803228:	75 09                	jne    803233 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80322a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803231:	eb 12                	jmp    803245 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803233:	ff 45 e8             	incl   -0x18(%ebp)
  803236:	a1 20 40 80 00       	mov    0x804020,%eax
  80323b:	8b 50 74             	mov    0x74(%eax),%edx
  80323e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803241:	39 c2                	cmp    %eax,%edx
  803243:	77 88                	ja     8031cd <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803245:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803249:	75 14                	jne    80325f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80324b:	83 ec 04             	sub    $0x4,%esp
  80324e:	68 f4 3c 80 00       	push   $0x803cf4
  803253:	6a 3a                	push   $0x3a
  803255:	68 e8 3c 80 00       	push   $0x803ce8
  80325a:	e8 93 fe ff ff       	call   8030f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80325f:	ff 45 f0             	incl   -0x10(%ebp)
  803262:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803265:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803268:	0f 8c 32 ff ff ff    	jl     8031a0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80326e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803275:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80327c:	eb 26                	jmp    8032a4 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80327e:	a1 20 40 80 00       	mov    0x804020,%eax
  803283:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803289:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80328c:	89 d0                	mov    %edx,%eax
  80328e:	01 c0                	add    %eax,%eax
  803290:	01 d0                	add    %edx,%eax
  803292:	c1 e0 03             	shl    $0x3,%eax
  803295:	01 c8                	add    %ecx,%eax
  803297:	8a 40 04             	mov    0x4(%eax),%al
  80329a:	3c 01                	cmp    $0x1,%al
  80329c:	75 03                	jne    8032a1 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80329e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032a1:	ff 45 e0             	incl   -0x20(%ebp)
  8032a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8032a9:	8b 50 74             	mov    0x74(%eax),%edx
  8032ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032af:	39 c2                	cmp    %eax,%edx
  8032b1:	77 cb                	ja     80327e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8032b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032b9:	74 14                	je     8032cf <CheckWSWithoutLastIndex+0x16b>
		panic(
  8032bb:	83 ec 04             	sub    $0x4,%esp
  8032be:	68 48 3d 80 00       	push   $0x803d48
  8032c3:	6a 44                	push   $0x44
  8032c5:	68 e8 3c 80 00       	push   $0x803ce8
  8032ca:	e8 23 fe ff ff       	call   8030f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8032cf:	90                   	nop
  8032d0:	c9                   	leave  
  8032d1:	c3                   	ret    
  8032d2:	66 90                	xchg   %ax,%ax

008032d4 <__udivdi3>:
  8032d4:	55                   	push   %ebp
  8032d5:	57                   	push   %edi
  8032d6:	56                   	push   %esi
  8032d7:	53                   	push   %ebx
  8032d8:	83 ec 1c             	sub    $0x1c,%esp
  8032db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8032df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032eb:	89 ca                	mov    %ecx,%edx
  8032ed:	89 f8                	mov    %edi,%eax
  8032ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032f3:	85 f6                	test   %esi,%esi
  8032f5:	75 2d                	jne    803324 <__udivdi3+0x50>
  8032f7:	39 cf                	cmp    %ecx,%edi
  8032f9:	77 65                	ja     803360 <__udivdi3+0x8c>
  8032fb:	89 fd                	mov    %edi,%ebp
  8032fd:	85 ff                	test   %edi,%edi
  8032ff:	75 0b                	jne    80330c <__udivdi3+0x38>
  803301:	b8 01 00 00 00       	mov    $0x1,%eax
  803306:	31 d2                	xor    %edx,%edx
  803308:	f7 f7                	div    %edi
  80330a:	89 c5                	mov    %eax,%ebp
  80330c:	31 d2                	xor    %edx,%edx
  80330e:	89 c8                	mov    %ecx,%eax
  803310:	f7 f5                	div    %ebp
  803312:	89 c1                	mov    %eax,%ecx
  803314:	89 d8                	mov    %ebx,%eax
  803316:	f7 f5                	div    %ebp
  803318:	89 cf                	mov    %ecx,%edi
  80331a:	89 fa                	mov    %edi,%edx
  80331c:	83 c4 1c             	add    $0x1c,%esp
  80331f:	5b                   	pop    %ebx
  803320:	5e                   	pop    %esi
  803321:	5f                   	pop    %edi
  803322:	5d                   	pop    %ebp
  803323:	c3                   	ret    
  803324:	39 ce                	cmp    %ecx,%esi
  803326:	77 28                	ja     803350 <__udivdi3+0x7c>
  803328:	0f bd fe             	bsr    %esi,%edi
  80332b:	83 f7 1f             	xor    $0x1f,%edi
  80332e:	75 40                	jne    803370 <__udivdi3+0x9c>
  803330:	39 ce                	cmp    %ecx,%esi
  803332:	72 0a                	jb     80333e <__udivdi3+0x6a>
  803334:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803338:	0f 87 9e 00 00 00    	ja     8033dc <__udivdi3+0x108>
  80333e:	b8 01 00 00 00       	mov    $0x1,%eax
  803343:	89 fa                	mov    %edi,%edx
  803345:	83 c4 1c             	add    $0x1c,%esp
  803348:	5b                   	pop    %ebx
  803349:	5e                   	pop    %esi
  80334a:	5f                   	pop    %edi
  80334b:	5d                   	pop    %ebp
  80334c:	c3                   	ret    
  80334d:	8d 76 00             	lea    0x0(%esi),%esi
  803350:	31 ff                	xor    %edi,%edi
  803352:	31 c0                	xor    %eax,%eax
  803354:	89 fa                	mov    %edi,%edx
  803356:	83 c4 1c             	add    $0x1c,%esp
  803359:	5b                   	pop    %ebx
  80335a:	5e                   	pop    %esi
  80335b:	5f                   	pop    %edi
  80335c:	5d                   	pop    %ebp
  80335d:	c3                   	ret    
  80335e:	66 90                	xchg   %ax,%ax
  803360:	89 d8                	mov    %ebx,%eax
  803362:	f7 f7                	div    %edi
  803364:	31 ff                	xor    %edi,%edi
  803366:	89 fa                	mov    %edi,%edx
  803368:	83 c4 1c             	add    $0x1c,%esp
  80336b:	5b                   	pop    %ebx
  80336c:	5e                   	pop    %esi
  80336d:	5f                   	pop    %edi
  80336e:	5d                   	pop    %ebp
  80336f:	c3                   	ret    
  803370:	bd 20 00 00 00       	mov    $0x20,%ebp
  803375:	89 eb                	mov    %ebp,%ebx
  803377:	29 fb                	sub    %edi,%ebx
  803379:	89 f9                	mov    %edi,%ecx
  80337b:	d3 e6                	shl    %cl,%esi
  80337d:	89 c5                	mov    %eax,%ebp
  80337f:	88 d9                	mov    %bl,%cl
  803381:	d3 ed                	shr    %cl,%ebp
  803383:	89 e9                	mov    %ebp,%ecx
  803385:	09 f1                	or     %esi,%ecx
  803387:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80338b:	89 f9                	mov    %edi,%ecx
  80338d:	d3 e0                	shl    %cl,%eax
  80338f:	89 c5                	mov    %eax,%ebp
  803391:	89 d6                	mov    %edx,%esi
  803393:	88 d9                	mov    %bl,%cl
  803395:	d3 ee                	shr    %cl,%esi
  803397:	89 f9                	mov    %edi,%ecx
  803399:	d3 e2                	shl    %cl,%edx
  80339b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80339f:	88 d9                	mov    %bl,%cl
  8033a1:	d3 e8                	shr    %cl,%eax
  8033a3:	09 c2                	or     %eax,%edx
  8033a5:	89 d0                	mov    %edx,%eax
  8033a7:	89 f2                	mov    %esi,%edx
  8033a9:	f7 74 24 0c          	divl   0xc(%esp)
  8033ad:	89 d6                	mov    %edx,%esi
  8033af:	89 c3                	mov    %eax,%ebx
  8033b1:	f7 e5                	mul    %ebp
  8033b3:	39 d6                	cmp    %edx,%esi
  8033b5:	72 19                	jb     8033d0 <__udivdi3+0xfc>
  8033b7:	74 0b                	je     8033c4 <__udivdi3+0xf0>
  8033b9:	89 d8                	mov    %ebx,%eax
  8033bb:	31 ff                	xor    %edi,%edi
  8033bd:	e9 58 ff ff ff       	jmp    80331a <__udivdi3+0x46>
  8033c2:	66 90                	xchg   %ax,%ax
  8033c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033c8:	89 f9                	mov    %edi,%ecx
  8033ca:	d3 e2                	shl    %cl,%edx
  8033cc:	39 c2                	cmp    %eax,%edx
  8033ce:	73 e9                	jae    8033b9 <__udivdi3+0xe5>
  8033d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8033d3:	31 ff                	xor    %edi,%edi
  8033d5:	e9 40 ff ff ff       	jmp    80331a <__udivdi3+0x46>
  8033da:	66 90                	xchg   %ax,%ax
  8033dc:	31 c0                	xor    %eax,%eax
  8033de:	e9 37 ff ff ff       	jmp    80331a <__udivdi3+0x46>
  8033e3:	90                   	nop

008033e4 <__umoddi3>:
  8033e4:	55                   	push   %ebp
  8033e5:	57                   	push   %edi
  8033e6:	56                   	push   %esi
  8033e7:	53                   	push   %ebx
  8033e8:	83 ec 1c             	sub    $0x1c,%esp
  8033eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803403:	89 f3                	mov    %esi,%ebx
  803405:	89 fa                	mov    %edi,%edx
  803407:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80340b:	89 34 24             	mov    %esi,(%esp)
  80340e:	85 c0                	test   %eax,%eax
  803410:	75 1a                	jne    80342c <__umoddi3+0x48>
  803412:	39 f7                	cmp    %esi,%edi
  803414:	0f 86 a2 00 00 00    	jbe    8034bc <__umoddi3+0xd8>
  80341a:	89 c8                	mov    %ecx,%eax
  80341c:	89 f2                	mov    %esi,%edx
  80341e:	f7 f7                	div    %edi
  803420:	89 d0                	mov    %edx,%eax
  803422:	31 d2                	xor    %edx,%edx
  803424:	83 c4 1c             	add    $0x1c,%esp
  803427:	5b                   	pop    %ebx
  803428:	5e                   	pop    %esi
  803429:	5f                   	pop    %edi
  80342a:	5d                   	pop    %ebp
  80342b:	c3                   	ret    
  80342c:	39 f0                	cmp    %esi,%eax
  80342e:	0f 87 ac 00 00 00    	ja     8034e0 <__umoddi3+0xfc>
  803434:	0f bd e8             	bsr    %eax,%ebp
  803437:	83 f5 1f             	xor    $0x1f,%ebp
  80343a:	0f 84 ac 00 00 00    	je     8034ec <__umoddi3+0x108>
  803440:	bf 20 00 00 00       	mov    $0x20,%edi
  803445:	29 ef                	sub    %ebp,%edi
  803447:	89 fe                	mov    %edi,%esi
  803449:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80344d:	89 e9                	mov    %ebp,%ecx
  80344f:	d3 e0                	shl    %cl,%eax
  803451:	89 d7                	mov    %edx,%edi
  803453:	89 f1                	mov    %esi,%ecx
  803455:	d3 ef                	shr    %cl,%edi
  803457:	09 c7                	or     %eax,%edi
  803459:	89 e9                	mov    %ebp,%ecx
  80345b:	d3 e2                	shl    %cl,%edx
  80345d:	89 14 24             	mov    %edx,(%esp)
  803460:	89 d8                	mov    %ebx,%eax
  803462:	d3 e0                	shl    %cl,%eax
  803464:	89 c2                	mov    %eax,%edx
  803466:	8b 44 24 08          	mov    0x8(%esp),%eax
  80346a:	d3 e0                	shl    %cl,%eax
  80346c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803470:	8b 44 24 08          	mov    0x8(%esp),%eax
  803474:	89 f1                	mov    %esi,%ecx
  803476:	d3 e8                	shr    %cl,%eax
  803478:	09 d0                	or     %edx,%eax
  80347a:	d3 eb                	shr    %cl,%ebx
  80347c:	89 da                	mov    %ebx,%edx
  80347e:	f7 f7                	div    %edi
  803480:	89 d3                	mov    %edx,%ebx
  803482:	f7 24 24             	mull   (%esp)
  803485:	89 c6                	mov    %eax,%esi
  803487:	89 d1                	mov    %edx,%ecx
  803489:	39 d3                	cmp    %edx,%ebx
  80348b:	0f 82 87 00 00 00    	jb     803518 <__umoddi3+0x134>
  803491:	0f 84 91 00 00 00    	je     803528 <__umoddi3+0x144>
  803497:	8b 54 24 04          	mov    0x4(%esp),%edx
  80349b:	29 f2                	sub    %esi,%edx
  80349d:	19 cb                	sbb    %ecx,%ebx
  80349f:	89 d8                	mov    %ebx,%eax
  8034a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034a5:	d3 e0                	shl    %cl,%eax
  8034a7:	89 e9                	mov    %ebp,%ecx
  8034a9:	d3 ea                	shr    %cl,%edx
  8034ab:	09 d0                	or     %edx,%eax
  8034ad:	89 e9                	mov    %ebp,%ecx
  8034af:	d3 eb                	shr    %cl,%ebx
  8034b1:	89 da                	mov    %ebx,%edx
  8034b3:	83 c4 1c             	add    $0x1c,%esp
  8034b6:	5b                   	pop    %ebx
  8034b7:	5e                   	pop    %esi
  8034b8:	5f                   	pop    %edi
  8034b9:	5d                   	pop    %ebp
  8034ba:	c3                   	ret    
  8034bb:	90                   	nop
  8034bc:	89 fd                	mov    %edi,%ebp
  8034be:	85 ff                	test   %edi,%edi
  8034c0:	75 0b                	jne    8034cd <__umoddi3+0xe9>
  8034c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8034c7:	31 d2                	xor    %edx,%edx
  8034c9:	f7 f7                	div    %edi
  8034cb:	89 c5                	mov    %eax,%ebp
  8034cd:	89 f0                	mov    %esi,%eax
  8034cf:	31 d2                	xor    %edx,%edx
  8034d1:	f7 f5                	div    %ebp
  8034d3:	89 c8                	mov    %ecx,%eax
  8034d5:	f7 f5                	div    %ebp
  8034d7:	89 d0                	mov    %edx,%eax
  8034d9:	e9 44 ff ff ff       	jmp    803422 <__umoddi3+0x3e>
  8034de:	66 90                	xchg   %ax,%ax
  8034e0:	89 c8                	mov    %ecx,%eax
  8034e2:	89 f2                	mov    %esi,%edx
  8034e4:	83 c4 1c             	add    $0x1c,%esp
  8034e7:	5b                   	pop    %ebx
  8034e8:	5e                   	pop    %esi
  8034e9:	5f                   	pop    %edi
  8034ea:	5d                   	pop    %ebp
  8034eb:	c3                   	ret    
  8034ec:	3b 04 24             	cmp    (%esp),%eax
  8034ef:	72 06                	jb     8034f7 <__umoddi3+0x113>
  8034f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034f5:	77 0f                	ja     803506 <__umoddi3+0x122>
  8034f7:	89 f2                	mov    %esi,%edx
  8034f9:	29 f9                	sub    %edi,%ecx
  8034fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034ff:	89 14 24             	mov    %edx,(%esp)
  803502:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803506:	8b 44 24 04          	mov    0x4(%esp),%eax
  80350a:	8b 14 24             	mov    (%esp),%edx
  80350d:	83 c4 1c             	add    $0x1c,%esp
  803510:	5b                   	pop    %ebx
  803511:	5e                   	pop    %esi
  803512:	5f                   	pop    %edi
  803513:	5d                   	pop    %ebp
  803514:	c3                   	ret    
  803515:	8d 76 00             	lea    0x0(%esi),%esi
  803518:	2b 04 24             	sub    (%esp),%eax
  80351b:	19 fa                	sbb    %edi,%edx
  80351d:	89 d1                	mov    %edx,%ecx
  80351f:	89 c6                	mov    %eax,%esi
  803521:	e9 71 ff ff ff       	jmp    803497 <__umoddi3+0xb3>
  803526:	66 90                	xchg   %ax,%ax
  803528:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80352c:	72 ea                	jb     803518 <__umoddi3+0x134>
  80352e:	89 d9                	mov    %ebx,%ecx
  803530:	e9 62 ff ff ff       	jmp    803497 <__umoddi3+0xb3>
