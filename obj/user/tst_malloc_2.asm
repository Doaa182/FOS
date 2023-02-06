
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 80 03 00 00       	call   8003b6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	81 ec 94 00 00 00    	sub    $0x94,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 40 80 00       	mov    0x804020,%eax
  800054:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 40 80 00       	mov    0x804020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 80 34 80 00       	push   $0x803480
  800095:	6a 1a                	push   $0x1a
  800097:	68 9c 34 80 00       	push   $0x80349c
  80009c:	e8 51 04 00 00       	call   8004f2 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 74 16 00 00       	call   80171f <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ae:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	char minByte = 1<<7;
  8000bc:	c6 45 e7 80          	movb   $0x80,-0x19(%ebp)
	char maxByte = 0x7F;
  8000c0:	c6 45 e6 7f          	movb   $0x7f,-0x1a(%ebp)
	short minShort = 1<<15 ;
  8000c4:	66 c7 45 e4 00 80    	movw   $0x8000,-0x1c(%ebp)
	short maxShort = 0x7FFF;
  8000ca:	66 c7 45 e2 ff 7f    	movw   $0x7fff,-0x1e(%ebp)
	int minInt = 1<<31 ;
  8000d0:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d7:	c7 45 d8 ff ff ff 7f 	movl   $0x7fffffff,-0x28(%ebp)

	void* ptr_allocations[20] = {0};
  8000de:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  8000e4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ee:	89 d7                	mov    %edx,%edi
  8000f0:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f5:	01 c0                	add    %eax,%eax
  8000f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 1c 16 00 00       	call   80171f <malloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  80010c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800112:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800115:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800118:	01 c0                	add    %eax,%eax
  80011a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011d:	48                   	dec    %eax
  80011e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = minByte ;
  800121:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800124:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800127:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800129:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80012c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012f:	01 c2                	add    %eax,%edx
  800131:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800134:	88 02                	mov    %al,(%edx)

		ptr_allocations[1] = malloc(2*Mega-kilo);
  800136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800139:	01 c0                	add    %eax,%eax
  80013b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	50                   	push   %eax
  800142:	e8 d8 15 00 00       	call   80171f <malloc>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800150:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800156:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80015c:	01 c0                	add    %eax,%eax
  80015e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800161:	d1 e8                	shr    %eax
  800163:	48                   	dec    %eax
  800164:	89 45 c8             	mov    %eax,-0x38(%ebp)
		shortArr[0] = minShort;
  800167:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80016a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016d:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800170:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800173:	01 c0                	add    %eax,%eax
  800175:	89 c2                	mov    %eax,%edx
  800177:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80017a:	01 c2                	add    %eax,%edx
  80017c:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  800180:	66 89 02             	mov    %ax,(%edx)

		ptr_allocations[2] = malloc(3*kilo);
  800183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800186:	89 c2                	mov    %eax,%edx
  800188:	01 d2                	add    %edx,%edx
  80018a:	01 d0                	add    %edx,%eax
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	50                   	push   %eax
  800190:	e8 8a 15 00 00       	call   80171f <malloc>
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  80019e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8001a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8001a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	c1 e8 02             	shr    $0x2,%eax
  8001af:	48                   	dec    %eax
  8001b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr[0] = minInt;
  8001b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001b9:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8001bb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001c8:	01 c2                	add    %eax,%edx
  8001ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001cd:	89 02                	mov    %eax,(%edx)

		ptr_allocations[3] = malloc(7*kilo);
  8001cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001d2:	89 d0                	mov    %edx,%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	01 d0                	add    %edx,%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	01 d0                	add    %edx,%eax
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	50                   	push   %eax
  8001e0:	e8 3a 15 00 00       	call   80171f <malloc>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8001ee:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8001f4:	89 45 bc             	mov    %eax,-0x44(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8001f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001fa:	89 d0                	mov    %edx,%eax
  8001fc:	01 c0                	add    %eax,%eax
  8001fe:	01 d0                	add    %edx,%eax
  800200:	01 c0                	add    %eax,%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	c1 e8 03             	shr    $0x3,%eax
  800207:	48                   	dec    %eax
  800208:	89 45 b8             	mov    %eax,-0x48(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80020b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80020e:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800211:	88 10                	mov    %dl,(%eax)
  800213:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800219:	66 89 42 02          	mov    %ax,0x2(%edx)
  80021d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800220:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800223:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800226:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800229:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800230:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800233:	01 c2                	add    %eax,%edx
  800235:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800238:	88 02                	mov    %al,(%edx)
  80023a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800244:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800247:	01 c2                	add    %eax,%edx
  800249:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  80024d:	66 89 42 02          	mov    %ax,0x2(%edx)
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80025b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80025e:	01 c2                	add    %eax,%edx
  800260:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800263:	89 42 04             	mov    %eax,0x4(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800266:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800269:	8a 00                	mov    (%eax),%al
  80026b:	3a 45 e7             	cmp    -0x19(%ebp),%al
  80026e:	75 0f                	jne    80027f <_main+0x247>
  800270:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800273:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	8a 00                	mov    (%eax),%al
  80027a:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80027d:	74 14                	je     800293 <_main+0x25b>
  80027f:	83 ec 04             	sub    $0x4,%esp
  800282:	68 b0 34 80 00       	push   $0x8034b0
  800287:	6a 45                	push   $0x45
  800289:	68 9c 34 80 00       	push   $0x80349c
  80028e:	e8 5f 02 00 00       	call   8004f2 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800293:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800296:	66 8b 00             	mov    (%eax),%ax
  800299:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80029d:	75 15                	jne    8002b4 <_main+0x27c>
  80029f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002a2:	01 c0                	add    %eax,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	66 8b 00             	mov    (%eax),%ax
  8002ae:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  8002b2:	74 14                	je     8002c8 <_main+0x290>
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	68 b0 34 80 00       	push   $0x8034b0
  8002bc:	6a 46                	push   $0x46
  8002be:	68 9c 34 80 00       	push   $0x80349c
  8002c3:	e8 2a 02 00 00       	call   8004f2 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8002c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002cb:	8b 00                	mov    (%eax),%eax
  8002cd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d0:	75 16                	jne    8002e8 <_main+0x2b0>
  8002d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002df:	01 d0                	add    %edx,%eax
  8002e1:	8b 00                	mov    (%eax),%eax
  8002e3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 b0 34 80 00       	push   $0x8034b0
  8002f0:	6a 47                	push   $0x47
  8002f2:	68 9c 34 80 00       	push   $0x80349c
  8002f7:	e8 f6 01 00 00       	call   8004f2 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002fc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002ff:	8a 00                	mov    (%eax),%al
  800301:	3a 45 e7             	cmp    -0x19(%ebp),%al
  800304:	75 16                	jne    80031c <_main+0x2e4>
  800306:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800309:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800310:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	8a 00                	mov    (%eax),%al
  800317:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80031a:	74 14                	je     800330 <_main+0x2f8>
  80031c:	83 ec 04             	sub    $0x4,%esp
  80031f:	68 b0 34 80 00       	push   $0x8034b0
  800324:	6a 49                	push   $0x49
  800326:	68 9c 34 80 00       	push   $0x80349c
  80032b:	e8 c2 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  800330:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800333:	66 8b 40 02          	mov    0x2(%eax),%ax
  800337:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80033b:	75 19                	jne    800356 <_main+0x31e>
  80033d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800340:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800347:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034a:	01 d0                	add    %edx,%eax
  80034c:	66 8b 40 02          	mov    0x2(%eax),%ax
  800350:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  800354:	74 14                	je     80036a <_main+0x332>
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	68 b0 34 80 00       	push   $0x8034b0
  80035e:	6a 4a                	push   $0x4a
  800360:	68 9c 34 80 00       	push   $0x80349c
  800365:	e8 88 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  80036a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80036d:	8b 40 04             	mov    0x4(%eax),%eax
  800370:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800373:	75 17                	jne    80038c <_main+0x354>
  800375:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800378:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80037f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800382:	01 d0                	add    %edx,%eax
  800384:	8b 40 04             	mov    0x4(%eax),%eax
  800387:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80038a:	74 14                	je     8003a0 <_main+0x368>
  80038c:	83 ec 04             	sub    $0x4,%esp
  80038f:	68 b0 34 80 00       	push   $0x8034b0
  800394:	6a 4b                	push   $0x4b
  800396:	68 9c 34 80 00       	push   $0x80349c
  80039b:	e8 52 01 00 00       	call   8004f2 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 e8 34 80 00       	push   $0x8034e8
  8003a8:	e8 f9 03 00 00       	call   8007a6 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp

	return;
  8003b0:	90                   	nop
}
  8003b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003b4:	c9                   	leave  
  8003b5:	c3                   	ret    

008003b6 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003bc:	e8 7d 1a 00 00       	call   801e3e <sys_getenvindex>
  8003c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c7:	89 d0                	mov    %edx,%eax
  8003c9:	c1 e0 03             	shl    $0x3,%eax
  8003cc:	01 d0                	add    %edx,%eax
  8003ce:	01 c0                	add    %eax,%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d9:	01 d0                	add    %edx,%eax
  8003db:	c1 e0 04             	shl    $0x4,%eax
  8003de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003e3:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003e8:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ed:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003f3:	84 c0                	test   %al,%al
  8003f5:	74 0f                	je     800406 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fc:	05 5c 05 00 00       	add    $0x55c,%eax
  800401:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800406:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80040a:	7e 0a                	jle    800416 <libmain+0x60>
		binaryname = argv[0];
  80040c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	ff 75 0c             	pushl  0xc(%ebp)
  80041c:	ff 75 08             	pushl  0x8(%ebp)
  80041f:	e8 14 fc ff ff       	call   800038 <_main>
  800424:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800427:	e8 1f 18 00 00       	call   801c4b <sys_disable_interrupt>
	cprintf("**************************************\n");
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	68 3c 35 80 00       	push   $0x80353c
  800434:	e8 6d 03 00 00       	call   8007a6 <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80043c:	a1 20 40 80 00       	mov    0x804020,%eax
  800441:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800447:	a1 20 40 80 00       	mov    0x804020,%eax
  80044c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	52                   	push   %edx
  800456:	50                   	push   %eax
  800457:	68 64 35 80 00       	push   $0x803564
  80045c:	e8 45 03 00 00       	call   8007a6 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800464:	a1 20 40 80 00       	mov    0x804020,%eax
  800469:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80046f:	a1 20 40 80 00       	mov    0x804020,%eax
  800474:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80047a:	a1 20 40 80 00       	mov    0x804020,%eax
  80047f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800485:	51                   	push   %ecx
  800486:	52                   	push   %edx
  800487:	50                   	push   %eax
  800488:	68 8c 35 80 00       	push   $0x80358c
  80048d:	e8 14 03 00 00       	call   8007a6 <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800495:	a1 20 40 80 00       	mov    0x804020,%eax
  80049a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 e4 35 80 00       	push   $0x8035e4
  8004a9:	e8 f8 02 00 00       	call   8007a6 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	68 3c 35 80 00       	push   $0x80353c
  8004b9:	e8 e8 02 00 00       	call   8007a6 <cprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004c1:	e8 9f 17 00 00       	call   801c65 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004c6:	e8 19 00 00 00       	call   8004e4 <exit>
}
  8004cb:	90                   	nop
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004d4:	83 ec 0c             	sub    $0xc,%esp
  8004d7:	6a 00                	push   $0x0
  8004d9:	e8 2c 19 00 00       	call   801e0a <sys_destroy_env>
  8004de:	83 c4 10             	add    $0x10,%esp
}
  8004e1:	90                   	nop
  8004e2:	c9                   	leave  
  8004e3:	c3                   	ret    

008004e4 <exit>:

void
exit(void)
{
  8004e4:	55                   	push   %ebp
  8004e5:	89 e5                	mov    %esp,%ebp
  8004e7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ea:	e8 81 19 00 00       	call   801e70 <sys_exit_env>
}
  8004ef:	90                   	nop
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8004fb:	83 c0 04             	add    $0x4,%eax
  8004fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800501:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800506:	85 c0                	test   %eax,%eax
  800508:	74 16                	je     800520 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80050a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	50                   	push   %eax
  800513:	68 f8 35 80 00       	push   $0x8035f8
  800518:	e8 89 02 00 00       	call   8007a6 <cprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800520:	a1 00 40 80 00       	mov    0x804000,%eax
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	50                   	push   %eax
  80052c:	68 fd 35 80 00       	push   $0x8035fd
  800531:	e8 70 02 00 00       	call   8007a6 <cprintf>
  800536:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800539:	8b 45 10             	mov    0x10(%ebp),%eax
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	ff 75 f4             	pushl  -0xc(%ebp)
  800542:	50                   	push   %eax
  800543:	e8 f3 01 00 00       	call   80073b <vcprintf>
  800548:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	6a 00                	push   $0x0
  800550:	68 19 36 80 00       	push   $0x803619
  800555:	e8 e1 01 00 00       	call   80073b <vcprintf>
  80055a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80055d:	e8 82 ff ff ff       	call   8004e4 <exit>

	// should not return here
	while (1) ;
  800562:	eb fe                	jmp    800562 <_panic+0x70>

00800564 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80056a:	a1 20 40 80 00       	mov    0x804020,%eax
  80056f:	8b 50 74             	mov    0x74(%eax),%edx
  800572:	8b 45 0c             	mov    0xc(%ebp),%eax
  800575:	39 c2                	cmp    %eax,%edx
  800577:	74 14                	je     80058d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800579:	83 ec 04             	sub    $0x4,%esp
  80057c:	68 1c 36 80 00       	push   $0x80361c
  800581:	6a 26                	push   $0x26
  800583:	68 68 36 80 00       	push   $0x803668
  800588:	e8 65 ff ff ff       	call   8004f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80058d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800594:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80059b:	e9 c2 00 00 00       	jmp    800662 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	85 c0                	test   %eax,%eax
  8005b3:	75 08                	jne    8005bd <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005b5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005b8:	e9 a2 00 00 00       	jmp    80065f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005cb:	eb 69                	jmp    800636 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005db:	89 d0                	mov    %edx,%eax
  8005dd:	01 c0                	add    %eax,%eax
  8005df:	01 d0                	add    %edx,%eax
  8005e1:	c1 e0 03             	shl    $0x3,%eax
  8005e4:	01 c8                	add    %ecx,%eax
  8005e6:	8a 40 04             	mov    0x4(%eax),%al
  8005e9:	84 c0                	test   %al,%al
  8005eb:	75 46                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	01 c0                	add    %eax,%eax
  8005ff:	01 d0                	add    %edx,%eax
  800601:	c1 e0 03             	shl    $0x3,%eax
  800604:	01 c8                	add    %ecx,%eax
  800606:	8b 00                	mov    (%eax),%eax
  800608:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80060b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800613:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800618:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	01 c8                	add    %ecx,%eax
  800624:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800626:	39 c2                	cmp    %eax,%edx
  800628:	75 09                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80062a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800631:	eb 12                	jmp    800645 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800633:	ff 45 e8             	incl   -0x18(%ebp)
  800636:	a1 20 40 80 00       	mov    0x804020,%eax
  80063b:	8b 50 74             	mov    0x74(%eax),%edx
  80063e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800641:	39 c2                	cmp    %eax,%edx
  800643:	77 88                	ja     8005cd <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800645:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800649:	75 14                	jne    80065f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80064b:	83 ec 04             	sub    $0x4,%esp
  80064e:	68 74 36 80 00       	push   $0x803674
  800653:	6a 3a                	push   $0x3a
  800655:	68 68 36 80 00       	push   $0x803668
  80065a:	e8 93 fe ff ff       	call   8004f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80065f:	ff 45 f0             	incl   -0x10(%ebp)
  800662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800665:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800668:	0f 8c 32 ff ff ff    	jl     8005a0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80066e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800675:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80067c:	eb 26                	jmp    8006a4 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80067e:	a1 20 40 80 00       	mov    0x804020,%eax
  800683:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800689:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068c:	89 d0                	mov    %edx,%eax
  80068e:	01 c0                	add    %eax,%eax
  800690:	01 d0                	add    %edx,%eax
  800692:	c1 e0 03             	shl    $0x3,%eax
  800695:	01 c8                	add    %ecx,%eax
  800697:	8a 40 04             	mov    0x4(%eax),%al
  80069a:	3c 01                	cmp    $0x1,%al
  80069c:	75 03                	jne    8006a1 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80069e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a1:	ff 45 e0             	incl   -0x20(%ebp)
  8006a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8006a9:	8b 50 74             	mov    0x74(%eax),%edx
  8006ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006af:	39 c2                	cmp    %eax,%edx
  8006b1:	77 cb                	ja     80067e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006b9:	74 14                	je     8006cf <CheckWSWithoutLastIndex+0x16b>
		panic(
  8006bb:	83 ec 04             	sub    $0x4,%esp
  8006be:	68 c8 36 80 00       	push   $0x8036c8
  8006c3:	6a 44                	push   $0x44
  8006c5:	68 68 36 80 00       	push   $0x803668
  8006ca:	e8 23 fe ff ff       	call   8004f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8006e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e3:	89 0a                	mov    %ecx,(%edx)
  8006e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8006e8:	88 d1                	mov    %dl,%cl
  8006ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ed:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006fb:	75 2c                	jne    800729 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006fd:	a0 24 40 80 00       	mov    0x804024,%al
  800702:	0f b6 c0             	movzbl %al,%eax
  800705:	8b 55 0c             	mov    0xc(%ebp),%edx
  800708:	8b 12                	mov    (%edx),%edx
  80070a:	89 d1                	mov    %edx,%ecx
  80070c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80070f:	83 c2 08             	add    $0x8,%edx
  800712:	83 ec 04             	sub    $0x4,%esp
  800715:	50                   	push   %eax
  800716:	51                   	push   %ecx
  800717:	52                   	push   %edx
  800718:	e8 80 13 00 00       	call   801a9d <sys_cputs>
  80071d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800720:	8b 45 0c             	mov    0xc(%ebp),%eax
  800723:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072c:	8b 40 04             	mov    0x4(%eax),%eax
  80072f:	8d 50 01             	lea    0x1(%eax),%edx
  800732:	8b 45 0c             	mov    0xc(%ebp),%eax
  800735:	89 50 04             	mov    %edx,0x4(%eax)
}
  800738:	90                   	nop
  800739:	c9                   	leave  
  80073a:	c3                   	ret    

0080073b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800744:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80074b:	00 00 00 
	b.cnt = 0;
  80074e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800755:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	ff 75 08             	pushl  0x8(%ebp)
  80075e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800764:	50                   	push   %eax
  800765:	68 d2 06 80 00       	push   $0x8006d2
  80076a:	e8 11 02 00 00       	call   800980 <vprintfmt>
  80076f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800772:	a0 24 40 80 00       	mov    0x804024,%al
  800777:	0f b6 c0             	movzbl %al,%eax
  80077a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800780:	83 ec 04             	sub    $0x4,%esp
  800783:	50                   	push   %eax
  800784:	52                   	push   %edx
  800785:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80078b:	83 c0 08             	add    $0x8,%eax
  80078e:	50                   	push   %eax
  80078f:	e8 09 13 00 00       	call   801a9d <sys_cputs>
  800794:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800797:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80079e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007ac:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8007b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	e8 73 ff ff ff       	call   80073b <vcprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007d9:	e8 6d 14 00 00       	call   801c4b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ed:	50                   	push   %eax
  8007ee:	e8 48 ff ff ff       	call   80073b <vcprintf>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007f9:	e8 67 14 00 00       	call   801c65 <sys_enable_interrupt>
	return cnt;
  8007fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	53                   	push   %ebx
  800807:	83 ec 14             	sub    $0x14,%esp
  80080a:	8b 45 10             	mov    0x10(%ebp),%eax
  80080d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800816:	8b 45 18             	mov    0x18(%ebp),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800821:	77 55                	ja     800878 <printnum+0x75>
  800823:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800826:	72 05                	jb     80082d <printnum+0x2a>
  800828:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80082b:	77 4b                	ja     800878 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80082d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800830:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800833:	8b 45 18             	mov    0x18(%ebp),%eax
  800836:	ba 00 00 00 00       	mov    $0x0,%edx
  80083b:	52                   	push   %edx
  80083c:	50                   	push   %eax
  80083d:	ff 75 f4             	pushl  -0xc(%ebp)
  800840:	ff 75 f0             	pushl  -0x10(%ebp)
  800843:	e8 d0 29 00 00       	call   803218 <__udivdi3>
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	ff 75 20             	pushl  0x20(%ebp)
  800851:	53                   	push   %ebx
  800852:	ff 75 18             	pushl  0x18(%ebp)
  800855:	52                   	push   %edx
  800856:	50                   	push   %eax
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	e8 a1 ff ff ff       	call   800803 <printnum>
  800862:	83 c4 20             	add    $0x20,%esp
  800865:	eb 1a                	jmp    800881 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 20             	pushl  0x20(%ebp)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800878:	ff 4d 1c             	decl   0x1c(%ebp)
  80087b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087f:	7f e6                	jg     800867 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800881:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800884:	bb 00 00 00 00       	mov    $0x0,%ebx
  800889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088f:	53                   	push   %ebx
  800890:	51                   	push   %ecx
  800891:	52                   	push   %edx
  800892:	50                   	push   %eax
  800893:	e8 90 2a 00 00       	call   803328 <__umoddi3>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	05 34 39 80 00       	add    $0x803934,%eax
  8008a0:	8a 00                	mov    (%eax),%al
  8008a2:	0f be c0             	movsbl %al,%eax
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
}
  8008b4:	90                   	nop
  8008b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c1:	7e 1c                	jle    8008df <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 08             	lea    0x8(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 08             	sub    $0x8,%eax
  8008d8:	8b 50 04             	mov    0x4(%eax),%edx
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	eb 40                	jmp    80091f <getuint+0x65>
	else if (lflag)
  8008df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e3:	74 1e                	je     800903 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800901:	eb 1c                	jmp    80091f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	8d 50 04             	lea    0x4(%eax),%edx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	89 10                	mov    %edx,(%eax)
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	83 e8 04             	sub    $0x4,%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800924:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800928:	7e 1c                	jle    800946 <getint+0x25>
		return va_arg(*ap, long long);
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	8d 50 08             	lea    0x8(%eax),%edx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	89 10                	mov    %edx,(%eax)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	83 e8 08             	sub    $0x8,%eax
  80093f:	8b 50 04             	mov    0x4(%eax),%edx
  800942:	8b 00                	mov    (%eax),%eax
  800944:	eb 38                	jmp    80097e <getint+0x5d>
	else if (lflag)
  800946:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094a:	74 1a                	je     800966 <getint+0x45>
		return va_arg(*ap, long);
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 10                	mov    %edx,(%eax)
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	83 e8 04             	sub    $0x4,%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	99                   	cltd   
  800964:	eb 18                	jmp    80097e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 50 04             	lea    0x4(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 10                	mov    %edx,(%eax)
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	83 e8 04             	sub    $0x4,%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	99                   	cltd   
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800988:	eb 17                	jmp    8009a1 <vprintfmt+0x21>
			if (ch == '\0')
  80098a:	85 db                	test   %ebx,%ebx
  80098c:	0f 84 af 03 00 00    	je     800d41 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	53                   	push   %ebx
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	ff d0                	call   *%eax
  80099e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a4:	8d 50 01             	lea    0x1(%eax),%edx
  8009a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009aa:	8a 00                	mov    (%eax),%al
  8009ac:	0f b6 d8             	movzbl %al,%ebx
  8009af:	83 fb 25             	cmp    $0x25,%ebx
  8009b2:	75 d6                	jne    80098a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d7:	8d 50 01             	lea    0x1(%eax),%edx
  8009da:	89 55 10             	mov    %edx,0x10(%ebp)
  8009dd:	8a 00                	mov    (%eax),%al
  8009df:	0f b6 d8             	movzbl %al,%ebx
  8009e2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e5:	83 f8 55             	cmp    $0x55,%eax
  8009e8:	0f 87 2b 03 00 00    	ja     800d19 <vprintfmt+0x399>
  8009ee:	8b 04 85 58 39 80 00 	mov    0x803958(,%eax,4),%eax
  8009f5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009fb:	eb d7                	jmp    8009d4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009fd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a01:	eb d1                	jmp    8009d4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	c1 e0 02             	shl    $0x2,%eax
  800a12:	01 d0                	add    %edx,%eax
  800a14:	01 c0                	add    %eax,%eax
  800a16:	01 d8                	add    %ebx,%eax
  800a18:	83 e8 30             	sub    $0x30,%eax
  800a1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	8a 00                	mov    (%eax),%al
  800a23:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a26:	83 fb 2f             	cmp    $0x2f,%ebx
  800a29:	7e 3e                	jle    800a69 <vprintfmt+0xe9>
  800a2b:	83 fb 39             	cmp    $0x39,%ebx
  800a2e:	7f 39                	jg     800a69 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a30:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a33:	eb d5                	jmp    800a0a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a49:	eb 1f                	jmp    800a6a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4f:	79 83                	jns    8009d4 <vprintfmt+0x54>
				width = 0;
  800a51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a58:	e9 77 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a5d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a64:	e9 6b ff ff ff       	jmp    8009d4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a69:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6e:	0f 89 60 ff ff ff    	jns    8009d4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a81:	e9 4e ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a86:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a89:	e9 46 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 c0 04             	add    $0x4,%eax
  800a94:	89 45 14             	mov    %eax,0x14(%ebp)
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 e8 04             	sub    $0x4,%eax
  800a9d:	8b 00                	mov    (%eax),%eax
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	50                   	push   %eax
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 89 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	79 02                	jns    800aca <vprintfmt+0x14a>
				err = -err;
  800ac8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aca:	83 fb 64             	cmp    $0x64,%ebx
  800acd:	7f 0b                	jg     800ada <vprintfmt+0x15a>
  800acf:	8b 34 9d a0 37 80 00 	mov    0x8037a0(,%ebx,4),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 19                	jne    800af3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ada:	53                   	push   %ebx
  800adb:	68 45 39 80 00       	push   $0x803945
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 5e 02 00 00       	call   800d49 <printfmt>
  800aeb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aee:	e9 49 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af3:	56                   	push   %esi
  800af4:	68 4e 39 80 00       	push   $0x80394e
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	ff 75 08             	pushl  0x8(%ebp)
  800aff:	e8 45 02 00 00       	call   800d49 <printfmt>
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 30 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0f:	83 c0 04             	add    $0x4,%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 e8 04             	sub    $0x4,%eax
  800b1b:	8b 30                	mov    (%eax),%esi
  800b1d:	85 f6                	test   %esi,%esi
  800b1f:	75 05                	jne    800b26 <vprintfmt+0x1a6>
				p = "(null)";
  800b21:	be 51 39 80 00       	mov    $0x803951,%esi
			if (width > 0 && padc != '-')
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7e 6d                	jle    800b99 <vprintfmt+0x219>
  800b2c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b30:	74 67                	je     800b99 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	50                   	push   %eax
  800b39:	56                   	push   %esi
  800b3a:	e8 0c 03 00 00       	call   800e4b <strnlen>
  800b3f:	83 c4 10             	add    $0x10,%esp
  800b42:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b45:	eb 16                	jmp    800b5d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b47:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	50                   	push   %eax
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b61:	7f e4                	jg     800b47 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b63:	eb 34                	jmp    800b99 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b69:	74 1c                	je     800b87 <vprintfmt+0x207>
  800b6b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6e:	7e 05                	jle    800b75 <vprintfmt+0x1f5>
  800b70:	83 fb 7e             	cmp    $0x7e,%ebx
  800b73:	7e 12                	jle    800b87 <vprintfmt+0x207>
					putch('?', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 3f                	push   $0x3f
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
  800b85:	eb 0f                	jmp    800b96 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b96:	ff 4d e4             	decl   -0x1c(%ebp)
  800b99:	89 f0                	mov    %esi,%eax
  800b9b:	8d 70 01             	lea    0x1(%eax),%esi
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f be d8             	movsbl %al,%ebx
  800ba3:	85 db                	test   %ebx,%ebx
  800ba5:	74 24                	je     800bcb <vprintfmt+0x24b>
  800ba7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bab:	78 b8                	js     800b65 <vprintfmt+0x1e5>
  800bad:	ff 4d e0             	decl   -0x20(%ebp)
  800bb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb4:	79 af                	jns    800b65 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb6:	eb 13                	jmp    800bcb <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	6a 20                	push   $0x20
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcf:	7f e7                	jg     800bb8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd1:	e9 66 01 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdf:	50                   	push   %eax
  800be0:	e8 3c fd ff ff       	call   800921 <getint>
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800beb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf4:	85 d2                	test   %edx,%edx
  800bf6:	79 23                	jns    800c1b <vprintfmt+0x29b>
				putch('-', putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	6a 2d                	push   $0x2d
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0e:	f7 d8                	neg    %eax
  800c10:	83 d2 00             	adc    $0x0,%edx
  800c13:	f7 da                	neg    %edx
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c30:	50                   	push   %eax
  800c31:	e8 84 fc ff ff       	call   8008ba <getuint>
  800c36:	83 c4 10             	add    $0x10,%esp
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c46:	e9 98 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	6a 58                	push   $0x58
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	ff d0                	call   *%eax
  800c58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 58                	push   $0x58
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 58                	push   $0x58
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
			break;
  800c7b:	e9 bc 00 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	6a 30                	push   $0x30
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	ff d0                	call   *%eax
  800c8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	6a 78                	push   $0x78
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 e8 04             	sub    $0x4,%eax
  800caf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cbb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc2:	eb 1f                	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cca:	8d 45 14             	lea    0x14(%ebp),%eax
  800ccd:	50                   	push   %eax
  800cce:	e8 e7 fb ff ff       	call   8008ba <getuint>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cdc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cea:	83 ec 04             	sub    $0x4,%esp
  800ced:	52                   	push   %edx
  800cee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf1:	50                   	push   %eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	ff 75 08             	pushl  0x8(%ebp)
  800cfe:	e8 00 fb ff ff       	call   800803 <printnum>
  800d03:	83 c4 20             	add    $0x20,%esp
			break;
  800d06:	eb 34                	jmp    800d3c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	53                   	push   %ebx
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	ff d0                	call   *%eax
  800d14:	83 c4 10             	add    $0x10,%esp
			break;
  800d17:	eb 23                	jmp    800d3c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	6a 25                	push   $0x25
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	ff d0                	call   *%eax
  800d26:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d29:	ff 4d 10             	decl   0x10(%ebp)
  800d2c:	eb 03                	jmp    800d31 <vprintfmt+0x3b1>
  800d2e:	ff 4d 10             	decl   0x10(%ebp)
  800d31:	8b 45 10             	mov    0x10(%ebp),%eax
  800d34:	48                   	dec    %eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	3c 25                	cmp    $0x25,%al
  800d39:	75 f3                	jne    800d2e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d3b:	90                   	nop
		}
	}
  800d3c:	e9 47 fc ff ff       	jmp    800988 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d41:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d52:	83 c0 04             	add    $0x4,%eax
  800d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5e:	50                   	push   %eax
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	ff 75 08             	pushl  0x8(%ebp)
  800d65:	e8 16 fc ff ff       	call   800980 <vprintfmt>
  800d6a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d6d:	90                   	nop
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	8b 40 08             	mov    0x8(%eax),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	8b 10                	mov    (%eax),%edx
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8b 40 04             	mov    0x4(%eax),%eax
  800d8d:	39 c2                	cmp    %eax,%edx
  800d8f:	73 12                	jae    800da3 <sprintputch+0x33>
		*b->buf++ = ch;
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	8d 48 01             	lea    0x1(%eax),%ecx
  800d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9c:	89 0a                	mov    %ecx,(%edx)
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	88 10                	mov    %dl,(%eax)
}
  800da3:	90                   	nop
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	01 d0                	add    %edx,%eax
  800dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dcb:	74 06                	je     800dd3 <vsnprintf+0x2d>
  800dcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd1:	7f 07                	jg     800dda <vsnprintf+0x34>
		return -E_INVAL;
  800dd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd8:	eb 20                	jmp    800dfa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dda:	ff 75 14             	pushl  0x14(%ebp)
  800ddd:	ff 75 10             	pushl  0x10(%ebp)
  800de0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de3:	50                   	push   %eax
  800de4:	68 70 0d 80 00       	push   $0x800d70
  800de9:	e8 92 fb ff ff       	call   800980 <vprintfmt>
  800dee:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e02:	8d 45 10             	lea    0x10(%ebp),%eax
  800e05:	83 c0 04             	add    $0x4,%eax
  800e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e11:	50                   	push   %eax
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	ff 75 08             	pushl  0x8(%ebp)
  800e18:	e8 89 ff ff ff       	call   800da6 <vsnprintf>
  800e1d:	83 c4 10             	add    $0x10,%esp
  800e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e35:	eb 06                	jmp    800e3d <strlen+0x15>
		n++;
  800e37:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3a:	ff 45 08             	incl   0x8(%ebp)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	84 c0                	test   %al,%al
  800e44:	75 f1                	jne    800e37 <strlen+0xf>
		n++;
	return n;
  800e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e58:	eb 09                	jmp    800e63 <strnlen+0x18>
		n++;
  800e5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5d:	ff 45 08             	incl   0x8(%ebp)
  800e60:	ff 4d 0c             	decl   0xc(%ebp)
  800e63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e67:	74 09                	je     800e72 <strnlen+0x27>
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 e8                	jne    800e5a <strnlen+0xf>
		n++;
	return n;
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e83:	90                   	nop
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e93:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e96:	8a 12                	mov    (%edx),%dl
  800e98:	88 10                	mov    %dl,(%eax)
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	84 c0                	test   %al,%al
  800e9e:	75 e4                	jne    800e84 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb8:	eb 1f                	jmp    800ed9 <strncpy+0x34>
		*dst++ = *src;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8d 50 01             	lea    0x1(%eax),%edx
  800ec0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec6:	8a 12                	mov    (%edx),%dl
  800ec8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	84 c0                	test   %al,%al
  800ed1:	74 03                	je     800ed6 <strncpy+0x31>
			src++;
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed6:	ff 45 fc             	incl   -0x4(%ebp)
  800ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800edf:	72 d9                	jb     800eba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	74 30                	je     800f28 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef8:	eb 16                	jmp    800f10 <strlcpy+0x2a>
			*dst++ = *src++;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8d 50 01             	lea    0x1(%eax),%edx
  800f00:	89 55 08             	mov    %edx,0x8(%ebp)
  800f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f09:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f0c:	8a 12                	mov    (%edx),%dl
  800f0e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f10:	ff 4d 10             	decl   0x10(%ebp)
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 09                	je     800f22 <strlcpy+0x3c>
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	84 c0                	test   %al,%al
  800f20:	75 d8                	jne    800efa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2e:	29 c2                	sub    %eax,%edx
  800f30:	89 d0                	mov    %edx,%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f37:	eb 06                	jmp    800f3f <strcmp+0xb>
		p++, q++;
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	84 c0                	test   %al,%al
  800f46:	74 0e                	je     800f56 <strcmp+0x22>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 10                	mov    (%eax),%dl
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	38 c2                	cmp    %al,%dl
  800f54:	74 e3                	je     800f39 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f b6 d0             	movzbl %al,%edx
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 c0             	movzbl %al,%eax
  800f66:	29 c2                	sub    %eax,%edx
  800f68:	89 d0                	mov    %edx,%eax
}
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f6f:	eb 09                	jmp    800f7a <strncmp+0xe>
		n--, p++, q++;
  800f71:	ff 4d 10             	decl   0x10(%ebp)
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	74 17                	je     800f97 <strncmp+0x2b>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	84 c0                	test   %al,%al
  800f87:	74 0e                	je     800f97 <strncmp+0x2b>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 10                	mov    (%eax),%dl
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	38 c2                	cmp    %al,%dl
  800f95:	74 da                	je     800f71 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	75 07                	jne    800fa4 <strncmp+0x38>
		return 0;
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa2:	eb 14                	jmp    800fb8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 d0             	movzbl %al,%edx
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	29 c2                	sub    %eax,%edx
  800fb6:	89 d0                	mov    %edx,%eax
}
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 04             	sub    $0x4,%esp
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc6:	eb 12                	jmp    800fda <strchr+0x20>
		if (*s == c)
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd0:	75 05                	jne    800fd7 <strchr+0x1d>
			return (char *) s;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	eb 11                	jmp    800fe8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fd7:	ff 45 08             	incl   0x8(%ebp)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	84 c0                	test   %al,%al
  800fe1:	75 e5                	jne    800fc8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 04             	sub    $0x4,%esp
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff6:	eb 0d                	jmp    801005 <strfind+0x1b>
		if (*s == c)
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801000:	74 0e                	je     801010 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801002:	ff 45 08             	incl   0x8(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	84 c0                	test   %al,%al
  80100c:	75 ea                	jne    800ff8 <strfind+0xe>
  80100e:	eb 01                	jmp    801011 <strfind+0x27>
		if (*s == c)
			break;
  801010:	90                   	nop
	return (char *) s;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801028:	eb 0e                	jmp    801038 <memset+0x22>
		*p++ = c;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8d 50 01             	lea    0x1(%eax),%edx
  801030:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801033:	8b 55 0c             	mov    0xc(%ebp),%edx
  801036:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801038:	ff 4d f8             	decl   -0x8(%ebp)
  80103b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80103f:	79 e9                	jns    80102a <memset+0x14>
		*p++ = c;

	return v;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801058:	eb 16                	jmp    801070 <memcpy+0x2a>
		*d++ = *s++;
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	8d 50 01             	lea    0x1(%eax),%edx
  801060:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801063:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801066:	8d 4a 01             	lea    0x1(%edx),%ecx
  801069:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80106c:	8a 12                	mov    (%edx),%dl
  80106e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	8d 50 ff             	lea    -0x1(%eax),%edx
  801076:	89 55 10             	mov    %edx,0x10(%ebp)
  801079:	85 c0                	test   %eax,%eax
  80107b:	75 dd                	jne    80105a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80109a:	73 50                	jae    8010ec <memmove+0x6a>
  80109c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109f:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a2:	01 d0                	add    %edx,%eax
  8010a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010a7:	76 43                	jbe    8010ec <memmove+0x6a>
		s += n;
  8010a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ac:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b5:	eb 10                	jmp    8010c7 <memmove+0x45>
			*--d = *--s;
  8010b7:	ff 4d f8             	decl   -0x8(%ebp)
  8010ba:	ff 4d fc             	decl   -0x4(%ebp)
  8010bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c0:	8a 10                	mov    (%eax),%dl
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	75 e3                	jne    8010b7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010d4:	eb 23                	jmp    8010f9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d9:	8d 50 01             	lea    0x1(%eax),%edx
  8010dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010e8:	8a 12                	mov    (%edx),%dl
  8010ea:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	75 dd                	jne    8010d6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    

008010fe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801110:	eb 2a                	jmp    80113c <memcmp+0x3e>
		if (*s1 != *s2)
  801112:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801115:	8a 10                	mov    (%eax),%dl
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	38 c2                	cmp    %al,%dl
  80111e:	74 16                	je     801136 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	0f b6 d0             	movzbl %al,%edx
  801128:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	0f b6 c0             	movzbl %al,%eax
  801130:	29 c2                	sub    %eax,%edx
  801132:	89 d0                	mov    %edx,%eax
  801134:	eb 18                	jmp    80114e <memcmp+0x50>
		s1++, s2++;
  801136:	ff 45 fc             	incl   -0x4(%ebp)
  801139:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80113c:	8b 45 10             	mov    0x10(%ebp),%eax
  80113f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801142:	89 55 10             	mov    %edx,0x10(%ebp)
  801145:	85 c0                	test   %eax,%eax
  801147:	75 c9                	jne    801112 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801149:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801156:	8b 55 08             	mov    0x8(%ebp),%edx
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801161:	eb 15                	jmp    801178 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	0f b6 d0             	movzbl %al,%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	0f b6 c0             	movzbl %al,%eax
  801171:	39 c2                	cmp    %eax,%edx
  801173:	74 0d                	je     801182 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801175:	ff 45 08             	incl   0x8(%ebp)
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80117e:	72 e3                	jb     801163 <memfind+0x13>
  801180:	eb 01                	jmp    801183 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801182:	90                   	nop
	return (void *) s;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80118e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801195:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80119c:	eb 03                	jmp    8011a1 <strtol+0x19>
		s++;
  80119e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3c 20                	cmp    $0x20,%al
  8011a8:	74 f4                	je     80119e <strtol+0x16>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	3c 09                	cmp    $0x9,%al
  8011b1:	74 eb                	je     80119e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 2b                	cmp    $0x2b,%al
  8011ba:	75 05                	jne    8011c1 <strtol+0x39>
		s++;
  8011bc:	ff 45 08             	incl   0x8(%ebp)
  8011bf:	eb 13                	jmp    8011d4 <strtol+0x4c>
	else if (*s == '-')
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 2d                	cmp    $0x2d,%al
  8011c8:	75 0a                	jne    8011d4 <strtol+0x4c>
		s++, neg = 1;
  8011ca:	ff 45 08             	incl   0x8(%ebp)
  8011cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d8:	74 06                	je     8011e0 <strtol+0x58>
  8011da:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011de:	75 20                	jne    801200 <strtol+0x78>
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 30                	cmp    $0x30,%al
  8011e7:	75 17                	jne    801200 <strtol+0x78>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	40                   	inc    %eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 78                	cmp    $0x78,%al
  8011f1:	75 0d                	jne    801200 <strtol+0x78>
		s += 2, base = 16;
  8011f3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011f7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011fe:	eb 28                	jmp    801228 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801200:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801204:	75 15                	jne    80121b <strtol+0x93>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 30                	cmp    $0x30,%al
  80120d:	75 0c                	jne    80121b <strtol+0x93>
		s++, base = 8;
  80120f:	ff 45 08             	incl   0x8(%ebp)
  801212:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801219:	eb 0d                	jmp    801228 <strtol+0xa0>
	else if (base == 0)
  80121b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121f:	75 07                	jne    801228 <strtol+0xa0>
		base = 10;
  801221:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 2f                	cmp    $0x2f,%al
  80122f:	7e 19                	jle    80124a <strtol+0xc2>
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 39                	cmp    $0x39,%al
  801238:	7f 10                	jg     80124a <strtol+0xc2>
			dig = *s - '0';
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	0f be c0             	movsbl %al,%eax
  801242:	83 e8 30             	sub    $0x30,%eax
  801245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801248:	eb 42                	jmp    80128c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	3c 60                	cmp    $0x60,%al
  801251:	7e 19                	jle    80126c <strtol+0xe4>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	3c 7a                	cmp    $0x7a,%al
  80125a:	7f 10                	jg     80126c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	0f be c0             	movsbl %al,%eax
  801264:	83 e8 57             	sub    $0x57,%eax
  801267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80126a:	eb 20                	jmp    80128c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 40                	cmp    $0x40,%al
  801273:	7e 39                	jle    8012ae <strtol+0x126>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 5a                	cmp    $0x5a,%al
  80127c:	7f 30                	jg     8012ae <strtol+0x126>
			dig = *s - 'A' + 10;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	0f be c0             	movsbl %al,%eax
  801286:	83 e8 37             	sub    $0x37,%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801292:	7d 19                	jge    8012ad <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801294:	ff 45 08             	incl   0x8(%ebp)
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80129e:	89 c2                	mov    %eax,%edx
  8012a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a3:	01 d0                	add    %edx,%eax
  8012a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012a8:	e9 7b ff ff ff       	jmp    801228 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012ad:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b2:	74 08                	je     8012bc <strtol+0x134>
		*endptr = (char *) s;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ba:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c0:	74 07                	je     8012c9 <strtol+0x141>
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	f7 d8                	neg    %eax
  8012c7:	eb 03                	jmp    8012cc <strtol+0x144>
  8012c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <ltostr>:

void
ltostr(long value, char *str)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e6:	79 13                	jns    8012fb <ltostr+0x2d>
	{
		neg = 1;
  8012e8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012f5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012f8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801303:	99                   	cltd   
  801304:	f7 f9                	idiv   %ecx
  801306:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801309:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130c:	8d 50 01             	lea    0x1(%eax),%edx
  80130f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801312:	89 c2                	mov    %eax,%edx
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
  801317:	01 d0                	add    %edx,%eax
  801319:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80131c:	83 c2 30             	add    $0x30,%edx
  80131f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801321:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801324:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801329:	f7 e9                	imul   %ecx
  80132b:	c1 fa 02             	sar    $0x2,%edx
  80132e:	89 c8                	mov    %ecx,%eax
  801330:	c1 f8 1f             	sar    $0x1f,%eax
  801333:	29 c2                	sub    %eax,%edx
  801335:	89 d0                	mov    %edx,%eax
  801337:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80133a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80133d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801342:	f7 e9                	imul   %ecx
  801344:	c1 fa 02             	sar    $0x2,%edx
  801347:	89 c8                	mov    %ecx,%eax
  801349:	c1 f8 1f             	sar    $0x1f,%eax
  80134c:	29 c2                	sub    %eax,%edx
  80134e:	89 d0                	mov    %edx,%eax
  801350:	c1 e0 02             	shl    $0x2,%eax
  801353:	01 d0                	add    %edx,%eax
  801355:	01 c0                	add    %eax,%eax
  801357:	29 c1                	sub    %eax,%ecx
  801359:	89 ca                	mov    %ecx,%edx
  80135b:	85 d2                	test   %edx,%edx
  80135d:	75 9c                	jne    8012fb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80135f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801366:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801369:	48                   	dec    %eax
  80136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80136d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801371:	74 3d                	je     8013b0 <ltostr+0xe2>
		start = 1 ;
  801373:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80137a:	eb 34                	jmp    8013b0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	01 d0                	add    %edx,%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	01 c2                	add    %eax,%edx
  801391:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	01 c8                	add    %ecx,%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80139d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	01 c2                	add    %eax,%edx
  8013a5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013a8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013aa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013ad:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b6:	7c c4                	jl     80137c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	01 d0                	add    %edx,%eax
  8013c0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013c3:	90                   	nop
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013cc:	ff 75 08             	pushl  0x8(%ebp)
  8013cf:	e8 54 fa ff ff       	call   800e28 <strlen>
  8013d4:	83 c4 04             	add    $0x4,%esp
  8013d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 46 fa ff ff       	call   800e28 <strlen>
  8013e2:	83 c4 04             	add    $0x4,%esp
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f6:	eb 17                	jmp    80140f <strcconcat+0x49>
		final[s] = str1[s] ;
  8013f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80140c:	ff 45 fc             	incl   -0x4(%ebp)
  80140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801412:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801415:	7c e1                	jl     8013f8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801417:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80141e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801425:	eb 1f                	jmp    801446 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	8d 50 01             	lea    0x1(%eax),%edx
  80142d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801430:	89 c2                	mov    %eax,%edx
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
  801435:	01 c2                	add    %eax,%edx
  801437:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c8                	add    %ecx,%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801443:	ff 45 f8             	incl   -0x8(%ebp)
  801446:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144c:	7c d9                	jl     801427 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80144e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801451:	8b 45 10             	mov    0x10(%ebp),%eax
  801454:	01 d0                	add    %edx,%eax
  801456:	c6 00 00             	movb   $0x0,(%eax)
}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	01 d0                	add    %edx,%eax
  801479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80147f:	eb 0c                	jmp    80148d <strsplit+0x31>
			*string++ = 0;
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8d 50 01             	lea    0x1(%eax),%edx
  801487:	89 55 08             	mov    %edx,0x8(%ebp)
  80148a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 18                	je     8014ae <strsplit+0x52>
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	0f be c0             	movsbl %al,%eax
  80149e:	50                   	push   %eax
  80149f:	ff 75 0c             	pushl  0xc(%ebp)
  8014a2:	e8 13 fb ff ff       	call   800fba <strchr>
  8014a7:	83 c4 08             	add    $0x8,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	75 d3                	jne    801481 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	84 c0                	test   %al,%al
  8014b5:	74 5a                	je     801511 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	83 f8 0f             	cmp    $0xf,%eax
  8014bf:	75 07                	jne    8014c8 <strsplit+0x6c>
		{
			return 0;
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c6:	eb 66                	jmp    80152e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cb:	8b 00                	mov    (%eax),%eax
  8014cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8014d3:	89 0a                	mov    %ecx,(%edx)
  8014d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014df:	01 c2                	add    %eax,%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e6:	eb 03                	jmp    8014eb <strsplit+0x8f>
			string++;
  8014e8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	84 c0                	test   %al,%al
  8014f2:	74 8b                	je     80147f <strsplit+0x23>
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	0f be c0             	movsbl %al,%eax
  8014fc:	50                   	push   %eax
  8014fd:	ff 75 0c             	pushl  0xc(%ebp)
  801500:	e8 b5 fa ff ff       	call   800fba <strchr>
  801505:	83 c4 08             	add    $0x8,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	74 dc                	je     8014e8 <strsplit+0x8c>
			string++;
	}
  80150c:	e9 6e ff ff ff       	jmp    80147f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801511:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801512:	8b 45 14             	mov    0x14(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151e:	8b 45 10             	mov    0x10(%ebp),%eax
  801521:	01 d0                	add    %edx,%eax
  801523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801529:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801536:	a1 04 40 80 00       	mov    0x804004,%eax
  80153b:	85 c0                	test   %eax,%eax
  80153d:	74 1f                	je     80155e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80153f:	e8 1d 00 00 00       	call   801561 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	68 b0 3a 80 00       	push   $0x803ab0
  80154c:	e8 55 f2 ff ff       	call   8007a6 <cprintf>
  801551:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801554:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80155b:	00 00 00 
	}
}
  80155e:	90                   	nop
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801567:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80156e:	00 00 00 
  801571:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801578:	00 00 00 
  80157b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801582:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801585:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80158c:	00 00 00 
  80158f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801596:	00 00 00 
  801599:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8015a0:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  8015a3:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8015aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015b2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015b7:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8015bc:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8015c3:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8015c6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d0:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8015d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015db:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e0:	f7 75 f0             	divl   -0x10(%ebp)
  8015e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e6:	29 d0                	sub    %edx,%eax
  8015e8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8015eb:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8015f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015fa:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015ff:	83 ec 04             	sub    $0x4,%esp
  801602:	6a 06                	push   $0x6
  801604:	ff 75 e8             	pushl  -0x18(%ebp)
  801607:	50                   	push   %eax
  801608:	e8 d4 05 00 00       	call   801be1 <sys_allocate_chunk>
  80160d:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801610:	a1 20 41 80 00       	mov    0x804120,%eax
  801615:	83 ec 0c             	sub    $0xc,%esp
  801618:	50                   	push   %eax
  801619:	e8 49 0c 00 00       	call   802267 <initialize_MemBlocksList>
  80161e:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801621:	a1 48 41 80 00       	mov    0x804148,%eax
  801626:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801629:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80162d:	75 14                	jne    801643 <initialize_dyn_block_system+0xe2>
  80162f:	83 ec 04             	sub    $0x4,%esp
  801632:	68 d5 3a 80 00       	push   $0x803ad5
  801637:	6a 39                	push   $0x39
  801639:	68 f3 3a 80 00       	push   $0x803af3
  80163e:	e8 af ee ff ff       	call   8004f2 <_panic>
  801643:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801646:	8b 00                	mov    (%eax),%eax
  801648:	85 c0                	test   %eax,%eax
  80164a:	74 10                	je     80165c <initialize_dyn_block_system+0xfb>
  80164c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164f:	8b 00                	mov    (%eax),%eax
  801651:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801654:	8b 52 04             	mov    0x4(%edx),%edx
  801657:	89 50 04             	mov    %edx,0x4(%eax)
  80165a:	eb 0b                	jmp    801667 <initialize_dyn_block_system+0x106>
  80165c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80165f:	8b 40 04             	mov    0x4(%eax),%eax
  801662:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801667:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80166a:	8b 40 04             	mov    0x4(%eax),%eax
  80166d:	85 c0                	test   %eax,%eax
  80166f:	74 0f                	je     801680 <initialize_dyn_block_system+0x11f>
  801671:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801674:	8b 40 04             	mov    0x4(%eax),%eax
  801677:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80167a:	8b 12                	mov    (%edx),%edx
  80167c:	89 10                	mov    %edx,(%eax)
  80167e:	eb 0a                	jmp    80168a <initialize_dyn_block_system+0x129>
  801680:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801683:	8b 00                	mov    (%eax),%eax
  801685:	a3 48 41 80 00       	mov    %eax,0x804148
  80168a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80168d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801693:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801696:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80169d:	a1 54 41 80 00       	mov    0x804154,%eax
  8016a2:	48                   	dec    %eax
  8016a3:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  8016a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ab:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  8016b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b5:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  8016bc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016c0:	75 14                	jne    8016d6 <initialize_dyn_block_system+0x175>
  8016c2:	83 ec 04             	sub    $0x4,%esp
  8016c5:	68 00 3b 80 00       	push   $0x803b00
  8016ca:	6a 3f                	push   $0x3f
  8016cc:	68 f3 3a 80 00       	push   $0x803af3
  8016d1:	e8 1c ee ff ff       	call   8004f2 <_panic>
  8016d6:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8016dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016df:	89 10                	mov    %edx,(%eax)
  8016e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e4:	8b 00                	mov    (%eax),%eax
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	74 0d                	je     8016f7 <initialize_dyn_block_system+0x196>
  8016ea:	a1 38 41 80 00       	mov    0x804138,%eax
  8016ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016f2:	89 50 04             	mov    %edx,0x4(%eax)
  8016f5:	eb 08                	jmp    8016ff <initialize_dyn_block_system+0x19e>
  8016f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016fa:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8016ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801702:	a3 38 41 80 00       	mov    %eax,0x804138
  801707:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80170a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801711:	a1 44 41 80 00       	mov    0x804144,%eax
  801716:	40                   	inc    %eax
  801717:	a3 44 41 80 00       	mov    %eax,0x804144

}
  80171c:	90                   	nop
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801725:	e8 06 fe ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  80172a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80172e:	75 07                	jne    801737 <malloc+0x18>
  801730:	b8 00 00 00 00       	mov    $0x0,%eax
  801735:	eb 7d                	jmp    8017b4 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801737:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80173e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801745:	8b 55 08             	mov    0x8(%ebp),%edx
  801748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174b:	01 d0                	add    %edx,%eax
  80174d:	48                   	dec    %eax
  80174e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801751:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801754:	ba 00 00 00 00       	mov    $0x0,%edx
  801759:	f7 75 f0             	divl   -0x10(%ebp)
  80175c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175f:	29 d0                	sub    %edx,%eax
  801761:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801764:	e8 46 08 00 00       	call   801faf <sys_isUHeapPlacementStrategyFIRSTFIT>
  801769:	83 f8 01             	cmp    $0x1,%eax
  80176c:	75 07                	jne    801775 <malloc+0x56>
  80176e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801775:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801779:	75 34                	jne    8017af <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  80177b:	83 ec 0c             	sub    $0xc,%esp
  80177e:	ff 75 e8             	pushl  -0x18(%ebp)
  801781:	e8 73 0e 00 00       	call   8025f9 <alloc_block_FF>
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  80178c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801790:	74 16                	je     8017a8 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801792:	83 ec 0c             	sub    $0xc,%esp
  801795:	ff 75 e4             	pushl  -0x1c(%ebp)
  801798:	e8 ff 0b 00 00       	call   80239c <insert_sorted_allocList>
  80179d:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  8017a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a3:	8b 40 08             	mov    0x8(%eax),%eax
  8017a6:	eb 0c                	jmp    8017b4 <malloc+0x95>
	             }
	             else
	             	return NULL;
  8017a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ad:	eb 05                	jmp    8017b4 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  8017af:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  8017c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017d0:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  8017d3:	83 ec 08             	sub    $0x8,%esp
  8017d6:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d9:	68 40 40 80 00       	push   $0x804040
  8017de:	e8 61 0b 00 00       	call   802344 <find_block>
  8017e3:	83 c4 10             	add    $0x10,%esp
  8017e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8017e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017ed:	0f 84 a5 00 00 00    	je     801898 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8017f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f9:	83 ec 08             	sub    $0x8,%esp
  8017fc:	50                   	push   %eax
  8017fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801800:	e8 a4 03 00 00       	call   801ba9 <sys_free_user_mem>
  801805:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801808:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80180c:	75 17                	jne    801825 <free+0x6f>
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	68 d5 3a 80 00       	push   $0x803ad5
  801816:	68 87 00 00 00       	push   $0x87
  80181b:	68 f3 3a 80 00       	push   $0x803af3
  801820:	e8 cd ec ff ff       	call   8004f2 <_panic>
  801825:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801828:	8b 00                	mov    (%eax),%eax
  80182a:	85 c0                	test   %eax,%eax
  80182c:	74 10                	je     80183e <free+0x88>
  80182e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801831:	8b 00                	mov    (%eax),%eax
  801833:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801836:	8b 52 04             	mov    0x4(%edx),%edx
  801839:	89 50 04             	mov    %edx,0x4(%eax)
  80183c:	eb 0b                	jmp    801849 <free+0x93>
  80183e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801841:	8b 40 04             	mov    0x4(%eax),%eax
  801844:	a3 44 40 80 00       	mov    %eax,0x804044
  801849:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184c:	8b 40 04             	mov    0x4(%eax),%eax
  80184f:	85 c0                	test   %eax,%eax
  801851:	74 0f                	je     801862 <free+0xac>
  801853:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801856:	8b 40 04             	mov    0x4(%eax),%eax
  801859:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80185c:	8b 12                	mov    (%edx),%edx
  80185e:	89 10                	mov    %edx,(%eax)
  801860:	eb 0a                	jmp    80186c <free+0xb6>
  801862:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801865:	8b 00                	mov    (%eax),%eax
  801867:	a3 40 40 80 00       	mov    %eax,0x804040
  80186c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80186f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801875:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801878:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80187f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801884:	48                   	dec    %eax
  801885:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  80188a:	83 ec 0c             	sub    $0xc,%esp
  80188d:	ff 75 ec             	pushl  -0x14(%ebp)
  801890:	e8 37 12 00 00       	call   802acc <insert_sorted_with_merge_freeList>
  801895:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801898:	90                   	nop
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	83 ec 38             	sub    $0x38,%esp
  8018a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a4:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018a7:	e8 84 fc ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  8018ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018b0:	75 07                	jne    8018b9 <smalloc+0x1e>
  8018b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b7:	eb 7e                	jmp    801937 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  8018b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8018c0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cd:	01 d0                	add    %edx,%eax
  8018cf:	48                   	dec    %eax
  8018d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018db:	f7 75 f0             	divl   -0x10(%ebp)
  8018de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e1:	29 d0                	sub    %edx,%eax
  8018e3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8018e6:	e8 c4 06 00 00       	call   801faf <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018eb:	83 f8 01             	cmp    $0x1,%eax
  8018ee:	75 42                	jne    801932 <smalloc+0x97>

		  va = malloc(newsize) ;
  8018f0:	83 ec 0c             	sub    $0xc,%esp
  8018f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8018f6:	e8 24 fe ff ff       	call   80171f <malloc>
  8018fb:	83 c4 10             	add    $0x10,%esp
  8018fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801901:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801905:	74 24                	je     80192b <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801907:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80190b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80190e:	50                   	push   %eax
  80190f:	ff 75 e8             	pushl  -0x18(%ebp)
  801912:	ff 75 08             	pushl  0x8(%ebp)
  801915:	e8 1a 04 00 00       	call   801d34 <sys_createSharedObject>
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801920:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801924:	78 0c                	js     801932 <smalloc+0x97>
					  return va ;
  801926:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801929:	eb 0c                	jmp    801937 <smalloc+0x9c>
				 }
				 else
					return NULL;
  80192b:	b8 00 00 00 00       	mov    $0x0,%eax
  801930:	eb 05                	jmp    801937 <smalloc+0x9c>
	  }
		  return NULL ;
  801932:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80193f:	e8 ec fb ff ff       	call   801530 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801944:	83 ec 08             	sub    $0x8,%esp
  801947:	ff 75 0c             	pushl  0xc(%ebp)
  80194a:	ff 75 08             	pushl  0x8(%ebp)
  80194d:	e8 0c 04 00 00       	call   801d5e <sys_getSizeOfSharedObject>
  801952:	83 c4 10             	add    $0x10,%esp
  801955:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801958:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80195c:	75 07                	jne    801965 <sget+0x2c>
  80195e:	b8 00 00 00 00       	mov    $0x0,%eax
  801963:	eb 75                	jmp    8019da <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801965:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80196c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801972:	01 d0                	add    %edx,%eax
  801974:	48                   	dec    %eax
  801975:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801978:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80197b:	ba 00 00 00 00       	mov    $0x0,%edx
  801980:	f7 75 f0             	divl   -0x10(%ebp)
  801983:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801986:	29 d0                	sub    %edx,%eax
  801988:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  80198b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801992:	e8 18 06 00 00       	call   801faf <sys_isUHeapPlacementStrategyFIRSTFIT>
  801997:	83 f8 01             	cmp    $0x1,%eax
  80199a:	75 39                	jne    8019d5 <sget+0x9c>

		  va = malloc(newsize) ;
  80199c:	83 ec 0c             	sub    $0xc,%esp
  80199f:	ff 75 e8             	pushl  -0x18(%ebp)
  8019a2:	e8 78 fd ff ff       	call   80171f <malloc>
  8019a7:	83 c4 10             	add    $0x10,%esp
  8019aa:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  8019ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019b1:	74 22                	je     8019d5 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  8019b3:	83 ec 04             	sub    $0x4,%esp
  8019b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8019b9:	ff 75 0c             	pushl  0xc(%ebp)
  8019bc:	ff 75 08             	pushl  0x8(%ebp)
  8019bf:	e8 b7 03 00 00       	call   801d7b <sys_getSharedObject>
  8019c4:	83 c4 10             	add    $0x10,%esp
  8019c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  8019ca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8019ce:	78 05                	js     8019d5 <sget+0x9c>
					  return va;
  8019d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019d3:	eb 05                	jmp    8019da <sget+0xa1>
				  }
			  }
     }
         return NULL;
  8019d5:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019e2:	e8 49 fb ff ff       	call   801530 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	68 24 3b 80 00       	push   $0x803b24
  8019ef:	68 1e 01 00 00       	push   $0x11e
  8019f4:	68 f3 3a 80 00       	push   $0x803af3
  8019f9:	e8 f4 ea ff ff       	call   8004f2 <_panic>

008019fe <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a04:	83 ec 04             	sub    $0x4,%esp
  801a07:	68 4c 3b 80 00       	push   $0x803b4c
  801a0c:	68 32 01 00 00       	push   $0x132
  801a11:	68 f3 3a 80 00       	push   $0x803af3
  801a16:	e8 d7 ea ff ff       	call   8004f2 <_panic>

00801a1b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
  801a1e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a21:	83 ec 04             	sub    $0x4,%esp
  801a24:	68 70 3b 80 00       	push   $0x803b70
  801a29:	68 3d 01 00 00       	push   $0x13d
  801a2e:	68 f3 3a 80 00       	push   $0x803af3
  801a33:	e8 ba ea ff ff       	call   8004f2 <_panic>

00801a38 <shrink>:

}
void shrink(uint32 newSize)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a3e:	83 ec 04             	sub    $0x4,%esp
  801a41:	68 70 3b 80 00       	push   $0x803b70
  801a46:	68 42 01 00 00       	push   $0x142
  801a4b:	68 f3 3a 80 00       	push   $0x803af3
  801a50:	e8 9d ea ff ff       	call   8004f2 <_panic>

00801a55 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a5b:	83 ec 04             	sub    $0x4,%esp
  801a5e:	68 70 3b 80 00       	push   $0x803b70
  801a63:	68 47 01 00 00       	push   $0x147
  801a68:	68 f3 3a 80 00       	push   $0x803af3
  801a6d:	e8 80 ea ff ff       	call   8004f2 <_panic>

00801a72 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	57                   	push   %edi
  801a76:	56                   	push   %esi
  801a77:	53                   	push   %ebx
  801a78:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a81:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a84:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a87:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a8a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a8d:	cd 30                	int    $0x30
  801a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a95:	83 c4 10             	add    $0x10,%esp
  801a98:	5b                   	pop    %ebx
  801a99:	5e                   	pop    %esi
  801a9a:	5f                   	pop    %edi
  801a9b:	5d                   	pop    %ebp
  801a9c:	c3                   	ret    

00801a9d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 04             	sub    $0x4,%esp
  801aa3:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801aa9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	52                   	push   %edx
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	50                   	push   %eax
  801ab9:	6a 00                	push   $0x0
  801abb:	e8 b2 ff ff ff       	call   801a72 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	90                   	nop
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 01                	push   $0x1
  801ad5:	e8 98 ff ff ff       	call   801a72 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	52                   	push   %edx
  801aef:	50                   	push   %eax
  801af0:	6a 05                	push   $0x5
  801af2:	e8 7b ff ff ff       	call   801a72 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	56                   	push   %esi
  801b00:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b01:	8b 75 18             	mov    0x18(%ebp),%esi
  801b04:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	56                   	push   %esi
  801b11:	53                   	push   %ebx
  801b12:	51                   	push   %ecx
  801b13:	52                   	push   %edx
  801b14:	50                   	push   %eax
  801b15:	6a 06                	push   $0x6
  801b17:	e8 56 ff ff ff       	call   801a72 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b22:	5b                   	pop    %ebx
  801b23:	5e                   	pop    %esi
  801b24:	5d                   	pop    %ebp
  801b25:	c3                   	ret    

00801b26 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	52                   	push   %edx
  801b36:	50                   	push   %eax
  801b37:	6a 07                	push   $0x7
  801b39:	e8 34 ff ff ff       	call   801a72 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	ff 75 0c             	pushl  0xc(%ebp)
  801b4f:	ff 75 08             	pushl  0x8(%ebp)
  801b52:	6a 08                	push   $0x8
  801b54:	e8 19 ff ff ff       	call   801a72 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 09                	push   $0x9
  801b6d:	e8 00 ff ff ff       	call   801a72 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 0a                	push   $0xa
  801b86:	e8 e7 fe ff ff       	call   801a72 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 0b                	push   $0xb
  801b9f:	e8 ce fe ff ff       	call   801a72 <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	6a 0f                	push   $0xf
  801bba:	e8 b3 fe ff ff       	call   801a72 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
	return;
  801bc2:	90                   	nop
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	ff 75 0c             	pushl  0xc(%ebp)
  801bd1:	ff 75 08             	pushl  0x8(%ebp)
  801bd4:	6a 10                	push   $0x10
  801bd6:	e8 97 fe ff ff       	call   801a72 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bde:	90                   	nop
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	ff 75 10             	pushl  0x10(%ebp)
  801beb:	ff 75 0c             	pushl  0xc(%ebp)
  801bee:	ff 75 08             	pushl  0x8(%ebp)
  801bf1:	6a 11                	push   $0x11
  801bf3:	e8 7a fe ff ff       	call   801a72 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfb:	90                   	nop
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 0c                	push   $0xc
  801c0d:	e8 60 fe ff ff       	call   801a72 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	ff 75 08             	pushl  0x8(%ebp)
  801c25:	6a 0d                	push   $0xd
  801c27:	e8 46 fe ff ff       	call   801a72 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 0e                	push   $0xe
  801c40:	e8 2d fe ff ff       	call   801a72 <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	90                   	nop
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 13                	push   $0x13
  801c5a:	e8 13 fe ff ff       	call   801a72 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	90                   	nop
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 14                	push   $0x14
  801c74:	e8 f9 fd ff ff       	call   801a72 <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
}
  801c7c:	90                   	nop
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_cputc>:


void
sys_cputc(const char c)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 04             	sub    $0x4,%esp
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c8b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	50                   	push   %eax
  801c98:	6a 15                	push   $0x15
  801c9a:	e8 d3 fd ff ff       	call   801a72 <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
}
  801ca2:	90                   	nop
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 16                	push   $0x16
  801cb4:	e8 b9 fd ff ff       	call   801a72 <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
}
  801cbc:	90                   	nop
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	ff 75 0c             	pushl  0xc(%ebp)
  801cce:	50                   	push   %eax
  801ccf:	6a 17                	push   $0x17
  801cd1:	e8 9c fd ff ff       	call   801a72 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	52                   	push   %edx
  801ceb:	50                   	push   %eax
  801cec:	6a 1a                	push   $0x1a
  801cee:	e8 7f fd ff ff       	call   801a72 <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	52                   	push   %edx
  801d08:	50                   	push   %eax
  801d09:	6a 18                	push   $0x18
  801d0b:	e8 62 fd ff ff       	call   801a72 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	90                   	nop
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	52                   	push   %edx
  801d26:	50                   	push   %eax
  801d27:	6a 19                	push   $0x19
  801d29:	e8 44 fd ff ff       	call   801a72 <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
}
  801d31:	90                   	nop
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	83 ec 04             	sub    $0x4,%esp
  801d3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d40:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d43:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	6a 00                	push   $0x0
  801d4c:	51                   	push   %ecx
  801d4d:	52                   	push   %edx
  801d4e:	ff 75 0c             	pushl  0xc(%ebp)
  801d51:	50                   	push   %eax
  801d52:	6a 1b                	push   $0x1b
  801d54:	e8 19 fd ff ff       	call   801a72 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	52                   	push   %edx
  801d6e:	50                   	push   %eax
  801d6f:	6a 1c                	push   $0x1c
  801d71:	e8 fc fc ff ff       	call   801a72 <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	51                   	push   %ecx
  801d8c:	52                   	push   %edx
  801d8d:	50                   	push   %eax
  801d8e:	6a 1d                	push   $0x1d
  801d90:	e8 dd fc ff ff       	call   801a72 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	52                   	push   %edx
  801daa:	50                   	push   %eax
  801dab:	6a 1e                	push   $0x1e
  801dad:	e8 c0 fc ff ff       	call   801a72 <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 1f                	push   $0x1f
  801dc6:	e8 a7 fc ff ff       	call   801a72 <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	6a 00                	push   $0x0
  801dd8:	ff 75 14             	pushl  0x14(%ebp)
  801ddb:	ff 75 10             	pushl  0x10(%ebp)
  801dde:	ff 75 0c             	pushl  0xc(%ebp)
  801de1:	50                   	push   %eax
  801de2:	6a 20                	push   $0x20
  801de4:	e8 89 fc ff ff       	call   801a72 <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	50                   	push   %eax
  801dfd:	6a 21                	push   $0x21
  801dff:	e8 6e fc ff ff       	call   801a72 <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
}
  801e07:	90                   	nop
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	50                   	push   %eax
  801e19:	6a 22                	push   $0x22
  801e1b:	e8 52 fc ff ff       	call   801a72 <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 02                	push   $0x2
  801e34:	e8 39 fc ff ff       	call   801a72 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 03                	push   $0x3
  801e4d:	e8 20 fc ff ff       	call   801a72 <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 04                	push   $0x4
  801e66:	e8 07 fc ff ff       	call   801a72 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_exit_env>:


void sys_exit_env(void)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 23                	push   $0x23
  801e7f:	e8 ee fb ff ff       	call   801a72 <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
}
  801e87:	90                   	nop
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e90:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e93:	8d 50 04             	lea    0x4(%eax),%edx
  801e96:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	52                   	push   %edx
  801ea0:	50                   	push   %eax
  801ea1:	6a 24                	push   $0x24
  801ea3:	e8 ca fb ff ff       	call   801a72 <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
	return result;
  801eab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801eb1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801eb4:	89 01                	mov    %eax,(%ecx)
  801eb6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	c9                   	leave  
  801ebd:	c2 04 00             	ret    $0x4

00801ec0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	ff 75 10             	pushl  0x10(%ebp)
  801eca:	ff 75 0c             	pushl  0xc(%ebp)
  801ecd:	ff 75 08             	pushl  0x8(%ebp)
  801ed0:	6a 12                	push   $0x12
  801ed2:	e8 9b fb ff ff       	call   801a72 <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eda:	90                   	nop
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <sys_rcr2>:
uint32 sys_rcr2()
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 25                	push   $0x25
  801eec:	e8 81 fb ff ff       	call   801a72 <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 04             	sub    $0x4,%esp
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f02:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	50                   	push   %eax
  801f0f:	6a 26                	push   $0x26
  801f11:	e8 5c fb ff ff       	call   801a72 <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
	return ;
  801f19:	90                   	nop
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <rsttst>:
void rsttst()
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 28                	push   $0x28
  801f2b:	e8 42 fb ff ff       	call   801a72 <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
	return ;
  801f33:	90                   	nop
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	83 ec 04             	sub    $0x4,%esp
  801f3c:	8b 45 14             	mov    0x14(%ebp),%eax
  801f3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f42:	8b 55 18             	mov    0x18(%ebp),%edx
  801f45:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f49:	52                   	push   %edx
  801f4a:	50                   	push   %eax
  801f4b:	ff 75 10             	pushl  0x10(%ebp)
  801f4e:	ff 75 0c             	pushl  0xc(%ebp)
  801f51:	ff 75 08             	pushl  0x8(%ebp)
  801f54:	6a 27                	push   $0x27
  801f56:	e8 17 fb ff ff       	call   801a72 <syscall>
  801f5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5e:	90                   	nop
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <chktst>:
void chktst(uint32 n)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	ff 75 08             	pushl  0x8(%ebp)
  801f6f:	6a 29                	push   $0x29
  801f71:	e8 fc fa ff ff       	call   801a72 <syscall>
  801f76:	83 c4 18             	add    $0x18,%esp
	return ;
  801f79:	90                   	nop
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <inctst>:

void inctst()
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 2a                	push   $0x2a
  801f8b:	e8 e2 fa ff ff       	call   801a72 <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
	return ;
  801f93:	90                   	nop
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <gettst>:
uint32 gettst()
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 2b                	push   $0x2b
  801fa5:	e8 c8 fa ff ff       	call   801a72 <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 2c                	push   $0x2c
  801fc1:	e8 ac fa ff ff       	call   801a72 <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
  801fc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fcc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fd0:	75 07                	jne    801fd9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd7:	eb 05                	jmp    801fde <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 2c                	push   $0x2c
  801ff2:	e8 7b fa ff ff       	call   801a72 <syscall>
  801ff7:	83 c4 18             	add    $0x18,%esp
  801ffa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ffd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802001:	75 07                	jne    80200a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802003:	b8 01 00 00 00       	mov    $0x1,%eax
  802008:	eb 05                	jmp    80200f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80200a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 2c                	push   $0x2c
  802023:	e8 4a fa ff ff       	call   801a72 <syscall>
  802028:	83 c4 18             	add    $0x18,%esp
  80202b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80202e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802032:	75 07                	jne    80203b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802034:	b8 01 00 00 00       	mov    $0x1,%eax
  802039:	eb 05                	jmp    802040 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80203b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 2c                	push   $0x2c
  802054:	e8 19 fa ff ff       	call   801a72 <syscall>
  802059:	83 c4 18             	add    $0x18,%esp
  80205c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80205f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802063:	75 07                	jne    80206c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802065:	b8 01 00 00 00       	mov    $0x1,%eax
  80206a:	eb 05                	jmp    802071 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80206c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	ff 75 08             	pushl  0x8(%ebp)
  802081:	6a 2d                	push   $0x2d
  802083:	e8 ea f9 ff ff       	call   801a72 <syscall>
  802088:	83 c4 18             	add    $0x18,%esp
	return ;
  80208b:	90                   	nop
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802092:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802095:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802098:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	6a 00                	push   $0x0
  8020a0:	53                   	push   %ebx
  8020a1:	51                   	push   %ecx
  8020a2:	52                   	push   %edx
  8020a3:	50                   	push   %eax
  8020a4:	6a 2e                	push   $0x2e
  8020a6:	e8 c7 f9 ff ff       	call   801a72 <syscall>
  8020ab:	83 c4 18             	add    $0x18,%esp
}
  8020ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	52                   	push   %edx
  8020c3:	50                   	push   %eax
  8020c4:	6a 2f                	push   $0x2f
  8020c6:	e8 a7 f9 ff ff       	call   801a72 <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020d6:	83 ec 0c             	sub    $0xc,%esp
  8020d9:	68 80 3b 80 00       	push   $0x803b80
  8020de:	e8 c3 e6 ff ff       	call   8007a6 <cprintf>
  8020e3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020ed:	83 ec 0c             	sub    $0xc,%esp
  8020f0:	68 ac 3b 80 00       	push   $0x803bac
  8020f5:	e8 ac e6 ff ff       	call   8007a6 <cprintf>
  8020fa:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020fd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802101:	a1 38 41 80 00       	mov    0x804138,%eax
  802106:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802109:	eb 56                	jmp    802161 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80210b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80210f:	74 1c                	je     80212d <print_mem_block_lists+0x5d>
  802111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802114:	8b 50 08             	mov    0x8(%eax),%edx
  802117:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211a:	8b 48 08             	mov    0x8(%eax),%ecx
  80211d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802120:	8b 40 0c             	mov    0xc(%eax),%eax
  802123:	01 c8                	add    %ecx,%eax
  802125:	39 c2                	cmp    %eax,%edx
  802127:	73 04                	jae    80212d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802129:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80212d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802130:	8b 50 08             	mov    0x8(%eax),%edx
  802133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802136:	8b 40 0c             	mov    0xc(%eax),%eax
  802139:	01 c2                	add    %eax,%edx
  80213b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213e:	8b 40 08             	mov    0x8(%eax),%eax
  802141:	83 ec 04             	sub    $0x4,%esp
  802144:	52                   	push   %edx
  802145:	50                   	push   %eax
  802146:	68 c1 3b 80 00       	push   $0x803bc1
  80214b:	e8 56 e6 ff ff       	call   8007a6 <cprintf>
  802150:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802156:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802159:	a1 40 41 80 00       	mov    0x804140,%eax
  80215e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802161:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802165:	74 07                	je     80216e <print_mem_block_lists+0x9e>
  802167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216a:	8b 00                	mov    (%eax),%eax
  80216c:	eb 05                	jmp    802173 <print_mem_block_lists+0xa3>
  80216e:	b8 00 00 00 00       	mov    $0x0,%eax
  802173:	a3 40 41 80 00       	mov    %eax,0x804140
  802178:	a1 40 41 80 00       	mov    0x804140,%eax
  80217d:	85 c0                	test   %eax,%eax
  80217f:	75 8a                	jne    80210b <print_mem_block_lists+0x3b>
  802181:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802185:	75 84                	jne    80210b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802187:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80218b:	75 10                	jne    80219d <print_mem_block_lists+0xcd>
  80218d:	83 ec 0c             	sub    $0xc,%esp
  802190:	68 d0 3b 80 00       	push   $0x803bd0
  802195:	e8 0c e6 ff ff       	call   8007a6 <cprintf>
  80219a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80219d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021a4:	83 ec 0c             	sub    $0xc,%esp
  8021a7:	68 f4 3b 80 00       	push   $0x803bf4
  8021ac:	e8 f5 e5 ff ff       	call   8007a6 <cprintf>
  8021b1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8021b4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021b8:	a1 40 40 80 00       	mov    0x804040,%eax
  8021bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c0:	eb 56                	jmp    802218 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021c6:	74 1c                	je     8021e4 <print_mem_block_lists+0x114>
  8021c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cb:	8b 50 08             	mov    0x8(%eax),%edx
  8021ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d1:	8b 48 08             	mov    0x8(%eax),%ecx
  8021d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8021da:	01 c8                	add    %ecx,%eax
  8021dc:	39 c2                	cmp    %eax,%edx
  8021de:	73 04                	jae    8021e4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021e0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	8b 50 08             	mov    0x8(%eax),%edx
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f0:	01 c2                	add    %eax,%edx
  8021f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f5:	8b 40 08             	mov    0x8(%eax),%eax
  8021f8:	83 ec 04             	sub    $0x4,%esp
  8021fb:	52                   	push   %edx
  8021fc:	50                   	push   %eax
  8021fd:	68 c1 3b 80 00       	push   $0x803bc1
  802202:	e8 9f e5 ff ff       	call   8007a6 <cprintf>
  802207:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80220a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802210:	a1 48 40 80 00       	mov    0x804048,%eax
  802215:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802218:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221c:	74 07                	je     802225 <print_mem_block_lists+0x155>
  80221e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802221:	8b 00                	mov    (%eax),%eax
  802223:	eb 05                	jmp    80222a <print_mem_block_lists+0x15a>
  802225:	b8 00 00 00 00       	mov    $0x0,%eax
  80222a:	a3 48 40 80 00       	mov    %eax,0x804048
  80222f:	a1 48 40 80 00       	mov    0x804048,%eax
  802234:	85 c0                	test   %eax,%eax
  802236:	75 8a                	jne    8021c2 <print_mem_block_lists+0xf2>
  802238:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223c:	75 84                	jne    8021c2 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80223e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802242:	75 10                	jne    802254 <print_mem_block_lists+0x184>
  802244:	83 ec 0c             	sub    $0xc,%esp
  802247:	68 0c 3c 80 00       	push   $0x803c0c
  80224c:	e8 55 e5 ff ff       	call   8007a6 <cprintf>
  802251:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802254:	83 ec 0c             	sub    $0xc,%esp
  802257:	68 80 3b 80 00       	push   $0x803b80
  80225c:	e8 45 e5 ff ff       	call   8007a6 <cprintf>
  802261:	83 c4 10             	add    $0x10,%esp

}
  802264:	90                   	nop
  802265:	c9                   	leave  
  802266:	c3                   	ret    

00802267 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
  80226a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  80226d:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802274:	00 00 00 
  802277:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80227e:	00 00 00 
  802281:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802288:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80228b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802292:	e9 9e 00 00 00       	jmp    802335 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802297:	a1 50 40 80 00       	mov    0x804050,%eax
  80229c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229f:	c1 e2 04             	shl    $0x4,%edx
  8022a2:	01 d0                	add    %edx,%eax
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	75 14                	jne    8022bc <initialize_MemBlocksList+0x55>
  8022a8:	83 ec 04             	sub    $0x4,%esp
  8022ab:	68 34 3c 80 00       	push   $0x803c34
  8022b0:	6a 47                	push   $0x47
  8022b2:	68 57 3c 80 00       	push   $0x803c57
  8022b7:	e8 36 e2 ff ff       	call   8004f2 <_panic>
  8022bc:	a1 50 40 80 00       	mov    0x804050,%eax
  8022c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c4:	c1 e2 04             	shl    $0x4,%edx
  8022c7:	01 d0                	add    %edx,%eax
  8022c9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8022cf:	89 10                	mov    %edx,(%eax)
  8022d1:	8b 00                	mov    (%eax),%eax
  8022d3:	85 c0                	test   %eax,%eax
  8022d5:	74 18                	je     8022ef <initialize_MemBlocksList+0x88>
  8022d7:	a1 48 41 80 00       	mov    0x804148,%eax
  8022dc:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8022e2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022e5:	c1 e1 04             	shl    $0x4,%ecx
  8022e8:	01 ca                	add    %ecx,%edx
  8022ea:	89 50 04             	mov    %edx,0x4(%eax)
  8022ed:	eb 12                	jmp    802301 <initialize_MemBlocksList+0x9a>
  8022ef:	a1 50 40 80 00       	mov    0x804050,%eax
  8022f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f7:	c1 e2 04             	shl    $0x4,%edx
  8022fa:	01 d0                	add    %edx,%eax
  8022fc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802301:	a1 50 40 80 00       	mov    0x804050,%eax
  802306:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802309:	c1 e2 04             	shl    $0x4,%edx
  80230c:	01 d0                	add    %edx,%eax
  80230e:	a3 48 41 80 00       	mov    %eax,0x804148
  802313:	a1 50 40 80 00       	mov    0x804050,%eax
  802318:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231b:	c1 e2 04             	shl    $0x4,%edx
  80231e:	01 d0                	add    %edx,%eax
  802320:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802327:	a1 54 41 80 00       	mov    0x804154,%eax
  80232c:	40                   	inc    %eax
  80232d:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802332:	ff 45 f4             	incl   -0xc(%ebp)
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233b:	0f 82 56 ff ff ff    	jb     802297 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802341:	90                   	nop
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	8b 00                	mov    (%eax),%eax
  80234f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802352:	eb 19                	jmp    80236d <find_block+0x29>
	{
		if(element->sva == va){
  802354:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802357:	8b 40 08             	mov    0x8(%eax),%eax
  80235a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80235d:	75 05                	jne    802364 <find_block+0x20>
			 		return element;
  80235f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802362:	eb 36                	jmp    80239a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	8b 40 08             	mov    0x8(%eax),%eax
  80236a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80236d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802371:	74 07                	je     80237a <find_block+0x36>
  802373:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802376:	8b 00                	mov    (%eax),%eax
  802378:	eb 05                	jmp    80237f <find_block+0x3b>
  80237a:	b8 00 00 00 00       	mov    $0x0,%eax
  80237f:	8b 55 08             	mov    0x8(%ebp),%edx
  802382:	89 42 08             	mov    %eax,0x8(%edx)
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	8b 40 08             	mov    0x8(%eax),%eax
  80238b:	85 c0                	test   %eax,%eax
  80238d:	75 c5                	jne    802354 <find_block+0x10>
  80238f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802393:	75 bf                	jne    802354 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802395:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
  80239f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  8023a2:	a1 44 40 80 00       	mov    0x804044,%eax
  8023a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  8023aa:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023af:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  8023b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023b6:	74 0a                	je     8023c2 <insert_sorted_allocList+0x26>
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8b 40 08             	mov    0x8(%eax),%eax
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	75 65                	jne    802427 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8023c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c6:	75 14                	jne    8023dc <insert_sorted_allocList+0x40>
  8023c8:	83 ec 04             	sub    $0x4,%esp
  8023cb:	68 34 3c 80 00       	push   $0x803c34
  8023d0:	6a 6e                	push   $0x6e
  8023d2:	68 57 3c 80 00       	push   $0x803c57
  8023d7:	e8 16 e1 ff ff       	call   8004f2 <_panic>
  8023dc:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e5:	89 10                	mov    %edx,(%eax)
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	8b 00                	mov    (%eax),%eax
  8023ec:	85 c0                	test   %eax,%eax
  8023ee:	74 0d                	je     8023fd <insert_sorted_allocList+0x61>
  8023f0:	a1 40 40 80 00       	mov    0x804040,%eax
  8023f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f8:	89 50 04             	mov    %edx,0x4(%eax)
  8023fb:	eb 08                	jmp    802405 <insert_sorted_allocList+0x69>
  8023fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802400:	a3 44 40 80 00       	mov    %eax,0x804044
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	a3 40 40 80 00       	mov    %eax,0x804040
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802417:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80241c:	40                   	inc    %eax
  80241d:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802422:	e9 cf 01 00 00       	jmp    8025f6 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242a:	8b 50 08             	mov    0x8(%eax),%edx
  80242d:	8b 45 08             	mov    0x8(%ebp),%eax
  802430:	8b 40 08             	mov    0x8(%eax),%eax
  802433:	39 c2                	cmp    %eax,%edx
  802435:	73 65                	jae    80249c <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802437:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80243b:	75 14                	jne    802451 <insert_sorted_allocList+0xb5>
  80243d:	83 ec 04             	sub    $0x4,%esp
  802440:	68 70 3c 80 00       	push   $0x803c70
  802445:	6a 72                	push   $0x72
  802447:	68 57 3c 80 00       	push   $0x803c57
  80244c:	e8 a1 e0 ff ff       	call   8004f2 <_panic>
  802451:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	89 50 04             	mov    %edx,0x4(%eax)
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	8b 40 04             	mov    0x4(%eax),%eax
  802463:	85 c0                	test   %eax,%eax
  802465:	74 0c                	je     802473 <insert_sorted_allocList+0xd7>
  802467:	a1 44 40 80 00       	mov    0x804044,%eax
  80246c:	8b 55 08             	mov    0x8(%ebp),%edx
  80246f:	89 10                	mov    %edx,(%eax)
  802471:	eb 08                	jmp    80247b <insert_sorted_allocList+0xdf>
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	a3 40 40 80 00       	mov    %eax,0x804040
  80247b:	8b 45 08             	mov    0x8(%ebp),%eax
  80247e:	a3 44 40 80 00       	mov    %eax,0x804044
  802483:	8b 45 08             	mov    0x8(%ebp),%eax
  802486:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80248c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802491:	40                   	inc    %eax
  802492:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802497:	e9 5a 01 00 00       	jmp    8025f6 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  80249c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249f:	8b 50 08             	mov    0x8(%eax),%edx
  8024a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a5:	8b 40 08             	mov    0x8(%eax),%eax
  8024a8:	39 c2                	cmp    %eax,%edx
  8024aa:	75 70                	jne    80251c <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  8024ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024b0:	74 06                	je     8024b8 <insert_sorted_allocList+0x11c>
  8024b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024b6:	75 14                	jne    8024cc <insert_sorted_allocList+0x130>
  8024b8:	83 ec 04             	sub    $0x4,%esp
  8024bb:	68 94 3c 80 00       	push   $0x803c94
  8024c0:	6a 75                	push   $0x75
  8024c2:	68 57 3c 80 00       	push   $0x803c57
  8024c7:	e8 26 e0 ff ff       	call   8004f2 <_panic>
  8024cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cf:	8b 10                	mov    (%eax),%edx
  8024d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d4:	89 10                	mov    %edx,(%eax)
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	8b 00                	mov    (%eax),%eax
  8024db:	85 c0                	test   %eax,%eax
  8024dd:	74 0b                	je     8024ea <insert_sorted_allocList+0x14e>
  8024df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e2:	8b 00                	mov    (%eax),%eax
  8024e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f0:	89 10                	mov    %edx,(%eax)
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f8:	89 50 04             	mov    %edx,0x4(%eax)
  8024fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fe:	8b 00                	mov    (%eax),%eax
  802500:	85 c0                	test   %eax,%eax
  802502:	75 08                	jne    80250c <insert_sorted_allocList+0x170>
  802504:	8b 45 08             	mov    0x8(%ebp),%eax
  802507:	a3 44 40 80 00       	mov    %eax,0x804044
  80250c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802511:	40                   	inc    %eax
  802512:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802517:	e9 da 00 00 00       	jmp    8025f6 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80251c:	a1 40 40 80 00       	mov    0x804040,%eax
  802521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802524:	e9 9d 00 00 00       	jmp    8025c6 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	8b 50 08             	mov    0x8(%eax),%edx
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 40 08             	mov    0x8(%eax),%eax
  80253d:	39 c2                	cmp    %eax,%edx
  80253f:	76 7d                	jbe    8025be <insert_sorted_allocList+0x222>
  802541:	8b 45 08             	mov    0x8(%ebp),%eax
  802544:	8b 50 08             	mov    0x8(%eax),%edx
  802547:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80254a:	8b 40 08             	mov    0x8(%eax),%eax
  80254d:	39 c2                	cmp    %eax,%edx
  80254f:	73 6d                	jae    8025be <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802555:	74 06                	je     80255d <insert_sorted_allocList+0x1c1>
  802557:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80255b:	75 14                	jne    802571 <insert_sorted_allocList+0x1d5>
  80255d:	83 ec 04             	sub    $0x4,%esp
  802560:	68 94 3c 80 00       	push   $0x803c94
  802565:	6a 7c                	push   $0x7c
  802567:	68 57 3c 80 00       	push   $0x803c57
  80256c:	e8 81 df ff ff       	call   8004f2 <_panic>
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 10                	mov    (%eax),%edx
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	89 10                	mov    %edx,(%eax)
  80257b:	8b 45 08             	mov    0x8(%ebp),%eax
  80257e:	8b 00                	mov    (%eax),%eax
  802580:	85 c0                	test   %eax,%eax
  802582:	74 0b                	je     80258f <insert_sorted_allocList+0x1f3>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 00                	mov    (%eax),%eax
  802589:	8b 55 08             	mov    0x8(%ebp),%edx
  80258c:	89 50 04             	mov    %edx,0x4(%eax)
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 55 08             	mov    0x8(%ebp),%edx
  802595:	89 10                	mov    %edx,(%eax)
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259d:	89 50 04             	mov    %edx,0x4(%eax)
  8025a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a3:	8b 00                	mov    (%eax),%eax
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	75 08                	jne    8025b1 <insert_sorted_allocList+0x215>
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	a3 44 40 80 00       	mov    %eax,0x804044
  8025b1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8025b6:	40                   	inc    %eax
  8025b7:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8025bc:	eb 38                	jmp    8025f6 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8025be:	a1 48 40 80 00       	mov    0x804048,%eax
  8025c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ca:	74 07                	je     8025d3 <insert_sorted_allocList+0x237>
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 00                	mov    (%eax),%eax
  8025d1:	eb 05                	jmp    8025d8 <insert_sorted_allocList+0x23c>
  8025d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d8:	a3 48 40 80 00       	mov    %eax,0x804048
  8025dd:	a1 48 40 80 00       	mov    0x804048,%eax
  8025e2:	85 c0                	test   %eax,%eax
  8025e4:	0f 85 3f ff ff ff    	jne    802529 <insert_sorted_allocList+0x18d>
  8025ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ee:	0f 85 35 ff ff ff    	jne    802529 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8025f4:	eb 00                	jmp    8025f6 <insert_sorted_allocList+0x25a>
  8025f6:	90                   	nop
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
  8025fc:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8025ff:	a1 38 41 80 00       	mov    0x804138,%eax
  802604:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802607:	e9 6b 02 00 00       	jmp    802877 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 40 0c             	mov    0xc(%eax),%eax
  802612:	3b 45 08             	cmp    0x8(%ebp),%eax
  802615:	0f 85 90 00 00 00    	jne    8026ab <alloc_block_FF+0xb2>
			  temp=element;
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802621:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802625:	75 17                	jne    80263e <alloc_block_FF+0x45>
  802627:	83 ec 04             	sub    $0x4,%esp
  80262a:	68 c8 3c 80 00       	push   $0x803cc8
  80262f:	68 92 00 00 00       	push   $0x92
  802634:	68 57 3c 80 00       	push   $0x803c57
  802639:	e8 b4 de ff ff       	call   8004f2 <_panic>
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	8b 00                	mov    (%eax),%eax
  802643:	85 c0                	test   %eax,%eax
  802645:	74 10                	je     802657 <alloc_block_FF+0x5e>
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	8b 00                	mov    (%eax),%eax
  80264c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264f:	8b 52 04             	mov    0x4(%edx),%edx
  802652:	89 50 04             	mov    %edx,0x4(%eax)
  802655:	eb 0b                	jmp    802662 <alloc_block_FF+0x69>
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 40 04             	mov    0x4(%eax),%eax
  80265d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	8b 40 04             	mov    0x4(%eax),%eax
  802668:	85 c0                	test   %eax,%eax
  80266a:	74 0f                	je     80267b <alloc_block_FF+0x82>
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 40 04             	mov    0x4(%eax),%eax
  802672:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802675:	8b 12                	mov    (%edx),%edx
  802677:	89 10                	mov    %edx,(%eax)
  802679:	eb 0a                	jmp    802685 <alloc_block_FF+0x8c>
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 00                	mov    (%eax),%eax
  802680:	a3 38 41 80 00       	mov    %eax,0x804138
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802698:	a1 44 41 80 00       	mov    0x804144,%eax
  80269d:	48                   	dec    %eax
  80269e:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  8026a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a6:	e9 ff 01 00 00       	jmp    8028aa <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b4:	0f 86 b5 01 00 00    	jbe    80286f <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c0:	2b 45 08             	sub    0x8(%ebp),%eax
  8026c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  8026c6:	a1 48 41 80 00       	mov    0x804148,%eax
  8026cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  8026ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026d2:	75 17                	jne    8026eb <alloc_block_FF+0xf2>
  8026d4:	83 ec 04             	sub    $0x4,%esp
  8026d7:	68 c8 3c 80 00       	push   $0x803cc8
  8026dc:	68 99 00 00 00       	push   $0x99
  8026e1:	68 57 3c 80 00       	push   $0x803c57
  8026e6:	e8 07 de ff ff       	call   8004f2 <_panic>
  8026eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ee:	8b 00                	mov    (%eax),%eax
  8026f0:	85 c0                	test   %eax,%eax
  8026f2:	74 10                	je     802704 <alloc_block_FF+0x10b>
  8026f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f7:	8b 00                	mov    (%eax),%eax
  8026f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026fc:	8b 52 04             	mov    0x4(%edx),%edx
  8026ff:	89 50 04             	mov    %edx,0x4(%eax)
  802702:	eb 0b                	jmp    80270f <alloc_block_FF+0x116>
  802704:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802707:	8b 40 04             	mov    0x4(%eax),%eax
  80270a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80270f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802712:	8b 40 04             	mov    0x4(%eax),%eax
  802715:	85 c0                	test   %eax,%eax
  802717:	74 0f                	je     802728 <alloc_block_FF+0x12f>
  802719:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271c:	8b 40 04             	mov    0x4(%eax),%eax
  80271f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802722:	8b 12                	mov    (%edx),%edx
  802724:	89 10                	mov    %edx,(%eax)
  802726:	eb 0a                	jmp    802732 <alloc_block_FF+0x139>
  802728:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272b:	8b 00                	mov    (%eax),%eax
  80272d:	a3 48 41 80 00       	mov    %eax,0x804148
  802732:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802735:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802745:	a1 54 41 80 00       	mov    0x804154,%eax
  80274a:	48                   	dec    %eax
  80274b:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802750:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802754:	75 17                	jne    80276d <alloc_block_FF+0x174>
  802756:	83 ec 04             	sub    $0x4,%esp
  802759:	68 70 3c 80 00       	push   $0x803c70
  80275e:	68 9a 00 00 00       	push   $0x9a
  802763:	68 57 3c 80 00       	push   $0x803c57
  802768:	e8 85 dd ff ff       	call   8004f2 <_panic>
  80276d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802773:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802776:	89 50 04             	mov    %edx,0x4(%eax)
  802779:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277c:	8b 40 04             	mov    0x4(%eax),%eax
  80277f:	85 c0                	test   %eax,%eax
  802781:	74 0c                	je     80278f <alloc_block_FF+0x196>
  802783:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802788:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80278b:	89 10                	mov    %edx,(%eax)
  80278d:	eb 08                	jmp    802797 <alloc_block_FF+0x19e>
  80278f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802792:	a3 38 41 80 00       	mov    %eax,0x804138
  802797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80279f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a8:	a1 44 41 80 00       	mov    0x804144,%eax
  8027ad:	40                   	inc    %eax
  8027ae:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  8027b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b9:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	8b 50 08             	mov    0x8(%eax),%edx
  8027c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c5:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ce:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 50 08             	mov    0x8(%eax),%edx
  8027d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027da:	01 c2                	add    %eax,%edx
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8027e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8027e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027ec:	75 17                	jne    802805 <alloc_block_FF+0x20c>
  8027ee:	83 ec 04             	sub    $0x4,%esp
  8027f1:	68 c8 3c 80 00       	push   $0x803cc8
  8027f6:	68 a2 00 00 00       	push   $0xa2
  8027fb:	68 57 3c 80 00       	push   $0x803c57
  802800:	e8 ed dc ff ff       	call   8004f2 <_panic>
  802805:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	85 c0                	test   %eax,%eax
  80280c:	74 10                	je     80281e <alloc_block_FF+0x225>
  80280e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802811:	8b 00                	mov    (%eax),%eax
  802813:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802816:	8b 52 04             	mov    0x4(%edx),%edx
  802819:	89 50 04             	mov    %edx,0x4(%eax)
  80281c:	eb 0b                	jmp    802829 <alloc_block_FF+0x230>
  80281e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802821:	8b 40 04             	mov    0x4(%eax),%eax
  802824:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802829:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282c:	8b 40 04             	mov    0x4(%eax),%eax
  80282f:	85 c0                	test   %eax,%eax
  802831:	74 0f                	je     802842 <alloc_block_FF+0x249>
  802833:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802836:	8b 40 04             	mov    0x4(%eax),%eax
  802839:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80283c:	8b 12                	mov    (%edx),%edx
  80283e:	89 10                	mov    %edx,(%eax)
  802840:	eb 0a                	jmp    80284c <alloc_block_FF+0x253>
  802842:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802845:	8b 00                	mov    (%eax),%eax
  802847:	a3 38 41 80 00       	mov    %eax,0x804138
  80284c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802855:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802858:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285f:	a1 44 41 80 00       	mov    0x804144,%eax
  802864:	48                   	dec    %eax
  802865:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  80286a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80286d:	eb 3b                	jmp    8028aa <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80286f:	a1 40 41 80 00       	mov    0x804140,%eax
  802874:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802877:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287b:	74 07                	je     802884 <alloc_block_FF+0x28b>
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 00                	mov    (%eax),%eax
  802882:	eb 05                	jmp    802889 <alloc_block_FF+0x290>
  802884:	b8 00 00 00 00       	mov    $0x0,%eax
  802889:	a3 40 41 80 00       	mov    %eax,0x804140
  80288e:	a1 40 41 80 00       	mov    0x804140,%eax
  802893:	85 c0                	test   %eax,%eax
  802895:	0f 85 71 fd ff ff    	jne    80260c <alloc_block_FF+0x13>
  80289b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289f:	0f 85 67 fd ff ff    	jne    80260c <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  8028a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028aa:	c9                   	leave  
  8028ab:	c3                   	ret    

008028ac <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8028ac:	55                   	push   %ebp
  8028ad:	89 e5                	mov    %esp,%ebp
  8028af:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  8028b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  8028b9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8028c0:	a1 38 41 80 00       	mov    0x804138,%eax
  8028c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8028c8:	e9 d3 00 00 00       	jmp    8029a0 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  8028cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d6:	0f 85 90 00 00 00    	jne    80296c <alloc_block_BF+0xc0>
	   temp = element;
  8028dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028df:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8028e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028e6:	75 17                	jne    8028ff <alloc_block_BF+0x53>
  8028e8:	83 ec 04             	sub    $0x4,%esp
  8028eb:	68 c8 3c 80 00       	push   $0x803cc8
  8028f0:	68 bd 00 00 00       	push   $0xbd
  8028f5:	68 57 3c 80 00       	push   $0x803c57
  8028fa:	e8 f3 db ff ff       	call   8004f2 <_panic>
  8028ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802902:	8b 00                	mov    (%eax),%eax
  802904:	85 c0                	test   %eax,%eax
  802906:	74 10                	je     802918 <alloc_block_BF+0x6c>
  802908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290b:	8b 00                	mov    (%eax),%eax
  80290d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802910:	8b 52 04             	mov    0x4(%edx),%edx
  802913:	89 50 04             	mov    %edx,0x4(%eax)
  802916:	eb 0b                	jmp    802923 <alloc_block_BF+0x77>
  802918:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291b:	8b 40 04             	mov    0x4(%eax),%eax
  80291e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802923:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802926:	8b 40 04             	mov    0x4(%eax),%eax
  802929:	85 c0                	test   %eax,%eax
  80292b:	74 0f                	je     80293c <alloc_block_BF+0x90>
  80292d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802930:	8b 40 04             	mov    0x4(%eax),%eax
  802933:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802936:	8b 12                	mov    (%edx),%edx
  802938:	89 10                	mov    %edx,(%eax)
  80293a:	eb 0a                	jmp    802946 <alloc_block_BF+0x9a>
  80293c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293f:	8b 00                	mov    (%eax),%eax
  802941:	a3 38 41 80 00       	mov    %eax,0x804138
  802946:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802949:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802952:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802959:	a1 44 41 80 00       	mov    0x804144,%eax
  80295e:	48                   	dec    %eax
  80295f:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802964:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802967:	e9 41 01 00 00       	jmp    802aad <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  80296c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296f:	8b 40 0c             	mov    0xc(%eax),%eax
  802972:	3b 45 08             	cmp    0x8(%ebp),%eax
  802975:	76 21                	jbe    802998 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802977:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297a:	8b 40 0c             	mov    0xc(%eax),%eax
  80297d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802980:	73 16                	jae    802998 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802982:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802985:	8b 40 0c             	mov    0xc(%eax),%eax
  802988:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  80298b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802991:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802998:	a1 40 41 80 00       	mov    0x804140,%eax
  80299d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8029a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029a4:	74 07                	je     8029ad <alloc_block_BF+0x101>
  8029a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a9:	8b 00                	mov    (%eax),%eax
  8029ab:	eb 05                	jmp    8029b2 <alloc_block_BF+0x106>
  8029ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b2:	a3 40 41 80 00       	mov    %eax,0x804140
  8029b7:	a1 40 41 80 00       	mov    0x804140,%eax
  8029bc:	85 c0                	test   %eax,%eax
  8029be:	0f 85 09 ff ff ff    	jne    8028cd <alloc_block_BF+0x21>
  8029c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029c8:	0f 85 ff fe ff ff    	jne    8028cd <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  8029ce:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8029d2:	0f 85 d0 00 00 00    	jne    802aa8 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  8029d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029db:	8b 40 0c             	mov    0xc(%eax),%eax
  8029de:	2b 45 08             	sub    0x8(%ebp),%eax
  8029e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8029e4:	a1 48 41 80 00       	mov    0x804148,%eax
  8029e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8029ec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8029f0:	75 17                	jne    802a09 <alloc_block_BF+0x15d>
  8029f2:	83 ec 04             	sub    $0x4,%esp
  8029f5:	68 c8 3c 80 00       	push   $0x803cc8
  8029fa:	68 d1 00 00 00       	push   $0xd1
  8029ff:	68 57 3c 80 00       	push   $0x803c57
  802a04:	e8 e9 da ff ff       	call   8004f2 <_panic>
  802a09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 10                	je     802a22 <alloc_block_BF+0x176>
  802a12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a1a:	8b 52 04             	mov    0x4(%edx),%edx
  802a1d:	89 50 04             	mov    %edx,0x4(%eax)
  802a20:	eb 0b                	jmp    802a2d <alloc_block_BF+0x181>
  802a22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a25:	8b 40 04             	mov    0x4(%eax),%eax
  802a28:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a30:	8b 40 04             	mov    0x4(%eax),%eax
  802a33:	85 c0                	test   %eax,%eax
  802a35:	74 0f                	je     802a46 <alloc_block_BF+0x19a>
  802a37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a3a:	8b 40 04             	mov    0x4(%eax),%eax
  802a3d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a40:	8b 12                	mov    (%edx),%edx
  802a42:	89 10                	mov    %edx,(%eax)
  802a44:	eb 0a                	jmp    802a50 <alloc_block_BF+0x1a4>
  802a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a49:	8b 00                	mov    (%eax),%eax
  802a4b:	a3 48 41 80 00       	mov    %eax,0x804148
  802a50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a63:	a1 54 41 80 00       	mov    0x804154,%eax
  802a68:	48                   	dec    %eax
  802a69:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802a6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a71:	8b 55 08             	mov    0x8(%ebp),%edx
  802a74:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7a:	8b 50 08             	mov    0x8(%eax),%edx
  802a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a80:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a89:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802a8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8f:	8b 50 08             	mov    0x8(%eax),%edx
  802a92:	8b 45 08             	mov    0x8(%ebp),%eax
  802a95:	01 c2                	add    %eax,%edx
  802a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9a:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802a9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802aa3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802aa6:	eb 05                	jmp    802aad <alloc_block_BF+0x201>
	 }
	 return NULL;
  802aa8:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802aad:	c9                   	leave  
  802aae:	c3                   	ret    

00802aaf <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802aaf:	55                   	push   %ebp
  802ab0:	89 e5                	mov    %esp,%ebp
  802ab2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802ab5:	83 ec 04             	sub    $0x4,%esp
  802ab8:	68 e8 3c 80 00       	push   $0x803ce8
  802abd:	68 e8 00 00 00       	push   $0xe8
  802ac2:	68 57 3c 80 00       	push   $0x803c57
  802ac7:	e8 26 da ff ff       	call   8004f2 <_panic>

00802acc <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802acc:	55                   	push   %ebp
  802acd:	89 e5                	mov    %esp,%ebp
  802acf:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802ad2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802ada:	a1 38 41 80 00       	mov    0x804138,%eax
  802adf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802ae2:	a1 44 41 80 00       	mov    0x804144,%eax
  802ae7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802aea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aee:	75 68                	jne    802b58 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802af0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802af4:	75 17                	jne    802b0d <insert_sorted_with_merge_freeList+0x41>
  802af6:	83 ec 04             	sub    $0x4,%esp
  802af9:	68 34 3c 80 00       	push   $0x803c34
  802afe:	68 36 01 00 00       	push   $0x136
  802b03:	68 57 3c 80 00       	push   $0x803c57
  802b08:	e8 e5 d9 ff ff       	call   8004f2 <_panic>
  802b0d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b13:	8b 45 08             	mov    0x8(%ebp),%eax
  802b16:	89 10                	mov    %edx,(%eax)
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	8b 00                	mov    (%eax),%eax
  802b1d:	85 c0                	test   %eax,%eax
  802b1f:	74 0d                	je     802b2e <insert_sorted_with_merge_freeList+0x62>
  802b21:	a1 38 41 80 00       	mov    0x804138,%eax
  802b26:	8b 55 08             	mov    0x8(%ebp),%edx
  802b29:	89 50 04             	mov    %edx,0x4(%eax)
  802b2c:	eb 08                	jmp    802b36 <insert_sorted_with_merge_freeList+0x6a>
  802b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b31:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b36:	8b 45 08             	mov    0x8(%ebp),%eax
  802b39:	a3 38 41 80 00       	mov    %eax,0x804138
  802b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b48:	a1 44 41 80 00       	mov    0x804144,%eax
  802b4d:	40                   	inc    %eax
  802b4e:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802b53:	e9 ba 06 00 00       	jmp    803212 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5b:	8b 50 08             	mov    0x8(%eax),%edx
  802b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b61:	8b 40 0c             	mov    0xc(%eax),%eax
  802b64:	01 c2                	add    %eax,%edx
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	8b 40 08             	mov    0x8(%eax),%eax
  802b6c:	39 c2                	cmp    %eax,%edx
  802b6e:	73 68                	jae    802bd8 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802b70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b74:	75 17                	jne    802b8d <insert_sorted_with_merge_freeList+0xc1>
  802b76:	83 ec 04             	sub    $0x4,%esp
  802b79:	68 70 3c 80 00       	push   $0x803c70
  802b7e:	68 3a 01 00 00       	push   $0x13a
  802b83:	68 57 3c 80 00       	push   $0x803c57
  802b88:	e8 65 d9 ff ff       	call   8004f2 <_panic>
  802b8d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b93:	8b 45 08             	mov    0x8(%ebp),%eax
  802b96:	89 50 04             	mov    %edx,0x4(%eax)
  802b99:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9c:	8b 40 04             	mov    0x4(%eax),%eax
  802b9f:	85 c0                	test   %eax,%eax
  802ba1:	74 0c                	je     802baf <insert_sorted_with_merge_freeList+0xe3>
  802ba3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ba8:	8b 55 08             	mov    0x8(%ebp),%edx
  802bab:	89 10                	mov    %edx,(%eax)
  802bad:	eb 08                	jmp    802bb7 <insert_sorted_with_merge_freeList+0xeb>
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	a3 38 41 80 00       	mov    %eax,0x804138
  802bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bba:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc8:	a1 44 41 80 00       	mov    0x804144,%eax
  802bcd:	40                   	inc    %eax
  802bce:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802bd3:	e9 3a 06 00 00       	jmp    803212 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdb:	8b 50 08             	mov    0x8(%eax),%edx
  802bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be1:	8b 40 0c             	mov    0xc(%eax),%eax
  802be4:	01 c2                	add    %eax,%edx
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	8b 40 08             	mov    0x8(%eax),%eax
  802bec:	39 c2                	cmp    %eax,%edx
  802bee:	0f 85 90 00 00 00    	jne    802c84 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf7:	8b 50 0c             	mov    0xc(%eax),%edx
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802c00:	01 c2                	add    %eax,%edx
  802c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c05:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c20:	75 17                	jne    802c39 <insert_sorted_with_merge_freeList+0x16d>
  802c22:	83 ec 04             	sub    $0x4,%esp
  802c25:	68 34 3c 80 00       	push   $0x803c34
  802c2a:	68 41 01 00 00       	push   $0x141
  802c2f:	68 57 3c 80 00       	push   $0x803c57
  802c34:	e8 b9 d8 ff ff       	call   8004f2 <_panic>
  802c39:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	89 10                	mov    %edx,(%eax)
  802c44:	8b 45 08             	mov    0x8(%ebp),%eax
  802c47:	8b 00                	mov    (%eax),%eax
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	74 0d                	je     802c5a <insert_sorted_with_merge_freeList+0x18e>
  802c4d:	a1 48 41 80 00       	mov    0x804148,%eax
  802c52:	8b 55 08             	mov    0x8(%ebp),%edx
  802c55:	89 50 04             	mov    %edx,0x4(%eax)
  802c58:	eb 08                	jmp    802c62 <insert_sorted_with_merge_freeList+0x196>
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c62:	8b 45 08             	mov    0x8(%ebp),%eax
  802c65:	a3 48 41 80 00       	mov    %eax,0x804148
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c74:	a1 54 41 80 00       	mov    0x804154,%eax
  802c79:	40                   	inc    %eax
  802c7a:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802c7f:	e9 8e 05 00 00       	jmp    803212 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	8b 50 08             	mov    0x8(%eax),%edx
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c90:	01 c2                	add    %eax,%edx
  802c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c95:	8b 40 08             	mov    0x8(%eax),%eax
  802c98:	39 c2                	cmp    %eax,%edx
  802c9a:	73 68                	jae    802d04 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca0:	75 17                	jne    802cb9 <insert_sorted_with_merge_freeList+0x1ed>
  802ca2:	83 ec 04             	sub    $0x4,%esp
  802ca5:	68 34 3c 80 00       	push   $0x803c34
  802caa:	68 45 01 00 00       	push   $0x145
  802caf:	68 57 3c 80 00       	push   $0x803c57
  802cb4:	e8 39 d8 ff ff       	call   8004f2 <_panic>
  802cb9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc2:	89 10                	mov    %edx,(%eax)
  802cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc7:	8b 00                	mov    (%eax),%eax
  802cc9:	85 c0                	test   %eax,%eax
  802ccb:	74 0d                	je     802cda <insert_sorted_with_merge_freeList+0x20e>
  802ccd:	a1 38 41 80 00       	mov    0x804138,%eax
  802cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd5:	89 50 04             	mov    %edx,0x4(%eax)
  802cd8:	eb 08                	jmp    802ce2 <insert_sorted_with_merge_freeList+0x216>
  802cda:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	a3 38 41 80 00       	mov    %eax,0x804138
  802cea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ced:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf4:	a1 44 41 80 00       	mov    0x804144,%eax
  802cf9:	40                   	inc    %eax
  802cfa:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802cff:	e9 0e 05 00 00       	jmp    803212 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	8b 50 08             	mov    0x8(%eax),%edx
  802d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d10:	01 c2                	add    %eax,%edx
  802d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d15:	8b 40 08             	mov    0x8(%eax),%eax
  802d18:	39 c2                	cmp    %eax,%edx
  802d1a:	0f 85 9c 00 00 00    	jne    802dbc <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d23:	8b 50 0c             	mov    0xc(%eax),%edx
  802d26:	8b 45 08             	mov    0x8(%ebp),%eax
  802d29:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2c:	01 c2                	add    %eax,%edx
  802d2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d31:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802d34:	8b 45 08             	mov    0x8(%ebp),%eax
  802d37:	8b 50 08             	mov    0x8(%eax),%edx
  802d3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3d:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d58:	75 17                	jne    802d71 <insert_sorted_with_merge_freeList+0x2a5>
  802d5a:	83 ec 04             	sub    $0x4,%esp
  802d5d:	68 34 3c 80 00       	push   $0x803c34
  802d62:	68 4d 01 00 00       	push   $0x14d
  802d67:	68 57 3c 80 00       	push   $0x803c57
  802d6c:	e8 81 d7 ff ff       	call   8004f2 <_panic>
  802d71:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	89 10                	mov    %edx,(%eax)
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	8b 00                	mov    (%eax),%eax
  802d81:	85 c0                	test   %eax,%eax
  802d83:	74 0d                	je     802d92 <insert_sorted_with_merge_freeList+0x2c6>
  802d85:	a1 48 41 80 00       	mov    0x804148,%eax
  802d8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d8d:	89 50 04             	mov    %edx,0x4(%eax)
  802d90:	eb 08                	jmp    802d9a <insert_sorted_with_merge_freeList+0x2ce>
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	a3 48 41 80 00       	mov    %eax,0x804148
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dac:	a1 54 41 80 00       	mov    0x804154,%eax
  802db1:	40                   	inc    %eax
  802db2:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802db7:	e9 56 04 00 00       	jmp    803212 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802dbc:	a1 38 41 80 00       	mov    0x804138,%eax
  802dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dc4:	e9 19 04 00 00       	jmp    8031e2 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 00                	mov    (%eax),%eax
  802dce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	8b 50 08             	mov    0x8(%eax),%edx
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddd:	01 c2                	add    %eax,%edx
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	8b 40 08             	mov    0x8(%eax),%eax
  802de5:	39 c2                	cmp    %eax,%edx
  802de7:	0f 85 ad 01 00 00    	jne    802f9a <insert_sorted_with_merge_freeList+0x4ce>
  802ded:	8b 45 08             	mov    0x8(%ebp),%eax
  802df0:	8b 50 08             	mov    0x8(%eax),%edx
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	8b 40 0c             	mov    0xc(%eax),%eax
  802df9:	01 c2                	add    %eax,%edx
  802dfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfe:	8b 40 08             	mov    0x8(%eax),%eax
  802e01:	39 c2                	cmp    %eax,%edx
  802e03:	0f 85 91 01 00 00    	jne    802f9a <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	8b 50 0c             	mov    0xc(%eax),%edx
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	8b 48 0c             	mov    0xc(%eax),%ecx
  802e15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e18:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1b:	01 c8                	add    %ecx,%eax
  802e1d:	01 c2                	add    %eax,%edx
  802e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e22:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802e39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802e43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e46:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802e4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e51:	75 17                	jne    802e6a <insert_sorted_with_merge_freeList+0x39e>
  802e53:	83 ec 04             	sub    $0x4,%esp
  802e56:	68 c8 3c 80 00       	push   $0x803cc8
  802e5b:	68 5b 01 00 00       	push   $0x15b
  802e60:	68 57 3c 80 00       	push   $0x803c57
  802e65:	e8 88 d6 ff ff       	call   8004f2 <_panic>
  802e6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6d:	8b 00                	mov    (%eax),%eax
  802e6f:	85 c0                	test   %eax,%eax
  802e71:	74 10                	je     802e83 <insert_sorted_with_merge_freeList+0x3b7>
  802e73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e76:	8b 00                	mov    (%eax),%eax
  802e78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e7b:	8b 52 04             	mov    0x4(%edx),%edx
  802e7e:	89 50 04             	mov    %edx,0x4(%eax)
  802e81:	eb 0b                	jmp    802e8e <insert_sorted_with_merge_freeList+0x3c2>
  802e83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e86:	8b 40 04             	mov    0x4(%eax),%eax
  802e89:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e91:	8b 40 04             	mov    0x4(%eax),%eax
  802e94:	85 c0                	test   %eax,%eax
  802e96:	74 0f                	je     802ea7 <insert_sorted_with_merge_freeList+0x3db>
  802e98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e9b:	8b 40 04             	mov    0x4(%eax),%eax
  802e9e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ea1:	8b 12                	mov    (%edx),%edx
  802ea3:	89 10                	mov    %edx,(%eax)
  802ea5:	eb 0a                	jmp    802eb1 <insert_sorted_with_merge_freeList+0x3e5>
  802ea7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eaa:	8b 00                	mov    (%eax),%eax
  802eac:	a3 38 41 80 00       	mov    %eax,0x804138
  802eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ebd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec4:	a1 44 41 80 00       	mov    0x804144,%eax
  802ec9:	48                   	dec    %eax
  802eca:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ecf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed3:	75 17                	jne    802eec <insert_sorted_with_merge_freeList+0x420>
  802ed5:	83 ec 04             	sub    $0x4,%esp
  802ed8:	68 34 3c 80 00       	push   $0x803c34
  802edd:	68 5c 01 00 00       	push   $0x15c
  802ee2:	68 57 3c 80 00       	push   $0x803c57
  802ee7:	e8 06 d6 ff ff       	call   8004f2 <_panic>
  802eec:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	89 10                	mov    %edx,(%eax)
  802ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  802efa:	8b 00                	mov    (%eax),%eax
  802efc:	85 c0                	test   %eax,%eax
  802efe:	74 0d                	je     802f0d <insert_sorted_with_merge_freeList+0x441>
  802f00:	a1 48 41 80 00       	mov    0x804148,%eax
  802f05:	8b 55 08             	mov    0x8(%ebp),%edx
  802f08:	89 50 04             	mov    %edx,0x4(%eax)
  802f0b:	eb 08                	jmp    802f15 <insert_sorted_with_merge_freeList+0x449>
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	a3 48 41 80 00       	mov    %eax,0x804148
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f27:	a1 54 41 80 00       	mov    0x804154,%eax
  802f2c:	40                   	inc    %eax
  802f2d:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802f32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f36:	75 17                	jne    802f4f <insert_sorted_with_merge_freeList+0x483>
  802f38:	83 ec 04             	sub    $0x4,%esp
  802f3b:	68 34 3c 80 00       	push   $0x803c34
  802f40:	68 5d 01 00 00       	push   $0x15d
  802f45:	68 57 3c 80 00       	push   $0x803c57
  802f4a:	e8 a3 d5 ff ff       	call   8004f2 <_panic>
  802f4f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f58:	89 10                	mov    %edx,(%eax)
  802f5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f5d:	8b 00                	mov    (%eax),%eax
  802f5f:	85 c0                	test   %eax,%eax
  802f61:	74 0d                	je     802f70 <insert_sorted_with_merge_freeList+0x4a4>
  802f63:	a1 48 41 80 00       	mov    0x804148,%eax
  802f68:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f6b:	89 50 04             	mov    %edx,0x4(%eax)
  802f6e:	eb 08                	jmp    802f78 <insert_sorted_with_merge_freeList+0x4ac>
  802f70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f73:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7b:	a3 48 41 80 00       	mov    %eax,0x804148
  802f80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8a:	a1 54 41 80 00       	mov    0x804154,%eax
  802f8f:	40                   	inc    %eax
  802f90:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802f95:	e9 78 02 00 00       	jmp    803212 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9d:	8b 50 08             	mov    0x8(%eax),%edx
  802fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa6:	01 c2                	add    %eax,%edx
  802fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fab:	8b 40 08             	mov    0x8(%eax),%eax
  802fae:	39 c2                	cmp    %eax,%edx
  802fb0:	0f 83 b8 00 00 00    	jae    80306e <insert_sorted_with_merge_freeList+0x5a2>
  802fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb9:	8b 50 08             	mov    0x8(%eax),%edx
  802fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc2:	01 c2                	add    %eax,%edx
  802fc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc7:	8b 40 08             	mov    0x8(%eax),%eax
  802fca:	39 c2                	cmp    %eax,%edx
  802fcc:	0f 85 9c 00 00 00    	jne    80306e <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802fd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd5:	8b 50 0c             	mov    0xc(%eax),%edx
  802fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdb:	8b 40 0c             	mov    0xc(%eax),%eax
  802fde:	01 c2                	add    %eax,%edx
  802fe0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe3:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe9:	8b 50 08             	mov    0x8(%eax),%edx
  802fec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fef:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803006:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300a:	75 17                	jne    803023 <insert_sorted_with_merge_freeList+0x557>
  80300c:	83 ec 04             	sub    $0x4,%esp
  80300f:	68 34 3c 80 00       	push   $0x803c34
  803014:	68 67 01 00 00       	push   $0x167
  803019:	68 57 3c 80 00       	push   $0x803c57
  80301e:	e8 cf d4 ff ff       	call   8004f2 <_panic>
  803023:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803029:	8b 45 08             	mov    0x8(%ebp),%eax
  80302c:	89 10                	mov    %edx,(%eax)
  80302e:	8b 45 08             	mov    0x8(%ebp),%eax
  803031:	8b 00                	mov    (%eax),%eax
  803033:	85 c0                	test   %eax,%eax
  803035:	74 0d                	je     803044 <insert_sorted_with_merge_freeList+0x578>
  803037:	a1 48 41 80 00       	mov    0x804148,%eax
  80303c:	8b 55 08             	mov    0x8(%ebp),%edx
  80303f:	89 50 04             	mov    %edx,0x4(%eax)
  803042:	eb 08                	jmp    80304c <insert_sorted_with_merge_freeList+0x580>
  803044:	8b 45 08             	mov    0x8(%ebp),%eax
  803047:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80304c:	8b 45 08             	mov    0x8(%ebp),%eax
  80304f:	a3 48 41 80 00       	mov    %eax,0x804148
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305e:	a1 54 41 80 00       	mov    0x804154,%eax
  803063:	40                   	inc    %eax
  803064:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  803069:	e9 a4 01 00 00       	jmp    803212 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	8b 50 08             	mov    0x8(%eax),%edx
  803074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803077:	8b 40 0c             	mov    0xc(%eax),%eax
  80307a:	01 c2                	add    %eax,%edx
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	8b 40 08             	mov    0x8(%eax),%eax
  803082:	39 c2                	cmp    %eax,%edx
  803084:	0f 85 ac 00 00 00    	jne    803136 <insert_sorted_with_merge_freeList+0x66a>
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	8b 50 08             	mov    0x8(%eax),%edx
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	8b 40 0c             	mov    0xc(%eax),%eax
  803096:	01 c2                	add    %eax,%edx
  803098:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80309b:	8b 40 08             	mov    0x8(%eax),%eax
  80309e:	39 c2                	cmp    %eax,%edx
  8030a0:	0f 83 90 00 00 00    	jae    803136 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  8030a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a9:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b2:	01 c2                	add    %eax,%edx
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d2:	75 17                	jne    8030eb <insert_sorted_with_merge_freeList+0x61f>
  8030d4:	83 ec 04             	sub    $0x4,%esp
  8030d7:	68 34 3c 80 00       	push   $0x803c34
  8030dc:	68 70 01 00 00       	push   $0x170
  8030e1:	68 57 3c 80 00       	push   $0x803c57
  8030e6:	e8 07 d4 ff ff       	call   8004f2 <_panic>
  8030eb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f4:	89 10                	mov    %edx,(%eax)
  8030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f9:	8b 00                	mov    (%eax),%eax
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	74 0d                	je     80310c <insert_sorted_with_merge_freeList+0x640>
  8030ff:	a1 48 41 80 00       	mov    0x804148,%eax
  803104:	8b 55 08             	mov    0x8(%ebp),%edx
  803107:	89 50 04             	mov    %edx,0x4(%eax)
  80310a:	eb 08                	jmp    803114 <insert_sorted_with_merge_freeList+0x648>
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	a3 48 41 80 00       	mov    %eax,0x804148
  80311c:	8b 45 08             	mov    0x8(%ebp),%eax
  80311f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803126:	a1 54 41 80 00       	mov    0x804154,%eax
  80312b:	40                   	inc    %eax
  80312c:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  803131:	e9 dc 00 00 00       	jmp    803212 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803139:	8b 50 08             	mov    0x8(%eax),%edx
  80313c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313f:	8b 40 0c             	mov    0xc(%eax),%eax
  803142:	01 c2                	add    %eax,%edx
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	8b 40 08             	mov    0x8(%eax),%eax
  80314a:	39 c2                	cmp    %eax,%edx
  80314c:	0f 83 88 00 00 00    	jae    8031da <insert_sorted_with_merge_freeList+0x70e>
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	8b 50 08             	mov    0x8(%eax),%edx
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	8b 40 0c             	mov    0xc(%eax),%eax
  80315e:	01 c2                	add    %eax,%edx
  803160:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803163:	8b 40 08             	mov    0x8(%eax),%eax
  803166:	39 c2                	cmp    %eax,%edx
  803168:	73 70                	jae    8031da <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  80316a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80316e:	74 06                	je     803176 <insert_sorted_with_merge_freeList+0x6aa>
  803170:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803174:	75 17                	jne    80318d <insert_sorted_with_merge_freeList+0x6c1>
  803176:	83 ec 04             	sub    $0x4,%esp
  803179:	68 94 3c 80 00       	push   $0x803c94
  80317e:	68 75 01 00 00       	push   $0x175
  803183:	68 57 3c 80 00       	push   $0x803c57
  803188:	e8 65 d3 ff ff       	call   8004f2 <_panic>
  80318d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803190:	8b 10                	mov    (%eax),%edx
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	89 10                	mov    %edx,(%eax)
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	8b 00                	mov    (%eax),%eax
  80319c:	85 c0                	test   %eax,%eax
  80319e:	74 0b                	je     8031ab <insert_sorted_with_merge_freeList+0x6df>
  8031a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a3:	8b 00                	mov    (%eax),%eax
  8031a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a8:	89 50 04             	mov    %edx,0x4(%eax)
  8031ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b1:	89 10                	mov    %edx,(%eax)
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031b9:	89 50 04             	mov    %edx,0x4(%eax)
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	8b 00                	mov    (%eax),%eax
  8031c1:	85 c0                	test   %eax,%eax
  8031c3:	75 08                	jne    8031cd <insert_sorted_with_merge_freeList+0x701>
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031cd:	a1 44 41 80 00       	mov    0x804144,%eax
  8031d2:	40                   	inc    %eax
  8031d3:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  8031d8:	eb 38                	jmp    803212 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8031da:	a1 40 41 80 00       	mov    0x804140,%eax
  8031df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e6:	74 07                	je     8031ef <insert_sorted_with_merge_freeList+0x723>
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	8b 00                	mov    (%eax),%eax
  8031ed:	eb 05                	jmp    8031f4 <insert_sorted_with_merge_freeList+0x728>
  8031ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8031f4:	a3 40 41 80 00       	mov    %eax,0x804140
  8031f9:	a1 40 41 80 00       	mov    0x804140,%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	0f 85 c3 fb ff ff    	jne    802dc9 <insert_sorted_with_merge_freeList+0x2fd>
  803206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80320a:	0f 85 b9 fb ff ff    	jne    802dc9 <insert_sorted_with_merge_freeList+0x2fd>





}
  803210:	eb 00                	jmp    803212 <insert_sorted_with_merge_freeList+0x746>
  803212:	90                   	nop
  803213:	c9                   	leave  
  803214:	c3                   	ret    
  803215:	66 90                	xchg   %ax,%ax
  803217:	90                   	nop

00803218 <__udivdi3>:
  803218:	55                   	push   %ebp
  803219:	57                   	push   %edi
  80321a:	56                   	push   %esi
  80321b:	53                   	push   %ebx
  80321c:	83 ec 1c             	sub    $0x1c,%esp
  80321f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803223:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803227:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80322b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80322f:	89 ca                	mov    %ecx,%edx
  803231:	89 f8                	mov    %edi,%eax
  803233:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803237:	85 f6                	test   %esi,%esi
  803239:	75 2d                	jne    803268 <__udivdi3+0x50>
  80323b:	39 cf                	cmp    %ecx,%edi
  80323d:	77 65                	ja     8032a4 <__udivdi3+0x8c>
  80323f:	89 fd                	mov    %edi,%ebp
  803241:	85 ff                	test   %edi,%edi
  803243:	75 0b                	jne    803250 <__udivdi3+0x38>
  803245:	b8 01 00 00 00       	mov    $0x1,%eax
  80324a:	31 d2                	xor    %edx,%edx
  80324c:	f7 f7                	div    %edi
  80324e:	89 c5                	mov    %eax,%ebp
  803250:	31 d2                	xor    %edx,%edx
  803252:	89 c8                	mov    %ecx,%eax
  803254:	f7 f5                	div    %ebp
  803256:	89 c1                	mov    %eax,%ecx
  803258:	89 d8                	mov    %ebx,%eax
  80325a:	f7 f5                	div    %ebp
  80325c:	89 cf                	mov    %ecx,%edi
  80325e:	89 fa                	mov    %edi,%edx
  803260:	83 c4 1c             	add    $0x1c,%esp
  803263:	5b                   	pop    %ebx
  803264:	5e                   	pop    %esi
  803265:	5f                   	pop    %edi
  803266:	5d                   	pop    %ebp
  803267:	c3                   	ret    
  803268:	39 ce                	cmp    %ecx,%esi
  80326a:	77 28                	ja     803294 <__udivdi3+0x7c>
  80326c:	0f bd fe             	bsr    %esi,%edi
  80326f:	83 f7 1f             	xor    $0x1f,%edi
  803272:	75 40                	jne    8032b4 <__udivdi3+0x9c>
  803274:	39 ce                	cmp    %ecx,%esi
  803276:	72 0a                	jb     803282 <__udivdi3+0x6a>
  803278:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80327c:	0f 87 9e 00 00 00    	ja     803320 <__udivdi3+0x108>
  803282:	b8 01 00 00 00       	mov    $0x1,%eax
  803287:	89 fa                	mov    %edi,%edx
  803289:	83 c4 1c             	add    $0x1c,%esp
  80328c:	5b                   	pop    %ebx
  80328d:	5e                   	pop    %esi
  80328e:	5f                   	pop    %edi
  80328f:	5d                   	pop    %ebp
  803290:	c3                   	ret    
  803291:	8d 76 00             	lea    0x0(%esi),%esi
  803294:	31 ff                	xor    %edi,%edi
  803296:	31 c0                	xor    %eax,%eax
  803298:	89 fa                	mov    %edi,%edx
  80329a:	83 c4 1c             	add    $0x1c,%esp
  80329d:	5b                   	pop    %ebx
  80329e:	5e                   	pop    %esi
  80329f:	5f                   	pop    %edi
  8032a0:	5d                   	pop    %ebp
  8032a1:	c3                   	ret    
  8032a2:	66 90                	xchg   %ax,%ax
  8032a4:	89 d8                	mov    %ebx,%eax
  8032a6:	f7 f7                	div    %edi
  8032a8:	31 ff                	xor    %edi,%edi
  8032aa:	89 fa                	mov    %edi,%edx
  8032ac:	83 c4 1c             	add    $0x1c,%esp
  8032af:	5b                   	pop    %ebx
  8032b0:	5e                   	pop    %esi
  8032b1:	5f                   	pop    %edi
  8032b2:	5d                   	pop    %ebp
  8032b3:	c3                   	ret    
  8032b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8032b9:	89 eb                	mov    %ebp,%ebx
  8032bb:	29 fb                	sub    %edi,%ebx
  8032bd:	89 f9                	mov    %edi,%ecx
  8032bf:	d3 e6                	shl    %cl,%esi
  8032c1:	89 c5                	mov    %eax,%ebp
  8032c3:	88 d9                	mov    %bl,%cl
  8032c5:	d3 ed                	shr    %cl,%ebp
  8032c7:	89 e9                	mov    %ebp,%ecx
  8032c9:	09 f1                	or     %esi,%ecx
  8032cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8032cf:	89 f9                	mov    %edi,%ecx
  8032d1:	d3 e0                	shl    %cl,%eax
  8032d3:	89 c5                	mov    %eax,%ebp
  8032d5:	89 d6                	mov    %edx,%esi
  8032d7:	88 d9                	mov    %bl,%cl
  8032d9:	d3 ee                	shr    %cl,%esi
  8032db:	89 f9                	mov    %edi,%ecx
  8032dd:	d3 e2                	shl    %cl,%edx
  8032df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032e3:	88 d9                	mov    %bl,%cl
  8032e5:	d3 e8                	shr    %cl,%eax
  8032e7:	09 c2                	or     %eax,%edx
  8032e9:	89 d0                	mov    %edx,%eax
  8032eb:	89 f2                	mov    %esi,%edx
  8032ed:	f7 74 24 0c          	divl   0xc(%esp)
  8032f1:	89 d6                	mov    %edx,%esi
  8032f3:	89 c3                	mov    %eax,%ebx
  8032f5:	f7 e5                	mul    %ebp
  8032f7:	39 d6                	cmp    %edx,%esi
  8032f9:	72 19                	jb     803314 <__udivdi3+0xfc>
  8032fb:	74 0b                	je     803308 <__udivdi3+0xf0>
  8032fd:	89 d8                	mov    %ebx,%eax
  8032ff:	31 ff                	xor    %edi,%edi
  803301:	e9 58 ff ff ff       	jmp    80325e <__udivdi3+0x46>
  803306:	66 90                	xchg   %ax,%ax
  803308:	8b 54 24 08          	mov    0x8(%esp),%edx
  80330c:	89 f9                	mov    %edi,%ecx
  80330e:	d3 e2                	shl    %cl,%edx
  803310:	39 c2                	cmp    %eax,%edx
  803312:	73 e9                	jae    8032fd <__udivdi3+0xe5>
  803314:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803317:	31 ff                	xor    %edi,%edi
  803319:	e9 40 ff ff ff       	jmp    80325e <__udivdi3+0x46>
  80331e:	66 90                	xchg   %ax,%ax
  803320:	31 c0                	xor    %eax,%eax
  803322:	e9 37 ff ff ff       	jmp    80325e <__udivdi3+0x46>
  803327:	90                   	nop

00803328 <__umoddi3>:
  803328:	55                   	push   %ebp
  803329:	57                   	push   %edi
  80332a:	56                   	push   %esi
  80332b:	53                   	push   %ebx
  80332c:	83 ec 1c             	sub    $0x1c,%esp
  80332f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803333:	8b 74 24 34          	mov    0x34(%esp),%esi
  803337:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80333b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80333f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803343:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803347:	89 f3                	mov    %esi,%ebx
  803349:	89 fa                	mov    %edi,%edx
  80334b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80334f:	89 34 24             	mov    %esi,(%esp)
  803352:	85 c0                	test   %eax,%eax
  803354:	75 1a                	jne    803370 <__umoddi3+0x48>
  803356:	39 f7                	cmp    %esi,%edi
  803358:	0f 86 a2 00 00 00    	jbe    803400 <__umoddi3+0xd8>
  80335e:	89 c8                	mov    %ecx,%eax
  803360:	89 f2                	mov    %esi,%edx
  803362:	f7 f7                	div    %edi
  803364:	89 d0                	mov    %edx,%eax
  803366:	31 d2                	xor    %edx,%edx
  803368:	83 c4 1c             	add    $0x1c,%esp
  80336b:	5b                   	pop    %ebx
  80336c:	5e                   	pop    %esi
  80336d:	5f                   	pop    %edi
  80336e:	5d                   	pop    %ebp
  80336f:	c3                   	ret    
  803370:	39 f0                	cmp    %esi,%eax
  803372:	0f 87 ac 00 00 00    	ja     803424 <__umoddi3+0xfc>
  803378:	0f bd e8             	bsr    %eax,%ebp
  80337b:	83 f5 1f             	xor    $0x1f,%ebp
  80337e:	0f 84 ac 00 00 00    	je     803430 <__umoddi3+0x108>
  803384:	bf 20 00 00 00       	mov    $0x20,%edi
  803389:	29 ef                	sub    %ebp,%edi
  80338b:	89 fe                	mov    %edi,%esi
  80338d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803391:	89 e9                	mov    %ebp,%ecx
  803393:	d3 e0                	shl    %cl,%eax
  803395:	89 d7                	mov    %edx,%edi
  803397:	89 f1                	mov    %esi,%ecx
  803399:	d3 ef                	shr    %cl,%edi
  80339b:	09 c7                	or     %eax,%edi
  80339d:	89 e9                	mov    %ebp,%ecx
  80339f:	d3 e2                	shl    %cl,%edx
  8033a1:	89 14 24             	mov    %edx,(%esp)
  8033a4:	89 d8                	mov    %ebx,%eax
  8033a6:	d3 e0                	shl    %cl,%eax
  8033a8:	89 c2                	mov    %eax,%edx
  8033aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033ae:	d3 e0                	shl    %cl,%eax
  8033b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033b8:	89 f1                	mov    %esi,%ecx
  8033ba:	d3 e8                	shr    %cl,%eax
  8033bc:	09 d0                	or     %edx,%eax
  8033be:	d3 eb                	shr    %cl,%ebx
  8033c0:	89 da                	mov    %ebx,%edx
  8033c2:	f7 f7                	div    %edi
  8033c4:	89 d3                	mov    %edx,%ebx
  8033c6:	f7 24 24             	mull   (%esp)
  8033c9:	89 c6                	mov    %eax,%esi
  8033cb:	89 d1                	mov    %edx,%ecx
  8033cd:	39 d3                	cmp    %edx,%ebx
  8033cf:	0f 82 87 00 00 00    	jb     80345c <__umoddi3+0x134>
  8033d5:	0f 84 91 00 00 00    	je     80346c <__umoddi3+0x144>
  8033db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8033df:	29 f2                	sub    %esi,%edx
  8033e1:	19 cb                	sbb    %ecx,%ebx
  8033e3:	89 d8                	mov    %ebx,%eax
  8033e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8033e9:	d3 e0                	shl    %cl,%eax
  8033eb:	89 e9                	mov    %ebp,%ecx
  8033ed:	d3 ea                	shr    %cl,%edx
  8033ef:	09 d0                	or     %edx,%eax
  8033f1:	89 e9                	mov    %ebp,%ecx
  8033f3:	d3 eb                	shr    %cl,%ebx
  8033f5:	89 da                	mov    %ebx,%edx
  8033f7:	83 c4 1c             	add    $0x1c,%esp
  8033fa:	5b                   	pop    %ebx
  8033fb:	5e                   	pop    %esi
  8033fc:	5f                   	pop    %edi
  8033fd:	5d                   	pop    %ebp
  8033fe:	c3                   	ret    
  8033ff:	90                   	nop
  803400:	89 fd                	mov    %edi,%ebp
  803402:	85 ff                	test   %edi,%edi
  803404:	75 0b                	jne    803411 <__umoddi3+0xe9>
  803406:	b8 01 00 00 00       	mov    $0x1,%eax
  80340b:	31 d2                	xor    %edx,%edx
  80340d:	f7 f7                	div    %edi
  80340f:	89 c5                	mov    %eax,%ebp
  803411:	89 f0                	mov    %esi,%eax
  803413:	31 d2                	xor    %edx,%edx
  803415:	f7 f5                	div    %ebp
  803417:	89 c8                	mov    %ecx,%eax
  803419:	f7 f5                	div    %ebp
  80341b:	89 d0                	mov    %edx,%eax
  80341d:	e9 44 ff ff ff       	jmp    803366 <__umoddi3+0x3e>
  803422:	66 90                	xchg   %ax,%ax
  803424:	89 c8                	mov    %ecx,%eax
  803426:	89 f2                	mov    %esi,%edx
  803428:	83 c4 1c             	add    $0x1c,%esp
  80342b:	5b                   	pop    %ebx
  80342c:	5e                   	pop    %esi
  80342d:	5f                   	pop    %edi
  80342e:	5d                   	pop    %ebp
  80342f:	c3                   	ret    
  803430:	3b 04 24             	cmp    (%esp),%eax
  803433:	72 06                	jb     80343b <__umoddi3+0x113>
  803435:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803439:	77 0f                	ja     80344a <__umoddi3+0x122>
  80343b:	89 f2                	mov    %esi,%edx
  80343d:	29 f9                	sub    %edi,%ecx
  80343f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803443:	89 14 24             	mov    %edx,(%esp)
  803446:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80344a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80344e:	8b 14 24             	mov    (%esp),%edx
  803451:	83 c4 1c             	add    $0x1c,%esp
  803454:	5b                   	pop    %ebx
  803455:	5e                   	pop    %esi
  803456:	5f                   	pop    %edi
  803457:	5d                   	pop    %ebp
  803458:	c3                   	ret    
  803459:	8d 76 00             	lea    0x0(%esi),%esi
  80345c:	2b 04 24             	sub    (%esp),%eax
  80345f:	19 fa                	sbb    %edi,%edx
  803461:	89 d1                	mov    %edx,%ecx
  803463:	89 c6                	mov    %eax,%esi
  803465:	e9 71 ff ff ff       	jmp    8033db <__umoddi3+0xb3>
  80346a:	66 90                	xchg   %ax,%ax
  80346c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803470:	72 ea                	jb     80345c <__umoddi3+0x134>
  803472:	89 d9                	mov    %ebx,%ecx
  803474:	e9 62 ff ff ff       	jmp    8033db <__umoddi3+0xb3>
