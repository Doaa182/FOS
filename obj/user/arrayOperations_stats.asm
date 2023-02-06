
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 f7 04 00 00       	call   80052d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 79 1d 00 00       	call   801dbc <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 a3 1d 00 00       	call   801dee <sys_getparentenvid>
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
  80005f:	68 00 36 80 00       	push   $0x803600
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 64 18 00 00       	call   8018d0 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 04 36 80 00       	push   $0x803604
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 4e 18 00 00       	call   8018d0 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 0c 36 80 00       	push   $0x80360c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 31 18 00 00       	call   8018d0 <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 1a 36 80 00       	push   $0x80361a
  8000b8:	e8 75 17 00 00       	call   801832 <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		tmpArray[i] = sharedArray[i];
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

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	8d 55 b4             	lea    -0x4c(%ebp),%edx
  800106:	52                   	push   %edx
  800107:	8d 55 b8             	lea    -0x48(%ebp),%edx
  80010a:	52                   	push   %edx
  80010b:	8d 55 bc             	lea    -0x44(%ebp),%edx
  80010e:	52                   	push   %edx
  80010f:	8d 55 c0             	lea    -0x40(%ebp),%edx
  800112:	52                   	push   %edx
  800113:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800116:	52                   	push   %edx
  800117:	50                   	push   %eax
  800118:	ff 75 dc             	pushl  -0x24(%ebp)
  80011b:	e8 55 02 00 00       	call   800375 <ArrayStats>
  800120:	83 c4 20             	add    $0x20,%esp
	cprintf("Stats Calculations are Finished!!!!\n") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 24 36 80 00       	push   $0x803624
  80012b:	e8 0d 06 00 00       	call   80073d <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 49 36 80 00       	push   $0x803649
  80013f:	e8 ee 16 00 00       	call   801832 <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 4e 36 80 00       	push   $0x80364e
  80015e:	e8 cf 16 00 00       	call   801832 <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 52 36 80 00       	push   $0x803652
  80017d:	e8 b0 16 00 00       	call   801832 <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 56 36 80 00       	push   $0x803656
  80019c:	e8 91 16 00 00       	call   801832 <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 5a 36 80 00       	push   $0x80365a
  8001bb:	e8 72 16 00 00       	call   801832 <smalloc>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8001c6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001cc:	89 10                	mov    %edx,(%eax)

	(*finishedCount)++ ;
  8001ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d1:	8b 00                	mov    (%eax),%eax
  8001d3:	8d 50 01             	lea    0x1(%eax),%edx
  8001d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)

}
  8001db:	90                   	nop
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  8001e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8001ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ed:	48                   	dec    %eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	52                   	push   %edx
  8001f2:	50                   	push   %eax
  8001f3:	6a 00                	push   $0x0
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 05 00 00 00       	call   800205 <QSort>
  800200:	83 c4 20             	add    $0x20,%esp
}
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  80020b:	8b 45 10             	mov    0x10(%ebp),%eax
  80020e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800211:	7c 16                	jl     800229 <QSort+0x24>
  800213:	8b 45 14             	mov    0x14(%ebp),%eax
  800216:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021d:	8b 45 08             	mov    0x8(%ebp),%eax
  800220:	01 d0                	add    %edx,%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	e9 4a 01 00 00       	jmp    800373 <QSort+0x16e>

	int pvtIndex = RAND(startIndex, finalIndex) ;
  800229:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	50                   	push   %eax
  800230:	e8 ec 1b 00 00       	call   801e21 <sys_get_virtual_time>
  800235:	83 c4 0c             	add    $0xc,%esp
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 55 14             	mov    0x14(%ebp),%edx
  80023e:	2b 55 10             	sub    0x10(%ebp),%edx
  800241:	89 d1                	mov    %edx,%ecx
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 f1                	div    %ecx
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	ff 75 ec             	pushl  -0x14(%ebp)
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	e8 77 02 00 00       	call   8004da <Swap>
  800263:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  800266:	8b 45 10             	mov    0x10(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80026d:	8b 45 14             	mov    0x14(%ebp),%eax
  800270:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800273:	e9 80 00 00 00       	jmp    8002f8 <QSort+0xf3>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800278:	ff 45 f4             	incl   -0xc(%ebp)
  80027b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	7f 2b                	jg     8002ae <QSort+0xa9>
  800283:	8b 45 10             	mov    0x10(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 10                	mov    (%eax),%edx
  800294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800297:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	01 c8                	add    %ecx,%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	39 c2                	cmp    %eax,%edx
  8002a7:	7d cf                	jge    800278 <QSort+0x73>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002a9:	eb 03                	jmp    8002ae <QSort+0xa9>
  8002ab:	ff 4d f0             	decl   -0x10(%ebp)
  8002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002b4:	7e 26                	jle    8002dc <QSort+0xd7>
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	01 c8                	add    %ecx,%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	7e cf                	jle    8002ab <QSort+0xa6>

		if (i <= j)
  8002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e2:	7f 14                	jg     8002f8 <QSort+0xf3>
		{
			Swap(Elements, i, j);
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8002ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ed:	ff 75 08             	pushl  0x8(%ebp)
  8002f0:	e8 e5 01 00 00       	call   8004da <Swap>
  8002f5:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8002f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002fe:	0f 8e 77 ff ff ff    	jle    80027b <QSort+0x76>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 f0             	pushl  -0x10(%ebp)
  80030a:	ff 75 10             	pushl  0x10(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 c5 01 00 00       	call   8004da <Swap>
  800315:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  800318:	8b 45 18             	mov    0x18(%ebp),%eax
  80031b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031e:	75 13                	jne    800333 <QSort+0x12e>
		return Elements[kIndex] ;
  800320:	8b 45 18             	mov    0x18(%ebp),%eax
  800323:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	eb 40                	jmp    800373 <QSort+0x16e>
	else if (kIndex < j)
  800333:	8b 45 18             	mov    0x18(%ebp),%eax
  800336:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800339:	7d 1e                	jge    800359 <QSort+0x154>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  80033b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033e:	48                   	dec    %eax
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 18             	pushl  0x18(%ebp)
  800345:	50                   	push   %eax
  800346:	ff 75 10             	pushl  0x10(%ebp)
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 b1 fe ff ff       	call   800205 <QSort>
  800354:	83 c4 20             	add    $0x20,%esp
  800357:	eb 1a                	jmp    800373 <QSort+0x16e>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	ff 75 18             	pushl  0x18(%ebp)
  80035f:	ff 75 14             	pushl  0x14(%ebp)
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	ff 75 0c             	pushl  0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 95 fe ff ff       	call   800205 <QSort>
  800370:	83 c4 20             	add    $0x20,%esp
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	53                   	push   %ebx
  800379:	83 ec 14             	sub    $0x14,%esp
	int i ;
	*mean =0 ;
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*min = 0x7FFFFFFF ;
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  80038e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800391:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80039e:	e9 80 00 00 00       	jmp    800423 <ArrayStats+0xae>
	{
		(*mean) += Elements[i];
  8003a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a6:	8b 10                	mov    (%eax),%edx
  8003a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	01 c8                	add    %ecx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	01 c2                	add    %eax,%edx
  8003bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003be:	89 10                	mov    %edx,(%eax)
		if (Elements[i] < (*min))
  8003c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	8b 10                	mov    (%eax),%edx
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	7d 16                	jge    8003f0 <ArrayStats+0x7b>
		{
			(*min) = Elements[i];
  8003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  8003f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	8b 10                	mov    (%eax),%edx
  800401:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	7e 16                	jle    800420 <ArrayStats+0xab>
		{
			(*max) = Elements[i];
  80040a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80040d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	01 d0                	add    %edx,%eax
  800419:	8b 10                	mov    (%eax),%edx
  80041b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80041e:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 f4             	incl   -0xc(%ebp)
  800423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	0f 8c 74 ff ff ff    	jl     8003a3 <ArrayStats+0x2e>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);
  80042f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800432:	89 c2                	mov    %eax,%edx
  800434:	c1 ea 1f             	shr    $0x1f,%edx
  800437:	01 d0                	add    %edx,%eax
  800439:	d1 f8                	sar    %eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	50                   	push   %eax
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 08             	pushl  0x8(%ebp)
  800445:	e8 94 fd ff ff       	call   8001de <KthElement>
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	8b 45 20             	mov    0x20(%ebp),%eax
  800452:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  800454:	8b 45 10             	mov    0x10(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	99                   	cltd   
  80045a:	f7 7d 0c             	idivl  0xc(%ebp)
  80045d:	89 c2                	mov    %eax,%edx
  80045f:	8b 45 10             	mov    0x10(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
	(*var) = 0;
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80046d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800474:	eb 46                	jmp    8004bc <ArrayStats+0x147>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8b 10                	mov    (%eax),%edx
  80047b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c8                	add    %ecx,%eax
  80048a:	8b 08                	mov    (%eax),%ecx
  80048c:	8b 45 10             	mov    0x10(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	89 cb                	mov    %ecx,%ebx
  800493:	29 c3                	sub    %eax,%ebx
  800495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800498:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 08                	mov    (%eax),%ecx
  8004a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	29 c1                	sub    %eax,%ecx
  8004ad:	89 c8                	mov    %ecx,%eax
  8004af:	0f af c3             	imul   %ebx,%eax
  8004b2:	01 c2                	add    %eax,%edx
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	89 10                	mov    %edx,(%eax)

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b9:	ff 45 f4             	incl   -0xc(%ebp)
  8004bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004c2:	7c b2                	jl     800476 <ArrayStats+0x101>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
	}
	(*var) /= NumOfElements;
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
  8004ca:	f7 7d 0c             	idivl  0xc(%ebp)
  8004cd:	89 c2                	mov    %eax,%edx
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
}
  8004d4:	90                   	nop
  8004d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	01 c2                	add    %eax,%edx
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	01 c8                	add    %ecx,%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800516:	8b 45 10             	mov    0x10(%ebp),%eax
  800519:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	01 c2                	add    %eax,%edx
  800525:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800528:	89 02                	mov    %eax,(%edx)
}
  80052a:	90                   	nop
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800533:	e8 9d 18 00 00       	call   801dd5 <sys_getenvindex>
  800538:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80053b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	c1 e0 03             	shl    $0x3,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800550:	01 d0                	add    %edx,%eax
  800552:	c1 e0 04             	shl    $0x4,%eax
  800555:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80055a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80055f:	a1 20 40 80 00       	mov    0x804020,%eax
  800564:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80056a:	84 c0                	test   %al,%al
  80056c:	74 0f                	je     80057d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80056e:	a1 20 40 80 00       	mov    0x804020,%eax
  800573:	05 5c 05 00 00       	add    $0x55c,%eax
  800578:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80057d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800581:	7e 0a                	jle    80058d <libmain+0x60>
		binaryname = argv[0];
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	ff 75 0c             	pushl  0xc(%ebp)
  800593:	ff 75 08             	pushl  0x8(%ebp)
  800596:	e8 9d fa ff ff       	call   800038 <_main>
  80059b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80059e:	e8 3f 16 00 00       	call   801be2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	68 78 36 80 00       	push   $0x803678
  8005ab:	e8 8d 01 00 00       	call   80073d <cprintf>
  8005b0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8005b8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8005be:	a1 20 40 80 00       	mov    0x804020,%eax
  8005c3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	52                   	push   %edx
  8005cd:	50                   	push   %eax
  8005ce:	68 a0 36 80 00       	push   $0x8036a0
  8005d3:	e8 65 01 00 00       	call   80073d <cprintf>
  8005d8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005db:	a1 20 40 80 00       	mov    0x804020,%eax
  8005e0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8005e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005eb:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8005f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8005fc:	51                   	push   %ecx
  8005fd:	52                   	push   %edx
  8005fe:	50                   	push   %eax
  8005ff:	68 c8 36 80 00       	push   $0x8036c8
  800604:	e8 34 01 00 00       	call   80073d <cprintf>
  800609:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060c:	a1 20 40 80 00       	mov    0x804020,%eax
  800611:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	50                   	push   %eax
  80061b:	68 20 37 80 00       	push   $0x803720
  800620:	e8 18 01 00 00       	call   80073d <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800628:	83 ec 0c             	sub    $0xc,%esp
  80062b:	68 78 36 80 00       	push   $0x803678
  800630:	e8 08 01 00 00       	call   80073d <cprintf>
  800635:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800638:	e8 bf 15 00 00       	call   801bfc <sys_enable_interrupt>

	// exit gracefully
	exit();
  80063d:	e8 19 00 00 00       	call   80065b <exit>
}
  800642:	90                   	nop
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80064b:	83 ec 0c             	sub    $0xc,%esp
  80064e:	6a 00                	push   $0x0
  800650:	e8 4c 17 00 00       	call   801da1 <sys_destroy_env>
  800655:	83 c4 10             	add    $0x10,%esp
}
  800658:	90                   	nop
  800659:	c9                   	leave  
  80065a:	c3                   	ret    

0080065b <exit>:

void
exit(void)
{
  80065b:	55                   	push   %ebp
  80065c:	89 e5                	mov    %esp,%ebp
  80065e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800661:	e8 a1 17 00 00       	call   801e07 <sys_exit_env>
}
  800666:	90                   	nop
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
  80066c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80066f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	8d 48 01             	lea    0x1(%eax),%ecx
  800677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067a:	89 0a                	mov    %ecx,(%edx)
  80067c:	8b 55 08             	mov    0x8(%ebp),%edx
  80067f:	88 d1                	mov    %dl,%cl
  800681:	8b 55 0c             	mov    0xc(%ebp),%edx
  800684:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800692:	75 2c                	jne    8006c0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800694:	a0 24 40 80 00       	mov    0x804024,%al
  800699:	0f b6 c0             	movzbl %al,%eax
  80069c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069f:	8b 12                	mov    (%edx),%edx
  8006a1:	89 d1                	mov    %edx,%ecx
  8006a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a6:	83 c2 08             	add    $0x8,%edx
  8006a9:	83 ec 04             	sub    $0x4,%esp
  8006ac:	50                   	push   %eax
  8006ad:	51                   	push   %ecx
  8006ae:	52                   	push   %edx
  8006af:	e8 80 13 00 00       	call   801a34 <sys_cputs>
  8006b4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c3:	8b 40 04             	mov    0x4(%eax),%eax
  8006c6:	8d 50 01             	lea    0x1(%eax),%edx
  8006c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e2:	00 00 00 
	b.cnt = 0;
  8006e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ec:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ef:	ff 75 0c             	pushl  0xc(%ebp)
  8006f2:	ff 75 08             	pushl  0x8(%ebp)
  8006f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006fb:	50                   	push   %eax
  8006fc:	68 69 06 80 00       	push   $0x800669
  800701:	e8 11 02 00 00       	call   800917 <vprintfmt>
  800706:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800709:	a0 24 40 80 00       	mov    0x804024,%al
  80070e:	0f b6 c0             	movzbl %al,%eax
  800711:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800717:	83 ec 04             	sub    $0x4,%esp
  80071a:	50                   	push   %eax
  80071b:	52                   	push   %edx
  80071c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800722:	83 c0 08             	add    $0x8,%eax
  800725:	50                   	push   %eax
  800726:	e8 09 13 00 00       	call   801a34 <sys_cputs>
  80072b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80072e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800735:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80073b:	c9                   	leave  
  80073c:	c3                   	ret    

0080073d <cprintf>:

int cprintf(const char *fmt, ...) {
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800743:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80074a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 f4             	pushl  -0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	e8 73 ff ff ff       	call   8006d2 <vcprintf>
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800765:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800770:	e8 6d 14 00 00       	call   801be2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800775:	8d 45 0c             	lea    0xc(%ebp),%eax
  800778:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	ff 75 f4             	pushl  -0xc(%ebp)
  800784:	50                   	push   %eax
  800785:	e8 48 ff ff ff       	call   8006d2 <vcprintf>
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800790:	e8 67 14 00 00       	call   801bfc <sys_enable_interrupt>
	return cnt;
  800795:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	53                   	push   %ebx
  80079e:	83 ec 14             	sub    $0x14,%esp
  8007a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ad:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b8:	77 55                	ja     80080f <printnum+0x75>
  8007ba:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007bd:	72 05                	jb     8007c4 <printnum+0x2a>
  8007bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007c2:	77 4b                	ja     80080f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007c4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007c7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8007cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d2:	52                   	push   %edx
  8007d3:	50                   	push   %eax
  8007d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007da:	e8 ad 2b 00 00       	call   80338c <__udivdi3>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	83 ec 04             	sub    $0x4,%esp
  8007e5:	ff 75 20             	pushl  0x20(%ebp)
  8007e8:	53                   	push   %ebx
  8007e9:	ff 75 18             	pushl  0x18(%ebp)
  8007ec:	52                   	push   %edx
  8007ed:	50                   	push   %eax
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	ff 75 08             	pushl  0x8(%ebp)
  8007f4:	e8 a1 ff ff ff       	call   80079a <printnum>
  8007f9:	83 c4 20             	add    $0x20,%esp
  8007fc:	eb 1a                	jmp    800818 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	ff 75 20             	pushl  0x20(%ebp)
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	ff d0                	call   *%eax
  80080c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80080f:	ff 4d 1c             	decl   0x1c(%ebp)
  800812:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800816:	7f e6                	jg     8007fe <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800818:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80081b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800826:	53                   	push   %ebx
  800827:	51                   	push   %ecx
  800828:	52                   	push   %edx
  800829:	50                   	push   %eax
  80082a:	e8 6d 2c 00 00       	call   80349c <__umoddi3>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	05 54 39 80 00       	add    $0x803954,%eax
  800837:	8a 00                	mov    (%eax),%al
  800839:	0f be c0             	movsbl %al,%eax
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	50                   	push   %eax
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
}
  80084b:	90                   	nop
  80084c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084f:	c9                   	leave  
  800850:	c3                   	ret    

00800851 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800854:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800858:	7e 1c                	jle    800876 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8d 50 08             	lea    0x8(%eax),%edx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	89 10                	mov    %edx,(%eax)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	83 e8 08             	sub    $0x8,%eax
  80086f:	8b 50 04             	mov    0x4(%eax),%edx
  800872:	8b 00                	mov    (%eax),%eax
  800874:	eb 40                	jmp    8008b6 <getuint+0x65>
	else if (lflag)
  800876:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087a:	74 1e                	je     80089a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	8d 50 04             	lea    0x4(%eax),%edx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	89 10                	mov    %edx,(%eax)
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
  800898:	eb 1c                	jmp    8008b6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 04             	lea    0x4(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008bf:	7e 1c                	jle    8008dd <getint+0x25>
		return va_arg(*ap, long long);
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	8d 50 08             	lea    0x8(%eax),%edx
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	89 10                	mov    %edx,(%eax)
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 e8 08             	sub    $0x8,%eax
  8008d6:	8b 50 04             	mov    0x4(%eax),%edx
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	eb 38                	jmp    800915 <getint+0x5d>
	else if (lflag)
  8008dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e1:	74 1a                	je     8008fd <getint+0x45>
		return va_arg(*ap, long);
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	8d 50 04             	lea    0x4(%eax),%edx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	89 10                	mov    %edx,(%eax)
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	83 e8 04             	sub    $0x4,%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	99                   	cltd   
  8008fb:	eb 18                	jmp    800915 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	8d 50 04             	lea    0x4(%eax),%edx
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	89 10                	mov    %edx,(%eax)
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	99                   	cltd   
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	56                   	push   %esi
  80091b:	53                   	push   %ebx
  80091c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091f:	eb 17                	jmp    800938 <vprintfmt+0x21>
			if (ch == '\0')
  800921:	85 db                	test   %ebx,%ebx
  800923:	0f 84 af 03 00 00    	je     800cd8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	53                   	push   %ebx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800938:	8b 45 10             	mov    0x10(%ebp),%eax
  80093b:	8d 50 01             	lea    0x1(%eax),%edx
  80093e:	89 55 10             	mov    %edx,0x10(%ebp)
  800941:	8a 00                	mov    (%eax),%al
  800943:	0f b6 d8             	movzbl %al,%ebx
  800946:	83 fb 25             	cmp    $0x25,%ebx
  800949:	75 d6                	jne    800921 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80094f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800956:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80095d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800964:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096b:	8b 45 10             	mov    0x10(%ebp),%eax
  80096e:	8d 50 01             	lea    0x1(%eax),%edx
  800971:	89 55 10             	mov    %edx,0x10(%ebp)
  800974:	8a 00                	mov    (%eax),%al
  800976:	0f b6 d8             	movzbl %al,%ebx
  800979:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80097c:	83 f8 55             	cmp    $0x55,%eax
  80097f:	0f 87 2b 03 00 00    	ja     800cb0 <vprintfmt+0x399>
  800985:	8b 04 85 78 39 80 00 	mov    0x803978(,%eax,4),%eax
  80098c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80098e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800992:	eb d7                	jmp    80096b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800994:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800998:	eb d1                	jmp    80096b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	c1 e0 02             	shl    $0x2,%eax
  8009a9:	01 d0                	add    %edx,%eax
  8009ab:	01 c0                	add    %eax,%eax
  8009ad:	01 d8                	add    %ebx,%eax
  8009af:	83 e8 30             	sub    $0x30,%eax
  8009b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b8:	8a 00                	mov    (%eax),%al
  8009ba:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009bd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c0:	7e 3e                	jle    800a00 <vprintfmt+0xe9>
  8009c2:	83 fb 39             	cmp    $0x39,%ebx
  8009c5:	7f 39                	jg     800a00 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ca:	eb d5                	jmp    8009a1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cf:	83 c0 04             	add    $0x4,%eax
  8009d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 e8 04             	sub    $0x4,%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e0:	eb 1f                	jmp    800a01 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e6:	79 83                	jns    80096b <vprintfmt+0x54>
				width = 0;
  8009e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ef:	e9 77 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009f4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009fb:	e9 6b ff ff ff       	jmp    80096b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a00:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a05:	0f 89 60 ff ff ff    	jns    80096b <vprintfmt+0x54>
				width = precision, precision = -1;
  800a0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a11:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a18:	e9 4e ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a20:	e9 46 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	50                   	push   %eax
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	ff d0                	call   *%eax
  800a42:	83 c4 10             	add    $0x10,%esp
			break;
  800a45:	e9 89 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4d:	83 c0 04             	add    $0x4,%eax
  800a50:	89 45 14             	mov    %eax,0x14(%ebp)
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	83 e8 04             	sub    $0x4,%eax
  800a59:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a5b:	85 db                	test   %ebx,%ebx
  800a5d:	79 02                	jns    800a61 <vprintfmt+0x14a>
				err = -err;
  800a5f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a61:	83 fb 64             	cmp    $0x64,%ebx
  800a64:	7f 0b                	jg     800a71 <vprintfmt+0x15a>
  800a66:	8b 34 9d c0 37 80 00 	mov    0x8037c0(,%ebx,4),%esi
  800a6d:	85 f6                	test   %esi,%esi
  800a6f:	75 19                	jne    800a8a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a71:	53                   	push   %ebx
  800a72:	68 65 39 80 00       	push   $0x803965
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 5e 02 00 00       	call   800ce0 <printfmt>
  800a82:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a85:	e9 49 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8a:	56                   	push   %esi
  800a8b:	68 6e 39 80 00       	push   $0x80396e
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	ff 75 08             	pushl  0x8(%ebp)
  800a96:	e8 45 02 00 00       	call   800ce0 <printfmt>
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	e9 30 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	83 c0 04             	add    $0x4,%eax
  800aa9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	83 e8 04             	sub    $0x4,%eax
  800ab2:	8b 30                	mov    (%eax),%esi
  800ab4:	85 f6                	test   %esi,%esi
  800ab6:	75 05                	jne    800abd <vprintfmt+0x1a6>
				p = "(null)";
  800ab8:	be 71 39 80 00       	mov    $0x803971,%esi
			if (width > 0 && padc != '-')
  800abd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac1:	7e 6d                	jle    800b30 <vprintfmt+0x219>
  800ac3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ac7:	74 67                	je     800b30 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	50                   	push   %eax
  800ad0:	56                   	push   %esi
  800ad1:	e8 0c 03 00 00       	call   800de2 <strnlen>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800adc:	eb 16                	jmp    800af4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ade:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	ff d0                	call   *%eax
  800aee:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af1:	ff 4d e4             	decl   -0x1c(%ebp)
  800af4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af8:	7f e4                	jg     800ade <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afa:	eb 34                	jmp    800b30 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800afc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b00:	74 1c                	je     800b1e <vprintfmt+0x207>
  800b02:	83 fb 1f             	cmp    $0x1f,%ebx
  800b05:	7e 05                	jle    800b0c <vprintfmt+0x1f5>
  800b07:	83 fb 7e             	cmp    $0x7e,%ebx
  800b0a:	7e 12                	jle    800b1e <vprintfmt+0x207>
					putch('?', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 3f                	push   $0x3f
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
  800b1c:	eb 0f                	jmp    800b2d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	53                   	push   %ebx
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	ff d0                	call   *%eax
  800b2a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b30:	89 f0                	mov    %esi,%eax
  800b32:	8d 70 01             	lea    0x1(%eax),%esi
  800b35:	8a 00                	mov    (%eax),%al
  800b37:	0f be d8             	movsbl %al,%ebx
  800b3a:	85 db                	test   %ebx,%ebx
  800b3c:	74 24                	je     800b62 <vprintfmt+0x24b>
  800b3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b42:	78 b8                	js     800afc <vprintfmt+0x1e5>
  800b44:	ff 4d e0             	decl   -0x20(%ebp)
  800b47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4b:	79 af                	jns    800afc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4d:	eb 13                	jmp    800b62 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 0c             	pushl  0xc(%ebp)
  800b55:	6a 20                	push   $0x20
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b66:	7f e7                	jg     800b4f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b68:	e9 66 01 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 e8             	pushl  -0x18(%ebp)
  800b73:	8d 45 14             	lea    0x14(%ebp),%eax
  800b76:	50                   	push   %eax
  800b77:	e8 3c fd ff ff       	call   8008b8 <getint>
  800b7c:	83 c4 10             	add    $0x10,%esp
  800b7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8b:	85 d2                	test   %edx,%edx
  800b8d:	79 23                	jns    800bb2 <vprintfmt+0x29b>
				putch('-', putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	6a 2d                	push   $0x2d
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	ff d0                	call   *%eax
  800b9c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba5:	f7 d8                	neg    %eax
  800ba7:	83 d2 00             	adc    $0x0,%edx
  800baa:	f7 da                	neg    %edx
  800bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800baf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bb2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb9:	e9 bc 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc7:	50                   	push   %eax
  800bc8:	e8 84 fc ff ff       	call   800851 <getuint>
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bd6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bdd:	e9 98 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	6a 58                	push   $0x58
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	ff d0                	call   *%eax
  800bef:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	6a 58                	push   $0x58
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	ff d0                	call   *%eax
  800bff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 58                	push   $0x58
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
			break;
  800c12:	e9 bc 00 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	6a 30                	push   $0x30
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	ff d0                	call   *%eax
  800c24:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	6a 78                	push   $0x78
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c37:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3a:	83 c0 04             	add    $0x4,%eax
  800c3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c40:	8b 45 14             	mov    0x14(%ebp),%eax
  800c43:	83 e8 04             	sub    $0x4,%eax
  800c46:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c52:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c59:	eb 1f                	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c61:	8d 45 14             	lea    0x14(%ebp),%eax
  800c64:	50                   	push   %eax
  800c65:	e8 e7 fb ff ff       	call   800851 <getuint>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c7a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c81:	83 ec 04             	sub    $0x4,%esp
  800c84:	52                   	push   %edx
  800c85:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c88:	50                   	push   %eax
  800c89:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	ff 75 08             	pushl  0x8(%ebp)
  800c95:	e8 00 fb ff ff       	call   80079a <printnum>
  800c9a:	83 c4 20             	add    $0x20,%esp
			break;
  800c9d:	eb 34                	jmp    800cd3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	53                   	push   %ebx
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	ff d0                	call   *%eax
  800cab:	83 c4 10             	add    $0x10,%esp
			break;
  800cae:	eb 23                	jmp    800cd3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cb0:	83 ec 08             	sub    $0x8,%esp
  800cb3:	ff 75 0c             	pushl  0xc(%ebp)
  800cb6:	6a 25                	push   $0x25
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	ff d0                	call   *%eax
  800cbd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc0:	ff 4d 10             	decl   0x10(%ebp)
  800cc3:	eb 03                	jmp    800cc8 <vprintfmt+0x3b1>
  800cc5:	ff 4d 10             	decl   0x10(%ebp)
  800cc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccb:	48                   	dec    %eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	3c 25                	cmp    $0x25,%al
  800cd0:	75 f3                	jne    800cc5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cd2:	90                   	nop
		}
	}
  800cd3:	e9 47 fc ff ff       	jmp    80091f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cd8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ce6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce9:	83 c0 04             	add    $0x4,%eax
  800cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cef:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	50                   	push   %eax
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	ff 75 08             	pushl  0x8(%ebp)
  800cfc:	e8 16 fc ff ff       	call   800917 <vprintfmt>
  800d01:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d04:	90                   	nop
  800d05:	c9                   	leave  
  800d06:	c3                   	ret    

00800d07 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0d:	8b 40 08             	mov    0x8(%eax),%eax
  800d10:	8d 50 01             	lea    0x1(%eax),%edx
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1c:	8b 10                	mov    (%eax),%edx
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8b 40 04             	mov    0x4(%eax),%eax
  800d24:	39 c2                	cmp    %eax,%edx
  800d26:	73 12                	jae    800d3a <sprintputch+0x33>
		*b->buf++ = ch;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d33:	89 0a                	mov    %ecx,(%edx)
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	88 10                	mov    %dl,(%eax)
}
  800d3a:	90                   	nop
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	01 d0                	add    %edx,%eax
  800d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d62:	74 06                	je     800d6a <vsnprintf+0x2d>
  800d64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d68:	7f 07                	jg     800d71 <vsnprintf+0x34>
		return -E_INVAL;
  800d6a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d6f:	eb 20                	jmp    800d91 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d71:	ff 75 14             	pushl  0x14(%ebp)
  800d74:	ff 75 10             	pushl  0x10(%ebp)
  800d77:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d7a:	50                   	push   %eax
  800d7b:	68 07 0d 80 00       	push   $0x800d07
  800d80:	e8 92 fb ff ff       	call   800917 <vprintfmt>
  800d85:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d8b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d99:	8d 45 10             	lea    0x10(%ebp),%eax
  800d9c:	83 c0 04             	add    $0x4,%eax
  800d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	ff 75 f4             	pushl  -0xc(%ebp)
  800da8:	50                   	push   %eax
  800da9:	ff 75 0c             	pushl  0xc(%ebp)
  800dac:	ff 75 08             	pushl  0x8(%ebp)
  800daf:	e8 89 ff ff ff       	call   800d3d <vsnprintf>
  800db4:	83 c4 10             	add    $0x10,%esp
  800db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dcc:	eb 06                	jmp    800dd4 <strlen+0x15>
		n++;
  800dce:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd1:	ff 45 08             	incl   0x8(%ebp)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	84 c0                	test   %al,%al
  800ddb:	75 f1                	jne    800dce <strlen+0xf>
		n++;
	return n;
  800ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800def:	eb 09                	jmp    800dfa <strnlen+0x18>
		n++;
  800df1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df4:	ff 45 08             	incl   0x8(%ebp)
  800df7:	ff 4d 0c             	decl   0xc(%ebp)
  800dfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfe:	74 09                	je     800e09 <strnlen+0x27>
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	84 c0                	test   %al,%al
  800e07:	75 e8                	jne    800df1 <strnlen+0xf>
		n++;
	return n;
  800e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e1a:	90                   	nop
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8d 50 01             	lea    0x1(%eax),%edx
  800e21:	89 55 08             	mov    %edx,0x8(%ebp)
  800e24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2d:	8a 12                	mov    (%edx),%dl
  800e2f:	88 10                	mov    %dl,(%eax)
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	84 c0                	test   %al,%al
  800e35:	75 e4                	jne    800e1b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e4f:	eb 1f                	jmp    800e70 <strncpy+0x34>
		*dst++ = *src;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 08             	mov    %edx,0x8(%ebp)
  800e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5d:	8a 12                	mov    (%edx),%dl
  800e5f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	84 c0                	test   %al,%al
  800e68:	74 03                	je     800e6d <strncpy+0x31>
			src++;
  800e6a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e6d:	ff 45 fc             	incl   -0x4(%ebp)
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e76:	72 d9                	jb     800e51 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e78:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8d:	74 30                	je     800ebf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e8f:	eb 16                	jmp    800ea7 <strlcpy+0x2a>
			*dst++ = *src++;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8d 50 01             	lea    0x1(%eax),%edx
  800e97:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea3:	8a 12                	mov    (%edx),%dl
  800ea5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ea7:	ff 4d 10             	decl   0x10(%ebp)
  800eaa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eae:	74 09                	je     800eb9 <strlcpy+0x3c>
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 d8                	jne    800e91 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec5:	29 c2                	sub    %eax,%edx
  800ec7:	89 d0                	mov    %edx,%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ece:	eb 06                	jmp    800ed6 <strcmp+0xb>
		p++, q++;
  800ed0:	ff 45 08             	incl   0x8(%ebp)
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	84 c0                	test   %al,%al
  800edd:	74 0e                	je     800eed <strcmp+0x22>
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 10                	mov    (%eax),%dl
  800ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	38 c2                	cmp    %al,%dl
  800eeb:	74 e3                	je     800ed0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	0f b6 d0             	movzbl %al,%edx
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	0f b6 c0             	movzbl %al,%eax
  800efd:	29 c2                	sub    %eax,%edx
  800eff:	89 d0                	mov    %edx,%eax
}
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f06:	eb 09                	jmp    800f11 <strncmp+0xe>
		n--, p++, q++;
  800f08:	ff 4d 10             	decl   0x10(%ebp)
  800f0b:	ff 45 08             	incl   0x8(%ebp)
  800f0e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f15:	74 17                	je     800f2e <strncmp+0x2b>
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	84 c0                	test   %al,%al
  800f1e:	74 0e                	je     800f2e <strncmp+0x2b>
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 10                	mov    (%eax),%dl
  800f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	38 c2                	cmp    %al,%dl
  800f2c:	74 da                	je     800f08 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	75 07                	jne    800f3b <strncmp+0x38>
		return 0;
  800f34:	b8 00 00 00 00       	mov    $0x0,%eax
  800f39:	eb 14                	jmp    800f4f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	0f b6 d0             	movzbl %al,%edx
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 c0             	movzbl %al,%eax
  800f4b:	29 c2                	sub    %eax,%edx
  800f4d:	89 d0                	mov    %edx,%eax
}
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    

00800f51 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	83 ec 04             	sub    $0x4,%esp
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f5d:	eb 12                	jmp    800f71 <strchr+0x20>
		if (*s == c)
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f67:	75 05                	jne    800f6e <strchr+0x1d>
			return (char *) s;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	eb 11                	jmp    800f7f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f6e:	ff 45 08             	incl   0x8(%ebp)
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	84 c0                	test   %al,%al
  800f78:	75 e5                	jne    800f5f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 04             	sub    $0x4,%esp
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8d:	eb 0d                	jmp    800f9c <strfind+0x1b>
		if (*s == c)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f97:	74 0e                	je     800fa7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f99:	ff 45 08             	incl   0x8(%ebp)
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	84 c0                	test   %al,%al
  800fa3:	75 ea                	jne    800f8f <strfind+0xe>
  800fa5:	eb 01                	jmp    800fa8 <strfind+0x27>
		if (*s == c)
			break;
  800fa7:	90                   	nop
	return (char *) s;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fbf:	eb 0e                	jmp    800fcf <memset+0x22>
		*p++ = c;
  800fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc4:	8d 50 01             	lea    0x1(%eax),%edx
  800fc7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fcf:	ff 4d f8             	decl   -0x8(%ebp)
  800fd2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fd6:	79 e9                	jns    800fc1 <memset+0x14>
		*p++ = c;

	return v;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdb:	c9                   	leave  
  800fdc:	c3                   	ret    

00800fdd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fef:	eb 16                	jmp    801007 <memcpy+0x2a>
		*d++ = *s++;
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff4:	8d 50 01             	lea    0x1(%eax),%edx
  800ff7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ffa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffd:	8d 4a 01             	lea    0x1(%edx),%ecx
  801000:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801003:	8a 12                	mov    (%edx),%dl
  801005:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100d:	89 55 10             	mov    %edx,0x10(%ebp)
  801010:	85 c0                	test   %eax,%eax
  801012:	75 dd                	jne    800ff1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80102b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801031:	73 50                	jae    801083 <memmove+0x6a>
  801033:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80103e:	76 43                	jbe    801083 <memmove+0x6a>
		s += n;
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80104c:	eb 10                	jmp    80105e <memmove+0x45>
			*--d = *--s;
  80104e:	ff 4d f8             	decl   -0x8(%ebp)
  801051:	ff 4d fc             	decl   -0x4(%ebp)
  801054:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801057:	8a 10                	mov    (%eax),%dl
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	8d 50 ff             	lea    -0x1(%eax),%edx
  801064:	89 55 10             	mov    %edx,0x10(%ebp)
  801067:	85 c0                	test   %eax,%eax
  801069:	75 e3                	jne    80104e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80106b:	eb 23                	jmp    801090 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80106d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801070:	8d 50 01             	lea    0x1(%eax),%edx
  801073:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801076:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801079:	8d 4a 01             	lea    0x1(%edx),%ecx
  80107c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80107f:	8a 12                	mov    (%edx),%dl
  801081:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	8d 50 ff             	lea    -0x1(%eax),%edx
  801089:	89 55 10             	mov    %edx,0x10(%ebp)
  80108c:	85 c0                	test   %eax,%eax
  80108e:	75 dd                	jne    80106d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010a7:	eb 2a                	jmp    8010d3 <memcmp+0x3e>
		if (*s1 != *s2)
  8010a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ac:	8a 10                	mov    (%eax),%dl
  8010ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	38 c2                	cmp    %al,%dl
  8010b5:	74 16                	je     8010cd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	0f b6 d0             	movzbl %al,%edx
  8010bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	0f b6 c0             	movzbl %al,%eax
  8010c7:	29 c2                	sub    %eax,%edx
  8010c9:	89 d0                	mov    %edx,%eax
  8010cb:	eb 18                	jmp    8010e5 <memcmp+0x50>
		s1++, s2++;
  8010cd:	ff 45 fc             	incl   -0x4(%ebp)
  8010d0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	75 c9                	jne    8010a9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010f8:	eb 15                	jmp    80110f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f b6 d0             	movzbl %al,%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	0f b6 c0             	movzbl %al,%eax
  801108:	39 c2                	cmp    %eax,%edx
  80110a:	74 0d                	je     801119 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80110c:	ff 45 08             	incl   0x8(%ebp)
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801115:	72 e3                	jb     8010fa <memfind+0x13>
  801117:	eb 01                	jmp    80111a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801119:	90                   	nop
	return (void *) s;
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80112c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801133:	eb 03                	jmp    801138 <strtol+0x19>
		s++;
  801135:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	3c 20                	cmp    $0x20,%al
  80113f:	74 f4                	je     801135 <strtol+0x16>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 09                	cmp    $0x9,%al
  801148:	74 eb                	je     801135 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 2b                	cmp    $0x2b,%al
  801151:	75 05                	jne    801158 <strtol+0x39>
		s++;
  801153:	ff 45 08             	incl   0x8(%ebp)
  801156:	eb 13                	jmp    80116b <strtol+0x4c>
	else if (*s == '-')
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	3c 2d                	cmp    $0x2d,%al
  80115f:	75 0a                	jne    80116b <strtol+0x4c>
		s++, neg = 1;
  801161:	ff 45 08             	incl   0x8(%ebp)
  801164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80116b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116f:	74 06                	je     801177 <strtol+0x58>
  801171:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801175:	75 20                	jne    801197 <strtol+0x78>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 30                	cmp    $0x30,%al
  80117e:	75 17                	jne    801197 <strtol+0x78>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	40                   	inc    %eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	3c 78                	cmp    $0x78,%al
  801188:	75 0d                	jne    801197 <strtol+0x78>
		s += 2, base = 16;
  80118a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80118e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801195:	eb 28                	jmp    8011bf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801197:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119b:	75 15                	jne    8011b2 <strtol+0x93>
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	3c 30                	cmp    $0x30,%al
  8011a4:	75 0c                	jne    8011b2 <strtol+0x93>
		s++, base = 8;
  8011a6:	ff 45 08             	incl   0x8(%ebp)
  8011a9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011b0:	eb 0d                	jmp    8011bf <strtol+0xa0>
	else if (base == 0)
  8011b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b6:	75 07                	jne    8011bf <strtol+0xa0>
		base = 10;
  8011b8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	3c 2f                	cmp    $0x2f,%al
  8011c6:	7e 19                	jle    8011e1 <strtol+0xc2>
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	3c 39                	cmp    $0x39,%al
  8011cf:	7f 10                	jg     8011e1 <strtol+0xc2>
			dig = *s - '0';
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	0f be c0             	movsbl %al,%eax
  8011d9:	83 e8 30             	sub    $0x30,%eax
  8011dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011df:	eb 42                	jmp    801223 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	3c 60                	cmp    $0x60,%al
  8011e8:	7e 19                	jle    801203 <strtol+0xe4>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 7a                	cmp    $0x7a,%al
  8011f1:	7f 10                	jg     801203 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	0f be c0             	movsbl %al,%eax
  8011fb:	83 e8 57             	sub    $0x57,%eax
  8011fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801201:	eb 20                	jmp    801223 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	3c 40                	cmp    $0x40,%al
  80120a:	7e 39                	jle    801245 <strtol+0x126>
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 5a                	cmp    $0x5a,%al
  801213:	7f 30                	jg     801245 <strtol+0x126>
			dig = *s - 'A' + 10;
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f be c0             	movsbl %al,%eax
  80121d:	83 e8 37             	sub    $0x37,%eax
  801220:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801226:	3b 45 10             	cmp    0x10(%ebp),%eax
  801229:	7d 19                	jge    801244 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80122b:	ff 45 08             	incl   0x8(%ebp)
  80122e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801231:	0f af 45 10          	imul   0x10(%ebp),%eax
  801235:	89 c2                	mov    %eax,%edx
  801237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80123f:	e9 7b ff ff ff       	jmp    8011bf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801244:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801245:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801249:	74 08                	je     801253 <strtol+0x134>
		*endptr = (char *) s;
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801253:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801257:	74 07                	je     801260 <strtol+0x141>
  801259:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125c:	f7 d8                	neg    %eax
  80125e:	eb 03                	jmp    801263 <strtol+0x144>
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <ltostr>:

void
ltostr(long value, char *str)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801272:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801279:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127d:	79 13                	jns    801292 <ltostr+0x2d>
	{
		neg = 1;
  80127f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80128c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80128f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80129a:	99                   	cltd   
  80129b:	f7 f9                	idiv   %ecx
  80129d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a3:	8d 50 01             	lea    0x1(%eax),%edx
  8012a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a9:	89 c2                	mov    %eax,%edx
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012b3:	83 c2 30             	add    $0x30,%edx
  8012b6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012bb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012c0:	f7 e9                	imul   %ecx
  8012c2:	c1 fa 02             	sar    $0x2,%edx
  8012c5:	89 c8                	mov    %ecx,%eax
  8012c7:	c1 f8 1f             	sar    $0x1f,%eax
  8012ca:	29 c2                	sub    %eax,%edx
  8012cc:	89 d0                	mov    %edx,%eax
  8012ce:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d9:	f7 e9                	imul   %ecx
  8012db:	c1 fa 02             	sar    $0x2,%edx
  8012de:	89 c8                	mov    %ecx,%eax
  8012e0:	c1 f8 1f             	sar    $0x1f,%eax
  8012e3:	29 c2                	sub    %eax,%edx
  8012e5:	89 d0                	mov    %edx,%eax
  8012e7:	c1 e0 02             	shl    $0x2,%eax
  8012ea:	01 d0                	add    %edx,%eax
  8012ec:	01 c0                	add    %eax,%eax
  8012ee:	29 c1                	sub    %eax,%ecx
  8012f0:	89 ca                	mov    %ecx,%edx
  8012f2:	85 d2                	test   %edx,%edx
  8012f4:	75 9c                	jne    801292 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801300:	48                   	dec    %eax
  801301:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801304:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801308:	74 3d                	je     801347 <ltostr+0xe2>
		start = 1 ;
  80130a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801311:	eb 34                	jmp    801347 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	01 d0                	add    %edx,%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 c2                	add    %eax,%edx
  801328:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80132b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132e:	01 c8                	add    %ecx,%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801334:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	01 c2                	add    %eax,%edx
  80133c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80133f:	88 02                	mov    %al,(%edx)
		start++ ;
  801341:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801344:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134d:	7c c4                	jl     801313 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80134f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80135a:	90                   	nop
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801363:	ff 75 08             	pushl  0x8(%ebp)
  801366:	e8 54 fa ff ff       	call   800dbf <strlen>
  80136b:	83 c4 04             	add    $0x4,%esp
  80136e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801371:	ff 75 0c             	pushl  0xc(%ebp)
  801374:	e8 46 fa ff ff       	call   800dbf <strlen>
  801379:	83 c4 04             	add    $0x4,%esp
  80137c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80137f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 17                	jmp    8013a6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80138f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801392:	8b 45 10             	mov    0x10(%ebp),%eax
  801395:	01 c2                	add    %eax,%edx
  801397:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	01 c8                	add    %ecx,%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013a3:	ff 45 fc             	incl   -0x4(%ebp)
  8013a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ac:	7c e1                	jl     80138f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013bc:	eb 1f                	jmp    8013dd <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c1:	8d 50 01             	lea    0x1(%eax),%edx
  8013c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013c7:	89 c2                	mov    %eax,%edx
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	01 c2                	add    %eax,%edx
  8013ce:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 c8                	add    %ecx,%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013da:	ff 45 f8             	incl   -0x8(%ebp)
  8013dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e3:	7c d9                	jl     8013be <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	01 d0                	add    %edx,%eax
  8013ed:	c6 00 00             	movb   $0x0,(%eax)
}
  8013f0:	90                   	nop
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801402:	8b 00                	mov    (%eax),%eax
  801404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140b:	8b 45 10             	mov    0x10(%ebp),%eax
  80140e:	01 d0                	add    %edx,%eax
  801410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801416:	eb 0c                	jmp    801424 <strsplit+0x31>
			*string++ = 0;
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8d 50 01             	lea    0x1(%eax),%edx
  80141e:	89 55 08             	mov    %edx,0x8(%ebp)
  801421:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	8a 00                	mov    (%eax),%al
  801429:	84 c0                	test   %al,%al
  80142b:	74 18                	je     801445 <strsplit+0x52>
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	0f be c0             	movsbl %al,%eax
  801435:	50                   	push   %eax
  801436:	ff 75 0c             	pushl  0xc(%ebp)
  801439:	e8 13 fb ff ff       	call   800f51 <strchr>
  80143e:	83 c4 08             	add    $0x8,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	75 d3                	jne    801418 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	84 c0                	test   %al,%al
  80144c:	74 5a                	je     8014a8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80144e:	8b 45 14             	mov    0x14(%ebp),%eax
  801451:	8b 00                	mov    (%eax),%eax
  801453:	83 f8 0f             	cmp    $0xf,%eax
  801456:	75 07                	jne    80145f <strsplit+0x6c>
		{
			return 0;
  801458:	b8 00 00 00 00       	mov    $0x0,%eax
  80145d:	eb 66                	jmp    8014c5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	8b 00                	mov    (%eax),%eax
  801464:	8d 48 01             	lea    0x1(%eax),%ecx
  801467:	8b 55 14             	mov    0x14(%ebp),%edx
  80146a:	89 0a                	mov    %ecx,(%edx)
  80146c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801473:	8b 45 10             	mov    0x10(%ebp),%eax
  801476:	01 c2                	add    %eax,%edx
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80147d:	eb 03                	jmp    801482 <strsplit+0x8f>
			string++;
  80147f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	74 8b                	je     801416 <strsplit+0x23>
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f be c0             	movsbl %al,%eax
  801493:	50                   	push   %eax
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	e8 b5 fa ff ff       	call   800f51 <strchr>
  80149c:	83 c4 08             	add    $0x8,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	74 dc                	je     80147f <strsplit+0x8c>
			string++;
	}
  8014a3:	e9 6e ff ff ff       	jmp    801416 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014a8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b8:	01 d0                	add    %edx,%eax
  8014ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014cd:	a1 04 40 80 00       	mov    0x804004,%eax
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	74 1f                	je     8014f5 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014d6:	e8 1d 00 00 00       	call   8014f8 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	68 d0 3a 80 00       	push   $0x803ad0
  8014e3:	e8 55 f2 ff ff       	call   80073d <cprintf>
  8014e8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014eb:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8014f2:	00 00 00 
	}
}
  8014f5:	90                   	nop
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  8014fe:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801505:	00 00 00 
  801508:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80150f:	00 00 00 
  801512:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801519:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  80151c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801523:	00 00 00 
  801526:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80152d:	00 00 00 
  801530:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801537:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  80153a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801544:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801549:	2d 00 10 00 00       	sub    $0x1000,%eax
  80154e:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801553:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80155a:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80155d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801567:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  80156c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80156f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801572:	ba 00 00 00 00       	mov    $0x0,%edx
  801577:	f7 75 f0             	divl   -0x10(%ebp)
  80157a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157d:	29 d0                	sub    %edx,%eax
  80157f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801582:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80158c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801591:	2d 00 10 00 00       	sub    $0x1000,%eax
  801596:	83 ec 04             	sub    $0x4,%esp
  801599:	6a 06                	push   $0x6
  80159b:	ff 75 e8             	pushl  -0x18(%ebp)
  80159e:	50                   	push   %eax
  80159f:	e8 d4 05 00 00       	call   801b78 <sys_allocate_chunk>
  8015a4:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015a7:	a1 20 41 80 00       	mov    0x804120,%eax
  8015ac:	83 ec 0c             	sub    $0xc,%esp
  8015af:	50                   	push   %eax
  8015b0:	e8 49 0c 00 00       	call   8021fe <initialize_MemBlocksList>
  8015b5:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8015b8:	a1 48 41 80 00       	mov    0x804148,%eax
  8015bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8015c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015c4:	75 14                	jne    8015da <initialize_dyn_block_system+0xe2>
  8015c6:	83 ec 04             	sub    $0x4,%esp
  8015c9:	68 f5 3a 80 00       	push   $0x803af5
  8015ce:	6a 39                	push   $0x39
  8015d0:	68 13 3b 80 00       	push   $0x803b13
  8015d5:	e8 d2 1b 00 00       	call   8031ac <_panic>
  8015da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015dd:	8b 00                	mov    (%eax),%eax
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	74 10                	je     8015f3 <initialize_dyn_block_system+0xfb>
  8015e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e6:	8b 00                	mov    (%eax),%eax
  8015e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015eb:	8b 52 04             	mov    0x4(%edx),%edx
  8015ee:	89 50 04             	mov    %edx,0x4(%eax)
  8015f1:	eb 0b                	jmp    8015fe <initialize_dyn_block_system+0x106>
  8015f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015f6:	8b 40 04             	mov    0x4(%eax),%eax
  8015f9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8015fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801601:	8b 40 04             	mov    0x4(%eax),%eax
  801604:	85 c0                	test   %eax,%eax
  801606:	74 0f                	je     801617 <initialize_dyn_block_system+0x11f>
  801608:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80160b:	8b 40 04             	mov    0x4(%eax),%eax
  80160e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801611:	8b 12                	mov    (%edx),%edx
  801613:	89 10                	mov    %edx,(%eax)
  801615:	eb 0a                	jmp    801621 <initialize_dyn_block_system+0x129>
  801617:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80161a:	8b 00                	mov    (%eax),%eax
  80161c:	a3 48 41 80 00       	mov    %eax,0x804148
  801621:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801624:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80162a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80162d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801634:	a1 54 41 80 00       	mov    0x804154,%eax
  801639:	48                   	dec    %eax
  80163a:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  80163f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801642:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164c:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801653:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801657:	75 14                	jne    80166d <initialize_dyn_block_system+0x175>
  801659:	83 ec 04             	sub    $0x4,%esp
  80165c:	68 20 3b 80 00       	push   $0x803b20
  801661:	6a 3f                	push   $0x3f
  801663:	68 13 3b 80 00       	push   $0x803b13
  801668:	e8 3f 1b 00 00       	call   8031ac <_panic>
  80166d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801673:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801676:	89 10                	mov    %edx,(%eax)
  801678:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80167b:	8b 00                	mov    (%eax),%eax
  80167d:	85 c0                	test   %eax,%eax
  80167f:	74 0d                	je     80168e <initialize_dyn_block_system+0x196>
  801681:	a1 38 41 80 00       	mov    0x804138,%eax
  801686:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801689:	89 50 04             	mov    %edx,0x4(%eax)
  80168c:	eb 08                	jmp    801696 <initialize_dyn_block_system+0x19e>
  80168e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801691:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801696:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801699:	a3 38 41 80 00       	mov    %eax,0x804138
  80169e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016a8:	a1 44 41 80 00       	mov    0x804144,%eax
  8016ad:	40                   	inc    %eax
  8016ae:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8016b3:	90                   	nop
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016bc:	e8 06 fe ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016c5:	75 07                	jne    8016ce <malloc+0x18>
  8016c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cc:	eb 7d                	jmp    80174b <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8016ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8016d5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8016df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e2:	01 d0                	add    %edx,%eax
  8016e4:	48                   	dec    %eax
  8016e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f0:	f7 75 f0             	divl   -0x10(%ebp)
  8016f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f6:	29 d0                	sub    %edx,%eax
  8016f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  8016fb:	e8 46 08 00 00       	call   801f46 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801700:	83 f8 01             	cmp    $0x1,%eax
  801703:	75 07                	jne    80170c <malloc+0x56>
  801705:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  80170c:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801710:	75 34                	jne    801746 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801712:	83 ec 0c             	sub    $0xc,%esp
  801715:	ff 75 e8             	pushl  -0x18(%ebp)
  801718:	e8 73 0e 00 00       	call   802590 <alloc_block_FF>
  80171d:	83 c4 10             	add    $0x10,%esp
  801720:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801723:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801727:	74 16                	je     80173f <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801729:	83 ec 0c             	sub    $0xc,%esp
  80172c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80172f:	e8 ff 0b 00 00       	call   802333 <insert_sorted_allocList>
  801734:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801737:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80173a:	8b 40 08             	mov    0x8(%eax),%eax
  80173d:	eb 0c                	jmp    80174b <malloc+0x95>
	             }
	             else
	             	return NULL;
  80173f:	b8 00 00 00 00       	mov    $0x0,%eax
  801744:	eb 05                	jmp    80174b <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801746:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80175f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801762:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801767:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  80176a:	83 ec 08             	sub    $0x8,%esp
  80176d:	ff 75 f4             	pushl  -0xc(%ebp)
  801770:	68 40 40 80 00       	push   $0x804040
  801775:	e8 61 0b 00 00       	call   8022db <find_block>
  80177a:	83 c4 10             	add    $0x10,%esp
  80177d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801780:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801784:	0f 84 a5 00 00 00    	je     80182f <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  80178a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178d:	8b 40 0c             	mov    0xc(%eax),%eax
  801790:	83 ec 08             	sub    $0x8,%esp
  801793:	50                   	push   %eax
  801794:	ff 75 f4             	pushl  -0xc(%ebp)
  801797:	e8 a4 03 00 00       	call   801b40 <sys_free_user_mem>
  80179c:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  80179f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017a3:	75 17                	jne    8017bc <free+0x6f>
  8017a5:	83 ec 04             	sub    $0x4,%esp
  8017a8:	68 f5 3a 80 00       	push   $0x803af5
  8017ad:	68 87 00 00 00       	push   $0x87
  8017b2:	68 13 3b 80 00       	push   $0x803b13
  8017b7:	e8 f0 19 00 00       	call   8031ac <_panic>
  8017bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bf:	8b 00                	mov    (%eax),%eax
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	74 10                	je     8017d5 <free+0x88>
  8017c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c8:	8b 00                	mov    (%eax),%eax
  8017ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017cd:	8b 52 04             	mov    0x4(%edx),%edx
  8017d0:	89 50 04             	mov    %edx,0x4(%eax)
  8017d3:	eb 0b                	jmp    8017e0 <free+0x93>
  8017d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d8:	8b 40 04             	mov    0x4(%eax),%eax
  8017db:	a3 44 40 80 00       	mov    %eax,0x804044
  8017e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e3:	8b 40 04             	mov    0x4(%eax),%eax
  8017e6:	85 c0                	test   %eax,%eax
  8017e8:	74 0f                	je     8017f9 <free+0xac>
  8017ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ed:	8b 40 04             	mov    0x4(%eax),%eax
  8017f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017f3:	8b 12                	mov    (%edx),%edx
  8017f5:	89 10                	mov    %edx,(%eax)
  8017f7:	eb 0a                	jmp    801803 <free+0xb6>
  8017f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fc:	8b 00                	mov    (%eax),%eax
  8017fe:	a3 40 40 80 00       	mov    %eax,0x804040
  801803:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801806:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80180c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801816:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80181b:	48                   	dec    %eax
  80181c:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801821:	83 ec 0c             	sub    $0xc,%esp
  801824:	ff 75 ec             	pushl  -0x14(%ebp)
  801827:	e8 37 12 00 00       	call   802a63 <insert_sorted_with_merge_freeList>
  80182c:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  80182f:	90                   	nop
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 38             	sub    $0x38,%esp
  801838:	8b 45 10             	mov    0x10(%ebp),%eax
  80183b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80183e:	e8 84 fc ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  801843:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801847:	75 07                	jne    801850 <smalloc+0x1e>
  801849:	b8 00 00 00 00       	mov    $0x0,%eax
  80184e:	eb 7e                	jmp    8018ce <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801850:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801857:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80185e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801864:	01 d0                	add    %edx,%eax
  801866:	48                   	dec    %eax
  801867:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80186a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186d:	ba 00 00 00 00       	mov    $0x0,%edx
  801872:	f7 75 f0             	divl   -0x10(%ebp)
  801875:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801878:	29 d0                	sub    %edx,%eax
  80187a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80187d:	e8 c4 06 00 00       	call   801f46 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801882:	83 f8 01             	cmp    $0x1,%eax
  801885:	75 42                	jne    8018c9 <smalloc+0x97>

		  va = malloc(newsize) ;
  801887:	83 ec 0c             	sub    $0xc,%esp
  80188a:	ff 75 e8             	pushl  -0x18(%ebp)
  80188d:	e8 24 fe ff ff       	call   8016b6 <malloc>
  801892:	83 c4 10             	add    $0x10,%esp
  801895:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801898:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80189c:	74 24                	je     8018c2 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  80189e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018a5:	50                   	push   %eax
  8018a6:	ff 75 e8             	pushl  -0x18(%ebp)
  8018a9:	ff 75 08             	pushl  0x8(%ebp)
  8018ac:	e8 1a 04 00 00       	call   801ccb <sys_createSharedObject>
  8018b1:	83 c4 10             	add    $0x10,%esp
  8018b4:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8018b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018bb:	78 0c                	js     8018c9 <smalloc+0x97>
					  return va ;
  8018bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018c0:	eb 0c                	jmp    8018ce <smalloc+0x9c>
				 }
				 else
					return NULL;
  8018c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c7:	eb 05                	jmp    8018ce <smalloc+0x9c>
	  }
		  return NULL ;
  8018c9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018d6:	e8 ec fb ff ff       	call   8014c7 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8018db:	83 ec 08             	sub    $0x8,%esp
  8018de:	ff 75 0c             	pushl  0xc(%ebp)
  8018e1:	ff 75 08             	pushl  0x8(%ebp)
  8018e4:	e8 0c 04 00 00       	call   801cf5 <sys_getSizeOfSharedObject>
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8018ef:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8018f3:	75 07                	jne    8018fc <sget+0x2c>
  8018f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fa:	eb 75                	jmp    801971 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8018fc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801903:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801909:	01 d0                	add    %edx,%eax
  80190b:	48                   	dec    %eax
  80190c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80190f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801912:	ba 00 00 00 00       	mov    $0x0,%edx
  801917:	f7 75 f0             	divl   -0x10(%ebp)
  80191a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191d:	29 d0                	sub    %edx,%eax
  80191f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801922:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801929:	e8 18 06 00 00       	call   801f46 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80192e:	83 f8 01             	cmp    $0x1,%eax
  801931:	75 39                	jne    80196c <sget+0x9c>

		  va = malloc(newsize) ;
  801933:	83 ec 0c             	sub    $0xc,%esp
  801936:	ff 75 e8             	pushl  -0x18(%ebp)
  801939:	e8 78 fd ff ff       	call   8016b6 <malloc>
  80193e:	83 c4 10             	add    $0x10,%esp
  801941:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801944:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801948:	74 22                	je     80196c <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  80194a:	83 ec 04             	sub    $0x4,%esp
  80194d:	ff 75 e0             	pushl  -0x20(%ebp)
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	ff 75 08             	pushl  0x8(%ebp)
  801956:	e8 b7 03 00 00       	call   801d12 <sys_getSharedObject>
  80195b:	83 c4 10             	add    $0x10,%esp
  80195e:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801961:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801965:	78 05                	js     80196c <sget+0x9c>
					  return va;
  801967:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80196a:	eb 05                	jmp    801971 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  80196c:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801979:	e8 49 fb ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80197e:	83 ec 04             	sub    $0x4,%esp
  801981:	68 44 3b 80 00       	push   $0x803b44
  801986:	68 1e 01 00 00       	push   $0x11e
  80198b:	68 13 3b 80 00       	push   $0x803b13
  801990:	e8 17 18 00 00       	call   8031ac <_panic>

00801995 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80199b:	83 ec 04             	sub    $0x4,%esp
  80199e:	68 6c 3b 80 00       	push   $0x803b6c
  8019a3:	68 32 01 00 00       	push   $0x132
  8019a8:	68 13 3b 80 00       	push   $0x803b13
  8019ad:	e8 fa 17 00 00       	call   8031ac <_panic>

008019b2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019b8:	83 ec 04             	sub    $0x4,%esp
  8019bb:	68 90 3b 80 00       	push   $0x803b90
  8019c0:	68 3d 01 00 00       	push   $0x13d
  8019c5:	68 13 3b 80 00       	push   $0x803b13
  8019ca:	e8 dd 17 00 00       	call   8031ac <_panic>

008019cf <shrink>:

}
void shrink(uint32 newSize)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019d5:	83 ec 04             	sub    $0x4,%esp
  8019d8:	68 90 3b 80 00       	push   $0x803b90
  8019dd:	68 42 01 00 00       	push   $0x142
  8019e2:	68 13 3b 80 00       	push   $0x803b13
  8019e7:	e8 c0 17 00 00       	call   8031ac <_panic>

008019ec <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	68 90 3b 80 00       	push   $0x803b90
  8019fa:	68 47 01 00 00       	push   $0x147
  8019ff:	68 13 3b 80 00       	push   $0x803b13
  801a04:	e8 a3 17 00 00       	call   8031ac <_panic>

00801a09 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	57                   	push   %edi
  801a0d:	56                   	push   %esi
  801a0e:	53                   	push   %ebx
  801a0f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a18:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a1b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a1e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a21:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a24:	cd 30                	int    $0x30
  801a26:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a2c:	83 c4 10             	add    $0x10,%esp
  801a2f:	5b                   	pop    %ebx
  801a30:	5e                   	pop    %esi
  801a31:	5f                   	pop    %edi
  801a32:	5d                   	pop    %ebp
  801a33:	c3                   	ret    

00801a34 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 04             	sub    $0x4,%esp
  801a3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a40:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	52                   	push   %edx
  801a4c:	ff 75 0c             	pushl  0xc(%ebp)
  801a4f:	50                   	push   %eax
  801a50:	6a 00                	push   $0x0
  801a52:	e8 b2 ff ff ff       	call   801a09 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	90                   	nop
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_cgetc>:

int
sys_cgetc(void)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 01                	push   $0x1
  801a6c:	e8 98 ff ff ff       	call   801a09 <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	52                   	push   %edx
  801a86:	50                   	push   %eax
  801a87:	6a 05                	push   $0x5
  801a89:	e8 7b ff ff ff       	call   801a09 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	56                   	push   %esi
  801a97:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a98:	8b 75 18             	mov    0x18(%ebp),%esi
  801a9b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	56                   	push   %esi
  801aa8:	53                   	push   %ebx
  801aa9:	51                   	push   %ecx
  801aaa:	52                   	push   %edx
  801aab:	50                   	push   %eax
  801aac:	6a 06                	push   $0x6
  801aae:	e8 56 ff ff ff       	call   801a09 <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab9:	5b                   	pop    %ebx
  801aba:	5e                   	pop    %esi
  801abb:	5d                   	pop    %ebp
  801abc:	c3                   	ret    

00801abd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	52                   	push   %edx
  801acd:	50                   	push   %eax
  801ace:	6a 07                	push   $0x7
  801ad0:	e8 34 ff ff ff       	call   801a09 <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	ff 75 0c             	pushl  0xc(%ebp)
  801ae6:	ff 75 08             	pushl  0x8(%ebp)
  801ae9:	6a 08                	push   $0x8
  801aeb:	e8 19 ff ff ff       	call   801a09 <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 09                	push   $0x9
  801b04:	e8 00 ff ff ff       	call   801a09 <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 0a                	push   $0xa
  801b1d:	e8 e7 fe ff ff       	call   801a09 <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 0b                	push   $0xb
  801b36:	e8 ce fe ff ff       	call   801a09 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	ff 75 08             	pushl  0x8(%ebp)
  801b4f:	6a 0f                	push   $0xf
  801b51:	e8 b3 fe ff ff       	call   801a09 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
	return;
  801b59:	90                   	nop
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	6a 10                	push   $0x10
  801b6d:	e8 97 fe ff ff       	call   801a09 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
	return ;
  801b75:	90                   	nop
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	ff 75 10             	pushl  0x10(%ebp)
  801b82:	ff 75 0c             	pushl  0xc(%ebp)
  801b85:	ff 75 08             	pushl  0x8(%ebp)
  801b88:	6a 11                	push   $0x11
  801b8a:	e8 7a fe ff ff       	call   801a09 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b92:	90                   	nop
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 0c                	push   $0xc
  801ba4:	e8 60 fe ff ff       	call   801a09 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	ff 75 08             	pushl  0x8(%ebp)
  801bbc:	6a 0d                	push   $0xd
  801bbe:	e8 46 fe ff ff       	call   801a09 <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 0e                	push   $0xe
  801bd7:	e8 2d fe ff ff       	call   801a09 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	90                   	nop
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 13                	push   $0x13
  801bf1:	e8 13 fe ff ff       	call   801a09 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 14                	push   $0x14
  801c0b:	e8 f9 fd ff ff       	call   801a09 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	90                   	nop
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 04             	sub    $0x4,%esp
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c22:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	50                   	push   %eax
  801c2f:	6a 15                	push   $0x15
  801c31:	e8 d3 fd ff ff       	call   801a09 <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	90                   	nop
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 16                	push   $0x16
  801c4b:	e8 b9 fd ff ff       	call   801a09 <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	90                   	nop
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	ff 75 0c             	pushl  0xc(%ebp)
  801c65:	50                   	push   %eax
  801c66:	6a 17                	push   $0x17
  801c68:	e8 9c fd ff ff       	call   801a09 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c78:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	52                   	push   %edx
  801c82:	50                   	push   %eax
  801c83:	6a 1a                	push   $0x1a
  801c85:	e8 7f fd ff ff       	call   801a09 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	52                   	push   %edx
  801c9f:	50                   	push   %eax
  801ca0:	6a 18                	push   $0x18
  801ca2:	e8 62 fd ff ff       	call   801a09 <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	90                   	nop
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	52                   	push   %edx
  801cbd:	50                   	push   %eax
  801cbe:	6a 19                	push   $0x19
  801cc0:	e8 44 fd ff ff       	call   801a09 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	90                   	nop
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 04             	sub    $0x4,%esp
  801cd1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cd7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cda:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	51                   	push   %ecx
  801ce4:	52                   	push   %edx
  801ce5:	ff 75 0c             	pushl  0xc(%ebp)
  801ce8:	50                   	push   %eax
  801ce9:	6a 1b                	push   $0x1b
  801ceb:	e8 19 fd ff ff       	call   801a09 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	52                   	push   %edx
  801d05:	50                   	push   %eax
  801d06:	6a 1c                	push   $0x1c
  801d08:	e8 fc fc ff ff       	call   801a09 <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d15:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	51                   	push   %ecx
  801d23:	52                   	push   %edx
  801d24:	50                   	push   %eax
  801d25:	6a 1d                	push   $0x1d
  801d27:	e8 dd fc ff ff       	call   801a09 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d37:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	52                   	push   %edx
  801d41:	50                   	push   %eax
  801d42:	6a 1e                	push   $0x1e
  801d44:	e8 c0 fc ff ff       	call   801a09 <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 1f                	push   $0x1f
  801d5d:	e8 a7 fc ff ff       	call   801a09 <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	6a 00                	push   $0x0
  801d6f:	ff 75 14             	pushl  0x14(%ebp)
  801d72:	ff 75 10             	pushl  0x10(%ebp)
  801d75:	ff 75 0c             	pushl  0xc(%ebp)
  801d78:	50                   	push   %eax
  801d79:	6a 20                	push   $0x20
  801d7b:	e8 89 fc ff ff       	call   801a09 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	50                   	push   %eax
  801d94:	6a 21                	push   $0x21
  801d96:	e8 6e fc ff ff       	call   801a09 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
}
  801d9e:	90                   	nop
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	50                   	push   %eax
  801db0:	6a 22                	push   $0x22
  801db2:	e8 52 fc ff ff       	call   801a09 <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 02                	push   $0x2
  801dcb:	e8 39 fc ff ff       	call   801a09 <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 03                	push   $0x3
  801de4:	e8 20 fc ff ff       	call   801a09 <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 04                	push   $0x4
  801dfd:	e8 07 fc ff ff       	call   801a09 <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_exit_env>:


void sys_exit_env(void)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 23                	push   $0x23
  801e16:	e8 ee fb ff ff       	call   801a09 <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
}
  801e1e:	90                   	nop
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e27:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e2a:	8d 50 04             	lea    0x4(%eax),%edx
  801e2d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	52                   	push   %edx
  801e37:	50                   	push   %eax
  801e38:	6a 24                	push   $0x24
  801e3a:	e8 ca fb ff ff       	call   801a09 <syscall>
  801e3f:	83 c4 18             	add    $0x18,%esp
	return result;
  801e42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e4b:	89 01                	mov    %eax,(%ecx)
  801e4d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	c9                   	leave  
  801e54:	c2 04 00             	ret    $0x4

00801e57 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	ff 75 10             	pushl  0x10(%ebp)
  801e61:	ff 75 0c             	pushl  0xc(%ebp)
  801e64:	ff 75 08             	pushl  0x8(%ebp)
  801e67:	6a 12                	push   $0x12
  801e69:	e8 9b fb ff ff       	call   801a09 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e71:	90                   	nop
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 25                	push   $0x25
  801e83:	e8 81 fb ff ff       	call   801a09 <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 04             	sub    $0x4,%esp
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e99:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	50                   	push   %eax
  801ea6:	6a 26                	push   $0x26
  801ea8:	e8 5c fb ff ff       	call   801a09 <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb0:	90                   	nop
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <rsttst>:
void rsttst()
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 28                	push   $0x28
  801ec2:	e8 42 fb ff ff       	call   801a09 <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eca:	90                   	nop
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 04             	sub    $0x4,%esp
  801ed3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ed9:	8b 55 18             	mov    0x18(%ebp),%edx
  801edc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ee0:	52                   	push   %edx
  801ee1:	50                   	push   %eax
  801ee2:	ff 75 10             	pushl  0x10(%ebp)
  801ee5:	ff 75 0c             	pushl  0xc(%ebp)
  801ee8:	ff 75 08             	pushl  0x8(%ebp)
  801eeb:	6a 27                	push   $0x27
  801eed:	e8 17 fb ff ff       	call   801a09 <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef5:	90                   	nop
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <chktst>:
void chktst(uint32 n)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	ff 75 08             	pushl  0x8(%ebp)
  801f06:	6a 29                	push   $0x29
  801f08:	e8 fc fa ff ff       	call   801a09 <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f10:	90                   	nop
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <inctst>:

void inctst()
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 2a                	push   $0x2a
  801f22:	e8 e2 fa ff ff       	call   801a09 <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2a:	90                   	nop
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <gettst>:
uint32 gettst()
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 2b                	push   $0x2b
  801f3c:	e8 c8 fa ff ff       	call   801a09 <syscall>
  801f41:	83 c4 18             	add    $0x18,%esp
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 2c                	push   $0x2c
  801f58:	e8 ac fa ff ff       	call   801a09 <syscall>
  801f5d:	83 c4 18             	add    $0x18,%esp
  801f60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f63:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f67:	75 07                	jne    801f70 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f69:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6e:	eb 05                	jmp    801f75 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 2c                	push   $0x2c
  801f89:	e8 7b fa ff ff       	call   801a09 <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
  801f91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f94:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f98:	75 07                	jne    801fa1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9f:	eb 05                	jmp    801fa6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 2c                	push   $0x2c
  801fba:	e8 4a fa ff ff       	call   801a09 <syscall>
  801fbf:	83 c4 18             	add    $0x18,%esp
  801fc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fc5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fc9:	75 07                	jne    801fd2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fcb:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd0:	eb 05                	jmp    801fd7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 2c                	push   $0x2c
  801feb:	e8 19 fa ff ff       	call   801a09 <syscall>
  801ff0:	83 c4 18             	add    $0x18,%esp
  801ff3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ff6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ffa:	75 07                	jne    802003 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ffc:	b8 01 00 00 00       	mov    $0x1,%eax
  802001:	eb 05                	jmp    802008 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802003:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	ff 75 08             	pushl  0x8(%ebp)
  802018:	6a 2d                	push   $0x2d
  80201a:	e8 ea f9 ff ff       	call   801a09 <syscall>
  80201f:	83 c4 18             	add    $0x18,%esp
	return ;
  802022:	90                   	nop
}
  802023:	c9                   	leave  
  802024:	c3                   	ret    

00802025 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802029:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80202c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80202f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	6a 00                	push   $0x0
  802037:	53                   	push   %ebx
  802038:	51                   	push   %ecx
  802039:	52                   	push   %edx
  80203a:	50                   	push   %eax
  80203b:	6a 2e                	push   $0x2e
  80203d:	e8 c7 f9 ff ff       	call   801a09 <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80204d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	52                   	push   %edx
  80205a:	50                   	push   %eax
  80205b:	6a 2f                	push   $0x2f
  80205d:	e8 a7 f9 ff ff       	call   801a09 <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
  80206a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80206d:	83 ec 0c             	sub    $0xc,%esp
  802070:	68 a0 3b 80 00       	push   $0x803ba0
  802075:	e8 c3 e6 ff ff       	call   80073d <cprintf>
  80207a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80207d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802084:	83 ec 0c             	sub    $0xc,%esp
  802087:	68 cc 3b 80 00       	push   $0x803bcc
  80208c:	e8 ac e6 ff ff       	call   80073d <cprintf>
  802091:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802094:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802098:	a1 38 41 80 00       	mov    0x804138,%eax
  80209d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a0:	eb 56                	jmp    8020f8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020a6:	74 1c                	je     8020c4 <print_mem_block_lists+0x5d>
  8020a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ab:	8b 50 08             	mov    0x8(%eax),%edx
  8020ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b1:	8b 48 08             	mov    0x8(%eax),%ecx
  8020b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ba:	01 c8                	add    %ecx,%eax
  8020bc:	39 c2                	cmp    %eax,%edx
  8020be:	73 04                	jae    8020c4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020c0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c7:	8b 50 08             	mov    0x8(%eax),%edx
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d0:	01 c2                	add    %eax,%edx
  8020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d5:	8b 40 08             	mov    0x8(%eax),%eax
  8020d8:	83 ec 04             	sub    $0x4,%esp
  8020db:	52                   	push   %edx
  8020dc:	50                   	push   %eax
  8020dd:	68 e1 3b 80 00       	push   $0x803be1
  8020e2:	e8 56 e6 ff ff       	call   80073d <cprintf>
  8020e7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020f0:	a1 40 41 80 00       	mov    0x804140,%eax
  8020f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020fc:	74 07                	je     802105 <print_mem_block_lists+0x9e>
  8020fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802101:	8b 00                	mov    (%eax),%eax
  802103:	eb 05                	jmp    80210a <print_mem_block_lists+0xa3>
  802105:	b8 00 00 00 00       	mov    $0x0,%eax
  80210a:	a3 40 41 80 00       	mov    %eax,0x804140
  80210f:	a1 40 41 80 00       	mov    0x804140,%eax
  802114:	85 c0                	test   %eax,%eax
  802116:	75 8a                	jne    8020a2 <print_mem_block_lists+0x3b>
  802118:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211c:	75 84                	jne    8020a2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80211e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802122:	75 10                	jne    802134 <print_mem_block_lists+0xcd>
  802124:	83 ec 0c             	sub    $0xc,%esp
  802127:	68 f0 3b 80 00       	push   $0x803bf0
  80212c:	e8 0c e6 ff ff       	call   80073d <cprintf>
  802131:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802134:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80213b:	83 ec 0c             	sub    $0xc,%esp
  80213e:	68 14 3c 80 00       	push   $0x803c14
  802143:	e8 f5 e5 ff ff       	call   80073d <cprintf>
  802148:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80214b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80214f:	a1 40 40 80 00       	mov    0x804040,%eax
  802154:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802157:	eb 56                	jmp    8021af <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802159:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80215d:	74 1c                	je     80217b <print_mem_block_lists+0x114>
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802162:	8b 50 08             	mov    0x8(%eax),%edx
  802165:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802168:	8b 48 08             	mov    0x8(%eax),%ecx
  80216b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216e:	8b 40 0c             	mov    0xc(%eax),%eax
  802171:	01 c8                	add    %ecx,%eax
  802173:	39 c2                	cmp    %eax,%edx
  802175:	73 04                	jae    80217b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802177:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80217b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217e:	8b 50 08             	mov    0x8(%eax),%edx
  802181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802184:	8b 40 0c             	mov    0xc(%eax),%eax
  802187:	01 c2                	add    %eax,%edx
  802189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218c:	8b 40 08             	mov    0x8(%eax),%eax
  80218f:	83 ec 04             	sub    $0x4,%esp
  802192:	52                   	push   %edx
  802193:	50                   	push   %eax
  802194:	68 e1 3b 80 00       	push   $0x803be1
  802199:	e8 9f e5 ff ff       	call   80073d <cprintf>
  80219e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021a7:	a1 48 40 80 00       	mov    0x804048,%eax
  8021ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b3:	74 07                	je     8021bc <print_mem_block_lists+0x155>
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	8b 00                	mov    (%eax),%eax
  8021ba:	eb 05                	jmp    8021c1 <print_mem_block_lists+0x15a>
  8021bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c1:	a3 48 40 80 00       	mov    %eax,0x804048
  8021c6:	a1 48 40 80 00       	mov    0x804048,%eax
  8021cb:	85 c0                	test   %eax,%eax
  8021cd:	75 8a                	jne    802159 <print_mem_block_lists+0xf2>
  8021cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d3:	75 84                	jne    802159 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021d5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021d9:	75 10                	jne    8021eb <print_mem_block_lists+0x184>
  8021db:	83 ec 0c             	sub    $0xc,%esp
  8021de:	68 2c 3c 80 00       	push   $0x803c2c
  8021e3:	e8 55 e5 ff ff       	call   80073d <cprintf>
  8021e8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021eb:	83 ec 0c             	sub    $0xc,%esp
  8021ee:	68 a0 3b 80 00       	push   $0x803ba0
  8021f3:	e8 45 e5 ff ff       	call   80073d <cprintf>
  8021f8:	83 c4 10             	add    $0x10,%esp

}
  8021fb:	90                   	nop
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
  802201:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802204:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80220b:	00 00 00 
  80220e:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802215:	00 00 00 
  802218:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80221f:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802222:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802229:	e9 9e 00 00 00       	jmp    8022cc <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80222e:	a1 50 40 80 00       	mov    0x804050,%eax
  802233:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802236:	c1 e2 04             	shl    $0x4,%edx
  802239:	01 d0                	add    %edx,%eax
  80223b:	85 c0                	test   %eax,%eax
  80223d:	75 14                	jne    802253 <initialize_MemBlocksList+0x55>
  80223f:	83 ec 04             	sub    $0x4,%esp
  802242:	68 54 3c 80 00       	push   $0x803c54
  802247:	6a 47                	push   $0x47
  802249:	68 77 3c 80 00       	push   $0x803c77
  80224e:	e8 59 0f 00 00       	call   8031ac <_panic>
  802253:	a1 50 40 80 00       	mov    0x804050,%eax
  802258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225b:	c1 e2 04             	shl    $0x4,%edx
  80225e:	01 d0                	add    %edx,%eax
  802260:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802266:	89 10                	mov    %edx,(%eax)
  802268:	8b 00                	mov    (%eax),%eax
  80226a:	85 c0                	test   %eax,%eax
  80226c:	74 18                	je     802286 <initialize_MemBlocksList+0x88>
  80226e:	a1 48 41 80 00       	mov    0x804148,%eax
  802273:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802279:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80227c:	c1 e1 04             	shl    $0x4,%ecx
  80227f:	01 ca                	add    %ecx,%edx
  802281:	89 50 04             	mov    %edx,0x4(%eax)
  802284:	eb 12                	jmp    802298 <initialize_MemBlocksList+0x9a>
  802286:	a1 50 40 80 00       	mov    0x804050,%eax
  80228b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228e:	c1 e2 04             	shl    $0x4,%edx
  802291:	01 d0                	add    %edx,%eax
  802293:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802298:	a1 50 40 80 00       	mov    0x804050,%eax
  80229d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a0:	c1 e2 04             	shl    $0x4,%edx
  8022a3:	01 d0                	add    %edx,%eax
  8022a5:	a3 48 41 80 00       	mov    %eax,0x804148
  8022aa:	a1 50 40 80 00       	mov    0x804050,%eax
  8022af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b2:	c1 e2 04             	shl    $0x4,%edx
  8022b5:	01 d0                	add    %edx,%eax
  8022b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022be:	a1 54 41 80 00       	mov    0x804154,%eax
  8022c3:	40                   	inc    %eax
  8022c4:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8022c9:	ff 45 f4             	incl   -0xc(%ebp)
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d2:	0f 82 56 ff ff ff    	jb     80222e <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8022d8:	90                   	nop
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	8b 00                	mov    (%eax),%eax
  8022e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022e9:	eb 19                	jmp    802304 <find_block+0x29>
	{
		if(element->sva == va){
  8022eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022ee:	8b 40 08             	mov    0x8(%eax),%eax
  8022f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022f4:	75 05                	jne    8022fb <find_block+0x20>
			 		return element;
  8022f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f9:	eb 36                	jmp    802331 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	8b 40 08             	mov    0x8(%eax),%eax
  802301:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802304:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802308:	74 07                	je     802311 <find_block+0x36>
  80230a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80230d:	8b 00                	mov    (%eax),%eax
  80230f:	eb 05                	jmp    802316 <find_block+0x3b>
  802311:	b8 00 00 00 00       	mov    $0x0,%eax
  802316:	8b 55 08             	mov    0x8(%ebp),%edx
  802319:	89 42 08             	mov    %eax,0x8(%edx)
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	8b 40 08             	mov    0x8(%eax),%eax
  802322:	85 c0                	test   %eax,%eax
  802324:	75 c5                	jne    8022eb <find_block+0x10>
  802326:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80232a:	75 bf                	jne    8022eb <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  80232c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802339:	a1 44 40 80 00       	mov    0x804044,%eax
  80233e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802341:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802346:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802349:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80234d:	74 0a                	je     802359 <insert_sorted_allocList+0x26>
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	8b 40 08             	mov    0x8(%eax),%eax
  802355:	85 c0                	test   %eax,%eax
  802357:	75 65                	jne    8023be <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802359:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80235d:	75 14                	jne    802373 <insert_sorted_allocList+0x40>
  80235f:	83 ec 04             	sub    $0x4,%esp
  802362:	68 54 3c 80 00       	push   $0x803c54
  802367:	6a 6e                	push   $0x6e
  802369:	68 77 3c 80 00       	push   $0x803c77
  80236e:	e8 39 0e 00 00       	call   8031ac <_panic>
  802373:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	89 10                	mov    %edx,(%eax)
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	8b 00                	mov    (%eax),%eax
  802383:	85 c0                	test   %eax,%eax
  802385:	74 0d                	je     802394 <insert_sorted_allocList+0x61>
  802387:	a1 40 40 80 00       	mov    0x804040,%eax
  80238c:	8b 55 08             	mov    0x8(%ebp),%edx
  80238f:	89 50 04             	mov    %edx,0x4(%eax)
  802392:	eb 08                	jmp    80239c <insert_sorted_allocList+0x69>
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	a3 44 40 80 00       	mov    %eax,0x804044
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	a3 40 40 80 00       	mov    %eax,0x804040
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ae:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023b3:	40                   	inc    %eax
  8023b4:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8023b9:	e9 cf 01 00 00       	jmp    80258d <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8023be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c1:	8b 50 08             	mov    0x8(%eax),%edx
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	8b 40 08             	mov    0x8(%eax),%eax
  8023ca:	39 c2                	cmp    %eax,%edx
  8023cc:	73 65                	jae    802433 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8023ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d2:	75 14                	jne    8023e8 <insert_sorted_allocList+0xb5>
  8023d4:	83 ec 04             	sub    $0x4,%esp
  8023d7:	68 90 3c 80 00       	push   $0x803c90
  8023dc:	6a 72                	push   $0x72
  8023de:	68 77 3c 80 00       	push   $0x803c77
  8023e3:	e8 c4 0d 00 00       	call   8031ac <_panic>
  8023e8:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	89 50 04             	mov    %edx,0x4(%eax)
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	8b 40 04             	mov    0x4(%eax),%eax
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	74 0c                	je     80240a <insert_sorted_allocList+0xd7>
  8023fe:	a1 44 40 80 00       	mov    0x804044,%eax
  802403:	8b 55 08             	mov    0x8(%ebp),%edx
  802406:	89 10                	mov    %edx,(%eax)
  802408:	eb 08                	jmp    802412 <insert_sorted_allocList+0xdf>
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	a3 40 40 80 00       	mov    %eax,0x804040
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	a3 44 40 80 00       	mov    %eax,0x804044
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802423:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802428:	40                   	inc    %eax
  802429:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80242e:	e9 5a 01 00 00       	jmp    80258d <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802436:	8b 50 08             	mov    0x8(%eax),%edx
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	8b 40 08             	mov    0x8(%eax),%eax
  80243f:	39 c2                	cmp    %eax,%edx
  802441:	75 70                	jne    8024b3 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802443:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802447:	74 06                	je     80244f <insert_sorted_allocList+0x11c>
  802449:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80244d:	75 14                	jne    802463 <insert_sorted_allocList+0x130>
  80244f:	83 ec 04             	sub    $0x4,%esp
  802452:	68 b4 3c 80 00       	push   $0x803cb4
  802457:	6a 75                	push   $0x75
  802459:	68 77 3c 80 00       	push   $0x803c77
  80245e:	e8 49 0d 00 00       	call   8031ac <_panic>
  802463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802466:	8b 10                	mov    (%eax),%edx
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	89 10                	mov    %edx,(%eax)
  80246d:	8b 45 08             	mov    0x8(%ebp),%eax
  802470:	8b 00                	mov    (%eax),%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	74 0b                	je     802481 <insert_sorted_allocList+0x14e>
  802476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802479:	8b 00                	mov    (%eax),%eax
  80247b:	8b 55 08             	mov    0x8(%ebp),%edx
  80247e:	89 50 04             	mov    %edx,0x4(%eax)
  802481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802484:	8b 55 08             	mov    0x8(%ebp),%edx
  802487:	89 10                	mov    %edx,(%eax)
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80248f:	89 50 04             	mov    %edx,0x4(%eax)
  802492:	8b 45 08             	mov    0x8(%ebp),%eax
  802495:	8b 00                	mov    (%eax),%eax
  802497:	85 c0                	test   %eax,%eax
  802499:	75 08                	jne    8024a3 <insert_sorted_allocList+0x170>
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	a3 44 40 80 00       	mov    %eax,0x804044
  8024a3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024a8:	40                   	inc    %eax
  8024a9:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8024ae:	e9 da 00 00 00       	jmp    80258d <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8024b3:	a1 40 40 80 00       	mov    0x804040,%eax
  8024b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bb:	e9 9d 00 00 00       	jmp    80255d <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 00                	mov    (%eax),%eax
  8024c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8024c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cb:	8b 50 08             	mov    0x8(%eax),%edx
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	8b 40 08             	mov    0x8(%eax),%eax
  8024d4:	39 c2                	cmp    %eax,%edx
  8024d6:	76 7d                	jbe    802555 <insert_sorted_allocList+0x222>
  8024d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024db:	8b 50 08             	mov    0x8(%eax),%edx
  8024de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024e1:	8b 40 08             	mov    0x8(%eax),%eax
  8024e4:	39 c2                	cmp    %eax,%edx
  8024e6:	73 6d                	jae    802555 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8024e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ec:	74 06                	je     8024f4 <insert_sorted_allocList+0x1c1>
  8024ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024f2:	75 14                	jne    802508 <insert_sorted_allocList+0x1d5>
  8024f4:	83 ec 04             	sub    $0x4,%esp
  8024f7:	68 b4 3c 80 00       	push   $0x803cb4
  8024fc:	6a 7c                	push   $0x7c
  8024fe:	68 77 3c 80 00       	push   $0x803c77
  802503:	e8 a4 0c 00 00       	call   8031ac <_panic>
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	8b 10                	mov    (%eax),%edx
  80250d:	8b 45 08             	mov    0x8(%ebp),%eax
  802510:	89 10                	mov    %edx,(%eax)
  802512:	8b 45 08             	mov    0x8(%ebp),%eax
  802515:	8b 00                	mov    (%eax),%eax
  802517:	85 c0                	test   %eax,%eax
  802519:	74 0b                	je     802526 <insert_sorted_allocList+0x1f3>
  80251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251e:	8b 00                	mov    (%eax),%eax
  802520:	8b 55 08             	mov    0x8(%ebp),%edx
  802523:	89 50 04             	mov    %edx,0x4(%eax)
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	8b 55 08             	mov    0x8(%ebp),%edx
  80252c:	89 10                	mov    %edx,(%eax)
  80252e:	8b 45 08             	mov    0x8(%ebp),%eax
  802531:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802534:	89 50 04             	mov    %edx,0x4(%eax)
  802537:	8b 45 08             	mov    0x8(%ebp),%eax
  80253a:	8b 00                	mov    (%eax),%eax
  80253c:	85 c0                	test   %eax,%eax
  80253e:	75 08                	jne    802548 <insert_sorted_allocList+0x215>
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	a3 44 40 80 00       	mov    %eax,0x804044
  802548:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80254d:	40                   	inc    %eax
  80254e:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802553:	eb 38                	jmp    80258d <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802555:	a1 48 40 80 00       	mov    0x804048,%eax
  80255a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80255d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802561:	74 07                	je     80256a <insert_sorted_allocList+0x237>
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 00                	mov    (%eax),%eax
  802568:	eb 05                	jmp    80256f <insert_sorted_allocList+0x23c>
  80256a:	b8 00 00 00 00       	mov    $0x0,%eax
  80256f:	a3 48 40 80 00       	mov    %eax,0x804048
  802574:	a1 48 40 80 00       	mov    0x804048,%eax
  802579:	85 c0                	test   %eax,%eax
  80257b:	0f 85 3f ff ff ff    	jne    8024c0 <insert_sorted_allocList+0x18d>
  802581:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802585:	0f 85 35 ff ff ff    	jne    8024c0 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  80258b:	eb 00                	jmp    80258d <insert_sorted_allocList+0x25a>
  80258d:	90                   	nop
  80258e:	c9                   	leave  
  80258f:	c3                   	ret    

00802590 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802596:	a1 38 41 80 00       	mov    0x804138,%eax
  80259b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259e:	e9 6b 02 00 00       	jmp    80280e <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ac:	0f 85 90 00 00 00    	jne    802642 <alloc_block_FF+0xb2>
			  temp=element;
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8025b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bc:	75 17                	jne    8025d5 <alloc_block_FF+0x45>
  8025be:	83 ec 04             	sub    $0x4,%esp
  8025c1:	68 e8 3c 80 00       	push   $0x803ce8
  8025c6:	68 92 00 00 00       	push   $0x92
  8025cb:	68 77 3c 80 00       	push   $0x803c77
  8025d0:	e8 d7 0b 00 00       	call   8031ac <_panic>
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	8b 00                	mov    (%eax),%eax
  8025da:	85 c0                	test   %eax,%eax
  8025dc:	74 10                	je     8025ee <alloc_block_FF+0x5e>
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 00                	mov    (%eax),%eax
  8025e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e6:	8b 52 04             	mov    0x4(%edx),%edx
  8025e9:	89 50 04             	mov    %edx,0x4(%eax)
  8025ec:	eb 0b                	jmp    8025f9 <alloc_block_FF+0x69>
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 40 04             	mov    0x4(%eax),%eax
  8025f4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 40 04             	mov    0x4(%eax),%eax
  8025ff:	85 c0                	test   %eax,%eax
  802601:	74 0f                	je     802612 <alloc_block_FF+0x82>
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 40 04             	mov    0x4(%eax),%eax
  802609:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260c:	8b 12                	mov    (%edx),%edx
  80260e:	89 10                	mov    %edx,(%eax)
  802610:	eb 0a                	jmp    80261c <alloc_block_FF+0x8c>
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 00                	mov    (%eax),%eax
  802617:	a3 38 41 80 00       	mov    %eax,0x804138
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80262f:	a1 44 41 80 00       	mov    0x804144,%eax
  802634:	48                   	dec    %eax
  802635:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  80263a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80263d:	e9 ff 01 00 00       	jmp    802841 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 40 0c             	mov    0xc(%eax),%eax
  802648:	3b 45 08             	cmp    0x8(%ebp),%eax
  80264b:	0f 86 b5 01 00 00    	jbe    802806 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 40 0c             	mov    0xc(%eax),%eax
  802657:	2b 45 08             	sub    0x8(%ebp),%eax
  80265a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80265d:	a1 48 41 80 00       	mov    0x804148,%eax
  802662:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802665:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802669:	75 17                	jne    802682 <alloc_block_FF+0xf2>
  80266b:	83 ec 04             	sub    $0x4,%esp
  80266e:	68 e8 3c 80 00       	push   $0x803ce8
  802673:	68 99 00 00 00       	push   $0x99
  802678:	68 77 3c 80 00       	push   $0x803c77
  80267d:	e8 2a 0b 00 00       	call   8031ac <_panic>
  802682:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802685:	8b 00                	mov    (%eax),%eax
  802687:	85 c0                	test   %eax,%eax
  802689:	74 10                	je     80269b <alloc_block_FF+0x10b>
  80268b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268e:	8b 00                	mov    (%eax),%eax
  802690:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802693:	8b 52 04             	mov    0x4(%edx),%edx
  802696:	89 50 04             	mov    %edx,0x4(%eax)
  802699:	eb 0b                	jmp    8026a6 <alloc_block_FF+0x116>
  80269b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269e:	8b 40 04             	mov    0x4(%eax),%eax
  8026a1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a9:	8b 40 04             	mov    0x4(%eax),%eax
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	74 0f                	je     8026bf <alloc_block_FF+0x12f>
  8026b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026b9:	8b 12                	mov    (%edx),%edx
  8026bb:	89 10                	mov    %edx,(%eax)
  8026bd:	eb 0a                	jmp    8026c9 <alloc_block_FF+0x139>
  8026bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c2:	8b 00                	mov    (%eax),%eax
  8026c4:	a3 48 41 80 00       	mov    %eax,0x804148
  8026c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026dc:	a1 54 41 80 00       	mov    0x804154,%eax
  8026e1:	48                   	dec    %eax
  8026e2:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8026e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026eb:	75 17                	jne    802704 <alloc_block_FF+0x174>
  8026ed:	83 ec 04             	sub    $0x4,%esp
  8026f0:	68 90 3c 80 00       	push   $0x803c90
  8026f5:	68 9a 00 00 00       	push   $0x9a
  8026fa:	68 77 3c 80 00       	push   $0x803c77
  8026ff:	e8 a8 0a 00 00       	call   8031ac <_panic>
  802704:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80270a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270d:	89 50 04             	mov    %edx,0x4(%eax)
  802710:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802713:	8b 40 04             	mov    0x4(%eax),%eax
  802716:	85 c0                	test   %eax,%eax
  802718:	74 0c                	je     802726 <alloc_block_FF+0x196>
  80271a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80271f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802722:	89 10                	mov    %edx,(%eax)
  802724:	eb 08                	jmp    80272e <alloc_block_FF+0x19e>
  802726:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802729:	a3 38 41 80 00       	mov    %eax,0x804138
  80272e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802731:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802736:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802739:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273f:	a1 44 41 80 00       	mov    0x804144,%eax
  802744:	40                   	inc    %eax
  802745:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  80274a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274d:	8b 55 08             	mov    0x8(%ebp),%edx
  802750:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 50 08             	mov    0x8(%eax),%edx
  802759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275c:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802765:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 50 08             	mov    0x8(%eax),%edx
  80276e:	8b 45 08             	mov    0x8(%ebp),%eax
  802771:	01 c2                	add    %eax,%edx
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802779:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  80277f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802783:	75 17                	jne    80279c <alloc_block_FF+0x20c>
  802785:	83 ec 04             	sub    $0x4,%esp
  802788:	68 e8 3c 80 00       	push   $0x803ce8
  80278d:	68 a2 00 00 00       	push   $0xa2
  802792:	68 77 3c 80 00       	push   $0x803c77
  802797:	e8 10 0a 00 00       	call   8031ac <_panic>
  80279c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279f:	8b 00                	mov    (%eax),%eax
  8027a1:	85 c0                	test   %eax,%eax
  8027a3:	74 10                	je     8027b5 <alloc_block_FF+0x225>
  8027a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a8:	8b 00                	mov    (%eax),%eax
  8027aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ad:	8b 52 04             	mov    0x4(%edx),%edx
  8027b0:	89 50 04             	mov    %edx,0x4(%eax)
  8027b3:	eb 0b                	jmp    8027c0 <alloc_block_FF+0x230>
  8027b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b8:	8b 40 04             	mov    0x4(%eax),%eax
  8027bb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c3:	8b 40 04             	mov    0x4(%eax),%eax
  8027c6:	85 c0                	test   %eax,%eax
  8027c8:	74 0f                	je     8027d9 <alloc_block_FF+0x249>
  8027ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cd:	8b 40 04             	mov    0x4(%eax),%eax
  8027d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027d3:	8b 12                	mov    (%edx),%edx
  8027d5:	89 10                	mov    %edx,(%eax)
  8027d7:	eb 0a                	jmp    8027e3 <alloc_block_FF+0x253>
  8027d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027dc:	8b 00                	mov    (%eax),%eax
  8027de:	a3 38 41 80 00       	mov    %eax,0x804138
  8027e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f6:	a1 44 41 80 00       	mov    0x804144,%eax
  8027fb:	48                   	dec    %eax
  8027fc:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  802801:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802804:	eb 3b                	jmp    802841 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802806:	a1 40 41 80 00       	mov    0x804140,%eax
  80280b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802812:	74 07                	je     80281b <alloc_block_FF+0x28b>
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 00                	mov    (%eax),%eax
  802819:	eb 05                	jmp    802820 <alloc_block_FF+0x290>
  80281b:	b8 00 00 00 00       	mov    $0x0,%eax
  802820:	a3 40 41 80 00       	mov    %eax,0x804140
  802825:	a1 40 41 80 00       	mov    0x804140,%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	0f 85 71 fd ff ff    	jne    8025a3 <alloc_block_FF+0x13>
  802832:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802836:	0f 85 67 fd ff ff    	jne    8025a3 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  80283c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802841:	c9                   	leave  
  802842:	c3                   	ret    

00802843 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802849:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802850:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802857:	a1 38 41 80 00       	mov    0x804138,%eax
  80285c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80285f:	e9 d3 00 00 00       	jmp    802937 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802864:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802867:	8b 40 0c             	mov    0xc(%eax),%eax
  80286a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286d:	0f 85 90 00 00 00    	jne    802903 <alloc_block_BF+0xc0>
	   temp = element;
  802873:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802876:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802879:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80287d:	75 17                	jne    802896 <alloc_block_BF+0x53>
  80287f:	83 ec 04             	sub    $0x4,%esp
  802882:	68 e8 3c 80 00       	push   $0x803ce8
  802887:	68 bd 00 00 00       	push   $0xbd
  80288c:	68 77 3c 80 00       	push   $0x803c77
  802891:	e8 16 09 00 00       	call   8031ac <_panic>
  802896:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802899:	8b 00                	mov    (%eax),%eax
  80289b:	85 c0                	test   %eax,%eax
  80289d:	74 10                	je     8028af <alloc_block_BF+0x6c>
  80289f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a2:	8b 00                	mov    (%eax),%eax
  8028a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028a7:	8b 52 04             	mov    0x4(%edx),%edx
  8028aa:	89 50 04             	mov    %edx,0x4(%eax)
  8028ad:	eb 0b                	jmp    8028ba <alloc_block_BF+0x77>
  8028af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b2:	8b 40 04             	mov    0x4(%eax),%eax
  8028b5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028bd:	8b 40 04             	mov    0x4(%eax),%eax
  8028c0:	85 c0                	test   %eax,%eax
  8028c2:	74 0f                	je     8028d3 <alloc_block_BF+0x90>
  8028c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028cd:	8b 12                	mov    (%edx),%edx
  8028cf:	89 10                	mov    %edx,(%eax)
  8028d1:	eb 0a                	jmp    8028dd <alloc_block_BF+0x9a>
  8028d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d6:	8b 00                	mov    (%eax),%eax
  8028d8:	a3 38 41 80 00       	mov    %eax,0x804138
  8028dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f0:	a1 44 41 80 00       	mov    0x804144,%eax
  8028f5:	48                   	dec    %eax
  8028f6:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  8028fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028fe:	e9 41 01 00 00       	jmp    802a44 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802903:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802906:	8b 40 0c             	mov    0xc(%eax),%eax
  802909:	3b 45 08             	cmp    0x8(%ebp),%eax
  80290c:	76 21                	jbe    80292f <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  80290e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802911:	8b 40 0c             	mov    0xc(%eax),%eax
  802914:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802917:	73 16                	jae    80292f <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802919:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291c:	8b 40 0c             	mov    0xc(%eax),%eax
  80291f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802922:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802925:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802928:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80292f:	a1 40 41 80 00       	mov    0x804140,%eax
  802934:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802937:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80293b:	74 07                	je     802944 <alloc_block_BF+0x101>
  80293d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802940:	8b 00                	mov    (%eax),%eax
  802942:	eb 05                	jmp    802949 <alloc_block_BF+0x106>
  802944:	b8 00 00 00 00       	mov    $0x0,%eax
  802949:	a3 40 41 80 00       	mov    %eax,0x804140
  80294e:	a1 40 41 80 00       	mov    0x804140,%eax
  802953:	85 c0                	test   %eax,%eax
  802955:	0f 85 09 ff ff ff    	jne    802864 <alloc_block_BF+0x21>
  80295b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80295f:	0f 85 ff fe ff ff    	jne    802864 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802965:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802969:	0f 85 d0 00 00 00    	jne    802a3f <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80296f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802972:	8b 40 0c             	mov    0xc(%eax),%eax
  802975:	2b 45 08             	sub    0x8(%ebp),%eax
  802978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  80297b:	a1 48 41 80 00       	mov    0x804148,%eax
  802980:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802983:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802987:	75 17                	jne    8029a0 <alloc_block_BF+0x15d>
  802989:	83 ec 04             	sub    $0x4,%esp
  80298c:	68 e8 3c 80 00       	push   $0x803ce8
  802991:	68 d1 00 00 00       	push   $0xd1
  802996:	68 77 3c 80 00       	push   $0x803c77
  80299b:	e8 0c 08 00 00       	call   8031ac <_panic>
  8029a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029a3:	8b 00                	mov    (%eax),%eax
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	74 10                	je     8029b9 <alloc_block_BF+0x176>
  8029a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ac:	8b 00                	mov    (%eax),%eax
  8029ae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029b1:	8b 52 04             	mov    0x4(%edx),%edx
  8029b4:	89 50 04             	mov    %edx,0x4(%eax)
  8029b7:	eb 0b                	jmp    8029c4 <alloc_block_BF+0x181>
  8029b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029bc:	8b 40 04             	mov    0x4(%eax),%eax
  8029bf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029c7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	74 0f                	je     8029dd <alloc_block_BF+0x19a>
  8029ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029d1:	8b 40 04             	mov    0x4(%eax),%eax
  8029d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029d7:	8b 12                	mov    (%edx),%edx
  8029d9:	89 10                	mov    %edx,(%eax)
  8029db:	eb 0a                	jmp    8029e7 <alloc_block_BF+0x1a4>
  8029dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029e0:	8b 00                	mov    (%eax),%eax
  8029e2:	a3 48 41 80 00       	mov    %eax,0x804148
  8029e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fa:	a1 54 41 80 00       	mov    0x804154,%eax
  8029ff:	48                   	dec    %eax
  802a00:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802a05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a08:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0b:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a11:	8b 50 08             	mov    0x8(%eax),%edx
  802a14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a17:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802a1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a20:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a26:	8b 50 08             	mov    0x8(%eax),%edx
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	01 c2                	add    %eax,%edx
  802a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a31:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a37:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802a3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a3d:	eb 05                	jmp    802a44 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802a3f:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802a44:	c9                   	leave  
  802a45:	c3                   	ret    

00802a46 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a46:	55                   	push   %ebp
  802a47:	89 e5                	mov    %esp,%ebp
  802a49:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802a4c:	83 ec 04             	sub    $0x4,%esp
  802a4f:	68 08 3d 80 00       	push   $0x803d08
  802a54:	68 e8 00 00 00       	push   $0xe8
  802a59:	68 77 3c 80 00       	push   $0x803c77
  802a5e:	e8 49 07 00 00       	call   8031ac <_panic>

00802a63 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a63:	55                   	push   %ebp
  802a64:	89 e5                	mov    %esp,%ebp
  802a66:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802a69:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802a71:	a1 38 41 80 00       	mov    0x804138,%eax
  802a76:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802a79:	a1 44 41 80 00       	mov    0x804144,%eax
  802a7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802a81:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a85:	75 68                	jne    802aef <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a8b:	75 17                	jne    802aa4 <insert_sorted_with_merge_freeList+0x41>
  802a8d:	83 ec 04             	sub    $0x4,%esp
  802a90:	68 54 3c 80 00       	push   $0x803c54
  802a95:	68 36 01 00 00       	push   $0x136
  802a9a:	68 77 3c 80 00       	push   $0x803c77
  802a9f:	e8 08 07 00 00       	call   8031ac <_panic>
  802aa4:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802aad:	89 10                	mov    %edx,(%eax)
  802aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab2:	8b 00                	mov    (%eax),%eax
  802ab4:	85 c0                	test   %eax,%eax
  802ab6:	74 0d                	je     802ac5 <insert_sorted_with_merge_freeList+0x62>
  802ab8:	a1 38 41 80 00       	mov    0x804138,%eax
  802abd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac0:	89 50 04             	mov    %edx,0x4(%eax)
  802ac3:	eb 08                	jmp    802acd <insert_sorted_with_merge_freeList+0x6a>
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	a3 38 41 80 00       	mov    %eax,0x804138
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802adf:	a1 44 41 80 00       	mov    0x804144,%eax
  802ae4:	40                   	inc    %eax
  802ae5:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802aea:	e9 ba 06 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af2:	8b 50 08             	mov    0x8(%eax),%edx
  802af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af8:	8b 40 0c             	mov    0xc(%eax),%eax
  802afb:	01 c2                	add    %eax,%edx
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	8b 40 08             	mov    0x8(%eax),%eax
  802b03:	39 c2                	cmp    %eax,%edx
  802b05:	73 68                	jae    802b6f <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802b07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b0b:	75 17                	jne    802b24 <insert_sorted_with_merge_freeList+0xc1>
  802b0d:	83 ec 04             	sub    $0x4,%esp
  802b10:	68 90 3c 80 00       	push   $0x803c90
  802b15:	68 3a 01 00 00       	push   $0x13a
  802b1a:	68 77 3c 80 00       	push   $0x803c77
  802b1f:	e8 88 06 00 00       	call   8031ac <_panic>
  802b24:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2d:	89 50 04             	mov    %edx,0x4(%eax)
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	74 0c                	je     802b46 <insert_sorted_with_merge_freeList+0xe3>
  802b3a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b42:	89 10                	mov    %edx,(%eax)
  802b44:	eb 08                	jmp    802b4e <insert_sorted_with_merge_freeList+0xeb>
  802b46:	8b 45 08             	mov    0x8(%ebp),%eax
  802b49:	a3 38 41 80 00       	mov    %eax,0x804138
  802b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b51:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5f:	a1 44 41 80 00       	mov    0x804144,%eax
  802b64:	40                   	inc    %eax
  802b65:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802b6a:	e9 3a 06 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b72:	8b 50 08             	mov    0x8(%eax),%edx
  802b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b78:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7b:	01 c2                	add    %eax,%edx
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	8b 40 08             	mov    0x8(%eax),%eax
  802b83:	39 c2                	cmp    %eax,%edx
  802b85:	0f 85 90 00 00 00    	jne    802c1b <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8e:	8b 50 0c             	mov    0xc(%eax),%edx
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	8b 40 0c             	mov    0xc(%eax),%eax
  802b97:	01 c2                	add    %eax,%edx
  802b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9c:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802bb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bb7:	75 17                	jne    802bd0 <insert_sorted_with_merge_freeList+0x16d>
  802bb9:	83 ec 04             	sub    $0x4,%esp
  802bbc:	68 54 3c 80 00       	push   $0x803c54
  802bc1:	68 41 01 00 00       	push   $0x141
  802bc6:	68 77 3c 80 00       	push   $0x803c77
  802bcb:	e8 dc 05 00 00       	call   8031ac <_panic>
  802bd0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	89 10                	mov    %edx,(%eax)
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	8b 00                	mov    (%eax),%eax
  802be0:	85 c0                	test   %eax,%eax
  802be2:	74 0d                	je     802bf1 <insert_sorted_with_merge_freeList+0x18e>
  802be4:	a1 48 41 80 00       	mov    0x804148,%eax
  802be9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bec:	89 50 04             	mov    %edx,0x4(%eax)
  802bef:	eb 08                	jmp    802bf9 <insert_sorted_with_merge_freeList+0x196>
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfc:	a3 48 41 80 00       	mov    %eax,0x804148
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0b:	a1 54 41 80 00       	mov    0x804154,%eax
  802c10:	40                   	inc    %eax
  802c11:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802c16:	e9 8e 05 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1e:	8b 50 08             	mov    0x8(%eax),%edx
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	8b 40 0c             	mov    0xc(%eax),%eax
  802c27:	01 c2                	add    %eax,%edx
  802c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2c:	8b 40 08             	mov    0x8(%eax),%eax
  802c2f:	39 c2                	cmp    %eax,%edx
  802c31:	73 68                	jae    802c9b <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c37:	75 17                	jne    802c50 <insert_sorted_with_merge_freeList+0x1ed>
  802c39:	83 ec 04             	sub    $0x4,%esp
  802c3c:	68 54 3c 80 00       	push   $0x803c54
  802c41:	68 45 01 00 00       	push   $0x145
  802c46:	68 77 3c 80 00       	push   $0x803c77
  802c4b:	e8 5c 05 00 00       	call   8031ac <_panic>
  802c50:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	89 10                	mov    %edx,(%eax)
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	85 c0                	test   %eax,%eax
  802c62:	74 0d                	je     802c71 <insert_sorted_with_merge_freeList+0x20e>
  802c64:	a1 38 41 80 00       	mov    0x804138,%eax
  802c69:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6c:	89 50 04             	mov    %edx,0x4(%eax)
  802c6f:	eb 08                	jmp    802c79 <insert_sorted_with_merge_freeList+0x216>
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	a3 38 41 80 00       	mov    %eax,0x804138
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8b:	a1 44 41 80 00       	mov    0x804144,%eax
  802c90:	40                   	inc    %eax
  802c91:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802c96:	e9 0e 05 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca7:	01 c2                	add    %eax,%edx
  802ca9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cac:	8b 40 08             	mov    0x8(%eax),%eax
  802caf:	39 c2                	cmp    %eax,%edx
  802cb1:	0f 85 9c 00 00 00    	jne    802d53 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802cb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cba:	8b 50 0c             	mov    0xc(%eax),%edx
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc3:	01 c2                	add    %eax,%edx
  802cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc8:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cce:	8b 50 08             	mov    0x8(%eax),%edx
  802cd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd4:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ceb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cef:	75 17                	jne    802d08 <insert_sorted_with_merge_freeList+0x2a5>
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	68 54 3c 80 00       	push   $0x803c54
  802cf9:	68 4d 01 00 00       	push   $0x14d
  802cfe:	68 77 3c 80 00       	push   $0x803c77
  802d03:	e8 a4 04 00 00       	call   8031ac <_panic>
  802d08:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	89 10                	mov    %edx,(%eax)
  802d13:	8b 45 08             	mov    0x8(%ebp),%eax
  802d16:	8b 00                	mov    (%eax),%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	74 0d                	je     802d29 <insert_sorted_with_merge_freeList+0x2c6>
  802d1c:	a1 48 41 80 00       	mov    0x804148,%eax
  802d21:	8b 55 08             	mov    0x8(%ebp),%edx
  802d24:	89 50 04             	mov    %edx,0x4(%eax)
  802d27:	eb 08                	jmp    802d31 <insert_sorted_with_merge_freeList+0x2ce>
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	a3 48 41 80 00       	mov    %eax,0x804148
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d43:	a1 54 41 80 00       	mov    0x804154,%eax
  802d48:	40                   	inc    %eax
  802d49:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802d4e:	e9 56 04 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802d53:	a1 38 41 80 00       	mov    0x804138,%eax
  802d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d5b:	e9 19 04 00 00       	jmp    803179 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	8b 00                	mov    (%eax),%eax
  802d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 50 08             	mov    0x8(%eax),%edx
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 40 0c             	mov    0xc(%eax),%eax
  802d74:	01 c2                	add    %eax,%edx
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	8b 40 08             	mov    0x8(%eax),%eax
  802d7c:	39 c2                	cmp    %eax,%edx
  802d7e:	0f 85 ad 01 00 00    	jne    802f31 <insert_sorted_with_merge_freeList+0x4ce>
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	8b 50 08             	mov    0x8(%eax),%edx
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d90:	01 c2                	add    %eax,%edx
  802d92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d95:	8b 40 08             	mov    0x8(%eax),%eax
  802d98:	39 c2                	cmp    %eax,%edx
  802d9a:	0f 85 91 01 00 00    	jne    802f31 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 50 0c             	mov    0xc(%eax),%edx
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	8b 48 0c             	mov    0xc(%eax),%ecx
  802dac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802daf:	8b 40 0c             	mov    0xc(%eax),%eax
  802db2:	01 c8                	add    %ecx,%eax
  802db4:	01 c2                	add    %eax,%edx
  802db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db9:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802dd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802dda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ddd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802de4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802de8:	75 17                	jne    802e01 <insert_sorted_with_merge_freeList+0x39e>
  802dea:	83 ec 04             	sub    $0x4,%esp
  802ded:	68 e8 3c 80 00       	push   $0x803ce8
  802df2:	68 5b 01 00 00       	push   $0x15b
  802df7:	68 77 3c 80 00       	push   $0x803c77
  802dfc:	e8 ab 03 00 00       	call   8031ac <_panic>
  802e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e04:	8b 00                	mov    (%eax),%eax
  802e06:	85 c0                	test   %eax,%eax
  802e08:	74 10                	je     802e1a <insert_sorted_with_merge_freeList+0x3b7>
  802e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e0d:	8b 00                	mov    (%eax),%eax
  802e0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e12:	8b 52 04             	mov    0x4(%edx),%edx
  802e15:	89 50 04             	mov    %edx,0x4(%eax)
  802e18:	eb 0b                	jmp    802e25 <insert_sorted_with_merge_freeList+0x3c2>
  802e1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e1d:	8b 40 04             	mov    0x4(%eax),%eax
  802e20:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e28:	8b 40 04             	mov    0x4(%eax),%eax
  802e2b:	85 c0                	test   %eax,%eax
  802e2d:	74 0f                	je     802e3e <insert_sorted_with_merge_freeList+0x3db>
  802e2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e32:	8b 40 04             	mov    0x4(%eax),%eax
  802e35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e38:	8b 12                	mov    (%edx),%edx
  802e3a:	89 10                	mov    %edx,(%eax)
  802e3c:	eb 0a                	jmp    802e48 <insert_sorted_with_merge_freeList+0x3e5>
  802e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e41:	8b 00                	mov    (%eax),%eax
  802e43:	a3 38 41 80 00       	mov    %eax,0x804138
  802e48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5b:	a1 44 41 80 00       	mov    0x804144,%eax
  802e60:	48                   	dec    %eax
  802e61:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e6a:	75 17                	jne    802e83 <insert_sorted_with_merge_freeList+0x420>
  802e6c:	83 ec 04             	sub    $0x4,%esp
  802e6f:	68 54 3c 80 00       	push   $0x803c54
  802e74:	68 5c 01 00 00       	push   $0x15c
  802e79:	68 77 3c 80 00       	push   $0x803c77
  802e7e:	e8 29 03 00 00       	call   8031ac <_panic>
  802e83:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	89 10                	mov    %edx,(%eax)
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	8b 00                	mov    (%eax),%eax
  802e93:	85 c0                	test   %eax,%eax
  802e95:	74 0d                	je     802ea4 <insert_sorted_with_merge_freeList+0x441>
  802e97:	a1 48 41 80 00       	mov    0x804148,%eax
  802e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ea2:	eb 08                	jmp    802eac <insert_sorted_with_merge_freeList+0x449>
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	a3 48 41 80 00       	mov    %eax,0x804148
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ebe:	a1 54 41 80 00       	mov    0x804154,%eax
  802ec3:	40                   	inc    %eax
  802ec4:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802ec9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ecd:	75 17                	jne    802ee6 <insert_sorted_with_merge_freeList+0x483>
  802ecf:	83 ec 04             	sub    $0x4,%esp
  802ed2:	68 54 3c 80 00       	push   $0x803c54
  802ed7:	68 5d 01 00 00       	push   $0x15d
  802edc:	68 77 3c 80 00       	push   $0x803c77
  802ee1:	e8 c6 02 00 00       	call   8031ac <_panic>
  802ee6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eef:	89 10                	mov    %edx,(%eax)
  802ef1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	85 c0                	test   %eax,%eax
  802ef8:	74 0d                	je     802f07 <insert_sorted_with_merge_freeList+0x4a4>
  802efa:	a1 48 41 80 00       	mov    0x804148,%eax
  802eff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f02:	89 50 04             	mov    %edx,0x4(%eax)
  802f05:	eb 08                	jmp    802f0f <insert_sorted_with_merge_freeList+0x4ac>
  802f07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f0a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f12:	a3 48 41 80 00       	mov    %eax,0x804148
  802f17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f21:	a1 54 41 80 00       	mov    0x804154,%eax
  802f26:	40                   	inc    %eax
  802f27:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802f2c:	e9 78 02 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 50 08             	mov    0x8(%eax),%edx
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3d:	01 c2                	add    %eax,%edx
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	8b 40 08             	mov    0x8(%eax),%eax
  802f45:	39 c2                	cmp    %eax,%edx
  802f47:	0f 83 b8 00 00 00    	jae    803005 <insert_sorted_with_merge_freeList+0x5a2>
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	8b 50 08             	mov    0x8(%eax),%edx
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	8b 40 0c             	mov    0xc(%eax),%eax
  802f59:	01 c2                	add    %eax,%edx
  802f5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f5e:	8b 40 08             	mov    0x8(%eax),%eax
  802f61:	39 c2                	cmp    %eax,%edx
  802f63:	0f 85 9c 00 00 00    	jne    803005 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802f69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f6c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	8b 40 0c             	mov    0xc(%eax),%eax
  802f75:	01 c2                	add    %eax,%edx
  802f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7a:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	8b 50 08             	mov    0x8(%eax),%edx
  802f83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f86:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa1:	75 17                	jne    802fba <insert_sorted_with_merge_freeList+0x557>
  802fa3:	83 ec 04             	sub    $0x4,%esp
  802fa6:	68 54 3c 80 00       	push   $0x803c54
  802fab:	68 67 01 00 00       	push   $0x167
  802fb0:	68 77 3c 80 00       	push   $0x803c77
  802fb5:	e8 f2 01 00 00       	call   8031ac <_panic>
  802fba:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	89 10                	mov    %edx,(%eax)
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	8b 00                	mov    (%eax),%eax
  802fca:	85 c0                	test   %eax,%eax
  802fcc:	74 0d                	je     802fdb <insert_sorted_with_merge_freeList+0x578>
  802fce:	a1 48 41 80 00       	mov    0x804148,%eax
  802fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd6:	89 50 04             	mov    %edx,0x4(%eax)
  802fd9:	eb 08                	jmp    802fe3 <insert_sorted_with_merge_freeList+0x580>
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	a3 48 41 80 00       	mov    %eax,0x804148
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff5:	a1 54 41 80 00       	mov    0x804154,%eax
  802ffa:	40                   	inc    %eax
  802ffb:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  803000:	e9 a4 01 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 50 08             	mov    0x8(%eax),%edx
  80300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300e:	8b 40 0c             	mov    0xc(%eax),%eax
  803011:	01 c2                	add    %eax,%edx
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	8b 40 08             	mov    0x8(%eax),%eax
  803019:	39 c2                	cmp    %eax,%edx
  80301b:	0f 85 ac 00 00 00    	jne    8030cd <insert_sorted_with_merge_freeList+0x66a>
  803021:	8b 45 08             	mov    0x8(%ebp),%eax
  803024:	8b 50 08             	mov    0x8(%eax),%edx
  803027:	8b 45 08             	mov    0x8(%ebp),%eax
  80302a:	8b 40 0c             	mov    0xc(%eax),%eax
  80302d:	01 c2                	add    %eax,%edx
  80302f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803032:	8b 40 08             	mov    0x8(%eax),%eax
  803035:	39 c2                	cmp    %eax,%edx
  803037:	0f 83 90 00 00 00    	jae    8030cd <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	8b 50 0c             	mov    0xc(%eax),%edx
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	8b 40 0c             	mov    0xc(%eax),%eax
  803049:	01 c2                	add    %eax,%edx
  80304b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304e:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  80305b:	8b 45 08             	mov    0x8(%ebp),%eax
  80305e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803065:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803069:	75 17                	jne    803082 <insert_sorted_with_merge_freeList+0x61f>
  80306b:	83 ec 04             	sub    $0x4,%esp
  80306e:	68 54 3c 80 00       	push   $0x803c54
  803073:	68 70 01 00 00       	push   $0x170
  803078:	68 77 3c 80 00       	push   $0x803c77
  80307d:	e8 2a 01 00 00       	call   8031ac <_panic>
  803082:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	89 10                	mov    %edx,(%eax)
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	8b 00                	mov    (%eax),%eax
  803092:	85 c0                	test   %eax,%eax
  803094:	74 0d                	je     8030a3 <insert_sorted_with_merge_freeList+0x640>
  803096:	a1 48 41 80 00       	mov    0x804148,%eax
  80309b:	8b 55 08             	mov    0x8(%ebp),%edx
  80309e:	89 50 04             	mov    %edx,0x4(%eax)
  8030a1:	eb 08                	jmp    8030ab <insert_sorted_with_merge_freeList+0x648>
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	a3 48 41 80 00       	mov    %eax,0x804148
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bd:	a1 54 41 80 00       	mov    0x804154,%eax
  8030c2:	40                   	inc    %eax
  8030c3:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  8030c8:	e9 dc 00 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8030cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d0:	8b 50 08             	mov    0x8(%eax),%edx
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d9:	01 c2                	add    %eax,%edx
  8030db:	8b 45 08             	mov    0x8(%ebp),%eax
  8030de:	8b 40 08             	mov    0x8(%eax),%eax
  8030e1:	39 c2                	cmp    %eax,%edx
  8030e3:	0f 83 88 00 00 00    	jae    803171 <insert_sorted_with_merge_freeList+0x70e>
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	8b 50 08             	mov    0x8(%eax),%edx
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f5:	01 c2                	add    %eax,%edx
  8030f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030fa:	8b 40 08             	mov    0x8(%eax),%eax
  8030fd:	39 c2                	cmp    %eax,%edx
  8030ff:	73 70                	jae    803171 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803101:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803105:	74 06                	je     80310d <insert_sorted_with_merge_freeList+0x6aa>
  803107:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310b:	75 17                	jne    803124 <insert_sorted_with_merge_freeList+0x6c1>
  80310d:	83 ec 04             	sub    $0x4,%esp
  803110:	68 b4 3c 80 00       	push   $0x803cb4
  803115:	68 75 01 00 00       	push   $0x175
  80311a:	68 77 3c 80 00       	push   $0x803c77
  80311f:	e8 88 00 00 00       	call   8031ac <_panic>
  803124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803127:	8b 10                	mov    (%eax),%edx
  803129:	8b 45 08             	mov    0x8(%ebp),%eax
  80312c:	89 10                	mov    %edx,(%eax)
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	8b 00                	mov    (%eax),%eax
  803133:	85 c0                	test   %eax,%eax
  803135:	74 0b                	je     803142 <insert_sorted_with_merge_freeList+0x6df>
  803137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313a:	8b 00                	mov    (%eax),%eax
  80313c:	8b 55 08             	mov    0x8(%ebp),%edx
  80313f:	89 50 04             	mov    %edx,0x4(%eax)
  803142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803145:	8b 55 08             	mov    0x8(%ebp),%edx
  803148:	89 10                	mov    %edx,(%eax)
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803150:	89 50 04             	mov    %edx,0x4(%eax)
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	8b 00                	mov    (%eax),%eax
  803158:	85 c0                	test   %eax,%eax
  80315a:	75 08                	jne    803164 <insert_sorted_with_merge_freeList+0x701>
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803164:	a1 44 41 80 00       	mov    0x804144,%eax
  803169:	40                   	inc    %eax
  80316a:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  80316f:	eb 38                	jmp    8031a9 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803171:	a1 40 41 80 00       	mov    0x804140,%eax
  803176:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803179:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80317d:	74 07                	je     803186 <insert_sorted_with_merge_freeList+0x723>
  80317f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803182:	8b 00                	mov    (%eax),%eax
  803184:	eb 05                	jmp    80318b <insert_sorted_with_merge_freeList+0x728>
  803186:	b8 00 00 00 00       	mov    $0x0,%eax
  80318b:	a3 40 41 80 00       	mov    %eax,0x804140
  803190:	a1 40 41 80 00       	mov    0x804140,%eax
  803195:	85 c0                	test   %eax,%eax
  803197:	0f 85 c3 fb ff ff    	jne    802d60 <insert_sorted_with_merge_freeList+0x2fd>
  80319d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a1:	0f 85 b9 fb ff ff    	jne    802d60 <insert_sorted_with_merge_freeList+0x2fd>





}
  8031a7:	eb 00                	jmp    8031a9 <insert_sorted_with_merge_freeList+0x746>
  8031a9:	90                   	nop
  8031aa:	c9                   	leave  
  8031ab:	c3                   	ret    

008031ac <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8031ac:	55                   	push   %ebp
  8031ad:	89 e5                	mov    %esp,%ebp
  8031af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8031b2:	8d 45 10             	lea    0x10(%ebp),%eax
  8031b5:	83 c0 04             	add    $0x4,%eax
  8031b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8031bb:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8031c0:	85 c0                	test   %eax,%eax
  8031c2:	74 16                	je     8031da <_panic+0x2e>
		cprintf("%s: ", argv0);
  8031c4:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8031c9:	83 ec 08             	sub    $0x8,%esp
  8031cc:	50                   	push   %eax
  8031cd:	68 38 3d 80 00       	push   $0x803d38
  8031d2:	e8 66 d5 ff ff       	call   80073d <cprintf>
  8031d7:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8031da:	a1 00 40 80 00       	mov    0x804000,%eax
  8031df:	ff 75 0c             	pushl  0xc(%ebp)
  8031e2:	ff 75 08             	pushl  0x8(%ebp)
  8031e5:	50                   	push   %eax
  8031e6:	68 3d 3d 80 00       	push   $0x803d3d
  8031eb:	e8 4d d5 ff ff       	call   80073d <cprintf>
  8031f0:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8031f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8031f6:	83 ec 08             	sub    $0x8,%esp
  8031f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8031fc:	50                   	push   %eax
  8031fd:	e8 d0 d4 ff ff       	call   8006d2 <vcprintf>
  803202:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803205:	83 ec 08             	sub    $0x8,%esp
  803208:	6a 00                	push   $0x0
  80320a:	68 59 3d 80 00       	push   $0x803d59
  80320f:	e8 be d4 ff ff       	call   8006d2 <vcprintf>
  803214:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803217:	e8 3f d4 ff ff       	call   80065b <exit>

	// should not return here
	while (1) ;
  80321c:	eb fe                	jmp    80321c <_panic+0x70>

0080321e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80321e:	55                   	push   %ebp
  80321f:	89 e5                	mov    %esp,%ebp
  803221:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803224:	a1 20 40 80 00       	mov    0x804020,%eax
  803229:	8b 50 74             	mov    0x74(%eax),%edx
  80322c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80322f:	39 c2                	cmp    %eax,%edx
  803231:	74 14                	je     803247 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803233:	83 ec 04             	sub    $0x4,%esp
  803236:	68 5c 3d 80 00       	push   $0x803d5c
  80323b:	6a 26                	push   $0x26
  80323d:	68 a8 3d 80 00       	push   $0x803da8
  803242:	e8 65 ff ff ff       	call   8031ac <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803247:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80324e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803255:	e9 c2 00 00 00       	jmp    80331c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80325a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	01 d0                	add    %edx,%eax
  803269:	8b 00                	mov    (%eax),%eax
  80326b:	85 c0                	test   %eax,%eax
  80326d:	75 08                	jne    803277 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80326f:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803272:	e9 a2 00 00 00       	jmp    803319 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803277:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80327e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803285:	eb 69                	jmp    8032f0 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803287:	a1 20 40 80 00       	mov    0x804020,%eax
  80328c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803292:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803295:	89 d0                	mov    %edx,%eax
  803297:	01 c0                	add    %eax,%eax
  803299:	01 d0                	add    %edx,%eax
  80329b:	c1 e0 03             	shl    $0x3,%eax
  80329e:	01 c8                	add    %ecx,%eax
  8032a0:	8a 40 04             	mov    0x4(%eax),%al
  8032a3:	84 c0                	test   %al,%al
  8032a5:	75 46                	jne    8032ed <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8032a7:	a1 20 40 80 00       	mov    0x804020,%eax
  8032ac:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8032b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032b5:	89 d0                	mov    %edx,%eax
  8032b7:	01 c0                	add    %eax,%eax
  8032b9:	01 d0                	add    %edx,%eax
  8032bb:	c1 e0 03             	shl    $0x3,%eax
  8032be:	01 c8                	add    %ecx,%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8032c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8032cd:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8032cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d2:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	01 c8                	add    %ecx,%eax
  8032de:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8032e0:	39 c2                	cmp    %eax,%edx
  8032e2:	75 09                	jne    8032ed <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8032e4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8032eb:	eb 12                	jmp    8032ff <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032ed:	ff 45 e8             	incl   -0x18(%ebp)
  8032f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8032f5:	8b 50 74             	mov    0x74(%eax),%edx
  8032f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fb:	39 c2                	cmp    %eax,%edx
  8032fd:	77 88                	ja     803287 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8032ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803303:	75 14                	jne    803319 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803305:	83 ec 04             	sub    $0x4,%esp
  803308:	68 b4 3d 80 00       	push   $0x803db4
  80330d:	6a 3a                	push   $0x3a
  80330f:	68 a8 3d 80 00       	push   $0x803da8
  803314:	e8 93 fe ff ff       	call   8031ac <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803319:	ff 45 f0             	incl   -0x10(%ebp)
  80331c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803322:	0f 8c 32 ff ff ff    	jl     80325a <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803328:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80332f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803336:	eb 26                	jmp    80335e <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803338:	a1 20 40 80 00       	mov    0x804020,%eax
  80333d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803343:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803346:	89 d0                	mov    %edx,%eax
  803348:	01 c0                	add    %eax,%eax
  80334a:	01 d0                	add    %edx,%eax
  80334c:	c1 e0 03             	shl    $0x3,%eax
  80334f:	01 c8                	add    %ecx,%eax
  803351:	8a 40 04             	mov    0x4(%eax),%al
  803354:	3c 01                	cmp    $0x1,%al
  803356:	75 03                	jne    80335b <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803358:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80335b:	ff 45 e0             	incl   -0x20(%ebp)
  80335e:	a1 20 40 80 00       	mov    0x804020,%eax
  803363:	8b 50 74             	mov    0x74(%eax),%edx
  803366:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803369:	39 c2                	cmp    %eax,%edx
  80336b:	77 cb                	ja     803338 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80336d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803370:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803373:	74 14                	je     803389 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803375:	83 ec 04             	sub    $0x4,%esp
  803378:	68 08 3e 80 00       	push   $0x803e08
  80337d:	6a 44                	push   $0x44
  80337f:	68 a8 3d 80 00       	push   $0x803da8
  803384:	e8 23 fe ff ff       	call   8031ac <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803389:	90                   	nop
  80338a:	c9                   	leave  
  80338b:	c3                   	ret    

0080338c <__udivdi3>:
  80338c:	55                   	push   %ebp
  80338d:	57                   	push   %edi
  80338e:	56                   	push   %esi
  80338f:	53                   	push   %ebx
  803390:	83 ec 1c             	sub    $0x1c,%esp
  803393:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803397:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80339b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80339f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033a3:	89 ca                	mov    %ecx,%edx
  8033a5:	89 f8                	mov    %edi,%eax
  8033a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033ab:	85 f6                	test   %esi,%esi
  8033ad:	75 2d                	jne    8033dc <__udivdi3+0x50>
  8033af:	39 cf                	cmp    %ecx,%edi
  8033b1:	77 65                	ja     803418 <__udivdi3+0x8c>
  8033b3:	89 fd                	mov    %edi,%ebp
  8033b5:	85 ff                	test   %edi,%edi
  8033b7:	75 0b                	jne    8033c4 <__udivdi3+0x38>
  8033b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8033be:	31 d2                	xor    %edx,%edx
  8033c0:	f7 f7                	div    %edi
  8033c2:	89 c5                	mov    %eax,%ebp
  8033c4:	31 d2                	xor    %edx,%edx
  8033c6:	89 c8                	mov    %ecx,%eax
  8033c8:	f7 f5                	div    %ebp
  8033ca:	89 c1                	mov    %eax,%ecx
  8033cc:	89 d8                	mov    %ebx,%eax
  8033ce:	f7 f5                	div    %ebp
  8033d0:	89 cf                	mov    %ecx,%edi
  8033d2:	89 fa                	mov    %edi,%edx
  8033d4:	83 c4 1c             	add    $0x1c,%esp
  8033d7:	5b                   	pop    %ebx
  8033d8:	5e                   	pop    %esi
  8033d9:	5f                   	pop    %edi
  8033da:	5d                   	pop    %ebp
  8033db:	c3                   	ret    
  8033dc:	39 ce                	cmp    %ecx,%esi
  8033de:	77 28                	ja     803408 <__udivdi3+0x7c>
  8033e0:	0f bd fe             	bsr    %esi,%edi
  8033e3:	83 f7 1f             	xor    $0x1f,%edi
  8033e6:	75 40                	jne    803428 <__udivdi3+0x9c>
  8033e8:	39 ce                	cmp    %ecx,%esi
  8033ea:	72 0a                	jb     8033f6 <__udivdi3+0x6a>
  8033ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033f0:	0f 87 9e 00 00 00    	ja     803494 <__udivdi3+0x108>
  8033f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8033fb:	89 fa                	mov    %edi,%edx
  8033fd:	83 c4 1c             	add    $0x1c,%esp
  803400:	5b                   	pop    %ebx
  803401:	5e                   	pop    %esi
  803402:	5f                   	pop    %edi
  803403:	5d                   	pop    %ebp
  803404:	c3                   	ret    
  803405:	8d 76 00             	lea    0x0(%esi),%esi
  803408:	31 ff                	xor    %edi,%edi
  80340a:	31 c0                	xor    %eax,%eax
  80340c:	89 fa                	mov    %edi,%edx
  80340e:	83 c4 1c             	add    $0x1c,%esp
  803411:	5b                   	pop    %ebx
  803412:	5e                   	pop    %esi
  803413:	5f                   	pop    %edi
  803414:	5d                   	pop    %ebp
  803415:	c3                   	ret    
  803416:	66 90                	xchg   %ax,%ax
  803418:	89 d8                	mov    %ebx,%eax
  80341a:	f7 f7                	div    %edi
  80341c:	31 ff                	xor    %edi,%edi
  80341e:	89 fa                	mov    %edi,%edx
  803420:	83 c4 1c             	add    $0x1c,%esp
  803423:	5b                   	pop    %ebx
  803424:	5e                   	pop    %esi
  803425:	5f                   	pop    %edi
  803426:	5d                   	pop    %ebp
  803427:	c3                   	ret    
  803428:	bd 20 00 00 00       	mov    $0x20,%ebp
  80342d:	89 eb                	mov    %ebp,%ebx
  80342f:	29 fb                	sub    %edi,%ebx
  803431:	89 f9                	mov    %edi,%ecx
  803433:	d3 e6                	shl    %cl,%esi
  803435:	89 c5                	mov    %eax,%ebp
  803437:	88 d9                	mov    %bl,%cl
  803439:	d3 ed                	shr    %cl,%ebp
  80343b:	89 e9                	mov    %ebp,%ecx
  80343d:	09 f1                	or     %esi,%ecx
  80343f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803443:	89 f9                	mov    %edi,%ecx
  803445:	d3 e0                	shl    %cl,%eax
  803447:	89 c5                	mov    %eax,%ebp
  803449:	89 d6                	mov    %edx,%esi
  80344b:	88 d9                	mov    %bl,%cl
  80344d:	d3 ee                	shr    %cl,%esi
  80344f:	89 f9                	mov    %edi,%ecx
  803451:	d3 e2                	shl    %cl,%edx
  803453:	8b 44 24 08          	mov    0x8(%esp),%eax
  803457:	88 d9                	mov    %bl,%cl
  803459:	d3 e8                	shr    %cl,%eax
  80345b:	09 c2                	or     %eax,%edx
  80345d:	89 d0                	mov    %edx,%eax
  80345f:	89 f2                	mov    %esi,%edx
  803461:	f7 74 24 0c          	divl   0xc(%esp)
  803465:	89 d6                	mov    %edx,%esi
  803467:	89 c3                	mov    %eax,%ebx
  803469:	f7 e5                	mul    %ebp
  80346b:	39 d6                	cmp    %edx,%esi
  80346d:	72 19                	jb     803488 <__udivdi3+0xfc>
  80346f:	74 0b                	je     80347c <__udivdi3+0xf0>
  803471:	89 d8                	mov    %ebx,%eax
  803473:	31 ff                	xor    %edi,%edi
  803475:	e9 58 ff ff ff       	jmp    8033d2 <__udivdi3+0x46>
  80347a:	66 90                	xchg   %ax,%ax
  80347c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803480:	89 f9                	mov    %edi,%ecx
  803482:	d3 e2                	shl    %cl,%edx
  803484:	39 c2                	cmp    %eax,%edx
  803486:	73 e9                	jae    803471 <__udivdi3+0xe5>
  803488:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80348b:	31 ff                	xor    %edi,%edi
  80348d:	e9 40 ff ff ff       	jmp    8033d2 <__udivdi3+0x46>
  803492:	66 90                	xchg   %ax,%ax
  803494:	31 c0                	xor    %eax,%eax
  803496:	e9 37 ff ff ff       	jmp    8033d2 <__udivdi3+0x46>
  80349b:	90                   	nop

0080349c <__umoddi3>:
  80349c:	55                   	push   %ebp
  80349d:	57                   	push   %edi
  80349e:	56                   	push   %esi
  80349f:	53                   	push   %ebx
  8034a0:	83 ec 1c             	sub    $0x1c,%esp
  8034a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034bb:	89 f3                	mov    %esi,%ebx
  8034bd:	89 fa                	mov    %edi,%edx
  8034bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034c3:	89 34 24             	mov    %esi,(%esp)
  8034c6:	85 c0                	test   %eax,%eax
  8034c8:	75 1a                	jne    8034e4 <__umoddi3+0x48>
  8034ca:	39 f7                	cmp    %esi,%edi
  8034cc:	0f 86 a2 00 00 00    	jbe    803574 <__umoddi3+0xd8>
  8034d2:	89 c8                	mov    %ecx,%eax
  8034d4:	89 f2                	mov    %esi,%edx
  8034d6:	f7 f7                	div    %edi
  8034d8:	89 d0                	mov    %edx,%eax
  8034da:	31 d2                	xor    %edx,%edx
  8034dc:	83 c4 1c             	add    $0x1c,%esp
  8034df:	5b                   	pop    %ebx
  8034e0:	5e                   	pop    %esi
  8034e1:	5f                   	pop    %edi
  8034e2:	5d                   	pop    %ebp
  8034e3:	c3                   	ret    
  8034e4:	39 f0                	cmp    %esi,%eax
  8034e6:	0f 87 ac 00 00 00    	ja     803598 <__umoddi3+0xfc>
  8034ec:	0f bd e8             	bsr    %eax,%ebp
  8034ef:	83 f5 1f             	xor    $0x1f,%ebp
  8034f2:	0f 84 ac 00 00 00    	je     8035a4 <__umoddi3+0x108>
  8034f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8034fd:	29 ef                	sub    %ebp,%edi
  8034ff:	89 fe                	mov    %edi,%esi
  803501:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803505:	89 e9                	mov    %ebp,%ecx
  803507:	d3 e0                	shl    %cl,%eax
  803509:	89 d7                	mov    %edx,%edi
  80350b:	89 f1                	mov    %esi,%ecx
  80350d:	d3 ef                	shr    %cl,%edi
  80350f:	09 c7                	or     %eax,%edi
  803511:	89 e9                	mov    %ebp,%ecx
  803513:	d3 e2                	shl    %cl,%edx
  803515:	89 14 24             	mov    %edx,(%esp)
  803518:	89 d8                	mov    %ebx,%eax
  80351a:	d3 e0                	shl    %cl,%eax
  80351c:	89 c2                	mov    %eax,%edx
  80351e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803522:	d3 e0                	shl    %cl,%eax
  803524:	89 44 24 04          	mov    %eax,0x4(%esp)
  803528:	8b 44 24 08          	mov    0x8(%esp),%eax
  80352c:	89 f1                	mov    %esi,%ecx
  80352e:	d3 e8                	shr    %cl,%eax
  803530:	09 d0                	or     %edx,%eax
  803532:	d3 eb                	shr    %cl,%ebx
  803534:	89 da                	mov    %ebx,%edx
  803536:	f7 f7                	div    %edi
  803538:	89 d3                	mov    %edx,%ebx
  80353a:	f7 24 24             	mull   (%esp)
  80353d:	89 c6                	mov    %eax,%esi
  80353f:	89 d1                	mov    %edx,%ecx
  803541:	39 d3                	cmp    %edx,%ebx
  803543:	0f 82 87 00 00 00    	jb     8035d0 <__umoddi3+0x134>
  803549:	0f 84 91 00 00 00    	je     8035e0 <__umoddi3+0x144>
  80354f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803553:	29 f2                	sub    %esi,%edx
  803555:	19 cb                	sbb    %ecx,%ebx
  803557:	89 d8                	mov    %ebx,%eax
  803559:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80355d:	d3 e0                	shl    %cl,%eax
  80355f:	89 e9                	mov    %ebp,%ecx
  803561:	d3 ea                	shr    %cl,%edx
  803563:	09 d0                	or     %edx,%eax
  803565:	89 e9                	mov    %ebp,%ecx
  803567:	d3 eb                	shr    %cl,%ebx
  803569:	89 da                	mov    %ebx,%edx
  80356b:	83 c4 1c             	add    $0x1c,%esp
  80356e:	5b                   	pop    %ebx
  80356f:	5e                   	pop    %esi
  803570:	5f                   	pop    %edi
  803571:	5d                   	pop    %ebp
  803572:	c3                   	ret    
  803573:	90                   	nop
  803574:	89 fd                	mov    %edi,%ebp
  803576:	85 ff                	test   %edi,%edi
  803578:	75 0b                	jne    803585 <__umoddi3+0xe9>
  80357a:	b8 01 00 00 00       	mov    $0x1,%eax
  80357f:	31 d2                	xor    %edx,%edx
  803581:	f7 f7                	div    %edi
  803583:	89 c5                	mov    %eax,%ebp
  803585:	89 f0                	mov    %esi,%eax
  803587:	31 d2                	xor    %edx,%edx
  803589:	f7 f5                	div    %ebp
  80358b:	89 c8                	mov    %ecx,%eax
  80358d:	f7 f5                	div    %ebp
  80358f:	89 d0                	mov    %edx,%eax
  803591:	e9 44 ff ff ff       	jmp    8034da <__umoddi3+0x3e>
  803596:	66 90                	xchg   %ax,%ax
  803598:	89 c8                	mov    %ecx,%eax
  80359a:	89 f2                	mov    %esi,%edx
  80359c:	83 c4 1c             	add    $0x1c,%esp
  80359f:	5b                   	pop    %ebx
  8035a0:	5e                   	pop    %esi
  8035a1:	5f                   	pop    %edi
  8035a2:	5d                   	pop    %ebp
  8035a3:	c3                   	ret    
  8035a4:	3b 04 24             	cmp    (%esp),%eax
  8035a7:	72 06                	jb     8035af <__umoddi3+0x113>
  8035a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035ad:	77 0f                	ja     8035be <__umoddi3+0x122>
  8035af:	89 f2                	mov    %esi,%edx
  8035b1:	29 f9                	sub    %edi,%ecx
  8035b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035b7:	89 14 24             	mov    %edx,(%esp)
  8035ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035c2:	8b 14 24             	mov    (%esp),%edx
  8035c5:	83 c4 1c             	add    $0x1c,%esp
  8035c8:	5b                   	pop    %ebx
  8035c9:	5e                   	pop    %esi
  8035ca:	5f                   	pop    %edi
  8035cb:	5d                   	pop    %ebp
  8035cc:	c3                   	ret    
  8035cd:	8d 76 00             	lea    0x0(%esi),%esi
  8035d0:	2b 04 24             	sub    (%esp),%eax
  8035d3:	19 fa                	sbb    %edi,%edx
  8035d5:	89 d1                	mov    %edx,%ecx
  8035d7:	89 c6                	mov    %eax,%esi
  8035d9:	e9 71 ff ff ff       	jmp    80354f <__umoddi3+0xb3>
  8035de:	66 90                	xchg   %ax,%ax
  8035e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035e4:	72 ea                	jb     8035d0 <__umoddi3+0x134>
  8035e6:	89 d9                	mov    %ebx,%ecx
  8035e8:	e9 62 ff ff ff       	jmp    80354f <__umoddi3+0xb3>
