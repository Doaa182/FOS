
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 15 0b 00 00       	call   800b4b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec fc 01 00 00    	sub    $0x1fc,%esp
	int envID = sys_getenvid();
  800044:	e8 71 25 00 00       	call   8025ba <sys_getenvid>
  800049:	89 45 bc             	mov    %eax,-0x44(%ebp)

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************

	int numOfCustomers = 15;
  80004c:	c7 45 b8 0f 00 00 00 	movl   $0xf,-0x48(%ebp)
	int flight1Customers = 3;
  800053:	c7 45 b4 03 00 00 00 	movl   $0x3,-0x4c(%ebp)
	int flight2Customers = 8;
  80005a:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%ebp)
	int flight3Customers = 4;
  800061:	c7 45 ac 04 00 00 00 	movl   $0x4,-0x54(%ebp)

	int flight1NumOfTickets = 8;
  800068:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%ebp)
	int flight2NumOfTickets = 15;
  80006f:	c7 45 a4 0f 00 00 00 	movl   $0xf,-0x5c(%ebp)

	char _customers[] = "customers";
  800076:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  80007c:	bb b6 3f 80 00       	mov    $0x803fb6,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800094:	bb c0 3f 80 00       	mov    $0x803fc0,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  8000ac:	bb cc 3f 80 00       	mov    $0x803fcc,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8000c4:	bb db 3f 80 00       	mov    $0x803fdb,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8000dc:	bb ea 3f 80 00       	mov    $0x803fea,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8000f4:	bb ff 3f 80 00       	mov    $0x803fff,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  80010c:	bb 14 40 80 00       	mov    $0x804014,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800124:	bb 25 40 80 00       	mov    $0x804025,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80013c:	bb 36 40 80 00       	mov    $0x804036,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800154:	bb 47 40 80 00       	mov    $0x804047,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80016c:	bb 50 40 80 00       	mov    $0x804050,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800184:	bb 5a 40 80 00       	mov    $0x80405a,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  80019c:	bb 65 40 80 00       	mov    $0x804065,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8001b4:	bb 71 40 80 00       	mov    $0x804071,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8001cc:	bb 7b 40 80 00       	mov    $0x80407b,%ebx
  8001d1:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001d6:	89 c7                	mov    %eax,%edi
  8001d8:	89 de                	mov    %ebx,%esi
  8001da:	89 d1                	mov    %edx,%ecx
  8001dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001de:	c7 85 9f fe ff ff 63 	movl   $0x72656c63,-0x161(%ebp)
  8001e5:	6c 65 72 
  8001e8:	66 c7 85 a3 fe ff ff 	movw   $0x6b,-0x15d(%ebp)
  8001ef:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001f1:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8001f7:	bb 85 40 80 00       	mov    $0x804085,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  80020f:	bb 93 40 80 00       	mov    $0x804093,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800227:	bb a2 40 80 00       	mov    $0x8040a2,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80023f:	bb a9 40 80 00       	mov    $0x8040a9,%ebx
  800244:	ba 07 00 00 00       	mov    $0x7,%edx
  800249:	89 c7                	mov    %eax,%edi
  80024b:	89 de                	mov    %ebx,%esi
  80024d:	89 d1                	mov    %edx,%ecx
  80024f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*numOfCustomers, 1);
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	c1 e0 03             	shl    $0x3,%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	6a 01                	push   $0x1
  80025c:	50                   	push   %eax
  80025d:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	e8 c7 1d 00 00       	call   802030 <smalloc>
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
  80026f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for(;f1<flight1Customers; ++f1)
  800276:	eb 2e                	jmp    8002a6 <_main+0x26e>
		{
			custs[f1].booked = 0;
  800278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800282:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800285:	01 d0                	add    %edx,%eax
  800287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f1].flightType = 1;
  80028e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800291:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800298:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  8002a3:	ff 45 e4             	incl   -0x1c(%ebp)
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  8002ac:	7c ca                	jl     800278 <_main+0x240>
		{
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
  8002ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  8002b4:	eb 2e                	jmp    8002e4 <_main+0x2ac>
		{
			custs[f2].booked = 0;
  8002b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f2].flightType = 2;
  8002cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  8002e1:	ff 45 e0             	incl   -0x20(%ebp)
  8002e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002ef:	7f c5                	jg     8002b6 <_main+0x27e>
		{
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
  8002f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  8002f7:	eb 2e                	jmp    800327 <_main+0x2ef>
		{
			custs[f3].booked = 0;
  8002f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800303:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f3].flightType = 3;
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  800324:	ff 45 dc             	incl   -0x24(%ebp)
  800327:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80032a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	7f c5                	jg     8002f9 <_main+0x2c1>
			custs[f3].booked = 0;
			custs[f3].flightType = 3;
		}
	}

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	6a 01                	push   $0x1
  800339:	6a 04                	push   $0x4
  80033b:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800341:	50                   	push   %eax
  800342:	e8 e9 1c 00 00       	call   802030 <smalloc>
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	89 45 9c             	mov    %eax,-0x64(%ebp)
	*custCounter = 0;
  80034d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	6a 01                	push   $0x1
  80035b:	6a 04                	push   $0x4
  80035d:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  800363:	50                   	push   %eax
  800364:	e8 c7 1c 00 00       	call   802030 <smalloc>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	89 45 98             	mov    %eax,-0x68(%ebp)
	*flight1Counter = flight1NumOfTickets;
  80036f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800372:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800375:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	6a 01                	push   $0x1
  80037c:	6a 04                	push   $0x4
  80037e:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800384:	50                   	push   %eax
  800385:	e8 a6 1c 00 00       	call   802030 <smalloc>
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	89 45 94             	mov    %eax,-0x6c(%ebp)
	*flight2Counter = flight2NumOfTickets;
  800390:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800393:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800396:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	6a 01                	push   $0x1
  80039d:	6a 04                	push   $0x4
  80039f:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	e8 85 1c 00 00       	call   802030 <smalloc>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	89 45 90             	mov    %eax,-0x70(%ebp)
	*flight1BookedCounter = 0;
  8003b1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	6a 01                	push   $0x1
  8003bf:	6a 04                	push   $0x4
  8003c1:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 63 1c 00 00       	call   802030 <smalloc>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 8c             	mov    %eax,-0x74(%ebp)
	*flight2BookedCounter = 0;
  8003d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  8003dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003df:	c1 e0 02             	shl    $0x2,%eax
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	6a 01                	push   $0x1
  8003e7:	50                   	push   %eax
  8003e8:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  8003ee:	50                   	push   %eax
  8003ef:	e8 3c 1c 00 00       	call   802030 <smalloc>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 45 88             	mov    %eax,-0x78(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  8003fa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fd:	c1 e0 02             	shl    $0x2,%eax
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	6a 01                	push   $0x1
  800405:	50                   	push   %eax
  800406:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	e8 1e 1c 00 00       	call   802030 <smalloc>
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	89 45 84             	mov    %eax,-0x7c(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*numOfCustomers, 1);
  800418:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80041b:	c1 e0 02             	shl    $0x2,%eax
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	6a 01                	push   $0x1
  800423:	50                   	push   %eax
  800424:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80042a:	50                   	push   %eax
  80042b:	e8 00 1c 00 00       	call   802030 <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 e7 1b 00 00       	call   802030 <smalloc>
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*queue_in = 0;
  800452:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	6a 01                	push   $0x1
  800463:	6a 04                	push   $0x4
  800465:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80046b:	50                   	push   %eax
  80046c:	e8 bf 1b 00 00       	call   802030 <smalloc>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*queue_out = 0;
  80047a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************
	sys_createSemaphore(_flight1CS, 1);
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	6a 01                	push   $0x1
  80048b:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  800491:	50                   	push   %eax
  800492:	e8 bd 1f 00 00       	call   802454 <sys_createSemaphore>
  800497:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_flight2CS, 1);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	6a 01                	push   $0x1
  80049f:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8004a5:	50                   	push   %eax
  8004a6:	e8 a9 1f 00 00       	call   802454 <sys_createSemaphore>
  8004ab:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custCounterCS, 1);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	6a 01                	push   $0x1
  8004b3:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8004b9:	50                   	push   %eax
  8004ba:	e8 95 1f 00 00       	call   802454 <sys_createSemaphore>
  8004bf:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_custQueueCS, 1);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 81 1f 00 00       	call   802454 <sys_createSemaphore>
  8004d3:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_clerk, 3);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	6a 03                	push   $0x3
  8004db:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	e8 6d 1f 00 00       	call   802454 <sys_createSemaphore>
  8004e7:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_cust_ready, 0);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	6a 00                	push   $0x0
  8004ef:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 59 1f 00 00       	call   802454 <sys_createSemaphore>
  8004fb:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custTerminated, 0);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	6a 00                	push   $0x0
  800503:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800509:	50                   	push   %eax
  80050a:	e8 45 1f 00 00       	call   802454 <sys_createSemaphore>
  80050f:	83 c4 10             	add    $0x10,%esp

	int s=0;
  800512:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800519:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800520:	eb 78                	jmp    80059a <_main+0x562>
	{
		char prefix[30]="cust_finished";
  800522:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  800528:	bb b0 40 80 00       	mov    $0x8040b0,%ebx
  80052d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800532:	89 c7                	mov    %eax,%edi
  800534:	89 de                	mov    %ebx,%esi
  800536:	89 d1                	mov    %edx,%ecx
  800538:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80053a:	8d 95 64 fe ff ff    	lea    -0x19c(%ebp),%edx
  800540:	b9 04 00 00 00       	mov    $0x4,%ecx
  800545:	b8 00 00 00 00       	mov    $0x0,%eax
  80054a:	89 d7                	mov    %edx,%edi
  80054c:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800557:	50                   	push   %eax
  800558:	ff 75 d8             	pushl  -0x28(%ebp)
  80055b:	e8 03 15 00 00       	call   801a63 <ltostr>
  800560:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  800563:	83 ec 04             	sub    $0x4,%esp
  800566:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80056c:	50                   	push   %eax
  80056d:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800573:	50                   	push   %eax
  800574:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	e8 db 15 00 00       	call   801b5b <strcconcat>
  800580:	83 c4 10             	add    $0x10,%esp
		sys_createSemaphore(sname, 0);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	6a 00                	push   $0x0
  800588:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80058e:	50                   	push   %eax
  80058f:	e8 c0 1e 00 00       	call   802454 <sys_createSemaphore>
  800594:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_cust_ready, 0);

	sys_createSemaphore(_custTerminated, 0);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  800597:	ff 45 d8             	incl   -0x28(%ebp)
  80059a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80059d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8005a0:	7c 80                	jl     800522 <_main+0x4ea>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//3 clerks
	uint32 envId;
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8005a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005a7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8005b8:	89 c1                	mov    %eax,%ecx
  8005ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bf:	8b 40 74             	mov    0x74(%eax),%eax
  8005c2:	52                   	push   %edx
  8005c3:	51                   	push   %ecx
  8005c4:	50                   	push   %eax
  8005c5:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  8005cb:	50                   	push   %eax
  8005cc:	e8 94 1f 00 00       	call   802565 <sys_create_env>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  8005da:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 9a 1f 00 00       	call   802583 <sys_run_env>
  8005e9:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8005ec:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f1:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8005fc:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800602:	89 c1                	mov    %eax,%ecx
  800604:	a1 20 50 80 00       	mov    0x805020,%eax
  800609:	8b 40 74             	mov    0x74(%eax),%eax
  80060c:	52                   	push   %edx
  80060d:	51                   	push   %ecx
  80060e:	50                   	push   %eax
  80060f:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800615:	50                   	push   %eax
  800616:	e8 4a 1f 00 00       	call   802565 <sys_create_env>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  800624:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80062a:	83 ec 0c             	sub    $0xc,%esp
  80062d:	50                   	push   %eax
  80062e:	e8 50 1f 00 00       	call   802583 <sys_run_env>
  800633:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800636:	a1 20 50 80 00       	mov    0x805020,%eax
  80063b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800641:	a1 20 50 80 00       	mov    0x805020,%eax
  800646:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	a1 20 50 80 00       	mov    0x805020,%eax
  800653:	8b 40 74             	mov    0x74(%eax),%eax
  800656:	52                   	push   %edx
  800657:	51                   	push   %ecx
  800658:	50                   	push   %eax
  800659:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  80065f:	50                   	push   %eax
  800660:	e8 00 1f 00 00       	call   802565 <sys_create_env>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  80066e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800674:	83 ec 0c             	sub    $0xc,%esp
  800677:	50                   	push   %eax
  800678:	e8 06 1f 00 00       	call   802583 <sys_run_env>
  80067d:	83 c4 10             	add    $0x10,%esp

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800680:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800687:	eb 6d                	jmp    8006f6 <_main+0x6be>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800689:	a1 20 50 80 00       	mov    0x805020,%eax
  80068e:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800694:	a1 20 50 80 00       	mov    0x805020,%eax
  800699:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a6:	8b 40 74             	mov    0x74(%eax),%eax
  8006a9:	52                   	push   %edx
  8006aa:	51                   	push   %ecx
  8006ab:	50                   	push   %eax
  8006ac:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  8006b2:	50                   	push   %eax
  8006b3:	e8 ad 1e 00 00       	call   802565 <sys_create_env>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  8006c1:	83 bd 74 ff ff ff ef 	cmpl   $0xffffffef,-0x8c(%ebp)
  8006c8:	75 17                	jne    8006e1 <_main+0x6a9>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	68 e0 3c 80 00       	push   $0x803ce0
  8006d2:	68 95 00 00 00       	push   $0x95
  8006d7:	68 26 3d 80 00       	push   $0x803d26
  8006dc:	e8 a6 05 00 00       	call   800c87 <_panic>

		sys_run_env(envId);
  8006e1:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 93 1e 00 00       	call   802583 <sys_run_env>
  8006f0:	83 c4 10             	add    $0x10,%esp
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
	sys_run_env(envId);

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  8006f3:	ff 45 d4             	incl   -0x2c(%ebp)
  8006f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8006fc:	7c 8b                	jl     800689 <_main+0x651>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8006fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800705:	eb 18                	jmp    80071f <_main+0x6e7>
	{
		sys_waitSemaphore(envID, _custTerminated);
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800710:	50                   	push   %eax
  800711:	ff 75 bc             	pushl  -0x44(%ebp)
  800714:	e8 74 1d 00 00       	call   80248d <sys_waitSemaphore>
  800719:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  80071c:	ff 45 d4             	incl   -0x2c(%ebp)
  80071f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800722:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800725:	7c e0                	jl     800707 <_main+0x6cf>
	{
		sys_waitSemaphore(envID, _custTerminated);
	}

	env_sleep(1500);
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	68 dc 05 00 00       	push   $0x5dc
  80072f:	e8 76 32 00 00       	call   8039aa <env_sleep>
  800734:	83 c4 10             	add    $0x10,%esp

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800737:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80073e:	eb 45                	jmp    800785 <_main+0x74d>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  800740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800758:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80075b:	01 d0                	add    %edx,%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800762:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800769:	8b 45 88             	mov    -0x78(%ebp),%eax
  80076c:	01 c8                	add    %ecx,%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 ec 04             	sub    $0x4,%esp
  800773:	52                   	push   %edx
  800774:	50                   	push   %eax
  800775:	68 38 3d 80 00       	push   $0x803d38
  80077a:	e8 bc 07 00 00       	call   800f3b <cprintf>
  80077f:	83 c4 10             	add    $0x10,%esp

	env_sleep(1500);

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800782:	ff 45 d0             	incl   -0x30(%ebp)
  800785:	8b 45 90             	mov    -0x70(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80078d:	7f b1                	jg     800740 <_main+0x708>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  80078f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800796:	eb 45                	jmp    8007dd <_main+0x7a5>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800798:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80079b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007a2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007a5:	01 d0                	add    %edx,%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007b0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007b3:	01 d0                	add    %edx,%eax
  8007b5:	8b 10                	mov    (%eax),%edx
  8007b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007c1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007c4:	01 c8                	add    %ecx,%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 ec 04             	sub    $0x4,%esp
  8007cb:	52                   	push   %edx
  8007cc:	50                   	push   %eax
  8007cd:	68 68 3d 80 00       	push   $0x803d68
  8007d2:	e8 64 07 00 00       	call   800f3b <cprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  8007da:	ff 45 d0             	incl   -0x30(%ebp)
  8007dd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8007e5:	7f b1                	jg     800798 <_main+0x760>
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
  8007e7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		for(;f1<flight1Customers; ++f1)
  8007ee:	eb 33                	jmp    800823 <_main+0x7eb>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f1) != 1)
  8007f0:	83 ec 04             	sub    $0x4,%esp
  8007f3:	ff 75 cc             	pushl  -0x34(%ebp)
  8007f6:	ff 75 a8             	pushl  -0x58(%ebp)
  8007f9:	ff 75 88             	pushl  -0x78(%ebp)
  8007fc:	e8 05 03 00 00       	call   800b06 <find>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	83 f8 01             	cmp    $0x1,%eax
  800807:	74 17                	je     800820 <_main+0x7e8>
			{
				panic("Error, wrong booking for user %d\n", f1);
  800809:	ff 75 cc             	pushl  -0x34(%ebp)
  80080c:	68 98 3d 80 00       	push   $0x803d98
  800811:	68 b5 00 00 00       	push   $0xb5
  800816:	68 26 3d 80 00       	push   $0x803d26
  80081b:	e8 67 04 00 00       	call   800c87 <_panic>
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  800820:	ff 45 cc             	incl   -0x34(%ebp)
  800823:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800826:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  800829:	7c c5                	jl     8007f0 <_main+0x7b8>
			{
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
  80082b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80082e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  800831:	eb 33                	jmp    800866 <_main+0x82e>
		{
			if(find(flight2BookedArr, flight2NumOfTickets, f2) != 1)
  800833:	83 ec 04             	sub    $0x4,%esp
  800836:	ff 75 c8             	pushl  -0x38(%ebp)
  800839:	ff 75 a4             	pushl  -0x5c(%ebp)
  80083c:	ff 75 84             	pushl  -0x7c(%ebp)
  80083f:	e8 c2 02 00 00       	call   800b06 <find>
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	83 f8 01             	cmp    $0x1,%eax
  80084a:	74 17                	je     800863 <_main+0x82b>
			{
				panic("Error, wrong booking for user %d\n", f2);
  80084c:	ff 75 c8             	pushl  -0x38(%ebp)
  80084f:	68 98 3d 80 00       	push   $0x803d98
  800854:	68 be 00 00 00       	push   $0xbe
  800859:	68 26 3d 80 00       	push   $0x803d26
  80085e:	e8 24 04 00 00       	call   800c87 <_panic>
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  800863:	ff 45 c8             	incl   -0x38(%ebp)
  800866:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800869:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80086c:	01 d0                	add    %edx,%eax
  80086e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800871:	7f c0                	jg     800833 <_main+0x7fb>
			{
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
  800873:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800876:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  800879:	eb 4c                	jmp    8008c7 <_main+0x88f>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f3) != 1 || find(flight2BookedArr, flight2NumOfTickets, f3) != 1)
  80087b:	83 ec 04             	sub    $0x4,%esp
  80087e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800881:	ff 75 a8             	pushl  -0x58(%ebp)
  800884:	ff 75 88             	pushl  -0x78(%ebp)
  800887:	e8 7a 02 00 00       	call   800b06 <find>
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	83 f8 01             	cmp    $0x1,%eax
  800892:	75 19                	jne    8008ad <_main+0x875>
  800894:	83 ec 04             	sub    $0x4,%esp
  800897:	ff 75 c4             	pushl  -0x3c(%ebp)
  80089a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80089d:	ff 75 84             	pushl  -0x7c(%ebp)
  8008a0:	e8 61 02 00 00       	call   800b06 <find>
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	83 f8 01             	cmp    $0x1,%eax
  8008ab:	74 17                	je     8008c4 <_main+0x88c>
			{
				panic("Error, wrong booking for user %d\n", f3);
  8008ad:	ff 75 c4             	pushl  -0x3c(%ebp)
  8008b0:	68 98 3d 80 00       	push   $0x803d98
  8008b5:	68 c7 00 00 00       	push   $0xc7
  8008ba:	68 26 3d 80 00       	push   $0x803d26
  8008bf:	e8 c3 03 00 00       	call   800c87 <_panic>
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  8008c4:	ff 45 c4             	incl   -0x3c(%ebp)
  8008c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8008ca:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8008cd:	01 d0                	add    %edx,%eax
  8008cf:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8008d2:	7f a7                	jg     80087b <_main+0x843>
			{
				panic("Error, wrong booking for user %d\n", f3);
			}
		}

		assert(sys_getSemaphoreValue(envID, _flight1CS) == 1);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8008dd:	50                   	push   %eax
  8008de:	ff 75 bc             	pushl  -0x44(%ebp)
  8008e1:	e8 8a 1b 00 00       	call   802470 <sys_getSemaphoreValue>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	83 f8 01             	cmp    $0x1,%eax
  8008ec:	74 19                	je     800907 <_main+0x8cf>
  8008ee:	68 bc 3d 80 00       	push   $0x803dbc
  8008f3:	68 ea 3d 80 00       	push   $0x803dea
  8008f8:	68 cb 00 00 00       	push   $0xcb
  8008fd:	68 26 3d 80 00       	push   $0x803d26
  800902:	e8 80 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _flight2CS) == 1);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	ff 75 bc             	pushl  -0x44(%ebp)
  800914:	e8 57 1b 00 00       	call   802470 <sys_getSemaphoreValue>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	83 f8 01             	cmp    $0x1,%eax
  80091f:	74 19                	je     80093a <_main+0x902>
  800921:	68 00 3e 80 00       	push   $0x803e00
  800926:	68 ea 3d 80 00       	push   $0x803dea
  80092b:	68 cc 00 00 00       	push   $0xcc
  800930:	68 26 3d 80 00       	push   $0x803d26
  800935:	e8 4d 03 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custCounterCS) ==  1);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	ff 75 bc             	pushl  -0x44(%ebp)
  800947:	e8 24 1b 00 00       	call   802470 <sys_getSemaphoreValue>
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	83 f8 01             	cmp    $0x1,%eax
  800952:	74 19                	je     80096d <_main+0x935>
  800954:	68 30 3e 80 00       	push   $0x803e30
  800959:	68 ea 3d 80 00       	push   $0x803dea
  80095e:	68 ce 00 00 00       	push   $0xce
  800963:	68 26 3d 80 00       	push   $0x803d26
  800968:	e8 1a 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _custQueueCS) ==  1);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  800976:	50                   	push   %eax
  800977:	ff 75 bc             	pushl  -0x44(%ebp)
  80097a:	e8 f1 1a 00 00       	call   802470 <sys_getSemaphoreValue>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	83 f8 01             	cmp    $0x1,%eax
  800985:	74 19                	je     8009a0 <_main+0x968>
  800987:	68 64 3e 80 00       	push   $0x803e64
  80098c:	68 ea 3d 80 00       	push   $0x803dea
  800991:	68 cf 00 00 00       	push   $0xcf
  800996:	68 26 3d 80 00       	push   $0x803d26
  80099b:	e8 e7 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _clerk) == 3);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	ff 75 bc             	pushl  -0x44(%ebp)
  8009ad:	e8 be 1a 00 00       	call   802470 <sys_getSemaphoreValue>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	83 f8 03             	cmp    $0x3,%eax
  8009b8:	74 19                	je     8009d3 <_main+0x99b>
  8009ba:	68 94 3e 80 00       	push   $0x803e94
  8009bf:	68 ea 3d 80 00       	push   $0x803dea
  8009c4:	68 d1 00 00 00       	push   $0xd1
  8009c9:	68 26 3d 80 00       	push   $0x803d26
  8009ce:	e8 b4 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8009e0:	e8 8b 1a 00 00       	call   802470 <sys_getSemaphoreValue>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8009eb:	74 19                	je     800a06 <_main+0x9ce>
  8009ed:	68 c0 3e 80 00       	push   $0x803ec0
  8009f2:	68 ea 3d 80 00       	push   $0x803dea
  8009f7:	68 d3 00 00 00       	push   $0xd3
  8009fc:	68 26 3d 80 00       	push   $0x803d26
  800a01:	e8 81 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	ff 75 bc             	pushl  -0x44(%ebp)
  800a13:	e8 58 1a 00 00       	call   802470 <sys_getSemaphoreValue>
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	74 19                	je     800a38 <_main+0xa00>
  800a1f:	68 f0 3e 80 00       	push   $0x803ef0
  800a24:	68 ea 3d 80 00       	push   $0x803dea
  800a29:	68 d5 00 00 00       	push   $0xd5
  800a2e:	68 26 3d 80 00       	push   $0x803d26
  800a33:	e8 4f 02 00 00       	call   800c87 <_panic>

		int s=0;
  800a38:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800a3f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800a46:	e9 96 00 00 00       	jmp    800ae1 <_main+0xaa9>
		{
			char prefix[30]="cust_finished";
  800a4b:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800a51:	bb b0 40 80 00       	mov    $0x8040b0,%ebx
  800a56:	ba 0e 00 00 00       	mov    $0xe,%edx
  800a5b:	89 c7                	mov    %eax,%edi
  800a5d:	89 de                	mov    %ebx,%esi
  800a5f:	89 d1                	mov    %edx,%ecx
  800a61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800a63:	8d 95 41 fe ff ff    	lea    -0x1bf(%ebp),%edx
  800a69:	b9 04 00 00 00       	mov    $0x4,%ecx
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a73:	89 d7                	mov    %edx,%edi
  800a75:	f3 ab                	rep stos %eax,%es:(%edi)
			char id[5]; char cust_finishedSemaphoreName[50];
			ltostr(s, id);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a80:	50                   	push   %eax
  800a81:	ff 75 c0             	pushl  -0x40(%ebp)
  800a84:	e8 da 0f 00 00       	call   801a63 <ltostr>
  800a89:	83 c4 10             	add    $0x10,%esp
			strcconcat(prefix, id, cust_finishedSemaphoreName);
  800a8c:	83 ec 04             	sub    $0x4,%esp
  800a8f:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800a95:	50                   	push   %eax
  800a96:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a9c:	50                   	push   %eax
  800a9d:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800aa3:	50                   	push   %eax
  800aa4:	e8 b2 10 00 00       	call   801b5b <strcconcat>
  800aa9:	83 c4 10             	add    $0x10,%esp
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 bc             	pushl  -0x44(%ebp)
  800ab9:	e8 b2 19 00 00       	call   802470 <sys_getSemaphoreValue>
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	74 19                	je     800ade <_main+0xaa6>
  800ac5:	68 24 3f 80 00       	push   $0x803f24
  800aca:	68 ea 3d 80 00       	push   $0x803dea
  800acf:	68 de 00 00 00       	push   $0xde
  800ad4:	68 26 3d 80 00       	push   $0x803d26
  800ad9:	e8 a9 01 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800ade:	ff 45 c0             	incl   -0x40(%ebp)
  800ae1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ae4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800ae7:	0f 8c 5e ff ff ff    	jl     800a4b <_main+0xa13>
			ltostr(s, id);
			strcconcat(prefix, id, cust_finishedSemaphoreName);
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
		}

		cprintf("Congratulations, All reservations are successfully done... have a nice flight :)\n");
  800aed:	83 ec 0c             	sub    $0xc,%esp
  800af0:	68 64 3f 80 00       	push   $0x803f64
  800af5:	e8 41 04 00 00       	call   800f3b <cprintf>
  800afa:	83 c4 10             	add    $0x10,%esp
	}

}
  800afd:	90                   	nop
  800afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <find>:


int find(int* arr, int size, int val)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800b0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800b13:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800b1a:	eb 22                	jmp    800b3e <find+0x38>
	{
		if(arr[i] == val)
  800b1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	01 d0                	add    %edx,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b30:	75 09                	jne    800b3b <find+0x35>
		{
			result = 1;
  800b32:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800b39:	eb 0b                	jmp    800b46 <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800b3b:	ff 45 f8             	incl   -0x8(%ebp)
  800b3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b41:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b44:	7c d6                	jl     800b1c <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b51:	e8 7d 1a 00 00       	call   8025d3 <sys_getenvindex>
  800b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5c:	89 d0                	mov    %edx,%eax
  800b5e:	c1 e0 03             	shl    $0x3,%eax
  800b61:	01 d0                	add    %edx,%eax
  800b63:	01 c0                	add    %eax,%eax
  800b65:	01 d0                	add    %edx,%eax
  800b67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b6e:	01 d0                	add    %edx,%eax
  800b70:	c1 e0 04             	shl    $0x4,%eax
  800b73:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b78:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b7d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b82:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800b88:	84 c0                	test   %al,%al
  800b8a:	74 0f                	je     800b9b <libmain+0x50>
		binaryname = myEnv->prog_name;
  800b8c:	a1 20 50 80 00       	mov    0x805020,%eax
  800b91:	05 5c 05 00 00       	add    $0x55c,%eax
  800b96:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b9f:	7e 0a                	jle    800bab <libmain+0x60>
		binaryname = argv[0];
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	ff 75 0c             	pushl  0xc(%ebp)
  800bb1:	ff 75 08             	pushl  0x8(%ebp)
  800bb4:	e8 7f f4 ff ff       	call   800038 <_main>
  800bb9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bbc:	e8 1f 18 00 00       	call   8023e0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 e8 40 80 00       	push   $0x8040e8
  800bc9:	e8 6d 03 00 00       	call   800f3b <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bd1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800bdc:	a1 20 50 80 00       	mov    0x805020,%eax
  800be1:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800be7:	83 ec 04             	sub    $0x4,%esp
  800bea:	52                   	push   %edx
  800beb:	50                   	push   %eax
  800bec:	68 10 41 80 00       	push   $0x804110
  800bf1:	e8 45 03 00 00       	call   800f3b <cprintf>
  800bf6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bf9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bfe:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800c04:	a1 20 50 80 00       	mov    0x805020,%eax
  800c09:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800c0f:	a1 20 50 80 00       	mov    0x805020,%eax
  800c14:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800c1a:	51                   	push   %ecx
  800c1b:	52                   	push   %edx
  800c1c:	50                   	push   %eax
  800c1d:	68 38 41 80 00       	push   $0x804138
  800c22:	e8 14 03 00 00       	call   800f3b <cprintf>
  800c27:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c2a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	50                   	push   %eax
  800c39:	68 90 41 80 00       	push   $0x804190
  800c3e:	e8 f8 02 00 00       	call   800f3b <cprintf>
  800c43:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c46:	83 ec 0c             	sub    $0xc,%esp
  800c49:	68 e8 40 80 00       	push   $0x8040e8
  800c4e:	e8 e8 02 00 00       	call   800f3b <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c56:	e8 9f 17 00 00       	call   8023fa <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c5b:	e8 19 00 00 00       	call   800c79 <exit>
}
  800c60:	90                   	nop
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	6a 00                	push   $0x0
  800c6e:	e8 2c 19 00 00       	call   80259f <sys_destroy_env>
  800c73:	83 c4 10             	add    $0x10,%esp
}
  800c76:	90                   	nop
  800c77:	c9                   	leave  
  800c78:	c3                   	ret    

00800c79 <exit>:

void
exit(void)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c7f:	e8 81 19 00 00       	call   802605 <sys_exit_env>
}
  800c84:	90                   	nop
  800c85:	c9                   	leave  
  800c86:	c3                   	ret    

00800c87 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c8d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c90:	83 c0 04             	add    $0x4,%eax
  800c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c96:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	74 16                	je     800cb5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c9f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ca4:	83 ec 08             	sub    $0x8,%esp
  800ca7:	50                   	push   %eax
  800ca8:	68 a4 41 80 00       	push   $0x8041a4
  800cad:	e8 89 02 00 00       	call   800f3b <cprintf>
  800cb2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cb5:	a1 00 50 80 00       	mov    0x805000,%eax
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	68 a9 41 80 00       	push   $0x8041a9
  800cc6:	e8 70 02 00 00       	call   800f3b <cprintf>
  800ccb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cce:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd7:	50                   	push   %eax
  800cd8:	e8 f3 01 00 00       	call   800ed0 <vcprintf>
  800cdd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ce0:	83 ec 08             	sub    $0x8,%esp
  800ce3:	6a 00                	push   $0x0
  800ce5:	68 c5 41 80 00       	push   $0x8041c5
  800cea:	e8 e1 01 00 00       	call   800ed0 <vcprintf>
  800cef:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800cf2:	e8 82 ff ff ff       	call   800c79 <exit>

	// should not return here
	while (1) ;
  800cf7:	eb fe                	jmp    800cf7 <_panic+0x70>

00800cf9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cff:	a1 20 50 80 00       	mov    0x805020,%eax
  800d04:	8b 50 74             	mov    0x74(%eax),%edx
  800d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0a:	39 c2                	cmp    %eax,%edx
  800d0c:	74 14                	je     800d22 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d0e:	83 ec 04             	sub    $0x4,%esp
  800d11:	68 c8 41 80 00       	push   $0x8041c8
  800d16:	6a 26                	push   $0x26
  800d18:	68 14 42 80 00       	push   $0x804214
  800d1d:	e8 65 ff ff ff       	call   800c87 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d30:	e9 c2 00 00 00       	jmp    800df7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d38:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	01 d0                	add    %edx,%eax
  800d44:	8b 00                	mov    (%eax),%eax
  800d46:	85 c0                	test   %eax,%eax
  800d48:	75 08                	jne    800d52 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d4a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d4d:	e9 a2 00 00 00       	jmp    800df4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d52:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d59:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d60:	eb 69                	jmp    800dcb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d62:	a1 20 50 80 00       	mov    0x805020,%eax
  800d67:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d70:	89 d0                	mov    %edx,%eax
  800d72:	01 c0                	add    %eax,%eax
  800d74:	01 d0                	add    %edx,%eax
  800d76:	c1 e0 03             	shl    $0x3,%eax
  800d79:	01 c8                	add    %ecx,%eax
  800d7b:	8a 40 04             	mov    0x4(%eax),%al
  800d7e:	84 c0                	test   %al,%al
  800d80:	75 46                	jne    800dc8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d82:	a1 20 50 80 00       	mov    0x805020,%eax
  800d87:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d90:	89 d0                	mov    %edx,%eax
  800d92:	01 c0                	add    %eax,%eax
  800d94:	01 d0                	add    %edx,%eax
  800d96:	c1 e0 03             	shl    $0x3,%eax
  800d99:	01 c8                	add    %ecx,%eax
  800d9b:	8b 00                	mov    (%eax),%eax
  800d9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800da0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800da3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800da8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	01 c8                	add    %ecx,%eax
  800db9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	75 09                	jne    800dc8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800dbf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800dc6:	eb 12                	jmp    800dda <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc8:	ff 45 e8             	incl   -0x18(%ebp)
  800dcb:	a1 20 50 80 00       	mov    0x805020,%eax
  800dd0:	8b 50 74             	mov    0x74(%eax),%edx
  800dd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dd6:	39 c2                	cmp    %eax,%edx
  800dd8:	77 88                	ja     800d62 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dda:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dde:	75 14                	jne    800df4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	68 20 42 80 00       	push   $0x804220
  800de8:	6a 3a                	push   $0x3a
  800dea:	68 14 42 80 00       	push   $0x804214
  800def:	e8 93 fe ff ff       	call   800c87 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800df4:	ff 45 f0             	incl   -0x10(%ebp)
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dfd:	0f 8c 32 ff ff ff    	jl     800d35 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e03:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e0a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e11:	eb 26                	jmp    800e39 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e13:	a1 20 50 80 00       	mov    0x805020,%eax
  800e18:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e21:	89 d0                	mov    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	01 d0                	add    %edx,%eax
  800e27:	c1 e0 03             	shl    $0x3,%eax
  800e2a:	01 c8                	add    %ecx,%eax
  800e2c:	8a 40 04             	mov    0x4(%eax),%al
  800e2f:	3c 01                	cmp    $0x1,%al
  800e31:	75 03                	jne    800e36 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800e33:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e36:	ff 45 e0             	incl   -0x20(%ebp)
  800e39:	a1 20 50 80 00       	mov    0x805020,%eax
  800e3e:	8b 50 74             	mov    0x74(%eax),%edx
  800e41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e44:	39 c2                	cmp    %eax,%edx
  800e46:	77 cb                	ja     800e13 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e4e:	74 14                	je     800e64 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e50:	83 ec 04             	sub    $0x4,%esp
  800e53:	68 74 42 80 00       	push   $0x804274
  800e58:	6a 44                	push   $0x44
  800e5a:	68 14 42 80 00       	push   $0x804214
  800e5f:	e8 23 fe ff ff       	call   800c87 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e64:	90                   	nop
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	8b 00                	mov    (%eax),%eax
  800e72:	8d 48 01             	lea    0x1(%eax),%ecx
  800e75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e78:	89 0a                	mov    %ecx,(%edx)
  800e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7d:	88 d1                	mov    %dl,%cl
  800e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e82:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	8b 00                	mov    (%eax),%eax
  800e8b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e90:	75 2c                	jne    800ebe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e92:	a0 24 50 80 00       	mov    0x805024,%al
  800e97:	0f b6 c0             	movzbl %al,%eax
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	8b 12                	mov    (%edx),%edx
  800e9f:	89 d1                	mov    %edx,%ecx
  800ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea4:	83 c2 08             	add    $0x8,%edx
  800ea7:	83 ec 04             	sub    $0x4,%esp
  800eaa:	50                   	push   %eax
  800eab:	51                   	push   %ecx
  800eac:	52                   	push   %edx
  800ead:	e8 80 13 00 00       	call   802232 <sys_cputs>
  800eb2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	8b 40 04             	mov    0x4(%eax),%eax
  800ec4:	8d 50 01             	lea    0x1(%eax),%edx
  800ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eca:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ecd:	90                   	nop
  800ece:	c9                   	leave  
  800ecf:	c3                   	ret    

00800ed0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ed9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ee0:	00 00 00 
	b.cnt = 0;
  800ee3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800eea:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	ff 75 08             	pushl  0x8(%ebp)
  800ef3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	68 67 0e 80 00       	push   $0x800e67
  800eff:	e8 11 02 00 00       	call   801115 <vprintfmt>
  800f04:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f07:	a0 24 50 80 00       	mov    0x805024,%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f15:	83 ec 04             	sub    $0x4,%esp
  800f18:	50                   	push   %eax
  800f19:	52                   	push   %edx
  800f1a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f20:	83 c0 08             	add    $0x8,%eax
  800f23:	50                   	push   %eax
  800f24:	e8 09 13 00 00       	call   802232 <sys_cputs>
  800f29:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f2c:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800f33:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <cprintf>:

int cprintf(const char *fmt, ...) {
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f41:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f48:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	83 ec 08             	sub    $0x8,%esp
  800f54:	ff 75 f4             	pushl  -0xc(%ebp)
  800f57:	50                   	push   %eax
  800f58:	e8 73 ff ff ff       	call   800ed0 <vcprintf>
  800f5d:	83 c4 10             	add    $0x10,%esp
  800f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f6e:	e8 6d 14 00 00       	call   8023e0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f73:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	83 ec 08             	sub    $0x8,%esp
  800f7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f82:	50                   	push   %eax
  800f83:	e8 48 ff ff ff       	call   800ed0 <vcprintf>
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f8e:	e8 67 14 00 00       	call   8023fa <sys_enable_interrupt>
	return cnt;
  800f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    

00800f98 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	53                   	push   %ebx
  800f9c:	83 ec 14             	sub    $0x14,%esp
  800f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fab:	8b 45 18             	mov    0x18(%ebp),%eax
  800fae:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fb6:	77 55                	ja     80100d <printnum+0x75>
  800fb8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fbb:	72 05                	jb     800fc2 <printnum+0x2a>
  800fbd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fc0:	77 4b                	ja     80100d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fc2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fc8:	8b 45 18             	mov    0x18(%ebp),%eax
  800fcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd0:	52                   	push   %edx
  800fd1:	50                   	push   %eax
  800fd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd5:	ff 75 f0             	pushl  -0x10(%ebp)
  800fd8:	e8 83 2a 00 00       	call   803a60 <__udivdi3>
  800fdd:	83 c4 10             	add    $0x10,%esp
  800fe0:	83 ec 04             	sub    $0x4,%esp
  800fe3:	ff 75 20             	pushl  0x20(%ebp)
  800fe6:	53                   	push   %ebx
  800fe7:	ff 75 18             	pushl  0x18(%ebp)
  800fea:	52                   	push   %edx
  800feb:	50                   	push   %eax
  800fec:	ff 75 0c             	pushl  0xc(%ebp)
  800fef:	ff 75 08             	pushl  0x8(%ebp)
  800ff2:	e8 a1 ff ff ff       	call   800f98 <printnum>
  800ff7:	83 c4 20             	add    $0x20,%esp
  800ffa:	eb 1a                	jmp    801016 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ffc:	83 ec 08             	sub    $0x8,%esp
  800fff:	ff 75 0c             	pushl  0xc(%ebp)
  801002:	ff 75 20             	pushl  0x20(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	ff d0                	call   *%eax
  80100a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80100d:	ff 4d 1c             	decl   0x1c(%ebp)
  801010:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801014:	7f e6                	jg     800ffc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801016:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801019:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801024:	53                   	push   %ebx
  801025:	51                   	push   %ecx
  801026:	52                   	push   %edx
  801027:	50                   	push   %eax
  801028:	e8 43 2b 00 00       	call   803b70 <__umoddi3>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	05 d4 44 80 00       	add    $0x8044d4,%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f be c0             	movsbl %al,%eax
  80103a:	83 ec 08             	sub    $0x8,%esp
  80103d:	ff 75 0c             	pushl  0xc(%ebp)
  801040:	50                   	push   %eax
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	ff d0                	call   *%eax
  801046:	83 c4 10             	add    $0x10,%esp
}
  801049:	90                   	nop
  80104a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801052:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801056:	7e 1c                	jle    801074 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8b 00                	mov    (%eax),%eax
  80105d:	8d 50 08             	lea    0x8(%eax),%edx
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	89 10                	mov    %edx,(%eax)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8b 00                	mov    (%eax),%eax
  80106a:	83 e8 08             	sub    $0x8,%eax
  80106d:	8b 50 04             	mov    0x4(%eax),%edx
  801070:	8b 00                	mov    (%eax),%eax
  801072:	eb 40                	jmp    8010b4 <getuint+0x65>
	else if (lflag)
  801074:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801078:	74 1e                	je     801098 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8b 00                	mov    (%eax),%eax
  80107f:	8d 50 04             	lea    0x4(%eax),%edx
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	89 10                	mov    %edx,(%eax)
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8b 00                	mov    (%eax),%eax
  80108c:	83 e8 04             	sub    $0x4,%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	ba 00 00 00 00       	mov    $0x0,%edx
  801096:	eb 1c                	jmp    8010b4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8b 00                	mov    (%eax),%eax
  80109d:	8d 50 04             	lea    0x4(%eax),%edx
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	89 10                	mov    %edx,(%eax)
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8b 00                	mov    (%eax),%eax
  8010aa:	83 e8 04             	sub    $0x4,%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010b9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010bd:	7e 1c                	jle    8010db <getint+0x25>
		return va_arg(*ap, long long);
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8b 00                	mov    (%eax),%eax
  8010c4:	8d 50 08             	lea    0x8(%eax),%edx
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	89 10                	mov    %edx,(%eax)
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	83 e8 08             	sub    $0x8,%eax
  8010d4:	8b 50 04             	mov    0x4(%eax),%edx
  8010d7:	8b 00                	mov    (%eax),%eax
  8010d9:	eb 38                	jmp    801113 <getint+0x5d>
	else if (lflag)
  8010db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010df:	74 1a                	je     8010fb <getint+0x45>
		return va_arg(*ap, long);
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8b 00                	mov    (%eax),%eax
  8010e6:	8d 50 04             	lea    0x4(%eax),%edx
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	89 10                	mov    %edx,(%eax)
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8b 00                	mov    (%eax),%eax
  8010f3:	83 e8 04             	sub    $0x4,%eax
  8010f6:	8b 00                	mov    (%eax),%eax
  8010f8:	99                   	cltd   
  8010f9:	eb 18                	jmp    801113 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8b 00                	mov    (%eax),%eax
  801100:	8d 50 04             	lea    0x4(%eax),%edx
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	89 10                	mov    %edx,(%eax)
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8b 00                	mov    (%eax),%eax
  80110d:	83 e8 04             	sub    $0x4,%eax
  801110:	8b 00                	mov    (%eax),%eax
  801112:	99                   	cltd   
}
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
  80111a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80111d:	eb 17                	jmp    801136 <vprintfmt+0x21>
			if (ch == '\0')
  80111f:	85 db                	test   %ebx,%ebx
  801121:	0f 84 af 03 00 00    	je     8014d6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	ff 75 0c             	pushl  0xc(%ebp)
  80112d:	53                   	push   %ebx
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	ff d0                	call   *%eax
  801133:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801136:	8b 45 10             	mov    0x10(%ebp),%eax
  801139:	8d 50 01             	lea    0x1(%eax),%edx
  80113c:	89 55 10             	mov    %edx,0x10(%ebp)
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f b6 d8             	movzbl %al,%ebx
  801144:	83 fb 25             	cmp    $0x25,%ebx
  801147:	75 d6                	jne    80111f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801149:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80114d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801154:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80115b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801162:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	8d 50 01             	lea    0x1(%eax),%edx
  80116f:	89 55 10             	mov    %edx,0x10(%ebp)
  801172:	8a 00                	mov    (%eax),%al
  801174:	0f b6 d8             	movzbl %al,%ebx
  801177:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80117a:	83 f8 55             	cmp    $0x55,%eax
  80117d:	0f 87 2b 03 00 00    	ja     8014ae <vprintfmt+0x399>
  801183:	8b 04 85 f8 44 80 00 	mov    0x8044f8(,%eax,4),%eax
  80118a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80118c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801190:	eb d7                	jmp    801169 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801192:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801196:	eb d1                	jmp    801169 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801198:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80119f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011a2:	89 d0                	mov    %edx,%eax
  8011a4:	c1 e0 02             	shl    $0x2,%eax
  8011a7:	01 d0                	add    %edx,%eax
  8011a9:	01 c0                	add    %eax,%eax
  8011ab:	01 d8                	add    %ebx,%eax
  8011ad:	83 e8 30             	sub    $0x30,%eax
  8011b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011bb:	83 fb 2f             	cmp    $0x2f,%ebx
  8011be:	7e 3e                	jle    8011fe <vprintfmt+0xe9>
  8011c0:	83 fb 39             	cmp    $0x39,%ebx
  8011c3:	7f 39                	jg     8011fe <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011c5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011c8:	eb d5                	jmp    80119f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cd:	83 c0 04             	add    $0x4,%eax
  8011d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8011d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d6:	83 e8 04             	sub    $0x4,%eax
  8011d9:	8b 00                	mov    (%eax),%eax
  8011db:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011de:	eb 1f                	jmp    8011ff <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011e4:	79 83                	jns    801169 <vprintfmt+0x54>
				width = 0;
  8011e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011ed:	e9 77 ff ff ff       	jmp    801169 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011f2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011f9:	e9 6b ff ff ff       	jmp    801169 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011fe:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801203:	0f 89 60 ff ff ff    	jns    801169 <vprintfmt+0x54>
				width = precision, precision = -1;
  801209:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80120c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80120f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801216:	e9 4e ff ff ff       	jmp    801169 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80121b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80121e:	e9 46 ff ff ff       	jmp    801169 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	83 c0 04             	add    $0x4,%eax
  801229:	89 45 14             	mov    %eax,0x14(%ebp)
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	83 e8 04             	sub    $0x4,%eax
  801232:	8b 00                	mov    (%eax),%eax
  801234:	83 ec 08             	sub    $0x8,%esp
  801237:	ff 75 0c             	pushl  0xc(%ebp)
  80123a:	50                   	push   %eax
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	ff d0                	call   *%eax
  801240:	83 c4 10             	add    $0x10,%esp
			break;
  801243:	e9 89 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801248:	8b 45 14             	mov    0x14(%ebp),%eax
  80124b:	83 c0 04             	add    $0x4,%eax
  80124e:	89 45 14             	mov    %eax,0x14(%ebp)
  801251:	8b 45 14             	mov    0x14(%ebp),%eax
  801254:	83 e8 04             	sub    $0x4,%eax
  801257:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801259:	85 db                	test   %ebx,%ebx
  80125b:	79 02                	jns    80125f <vprintfmt+0x14a>
				err = -err;
  80125d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80125f:	83 fb 64             	cmp    $0x64,%ebx
  801262:	7f 0b                	jg     80126f <vprintfmt+0x15a>
  801264:	8b 34 9d 40 43 80 00 	mov    0x804340(,%ebx,4),%esi
  80126b:	85 f6                	test   %esi,%esi
  80126d:	75 19                	jne    801288 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80126f:	53                   	push   %ebx
  801270:	68 e5 44 80 00       	push   $0x8044e5
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	ff 75 08             	pushl  0x8(%ebp)
  80127b:	e8 5e 02 00 00       	call   8014de <printfmt>
  801280:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801283:	e9 49 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801288:	56                   	push   %esi
  801289:	68 ee 44 80 00       	push   $0x8044ee
  80128e:	ff 75 0c             	pushl  0xc(%ebp)
  801291:	ff 75 08             	pushl  0x8(%ebp)
  801294:	e8 45 02 00 00       	call   8014de <printfmt>
  801299:	83 c4 10             	add    $0x10,%esp
			break;
  80129c:	e9 30 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a4:	83 c0 04             	add    $0x4,%eax
  8012a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8012aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ad:	83 e8 04             	sub    $0x4,%eax
  8012b0:	8b 30                	mov    (%eax),%esi
  8012b2:	85 f6                	test   %esi,%esi
  8012b4:	75 05                	jne    8012bb <vprintfmt+0x1a6>
				p = "(null)";
  8012b6:	be f1 44 80 00       	mov    $0x8044f1,%esi
			if (width > 0 && padc != '-')
  8012bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012bf:	7e 6d                	jle    80132e <vprintfmt+0x219>
  8012c1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012c5:	74 67                	je     80132e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ca:	83 ec 08             	sub    $0x8,%esp
  8012cd:	50                   	push   %eax
  8012ce:	56                   	push   %esi
  8012cf:	e8 0c 03 00 00       	call   8015e0 <strnlen>
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012da:	eb 16                	jmp    8012f2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012dc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	ff 75 0c             	pushl  0xc(%ebp)
  8012e6:	50                   	push   %eax
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	ff d0                	call   *%eax
  8012ec:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8012f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012f6:	7f e4                	jg     8012dc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012f8:	eb 34                	jmp    80132e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012fe:	74 1c                	je     80131c <vprintfmt+0x207>
  801300:	83 fb 1f             	cmp    $0x1f,%ebx
  801303:	7e 05                	jle    80130a <vprintfmt+0x1f5>
  801305:	83 fb 7e             	cmp    $0x7e,%ebx
  801308:	7e 12                	jle    80131c <vprintfmt+0x207>
					putch('?', putdat);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	6a 3f                	push   $0x3f
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	eb 0f                	jmp    80132b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 0c             	pushl  0xc(%ebp)
  801322:	53                   	push   %ebx
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	ff d0                	call   *%eax
  801328:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80132b:	ff 4d e4             	decl   -0x1c(%ebp)
  80132e:	89 f0                	mov    %esi,%eax
  801330:	8d 70 01             	lea    0x1(%eax),%esi
  801333:	8a 00                	mov    (%eax),%al
  801335:	0f be d8             	movsbl %al,%ebx
  801338:	85 db                	test   %ebx,%ebx
  80133a:	74 24                	je     801360 <vprintfmt+0x24b>
  80133c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801340:	78 b8                	js     8012fa <vprintfmt+0x1e5>
  801342:	ff 4d e0             	decl   -0x20(%ebp)
  801345:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801349:	79 af                	jns    8012fa <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80134b:	eb 13                	jmp    801360 <vprintfmt+0x24b>
				putch(' ', putdat);
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	6a 20                	push   $0x20
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	ff d0                	call   *%eax
  80135a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80135d:	ff 4d e4             	decl   -0x1c(%ebp)
  801360:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801364:	7f e7                	jg     80134d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801366:	e9 66 01 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	ff 75 e8             	pushl  -0x18(%ebp)
  801371:	8d 45 14             	lea    0x14(%ebp),%eax
  801374:	50                   	push   %eax
  801375:	e8 3c fd ff ff       	call   8010b6 <getint>
  80137a:	83 c4 10             	add    $0x10,%esp
  80137d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801380:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801386:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801389:	85 d2                	test   %edx,%edx
  80138b:	79 23                	jns    8013b0 <vprintfmt+0x29b>
				putch('-', putdat);
  80138d:	83 ec 08             	sub    $0x8,%esp
  801390:	ff 75 0c             	pushl  0xc(%ebp)
  801393:	6a 2d                	push   $0x2d
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	ff d0                	call   *%eax
  80139a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80139d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a3:	f7 d8                	neg    %eax
  8013a5:	83 d2 00             	adc    $0x0,%edx
  8013a8:	f7 da                	neg    %edx
  8013aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013b0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013b7:	e9 bc 00 00 00       	jmp    801478 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013bc:	83 ec 08             	sub    $0x8,%esp
  8013bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8013c2:	8d 45 14             	lea    0x14(%ebp),%eax
  8013c5:	50                   	push   %eax
  8013c6:	e8 84 fc ff ff       	call   80104f <getuint>
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013d4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013db:	e9 98 00 00 00       	jmp    801478 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013e0:	83 ec 08             	sub    $0x8,%esp
  8013e3:	ff 75 0c             	pushl  0xc(%ebp)
  8013e6:	6a 58                	push   $0x58
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	ff d0                	call   *%eax
  8013ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013f0:	83 ec 08             	sub    $0x8,%esp
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	6a 58                	push   $0x58
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	ff d0                	call   *%eax
  8013fd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	ff 75 0c             	pushl  0xc(%ebp)
  801406:	6a 58                	push   $0x58
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	ff d0                	call   *%eax
  80140d:	83 c4 10             	add    $0x10,%esp
			break;
  801410:	e9 bc 00 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801415:	83 ec 08             	sub    $0x8,%esp
  801418:	ff 75 0c             	pushl  0xc(%ebp)
  80141b:	6a 30                	push   $0x30
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	ff d0                	call   *%eax
  801422:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	ff 75 0c             	pushl  0xc(%ebp)
  80142b:	6a 78                	push   $0x78
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	ff d0                	call   *%eax
  801432:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801435:	8b 45 14             	mov    0x14(%ebp),%eax
  801438:	83 c0 04             	add    $0x4,%eax
  80143b:	89 45 14             	mov    %eax,0x14(%ebp)
  80143e:	8b 45 14             	mov    0x14(%ebp),%eax
  801441:	83 e8 04             	sub    $0x4,%eax
  801444:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801446:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801449:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801450:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801457:	eb 1f                	jmp    801478 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	ff 75 e8             	pushl  -0x18(%ebp)
  80145f:	8d 45 14             	lea    0x14(%ebp),%eax
  801462:	50                   	push   %eax
  801463:	e8 e7 fb ff ff       	call   80104f <getuint>
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801471:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801478:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80147c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	52                   	push   %edx
  801483:	ff 75 e4             	pushl  -0x1c(%ebp)
  801486:	50                   	push   %eax
  801487:	ff 75 f4             	pushl  -0xc(%ebp)
  80148a:	ff 75 f0             	pushl  -0x10(%ebp)
  80148d:	ff 75 0c             	pushl  0xc(%ebp)
  801490:	ff 75 08             	pushl  0x8(%ebp)
  801493:	e8 00 fb ff ff       	call   800f98 <printnum>
  801498:	83 c4 20             	add    $0x20,%esp
			break;
  80149b:	eb 34                	jmp    8014d1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	ff 75 0c             	pushl  0xc(%ebp)
  8014a3:	53                   	push   %ebx
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	ff d0                	call   *%eax
  8014a9:	83 c4 10             	add    $0x10,%esp
			break;
  8014ac:	eb 23                	jmp    8014d1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014ae:	83 ec 08             	sub    $0x8,%esp
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	6a 25                	push   $0x25
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	ff d0                	call   *%eax
  8014bb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014be:	ff 4d 10             	decl   0x10(%ebp)
  8014c1:	eb 03                	jmp    8014c6 <vprintfmt+0x3b1>
  8014c3:	ff 4d 10             	decl   0x10(%ebp)
  8014c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c9:	48                   	dec    %eax
  8014ca:	8a 00                	mov    (%eax),%al
  8014cc:	3c 25                	cmp    $0x25,%al
  8014ce:	75 f3                	jne    8014c3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014d0:	90                   	nop
		}
	}
  8014d1:	e9 47 fc ff ff       	jmp    80111d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014d6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014da:	5b                   	pop    %ebx
  8014db:	5e                   	pop    %esi
  8014dc:	5d                   	pop    %ebp
  8014dd:	c3                   	ret    

008014de <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014e4:	8d 45 10             	lea    0x10(%ebp),%eax
  8014e7:	83 c0 04             	add    $0x4,%eax
  8014ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f3:	50                   	push   %eax
  8014f4:	ff 75 0c             	pushl  0xc(%ebp)
  8014f7:	ff 75 08             	pushl  0x8(%ebp)
  8014fa:	e8 16 fc ff ff       	call   801115 <vprintfmt>
  8014ff:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801502:	90                   	nop
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	8b 40 08             	mov    0x8(%eax),%eax
  80150e:	8d 50 01             	lea    0x1(%eax),%edx
  801511:	8b 45 0c             	mov    0xc(%ebp),%eax
  801514:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151a:	8b 10                	mov    (%eax),%edx
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	8b 40 04             	mov    0x4(%eax),%eax
  801522:	39 c2                	cmp    %eax,%edx
  801524:	73 12                	jae    801538 <sprintputch+0x33>
		*b->buf++ = ch;
  801526:	8b 45 0c             	mov    0xc(%ebp),%eax
  801529:	8b 00                	mov    (%eax),%eax
  80152b:	8d 48 01             	lea    0x1(%eax),%ecx
  80152e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801531:	89 0a                	mov    %ecx,(%edx)
  801533:	8b 55 08             	mov    0x8(%ebp),%edx
  801536:	88 10                	mov    %dl,(%eax)
}
  801538:	90                   	nop
  801539:	5d                   	pop    %ebp
  80153a:	c3                   	ret    

0080153b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	01 d0                	add    %edx,%eax
  801552:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801555:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80155c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801560:	74 06                	je     801568 <vsnprintf+0x2d>
  801562:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801566:	7f 07                	jg     80156f <vsnprintf+0x34>
		return -E_INVAL;
  801568:	b8 03 00 00 00       	mov    $0x3,%eax
  80156d:	eb 20                	jmp    80158f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80156f:	ff 75 14             	pushl  0x14(%ebp)
  801572:	ff 75 10             	pushl  0x10(%ebp)
  801575:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801578:	50                   	push   %eax
  801579:	68 05 15 80 00       	push   $0x801505
  80157e:	e8 92 fb ff ff       	call   801115 <vprintfmt>
  801583:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801586:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801589:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80158c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801597:	8d 45 10             	lea    0x10(%ebp),%eax
  80159a:	83 c0 04             	add    $0x4,%eax
  80159d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a6:	50                   	push   %eax
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	ff 75 08             	pushl  0x8(%ebp)
  8015ad:	e8 89 ff ff ff       	call   80153b <vsnprintf>
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ca:	eb 06                	jmp    8015d2 <strlen+0x15>
		n++;
  8015cc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015cf:	ff 45 08             	incl   0x8(%ebp)
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	8a 00                	mov    (%eax),%al
  8015d7:	84 c0                	test   %al,%al
  8015d9:	75 f1                	jne    8015cc <strlen+0xf>
		n++;
	return n;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ed:	eb 09                	jmp    8015f8 <strnlen+0x18>
		n++;
  8015ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015f2:	ff 45 08             	incl   0x8(%ebp)
  8015f5:	ff 4d 0c             	decl   0xc(%ebp)
  8015f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015fc:	74 09                	je     801607 <strnlen+0x27>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	84 c0                	test   %al,%al
  801605:	75 e8                	jne    8015ef <strnlen+0xf>
		n++;
	return n;
  801607:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801618:	90                   	nop
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	8d 50 01             	lea    0x1(%eax),%edx
  80161f:	89 55 08             	mov    %edx,0x8(%ebp)
  801622:	8b 55 0c             	mov    0xc(%ebp),%edx
  801625:	8d 4a 01             	lea    0x1(%edx),%ecx
  801628:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80162b:	8a 12                	mov    (%edx),%dl
  80162d:	88 10                	mov    %dl,(%eax)
  80162f:	8a 00                	mov    (%eax),%al
  801631:	84 c0                	test   %al,%al
  801633:	75 e4                	jne    801619 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801635:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801646:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80164d:	eb 1f                	jmp    80166e <strncpy+0x34>
		*dst++ = *src;
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8d 50 01             	lea    0x1(%eax),%edx
  801655:	89 55 08             	mov    %edx,0x8(%ebp)
  801658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165b:	8a 12                	mov    (%edx),%dl
  80165d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80165f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801662:	8a 00                	mov    (%eax),%al
  801664:	84 c0                	test   %al,%al
  801666:	74 03                	je     80166b <strncpy+0x31>
			src++;
  801668:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80166b:	ff 45 fc             	incl   -0x4(%ebp)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	3b 45 10             	cmp    0x10(%ebp),%eax
  801674:	72 d9                	jb     80164f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801676:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801687:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80168b:	74 30                	je     8016bd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80168d:	eb 16                	jmp    8016a5 <strlcpy+0x2a>
			*dst++ = *src++;
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8d 50 01             	lea    0x1(%eax),%edx
  801695:	89 55 08             	mov    %edx,0x8(%ebp)
  801698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80169e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016a1:	8a 12                	mov    (%edx),%dl
  8016a3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016a5:	ff 4d 10             	decl   0x10(%ebp)
  8016a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ac:	74 09                	je     8016b7 <strlcpy+0x3c>
  8016ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	84 c0                	test   %al,%al
  8016b5:	75 d8                	jne    80168f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c3:	29 c2                	sub    %eax,%edx
  8016c5:	89 d0                	mov    %edx,%eax
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016cc:	eb 06                	jmp    8016d4 <strcmp+0xb>
		p++, q++;
  8016ce:	ff 45 08             	incl   0x8(%ebp)
  8016d1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	8a 00                	mov    (%eax),%al
  8016d9:	84 c0                	test   %al,%al
  8016db:	74 0e                	je     8016eb <strcmp+0x22>
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8a 10                	mov    (%eax),%dl
  8016e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e5:	8a 00                	mov    (%eax),%al
  8016e7:	38 c2                	cmp    %al,%dl
  8016e9:	74 e3                	je     8016ce <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f b6 d0             	movzbl %al,%edx
  8016f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f6:	8a 00                	mov    (%eax),%al
  8016f8:	0f b6 c0             	movzbl %al,%eax
  8016fb:	29 c2                	sub    %eax,%edx
  8016fd:	89 d0                	mov    %edx,%eax
}
  8016ff:	5d                   	pop    %ebp
  801700:	c3                   	ret    

00801701 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801704:	eb 09                	jmp    80170f <strncmp+0xe>
		n--, p++, q++;
  801706:	ff 4d 10             	decl   0x10(%ebp)
  801709:	ff 45 08             	incl   0x8(%ebp)
  80170c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80170f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801713:	74 17                	je     80172c <strncmp+0x2b>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	84 c0                	test   %al,%al
  80171c:	74 0e                	je     80172c <strncmp+0x2b>
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8a 10                	mov    (%eax),%dl
  801723:	8b 45 0c             	mov    0xc(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	38 c2                	cmp    %al,%dl
  80172a:	74 da                	je     801706 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80172c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801730:	75 07                	jne    801739 <strncmp+0x38>
		return 0;
  801732:	b8 00 00 00 00       	mov    $0x0,%eax
  801737:	eb 14                	jmp    80174d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	8a 00                	mov    (%eax),%al
  80173e:	0f b6 d0             	movzbl %al,%edx
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	0f b6 c0             	movzbl %al,%eax
  801749:	29 c2                	sub    %eax,%edx
  80174b:	89 d0                	mov    %edx,%eax
}
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    

0080174f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	8b 45 0c             	mov    0xc(%ebp),%eax
  801758:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80175b:	eb 12                	jmp    80176f <strchr+0x20>
		if (*s == c)
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801765:	75 05                	jne    80176c <strchr+0x1d>
			return (char *) s;
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	eb 11                	jmp    80177d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80176c:	ff 45 08             	incl   0x8(%ebp)
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	84 c0                	test   %al,%al
  801776:	75 e5                	jne    80175d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	8b 45 0c             	mov    0xc(%ebp),%eax
  801788:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80178b:	eb 0d                	jmp    80179a <strfind+0x1b>
		if (*s == c)
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8a 00                	mov    (%eax),%al
  801792:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801795:	74 0e                	je     8017a5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801797:	ff 45 08             	incl   0x8(%ebp)
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8a 00                	mov    (%eax),%al
  80179f:	84 c0                	test   %al,%al
  8017a1:	75 ea                	jne    80178d <strfind+0xe>
  8017a3:	eb 01                	jmp    8017a6 <strfind+0x27>
		if (*s == c)
			break;
  8017a5:	90                   	nop
	return (char *) s;
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017bd:	eb 0e                	jmp    8017cd <memset+0x22>
		*p++ = c;
  8017bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c2:	8d 50 01             	lea    0x1(%eax),%edx
  8017c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017cd:	ff 4d f8             	decl   -0x8(%ebp)
  8017d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017d4:	79 e9                	jns    8017bf <memset+0x14>
		*p++ = c;

	return v;
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017ed:	eb 16                	jmp    801805 <memcpy+0x2a>
		*d++ = *s++;
  8017ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f2:	8d 50 01             	lea    0x1(%eax),%edx
  8017f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017fe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801801:	8a 12                	mov    (%edx),%dl
  801803:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801805:	8b 45 10             	mov    0x10(%ebp),%eax
  801808:	8d 50 ff             	lea    -0x1(%eax),%edx
  80180b:	89 55 10             	mov    %edx,0x10(%ebp)
  80180e:	85 c0                	test   %eax,%eax
  801810:	75 dd                	jne    8017ef <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80181d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801820:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80182f:	73 50                	jae    801881 <memmove+0x6a>
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8b 45 10             	mov    0x10(%ebp),%eax
  801837:	01 d0                	add    %edx,%eax
  801839:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80183c:	76 43                	jbe    801881 <memmove+0x6a>
		s += n;
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801844:	8b 45 10             	mov    0x10(%ebp),%eax
  801847:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80184a:	eb 10                	jmp    80185c <memmove+0x45>
			*--d = *--s;
  80184c:	ff 4d f8             	decl   -0x8(%ebp)
  80184f:	ff 4d fc             	decl   -0x4(%ebp)
  801852:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801855:	8a 10                	mov    (%eax),%dl
  801857:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80185c:	8b 45 10             	mov    0x10(%ebp),%eax
  80185f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801862:	89 55 10             	mov    %edx,0x10(%ebp)
  801865:	85 c0                	test   %eax,%eax
  801867:	75 e3                	jne    80184c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801869:	eb 23                	jmp    80188e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80186b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186e:	8d 50 01             	lea    0x1(%eax),%edx
  801871:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801874:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801877:	8d 4a 01             	lea    0x1(%edx),%ecx
  80187a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80187d:	8a 12                	mov    (%edx),%dl
  80187f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	8d 50 ff             	lea    -0x1(%eax),%edx
  801887:	89 55 10             	mov    %edx,0x10(%ebp)
  80188a:	85 c0                	test   %eax,%eax
  80188c:	75 dd                	jne    80186b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018a5:	eb 2a                	jmp    8018d1 <memcmp+0x3e>
		if (*s1 != *s2)
  8018a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018aa:	8a 10                	mov    (%eax),%dl
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	8a 00                	mov    (%eax),%al
  8018b1:	38 c2                	cmp    %al,%dl
  8018b3:	74 16                	je     8018cb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c0:	8a 00                	mov    (%eax),%al
  8018c2:	0f b6 c0             	movzbl %al,%eax
  8018c5:	29 c2                	sub    %eax,%edx
  8018c7:	89 d0                	mov    %edx,%eax
  8018c9:	eb 18                	jmp    8018e3 <memcmp+0x50>
		s1++, s2++;
  8018cb:	ff 45 fc             	incl   -0x4(%ebp)
  8018ce:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	75 c9                	jne    8018a7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f1:	01 d0                	add    %edx,%eax
  8018f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018f6:	eb 15                	jmp    80190d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	8a 00                	mov    (%eax),%al
  8018fd:	0f b6 d0             	movzbl %al,%edx
  801900:	8b 45 0c             	mov    0xc(%ebp),%eax
  801903:	0f b6 c0             	movzbl %al,%eax
  801906:	39 c2                	cmp    %eax,%edx
  801908:	74 0d                	je     801917 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80190a:	ff 45 08             	incl   0x8(%ebp)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801913:	72 e3                	jb     8018f8 <memfind+0x13>
  801915:	eb 01                	jmp    801918 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801917:	90                   	nop
	return (void *) s;
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801923:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80192a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801931:	eb 03                	jmp    801936 <strtol+0x19>
		s++;
  801933:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	8a 00                	mov    (%eax),%al
  80193b:	3c 20                	cmp    $0x20,%al
  80193d:	74 f4                	je     801933 <strtol+0x16>
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	8a 00                	mov    (%eax),%al
  801944:	3c 09                	cmp    $0x9,%al
  801946:	74 eb                	je     801933 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	8a 00                	mov    (%eax),%al
  80194d:	3c 2b                	cmp    $0x2b,%al
  80194f:	75 05                	jne    801956 <strtol+0x39>
		s++;
  801951:	ff 45 08             	incl   0x8(%ebp)
  801954:	eb 13                	jmp    801969 <strtol+0x4c>
	else if (*s == '-')
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	3c 2d                	cmp    $0x2d,%al
  80195d:	75 0a                	jne    801969 <strtol+0x4c>
		s++, neg = 1;
  80195f:	ff 45 08             	incl   0x8(%ebp)
  801962:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801969:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196d:	74 06                	je     801975 <strtol+0x58>
  80196f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801973:	75 20                	jne    801995 <strtol+0x78>
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	8a 00                	mov    (%eax),%al
  80197a:	3c 30                	cmp    $0x30,%al
  80197c:	75 17                	jne    801995 <strtol+0x78>
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	40                   	inc    %eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	3c 78                	cmp    $0x78,%al
  801986:	75 0d                	jne    801995 <strtol+0x78>
		s += 2, base = 16;
  801988:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80198c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801993:	eb 28                	jmp    8019bd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801995:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801999:	75 15                	jne    8019b0 <strtol+0x93>
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8a 00                	mov    (%eax),%al
  8019a0:	3c 30                	cmp    $0x30,%al
  8019a2:	75 0c                	jne    8019b0 <strtol+0x93>
		s++, base = 8;
  8019a4:	ff 45 08             	incl   0x8(%ebp)
  8019a7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019ae:	eb 0d                	jmp    8019bd <strtol+0xa0>
	else if (base == 0)
  8019b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019b4:	75 07                	jne    8019bd <strtol+0xa0>
		base = 10;
  8019b6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8a 00                	mov    (%eax),%al
  8019c2:	3c 2f                	cmp    $0x2f,%al
  8019c4:	7e 19                	jle    8019df <strtol+0xc2>
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8a 00                	mov    (%eax),%al
  8019cb:	3c 39                	cmp    $0x39,%al
  8019cd:	7f 10                	jg     8019df <strtol+0xc2>
			dig = *s - '0';
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	8a 00                	mov    (%eax),%al
  8019d4:	0f be c0             	movsbl %al,%eax
  8019d7:	83 e8 30             	sub    $0x30,%eax
  8019da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019dd:	eb 42                	jmp    801a21 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8a 00                	mov    (%eax),%al
  8019e4:	3c 60                	cmp    $0x60,%al
  8019e6:	7e 19                	jle    801a01 <strtol+0xe4>
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8a 00                	mov    (%eax),%al
  8019ed:	3c 7a                	cmp    $0x7a,%al
  8019ef:	7f 10                	jg     801a01 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	8a 00                	mov    (%eax),%al
  8019f6:	0f be c0             	movsbl %al,%eax
  8019f9:	83 e8 57             	sub    $0x57,%eax
  8019fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019ff:	eb 20                	jmp    801a21 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	3c 40                	cmp    $0x40,%al
  801a08:	7e 39                	jle    801a43 <strtol+0x126>
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	3c 5a                	cmp    $0x5a,%al
  801a11:	7f 30                	jg     801a43 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8a 00                	mov    (%eax),%al
  801a18:	0f be c0             	movsbl %al,%eax
  801a1b:	83 e8 37             	sub    $0x37,%eax
  801a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a24:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a27:	7d 19                	jge    801a42 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a29:	ff 45 08             	incl   0x8(%ebp)
  801a2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a33:	89 c2                	mov    %eax,%edx
  801a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a3d:	e9 7b ff ff ff       	jmp    8019bd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a42:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a47:	74 08                	je     801a51 <strtol+0x134>
		*endptr = (char *) s;
  801a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a4f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a51:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a55:	74 07                	je     801a5e <strtol+0x141>
  801a57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5a:	f7 d8                	neg    %eax
  801a5c:	eb 03                	jmp    801a61 <strtol+0x144>
  801a5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <ltostr>:

void
ltostr(long value, char *str)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a7b:	79 13                	jns    801a90 <ltostr+0x2d>
	{
		neg = 1;
  801a7d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a87:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a8a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a8d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a98:	99                   	cltd   
  801a99:	f7 f9                	idiv   %ecx
  801a9b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa1:	8d 50 01             	lea    0x1(%eax),%edx
  801aa4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aa7:	89 c2                	mov    %eax,%edx
  801aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aac:	01 d0                	add    %edx,%eax
  801aae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ab1:	83 c2 30             	add    $0x30,%edx
  801ab4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ab6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801abe:	f7 e9                	imul   %ecx
  801ac0:	c1 fa 02             	sar    $0x2,%edx
  801ac3:	89 c8                	mov    %ecx,%eax
  801ac5:	c1 f8 1f             	sar    $0x1f,%eax
  801ac8:	29 c2                	sub    %eax,%edx
  801aca:	89 d0                	mov    %edx,%eax
  801acc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ad2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ad7:	f7 e9                	imul   %ecx
  801ad9:	c1 fa 02             	sar    $0x2,%edx
  801adc:	89 c8                	mov    %ecx,%eax
  801ade:	c1 f8 1f             	sar    $0x1f,%eax
  801ae1:	29 c2                	sub    %eax,%edx
  801ae3:	89 d0                	mov    %edx,%eax
  801ae5:	c1 e0 02             	shl    $0x2,%eax
  801ae8:	01 d0                	add    %edx,%eax
  801aea:	01 c0                	add    %eax,%eax
  801aec:	29 c1                	sub    %eax,%ecx
  801aee:	89 ca                	mov    %ecx,%edx
  801af0:	85 d2                	test   %edx,%edx
  801af2:	75 9c                	jne    801a90 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801af4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801afb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afe:	48                   	dec    %eax
  801aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b02:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b06:	74 3d                	je     801b45 <ltostr+0xe2>
		start = 1 ;
  801b08:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b0f:	eb 34                	jmp    801b45 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b17:	01 d0                	add    %edx,%eax
  801b19:	8a 00                	mov    (%eax),%al
  801b1b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b24:	01 c2                	add    %eax,%edx
  801b26:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2c:	01 c8                	add    %ecx,%eax
  801b2e:	8a 00                	mov    (%eax),%al
  801b30:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b38:	01 c2                	add    %eax,%edx
  801b3a:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b3d:	88 02                	mov    %al,(%edx)
		start++ ;
  801b3f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b42:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b48:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b4b:	7c c4                	jl     801b11 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b4d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b53:	01 d0                	add    %edx,%eax
  801b55:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b58:	90                   	nop
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b61:	ff 75 08             	pushl  0x8(%ebp)
  801b64:	e8 54 fa ff ff       	call   8015bd <strlen>
  801b69:	83 c4 04             	add    $0x4,%esp
  801b6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	e8 46 fa ff ff       	call   8015bd <strlen>
  801b77:	83 c4 04             	add    $0x4,%esp
  801b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b8b:	eb 17                	jmp    801ba4 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b90:	8b 45 10             	mov    0x10(%ebp),%eax
  801b93:	01 c2                	add    %eax,%edx
  801b95:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	01 c8                	add    %ecx,%eax
  801b9d:	8a 00                	mov    (%eax),%al
  801b9f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ba1:	ff 45 fc             	incl   -0x4(%ebp)
  801ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ba7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801baa:	7c e1                	jl     801b8d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bb3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bba:	eb 1f                	jmp    801bdb <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bbf:	8d 50 01             	lea    0x1(%eax),%edx
  801bc2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bc5:	89 c2                	mov    %eax,%edx
  801bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bca:	01 c2                	add    %eax,%edx
  801bcc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd2:	01 c8                	add    %ecx,%eax
  801bd4:	8a 00                	mov    (%eax),%al
  801bd6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bd8:	ff 45 f8             	incl   -0x8(%ebp)
  801bdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bde:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801be1:	7c d9                	jl     801bbc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801be3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be6:	8b 45 10             	mov    0x10(%ebp),%eax
  801be9:	01 d0                	add    %edx,%eax
  801beb:	c6 00 00             	movb   $0x0,(%eax)
}
  801bee:	90                   	nop
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bfd:	8b 45 14             	mov    0x14(%ebp),%eax
  801c00:	8b 00                	mov    (%eax),%eax
  801c02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c14:	eb 0c                	jmp    801c22 <strsplit+0x31>
			*string++ = 0;
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	8d 50 01             	lea    0x1(%eax),%edx
  801c1c:	89 55 08             	mov    %edx,0x8(%ebp)
  801c1f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	8a 00                	mov    (%eax),%al
  801c27:	84 c0                	test   %al,%al
  801c29:	74 18                	je     801c43 <strsplit+0x52>
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	8a 00                	mov    (%eax),%al
  801c30:	0f be c0             	movsbl %al,%eax
  801c33:	50                   	push   %eax
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	e8 13 fb ff ff       	call   80174f <strchr>
  801c3c:	83 c4 08             	add    $0x8,%esp
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	75 d3                	jne    801c16 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	8a 00                	mov    (%eax),%al
  801c48:	84 c0                	test   %al,%al
  801c4a:	74 5a                	je     801ca6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4f:	8b 00                	mov    (%eax),%eax
  801c51:	83 f8 0f             	cmp    $0xf,%eax
  801c54:	75 07                	jne    801c5d <strsplit+0x6c>
		{
			return 0;
  801c56:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5b:	eb 66                	jmp    801cc3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c60:	8b 00                	mov    (%eax),%eax
  801c62:	8d 48 01             	lea    0x1(%eax),%ecx
  801c65:	8b 55 14             	mov    0x14(%ebp),%edx
  801c68:	89 0a                	mov    %ecx,(%edx)
  801c6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c71:	8b 45 10             	mov    0x10(%ebp),%eax
  801c74:	01 c2                	add    %eax,%edx
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c7b:	eb 03                	jmp    801c80 <strsplit+0x8f>
			string++;
  801c7d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	8a 00                	mov    (%eax),%al
  801c85:	84 c0                	test   %al,%al
  801c87:	74 8b                	je     801c14 <strsplit+0x23>
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	8a 00                	mov    (%eax),%al
  801c8e:	0f be c0             	movsbl %al,%eax
  801c91:	50                   	push   %eax
  801c92:	ff 75 0c             	pushl  0xc(%ebp)
  801c95:	e8 b5 fa ff ff       	call   80174f <strchr>
  801c9a:	83 c4 08             	add    $0x8,%esp
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	74 dc                	je     801c7d <strsplit+0x8c>
			string++;
	}
  801ca1:	e9 6e ff ff ff       	jmp    801c14 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ca6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  801caa:	8b 00                	mov    (%eax),%eax
  801cac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb6:	01 d0                	add    %edx,%eax
  801cb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801ccb:	a1 04 50 80 00       	mov    0x805004,%eax
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	74 1f                	je     801cf3 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801cd4:	e8 1d 00 00 00       	call   801cf6 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801cd9:	83 ec 0c             	sub    $0xc,%esp
  801cdc:	68 50 46 80 00       	push   $0x804650
  801ce1:	e8 55 f2 ff ff       	call   800f3b <cprintf>
  801ce6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801ce9:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801cf0:	00 00 00 
	}
}
  801cf3:	90                   	nop
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801cfc:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801d03:	00 00 00 
  801d06:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801d0d:	00 00 00 
  801d10:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801d17:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801d1a:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801d21:	00 00 00 
  801d24:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801d2b:	00 00 00 
  801d2e:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801d35:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801d38:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d47:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d4c:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801d51:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801d58:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801d5b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d65:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801d6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d70:	ba 00 00 00 00       	mov    $0x0,%edx
  801d75:	f7 75 f0             	divl   -0x10(%ebp)
  801d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7b:	29 d0                	sub    %edx,%eax
  801d7d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801d80:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d8f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d94:	83 ec 04             	sub    $0x4,%esp
  801d97:	6a 06                	push   $0x6
  801d99:	ff 75 e8             	pushl  -0x18(%ebp)
  801d9c:	50                   	push   %eax
  801d9d:	e8 d4 05 00 00       	call   802376 <sys_allocate_chunk>
  801da2:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801da5:	a1 20 51 80 00       	mov    0x805120,%eax
  801daa:	83 ec 0c             	sub    $0xc,%esp
  801dad:	50                   	push   %eax
  801dae:	e8 49 0c 00 00       	call   8029fc <initialize_MemBlocksList>
  801db3:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801db6:	a1 48 51 80 00       	mov    0x805148,%eax
  801dbb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801dbe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dc2:	75 14                	jne    801dd8 <initialize_dyn_block_system+0xe2>
  801dc4:	83 ec 04             	sub    $0x4,%esp
  801dc7:	68 75 46 80 00       	push   $0x804675
  801dcc:	6a 39                	push   $0x39
  801dce:	68 93 46 80 00       	push   $0x804693
  801dd3:	e8 af ee ff ff       	call   800c87 <_panic>
  801dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ddb:	8b 00                	mov    (%eax),%eax
  801ddd:	85 c0                	test   %eax,%eax
  801ddf:	74 10                	je     801df1 <initialize_dyn_block_system+0xfb>
  801de1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de4:	8b 00                	mov    (%eax),%eax
  801de6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801de9:	8b 52 04             	mov    0x4(%edx),%edx
  801dec:	89 50 04             	mov    %edx,0x4(%eax)
  801def:	eb 0b                	jmp    801dfc <initialize_dyn_block_system+0x106>
  801df1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801df4:	8b 40 04             	mov    0x4(%eax),%eax
  801df7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801dfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dff:	8b 40 04             	mov    0x4(%eax),%eax
  801e02:	85 c0                	test   %eax,%eax
  801e04:	74 0f                	je     801e15 <initialize_dyn_block_system+0x11f>
  801e06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e09:	8b 40 04             	mov    0x4(%eax),%eax
  801e0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e0f:	8b 12                	mov    (%edx),%edx
  801e11:	89 10                	mov    %edx,(%eax)
  801e13:	eb 0a                	jmp    801e1f <initialize_dyn_block_system+0x129>
  801e15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e18:	8b 00                	mov    (%eax),%eax
  801e1a:	a3 48 51 80 00       	mov    %eax,0x805148
  801e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e32:	a1 54 51 80 00       	mov    0x805154,%eax
  801e37:	48                   	dec    %eax
  801e38:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801e3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e40:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801e47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e4a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801e51:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e55:	75 14                	jne    801e6b <initialize_dyn_block_system+0x175>
  801e57:	83 ec 04             	sub    $0x4,%esp
  801e5a:	68 a0 46 80 00       	push   $0x8046a0
  801e5f:	6a 3f                	push   $0x3f
  801e61:	68 93 46 80 00       	push   $0x804693
  801e66:	e8 1c ee ff ff       	call   800c87 <_panic>
  801e6b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801e71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e74:	89 10                	mov    %edx,(%eax)
  801e76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e79:	8b 00                	mov    (%eax),%eax
  801e7b:	85 c0                	test   %eax,%eax
  801e7d:	74 0d                	je     801e8c <initialize_dyn_block_system+0x196>
  801e7f:	a1 38 51 80 00       	mov    0x805138,%eax
  801e84:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e87:	89 50 04             	mov    %edx,0x4(%eax)
  801e8a:	eb 08                	jmp    801e94 <initialize_dyn_block_system+0x19e>
  801e8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e8f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801e94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e97:	a3 38 51 80 00       	mov    %eax,0x805138
  801e9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ea6:	a1 44 51 80 00       	mov    0x805144,%eax
  801eab:	40                   	inc    %eax
  801eac:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801eb1:	90                   	nop
  801eb2:	c9                   	leave  
  801eb3:	c3                   	ret    

00801eb4 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801eba:	e8 06 fe ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ebf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ec3:	75 07                	jne    801ecc <malloc+0x18>
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eca:	eb 7d                	jmp    801f49 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801ecc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801ed3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801eda:	8b 55 08             	mov    0x8(%ebp),%edx
  801edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee0:	01 d0                	add    %edx,%eax
  801ee2:	48                   	dec    %eax
  801ee3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ee6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee9:	ba 00 00 00 00       	mov    $0x0,%edx
  801eee:	f7 75 f0             	divl   -0x10(%ebp)
  801ef1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ef4:	29 d0                	sub    %edx,%eax
  801ef6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801ef9:	e8 46 08 00 00       	call   802744 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801efe:	83 f8 01             	cmp    $0x1,%eax
  801f01:	75 07                	jne    801f0a <malloc+0x56>
  801f03:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801f0a:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801f0e:	75 34                	jne    801f44 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801f10:	83 ec 0c             	sub    $0xc,%esp
  801f13:	ff 75 e8             	pushl  -0x18(%ebp)
  801f16:	e8 73 0e 00 00       	call   802d8e <alloc_block_FF>
  801f1b:	83 c4 10             	add    $0x10,%esp
  801f1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801f21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f25:	74 16                	je     801f3d <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801f27:	83 ec 0c             	sub    $0xc,%esp
  801f2a:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f2d:	e8 ff 0b 00 00       	call   802b31 <insert_sorted_allocList>
  801f32:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801f35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f38:	8b 40 08             	mov    0x8(%eax),%eax
  801f3b:	eb 0c                	jmp    801f49 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f42:	eb 05                	jmp    801f49 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801f44:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f65:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801f68:	83 ec 08             	sub    $0x8,%esp
  801f6b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f6e:	68 40 50 80 00       	push   $0x805040
  801f73:	e8 61 0b 00 00       	call   802ad9 <find_block>
  801f78:	83 c4 10             	add    $0x10,%esp
  801f7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801f7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f82:	0f 84 a5 00 00 00    	je     80202d <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801f88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f8e:	83 ec 08             	sub    $0x8,%esp
  801f91:	50                   	push   %eax
  801f92:	ff 75 f4             	pushl  -0xc(%ebp)
  801f95:	e8 a4 03 00 00       	call   80233e <sys_free_user_mem>
  801f9a:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801f9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fa1:	75 17                	jne    801fba <free+0x6f>
  801fa3:	83 ec 04             	sub    $0x4,%esp
  801fa6:	68 75 46 80 00       	push   $0x804675
  801fab:	68 87 00 00 00       	push   $0x87
  801fb0:	68 93 46 80 00       	push   $0x804693
  801fb5:	e8 cd ec ff ff       	call   800c87 <_panic>
  801fba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fbd:	8b 00                	mov    (%eax),%eax
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	74 10                	je     801fd3 <free+0x88>
  801fc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc6:	8b 00                	mov    (%eax),%eax
  801fc8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801fcb:	8b 52 04             	mov    0x4(%edx),%edx
  801fce:	89 50 04             	mov    %edx,0x4(%eax)
  801fd1:	eb 0b                	jmp    801fde <free+0x93>
  801fd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd6:	8b 40 04             	mov    0x4(%eax),%eax
  801fd9:	a3 44 50 80 00       	mov    %eax,0x805044
  801fde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe1:	8b 40 04             	mov    0x4(%eax),%eax
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	74 0f                	je     801ff7 <free+0xac>
  801fe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801feb:	8b 40 04             	mov    0x4(%eax),%eax
  801fee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ff1:	8b 12                	mov    (%edx),%edx
  801ff3:	89 10                	mov    %edx,(%eax)
  801ff5:	eb 0a                	jmp    802001 <free+0xb6>
  801ff7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ffa:	8b 00                	mov    (%eax),%eax
  801ffc:	a3 40 50 80 00       	mov    %eax,0x805040
  802001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80200a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80200d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802014:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802019:	48                   	dec    %eax
  80201a:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  80201f:	83 ec 0c             	sub    $0xc,%esp
  802022:	ff 75 ec             	pushl  -0x14(%ebp)
  802025:	e8 37 12 00 00       	call   803261 <insert_sorted_with_merge_freeList>
  80202a:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  80202d:	90                   	nop
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 38             	sub    $0x38,%esp
  802036:	8b 45 10             	mov    0x10(%ebp),%eax
  802039:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80203c:	e8 84 fc ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  802041:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802045:	75 07                	jne    80204e <smalloc+0x1e>
  802047:	b8 00 00 00 00       	mov    $0x0,%eax
  80204c:	eb 7e                	jmp    8020cc <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  80204e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  802055:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80205c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802062:	01 d0                	add    %edx,%eax
  802064:	48                   	dec    %eax
  802065:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802068:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206b:	ba 00 00 00 00       	mov    $0x0,%edx
  802070:	f7 75 f0             	divl   -0x10(%ebp)
  802073:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802076:	29 d0                	sub    %edx,%eax
  802078:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80207b:	e8 c4 06 00 00       	call   802744 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802080:	83 f8 01             	cmp    $0x1,%eax
  802083:	75 42                	jne    8020c7 <smalloc+0x97>

		  va = malloc(newsize) ;
  802085:	83 ec 0c             	sub    $0xc,%esp
  802088:	ff 75 e8             	pushl  -0x18(%ebp)
  80208b:	e8 24 fe ff ff       	call   801eb4 <malloc>
  802090:	83 c4 10             	add    $0x10,%esp
  802093:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  802096:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80209a:	74 24                	je     8020c0 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  80209c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8020a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020a3:	50                   	push   %eax
  8020a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8020a7:	ff 75 08             	pushl  0x8(%ebp)
  8020aa:	e8 1a 04 00 00       	call   8024c9 <sys_createSharedObject>
  8020af:	83 c4 10             	add    $0x10,%esp
  8020b2:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8020b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020b9:	78 0c                	js     8020c7 <smalloc+0x97>
					  return va ;
  8020bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020be:	eb 0c                	jmp    8020cc <smalloc+0x9c>
				 }
				 else
					return NULL;
  8020c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c5:	eb 05                	jmp    8020cc <smalloc+0x9c>
	  }
		  return NULL ;
  8020c7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020d4:	e8 ec fb ff ff       	call   801cc5 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8020d9:	83 ec 08             	sub    $0x8,%esp
  8020dc:	ff 75 0c             	pushl  0xc(%ebp)
  8020df:	ff 75 08             	pushl  0x8(%ebp)
  8020e2:	e8 0c 04 00 00       	call   8024f3 <sys_getSizeOfSharedObject>
  8020e7:	83 c4 10             	add    $0x10,%esp
  8020ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8020ed:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8020f1:	75 07                	jne    8020fa <sget+0x2c>
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f8:	eb 75                	jmp    80216f <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8020fa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802107:	01 d0                	add    %edx,%eax
  802109:	48                   	dec    %eax
  80210a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80210d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802110:	ba 00 00 00 00       	mov    $0x0,%edx
  802115:	f7 75 f0             	divl   -0x10(%ebp)
  802118:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80211b:	29 d0                	sub    %edx,%eax
  80211d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  802120:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  802127:	e8 18 06 00 00       	call   802744 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80212c:	83 f8 01             	cmp    $0x1,%eax
  80212f:	75 39                	jne    80216a <sget+0x9c>

		  va = malloc(newsize) ;
  802131:	83 ec 0c             	sub    $0xc,%esp
  802134:	ff 75 e8             	pushl  -0x18(%ebp)
  802137:	e8 78 fd ff ff       	call   801eb4 <malloc>
  80213c:	83 c4 10             	add    $0x10,%esp
  80213f:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  802142:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802146:	74 22                	je     80216a <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  802148:	83 ec 04             	sub    $0x4,%esp
  80214b:	ff 75 e0             	pushl  -0x20(%ebp)
  80214e:	ff 75 0c             	pushl  0xc(%ebp)
  802151:	ff 75 08             	pushl  0x8(%ebp)
  802154:	e8 b7 03 00 00       	call   802510 <sys_getSharedObject>
  802159:	83 c4 10             	add    $0x10,%esp
  80215c:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  80215f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802163:	78 05                	js     80216a <sget+0x9c>
					  return va;
  802165:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802168:	eb 05                	jmp    80216f <sget+0xa1>
				  }
			  }
     }
         return NULL;
  80216a:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  80216f:	c9                   	leave  
  802170:	c3                   	ret    

00802171 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
  802174:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802177:	e8 49 fb ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80217c:	83 ec 04             	sub    $0x4,%esp
  80217f:	68 c4 46 80 00       	push   $0x8046c4
  802184:	68 1e 01 00 00       	push   $0x11e
  802189:	68 93 46 80 00       	push   $0x804693
  80218e:	e8 f4 ea ff ff       	call   800c87 <_panic>

00802193 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
  802196:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802199:	83 ec 04             	sub    $0x4,%esp
  80219c:	68 ec 46 80 00       	push   $0x8046ec
  8021a1:	68 32 01 00 00       	push   $0x132
  8021a6:	68 93 46 80 00       	push   $0x804693
  8021ab:	e8 d7 ea ff ff       	call   800c87 <_panic>

008021b0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021b6:	83 ec 04             	sub    $0x4,%esp
  8021b9:	68 10 47 80 00       	push   $0x804710
  8021be:	68 3d 01 00 00       	push   $0x13d
  8021c3:	68 93 46 80 00       	push   $0x804693
  8021c8:	e8 ba ea ff ff       	call   800c87 <_panic>

008021cd <shrink>:

}
void shrink(uint32 newSize)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021d3:	83 ec 04             	sub    $0x4,%esp
  8021d6:	68 10 47 80 00       	push   $0x804710
  8021db:	68 42 01 00 00       	push   $0x142
  8021e0:	68 93 46 80 00       	push   $0x804693
  8021e5:	e8 9d ea ff ff       	call   800c87 <_panic>

008021ea <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021f0:	83 ec 04             	sub    $0x4,%esp
  8021f3:	68 10 47 80 00       	push   $0x804710
  8021f8:	68 47 01 00 00       	push   $0x147
  8021fd:	68 93 46 80 00       	push   $0x804693
  802202:	e8 80 ea ff ff       	call   800c87 <_panic>

00802207 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
  80220a:	57                   	push   %edi
  80220b:	56                   	push   %esi
  80220c:	53                   	push   %ebx
  80220d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	8b 55 0c             	mov    0xc(%ebp),%edx
  802216:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802219:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80221c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80221f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802222:	cd 30                	int    $0x30
  802224:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802227:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80222a:	83 c4 10             	add    $0x10,%esp
  80222d:	5b                   	pop    %ebx
  80222e:	5e                   	pop    %esi
  80222f:	5f                   	pop    %edi
  802230:	5d                   	pop    %ebp
  802231:	c3                   	ret    

00802232 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	83 ec 04             	sub    $0x4,%esp
  802238:	8b 45 10             	mov    0x10(%ebp),%eax
  80223b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80223e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	52                   	push   %edx
  80224a:	ff 75 0c             	pushl  0xc(%ebp)
  80224d:	50                   	push   %eax
  80224e:	6a 00                	push   $0x0
  802250:	e8 b2 ff ff ff       	call   802207 <syscall>
  802255:	83 c4 18             	add    $0x18,%esp
}
  802258:	90                   	nop
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <sys_cgetc>:

int
sys_cgetc(void)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 01                	push   $0x1
  80226a:	e8 98 ff ff ff       	call   802207 <syscall>
  80226f:	83 c4 18             	add    $0x18,%esp
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802277:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	52                   	push   %edx
  802284:	50                   	push   %eax
  802285:	6a 05                	push   $0x5
  802287:	e8 7b ff ff ff       	call   802207 <syscall>
  80228c:	83 c4 18             	add    $0x18,%esp
}
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	56                   	push   %esi
  802295:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802296:	8b 75 18             	mov    0x18(%ebp),%esi
  802299:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80229c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80229f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	56                   	push   %esi
  8022a6:	53                   	push   %ebx
  8022a7:	51                   	push   %ecx
  8022a8:	52                   	push   %edx
  8022a9:	50                   	push   %eax
  8022aa:	6a 06                	push   $0x6
  8022ac:	e8 56 ff ff ff       	call   802207 <syscall>
  8022b1:	83 c4 18             	add    $0x18,%esp
}
  8022b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022b7:	5b                   	pop    %ebx
  8022b8:	5e                   	pop    %esi
  8022b9:	5d                   	pop    %ebp
  8022ba:	c3                   	ret    

008022bb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	52                   	push   %edx
  8022cb:	50                   	push   %eax
  8022cc:	6a 07                	push   $0x7
  8022ce:	e8 34 ff ff ff       	call   802207 <syscall>
  8022d3:	83 c4 18             	add    $0x18,%esp
}
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    

008022d8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	ff 75 0c             	pushl  0xc(%ebp)
  8022e4:	ff 75 08             	pushl  0x8(%ebp)
  8022e7:	6a 08                	push   $0x8
  8022e9:	e8 19 ff ff ff       	call   802207 <syscall>
  8022ee:	83 c4 18             	add    $0x18,%esp
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 09                	push   $0x9
  802302:	e8 00 ff ff ff       	call   802207 <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 00                	push   $0x0
  802319:	6a 0a                	push   $0xa
  80231b:	e8 e7 fe ff ff       	call   802207 <syscall>
  802320:	83 c4 18             	add    $0x18,%esp
}
  802323:	c9                   	leave  
  802324:	c3                   	ret    

00802325 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 00                	push   $0x0
  80232e:	6a 00                	push   $0x0
  802330:	6a 00                	push   $0x0
  802332:	6a 0b                	push   $0xb
  802334:	e8 ce fe ff ff       	call   802207 <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	ff 75 0c             	pushl  0xc(%ebp)
  80234a:	ff 75 08             	pushl  0x8(%ebp)
  80234d:	6a 0f                	push   $0xf
  80234f:	e8 b3 fe ff ff       	call   802207 <syscall>
  802354:	83 c4 18             	add    $0x18,%esp
	return;
  802357:	90                   	nop
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	ff 75 0c             	pushl  0xc(%ebp)
  802366:	ff 75 08             	pushl  0x8(%ebp)
  802369:	6a 10                	push   $0x10
  80236b:	e8 97 fe ff ff       	call   802207 <syscall>
  802370:	83 c4 18             	add    $0x18,%esp
	return ;
  802373:	90                   	nop
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	ff 75 10             	pushl  0x10(%ebp)
  802380:	ff 75 0c             	pushl  0xc(%ebp)
  802383:	ff 75 08             	pushl  0x8(%ebp)
  802386:	6a 11                	push   $0x11
  802388:	e8 7a fe ff ff       	call   802207 <syscall>
  80238d:	83 c4 18             	add    $0x18,%esp
	return ;
  802390:	90                   	nop
}
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 0c                	push   $0xc
  8023a2:	e8 60 fe ff ff       	call   802207 <syscall>
  8023a7:	83 c4 18             	add    $0x18,%esp
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	ff 75 08             	pushl  0x8(%ebp)
  8023ba:	6a 0d                	push   $0xd
  8023bc:	e8 46 fe ff ff       	call   802207 <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 0e                	push   $0xe
  8023d5:	e8 2d fe ff ff       	call   802207 <syscall>
  8023da:	83 c4 18             	add    $0x18,%esp
}
  8023dd:	90                   	nop
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 13                	push   $0x13
  8023ef:	e8 13 fe ff ff       	call   802207 <syscall>
  8023f4:	83 c4 18             	add    $0x18,%esp
}
  8023f7:	90                   	nop
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 14                	push   $0x14
  802409:	e8 f9 fd ff ff       	call   802207 <syscall>
  80240e:	83 c4 18             	add    $0x18,%esp
}
  802411:	90                   	nop
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <sys_cputc>:


void
sys_cputc(const char c)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
  802417:	83 ec 04             	sub    $0x4,%esp
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802420:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	50                   	push   %eax
  80242d:	6a 15                	push   $0x15
  80242f:	e8 d3 fd ff ff       	call   802207 <syscall>
  802434:	83 c4 18             	add    $0x18,%esp
}
  802437:	90                   	nop
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 16                	push   $0x16
  802449:	e8 b9 fd ff ff       	call   802207 <syscall>
  80244e:	83 c4 18             	add    $0x18,%esp
}
  802451:	90                   	nop
  802452:	c9                   	leave  
  802453:	c3                   	ret    

00802454 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	ff 75 0c             	pushl  0xc(%ebp)
  802463:	50                   	push   %eax
  802464:	6a 17                	push   $0x17
  802466:	e8 9c fd ff ff       	call   802207 <syscall>
  80246b:	83 c4 18             	add    $0x18,%esp
}
  80246e:	c9                   	leave  
  80246f:	c3                   	ret    

00802470 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802473:	8b 55 0c             	mov    0xc(%ebp),%edx
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	52                   	push   %edx
  802480:	50                   	push   %eax
  802481:	6a 1a                	push   $0x1a
  802483:	e8 7f fd ff ff       	call   802207 <syscall>
  802488:	83 c4 18             	add    $0x18,%esp
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802490:	8b 55 0c             	mov    0xc(%ebp),%edx
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	52                   	push   %edx
  80249d:	50                   	push   %eax
  80249e:	6a 18                	push   $0x18
  8024a0:	e8 62 fd ff ff       	call   802207 <syscall>
  8024a5:	83 c4 18             	add    $0x18,%esp
}
  8024a8:	90                   	nop
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	52                   	push   %edx
  8024bb:	50                   	push   %eax
  8024bc:	6a 19                	push   $0x19
  8024be:	e8 44 fd ff ff       	call   802207 <syscall>
  8024c3:	83 c4 18             	add    $0x18,%esp
}
  8024c6:	90                   	nop
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    

008024c9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
  8024cc:	83 ec 04             	sub    $0x4,%esp
  8024cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024d5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024d8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	6a 00                	push   $0x0
  8024e1:	51                   	push   %ecx
  8024e2:	52                   	push   %edx
  8024e3:	ff 75 0c             	pushl  0xc(%ebp)
  8024e6:	50                   	push   %eax
  8024e7:	6a 1b                	push   $0x1b
  8024e9:	e8 19 fd ff ff       	call   802207 <syscall>
  8024ee:	83 c4 18             	add    $0x18,%esp
}
  8024f1:	c9                   	leave  
  8024f2:	c3                   	ret    

008024f3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8024f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	52                   	push   %edx
  802503:	50                   	push   %eax
  802504:	6a 1c                	push   $0x1c
  802506:	e8 fc fc ff ff       	call   802207 <syscall>
  80250b:	83 c4 18             	add    $0x18,%esp
}
  80250e:	c9                   	leave  
  80250f:	c3                   	ret    

00802510 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802513:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802516:	8b 55 0c             	mov    0xc(%ebp),%edx
  802519:	8b 45 08             	mov    0x8(%ebp),%eax
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	51                   	push   %ecx
  802521:	52                   	push   %edx
  802522:	50                   	push   %eax
  802523:	6a 1d                	push   $0x1d
  802525:	e8 dd fc ff ff       	call   802207 <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802532:	8b 55 0c             	mov    0xc(%ebp),%edx
  802535:	8b 45 08             	mov    0x8(%ebp),%eax
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	52                   	push   %edx
  80253f:	50                   	push   %eax
  802540:	6a 1e                	push   $0x1e
  802542:	e8 c0 fc ff ff       	call   802207 <syscall>
  802547:	83 c4 18             	add    $0x18,%esp
}
  80254a:	c9                   	leave  
  80254b:	c3                   	ret    

0080254c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	6a 1f                	push   $0x1f
  80255b:	e8 a7 fc ff ff       	call   802207 <syscall>
  802560:	83 c4 18             	add    $0x18,%esp
}
  802563:	c9                   	leave  
  802564:	c3                   	ret    

00802565 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802568:	8b 45 08             	mov    0x8(%ebp),%eax
  80256b:	6a 00                	push   $0x0
  80256d:	ff 75 14             	pushl  0x14(%ebp)
  802570:	ff 75 10             	pushl  0x10(%ebp)
  802573:	ff 75 0c             	pushl  0xc(%ebp)
  802576:	50                   	push   %eax
  802577:	6a 20                	push   $0x20
  802579:	e8 89 fc ff ff       	call   802207 <syscall>
  80257e:	83 c4 18             	add    $0x18,%esp
}
  802581:	c9                   	leave  
  802582:	c3                   	ret    

00802583 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802586:	8b 45 08             	mov    0x8(%ebp),%eax
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	50                   	push   %eax
  802592:	6a 21                	push   $0x21
  802594:	e8 6e fc ff ff       	call   802207 <syscall>
  802599:	83 c4 18             	add    $0x18,%esp
}
  80259c:	90                   	nop
  80259d:	c9                   	leave  
  80259e:	c3                   	ret    

0080259f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	50                   	push   %eax
  8025ae:	6a 22                	push   $0x22
  8025b0:	e8 52 fc ff ff       	call   802207 <syscall>
  8025b5:	83 c4 18             	add    $0x18,%esp
}
  8025b8:	c9                   	leave  
  8025b9:	c3                   	ret    

008025ba <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 02                	push   $0x2
  8025c9:	e8 39 fc ff ff       	call   802207 <syscall>
  8025ce:	83 c4 18             	add    $0x18,%esp
}
  8025d1:	c9                   	leave  
  8025d2:	c3                   	ret    

008025d3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8025d3:	55                   	push   %ebp
  8025d4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 00                	push   $0x0
  8025e0:	6a 03                	push   $0x3
  8025e2:	e8 20 fc ff ff       	call   802207 <syscall>
  8025e7:	83 c4 18             	add    $0x18,%esp
}
  8025ea:	c9                   	leave  
  8025eb:	c3                   	ret    

008025ec <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 04                	push   $0x4
  8025fb:	e8 07 fc ff ff       	call   802207 <syscall>
  802600:	83 c4 18             	add    $0x18,%esp
}
  802603:	c9                   	leave  
  802604:	c3                   	ret    

00802605 <sys_exit_env>:


void sys_exit_env(void)
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	6a 00                	push   $0x0
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 23                	push   $0x23
  802614:	e8 ee fb ff ff       	call   802207 <syscall>
  802619:	83 c4 18             	add    $0x18,%esp
}
  80261c:	90                   	nop
  80261d:	c9                   	leave  
  80261e:	c3                   	ret    

0080261f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80261f:	55                   	push   %ebp
  802620:	89 e5                	mov    %esp,%ebp
  802622:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802625:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802628:	8d 50 04             	lea    0x4(%eax),%edx
  80262b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	52                   	push   %edx
  802635:	50                   	push   %eax
  802636:	6a 24                	push   $0x24
  802638:	e8 ca fb ff ff       	call   802207 <syscall>
  80263d:	83 c4 18             	add    $0x18,%esp
	return result;
  802640:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802643:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802646:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802649:	89 01                	mov    %eax,(%ecx)
  80264b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80264e:	8b 45 08             	mov    0x8(%ebp),%eax
  802651:	c9                   	leave  
  802652:	c2 04 00             	ret    $0x4

00802655 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	ff 75 10             	pushl  0x10(%ebp)
  80265f:	ff 75 0c             	pushl  0xc(%ebp)
  802662:	ff 75 08             	pushl  0x8(%ebp)
  802665:	6a 12                	push   $0x12
  802667:	e8 9b fb ff ff       	call   802207 <syscall>
  80266c:	83 c4 18             	add    $0x18,%esp
	return ;
  80266f:	90                   	nop
}
  802670:	c9                   	leave  
  802671:	c3                   	ret    

00802672 <sys_rcr2>:
uint32 sys_rcr2()
{
  802672:	55                   	push   %ebp
  802673:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 25                	push   $0x25
  802681:	e8 81 fb ff ff       	call   802207 <syscall>
  802686:	83 c4 18             	add    $0x18,%esp
}
  802689:	c9                   	leave  
  80268a:	c3                   	ret    

0080268b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
  80268e:	83 ec 04             	sub    $0x4,%esp
  802691:	8b 45 08             	mov    0x8(%ebp),%eax
  802694:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802697:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	6a 00                	push   $0x0
  8026a1:	6a 00                	push   $0x0
  8026a3:	50                   	push   %eax
  8026a4:	6a 26                	push   $0x26
  8026a6:	e8 5c fb ff ff       	call   802207 <syscall>
  8026ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ae:	90                   	nop
}
  8026af:	c9                   	leave  
  8026b0:	c3                   	ret    

008026b1 <rsttst>:
void rsttst()
{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 28                	push   $0x28
  8026c0:	e8 42 fb ff ff       	call   802207 <syscall>
  8026c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8026c8:	90                   	nop
}
  8026c9:	c9                   	leave  
  8026ca:	c3                   	ret    

008026cb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026cb:	55                   	push   %ebp
  8026cc:	89 e5                	mov    %esp,%ebp
  8026ce:	83 ec 04             	sub    $0x4,%esp
  8026d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8026d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026d7:	8b 55 18             	mov    0x18(%ebp),%edx
  8026da:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026de:	52                   	push   %edx
  8026df:	50                   	push   %eax
  8026e0:	ff 75 10             	pushl  0x10(%ebp)
  8026e3:	ff 75 0c             	pushl  0xc(%ebp)
  8026e6:	ff 75 08             	pushl  0x8(%ebp)
  8026e9:	6a 27                	push   $0x27
  8026eb:	e8 17 fb ff ff       	call   802207 <syscall>
  8026f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f3:	90                   	nop
}
  8026f4:	c9                   	leave  
  8026f5:	c3                   	ret    

008026f6 <chktst>:
void chktst(uint32 n)
{
  8026f6:	55                   	push   %ebp
  8026f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026f9:	6a 00                	push   $0x0
  8026fb:	6a 00                	push   $0x0
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	ff 75 08             	pushl  0x8(%ebp)
  802704:	6a 29                	push   $0x29
  802706:	e8 fc fa ff ff       	call   802207 <syscall>
  80270b:	83 c4 18             	add    $0x18,%esp
	return ;
  80270e:	90                   	nop
}
  80270f:	c9                   	leave  
  802710:	c3                   	ret    

00802711 <inctst>:

void inctst()
{
  802711:	55                   	push   %ebp
  802712:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 2a                	push   $0x2a
  802720:	e8 e2 fa ff ff       	call   802207 <syscall>
  802725:	83 c4 18             	add    $0x18,%esp
	return ;
  802728:	90                   	nop
}
  802729:	c9                   	leave  
  80272a:	c3                   	ret    

0080272b <gettst>:
uint32 gettst()
{
  80272b:	55                   	push   %ebp
  80272c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	6a 00                	push   $0x0
  802736:	6a 00                	push   $0x0
  802738:	6a 2b                	push   $0x2b
  80273a:	e8 c8 fa ff ff       	call   802207 <syscall>
  80273f:	83 c4 18             	add    $0x18,%esp
}
  802742:	c9                   	leave  
  802743:	c3                   	ret    

00802744 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802744:	55                   	push   %ebp
  802745:	89 e5                	mov    %esp,%ebp
  802747:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	6a 00                	push   $0x0
  802752:	6a 00                	push   $0x0
  802754:	6a 2c                	push   $0x2c
  802756:	e8 ac fa ff ff       	call   802207 <syscall>
  80275b:	83 c4 18             	add    $0x18,%esp
  80275e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802761:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802765:	75 07                	jne    80276e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802767:	b8 01 00 00 00       	mov    $0x1,%eax
  80276c:	eb 05                	jmp    802773 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80276e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802773:	c9                   	leave  
  802774:	c3                   	ret    

00802775 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802775:	55                   	push   %ebp
  802776:	89 e5                	mov    %esp,%ebp
  802778:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80277b:	6a 00                	push   $0x0
  80277d:	6a 00                	push   $0x0
  80277f:	6a 00                	push   $0x0
  802781:	6a 00                	push   $0x0
  802783:	6a 00                	push   $0x0
  802785:	6a 2c                	push   $0x2c
  802787:	e8 7b fa ff ff       	call   802207 <syscall>
  80278c:	83 c4 18             	add    $0x18,%esp
  80278f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802792:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802796:	75 07                	jne    80279f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802798:	b8 01 00 00 00       	mov    $0x1,%eax
  80279d:	eb 05                	jmp    8027a4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80279f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027a4:	c9                   	leave  
  8027a5:	c3                   	ret    

008027a6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8027a6:	55                   	push   %ebp
  8027a7:	89 e5                	mov    %esp,%ebp
  8027a9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027ac:	6a 00                	push   $0x0
  8027ae:	6a 00                	push   $0x0
  8027b0:	6a 00                	push   $0x0
  8027b2:	6a 00                	push   $0x0
  8027b4:	6a 00                	push   $0x0
  8027b6:	6a 2c                	push   $0x2c
  8027b8:	e8 4a fa ff ff       	call   802207 <syscall>
  8027bd:	83 c4 18             	add    $0x18,%esp
  8027c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8027c3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8027c7:	75 07                	jne    8027d0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ce:	eb 05                	jmp    8027d5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027d5:	c9                   	leave  
  8027d6:	c3                   	ret    

008027d7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027d7:	55                   	push   %ebp
  8027d8:	89 e5                	mov    %esp,%ebp
  8027da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027dd:	6a 00                	push   $0x0
  8027df:	6a 00                	push   $0x0
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 2c                	push   $0x2c
  8027e9:	e8 19 fa ff ff       	call   802207 <syscall>
  8027ee:	83 c4 18             	add    $0x18,%esp
  8027f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027f4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027f8:	75 07                	jne    802801 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ff:	eb 05                	jmp    802806 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802801:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802806:	c9                   	leave  
  802807:	c3                   	ret    

00802808 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802808:	55                   	push   %ebp
  802809:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80280b:	6a 00                	push   $0x0
  80280d:	6a 00                	push   $0x0
  80280f:	6a 00                	push   $0x0
  802811:	6a 00                	push   $0x0
  802813:	ff 75 08             	pushl  0x8(%ebp)
  802816:	6a 2d                	push   $0x2d
  802818:	e8 ea f9 ff ff       	call   802207 <syscall>
  80281d:	83 c4 18             	add    $0x18,%esp
	return ;
  802820:	90                   	nop
}
  802821:	c9                   	leave  
  802822:	c3                   	ret    

00802823 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802823:	55                   	push   %ebp
  802824:	89 e5                	mov    %esp,%ebp
  802826:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802827:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80282a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80282d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802830:	8b 45 08             	mov    0x8(%ebp),%eax
  802833:	6a 00                	push   $0x0
  802835:	53                   	push   %ebx
  802836:	51                   	push   %ecx
  802837:	52                   	push   %edx
  802838:	50                   	push   %eax
  802839:	6a 2e                	push   $0x2e
  80283b:	e8 c7 f9 ff ff       	call   802207 <syscall>
  802840:	83 c4 18             	add    $0x18,%esp
}
  802843:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802846:	c9                   	leave  
  802847:	c3                   	ret    

00802848 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802848:	55                   	push   %ebp
  802849:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80284b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80284e:	8b 45 08             	mov    0x8(%ebp),%eax
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	6a 00                	push   $0x0
  802857:	52                   	push   %edx
  802858:	50                   	push   %eax
  802859:	6a 2f                	push   $0x2f
  80285b:	e8 a7 f9 ff ff       	call   802207 <syscall>
  802860:	83 c4 18             	add    $0x18,%esp
}
  802863:	c9                   	leave  
  802864:	c3                   	ret    

00802865 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802865:	55                   	push   %ebp
  802866:	89 e5                	mov    %esp,%ebp
  802868:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80286b:	83 ec 0c             	sub    $0xc,%esp
  80286e:	68 20 47 80 00       	push   $0x804720
  802873:	e8 c3 e6 ff ff       	call   800f3b <cprintf>
  802878:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80287b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802882:	83 ec 0c             	sub    $0xc,%esp
  802885:	68 4c 47 80 00       	push   $0x80474c
  80288a:	e8 ac e6 ff ff       	call   800f3b <cprintf>
  80288f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802892:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802896:	a1 38 51 80 00       	mov    0x805138,%eax
  80289b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289e:	eb 56                	jmp    8028f6 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8028a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028a4:	74 1c                	je     8028c2 <print_mem_block_lists+0x5d>
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 50 08             	mov    0x8(%eax),%edx
  8028ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028af:	8b 48 08             	mov    0x8(%eax),%ecx
  8028b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b8:	01 c8                	add    %ecx,%eax
  8028ba:	39 c2                	cmp    %eax,%edx
  8028bc:	73 04                	jae    8028c2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8028be:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 50 08             	mov    0x8(%eax),%edx
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ce:	01 c2                	add    %eax,%edx
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 40 08             	mov    0x8(%eax),%eax
  8028d6:	83 ec 04             	sub    $0x4,%esp
  8028d9:	52                   	push   %edx
  8028da:	50                   	push   %eax
  8028db:	68 61 47 80 00       	push   $0x804761
  8028e0:	e8 56 e6 ff ff       	call   800f3b <cprintf>
  8028e5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8028f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fa:	74 07                	je     802903 <print_mem_block_lists+0x9e>
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 00                	mov    (%eax),%eax
  802901:	eb 05                	jmp    802908 <print_mem_block_lists+0xa3>
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
  802908:	a3 40 51 80 00       	mov    %eax,0x805140
  80290d:	a1 40 51 80 00       	mov    0x805140,%eax
  802912:	85 c0                	test   %eax,%eax
  802914:	75 8a                	jne    8028a0 <print_mem_block_lists+0x3b>
  802916:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291a:	75 84                	jne    8028a0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80291c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802920:	75 10                	jne    802932 <print_mem_block_lists+0xcd>
  802922:	83 ec 0c             	sub    $0xc,%esp
  802925:	68 70 47 80 00       	push   $0x804770
  80292a:	e8 0c e6 ff ff       	call   800f3b <cprintf>
  80292f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802932:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802939:	83 ec 0c             	sub    $0xc,%esp
  80293c:	68 94 47 80 00       	push   $0x804794
  802941:	e8 f5 e5 ff ff       	call   800f3b <cprintf>
  802946:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802949:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80294d:	a1 40 50 80 00       	mov    0x805040,%eax
  802952:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802955:	eb 56                	jmp    8029ad <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802957:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80295b:	74 1c                	je     802979 <print_mem_block_lists+0x114>
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 50 08             	mov    0x8(%eax),%edx
  802963:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802966:	8b 48 08             	mov    0x8(%eax),%ecx
  802969:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296c:	8b 40 0c             	mov    0xc(%eax),%eax
  80296f:	01 c8                	add    %ecx,%eax
  802971:	39 c2                	cmp    %eax,%edx
  802973:	73 04                	jae    802979 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802975:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 50 08             	mov    0x8(%eax),%edx
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 40 0c             	mov    0xc(%eax),%eax
  802985:	01 c2                	add    %eax,%edx
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	8b 40 08             	mov    0x8(%eax),%eax
  80298d:	83 ec 04             	sub    $0x4,%esp
  802990:	52                   	push   %edx
  802991:	50                   	push   %eax
  802992:	68 61 47 80 00       	push   $0x804761
  802997:	e8 9f e5 ff ff       	call   800f3b <cprintf>
  80299c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029a5:	a1 48 50 80 00       	mov    0x805048,%eax
  8029aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b1:	74 07                	je     8029ba <print_mem_block_lists+0x155>
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	8b 00                	mov    (%eax),%eax
  8029b8:	eb 05                	jmp    8029bf <print_mem_block_lists+0x15a>
  8029ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8029bf:	a3 48 50 80 00       	mov    %eax,0x805048
  8029c4:	a1 48 50 80 00       	mov    0x805048,%eax
  8029c9:	85 c0                	test   %eax,%eax
  8029cb:	75 8a                	jne    802957 <print_mem_block_lists+0xf2>
  8029cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d1:	75 84                	jne    802957 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8029d3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029d7:	75 10                	jne    8029e9 <print_mem_block_lists+0x184>
  8029d9:	83 ec 0c             	sub    $0xc,%esp
  8029dc:	68 ac 47 80 00       	push   $0x8047ac
  8029e1:	e8 55 e5 ff ff       	call   800f3b <cprintf>
  8029e6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8029e9:	83 ec 0c             	sub    $0xc,%esp
  8029ec:	68 20 47 80 00       	push   $0x804720
  8029f1:	e8 45 e5 ff ff       	call   800f3b <cprintf>
  8029f6:	83 c4 10             	add    $0x10,%esp

}
  8029f9:	90                   	nop
  8029fa:	c9                   	leave  
  8029fb:	c3                   	ret    

008029fc <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8029fc:	55                   	push   %ebp
  8029fd:	89 e5                	mov    %esp,%ebp
  8029ff:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802a02:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802a09:	00 00 00 
  802a0c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802a13:	00 00 00 
  802a16:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802a1d:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802a20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a27:	e9 9e 00 00 00       	jmp    802aca <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802a2c:	a1 50 50 80 00       	mov    0x805050,%eax
  802a31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a34:	c1 e2 04             	shl    $0x4,%edx
  802a37:	01 d0                	add    %edx,%eax
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	75 14                	jne    802a51 <initialize_MemBlocksList+0x55>
  802a3d:	83 ec 04             	sub    $0x4,%esp
  802a40:	68 d4 47 80 00       	push   $0x8047d4
  802a45:	6a 47                	push   $0x47
  802a47:	68 f7 47 80 00       	push   $0x8047f7
  802a4c:	e8 36 e2 ff ff       	call   800c87 <_panic>
  802a51:	a1 50 50 80 00       	mov    0x805050,%eax
  802a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a59:	c1 e2 04             	shl    $0x4,%edx
  802a5c:	01 d0                	add    %edx,%eax
  802a5e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a64:	89 10                	mov    %edx,(%eax)
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	74 18                	je     802a84 <initialize_MemBlocksList+0x88>
  802a6c:	a1 48 51 80 00       	mov    0x805148,%eax
  802a71:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a77:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a7a:	c1 e1 04             	shl    $0x4,%ecx
  802a7d:	01 ca                	add    %ecx,%edx
  802a7f:	89 50 04             	mov    %edx,0x4(%eax)
  802a82:	eb 12                	jmp    802a96 <initialize_MemBlocksList+0x9a>
  802a84:	a1 50 50 80 00       	mov    0x805050,%eax
  802a89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8c:	c1 e2 04             	shl    $0x4,%edx
  802a8f:	01 d0                	add    %edx,%eax
  802a91:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a96:	a1 50 50 80 00       	mov    0x805050,%eax
  802a9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9e:	c1 e2 04             	shl    $0x4,%edx
  802aa1:	01 d0                	add    %edx,%eax
  802aa3:	a3 48 51 80 00       	mov    %eax,0x805148
  802aa8:	a1 50 50 80 00       	mov    0x805050,%eax
  802aad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab0:	c1 e2 04             	shl    $0x4,%edx
  802ab3:	01 d0                	add    %edx,%eax
  802ab5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abc:	a1 54 51 80 00       	mov    0x805154,%eax
  802ac1:	40                   	inc    %eax
  802ac2:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802ac7:	ff 45 f4             	incl   -0xc(%ebp)
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad0:	0f 82 56 ff ff ff    	jb     802a2c <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802ad6:	90                   	nop
  802ad7:	c9                   	leave  
  802ad8:	c3                   	ret    

00802ad9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802ad9:	55                   	push   %ebp
  802ada:	89 e5                	mov    %esp,%ebp
  802adc:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802adf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae2:	8b 00                	mov    (%eax),%eax
  802ae4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ae7:	eb 19                	jmp    802b02 <find_block+0x29>
	{
		if(element->sva == va){
  802ae9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802aec:	8b 40 08             	mov    0x8(%eax),%eax
  802aef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802af2:	75 05                	jne    802af9 <find_block+0x20>
			 		return element;
  802af4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802af7:	eb 36                	jmp    802b2f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802af9:	8b 45 08             	mov    0x8(%ebp),%eax
  802afc:	8b 40 08             	mov    0x8(%eax),%eax
  802aff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b02:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b06:	74 07                	je     802b0f <find_block+0x36>
  802b08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b0b:	8b 00                	mov    (%eax),%eax
  802b0d:	eb 05                	jmp    802b14 <find_block+0x3b>
  802b0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b14:	8b 55 08             	mov    0x8(%ebp),%edx
  802b17:	89 42 08             	mov    %eax,0x8(%edx)
  802b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1d:	8b 40 08             	mov    0x8(%eax),%eax
  802b20:	85 c0                	test   %eax,%eax
  802b22:	75 c5                	jne    802ae9 <find_block+0x10>
  802b24:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b28:	75 bf                	jne    802ae9 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802b2a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b2f:	c9                   	leave  
  802b30:	c3                   	ret    

00802b31 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802b31:	55                   	push   %ebp
  802b32:	89 e5                	mov    %esp,%ebp
  802b34:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802b37:	a1 44 50 80 00       	mov    0x805044,%eax
  802b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802b3f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b44:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802b47:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b4b:	74 0a                	je     802b57 <insert_sorted_allocList+0x26>
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	8b 40 08             	mov    0x8(%eax),%eax
  802b53:	85 c0                	test   %eax,%eax
  802b55:	75 65                	jne    802bbc <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802b57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b5b:	75 14                	jne    802b71 <insert_sorted_allocList+0x40>
  802b5d:	83 ec 04             	sub    $0x4,%esp
  802b60:	68 d4 47 80 00       	push   $0x8047d4
  802b65:	6a 6e                	push   $0x6e
  802b67:	68 f7 47 80 00       	push   $0x8047f7
  802b6c:	e8 16 e1 ff ff       	call   800c87 <_panic>
  802b71:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	89 10                	mov    %edx,(%eax)
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	85 c0                	test   %eax,%eax
  802b83:	74 0d                	je     802b92 <insert_sorted_allocList+0x61>
  802b85:	a1 40 50 80 00       	mov    0x805040,%eax
  802b8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8d:	89 50 04             	mov    %edx,0x4(%eax)
  802b90:	eb 08                	jmp    802b9a <insert_sorted_allocList+0x69>
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	a3 44 50 80 00       	mov    %eax,0x805044
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	a3 40 50 80 00       	mov    %eax,0x805040
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bac:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bb1:	40                   	inc    %eax
  802bb2:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802bb7:	e9 cf 01 00 00       	jmp    802d8b <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbf:	8b 50 08             	mov    0x8(%eax),%edx
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	8b 40 08             	mov    0x8(%eax),%eax
  802bc8:	39 c2                	cmp    %eax,%edx
  802bca:	73 65                	jae    802c31 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802bcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd0:	75 14                	jne    802be6 <insert_sorted_allocList+0xb5>
  802bd2:	83 ec 04             	sub    $0x4,%esp
  802bd5:	68 10 48 80 00       	push   $0x804810
  802bda:	6a 72                	push   $0x72
  802bdc:	68 f7 47 80 00       	push   $0x8047f7
  802be1:	e8 a1 e0 ff ff       	call   800c87 <_panic>
  802be6:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	89 50 04             	mov    %edx,0x4(%eax)
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	8b 40 04             	mov    0x4(%eax),%eax
  802bf8:	85 c0                	test   %eax,%eax
  802bfa:	74 0c                	je     802c08 <insert_sorted_allocList+0xd7>
  802bfc:	a1 44 50 80 00       	mov    0x805044,%eax
  802c01:	8b 55 08             	mov    0x8(%ebp),%edx
  802c04:	89 10                	mov    %edx,(%eax)
  802c06:	eb 08                	jmp    802c10 <insert_sorted_allocList+0xdf>
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	a3 40 50 80 00       	mov    %eax,0x805040
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	a3 44 50 80 00       	mov    %eax,0x805044
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c21:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c26:	40                   	inc    %eax
  802c27:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802c2c:	e9 5a 01 00 00       	jmp    802d8b <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c34:	8b 50 08             	mov    0x8(%eax),%edx
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	8b 40 08             	mov    0x8(%eax),%eax
  802c3d:	39 c2                	cmp    %eax,%edx
  802c3f:	75 70                	jne    802cb1 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802c41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c45:	74 06                	je     802c4d <insert_sorted_allocList+0x11c>
  802c47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4b:	75 14                	jne    802c61 <insert_sorted_allocList+0x130>
  802c4d:	83 ec 04             	sub    $0x4,%esp
  802c50:	68 34 48 80 00       	push   $0x804834
  802c55:	6a 75                	push   $0x75
  802c57:	68 f7 47 80 00       	push   $0x8047f7
  802c5c:	e8 26 e0 ff ff       	call   800c87 <_panic>
  802c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c64:	8b 10                	mov    (%eax),%edx
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	89 10                	mov    %edx,(%eax)
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	8b 00                	mov    (%eax),%eax
  802c70:	85 c0                	test   %eax,%eax
  802c72:	74 0b                	je     802c7f <insert_sorted_allocList+0x14e>
  802c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7c:	89 50 04             	mov    %edx,0x4(%eax)
  802c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c82:	8b 55 08             	mov    0x8(%ebp),%edx
  802c85:	89 10                	mov    %edx,(%eax)
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c8d:	89 50 04             	mov    %edx,0x4(%eax)
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	85 c0                	test   %eax,%eax
  802c97:	75 08                	jne    802ca1 <insert_sorted_allocList+0x170>
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	a3 44 50 80 00       	mov    %eax,0x805044
  802ca1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ca6:	40                   	inc    %eax
  802ca7:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802cac:	e9 da 00 00 00       	jmp    802d8b <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802cb1:	a1 40 50 80 00       	mov    0x805040,%eax
  802cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb9:	e9 9d 00 00 00       	jmp    802d5b <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	8b 00                	mov    (%eax),%eax
  802cc3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	8b 50 08             	mov    0x8(%eax),%edx
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 40 08             	mov    0x8(%eax),%eax
  802cd2:	39 c2                	cmp    %eax,%edx
  802cd4:	76 7d                	jbe    802d53 <insert_sorted_allocList+0x222>
  802cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd9:	8b 50 08             	mov    0x8(%eax),%edx
  802cdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cdf:	8b 40 08             	mov    0x8(%eax),%eax
  802ce2:	39 c2                	cmp    %eax,%edx
  802ce4:	73 6d                	jae    802d53 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802ce6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cea:	74 06                	je     802cf2 <insert_sorted_allocList+0x1c1>
  802cec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf0:	75 14                	jne    802d06 <insert_sorted_allocList+0x1d5>
  802cf2:	83 ec 04             	sub    $0x4,%esp
  802cf5:	68 34 48 80 00       	push   $0x804834
  802cfa:	6a 7c                	push   $0x7c
  802cfc:	68 f7 47 80 00       	push   $0x8047f7
  802d01:	e8 81 df ff ff       	call   800c87 <_panic>
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	8b 10                	mov    (%eax),%edx
  802d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0e:	89 10                	mov    %edx,(%eax)
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	8b 00                	mov    (%eax),%eax
  802d15:	85 c0                	test   %eax,%eax
  802d17:	74 0b                	je     802d24 <insert_sorted_allocList+0x1f3>
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d21:	89 50 04             	mov    %edx,0x4(%eax)
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2a:	89 10                	mov    %edx,(%eax)
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d32:	89 50 04             	mov    %edx,0x4(%eax)
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	75 08                	jne    802d46 <insert_sorted_allocList+0x215>
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	a3 44 50 80 00       	mov    %eax,0x805044
  802d46:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d4b:	40                   	inc    %eax
  802d4c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802d51:	eb 38                	jmp    802d8b <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802d53:	a1 48 50 80 00       	mov    0x805048,%eax
  802d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5f:	74 07                	je     802d68 <insert_sorted_allocList+0x237>
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 00                	mov    (%eax),%eax
  802d66:	eb 05                	jmp    802d6d <insert_sorted_allocList+0x23c>
  802d68:	b8 00 00 00 00       	mov    $0x0,%eax
  802d6d:	a3 48 50 80 00       	mov    %eax,0x805048
  802d72:	a1 48 50 80 00       	mov    0x805048,%eax
  802d77:	85 c0                	test   %eax,%eax
  802d79:	0f 85 3f ff ff ff    	jne    802cbe <insert_sorted_allocList+0x18d>
  802d7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d83:	0f 85 35 ff ff ff    	jne    802cbe <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802d89:	eb 00                	jmp    802d8b <insert_sorted_allocList+0x25a>
  802d8b:	90                   	nop
  802d8c:	c9                   	leave  
  802d8d:	c3                   	ret    

00802d8e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802d8e:	55                   	push   %ebp
  802d8f:	89 e5                	mov    %esp,%ebp
  802d91:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802d94:	a1 38 51 80 00       	mov    0x805138,%eax
  802d99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d9c:	e9 6b 02 00 00       	jmp    80300c <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da4:	8b 40 0c             	mov    0xc(%eax),%eax
  802da7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802daa:	0f 85 90 00 00 00    	jne    802e40 <alloc_block_FF+0xb2>
			  temp=element;
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802db6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dba:	75 17                	jne    802dd3 <alloc_block_FF+0x45>
  802dbc:	83 ec 04             	sub    $0x4,%esp
  802dbf:	68 68 48 80 00       	push   $0x804868
  802dc4:	68 92 00 00 00       	push   $0x92
  802dc9:	68 f7 47 80 00       	push   $0x8047f7
  802dce:	e8 b4 de ff ff       	call   800c87 <_panic>
  802dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd6:	8b 00                	mov    (%eax),%eax
  802dd8:	85 c0                	test   %eax,%eax
  802dda:	74 10                	je     802dec <alloc_block_FF+0x5e>
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	8b 00                	mov    (%eax),%eax
  802de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de4:	8b 52 04             	mov    0x4(%edx),%edx
  802de7:	89 50 04             	mov    %edx,0x4(%eax)
  802dea:	eb 0b                	jmp    802df7 <alloc_block_FF+0x69>
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	8b 40 04             	mov    0x4(%eax),%eax
  802df2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfa:	8b 40 04             	mov    0x4(%eax),%eax
  802dfd:	85 c0                	test   %eax,%eax
  802dff:	74 0f                	je     802e10 <alloc_block_FF+0x82>
  802e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e04:	8b 40 04             	mov    0x4(%eax),%eax
  802e07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e0a:	8b 12                	mov    (%edx),%edx
  802e0c:	89 10                	mov    %edx,(%eax)
  802e0e:	eb 0a                	jmp    802e1a <alloc_block_FF+0x8c>
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	8b 00                	mov    (%eax),%eax
  802e15:	a3 38 51 80 00       	mov    %eax,0x805138
  802e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2d:	a1 44 51 80 00       	mov    0x805144,%eax
  802e32:	48                   	dec    %eax
  802e33:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802e38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3b:	e9 ff 01 00 00       	jmp    80303f <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	8b 40 0c             	mov    0xc(%eax),%eax
  802e46:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e49:	0f 86 b5 01 00 00    	jbe    803004 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	8b 40 0c             	mov    0xc(%eax),%eax
  802e55:	2b 45 08             	sub    0x8(%ebp),%eax
  802e58:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802e5b:	a1 48 51 80 00       	mov    0x805148,%eax
  802e60:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802e63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e67:	75 17                	jne    802e80 <alloc_block_FF+0xf2>
  802e69:	83 ec 04             	sub    $0x4,%esp
  802e6c:	68 68 48 80 00       	push   $0x804868
  802e71:	68 99 00 00 00       	push   $0x99
  802e76:	68 f7 47 80 00       	push   $0x8047f7
  802e7b:	e8 07 de ff ff       	call   800c87 <_panic>
  802e80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e83:	8b 00                	mov    (%eax),%eax
  802e85:	85 c0                	test   %eax,%eax
  802e87:	74 10                	je     802e99 <alloc_block_FF+0x10b>
  802e89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8c:	8b 00                	mov    (%eax),%eax
  802e8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e91:	8b 52 04             	mov    0x4(%edx),%edx
  802e94:	89 50 04             	mov    %edx,0x4(%eax)
  802e97:	eb 0b                	jmp    802ea4 <alloc_block_FF+0x116>
  802e99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9c:	8b 40 04             	mov    0x4(%eax),%eax
  802e9f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ea4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea7:	8b 40 04             	mov    0x4(%eax),%eax
  802eaa:	85 c0                	test   %eax,%eax
  802eac:	74 0f                	je     802ebd <alloc_block_FF+0x12f>
  802eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb1:	8b 40 04             	mov    0x4(%eax),%eax
  802eb4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802eb7:	8b 12                	mov    (%edx),%edx
  802eb9:	89 10                	mov    %edx,(%eax)
  802ebb:	eb 0a                	jmp    802ec7 <alloc_block_FF+0x139>
  802ebd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec0:	8b 00                	mov    (%eax),%eax
  802ec2:	a3 48 51 80 00       	mov    %eax,0x805148
  802ec7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eda:	a1 54 51 80 00       	mov    0x805154,%eax
  802edf:	48                   	dec    %eax
  802ee0:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802ee5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ee9:	75 17                	jne    802f02 <alloc_block_FF+0x174>
  802eeb:	83 ec 04             	sub    $0x4,%esp
  802eee:	68 10 48 80 00       	push   $0x804810
  802ef3:	68 9a 00 00 00       	push   $0x9a
  802ef8:	68 f7 47 80 00       	push   $0x8047f7
  802efd:	e8 85 dd ff ff       	call   800c87 <_panic>
  802f02:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0b:	89 50 04             	mov    %edx,0x4(%eax)
  802f0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f11:	8b 40 04             	mov    0x4(%eax),%eax
  802f14:	85 c0                	test   %eax,%eax
  802f16:	74 0c                	je     802f24 <alloc_block_FF+0x196>
  802f18:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f1d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f20:	89 10                	mov    %edx,(%eax)
  802f22:	eb 08                	jmp    802f2c <alloc_block_FF+0x19e>
  802f24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f27:	a3 38 51 80 00       	mov    %eax,0x805138
  802f2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3d:	a1 44 51 80 00       	mov    0x805144,%eax
  802f42:	40                   	inc    %eax
  802f43:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802f48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4e:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	8b 50 08             	mov    0x8(%eax),%edx
  802f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5a:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f63:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f69:	8b 50 08             	mov    0x8(%eax),%edx
  802f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6f:	01 c2                	add    %eax,%edx
  802f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f74:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802f77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802f7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f81:	75 17                	jne    802f9a <alloc_block_FF+0x20c>
  802f83:	83 ec 04             	sub    $0x4,%esp
  802f86:	68 68 48 80 00       	push   $0x804868
  802f8b:	68 a2 00 00 00       	push   $0xa2
  802f90:	68 f7 47 80 00       	push   $0x8047f7
  802f95:	e8 ed dc ff ff       	call   800c87 <_panic>
  802f9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9d:	8b 00                	mov    (%eax),%eax
  802f9f:	85 c0                	test   %eax,%eax
  802fa1:	74 10                	je     802fb3 <alloc_block_FF+0x225>
  802fa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa6:	8b 00                	mov    (%eax),%eax
  802fa8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fab:	8b 52 04             	mov    0x4(%edx),%edx
  802fae:	89 50 04             	mov    %edx,0x4(%eax)
  802fb1:	eb 0b                	jmp    802fbe <alloc_block_FF+0x230>
  802fb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb6:	8b 40 04             	mov    0x4(%eax),%eax
  802fb9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc1:	8b 40 04             	mov    0x4(%eax),%eax
  802fc4:	85 c0                	test   %eax,%eax
  802fc6:	74 0f                	je     802fd7 <alloc_block_FF+0x249>
  802fc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcb:	8b 40 04             	mov    0x4(%eax),%eax
  802fce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fd1:	8b 12                	mov    (%edx),%edx
  802fd3:	89 10                	mov    %edx,(%eax)
  802fd5:	eb 0a                	jmp    802fe1 <alloc_block_FF+0x253>
  802fd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fda:	8b 00                	mov    (%eax),%eax
  802fdc:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff4:	a1 44 51 80 00       	mov    0x805144,%eax
  802ff9:	48                   	dec    %eax
  802ffa:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802fff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803002:	eb 3b                	jmp    80303f <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  803004:	a1 40 51 80 00       	mov    0x805140,%eax
  803009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803010:	74 07                	je     803019 <alloc_block_FF+0x28b>
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	8b 00                	mov    (%eax),%eax
  803017:	eb 05                	jmp    80301e <alloc_block_FF+0x290>
  803019:	b8 00 00 00 00       	mov    $0x0,%eax
  80301e:	a3 40 51 80 00       	mov    %eax,0x805140
  803023:	a1 40 51 80 00       	mov    0x805140,%eax
  803028:	85 c0                	test   %eax,%eax
  80302a:	0f 85 71 fd ff ff    	jne    802da1 <alloc_block_FF+0x13>
  803030:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803034:	0f 85 67 fd ff ff    	jne    802da1 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  80303a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80303f:	c9                   	leave  
  803040:	c3                   	ret    

00803041 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803041:	55                   	push   %ebp
  803042:	89 e5                	mov    %esp,%ebp
  803044:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  803047:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  80304e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  803055:	a1 38 51 80 00       	mov    0x805138,%eax
  80305a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80305d:	e9 d3 00 00 00       	jmp    803135 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  803062:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803065:	8b 40 0c             	mov    0xc(%eax),%eax
  803068:	3b 45 08             	cmp    0x8(%ebp),%eax
  80306b:	0f 85 90 00 00 00    	jne    803101 <alloc_block_BF+0xc0>
	   temp = element;
  803071:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803074:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  803077:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80307b:	75 17                	jne    803094 <alloc_block_BF+0x53>
  80307d:	83 ec 04             	sub    $0x4,%esp
  803080:	68 68 48 80 00       	push   $0x804868
  803085:	68 bd 00 00 00       	push   $0xbd
  80308a:	68 f7 47 80 00       	push   $0x8047f7
  80308f:	e8 f3 db ff ff       	call   800c87 <_panic>
  803094:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803097:	8b 00                	mov    (%eax),%eax
  803099:	85 c0                	test   %eax,%eax
  80309b:	74 10                	je     8030ad <alloc_block_BF+0x6c>
  80309d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a0:	8b 00                	mov    (%eax),%eax
  8030a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a5:	8b 52 04             	mov    0x4(%edx),%edx
  8030a8:	89 50 04             	mov    %edx,0x4(%eax)
  8030ab:	eb 0b                	jmp    8030b8 <alloc_block_BF+0x77>
  8030ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b0:	8b 40 04             	mov    0x4(%eax),%eax
  8030b3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bb:	8b 40 04             	mov    0x4(%eax),%eax
  8030be:	85 c0                	test   %eax,%eax
  8030c0:	74 0f                	je     8030d1 <alloc_block_BF+0x90>
  8030c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c5:	8b 40 04             	mov    0x4(%eax),%eax
  8030c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030cb:	8b 12                	mov    (%edx),%edx
  8030cd:	89 10                	mov    %edx,(%eax)
  8030cf:	eb 0a                	jmp    8030db <alloc_block_BF+0x9a>
  8030d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d4:	8b 00                	mov    (%eax),%eax
  8030d6:	a3 38 51 80 00       	mov    %eax,0x805138
  8030db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ee:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f3:	48                   	dec    %eax
  8030f4:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  8030f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030fc:	e9 41 01 00 00       	jmp    803242 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  803101:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803104:	8b 40 0c             	mov    0xc(%eax),%eax
  803107:	3b 45 08             	cmp    0x8(%ebp),%eax
  80310a:	76 21                	jbe    80312d <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  80310c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310f:	8b 40 0c             	mov    0xc(%eax),%eax
  803112:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803115:	73 16                	jae    80312d <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  803117:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311a:	8b 40 0c             	mov    0xc(%eax),%eax
  80311d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  803120:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803123:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  803126:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80312d:	a1 40 51 80 00       	mov    0x805140,%eax
  803132:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803135:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803139:	74 07                	je     803142 <alloc_block_BF+0x101>
  80313b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313e:	8b 00                	mov    (%eax),%eax
  803140:	eb 05                	jmp    803147 <alloc_block_BF+0x106>
  803142:	b8 00 00 00 00       	mov    $0x0,%eax
  803147:	a3 40 51 80 00       	mov    %eax,0x805140
  80314c:	a1 40 51 80 00       	mov    0x805140,%eax
  803151:	85 c0                	test   %eax,%eax
  803153:	0f 85 09 ff ff ff    	jne    803062 <alloc_block_BF+0x21>
  803159:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80315d:	0f 85 ff fe ff ff    	jne    803062 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  803163:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  803167:	0f 85 d0 00 00 00    	jne    80323d <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80316d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803170:	8b 40 0c             	mov    0xc(%eax),%eax
  803173:	2b 45 08             	sub    0x8(%ebp),%eax
  803176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  803179:	a1 48 51 80 00       	mov    0x805148,%eax
  80317e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  803181:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803185:	75 17                	jne    80319e <alloc_block_BF+0x15d>
  803187:	83 ec 04             	sub    $0x4,%esp
  80318a:	68 68 48 80 00       	push   $0x804868
  80318f:	68 d1 00 00 00       	push   $0xd1
  803194:	68 f7 47 80 00       	push   $0x8047f7
  803199:	e8 e9 da ff ff       	call   800c87 <_panic>
  80319e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	85 c0                	test   %eax,%eax
  8031a5:	74 10                	je     8031b7 <alloc_block_BF+0x176>
  8031a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031aa:	8b 00                	mov    (%eax),%eax
  8031ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031af:	8b 52 04             	mov    0x4(%edx),%edx
  8031b2:	89 50 04             	mov    %edx,0x4(%eax)
  8031b5:	eb 0b                	jmp    8031c2 <alloc_block_BF+0x181>
  8031b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ba:	8b 40 04             	mov    0x4(%eax),%eax
  8031bd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031c5:	8b 40 04             	mov    0x4(%eax),%eax
  8031c8:	85 c0                	test   %eax,%eax
  8031ca:	74 0f                	je     8031db <alloc_block_BF+0x19a>
  8031cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031cf:	8b 40 04             	mov    0x4(%eax),%eax
  8031d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031d5:	8b 12                	mov    (%edx),%edx
  8031d7:	89 10                	mov    %edx,(%eax)
  8031d9:	eb 0a                	jmp    8031e5 <alloc_block_BF+0x1a4>
  8031db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031de:	8b 00                	mov    (%eax),%eax
  8031e0:	a3 48 51 80 00       	mov    %eax,0x805148
  8031e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8031fd:	48                   	dec    %eax
  8031fe:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  803203:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803206:	8b 55 08             	mov    0x8(%ebp),%edx
  803209:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  80320c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320f:	8b 50 08             	mov    0x8(%eax),%edx
  803212:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803215:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  803218:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80321e:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  803221:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803224:	8b 50 08             	mov    0x8(%eax),%edx
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	01 c2                	add    %eax,%edx
  80322c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322f:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  803232:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803235:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  803238:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80323b:	eb 05                	jmp    803242 <alloc_block_BF+0x201>
	 }
	 return NULL;
  80323d:	b8 00 00 00 00       	mov    $0x0,%eax


}
  803242:	c9                   	leave  
  803243:	c3                   	ret    

00803244 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803244:	55                   	push   %ebp
  803245:	89 e5                	mov    %esp,%ebp
  803247:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80324a:	83 ec 04             	sub    $0x4,%esp
  80324d:	68 88 48 80 00       	push   $0x804888
  803252:	68 e8 00 00 00       	push   $0xe8
  803257:	68 f7 47 80 00       	push   $0x8047f7
  80325c:	e8 26 da ff ff       	call   800c87 <_panic>

00803261 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803261:	55                   	push   %ebp
  803262:	89 e5                	mov    %esp,%ebp
  803264:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  803267:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80326c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  80326f:	a1 38 51 80 00       	mov    0x805138,%eax
  803274:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  803277:	a1 44 51 80 00       	mov    0x805144,%eax
  80327c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  80327f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803283:	75 68                	jne    8032ed <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803285:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803289:	75 17                	jne    8032a2 <insert_sorted_with_merge_freeList+0x41>
  80328b:	83 ec 04             	sub    $0x4,%esp
  80328e:	68 d4 47 80 00       	push   $0x8047d4
  803293:	68 36 01 00 00       	push   $0x136
  803298:	68 f7 47 80 00       	push   $0x8047f7
  80329d:	e8 e5 d9 ff ff       	call   800c87 <_panic>
  8032a2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ab:	89 10                	mov    %edx,(%eax)
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	8b 00                	mov    (%eax),%eax
  8032b2:	85 c0                	test   %eax,%eax
  8032b4:	74 0d                	je     8032c3 <insert_sorted_with_merge_freeList+0x62>
  8032b6:	a1 38 51 80 00       	mov    0x805138,%eax
  8032bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8032be:	89 50 04             	mov    %edx,0x4(%eax)
  8032c1:	eb 08                	jmp    8032cb <insert_sorted_with_merge_freeList+0x6a>
  8032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032dd:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e2:	40                   	inc    %eax
  8032e3:	a3 44 51 80 00       	mov    %eax,0x805144





}
  8032e8:	e9 ba 06 00 00       	jmp    8039a7 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  8032ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f0:	8b 50 08             	mov    0x8(%eax),%edx
  8032f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f9:	01 c2                	add    %eax,%edx
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	8b 40 08             	mov    0x8(%eax),%eax
  803301:	39 c2                	cmp    %eax,%edx
  803303:	73 68                	jae    80336d <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803305:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803309:	75 17                	jne    803322 <insert_sorted_with_merge_freeList+0xc1>
  80330b:	83 ec 04             	sub    $0x4,%esp
  80330e:	68 10 48 80 00       	push   $0x804810
  803313:	68 3a 01 00 00       	push   $0x13a
  803318:	68 f7 47 80 00       	push   $0x8047f7
  80331d:	e8 65 d9 ff ff       	call   800c87 <_panic>
  803322:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	89 50 04             	mov    %edx,0x4(%eax)
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	8b 40 04             	mov    0x4(%eax),%eax
  803334:	85 c0                	test   %eax,%eax
  803336:	74 0c                	je     803344 <insert_sorted_with_merge_freeList+0xe3>
  803338:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80333d:	8b 55 08             	mov    0x8(%ebp),%edx
  803340:	89 10                	mov    %edx,(%eax)
  803342:	eb 08                	jmp    80334c <insert_sorted_with_merge_freeList+0xeb>
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	a3 38 51 80 00       	mov    %eax,0x805138
  80334c:	8b 45 08             	mov    0x8(%ebp),%eax
  80334f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80335d:	a1 44 51 80 00       	mov    0x805144,%eax
  803362:	40                   	inc    %eax
  803363:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803368:	e9 3a 06 00 00       	jmp    8039a7 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  80336d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803370:	8b 50 08             	mov    0x8(%eax),%edx
  803373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803376:	8b 40 0c             	mov    0xc(%eax),%eax
  803379:	01 c2                	add    %eax,%edx
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	8b 40 08             	mov    0x8(%eax),%eax
  803381:	39 c2                	cmp    %eax,%edx
  803383:	0f 85 90 00 00 00    	jne    803419 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  803389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338c:	8b 50 0c             	mov    0xc(%eax),%edx
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	8b 40 0c             	mov    0xc(%eax),%eax
  803395:	01 c2                	add    %eax,%edx
  803397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339a:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  80339d:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8033a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033aa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8033b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b5:	75 17                	jne    8033ce <insert_sorted_with_merge_freeList+0x16d>
  8033b7:	83 ec 04             	sub    $0x4,%esp
  8033ba:	68 d4 47 80 00       	push   $0x8047d4
  8033bf:	68 41 01 00 00       	push   $0x141
  8033c4:	68 f7 47 80 00       	push   $0x8047f7
  8033c9:	e8 b9 d8 ff ff       	call   800c87 <_panic>
  8033ce:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d7:	89 10                	mov    %edx,(%eax)
  8033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dc:	8b 00                	mov    (%eax),%eax
  8033de:	85 c0                	test   %eax,%eax
  8033e0:	74 0d                	je     8033ef <insert_sorted_with_merge_freeList+0x18e>
  8033e2:	a1 48 51 80 00       	mov    0x805148,%eax
  8033e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ea:	89 50 04             	mov    %edx,0x4(%eax)
  8033ed:	eb 08                	jmp    8033f7 <insert_sorted_with_merge_freeList+0x196>
  8033ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	a3 48 51 80 00       	mov    %eax,0x805148
  8033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803402:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803409:	a1 54 51 80 00       	mov    0x805154,%eax
  80340e:	40                   	inc    %eax
  80340f:	a3 54 51 80 00       	mov    %eax,0x805154





}
  803414:	e9 8e 05 00 00       	jmp    8039a7 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  803419:	8b 45 08             	mov    0x8(%ebp),%eax
  80341c:	8b 50 08             	mov    0x8(%eax),%edx
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	8b 40 0c             	mov    0xc(%eax),%eax
  803425:	01 c2                	add    %eax,%edx
  803427:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342a:	8b 40 08             	mov    0x8(%eax),%eax
  80342d:	39 c2                	cmp    %eax,%edx
  80342f:	73 68                	jae    803499 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803431:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803435:	75 17                	jne    80344e <insert_sorted_with_merge_freeList+0x1ed>
  803437:	83 ec 04             	sub    $0x4,%esp
  80343a:	68 d4 47 80 00       	push   $0x8047d4
  80343f:	68 45 01 00 00       	push   $0x145
  803444:	68 f7 47 80 00       	push   $0x8047f7
  803449:	e8 39 d8 ff ff       	call   800c87 <_panic>
  80344e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803454:	8b 45 08             	mov    0x8(%ebp),%eax
  803457:	89 10                	mov    %edx,(%eax)
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	8b 00                	mov    (%eax),%eax
  80345e:	85 c0                	test   %eax,%eax
  803460:	74 0d                	je     80346f <insert_sorted_with_merge_freeList+0x20e>
  803462:	a1 38 51 80 00       	mov    0x805138,%eax
  803467:	8b 55 08             	mov    0x8(%ebp),%edx
  80346a:	89 50 04             	mov    %edx,0x4(%eax)
  80346d:	eb 08                	jmp    803477 <insert_sorted_with_merge_freeList+0x216>
  80346f:	8b 45 08             	mov    0x8(%ebp),%eax
  803472:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	a3 38 51 80 00       	mov    %eax,0x805138
  80347f:	8b 45 08             	mov    0x8(%ebp),%eax
  803482:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803489:	a1 44 51 80 00       	mov    0x805144,%eax
  80348e:	40                   	inc    %eax
  80348f:	a3 44 51 80 00       	mov    %eax,0x805144





}
  803494:	e9 0e 05 00 00       	jmp    8039a7 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	8b 50 08             	mov    0x8(%eax),%edx
  80349f:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a5:	01 c2                	add    %eax,%edx
  8034a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034aa:	8b 40 08             	mov    0x8(%eax),%eax
  8034ad:	39 c2                	cmp    %eax,%edx
  8034af:	0f 85 9c 00 00 00    	jne    803551 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  8034b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b8:	8b 50 0c             	mov    0xc(%eax),%edx
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c1:	01 c2                	add    %eax,%edx
  8034c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034c6:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  8034c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cc:	8b 50 08             	mov    0x8(%eax),%edx
  8034cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d2:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  8034d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  8034df:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8034e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ed:	75 17                	jne    803506 <insert_sorted_with_merge_freeList+0x2a5>
  8034ef:	83 ec 04             	sub    $0x4,%esp
  8034f2:	68 d4 47 80 00       	push   $0x8047d4
  8034f7:	68 4d 01 00 00       	push   $0x14d
  8034fc:	68 f7 47 80 00       	push   $0x8047f7
  803501:	e8 81 d7 ff ff       	call   800c87 <_panic>
  803506:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	89 10                	mov    %edx,(%eax)
  803511:	8b 45 08             	mov    0x8(%ebp),%eax
  803514:	8b 00                	mov    (%eax),%eax
  803516:	85 c0                	test   %eax,%eax
  803518:	74 0d                	je     803527 <insert_sorted_with_merge_freeList+0x2c6>
  80351a:	a1 48 51 80 00       	mov    0x805148,%eax
  80351f:	8b 55 08             	mov    0x8(%ebp),%edx
  803522:	89 50 04             	mov    %edx,0x4(%eax)
  803525:	eb 08                	jmp    80352f <insert_sorted_with_merge_freeList+0x2ce>
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80352f:	8b 45 08             	mov    0x8(%ebp),%eax
  803532:	a3 48 51 80 00       	mov    %eax,0x805148
  803537:	8b 45 08             	mov    0x8(%ebp),%eax
  80353a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803541:	a1 54 51 80 00       	mov    0x805154,%eax
  803546:	40                   	inc    %eax
  803547:	a3 54 51 80 00       	mov    %eax,0x805154





}
  80354c:	e9 56 04 00 00       	jmp    8039a7 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803551:	a1 38 51 80 00       	mov    0x805138,%eax
  803556:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803559:	e9 19 04 00 00       	jmp    803977 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  80355e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803561:	8b 00                	mov    (%eax),%eax
  803563:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803569:	8b 50 08             	mov    0x8(%eax),%edx
  80356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356f:	8b 40 0c             	mov    0xc(%eax),%eax
  803572:	01 c2                	add    %eax,%edx
  803574:	8b 45 08             	mov    0x8(%ebp),%eax
  803577:	8b 40 08             	mov    0x8(%eax),%eax
  80357a:	39 c2                	cmp    %eax,%edx
  80357c:	0f 85 ad 01 00 00    	jne    80372f <insert_sorted_with_merge_freeList+0x4ce>
  803582:	8b 45 08             	mov    0x8(%ebp),%eax
  803585:	8b 50 08             	mov    0x8(%eax),%edx
  803588:	8b 45 08             	mov    0x8(%ebp),%eax
  80358b:	8b 40 0c             	mov    0xc(%eax),%eax
  80358e:	01 c2                	add    %eax,%edx
  803590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803593:	8b 40 08             	mov    0x8(%eax),%eax
  803596:	39 c2                	cmp    %eax,%edx
  803598:	0f 85 91 01 00 00    	jne    80372f <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  80359e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a1:	8b 50 0c             	mov    0xc(%eax),%edx
  8035a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a7:	8b 48 0c             	mov    0xc(%eax),%ecx
  8035aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b0:	01 c8                	add    %ecx,%eax
  8035b2:	01 c2                	add    %eax,%edx
  8035b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b7:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  8035ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8035c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  8035ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  8035d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035db:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  8035e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035e6:	75 17                	jne    8035ff <insert_sorted_with_merge_freeList+0x39e>
  8035e8:	83 ec 04             	sub    $0x4,%esp
  8035eb:	68 68 48 80 00       	push   $0x804868
  8035f0:	68 5b 01 00 00       	push   $0x15b
  8035f5:	68 f7 47 80 00       	push   $0x8047f7
  8035fa:	e8 88 d6 ff ff       	call   800c87 <_panic>
  8035ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803602:	8b 00                	mov    (%eax),%eax
  803604:	85 c0                	test   %eax,%eax
  803606:	74 10                	je     803618 <insert_sorted_with_merge_freeList+0x3b7>
  803608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80360b:	8b 00                	mov    (%eax),%eax
  80360d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803610:	8b 52 04             	mov    0x4(%edx),%edx
  803613:	89 50 04             	mov    %edx,0x4(%eax)
  803616:	eb 0b                	jmp    803623 <insert_sorted_with_merge_freeList+0x3c2>
  803618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361b:	8b 40 04             	mov    0x4(%eax),%eax
  80361e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803626:	8b 40 04             	mov    0x4(%eax),%eax
  803629:	85 c0                	test   %eax,%eax
  80362b:	74 0f                	je     80363c <insert_sorted_with_merge_freeList+0x3db>
  80362d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803630:	8b 40 04             	mov    0x4(%eax),%eax
  803633:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803636:	8b 12                	mov    (%edx),%edx
  803638:	89 10                	mov    %edx,(%eax)
  80363a:	eb 0a                	jmp    803646 <insert_sorted_with_merge_freeList+0x3e5>
  80363c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363f:	8b 00                	mov    (%eax),%eax
  803641:	a3 38 51 80 00       	mov    %eax,0x805138
  803646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803649:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80364f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803652:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803659:	a1 44 51 80 00       	mov    0x805144,%eax
  80365e:	48                   	dec    %eax
  80365f:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803664:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803668:	75 17                	jne    803681 <insert_sorted_with_merge_freeList+0x420>
  80366a:	83 ec 04             	sub    $0x4,%esp
  80366d:	68 d4 47 80 00       	push   $0x8047d4
  803672:	68 5c 01 00 00       	push   $0x15c
  803677:	68 f7 47 80 00       	push   $0x8047f7
  80367c:	e8 06 d6 ff ff       	call   800c87 <_panic>
  803681:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803687:	8b 45 08             	mov    0x8(%ebp),%eax
  80368a:	89 10                	mov    %edx,(%eax)
  80368c:	8b 45 08             	mov    0x8(%ebp),%eax
  80368f:	8b 00                	mov    (%eax),%eax
  803691:	85 c0                	test   %eax,%eax
  803693:	74 0d                	je     8036a2 <insert_sorted_with_merge_freeList+0x441>
  803695:	a1 48 51 80 00       	mov    0x805148,%eax
  80369a:	8b 55 08             	mov    0x8(%ebp),%edx
  80369d:	89 50 04             	mov    %edx,0x4(%eax)
  8036a0:	eb 08                	jmp    8036aa <insert_sorted_with_merge_freeList+0x449>
  8036a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ad:	a3 48 51 80 00       	mov    %eax,0x805148
  8036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036bc:	a1 54 51 80 00       	mov    0x805154,%eax
  8036c1:	40                   	inc    %eax
  8036c2:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  8036c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036cb:	75 17                	jne    8036e4 <insert_sorted_with_merge_freeList+0x483>
  8036cd:	83 ec 04             	sub    $0x4,%esp
  8036d0:	68 d4 47 80 00       	push   $0x8047d4
  8036d5:	68 5d 01 00 00       	push   $0x15d
  8036da:	68 f7 47 80 00       	push   $0x8047f7
  8036df:	e8 a3 d5 ff ff       	call   800c87 <_panic>
  8036e4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ed:	89 10                	mov    %edx,(%eax)
  8036ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f2:	8b 00                	mov    (%eax),%eax
  8036f4:	85 c0                	test   %eax,%eax
  8036f6:	74 0d                	je     803705 <insert_sorted_with_merge_freeList+0x4a4>
  8036f8:	a1 48 51 80 00       	mov    0x805148,%eax
  8036fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803700:	89 50 04             	mov    %edx,0x4(%eax)
  803703:	eb 08                	jmp    80370d <insert_sorted_with_merge_freeList+0x4ac>
  803705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803708:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80370d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803710:	a3 48 51 80 00       	mov    %eax,0x805148
  803715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803718:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80371f:	a1 54 51 80 00       	mov    0x805154,%eax
  803724:	40                   	inc    %eax
  803725:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80372a:	e9 78 02 00 00       	jmp    8039a7 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  80372f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803732:	8b 50 08             	mov    0x8(%eax),%edx
  803735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803738:	8b 40 0c             	mov    0xc(%eax),%eax
  80373b:	01 c2                	add    %eax,%edx
  80373d:	8b 45 08             	mov    0x8(%ebp),%eax
  803740:	8b 40 08             	mov    0x8(%eax),%eax
  803743:	39 c2                	cmp    %eax,%edx
  803745:	0f 83 b8 00 00 00    	jae    803803 <insert_sorted_with_merge_freeList+0x5a2>
  80374b:	8b 45 08             	mov    0x8(%ebp),%eax
  80374e:	8b 50 08             	mov    0x8(%eax),%edx
  803751:	8b 45 08             	mov    0x8(%ebp),%eax
  803754:	8b 40 0c             	mov    0xc(%eax),%eax
  803757:	01 c2                	add    %eax,%edx
  803759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80375c:	8b 40 08             	mov    0x8(%eax),%eax
  80375f:	39 c2                	cmp    %eax,%edx
  803761:	0f 85 9c 00 00 00    	jne    803803 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  803767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80376a:	8b 50 0c             	mov    0xc(%eax),%edx
  80376d:	8b 45 08             	mov    0x8(%ebp),%eax
  803770:	8b 40 0c             	mov    0xc(%eax),%eax
  803773:	01 c2                	add    %eax,%edx
  803775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803778:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  80377b:	8b 45 08             	mov    0x8(%ebp),%eax
  80377e:	8b 50 08             	mov    0x8(%eax),%edx
  803781:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803784:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  803787:	8b 45 08             	mov    0x8(%ebp),%eax
  80378a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803791:	8b 45 08             	mov    0x8(%ebp),%eax
  803794:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80379b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80379f:	75 17                	jne    8037b8 <insert_sorted_with_merge_freeList+0x557>
  8037a1:	83 ec 04             	sub    $0x4,%esp
  8037a4:	68 d4 47 80 00       	push   $0x8047d4
  8037a9:	68 67 01 00 00       	push   $0x167
  8037ae:	68 f7 47 80 00       	push   $0x8047f7
  8037b3:	e8 cf d4 ff ff       	call   800c87 <_panic>
  8037b8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037be:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c1:	89 10                	mov    %edx,(%eax)
  8037c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c6:	8b 00                	mov    (%eax),%eax
  8037c8:	85 c0                	test   %eax,%eax
  8037ca:	74 0d                	je     8037d9 <insert_sorted_with_merge_freeList+0x578>
  8037cc:	a1 48 51 80 00       	mov    0x805148,%eax
  8037d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8037d4:	89 50 04             	mov    %edx,0x4(%eax)
  8037d7:	eb 08                	jmp    8037e1 <insert_sorted_with_merge_freeList+0x580>
  8037d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e4:	a3 48 51 80 00       	mov    %eax,0x805148
  8037e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f3:	a1 54 51 80 00       	mov    0x805154,%eax
  8037f8:	40                   	inc    %eax
  8037f9:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  8037fe:	e9 a4 01 00 00       	jmp    8039a7 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803806:	8b 50 08             	mov    0x8(%eax),%edx
  803809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380c:	8b 40 0c             	mov    0xc(%eax),%eax
  80380f:	01 c2                	add    %eax,%edx
  803811:	8b 45 08             	mov    0x8(%ebp),%eax
  803814:	8b 40 08             	mov    0x8(%eax),%eax
  803817:	39 c2                	cmp    %eax,%edx
  803819:	0f 85 ac 00 00 00    	jne    8038cb <insert_sorted_with_merge_freeList+0x66a>
  80381f:	8b 45 08             	mov    0x8(%ebp),%eax
  803822:	8b 50 08             	mov    0x8(%eax),%edx
  803825:	8b 45 08             	mov    0x8(%ebp),%eax
  803828:	8b 40 0c             	mov    0xc(%eax),%eax
  80382b:	01 c2                	add    %eax,%edx
  80382d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803830:	8b 40 08             	mov    0x8(%eax),%eax
  803833:	39 c2                	cmp    %eax,%edx
  803835:	0f 83 90 00 00 00    	jae    8038cb <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  80383b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383e:	8b 50 0c             	mov    0xc(%eax),%edx
  803841:	8b 45 08             	mov    0x8(%ebp),%eax
  803844:	8b 40 0c             	mov    0xc(%eax),%eax
  803847:	01 c2                	add    %eax,%edx
  803849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384c:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  80384f:	8b 45 08             	mov    0x8(%ebp),%eax
  803852:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  803859:	8b 45 08             	mov    0x8(%ebp),%eax
  80385c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803863:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803867:	75 17                	jne    803880 <insert_sorted_with_merge_freeList+0x61f>
  803869:	83 ec 04             	sub    $0x4,%esp
  80386c:	68 d4 47 80 00       	push   $0x8047d4
  803871:	68 70 01 00 00       	push   $0x170
  803876:	68 f7 47 80 00       	push   $0x8047f7
  80387b:	e8 07 d4 ff ff       	call   800c87 <_panic>
  803880:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803886:	8b 45 08             	mov    0x8(%ebp),%eax
  803889:	89 10                	mov    %edx,(%eax)
  80388b:	8b 45 08             	mov    0x8(%ebp),%eax
  80388e:	8b 00                	mov    (%eax),%eax
  803890:	85 c0                	test   %eax,%eax
  803892:	74 0d                	je     8038a1 <insert_sorted_with_merge_freeList+0x640>
  803894:	a1 48 51 80 00       	mov    0x805148,%eax
  803899:	8b 55 08             	mov    0x8(%ebp),%edx
  80389c:	89 50 04             	mov    %edx,0x4(%eax)
  80389f:	eb 08                	jmp    8038a9 <insert_sorted_with_merge_freeList+0x648>
  8038a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ac:	a3 48 51 80 00       	mov    %eax,0x805148
  8038b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038bb:	a1 54 51 80 00       	mov    0x805154,%eax
  8038c0:	40                   	inc    %eax
  8038c1:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  8038c6:	e9 dc 00 00 00       	jmp    8039a7 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8038cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ce:	8b 50 08             	mov    0x8(%eax),%edx
  8038d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8038d7:	01 c2                	add    %eax,%edx
  8038d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038dc:	8b 40 08             	mov    0x8(%eax),%eax
  8038df:	39 c2                	cmp    %eax,%edx
  8038e1:	0f 83 88 00 00 00    	jae    80396f <insert_sorted_with_merge_freeList+0x70e>
  8038e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ea:	8b 50 08             	mov    0x8(%eax),%edx
  8038ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8038f3:	01 c2                	add    %eax,%edx
  8038f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f8:	8b 40 08             	mov    0x8(%eax),%eax
  8038fb:	39 c2                	cmp    %eax,%edx
  8038fd:	73 70                	jae    80396f <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  8038ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803903:	74 06                	je     80390b <insert_sorted_with_merge_freeList+0x6aa>
  803905:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803909:	75 17                	jne    803922 <insert_sorted_with_merge_freeList+0x6c1>
  80390b:	83 ec 04             	sub    $0x4,%esp
  80390e:	68 34 48 80 00       	push   $0x804834
  803913:	68 75 01 00 00       	push   $0x175
  803918:	68 f7 47 80 00       	push   $0x8047f7
  80391d:	e8 65 d3 ff ff       	call   800c87 <_panic>
  803922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803925:	8b 10                	mov    (%eax),%edx
  803927:	8b 45 08             	mov    0x8(%ebp),%eax
  80392a:	89 10                	mov    %edx,(%eax)
  80392c:	8b 45 08             	mov    0x8(%ebp),%eax
  80392f:	8b 00                	mov    (%eax),%eax
  803931:	85 c0                	test   %eax,%eax
  803933:	74 0b                	je     803940 <insert_sorted_with_merge_freeList+0x6df>
  803935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803938:	8b 00                	mov    (%eax),%eax
  80393a:	8b 55 08             	mov    0x8(%ebp),%edx
  80393d:	89 50 04             	mov    %edx,0x4(%eax)
  803940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803943:	8b 55 08             	mov    0x8(%ebp),%edx
  803946:	89 10                	mov    %edx,(%eax)
  803948:	8b 45 08             	mov    0x8(%ebp),%eax
  80394b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80394e:	89 50 04             	mov    %edx,0x4(%eax)
  803951:	8b 45 08             	mov    0x8(%ebp),%eax
  803954:	8b 00                	mov    (%eax),%eax
  803956:	85 c0                	test   %eax,%eax
  803958:	75 08                	jne    803962 <insert_sorted_with_merge_freeList+0x701>
  80395a:	8b 45 08             	mov    0x8(%ebp),%eax
  80395d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803962:	a1 44 51 80 00       	mov    0x805144,%eax
  803967:	40                   	inc    %eax
  803968:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  80396d:	eb 38                	jmp    8039a7 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  80396f:	a1 40 51 80 00       	mov    0x805140,%eax
  803974:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803977:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80397b:	74 07                	je     803984 <insert_sorted_with_merge_freeList+0x723>
  80397d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803980:	8b 00                	mov    (%eax),%eax
  803982:	eb 05                	jmp    803989 <insert_sorted_with_merge_freeList+0x728>
  803984:	b8 00 00 00 00       	mov    $0x0,%eax
  803989:	a3 40 51 80 00       	mov    %eax,0x805140
  80398e:	a1 40 51 80 00       	mov    0x805140,%eax
  803993:	85 c0                	test   %eax,%eax
  803995:	0f 85 c3 fb ff ff    	jne    80355e <insert_sorted_with_merge_freeList+0x2fd>
  80399b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80399f:	0f 85 b9 fb ff ff    	jne    80355e <insert_sorted_with_merge_freeList+0x2fd>





}
  8039a5:	eb 00                	jmp    8039a7 <insert_sorted_with_merge_freeList+0x746>
  8039a7:	90                   	nop
  8039a8:	c9                   	leave  
  8039a9:	c3                   	ret    

008039aa <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8039aa:	55                   	push   %ebp
  8039ab:	89 e5                	mov    %esp,%ebp
  8039ad:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8039b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8039b3:	89 d0                	mov    %edx,%eax
  8039b5:	c1 e0 02             	shl    $0x2,%eax
  8039b8:	01 d0                	add    %edx,%eax
  8039ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039c1:	01 d0                	add    %edx,%eax
  8039c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039ca:	01 d0                	add    %edx,%eax
  8039cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8039d3:	01 d0                	add    %edx,%eax
  8039d5:	c1 e0 04             	shl    $0x4,%eax
  8039d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8039db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8039e2:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8039e5:	83 ec 0c             	sub    $0xc,%esp
  8039e8:	50                   	push   %eax
  8039e9:	e8 31 ec ff ff       	call   80261f <sys_get_virtual_time>
  8039ee:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8039f1:	eb 41                	jmp    803a34 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8039f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8039f6:	83 ec 0c             	sub    $0xc,%esp
  8039f9:	50                   	push   %eax
  8039fa:	e8 20 ec ff ff       	call   80261f <sys_get_virtual_time>
  8039ff:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803a02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a08:	29 c2                	sub    %eax,%edx
  803a0a:	89 d0                	mov    %edx,%eax
  803a0c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803a0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a15:	89 d1                	mov    %edx,%ecx
  803a17:	29 c1                	sub    %eax,%ecx
  803a19:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a1f:	39 c2                	cmp    %eax,%edx
  803a21:	0f 97 c0             	seta   %al
  803a24:	0f b6 c0             	movzbl %al,%eax
  803a27:	29 c1                	sub    %eax,%ecx
  803a29:	89 c8                	mov    %ecx,%eax
  803a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803a2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a31:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a37:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803a3a:	72 b7                	jb     8039f3 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803a3c:	90                   	nop
  803a3d:	c9                   	leave  
  803a3e:	c3                   	ret    

00803a3f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803a3f:	55                   	push   %ebp
  803a40:	89 e5                	mov    %esp,%ebp
  803a42:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803a45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803a4c:	eb 03                	jmp    803a51 <busy_wait+0x12>
  803a4e:	ff 45 fc             	incl   -0x4(%ebp)
  803a51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a54:	3b 45 08             	cmp    0x8(%ebp),%eax
  803a57:	72 f5                	jb     803a4e <busy_wait+0xf>
	return i;
  803a59:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803a5c:	c9                   	leave  
  803a5d:	c3                   	ret    
  803a5e:	66 90                	xchg   %ax,%ax

00803a60 <__udivdi3>:
  803a60:	55                   	push   %ebp
  803a61:	57                   	push   %edi
  803a62:	56                   	push   %esi
  803a63:	53                   	push   %ebx
  803a64:	83 ec 1c             	sub    $0x1c,%esp
  803a67:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a6b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a73:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a77:	89 ca                	mov    %ecx,%edx
  803a79:	89 f8                	mov    %edi,%eax
  803a7b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a7f:	85 f6                	test   %esi,%esi
  803a81:	75 2d                	jne    803ab0 <__udivdi3+0x50>
  803a83:	39 cf                	cmp    %ecx,%edi
  803a85:	77 65                	ja     803aec <__udivdi3+0x8c>
  803a87:	89 fd                	mov    %edi,%ebp
  803a89:	85 ff                	test   %edi,%edi
  803a8b:	75 0b                	jne    803a98 <__udivdi3+0x38>
  803a8d:	b8 01 00 00 00       	mov    $0x1,%eax
  803a92:	31 d2                	xor    %edx,%edx
  803a94:	f7 f7                	div    %edi
  803a96:	89 c5                	mov    %eax,%ebp
  803a98:	31 d2                	xor    %edx,%edx
  803a9a:	89 c8                	mov    %ecx,%eax
  803a9c:	f7 f5                	div    %ebp
  803a9e:	89 c1                	mov    %eax,%ecx
  803aa0:	89 d8                	mov    %ebx,%eax
  803aa2:	f7 f5                	div    %ebp
  803aa4:	89 cf                	mov    %ecx,%edi
  803aa6:	89 fa                	mov    %edi,%edx
  803aa8:	83 c4 1c             	add    $0x1c,%esp
  803aab:	5b                   	pop    %ebx
  803aac:	5e                   	pop    %esi
  803aad:	5f                   	pop    %edi
  803aae:	5d                   	pop    %ebp
  803aaf:	c3                   	ret    
  803ab0:	39 ce                	cmp    %ecx,%esi
  803ab2:	77 28                	ja     803adc <__udivdi3+0x7c>
  803ab4:	0f bd fe             	bsr    %esi,%edi
  803ab7:	83 f7 1f             	xor    $0x1f,%edi
  803aba:	75 40                	jne    803afc <__udivdi3+0x9c>
  803abc:	39 ce                	cmp    %ecx,%esi
  803abe:	72 0a                	jb     803aca <__udivdi3+0x6a>
  803ac0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ac4:	0f 87 9e 00 00 00    	ja     803b68 <__udivdi3+0x108>
  803aca:	b8 01 00 00 00       	mov    $0x1,%eax
  803acf:	89 fa                	mov    %edi,%edx
  803ad1:	83 c4 1c             	add    $0x1c,%esp
  803ad4:	5b                   	pop    %ebx
  803ad5:	5e                   	pop    %esi
  803ad6:	5f                   	pop    %edi
  803ad7:	5d                   	pop    %ebp
  803ad8:	c3                   	ret    
  803ad9:	8d 76 00             	lea    0x0(%esi),%esi
  803adc:	31 ff                	xor    %edi,%edi
  803ade:	31 c0                	xor    %eax,%eax
  803ae0:	89 fa                	mov    %edi,%edx
  803ae2:	83 c4 1c             	add    $0x1c,%esp
  803ae5:	5b                   	pop    %ebx
  803ae6:	5e                   	pop    %esi
  803ae7:	5f                   	pop    %edi
  803ae8:	5d                   	pop    %ebp
  803ae9:	c3                   	ret    
  803aea:	66 90                	xchg   %ax,%ax
  803aec:	89 d8                	mov    %ebx,%eax
  803aee:	f7 f7                	div    %edi
  803af0:	31 ff                	xor    %edi,%edi
  803af2:	89 fa                	mov    %edi,%edx
  803af4:	83 c4 1c             	add    $0x1c,%esp
  803af7:	5b                   	pop    %ebx
  803af8:	5e                   	pop    %esi
  803af9:	5f                   	pop    %edi
  803afa:	5d                   	pop    %ebp
  803afb:	c3                   	ret    
  803afc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b01:	89 eb                	mov    %ebp,%ebx
  803b03:	29 fb                	sub    %edi,%ebx
  803b05:	89 f9                	mov    %edi,%ecx
  803b07:	d3 e6                	shl    %cl,%esi
  803b09:	89 c5                	mov    %eax,%ebp
  803b0b:	88 d9                	mov    %bl,%cl
  803b0d:	d3 ed                	shr    %cl,%ebp
  803b0f:	89 e9                	mov    %ebp,%ecx
  803b11:	09 f1                	or     %esi,%ecx
  803b13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b17:	89 f9                	mov    %edi,%ecx
  803b19:	d3 e0                	shl    %cl,%eax
  803b1b:	89 c5                	mov    %eax,%ebp
  803b1d:	89 d6                	mov    %edx,%esi
  803b1f:	88 d9                	mov    %bl,%cl
  803b21:	d3 ee                	shr    %cl,%esi
  803b23:	89 f9                	mov    %edi,%ecx
  803b25:	d3 e2                	shl    %cl,%edx
  803b27:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b2b:	88 d9                	mov    %bl,%cl
  803b2d:	d3 e8                	shr    %cl,%eax
  803b2f:	09 c2                	or     %eax,%edx
  803b31:	89 d0                	mov    %edx,%eax
  803b33:	89 f2                	mov    %esi,%edx
  803b35:	f7 74 24 0c          	divl   0xc(%esp)
  803b39:	89 d6                	mov    %edx,%esi
  803b3b:	89 c3                	mov    %eax,%ebx
  803b3d:	f7 e5                	mul    %ebp
  803b3f:	39 d6                	cmp    %edx,%esi
  803b41:	72 19                	jb     803b5c <__udivdi3+0xfc>
  803b43:	74 0b                	je     803b50 <__udivdi3+0xf0>
  803b45:	89 d8                	mov    %ebx,%eax
  803b47:	31 ff                	xor    %edi,%edi
  803b49:	e9 58 ff ff ff       	jmp    803aa6 <__udivdi3+0x46>
  803b4e:	66 90                	xchg   %ax,%ax
  803b50:	8b 54 24 08          	mov    0x8(%esp),%edx
  803b54:	89 f9                	mov    %edi,%ecx
  803b56:	d3 e2                	shl    %cl,%edx
  803b58:	39 c2                	cmp    %eax,%edx
  803b5a:	73 e9                	jae    803b45 <__udivdi3+0xe5>
  803b5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803b5f:	31 ff                	xor    %edi,%edi
  803b61:	e9 40 ff ff ff       	jmp    803aa6 <__udivdi3+0x46>
  803b66:	66 90                	xchg   %ax,%ax
  803b68:	31 c0                	xor    %eax,%eax
  803b6a:	e9 37 ff ff ff       	jmp    803aa6 <__udivdi3+0x46>
  803b6f:	90                   	nop

00803b70 <__umoddi3>:
  803b70:	55                   	push   %ebp
  803b71:	57                   	push   %edi
  803b72:	56                   	push   %esi
  803b73:	53                   	push   %ebx
  803b74:	83 ec 1c             	sub    $0x1c,%esp
  803b77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b8f:	89 f3                	mov    %esi,%ebx
  803b91:	89 fa                	mov    %edi,%edx
  803b93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b97:	89 34 24             	mov    %esi,(%esp)
  803b9a:	85 c0                	test   %eax,%eax
  803b9c:	75 1a                	jne    803bb8 <__umoddi3+0x48>
  803b9e:	39 f7                	cmp    %esi,%edi
  803ba0:	0f 86 a2 00 00 00    	jbe    803c48 <__umoddi3+0xd8>
  803ba6:	89 c8                	mov    %ecx,%eax
  803ba8:	89 f2                	mov    %esi,%edx
  803baa:	f7 f7                	div    %edi
  803bac:	89 d0                	mov    %edx,%eax
  803bae:	31 d2                	xor    %edx,%edx
  803bb0:	83 c4 1c             	add    $0x1c,%esp
  803bb3:	5b                   	pop    %ebx
  803bb4:	5e                   	pop    %esi
  803bb5:	5f                   	pop    %edi
  803bb6:	5d                   	pop    %ebp
  803bb7:	c3                   	ret    
  803bb8:	39 f0                	cmp    %esi,%eax
  803bba:	0f 87 ac 00 00 00    	ja     803c6c <__umoddi3+0xfc>
  803bc0:	0f bd e8             	bsr    %eax,%ebp
  803bc3:	83 f5 1f             	xor    $0x1f,%ebp
  803bc6:	0f 84 ac 00 00 00    	je     803c78 <__umoddi3+0x108>
  803bcc:	bf 20 00 00 00       	mov    $0x20,%edi
  803bd1:	29 ef                	sub    %ebp,%edi
  803bd3:	89 fe                	mov    %edi,%esi
  803bd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803bd9:	89 e9                	mov    %ebp,%ecx
  803bdb:	d3 e0                	shl    %cl,%eax
  803bdd:	89 d7                	mov    %edx,%edi
  803bdf:	89 f1                	mov    %esi,%ecx
  803be1:	d3 ef                	shr    %cl,%edi
  803be3:	09 c7                	or     %eax,%edi
  803be5:	89 e9                	mov    %ebp,%ecx
  803be7:	d3 e2                	shl    %cl,%edx
  803be9:	89 14 24             	mov    %edx,(%esp)
  803bec:	89 d8                	mov    %ebx,%eax
  803bee:	d3 e0                	shl    %cl,%eax
  803bf0:	89 c2                	mov    %eax,%edx
  803bf2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bf6:	d3 e0                	shl    %cl,%eax
  803bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bfc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c00:	89 f1                	mov    %esi,%ecx
  803c02:	d3 e8                	shr    %cl,%eax
  803c04:	09 d0                	or     %edx,%eax
  803c06:	d3 eb                	shr    %cl,%ebx
  803c08:	89 da                	mov    %ebx,%edx
  803c0a:	f7 f7                	div    %edi
  803c0c:	89 d3                	mov    %edx,%ebx
  803c0e:	f7 24 24             	mull   (%esp)
  803c11:	89 c6                	mov    %eax,%esi
  803c13:	89 d1                	mov    %edx,%ecx
  803c15:	39 d3                	cmp    %edx,%ebx
  803c17:	0f 82 87 00 00 00    	jb     803ca4 <__umoddi3+0x134>
  803c1d:	0f 84 91 00 00 00    	je     803cb4 <__umoddi3+0x144>
  803c23:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c27:	29 f2                	sub    %esi,%edx
  803c29:	19 cb                	sbb    %ecx,%ebx
  803c2b:	89 d8                	mov    %ebx,%eax
  803c2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c31:	d3 e0                	shl    %cl,%eax
  803c33:	89 e9                	mov    %ebp,%ecx
  803c35:	d3 ea                	shr    %cl,%edx
  803c37:	09 d0                	or     %edx,%eax
  803c39:	89 e9                	mov    %ebp,%ecx
  803c3b:	d3 eb                	shr    %cl,%ebx
  803c3d:	89 da                	mov    %ebx,%edx
  803c3f:	83 c4 1c             	add    $0x1c,%esp
  803c42:	5b                   	pop    %ebx
  803c43:	5e                   	pop    %esi
  803c44:	5f                   	pop    %edi
  803c45:	5d                   	pop    %ebp
  803c46:	c3                   	ret    
  803c47:	90                   	nop
  803c48:	89 fd                	mov    %edi,%ebp
  803c4a:	85 ff                	test   %edi,%edi
  803c4c:	75 0b                	jne    803c59 <__umoddi3+0xe9>
  803c4e:	b8 01 00 00 00       	mov    $0x1,%eax
  803c53:	31 d2                	xor    %edx,%edx
  803c55:	f7 f7                	div    %edi
  803c57:	89 c5                	mov    %eax,%ebp
  803c59:	89 f0                	mov    %esi,%eax
  803c5b:	31 d2                	xor    %edx,%edx
  803c5d:	f7 f5                	div    %ebp
  803c5f:	89 c8                	mov    %ecx,%eax
  803c61:	f7 f5                	div    %ebp
  803c63:	89 d0                	mov    %edx,%eax
  803c65:	e9 44 ff ff ff       	jmp    803bae <__umoddi3+0x3e>
  803c6a:	66 90                	xchg   %ax,%ax
  803c6c:	89 c8                	mov    %ecx,%eax
  803c6e:	89 f2                	mov    %esi,%edx
  803c70:	83 c4 1c             	add    $0x1c,%esp
  803c73:	5b                   	pop    %ebx
  803c74:	5e                   	pop    %esi
  803c75:	5f                   	pop    %edi
  803c76:	5d                   	pop    %ebp
  803c77:	c3                   	ret    
  803c78:	3b 04 24             	cmp    (%esp),%eax
  803c7b:	72 06                	jb     803c83 <__umoddi3+0x113>
  803c7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c81:	77 0f                	ja     803c92 <__umoddi3+0x122>
  803c83:	89 f2                	mov    %esi,%edx
  803c85:	29 f9                	sub    %edi,%ecx
  803c87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c8b:	89 14 24             	mov    %edx,(%esp)
  803c8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c92:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c96:	8b 14 24             	mov    (%esp),%edx
  803c99:	83 c4 1c             	add    $0x1c,%esp
  803c9c:	5b                   	pop    %ebx
  803c9d:	5e                   	pop    %esi
  803c9e:	5f                   	pop    %edi
  803c9f:	5d                   	pop    %ebp
  803ca0:	c3                   	ret    
  803ca1:	8d 76 00             	lea    0x0(%esi),%esi
  803ca4:	2b 04 24             	sub    (%esp),%eax
  803ca7:	19 fa                	sbb    %edi,%edx
  803ca9:	89 d1                	mov    %edx,%ecx
  803cab:	89 c6                	mov    %eax,%esi
  803cad:	e9 71 ff ff ff       	jmp    803c23 <__umoddi3+0xb3>
  803cb2:	66 90                	xchg   %ax,%ax
  803cb4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803cb8:	72 ea                	jb     803ca4 <__umoddi3+0x134>
  803cba:	89 d9                	mov    %ebx,%ecx
  803cbc:	e9 62 ff ff ff       	jmp    803c23 <__umoddi3+0xb3>
